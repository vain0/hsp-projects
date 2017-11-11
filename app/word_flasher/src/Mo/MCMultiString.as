// ����������N���X

#ifndef IG_MODULECLASS_MULTI_STRING_AS
#define IG_MODULECLASS_MULTI_STRING_AS

// @ abdata_list �̃��b�p�[

; TODO
; �E�\�[�g�̃A���S���Y����
; �E�ꊇ�u��
; �E��������
; �E
// @in iterating:
// @	�Ō���ւ̒ǉ��̂݋��B����ȊO�ւ̑}���E��������͋֎~�B

#include "abdata/abdata/list.as"
#include "Mo/MCLongString.as"

	sdim stt_clone@MCMultiString

#module MCMultiString mStrlist

//##############################################################################
//        �R���X�g���N�^�E�f�X�g���N�^
//##############################################################################
//------------------------------------------------
// [i] �\�z
//------------------------------------------------
#define global MStr_new(%1) newmod %1, MCMultiString@
#modinit
	List_new mStrlist
	return
	
//------------------------------------------------
// [i] ���
//------------------------------------------------
#define global MStr_delete(%1) delmod %1
#modterm
	List_delete mStrlist
	return
	
//##############################################################################
//        �����o���߁E�֐�
//##############################################################################

//################################################
//        �G���n
//################################################
//------------------------------------------------
// [i] �v�f��
//------------------------------------------------
#modcfunc MStr_size
	return List_size( mStrlist )
	
#define global MStr_empty MStr_size
#define global MStr_count MStr_size

//------------------------------------------------
// �͈̓`�F�b�N
//------------------------------------------------
#modcfunc MStr_isValid int idx
	return List_isValid( mStrlist, idx )
	
//################################################
//        �擾�n
//################################################
//------------------------------------------------
// �l�Ԃ� ( ���ߌ`�� )
//------------------------------------------------
#modfunc MStr_getv var vResult, int idx
	List_getv mStrlist, vResult, idx
	return
	
//------------------------------------------------
// �l�Ԃ� ( �֐��`�� )
//------------------------------------------------
#modcfunc MStr_get int idx
	return List_get( mStrlist, idx )
	
//------------------------------------------------
// �Q�Ɖ� ( ���ߌ`�� )
// 
// @! �m�ۍςݗ̈���z����Ɣ��f����Ȃ�
//------------------------------------------------
#modfunc MStr_clone var vRef, int idx
	List_clone mStrlist, vRef, idx
	return
	
//------------------------------------------------
// �Q�Ƃ𓾂� ( �֐��`�� )
//------------------------------------------------
#define global ctype MStr_ref(%1, %2 = 0) stt_clone@MCMultiString( MStr_ref_core(%1, %2) )
#modfunc MStr_ref_core int idx
	MStr_clone stt_clone, idx
	return 0
	
//################################################
//        �ݒ�n
//################################################
//------------------------------------------------
// �f�[�^�u��
//------------------------------------------------
#define global MStr_set(%1, %2 = "", %3 = 0) _MStr_set %1, "" + (%2), %3
#define global MStr_setv(%1, %2, %3 = 0)     _MStr_set %1,       %2,  %3
#modfunc _MStr_set str s_value, int idx
	List_set mStrlist, s_value, idx
	return
	
//################################################
//        ����n
//################################################
//------------------------------------------------
// �}��
//------------------------------------------------
#define global MStr_insert(%1,%2,%3=0) _MStr_insert %1, "" + (%2), %3
#modfunc _MStr_insert str s_value, int idx
	List_insert mStrlist, s_value, idx
	return
	
//------------------------------------------------
// �Ō���ւ̒ǉ�
//------------------------------------------------
#define global MStr_add(%1,%2) MStr_insert %1, %2, MStr_size(%1)
#define global MStr_push_back  MStr_add

//------------------------------------------------
// �폜
//------------------------------------------------
#modfunc MStr_remove int idx
	List_remove mStrlist, idx
	return
	
//------------------------------------------------
// �ړ�
//------------------------------------------------
;#modfunc MStr_move int idxSrc, int idxDst
;	List__move mStrlist, idxSrc, idxDst
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
;#modfunc MStr_swap int idx1, int idx2
	;List_swap mStrlist, idx1, idx2
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
;#modfunc MStr_rotate
	;List_rotate mStrlist
	return
	
//------------------------------------------------
// ���� ( �t��] )
//------------------------------------------------
;#modfunc MStr_rotate_back
	;List_rotate_back mStrlist
	return
	
//------------------------------------------------
// ���]
//------------------------------------------------
#modfunc MStr_reverse
	List_reverse mStrlist
	return
	
//################################################
//        ���̑�
//################################################
//------------------------------------------------
// [i] ���S����
//------------------------------------------------
#modfunc MStr_clear
	List_clear mStrlist
	return
	
//------------------------------------------------
// �󕶎���̍��ڂ��폜����
//------------------------------------------------
#modfunc MStr_removeVoid  local cntItem, local idx
	cntItem = MStr_size(thismod)
	if ( cntItem == 0 ) { return }
	
	repeat cntItem
		idx = cntItem - (cnt + 1)
		if ( MStr_get(thismod, idx) == "" ) {
			MStr_remove idx
		}
	loop
	
	return
	
//------------------------------------------------
// ����̕�����̍���(���S��v)��T���Aindex ��Ԃ�
// 
// @ ���`�T��
//------------------------------------------------
#modcfunc MStr_findString str sTarget,  local idx
	idx = -1
	repeat MStr_size(thismod)
		if ( MStr_get(thismod, cnt) == sTarget ) {
			idx = cnt
			break
		}
	loop
	return idx
	
#define global ctype MStr_existsString(%1,%2) ( MStr_findString(%1, %2) >= 0 )
	
//------------------------------------------------
// ����̕�����̍��ڂ��폜����
// 
// @prm bGlobal : ���ׂĂ̍��ڂ��폜���邩
//------------------------------------------------
#modfunc MStr_removeString str sTarget, int bGlobal,  local idx
	repeat
		idx = MStr_findString(thismod, sTarget)
		if ( bGlobal == false || idx < 0 ) {
			break
		}
		MStr_remove thismod, idx
	loop
	return
	
//################################################
//        �A��
//################################################
#define global MStr_cat            MStr_chain
#define global MStr_catSplitString MStr_chainSplitString
#define global MStr_catNoteString  MStr_chainNoteString
#define global MStr_catArray       MStr_chainArray

//------------------------------------------------
// [i] �A��
//------------------------------------------------
#modfunc MStr_chain var mv_src
	// ����}���ɒǉ����Ă���
	repeat MStr_size(mv_src)
		MStr_add thismod, MStr_get(mv_src, cnt)
	loop
	return
	
//------------------------------------------------
// ��؂蕶�����ǉ�����
//------------------------------------------------
#modfunc MStr_chainSplitString str split_string, str sSplitter,  local sSrc, local arr
	sSrc = split_string
	split@hsp sSrc, sSplitter, arr
	MStr_chainArray thismod, arr
	return
	
/*
#modfunc MStr_chainSplitString str split_string, str prm_sSplitter,  local sSrc, local stmp, local index, local sSplitter, local lenSplitter
	sdim stmp, 320
	
	index       = 0
	sSplitter   = prm_sSplitter
	lenSplitter = strlen(sSplitter)
	sSrc        = split_string
	
	// ��؂��ă}���ɒǉ�
	repeat
		splitNext stmp, sSrc, index, sSplitter, lenSplitter
		if ( stat == failure ) { break }
		
		MStr_add thismod, stmp
	loop
	
	return
	
//------------------------------------------------
// ���̋�؂蕶����܂ł�؂��ĕԂ�
//------------------------------------------------
#deffunc splitNext@MCMultiString var result, var sSrc, var index, var sSplitter, int lenSplitter,  local iFound, local lenSrc
	// ���s��؂�̏ꍇ
	if ( sSplitter == "\n" ) {
		getstr result, sSrc, index : index += strsize
		
		if ( strsize == 0 ) {
			return failure
		}
		
	// �ėp
	} else {
		iFound = instr(sSrc, index, sSplitter)
		
		if ( iFound >= 0 ) {
			result  = strmid(sSrc, index, iFound)
			index += iFound + lenSplitter
			
		} else {
			lenSrc = strlen(sSrc)
			if ( lenSrc <= index ) {
				return failure
			} else {											// �܂������񂪎c���Ă���ꍇ
				result = strmid(sSrc, index, lenSrc - index)	// �Ō�܂Ő؂�o��
				index  = lenSrc
			}
		}
	}
	
	return success
//*/
	
//------------------------------------------------
// �����s�������ǉ�����
//------------------------------------------------
#define global MStr_chainNoteString(%1,%2) MStr_chainSplitString %1, %2, "\n"

//------------------------------------------------
// �J���}��؂蕶�����ǉ�����
//------------------------------------------------
#define global MStr_chainCsvString(%1,%2) MStr_chainSplitString %1, %2, ","

//------------------------------------------------
// �ꎟ��������z���ǉ�����
//------------------------------------------------
#modfunc MStr_chainArray array arrString
	foreach arrString
		MStr_add thismod, arrString(cnt)
	loop
	return
	
//################################################
//        �ϊ�
//################################################
//------------------------------------------------
// �����s������ɂ���
//------------------------------------------------
#define global MStr_toNoteString(%1,%2) MStr_toSplitString %1, %2, "\n"

//------------------------------------------------
// �J���}��؂蕶����ɂ���
//------------------------------------------------
#define global MStr_toCsvString(%1,%2) MStr_toSplitString %1, %2, ","

//------------------------------------------------
// ��؂蕶����ɂ���
// 
// @result (stat) : buf �̕����� [byte]
//------------------------------------------------
#modfunc MStr_toSplitString var buf, str prm_sSplitter,  local sSplitter, local ls, local len
	
	sSplitter = prm_sSplitter
	
	// ����}���ɘA������
	LongStr_new ls
	repeat MStr_size(thismod)
		if ( cnt ) {
			LongStr_add ls, sSplitter
		}
		LongStr_add ls, MStr_get(thismod, cnt)
	loop
	LongStr_tobuf  ls, buf : len = LongStr_length(ls)
	LongStr_delete ls
	
	return len
	
//------------------------------------------------
// ������^�z��ɂ���( �ꎟ�� )
//------------------------------------------------
#modfunc MStr_toArray array arrString
	sdim arrString, , MStr_size(thismod)
	
	foreach arrString
		arrString(cnt) = MStr_get(thismod, cnt)
	loop
	
	return
	
//################################################
//        ����֐�
//################################################
//------------------------------------------------
// [i] ���S����
//------------------------------------------------
//------------------------------------------------
// [i] �A��
//------------------------------------------------
// ���q

//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc MStr_copy var mv_from
	MStr_clear thismod
	MStr_chain thismod, mv_from
	return
	
//------------------------------------------------
// [i] ����
//------------------------------------------------
#modfunc MStr_exchange var mv2,  local mvTemp
	MStr_new  mvTemp
	MStr_copy mvTemp,  thismod
	MStr_copy thismod, mv2
	MStr_copy mv2,     mvTemp
	MStr_delete mvTemp
	return
	
//------------------------------------------------
// [i] �����q::������
//------------------------------------------------
#modfunc MStr_iterInit var iterData
	List_iterInit mStrlist, iterData
	return
	
//------------------------------------------------
// [i] �����q::�X�V
//------------------------------------------------
#modcfunc MStr_iterNext var vIt, var iterData
	return List_iterNext( mStrlist, vIt, iterData )
	
//################################################
//        ����
//################################################
//------------------------------------------------
// ����
//------------------------------------------------
#modfunc MStr_sort int mode
	List_sort mStrlist, mode
	return
	
/*
#modfunc MStr_sort  local ar, local len, local tr, local n, local m, local p, local p1, local e1, local p2, local e2, local s, local mv_temp
	dim ar, MStr_size(thismod)
	
	foreach ar
		ar(cnt) = cnt
	loop
	
	// �}�[�W�\�[�g
	len = MStr_size(thismod)	// �\�[�g����z��
	dim tr, len					// temp array
	
	repeat
		// �Z�O�����g�T�C�Y��`
		n = 1 << cnt	// �}�[�W�T�C�Y
		m = n * 2		// �Z�O�����g �T�C�Y
		
		// �S�Z�O�����g�ɑ΂���
		repeat
			// �Z�O�����g �̈��`
			p  = m * cnt				// �Z�O�����g�J�n�_
			p1 = p						// �p�[�g 1 �J�n�_
			e1 = p1 + n					// �p�[�g 1 �I���_
			p2 = e1						// �p�[�g 2 �J�n�_
			e2 = limit(p2 + n, 0, len)	// �p�[�g 2 �I���_ (clipping)
			s  = e2 - p1				// �Z�O�����g �T�C�Y
			
			if ( s <= n ) { break }		// �Z�O�����g �T�C�Y��臒l�ȉ��Ȃ� �}�[�W���Ȃ�
			
			// �Z�O�����g�� �}�[�W
			repeat s
				if ( p2 >= e2 ) {				// p2 �̈�O
					tr(cnt) = ar(p1) : p1 ++
				} else : if ( p1 >= e1 ) {		// p1 �̈�O
					tr(cnt) = ar(p2) : p2 ++
				} else : if ( MStr_get(thismod, ar(p1)) != MStr_get(thismod, ar(p2)) <= 0 ) {	// ��r & �}�[�W (strcmp)
					tr(cnt) = ar(p1) : p1 ++
				} else {
					tr(cnt) = ar(p2) : p2 ++
				}
			loop
			
			// �}�[�W���ꂽ�z����\�[�X�z��ɓ\��t��
			memcpy ar(p), tr, s * 4
		loop
		
		// �\�[�g ����
		if ( n >= len ) : break
	loop
	
	// ���̔z��̏��Ԃ����ւ��ăe���|�����z��ɑ��
	MStr_new  mv_temp
	MStr_copy mv_temp, thismod
	
	// �߂�z��ɍĊi�[
	MStr_clear thismod
	repeat len
		MStr_add thismod, MStr_get(mv_temp, ar(cnt))
	loop
	return
//*/
	
//################################################
//        �t�@�C�����o��
//################################################
//------------------------------------------------
// �t�@�C������ǂݍ���
// 
// @ ��؂蕶����Ƃ��ēǂݍ��ށB
// @ �����̃��X�g�ɘA������B
//------------------------------------------------
#define global MStr_load(%1,%2,%3="\n") MStr_load_ %1, %2, %3
#modfunc MStr_load_  str filename, str splitter,  local buf
	exist filename
	if ( strsize < 0 ) { return }
	
	sdim            buf, strsize + 1
	bload filename, buf, strsize
	MStr_catSplitString thismod, buf, splitter
	return
	
//------------------------------------------------
// �t�@�C���ɕۑ�
// 
// @ ��؂蕶����Ƃ��ĕۑ�����B
//------------------------------------------------
#define global MStr_save(%1,%2,%3="\n") MStr_save_ %1, %2, %3
#modfunc MStr_save_ str filename, str splitter,  local buf, local memsize, local index
	MStr_toSplitString thismod, buf, splitter
	bsave filename, buf, stat
	return
	
//##############################################################################
//        �f�o�b�O
//##############################################################################
//------------------------------------------------
// �f�o�b�O�o��
//------------------------------------------------
#ifdef _DEBUG

#modfunc MStr_dbglog
	logmes "\n[MStr_dbglog]"
	repeat List_size( mStrlist )
		logmes strf("#%02d: ", cnt) + List_get( mStrlist, cnt )
	loop
	return
	
#else
 #define global MStr_dbglog(%1) :
#endif

#global

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

#include "d3m.hsp"

	randomize
	
	MStr_new slist
	
	repeat 10
		time = d3timer()
		
		repeat 1000
			
			MStr_clear slist
			MStr_chainCsvString slist, "�����S,�o�i�i,�~�J��,Grape,"	// (7 ~ 8)e-2[ms]
			MStr_dbglog         slist
			
		;	MStr_toSplitString  slist, stmp, "|"
			
		;	mes stmp
			
			MStr_sort   slist
		;	MStr_dbglog slist
			
		loop
		
		time = d3timer() - time - 75
		mes "" + time + "[ms]"
	loop
	
	MStr_delete slist
	
	stop
	
#endif

#endif
