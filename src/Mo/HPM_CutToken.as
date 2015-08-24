// HSP parse module - CutToken

#ifndef __HSP_PARSE_MODULE_CUT_TOKEN_AS__
#define __HSP_PARSE_MODULE_CUT_TOKEN_AS__

//##############################################################################
//                ���ʎq�؂�o�����W���[��
//##############################################################################
#module hpm_cutToken

#include "HPM_Header.as"

//------------------------------------------------
// �G�X�P�[�v�V�[�P���X�t���؂�o��
//------------------------------------------------
#define TEMP_CutTokenInEsqSec(%1,%2) /* p1 = �I�t�Z�b�g p2 = �I������ */\
	i = (%1) :\
	repeat :\
		c = peek(p1, p2 + i) : i ++ :\
		if ( c == '\\' || IsSJIS1st(c) ) {		/* �����m���ɏ������� */\
			i ++ :\
		}\
		if ( %2 ) { break }/* �I�� */\
	loop :\
	return strmid(p1, p2, i)
	
//------------------------------------------------
// �����񂩕����萔��؂�o��
//------------------------------------------------
#defcfunc CutStr_or_Char var p1, int p2, int p3
	TEMP_CutTokenInEsqSec 1, ( c == p3 || IsNewLine(c) || c == 0 )
	
//------------------------------------------------
// �@�������؂�o���ĕԂ�
// �������萔��؂�o���ĕԂ�
//------------------------------------------------
#define global ctype CutStr(%1,%2=0) CutStr_or_Char(%1,%2,'"')
#define global ctype CutCharactor(%1,%2=0) CutStr_or_Char(%1,%2,'\'')

//------------------------------------------------
// �����s�������؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutStrMulti var p1, int p2
	TEMP_CutTokenInEsqSec 2, ( peek(p1, p2 + i - 2) == '"' && c == '}' || c == 0 )
	
//------------------------------------------------
// �͈͂̈Ⴄ�u�g�[�N���v��؂�o���ĕԂ�
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
// ���ʎq��؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutName var p1, int p2
	TEMP_CutToken ( IsIdent(c) || IsSJIS1st(c) || c == '`' ), IsSJIS1st(c)
	
//------------------------------------------------
// 16�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Hex var p1, int p2
	TEMP_CutToken ( IsHex(c) )
	
//------------------------------------------------
// 2�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Bin var p1, int p2
	TEMP_CutToken ( IsBin(c) )
	
//------------------------------------------------
// 10�i����؂�o���ĕԂ�
//------------------------------------------------
#defcfunc CutNum_Dgt var p1, int p2
	TEMP_CutToken ( IsDigit(c) || c == '.' )
	
#global

#endif
