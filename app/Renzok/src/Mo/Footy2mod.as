#ifndef __FOOTY2MOD_AS__
#define __FOOTY2MOD_AS__

;#include "Footy2.as"

//-------- ����͏�傪����ɒǉ��������� ----------------------------------------------------------
#module
#define ctype IsSJIS1st(%1) ((0x81<=(%1)&&(%1)<=0x9F)||(0xE0<=(%1)&&(%1)<=0xFC))/* �������o�C�g�𔻒� */
#define ctype which_int(%1,%2,%3) ((%2)*((%1)!=0)||(%3)*((%1)==0))

// ��������Ԃ�
#defcfunc strlenW var p1
	nChar = 0
	count = 0
*@
		chr = peek(p1, count)
		if ( chr == 0 ) { return nChar }
		if ( IsSJIS1st(chr) ) {
			count ++
		}
		nChar ++
		count ++
	goto *@before
	return 0
	
// �������ƒ����𑊌ݕϊ�
// p3 �� �U�F������->���� �^�F���̋t
#defcfunc CnvStrnumLen var p1, int p2, int p3
	nChar = 0	// ������
	count = 0	// ���Ă���ʒu(����)
*@
		if ( p3 == 0 && nChar >= p2 ) {	// �������܂ŒB����
			return count
		} else
		if ( p3 != 0 && count >= p2 ) {	// �����܂ŒB����
			return nChar
		}
		
		chr = peek(p1, count)
		if ( chr == 0 ) { return which_int(p3, nChar, count) }
		if ( IsSJIS1st(chr) ) {			// ��o�C�g�������H
			count ++
		}
		nChar ++
		count ++
	goto *@before
	return
	
/**
 * �s���̕����C���f�b�N�X��Ԃ�
 * @prm p1 var	: ������^�ϐ�
 * @prm p2 int	: �s�ԍ� ( 0����n�܂� )
 * @prm p3 int	: �߂�l�t���O
 * @return
 *		p3 == 1 : �o�C�g��
 *		p3 == 2 : ������
 *		else    : varptr(ret) : ret = �o�C�g��, ������
 */
#defcfunc GetCharIndexAtLineTop var p1, int p2, int p3
	// �s�����當���������߂�
	i = 0
	n = 0
	nChar = 0
	while n < p2
		chr = peek(p1, i)
		if ( chr == 0 ) { _break }			// NULL�Ȃ�I��
		
		// ���s��
		if ( chr == 0x0A || chr == 0x0D ) {
			if ( chr == 0x0D ) {			// CarriageReturn + LineFeed �`��
				// CR + LF �`��
				if ( peek(p1, i + 1) == 0x0A ) {
					i ++
				}
			}
			n ++	// ���s����
		} else : if ( IsSJIS1st(chr) ) {
			i ++
		}
		nChar ++
		i ++
	wend
	
	if ( p3 == 1 ) {
		return i
	} else : if ( p3 == 2 ) {
		return nChar
	}
	ret = i, nChar
	return varptr(ret)
	
#global

#module footymod
#define _true_  1
#define _false_ 0

#uselib "user32.dll"
#func GetScrollInfo "GetScrollInfo" int,int,int
#func GetWindowRect "GetWindowRect" int,int

#define ctype IsSJIS1st(%1) ((0x81 <= (%1) && (%1) <= 0x9F)||(0xE0 <= (%1) && (%1) <= 0xFC)) ; �������o�C�g�𔻒�
##define ctype IsSJIS2nd(%1)((0x40 <= (%1) && (%1) <= 0x7E)||(0x80 <= (%1) && (%1) <= 0xFC)) ; �������o�C�g�𔻒�

// �I����Ԃ����邩
#defcfunc IsSelOnFooty int FootyID
	Footy2GetSel FootyID, 0, 0, 0, 0	// �I����Ԃ��ǂ������擾(������ΐ^)
	return (stat != -5)					// �I������Ă���ΐ^
	
// Footy ����S�������o���Ap2(= buf) �Ɋi�[����
#define global GetAllTextInFooty(%1,%2,%3=LM_AUTOMATIC) _GetAllTextInFooty %1,%2,%3
#deffunc _GetAllTextInFooty int FootyID, var _buf, int LineType
	len = Footy2GetTextLengthW( FootyID, LineType )			// �������擾
	len <<= 1							// ��{�ɂ���
	
	sdim _buf, len + 12
	Footy2GetTextW FootyID, varptr(_buf), LineType, len + 2	// ������擾
	
	_buf = cnvwtos(_buf)				// Wide ���� SHIFT_JIS �ɕϊ�
	if ( len < 260 ) {
		_buf = strmid(_buf, 0, len)		// 260 �ȉ��Ȃ�A�p�X���������Ă���\��������
	}
	return _false_
	
// Footy ���� p2 �̈�s�����o���Ap3(= buf) �Ɋi�[����
#deffunc GetLineInFooty int FootyID, int p2, var _buf, local wchr
	sdim _buf, 64								// ������ɂ��Ă��� & ������
	len = Footy2GetLineLengthW(FootyID, p2)		// �������擾
	if ( len <= 0 ) { return _true_ }
	
	len <<= 1	// 2�{�ɂ���
	
	sdim _buf, len + 64							// ���߂Ɋm�ۂ��Ă���
	ptr = Footy2GetLineW(FootyID, p2)			// ������|�C���^���擾
	if ( ptr == 0 ) { return }
	
	sdim   wchr, 64
	dupptr wchr, ptr, len, vartype("str")	// ������^
	
	_buf = cnvwtos(wchr)					// Wide ���� SHIFT_JIS �ɕϊ�
	if ( len < 260 ) {
		_buf = strmid(_buf, 0, len)			// 260 �ȉ��Ȃ�A�p�X���������Ă���\��������
	}
	return _false_
	
// Footy ����I������Ă��镶��������o���Ap2(= buf) �Ɋi�[����
#define global GetSelTextInFooty(%1,%2,%3=LM_AUTOMATIC) _GetSelTextInFooty %1,%2,%3
#deffunc _GetSelTextInFooty int FootyID, var _buf, int LineType
	sdim _buf
	len = Footy2GetSelLengthW(FootyID, LineType)	// �������擾
	len <<= 1										// ��{�ɂ���
	
	sdim _buf, len + 64
	Footy2GetSelTextW FootyID, varptr(_buf), LineType, len + 2	// ������擾
	
	_buf = cnvwtos(_buf)				// Wide ���� SHIFT_JIS �ɕϊ�
	if ( len < 260 ) {
		_buf = strmid(_buf, 0, len)		// 260 �ȉ��Ȃ�A�p�X���������Ă���\��������
	}
	return _false_
	
// �I�𕶎���̑O��Ɋ��ʂ�}��
#define global SetBracket(%1,%2,%3) _SetBracket %1,""+(%2),""+(%3)
#deffunc _SetBracket int FootyID, str p2, str p3, local _n	// FootyID, �O, ��
	dim _n, 3
	Footy2GetSel FootyID, varptr(_n.1), varptr(_n.2), 0, 0	// �I��͈͂̑O�����擾
	GetSelTextInFooty      FootyID, buf						// �I�����Ă��镶����� buf �Ɋi�[����
	Footy2SetSelTextW      FootyID, p2 +""+ buf +""+ p3		// �ǉ�
	Footy2SetCaretPosition FootyID, _n(1), _n(2)			// �L�����b�g�ʒu�����ɖ߂�
	return
	
// �J�[�\���𓮂���
#deffunc GotopOnFooty  int FootyID
	Footy2SetCaretPosition FootyID, 0, 0, _true_
	return
	
#deffunc GobtmOnFooty  int FootyID, local nLine, local nPos
	nLine = Footy2GetLines(FootyID) - 1				// �ŏI�s�̍s�ԍ�
	nPos  = Footy2GetLineLengthW(FootyID, nLine)
	Footy2SetCaretPosition FootyID, nLine, nPos, _true_
	return
	
#deffunc GoCaretOnFooty int FootyID, array Caret
	Footy2SetCaretPosition  FootyID, Caret(0), Caret(1), _true_
	return
	
// �J�[�\���ʒu�̎擾
#deffunc GetCaretOnFooty int FootyID, array Caret
	dim Caret, 2
	Footy2GetCaretPosition FootyID, varptr( Caret(0) ), varptr( Caret(1) )
	return (stat)
	
#deffunc SetCaretOnFooty int FootyID, array Caret, int bRefresh
	Footy2SetCaretPosition FootyID, Caret(0), Caret(1), bRefresh
	return stat
	
// �J�[�\���ʒu�����S���m�F�A����������Β���
#deffunc AdjustCaretOnFooty int FootyID, array _Caret, local nRet, local temp
	nRet = 0
	if ( _Caret(0) < 0 ) { _Caret(0) = 0 : nRet = 1 }	// �����Ȃ璲�߂���
	if ( _Caret(1) < 0 ) { _Caret(1) = 0 : nRet = 2 }	// �V
	
	if ( _Caret(0) >= Footy2GetLines(FootyID) ) {
		 _Caret(0)  = Footy2GetLines(FootyID) - 1	// �s���ُ̈�
		 nRet = 1
	}
	if ( _Caret(1) >= Footy2GetLineLengthW(FootyID, _Caret(0)) ) {
		 _Caret(1)  = Footy2GetLineLengthW(FootyID, _Caret(0))
		 nRet = 2
	}
/*
	sdim temp, 511
	GetLineInFooty FootyID, _Caret(0), temp			// ��s���擾 (�����`�F�b�N)
	if ( _Caret(1) >= strlen(temp) ) {				// �ł��������
		 _Caret(1)  = strlen(temp)					// ����
		 nRet = 2
	}
*/
	return nRet
	
// �͈͂�I������
#deffunc SetSelectOnFooty int FootyID, array select, int bRefresh
	Footy2SetSel FootyID, select(0), select(1), select(2), select(3), bRefresh
	return stat
	
// �I��͈͂��擾
#deffunc GetSelectOnFooty int FootyID, array select
	dim select, 4
	Footy2GetSel FootyID, varptr(select(0)), varptr(select(1)), varptr(select(2)), varptr(select(3))
	return (stat)
	
// �͈͂̕�����𓾂�
#deffunc GetTextFromRangeInFooty int FootyID, array range,  local select, local sResult, local bSelected
	bSelected = IsSelOnFooty(FootyID)
	if ( bSelected ) {
		GetSelectOnFooty FootyID, select		// ���݂̑I��͈�
	} else {
		GetCaretOnFooty  FootyID, select		// ���݂̃L�����b�g�ʒu
	}
	
	SetSelectOnFooty  FootyID, range,  _false_	// �w��͈͂�I������
	GetSelTextInFooty FootyID, sResult			// �͈͕�����𓾂�
	
	if ( bSelected ) {
		SetSelectOnFooty FootyID, select, _false_	// �I��͈͂����ɖ߂�
	} else {
		SetCaretOnFooty  FootyID, select, _false_	// �L�����b�g�ʒu�����ɖ߂�
	}
	return sResult
	
// �S�̂̕�����
#define global ctype GetLengthInFooty(%1,%2=LM_AUTOMATIC) _GetLengthInFooty(%1,%2)
#defcfunc _GetLengthInFooty int FootyID, int LineType, local _buf
	sdim _buf
	GetAllTextInFooty FootyID, _buf, LineType		// �S�Ă̕�������擾
	return strlen(_buf)
	
// �͈͂̕����񒷂��擾
#define global ctype GetLengthBySelectInFooty(%1,%2=0,%3=0,%4=0,%5=0,%6=LM_AUTOMATIC) _GetLengthBySelectInFooty(%1,%2,%3,%4,%5,%6)
#defcfunc _GetLengthBySelectInFooty int FootyID, int scL, int scP, int ecL, int ecP, int LineType, local select
	dim select, 4
	GetSelectOnFooty FootyID, select		// ���̑I��͈͂��擾
	if ( stat < 0 ) {
		GetCaretOnFooty FootyID, select
		select(2) = 0, 0
	}
	
	Footy2SetSel FootyID, scL, scP, ecL, ecP, _false_					// �͈͂�I������
	len = Footy2GetSelLengthW( FootyID, LineType )						// �������擾
	Footy2SetSel FootyID, select(0), select(1), select(2), select(3)	// �͈͂����ɖ߂�
	
	if ( len < 0 ) { return 0 }
	return len
	
// �擪����A�w��L�����b�g�܂ł̕����񒷂��擾
#defcfunc GetLengthByCaretInFooty int FootyID, int p2, int p3, int p4, local _buf, local offset
	// ��������擾����
	GetAllTextInFooty FootyID, _buf, LM_AUTOMATIC
	
	// �s���܂ł̕�����
	dupptr  indexAtLinetop, GetCharIndexAtLineTop(_buf, p2), 8
	i     = indexAtLinetop(0)
	nChar = indexAtLinetop(1)
	
	// ��������擾����
	GetAllTextInFooty FootyID, _buf, LM_AUTOMATIC
	
	if ( p4 == 2 ) {		// ����������
		return nChar + p3
	}
	// �o�C�g���𓾂�
	offset = nChar
	while (nChar - offset) < p3
		chr = peek(_buf, i)
		if ( chr == 0 ) { _break }
		if ( IsSJIS1st(chr) ) {
			i ++
		}
		nChar ++
		i     ++
	wend
	
	if ( p4 == 1 ) {
		return i
	}
	ret = i, nChar
	return varptr(ret)
	
// �����񒷂���A�L�����b�g�ʒu���擾����( len �� �o�C�g�� )
// �E�L�����b�g�ʒu�܂ł̕��������擾
// �E_Caret(0)�̍s��_Caret(1)�܂ł̌��̃o�C�g���𓾂�
// �E�w�肳�ꂽ�o�C�g����i�߂�
// �E�o�C�g���𕶎����ɕϊ�
#define global GetCaretByLengthOnFooty(%1,%2,%3,%4=LM_AUTOMATIC) _GetCaretByLengthOnFooty %1,%2,%3,%4
#deffunc _GetCaretByLengthOnFooty int FootyID, array _Caret, int _len, int LineType, local _buf, local offset
	if ( _len < 0 ) { return _true_ }
	
;	logmes "defualt : "+ logp(_Caret(0), _Caret(1))
;	logmes logv(_len)
	
	// ��������擾����
	GetAllTextInFooty FootyID, _buf, LineType
	
	// �s�����當���������߂�
	dupptr   indexAtLinetop, GetCharIndexAtLineTop(_buf, _Caret(0)), 8
	i      = indexAtLinetop(0)
	offset = indexAtLinetop(1)
;	logmes "�s�����狁�߂��������F"+ offset
	
	offset += _Caret(1)			// ���̕����������Z
	
;	logmes logv(offset)
	
	// Caret(1) �̃o�C�g�������߁A�w��o�C�g�i�߁A�������ɕϊ�����
	sdim   temp, _Caret(1) * 2 + _len + 1
	getstr temp, _buf, i, , _Caret(1) * 2 + 1
	_Caret1_byte = CnvStrnumLen(temp, _Caret(1))	// �������𒷂��ɕϊ�
	
;	logmes logv(_Caret1_byte)
	
	// �i�߂�
	i     += _Caret1_byte
	offset = i
	while (i - offset) < _len
		chr = peek(_buf, i)
		if ( chr == 0 ) { _break }
		if ( chr == 0x0D || chr == 0x0A ) {
			if ( chr == 0x0D ) {			// CarriageReturn + LineFeed �`��
				// CR + LF �`��
				if ( peek(_buf, i + 1) == 0x0A ) {
					i ++
				}
			}
			_Caret(0) ++
			_Caret(1) = -1	// ���s���� (�C���N�������g�����̂� -1)
		} else : if ( IsSJIS1st(chr) ) {
			i ++
		}
		_Caret(1) ++
		i ++
	wend
	return _false_
	
/**
* �s�����g������
* @param fid	: FootyID
* @param lines	: �g����̍s��
* @return int	: �g�������s�� or ����(�G���[)
**/
#deffunc SetLinesOnFooty int FootyID, int nLine, local _buf, local _Caret
	n = Footy2GetLines( FootyID )		// ���̍s��
	if ( n < 0 || n >= nLine ) {		// ���s
		return -1
	}
	
	// ���s�R�[�h�̕�������쐬
	sdim _buf, (nLine - n) * 2 + 64
	repeat nLine - n
		wpoke _buf, cnt * 2, 0x0A0D
	loop
	
	// �ǉ�
	dim _Caret, 2
	GetCaretOnFooty		FootyID, _Caret	// ���̃L�����b�g���擾
	GoBtmOnFooty		FootyID			// �Ō���Ɉړ�
	Footy2SetSelTextW	FootyID, _buf	// �}��
	
	// �L�����b�g�ʒu��߂�
	GoCaretOnFooty FootyID, _Caret
	return nLine - n
	
//######## �����h���b�O�ɖ𗧂� ################################################
#define global ctype GetFirstVisibleLineOnFooty(%1,%2) GetFirstVisibleCaretOnFooty(%1,%2,1)
#define global ctype GetFirstVisibleColumnOnFooty(%1,%2) GetFirstVisibleCaretOnFooty(%1,%2,0)
#defcfunc GetFirstVisibleCaretOnFooty int FootyID, int nViewID, int flag, local ScrollInfo
	dim ScrollInfo, 7
	ScrollInfo = 28, 4
	
	GetScrollInfo Footy2GetWnd(FootyID, nViewID), flag, varptr(ScrollInfo)
	return ScrollInfo(5)
	
#define ctype IsInRect(%1=RECT,%2=mousex,%3=mousey)  ( (((%1(0)) <= (%2)) && ((%2) <= (%1(2)))) && (((%1(1)) <= (%3)) && ((%3) <= (%1(3)))) )

// �����h���b�O�J�n�\��
#defcfunc CanStartDragOnFooty int FootyID, int nViewID, int FontSize, int mx, int my, local Caret
	dim Caret, 2, 3
	dim select, 4
	dim rect, 4
	
	// ������͈͂̍ŏ��ƍő���m��
	Caret(0, 0) =       GetFirstVisibleLineOnFooty  ( FootyID, nViewID )
	Caret(1, 0) =       GetFirstVisibleColumnOnFooty( FootyID, nViewID )
	Caret(0, 1) = Caret(0) + Footy2GetVisibleLines  ( FootyID, nViewID )
	Caret(1, 1) = Caret(1) + Footy2GetVisibleColumns( FootyID, nViewID )
	
	// Footy�R���g���[���� RECT ���擾
	GetWindowRect Footy2GetWnd( FootyID, nViewID ), varptr(rect)
	if ( IsInRect(rect, mx, my) == _false_ ) {
		return _false_
	}
	
	// �I��͈͂��擾
	GetSelectOnFooty FootyID, select
	
	// �s�ԍ������[���[�̕����擾
	Footy2GetMetrics FootyID, SM_LINENUM_WIDTH, varptr(linenumWidth)	// �s�ԍ��̕�
	Footy2GetMetrics FootyID, SM_RULER_HEIGHT , varptr(rulerHeight)		// ���[���[�̍���
	
	logmes dbgstr(linenumWidth)
	logmes dbgstr(rulerHeight)
	
	// �}�E�X�̉��̃L�����b�g�ʒu���擾
	Caret(0, 2) = ( mx - (rect(0) + linenumWidth) ) / FontSize
	Caret(0, 3) = ( my - (rect(1) +  rulerHeight) ) / (FontSize + 1)
	
	logmes dbgpair(Caret(0, 2), Caret(0, 3))
	
	return 0
	
#global

#endif
