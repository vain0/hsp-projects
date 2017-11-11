// �q�E�B���h�E�쐬���W���[��

#ifndef IG_CREATE_CHILD_WINDOW_AS
#define IG_CREATE_CHILD_WINDOW_AS

#module mCreateChildWindow

#define WS_CHILD 0x40000000
#define WS_POPUP 0x80000000

#uselib "user32.dll"
#func   SetWindowLong@mCreateChildWindow "SetWindowLongA" int,int,int
#cfunc  GetWindowLong@mCreateChildWindow "GetWindowLongA" int,int
#func   SetParent@mCreateChildWindow     "SetParent"      int,int

// �}�N��
#define SetStyle(%1,%2=-16,%3=0,%4=0) SetWindowLong %1, %2, BitOff(GetWindowLong(%1, %2) | %3, %4)
#define ctype BITOFF(%1,%2=0) ( (%1) & ((%2) ^ 0xFFFFFFFF) )

//------------------------------------------------
// �q�E�B���h�E�̍쐬
// 
// @prm hParent : �e�E�B���h�E�̃n���h��
// @prm wid     : �g�p�����E�B���h�EID
// @prm sx, sy  : �E�B���h�E�̍ő�T�C�Y
// @prm flag    : �t���O (screen �Q��)
// @            : + 32 �ŃL���v�V�����Ȃ� (bgscr)
// @prm winStyle      : �ǉ��Ŏg���@�@�E�B���h�E�E�X�^�C��
// @prm winStyleEx    : �ǉ��Ŏg���g���E�B���h�E�E�X�^�C��
// @prm winOutStyle   : �g�p���Ȃ��@�@�E�B���h�E�E�X�^�C��
// @prm winOutStyleEx : �g�p���Ȃ��g���E�B���h�E�E�X�^�C��
// @result stat : �E�B���h�E�E�n���h�� (hwnd)
//------------------------------------------------
#deffunc CreateChildWindow int hParent, int wid, int sx, int sy, int flag, int winStyle, int winStyleEx, int winOutStyle, int winOutStyleEx
	if ( flag & 32 ) {
		bgscr  wid, sx, sy, 2 | (flag & 1), 0, 0
	} else {
		screen wid, sx, sy, 2 | (flag & 0b11111), 0, 0
	}
	
	hChild = hwnd
	SetStyle hwnd, -16, winStyle | WS_CHILD, winOutStyle | WS_POPUP	// �X�^�C�� (�q�E�B���h�E�ɂ���)
	
	if ( winStyleEx || winOutStyleEx ) {
		SetStyle hwnd, -20, winStyleEx, winOutStyleEx		// �g���X�^�C��
	}
	SetParent hwnd, hParent									// �q�E�B���h�E�ɂ���
	
	if ( (flag & 2) == 0 ) {	// �B�������������Ȃ�
		gsel wid, 1			// �J����
	}
	
	return hWin
	
#global

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

#enum IDW_Main = 0
#enum IDW_Child
	
	screen IDW_Main, 640, 480, 16
	CreateChildWindow hwnd, IDW_Child, 240, 120, 2 + 8	// �c�[���E�B���h�E
	width 120, 80, 0,0
	
	color : boxf : syscolor 15
	mes "���[��\n�c�c \n�q window ���"
	gsel IDW_Child, 1
	gsel IDW_Main,  1
	
	stop
	
#endif

#endif
