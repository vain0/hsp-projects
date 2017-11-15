// hsed utility module

#ifndef __HSED_UTILITY_MODULE_AS__
#define __HSED_UTILITY_MODULE_AS__

#include "hsedsdk.as"
#include "MCProcMemory.as"

#module hsedutil

//##################################################################################################
//        �萔�E�}�N��
//##################################################################################################
#define true  1
#define false 0
#define NULL  0
#define MAX_PATH 260

#define hIF hIF@hsedsdk

//------------------------------------------------
// Win32 API �֐��Q
//------------------------------------------------
#uselib "psapi.dll"
#func   EnumProcessModules@hsedutil  "EnumProcessModules"   int,sptr,int,sptr
#func   GetModuleFileNameEx@hsedutil "GetModuleFileNameExA" int,int,sptr,int

//##################################################################################################
//        [define] ���ߌQ
//##################################################################################################
//------------------------------------------------
// �X�N���v�g�G�f�B�^�̃t���p�X�𓾂�
//------------------------------------------------
#defcfunc hsed_GetHsedPath local hHsed, local mHsedPcm, local path, local hModule, local retSize
	sdim path, MAX_PATH
	
	hsed_getwnd       hHsed, HGW_MAIN
	PCM_new mHsedPcm, hHsed
	
	EnumProcessModules  PCM_hProc(mHsedPcm), varptr(hModule), 4, varptr(retSize)
	GetModuleFileNameEx PCM_hProc(mHsedPcm), hModule, varptr(path), MAX_PATH
	
	PCM_delete mHsedPcm
	return path
	
//------------------------------------------------
// �w��^�u���J���Ă���t�@�C���̃p�X���擾����
//------------------------------------------------
#deffunc hsed_GetFilePath int nTabID,  local path	;, local mTabPcm, local tci, local path, local hTab
	hsed_getpath path, nTabID
	return path
/*
	dim  tci, 7				// TCITEM �\����
	sdim path, MAX_PATH
	tci(0) = 0x08			// TCIF_PARAM ( lparam )
	
	hsed_getwnd        hTab, HGW_TAB
	PCM_new   mTabPcm, hTab
	PCM_alloc mTabPcm, 7 * 4
	PCM_write mTabPcm, varptr(tci), 7 * 4
	
	// TCM_GETITEM : tcitem.lparam = ptr to filepath
	sendmsg hTab, 0x1305, nTabID, PCM_getPtr( mTabPcm )
	if ( stat == false ) { return "" }					// ���s
	
	PCM_read mTabPcm, varptr(tci), 7 * 4
	if ( tci(6) != NULL ) {
		PCM_readVM mTabPcm, tci(6), varptr(path), MAX_PATH
	}
	
	PCM_delete mTabPcm
	return path
//*/

//------------------------------------------------
// �A�N�e�B�u�� FootyID ��Ԃ�
//------------------------------------------------
#defcfunc hsed_activeFootyID  local fID
	hsed_getactfootyid fID
	return fID
	
//------------------------------------------------
// �A�N�e�B�u��Footy�̃e�L�X�g���擾
//------------------------------------------------
#deffunc hsed_getActText var p1,  local nActFootyID, local nTextLength
	hsed_capture
	if ( stat ) { return 1 }
	
	sendmsg hIF, _HSED_GETACTFOOTYID@hsedsdk
	nActFootyID = stat
	
	hsed_GetTextLength nTextLength, nActFootyID
	if ( stat ) { return }
	if ( nTextLength == 0 ) {
		p1 = ""
	} else {
		hsed_gettext p1, nActFootyID
	}
	return
	
//------------------------------------------------
// �A�N�e�B�u��Footy�̃e�L�X�g��ύX
//------------------------------------------------
#deffunc hsed_setActText str sText, local nActFootyID
	hsed_capture
	if ( stat ) { return 1 }
	
	sendmsg hIF, _HSED_GETACTFOOTYID@hsedsdk
	nActFootyID = stat

	hsed_settext nActFootyID, sText
	return
	
//------------------------------------------------
// �L�����b�g�̈ʒu���擾
// @ base 1 ( �s�� )
//------------------------------------------------
#deffunc hsed_getCaretPos var p1, int nFootyID
	hsed_capture
	if ( stat ) { return 1 }
	sendmsg hIF, _HSED_GETCARETPOS@hsedsdk, nFootyID
	if ( stat <= 0 ) { return 1 }
	p1 = stat
	return 0
	
//------------------------------------------------
// �L�����b�g�̈ʒu���擾
// @ base 1 ( �X�N���v�g�擪 )
//------------------------------------------------
#deffunc hsed_getCaretThrough var p1, int nFootyID
	hsed_capture
	if stat : return 1
	sendmsg hIF, _HSED_GETCARETTHROUGH@hsedsdk, nFootyID
	if stat <= 0 : return 1
	p1 = stat
	return 0
	
//------------------------------------------------
// �������[���[�̈ʒu���擾
// @ base 1 ( �s�� )
//------------------------------------------------
#deffunc hsed_getCaretVPos var p1, int nFootyID
	hsed_capture
	if stat : return 1
	sendmsg hIF, _HSED_GETCARETVPOS@hsedsdk, nFootyID
	if stat < 0 : return 1
	p1 = stat
	return 0
	
//------------------------------------------------
// �L�����b�g�̂���s�̍s�ԍ����擾
//------------------------------------------------
#deffunc hsed_getCaretLine var p1, int nFootyID
	hsed_capture
	if stat : return 1
	sendmsg hIF, _HSED_GETCARETLINE@hsedsdk, nFootyID
	
	if ( stat <= 0 ) {
		return 1
	} else {
		p1 = stat
		return 0
	}
	
//------------------------------------------------
// �w��ʒu�ɃL�����b�g�̈ʒu��ݒ�
// @ base 1 ( �s�� )
//------------------------------------------------
#deffunc hsed_setCaretPos int nFootyID, int nCaretpos
	hsed_capture
	if stat : return 1
	sendmsg hIF, _HSED_SETCARETPOS@hsedsdk, nFootyID, nCaretpos
	return

//------------------------------------------------
// �w��ʒu�ɃL�����b�g�̈ʒu��ύX
// @ base 1 ( �X�N���v�g�擪 )
//------------------------------------------------
#deffunc hsed_setCaretThrough int nFootyID, int nCaretthrough
	hsed_capture
	if stat : return 1
	sendmsg hIF, _HSED_SETCARETTHROUGH@hsedsdk, nFootyID, nCaretthrough
	return
	
//------------------------------------------------
// �w�肵���s�ԍ��ɃL�����b�g�̈ʒu��ύX
//------------------------------------------------
#deffunc hsed_setCaretLine int nFootyID, int nLine
	hsed_capture
	if stat : return 1
	sendmsg hIF, _HSED_SETCARETLINE@hsedsdk, nFootyID, nLine
	return
	
#global

//##################################################################################################
//        �T���v���E�X�N���v�g
//##################################################################################################
#if 0

	mes hsed_GetHsedPath()
	hsed_getacttabid nTabID
	hsed_GetFilePath nTabID
	mes refstr
	stop
	
#endif

#endif
