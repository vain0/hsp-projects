/*************************************************
 * �u�}�E�X�̖��������]���Ă��邩�ǂ����v���A
 * ���ׂ郂�W���[���ł��B
 * �t�@�C�����E�֐����� Is Mouse Button Swapped �́A
 * �������炵��������A�K���ɕύX���Ă��������B
 * 
 * ���g����
 * �X�N���v�g�̎n�߂ɁACheckMouseButton �}�N�����g���܂��B
 * �O���[�o���ϐ� bMouseBtnSwapped �ɁA
 * �}�E�X�̖�������������Ă�����A�^(0�ȊO)���A
 * �����łȂ���΁A�U(0)���������܂��B
 * 
 * getkey ���߂ɔ��f����ɂ́A
 * �@���N���b�N�FGETKEY_LBTN
 * �@�E�N���b�N�FGETKEY_RBTN
 * 
 * stick ���߂ɔ��f����ɂ́A
 * �@���N���b�N�FSTICK_LBTN
 * �@�E�N���b�N�FSTICK_RBTN
 * 
 * ���A���ۂ̐��l�̑���Ɏg�p���Ă��������B
 ************************************************/

#ifndef __IS_MOUSE_BUTTON_SWAPPED_AS__
#define __IS_MOUSE_BUTTON_SWAPPED_AS__

#ifndef ___GetSystemMetrics@
 #uselib "user32.dll"
 #cfunc ___GetSystemMetrics@ "GetSystemMetrics" int
#endif

//------------------------------------------------
// �ϐ��}�N��
//------------------------------------------------
#define global bMouseBtnSwapped __bMouseButtonSwapped@

//------------------------------------------------
// �`�F�b�N�}�N��
// 
// @ �������x�����N������
// @ SM_SWAPBUTTON( �}�E�X�@�\����������Ă�����^ )
//------------------------------------------------
#define global CheckMouseButton bMouseBtnSwapped = ___GetSystemMetrics@(23)

//------------------------------------------------
// stick�p�ɒ�`
//------------------------------------------------
#define global STICK_LBTN (256 + (256 * bMouseBtnSwapped))
#define global STICK_RBTN (512 - (256 * bMouseBtnSwapped))

//------------------------------------------------
// getkey�p�ɒ�`
//------------------------------------------------
#define global GETKEY_LBTN (1 + bMouseBtnSwapped)
#define global GETKEY_RBTN (2 - bMouseBtnSwapped)

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

	CheckMouseButton	// ���ŏ��Ɉ��Ăяo�������I
	
	// ���]�����N���b�N�𐳊m�Ɋ��m����
	width 240, 180
	
*mainlp
	redraw 2
	
	color 255, 255, 255 : boxf : color
	pos 20, 20
	
	// getkey ����o�[�W����
	mes "getkey"
	getkey bLDown, GETKEY_LBTN : mes "���{�^���F"+ bLDown	// ��
	getkey bRDown, GETKEY_RBTN : mes "�E�{�^���F"+ bRDown	// �E
	mes
	
	// stick ���g���o�[�W����
	mes "stick"
	
	stick key, STICK_LBTN	// ���N���b�N���g���K�[�ɂ���
	mes "���{�^���F"+ ( key & STICK_LBTN )
	mes "�E�{�^���F"+ ( key & STICK_RBTN )
	
	redraw
	await 20
	goto *mainlp
	
#endif

#endif
