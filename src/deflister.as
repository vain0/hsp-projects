// deflister - header

#ifndef __DEFINED_LISTER_HEADER_AS__
#define __DEFINED_LISTER_HEADER_AS__

#include "Mo/cwhich.as"
#include "Mo/LongString.as"
#include "Mo/strutil.as"
#ifdef __LISTUP_INCLUDE__
#include "Mo/hsedutil.as"
#include "Mo/SearchFileEx.as"
#endif
#include "mod_deflist.as"

// Win32 API
#uselib "user32.dll"
#func   global SetWindowLong  "SetWindowLongA" int,int,int
#cfunc  global GetWindowLong  "GetWindowLongA" int,int
#func   global MoveWindow     "MoveWindow"     int,int,int,int,int,int
#func   global PostMessage    "PostMessageA"   int,int,int,sptr
#func   global SetScrollInfo  "SetScrollInfo"  int,int,int,int
#cfunc  global LoadCursor     "LoadCursorA"    nullptr,int
#func   global SetClassLong   "SetClassLongA"  int,int,int
#func   global SetCursor      "SetCursor"      int
#func   global ClipCursor     "ClipCursor"     int
#func   global EnableWindow   "EnableWindow"   int,int

#func   global SetForegroundWindow   "SetForegroundWindow"    int
#cfunc  global RegisterWindowMessage "RegisterWindowMessageA" sptr

#uselib "kernel32.dll"
#func   global GetFullPathNameA "GetFullPathNameA" sptr,int,int,nullptr
#define global GetFullPathName(%1,%2) GetFullPathNameA %1,MAX_PATH,varptr(%2)

//##################################################################################################
//        �萔�E�}�N��
//##################################################################################################
// window ID
#const wID_Main 0

#const UWM_SPLITTERMOVE 0x0400

// ���̑�
#define global HSED_TEMPFILE (curdir +"\\hsedtmp.hsp")

//##################################################################################################
//        ���W���[��
//##################################################################################################
#module deflister_mod

#include "Mo/ctype.as"

#define true  1
#define false 0

// �e�s�̐擪�ɍs�ԍ��𖄂ߍ���
#deffunc SetLinenum var retbuf, str p2, str sform, int start, local text, local tmpbuf, local index, local stmp
	newmod tmpbuf, longstr
	text  = p2
	index = 0
	
	sdim stmp, 320
	
	repeat , start
		// ���̈�s���擾
		getstr stmp, text, index : index += strsize
		
		if ( strsize == 0 ) { break }
		
		// ��������
		LongStr_cat tmpbuf, strf(sform, cnt) + stmp +"\n"
	loop
	
	sdim retbuf,  LongStr_len(tmpbuf) + 1
	     retbuf = LongStr_get(tmpbuf)
	return
	
// ��`�^�C�v���當����𐶐�����
#defcfunc MakeTypeString int deftype, local stype
	sdim stype, 320
	if ( deftype & DEFTYPE_LABEL ) { stype = "���x��" }
	if ( deftype & DEFTYPE_MACRO ) { stype = "�}�N��" }
	if ( deftype & DEFTYPE_CONST ) { stype = "�萔"   }
	if ( deftype & DEFTYPE_FUNC  ) {
		if ( deftype & DEFTYPE_CTYPE ) { stype = "�֐�" } else { stype = "����" }
	} else {
		if ( deftype & DEFTYPE_CTYPE ) { stype += " �b" }
	}
	if ( deftype & DEFTYPE_MODULE ) { stype += " �l" }
	return stype
	
#ifdef __LISTUP_INCLUDE__

// �����p�X��ǉ�����
#deffunc AppendSearchPath str p1, local path, local c, local len
	sdim path, MAX_PATH
	path = p1
	len  = strlen(path)
	c    = peek(path, len - 1)
	if ( c == '/' ) { len -- }
	if ( c != '\\') { wpoke path, len, '\\' << 16 : len ++ }
	if ( instr(searchpath, 0, path +";") < 0 ) {
		searchpath += path +";"
	}
	return
	
// ��`���X�g���ċA�I�ɍ쐬����
#deffunc CreateDefinitionList array mdeflist, array listIncludeToLoad, local listInclude, local filename, local index, local bListupped
	
	foreach listIncludeToLoad
		
		// ���̃t�@�C���̃t���p�X���擾
		if ( peek(listIncludeToLoad(cnt), 1) != ':' ) {		// "x:\..." �Ȃ���Ƀt���p�X
			
			SearchFileEx searchpath, listIncludeToLoad(cnt)
			if ( refstr == "" ) { continue }
			listIncludeToLoad(cnt) = refstr
			AppendSearchPath getpath(refstr, 32)	// ���ꌟ���p�X���g�����Ă���
		}
		
		// �t�@�C�����݂̂��擾���Ă���
		filename = getpath(listIncludeToLoad(cnt), 8)
		
		// ���ɊJ����Ă���t�@�C���Ȃ疳��
		if ( vartype(mdeflist) == vartype("struct") ) {
			bListupped = false
			foreach mdeflist
				if ( DefList_GetFileName( mdeflist(cnt) ) == filename ) {
					bListupped = true
					break
				}
			loop
			if ( bListupped ) { continue }
		}
		
;		exist listIncludeToLoad(cnt)
;		if ( strsize < 0 ) { continue }
		
		// ��`���X�g���쐬����
		newmod mdeflist, deflist, listIncludeToLoad(cnt)
		index = stat
		
		// �ċA�I�Ɍ������ꂽ�t�@�C�������`�����o��
		if ( DefList_GetCntInclude( mdeflist(index) ) ) {
			DefList_GetIncludeArray mdeflist(index), listInclude
			CreateDefinitionList    mdeflist,        listInclude
		}
		
	loop
	
	return
	
#endif
	
// �R���g���[����P������ɃX�N���[������( direction = SB_HORZ(=0) or SB_VERT(=1) )
#deffunc ScrollWindow int handle, int direction, int nPos
	dim scrollinfo, 8
	scrollinfo = 32, 0x04, 0, 0, 0, nPos
	SetScrollInfo handle, direction, varptr(scrollinfo), true
	sendmsg       handle, 0x0114 + direction, MAKELONG(4, nPos), handle
	return
	
#if 0

// ���ӂ̎O�s�����o��
#deffunc TookArline3 var bufArline3, str p2, int linenum, local text, local index, local stmp, local tmpbuf
	newmod tmpbuf, longstr
	text  = p2
	index = 0
	
	sdim stmp, 1200
	sdim bufArline3, 256
	
	if ( linenum == 0 ) { LongStr_cat tmpbuf, "\n" }
	
	repeat
		// ���̈�s�����o��
		getstr stmp, text, index : index += strsize
		
		if ( strsize == 0 ) {
			break
		}
		
		if ( numrg(cnt, linenum - 1, linenum + 1) ) {
			LongStr_cat tmpbuf, stmp +"\n"
			count ++
			if ( count == 3 ) { break }
		}
		
	loop
	
	if ( count < 3 ) {
		repeat 3 - count
			LongStr_cat tmpbuf, "\n"
			count ++
		loop
	}
	
	sdim bufArline3,  LongStr_len(tmpbuf)
	     bufArline3 = LongStr_get(tmpbuf)
	
	return
#endif

#global
sdim searchpath@deflister_mod, MAX_PATH * 3

#endif
