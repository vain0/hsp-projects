// �T���v���p�w�b�_�t�@�C��

// �T���v���ɂ����g��Ȃ�

#ifndef __SAMPLE_AS__
#define __SAMPLW_AS__

// �}�N��
#ifndef __UserDefHeader__
 #define ctype HIWORD(%1) (((%1) >> 16) & 0xFFFF)
 #define ctype LOWORD(%1) ((%1) & 0xFFFF)
 #define ctype RGB(%1=0,%2=0,%3=0) (((%1) & 0xFF) | (((%2) & 0xFF) << 8) | (((%3) & 0xFF) << 16))
 #define global NULL  0
 #define global true  1
 #define global false 0
#endif

// ��`
#define wID_Main 1
#define wID_Buffer 2

// API �Ăяo��
#uselib "user32.dll"
#func   DestroyIcon "DestroyIcon" int
#cfunc  GetDC       "GetDC"       int
#func   ReleaseDC   "ReleaseDC"   int,int
#func   MoveWindow  "MoveWindow"  int,int,int,int,int,int

#uselib "gdi32.dll"
#func   BitBlt "BitBlt" int,int,int,int,int,int,int,int,int

#uselib "shell32.dll"
#func   ExtractIconEx "ExtractIconExA" sptr,int,int,int,int


// DrawText�֐��̃t�H�[�}�b�g
#define DT_TOP					0x00000000		// �㑵�� (�f�t�H���g)
#define DT_LEFT					0x00000000		// ���� (�f�t�H���g)
#define DT_CENTER				0x00000001		// ���������ɒ�������
#define DT_RIGHT				0x00000002		// �E��
#define DT_VCENTER				0x00000004		// ���������ɒ�������
#define DT_BOTTOM				0x00000008		// ������
#define DT_WORDBREAK			0x00000010		// �����s�ŕ`��B�܂�Ԃ��͎���
#define DT_SINGLELINE			0x00000020		// ��s����
#define DT_EXPANDTABS			0x00000040		// �^�u����(\t)��W�J
#define DT_TABSTOP				0x00000080		// �^�u�����̋󔒕�������ݒ�B���ʃ��[�h�̏�ʃo�C�g�ŋ󔒐����L��
#define DT_NOCLIP				0x00000100		// �N���b�s���O���s��Ȃ�
#define DT_EXTERNALLEADING		0x00000200		// �s���ɁA�s�ԂƂ��ēK���ȍ�����������
#define DT_CALCRECT				0x00000400		// �`��ɕK�v�� RECT �� lpRect �Ɋi�[���� (�`�揈���͂Ȃ�)
#define DT_NOPREFIX				0x00000800		// �v���t�B�b�N�X����(&)�𖳌��� (& �͎��̕����ɉ����������A&& -> &)
#define DT_INTERNAL				0x00001000		// DT_CALCRECT �̂Ƃ��A�t�H���g�� SystemFont �Ƃ���
#define DT_EDITCONTROL			0x00002000		// EditControl(�����s) �̓����Ɠ��������ŕ`�悷��
#define DT_PATH_ELLIPSIS		0x00004000		// �e�L�X�g�����܂�Ȃ��ꍇ�A�r�����ȗ��L��(...)�ɂ���
#define DT_END_ELLIPSIS			0x00008000		// �e�L�X�g�����܂�Ȃ��ꍇ�A�Ō���ȗ��L��(...)�ɂ���
#define DT_MODIFYSTRING			0x00010000		// �ȗ������ꍇ�AlpStr �ɏȗ���̕�������i�[����
#define DT_RTLREADING			0x00020000		// �E���獶�Ɍ������ĕ`��B�E���獶�ɓǂތ���Ŏg�p����
#define DT_WORD_ELLIPSIS		0x00040000		// �e�L�X�g�����܂�Ȃ��ꍇ�A�K���ȗ��L��(...)�ɂ���
#define DT_NOFULLWIDTHCHARBREAK	0x00080000		// 
#define DT_HIDEPREFIX			0x00100000		// �v���t�B�b�N�X����(&)�𖳎����� ( && �́A�ˑR�Ƃ��� & �ɂȂ� )
#define DT_PREFIXONLY			0x00200000		// �v���t�B�b�N�X����(&)�ɂ�鉺���݂̂�`�悷��


// �t�H���g�쐬���W���[��
#module fontmod
#uselib "gdi32.dll"
#func CreateFontIndirect "CreateFontIndirectA" int
#func GetObject          "GetObjectA"          int,int,int
#func DeleteObject       "DeleteObject"        int
#defcfunc CreateFontByHSP str p1, int p2, int p3
	sdim sFontName, 64 : dim logfont, 15 : mref bmscr, 67
	GetObject bmscr(38), 60, varptr(logfont)				// ���݂� LOGFONT �\���̂��擾����
	getstr sFontName, logfont(7)								// �t�H���g��
	nFontData = abs(logfont), ((logfont(4) <= 700)) | (((logfont(5) & 0xFF) != 0) << 1) | (((logfont(5) & 0xFF00) != 0) << 2) | (((logfont(5) & 0xFF0000) != 0) << 3) | (((logfont(6) & 0x40000) != 0) << 4)
	font p1, p2, p3 : GetObject bmscr(38), 60, varptr(logfont)	// �V�����_���t�H���g���擾
	CreateFontIndirect varptr(logfont) : hFont = stat			// HSP�̉�ʂ���A�V�����t�H���g�����o��
	font sFontName, nFontData(0), nFontData(1)					// ���ɖ߂�
	return hFont
#define global DeleteFont(%1) if (%1) { DeleteObject@fontmod (%1) }
#global



#endif
