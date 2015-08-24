// ��������������N���X

#ifndef __MODULE_CLASS_LONG_STRING_AS__
#define __MODULE_CLASS_LONG_STRING_AS__

#module MCLongString mString, mStrlen, mStrSize, mExpand

#define mv modvar MCLongString@
#define DEFAULT_SIZE 3200

//------------------------------------------------
// [i] �R���X�g���N�^
//------------------------------------------------
#define global LongStr_new(%1,%2=-1,%3=-1) newmod %1, MCLongString@, %2, %3
#modinit int p2, int p3,  local defsize, local expandSize
	if ( p2 <= 0 ) { defsize = DEFAULT_SIZE } else { defsize = p2 }
	if ( p3 <= 0 ) { mExpand = DEFAULT_SIZE } else { mExpand = p3 }
	
	sdim mString, defsize
	mStrlen  = 0
	mStrSize = defsize
	return
	
//------------------------------------------------
// [i] �f�X�g���N�^
//------------------------------------------------
#define global LongStr_delete(%1) delmod %1

//------------------------------------------------
// [i] ������̒�����Ԃ�
//------------------------------------------------
#defcfunc LongStr_len mv
	return mStrlen
	
#define global LongStr_size LongStr_len
#define global LongStr_n    LongStr_len

//------------------------------------------------
// �m�ۍς݃o�b�t�@�̑傫����Ԃ�
//------------------------------------------------
#defcfunc LongStr_bufSize mv
	return mStrSize
	
//------------------------------------------------
// ����������ɒǉ�����
//------------------------------------------------
#modfunc LongStr_add str p2, int p3
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
	
#define global LongStr_cat       LongStr_add
#define global LongStr_push_back LongStr_add

//------------------------------------------------
// ��������֐��`���ŕԂ�( �񐄏� )
//------------------------------------------------
;#defcfunc LongStr_get mv
;	return mString
	
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
	
//------------------------------------------------
// [i] ������
//------------------------------------------------
#modfunc LongStr_clear
	memset mString, 0, mStrlen
	mStrlen = 0
	return
	
//------------------------------------------------
// [i] �A��
//------------------------------------------------
#modfunc LongStr_chain var mv_from,  local tmpbuf
	LongStr_tobuf mv_from, tmpbuf
	LongStr_add   thismod, tmpbuf
	return
	
//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc LongStr_copy var mv_from
	LongStr_clear thismod
	LongStr_chain thismod, mv_from
	return
	
//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc LongStr_exchange var mv2, local mvTemp
	LongStr_new  mvTemp
	LongStr_copy mvTemp,  thismod
	LongStr_copy thismod, mv2
	LongStr_copy mv2,     mvTemp
	LongStr_delete mvTemp
	return
	
//------------------------------------------------
// �������ݒ肷��
//------------------------------------------------
#modfunc LongStr_set str string
	LongStr_clear thismod
	LongStr_add   thismod, string
	return
	
#global

#endif
