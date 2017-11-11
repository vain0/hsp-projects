// ***** �t�H���_�I���_�C�A���O�\��  (foldialog.hsp) [ API�� ] *****
#module
	// ���K�v�ƂȂ�API��萔�̒�`

#uselib "shell32.dll"
#func SHGetPathFromIDList "SHGetPathFromIDList" int,int
#func SHBrowseForFolder "SHBrowseForFolderA" int

#uselib "ole32.dll"
#func CoTaskMemFree "CoTaskMemFree" int

#uselib "user32.dll"
#func SendMessage "SendMessageA" int,int,int,int

#deffunc foldlg str prm1, str prm2, int prm3
	//******************************************************************************
	//		�t�H���_�I���_�C�A���O (foldlg)
	//
	//  �߂�l : ���� stat = 0, refstr = �I���t�H���_��
	//			 ���s stat = 1, refstr �͕ω��Ȃ�
	//
	//  �E����	Foldlg "Title", "DefFolder", nOption
	//  �E����	dlgtitle  (str) : �_�C�A���O�^�C�g���� (�ȗ���)
	//			deffolder (str) : �����t�H���_��
	//			nOption   (int) : 0, 1, 0x4000 �X�^�C���I�v�V�����l
	//******************************************************************************
	mref ref, 65
	ls = strlen(prm1)
	dlgtitle  = prm1
	if (ls == 0) : dlgtitle = "�t�H���_��I�����ĉ�����"
	sdim deffolder, 260
	DefFolder = prm2
	if (strlen(deffolder) == 0) : deffolder=exedir
	nOption   = prm3  // (0, 1, 0x4000)
	if ( (nOption != 0) && (nOption != 1) && (nOption != 0x4000) ) : nOption=0
	
	dim browsinfo, 64 : sdim retbuf, 260
	browsinfo(0) = hwnd
	browsinfo(3) = varptr(dlgtitle)
	browsinfo(4) = nOption
	
	// BrowseCallback
	// �����t�H���_�w��\
	if (deffolder != "") {
		dim brproc, 9
		browsinfo(5) = varptr(brproc) : browsinfo(6) = varptr(deffolder)
		p = varptr(SendMessage)
		brproc    = 0x08247C83, 0x90177501, 0x102474FF, 0x6668016A, 0xFF000004
		brproc(5) = 0xB8102474, p, 0xC031D0FF, 0x000010C2
	}
	SHBrowseForFolder varptr(browsinfo)			: pidl = stat
	SHGetPathFromIDList pidl, varptr(retbuf)	: pidl = stat
	CoTaskMemFree pidl
	ref = retbuf : ls = strlen(retbuf)
	ret = (ls == 0)
	dim browsinfo, 0  : sdim retbuf, 0 : sdim deffolder, 0
	return ret
#global

#if 0
	// ***** sample *****
	
	foldlg "", dirinfo(0), 1
	
	pos 20, 10
	if ( stat == 0 ) {		// ����
		color 0, 0, 255
		mes refstr
	} else {				// ���s
		color 255, 0, 0
		mes "�t�H���_�I���Ɏ��s���܂����c�c"
	}
	stop

#endif
