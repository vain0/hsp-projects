;#############################
%dll
abdata_unor

%author
uedai

%date
2010 07/18 (Sun)	// �ŏI�X�V �\�L�ȂǁA���낢�����
2009 10/04 (Sun)	// 
2009 09/03 (Thu)	// �쐬

%ver
1.0

%type
���ۃf�[�^�\�� �A�z�z�� ( �s����R���e�i )

%group
�����o�֐�

%url
http://prograpark.ninja-web.net/

;--------------------
%index
unor_make
Unor �\�z (�ꎞ)

%prm
()

%inst
�V�����A�z�z�� (Unordered) ���\�z���A�Ԃ��܂��B

%href
unor_make
unor_new
unor_delete

%group
�\�z�֐�

;--------------------
%index
unor_new
Unor �\�z

%prm
self
var self : �C���X�^���X���i�[����ϐ�

%inst
�A�z�z����\�z���܂��B

%href
unor_make
unor_new
unor_delete

%group
�\�z�֐�

;--------------------
%index
unor_delete
Unor ���

%prm
self
inst self : �A�z�z��

%inst
�A�z�z�����̂��܂��B

���̊֐��̓v���O�����I�����A�����ŌĂяo����邽�߁A�ʏ�A�Ăяo���K�v�͂���܂���B

%href
unor_make
unor_new
unor_delete

%group
��̊֐�

;--------------------
%index
unor_get
Unor �l�̎擾

%prm
(self, key = "")
inst self : �A�z�z��
str  key  : �L�[

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l���擾���܂��B

�L�[���Ȃ��ꍇ�Aint(0) �̒l�Ƃ̑g�Ƃ��Ēǉ����܂��B

%href
unor_get
unor_getv
unor_pop
unor_popv
unor_clone
unor_ref

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_getv
Unor �l�̎擾 ( �ϐ� )

%prm
self, key = "", vResult
inst self    : �A�z�z��
str  key     : �L�[
var  vResult : �l���i�[����ϐ�

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l�� vResult �Ɋi�[���܂��B

�L�[���Ȃ��ꍇ�Aint(0) �̒l�Ƃ̑g�Ƃ��Ēǉ����܂��B

%href
unor_get
unor_getv
unor_pop
unor_popv
unor_clone
unor_ref

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_pop
Unor �l�̎��o��

%prm
(self, key = "")
inst self : �A�z�z��
str  key  : �L�[

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l�����o���ĕԂ��܂��B���̗v�f�ƃL�[�̑g�͍폜����܂��B

�L�[���Ȃ��ꍇ�Aint(0) �̒l�Ƃ̑g�Ƃ��Ēǉ����܂��B

%href
unor_get
unor_getv
unor_pop
unor_popv
unor_clone
unor_ref

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_popv
Unor �l�̎��o�� ( �ϐ� )

%prm
self, key = "", vResult
inst self    : �A�z�z��
str  key     : �L�[
var  vResult : �l���i�[����ϐ�

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l�����o���ĕԂ��܂��B���̗v�f�ƃL�[�̑g�͍폜����܂��B

�L�[���Ȃ��ꍇ�Aint(0) �̒l�Ƃ̑g�Ƃ��Ēǉ����܂��B

%href
unor_get
unor_getv
unor_pop
unor_popv
unor_clone
unor_ref

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_clone
Unor �v�f�̃N���[���� ( �ϐ� )

%prm
self, key, vRef
inst self : �A�z�z��
str  key  : �L�[
var  vRef : �N���[���ɂ���ϐ�

%inst
vRef ���w��L�[�Ɋ֘A�Â����Ă���v�f�̃N���[���ɂ��܂��B

�L�[���Ȃ��ꍇ�Aint(0) �̒l�Ƃ̑g�Ƃ��Ēǉ����܂��B

%href
unor_get
unor_getv
unor_pop
unor_popv
unor_clone
unor_ref

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_ref
Unor �Q��

%prm
(self, key = "")
inst self : �A�z�z��
str  key  : �L�[

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̃N���[����Ԃ��܂��B

�L�[���Ȃ��ꍇ�Aint(0) �̒l�Ƃ̑g�Ƃ��Ēǉ����܂��B

%sample
	
	unor_new unor
	unor_add unor, "key", "Hello, world!"
	mes unor_ref(unor, "key")
	stop
	
%href
unor_get
unor_getv
unor_pop
unor_popv
unor_clone
unor_ref

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_vartype
Unor �^�̎擾

%prm
(self, key = "")
inst self : �A�z�z��
str  key  : �L�[

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l�̌^��Ԃ��܂��B

%href
;unor_vartype

%group
�����o�֐�::�擾�n

;--------------------
%index
unor_add
Unor �v�f�̒ǉ�

%prm
self, key = "", value = 0
inst self  : �A�z�z��
str  key   : �ǉ�����L�[
any  value : �ǉ�����v�f�̒l

%inst
�A�z�z��ɁAkey �̃L�[�����v�f��ǉ����܂��B

���̃L�[�����łɑ��݂���ꍇ�A���̖��߂͖�������܂��B
�����́A�L�[�������̏ꍇ�̓���ɂ��āA���ӌ���W���ł��B�䂦�ɁA�d�l�ύX�����\�������ɍ������߁A�ˑ����Ȃ����Ƃ𐄏����܂��B

%href
unor_add
unor_addv

unor_set
unor_setv

%group
�����o�֐�::����n

;--------------------
%index
unor_addv
Unor �v�f�̒ǉ� ( �ϐ� )

%prm
self, key, vValue
inst self   : �A�z�z��
str  key    : �ǉ�����L�[
var  vValue : �ǉ�����v�f�̒l���i�[�����ϐ�

%inst
�A�z�z��ɁAkey �̃L�[�����v�f��ǉ����܂��B

���̃L�[�����łɑ��݂���ꍇ�A���̖��߂͖�������܂��B
�����̓���ɂ��āA���ӌ���W���ł��B�䂦�ɁA�d�l�ύX�����\�������ɍ������߁A�ˑ����Ȃ����Ƃ𐄏����܂��B

%href
unor_add
unor_addv

unor_set
unor_setv

%group
�����o�֐�::����n

;--------------------
%index
unor_set
Unor �l�̐ݒ�

%prm
self, key = "", value
inst self  : �A�z�z��
str  key   : �L�[
any  value : �ݒ肷��l

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l�� value �ɕύX���܂��B�L�[���Ȃ��ꍇ�́A�ǉ�����܂��B

%href
unor_add
unor_addv

unor_set
unor_setv

%group
�����o�֐�::����n

;--------------------
%index
unor_setv
Unor �l�̐ݒ� ( �ϐ� )

%prm
self, key, vValue
inst self   : �A�z�z��
str  key    : �L�[
var  vValue : �l���i�[���Ă���ϐ�

%inst
�w��L�[�Ɋ֘A�Â����Ă���v�f�̒l�� vValue �̒l�ɕύX���܂��B�L�[���Ȃ��ꍇ�́A�ǉ�����܂��B

%href
unor_add
unor_addv

unor_set
unor_setv

%group
�����o�֐�::����n

;--------------------
%index
unor_erase
Unor �v�f�̍폜

%prm
self, key
inst self : �A�z�z��
str  key  : �L�[

%inst
�A�z�z�񂩂�Akey �̃L�[�ƁA���̒l�̃y�A���폜���܂��B

���̃L�[�����݂��Ȃ��ꍇ�A���̖��߂͖�������܂��B

%href

%group
�����o�֐�::����n

;--------------------
%index
unor_clear
Unor ���� [i]

%prm
self
inst self : �A�z�z��

%inst
�A�z�z�񂩂炷�ׂĂ̗v�f����菜���A��ɂ��铝��֐��ł��B

%href
unor_clear
unor_chain
unor_copy
unor_swap

%group
�����o�֐�::�R���e�i����n

;--------------------
%index
unor_chain
Unor ���� [i]

%prm
self, src
inst self : �A�z�z��
inst src  : �V

%inst
�A�z�z�� self �ɁA�A�z�z�� src �������ׂĂ̗v�f��ǉ����铝��֐��ł��B

��self �� src ���Ƃ��Ɏ��L�[�̗v�f�̈����́Aunor_add �Ɠ��l�ł��B

%href
unor_clear
unor_chain
unor_copy
unor_swap

%group
�����o�֐�::�R���e�i����n

;--------------------
%index
unor_copy
Unor ���� [i]

%prm
self, src
inst self : �A�z�z��
inst src  : �V

%inst
�A�z�z�� self �� src �Ɠ����L�[�Ɨv�f�����悤�ɂ��铝��֐��ł��B���X self �ɂ��������ׂĂ̗v�f�͎�菜����܂��B

%href
unor_clear
unor_chain
unor_copy
unor_swap

%group
�����o�֐�::�R���e�i����n

;--------------------
%index
unor_swap
Unor �R���e�i���� [i]

%prm
self, obj
inst self : �A�z�z��
inst obj  : �V

%inst
2�̘A�z�z�� self, obj �̓��e�����ׂē���ւ��铝��֐��ł��B

%href
unor_clear
unor_chain
unor_copy
unor_swap

%group
�����o�֐�::�R���e�i����n

;--------------------
%index
unor_iter_init
Unor �����q::������ [i]

%prm
self, iterData
inst self     : �A�z�z��
var  iterData : �����q���

%inst
�A�z�z��̔����q�����������铝��֐��ł��B

%href
unor_iter_init
unor_iter_next

%group
�����o�֐�::�����q����n

;--------------------
%index
unor_iter_next
Unor �����q::�X�V [i]

%prm
(self, vIt, iterData)
inst self     : �A�z�z��
var  vIt      : it �ϐ�
var  iterData : �����q���

%inst
�A�z�z��̔����q���X�V���铝��֐��ł��B

it �ϐ� vIt �ɂ́A�L�[�̕����񂪊i�[����܂��B

%href
unor_iter_init
unor_iter_next

%group
�����o�֐�::�����q����n

;--------------------
%index
unor_size
Unor �v�f�� [i]

%prm
(self)
inst self : �A�z�z��

%inst
�A�z�z��Ɋ܂܂��v�f�̐���Ԃ�����֐��ł��B

%note
unor_length �Ɠ����B

%href

%group
�����o�֐�

;--------------------
%index
unor_count_value
Unor �v�f�̐����グ

%prm
(self)
inst self : �A�z�z��
var val : ������l

%inst
�A�z�z��Ɋ܂܂��A�l val �����v�f�̐���Ԃ������ł��B

%note
%href

%group
�����o�֐�

;--------------------
%index
unor_key
Unor �L�[�̐����グ

%prm
(self, key)
inst self : �A�z�z��
str  key  : �L�[

%inst
�w�肵���L�[�̐���Ԃ��܂��B�L�[�̏d���͋�����Ă��Ȃ��̂ŁA���݂���ꍇ�� 1�A���݂��Ȃ��ꍇ�� 0 �ƂȂ�܂��B

%href

%group
�����o�֐�

;--------------------
%index
unor_dbglog
Unor �f�o�b�O�o��

%prm
self
inst self : �A�z�z��

%inst
�A�z�z��Ɋ܂܂�邷�ׂĂ̗v�f�� logmes �ŏo�͂��܂��B

%href

%group
�����o�֐�::�f�o�b�O�n
