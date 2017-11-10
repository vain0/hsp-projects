// opex - command

#include "mod_makepval.h"
#include "mod_argGetter.h"
#include "mod_func_result.h"

#include "cmd_opex.h"

static operator_t GetOpFuncPtr( HspVarProc* hvp, OPTYPE optype );

//#########################################################
//        ����
//#########################################################
//------------------------------------------------
// ������Z
// 
// @ �A��������Z�Ή�
//------------------------------------------------
int assign( void** ppResult )
{
	PVal* pval = code_get_var();	// �����
	
	// ���l�̑��
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	PVal_assign( pval, mpval->pt, mpval->flag );
	
	// �A�����
	code_assign_multi( pval );
	
	// �֐��Ȃ�ԋp�l�̐ݒ�
	if ( ppResult != NULL ) {
		*ppResult = PVal_getptr(pval);
		return pval->flag;
	}
	
	return 0;			// ���߂Ȃ�K���ɒl��Ԃ��Ă�������
}

//------------------------------------------------
// �������Z
//------------------------------------------------
int swap( void** ppResult )
{
	PVal* pval1; APTR aptr1 = code_getva( &pval1 );	// �ϐ�#1
	PVal* pval2; APTR aptr2 = code_getva( &pval2 );	// �ϐ�#2
	
	// ����
	PVal_swap( pval1, pval2, aptr1, aptr2 );
	
	// �֐��Ȃ�ԋp�l�̐ݒ�
	if ( ppResult != NULL ) {
		*ppResult = PVal_getptr( pval2 );
		return pval2->flag;
	}
	
	return 0;			// ���߂Ȃ�K���ɒl��Ԃ��Ă�������
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
int shortLogOp( void** ppResult, bool bAnd )
{
	bool bResult = (bAnd ? true : false);
	
	for(;;) {
		// ����
		int const prm = code_getprm();
		if ( prm <= PARAM_END ) break;
		if ( mpval->flag != HSPVAR_FLAG_INT ) puterror( HSPERR_TYPE_MISMATCH );
		
		bool predicate = (*(int*)mpval->pt != 0);	// ����
		if ( bAnd && !predicate ) {				// and: 1�ł� false ������� false
			bResult = false;
			break;
			
		} else if ( !bAnd && predicate ) {		// or: 1�ł� true ������� true
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
int cmpLogOp( void** ppResult, bool bAnd )
{
	bool bResult = (bAnd ? true : false);
	
	// ��r���̒l���擾
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	
	vartype_t   flag = mpval->flag;
	HspVarProc* pHvp = exinfo->HspFunc_getproc( flag );
	operator_t  pfOp = GetOpFuncPtr( pHvp, (OPTYPE)OPTYPE_EQ );	// optype: �֌W���Z�Ȃ�Ȃ�ł��������A== �ɂ���
	
	if ( pfOp == NULL ) puterror( HSPERR_TYPE_MISMATCH );
	
	// ��r���̒l��ۑ�
	size_t size      = PVal_size( mpval );
	void* pTarget    = (void*)hspmalloc( size );	// ���f�[�^
	void* pTargetTmp = (void*)hspmalloc( size );	// ��Ɨp�o�b�t�@
	if ( pTarget == NULL || pTargetTmp == NULL ) puterror( HSPERR_OUT_OF_MEMORY );
	
	memcpy( pTarget, mpval->pt, size );			// �ہX�R�s�[���Ă���
	
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
	if ( pTarget    != NULL ) hspfree( pTarget    );
	if ( pTargetTmp != NULL ) hspfree( pTargetTmp );
	
	return SetReffuncResult( ppResult, bResult );
}

//------------------------------------------------
// �������Z (?:)
//------------------------------------------------
int which(void** ppResult)
{
	bool  predicate = (code_geti() != 0);	// ����
	if ( !predicate ) code_skipprm();		// �U => �^�̕������΂�
	
	if ( code_getprm() <= PARAM_END ) {
		puterror( HSPERR_NO_DEFAULT );
	}
	
	// �Ԓl�ƂȂ�l�����o��
	vartype_t flag = mpval->flag;
	*ppResult = mpval->pt;
	
	if ( predicate ) code_skipprm();		// �^ => �U�̕������΂�
	return flag;
}

//------------------------------------------------
// ����֐�
//------------------------------------------------
int what(void** ppResult)
{
	int idx = code_geti();
	if ( idx < 0 ) puterror( HSPERR_ILLEGAL_FUNCTION );
	
	// �O�̕������΂��Ă���
	for( int i = 0; i < idx; i ++ ) {
		if ( code_skipprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	}
	
	// �Ԓl�ƂȂ�l�����o��
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	vartype_t flag = mpval->flag;
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
int exprs( void** ppResult )
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
	if ( hvp == NULL ) return NULL;
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
			return NULL;
	}
}
