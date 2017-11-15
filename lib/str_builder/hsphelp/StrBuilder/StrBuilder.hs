%dll
StrBuilder.hsp

%port
Win

%group
�����񑀍얽��

;--------------------
%index
StrBuilder_new
StrBuilder�\�z

%prm
self, def_capa
array self: StrBuilder �C���X�^���X������z��ϐ�
int def_capa [4096]: �����L���p�V�e�B

%inst
StrBuilder �N���X�̃C���X�^���X�����B�����I�ɂ� newmod ���߁B

def_capa �ɂ��Ă� StrBuilder_capacity ���Q�ƁB

;--------------------
%index
StrBuilder_set
��������㏑������

%prm
self, s
str s: �㏑����̕�����

%inst
StrBuilder �������Ă������̕�������������āAs ���������ށB

;--------------------
%index
StrBuilder_append
������𖖔��ɒǋL����

%prm
self, src, src_len
str src: �������ޕ�����
int src_len: src �̒��� (�ȗ���)

%inst
StrBuilder �C���X�^���X�������Ă��镶����̖����ɁAsrc ��t��������B

src �̒��������炩���ߕ������Ă���ꍇ�́Asrc_len ���w�肷�邱�Ƃ� ``strlen(src)`` �̎��s������ł���B

;--------------------
%index
StrBuilder_append_v
������𖖔��ɒǋL����

%prm
self, src, src_len

var src: �������ޕ����񂪓������ϐ� 
int src_len: src �̒��� (�ȗ���)

%inst
StrBuilder_append �Ɠ����B������̂ق������s�����������B

;--------------------
%index
StrBuilder_strsize
�Ō��append�̒���

%prm
()

%inst
���O�ɌĂ΂ꂽ StrBuilder_append, StrBuilder_append_v �֐��ŏ������܂ꂽ��������Ԃ��B

�����̖��߂��ǂ̃C���X�^���X�ɑ΂��ČĂ΂ꂽ���͊֌W�Ȃ��B
StrBuilder_append_char �Ȃǂ̂ق��̖��߂̉e���͎󂯂Ȃ��B

;--------------------
%index
StrBuilder_append_char
1�����𖖔��ɏ���������

%prm
self, c
int c: �������ޕ���

%href
StrBuilder_append

;--------------------
%index
StrBuilder_erase_back
�����̕������폜����

%prm
self, len
int len: �폜���镶����

%inst
������̌��� len �o�C�g���폜����B

len ��������̒������傫���Ƃ��́A�S�č폜�����B

;--------------------
%index
StrBuilder_ensure_capacity
�L���p�V�e�B�����ȏ�ɂ���

%prm
self, new_capa
int new_capa: �v������L���p�V�e�B

%inst
StrBuilder �̃o�b�t�@�� new_capa �ȏ�̃L���p�V�e�B�����悤�ɗv������B

new_capa �����݂̃L���p�V�e�B���傫���Ƃ��ɂ̂݃o�b�t�@�g����������B

%href
StrBuilder_capacity

;--------------------
%index
StrBuilder_copy_to
��������o�b�t�@�ɏ�������

%prm
self, buf
var buf: ������o�b�t�@

%inst
StrBuilder �������Ă��镶������Abuf �ɓ]�ʂ���B

;--------------------
%index
StrBuilder_length
������̒���

%prm
(self)

%href
strlen

;--------------------
%index
StrBuilder_capacity
�m�ۍς݃L���p�V�e�B�̑傫��

%prm
(self)

%inst
StrBuilder �������I�Ɋm�ۂ��Ă���L���p�V�e�B�̑傫����Ԃ��B

�L���p�V�e�B�Ƃ́AStrBuilder �������Ƃ��ł��镶����̒����̍ő�l�ł���B(�o�C�g�P�ʁB�I�[�������܂܂Ȃ��B)

StrBuilder_append ���߂Ȃǂŕ����񂪒����Ȃ�Ƃ��A�����L���p�V�e�B�����肸�ɏ������ނ��Ƃ��ł��Ȃ���΁A�����I�ɃL���p�V�e�B��傫������B

;--------------------
;%index
;StrBuilder_str
;������𕶎���^�̒l�ŕԂ�
;
;%prm
;(self)
;;
;%inst
;�񐄏�

;--------------------
%index
StrBuilder_data_ptr
������o�b�t�@�ւ̃|�C���^

%prm
(self)

%inst
StrBuilder �������I�ɕۑ����Ă��镶����ւ̃|�C���^��Ԃ��B

dupptr �ȂǂŎg�p�ł���B�ʏ�g�p����K�v�͂Ȃ��B

;--------------------
%index
StrBuilder_dup
������o�b�t�@�̃N���[���ϐ������

%prm
(self)

%inst
StrBuilder �������I�ɕۑ����Ă��镶����ϐ��̃N���[�������B�����I�ɂ� dup ���߁B

���g�𕶎���^�̕ϐ��Ƃ��Ĉ��������Ƃ��Ɏg�p�ł���B
�������A�������ύX���鑀������Ă͂����Ȃ��B

�N���[���ϐ��́A���� self �� StrBuilder_append �̂悤�ȕ�����𒷂����閽�߂��g�����Ƃ��ɉ���B

;--------------------
%index
StrBuilder_clear
���������ɂ���

%prm
self

%inst
StrBuilder ���ۑ����Ă��镶��������ׂč폜����B

�L���p�V�e�B�͏k�܂Ȃ��B

;--------------------
%index
StrBuilder_chain
������𖖔��ɉ�����

%prm
self, src
StrBuilder src: �������ޕ����������StrBuilder�C���X�^���X

%inst
src �������Ă��镶������Aself �̖����ɏ���������B

%href
StrBuilder_append

;--------------------
%index
StrBuilder_copy
�������]�ʂ���

%prm
self, src
StrBuilder src: �������ޕ����������StrBuilder�C���X�^���X

%inst
src �������Ă��镶������Aself �ɓ]�ʂ���Bself �����X�����Ă���������͏�����B
