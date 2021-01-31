/*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
*
*		jump.hpi / rtjump
*				author uedai
*
*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*/

#include "hpimain.h"
#include "hsp3exrt.h"

// �֐��錾
static int cmdfunc( int cmd );

//------------------------------------------------
// ���߃R�}���h�Ăяo���֐�
//------------------------------------------------
static int cmdfunc( int cmd )
{
	code_next();
	
	switch( cmd ) {
		case 0x000: code_call( code_getlb() ); break;
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	
	return RUNMODE_RUN;
}

//------------------------------------------------
// �v���O�C���������֐�
//------------------------------------------------
HPIINIT(void) hsp3typeinit_jump( HSP3TYPEINFO* info )
{
	hsp3sdk_init( info );			// SDK�̏�����
	info->cmdfunc  = cmdfunc;		// ���s�֐�(cmdfunc)�̓o�^
	return;
}

#ifndef HSPEXRT

//------------------------------------------------
// Dll �G���g���[�|�C���g
//------------------------------------------------
BOOL WINAPI DllMain( HINSTANCE hInstance, DWORD fdwReason, PVOID pvReserved )
{
	return TRUE;
}

#endif
