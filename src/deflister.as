// deflister - header

#ifndef __DEFINED_LISTER_HEADER_AS__
#define __DEFINED_LISTER_HEADER_AS__

#include "Mo/strutil.as"

// Win32 API
#uselib "user32.dll"
#func   global SetWindowLong  "SetWindowLongA" int,int,int
#cfunc  global GetWindowLong  "GetWindowLongA" int,int
#func   global MoveWindow     "MoveWindow"     int,int,int,int,int,int
#func   global PostMessage    "PostMessageA"   int,int,int,sptr
#func   global CharLower      "CharLowerA"     sptr
#func   global SetScrollInfo  "SetScrollInfo"  int,int,int,int
#func   global InvalidateRect "InvalidateRect" int,int,int
#func   global UpdateWindow   "UpdateWindow"   int
#cfunc  global LoadCursor     "LoadCursorA"    nullptr,int
#func   global SetClassLong   "SetClassLongA"  int,int,int
#func   global SetCursor      "SetCursor"      int
#func   global EnableWindow   "EnableWindow"   int,int

//##################################################################################################
//        �萔�E�}�N��
//##################################################################################################
// window ID
#const wID_Main 0

#const UWM_SPLITTERMOVE 0x0400

//##################################################################################################
//        ���W���[��
//##################################################################################################
#module deflister_mod

#define true  1
#define false 0

// �e�s�̐擪�ɍs�ԍ��𖄂ߍ���
#deffunc SetLineNum var retbuf, str text, str sform, int start, local buf, local iWrote, local index, local bufsize, local stmp
	buf     = text
	bufsize = 3200
	index   = 0
	iWrote  = 0
	
	sdim stmp, 250
	sdim retbuf, bufsize
	
	repeat , start
		// ���̈�s���擾
		getstr stmp, buf, index : index += strsize
		
		if ( strsize == 0 ) { break }
		
		// �I�[�o�[�t���[���Ď�
		if ( (bufsize - iWrote - strsize) < 1200 ) {
			bufsize = iWrote + strsize + 3200
			memexpand retbuf, bufsize
		}
		
		// ��������
		poke retbuf, iWrote, strf(sform, cnt) + stmp +"\n"
		iWrote += strsize
	loop
	return
	
// ��`�����X�g�A�b�v����
#deffunc TookDefinition var retbuf, array lnlist, str p2, local script, local count, local bufsize, local stmp, local iWrote, local index, local ppName, local ppOffset
	script  = p2
	iWrote  = 0
	index   = 0
	bufsize = 3200
	count   = 0
	sdim   stmp, 250
	sdim ppName
	sdim retbuf, 3200
	
	repeat
		// ���̈�s���擾
		getstr stmp, script, index : index += strsize
		
		if ( strsize == 0 ) { break }
		
		// �󔒂𖳎�
		ppOffset = CntSpaces(stmp, 0)
		
		// �v���v���Z�b�T���߂�����΁A�`�F�b�N
		if ( peek(stmp, ppOffset) == '#' ) {
			ppOffset ++
			ppOffset += CntSpaces(stmp, ppOffset)			// # �Ɩ��̂̊Ԃ̋󔒂𖳎�
			ppOffset += TookIdent(ppName, stmp, ppOffset)	// �v���v���Z�b�T���߂̖��O
			switch getpath( ppName, 16 )
				
				case "deffunc" : case "defcfunc" 
				case "modfunc" : case "modcfunc"
				case "define"  : case "const"    : case "enum"
*@:					ppOffset += CntSpaces(stmp, ppOffset)
					ppOffset += TookIdent(ppName, stmp, ppOffset)
					
					switch getpath( ppName, 16 )
					case "global" : case "local" : case "ctype"
						goto *@b
					swend
					
					// ���X�g�ɒǉ�
					if ( ( bufsize - iWrote - ppOffset ) < 1200 ) {	// ��ppOffset > strlen(ppName)
						bufsize =    iWrote + ppOffset + 3200
						memexpand retbuf, bufsize
					}
					poke retbuf, iWrote, ppName +"\n" : iWrote += strsize
					lnlist(count) = cnt
					count ++
					swbreak
			swend
		}
	loop
	return count
	
// ���ӂ̎O�s�����o��
#deffunc TookArline3 var bufArline3, str p2, int linenum, local text, local index, local stmp
	text  = p2
	index = 0
	
	sdim stmp, 1200
	sdim bufArline3, 256
	
	if ( linenum == 0 ) { bufArline3 = "\n" }
	
	repeat
		// ���̈�s�����o��
		getstr stmp, text, index : index += strsize
		
		if ( strsize == 0 ) {
			break
		}
		
		if ( numrg(cnt, linenum - 1, linenum + 1) ) {
			bufArline3 += stmp +"\n"
			count ++
			if ( count == 3 ) { break }
		}
		
	loop
	
	if ( count < 3 ) {
		repeat 3 - count
			bufArline3 += "\n"
			count ++
		loop
	}
	
	return
	
// �R���g���[����P������ɃX�N���[������( direction = SB_HORZ(=0) or SB_VERT(=1) )
#deffunc ScrollWindow int handle, int direction, int nPos
	dim scrollinfo, 8
	
	scrollinfo = 32, 0x04, 0, 0, 0, nPos
	SetScrollInfo handle, direction, varptr(scrollinfo), true
	sendmsg       handle, 0x0114 + direction, MAKELONG(4, nPos), handle
	return
	
#global

#endif
