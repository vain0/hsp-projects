// �L�[�{�[�h�ꊇ�`�F�b�N�N���X

#ifndef __MODULECLASS_KEYBOARD_AS__
#define __MODULECLASS_KEYBOARD_AS__

#module MCKeyboard mbKeyboard

#uselib "user32.dll"
#func   GetKeyboardState@MCKeyboard "GetKeyboardState" int

#define mv modvar MCKeyboard@

//##############################################################################
//        �����o���߁E�֐�
//##############################################################################
//*--------------------------------------------------------*
//        ��Ԏ擾�n
//*--------------------------------------------------------*
// �L�[�{�[�h��Ԃ��X�V
#modfunc KeyBd_check
	GetKeyboardState varptr(mbKeyboard)
	return
	
// �L�[��������Ă��邩
#defcfunc KeyBd_isPut mv, int keycode
	return ( peek(mbKeyboard, keycode) & 0x80 )
	
// �L�[���g�O����Ԃ�
#defcfunc KeyBd_isToggle mv, int keycode
	return ( peek(mbKeyboard, keycode) & 1 )
	
//##############################################################################
//        �R���X�g���N�^�E�f�X�g���N�^
//##############################################################################
#modinit
	sdim mbKeyboard, 256 + 2
	return
	
#global

#endif
