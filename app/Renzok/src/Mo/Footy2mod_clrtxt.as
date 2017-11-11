// Footy2 module - Clrtxt

#ifndef __FOOTY2_MODULE_CLRTXT__
#define __FOOTY2_MODULE_CLRTXT__

#include "ClrtxtOptimize.as"

#module footy2mod_clrtxt mFootyID, mClrtxt, mClrtxtLen, mLibPath

#ifndef __UserDefHeader__
 #define exdel(%1) exist(%1):if(strsize >= 0){delete(%1)}
 #define note %tNoteLoop _note_noteloop
 #define noteIndex _noteIndex_noteloop
 #define ntcnt _ntcnt_noteloop
 #define ntlen _ntlen_noteloop
 #define NoteRepeat(%1,%2=0,%3=ntcnt,%4=1,%5=0,%6=0)%tbreak%i0 %tcontinue%i0 %tNoteLoop noteIndex=%5:%3=%2:ntlen=strlen@hsp(%1):%s3%s4 %i0 *%i:getstr@hsp note,%1,noteIndex,%6:noteindex+=strsize
 #define NoteLoop %tcontinue *%o:%tNoteLoop %p3+=%p2 : if(noteIndex < ntlen){goto@hsp *%o} %o0%o0:if(0){%tbreak *%o : %tNoteLoop %p=(%p^0xFFFFFFFF)+1} %o0
 #define true  1
 #define false 0
 #define MAX_PATH 260
#endif

// �R���X�g���N�^
#modinit int footyID
	mFootyID   = footyID
	mClrtxtLen = 0
	sdim mClrtxt, 3200
	sdim mLibPath, MAX_PATH
	return
	
// �f�X�g���N�^
#modterm local filelist
	// �L���b�V�����폜����
	if ( peek( mLibPath ) ) {
		sdim       filelist, MAX_PATH * 5
		dirlist    filelist, mLibPath +"*.clrtxtcache", 2	// ���X�g
		NoteRepeat filelist
			exdel mLibPath + note	// ����΍폜
		NoteLoop
	}
	return
	
// ���C�u�����̈ʒu��ݒ肷��
#modfunc F2CT_SetClrtxtLibPath str path, local len
	mLibPath = path
	len      = strlen( mLibPath )
	
	// �Ō�� \ �ŏI���Ȃ��悤�ɂ���
	if ( peek(mLibPath, len - 1) == '\\' || peek(mLibPath, len - 1) == '/' ) {
		poke mLibPath, len - 1, 0
	}
	return
	
// Clrtxt ��ǉ�����
#modfunc F2CT_AppendClrtxt str p2, local path, local filedata, local len
	path = p2
	if ( peek(path, 1, 1) != ':' ) {	// ���΃p�X�̏ꍇ
		path = mLibPath +"\\"+ path		// ���C�u�����E�p�X��t��
	}
	
	exist path
	if ( strsize < 0 ) { return true }
	
	// �L���b�V�������邩�ǂ���
	exist path +"cache"
	sdim  filedata, strsize + 1
	if ( strsize > 0 ) {			// ����ꍇ
		
		// �ǂݍ��ނ����ł���
		bload path +"cache", filedata, strsize
		len = strsize
		
	// ���L���b�V��
	} else {
		ClrtxtOptimize path, filedata		// �œK������
		bsave path +"cache", filedata, stat	// �L���b�V������
		len = stat
	}
	
	// �ǉ�����
	mClrtxt    += filedata
	mClrtxtLen += len
	
	return false
	
// Clrtxt ����菜��
#modfunc F2CT_RemoveClrtxt str p2
	ClrtxtDelete mClrtxt, p2		// �폜�����T�C�Y�� ����(�G���[) ��Ԃ�
	if ( stat >= 0 ) {
		;
	} else {
		// ��蔭��
		logmes "[ERROR] Clrtxt �̍폜�Ɏ��s���܂���"
		return true
	}
	return false
	
// Footy��Clrtxt�𔽉f������
#modfunc F2CT_InputClrtxt
	ClrtxtInput mFootyID, mClrtxt, true		// ����
	return
	
#global

#endif
