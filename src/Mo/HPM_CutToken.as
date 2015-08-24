// HSP parse module - CutToken

#ifndef __HSP_PARSE_MODULE_CUT_TOKEN_AS__
#define __HSP_PARSE_MODULE_CUT_TOKEN_AS__

//##############################################################################
//                識別子切り出しモジュール
//##############################################################################
#module hpm_cutToken

#include "HPM_Header.as"

//------------------------------------------------
// エスケープシーケンス付き切り出し
//------------------------------------------------
#define TEMP_CutTokenInEsqSec(%1,%2) /* p1 = オフセット p2 = 終了条件 */\
	i = (%1) :\
	repeat :\
		c = peek(p1, p2 + i) : i ++ :\
		if ( c == '\\' || IsSJIS1st(c) ) {		/* 次も確実に書き込む */\
			i ++ :\
		}\
		if ( %2 ) { break }/* 終了 */\
	loop :\
	return strmid(p1, p2, i)
	
//------------------------------------------------
// 文字列か文字定数を切り出す
//------------------------------------------------
#defcfunc CutStr_or_Char var p1, int p2, int p3
	TEMP_CutTokenInEsqSec 1, ( c == p3 || IsNewLine(c) || c == 0 )
	
//------------------------------------------------
// 　文字列を切り出して返す
// ＆文字定数を切り出して返す
//------------------------------------------------
#define global ctype CutStr(%1,%2=0) CutStr_or_Char(%1,%2,'"')
#define global ctype CutCharactor(%1,%2=0) CutStr_or_Char(%1,%2,'\'')

//------------------------------------------------
// 複数行文字列を切り出して返す
//------------------------------------------------
#defcfunc CutStrMulti var p1, int p2
	TEMP_CutTokenInEsqSec 2, ( peek(p1, p2 + i - 2) == '"' && c == '}' || c == 0 )
	
//------------------------------------------------
// 範囲の違う「トークン」を切り出して返す
//------------------------------------------------
#define TEMP_CutToken(%1,%2=0) \
	i = p2 :\
	repeat :\
		c = peek(p1, i) :\
		if ((%1) == false || c == 0) { break } \
		if (%2) { i ++ }\
		i ++ :\
	loop :\
	return strmid(p1, p2, i - p2)
	
//------------------------------------------------
// 識別子を切り出して返す
//------------------------------------------------
#defcfunc CutName var p1, int p2
	TEMP_CutToken ( IsIdent(c) || IsSJIS1st(c) || c == '`' ), IsSJIS1st(c)
	
//------------------------------------------------
// 16進数を切り出して返す
//------------------------------------------------
#defcfunc CutNum_Hex var p1, int p2
	TEMP_CutToken ( IsHex(c) )
	
//------------------------------------------------
// 2進数を切り出して返す
//------------------------------------------------
#defcfunc CutNum_Bin var p1, int p2
	TEMP_CutToken ( IsBin(c) )
	
//------------------------------------------------
// 10進数を切り出して返す
//------------------------------------------------
#defcfunc CutNum_Dgt var p1, int p2
	TEMP_CutToken ( IsDigit(c) || c == '.' )
	
#global

#endif
