// ��������������N���X

#ifndef __MODULE_CLASS_LONG_STRING_AS__
#define __MODULE_CLASS_LONG_STRING_AS__

#module MCLongStr mString, mStrlen, mStrSize, mExpand

#define mv modvar MCLongStr@
#define DEFAULT_SIZE 3200

//------------------------------------------------
// �R���X�g���N�^
//------------------------------------------------
#modinit int p2, int p3, local defsize, local expandSize
	if ( p2 <= 0 ) { defsize = DEFAULT_SIZE } else { defsize = p2 }
	if ( p3 <= 0 ) { mExpand = DEFAULT_SIZE } else { mExpand = p3 }
	
	sdim mString, defsize
	mStrlen  = 0
	mStrSize = defsize
	return
	
//------------------------------------------------
// ��������N���A����
//------------------------------------------------
#modfunc LongStr_clear
	memset mString, 0, mStrlen
	mStrlen = 0
	return
	
//------------------------------------------------
// ����������ɒǉ�����
//------------------------------------------------
#modfunc LongStr_cat str p2, int p3
	if ( p3 ) { len = p3 } else { len = strlen(p2) }
	
	// overflow ���Ȃ��悤��
	if ( ( mStrSize - mStrLen ) <= len ) {	// ����Ȃ����
		mStrSize += len + mExpand
		memexpand mString, mStrSize			// �g������
	}
	
	// ��������
	poke mString, mStrlen, p2
	mStrlen += strsize
	return
	
//------------------------------------------------
// ��������֐��`���ŕԂ�( �񐄏� )
//------------------------------------------------
;#defcfunc LongStr_get mv
;	return mString
	
//------------------------------------------------
// ������̒�����Ԃ�
//------------------------------------------------
#defcfunc LongStr_len mv
	return mStrlen
	
//------------------------------------------------
// �������ϐ��o�b�t�@�ɃR�s�[����
//------------------------------------------------
#modfunc LongStr_tobuf var buf
	if ( vartype( buf ) != vartype("str") ) {
		sdim      buf, mStrlen + 1
	} else {
		memexpand buf, mStrlen + 1
	}
	memcpy buf, mString, mStrlen
	poke   buf, mStrlen, 0
	return
	
#global

#endif
