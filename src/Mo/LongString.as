// Long String Module

#ifndef __LONG_STRING_MODULE_AS__
#define __LONG_STRING_MODULE_AS__

#module longstr mString, mStrlen, mStrSize

// �R���X�g���N�^
#modinit
	sdim mString, 6400
	mStrlen  = 0
	mStrSize = 6400
	return
	
// ����������ɒǉ�����
#modfunc LongStr_cat str p2, int p3
	if ( p3 ) { len = p3 } else { len = strlen(p2) }
	
	// overflow ���Ȃ��悤��
	if ( ( mStrSize - mStrLen) <= len ) {	// ����Ȃ����
		mStrSize += len + 6400
		memexpand mString, mStrSize			// �g������
	}
	
	// ��������
	poke mString, mStrlen, p2
	mStrlen += strsize
	return
	
// ��������֐��`���ŕԂ�
#defcfunc LongStr_get modvar longstr@
	return mString
	
// ������̒�����Ԃ�
#defcfunc LongStr_len modvar longstr@
	return mStrlen
	
// �������ϐ��o�b�t�@�ɃR�s�[����
#modfunc LongStr_tobuf var buf
	memexpand buf, mStrlen + 1
	memcpy    buf, mString, mStrlen
	poke      buf, mStrlen, 0
	return
	
#global

#endif
