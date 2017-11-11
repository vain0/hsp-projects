#ifndef __NOTE_CONVERTER_AS__
#define __NOTE_CONVERTER_AS__

#include "Mo/MCLongString.as"

#module notecnv_mod

//------------------------------------------------
// ������^�z��ϐ� �� �����s������ �ɕϊ�
//------------------------------------------------
#deffunc AryToNote var prmRet, array prmStr,  local ls
	LongStr_new ls
	
	foreach prmStr
		LongStr_add ls, prmStr(cnt) +"\n"
	loop
	
	LongStr_tobuf ls, prmRet
	wpoke prmRet, LongStr_length(ls) - 2, 0	// �Ō��2byte(CRLF)���폜
	
	LongStr_delete ls
	return
	
//------------------------------------------------
// �����s������ �� ������^�z��ϐ� �ɕϊ�
//------------------------------------------------
#deffunc NoteToAry array prmRet, str prmNote
	
	sBuf   = prmNote		// ��U�ϐ��Ɉڂ�
	iIndex = 0
	iLen   = strlen(sBuf)	// �S�̂̒���
	
	if ( iLen <= 0 ) {		// �ُ픭��
		return
	}
	
	// �Ōオ���s���ǂ����𒲂ׂ�
	cLast = peek(sBuf, iLen - 1)			// �Ō�̕����̕����R�[�h
	if ( peek(sBuf, iLen - 2) == 0x0D && cLast == 0x0A ) {
		// CRLF
		wpoke sBuf, iLen - 2, 0
		iLen -= 2
		
	} else : if ( cLast == 0x0D || cLast == 0x0A ) {
		// CR �� LF
		poke sBuf, iLen - 1, 0
		iLen --
		
	}
	
	// sBuf ���������m�[�g�ɂ���
	notesel sBuf
	sdim prmRet, , noteinfo()		// �s�����m��
	
	repeat noteinfo()
		
		// ��s���i�[���Ă���
		getstr prmRet(cnt), sBuf, iIndex
		iIndex += strsize
		
	loop
	
	noteunsel
	
	sdim sBuf, 0
	return
	
#global

#endif
