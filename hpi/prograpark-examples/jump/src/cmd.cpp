// jump - command

#include "cmd.h"

extern bool jump_core(LABEL lb, PVal *pval);

// jump���߂̃R�A
static bool jump_core(LABEL lb, PVal *pval)
{
	int old_sublev;
	
	old_sublev = ctx->sublev;	// sublev ���L�����Ă���
	
	code_call( lb );			// �W�����v
	
	 // �߂�l����H
	if (ctx->retval_level == (old_sublev + 1) ) {
		PVal *pretval = *exinfo->mpval;
		
		if ( pval != NULL ) {
			HspVarProc *phvp = exinfo->HspFunc_getproc( pretval->flag );
			code_setva( pval, pval->offset, pretval->flag, phvp->GetPtr(pretval) );
		}
		
		return true;
	}
	
	return false;	// �߂�l�Ȃ�
}

//##########################################################
//        ���ߌ`���R�}���h�֐�
//##########################################################
void jump_st(void)
{
	LABEL label;
	PVal *pval = NULL;
	APTR aptr;
	
	label = code_getlb();
	if ( (*exinfo->npexflg & EXFLG_1) == false ) {	// �܂�����������Ȃ�
		aptr         = code_getva( &pval );
		pval->offset = aptr;
	}
	
	// �ʏ�̃T�u���[�`���R�[���H
	if ( pval == NULL ) {
		code_call( label );
		
	// �߂�l�t���R�[���H
	} else {
		ctx->stat = ( jump_core( label, pval ) ? 1 : 0 );
	}
	return;
}

//##########################################################
//        �֐��`���R�}���h�֐�
//##########################################################
int jump_f(void **ppResult)
{
	static PVal *stt_retvar = NULL;
	LABEL label;
	
	// ����Ăяo�����H
	if ( stt_retvar == NULL ) {
		stt_retvar         = (PVal *)hspmalloc( sizeof(PVal) );
		stt_retvar->flag   = HSPVAR_FLAG_INT;
		stt_retvar->mode   = HSPVAR_MODE_NONE;
		stt_retvar->offset = 0;
		
		HspVarProc *phvp;
		phvp = exinfo->HspFunc_getproc(HSPVAR_FLAG_INT);
		phvp->Alloc(stt_retvar, NULL);
	}
	
	// �T�u���[�`���Ăяo��
	label = code_getlb();
	
	// �߂�l������H
	if ( jump_core( label, stt_retvar ) ) {
		HspVarProc *phvp;
		
		phvp      = exinfo->HspFunc_getproc( stt_retvar->flag );
		*ppResult = phvp->GetPtr( stt_retvar );
		
	} else {
		puterror( HSPERR_NORETVAL );
	}
	
	return stt_retvar->flag;
}

//##########################################################
//        �V�X�e���ϐ��`���R�}���h�֐�
//##########################################################
