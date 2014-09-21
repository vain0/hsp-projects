// Call(ModCls) - FlexValue
#if 0
#include "hsp3plugin_custom.h"
#include "mod_makePVal.h"

#include "CCaller.h"
#include "CCall.h"
#include "Functor.h"

#include "modcls_FlexValue.h"
#include "vt_structWrap.h"

static int const FLEXVAL_TYPE_ALLOC_EX = 9;		// FLEXVAL_TYPE_ALLOC �Ƃ͈قȂ�l

// ����ȃ����o�ւ̎Q�� (self.ptr �̖���)
static int& FlexValueEx_Counter( FlexValue const& self );
static int& FlexValueEx_TmpFlag( FlexValue const& self );

void FlexValue_Dbgout( FlexValue& self )
{
	dbgout( "struct id: %d, ptr: 0x%08x, size: %d, type: %d, <%d>", FlexValue_SubId(self), (int)self.ptr, self.size, self.type, self.ptr ? FlexValue_Counter(self) : 0 );
}

//------------------------------------------------
// FlexValue �\�z
// 
// @ �R�[�h���� ctor �̈��������o�����ԁB
// @ ctor �̈����� thismod �� PVal ���Q�Ɠn�����������������悢�̂ŁA
// @	��ł͂��邪 thismod �� pval, aptr ��������Ă����B
// @	���炦�Ȃ������ꍇ�͕��ʂɒl�n������B
// @ �R���X�g���N�^�̕Ԓl�͖�������B
//------------------------------------------------
void FlexValue_Ctor( FlexValue& self, stdat_t modcls )
{
	FlexValue_Ctor( self, modcls, nullptr, 0 );
}

void FlexValue_Ctor( FlexValue& self, stdat_t modcls, PVal* pval, APTR aptr )
{
	stprm_t const pStPrm = STRUCTDAT_getStPrm(modcls);

	FlexValue_CtorWoCtorCalling( self, modcls );

	// ctor ���s
	if ( pStPrm->offset != -1 ) {
		CCaller caller;
		caller.setFunctor( AxCmd::make(TYPE_MODCMD, pStPrm->offset) );	// (#modinit)
		if ( pval ) {
			caller.addArgByRef( pval ); pval->offset = aptr;	// thismod
		} else {
			caller.addArgByVal( &self, HSPVAR_FLAG_STRUCT );
		}
		caller.setArgAll();

		caller.call();
	}
	return;
}

void FlexValue_CtorWoCtorCalling( FlexValue& self, stdat_t modcls )
{
	stprm_t const pStPrm = STRUCTDAT_getStPrm(modcls);
	if ( pStPrm->mptype != MPTYPE_STRUCTTAG ) puterror( HSPERR_STRUCT_REQUIRED );

	// �V�v�f������
	{
		// �Q�ƃJ�E���^�A�e���|�����t���O�̕������傫���m�ۂ���
		size_t const size = modcls->size + sizeof(int) * 2;	

		self.type      = FLEXVAL_TYPE_ALLOC_EX;
		self.myid      = 0;
		self.customid  = modcls->prmindex;
		self.clonetype = 1;
		self.size      = size;
		self.ptr       = hspmalloc(size);

		FlexValueEx_TmpFlag( self ) = 0;
		FlexValueEx_Counter( self ) = 1;
	}

	// �����o�ϐ��̏�����
	for ( int i = 0; i < modcls->prmmax; ++ i ) {
		void* const out = Prmstack_getMemberPtr(self.ptr, &pStPrm[i]);
		switch ( pStPrm[i].mptype ) {
			case MPTYPE_STRUCTTAG: break;
			case MPTYPE_LOCALVAR:
				PVal_init( reinterpret_cast<PVal*>(out), HSPVAR_FLAG_INT );
				break;
			default:
				puterror( HSPERR_UNKNOWN_CODE );
		}
	}
	return;
}

//------------------------------------------------
// FlexValue ���
// 
// @ code_delstruct
// @ �f�X�g���N�^�̕Ԓl�͖�������B
// @ �f�X�g���N�^���Ăԏꍇ�A���̑O��� mpval ���ω����Ȃ��悤��
// @	mpval �̃|�C���^�Ƃ��̒l��ۑ�����B
//------------------------------------------------
void FlexValue_Dtor( FlexValue& self )
{
	if ( !FlexValueEx_Valid(self) ) return;

	DbgArea { if ( FlexValueEx_Counter(self) != 0 ) dbgout("�Q�ƃJ�E���^�� 0 �łȂ��̂� Dtor ���Ă΂ꂽ�B"); }

	// �f�X�g���N�^���Ăђ�����Ȃ��悤�ɁA�Q�ƃJ�E���^�����������Ă����B
	FlexValueEx_Counter(self) = FLEXVAL_COUNTER_DTORING;

	stdat_t const modcls = FlexValue_ModCls(self);

	// dtor ���s
	if ( modcls->otindex != 0 ) {
		// mpval �̒l��ۑ����Ă���
		PVal* const mpval_bak = mpval;

		// thismod �p�̕ϐ�
		PVal _pvTmp { };
		PVal* const pvTmp = &_pvTmp;
			pvTmp->flag   = HSPVAR_FLAG_STRUCT;
			pvTmp->mode   = HSPVAR_MODE_CLONE;
			pvTmp->pt     = ModCls::StructTraits::asPDAT(&self);
			pvTmp->len[1] = 1;

		CCaller caller;
		caller.setFunctor(AxCmd::make(TYPE_MODCMD, modcls->otindex));			// (#modterm)
		caller.addArgByRef( pvTmp );
		caller.addArgByVal( mpval->pt, mpval->flag );	// �ۑ����邽�߂Ɉ����ɓ���Ă��� (���̂��߂ɁA�f�X�g���N�^�͉ϒ����������ɂ��Ă���)
		caller.call();

		mpval = mpval_bak;		// mpval �� restore

		PVal* const pvArg1 = caller.getCall().getArgPVal(1);
		PVal_assign(mpval, pvArg1->pt, pvArg1->flag);
	}

	// member ���
	{
		void* const members = self.ptr;

		stprm_t const pStPrm = FlexValue_getModuleTag(&self);
		for ( int i = 0; i < modcls->prmmax; ++i ) {
			void* const out = Prmstack_getMemberPtr(members, pStPrm);
			switch ( pStPrm[i].mptype ) {
				case MPTYPE_STRUCTTAG: break;
				case MPTYPE_LOCALVAR:
					PVal_free(reinterpret_cast<PVal*>(out));
					break;
				default:
					puterror(HSPERR_UNKNOWN_CODE);
			}
		}

		hspfree(members);
	}

	// null clear
	FlexValue_NullClear(self);
	return;
}

//------------------------------------------------
// FlexValue ����
//------------------------------------------------
void FlexValue_Copy( FlexValue& dst, FlexValue const& src )
{
	if ( dst.ptr == src.ptr ) return;

	FlexValue_Release(dst);
	dst = src;
	FlexValue_AddRef(dst);
	return;
}

//------------------------------------------------
// FlexValue �ړ�
//------------------------------------------------
void FlexValue_Move( FlexValue& dst, FlexValue& src )
{
	FlexValue_Release( dst );
	dst = src;
	FlexValue_NullClear( src );
	return;
}

//------------------------------------------------
// FlexValue �Q�ƃJ�E���^����
//------------------------------------------------
void FlexValue_AddRef( FlexValue const& self )
{
	if ( !FlexValueEx_Valid(self) ) return;

	int& cnt = FlexValueEx_Counter(self);
	
	dbgout("%08X addref(++); %d -> %d", (int)self.ptr, cnt, cnt + 1);

	if ( cnt != FLEXVAL_COUNTER_DTORING ) ++ cnt;
	return;
}

void FlexValue_Release( FlexValue const& self )
{
	if ( !FlexValueEx_Valid(self) ) return;

	int& cnt = FlexValueEx_Counter(self);

	dbgout("%08X release(--); %d -> %d", (int)self.ptr, cnt, cnt - 1);
	
	if ( cnt != FLEXVAL_COUNTER_DTORING ) {
		if ( (--cnt) == 0 ) {		// (cnt < 0) => dtor �Ă΂Ȃ�
			FlexValue_Dtor(const_cast<FlexValue&>(self));
		}
	}
	return;
}

void FlexValue_DelRef( FlexValue& self )
{
	FlexValue_Release(self);
	FlexValue_NullClear(self);
	return;
}

//------------------------------------------------
// FlexValue 0 �N���A
// 
// @ �Q�ƃJ�E���^�𖳎�����̂Ŋ댯�B
//------------------------------------------------
void FlexValue_NullClear( FlexValue& self )
{
	std::memset( &self, 0x00, sizeof(FlexValue) );
}

//------------------------------------------------
// FlexValue �����o�擾
//------------------------------------------------
bool FlexValue_IsNull( FlexValue const& self )
{
	return ( self.ptr == nullptr );
}

// ModCls ���������� nullmod �łȂ� FlexValue �ł��邩
bool FlexValueEx_Valid( FlexValue const& self )
{
	return (self.type == FLEXVAL_TYPE_ALLOC_EX);
}

int FlexValue_SubId( FlexValue const& self )
{
	return ( !FlexValue_IsNull(self) ? FlexValue_getModuleTag(&self)->subid : -1 );
}

stdat_t FlexValue_ModCls( FlexValue const& self )
{
	return ( !FlexValue_IsNull(self) ? FlexValue_getModule(&self) : nullptr );
}

char const* FlexValue_ClsName( FlexValue const& self )
{
	return ModCls::Name( FlexValue_ModCls( self ) );
}

// �g�������o (�ǂ���� mutable ����)
int& FlexValueEx_Counter( FlexValue const& self )	// �Q�ƃJ�E���^�ւ̃|�C���^ (�o�b�t�@����)
{
	return *reinterpret_cast<int*>( &static_cast<char*>(self.ptr)[self.size - sizeof(int) * 1] );
}
int FlexValue_Counter( FlexValue const& self ) { return FlexValueEx_Counter(self); }

int& FlexValueEx_TmpFlag( FlexValue const& self )
{
	return *reinterpret_cast<int*>( &static_cast<char*>(self.ptr)[self.size - sizeof(int) * 2] );
}

//------------------------------------------------
// modinst �^�̒l�����o��
// 
// @ code_gets �ȂǂƓ��l�ɁA���̌Ăяo������
// @	�|�C���^�̐�̒l���ς��̂Œ��ӁB
// @ nullptr �͕ԋp���Ȃ��B
//------------------------------------------------
FlexValue* code_get_modinst_impl( FlexValue* def, bool const bDefault )
{
	int prm = code_getprm();
	if ( prm <= PARAM_END ) {
		if ( prm == PARAM_DEFAULT && bDefault ) return def;
		puterror( HSPERR_NO_DEFAULT );
	}
	if ( mpval->flag != HSPVAR_FLAG_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );
	return ModCls::StructTraits::asValptr(mpval->pt);
}

FlexValue* code_get_modinst()
{
	return code_get_modinst_impl( nullptr, false );
}

FlexValue* code_get_modinst( FlexValue* def )
{
	return code_get_modinst_impl( def, true );
}

//------------------------------------------------
// �ꎞ�I�u�W�F�N�g�̃��b�N
// 
// @ mpval ���������L����悤�ȃC���X�^���X��
// @	���̎��s���Ɏ��S������̂ŁA���b�N����B
//------------------------------------------------
/*
#include <deque>
static std::deque<FlexValue*> stt_modinst_locker;

void FlexValue_Lock( FlexValue& self )
{
	stt_modinst_locker.push_back( &self );
	FlexValue_AddRef( self );		// lock!
	return;
}

void FlexValue_LockRelease()
{
	for each ( auto it in stt_modinst_locker ) {
		FlexValue_Release( *it );
	}
	return;
}
//*/

//------------------------------------------------
// �ꎞ�I�u�W�F�N�g�̃t���O
// 
// @ HSP �̌v�Z�X�^�b�N�ɁA�ϐ��ł͂Ȃ� FlexValue (�E�Ӓl)���̂��ς܂��ꍇ�A
// @	���̃C���X�^���X���X�^�b�N�ɏ��L����Ă���ƍl���āA�Q�ƃJ�E���^�𑝂₷�B
// @	����ɁATmp �t���O�𗧂ĂĂ������ƂŁA�X�^�b�N����~�낳���Ƃ��ɁA
// @	���ꂪ�X�^�b�N�ɏ��L����Ă������ۂ������f�ł��A���S�ɔj���ł���B
//------------------------------------------------
void FlexValue_AddRefTmp( FlexValue const& self )
{
	if ( !FlexValueEx_Valid(self) ) return;

	FlexValueEx_TmpFlag( self ) ++;
	FlexValue_AddRef( self );
	return;
}

// �ꎞ�I�u�W�F�N�g�Ȃ�������
void FlexValue_ReleaseTmp( FlexValue const& self )
{
	if ( FlexValueEx_Valid(self) && FlexValueEx_TmpFlag(self) > 0 ) {
		assert(FlexValueEx_TmpFlag(self) == 1);
		FlexValueEx_TmpFlag(self)--;
		FlexValue_Release(self);
	}
	return;
}

bool FlexValue_IsTmp( FlexValue const& self )
{
	return ( FlexValueEx_Valid(self) ? FlexValueEx_TmpFlag(self) > 0 : false );
}
#endif
