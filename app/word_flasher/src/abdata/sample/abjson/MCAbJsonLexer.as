#ifndef IG_MODULECLASS_ABDATA_JSON_READER_AS
#define IG_MODULECLASS_ABDATA_JSON_READER_AS

// json �����͊�

#include "Mo/mod_array.as"
#include "Mo/strutil.as"

#module MCAbJsonLexer mSrc, tktype, tkstr, tklen, idx, cntToken, tktypelist, tkstrlist

#include "Mo/ctype.as"
#include "AbJson.header.as"

#define global abjsonLexer_new(%1,%2) newmod %1, MCAbJsonLexer@, %2
#define global abjsonLexer_delete(%1) delmod %1

//------------------------------------------------
// �\�z
//------------------------------------------------
#modinit str src
	mSrc = src
	mlen = strlen(mSrc)
	
	sdim tkstr
	dim tktype
	return
	
//------------------------------------------------
// ������
//------------------------------------------------
#modfunc abjsonLexer_Lex array tklist
	dim tktypelist
	sdim tkstrlist
	
	idx      = 0
	tktype   = TkType_None
	cntToken = 0
	
	repeat
		// �Ō�܂Ŏ擾������I������
		if ( mlen <= idx ) { break }
		
		// ���̃g�[�N�����擾
		abjsonLexer_Lex_GetNextToken thismod, tkstr, idx
		tktype = stat
		tklen  = strlen(tkstr)
		idx   += tklen
		
		// ���������g�[�N�� => ��΂�
		if ( tktype == TkType_Blank || tktype == TkType_Comment ) {
			continue
		}
		
		if ( tktype == TkType_Error ) {
			cntToken = -1
			break
		}
		
		dbgout( strf( "#%2d[%3d]: ( %2d, '%s' )", cnt, idx, tktype, tkstr ) )
		
		// �X�V
		tktypelist(cntToken) = tktype
		tkstrlist (cntToken) = tkstr
		cntToken ++
	loop
	
	tktypelist(cntToken) = TkType_Final
	tkstrlist (cntToken) = ""
	cntToken ++
	
#if _b_dbgout
	dbgout( "��������::���O" )
	repeat cntToken
		dbgout( strf("#%2d: (tktype, tkstr) = ( %2d, %s )", cnt, tktypelist(cnt), tkstrlist(cnt) ) )
	loop
#endif
	
	tklist = list_make(), list_make()
	repeat cntToken
		list_add tklist(0), tktypelist(cnt)
		list_add tklist(1), tkstrlist(cnt)
	loop
	
	return cntToken
	
//**********************************************************
//        ���ʎq�؂�o�� [static]
//**********************************************************
//------------------------------------------------
// �G�X�P�[�v�V�[�P���X�t���؂�o��
//------------------------------------------------
#define FTM_CutTokenInEsqSec(%1,%2,%3) /* %1 = �I�t�Z�b�g, %2 = �I������ */\
	i = (%1) :\
	repeat :\
		c = peek(sSrc, iOffset + i) : i ++ :\
		if ( c == '\\' || IsSJIS1st(c) ) {		/* �����m���ɏ������� */\
			i ++ :\
		}\
		if ( %2 ) { break }/* �I�� */\
	loop :\
	return strmid(sSrc, iOffset, i)
	
//------------------------------------------------
// �����񂩕����萔��؂�o��
//------------------------------------------------
#defcfunc CutStr_or_Char@MCAbJsonLexer var sSrc, int iOffset, int p3
	FTM_CutTokenInEsqSec 1, ( c == p3 || IsNewLine(c) || c == 0 )
	
//------------------------------------------------
// �������؂�o���ĕԂ�
//------------------------------------------------
#define ctype CutString(%1, %2 = 0) CutStr_or_Char( %1, %2, '"' )

//------------------------------------------------
// �͈͂̈Ⴄ�u�g�[�N���v��؂�o���ĕԂ�
//------------------------------------------------
#define FTM_CutToken(%1,%2=0) \
	i = iOffset :\
	repeat :\
		c = peek(sSrc, i) :\
		if ((%1) == false || c == 0) { break } \
		if (%2) { i ++ }\
		i ++ :\
	loop :\
	return strmid(sSrc, iOffset, i - iOffset)
	
//------------------------------------------------
// �󔒂�؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutBlank@MCAbJsonLexer var sSrc, int iOffset
	FTM_CutToken ( IsBlank(c) )
	
//------------------------------------------------
// ���ʎq��؂�o���ĕԂ�
//------------------------------------------------
#undef CutIdent			// @strutil
#defcfunc CutIdent@MCAbJsonLexer var sSrc, int iOffset
	FTM_CutToken ( IsIdent(c) || IsSJIS1st(c) ), IsSJIS1st(c)
	
//------------------------------------------------
// 10�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Dgt@MCAbJsonLexer var sSrc, int iOffset
	FTM_CutToken ( IsDigit(c) || c == '_' )
	
//**********************************************************
//        ������o��
//**********************************************************
//------------------------------------------------
// ���̃g�[�N�����擾����
//------------------------------------------------
#modfunc abjsonLexer_Lex_GetNextToken@MCAbJsonLexer var result, int idx_,  local restype
	idx = idx_
	c = peek(mSrc, idx)
	
	// �� (Blank)
	if ( IsBlank(c) ) {
		result = CutBlank(mSrc, idx)
		return TkType_Blank
	}
	
	// �L�� (Sign)
	switch ( c )
		case '(': result = "(" : return TkType_ParenL
		case ')': result = ")" : return TkType_ParenR
		case '[': result = "[" : return TkType_BrkArrL
		case ']': result = "]" : return TkType_BrkArrR
		case '{': result = "{" : return TkType_BrkObjL
		case '}': result = "}" : return TkType_BrkObjR
		case ':': result = ":" : return TkType_Colon
		case ',': result = "," : return TkType_Comma
		case '.': result = "." : return TkType_Period
	swend
	
	// ������ (Digit)
	if ( IsDigit(c) ) {
		restype = TkType_Digit
		result  = CutNum_Dgt(mSrc, idx)
		len     = strlen(result)
		c       = peek(mSrc, idx + len)
		
		// ������ (Frac)
		if ( c == '.' ) {
			c2 = peek(mSrc, idx + len + 1)
			if ( IsDigit(c2) ) {
				result += "." + CutNum_Dgt(mSrc, idx + len + 1)
				len     = strlen(result)
				c       = peek(mSrc, idx + len)
				restype = TkType_Number
			}
		}
		
		// �w���� (Exp)
		if ( c == 'e' || c == 'E' ) {
			c2 = peek(mSrc, idx + len + 1)
			if ( c2 == '+' || c2 == '-' || IsDigit(c2) ) {
				if ( IsDigit(c2) ) {
					result += "e" + CutNum_Dgt(mSrc, idx + len + 1)
				} else {
					result += strf("e%c%s", c2, CutNum_Dgt(mSrc, idx + len + 2))
				}
				restype = TkType_Number
			}
		}
		
		return restype
	}
	
	// ���ʎq (Identifier)
	if ( IsIdentTop(c) || IsSJIS1st(c) ) {
		result = CutIdent(mSrc, idx)
		return TkType_Ident
	}
	
	// ������萔 (Single-line String Literal)
	if ( c == '\"' ) {
		result = CutString(mSrc, idx)			// ����������o�� (""���܂�)
		return TkType_String
	}
	
	// ��ȏꍇ
/*
	if ( isSJIS1st(c) ) {
		logmes "ERROR! SJIS code!"
		wpoke result, 0, wpeek(mSrc, idx)	// ��������
		poke  result, 3, NULL
		return TkType_Error
	}
	
	// �H�H�H
	result = strf("%c", c)
	logmes "ERROR !! Can't Pop a Token! [ " + index + strf(" : %c : ", c) + c + " ]"
//*/
	return TkType_Error
	
#global

#endif
