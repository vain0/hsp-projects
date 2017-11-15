// �^�u�R���g���[�����샂�W���[��

#ifndef IG_MODULECLASS_TAB_CONTROL_AS
#define IG_MODULECLASS_TAB_CONTROL_AS

#include "mod_shiftArray.as"
#include "GetFontOfHSP.as"

// @ ���ڂ��Ȃ��Ƃ��̋����͎��M�Ȃ��B

// TabInt ( �֘A���l ) �@�\���g���ꍇ�́A��`���Ă��������B
;	#define __USE_TABINT__

#ifdef  __USE_TABINT__
 #define global __USE_TABINT_ON__
#endif

//##############################################################################
//                Tab-Ctrl �萔
//##############################################################################
#define global WC_TABCONTROL "SysTabControl32"	// �N���X��

#if 1
#define global TCM_FIRST				0x1300		// �^�u�R���g���[���֑��郁�b�Z�[�W�̊J�n
#define global TCM_GETIMAGELIST			0x1302		// �C���[�W���X�g���擾
#define global TCM_SETIMAGELIST			0x1303		// �C���[�W���X�g��ݒ�
#define global TCM_GETITEMCOUNT			0x1304		// �^�u�̐����擾
#define global TCM_GETITEM				0x1305		// �^�u�̏����擾
#define global TCM_SETITEM				0x1306		// �^�u�̑�����ݒ�
#define global TCM_INSERTITEM			0x1307		// �V�����^�u����(�܂�)��}��
#define global TCM_DELETEITEM			0x1308		// �܂݂���폜
#define global TCM_DELETEALLITEMS		0x1309		// ���ׂĂ̂܂݂��폜
#define global TCM_GETITEMRECT			0x130A		// (TIndex, 0) wParam �̂܂ݕ����� RECT ���擾
#define global TCM_GETCURSEL			0x130B		// �I������Ă��� TabIndex ���擾
#define global TCM_SETCURSEL			0x130C		// �܂݂�I��
#define global TCM_HITTEST				0x130D		// (0, varptr(TcHitTestInfo)) �w����W�ɂ���܂݂� Index ���擾
#define global TCM_SETITEMEXTRA			0x130E		// �^�u���ڂɊ֘A�Â���f�[�^�̃o�C�g����ݒ�
#define global TCM_ADJUSTRECT			0x1328		// �E�B���h�E�̈�ƕ\���̈�𑊌݂ɕϊ�
#define global TCM_SETITEMSIZE			0x1329		// �܂݂̑傫����ύX
#define global TCM_REMOVEIMAGE			0x132A		// �C���[�W���X�g��j��
#define global TCM_SETPADDING			0x132B		// �^�u�̃A�C�R���ƃ��x���̊ԂɊ��蓖�Ă�̈��ݒ肷��
#define global TCM_GETROWCOUNT			0x132C		// �^�u�̗񐔂��擾���� ( �����s�ɂȂ��Ă��鎞�̂� )
#define global TCM_GETTOOLTIPS			0x132D		// �c�[���`�b�v�̃n���h�����擾
#define global TCM_SETTOOLTIPS			0x132E		// �c�[���`�b�v�̃n���h����ݒ�
#define global TCM_GETCURFOCUS			0x132F		// �t�H�[�J�X�̂��� TabIndex ��Ԃ�
#define global TCM_SETCURFOCUS			0x1330		// w = TabIndex �ŁA�t�H�[�J�X���Z�b�g����
#define global TCM_SETMINTABWIDTH		0x1331		// �܂݂̍ŏ������w��
#define global TCM_DESELECTALL			0x1332		// �I�����ڂȂ��ɂ��� (TCS_BUTTONS �X�^�C���̎��̂�)
#define global TCM_HIGHLIGHTITEM		0x1333		// wParam = TabIndex �ŁA�܂݂��n�C���C�g�\������
#define global TCM_SETEXTENDEDSTYLE		0x1334		// TCS_EX_ �̊g���X�^�C����ݒ肷�� (SetWindowLong ����ʖ�)
#define global TCM_GETEXTENDEDSTYLE		0x1335		// TCS_EX_ �̊g���X�^�C�����ꊇ�擾����

#define global TCM_SETUNICODEFORMAT 	0x2005		// UNICODE�Ή��ɂ��邩�ǂ�����ݒ肷�� ( wparam �Ƀt���O )
#define global TCM_GETUNICODEFORMAT 	0x2006		// UNICODE�Ή����ǂ������擾����

// Ansi �ł̃��b�Z�[�W
#define global TCM_GETITEMA				TCM_GETITEM
#define global TCM_SETITEMA				TCM_SETITEM
#define global TCM_INSERTITEMA			TCM_INSERTITEM

// Unicode�ł̃��b�Z�[�W
#define global TCM_GETITEMW				0x133C
#define global TCM_SETITEMW				0x133D
#define global TCM_INSERTITEMW			0x133E

// TabControlStyles
#define global TCS_TABS					0x0000		// �f�t�H���g�ݒ�
#define global TCS_SCROLLOPPOSITE		0x0001		// �I������Ă��Ȃ��^�u���ڂ𔽑Α��Ɉړ�����
#define global TCS_BOTTOM				0x0002		// ���ɂ܂݂�u��
#define global TCS_RIGHT				0x0002		// �E�ɕt���� ( TCS_VERTICAL �ƂƂ��Ɏw�肵���Ƃ� )
#define global TCS_MULTISELECT			0x0004		// �����I��������( Ctrl �L�[�������Ȃ���I�� )
#define global TCS_FLATBUTTONS			0x0008		// �t���b�g�{�^��( �I�����Ă���܂݂͉��ށB����ȃo�[�ɂȂ� )
#define global TCS_FORCEICONLEFT		0x0010		// �A�C�R�������l�߂ɂ��A���͂𒆉��Ɋ񂹂�
#define global TCS_FORCELABELLEFT		0x0020		// �A�C�R���ƕ��͂����l�߂ɂ���
#define global TCS_HOTTRACK				0x0040		// �܂݂̕����񂪃z�b�g��ԂɂȂ�ƁA�F���ς��
#define global TCS_VERTICAL				0x0080		// �܂݂��c�ɂ��� (TCS_RIGHT �ƕ��p���鎞�Ɏw��)
#define global TCS_BUTTONS				0x0100		// �{�^����

#define global TCS_SINGLELINE			0x0000		// ��s�ŕ\������ ( �f�t�H���g )
#define global TCS_MULTILINE			0x0200		// �����Ȃ�ƕ����s�ŕ\������

#define global TCS_RIGHTJUSTIFY			0x0000		// ����
#define global TCS_FIXEDWIDTH			0x0400		// �܂݂̉������ψ�ɂ���
#define global TCS_RAGGEDRIGHT			0x0800		// �^�u���ڂ��E�l�ɕ\��
#define global TCS_FOCUSONBUTTONDOWN	0x1000		// �N���b�N���ꂽ��t�H�[�J�X�𓾂� (TCS_BUTTONS �̎�)
#define global TCS_OWNERDRAWFIXED		0x2000		// �I�[�i�[�`��ł���
#define global TCS_TOOLTIPS				0x4000		// �c�[���`�b�v�X���쐬����
#define global TCS_FOCUSNEVER			0x8000		// �t�H�[�J�X���΂ɓ��Ȃ�

#define global TCS_EX_FLATSEPARATORS	0x0001		// �܂݊Ԃɋ�؂��������
#define global TCS_EX_REGISTERDROP		0x0002		// �h���b�v�����Ƃ��ATCN_GETOBJECT �𑗂�

// �^�u����̒ʒm�R�[�h
#define global TCN_FIRST				(-550)		// �ʒm�R�[�h�̊J�n
#define global TCN_KEYDOWN				(-550)		// �L�[�������ꂽ
#define global TCN_SELCHANGE			(-551)		// �I����Ԃ��ς����
#define global TCN_SELCHANGING			(-552)		// �I����Ԃ��ς�낤�Ƃ��Ă��� (�܂��ς���Ă��Ȃ�)
#define global TCN_GETOBJECT			(-553)		// �h���b�v�Ώۂ̃I�u�W�F�N�g�����߂�
#define global TCN_FOCUSCHANGE			(-554)		// �t�H�[�J�X���ڂ���
#define global TCN_LAST					(-580)		// �ʒm�R�[�h�̍Ō�

// TCITEM �\���̂Ɏw��ł���萔
#define global TCIF_TEXT				0x0001		// TCITEM.mask �Ɏw�� : pszText ��L���ɂ���
#define global TCIF_IMAGE				0x0002		// TCITEM.mask �Ɏw�� : iImage  ��L���ɂ���
#define global TCIF_RTLREADING			0x0004		// TCITEM.mask �Ɏw�� : �\����������t�ɂ��� ( �ꕔ�̌���Ŏg�p )
#define global TCIF_PARAM				0x0008		// TCITEM.mask �Ɏw�� : lParam  ��L���ɂ���
#define global TCIF_STATE				0x0010		// TCITEM.mask �Ɏw�� : dwState ��L���ɂ��� ( version 4.70�ȍ~ )

#define global TCIS_BUTTONPRESSED		0x0001		// TCITEM.dwState �Ɏw�� : �I����Ԃł���
#define global TCIS_HIGHLIGHTED			0x0002		// TCITEM.dwState �Ɏw�� : �n�C���C�g����Ă���

// HITTEST �̒l
#define global TCHT_NOWHERE				0x0001		// �^�u�R���g���[���̏�
#define global TCHT_ONITEMICON			0x0002		// �܂݂̃A�C�R���̏�
#define global TCHT_ONITEMLABEL			0x0004		// �܂݂̃��x���̏�
#define global TCHT_ONITEM				0x0006		// �܂݂̏� (TCHT_ONITEMICON | TCHT_ONITEMLABEL)

#endif

//##############################################################################
//                ��`�� : MCTab
//##############################################################################

// TtoW �c�c TabIndex ����͂�����AWindowID ��Ԃ�(���Βl)
// WtoT �c�c WindowID ����͂�����ATabIndex ��Ԃ�
#module MCTab mhTab, mwidPageTop, mcntTab, mfUsing, TtoW, WtoT, midxAct, mwIdAct, mbReversed, mhFont

//------------------------------------------------
// �^���l�E���s�l
//------------------------------------------------
#define true    1
#define false   0
#define success 1
#define failure 0

//------------------------------------------------
// �}�N��
//------------------------------------------------
#define nBitOfInt 32	// int�^�̃r�b�g��

#define redim ArrayExpand

#define ctype bturn(%1) ( 0xFFFFFFFF ^ (%1) )
#define ctype BITOFF(%1,%2=0) ( bturn(%2) & (%1) )
#define FlagSw(%1=flags,%2=0,%3=true) if (%3) { %1((%2) / nBitOfInt) |= 1 << ((%2) \ nBitOfInt) } else { %1((%2) / nBitOfInt) = BitOff(%1((%2) / nBitOfInt), 1 << ((%2) \ nBitOfInt)) }// On / Off �؂�ւ��}�N��
#define ctype ff(%1=flags,%2=0) ((%1((%2) / nBitOfInt) && (1 << ((%2) \ nBitOfInt))) != 0)// �t���O������
#define SetStyle(%1,%2=-16,%3=0,%4=0) SetWindowLong %1, %2, BitOff(GetWindowLong(%1,%2) | (%3), %4)
#define ctype MAKELONG(%1,%2) ( LOWORD(%1) | LOWORD(%2) << 16 )
#define ctype LOWORD(%1) ((%1) & 0xFFFF)
#define ctype HIWORD(%1) LOWORD((%1) >> 16)

#define ctype UseTab(%1=0) ff(mfUsing,%1)
#define fUseSw(%1,%2=1) FlagSw mfUsing, %1, %2

#define Reverse_idxTab(%1) if (mbReversed) { %1 = mcntTab - (%1) }
#define ctype rvI(%1) %1;(abs( (mcntTab * (mbReversed != 0)) - (%1) ))// ���o�[�X���[�h�Ȃ甽�]����

#define ResetTCITEM memset tcitem, 0, length(tcitem) * nBitOfInt

;#define RepeatUntilTrue(%1,%2,%3=0,%4=0,%5) %1=%2:repeat %3,%4:if(%5){%1=cnt:break}loop

//------------------------------------------------
// API �֐������[�J���ŌĂяo��
//------------------------------------------------
#uselib "user32.dll"
#func   GetWindowRect@MCTab "GetWindowRect"  int,int
#func   GetClientRect@MCTab "GetClientRect"  int,int
#func   SetWindowLong@MCTab "SetWindowLongA" int,int,int
#cfunc  GetWindowLong@MCTab "GetWindowLongA" int,int
#func   SetParent@MCTab     "SetParent"      int,int
#func   MoveWindow@MCTab    "MoveWindow"     int,int,int,int,int,int

#uselib "gdi32.dll"
#cfunc  GetStockObject@MCTab		"GetStockObject"		int
#func   GetObject@MCTab				"GetObjectA"			int,int,int
#func   DeleteObject@MCTab			"DeleteObject"			int
#func   CreateFontIndirect@MCTab	"CreateFontIndirectA"	int

//------------------------------------------------
// ���W���[��������
//------------------------------------------------
#deffunc initialize@MCTab
	dim  rect, 4		// RECT �\����
	dim  tcitem, 7		// TCITEM �\����
	sdim pszText, 520	// ������o�b�t�@
	return
	
//###############################################################################
//                �����o�֐�
//###############################################################################

//**********************************************************
//        �\�z�E���
//**********************************************************
//------------------------------------------------
// �\�z
// 
// @prm int cx, cy     : Tab-Ctrl �̏����N���C�A���g�E�T�C�Y
// @prm int widPageTop : �y�[�W�Ɏg�p����E�B���h�EID�̐擪
// @prm int winStyle   : Tab-Ctrl �� Window Style
// @prm int bReversed  : ( ������ ) �܂݈ʒu�𔽓]�����邩
// @return             : Tab-Ctrl �n���h��
//------------------------------------------------
#define global tab_new(%1,%2,%3,%4=1,%5=0,%6=0) newmod %1, MCTab@, %2, %3, %4, %5, %6

#modinit int cx, int cy, int widPageTop, int winStyle, int bReversed,  local curpos
	
	curpos = ginfo_cx, ginfo_cy
	
	// Tab-Ctrl ����
	winobj WC_TABCONTROL, "", , 0x52000000 | winStyle, ginfo(20) * 2, ginfo(21) * 2
	mhTab = objinfo(stat, 2)
	
	sendmsg    mhTab, 0x0030, GetStockObject(17)	// �f�t�H���g�̃t�H���g�ɐݒ肷��
	MoveWindow mhTab, curpos(0), curpos(1), cx, cy
	
	// �����o�ϐ��̏�����
	mwidPageTop = widPageTop	// �g�p����E�B���h�E ID �̐擪
	dim  mfUsing, 3				// Window �̎g�p�󋵂�\���t���O
	dim  TtoW, 5				// winID ��Ԃ�
	dim  WtoT, 5				// index ��Ԃ�
	dim mhFont					// �t�H���g�n���h�� (ChangeTabStrFont �g�p���̂�)
 #ifdef __USE_TABINT_ON__
	dim  LPRM, 5				// �֘A int ( LPARAM �l )
 #endif
	
;	mbReversed = ( bReversed != 0 )		// ���]���[�h��
	
	return mhTab
	
//----------------------------------------------------------
// ���
//----------------------------------------------------------
#define global tab_delete delmod
#modterm
	if ( mhFont ) { DeleteObject mhFont : mhFont = 0 }	// �t�H���g�n���h�����������
	return
	
//**********************************************************
//        ���ڂ̑}���Ə���
//**********************************************************
//------------------------------------------------
// �^�u�܂݂̑}��
// 
// @prm modvar self  : MCTab
// @prm str    sItem : �^�u�܂݂̕�����
// @prm int    iTab  : �}���ʒu
// @return           : �}�����ꂽ�ʒu, or ����
//------------------------------------------------
#modfunc tab_insert str sItem, int iTab,  local iIns, local useId
	
	// �����C��
	if ( iTab < 0 ) {
		iIns = mcntTab ;* ( mbReversed == 0 )
	} else {
		iIns = rvI( limit(iTab, 0, mcntTab + 1) )
	}
	
	// �e�[�u���̏C��
	ArrayInsert TtoW, iIns		// �v�f��z��̓r���ɑ}������
	
 #ifdef __USE_TABINT_ON__
	ArrayInsert LPRM, iIns
 #endif
	
	// �A�C�e����ǉ�����
	pszText = sItem									// �^�u��������i�[
	tcitem  = 1, 0, 0, varptr(pszText)				// TCIF_TEXT  ( pszText �̂ݗL�� )
	sendmsg mhTab, 0x1307, iIns, varptr(tcitem)		// TCM_INSERTITEM ( �V�K�A�C�e����}�� )
	iIns = stat										// �}���ʒu or (x < 0)
	if ( iIns < 0 ) { return -1 }					// �G���[
	
	// �g�p���� winID ��I�яo��
	useId = mcntTab						// �f�t�H���g�ݒ�
	repeat  mcntTab
		if ( UseTab(cnt) == false ) {	// ���g�p�� PageWindow
			useId = cnt
			break
		}
	loop
	
	// �e�[�u�����C��
	WtoT( useId ) = iIns			// TabIndex
	TtoW( iIns  ) = useId			// WindowID
	fUseSw			useId, true		// �g�p���ɂ���
	
	// �T�C�Y�����߂�
	tab_getFittingPageRect thismod, rect
	
	// �E�B���h�E�쐬 ( �ꉞ�ő�T�C�Y�ō�� )
	bgscr useID + mwidPageTop, ginfo(20), ginfo(21), 2, rect(0), rect(1), rect(2) - rect(0), rect(3) - rect(1)
	SetStyle  hwnd, -16, 0x40000000, 0x80000000	// WS_CHILD ��t�����AWS_POPUP ����������
	SetParent hwnd, mhTab						// �q�E�B���h�E�ɂ���
	
	mcntTab ++				// �g�p���Ă���^�u�̐�
	
	return iIns
	
#define global tab_add(%1,%2) tab_insert %1, %2, -1

//------------------------------------------------
// �^�u�܂݂̏���
//------------------------------------------------
#modfunc tab_remove int iTab, int bNoActive
	if ( ( 0 <= iTab && iTab <= (mcntTab - 1) ) == false ) {
		return
	}
	
	sendmsg mhTab, 0x1308, iTab					// TCM_DELETETAB (�폜)
	fUseSw tab_idxToWId( thismod, iTab ), false	// �E�B���h�E�𖢎g�p�Ƃ���
	mcntTab --
	
	WtoT( tab_idxToWId(thismod, iTab) ) = -1
	ArrayRemove TtoW, iTab
	
 #ifdef __USE_TABINT_ON__
	ArrayRemove LPRM, iTab
 #endif
	
	if ( bNoActive == false ) {
		if ( midxAct >= iTab ) {
			gsel mwIdAct + mwidPageTop, -1
			midxAct = -1
			mwIdAct = 0
			
			if ( mcntTab > 0 ) {
				tab_show thismod, limit( iTab - 1, 0, mcntTab )
			}
		}
	}
	
	return
	
//**********************************************************
//        ���ڂ̑I��
//**********************************************************
//------------------------------------------------
// �I����Ԃ���ʂɂ��킹��
// 
// @return: active index
//------------------------------------------------
#modfunc tab_showActive
	
	if ( mcntTab == 0 ) {
		midxAct = -1
		mwIdAct = -1
		return midxAct
	}
	
	gsel mwIdAct + mwidPageTop, -1				// ���̃E�B���h�E���B��
	
	sendmsg mhTab, 0x130B, 0, 0					// TCM_GETCURSEL (�I������Ă���C���f�b�N�X���擾)
	midxAct = stat								// ���݂� TabIndex
	mwIdAct = tab_idxToWId( thismod, midxAct )	// midxAct �� wid
	tab_adjustPageRect      thismod, midxAct	// �T�C�Y�𒲐�
	gsel mwIdAct + mwidPageTop, 1				// ���J
	
	return midxAct
	
//------------------------------------------------
// �^�u���ڂ�I������
// 
// @result: active Window ID (relative) or ����(failure)
//------------------------------------------------
#modfunc tab_show int iTab,  local widAct_old
	if ( midxAct == iTab ) { return -1 }			// ���� active �� �Ȃɂ����Ȃ�
	if ( (0 <= iTab && iTab <= mcntTab - 1) == false ) { return -1 }	// iTab ���ُ�l
	
	widAct_old = mwIdAct
	midxAct    = limit( iTab, 0, mcntTab - 1 )	
	mwIdAct    = tab_idxToWId( thismod, midxAct )
	
;	gsel mwIdAct + mwIdPageTop, 1					// �؂�ւ���
	sendmsg mhTab, 0x130C,      midxAct,  0			// TCM_SETCURSEL (�^�u��I��)
	tab_adjustPageRect thismod, midxAct				// PageWindow �̃T�C�Y����
	
	// ���݂̃^�u���B���A�V�����I�����ڂ����J
	gsel widAct_old + mwidPageTop, -1
	gsel mwIdAct    + mwidPageTop,  1
	
	return mwIdAct
	
//**********************************************************
//        ���ڑ���
//**********************************************************
//------------------------------------------------
// �^�u�܂݂̕������ݒ肷��
//------------------------------------------------
#modfunc tab_setItemString int iTab, str string
	
	pszText = string
	tcitem  = 1, 0, 0, varptr(pszText)
	sendmsg mhTab, 0x1306, iTab, varptr(tcitem)		// TCM_SETITEM
	
	return stat
	
//------------------------------------------------
// �^�u�܂݂̕�������擾����
//------------------------------------------------
#define global ctype Tab_getItemString(%1,%2=0,%3=511) tab_getItemString_(%1,%2,%3)
#modcfunc tab_getItemString_ int iTab, int bufsize
	
	memexpand pszText, bufsize + 1					// �K�v�Ȃ����g������
	tcitem = 1, 0, 0, varptr(pszText), bufsize		// �|�C���^, �o�b�t�@�T�C�Y
	sendmsg mhTab, 0x1305, iTab, varptr(tcitem)		// TCM_GETITEM
	
	return pszText
	
//------------------------------------------------
// PageWindow �̑傫���𒲐�����
//------------------------------------------------
#modfunc tab_adjustPageRect int iTab,  local wid_actwin
	wid_actwin = ginfo(3)
	
	gsel tab_idxToWId( thismod, iTab ) + mwidPageTop	// hwnd �Ƀn���h�����i�[�����邽��
	
	Tab_getFittingPageRect thismod, rect
	MoveWindow hwnd, rect(0), rect(1), rect(2) - rect(0), rect(3) - rect(1), true
	
	gsel wid_actwin
	return
	
//------------------------------------------------
// PageWindow �̓K�؂ȑ傫�����擾����
//------------------------------------------------
#modfunc tab_getFittingPageRect array rc,  local size
	dim rc, 4
	
	size = tab_getSize(thismod)
	rc   = 0, 0, LOWORD(size), HIWORD(size)
	
	sendmsg mhTab, 0x1328, 0, varptr(rc)	// TCM_ADJUSTRECT ( TabRect �� PageRect �̑��ݕϊ� )
	return
	
//------------------------------------------------
// Tab-Ctrl �� SIZE ���擾����
// 
// @result: (int) SIZE
//------------------------------------------------
#modcfunc tab_getSize
	GetClientRect mhTab, varptr(rect)
	return MakeLong( rect(2), rect(3) )
	
//**********************************************************
//        �C���[�W���X�g�n
//**********************************************************
//------------------------------------------------
// �C���[�W���X�g���^�u�Ɋ֘A�Â���
//------------------------------------------------
#modfunc tab_setImageList int hImageList
	sendmsg mhTab, 0x1303, 0, hImageList		// TCM_SETIMAGELIST (�C���[�W���X�g������t����)
	return stat
	
//------------------------------------------------
// �C���[�W���X�g�̎擾
//------------------------------------------------
#modcfunc tab_getImageList
	sendmsg mhTab, 0x1302, 0, 0		// TCM_GETIMAGELIST (hImageList ���擾)
	return stat
	
//------------------------------------------------
// �^�u�܂݂ɃC���[�W��t����
//------------------------------------------------
#modfunc tab_setImage int iTab, int hImg
	tcitem(0) = 2, 0, 0, 0, 0, hImg				// TCIF_IMAGE
	sendmsg mhTab, 0x1306, iTab, varptr(tcitem)	// TCM_SETITEM
	return (stat != 0)
	
//------------------------------------------------
// �^�u����C���[�W����������
//------------------------------------------------
#modfunc tab_removeImage int iTab
	tab_setImage thismod, iTab, -1
	return stat
	
//**********************************************************
//        �^�u�̃t�H���g
//**********************************************************
//------------------------------------------------
// �^�u�̃t�H���g��ݒ肷��
// 
// @ �^�u�܂݂̕�����̃t�H���g�Ƃ��Ďg����B
//------------------------------------------------
#modfunc tab_font str fontFamily, int fontPt, int fontStyle

	// ���
	if ( mhFont ) { DeleteObject mhFont }
	
	// �t�H���g�쐬
	mhFont = CreateFontByHSP( fontFamily, fontPt, fontStyle )
	sendmsg mhTab, 0x0030, mhFont, true
	
	// �T�C�Y��K���ɂ���
	repeat mcntTab
		tab_adjustPageRect thismod, cnt
	loop
	
	return
	
//**********************************************************
//        ���̑��̓���
//**********************************************************
//----------------------------------------------------------
// �w����W�ɉ��Ԗڂ̂܂݂����邩
// 
// @ ���W�͐�΍��W
//----------------------------------------------------------
#modcfunc tab_getIdxFromPt int px, int py,  local tabrect, local cntTabs, local ptMouse, local idx
	
	dim tabrect, 4
	dim ptMouse, 2
	idx = -1
	
	// Tab-Ctrl �� WindowRect ���擾
	GetWindowRect mhTab, varptr(tabrect)
	
	pt = px - tabrect(0), py - tabrect(1)		// ���Βl�ɂ���
	
	repeat mcntTab
		// TCM_GETITEMRECT ( wparam �̂܂݂� RECT �� lparam(RECT ptr) �Ɋi�[ )
		sendmsg mhTab, 0x130A, cnt, varptr(rect)
		
		// �}�E�X�ʒu���܂݂̒��Ȃ�n�j
		if ( (rect(0) <= pt(0) && pt(0) <= rect(2)) && (rect(1) <= pt(1) && pt(1) <= rect(3)) ) {
			idx = cnt
			break
		}
	loop
	
	return idx
	
//----------------------------------------------------------
// �^�u�܂݂̒��̋�(padding)��ݒ肷��
// 
// @ TCM_SETPADDING
//----------------------------------------------------------
#modfunc tab_setTabPadding int cx, int cy
	sendmsg mhTab, 0x132B, , MakeLong(cx, cy)
	return
	
//----------------------------------------------------------
// �^�u�܂݂̍Œᕝ��ݒ肷��
// 
// @ TCM_SETMINTABWIDTH
//----------------------------------------------------------
#modfunc tab_setMinWidth int nMinWidth
	sendmsg mhTab, 0x1331, , nMinWidth
	return
	
//**********************************************************
//        �֘A int �n
//**********************************************************
//----------------------------------------------------------
// �֘A int �̐ݒ�
//----------------------------------------------------------
#modfunc tab_setInt int iTab, int value
 #ifdef __USE_TABINT_ON__
	LPRM( iTab ) = value
 #endif
	return
	
//----------------------------------------------------------
// �֘A int �̎擾
//----------------------------------------------------------
#modcfunc tab_getInt int iTab
 #ifdef __USE_TABINT_ON__
	return LPRM( iTab )
 #else
	return 0	// �ꉞ 0 ��Ԃ�
 #endif
	
//**********************************************************
//        �擾�n
//**********************************************************
//------------------------------------------------
// Tab-Ctrl �n���h��
//------------------------------------------------
#modcfunc tab_hwnd
	return mhTab
	
//------------------------------------------------
// ���ڐ�
//------------------------------------------------
#modcfunc tab_count
	return mcntTab
	
#define global tab_size tab_count

//------------------------------------------------
// Active-Item �� index
//------------------------------------------------
#modcfunc tab_idxAct
	return midxAct
	
//------------------------------------------------
// Active-Item �� Window ID
//------------------------------------------------
#modcfunc tab_widAct
	return mwIdAct
	
//------------------------------------------------
// Tab index <-> ���� WindowID �̑��ݕϊ�
//------------------------------------------------
#define global ItoW tab_idxToWId
#define global WtoI tab_widToIdx

#modcfunc tab_idxToWId int iTab
	if ( mcntTab == 0 ) { return 0 }
	return TtoW( limit( iTab, 0, mcntTab - 1 ) )
	
#modcfunc tab_widToIdx int widTab
	if ( mcntTab == 0 ) { return 0 }
	return WtoT( limit( widTab, 0, mcntTab - 1 ) )
	
//------------------------------------------------
// �܂݈ʒu�����]���Ă��邩�ǂ���
//------------------------------------------------
#modcfunc tab_isReversed
	return mbReversed != 0
	
//**********************************************************
//        static ������
//**********************************************************
//------------------------------------------------
// ���������p����
// 
// @ int �^�ꎟ���z����g��
//------------------------------------------------
#deffunc ArrayExpand@MCTab array arr, int size,  local temp
	if ( length(arr) >= size ) { return }	// �����Ȃ��ꍇ�͖���
	repeat size - length(arr), length(arr)
		arr(cnt) = 0
	loop
;	dim    temp, length(arr)
;	memcpy temp, arr, length(arr) * 4		// �R�s�[
;	dim    arr, size
;	memcpy arr, temp, length(temp) * 4		// �߂�
	return
	
//**********************************************************
//        Tabmod �Ƃ̌݊�
//**********************************************************
#define global CreateTab tab_new
#define global InsertTab tab_insert
#define global DeleteTab tab_remove

#define global SetTabStrItem tab_setItemString
#define global GetTabStrItem tab_getItemString

#define global AdjustWindowRect tab_adjustPageRect
#define global GetTabPageRect(%1,%2) tab_getFittingPageRect

#define global ChangeTab tab_showActive
#define global ShowTab   tab_show

#define global SetTabImageList tab_setImageList
#define global GetTabImageList tab_getImageList
#define global SetTabImage     tab_setImage

#define global ChangeTabStrFont tab_font

#define global NumberOfTabInPoint tab_getIdxFromPt

#define global SetTabPadding  tab_setPadding
#define global SetMinTabWidth tab_setMinWidth

#define global SetTabInt tab_setInt
#define global TabInt tab_getInt

#define global GetTabHandle tab_hwnd
#define global GetTabNum    tab_count

#define global ActTabIndex tab_idxAct
#define global ActTabWinID tab_widAct

#define global IsReverse tab_isReversed

#global

	initialize@MCTab

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

	#define __USE_BITMAP__

#ifdef __USE_BITMAP__
 #include "BitmapMaker.as"
#endif

#const global IDW_TABTOP 10

// �擾�p�}�N��
#define tIndex ActTabIndex(mTab)
#define actwin ActTabWinID(mTab)

#uselib "user32.dll"
#func   GetWindowRect "GetWindowRect" int,int

#ifdef __USE_BITMAP__	
	// �C���[�W���X�g�쐬(���Ȃ��Ă��ǂ�) (16�~16�~4, 24bit, �}�X�N����)
	CreateImageList 16, 16, 25, 4 : hIml = stat		// �C���[�W���X�g�̃n���h��
	buffer 2, , , 0 : picload "treeicon.bmp"		// �r�b�g�}�b�v�̓ǂݍ���
	AddImageList hIml, 0, 0, 16 * 4, 16, 0xF0CAA6	// �C���[�W���X�g�ɃC���[�W��ǉ�
#endif
	
	screen 0, 400, 300
	syscolor 15 : boxf : color
	title "Tab Sample"
	
//	�^�u�R���g���[����ݒu����B
//	p4 �� bgscr ���߂ō쐬����E�B���h�EID �̐擪�ɂȂ�܂��B
//	�Ⴆ�΁A���̂悤�� [10(IDW_TABTOP)] �Ń^�u���ڂ�4����ƁA
//	{10, 11, 12, 13} �̃E�B���h�E���g�p���܂��B
//	�܂��A[3] �Ń^�u�̍��ڂ� 8����ƁA{3, 4, 5, 6, 7, 8, 9, 10} ���g���܂��B
//	�ʂŎg�p����E�B���h�EID�l�Ɣ��Ȃ��悤���ӂ��Ă��������B
	pos 50, 50
	tab_new mTab, 300, 200, IDW_TABTOP, 0x4000	// TCS_TOOLTIPS
	hTab = stat									// Tab-Ctrl �̃n���h�����擾
	
	// �t�H���g���ύX�o���܂��B�K�{�ł͂���܂���B
	// font ���߂Ɠ������o�Ŏg�p�ł��܂��B
	tab_font mTab, "�l�r ����", 15, 4			// �����̓A�N�e�B�u�ȃ^�u�ɂ̂ݕt���l�q
	
#ifdef __USE_BITMAP__
	tab_setImageList mTab, hIml					// �C���[�W���X�g���֘A�Â���
#endif
	
	// �A�C�e���̑}�� ( ���W���[���ϐ�, �܂݂̕�����, �}���ʒu )
	// �}���ʒu���ȗ�����ƁA��Ԍ��( �ʏ�͉E )�ɒǉ����܂��B
	
	tab_add mTab, "AAA"
//		�X�N���[����ɃI�u�W�F�N�g��u�����o�ŏ����������܂��B
//		�J�����g�E�B���h�E�̓^�u�A�C�e���Ɏg�p���ꂽ�E�B���h�E�ɂȂ��Ă��܂��B
		pos 50, 50 : mes "A"
	
	tab_add mTab, "BBB"
		pos 50, 50 : mes "B"
	
	tab_add mTab, "CCC"
		pos 50, 50 : mes "C"
	
	tab_add mTab, "DDD"
		pos 50, 50 : mes "D"
	
;	tab_remove mTab, 1			// TabIndex �� 1 ("BBB") ������
	
;	tab_insert mTab, "EEE", 0	// ���[(0) �� 0 ��}��
;		pos 50, 50 : mes "E"
		
 #ifdef __USE_BITMAP__
	// �C���[�W��t����B�����ł��Ȃ��Ă������̂Ɂc�c
	repeat 4
		tab_setImage mTab, cnt, cnt
	loop
 #endif
	
	// �^�u�̍��ڒǉ����I�������A�^�u���ɓ\��t���� bgscr ���߂���\����ԂɂȂ��Ă���̂ŁA
	// �\�������悤 gsel ���߂��w�肵�Ă��������B
	// tab_new ���߂Ŏw�肵�� �E�B���h�EID �̏����l�Ɠ����l���w�肵�܂��B
	gsel IDW_TABTOP, 1
	
	// �E�B���h�EID 0 �ɕ`����߂��܂��B
	gsel
	
	// �^�u���ڐ؂�ւ��������̃��b�Z�[�W
	oncmd gosub *OnNotify, 0x004E		// WM_NOTIFY
	
	// �^�u�̑}���E�����e�X�g�p ( ����͖����Ă��ǂ� )
	gsel 0
	objsize 75, 28
	pos  5, 5 : button gosub "Insert !", *TabInsertEdit
	pos 85, 5 : button gosub "Remove !", *TabRemove
	
	screen 1, 230, 160, ( 2 | 4 | 8 )
	syscolor 15 : boxf : color
	title "InsertTab - Edit"
	sdim String   , 64, 2
	sdim InsertPos, 64
	bCheck = 1
	pos  10,  8 : mes "�܂�   : "
	pos 100,  5 : input String(0), 100, 25, 3
	pos  10, 38 : mes "���e     : "
	pos 100, 35 : input String(1), 100, 25, 12
	pos  10, 68 : mes "�}���ʒu : "
	pos 100, 65 : input InsertPos, 60, 25, 2
	
	objsize 160, 25
	pos  10, 95 : chkbox "�}����A�N�e�B�u�ɂ���", bCheck
	
	objsize 80, 28
	pos 120, 125 : button gosub "OK", *TabInsert
	
	gsel 0
	onexit goto *exit
	stop
	
// �^�u���ڐ؂�ւ���������
// �d�v�I�I
*OnNotify
	dupptr nmhdr, lparam, 12	// NMHDR �\����
	
;	logmes "nmhdr = "+ nmhdr(0) +", "+ nmhdr(1) +", "+ nmhdr(2)
	
	if ( nmhdr(0) == hTab ) {	// �^�u�R���g���[������̒ʒm 
		
		// �I���A�C�e���̕ύX
		if ( nmhdr(2) == -551 ) {
			tab_showActive mTab		// �I������Ă���A�C�e���ɐ؂�ւ���BActiveTabIndex ��Ԃ�
			
			// �ύX�̌��ʂ��o�� ( actIndex, �܂ݕ�����, windowID )
			logmes "tab_showActive �u"+ tab_getItemString(mTab, tIndex) +"�v { ( Index, WinID ) == ( "+ tIndex +", "+ tab_idxToWId(mTab, tIndex) +" ) }"
			
			gsel 0	// ���C���𑀍��ɖ߂�
			
		// �V���[�g�J�b�g���j���[
		} else : if ( nmhdr(2) == -5 ) {
			// �|�b�v�A�b�v������
			n = tab_getIdxFromPt( mTab, ginfo(0), ginfo(1) )
			if ( n >= 0 ) {
				logmes "ShortMenu Popup! [No."+ n +"]"
			}
		}
		
	}
	return
	
//	�s�v�ȕ���
*TabInsertEdit
	gsel 1, 1
	objsel 0
	return
	
// �^�u���ڂ̑}��
*TabInsert
	// �}���ʒu������ (��Ȃ� -1(�Ō�) �ɂ���)
	iIns = int(InsertPos) - (InsertPos == "")
	
	tab_insert mTab, String(0), iIns
	iIns = stat
	if ( iIns < 0 ) { return }		// ���s
	
	pos 50, 50 : mes String(1)		// �����ɏ�������
	
	// �`�F�b�N����Ă�����A�N�e�B�u�ɂ���
	if ( bCheck ) {
		tab_show mTab, iIns
	}
	
	gsel 1, -1
	gsel 0, 1
	return
	
// �^�u���ڂ̏���
*TabRemove
	tab_remove mTab, tIndex		// �A�N�e�B�u�ȃ^�u���폜����
	tab_show   mTab, tIndex		// �O�̃^�u���A�N�e�B�u�ɂ���
	gsel 0
	return stat
	
// �I�����̏��� ( �s�v )
*exit
	if ( wparam != 0 ) {
		gsel wparam, -1
		stop
	}
	end
	
#endif	// �T���v��

#endif	// ���W���[���S��
