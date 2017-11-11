// �c���[�r���[�Ǘ����W���[��

#ifndef IG_MODULECLASS_TREEVIEW_AS
#define IG_MODULECLASS_TREEVIEW_AS

#include "Treeview.as"

#module tvmod minfTv

#define true  1
#define false 0
#define mv modvar tvmod@

//------------------------------------------------
// ���W���[��������
//------------------------------------------------
#deffunc _init@tvmod
	dim tvitem, 10		// TVITEM �\����
	dim  tvins, 12		// TVINSERTSTRUCT �\����
	sdim pszText, 512
	return
	
//##############################################################################
//        �����o���߁E�֐��Q
//##############################################################################
//------------------------------------------------
// �ǉ�
//------------------------------------------------
#define global Tv_Insert(%1,%2="",%3=TVI_ROOT,%4=TVI_SORT,%5=0,%6=0) _Tv_Insert %1,%2,%3,%4,%5,%6
#modfunc _Tv_Insert str p2, int hTvParent, int hTvItem, int status, int iImg
	pszText  = p2				// ��������ϐ��Ɉڂ��Ă���
	
	tvins(0) = hTvParent		// �e�A�C�e���̃n���h��
	tvins(1) = hTvItem			// �}���ʒu�̃A�C�e���n���h��
	tvins(2) = 0x002F			// TVIF_TEXT | TVIF_IMAGE | TVIF_STATE | TVIF_SELECTEDIMAGE
	tvins(4) = status, status	// �A�C�e���̏��
	tvins(6) = varptr(pszText)	// ������̃A�h���X
	tvins(8) = iImg				// �C���[�W�C���f�b�N�X(��I����)
	tvins(9) = iImg				// �C���[�W�C���f�b�N�X(�I����)
	
	sendmsg minfTv, 0x1100, 0, varptr(tvins)	// TVM_INSERTITEM
	return stat
	
//------------------------------------------------
// �폜
//------------------------------------------------
#modfunc Tv_Delete int hTvItem
	sendmsg minfTv, 0x1101, 0, hTvItem
	return
	
#define global Tv_DeleteAll(%1) Tv_Delete %1, TVI_ROOT

//##########################################################
//        �n���h���擾�n
//##########################################################
//------------------------------------------------
// �擾
// 
// TVGN_*, hTvItem(p2�Ɉˑ�)
//------------------------------------------------
#define global ctype Tv_GetTarget(%1,%2,%3=0) _Tv_GetTarget(%1,%2,%3)
#defcfunc _Tv_GetTarget mv, int p2, int hTvItem
	sendmsg minfTv, 0x110A, p2, hTvItem	// TVM_GETNEXTITEM
	return stat
	
#define global ctype Tv_GetRoot(%1)     Tv_GetTarget(%1, TVGN_ROOT)//      ���[�g
#define global ctype Tv_GetNext(%1,%2)  Tv_GetTarget(%1, TVGN_NEXT,  %2)// ��
#define global ctype Tv_GetPrev(%1,%2)  Tv_GetTarget(%1, TVGN_PREV,  %2)// �Z
#define global ctype Tv_GetParent(%1,%2)Tv_GetTarget(%1, TVGN_PARENT,%2)// �e
#define global ctype Tv_GetChild(%1,%2) Tv_GetTarget(%1, TVGN_CHILD, %2)// ���q
#define global ctype Tv_GetSelected(%1) Tv_GetTarget(%1, TVGN_CARET)//     �I�����
#define global ctype Tv_GetDropped(%1)  Tv_GetTarget(%1, TVGN_DROPHILIGHT)// �h���b�v�Ώ�

//##########################################################
//        ���ڕ����񑀍�n
//##########################################################
//------------------------------------------------
// �擾
//------------------------------------------------
#define global ctype Tv_GetString(%1,%2,%3=511) _Tv_GetString(%1,%2,%3)
#defcfunc _Tv_GetString mv, int hTvItem, int p3
	if ( p3 > 511 ) { memexpand pszText, p3 + 1 }
	
	tvitem(0) = 1, hTvItem				// TVIF_TEXT
	tvitem(4) = varptr(pszText), p3		// ������̃A�h���X�ƁA�ő啶����
	
	sendmsg minfTv, 0x110C, 0, varptr(tvitem)	// TVM_GETITEM
	return pszText
	
//------------------------------------------------
// �ݒ�
//------------------------------------------------
#modfunc Tv_SetString int hTvItem, str p3
	pszText   = p3
	tvitem(0) = 1, hTvItem
	tvitem(4) = varptr(pszText)
	
	sendmsg minfTv, 0x110D, 0, varptr(tvitem)	// TVM_SETITEM
	return
	
//##########################################################
//        �C���[�W���X�g�֌W
//##########################################################

//------------------------------------------------
// �c���[�r���[�ɃC���[�W���X�g���֘A�Â���
//------------------------------------------------
#modfunc Tv_SetImglist int hImglist
	sendmsg minfTv, 0x1109, 0, hImglist		// TVM_SETIMAGELIST
	return
	
	
//##########################################################
//        �ėp�����o�֐��Q
//##########################################################
//------------------------------------------------
// ���ڂ̊J��
//------------------------------------------------
#modfunc Tv_Expand int hTvItem, int flag
	sendmsg minfTv, 0x1102, flag, hTvItem
	return
	
//------------------------------------------------
// ���ڐ�
//------------------------------------------------
#defcfunc Tv_GetCount mv
	sendmsg minfTv, 0x1105, 0, 0		// TVM_GETCOUNT
	return stat
	
//------------------------------------------------
// ���ڂ�RECT
//------------------------------------------------
#modfunc Tv_GetRect mv, int hTvItem, array _rect
	dim _rect, 4
		_rect(0) = hTvItem
	
	sendmsg minfTv, 0x1104, false, varptr(_rect)	// TVM_GETITEMRECT
	if ( stat == false ) {		// ���s����
		memset _rect, 0, 16		// 0 �Ŗ��߂�
		return false
	}
	return true
	
//##############################################################################
//        �R���X�g���N�^�E�f�X�g���N�^
//##############################################################################
#define global CreateTreeview(%1,%2,%3,%4=0) newmod %1,tvmod,%2,%3,%4
#modinit int cx, int cy, int p4
	dim minfTv, 2
	
	winobj "SysTreeView32", "", 0, 0x50000000 | p4, cx, cy
	minfTv = objinfo(stat, 2), stat
	
	return minfTv(1)
	
#global
_init@tvmod

//##############################################################################
//        �T���v���E�X�N���v�g
//##############################################################################
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
	CreateTreeview mTv, ginfo(12) / 2, ginfo(13), 0x800000 | TVS_HASBUTTON | TVS_HASLINES | TVS_LINESATROOT
	hTree = objinfo(stat, 2)		// �c���[�r���[�̃n���h��
	
	// �c���[�r���[�̃C���[�W���X�g��ݒ�
	Tv_SetImglist mTv, hIml
	
	dim hRoot , 2
	dim hChild, 2
	
	// �c���[�r���[�̃A�C�e���ǉ�
	Tv_Insert         mTv, "�e�A�C�e���P",   TVI_ROOT, TVI_SORT,, 0 : hRoot     = stat
		Tv_Insert     mTv, "�q�A�C�e���P",      hRoot, TVI_SORT,, 1 : hChild(0) = stat
			Tv_Insert mTv, "���A�C�e���P",  hChild(0), TVI_SORT,, 2
		Tv_Insert     mTv, "�q�A�C�e���Q",      hRoot, TVI_SORT,, 1 : hChild(1) = stat
			Tv_Insert mTv, "���A�C�e���Q",  hChild(1), TVI_SORT,, 2
	
	gsel 0
	oncmd gosub *OnNotify, 0x004E
	
	pos ginfo(12) / 2 + 5, 0
	stop
	
*OnNotify
	dupptr nmhdr, lparam, 12			// NMHDR�\����
	
	if ( nmhdr(0) == hTree ) {
		
		if ( nmhdr(2) == TVN_SELCHANGED ) {
			mes Tv_GetString( mTv, Tv_GetSelected( mTv ) )
		}
		
	}
	return
	
#endif

#endif
