// �o�����A�����X�g - �z��
// Double linked list (circularly)

#ifndef IG_ABSTRACT_DATA_STRUCTURE_DOUBLE_LINKED_LIST_AS
#define IG_ABSTRACT_DATA_STRUCTURE_DOUBLE_LINKED_LIST_AS

#include "dlinkvalue.as"

//##############################################################################
//                  Double Linked List
//##############################################################################
#module abdata_dlinklist mValue, mCntValue, mTop, mLast, mIter_v, mIter_c, mbIterStart

#define mIter mIter_v(mIter_c)

#define VAR_TEMP stt_temp@abdata_dlinklist

#define global DLList_IterDataType 4

// @ ���ׂĂ̒l�̓����o mValue ���Ǘ��B
// @ �v�f�̏��Ԃ́ADLValue �̎������N�ő��삷��B

//##########################################################
//        �\�z�E���
//##########################################################
#define global DLList_new(%1)    newmod %1, abdata_dlinklist@
#define global DLList_delete(%1) delmod %1

//------------------------------------------------
// [i] �\�z
//------------------------------------------------
#modinit
	DLList_clear thismod
	return
	
//------------------------------------------------
// [i] ���
//------------------------------------------------

//##########################################################
//        �����q����n
//##########################################################
//------------------------------------------------
// �擪�Ɉړ�
//------------------------------------------------
#modfunc DLList_goTop
	mIter = mTop
	return
	
//------------------------------------------------
// �I�[�Ɉړ�
//------------------------------------------------
#modfunc DLList_goLast
	mIter = mLast
	return
	
//------------------------------------------------
// �����q�� p2 �߂�
//------------------------------------------------
#modfunc DLList_back int p2
	repeat p2 : mIter = DLV_getPrev( mValue(mIter) ) : loop
	return
	
//------------------------------------------------
// �����q�� p2 �i�߂�
//------------------------------------------------
#modfunc DLList_skip int p2
	repeat p2 : mIter = DLV_getNext( mValue(mIter) ) : loop
	return
	
//------------------------------------------------
// p2 �Ԗڂ̗v�f�Ɉړ�����
//------------------------------------------------
#modfunc DLList_jump int p2
	mIter = DLList_followLink(thismod, p2)
	return
	
//------------------------------------------------
// �����q�̏�����
//------------------------------------------------
#modfunc DLList_iterClear
	mIter       = mTop
	mbIterStart = true
	if ( mCntValue == 0 ) { mbIterStart = 0 }
	return
	
//------------------------------------------------
// �����q�X�^�b�N�� push
//------------------------------------------------
#modfunc DLList_iterNew
	mIter_c          ++			// �J�E���g�𑝉�
	DLList_iterClear thismod	// �K�؂ɏ���������
	return
	
//------------------------------------------------
// �����q�X�^�b�N�� pop
//------------------------------------------------
#modfunc DLList_iterDelete
	if ( mIter_c > 0 ) {
		mIter_c --
	}
	return
	
//------------------------------------------------
// �����q�̍X�V ( while �̏����Ɏg�� )
//------------------------------------------------
#modcfunc DLList_iterCheck var vIt
	if ( mIter == mTop ) {
		if ( mbIterStart ) {
			mbIterStart = false
		} else {
			DLList_iterDelete thismod
			return false		// �������
		}
	}
	
	DLV_dup mValue(mIter), vIt				// ���w���Ă���ꏊ���擾
	mIter = DLV_getNext( mValue(mIter) )	// �����w�肷��
	return true
	
//------------------------------------------------
// �擪�ɂ��邩�H
//------------------------------------------------
#modcfunc DLList_iterIsTop
	return mIter == mTop
	
//------------------------------------------------
// �I�[�ɂ��邩�H
//------------------------------------------------
#modcfunc DLList_iterIsLast
	return mIter == mLast
	
//------------------------------------------------
// [i] �����q������
//------------------------------------------------
#modfunc DLList_iterInit var iterData
	DLList_iterNew thismod
	return
	
//------------------------------------------------
// [i] �����q�X�V
//------------------------------------------------
#modcfunc DLList_iterNext var vIt, var iterData
	return DLList_iterCheck(thismod, vIt)
	
//##########################################################
//        ���ڎ擾�n
//##########################################################
//------------------------------------------------
// ���̗v�f���擾����
//------------------------------------------------
#define global DLList_getNext(%1,%2)  DLList_getSeq %1,%2,1,0
#define global DLList_peekNext(%1,%2) DLList_getSeq %1,%2,0,0

#define global ctype DLList_getNextf(%1)  DLList_getSeqf(%1,1)
#define global ctype DLList_peekNextf(%1) DLList_getSeqf(%1,0)

#define global DLList_dupNext(%1,%2,%3=1)  DLList_getSeq %1,%2,%3,1
#define global DLList_dupValue(%1,%2,%3=0) DLList_getv   %1,%2,%3,1

//------------------------------------------------
// Sequential Access ���ߌ`��
//------------------------------------------------
#modfunc DLList_getSeq var vResult, int bMove, int bDup
	if ( bDup == 0 ) {
		DLV_getv mValue(mIter), vResult
	} else {
		DLV_dup mValue(mIter), vResult
	}
	if ( bMove ) {
		DLList_skip thismod, 1		// ���Ɉړ�����
	}
	return
	
//------------------------------------------------
// Sequential Access �֐��`��
//------------------------------------------------
#modcfunc DLList_getSeqf int bMove
	DLList_getSeq thismod, VAR_TEMP, bMove, 0
	return VAR_TEMP
	
//------------------------------------------------
// Random Access ���ߌ`��
//------------------------------------------------
#modfunc DLList_getv var p2, int p3, int bDup
	if ( bDup == 0 ) {
		DLV_getv mValue( DLList_followLink(thismod, p3) ), p2
	} else {
		DLV_dup  mValue( DLList_followLink(thismod, p3) ), p2
	}
	return
	
//------------------------------------------------
// Random Access �֐��`��
//------------------------------------------------
#modcfunc DLList_get int p2
	DLList_getv thismod, VAR_TEMP, p2, 0
	return VAR_TEMP
	
//##########################################################
//        ���ڐݒ�n
//##########################################################
//------------------------------------------------
// ���̗v�f��ύX����
//------------------------------------------------
#define global DLList_setNow(%1,%2) VAR_TEMP@abdata_dlinklist = (%2) : DLList_setNow_var %1,VAR_TEMP@abdata_dlinklist
#modfunc DLList_setNow_var var p2
	DLV_setv mValue(mIter), p2
	return
	
//------------------------------------------------
// �����قǎ擾�����̗v�f��ύX����
//------------------------------------------------
#define global DLList_setBack(%1,%2) VAR_TEMP@abdata_dlinklist = (%2) : DLList_setBack_var %1,VAR_TEMP@abdata_dlinklist
#modfunc DLList_setBack_var var p2
	DLList_back   thismod, 1
	DLList_setNow thismod, p2
	DLList_skip   thismod, 1
	return
	
//------------------------------------------------
// Random Access
//------------------------------------------------
#define global DLList_set(%1,%2,%3=0) VAR_TEMP@abdata_dlinklist = (%2) : DLList_setv %1,VAR_TEMP@abdata_dlinklist,%3
#modfunc DLList_setv var p2, int p3
	DLV_setv mValue( DLList_followLink(thismod, p3) ), p2
	return
	
//##############################################################################
//                ���ڑ}���n�֐��Q
//##############################################################################
//------------------------------------------------
// ���݂̈ʒu�ɒǉ�����
// 
// @ ���� GetSeq �Ŏ擾�����
//------------------------------------------------
#define global DLList_insNow(%1,%2) VAR_TEMP@abdata_dlinklist = (%2) : DLList_insNow_var %1,VAR_TEMP@abdata_dlinklist
#modfunc DLList_insNow_var var p2
	DLList_insertItem thismod, p2, mIter	// ���w���Ă���v�f�̑O�ɑ}������
	DLList_skip       thismod, 1
	return
	
//------------------------------------------------
// Random Access
//------------------------------------------------
#define global DLList_insert(%1,%2,%3=-1) VAR_TEMP@abdata_dlinklist = (%2) : DLList_insertv %1,VAR_TEMP@abdata_dlinklist,%3
#modfunc DLList_insertv var vResult, int n,  local nxt
	
	// �ǉ�����鍀�ڂ̎��̍��ڂ�T��
	if ( n >= mCntValue || n < 0 || mCntValue <= 0 ) {
		nxt = mTop		// �Ō�ɑ}������
		
	} else : if ( n == 0 ) {
		nxt = -1		// �擪�ɑ}������
		
	} else {
		nxt = DLList_followLink(thismod, n)
	}
	
	// �}������
	DLList_insertItem thismod, vResult, nxt
	return
	
//##############################################################################
//                ���ڍ폜�n�֐��Q
//##############################################################################
//------------------------------------------------
// ���Ɏ擾����v�f���폜����
//------------------------------------------------
#modfunc DLList_delNow  local prv
	prv   = DLV_getPrev( mValue(mIter) )
	DLList_removeItem thismod, mIter
	mIter = prv
	return
	
//------------------------------------------------
// �����ق� getnext �����v�f���폜����
//------------------------------------------------
#modfunc DLList_delBack
	DLList_back   thismod, 1
	DLList_delNow thismod
	return
	
//------------------------------------------------
// Random Access
//------------------------------------------------
#modfunc DLList_remove int p2,  local now, local nxt, local prv
	
	// �폜�����ꏊ��T��
	if ( p2 >= mCntValue || p2 < 0 ) {
		now = mLast								// �Ō���폜����
	} else {
		now = DLList_followLink(thismod, p2)	// p2 �Ԗڂ̗v�f���폜����
	}
	
	// �폜����
	DLList_removeItem thismod, now
	return
	
//##############################################################################
//                ���̑��̃����o�֐�
//##############################################################################
#define global DLList_cntValue !!"DLList_cntValue()�͔p�~�BDLList_size()�Ɉڍs����B"!!

//------------------------------------------------
// [i] �v�f��
//------------------------------------------------
#modcfunc DLList_size
	return mCntValue
	
#define global DLList_count  DLList_size
#define global DLList_length DLList_size
	
//##############################################################################
//                �C���^�[�t�F�[�X�֐�
//##############################################################################
//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc DLList_clear
	dim     mValue
;	DLV_new mValue, VAR_TEMP
	mCntValue = 0		// �v�f��
	mTop      = 0		// �擪�̗v�f�ԍ�
	mLast     = 0		// �Ō�̗v�f�ԍ�
	mIter_v   = 0		// �����q
	mIter_c   = 0		// �J�E���^
	return
	
//------------------------------------------------
// [i] �A��
//------------------------------------------------
#modfunc DLList_chain var mv_from,  local it
	// �S�v�f�𓯂����Ԃő}������
	DLList_iterNew mv_from
	
	while ( DLList_iterCheck(mv_from, it) )
		DLList_insert thismod, it, cnt
	wend
	
	DLList_iterDelete mv_from
	return
	
//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc DLList_copy var mv_from,  local it
	DLList_clear thismod
	DLList_chain thismod, mv_from
	return
	
//------------------------------------------------
// [i] �R���e�i����
//------------------------------------------------
#modfunc DLList_exchange var mv2,  local mvTemp
	DLList_new  mvTemp
	DLList_copy mvTemp,  thismod
	DLList_copy thismod, mv2
	DLList_copy mv2,     mvTemp
	DLList_delete mvTemp
	return
	
//------------------------------------------------
// 
//------------------------------------------------

//##############################################################################
//                �����֐�
//##############################################################################
//------------------------------------------------
// �����N��H���� n �Ԗڂ̗v�f�̔ԍ����擾
// @private
//------------------------------------------------
#modcfunc DLList_followLink int n, local now
	now = mTop
	repeat n
		now = DLV_getNext( mValue(now) )
	loop
	return now
	
//------------------------------------------------
// �����q�� p2 �񑀍��������
// @private
// @template macro
//------------------------------------------------
#define ctype FTM_DLList_iter(%1) repeat p2 : %1 : loop

//------------------------------------------------
// �擪�ɒǉ�����
// @private
//------------------------------------------------
#modfunc DLList_insTop var p2, local now
	
	// �A�C�e����ǉ�����
	DLV_new mValue, p2, mTop, mLast		// �ǉ�����
	now = stat
	
	// �����N���C������
	DLV_setNext mValue(mLast), now
	DLV_setPrev mValue(mTop),  now
	
	mTop = now
	mCntValue ++
	return
	
//------------------------------------------------
// ���ڂ�}������
// @private
// @ �}���ʒu���w�肷��
//------------------------------------------------
#modfunc DLList_insertItem var p2, int p3, local nxt, local prv, local now
	
	if ( mCntValue > 0 ) {
		if ( p3 < 0 ) {					// �擪�ɒǉ�����
			DLList_insTop thismod, p2
			return
			
		} else : if ( p3 == mTop ) {	// �Ō�ɒǉ�����
			prv = mLast
			nxt = mTop
			
		} else {
			nxt = p3
			prv = DLV_getPrev( mValue(nxt) )	// �O�̃����N�͎擾�ł���
		}
	} else {
		nxt = p3
		prv = 0
	}
	
	// �A�C�e����ǉ�����
	DLV_new mValue, p2, nxt, prv
	now = stat
	
	// �����N���C������
	DLV_setNext mValue(prv), now
	DLV_setPrev mValue(nxt), now
	
	if ( nxt == mTop ) {			// �Ō�ɑ}�������ꍇ
		mLast = now
	}
	
	mCntValue ++
	return
	
//------------------------------------------------
// ���ڂ��폜����
// @private
// @ �폜�ʒu���w�肷��
//------------------------------------------------
#modfunc DLList_removeItem int now,  local nxt, local prv
	
	// �O��̃����N��ۑ�����
	nxt = DLV_getNext( mValue(now) )
	prv = DLV_getPrev( mValue(now) )
	
	// �폜����
	DLV_delete mValue(now)
	mCntValue --
	if ( mCntValue <= 0 ) {
		mTop  = 0
		mLast = 0
		return
	}
	
	// �����N���C������
	DLV_setNext mValue(prv), nxt
	DLV_setPrev mValue(nxt), prv
	
	if ( now == mTop  ) { mTop  = nxt }		// �擪���폜�����ꍇ
	if ( now == mLast ) { mLast = prv }		// �Ō���폜�����ꍇ
	return
	
//##############################################################################
//                �f�o�b�O�p
//##############################################################################
#ifdef _DEBUG

//------------------------------------------------
// �S���ڂ�\��
//------------------------------------------------
#modfunc DLList_dbglog local i, local it
	logmes ""
	logmes "- DLList_allPut"
	i = 0
	DLList_iterNew thismod
	while ( DLList_iterCheck(thismod, it) )
		logmes strf("(%2d) ", i) + it
		i ++
	wend
	return
	
#else

#define global DLList_dbglog(%1) :

#endif

#global

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

#include "alg_iter.as"

#ifndef __UserDefHeader__
 #define color32(%1=0) color ((%1) & 0xFF),(((%1) >> 8) & 0xFF),(((%1) >> 16) & 0xFF)
 #define ctype RGB(%1,%2,%3) ((%1) | (%2) << 8 | (%3) << 16)
 #define ctype bturn(%1) ((%1) ^ 0xFFFFFFFF)
#endif

	randomize
	screen 0, 320, 240
	syscolor 15 : boxf
	
	font msgothic, 12
	
	pos 20, 20
	
	sdim  cmd, 64
	input cmd, , , 3
	count = 5
	
	DLList_new mDLList
	
	onkey gosub *enter
	stop
	
*enter
	objsel -1
	if (iparam != 13 || stat != 0) {
		return
	}
	
	getstr snum, cmd, 1
	
	prm = int(snum)
	c   = peek(cmd, 0)
	
	if ( snum == "" ) {
		prm = -1
	}
	
	switch c
	case '+'
		n = rnd(100)
		DLList_insert mDLList, n, prm
		
		color 255, 255, 255 : boxf 110, 20, 180, 40 : color
		pos 110, 26 : mes "insert : "+ n
		
		gosub *disp
		swbreak
		
	case '-'
		DLList_remove mDLList, prm
		gosub *disp
		swbreak
		
	case '@'
		randomize prm
		swbreak
		
	swend
	
	poke cmd
	objprm 0, cmd
	return
	
*disp
	if ( count == 5 ) {
		count = 0
		cref  = RGB(rnd(3) * 127 + 1, rnd(3) * 127 + 1, rnd(3) * 127 + 1)
	}
	
	color32 cref
	boxf 10 + ( 60 * count ), 45, 70 + ( 60 * count ), 230 : color32 bturn(cref)
	pos  15 + ( 60 * count ), 50
	
	/*
	i = 0
	DLList_iterNew mDLList
	while ( DLList_iterCheck(mDLList, it) )
		mes strf("(%2d) : ", i) + it
		i ++
	wend
	/*/
	IterateBegin mDLList, DLList
		mes strf("(%2d) : ", IterateCnt) + it
	IterateEnd
	//*/
	
	count ++
	return
	
#endif

#endif
