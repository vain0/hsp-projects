// Light Filer - MCViewData

#ifndef __LFILER_MODULECLASS_VIEWDATA_AS__
#define __LFILER_MODULECLASS_VIEWDATA_AS__

#include "Mo/NoteCnv.as"
#include "Mo/pvalptr.as"

#module MCViewData msPath, msFolderlist, mcntFolders, msFilelist, mcntFiles

#define mv modvar MCViewData@
#define MAX_PATH 260
	
// (private) ���X�g���X�V����
#modfunc ViewData_GetDirlist@MCViewData local folderlist, local filelist
	dirlist folderlist, msPath +"*?",  5	// �t�H���_���X�g�𓾂�
			mcntFolders = stat
	dirlist filelist,   msPath +"*.*", 1	// �t�@�C�����X�g�𓾂�
			mcntFiles   = stat
	
;	sdim msFolderlist, MAX_PATH, mcntFolders
;	sdim msFilelist,   MAX_PATH, mcntFiles
	
	NoteToAry msFolderlist, folderlist
	NoteToAry msFilelist,   filelist
	return
	
// ���݂̃t�H���_�̏���ݒ肷��
#modfunc ViewData_Renew
	ViewData_GetDirlist thismod
	return
	
// ���������擾
#defcfunc ViewData_path mv
	return msPath
	
#defcfunc ViewData_folderlist mv, int p2
	return msFolderlist( p2 )
	
#defcfunc ViewData_cntFolders mv
	return mcntFolders
	
#defcfunc ViewData_filelist mv, int p2
	return msFileList( p2 )
	
#defcfunc ViewData_cntFiles mv
	return mcntFiles
	
// �R���X�g���N�^
#modinit str p2
	sdim msPath, MAX_PATH
	msPath = p2
	
	ViewData_Renew thismod
	return getaptr(thismod)
	
#global

#endif
