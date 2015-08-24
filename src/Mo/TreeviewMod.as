#ifndef        __TREEVIEW_MODULE_AS__
#define global __TREEVIEW_MODULE_AS__

//######## �c���[�r���[���샂�W���[�� ##############################################################
#module Tvmod

#include "h/Treeview.as"

//################################################

/*************************************************
|*		�`�撆�E�B���h�E�Ƀc���[�r���[�쐬
|*	CreateTreeview p1, p2
|*		p1 = int	: ��
|*		p2 = int	: ����
|*		�� = stat	: �c���[�r���[�̃I�u�W�F�N�gID
.************************************************/
#deffunc CreateTreeview int sx, int sy, int p3
	winobj WC_TREEVIEW, "", 0, 0x50000000 | p3, sx, sy
	return ( stat )
	
/*************************************************
|*		�c���[�r���[�ɃC���[�W���X�g��ݒ�
|*	SetTreeImageList p1, p2
|*		p1 = HWND	: �c���[�r���[�̃n���h��
|*		p2 = HWND	: �C���[�W���X�g�̃n���h��
|*		�� = void
.************************************************/
#define global SetTreeImageList(%1,%2) sendmsg %1, 0x1109, 0, %2

/*************************************************
|*		�c���[�r���[�ɃA�C�e���ǉ�
|*	AddTreeItem p1, p2, p3, p4, p5
|*		p1 = HWND	: �c���[�r���[�̃n���h��
|*		p2 = str	: �\������e�L�X�g
|*		p3 = int	: �C���[�W�̃C���f�b�N�X ( iImage )
|*		p4 = HWND	: �e�A�C�e���̃n���h��
|*						TVI_ROOT	: ���[�g�v�f�̎�
|*		p5 = int	: �}���ʒu�̃A�C�e���n���h���܂��͈ȉ��̒l
|*						TVI_FIRST	: ���X�g�̍ŏ��̈ʒu
|*						TVI_LAST	: ���X�g�̍Ō�̈ʒu
|*						TVI_SORT	: ���X�g���A���t�@�x�b�g���Ƀ\�[�g
|*		p6 = int	: �A�C�e���̏������
|*		�� = int	: �A�C�e���n���h��
.************************************************/
#deffunc AddTreeItem int p1, str p2, int p3, int p4, int p5, int p6, local pszText
	pszText = p2					// ��������ϐ��Ɉڂ��Ă���
	
	// TVINSERTSTRUCT �\����
	dim tvins, 12
		tvins(0) = p4				// �e�A�C�e���̃n���h��
		tvins(1) = p5				// �}���ʒu�̃A�C�e���n���h��
		tvins(2) = 0x002F			// TVIF_TEXT | TVIF_IMAGE | TVIF_STATE | TVIF_SELECTEDIMAGE
		tvins(4) = p6, p6			// �A�C�e���̏��
		tvins(6) = varptr(pszText)	// ������̃A�h���X
		tvins(8) = p3				// �C���[�W�C���f�b�N�X(��I����)
		tvins(9) = p3				// �C���[�W�C���f�b�N�X(�I����)
	
	sendmsg p1, 0x1100, 0, varptr(tvins)	// TVM_INSERTITEM
	return ( stat )
	
/*************************************************
|*		�w�肳�ꂽ�c���[�A�C�e�����擾
|*	GetTargetTreeItem( p1, p2, p3=0 )
|*		p1 = HWND	: �c���[�r���[�̃n���h��
|*		p2 = int	: �A�C�e���Ƃ̊֌W
|*		p3 = HWND	: �c���[�A�C�e���̃n���h��( �g��Ȃ��Ƃ������� )
|*		�� = int	: �I������Ă���A�C�e���̃n���h�����Ԃ�
.************************************************/
#define global ctype GetTreeItemTarget(%1,%2,%3=0) _GetTreeItemTarget(%1,%2,%3)
#defcfunc _GetTreeItemTarget int p1, int p2, int p3
	sendmsg p1, 0x110A, p2, p3		// TVM_GETNEXTITEM
	return ( stat )
	
#define global ctype GetTreeItemRoot(%1)     GetTreeItemTarget(%1, TVGN_ROOT)
#define global ctype GetTreeItemNext(%1,%2)  GetTreeItemTarget(%1, TVGN_NEXT,  %2)
#define global ctype GetTreeItemPrev(%1,%2)  GetTreeItemTarget(%1, TVGN_PREV,  %2)
#define global ctype GetTreeItemParent(%1,%2)GetTreeItemTarget(%1, TVGN_PARENT,%2)
#define global ctype GetTreeItemChild(%1,%2) GetTreeItemTarget(%1, TVGN_CHILD, %2)
#define global ctype GetTreeItemSelected(%1) GetTreeItemTarget(%1, TVGN_CARET)

/*************************************************
|*		�A�C�e���̕�������擾����
|*	GetTreeItemString( p1, p2, p3=256 )
|*		p1 = HWND	: �c���[�r���[�̃n���h��
|*		p2 = HWND	: �c���[�A�C�e���̃n���h��
|*		p3 = int	: ������̌��E
|*		�� = str	: �A�C�e���̕�����
.************************************************/
#define global ctype GetTreeItemString(%1,%2,%3=256) _GetTreeItemString(%1,%2,%3)
#defcfunc _GetTreeItemString int p1, int p2, int p3, local pszText
	sdim pszText, p3 + 1
	
	// TVITEM �\����
	dim tvitem, 10
		tvitem(0) = 1, p2					// TVIF_TEXT
		tvitem(4) = varptr(pszText), p3		// ������̃A�h���X�ƁA�ő啶����
	sendmsg p1, 0x110C, 0, varptr(tvitem)
	return pszText
	
/*************************************************
|*		�c���[�r���[�A�C�e�����폜
|*	DeleteTreeItem  p1
|*		p1 = HWND	: �c���[�r���[�̃n���h��
|*		p2 = HWND	: �A�C�e���n���h��
|*		�� = void
.************************************************/
#define global DeleteTreeItem(%1,%2) sendmsg %1, 0x1101, 0, %2	// TVM_DELETEITEM

#global

//######## �T���v���E�X�N���v�g ####################################################################
#if 0

#include "Mo/BitmapMaker.as"

	// �C���[�W���X�g�쐬 (16�~16�~4, 24bit, �}�X�N����)
	CreateImageList 16, 16, 25, 4
	hIml = stat					// �C���[�W���X�g�̃n���h��
	
	// �C���[�W���X�g�쐬�p�o�b�t�@�E�B���h�E
	buffer 2, , , 0
	picload "treeicon.bmp"		// �r�b�g�}�b�v�̓ǂݍ���
	
	// �C���[�W���X�g�ɃC���[�W��ǉ�
	AddImageList hIml, 0, 0, 16 * 4, 16, 0x00F0CAA6
	
	// �c���[�r���[�쐬
	gsel 0
	pos 0, 0 : CreateTreeview ginfo(12) / 2, ginfo(13), 0x800000 | TVS_HASBUTTON | TVS_HASLINES | TVS_LINESATROOT
	hTree = objinfo(stat, 2)		// �c���[�r���[�̃n���h��
	
	// �c���[�r���[�̃C���[�W���X�g��ݒ�
	SetTreeImageList hTree, hIml
	
	dim hRoot , 2
	dim hChild, 2
	
	// �c���[�r���[�̃A�C�e���ǉ�
	AddTreeItem         hTree, "�e�A�C�e���P", 0,  TVI_ROOT, TVI_SORT : hRoot(0)  = stat
		AddTreeItem     hTree, "�q�A�C�e���P", 1,  hRoot(0), TVI_SORT : hChild(0) = stat
			AddTreeItem hTree, "���A�C�e���P", 2, hChild(0), TVI_SORT
		AddTreeItem     hTree, "�q�A�C�e���Q", 1,  hRoot(0), TVI_SORT : hChild(1) = stat
			AddTreeItem hTree, "���A�C�e���Q", 2, hChild(1), TVI_SORT
	
	gsel 0
	oncmd gosub *OnNotify, 0x004E
	stop
	
*OnNotify
	dupptr nmhdr, lparam, 12			// NMHDR�\����
	
;	logmes "nmhdr = "+ nmhdr(0) +", "+ nmhdr(1) +", "+ nmhdr(2)
	
	if ( nmhdr(0) == hTree ) {
		if ( nmhdr(2) == TVN_SELCHANGED ) {
			dialog GetTreeItemString( hTree, GetTreeItemSelected( hTree ) )
		}
	}
	return
	
#endif

#endif
