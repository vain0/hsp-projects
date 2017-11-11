// �E�B���h�E�Ɋւ��邠�ꂱ��

// �E���W�ϊ�( �X�N���[���A�E�B���h�E�A�N���C�A���g )
// �E�V�X�e�����j���[���ڂ̍폜( �ړ��֎~�Ȃ� )

#ifndef IG_WINDOW_COORD_SYS_AS
#define IG_WINDOW_COORD_SYS_AS

#module mod_window

//------------------------------------------------
//        Win32 API
//------------------------------------------------
#uselib "user32.dll"
#func   SetWindowLong@mod_window  "SetWindowLongA" int,int,int
#cfunc  GetWindowLong@mod_window  "GetWindowLongA" int,int
#func   GetWindowRect@mod_window  "GetWindowRect"  int,int
#func   ScreenToClient@mod_window "ScreenToClient" int,int
#func   ClientToScreen@mod_window "ClientToScreen" int,int
#cfunc  GetSystemMenu@mod_window  "GetSystemMenu"  int,int
#func   DeleteMenu@mod_window     "DeleteMenu"     int,int,int

//------------------------------------------------
//        �}�N��
//------------------------------------------------
#define ctype HIWORD(%1) (((%1) >> 16) & 0xFFFF)
#define ctype LOWORD(%1) ((%1) & 0xFFFF)
#define ctype MAKELONG(%1,%2) (LOWORD(%1) | (LOWORD(%2) << 16))
#define true  1
#define false 0
#define NULL  0

//------------------------------------------------
//        �萔
//------------------------------------------------
#define SC_MINIMIZE   0xF020
#define SC_MAXIMIZE   0xF030
#define SC_CLOSE      0xF060
#define SC_RESTORE    0xF120
#define SC_TASKLIST   0xF130
#define SC_SCREENSAVE 0xF140

#define WS_MAXIMIZEBOX 0x00010000
#define WS_MINIMIZEBOX 0x00020000
#define WS_SYSMENU     0x00080000

//##############################################################################
//                ���߁E�֐��Q
//##############################################################################
//------------------------------------------------
// ���W���[��������
//------------------------------------------------
#deffunc initialize_mod_window
	dim rctmp@mod_window, 4
	dim pttmp@mod_window, 2
	return
	
//################################################
//        ���W���ݕϊ�
//################################################

//------------------------------------------------
// �X�N���[�����W ���� �N���C�A���g���W
//------------------------------------------------
#defcfunc CnvScreenToClient int hWindow, int position
	pttmp = LOWORD(position), HIWORD(position)
	ScreenToClient hWindow, varptr(pttmp)
	return MAKELONG( pttmp(0), pttmp(1) )
	
#defcfunc CnvClientToScreen int hWindow, int position
	pttmp = LOWORD(position), HIWORD(position)
	ClientToScreen hWindow, varptr(pttmp)
	return MAKELONG( pttmp(0), pttmp(1) )
	
//------------------------------------------------
// �X�N���[�����W ���� �E�B���h�E���W
//------------------------------------------------
#defcfunc CnvScreenToWindow int hWindow, int position
	GetWindowRect hWindow, varptr(rctmp)
	return MAKELONG( LOWORD(position) - rctmp(0), HIWORD(position) - rctmp(1) )
	
#defcfunc CnvWindowToScreen int hWindow, int position
	GetWindowRect hWindow, varptr(rctmp)
	return MAKELONG( LOWORD(position) + rctmp(0), HIWORD(position) + rctmp(1) )
	
//------------------------------------------------
// �E�B���h�E���W ���� �N���C�A���g���W
//------------------------------------------------
#defcfunc CnvWindowToClient int hWindow, int position
	return CnvScreenToClient( hWindow, CnvWindowToScreen(hWindow, position) )
	
#defcfunc CnvClientToWindow int hWindow, int position
	return CnvScreenToWindow( hWindow, CnvClientToScreen(hWindow, position) )
	
//################################################
//        �E�B���h�E�E�T�C�Y
//################################################
//------------------------------------------------
// WM_SYSCOMMAND �֌W
//------------------------------------------------
#define global Window_Minimize(%1) sendmsg %1, 0x0112, SC_MINIMIZE@mod_window, 0
#define global Window_Maximize(%1) sendmsg %1, 0x0112, SC_MAXIMIZE@mod_window, 0
#define global Window_Restore(%1)  sendmsg %1, 0x0112, SC_RESTORE@mod_window,  0
#define global Window_TaskList(%1) sendmsg %1, 0x0112, SC_TASKLIST@mod_window, 0
#define global Window_ScreenSave(%1) sendmsg %1, 0x0112, SC_SCREENSAVE@mod_window, 0

//################################################
//        ���̑�
//################################################
//------------------------------------------------
// �ړ����ւ���
//------------------------------------------------
#deffunc ForbidMoving int hWindow
	DeleteMenu GetSystemMenu( hWindow, false ), 0xF010, 0
	return
	
//------------------------------------------------
// �V�X�e�����j���[�����ɖ߂�
//------------------------------------------------
#deffunc ResetSystemMenu int hWindow
	return GetSystemMenu( hWindow, true )	// p2 �� true ���w��A�߂�l�� NULL
	
//------------------------------------------------
// �ő剻�{�^����L�����E������
//------------------------------------------------
#deffunc EnableMaximizeBox int hWindow, int bAble
	SetWindowLong hWindow, -16, BITOFF(GetWindowLong(hWindow, -16) | WS_MAXIMIZEBOX * (bAble != false), WS_MAXIMIZEBOX * (bAble == false) )
	return
	
//------------------------------------------------
// �ŏ����{�^����L�����E������
//------------------------------------------------
#deffunc EnableMinimizeBox int hWindow, int bAble
	SetWindowLong hWindow, -16, BITOFF(GetWindowLong(hWindow, -16) | WS_MINIMIZEBOX * (bAble != false), WS_MINIMIZEBOX * (bAble == false) )
	return
	
//------------------------------------------------
// �E�B���h�E�{�^����L�����E������
//------------------------------------------------
#deffunc EnableWindowBtn int hWindow, int bAble
	SetWindowLong hWindow, -16, BITOFF(GetWindowLong(hWindow, -16) | WS_SYSMENU * (bAble != false), WS_SYSMENU * (bAble == false) )
	return
	
#global

	initialize_mod_window

/*******************************************************************************
�����W�̐���

���X�N���[�����W
	���(�X�N���[��)�S�̂���݂����W�B��΍��W�I�ȑ��݁B
	
���E�B���h�E���W
	�E�B���h�E�̍���𒆐S�Ƃ������W�B
	
���N���C�A���g���W
	�E�B���h�E�̒��̃N���C�A���g�̈�̍���𒆐S�Ƃ������W�B
	�^�C�g���o�[��E�B���h�E�̘g�Ȃǂ͊܂܂Ȃ����߁A�E�B���h�E���W�Ǝ኱�Ⴄ�l�ɂȂ�B
	
*******************************************************************************/

#endif
