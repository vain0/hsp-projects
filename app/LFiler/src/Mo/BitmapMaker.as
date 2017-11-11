// �r�b�g�}�b�v��
// �C���[�W���X�g�쐬
// ���W���[��
#ifndef __BITMAP_AND_IMAGELIST_MAKE_MODULE__
#define __BITMAP_AND_IMAGELIST_MAKE_MODULE__

#module BMPmod

#uselib "gdi32.dll"
#cfunc  CreateDC               "CreateDCA"              sptr,nullptr,nullptr,nullptr
#cfunc  CreateCompatibleBitmap "CreateCompatibleBitmap" int,int,int
#cfunc  CreateCompatibleDC     "CreateCompatibleDC"     int
#func   SelectObject           "SelectObject"           int,int
#func   BitBlt                 "BitBlt"                 int,int,int,int,int,int,int,int,int
#func   DeleteDC               "DeleteDC"               int
#func   DeleteObject           "DeleteObject"           int
#cfunc  GetStockObject         "GetStockObject"         int

#uselib "comctl32.dll"
#func   ImageList_Create    "ImageList_Create"    int,int,int,int,int
#func   ImageList_AddMasked "ImageList_AddMasked" int,int,int
#func   ImageList_Draw      "ImageList_Draw"      int,int,int,int,int,int
#func   ImageList_Destroy   "ImageList_Destroy"   int

//######## init ���� #############################
#deffunc BMPOBJ_MOD_init
	dim hBitmap , 2
	dim hImgList, 2
	dim count   , 2		// (0) = bmp, (1) = img
	return
	
// ���������p���� ( int�^�ꎟ���z����g�� )
#define _RedimInt _______RedimInt
#deffunc _______RedimInt array p1, int p2, local temp
	if ( length(p1) >= p2 ) { return }	// �����Ȃ��ꍇ�͖���
	dim    temp, length(p1)
	memcpy temp, p1, length(p1) * 4		// �R�s�[
	dim    p1, p2
	memcpy p1, temp, length(temp) * 4	// �߂�
	return
	
//######## �r�b�g�}�b�v �I�u�W�F�N�g�� #########################################
/*************************************************
|*		�`�撆�E�B���h�E�̃C���[�W����
|*		�r�b�g�}�b�v�I�u�W�F�N�g(DIB)�쐬
|*
|*	ret = CreateDIB (p1, p2, p3, p4)
|*		p1 = int	: HSP�E�B���h�Ex���W
|*		p2 = int	: HSP�E�B���h�Ey���W
|*		p3 = int	: ��
|*		p4 = int	: ����
|*		�� = stat	: �r�b�g�}�b�v�̃n���h��
.************************************************/
#defcfunc CreateDIB int x, int y, int w, int h
	_RedimInt hBitmap, count	// �g��
	
	hDisplayDC     = CreateDC              ("DISPLAY")			// 
	hBitMap(count) = CreateCompatibleBitmap(hDisplayDC, w, h)	// 
	hCcDc          = CreateCompatibleDC    (hDisplayDC)			// 
	SelectObject hCcDc, hBitmap( count )						// 
	BitBlt       hCcDc, 0, 0, w, h, hdc, x, y, 0x00CC0020		// ��ʂ���R�s�[ (SRCCOPY)
	DeleteDC     hDisplayDC										// Display �� hDC ���
	DeleteDC     hCcDc											// ���
	count ++
	return hBitmap( count - 1 )
	
// ����p���� ( �Ăяo���K�v�͂���܂��� )
#deffunc DeleteBmpObj int p1
	repeat count
		if ( hBitmap( cnt ) == p1 ) {		// ���W���[�����ō�������̂��T��
			 hBitmap( cnt ) = 0				// �����Ă���
		}
	loop
	DeleteObject p1	// �폜
	return (stat)
	
//######## �C���[�W���X�g�� ####################################################
/*************************************************
|*		�C���[�W���X�g�̍쐬
|*	CreateImageList	p1, p2, p3, p4
|*		p1 = int	: �C���[�W�̕�
|*		p2 = int	: �C���[�W�̍���
|*		p3 = int	: �C���[�W���X�g�̃^�C�v
|*		p4 = int	: �C���[�W�̐�
|*		�� = stat	: �C���[�W���X�g�̃n���h�����Ԃ�
.************************************************/
#define global CreateImageList(%1,%2,%3,%4,%5=0) _CreateImageList %1,%2,%3,%4,%5
#deffunc _CreateImageList int p1, int p2, int p3, int p4, int p5
	_RedimInt   hImgList, count(1)		// �g��
	
	ImageList_Create p1, p2, p3, p4, p5	// �쐬
	hImgList( count(1) ) = stat
	count(1) ++
	return
	
/*************************************************
|*		�C���[�W���X�g�ɕ`�撆�E�B���h�E�̃C���[�W�ǉ�
|*	AddImageList p1, p2, p3, p4, p5
|*		p1 = HWND		: �C���[�W���X�g�̃n���h��
|*		p2 = int		: HSP�E�B���h�Ex���W
|*		p3 = int		: HSP�E�B���h�Ey���W
|*		p4 = int		: ��
|*		p5 = int		: ����
|*		p6 = COLORREF	: �}�X�N�ɗp����F
|*		�� = stat		: �C���[�W�̃C���f�b�N�X���Ԃ�
.************************************************/
#deffunc AddImageList int hIml, int cx, int cy, int sx, int sy, int crmask, local index, local hBmp

	// DIB�I�u�W�F�N�g�̍쐬
	hBmp = CreateDIB( cx, cy, sx, sy )		// �r�b�g�}�b�v�n���h��
	
	// �r�b�g�}�b�v���C���[�W���X�g�ɒǉ�
	ImageList_AddMasked hIml, hBmp, crmask
	index = stat				// �ŏ��̃C���[�W�̃C���f�b�N�X
	
	// �r�b�g�}�b�v�I�u�W�F�N�g���폜
	DeleteBmpObj hBmp
	
	return index		// �C���[�W�̃C���f�b�N�X��Ԃ�
	
/*************************************************
|*		�C���[�W���X�g�̔j��
|*	DestroyImageList p1
|*		p1 = HWND	: �C���[�W���X�g�̃n���h��
|*		�� = void
.************************************************/
#deffunc DestroyImageList int p1
	if ( p1 ) {
		ImageList_Destroy p1
	}
	repeat count(1)
		// �ĉ�����Ȃ��悤�ɁANULL �ɂ��Ă���
		if ( hImgList(cnt) == p1 ) {
			 hImgList(cnt) = 0
		}
	loop
	return
	
//######## �f�X�g���N�^ ########################################################
#deffunc ONEXIT_ON_BMPMOD onexit
	// �r�b�g�}�b�v�E�I�u�W�F�N�g�����
	repeat count(0)
		if ( hBitmap(cnt)  ) { DeleteObject hBitmap(cnt) }
	loop
	
	// �C���[�W���X�g�����
	repeat count(1)
		if ( hImgList(cnt) ) { ImageList_Destroy hImgList(cnt) }
	loop
	
	return 0
	
#global
BMPOBJ_MOD_init
#endif
