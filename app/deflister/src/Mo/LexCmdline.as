// �R�}���h���C�����������́E��������

#ifndef __COMMANDLINE_LEXER_AS__
#define __COMMANDLINE_LEXER_AS__

#module mod_LexCmdline

#define true  1
#define false 0

#define success 1
#define failure 0

//------------------------------------------------
// �R�}���h���C�����������͂��A��������
//------------------------------------------------
#define global LexCmdline(%1=cmdopt@,%2=-1,%3=dir_cmdline) _LexCmdline %1,%2,%3
#deffunc _LexCmdline array cmdopt, int cntMax, str _cmdline,  local cmdline, local index, local c, local bInQuote, local cQuote, local cntOpt, local lenOpt, local iOptBegin
	
	if ( cntMax < 0 ) {
		sdim cmdopt, 320, 10
	} else {
		sdim cmdopt, 320, cntMax
	}
	
	if ( cntMax == 0 ) { return }
	
	cmdline   = _cmdline
	index     = 0
	bInQuote  = false
	cQuote    = 0
	cntOpt    = 0
	lenOpt    = 0
	iOptBegin = -1
	
	// ��������
	repeat
		c = peek(cmdline, index)
		
		// �I�[����
		if ( c == 0 ) {
			if ( lenOpt ) {
				gosub *LGetOption
			}
			break
			
		// ���p������ ( ���p���� cmdopt �Ɋ܂߂Ȃ� )
		} else : if ( c == '\'' || c == '"' ) {
			
			if ( bInQuote == false ) {		// ���p���̊J�n
			
				if ( iOptBegin < 0 ) { iOptBegin = index + 1 }
				bInQuote = true
				cQuote   = c
				
			} else : if ( cQuote == c ) {	// ���p���̏I��
				
				bInQuote = false
				cQuote   = 0
				
				gosub *LGetOption
				if ( stat == failure ) { break }
				
			} else {	// �֌W�Ȃ�����
				lenOpt ++
				/* */
			}
			
		// ���p���O�̋󔒔���
		} else : if ( c == ' ' && bInQuote == false ) {
			
			if ( lenOpt ) {
				
				gosub *LGetOption
				if ( stat == failure ) { break }
				
			} else {
				/* ���� */
			}
			
		// ���̑��̕���
		} else {
			if ( iOptBegin < 0 ) { iOptBegin = index }
			lenOpt ++
		}
		
		index ++
	loop
	
	return cntOpt
	
*LGetOption
	cmdopt( cntOpt ) = strmid( cmdline, iOptBegin, lenOpt )
	cntOpt ++
	lenOpt    = 0
	iOptBegin = -1
	
	if ( cntMax > 0 && cntOpt == cntMax ) {
		return failure
	}
	return success
	
//------------------------------------------------
// �����R�}���h���󂯎��
//------------------------------------------------
/*
#define global GetCmdline_Char(%1,%2,%3=dir_cmdline) _GetCmdline_Char
#deffunc _GetCmdline_Char var result_char, array result_str, str cmdline,  local cmdopt
	// �R�}���h���C�����
	LexCmdline cmdopt, , cmdline
	
	result_char = ""
	sdim result_str, , 1
	
	foreach cmdopt
		c = peek(cmdopt(cnt))
		switch ( c )
			// ��������
			case '+':
			case '-':
			case '/':
				getstr cmdopt(cnt), cmdopt(cnt), 1	// 2�����ڈȍ~
				result_char += cmdopt(cnt)
				swbreak
				
			// ���������
			default:
				result_str(length(result_str)) = cmdopt(cnt)
				swbreak
		swend
	loop
	
	return
	//*/
	
#global

#endif
