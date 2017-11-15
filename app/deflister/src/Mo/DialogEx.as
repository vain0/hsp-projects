// DialogEx

#ifndef __DIALOG_EX_MODULE_AS__
#define __DIALOG_EX_MODULE_AS__

#module DialogEx_mod

#uselib "comdlg32.dll"
#func   GetOpenFileName@DialogEx_mod "GetOpenFileNameA" int
#func   GetSaveFileName@DialogEx_mod "GetSaveFileNameA" int

#define BUFSIZE	260
#define FILTERSIZE 512
#define ALLTYPE				"ALL files (*.*)@*.*@"
#define PICTURE				"�摜�t�@�C�� (*.bmp;*.mag;*.jpg)@*.bmp;*.mag;*.jpg@"
#define SOUND				"���y�t�@�C�� (*.mid;*.mp3;*.wav)@*.mid;*.mp3;*.wav@"
#define DOCUMENT			"�����t�@�C�� (*.txt)@*.txt@"

// �t���O
#define global OFN_READONLY				0x00000001		// �ǂݎ���p��Ԃŏ���������
#define global OFN_OVERWRITEPROMPT		0x00000002		// �㏑���̏ꍇ�A�m�F����
#define global OFN_HIDEREADONLY			0x00000004		// ReadOnly �`�F�b�N�{�b�N�X���\���ɂ���
#define global OFN_NOCHANGEDIR			0x00000008		// �J�����g�f�B���N�g����ύX���Ȃ�
#define global OFN_SHOWHELP				0x00000010		// [�H] ��\��
#define global OFN_ENABLEHOOK			0x00000020		// lpfnHook �Ńt�b�N�֐��ւ̃|�C���^���w��\
#define global OFN_ENABLETEMPLATE		0x00000040		// lpTemplateName �� hInstance �Ŏw�肳��郂�W���[���� DialogTemplateResouce �̖��O�ւ̃|�C���^�ł��邱�Ƃ�����
#define global OFN_ENABLETEMPLATEHANDLE	0x00000080		// hInstace �����Ƀ��[�h����Ă��� DialogTemplate �����L���� DataBlock �ł��邱�Ƃ�����
#define global OFN_NOVALIDATE			0x00000100		// �p�X���̖����ȕ���������
#define global OFN_ALLOWMULTISELECT		0x00000200		// �����I��������
#define global OFN_EXTENSIONDIFFERENT	0x00000400		// �w�肳�ꂽ�g���q�� lpstrDefExt �Ƃ͈Ⴄ���Ƃ�����
#define global OFN_PATHMUSTEXIST		0x00000800		// �L���ȃp�X�ƃf�B���N�g���������͂ł��Ȃ��悤�ɂ���
#define global OFN_FILEMUSTEXIST		0x00001000		// ���݂���t�@�C���̂ݑI���ł���
#define global OFN_CREATEPROMPT			0x00002000		// ���[�U�[�����݂��Ȃ��t�@�C����I�����悤�Ƃ������͊m�F����
#define global OFN_SHAREAWARE			0x00004000		// ???
#define global OFN_NOREADONLYRETURN		0x00008000		// ???
#define global OFN_NOTESTFILECREATE		0x00010000		// �_�C�A���O��������܂Ńt�@�C�����쐬����Ȃ��悤�ɂ���
#define global OFN_NONETWORKBUTTON		0x00020000		// �l�b�g���[�N�{�^���𖳌��E��\���ɂ���
#define global OFN_NOLONGNAMES			0x00040000		// �]���̃_�C�A���O�ŁA�����t�@�C�������g��Ȃ�
#define global OFN_EXPLORER				0x00080000		// �G�N�X�v���[���X�^�C�����g��
#define global OFN_NODEREFERENCELINKS	0x00100000		//
#define global OFN_LONGNAMES			0x00200000		// �����t�@�C�������g��
#define global OFN_ENABLEINCLUDENOTIFY	0x00400000		// send include message to callback
#define global OFN_ENABLESIZING			0x00800000		//
#define global OFN_DONTADDTORECENT		0x02000000		// win2k
#define global OFN_FORCESHOWHIDDEN		0x10000000		// Show All files including System and hidden files

// http://hp.vector.co.jp/authors/VA023539/tips/dialog/004.htm

// str Filter, OPENFILENAME *, bSave, flags
#deffunc FileSelDlg str p1, int p2, int p3, int p4, local i, local match
	dim  ofn  , 22
	sdim aplFilter , FILTERSIZE +1
	sdim usrFilter , FILTERSIZE +1
	sdim filename  , BUFSIZE +1
	sdim Filter, strlen(p1) +1
	
	Filter = p1
	i = 0
	repeat
		match = instr(Filter, i, "@")	// @ ��T��
		if (match == -1) { break }		// ������ΏI��
		poke Filter,i +  match , 0		// @ �� NULL �����ɏ㏑��
					i += match + 1		// Index �ǉ�
	;	await 0
	loop
	
	if ( p2 == 0 ) {		// p2(ofn �� 0)
		ofn.0  = 88						// lStructSize
		ofn.1  = bmscr(13)				// hwndOwner
		ofn.2  = bmscr(14)				// hInstance
		ofn.3  = varptr(Filter)			// lpstrFilter
		ofn.4  = varptr(usrFilter)		// lpstrCustomFilter
		ofn.5  = FILTERSIZE				// nMaxCustFilter
		ofn.6  = 1						// nFilterIndex
		ofn.7  = varptr(filename)		// lpstrFile
		ofn.8  = BUFSIZE				// nMaxFile
		ofn.9  = 0						// lpstrFileTitle
		ofn.10 = 0						// nMaxFileTitle
		ofn.11 = 0						// lpstrInitialDir
		ofn.12 = 0						// lpstrTitle
		ofn.13 = OFN_FILEMUSTEXIST | p4	// Flags
		ofn.14 = 0						// nFileOffset
		ofn.15 = 0						// nFileExtension
		ofn.16 = 0						// lpstrDefExt
		ofn.17 = 0						// lCustData
		ofn.18 = 0						// lpfnHook
		ofn.19 = 0						// lpTemplateName
	} else {
		dupptr ofn, p2, 88, 4			// OPENFILENAME�\����
		if ( Filter != "" ) {			// p1 ���g�p����Ȃ�
			ofn(3)  = varptr(Filter)	// �t�B���^���㏑��
		}
	}
	
	if ( p3 == 0 ) {
		GetOpenFileName varptr(ofn)	// �u�t�@�C�����J���v
	} else {
		GetSaveFileName varptr(ofn)	// �u���O�����ĕۑ��v
	}
	if ( stat ) {
		// �t�@�C�����i�[
		if ( p2 ) {
			dupptr filename, ofn(7), ofn(8), 2
		}
		ref = filename				// �t�@�C���p�X��Ԃ�
		
		return varptr(ofn)			// ofn �ւ̃|�C���^ (�^�l)
	}
	return 0	// �U
	
#global
	mref bmscr@DialogEx_mod, 67		// BMSCR �\����
	mref ref@DialogEx_mod, 65		// refstr ���蓖��
	
#if 0

#undef false
#undef NULL
#define false 0
#define NULL 0

	FileSelDlg "1@*@2@*@3@*@4@*@5@*@", NULL, false
	pofn = stat
	mes "stat == "+ stat
	mes "refs == "+ refstr
	
	if ( pofn != NULL ) {
		dupptr ofn, pofn, 22 * 4
		mes "index == "+ ofn(6)
	}
	stop
#endif

#endif
