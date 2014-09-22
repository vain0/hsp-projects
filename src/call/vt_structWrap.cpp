// Call(ModCls) - vartype struct
#if 0
#include <map>
#include <array>
#include <limits>

#include "hsp3plugin_custom.h"
#include "mod_makePVal.h"

#include "cmd_modcls.h"
#include "vt_structWrap.h"
#include "modcls_FlexValue.h"

#include "CCaller.h"
#include "Functor.h"
#include "CPrmInfo.h"
#include "vt_functor.h"

using namespace hpimod;
using namespace ModCls;

// �e���|�����ϐ��ւ̎Q�� (���ʂɂ͎Q�Ƃł��Ȃ��̂ŁA�^����ꂽ�Ƃ��ɕۑ�����)
PVal* mpval_struct = nullptr;

PVal* ModCls::getMPValStruct()
{
	return mpval_struct;
}
PVal* ModCls::getMPVal(vartype_t type)
{
	return (mpval_struct ? (mpval_struct - HSPVAR_FLAG_STRUCT + type) : nullptr);
}

// ���X�� struct �^
static HspVarProc hvp_struct_impl;

// �O���錾
static void HspVarStructWrap_Alloc( PVal *pval, const PVal *pval2 );
static void HspVarStructWrap_Free( PVal *pval );

static void* HspVarStructWrap_Cnv      ( void const* buffer, int flag );
static void* HspVarStructWrap_CnvCustom( void const* buffer, int flag );

static void HspVarStructWrap_Set( PVal *pval, PDAT *pdat, const void *in );

static void HspVarStructWrap_AddI ( PDAT* pdat, void const* val );
static void HspVarStructWrap_SubI ( PDAT* pdat, void const* val );
static void HspVarStructWrap_MulI ( PDAT* pdat, void const* val );
static void HspVarStructWrap_DivI ( PDAT* pdat, void const* val );
static void HspVarStructWrap_ModI ( PDAT* pdat, void const* val );

static void HspVarStructWrap_AndI ( PDAT* pdat, void const* val );
static void HspVarStructWrap_OrI  ( PDAT* pdat, void const* val );
static void HspVarStructWrap_XorI ( PDAT* pdat, void const* val );

static void HspVarStructWrap_EqI  ( PDAT* pdat, void const* val );
static void HspVarStructWrap_NeI  ( PDAT* pdat, void const* val );
static void HspVarStructWrap_GtI  ( PDAT* pdat, void const* val );
static void HspVarStructWrap_LtI  ( PDAT* pdat, void const* val );
static void HspVarStructWrap_GtEqI( PDAT* pdat, void const* val );
static void HspVarStructWrap_LtEqI( PDAT* pdat, void const* val );

static void HspVarStructWrap_RrI  ( PDAT* pdat, void const* val );
static void HspVarStructWrap_LrI  ( PDAT* pdat, void const* val );

static void HspVarStructWrap_Method( PVal* pval );

static void HspVarStructWrap_InitCnvWrap();

//------------------------------------------------
// struct �����֐���u��������
//------------------------------------------------
void HspVarStructWrap_Init( HspVarProc* vp )
{
	hvp_struct_impl = *vp;

	vp->Alloc = HspVarStructWrap_Alloc;
	vp->Free  = HspVarStructWrap_Free;

	vp->Cnv   = HspVarStructWrap_Cnv;

	vp->Set   = HspVarStructWrap_Set;

	vp->AddI  = HspVarStructWrap_AddI;
	vp->SubI  = HspVarStructWrap_SubI;
	vp->MulI  = HspVarStructWrap_MulI;
	vp->DivI  = HspVarStructWrap_DivI;
	vp->ModI  = HspVarStructWrap_ModI;

	vp->AndI  = HspVarStructWrap_AndI;
	vp->OrI   = HspVarStructWrap_OrI;
	vp->XorI  = HspVarStructWrap_XorI;

	vp->EqI   = HspVarStructWrap_EqI;
	vp->NeI   = HspVarStructWrap_NeI;
	vp->GtI   = HspVarStructWrap_GtI;
	vp->LtI   = HspVarStructWrap_LtI;
	vp->GtEqI = HspVarStructWrap_GtEqI;
	vp->LtEqI = HspVarStructWrap_LtEqI;

	vp->RrI   = HspVarStructWrap_RrI;
	vp->LrI   = HspVarStructWrap_LrI;

	vp->ObjectMethod = HspVarStructWrap_Method;

	HspVarStructWrap_InitCnvWrap();
	return;
};

//------------------------------------------------
// �m��
//
// @ �����l�� nullmod �Ƃ���B
//------------------------------------------------
void HspVarStructWrap_Alloc( PVal* pval, PVal const* pval2 )
{
	if ( pval->len[1] < 1 ) pval->len[1] = 1;		// �z����Œ�1�͊m�ۂ���

	size_t const size = sizeof(FlexValue) * pval->len[1];
	auto const pt = reinterpret_cast<FlexValue*>(hspmalloc( size ));

	std::memset( pt, 0x00, size );

	// �l���p��(���� & src���) or ������
	if ( pval2 ) {
		// ���L�����ƊہX�R�s�[
		std::memmove(pt, pval2->pt, sizeof(FlexValue) * pval2->len[1]);

		// pval �̕����Z���ꍇ�A�p���ł��Ȃ�����j��
		auto const iter2 = VtTraits::asValptr<vtStruct>(pval2->pt);
		for ( int i = pval2->len[1]; i < pval->len[1]; ++i ) {
			FlexValue_Release(iter2[i]);
		}

		hspfree(pval2->pt);
	}

	pval->mode   = HSPVAR_MODE_MALLOC;
	pval->pt     = VtTraits::asPDAT<vtStruct>(pt);
	pval->size   = size;
//	pval->master = nullptr;	// �s�g�p
	return;
}

//------------------------------------------------
// ���
//------------------------------------------------
void HspVarStructWrap_Free( PVal* pval )
{
	if ( pval->mode == HSPVAR_MODE_MALLOC ) {
		auto const fv = VtTraits::asValptr<vtStruct>(pval->pt);
		for ( int i = 0; i < pval->len[1]; ++ i ) {
			FlexValue_Release( fv[i] );
		}
		hspfree( pval->pt );
	}
	else { assert(pval->mode == HSPVAR_MODE_CLONE || !pval->pt); }

	pval->mode = HSPVAR_MODE_NONE;
	pval->pt   = nullptr;
	pval->size = 0;
	return;
}

//------------------------------------------------
// ����
//------------------------------------------------
void HspVarStructWrap_Set( PVal* pval, PDAT* pdat, PDAT const* in )
{
	auto& fv_dst = *VtTraits::asValptr<vtStruct>(pdat);
	auto& fv_src = *VtTraits::asValptr<vtStruct>(in);

	FlexValue_Copy( fv_dst, fv_src );

	// �e���|�����ϐ��ւ̑��(��j�󉉎Z�̍��� | code_get() �̕Ԓl)
	// �e���|�����ϐ����L�����Ă���
	if ( !mpval_struct && (pval->support & HSPVAR_SUPPORT_TEMPVAR) ) {
		mpval_struct = pval;
	}

	FlexValue_ReleaseTmp(fv_src);
	return;
}

//------------------------------------------------
// �o�^���ꂽ���Z���̂��������Ď擾����
// 
// @result: �֐��q
//------------------------------------------------
static functor_t const& StructWrap_GetMethod( int subid, int opId )
{
	CModOperator const* const pModOp = getModOperator();

	// ���Z�֐����X�g������ 
	auto const iterCls = pModOp->find( subid );
	if ( iterCls == pModOp->end() ) { dbgout("no operation defined in %d", subid); puterror( HSPERR_UNSUPPORTED_FUNCTION ); }

	// ���s�����̎擾 
	auto const iterOp = iterCls->second.find( opId );
	if ( iterOp == iterCls->second.end() || iterOp->second->getUsing() == 0 ) { dbgout("operation #%d is not defined", opId); puterror( HSPERR_UNSUPPORTED_FUNCTION ); }

	functor_t const& functor = iterOp->second;

	return functor;
}

//------------------------------------------------
// �����֐��Ăяo��
// 
// @result: �������ꂽ�C���X�^���X (�Q�ƃJ�E���^: 1) or nullmod
//------------------------------------------------
void HspVarStructWrap_Dup( FlexValue* result, FlexValue* fv )
{
	if ( FlexValue_IsNull(*fv) ) {
		FlexValue_DelRef( *result );
		return;
	}

	// �ꎞ�ϐ� (����ɕ���������Ă��炤)
	PVal _pvTmp { };
	PVal* const pvTmp = &_pvTmp;

	PVal_init( pvTmp, HSPVAR_FLAG_STRUCT );

	// �Ăяo�� 
	{
		CCaller caller;
		functor_t const& functor = StructWrap_GetMethod( FlexValue_SubId(*fv), OpId_Dup );

		// �Ăяo������ 
		caller.setFunctor( functor );
		caller.addArgByVal( fv, HSPVAR_FLAG_STRUCT );
		caller.addArgByRef( pvTmp );

		// �Ăяo�� 
		caller.call();
	}

	if ( pvTmp->flag != HSPVAR_FLAG_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );
	FlexValue_Move( *result, *VtTraits::asValptr<vtStruct>(pvTmp->pt) );

	PVal_free( pvTmp );
	return;
}

//------------------------------------------------
// ���b�v���ꂽ���Z�֐�
// 
// @ ��j��񍀉��Z ( += �łȂ��A+ �Ȃǂ̂��� ) �̏ꍇ�A
// @	�R�[�h���s���� mpval �|�C���^���ς���Ă��܂��̂ŁA
// @	�����߂��O�� mpval �� mpval_struct �ɒ����Ă����B
// @ ��j��Ȃ�A���ӂ̃C���X�^���X��j�󂵂Ă͂����Ȃ��̂ŁA
// @	���ӂ̕����ɑ΂��ď������s�� (�ꎞ�I�u�W�F�N�g��Ԃ�)�B
// @ lhs(thismod) �� null �Ȃ猋�ʂ� null �A�̂ɉ������Ȃ��B
//------------------------------------------------
static void HspVarStructWrap_CoreI( PDAT* pdat, void const* val, int opId )
{
	// ��j��񍀉��Z�̏ꍇ (mpval_struct �͊��Ɏ擾�ł��Ă���͂�)
	bool const bTempOp =
		(mpval_struct && (void*)mpval_struct->pt == pdat);

	auto const lhs = VtTraits::asValptr<vtStruct>(pdat);
	auto const rhs = VtTraits::asValptr<vtStruct>(val);
	assert(!!lhs && !!rhs);

	// �Ăяo��
	if ( !FlexValue_IsNull(*lhs) ) {
		CCaller caller;

		functor_t const& functor = StructWrap_GetMethod( FlexValue_SubId(*lhs), opId );

		// �����𐶐����� 
		if ( bTempOp ) {
			FlexValue _lhsDup = {0};
			FlexValue* const lhsDup = &_lhsDup;
			{
				FlexValueHolder lhsBak( *lhs );	// dup ���ɉ��Ă��܂�����̂ŁAmpval_struct ��ۑ�
				HspVarStructWrap_Dup( lhsDup, lhs );
				FlexValue_AddRefTmp( *lhsDup );	// �ԋp����ăX�^�b�N�ɏ��̂�
			}

			// lhs �� lhsDup �������� (���X���������� lhsDup �ŕێ�)
			std::swap( *lhs, *lhsDup );
			
			// ���ӂɌ��X�������C���X�^���X��j��
			FlexValue_Release( *lhsDup );
		}

		// �Ăяo������ 
		caller.setFunctor( functor );
		caller.addArgByVal( lhs, HSPVAR_FLAG_STRUCT );
		caller.addArgByVal( rhs, HSPVAR_FLAG_STRUCT );

		// �Ăяo�� 
		caller.call();

	// ���ӂ� nullmod => �Ԓl�� nullmod
	} else {
		FlexValue_DelRef(*lhs);
	}

	getHvp(HSPVAR_FLAG_STRUCT)->aftertype = HSPVAR_FLAG_STRUCT;

	if ( bTempOp ) *(exinfo->mpval) = mpval_struct;	// restore

	// �E�ӂ��ꎞ�I�u�W�F�N�g�Ȃ�A�X�^�b�N����~���
	FlexValue_ReleaseTmp( *rhs );
	return;
}

//------------------------------------------------
// ���b�v���ꂽ���Z�֐�::��r
// 
// @ �����𐶐����Ȃ��B
// @ CmpI ���ĂсA���̕Ԓl���r�l�Ƃ��ė��p����B
// @ mpval_struct ��j�󂷂�̂łȂ��Ampval �� mpval_int �ɍ����ւ��āA
// @	����ɉ��Z�Ԓl��������B
//------------------------------------------------
static void HspVarStructWrap_CmpI( PDAT* pdat, void const* val, int opId )
{
	// ��j��񍀉��Z�̏ꍇ
	bool const bTempOp = (mpval_struct && (void*)mpval_struct->pt == pdat);	

	if ( !bTempOp ) {
		// ������� => ���ӕϐ��̌^���ς�邪�A����̓G���[�ɂȂ�̂Ő�ɃG���[���o���Ă���
		dbgout("int �^�ȊO�̕��������r���Z�͍s���Ȃ��B");
		puterror( HSPERR_TYPE_MISMATCH );
	}

	auto const lhs = VtTraits::asValptr<vtStruct>(pdat);
	auto const rhs = VtTraits::asValptr<vtStruct>(val);

	// ���Z����
	int cmp;

	// �Ăяo�� 
	if ( !FlexValue_IsNull(*lhs) && !FlexValue_IsNull(*rhs) ) {
		CCaller caller;
		functor_t const& functor = StructWrap_GetMethod( FlexValue_SubId(*lhs), OpId_Cmp );

		// �Ăяo������ 
		caller.setFunctor( functor );
		caller.addArgByVal(   lhs, HSPVAR_FLAG_STRUCT );
		caller.addArgByVal(   rhs, HSPVAR_FLAG_STRUCT );
		caller.addArgByVal( &opId, HSPVAR_FLAG_INT );

		// �Ăяo�� 
		caller.call();

		// �Ԓl���擾 
		PDAT* result = nullptr;
		vartype_t const resVt = caller.getCallResult( &result );
		if ( resVt != HSPVAR_FLAG_INT ) puterror( HSPERR_TYPE_MISMATCH );

		cmp = VtTraits::derefValptr<vtInt>(result);

	} else {
		// �ǂ��炩�� nullmod �̂Ƃ��Anullmod �łȂ������傫���Ƃ������Ƃɂ���
		cmp = (!FlexValue_IsNull(*lhs) ? 1 : 0) - (!FlexValue_IsNull(*rhs) ? 1 : 0);
	}

	// ���Z�Ԓl��ݒ肷��
	int const calccode = opId &~ OpFlag_Calc;
	int const resultValue = HspBool(
		( calccode == CALCCODE_EQ   ) ? cmp == 0 :
		( calccode == CALCCODE_NE   ) ? cmp != 0 :
		( calccode == CALCCODE_GT   ) ? cmp >  0 :
		( calccode == CALCCODE_LT   ) ? cmp <  0 :
		( calccode == CALCCODE_GTEQ ) ? cmp >= 0 :
		( calccode == CALCCODE_LTEQ ) ? cmp <= 0 : (puterror( HSPERR_UNKNOWN_CODE ), false)
	);

	PVal* const pvRes = getMPVal(HSPVAR_FLAG_INT);
	if ( !pvRes ) { dbgout("mpval_int is unknown"); puterror( HSPERR_UNKNOWN_CODE ); }
	*(exinfo->mpval) = pvRes; 
	*(int*)pvRes->pt = resultValue;

	getHvp(HSPVAR_FLAG_STRUCT)->aftertype = HSPVAR_FLAG_INT;

	// �E�ӂ��X�^�b�N����~���̂ňꎞ�I�u�W�F�N�g�Ȃ�������
	FlexValue_ReleaseTmp( *rhs );
	return;
}

void HspVarStructWrap_AddI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_ADD ); }
void HspVarStructWrap_SubI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_SUB ); }
void HspVarStructWrap_MulI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_MUL ); }
void HspVarStructWrap_DivI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_DIV ); }
void HspVarStructWrap_ModI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_MOD ); }

void HspVarStructWrap_AndI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_AND ); }
void HspVarStructWrap_OrI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_OR  ); }
void HspVarStructWrap_XorI ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_XOR ); }

void HspVarStructWrap_EqI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CmpI ( pdat, val, OpFlag_Calc | CALCCODE_EQ   ); }
void HspVarStructWrap_NeI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CmpI ( pdat, val, OpFlag_Calc | CALCCODE_NE   ); }
void HspVarStructWrap_GtI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CmpI ( pdat, val, OpFlag_Calc | CALCCODE_GT   ); }
void HspVarStructWrap_LtI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CmpI ( pdat, val, OpFlag_Calc | CALCCODE_LT   ); }
void HspVarStructWrap_GtEqI( PDAT* pdat, void const* val ) { HspVarStructWrap_CmpI ( pdat, val, OpFlag_Calc | CALCCODE_GTEQ ); }
void HspVarStructWrap_LtEqI( PDAT* pdat, void const* val ) { HspVarStructWrap_CmpI ( pdat, val, OpFlag_Calc | CALCCODE_LTEQ ); }

void HspVarStructWrap_RrI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_RR ); }
void HspVarStructWrap_LrI  ( PDAT* pdat, void const* val ) { HspVarStructWrap_CoreI( pdat, val, OpFlag_Calc | CALCCODE_LR ); }

//------------------------------------------------
// �^�ϊ� (from)
//------------------------------------------------
PDAT* HspVarStructWrap_Cnv( PDAT const* buffer, int flag )
{
	// �w��^(flag) �� struct
	if ( flag != HSPVAR_FLAG_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );
	return const_cast<PDAT*>(buffer);
}

//------------------------------------------------
// �^�ϊ� (to)
// 
// @ CnvCustom: CnvTo ( struct �� ���� )
//------------------------------------------------
PDAT* HspVarStructWrap_CnvCustom( PDAT const* buffer, int flag )
{
	int const opId = OpFlag_CnvTo | flag;
	auto const fv = VtTraits::asValptr<vtStruct>(buffer);

	if ( flag == HSPVAR_FLAG_STRUCT ) return VtTraits::asPDAT<vtStruct>(const_cast<FlexValue*>(fv));

	PDAT* result = nullptr;

	// �Ăяo�� 
	if ( !FlexValue_IsNull(*fv) ) {
		PVal*& mpval = *exinfo->mpval;

		PVal _pvTmp = {0};			// mpval �̒l��ۑ�
		PVal* const pvTmp = &_pvTmp;
		bool const bInExpr = (mpval->flag == flag);	// ���Z���̉E�ӂ̌^�ϊ����� => �R�[�h���s�� mpval ��j�󂵂Ă��܂��̂ŁA�ۑ�����
		if ( bInExpr ) {
			PVal_init( pvTmp, HSPVAR_FLAG_INT );
			PVal_assign( pvTmp, mpval->pt, mpval->flag );
		}

		// �ϊ��֐����Ăяo��
		{
			CCaller caller;
			functor_t const& functor = StructWrap_GetMethod(FlexValue_SubId(*fv), opId);

			caller.setFunctor(functor);
			caller.addArgByVal(fv, HSPVAR_FLAG_STRUCT);

			caller.call();

			vartype_t resVt = caller.getCallResult(&result);
			if ( resVt != flag ) puterror(HSPERR_TYPE_MISMATCH);
		}

		// ��n�� 
		if ( bInExpr ) {
			mpval = getMPVal(flag);
			PVal_assign( mpval, pvTmp->pt, pvTmp->flag );	// mpval �̒l�� restore
			PVal_free( pvTmp );
		}
		
		// �X�^�b�N����~���
		FlexValue_ReleaseTmp(*fv);

	} else {	// nullmod �� ��
		static PVal* pval;
		if ( !pval ) {
			pval = reinterpret_cast<PVal*>(hspmalloc( sizeof(PVal) ));
			PVal_init( pval, flag );
		}
		switch ( flag ) {
			case HSPVAR_FLAG_LABEL:
			{
				static label_t const lb = nullptr; PVal_assign( pval, VtTraits::asPDAT<vtLabel>(&lb), flag ); break;
			}
			case HSPVAR_FLAG_STR:
			{
				static char const* const s = ""; PVal_assign( pval, VtTraits::asPDAT<vtStr>(s), flag ); break;
			}
			case HSPVAR_FLAG_DOUBLE:
			{
				static double const r = std::numeric_limits<double>::quiet_NaN();
				PVal_assign( pval, VtTraits::asPDAT<double>(&r), flag ); break;
			}
			case HSPVAR_FLAG_INT:
			{
				static int const n = 0; PVal_assign( pval, VtTraits::asPDAT<vtInt>(&n), flag ); break;
			}
			default: puterror( HSPERR_UNSUPPORTED_FUNCTION );
		}
		result = pval->pt;
	}

	return result;
}

//------------------------------------------------
// �^�ϊ��֐��̃��b�v
// 
// @ �g�ݍ��݌^�� Cnv ���Astruct �̂Ƃ��ɓ��ꏈ������悤�Ƀ��b�v����B
// @	�g�ݍ��݌^�́uint �^�ւ̕ϊ��v�̊֐���p����̂ŁA
// @	����� struct ���^����ꂽ�Ƃ��� HspvarStructWrap_CnvCustom ��p����悤�ɂ���B
// @ ���X�̊֐��� g_cnvfunc_impl �ɕۑ�����B
//------------------------------------------------
/*
#include <functional>

typedef void* (*cnvfunc_t)( void const* buffer, int flag );
typedef std::function<void*( void const*, int )> cnvfuncLambda_t;

static std::array<cnvfunc_t,       HSPVAR_FLAG_USERDEF> g_cnvfunc_impl;	// ���X�ݒ肳��Ă��� Cnv �֐�
static std::array<cnvfuncLambda_t, HSPVAR_FLAG_USERDEF> g_cnvfunc_wrap;	// ���b�v���� Cnv �֐�

void HspVarStructWrap_InitCnvWrap()
{
	// ���b�p�[�֐��𐶐�����֐�
	auto makeCnvFuncWrapper = []( vartype_t this_type ) {
		return [this_type]( void const* buffer, int flag ) {
			return ( flag == HSPVAR_FLAG_STRUCT )
				? HspVarStructWrap_CnvCustom( buffer, flag )
				: g_cnvfunc_impl[ this_type ]( buffer, flag );
		};
	};

	// �e�g�ݍ��݌^�� Cnv �����b�v����
	for ( int i = 1; i <= HSPVAR_FLAG_STRUCT; ++ i ) {
		HspVarProc* vp = getHvp(i);

		g_cnvfunc_wrap[i] = makeCnvFuncWrapper( i );
		g_cnvfunc_impl[i] = vp->Cnv;
		vp->Cnv = g_cnvfunc_wrap[i];		// function<> �͊֐��|�C���^�ɂł��Ȃ�
	}

	return;
}

/*/
typedef PDAT* (*cnvfunc_t)( PDAT const* buffer, int flag );
static std::array<cnvfunc_t, HSPVAR_FLAG_USERDEF> g_cnvfunc_impl;	// ���X�ݒ肳��Ă��� Cnv �֐�
static std::array<cnvfunc_t, HSPVAR_FLAG_USERDEF> g_cnvfunc_wrap;	// ���b�v���� Cnv �֐�

#if 0
#define FTM_HspVarStructWrap_CnvWrap(Name, Type) \
	static void* HspVarStructWrap_CnvWrap_##Name( const void *buffer, int flag )	\
	{\
		return ( flag == HSPVAR_FLAG_STRUCT )				\
			? HspVarStructWrap_CnvCustom( buffer, Type )	\
			: g_cnvfunc_impl[ Type ]( buffer, flag );		\
	}

FTM_HspVarStructWrap_CnvWrap( Label,  HSPVAR_FLAG_LABEL  );
FTM_HspVarStructWrap_CnvWrap( Str,    HSPVAR_FLAG_STR    );
FTM_HspVarStructWrap_CnvWrap( Double, HSPVAR_FLAG_DOUBLE );
FTM_HspVarStructWrap_CnvWrap( Int,    HSPVAR_FLAG_INT    );
FTM_HspVarStructWrap_CnvWrap( Struct, HSPVAR_FLAG_STRUCT );
#endif

template<vartype_t Type>
PDAT* HspVarStructWrap_CnvWrap( PDAT const* buffer, int flag )
{
	return ( flag == HSPVAR_FLAG_STRUCT )
		? HspVarStructWrap_CnvCustom( buffer, Type )
		: g_cnvfunc_impl[ Type ]( buffer, flag );
}
//template<> void* HspVarStructWrap_CnvWrap<HSPVAR_FLAG_STRUCT>( void const* buffer, int flag )
//{ return HspVarStructWrap_CnvCustom( buffer, HSPVAR_FLAG_STRUCT ); }

void HspVarStructWrap_InitCnvWrap()
{
	g_cnvfunc_wrap[ HSPVAR_FLAG_LABEL  ] = HspVarStructWrap_CnvWrap<HSPVAR_FLAG_LABEL>;
	g_cnvfunc_wrap[ HSPVAR_FLAG_STR    ] = HspVarStructWrap_CnvWrap<HSPVAR_FLAG_STR>;
	g_cnvfunc_wrap[ HSPVAR_FLAG_DOUBLE ] = HspVarStructWrap_CnvWrap<HSPVAR_FLAG_DOUBLE>;
	g_cnvfunc_wrap[ HSPVAR_FLAG_INT    ] = HspVarStructWrap_CnvWrap<HSPVAR_FLAG_INT>;

	// �e�g�ݍ��݌^�� Cnv �����b�v����
	for ( int i = 1; i < HSPVAR_FLAG_STRUCT; ++ i ) {
		auto const vp = getHvp(i);

		g_cnvfunc_impl[i] = vp->Cnv;
		vp->Cnv = g_cnvfunc_wrap[i];
	}

	return;
}
//*/

//------------------------------------------------
// ���\�b�h
// 
// @ OpId_Method �ɓo�^���ꂽ���߂��ĂсA
// @	�����ŕԋp���ꂽ functor ���Ăяo���B
//------------------------------------------------
void HspVarStructWrap_Method( PVal* pval )
{
	FlexValue& self = *reinterpret_cast<FlexValue*>( getHvp(HSPVAR_FLAG_STRUCT)->GetPtr(pval) );
	FlexValue_AddRef( self );

	char* const method = code_gets();

	if ( FlexValue_IsNull(self) ) return;

	functor_t functorImpl;		// ���ۂ̃��\�b�h
	int const exflg_bak = *exinfo->npexflg;	// �ۑ�

	// ���U�֐��̌Ăяo�� 
	{
		CCaller caller;
		functor_t const& functorMethod = StructWrap_GetMethod( FlexValue_SubId(self), OpId_Method );

		caller.setFunctor( functorMethod );
		caller.addArgByVal( &self, HSPVAR_FLAG_STRUCT );
		caller.addArgByVal( method, HSPVAR_FLAG_STR );

		caller.call();

		PDAT* result;
		vartype_t const resultType = caller.getCallResult( &result );

		functorImpl = *reinterpret_cast<functor_t*>( g_hvpFunctor->Cnv( result, resultType ) );
	}

	*exinfo->npexflg = exflg_bak;	// restore

	// ���\�b�h���̂̌Ăяo�� 
	{
		CCaller caller;

		// �Ăяo������ 
		caller.setFunctor( functorImpl );

		int const prmtype = functorImpl->getPrmInfo().getPrmType(0);
		if ( prmtype == PrmType::Modvar || prmtype == PrmType::Var
		  || prmtype == HSPVAR_FLAG_STRUCT || prmtype == PrmType::Any
		 ) {		// �������� modvar ��n����ꍇ thismod ��n��
			caller.addArgByVal( &self, HSPVAR_FLAG_STRUCT );
		}
		
		// �X�N���v�g������������o��
		caller.setArgAll();

		// �Ăяo�� 
		caller.call();
	}

	FlexValue_Release( self );
	return;
}
#endif
