%dll
abdata_list
%type
���ۃf�[�^�\��
%group
�^�Ȃ��z��

;--------------------
%index
list_make
�\�z
%prm
()
%inst
�V�������X�g���쐬���āA���̎���ID (�����l) ��Ԃ��B

�쐬�������X�g��ID�́A�e�� list_ ���߁E�֐��̍ŏ��̈����Ɏw��ł���B

���X�g���s�v�ɂȂ�����A�Ȃ�ׂ� list_delete ���߂��Ăяo�����ƁB

;--------------------
%index
list_from_array
�\�z (�z��̕���)
%prm
(rhs, len)
array rhs
int len: rhs �̒���
%inst
���X�g�̐V�����C���X�^���X���쐬���āA���̎���ID��Ԃ��B

���X�g�ɂ� rhs �̍ŏ��� len �̗v�f�̃R�s�[�����B
%href
list_make

;--------------------
%index
list_delete
�j��
%prm
self
int self
%inst
���X�g self ����̂���B�Ȍ�Aself ���w��ID���g�p����Ɓu�������ȓ���v���N����̂Œ��ӁB

���X�g�̂��ׂẴC���X�^���X�́A�s�v�ɂȂ����Ƃ��ɁA���傤��1�� list_delete �����̂��]�܂����B�������A�v���O�����̏I������ list_delete ���g���K�v�͂Ȃ��B

;--------------------
%index
list_size
�v�f��
%prm
(self)
%inst
���X�g self �����v�f�̌���Ԃ��B
%href
length

;--------------------
%index
list_regular_ix
�C���f�b�N�X�̐��K��
%prm
(self, ix)
int self
int ix: �ʒu
%inst
���X�g�� ix �Ԗڂ̈ʒu��\�������l��Ԃ��B

1. ix ��0�ȏ�Alist_size(self)�����Ȃ�Aix �����̂܂ܕԂ����B
2. ix �� -list_size(self) �ȏ� -1 �ȉ��Ȃ�Aix + list_size(self) ���Ԃ�B�悤����ɁA�Ō�̗v�f�̈ʒu�� -1�A���̑O�̈ʒu�� -2�A�ȂǂƎg�p�ł���B
3. ������ł��Ȃ��ꍇ�̓G���[�ɂȂ�B

���̊֐��́A�uix�v�Ƃ������O�̈����ɑ΂��Ď����I�Ɏg�p�����B���[�U���g���K�v�͂Ȃ��B(�ʒu��\���ui�v�́A��q�� 1. �̒l�����󂯂��Ȃ��B)

;--------------------
%index
list_vartype
�v�f�̌^ID
%prm
(self, ix)
int self
int ix: �v�f�ԍ�
%inst
���X�g�� ix �Ԗڂ̗v�f�̒l�̌^ID(vartype)��Ԃ��B

;--------------------
%index
list_get
�l�̎擾
%prm
(self, ix)
inst self
int ix: �v�f�ԍ�
%inst
���X�g�� ix �Ԗڂ̗v�f�̒l��Ԃ��B
%href
list_regular_ix
list_try_get

;--------------------
%index
list_try_get
�l�̎擾
%prm
(self, result, i)
int self
var result: �l����������ϐ�
int i: �v�f�ԍ�
return: ����������^
%inst
���X�g�� i �Ԗڂ̗v�f�̒l���A�ϐ� result �ɑ������B

i �̒l���s���Ȃ玸�s���A�U(0)���Ԃ�B

;--------------------
%index
list_try_dup
�N���[���ϐ��̍쐬
%prm
(self, ref, i)
int self
var ref: �N���[���ϐ��ɂ���ϐ�
int i: �v�f�ԍ�
return int: ���������Ȃ�^
%inst
���X�g�� i �Ԗڂ̗v�f�̃N���[���ϐ��ɂ���B

�N���[���ϐ��́A���̗v�f�̌^���ύX���ꂽ�Ƃ���Aself �̗v�f�������������Ƃ��ȂǂɁA�g�p�ł��Ȃ��Ȃ�B

i �̒l���s���ł���Ƃ��ɂ͎��s���A�U(0)���Ԃ�B
%href
dup
list_try_dup

;--------------------
%index
list_ref
��Q��
%prm
(self, ix)
int self
int ix: �v�f�ԍ�
return: ix �Ԗڂ̗v�f�ւ̎�Q��
%inst
���X�g�� ix �Ԗڂ̗v�f�̃N���[���ϐ�������ĕԂ��B

���Ɏg���K�v�͂Ȃ��B
%href
list_try_dup

;--------------------
%index
list_setv
�v�f�̏㏑��
%prm
self, value, ix
int self
var value: �ݒ肷��l
int ix: �v�f�ԍ�
%inst
���X�g�� ix �Ԗڂ̗v�f�̒l�� value �ɕύX����B�v�f�̌^�� value �̌^�ɕύX�����B

;--------------------
%index
list_insertv
�v�f�̑}��
%prm
self, value, ix
int self
var value: �}������l
int ix: �}������ʒu
%inst
���X�g�� ix �ԖڂɁA�V�����v�f��}������B

ix �� list_size() �ȏ�̒l���w�肵���ꍇ���G���[�ɂȂ�Ȃ��B�v�f���� (ix + 1) �ɂȂ�悤�ɁA�v�f���}�������B
%href
list_pushv_front
list_pushv_back

;--------------------
%index
list_pushv_front
�擪�ւ̑}��
%prm
self, value
int self
var value: �}������l
%inst
���X�g�̐擪�ɒl value �̗v�f��}������B

;--------------------
%index
list_pushv_back
�����ւ̑}��
%prm
self, value
int self
var value: �}������l
%inst
���X�g�̖����ɒl value �̗v�f��}������B

;--------------------
%index
list_erase
�v�f�̏���
%prm
self, ix
int self
int ix: �v�f�ԍ�
%inst
���X�g�� ix �Ԗڂ̗v�f�����X�g�����菜���B
%href
list_erase_range

;--------------------
%index
list_erase_range
�v�f�̏��� (�͈�)
%prm
self, ix_beg, ix_end
int self
int ix_beg, ix_end: �ʒu
%inst
���X�g�� [ix_beg, ix_end) �Ԗڂ̗v�f�����X�g���珜������B

;--------------------
%index
list_iter_swap
�v�f�̌���
%prm
self, ix0, ix1
int self
int ix0, ix1: ��������v�f�̈ʒu
%inst
���X�g�� ix0, ix1 �Ԗڂ̗v�f����������B

;--------------------
%index
list_iter_move
�v�f�̈ړ�
%prm
self, ix_src, ix_dst
int self
int ix_src: �v�f�̈ړ��O�̈ʒu
int ix_dst: �v�f�̈ړ���̈ʒu

%inst
���X�g�� ix_src �Ԗڂ̗v�f���Aix_dst �ԖڂɈړ�������B

;--------------------
%index
list_reverse
�v�f���̔��]
%prm
self
int self
int ix_beg, ix_end: �v�f�͈̔�
%inst
���X�g�� [ix_beg, ix_end) �Ԗڂ̗v�f�̏��Ԃ��t�ɂ���B

;--------------------
%index
list_shuffle
�v�f���̖���׉�
%prm
self
int self
int ix_beg, ix_end: �v�f�͈̔�
%inst
���X�g�� [ix_beg, ix_end) �Ԗڂ̗v�f�̏��Ԃ���l�ɖ���׉�����B

;--------------------
%index
list_permutate
�v�f���̎w��
%prm
self
int self
array perm: �u��
%inst
���X�g�� i �Ԗڂ̗v�f�� perm(i) �ԖڂɈړ�������B

�z�� perm �́A[0, list_size(self)) ����ёւ�������łȂ���΂����Ȃ��Blist_regular_ix �͓K�p����Ȃ��B

;--------------------
%index
list_count
�v�f�̐����グ
%prm
(self)
int self
var val: ������l
%inst
���X�g�Ɋ܂܂��A�l�� val �ɓ������v�f�̌���Ԃ��B(�^�̈Ⴄ�l�́A�قȂ�l�Ƃ݂Ȃ����B)

;--------------------
%index
list_compare
��r
%prm
(self, rhs)
int self
int rhs: ���X�g�̃C���X�^���XID
return int: ��r�l
%inst
2�̃��X�g self, rhs ���������Ŕ�r����B

�Ⴄ�^�̒l�́A�^ID(vartype)�̏������ق����������A�Ƃ݂Ȃ��B

�Ԃ�����r�l�́A���̂悤�ȈӖ����������l�ł���B
 �� �� self �� rhs ��菬�����B
 0  �� self �� rhs ���������B
 �� �� self �� rhs ���傫���B

;--------------------
%index
list_clear
����
%prm
self
int self
%inst
���X�g���炷�ׂĂ̗v�f����������B

;--------------------
%index
list_chain
�A��
%prm
self, rhs
int self
int rhs: ���X�g�̃C���X�^���XID

%inst
���X�g rhs �Ɋ܂܂��e�v�f���Aself �̖����ɒǉ�����B

;--------------------
%index
list_dbglog
�f�o�b�O�o��

%prm
self
int self
%inst
���X�g�̂��ׂĂ̗v�f�� logmes �ŏo�͂���B

;--------------------
%index
list_is_sorted
����ς݂��H
%prm
(self, sort_mode)
int self
int sort_mode (= abdata_sort_ascending): ����
return int: ���X�g������ς݂Ȃ�^
%inst
���X�g�����񂳂�Ă��邱�Ƃ��m�F����B

sort_mode �͎���2�̂ǂ��炩�B
abdata_sort_ascending: ���� (���������̂��O�A�傫�����̂���)
abdata_sort_decending: �~�� (�傫�����̂��O�A���������̂���)
%href
list_compare
list_sort

list_equal_range
list_lb
list_ub
list_sorted_insertv
list_sorted_erasev

;--------------------
%index
list_sort
����
%prm
self, sort_mode
int self
int sort_mode (= abdata_sort_ascending): ����
%inst
���X�g�𐮗񂷂�B
%href
list_ix_sort
list_is_sorted

;--------------------
%index
list_ix_sort
����
%prm
self, perm, sort_mode
int self
array perm: �u������������z��
int sort_mode (= abdata_sort_ascending): ����
%inst
���X�g�𐮗񂷂�B

perm �́u���Ƃ��� i �Ԗڂɂ������v�f�� perm(i) �ԖڂɈړ������v�Ƃ������Ƃ�\���z��ϐ��B

;--------------------
%index
list_equal_range
�l�͈̔�
%prm
self, value, lb, ub, sort_mode
int self
var value
var lb, ub: �l�̉��E�Ə�E
int sort_mode (= abdata_sort_ascending): ����
%inst
arrlen_equal_range ���Q�ƁB

���̖��߂̓��X�g������ς�(list_is_sorted)�łȂ���΂����Ȃ��B
%href
list_is_sorted

;--------------------
%index
list_sorted_insertv
����ς݂̑}��
%prm
self, value, may_dup, sort_mode
int self
var value: �}������l
int may_dup (= true): �d�������}�����邩�H
int sort_mode (= abdata_sort_ascending): ����
%inst
����ς�(list_is_sorted)�̃��X�g�ɁA������ۂ悤�ɒl value �����v�f��}������B

may_dup �� false (= 0) ���w�肵���Ƃ��A���X�g�ɒl�� value �ɓ������v�f������Ȃ�A�v�f��}�����Ȃ��B

;--------------------
%index
list_sorted_erasev
����ς݂̏���
%prm
self, value, max_count, sort_mode
int self
var value: �}������l
int max_count (= ��): ��������v�f���̍ő�
int sort_mode (= abdata_sort_ascending): ����
%inst
����ς�(list_is_sorted)�̃��X�g����A�l value �ɓ������v�f����������B

�l value �ɓ������v�f����������ꍇ�A�ő�� max_count ������菜���B
