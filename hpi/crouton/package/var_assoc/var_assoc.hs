;--------------------------------------------------
; default

%dll
var_assoc.hpi

%ver
1.0

%date
2012.09/23 (Mon)	# Assoc(Result, Expr) �ǉ��AAssocClone �C��
2011.12/25 (Sun)	# Assoc(Chain, Copy, Dup) �ǉ�
2011.07/28 (Thu)	# multi �� assoc
2011.07/23 (Sat)
2011.06/23 (Thu)
2008.12/16 (Tue)

%author
uedai

%url
http://prograpark.ninja-web.net/

%note

%type
�ϐ��^�g���v���O�C��

%port
Win

%index
assoc
assoc�^�ϐ����쐬

%prm
p1, p2 = 1, p3 = 0, p4 = 0, p5 = 0
p1 = array	: assoc�^�ɂ���ϐ�
p2 = int	: �ꎟ���ڗv�f��
p3 = int	: �񎟌��ڗv�f��
p4 = int	: �O�����ڗv�f��
p5 = int	: �l�����ڗv�f��

%inst
assoc�^�̕ϐ����쐬���܂��Bdim���߂Ɠ����悤�Ȃ��̂Ȃ̂ŁA���߂̎g�����͂�������Q�Ƃ��Ă��������B

�쐬��́A�Ȃ�炩�̃L�[�����ĎQ�Ƃ����Ƃ��Ɏ��̂��m�ۂ���܂��B

%sample
#include "var_assoc.as"

#module

#deffunc drawRect array p1	// �K�� array �Ŏ󂯎��K�v����
	boxf p1("left"), p1("top"), p1("right"), p1("bottom")
	return
	
#global

	assoc rect
	
	color 255
	rect("left")   = 10		// �ŏ��� ("") �ŎQ�Ƃ����̂Ŋm�ۂ����
	rect("top")    = 10
	rect("right")  = 120
	rect("bottom") = 120
	drawRect rect
	stop
	
%href
sdim
ddim
dim
dimtype

%group
�������Ǘ�����

%index
AssocDelete
assoc��j������

%prm
p1
p1 = var	: assoc

%inst
assoc �I�u�W�F�N�g��j�����AAssocNull �������܂��B

%sample
%href
%group
�������Ǘ�����

%index
AssocClear
assoc�̃L�[��S�ď�������

%prm
p1
p1 = var	: assoc

%inst
assoc����S�ẴL�[���폜���܂��B

%sample
%href
AssocChain
AssocCopy
AssocDup

%group
�������Ǘ�����

%index
AssocChain
assoc ��A������

%prm
p1, p2
p1 = var	: assoc
p2 = var	: assoc

%inst
p2 �������ׂẴL�[���Ap1 �ɕ������Ēǉ����܂��B
�����L�[�̗v�f������ꍇ�A�㏑������Ap2 �̗v�f�̕����ƂȂ�܂��B

%sample
%href
AssocClear
AssocCopy
AssocDup

%group
�������Ǘ�����

%index
AssocCopy
assoc �𕡎ʂ���

%prm
p1, p2
p1 = var	: assoc
p2 = var	: assoc

%inst
p1 �� p2 �̕����ɂ��܂��B�܂�Ap2 �����S�Ă̗v�f�𕡐����� p1 �ɒǉ����܂��B
p1 �������Ă����v�f�͑S�ď�������܂��B

%sample
%href
AssocClear
AssocChain
;AssocCopy
AssocDup

%group
�������Ǘ�����

%index
AssocDup
assoc �̕����𓾂�

%prm
p1
p1 = var	: assoc

%inst
p1 �������ׂĂ̗v�f�̕��������� assoc �𐶐����A�ԋp���܂��B

%sample
%href
AssocClear
AssocChain
AssocCopy
;AssocDup

%group
�������Ǘ�����

%index
AssocInsert
assoc �L�[��}������

%prm
p1, p2 [, p3]
p1 = var	: assoc
p2 = str	: �L�[
p3 = any	: �����l

%inst
assoc �Ɏw��L�[��}�����܂��B
���ʂɑ������̂Ƃقړ����ł��B

%sample
	assoc a
	AssocInsert a, "name", "a"
;	a("name") = "a"
	
%href
AssocRemove

%group
�������Ǘ�����

%index
AssocRemove
assoc�̃L�[����������

%prm
p1, p2
p1 = var	: assoc
p2 = str	: �L�[

%inst
assoc����L�[���폜���܂��B�폜���ꂽ�L�[�́A����������Ă��Ȃ����̂Ƃ��Ĉ����܂��B

%sample
%href
AssocInsert

%group
�������Ǘ�����

%index
AssocDim
assoc�����ϐ���z��ɂ���

%prm
p1("�L�["), p2=vartype("int"), p3=1, p4=0, p5=0, p6=0
p1 = var	: assoc �����ϐ�
p2 = int	: �^�^�C�v�l
p3 = int	: �ꎟ���ڗv�f��
p4 = int	: �񎟌��ڗv�f��
p5 = int	: �O�����ڗv�f��
p6 = int	: �l�����ڗv�f��

%inst
assoc �̓����ϐ���z��Ƃ��Đ錾���܂��B�^�^�C�v�l�́Avartype �֐����Ԃ��l�ł��B

������g�p����ƁA���̓����ϐ��������Ă����f�[�^�����ׂč폜�����̂ŁA���ӂ��Ă��������B

���v�f���� AssocLen �֐��Ŏ擾���܂��B

%sample
#include "var_assoc.as"
	assoc m
	AssocDim m("x"), vartype("int"), 4
	    m("x", 3) = 333
	mes m("x", 3)
	stop
	
%href
AssocLen

sdim
ddim
dim
dimtype

%group
�������Ǘ�����

%index
AssocClone
assoc�̓����ϐ����N���[������

%prm
p1("�L�["), p2
p1 = var	: assoc �����ϐ�
p2 = var	: �N���[���ɂ���ϐ�

%inst
p2 ���Aassoc �̓����ϐ��̃N���[���ɂ��܂��B
�W���� dup ���߂̂悤�ɓ����܂��B

%sample
#include "assoc.as"

	assoc m
	AssocDim m("a"), vartype("int"), 3
	m("a", 2) = 3
	AssocClone m("a", 2), x	// �N���[��
	mes x
	
	x = 12		// ����������
	mes m("a", 2)	// ���̃f�[�^�����������܂�
	stop

%href
dup
dupptr

%group
����������

%index
AssocNewCom
assoc�̓����ϐ���comobj�ɂ���

%prm
p1("�L�["), p2, p3=0, p4=0
p1 = var	: assoc �����ϐ�
p2 = str	: �C���^�[�t�F�[�X���A�܂��̓N���XID
p3 = int	: �쐬���[�h(�I�v�V����)
p4 = int	: �Q�ƌ��|�C���^(�I�v�V����)

%inst
assoc�̓����ϐ��ɑ΂��āAnewcom ���߂��s���܂��B

���}�N��

%sample
#include "var_assoc.as"

	assoc m
	AssocNewCom m("com"), "WScript.Shell"	// newcom �Ɠ����g����
	
	mcall m("com"), "Run", dirinfo(3) +"/notepad.exe"	// ���������N������
	
	AssocDelCom m("com")	// �j��
	stop

%href
#usecom
#comfunc
newcom
delcom
comres
mcall

;AssocNewCom
AssocDelCom

%group
COM�I�u�W�F�N�g���얽��

%index
AssocDelCom
assoc�̓����ϐ���comobj��j��

%prm
p1("�L�[")
p1 = var	: assoc �����ϐ�

%inst
AssocNewCom�ō쐬���� comobj ��j�����܂��Bdelcom ���߂Ɠ���
�g�����Ȃ̂ŁA��������Q�Ƃ��Ă��������B

���}�N��

%sample
%href
newcom
delcom

AssocNewCom
;AssocDelCom

%group
COM�I�u�W�F�N�g���얽��

%index
AssocVarinfo
assoc�̓����ϐ��̏����擾

%prm
(p1("�L�["), type=0, option=0)
p1 = var	: assoc�^�ϐ�

%inst
assoc�̓����ϐ��̊e������擾���܂��B����́A�ʏ��varptr()
�֐���Avartype()�֐��Ȃǂ�����ɓ���ł��Ȃ����߂ɑ�ւƂ���
�p�ӂ��ꂽ�֐��ł��B�ʏ�̊֐��Ŏ擾�ł��Ȃ������܂Ŏ擾�\
�ƂȂ��Ă��܂��B

html{
<table border="1">
	<thead>
		<tr>
			<th>type</th>
			<th>option</th>
			<th>return value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>VARINFO_FLAG</td>
			<td>---</td>
			<td>�^�^�C�v�l( vartype() )</td>
		</tr><tr>
			<td>VARINFO_MODE</td>
			<td>---</td>
			<td>�ϐ����[�h( �ʏ�͎g�p���Ȃ� )</td>
		</tr><tr>
			<td>VARINFO_LEN</td>
			<td>���� - 1</td>
			<td>�z��̗v�f��( length() )</td>
		</tr><!--<tr>
			<td>VARINFO_SIZE</td>
			<td>---</td>
			<td>�o�b�t�@�T�C�Y( �ʏ�͎g�p���Ȃ� )</td>
		</tr>--><tr>
			<td>VARINFO_PT</td>
			<td>---</td>
			<td>�ϐ��ւ̃|�C���^( varptr() )</td>
		</tr><tr>
			<td>VARINFO_MASTER</td>
			<td>---</td>
			<td>PVal::master�̒l( �ʏ�͎g�p���Ȃ� )</td>
		</tr>
	</tbody>
</table>
}html

���̊֐��́AAssocRef()���g�p���Ă��������B

%sample
%href
vartype
varptr
length

%group
�g�����o�͊֐�

%index
AssocSize
assoc �v�f��

%prm
(p1)
p1 = var	: assoc

%inst
assoc �����L�[�ƒl�̃y�A�̐� (�v�f��) ��Ԃ��܂��B

%sample
%group
�g�����o�͊֐�

%index
AssocExists
assoc �L�[�����݂��邩

%prm
(p1, "�L�[")
p1 = var	: assoc
p2 = str	: �L�[

%inst
assoc ���w��L�[�̗v�f�����Ƃ��^��Ԃ��܂��B

%sample
%group
�g�����o�͊֐�

%index
AssocRef
assoc�̓����ϐ����Q�Ƃ���

%prm
(p1("�L�["))
p1 = var	: assoc �����ϐ�

%inst
assoc �̓����ϐ��̃N���[����Ԃ��܂��B�ϐ��Ɠ��l�Ɉ����Ă��������B

�N���[���������ɂȂ�Adim�Ȃǂ̖��߂�^�ϊ��Ȃǂ��s���Ă����Ӗ��Ȃ̂ŋC��t���Ă��������B

%sample
%href
%group
�Q�Ɗ֐�

%index
assoc
assoc�^�̌^�^�C�v�l

%inst
vartype( AssocTypeName ) �̒l��Ԃ��܂��B

%sample
%href

%group
���[�U�[��`�V�X�e���ϐ�

%index
AssocVtName
assoc�^�̌^��

%inst
assoc �̐����Ȍ^���̕�������擾���܂��B"assoc" �ł͂���܂���B

%sample
%href
assoc

%group
���[�U�[��`�V�X�e���ϐ�

%index
AssocNull
assoc null

%inst
assoc �� null �l�ł��B

%sample
%href
%group
���[�U��`�V�X�e���ϐ�
