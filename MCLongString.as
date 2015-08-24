// ��������������N���X

#ifndef IG_MODULE_CLASS_LONG_STRING_AS
#define IG_MODULE_CLASS_LONG_STRING_AS

#module MCLongString mString, mStrlen, mCapacity, mExpand

#define BufSize_Default 4096

// @ ��̃o�b�t�@���A�K�X�L���Ȃ��炽������̕������m�ۂ���B

//------------------------------------------------
// [i] �\�z
//------------------------------------------------
#define global LongStr_new(%1, %2 = -1, %3 = -1) newmod %1, MCLongString@, %2, %3
#modinit int p2, int p3,  local defsize, local expandSize
	if ( p2 <= 0 ) { defsize = BufSize_Default } else { defsize = p2 }
	if ( p3 <= 0 ) { mExpand = BufSize_Default } else { mExpand = p3 }
	
	mStrlen = 0
	mCapacity = defsize
	sdim mString, mCapacity
	return
	
//------------------------------------------------
// [i] ���
//------------------------------------------------
#define global LongStr_delete(%1) delmod %1

//##########################################################
//        ���J���\�b�h
//##########################################################
//------------------------------------------------
// �������ݒ肷��
//------------------------------------------------
#modfunc LongStr_set str string
	LongStr_clear thismod
	LongStr_add   thismod, string
	return
	
//------------------------------------------------
// ����������ɒǉ�����
//------------------------------------------------
#modfunc LongStr_add str src, int _lenToAppend
	// local tmpLen
	if ( _lenToAppend ) { tmpLen = _lenToAppend } else { tmpLen = strlen(src) }
//*
	// overflow ���Ȃ��悤��
	if ( mCapacity <= mStrlen + tmpLen ) {
		LongStr_expand thismod, tmpLen
	}
	
	// �������� (poke ���� src �� strlen ���镪���ʂ�����)
	poke mString, mStrlen, src
	mStrlen += strsize
	assert (strsize == tmpLen)
/*/
	mref tmpSrcPtr, 3	// �����p�Fsrc �ւ̃|�C���^�𓾂�
	dupptr tmpSrc, tmpSrcPtr, tmpLen + 1, 2
	LongStr_addv thismod, tmpSrc, tmpLen
//*/
	return
	
#modfunc LongStr_addv var src, int _lenToAppend
	if ( _lenToAppend ) { tmpLen = _lenToAppend } else { tmpLen = strlen(src) }
	
	if ( mCapacity <= mStrlen + tmpLen ) {
		LongStr_expand thismod, tmpLen
	}
	
	// �������� ('\0' ���܂߂�)
	memcpy mString, src, tmpLen + 1, mStrlen
	mStrlen += tmpLen
	return
	
#define global LongStr_cat       LongStr_add
#define global LongStr_push_back LongStr_add

// �Ō�ɒǉ����ꂽ������̒���
#defcfunc LongStr_lengthLastAddition
	return tmpLen

//------------------------------------------------
// ������A������
//------------------------------------------------
#modfunc LongStr_addchar int c
	if ( c == 0 ) { return }
	
	// over-flow ���Ȃ��悤��
	if ( mCapacity <= mStrlen + 1 ) {
		LongStr_expand thismod, 1
	}
	
	// ��������
	wpoke mString, mStrlen, c
	mStrlen ++
	return
	
//------------------------------------------------
// ���������납����
//------------------------------------------------
#modfunc LongStr_erase_back int sizeErase
	if ( sizeErase <= 0 ) { return }
	
	mStrlen -= sizeErase
	if ( mStrlen < 0 ) { mStrlen = 0 }
	
	// �I�[������u��
	poke mString, mStrlen, 0
	
	return
	
//------------------------------------------------
// �o�b�t�@���m�ۂ���
//------------------------------------------------
#modfunc LongStr_reserve int size
	if ( mCapacity < size ) {
		mCapacity = size + mExpand
		memexpand mString, mCapacity
	}
	return
	
#modfunc LongStr_expand int size
	mCapacity += size + mExpand
	memexpand mString, mCapacity
	return
	
//------------------------------------------------
// �������ϐ��o�b�t�@�ɕ��ʂ���
//------------------------------------------------
#modfunc LongStr_tobuf var buf
	if ( vartype( buf ) != vartype("str") ) {
		sdim      buf, mStrlen + 1
	} else {
		memexpand buf, mStrlen + 1
	}
	memcpy buf, mString, mStrlen + 1
	return
	
//------------------------------------------------
// [i] ������̒�����Ԃ�
//------------------------------------------------
#modcfunc LongStr_length
	return mStrlen
	
#define global LongStr_empty LongStr_length
#define global LongStr_size  LongStr_length
#define global LongStr_count LongStr_length

//------------------------------------------------
// �m�ۍς݃o�b�t�@�̑傫����Ԃ�
//------------------------------------------------
#modcfunc LongStr_bufSize
	return mCapacity
	
//------------------------------------------------
// ��������֐��`���ŕԂ�(�񐄏�)
//------------------------------------------------
#modcfunc LongStr_get
	return mString
	
#modcfunc LongStr_dataPtr
	return varptr(mString)
	
#modfunc longstr_dup var s
	dup s, mString
	return
	
//------------------------------------------------
// [i] ������
//------------------------------------------------
#modfunc LongStr_clear
;	memset mString, 0, mStrlen
	poke mString
	mStrlen = 0
	return
	
//------------------------------------------------
// [i] �A��
//------------------------------------------------
#modfunc LongStr_chain var mv_from,  local data, local len
	len = LongStr_length(mv_from)
	dupptr data, LongStr_dataPtr(mv_from), len + 1, vartype("str")
	LongStr_addv thismod, data, len
	return
	
//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc LongStr_copy var mv_from
	LongStr_clear thismod
	LongStr_chain thismod, mv_from
	return
	
//------------------------------------------------
// [i] �R���e�i����
//------------------------------------------------
#modfunc LongStr_exchange var mv2, local mvTemp
	LongStr_new  mvTemp
	LongStr_copy mvTemp,  thismod
	LongStr_copy thismod, mv2
	LongStr_copy mv2,     mvTemp
	LongStr_delete mvTemp
	return
	
#global

#endif
