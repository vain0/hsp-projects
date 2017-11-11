// �z��V�t�g���W���[��

#ifndef IG_MODULE_SHIFT_ARRAY_AS
#define IG_MODULE_SHIFT_ARRAY_AS

#module shift_array_mod

//------------------------------------------------
// �}�� ( �I�ȏ��� )
//------------------------------------------------
#deffunc ArrayInsert array arr, int idx
	
	// �}�������ꏊ���󂯂�
	for i, length(arr), idx, -1
		arr(i) = arr(i - 1)
	next
	
	return
	
//------------------------------------------------
// ���� ( �I�ȏ��� )
//------------------------------------------------
#deffunc ArrayRemove array arr, int idx
	
	// ���������ꏊ������ ( ���̒l�ŏ㏑������ )
	for i, idx, length(arr) - 1
		arr(i) = arr(i + 1)
	next
	
	return
	
//------------------------------------------------
// �ړ�
//------------------------------------------------
#deffunc ArrayMove array arr, int from, int to,  local temp
	if ( from == to ) { return }
	
	// �ړ����̒l��ۑ�����
	temp = arr(from)
	
	// �ړ�����
	if ( from > to ) {
		dir = -1				// ��ɐi�ނȂ� -1
	} else {
		dir = 1
	}
	for i, from, to, dir
		arr(i) = arr(i + dir)	// ���̏ꏊ�̒l���󂯎��
	next
	arr(to) = temp
	
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#deffunc ArraySwap array arr, int pos1, int pos2,  local temp
	if ( pos1 == pos2 ) { return }
	temp      = arr(pos1)
	arr(pos1) = arr(pos2)
	arr(pos2) = temp
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#deffunc ArrayRotate array arr, int step,  local temp
	if ( step >= 0 ) {
		ArrayMove arr, 0, length(arr) - 1
	} else {
		ArrayMove arr,    length(arr) - 1, 0
	}
	return
	
// �t��]
#define global ArrayRotateBack(%1) ArrayRotate %1, -1

//------------------------------------------------
// ���]
//------------------------------------------------
#define global ArrayReverse(%1,%2=-1) ArrayReverse_ %1,%2
#deffunc ArrayReverse_ array arr, int _lenArray,  local lenArray
	if ( _lenArray < 0 ) {
		lenArray = length(arr)
	} else {
		lenArray = _lenArray
	}
	
	repeat lenArray / 2
		ArraySwap arr, cnt, lenArray - cnt - 1
	loop
	
	return
	
#global

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

#module

#define global ArrayOutput(%1) ArrayOutput_ %1, "%1"
#deffunc ArrayOutput_ array arr, str ident
	foreach arr
		mes ident + strf("(%d) = ", cnt) + arr(cnt)
	loop
	return
	
#global

	gosub *LInitialize
	gosub *LInsert
	gosub *LMove
	gosub *LSwap
	gosub *LRotate
	gosub *LRemove
	stop
	
//------------------------------------------------
// ������
//------------------------------------------------
*LInitialize
	dim a, 6
	
	// �����l��ݒ肷��
	foreach a
		a(cnt) = cnt
	loop
	
	return
	
//------------------------------------------------
// �}��
//------------------------------------------------
*LInsert
	// �}����̔ԍ�
	p = 0
	
	ArrayInsert a, p
	
	// �}������
	a(p) = 100
	
	// �\��
	pos 20, 20
	mes "Array Insert"
	ArrayOutput a
	return
	
//------------------------------------------------
// �ړ�
//------------------------------------------------
*LMove
	p = 3	// �ړ����̔ԍ�
	t = 1	// �ړ���̔ԍ�
	
	ArrayMove a, p, t
	
	// �\��
	pos 140, 20
	mes "Array Move"
	ArrayOutput a
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
*LSwap
	// ��������v�f�Q��
	p = 4, 2
	
	ArraySwap a, p(0), p(1)
	
	// �\��
	pos 260, 20
	mes "Array Swap"
	ArrayOutput a
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
*LRotate
	ArrayRotate a
	
	// �\��
	pos 380, 20
	mes "Array Rotate"
	ArrayOutput a
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
*LRemove
	// ��������ԍ�
	p = 3
	
	ArrayRemove a, p
	
	// �\��
	pos 500, 20
	mes "Array Remove"
	ArrayOutput a		// (6) �͏������ꂽ�c�[
	
	stop
	
#endif

#endif
