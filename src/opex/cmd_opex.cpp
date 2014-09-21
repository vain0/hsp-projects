// opex - command

#include "mod_makepval.h"
#include "mod_argGetter.h"
#include "reffuncResult.h"

#include "cmd_opex.h"

using namespace hpimod;

static operator_t GetOpFuncPtr( HspVarProc* hvp, OPTYPE optype );

//------------------------------------------------
// ������Z
// 
// @ �A��������Z�Ή�
//------------------------------------------------
static PVal* assign_impl()
{
	PVal* const pval = code_get_var();	// �����

	// ���l�̑��
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	PVal_assign( pval, mpval->pt, mpval->flag );

	// �A�����
	code_assign_multi( pval );

	return pval;
}

void assign()
{
	assign_impl();
	return;
}

int assign( PDAT** ppResult )
{
	PVal* const pval = assign_impl();

	*ppResult = PVal_getptr(pval);
	return pval->flag;
}

//------------------------------------------------
// �������Z (�����e�[�g)
//------------------------------------------------
static PVal* swap_impl()
{
	static size_t const stc_maxCnt = 16;

	PVal* pval[stc_maxCnt];
	APTR  aptr[stc_maxCnt];

	// �����͍Œ�2�K�v
	aptr[0] = code_getva( &pval[0] );
	aptr[1] = code_getva( &pval[1] );

	int cnt = 2;
	for ( ; cnt < stc_maxCnt && code_isNextArg(); ++cnt ) {
		aptr[cnt] = code_getva( &pval[cnt] );
	}

	// ����
	for ( int i = cnt - 1; i > 0; -- i ) {
		PVal_swap( pval[i], pval[(i + 1) % cnt], aptr[i], aptr[(i + 1) % cnt] );
	}

	return pval[cnt - 1];	// �Ō��ԋp����
}

void swap()
{
	swap_impl();
	return;
}

int swap( PDAT** ppResult )
{
	PVal* const pval = swap_impl();
	*ppResult = PVal_getptr( pval );
	return pval->flag;
}

//------------------------------------------------
// ��Q�Ɖ��Z
//------------------------------------------------
static PVal* clone_impl()
{
	PVal* const pvDst = code_get_var();
	PVal* const pvSrc = code_get_var();

	PVal_cloneVar( pvDst, pvSrc );
	return pvDst;
}

void clone()
{
	clone_impl();
	return;
}

int clone( PDAT** ppResult )
{
	PVal* const pval = clone_impl();
	*ppResult = PVal_getptr( pval );
	return pval->flag;
}

//------------------------------------------------
// �L���X�g���Z
// 
// @ mpval �̊֌W�ŁA��� flag ���󂯎�邪�A
// @	�}�N���� castTo( value, flagDst ) �̏��ɒ�������B
//------------------------------------------------
int castTo( PDAT** ppResult )
{
	vartype_t const flag = code_geti();
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );

	*ppResult = const_cast<PDAT*>(
		Valptr_cnvTo( reinterpret_cast<PDAT*>(mpval->pt), mpval->flag, flag )
	);
	return flag;
}

//------------------------------------------------
// �����o�ϐ��̎��o��
//------------------------------------------------
static PVal* GetMemberOf(void* prmstack, stprm_t stprm)
{
	assert(stprm->mptype == MPTYPE_LOCALVAR);
	return reinterpret_cast<PVal*>( Prmstack_getMemberPtr(prmstack, stprm) );
}

static PVal* code_get_struct_member()
{
	FlexValue* const modSrc = code_get_struct();
	stprm_t const stprm = code_get_stprm();

	if ( !(modSrc->type != FLEXVAL_TYPE_NONE
		&& FlexValue_getModuleTag(modSrc)->subid == stprm->subid
		&& modSrc->ptr) ) puterror(HSPERR_INVALID_STRUCT_SOURCE);

	PVal* const pvMember = GetMemberOf(modSrc->ptr, stprm);

	// ���̌チ���o�ϐ��̓Y���������s��
	return pvMember;
}

static PVal* code_get_struct_member_lhs()
{
	PVal* const pvMember = code_get_struct_member();

	if ( *type == TYPE_MARK && *val == '(' ) {
		code_next();
		code_expand_index_lhs(pvMember);
		code_next_expect(TYPE_MARK, ')');

	} else if ( PVal_supportArray(pvMember) && !(pvMember->support & HSPVAR_SUPPORT_ARRAYOBJ) ) {
		HspVarCoreReset(pvMember);
	}
	return pvMember;
}

static PDAT* code_get_struct_member_rhs(int& vtype)
{
	PVal* const pvMember = code_get_struct_member();

	if ( *type == TYPE_MARK && *val == '(' ) {
		int mptype = 0;

		code_next();
		PDAT* const pResult = code_expand_index_rhs(pvMember, vtype);
		code_next_expect(TYPE_MARK, ')');

		return pResult;

	} else if ( PVal_supportArray(pvMember) && !(pvMember->support & HSPVAR_SUPPORT_ARRAYOBJ) ) {
		HspVarCoreReset(pvMember);
	}

	vtype = pvMember->flag;
	return pvMember->pt;
}

// @prm: [ mod, member,  src ]
// memberOf(mod, member) = src �Ƒ������B
void memberOf()
{
	PVal* const pvMember = code_get_struct_member_lhs();
	int const chk = code_getprm();
	if ( chk <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);

	PVal_assign(pvMember, mpval->pt, mpval->flag);
	return;
}

// @prm: [ src_mod, src_member ]
int memberOf(PDAT** ppResult)
{
	int vtype = HSPVAR_FLAG_NONE;
	*ppResult = code_get_struct_member_rhs(vtype);
	return vtype;
}

// @prm: [ dst_var, src_mod, src_member ]
void memberClone()
{
	PVal* const pvDst = code_get_var();
	PVal* const pvMember = code_get_struct_member_lhs();
	PVal_cloneVar(pvDst, pvMember);
	return;
}

//------------------------------------------------
// 
//------------------------------------------------

//#########################################################
//        �֐�
//#########################################################
//------------------------------------------------
// �Z���_�����Z
//------------------------------------------------
int shortLogOp( PDAT** ppResult, bool bAnd )
{
	bool bResult = (bAnd ? true : false);

	for(;;) {
		// ����
		int const prm = code_getprm();
		if ( prm <= PARAM_END ) break;
		if ( mpval->flag != HSPVAR_FLAG_INT ) puterror( HSPERR_TYPE_MISMATCH );

		bool const predicate = (*(int*)mpval->pt != 0);

		// and: 1�ł� false ������� false
		if ( bAnd && !predicate ) {
			bResult = false;
			break;

		// or: 1�ł� true ������� true
		} else if ( !bAnd && predicate ) {
			bResult = true;
			break;
		}
	}

	// �c��̈������̂Ă�
	while ( code_skipprm() > PARAM_END )
		;

	return SetReffuncResult( ppResult, bResult );
}

//------------------------------------------------
// ��r���Z
//------------------------------------------------
int cmpLogOp( PDAT** ppResult, bool bAnd )
{
	bool bResult = (bAnd ? true : false);

	// ��r���̒l���擾
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );

	vartype_t const flag = mpval->flag;
	auto const pfOp = GetOpFuncPtr( getHvp(flag), (OPTYPE)OPTYPE_EQ );

	if ( pfOp == NULL ) puterror( HSPERR_TYPE_MISMATCH );

	// ��r���̒l��ۑ�
	size_t const size = PVal_size( mpval );
	void* const pTarget    = hspmalloc(size);	// ���f�[�^
	void* const pTargetTmp = hspmalloc(size);	// ��Ɨp�o�b�t�@
	if ( !pTarget || !pTargetTmp ) puterror( HSPERR_OUT_OF_MEMORY );

	std::memcpy( pTarget, mpval->pt, size );			// �ہX�R�s�[���Ă���

	// ��r�l�Ɣ�r
	for(;;) {
		int prm = code_getprm();
		if ( prm <= PARAM_END ) break;

		bool bPred;

		if ( mpval->flag != flag ) {
			bPred = false;	// �^���Ⴄ���_�ŃA�E�g

		} else {
			// pTarget ����Ɨp�o�b�t�@�R�s�[
			memcpy( pTargetTmp, pTarget, size );

			// ���Z
			(*pfOp)( (PDAT*)pTargetTmp, mpval->pt );	// ���Z�q�̓���
			bPred = ( *(int*)pTargetTmp != 0 );
		}

		if ( bAnd && !bPred ) {
			bResult = false;
			break;

		} else if ( !bAnd && bPred ) {
			bResult = true;
			break;
		}
	}

	// �c��̈������̂Ă�
	while ( code_skipprm() > PARAM_END )
		;

	// �o�b�t�@�����
	if ( pTarget    ) hspfree( pTarget    );
	if ( pTargetTmp ) hspfree( pTargetTmp );

	return SetReffuncResult( ppResult, bResult );
}

//------------------------------------------------
// �������Z (?:)
//------------------------------------------------
int which(PDAT** ppResult)
{
	bool const predicate = (code_geti() != 0);
	if ( !predicate ) code_skipprm();		// �U => �^�̕������΂�

	if ( code_getprm() <= PARAM_END ) {
		puterror( HSPERR_NO_DEFAULT );
	}

	// �Ԓl�ƂȂ�l�����o��
	vartype_t const flag = mpval->flag;
	*ppResult = mpval->pt;

	if ( predicate ) code_skipprm();		// �^ => �U�̕������΂�
	return flag;
}

//------------------------------------------------
// ����֐�
//------------------------------------------------
int what(PDAT** ppResult)
{
	int const idx = code_geti();
	if ( idx < 0 ) puterror( HSPERR_ILLEGAL_FUNCTION );

	// �O�̕������΂��Ă���
	for( int i = 0; i < idx; i ++ ) {
		if ( code_skipprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	}

	// �Ԓl�ƂȂ�l�����o��
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	vartype_t const flag = mpval->flag;
	*ppResult = mpval->pt;

	// �c��̈������̂Ă�
	while ( code_skipprm() > PARAM_END )
		;

	return flag;
}

//------------------------------------------------
// ���X�g��
// 
// @ �e������]�����āA�Ō�̈����̒l��Ԃ��B
//------------------------------------------------
int exprs( PDAT** ppResult )
{
	while ( code_getprm() > PARAM_END )
		;

	*ppResult = mpval->pt;
	return mpval->flag;
}

//------------------------------------------------
// 
//------------------------------------------------

//#########################################################
//        �V�X�e���ϐ�
//#########################################################
//------------------------------------------------
// (kw) �萔�|�C���^
// 
// @ kw_constptr || CONST_VALUE
//------------------------------------------------
int kw_constptr( PDAT** ppResult )
{
	if ( *exinfo->npexflg & (EXFLG_1 | EXFLG_2) ) puterror( HSPERR_SYNTAX );

	int result;

	switch ( *type ) {
		case TYPE_STRING:
		case TYPE_DNUM:
			result = reinterpret_cast<int>( &ctx->mem_mds[*val] );
			break;

		case TYPE_INUM:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );	// CS���ɖ��ߍ��܂�Ă���̂łƂ�Ȃ�
		default:
			puterror( HSPERR_SYNTAX );
	}
	code_next();

	if ( !(*type == TYPE_MARK && *val == OPTYPE_OR) ) puterror( HSPERR_SYNTAX );
	code_next();

	return SetReffuncResult( ppResult, result );
}

//------------------------------------------------
// 
//------------------------------------------------

//#########################################################
//        ������
//#########################################################
//------------------------------------------------
// Hvp ���牉�Z�����֐������o��
//------------------------------------------------
operator_t GetOpFuncPtr( HspVarProc* hvp, OPTYPE optype )
{
	if ( !hvp ) return nullptr;
	switch ( optype ) {
		case OPTYPE_ADD: return hvp->AddI;
		case OPTYPE_SUB: return hvp->SubI;
		case OPTYPE_MUL: return hvp->MulI;
		case OPTYPE_DIV: return hvp->DivI;
		case OPTYPE_MOD: return hvp->ModI;
		case OPTYPE_AND: return hvp->AndI;
		case OPTYPE_OR:  return hvp->OrI;
		case OPTYPE_XOR: return hvp->XorI;

		case OPTYPE_EQ:   return hvp->EqI;
		case OPTYPE_NE:   return hvp->NeI;
		case OPTYPE_GT:   return hvp->GtI;
		case OPTYPE_LT:   return hvp->LtI;
		case OPTYPE_GTEQ: return hvp->GtEqI;
		case OPTYPE_LTEQ: return hvp->LtEqI;

		case OPTYPE_RR: return hvp->RrI;
		case OPTYPE_LR: return hvp->LrI;
		default:
			return nullptr;
	}
}

           