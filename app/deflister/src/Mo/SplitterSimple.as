// �ƂĂ��V���v���ȃX�v���b�^

// ����
// @ 1�̃E�B���h�E�ɂ̂ݎg�p�ł���
// @ ��}���`�v���C���X�^���X
//

#ifndef IG_SPLITTER_SIMPLE_AS
#define IG_SPLITTER_SIMPLE_AS

#module SplitterSimple

#uselib "user32.dll"
#func   SetWindowLong "SetWindowLongA" int,int,int
#cfunc  GetWindowLong "GetWindowLongA" int,int
#func   MoveWindow    "MoveWindow"     int,int,int,int,int,int
#func   PostMessage   "PostMessageA"   int,int,int,sptr

#cfunc  LoadCursor     "LoadCursorA"    nullptr,int
#func   SetClassLong   "SetClassLongA"  int,int,int
#func   SetCursor      "SetCursor"      int
#func   ClipCursor     "ClipCursor"     int

#define UWM_SPLITTERMOVE 0x0400

#define ctype boxin(%1=0,%2=0,%3=640,%4=480,%5=mousex,%6=mousey) ( (((%1) <= (%5)) && ((%5) <= (%3))) && (((%2) <= (%6)) && ((%6) <= (%4))) )
#define mousex2 ( ginfo_mx - (ginfo_wx1 + (ginfo_sizex - ginfo_winx) / 2) )
#define mousey2 ( ginfo_my - (ginfo_wy1 + (ginfo_sizey - ginfo_winy) - (ginfo_sizex - ginfo_winx) / 2) )

#if _DEBUG
// @static
	dim bDragging
	dim bLBtnDown
	ldim lbSplitterWhetherDragging, 1
	ldim lbSplitterMoveHandler, 1
	dim refStat
#endif

//------------------------------------------------
// ������
//------------------------------------------------
#deffunc SplitterSimple_Init
	oncmd gosub *OnSplitterMove, UWM_SPLITTERMOVE
	return
	
#deffunc SplitterSimple_Term
	if ( bDragging ) {
		ClipCursor NULL		// �}�E�X�̈ړ��͈͂��������
		bDragging = false
	}
	return
	
//------------------------------------------------
// �X�v���b�^�[�̈ʒu��ݒ�
//------------------------------------------------
#define global SplitterSimple_SetWhetherDraggingJudge(%1) \
	lbSplitterWhetherDragging@SplitterSimple = (%1)
	
//------------------------------------------------
// �n���h���̐ݒ�
//------------------------------------------------
#define global SplitterSimple_SetMoveHander(%1) \
	lbSplitterMoveHandler@SplitterSimple = (%1)

//------------------------------------------------
// ����̃E�B���h�E�R�}���h���`
//------------------------------------------------
#deffunc SplitterSimple_SetDefaultWindowCommand
	oncmd gosub *OnMouseMove, 0x0200		// WM_MOUSEMOVE (�}�E�X��������)
	oncmd gosub *OnLBtnDown,  0x0201		// WM_LBUTTONDOWN
	return
	
//------------------------------------------------
// �}�E�X�����z�X�v���b�^�[��𓮂����Ƃ�
//------------------------------------------------
#deffunc SplitterSimple_OnMouseMove
	gosub lbSplitterWhetherDragging
	if ( stat ) {
		SetCursor LoadCursor(IDC_SIZENS)	// �㉺
	}
	return
	
*OnMouseMove
	SplitterSimple_OnMouseMove
	return
	
//------------------------------------------------
// �h���b�O�J�n
//------------------------------------------------
#deffunc SplitterSimple_OnLBtnDown
	gosub lbSplitterWhetherDragging
	if ( stat ) {
		// �J�n���̈ʒu���L������
		bDragging   = true					// �h���b�O�J�n�t���b�O
		ptDragStart = ginfo_mx, ginfo_my	// �ʒu���L������
		
		// �}�E�X�̈ړ��͈͂𐧌�����
		rc(0) = ginfo_wx1 + 10
		rc(1) = ginfo_wy1 + (10 + 40)
		rc(2) = ginfo_wx2 - 10
		rc(3) = ginfo_wy2 - (10 + 20)
		ClipCursor varptr(rc)
		
		// �{�^�����������܂Ń��[�v
		repeat
			getkey bLBtnDown, GETKEY_LBTN
			if ( bLBtnDown == false ) { break }
			await
			
			// �X�v���b�^�[�ʒu���X�V����
			SetCursor LoadCursor(IDC_SIZENS)
			
			ptDragEnd   = ginfo_mx, ginfo_my			// �ЂƂ܂����̈ʒu�܂œ�����
			sendmsg hwnd, UWM_SPLITTERMOVE
			ptDragStart = ptDragEnd(0), ptDragEnd(1)	// �h���b�O�ĊJ
		loop
		
		// �h���b�v���ꂽ
		if ( bDragging ) {
			ClipCursor NULL							// �ړ����������
			bDragging = false						// �I��
			ptDragEnd = ginfo_mx, ginfo_my			// �ʒu���L������
			
			sendmsg hwnd, UWM_SPLITTERMOVE, 0, 0	// �I����ʒm����
		}
	}
	return
	
*OnLBtnDown
	SplitterSimple_OnLBtnDown
	return
	
//------------------------------------------------
// �X�v���b�^�[���������Ƃ�
//------------------------------------------------
*OnSplitterMove
	mref refStat, 64
	refStat = ptDragEnd(1) - ptDragStart(1)		// stat �ɃX�v���b�^�[�̕ψʂ���
	
	// ���[�U��`�n���h�����Ăяo��
	gosub lbSplitterMoveHandler
	return
	
#global

#endif
