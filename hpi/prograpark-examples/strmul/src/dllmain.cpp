// strmul.hpi
// uedai from 2008 12/25 (Thu)

#include "dllmain.h"
#include "cmd.h"

// �֐��錾
extern int    cmdfunc(int cmd);
extern void  *reffunc(int *type_res, int cmd);

extern int   ProcFunc(int cmd, void **ppResult);

//------------------------------------------------
// ���߃R�}���h�Ăяo���֐�
//------------------------------------------------
static int cmdfunc( int cmd )
{
	code_next();
	
	switch( cmd ) {
		case 0x000: strncpy(ctx->refstr, strmul(), HSPCTX_REFSTR_MAX - 1); break;
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	return RUNMODE_RUN;
}

//------------------------------------------------
// �֐��R�}���h�Ăяo���֐�
//------------------------------------------------
static void *reffunc( int *type_res, int cmd )
{
	void *pResult = NULL;
	
	// '('�Ŏn�܂邩�𒲂ׂ�
	if ( *type != TYPE_MARK || *val != '(' ) puterror( HSPERR_INVALID_FUNCPARAM );
	code_next();
	
	// �R�}���h����
	*type_res = ProcFunc( cmd, &pResult );
	
	// '('�ŏI��邩�𒲂ׂ�
	if ( *type != TYPE_MARK || *val != ')' ) puterror( HSPERR_INVALID_FUNCPARAM );
	code_next();
	
	if ( pResult == NULL ) puterror( HSPERR_NORETVAL );
	
	return pResult;
}

//------------------------------------------------
// �֐��R�}���h�����֐�
//------------------------------------------------
static int ProcFunc( int cmd, void **ppResult )
{
	switch ( cmd ) {
		case 0x000: *ppResult = strmul(); return HSPVAR_FLAG_STR;
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	return 0;
}

//------------------------------------------------
// �v���O�C���������֐�
//------------------------------------------------
EXPORT void WINAPI hsp3hpi_init( HSP3TYPEINFO *info )
{
	hsp3sdk_init( info ); // SDK�̏�����(�ŏ��ɍs�Ȃ��ĉ�����)
	
	info->cmdfunc  = cmdfunc; // ���s�֐�(cmdfunc)�̓o�^
	info->reffunc  = reffunc; // �Q�Ɗ֐�(reffunc)�̓o�^
	
	return;
}
