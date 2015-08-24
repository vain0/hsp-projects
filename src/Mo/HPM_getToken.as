// HSP parse module - GetToken

#ifndef __HSP_PARSE_MODULE_GET_TOKEN_AS__
#define __HSP_PARSE_MODULE_GET_TOKEN_AS__

#include "HPM_CutToken.as"	// ���ʎq���o��
#include "HPM_Sub.as"		// ���W���[��

// ��v���W���[��
#module hpm_getToken

#include "HPM_Header.as"

#uselib "user32.dll"
#func   _ChrLow "CharLowerA" int

//------------------------------------------------
// �}�N��
//------------------------------------------------
#define ctype IsWOp(%1) ((%1) == '<' || (%1) == '=' || (%1) == '>' || (%1) == '&' || (%1) == '|' || (%1) == '+' || (%1) == '-')

#define NULL 0

//------------------------------------------------
// ���̃g�[�N�����擾����
//------------------------------------------------
#deffunc GetNextToken var p1, var p2, int p3, int p_befTT, int bPreLine
	c = peek(p2, p3)
	
	// Name (���ʎq)
	if ( IsIdentTop(c) || c == '`' || IsSJIS1st(c) ) {
		p1 = CutName(p2, p3)
		return TOKENTYPE_NAME
	}
	
	// Preprocessor
	if ( c == '#' ) {
		iFound = 1 + CntSpaces(p2, p3 + 1)		// ��
		p1     = strmid(p2, p3, iFound) + CutName(p2, p3 + iFound)
		return TOKENTYPE_PREPROC
	}
	
	// String
	if ( c == '"' ) {
		p1 = CutStr(p2, p3)		// ����������o�� (""���܂�)
		return TOKENTYPE_STRING
	}
	if ( wpeek(p2, p3) == 0x227B ) {	// {"
		p1 = CutStrMulti(p2, p3)		// �����s����������o�� ({" "} �܂�)
		return TOKENTYPE_STRING
	}
	
	// �I���L��
	if ( c == ':' || c == '{' || c == '}' || IsNewLine(c) ) {
		p1 = strf("%c", c)
		if ( c == 0x0D ) {		// CRLF
			if ( peek(p2, p3 + 1) == 0x0A ) {
				p1 = "\n"
			}
		} else : if ( c == 0x0A ) {
			p1 = "\r"
		}
		return TOKENTYPE_END
	}
	
	// Sign
	if ( c == ',' ) { p1 = "," : return TOKENTYPE_CAMMA    }
	if ( c == '(' ) { p1 = "(" : return TOKENTYPE_CIRCLE_L }
	if ( c == ')' ) { p1 = ")" : return TOKENTYPE_CIRCLE_R }
	if ( c == '.' ) { p1 = "." : return TOKENTYPE_PERIOD   }
	
	// Label ( * ����n�܂�A�����A���̏I�[�A�J���}�A')' �̂����̂ǂꂩ�̂Ƃ� )
	if ( c == '*' ) {
		// ���x�����H
		if ( IsLabel(p2, p3, p_befTT, bPreline) ) {
			c2 = peek(p2, p3 + 1)
			if ( c2 == '@' ) {
				p1 = "*@"+ CutName(p2, p3 + 2)	// *@ �̌�͍D���Ȃ������o��
			} else : if ( c2 == '%' ) {			// *%
				p1 = "*%"+ CutName(p2, p3 + 2)
			} else {
				p1 = "*"+ CutName(p2, p3 + 1)	// �؂�o��
			}
			return TOKENTYPE_LABEL
		}
	}
	
	// Comment
	if ( c == ';' || wpeek(p2, p3) == 0x2F2F ) {
		getstr p1, p2, p3			// ���s�܂Ŏ��o��
		return TOKENTYPE_COMMENT
	}
	
	// Comment (multi)
	if ( wpeek(p2, p3) == 0x2A2F ) {
		iFound = instr(p2, p3 + 2, "*/")
		if ( iFound < 0 ) {
			p1 = strmid(p2, p3, strlen(p2) - p3)	// �ȍ~���ׂăR�����g
		} else {
			p1 = strmid(p2, p3, iFound + 4)			// �J�n�E�I�����܂�
		}
		return TOKENTYPE_COMMENT
	}
	
	// Operator
	if ( IsOperator(c) ) {							// ���Z�q���H
		
		// 2 �o�C�g�̉��Z�q�̎�������
		c2 = peek(p2, p3 + 1)
		if ( c2 == '=' || (IsWOp(c) && c == c2) ) {	// ?= ���A&& || �Ȃǂ̓�d
			p1 = strmid(p2, p3, 2)		// 2 byte
		} else {
			wpoke p1,, c				// 1 byte
		}
		if ( c == '\\' && bPreLine ) {	// ���s����̉\��
			if ( IsNewLine(c2) ) {
				if ( c2 == 0x0D && peek(p2, p3 + 2) == 0x0A ) {
					lpoke p1,, MAKELONG2('\\', 0x0D, 0x0A, 0)	// "\\\n"
				} else {
					lpoke p1,, MAKEWORD('\\', c2)
				}
				return TOKENTYPE_ESC_LINEFEED
			}
		}
		return TOKENTYPE_OPERATOR
	}
	
	// Char
	if ( c == '\'' ) {
		p1 = CutCharactor(p2, p3)
		return TOKENTYPE_CHAR
	}
	
	// Number (2 or 16)
	if ( c == '$' ) {
		p1 = "$"+ CutNum_Hex(p2, p3 + 1)
		return TOKENTYPE_NUMBER
	}
	if ( c == '%' ) {
		c2 = peek(p2, p3 + 1)
		
		if ( bPreLine ) {
			// ��i���\�L
			if ( c2 == '%' && IsBin(peek(p2, p3 + 2)) ) {
				p1 = "%"+ CutNum_Bin(p2, p3 + 1)
				return TOKENTYPE_NUMBER
				
			} else : if ( IsDigit(c2) ) {		// �}�N������
				p1 = "%"+ CutNum_Dgt(p2, p3 + 1)
				return TOKENTYPE_MACRO_PRM
				
			} else : if ( IsAlpha(c2) ) {		// ����W�J�}�N��
				p1 = "%"+ CutName(p2, p3 + 1)
				return TOKENTYPE_MACRO_SP
			}
		}
		
		// ��i���\�L
		if ( IsBin(c2) ) {
			p1 = "%"+ CutNum_Bin(p2, p3 + 1)
			return TOKENTYPE_NUMBER
		} else {
			goto *LGotUnknownToken
		}
	}
	
	if ( c == '0' ) {
		c2 = peek(p2, p3 + 1)
		if ( c2 == 'x' || c2 == 'X' ) {
			p1 = strmid(p2, p3, 2) + CutNum_Hex(p2, p3 + 2)
			
		} else : if ( c2 == 'b' || c2 == 'B' ) {
			p1 = strmid(p2, p3, 2) + CutNum_Bin(p2, p3 + 2)
			
		} else {
			p1 = CutNum_Dgt(p2, p3)
		}
		return TOKENTYPE_NUMBER
	}
	
	// Number (10)
	if ( IsDigit(c) || c == '.' ) {
		p1 = CutNum_Dgt(p2, p3)		// 10�i��
		return TOKENTYPE_NUMBER
	}
	
	// @Scope
	if ( c == '@' ) {
		p1 = "@"+ CutName(p2, p3 + 1)
		return TOKENTYPE_SCOPE
	}
	
	// ��ȏꍇ
*LGotUnknownToken
	if ( IsSJIS1st(c) ) {
		logmes "ERROR! SJIS code!"
		wpoke p1, 0, wpeek(p2, p3)	// ��������
		poke  p1, 3, NULL
		return TOKENTYPE_ERROR
	}
	
	// �H�H�H
	p1 = strf("%c", c)
	logmes "ERROR !! Can't Pop a Token! [ "+ p3 + strf(" : %c : ", c) + c +" ]"
	return TOKENTYPE_ERROR
	
#global

#endif
