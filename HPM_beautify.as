#ifndef IG_HSP_PARSE_MODULE_BEAUTIFY_AS
#define IG_HSP_PARSE_MODULE_BEAUTIFY_AS

#include "Mo/HPM_getToken.as"
#include "Mo/MCLongString.as"
#include "Mo/strutil.as"

#module

#include "Mo/HPM_header.as"

#deffunc hpm_beautify var outbuf, str inbuf
	
	LongStr_new script
	sdim nowtk, 320
;	sdim beftk
	
	textlen = strlen(inbuf)
	sdim buf, textlen + 1
	buf     = inbuf			// �ϐ��Ɉړ�
	index   = 0
	bRet    = false
	nestPP  = 0				// �v���v���Z�b�T���߂̃l�X�g
	nest    = 1				// �l�X�g�̐[��
	
	nowTT = TKTYPE_NONE
	befTT = TKTYPE_NONE
	
	repeat
		gosub *L_SkipSpaces
		
		// �Ō�܂Ŏ擾������I������
		if ( index >= textlen ) { break }
		
		// ���̃g�[�N�����擾
		hpm_GetNextToken nowtk, buf, index, befTT, bPreLine : nowTT = stat
		if ( nowTT == TKTYPE_ERROR ) {
			bRet = true
			break
		}
		
		def_tklen = strlen(nowtk)
		tklen     = def_tklen
		
		// �g�[�N������������
		gosub *L_ProcToken
		
		// �X�V
		befTT = nowTT
		await 0
	loop
	
	// �߂�l�̐ݒ�
	if ( bRet == false ) {
		LongStr_tobuf script, outbuf
;		bsave "./_buffer_outbuf.html", outbuf, LongStr_len(script)
	}
	
	LongStr_delete script
	
	return bRet
	
// �󔒂��X�L�b�v����
*L_SkipSpaces
	n = CntSpaces(buf, index)
	c = peek(buf, index + n)	// ���̕���
	
	// �s���Ȃ�A�w�肳�ꂽ���̃l�X�g��t����
	if ( bNewLine ) {					// �O�����s�Ȃ�
		if ( c == '#' ) {
			; PREPROC �̂Ƃ���ŃC���f���g�������s��
			
		} else : if ( c == '*' ) {
			; label => ���������Ȃ�
			
		} else : if ( c == '/' || c == ';' ) {
			
			if ( n ) {
				LongStr_cat script, strmul("\t", nest), nest
			}
			
		} else {
			if ( c == '}' ) { nest -- }
			LongStr_cat script, strmul("\t", nest), nest		// �^�u�ŃC���f���g
			
		}
		bNewLine = false
		
	// �X�y�[�X�����t���O�������Ă���ꍇ
	} else : if ( bIgSpace ) {
		bIgSpace = false
		
	// ���̏ꍇ�́A�R�s�[���邾��
	// <TODO> ������R�����g�������낦��
	} else {
		if ( n ) {
			LongStr_cat script, strmid(buf, index, n), n
			logmes "[SpaceSkip] "+ n
		}
	}
	
	// �i�߂�
	index += n
	return
	
// �g�[�N�����Ƃɏ���������
*L_ProcToken
	switch nowTT
	
	case TKTYPE_END		// ���̏I��
		nowTT = TKTYPE_NONE
		if ( bPreLine ) { bPreLine = false }
		
		c = peek(nowtk)
		
		// ���s�Ȃ�
		if ( IsNewLine(c) ) {	// ���s�Ȃ�
			index   += tklen
			nowtk    = "\n"		// CR + LF �`���ɂ���
			tklen    = 2
			bNewline = true
			
		// ���̑��̋L���Ȃ�
		} else {
			// �u���b�N { } �Ȃ�
			if ( c == '{' ) {
				nest ++
			} else : if ( c == '}' && befTT != TKTYPE_NONE ) {
				nest --					// �s����������A���� -1 ����Ă���
			}
			gosub *L_SetSpacesBoth		// �O��ɋ󔒂��Z�b�g����
			index ++					// index ��i�߂�
		}
		gosub *L_DefaultWrite			// �W���̏�������
		swbreak
		
	case TKTYPE_COMMENT : nowTT = befTT : gosub *L_DefaultProc : swbreak
;	case TKTYPE_STRING  : swbreak
;	case TKTYPE_LABEL   : swbreak
	case TKTYPE_PREPROC
		if ( IsPreproc(nowtk) ) {
			bPreLine = true
			
			// # �Ǝ��ʎq�̊Ԃ̋󔒂��폜����( # ����菜�� )
			tklen  = strlen(nowtk)
			index += tklen
			nSpace = 1 + CntSpaces(nowtk, 1)
			nowtk  = strmid(nowtk, nSpace, tklen)
			tklen -= nSpace
			
			// ���������s���A# ��}������
			LongStr_cat script, strmul(" ", nestPP) +"#", nestPP + 1	// ���p�X�y�[�X�Ŏ�����
			
			// ��ނɂ���ĕ���
			switch nowtk
				case "if"
				case "ifdef"
				case "ifndef"
					nSpace = CntSpaces(buf, index)
					if ( wpeek(buf, index + nSpace) != MAKEWORD('_', '_') ) {
						nestPP ++
					}
					swbreak
					
				case "endif"
					LongStr_erase_back script, 2		// ' ' �� '#' ���폜
					LongStr_cat script, "#"
					nestPP --
					swbreak
					
				case "func"   : case "cfunc"
				case "define" : case "const" : case "enum"
					// �������ʎq�̋󔒂����낦��
					nSpace = CntSpaces(buf, index)
					index += nSpace
					nowtk += strmul(" ", 7 - tklen)
					tklen += limit(7 - tklen, 0, MAX_INT)
					
					// ���ɑ����X�y�[�X�𖳎�
					bIgSpaces = true
					swbreak
			swend
			
			// �W����������
			gosub *L_DefaultWrite
			
		} else {
			// �W���̑�����s��
			gosub *L_DefaultProc
		}
		swbreak
		
	case TKTYPE_NAME			// ���ʎq
		switch ( nowtk )
			case "repeat":
			case "while":
			case "for":
				nest ++
				swbreak
				
			case "loop":
			case "wend":
			case "next":
				LongStr_erase_back script, 1
				nest --
				swbreak
				
			case "switch":
				nest += 2
				swbreak
				
			case "swend":
				LongStr_erase_back script, 2
				nest -= 2
				swbreak
				
			case "case":
			case "default":
				LongStr_erase_back script, 1
				swbreak
				
		swend
		gosub *L_DefaultProc
		swbreak
		
	case TKTYPE_OPERATOR		// ���Z�q
		if ( nowtk == "->" ) {		// �O��ɋ󔒂��Z�b�g���Ȃ�
			;
		} else {
			gosub *L_SetSpacesBoth	// �O��ɋ󔒂��Z�b�g
		}
		gosub *L_DefaultProc		// �W������
		swbreak
		
	case TKTYPE_COMMA
		gosub *L_SetSpacesBehind	// ��낾���ɋ󔒂��Z�b�g����
		gosub *L_DefaultProc
		swbreak
		
	default
		gosub *L_DefaultProc
		swbreak
		
	swend
	return
	
// �W���̏���
*L_DefaultProc
	gosub *L_DefaultMove
	gosub *L_DefaultWrite
	return
	
// �ǂݍ��݃C���f�b�N�X��L�΂�
*L_DefaultMove
	index += def_tklen
	return
	
// �X�N���v�g�ɏ�������
*L_DefaultWrite
	LongStr_cat script, nowtk, tklen
	return
	
// �L���̑O��ɋ󔒂��Z�b�g����
*L_SetSpacesBoth
	gosub *L_SetSpacesBehind
	gosub *L_SetSpacesFront
	return
	
// �L���̌��ɋ󔒂��Z�b�g����
*L_SetSpacesBehind
	c = peek(buf, index + def_tklen)
	if ( IsBlank(c) == false && c != '"' ) { nowtk += " " : tklen ++ }
	return
	
// �L���̎�O�ɋ󔒂��Z�b�g����
*L_SetSpacesFront
	if ( index > 0 ) {
		c = peek(buf, index - 1)
		if ( IsBlank(c) == false && c != '"' ) { nowtk = " "+ nowtk : tklen ++ }
	}
	return
	
#global

#endif
