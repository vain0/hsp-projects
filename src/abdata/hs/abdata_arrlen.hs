%dll
abdata
%group
�f�[�^�\��
%type
�������z��



%index
arrlen_is_valid_len
�u�����v���L���Ȓl���H
%prm
(self, len)
array self: �z��
int   len:  self �̒����H
return: len �� self �̒����Ƃ��ėL���Ȑ����Ȃ�^



%index
arrlen_clear
������
%prm
self, len
array self
var   len: self �̒���
%inst
self �������Ă����f�[�^����������B



%index
arrlen_chain
�A��
%prm
self, len, rhs, rhs_len
array self
var   len: self �̒���
array rhs: �A������z��
int   rhs_len: �A�����钷��
%inst
self �̌��� rhs (���� rhs_len) ��A������B

len == 0 �̂Ƃ��Aself �� rhs �̃R�s�[�ɂ���Blen > 0 �̂Ƃ��́Aself �� rhs �̌^�������łȂ���΂����Ȃ��B



%index
arrlen_compare
����������
%prm
(self, len, rhs, rhs_len)
array self
int   len
array rhs
int   rhs_len
return: ��r�l
%inst
(self, len) �� (rhs, rhs_len) �������������Ŕ�r����B



%index
arrlen_insert_no_init
�v�f��1�}������ (�������Ȃ�)
%prm
(self, len, i)
array self
var   len
int   i: �}������ʒu
%inst
self �� i �ԖڂɐV�����v�f��}������B�}�����ꂽ�v�f�͏����l�����B

�v�f�ԍ� i ���Ȃ��Ƃ��́A�����g������B



%index
arrlen_set
�v�f�ւ̑��
%prm
self, len, i, value
array self
var len
int i: �v�f�ԍ�
var value: �������l
%inst
self �� i �Ԗڂ̗v�f�� value ��������B

i �Ԗڂ̗v�f�����ɂ���Ȃ�A�㏑�������B�Ȃ���΁A�z��͗v�f�� (i + 1) �ɂȂ�B



%index
arrlen_erase_range
�͈͓��̗v�f������
%prm
(self, len, lb, ub)
array self
var len
int lb, ub: ��菜���Y���͈̔�
%inst
self ����Y�� [lb, ub) �̗v�f����������B

[lb, ub) �� { lb, lb + 1, lb + 2, ..., ub - 2, ub - 1 } ��\���B�Ⴆ�� [1, 4) = { 1, 2, 3 }�B



%index
arrlen_erase_many
�v�f������
%prm
(self, len, i, count)
array self
var len
int i: ��������v�f�̈ʒu
int count: ��������v�f�̌�
%inst
self �� i �Ԗڂ��� count �̗v�f����������B
%href
arrlen_erase_range



%index
arrlen_iter_swap
�v�f������
%prm
(self, len, i0, i1)
array self
int len
int i0, i1: ��������v�f�̓Y��
%inst
self �� i0, i1 �Ԗڂ�2�̗v�f����������B



%index
arrlen_iter_move
�v�f������
%prm
(self, len, i_src, i_dst)
array self
int len
int i_src: �ړ�����v�f�̈ʒu
int i_dst: �ړ���̈ʒu
%inst
self �� i_src �Ԗڂ̗v�f���Ai_dst �ԖڂɈړ�����B



%index
arrlen_reverse
�v�f�𔽓]
%prm
(self, len, i_beg, i_end)
array self
int len
int i_beg, i_end: �ʒu
%inst
self �͈̔� [i_beg, i_end) �ɂ���v�f�̏��Ԃ𔽓]����B



%index
arrlen_is_sorted
����ς݂��H
%prm
(self, len)
array self
int len
return: self �������ɐ���ς݂Ȃ�^
%inst
self �������ɐ���ς݂ł���Ƃ́A���Ȃ킿 self(0) <= self(1) <= ... <= self(len - 1) �ƂȂ邱�ƁB

����ς݂̔z��̂��߂̓��ʂȖ��ߌQ���p�ӂ���Ă���B
%href
arrlen_equal_range
arrlen_ord_count
arrlen_ord_insert
arrlen_ord_erase



%index
arrlen_lb
���E�ʒu������
%prm
(self, len, value)
array self: ����ςݔz��
int len
var value: �T���l
%href
arrlen_equal_range



%index
arrlen_ub
��E�ʒu������
%prm
(self, len, value)
array self: ����ςݔz��
int len
var value: �T���l
%href
arrlen_equal_range



%index
arrlen_equal_range
�l�͈̔͂�����
%prm
self, len, value, lb, ub
array self: ����ςݔz��
int len
var value: �T���l
var lb: ���E�̒l��������ϐ�
var ub: ��E�̒l��������ϐ�
%inst
����ς݂̔z�� self �ɂ��� value ���A�����ĕ���ł���ʒu [lb, ub) ���v�Z����B�ȉ��ɏڂ����������B

��Ƃ��Ď��̂悤�Ȕz����l����B

  self = 10, 10, 20, 50, 50, 50, 90
  len  = 7

�z�� self �͐���ς�(arrlen_is_sorted)�Ȃ̂ŁA�����ɂ��� 10 �� 50 �̂悤�ɁA�����l�͕K���A�����ĕ��ԁB

�܂��A���� value = 50 ���^����ꂽ�ꍇ���l����Blb, ub �Ƃ����̂́u50 ���ǂ�����ǂ��܂łɂ��邩�v��\�����l�ɂȂ�B�܂�Alb �́u50 ���ŏ��ɂ���ʒu�v���w���ԍ��ŁAub �́u50 ���Ō�ɂ���ʒu�̎��v���w���ԍ��ɂȂ�B

  self = 10, 10, 20, (lb�̈ʒu) 50, 50, 50, (ub�̈ʒu) 90
  lb = 3
  ub = 6

���K�̂��߁Avalue = 20 �̏ꍇ���l���Ă݂悤�B����������悤�Ɂuself �̂ǂ�����ǂ��܂ł� 20 �ɂȂ��Ă��邩�v���v�Z����΂����B

  self = 10, 10, (lb�̈ʒu) 20, (ub�̈ʒu) 50, 50, 50, 90
  lb = 2
  ub = 3

�܂��Avalue = 90 �̏ꍇ�������悤�Ȍ��ʂɂȂ邪�A����͏�����������ł���B90 �͔z�� self �̍Ō�ɂ���̂ŁAub = �u90 ���Ō�ɂ���ʒu�̎��v���w���ԍ��́A�z��̒����ɂȂ�B

  self = 10, 10, 20, 50, 50, 50, (lb �̈ʒu) 90 (ub�̈ʒu)
  lb = 6
  ub = 7

�Ō�ɁAvalue = 30 �Ƃ��āuvalue �� self �Ɋ܂܂�Ă��Ȃ��v�ꍇ���l����B���̂Ƃ��͍��܂Ōv�Z���Ă����uself �̂Ȃ��ɂ��� value �̈ʒu�v�Ƃ����l���������܂������Ȃ��B����ɁA�uself �̂Ȃ��� value �͂ǂ��ɂ���ׂ����H�v���l���悤�Bself ������ς݂ł��邽�߂ɂ́Avalue = 30 �́u20 ����A50 ���O�v�ɂȂ���΂����Ȃ��B

  self = 10, 10, 20, (lb�̈ʒu) (ub�̈ʒu) 50, 50, 50, 90
  lb = 3
  ub = 3

����ǂ��P�[�X�̗��2�グ�āA�������I���ɂ��悤�B

  (�T���l���A�z��̂��ׂĂ̒l��菬�����ꍇ)
  value = 0
  self  = (lb�̈ʒu) (ub�̈ʒu) 10, 10, 20, 50, 50, 50, 90
  lb = 0
  ub = 0

  (�T���l���A�z��̂��ׂĂ̒l���傫���ꍇ)
  value = 100
  self = 10, 10, 20, 50, 50, 50, 90 (lb�̈ʒu) (ub�̈ʒu)
  lb = 7
  ub = 7

----
���̑�

2���T�����g���BO(log len) ���ԁB
%href
arrlen_lb
arrlen_ub
arrlen_ord_count



%index
arrlen_sorted_count
�l�̌�
%prm
(self, len, value)
array self
int len
var value: �T���l
return: self �̂Ȃ��ɂ��� value �̐�
%inst
self �͐���ς݂łȂ���΂����Ȃ��B



%index
arrlen_sorted_insert
����ςݑ}��
%prm
(self, len, value, may_dup)
array self
int len
var value: �}������l
bool may_dup (= true): �d�������}�����邩
return: �}�����ꂽ�v�f�̌�
%inst
self ������ς݂̂܂܂ɂȂ�悤�ɁA�K�؂Ȉʒu�� value ��}������B



%index
arrlen_sorted_erase
����ςݏ���
%prm
(self, len, value)
array self
int len
var value: ��������l
int max_count (= ��): ��������ő��
return: �������ꂽ�v�f�̌�
%inst
self ���� value �ɓ������v�f���ő� max_count �܂ŏ�������B
