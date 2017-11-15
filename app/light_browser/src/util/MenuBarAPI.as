// MenuBarAPI

#ifndef IG_MENU_BAR_API_AS
#define IG_MENU_BAR_API_AS

#uselib "user32.dll"
#cfunc  global CreateMenu         "CreateMenu"							// hMenu = CreateMenu()
#cfunc  global CreatePopupMenu    "CreatePopupMenu"						// hMenu = CreatePopupMenu()
#func   global AppendMenu         "AppendMenuA"        int,int,int,sptr	// hMenu, State, IDM, "str"
#func   global SetMenuItemInfo    "SetMenuItemInfoA"   int,int,int,int	// hMenu, ID, Flag, MENUITEMINFO *
#func   global GetMenuItemInfo    "GetMenuItemInfoA"   int,int,int,int	// �V
#func   global EnableMenuItem     "EnableMenuItem"     int,int,int		// hMenu, ID, Flag
#func   global CheckMenuItem      "CheckMenuItem"      int,int,int		// hMenu, ID, Flag
#func   global CheckMenuRadioItem "CheckMenuRadioItem" int,int,int,int,int	// hMenu, FirstID, LastID, DefID, Flag
#func   global SetMenuItemBitmaps "SetMenuItemBitmaps" int,int,int,int,int	// hMenu, ID, Flag, hBmpUnchecking, hBmpChecking
#func   global SetMenu            "SetMenu"            int,int				// hwnd, hMenu
#func   global DrawMenuBar        "DrawMenuBar"        int					// hwnd
#func   global DestroyMenu        "DestroyMenu"        int					// hMenu
#func   global TrackPopupMenuEx   "TrackPopupMenuEx"   int,int,int,int,int,int	// hPopMenu, Flag, sPosX, sPosY, hwnd, LPRECT for Can'tPopupArea (or Nullptr)

#define global AddSeparator(%1) AppendMenu (%1), 0x0800, 0, ""	// hMenu
#define global SetRadioMenu(%1,%2,%3,%4=0) CheckMenuRadioItem %1,%2,%3,(%2)+(%4),0

// ���W���[��
#module menu_mod

// hMenu, ID, bNewState, 3(Grayed) | 8(Checked)
#deffunc MI_ChangeState int p1, int p2, int p3, int p4
	dim mii, 12								// MENUITEMINFO �\����
		mii = 48, 1, 0, ((p3 != 0) * p4)	// fState
	SetMenuItemInfo p1, p2, 0, varptr(mii)
	return (stat)
	
// hMenu, ID, "NewString"
#deffunc SetMenuString int p1, int p2, str p3
	string = p3
	dim mii, 12
		mii = 48, 0x0040
		mii(9) = varptr(string)
	SetMenuItemInfo p1, p2, 0, varptr(mii)	// �ݒ�
	return (stat)
#global

#if 0

// ���j���[�A�C�e���̎��ʎq��enum�Œ�`
#enum IDM_NONE = 0	// 1�߂� = 0 ���K�v
	// �t�@�C��
#enum IDM_NEW
#enum IDM_OPEN
#enum IDM_OWS	// = Over Write Save
#enum IDM_SAVE
	#enum IDM_CHAR_SJIS
	#enum IDM_CHAR_UTF_8
	#enum IDM_CHAR_UTF_16
#enum IDM_QUIT
	// �ҏW
#enum IDM_UNDO
;#enum IDM_REDO
#enum IDM_CUT
#enum IDM_COPY
#enum IDM_PASTE
#enum IDM_DELETE
#enum IDM_ALLSEL
	// ����
#enum IDM_SEARSH
#enum IDM_FIND_BACK
#enum IDM_FIND_NEXT
#enum IDM_REPLACE
	// �c�[��
#enum IDM_INSTIME

// ���̑��̒�`(�K�{�ł͂Ȃ�)
#uselib "user32.dll"
#func PostMessage   "PostMessageA" int,int,int,int
#func MoveWindow    "MoveWindow"   int,int,int,int,int,int
#func GetWindowRect "GetWindowRect" int,int

#define fname getpath(fdir, 8)
#define fext  getpath(fdir, 2+16)
#define titleEx(%1="new") title "Edit - "+ (%1)
#define Renew(%1=buf,%2=fname) objprm EditInfo(1),%1:titleEx %2

#const wID_Main 1

// ���C���J�n
	gsel 0, -1
	screen 0, 0, 0, 2
*main
	
	screen wID_Main, ginfo(20), ginfo(21), 2,,, 640, 480
	gosub *CreateMenuBar			// ���j���[�o�[���쐬����
	
	dim    EditInfo, 2
	sdim   buf, 65535
	mesbox buf, ginfo(12), ginfo(13)	// �ȈՃG�f�B�^�Ȃ̂ŁA�ꉞ
	EditInfo = objinfo(stat, 2), stat
	
	notesel buf
	
	titleEx
	gsel wID_Main, 1
	
	onIDM  gosub *Command, 0x0111	// WM_COMMAND (���j���[�o�[����̊��荞��)
	onIDM  gosub *Resize,  0x0005	// WM_SIZE (�T�C�Y�ύX)
;	onkey  gosub *key				// �L�[���荞��
	onexit goto  *exit				// �I�����̌Ăяo��
	
	stop

*CreateMenuBar
	// ���j���[�A�C�e�����쐬
	hCharacter= CreatePopupMenu() 
	hFileMenu = CreatePopupMenu()
		AppendMenu hFileMenu, 0, IDM_NEW,  "�V�K�쐬(&N)"		+"\t\tCtrl + N"
		AppendMenu hFileMenu, 0, IDM_OPEN, "�J��(&O)"			+"\t\tCtrl + O"
		AppendMenu hFileMenu, 0, IDM_OWS,  "�㏑���ۑ�(&S)"		+"\t\tCtrl + S"
		AppendMenu hFileMenu, 0, IDM_SAVE, "���O�����ĕۑ�"
		AddSeparator hFileMenu	// �Z�p���[�^
		AppendMenu hFileMenu, 0x10, hCharacter, "�����R�[�h"
			AppendMenu hCharacter, 0, IDM_CHAR_SJIS,   "S-JIS"
			AppendMenu hCharacter, 0, IDM_CHAR_UTF_8,  "UTF-8"
			AppendMenu hCharacter, 0, IDM_CHAR_UTF_16, "UTF-16"
		AddSeparator hFileMenu
		AppendMenu hFileMenu, 0, IDM_QUIT, "���̃\�t�g���I������\t\tCtrl + Q"
	
	hEditMenu = CreatePopupMenu()
		AppendMenu hEditMenu, 0, IDM_UNDO,  "���ɖ߂�(&U)"		+"\t\tCtrl + Z"
		AddSeparator hEditMenu
		AppendMenu hEditMenu, 0, IDM_CUT,   "�؂���(&T)"		+"\t\tCtrl + X"
		AppendMenu hEditMenu, 0, IDM_COPY,  "�R�s�[(&C)"		+"\t\tCtrl + C"
		AppendMenu hEditMenu, 0, IDM_PASTE, "�\��t��(&P)"		+"\t\tCtrl + V"
		AppendMenu hEditMenu, 0, IDM_DELETE, "�폜(&D)"			+"\t\t Delete "
		AddSeparator hEditMenu
		AppendMenu hEditMenu, 0, IDM_ALLSEL, "���ׂđI�� \t\tCtrl + Q"
		
	hFindMenu = CreatePopupMenu()
		AppendMenu hFindMenu, 0, IDM_SEARCH,    "�����񌟍�" + "\t\tCtrl + F"
		AppendMenu hFindMenu, 0, IDM_FIND_BACK, "�������"   + "\t\t  F2"
		AppendMenu hFindMenu, 0, IDM_FIND_NEXT, "�O������"   + "\t\t  F3"
		AppendMenu hFindMenu, 0, IDM_REPLACE,   "������u��" + "\t\tCtrl + R"
		
	hFormMenu = CreatePopupMenu()
		AppendMenu hFormMenu, 0, IDM_INSTIME, "���݂̎�����}��\t\t F5"
		
	// �o�[�̃��j���[
	hMenu = CreateMenu()
		AppendMenu hMenu, 0x10, hFileMenu, "�t�@�C��(&F)"
		AppendMenu hMenu, 0x10, hEditMenu, "�ҏW(&E)"
		AppendMenu hMenu, 0x10, hFindMenu, "����(&S)"
		AppendMenu hMenu, 0x10, hFormMenu, "����(&O)"
		AppendMenu hMenu, 0x10, IDM_QUIT,  "�I��(&Q)"
		
	// �����R�[�h���Z�b�g�ɂ���
	SetRadioMenu hCharacter, IDM_CHAR_SJIS, IDM_CHAR_UTF_16, 0
	
	// ���j���[�o�[���쐬
	SetMenu     hwnd, hMenu			// ���j���[���E�B���h�E�Ɋ��蓖�Ă�
	DrawMenuBar hwnd				// ���j���[���ĕ`��
	return
	
*Command
	cID = wParam & 0xFFFF
	
	switch cID
	case IDM_NEW	: gosub *new									: swbreak	// �V�K�쐬
	case IDM_OPEN	: gosub *open									: swbreak	// �J��
	case IDM_RELOAD	: gosub *ReLoad									: swbreak	// �ēǍ�
	case IDM_OWS	: gosub *OverWriteSave							: swbreak	// �㏑���ۑ�
	case IDM_SAVE	: gosub *Save									: swbreak	// ���O�����ĕۑ�
	case IDM_QUIT	: PostMessage hwnd, 0x0010, 0, 0				: swbreak	// �I��
	
	case IDM_UNDO	: sendmsg EditInfo, 0x0304, 0, 0				: swbreak	// �A���h�D
	case IDM_CUT	: sendmsg EditInfo, 0x0300, 0, 0				: swbreak	// �؂���
	case IDM_COPY	: sendmsg EditInfo, 0x0301, 0, 0				: swbreak	// �R�s�[
	case IDM_PASTE	: sendmsg EditInfo, 0x0302, 0, 0				: swbreak	// �\��t��
	case IDM_DELETE	: sendmsg EditInfo, 0x0303, 0, 0				: swbreak	// �폜
	case IDM_ALLSEL	: sendmsg EditInfo, 0x00B1, 0, strlen(buf)		: swbreak	// ���ׂđI��
	
	case IDM_CHAR_SJIS		// ����3�̂ǂ�ł��ύX�ɂȂ�
	case IDM_CHAR_UTF_8		// �����R�[�h�𐧌䂷�鏈���͓���Ă��܂���B
	case IDM_CHAR_UTF_16
		SetRadioMenu hCharacter, IDM_CHAR_SJIS, IDM_CHAR_UTF_16, cID - IDM_CHAR_SJIS
		swbreak
		
	case IDM_INSTIME : gosub *InsTime								: swbreak
	swend
	return
	
*New
	dialog "���ׂč폜���Ă���낵���ł����H", 2, "�x��"
	if ( stat == 7 ) { return }
	
	memset buf,  0, 65535
	memset fdir, 0, 260
	
	Renew "", "new"
	return
	
*Open
	dialog "*", 16, "÷��̧��"
	if ( stat == 0 ) { return }
	exist refstr
	if ( strsize == -1 ) { return }
	fdir =    refstr
	noteload (refstr)
	
	Renew
	return
	
*Reload
	dialog "���݂̕ҏW�͖����ɂȂ�A�Ō�ɕۑ�������Ԃɖ߂��܂��B\n��낵���ł����H", 2, "�x��"
	exist fdir
	if ( stat == 0 || strsize == -1 ) { return }
	
	noteload fdir
	Renew
	return
	
*OverWriteSave
	exist fdir
	if ( strsize == -1 ) {
		goto *Save
	}
	notesave fdir
	Renew
	return
	
*Save
	dialog "*", 17, "�ۑ���"
	if ( stat == 0 ) { return }
	fdir =    refstr
	notesave (refstr)
	
	Renew
	return
	
*InsTime			// ���݂̎�����}������
	// ����[21:16 2008/04/23]
	sdim tstr, 320
	tstr = ""+ strf("%02d", gettime(4)) +":"+ strf("%02d", gettime(5)) +" "+ gettime(0) +"/"+ gettime(1) +"/"+ gettime(3)
	
	sendmsg EditInfo, 0x00C2, 1, varptr(tstr)
	return
	
*Resize				// �E�B���h�E�̃T�C�Y���ς����
	MoveWindow EditInfo, 0, 0, lParam & 0xFFFF, (lParam >> 16) & 0xFFFF, 1
	return
	
*exit
	// dialog ���߂ł� [�L�����Z��] �t���̃_�C�A���O���o���Ȃ��B
	dialog "���e��ۑ����܂����H", 2, "�I���͎~�܂�܂���c�c"
	if ( stat == 6 ) { gosub *Save }
	
	if ( hMenu ) { DestroyMenu hMenu }	// ���j���[�o�[��j�� (�K�{)
	
	noteunsel	// �K�v�Ȃ�
	end
	
#endif

#endif
