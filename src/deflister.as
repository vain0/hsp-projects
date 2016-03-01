// deflister - header

#ifndef IG_DEFINITION_LISTER_HEADER_AS
#define IG_DEFINITION_LISTER_HEADER_AS

#include "Mo/MCLongString.as"

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
#func   global GetClientRect  "GetClientRect"  int,int

#func   global SetForegroundWindow   "SetForegroundWindow"    int
#cfunc  global RegisterWindowMessage "RegisterWindowMessageA" sptr

#uselib "kernel32.dll"
#func   global GetFullPathNameA "GetFullPathNameA" sptr,int,int,nullptr
#define global GetFullPathName(%1,%2) GetFullPathNameA %1, MAX_PATH, varptr(%2)

//##################################################################################################
//        �萔�E�}�N��
//##################################################################################################
// Window ID
#const IDW_MAIN 0

// Userdefined Window-Message
#const UWM_SPLITTERMOVE 0x0400

// ���̑�
#define global HSED_TEMPFILE (ownpath + "\\" + HSED_TEMPFILENAME)
#define global HSED_TEMPFILENAME "hsedtmp.hsp"

#define STR_INIPATH (dir_exe2 + "\\deflister.ini")

#undef SetStyle
#undef ChangeVisible
#define global SetStyle(%1,%2=-16,%3=0,%4=0) SetWindowLong (%1),(%2),bit_sub(GetWindowLong((%1),(%2)) | (%3), (%4))
#define global ChangeVisible(%1=hwnd,%2=1) SetStyle (%1), -16, 0x10000000 * (%2), 0x10000000 * ((%2) == 0)// Visible �؂�ւ�

//##################################################################################################
//        ���W���[��
//##################################################################################################
#module deflister_mod

#define true  1
#define false 0

//------------------------------------------------
// �e�s�̐擪�ɍs�ԍ��𖄂ߍ���
//------------------------------------------------
#deffunc SetLinenum var retbuf, str p2, str sform, int start, local text, local tmpbuf, local index, local stmp
	LongStr_new tmpbuf
	text  = p2
	index = 0
	
	sdim stmp, 320
	
	repeat , start
		// ���̈�s���擾
		getstr stmp, text, index : index += strsize
		
		if ( strsize == 0 ) { break }
		
		// ��������
		LongStr_cat tmpbuf, strf(sform, cnt) + stmp + "\n"
	loop
	
	LongStr_tobuf  tmpbuf, retbuf
	LongStr_delete tmpbuf
	return
	
//------------------------------------------------
// �E�B���h�E��P������ɃX�N���[������
// 
// @ direction = SB_HORZ(=0) or SB_VERT(=1)
//------------------------------------------------
#deffunc ScrollWindow int handle, int direction, int nPos
	dim scrollinfo, 8
	scrollinfo = 32, 0x04, 0, 0, 0, nPos
	SetScrollInfo handle, direction, varptr(scrollinfo), true
	sendmsg       handle, 0x0114 + direction, MAKELONG(4, nPos), handle
	return
	
//------------------------------------------------
// ��`�^�C�v���當����𐶐�����
// @static
//------------------------------------------------
#defcfunc MakeDefTypeString int deftype,  local stype, local bCType
	sdim stype, 320
	bCType = ( deftype & DEFTYPE_CTYPE ) != false
	
	if ( deftype & DEFTYPE_LABEL ) { stype = "���x��"   }
	if ( deftype & DEFTYPE_MACRO ) { stype = "�}�N��"   }
	if ( deftype & DEFTYPE_CONST ) { stype = "�萔"     }
	if ( deftype & DEFTYPE_CMD   ) { stype = "�R�}���h" }
	if ( deftype & DEFTYPE_COM   ) { stype = "����(COM)" }
	if ( deftype & DEFTYPE_IFACE ) { stype = "interface" }
	
	if ( deftype & DEFTYPE_DLL ) {
		if ( bCType ) { stype = "�֐�(Dll)" } else { stype = "����(Dll)" }
		
	} else : if ( deftype & DEFTYPE_FUNC  ) {
		if ( bCType ) { stype = "�֐�" } else { stype = "����" }
		
	} else {
		if ( bCType ) { stype += " �b" }
	}
	
	if ( deftype & DEFTYPE_MODULE ) { stype += " �l" }
	return stype
	
#if 0

//------------------------------------------------
// ���ӂ̎O�s�����o��
//------------------------------------------------
#deffunc TookArline3 var bufArline3, str p2, int linenum, local text, local index, local stmp, local tmpbuf
	newmod tmpbuf, MCLongStr
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
	
	LongStr_tobuf tmpbuf, bufArline3
	
	return
#endif

#global

#endif
