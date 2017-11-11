// SysCursor module

#ifndef __SYSTEM_CURSOR_MODULE_AS__
#define __SYSTEM_CURSOR_MODULE_AS__

#module syscursor_mod

#define global IDC_ARROW			0x00007F00		// �W�����J�[�\��
#define global IDC_IBEAM			0x00007F01		// I �^�J�[�\��
#define global IDC_WAIT				0x00007F02		// �����v
#define global IDC_CROSS			0x00007F03		// �\��
#define global IDC_UPARROW			0x00007F04		// �����̖��J�[�\��
#define global IDC_SIZE				0x00007F80		// (�g�p���Ȃ�)
#define global IDC_ICON				0x00007F81		// (�g�p���Ȃ�)
#define global IDC_SIZENWSE			0x00007F82		// �΂߉E������̖��J�[�\��
#define global IDC_SIZENESW			0x00007F83		// �΂ߍ�������̖��J�[�\��
#define global IDC_SIZEWE			0x00007F84		// ���E ���J�[�\��
#define global IDC_SIZENS			0x00007F85		// �㉺ ���J�[�\��
#define global IDC_SIZEALL			0x00007F86		// �l�������J�[�\��
#define global IDC_NO				0x00007F88		// �֎~�J�[�\��
#define global IDC_HAND				0x00007F89		// ��J�[�\��
#define global IDC_APPSTARTING		0x00007F8A		// �W�����J�[�\������я��^�����v�J�[�\��
#define global IDC_HELP				0x00007F8B		// �H�J�[�\��

#uselib "user32.dll"
#func   SetClassLong@syscursor_mod "SetClassLongA" int,int,int
#cfunc  LoadCursor@syscursor_mod   "LoadCursorA"   nullptr,int
#func   SetCursor@syscursor_mod    "SetCursor"     int
#func   GetCursor@syscursor_mod    "GetCursor"

#define global SetSystemCursor(%1=hwnd,%2) _SetSystemCursor %1,%2
#deffunc _SetSystemCursor int p1, int p2
	
	// �V�X�e����`�J�[�\���̃n���h���擾
	hCursor = LoadCursor(p2)			// �V�X�e���̃J�[�\���n���h�����擾����
	if ( hCursor == 0 ) {
		return 1
	}
	
	SetClassLong p1, -12, hCursor		// -12 == GCL_HCURSOR
	SetCursor hCursor 					// �J�[�\���ύX
	return 0
	
#global

#if 0

	SetSystemCursor hwnd, IDC_NO;APPSTARTING
	stop
	
#endif

#endif
