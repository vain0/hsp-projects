// �z��V�t�g���W���[��

#ifndef IG_MODULE_SHIFT_ARRAY_AS
#define IG_MODULE_SHIFT_ARRAY_AS

#module shift_array_mod

#define global ArrayRangeEndDefault (-127)

//------------------------------------------------
// �z���Ԃ̐��K�� @private
// 
// @result: ���]��Ԃ��ۂ�
//------------------------------------------------
#deffunc ArrayRangeRegularize@shift_array_mod array self, array range,  local tmp
	if ( range(1) == ArrayRangeEndDefault ) { range(1) = length(self) }
	
	if ( range(0) > range(1) ) {		// ��Ԃ��t => ���� + 1 ���Č���
		tmp      = range(0) + 1
		range(0) = range(1) + 1
		range(1) = tmp
		return true
	} else {
		return false
	}
	
//------------------------------------------------
// �}�� ( �I�ȏ��� )
//------------------------------------------------
#deffunc ArrayInsert array self, int idx
	
	// �}�������ꏊ���󂯂�
	for i, length(self), idx, -1
		self(i) = self(i - 1)
	next
	
	return
	
//------------------------------------------------
// �폜 ( �I�ȏ��� )
//------------------------------------------------
#deffunc ArrayRemove array self, int idx
	
	// �폜�����ꏊ������ ( ���̒l�ŏ㏑������ )
	for i, idx, length(self) - 1
		self(i) = self(i + 1)
	next
	
	return
	
//------------------------------------------------
// �ړ�
//------------------------------------------------
#deffunc ArrayMove array self, int from, int to,  local temp, local dir
	if ( from == to ) { return }
	
	// �ړ����̒l��ۑ�����
	temp = self(from)
	
	// �ړ�����
	if ( from > to ) {
		dir = -1				// ��ɐi�ނȂ� -1
	} else {
		dir = 1
	}
	for i, from, to, dir
		self(i) = self(i + dir)	// ���̏ꏊ�̒l���󂯎��
	next
	self(to) = temp
	
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#deffunc ArraySwap array self, int pos1, int pos2,  local temp
	if ( pos1 == pos2 ) { return }
	temp       = self(pos1)
	self(pos1) = self(pos2)
	self(pos2) = temp
	return
	
//------------------------------------------------
// ����
// 
// @prm self
// @prm step         : �������
// @prm [iBgn, iEnd) : ����Ώۂ̋��
//------------------------------------------------
#deffunc ArrayRotateImpl array self, int iBgn, int iEnd, int dir,  local range
	range = iBgn, iEnd
	ArrayRangeRegularize self, range
	
	if ( dir >= 0 ^ stat ) {		// ���]��� => �t������ Rotate
		ArrayMove self, range(0), range(1) - 1
	} else {
		ArrayMove self,           range(1) - 1, range(0)
	}
	return
	
// �t��]
#define global ArrayRotate(    %1, %2 = 0, %3 = ArrayRangeEndDefault) ArrayRotateImpl %1, %2, %3,  1
#define global ArrayRotateBack(%1, %2 = 0, %3 = ArrayRangeEndDefault) ArrayRotateImpl %1, %2, %3, -1

//------------------------------------------------
// ���]
// 
// @prm this
// @prm [iBgn, iEnd) : ���]�Ώۂ̋��
//------------------------------------------------
#define global ArrayReverse(%1, %2 = 0, %3 = ArrayRangeEndDefault) ArrayReverse_ %1, %2, %3
#deffunc ArrayReverse_ array self, int iBgn, int iEnd,  local range
	range = iBgn, iEnd
	ArrayRangeRegularize self, range
	if ( stat ) { return }			// ���]��� => ���]���Ă��߂�̂ŏ�������K�v�Ȃ�
	
	repeat (range(1) - range(0)) / 2
		ArraySwap self, range(0) + cnt, range(1) - cnt - 1
	loop
	
	return
	
#global

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

#module
#define global output(%1,%2) _output %1, %2, "%2"
#deffunc _output str ps1, array pa2, str ps3
	mes ps1
	foreach pa2
		mes ps3 + strf("(%d) = ", cnt) + pa2(cnt)
	loop
	return
#global

	dim a, 6
	
	// �����l��ݒ肷��
	foreach a
		a(cnt) = cnt
	loop
	
	//######## �v�f�̑}�� ###########################
	// �}����̔ԍ�
	p = 0
	
	ArrayInsert a, p
	
	// �}������
	a(p) = 100
	
	// �\��
	pos 20, 20
	output "Array Insert", a
	
	//######## �v�f�̈ړ� ###########################
	p = 3	// �ړ����̔ԍ�
	t = 1	// �ړ���̔ԍ�
	
	ArrayMove a, p, t
	
	// �\��
	pos 140, 20
	output "Array Move", a
	
	//######## �v�f�̌��� ###########################
	// ��������v�f�Q��
	p = 4, 2
	
	ArraySwap a, p(0), p(1)
	
	// �\��
	pos 260, 20
	output "Array Swap", a
	
	//######## �v�f�̏��� ###########################
	ArrayRotate a
	
	// �\��
	pos 380, 20
	output "Array Rotate", a
	
	//######## �v�f�̍폜 ###########################
	// �폜����ԍ�
	p = 3
	
	ArrayRemove a, p
	
	// �\��
	pos 500, 20
	output "Array Remove", a		// (5) �͍폜���ꂽ�c�[
	
	stop
	
#endif

#endif
