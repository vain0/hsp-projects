// font ���߂ł̐ݒ���擾����
// �R���g���[���̃t�H���g���ȒP�ɐݒ肷��

#ifndef __GETFONT_OF_HSP_AS__
#define __GETFONT_OF_HSP_AS__

#module gfoh_mod

#uselib "gdi32.dll"
#func   CreateFontIndirect@gfoh_mod "CreateFontIndirectA" int
#func   GetObject@gfoh_mod    "GetObjectA"   int,int,int
#func   DeleteObject@gfoh_mod "DeleteObject" int

//------------------------------------------------
// HSP �� LOGFONT �\���̂��擾����
//------------------------------------------------
#deffunc GetStructLogfont array _logfont
	dim    _logfont, 15
	mref      bmscr, 67
	GetObject bmscr(38), 60, varptr(_logfont)	// LOGFONT �\���̂��擾����
	
;	foreach logfont
;		logmes strf("logfont(%2d)", cnt) +" = "+ logfont(cnt)
;	loop
	
	dim bmscr	// �ꉞ�ʏ�̕ϐ��ɖ߂��Ă���
	return
	
//------------------------------------------------
// ���݂̃t�H���g���擾
//------------------------------------------------
#defcfunc GetFontName local sRet
	sdim   sRet, 64
	GetStructLogfont logfont 
	getstr sRet,     logfont(7)
	return sRet
	
//------------------------------------------------
// ���݂̃t�H���g�T�C�Y�擾
//------------------------------------------------
#defcfunc GetFontSize int bStillGotLogfont
	if ( bStillGotLogfont == 0 ) {
		GetStructLogfont logfont			// LOGFONT�\����
	}
	return ( logfont(0) ^ 0xFFFFFFFF ) + 1
	
//------------------------------------------------
// ���݂̃t�H���g�X�^�C���擾
//------------------------------------------------
#defcfunc GetFontStyle int bStillGotLogfont
	if ( bStillGotLogfont == 0 ) {
		GetStructLogfont logfont			// LOGFONT�\����
	}
/*
	style |= (  logfont(4) >= 700             ) << 0	// Bold
	style |= ( (logfont(5) & 0x000000FF) != 0 ) << 1	// Italic
	style |= ( (logfont(5) & 0x0000FF00) != 0 ) << 2	// UnderLine
	style |= ( (logfont(5) & 0x00FF0000) != 0 ) << 3	// StrikeLine
	style |= ( (logfont(6) & 0x00040000) != 0 ) << 4	// AntiAlias
	return style
/*///
// Compact version ��
	return ((logfont(4) >= 700)) | (((logfont(5) & 0x000000FF) != 0) << 1) | (((logfont(5) & 0x0000FF00) != 0) << 2) | (((logfont(5) & 0x00FF0000) != 0) << 3) | (((logfont(6) & 0x00040000) != 0) << 4)
//*/

//------------------------------------------------
// �t�H���g�I�u�W�F�N�g���쐬����
// 
// @return int
//  �t�H���g�n���h�� (int)
//  ���Ō�Ɂu�K���v DeleteFont �ŉ�����Ă��������I�I
// @ HSP �̃E�B���h�E�𗘗p���Ă���
//------------------------------------------------
#defcfunc CreateFontByHSP str p1, int p2, int p3, local sFontName, local nFontData
	sdim sFontName, 64		// name
	dim  nFontData, 2		// size, style
	
	// ���̃t�H���g�f�[�^���L��
	sFontName = GetFontName()				// �ϐ� logfont �ɒl���i�[�����
	nFontData = GetFontSize(1), GetFontStyle(1)
	
	// logfont �\���̂��쐬
	font p1, p2, p3
	GetStructLogfont          logfont		// �t�H���g��� (LOGFONT) ���擾
	CreateFontIndirect varptr(logfont)		// �V�����t�H���g�I�u�W�F�N�g���쐬
	hFont = stat							// HSP�E�B���h�E���������t�H���g�n���h��
	
	// ���ɖ߂�
	font sFontName, nFontData(0), nFontData(1)
	
	return hFont
	
//------------------------------------------------
// �R���g���[���̃t�H���g��ݒ�
// 
// @ WM_SETFONT �𑗂� ( hFont, bRefresh )
//------------------------------------------------
#define global ChangeControlFont(%1,%2="",%3,%4=0,%5=1) _ChangeControlFont %1,%2,%3,%4,%5
#deffunc ChangeControlFont int p1, str p2, int p3, int p4, int bRefresh
	hFont = CreateFontByHSP(p2, p3, p4)
	sendmsg p1, 0x0030, hFont, bRefresh
	return hFont
	
//------------------------------------------------
// �s�v�ȃt�H���g�n���h���̉��
//------------------------------------------------
#deffunc DeleteFont int p1
	if ( p1 ) { DeleteObject p1 }
	return
	
#global

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
//------------------------------------------------
// �T���v�� 1
//------------------------------------------------
#if 0
	// StaticText Control ���쐬
	winobj "static", " \n�\������e�L�X�g ", 0, 0x50000000, ginfo(12), ginfo(13)
	hStatic = objinfo(stat, 2)		// �n���h��
	
	ChangeControlFont hStatic, "�l�r ����", 58, 1 | 2	// �����E�Α�
	hFont = stat										// �t�H���g�n���h�����Ԃ�
	
	onexit goto *exit	// �I���Ɋ��荞��
	stop
	
*exit
	DeleteFont hFont	// �Ō�ɉ��
	end
	
#endif

//------------------------------------------------
// �T���v�� 2
//------------------------------------------------
#if 0

#define WAITTIME 120

	// A �� B �̃t�H���g����ւ�
	screen 0, 320, 240,,  20, 60 : title "Window A" : mes "Window A �ł�"
	screen 1, 320, 240,, 350, 60 : title "Window B" : mes "Window B �ł�"
	
	wait WAITTIME
	
	sdim sFontName, 64, 2
	dim  nFontSize,  2
	dim  nFontStyle, 2
	
	gsel 0, 1
	mes  "sysfont 0"
	font "�l�r �S�V�b�N", 24, 2 | 4 | 16
	mes " �l�r �S�V�b�N , 24, 2 | 4 | 16"
	
	wait WAITTIME
	
	// �S�V�b�N�̃f�[�^
	sFontName (0) = GetFontName()
	nFontSize (0) = GetFontSize()
	nFontStyle(0) = GetFontStyle()
	
	font "�l�r ����", 16
	mes  "�l�r ����, 16 �ɕύX"
	
	wait WAITTIME
	
	// �����̃f�[�^
	sFontName (1) = GetFontName()
	nFontSize (1) = GetFontSize()
	nFontStyle(1) = GetFontStyle()
	
	gsel 1, 1
	font sFontName(1), nFontSize(1), nFontStyle(1)
	mes "�����̂ɂ��܂���"
	
	wait WAITTIME
	
	gsel 0, 1
	font sFontName(0), nFontSize(0), nFontStyle(0)
	mes "�l�r �S�V�b�N�ɖ߂��܂���"
	stop
	
#endif

#endif
