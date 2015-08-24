// HSP parse module - TookToken

#ifndef __HSP_PARSE_MODULE_TOOK_TOKEN_AS__
#define __HSP_PARSE_MODULE_TOOK_TOKEN_AS__

// ���ʎq���o�����W���[��
#module hpm_tookToken

#include "HPM_Header.as"

// �G�X�P�[�v�V�[�P���X�t���؂�o��
#define TEMP_TookTokenInEsqSec(%1,%2) /* p1 = �I�t�Z�b�g p2 = �I������ */\
	i = (%1) :\
	while :\
		c = peek(p1, p2 + i) : i ++ :\
		if ( c == '\\' || IsSJIS1st(c) ) {		/* �����m���ɏ������� */\
			i ++ :\
		}\
		if ( %2 ) { _break }/* �I�� */\
	wend :\
	return strmid(p1, p2, i)
	
// �����񂩕����萔��؂�o��
#defcfunc TookStr_or_Char var p1, int p2, int p3
	TEMP_TookTokenInEsqSec 1, ( c == p3 || IsNewLine(c) || c == 0 )
	
// �@�������؂�o���ĕԂ�
// �������萔��؂�o���ĕԂ�
#define global ctype TookStr(%1,%2=0) TookStr_or_Char(%1,%2,'"')
#define global ctype TookCharactor(%1,%2=0) TookStr_or_Char(%1,%2,'\'')

// �����s�������؂�o���ĕԂ�
#defcfunc TookStrMulti var p1, int p2
	TEMP_TookTokenInEsqSec 2, ( peek(p1, p2 + i - 2) == '"' && c == '}' || c == 0 )
	
// �͈͂̈Ⴄ�u�g�[�N���v��؂�o���ĕԂ�
#define TEMP_TookToken(%1) \
	i = p2 :\
	while :\
		c = peek(p1, i) :\
		if ((%1) == false) { _break } \
		i ++ :\
	wend :\
	return strmid(p1, p2, i - p2)
	
// ���ʎq��؂�o���ĕԂ�
#defcfunc TookName var p1, int p2
	TEMP_TookToken ( IsIdent(c) )
	
// 16�i����؂�o���ĕԂ�
#defcfunc TookNum_Hex var p1, int p2
	TEMP_TookToken ( IsHex(c) )
	
// 2�i����؂�o���ĕԂ�
#defcfunc TookNum_Bin var p1, int p2
	TEMP_TookToken ( IsBin(c) )
	
// 10�i����؂�o���ĕԂ�
#defcfunc TookNum_Dgt var p1, int p2
	TEMP_TookToken ( IsDigit(c) || c == '.' )
	
	
#global

#endif
