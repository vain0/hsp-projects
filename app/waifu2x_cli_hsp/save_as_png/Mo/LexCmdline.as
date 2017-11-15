// �R�}���h���C�����������́E��������

#ifndef IG_COMMANDLINE_LEXER_AS
#define IG_COMMANDLINE_LEXER_AS

#module mod_LexCmdline

#define true  1
#define false 0

#define success 1
#define failure 0

//------------------------------------------------
// �R�}���h���C�����������͂��A��������
//------------------------------------------------
#define global LexCmdline(%1=argv@,%2=-1,%3=dir_cmdline) _LexCmdline %1,%2,%3
#deffunc _LexCmdline array argv, int cntMax, str _cmdline,  local cmdline, local index, local c, local bInQuote, local cQuote, local cntArg, local lenOpt, local iOptBegin
	
	if ( cntMax < 0 ) {
		sdim argv, 320, 10
	} else {
		sdim argv, 320, cntMax
	}
	
	if ( cntMax == 0 ) { return }
	
	cmdline   = _cmdline
	index     = 0
	bInQuote  = false
	cQuote    = 0
	cntArg    = 0
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
			
		// ���p������ ( ���p���� argv �Ɋ܂߂Ȃ� )
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
		} else : if ( (c == ' ' || c == '\t') && bInQuote == false ) {
			
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
	
	return cntArg
	
*LGetOption
	argv( cntArg ) = strmid( cmdline, iOptBegin, lenOpt )
	cntArg ++
	lenOpt    = 0
	iOptBegin = -1
	
	if ( cntMax > 0 && cntArg == cntMax ) {
		return failure
	}
	return success
	
//------------------------------------------------
// �����R�}���h���󂯎��
//------------------------------------------------
/*
#define global GetCmdline_Char(%1,%2,%3=dir_cmdline) _GetCmdline_Char
#deffunc _GetCmdline_Char var result_char, array result_str, str cmdline,  local argv
	// �R�}���h���C�����
	LexCmdline argv, , cmdline
	
	result_char = ""
	sdim result_str, , 1
	
	foreach argv
		c = peek(argv(cnt))
		switch ( c )
			// ��������
			case '+':
			case '-':
			case '/':
				getstr argv(cnt), argv(cnt), 1	// 2�����ڈȍ~
				result_char += argv(cnt)
				swbreak
				
			// ���������
			default:
				result_str(length(result_str)) = argv(cnt)
				swbreak
		swend
	loop
	
	return
	//*/
	
#global

#if 0
	
	cmdline = "  'fileA fileB' fileC "
	LexCmdline argv, 3, cmdline
	
	foreach argv
		mes strf( "(%d) %s", cnt, argv(cnt) )
	loop
	stop
	
#endif

#endif
