// deflister - header

#ifndef __DEFINED_LISTER_HEADER_AS__
#define __DEFINED_LISTER_HEADER_AS__

#include "Mo/cwhich.as"
#include "Mo/LongString.as"
#include "Mo/strutil.as"
#include "Mo/HPM_GetToken.as"

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
#func   global EnableWindow   "EnableWindow"   int,int

//##################################################################################################
//        �萔�E�}�N��
//##################################################################################################
// window ID
#const wID_Main 0

#const UWM_SPLITTERMOVE 0x0400

// DEFTYPE
#const global DEFTYPE_LABEL		0x0001		// ���x��
#const global DEFTYPE_MACRO		0x0002		// �}�N��
#const global DEFTYPE_CONST		0x0004		// �萔
#const global DEFTYPE_FUNC		0x0008		// ���߁E�֐�

#const global DEFTYPE_CTYPE		0x0100		// CTYPE
#const global DEFTYPE_MODULE	0x0200		// ���W���[�������o

// ����ȋ�Ԗ�
#define global AREA_GLOBAL "global"
#define global AREA_ALL    "*"

//##################################################################################################
//        ���W���[��
//##################################################################################################
#module deflister_mod

#include "Mo/ctype.as"
#include "Mo/HPM_Header.as"

#define true  1
#define false 0

// �e�s�̐擪�ɍs�ԍ��𖄂ߍ���
#deffunc SetLineNum var retbuf, str text, str sform, int start, local buf, local tmpbuf, local index, local stmp
	newmod tmpbuf, longstr
	buf   = text
	index = 0
	
	sdim stmp, 320
	
	repeat , start
		// ���̈�s���擾
		getstr stmp, buf, index : index += strsize
		
		if ( strsize == 0 ) { break }
		
		// ��������
		LongStr_cat tmpbuf, strf(sform, cnt) + stmp +"\n"
	loop
	
	sdim retbuf,  LongStr_len(tmpbuf) + 1
	     retbuf = LongStr_get(tmpbuf)
	return
	
// �w�蕶���C���f�b�N�X�̂���s�ԍ����擾����
#defcfunc GetLinenumByIndex str p1, int p2, int iStart, int iStartLineNum, local text, local linenum, local c
	text    = p1
	linenum = iStartLineNum
	
	if ( iStart > p2 ) { return iStartLineNum }
	
	repeat p2 - iStart, iStart
		c = peek(text, cnt)
		if ( c == 0x0D || c == 0x0A ) {		// ���s�R�[�h
			linenum ++
			if ( c == 0x0D && peek(text, cnt + 1) == 0x0A ) {
				continue cnt + 2
			}
		} else : if ( IsSJIS1st(c) ) {		// �S�p����
			continue cnt + 2
			
		} else : if ( c == 0 ) {
			break
		}
	loop
	
	return linenum
	
// ��`�^�C�v���當����𐶐�����
#defcfunc MakeDefTypeString int deftype, local stype
	sdim stype, 320
	if ( deftype & DEFTYPE_LABEL ) { stype = "���x��" }
	if ( deftype & DEFTYPE_MACRO ) { stype = "�}�N��" }
	if ( deftype & DEFTYPE_CONST ) { stype = "�萔"   }
	if ( deftype & DEFTYPE_FUNC ) {
		if ( deftype & DEFTYPE_CTYPE ) { stype = "�֐�" } else { stype = "����" }
	} else {
		if ( deftype & DEFTYPE_CTYPE ) { stype += " �b" }
	}
	if ( deftype & DEFTYPE_MODULE ) { stype += " �l" }
	return stype
	
// (private) ���W���[����Ԗ������肷��
#defcfunc TookModuleName var scope, var script, int offset, str defscope, local index
	index = offset
	if ( peek(script, index) == '@' ) {
		index ++
		index += TookIdent(scope, script, index)
		if ( stat == 0 ) { scope = AREA_GLOBAL }
	} else {
		scope = defscope
	}
	return index - offset
	
// ��`�����X�g�A�b�v����( �����̏��Ԃɒ��� )
#deffunc TookDefinition str p1, array listIdent, array listLn, array listType, array listScope, local script, local listIndex, local count, local stmp, local index, local textlen, local areaScope, local scope, local nowTT, local befTT, local bPreLine, local bGlobal, local deftype
	script  = p1
	index   = 0
	count   = 0
	textlen = strlen(script)
	sdim stmp, 250
	sdim name
	sdim scope
	sdim areaScope
	
	dim  listLn   ,  5
	sdim listIdent,, 5
	dim  listType ,  5
	sdim listScope,, 5
	dim  listIndex,  5		// �����C���f�b�N�X�̃��X�g( �������̂��߂Ɏg�� )
	
	areaScope = AREA_GLOBAL
	
	repeat
		// �󔒂��΂�
		index += CntSpaces(script, index)
		
		// �Ō�܂Ŏ擾�ł�����I������
		if ( textlen <= index ) { break }
		
		// ���̃g�[�N�����擾
		GetNextToken nowtk, script, index, befTT, bPreLine : nowTT = stat
		if ( nowTT == TOKENTYPE_ERROR ) {
			index += strlen(nowtk)
			continue				// �P���ɖ������邾��
		}
		
		// �g�[�N���̎�ނ��Ƃɏ������킯��
		gosub *L_ProcToken
		
		// �C���f�b�N�X��i�߂�
		index += strlen(nowtk)
		
		befTT = nowTT
	loop
	
	return count
	
*L_ProcToken
	switch nowTT
	
	case TOKENTYPE_COMMENT : nowTT = befTT : swbreak
	
	case TOKENTYPE_END		// ���̏I��
		nowTT = TOKENTYPE_NONE
		if ( bPreLine ) { bPreLine = false }
		swbreak
		
	case TOKENTYPE_LABEL	// ���x��
		if ( befTT == TOKENTYPE_NONE ) {	// �s���̏ꍇ�̂�
			
			index += strlen(nowtk)
			index += TookModuleName(scope, script, index, areaScope)
			
			// ���X�g�ɒǉ�
			listIdent(count) = nowtk
			if ( count <= 0 ) {
				listLn(count) = GetLinenumByIndex(script, index, 0, 0)
			} else {
				listLn(count) = GetLinenumByIndex(script, index, listIndex(count - 1), listLn(count - 1))
			}
			listType (count) = DEFTYPE_LABEL
			listScope(count) = scope
			listIndex(count) = index
			count ++
		}
		swbreak
		
	case TOKENTYPE_PREPROC	// �v���v���Z�b�T����
		if ( IsPreproc(nowtk) ) {
			bPreLine = true
			index   += strlen(nowtk)
			deftype  = 0
			bGlobal  = false
			
			// # �Ƌ󔒂���������
			getstr nowtk, nowtk, 1 + CntSpaces(nowtk, 1)
			
			switch ( getpath( nowtk, 16 ) )
			case "module"
				index += CntSpaces(script, index)				// ignore ��
				if ( peek(script, index) == '"' ) { index ++ }	// #module "modname" �̌`���ɑΉ�
				index += TookIdent(areaScope, script, index)	// ��Ԗ�
				swbreak
			case "global" : areaScope = AREA_GLOBAL : swbreak	// ���W���[����Ԃ���̒E�o
			
			case "modfunc"  : deftype  = DEFTYPE_MODULE
			case "deffunc"  : deftype |= DEFTYPE_FUNC                   : goto *L_AddDefinition
			case "modcfunc" : deftype  = DEFTYPE_MODULE
			case "defcfunc" : deftype |= DEFTYPE_FUNC   | DEFTYPE_CTYPE : goto *L_AddDefinition
			case "define"   : deftype  = DEFTYPE_MACRO                  : goto *L_AddDefinition
			case "const"
			case "enum"     : deftype  = DEFTYPE_CONST                  : goto *L_AddDefinition
*L_AddDefinition
				index += CntSpaces(script, index)			// �� ignore
				index += TookIdent(nowtk, script, index)	// ���ʎq�����o��
				switch getpath( nowtk, 16 )
					case "global" : bGlobal  = true          : goto *L_AddDefinition
					case "ctype"  : deftype |= DEFTYPE_CTYPE : goto *L_AddDefinition
					case "local"  : bGlobal  = false         : goto *L_AddDefinition
				swend
				
				index += TookModuleName(scope, script, index, areaScope)
				
				listIdent(count) = nowtk
				if ( count <= 0 ) {
					listLn(count) = GetLinenumByIndex(script, index, 0, 0)
				} else {
					listLn(count) = GetLinenumByIndex(script, index, listIndex(count - 1), listLn(count - 1))
				}
				listType (count) = deftype
				listScope(count) = cwhich( bGlobal, AREA_ALL, scope )
				listIndex(count) = index
				count ++
				swbreak
			swend
			
			poke nowtk
		}
		swbreak
		
	swend
	return
	
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
	
// �R���g���[����P������ɃX�N���[������( direction = SB_HORZ(=0) or SB_VERT(=1) )
#deffunc ScrollWindow int handle, int direction, int nPos
	dim scrollinfo, 8
	scrollinfo = 32, 0x04, 0, 0, 0, nPos
	SetScrollInfo handle, direction, varptr(scrollinfo), true
	sendmsg       handle, 0x0114 + direction, MAKELONG(4, nPos), handle
	return
	
#global

#endif
