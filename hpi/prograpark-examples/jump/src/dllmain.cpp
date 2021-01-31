/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*
*		jump.hpi
*				author Ue-dai @2008 12/27(Sat)
*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/

#include "dllmain.h"
#include "cmd.h"

// �֐��錾
extern int    cmdfunc(int cmd);
extern void  *reffunc(int *type_res, int cmd);

extern int   ProcFunc(int cmd, void **ppResult);
extern int ProcSysvar(int cmd, void **ppResult);

//###############################################
//        ���߃R�}���h�Ăяo���֐�
//###############################################
static int cmdfunc(int cmd)
{
	code_next();
	
	switch( cmd ) {
		case 0x000: jump_st(); break;
		case 0x001: code_setpc( code_getlb() ); break;
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	return RUNMODE_RUN;
}

//###############################################
//        �֐��R�}���h�Ăяo���֐�
//###############################################
static void *reffunc(int *type_res, int cmd)
{
	void *pResult = NULL;
	
//	if ( *type != TYPE_MARK || *val != '(' ) {
//		
//		*type_res = ProcSysvar( cmd, &pResult );
//		
//	} else {
		
		// '('�Ŏn�܂邩�𒲂ׂ�
		if ( *type != TYPE_MARK || *val != '(' ) puterror( HSPERR_INVALID_FUNCPARAM );
		code_next();
		
		// �R�}���h����
		*type_res = ProcFunc( cmd, &pResult );
		
		// '('�ŏI��邩�𒲂ׂ�
		if ( *type != TYPE_MARK || *val != ')' ) puterror( HSPERR_INVALID_FUNCPARAM );
		code_next();
//	}
	
	if ( pResult == NULL ) puterror( HSPERR_NORETVAL );
	
	return pResult;
}

//###############################################
//        �֐��R�}���h�����֐�
//###############################################
static int ProcFunc(int cmd, void **ppResult)
{
	switch ( cmd ) {
		case 0x000: return jump_f(ppResult);
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	return 0;
}

//###############################################
//        �V�X�e���ϐ��R�}���h�����֐�
//###############################################
/*
static int ProcSysvar(int cmd, void **ppResult)
{
	switch ( cmd ) {
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	return 0;
}
//*/

//###############################################
//        �v���O�C���������֐�
//###############################################
EXPORT void WINAPI hsp3hpi_init(HSP3TYPEINFO *info)
{
	hsp3sdk_init( info );			// SDK�̏�����
	
	info->cmdfunc  = cmdfunc;		// ���s�֐�(cmdfunc)�̓o�^
	info->reffunc  = reffunc;		// �Q�Ɗ֐�(reffunc)�̓o�^
//	info->termfunc = termfunc;		// �I���֐�(termfunc)�̓o�^
	
	return;
}
