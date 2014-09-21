// Call(ModCls) - Command
#if 0
#include <array>
#include <map>
#include <string>

#include "reffuncResult.h"

#include "cmd_modcls.h"
#include "cmd_sub.h"

#include "CCaller.h"
#include "CMethod.h"
#include "CMethodlist.h"
#include "CCall.h"
#include "CPrmInfo.h"
#include "vt_functor.h"

#include "modcls_FlexValue.h"
#include "vt_structWrap.h"
#include "CModClsCtor.h"

using namespace hpimod;
using namespace ModCls;

//------------------------------------------------
// �O���[�o���ϐ�
//------------------------------------------------

// null �I�u�W�F�N�g��L����ϐ�
static PVal* g_nullmod;
const  PVal* ModCls::getNullmod() { return g_nullmod; }

// ���Z�֐��̓o�^���X�g
static CModOperator* g_pModOp;
const  CModOperator* ModCls::getModOperator() { return g_pModOp; }

// �ŗL�I�u�W�F�N�g�̃��X�g
static std::map<stdat_t, functor_t>* g_pModClsIdentity;
functor_t const& getModClsCtor( stdat_t modcls );

// �Ԓl�ԋp�p
static FlexValue stt_resfv;

//------------------------------------------------
// struct �^�̒l�����o��
//------------------------------------------------
static FlexValue* code_get_fv()
{
	int const chk = code_getprm();
	if ( chk <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);
	if ( mpval->flag != HSPVAR_FLAG_STRUCT ) puterror(HSPERR_TYPE_MISMATCH);
	return reinterpret_cast<FlexValue*>(mpval->pt);
}

//------------------------------------------------
// struct �^�̒l��ԋp����
//------------------------------------------------
int SetReffuncResult(PDAT** ppResult, FlexValue const& fv)
{
	assert(vtype == HSPVAR_FLAG_STRUCT);

	FlexValue_Copy(stt_resfv, fv);
	*ppResult = &stt_resfv;

	FlexValue_AddRefTmp(stt_resfv);		// �X�^�b�N�ɐς܂��̂�
	return HSPVAR_FLAG_STRUCT;
}

static int SetReffuncResult(PDAT** ppResult, FlexValue const& fv)
{ return SetReffuncResult(ppResult, fv); }

// move semantics
static int SetReffuncResult(PDAT** ppResult, FlexValue&& fv)
{
	FlexValue_Move(stt_resfv, fv);
	*ppResult = &stt_resfv;

	FlexValue_AddRefTmp(stt_resfv);		// �X�^�b�N�ɐς܂��̂�
	return HSPVAR_FLAG_STRUCT;
}

//------------------------------------------------
// ���W���[���N���X�@�\���L�����ǂ���
//------------------------------------------------
bool ModCls::isWorking()
{
	return (g_nullmod != nullptr);
}

//------------------------------------------------
// ���W���[���N���X�@�\�̊J�n
// 
// @ struct �^��������B
//------------------------------------------------
void ModCls::init()
{
	if ( ModCls::IsWorking() ) return;		// �������ς�

	HspVarStructWrap_Init( getHvp(HSPVAR_FLAG_STRUCT) );

	g_nullmod = new PVal;
	PVal_init( g_nullmod, HSPVAR_FLAG_STRUCT );

	g_pModOp          = new CModOperator;
	g_pModClsIdentity = new std::remove_pointer_t<decltype(g_pModClsIdentity)>;
	return;
}

//------------------------------------------------
// �I����
//------------------------------------------------
void ModCls::term()
{
	if ( !ModCls::isWorking() ) return;		// �������� or ����ς�

	// �e���|�����ϐ������Q�Ƃ���������
	if ( getMPValStruct() ) {
		FlexValue_DelRef( *StructTraits::asValptr(getMPValStruct()->pt) );
	}

	// �S�Ă̐ÓI�ϐ������Q�Ƃ���������
	for ( int i = 0; i < ctx->hsphed->max_val; ++ i ) {
		PVal* const it = &ctx->mem_var[i];

		if ( it->flag == HSPVAR_FLAG_STRUCT ) {
			for ( int k = 0; k < it->len[1]; ++ k ) {
				FlexValue_DelRef( StructTraits::asValptr(it->pt)[k] );
			}
		}
	}

	FlexValue_DelRef( stt_resfv );
	PVal_free( g_nullmod );

	delete g_nullmod; g_nullmod = nullptr;
	delete g_pModOp;  g_pModOp  = nullptr;
	delete g_pModClsIdentity; g_pModClsIdentity = nullptr;
	return;
}

//------------------------------------------------
// ���Z�֐���o�^����
// 
// @prm p1 = modcls  : ���W���[���N���X
// @prm p2 = OpId    : OpId_*
// @prm p3 = functor : ����
//------------------------------------------------
void ModClsCmd::Register()
{
	// ������
	stdat_t const pStDat  = code_get_modcls();
	int const     opId    = code_geti();
	functor_t&&   functor = code_get_functor();

	// ���W���[���N���X������
	auto iter = g_pModOp->find( pStDat->subid );

	if ( iter == g_pModOp->end() ) {
		// ���o�^ => �o�^����
		iter = g_pModOp->insert({ pStDat->subid, OpFuncDefs() }).first;
	}

	OpFuncDefs& defs = iter->second;

	// ���Z�֐���o�^
	defs[opId] = functor;

	return;
}

//------------------------------------------------
// newmod (override)
// 
// @ �V�����C���X�^���X�𐶐�����B
//------------------------------------------------
static APTR       code_newstruct( PVal *pval );
static FlexValue* code_reserve_modinst( PVal* pval, APTR aptr );

// ���ߌ`��
void ModClsCmd::Newmod()
{
	PVal* const pval = code_get_var();
	stdat_t const modcls = code_get_modcls();

	// �z��̐V�K�v�f�𐶐�����
	APTR const aptr = code_newstruct( pval );
	FlexValue* const fv = code_reserve_modinst( pval, aptr );

	// �R���X�g���N�^���s (�c��̈����͂����ŏ��������)
	FlexValue_Ctor( *fv, modcls, pval, aptr );

	// �Q�ƃJ�E���^ 1 �Ő�������邪�A����͕ϐ��ɂ���ď��L����镪�Ƃ݂Ȃ��B
	dbgout("<%08X> new: %d", fv, FlexValue_Counter(*fv));
	return;
}

// �֐��`��
int ModClsCmd::Newmod( PDAT** ppResult, bool bSysvarForm )
{
	FlexValue self { };

	stdat_t const kls = code_get_modcls();

	if ( bSysvarForm ) {
		// [ modnew Modcls ( ... ) - ]
		if ( *type == TYPE_MARK && *val == '(' ) {
			code_next();
			FlexValue_Ctor( self, kls );			// �c��̈����͂����ŏ��������
			if ( !code_next_expect( TYPE_MARK, ')') ) puterror( HSPERR_INVALID_FUNCPARAM );

		// [ modnew Modcls - ]
		// �����Ȃ��R���X�g���N�^���Ă�
		} else {
			*exinfo->npexflg |= EXFLG_1;		// ���̈����͂Ȃ��Ƃ��ď���������
			FlexValue_Ctor( self, kls );
			*exinfo->npexflg &= ~EXFLG_1;
		}
		if ( !code_next_expect( TYPE_MARK, CALCCODE_SUB ) ) puterror( HSPERR_SYNTAX );

	} else {
		// newmod( Modcls, ... )
		FlexValue_Ctor( self, kls );			// �c��̈����͂����ŏ��������
	}

	return SetReffuncResult(ppResult, std::move(self));
}

// ���ɗv�f�𐶐����ׂ��Y�����擾����
APTR code_newstruct( PVal* pval )
{
	if ( pval->flag != HSPVAR_FLAG_STRUCT ) return 0;	// ([0] �ւ̕ʂ̌^�̑�� �� �^�ϊ������)

	size_t const last = pval->len[1];
	auto const fv = StructTraits::asValptr(mpval->pt);

	for ( size_t i = 0; i < last; ++i ) {
		if ( fv[i].type == FLEXVAL_TYPE_NONE ) return i;
	}

	exinfo->HspFunc_redim(pval, 1, last + 1);		// �z����g������
	return last;
}

// struct �^�̕ϐ��̃f�[�^�̈���m�ۂ���
// @ ���m�ۏ�Ԃɂ���
FlexValue* code_reserve_modinst( PVal* pval, APTR aptr )
{
	// �z��������g��������
	code_setva( pval, aptr, HSPVAR_FLAG_STRUCT, g_nullmod->pt );

	auto const fv = StructTraits::asValptr(PVal_getptr( pval, aptr ));
	assert(fv->type == FLEXVAL_TYPE_NONE && !fv->ptr);

	return fv;
}

//------------------------------------------------
// delmod (override)
// 
// @ �ϐ��v�f�� nullmod �ɂ���B
// @ ����ɁAmpval �Ȃǂ����L���Ă���ꍇ���j�����āA�ł��邾�� dtor �����s�����悤�ɂ���B
//------------------------------------------------
void ModClsCmd::Delmod()
{
	PVal* const pval = code_get_var();
	if ( pval->flag != HSPVAR_FLAG_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );

	auto const fv = StructTraits::asValptr(PVal_getptr(pval));

	if ( fv->ptr ) {
		if ( getMPValStruct() ) {
			auto const mpval_fv = StructTraits::asValptr(getMPValStruct()->pt);
			if ( mpval_fv && fv->ptr == mpval_fv->ptr ) FlexValue_DelRef( *mpval_fv );
		}

		if ( fv->ptr == stt_resfv.ptr ) FlexValue_DelRef( stt_resfv );
	}

	FlexValue_DelRef( *fv );
	return;
}

//------------------------------------------------
// nullmod
// 
// @ ��� FlexValue ��ԋp����
//------------------------------------------------
int ModClsCmd::Nullmod( PDAT** ppResult )
{
	*ppResult = g_nullmod->pt;
	return HSPVAR_FLAG_STRUCT;
}

//------------------------------------------------
// dupmod
// 
// @ ���� Factory
//------------------------------------------------
// ���ߌ`��
void ModClsCmd::Dupmod()
{
	PVal* const pvSrc = code_get_var();
	PVal* const pvDst = code_get_var();		// ������

	if ( pvSrc->flag != HSPVAR_FLAG_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );

	auto const src = StructTraits::asValptr(PVal_getptr(pvSrc));

	FlexValue* const dst = code_reserve_modinst( pvDst, pvDst->offset );
	HspVarStructWrap_Dup( dst, src );
	return;
}

// �֐��`��
int ModClsCmd::Dupmod( PDAT** ppResult )
{
	FlexValue* const pSrc = code_get_fv();
	if ( !pSrc ) puterror( HSPERR_ILLEGAL_FUNCTION );

	FlexValue self { };
	{
		FlexValue src { };
		FlexValue_Copy( src, *pSrc );
		FlexValue_AddRef( src );
		{
			HspVarStructWrap_Dup( &self, &src );
		}
		FlexValue_Release( src );
	}
	return SetReffuncResult(ppResult, std::move(self));
}

//------------------------------------------------
// ���W���[���N���X�̖��O
//------------------------------------------------
int ModClsCmd::Name( PDAT** ppResult )
{
	stdat_t const modcls  = code_get_modcls();

	return SetReffuncResult( ppResult, ModCls::Name(modcls) );
}

//------------------------------------------------
// �ŗL�I�u�W�F�N�g�𓾂�
//------------------------------------------------
int ModClsCmd::Identity( PDAT** ppResult )
{
	stdat_t const modcls = code_get_modcls();

	return SetReffuncResult( ppResult, getModClsCtor(modcls) );
}

functor_t const& getModClsCtor( stdat_t modcls )
{
	auto const iter = g_pModClsIdentity->find( modcls );
	if ( iter != g_pModClsIdentity->end() ) {	// �L���b�V���ς�
		return iter->second;

	} else {
		functor_t functor { static_cast<exfunctor_t>(CModClsCtor::New(modcls)) };
		return g_pModClsIdentity->insert({ modcls, functor }).first->second;
	}
}

//------------------------------------------------
// �N���X�𓾂�
//------------------------------------------------
int ModInst_Cls( PDAT** ppResult )
{
	FlexValue* const src = code_get_modinst();
	auto       const kls = FlexValue_ModCls(*src);
	return SetReffuncResult( ppResult, getModClsCtor(kls) );
}

//------------------------------------------------
// �N���X���𓾂�
//------------------------------------------------
int ModInst_ClsName( PDAT** ppResult )
{
	FlexValue* const src = code_get_modinst();
	return SetReffuncResult( ppResult, FlexValue_ClsName(*src) );
}

//------------------------------------------------
// ���ꐫ��r
//------------------------------------------------
int ModInst_Identify( PDAT** ppResult )
{
	void* member_lhs = code_get_modinst()->ptr;
	void* member_rhs = code_get_modinst()->ptr;
	return SetReffuncResult( ppResult, HspBool(member_lhs == member_rhs) );
}

//------------------------------------------------
// thismod
// 
// @ thismod@hsp ���g�p�ł���B
// @ ���̃R�}���h�́A�l�Ƃ��Ďg����B
//------------------------------------------------
int ModClsCmd::This( PDAT** ppResult )
{
	auto const thismod = reinterpret_cast<MPModVarData*>(ctx->prmstack);
	if ( thismod->magic != MODVAR_MAGICCODE ) puterror( HSPERR_INVALID_STRUCT_SOURCE );
	if ( thismod->pval->flag != HSPVAR_FLAG_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );

	*ppResult = PVal_getPtr(thismod->pval, thismod->aptr);
	return HSPVAR_FLAG_STRUCT;
}

//------------------------------------------------
// 
//------------------------------------------------
#endif
