;--------------------------------------------------
; HSP help source (hs)
; default

%dll
call.hpi

%ver
1.21

%date
;2008 11/9 (Sun)
;2008 11/10 (Mon)
;2008 12/11 (Thu)
;2008 12/30 (Tue)
;2009 08/10 (Mon)
;2009 08/16 (Sun)
;2009 08/18 (Tue)
2010 05/22 (Sat)

%author
uedai

%url
http://prograpark.ninja-web.net/

%note
%type
HSP3.2�g���v���O�C��

%port
Win

%portinfo
WindowsXP�ł̂ݓ���m�F

;-----------------------------
%index
call
���x�����ߌĂяo��

%prm
lbDst, ...
label lbDst	: �W�����v�惉�x��
any   ...	: ���x�����߂̈������X�g

%inst
���x���ɁA�����t���ŃT�u���[�`���Ăяo�����s���܂��B

�����́A��{�I�ɒl�n���ł����Abyref() �Ɉ͂܂ꂽ�ϐ��͎Q�Ɠn�����܂��B
�ʂɎw�肷��ɂ́Acall ���O�� call_decprm ���g�p���āA�����̏���ݒ肵�Ă����܂��B
���Q�Ɠn���Ƃ́A�ϐ����̂������ɓn�����Ƃł��B�܂�A���ߑ��������ɒl��������ƁA�Ăяo����̕ϐ��̒l���ω����܂��B( #deffunc �ł����Ƃ���� var �����ł��B )
�@�΂��āA�l�n���ł͒l�̃R�s�[��n�����߁A�Ăяo���悪�����ɑ�������Ƃ��Ă��A�Ăяo�����ɂ͉e���͑S������܂���B

�����̐��Ǝ�ނ͎��R�ł��B�������錾���Ȃ��ꍇ�́A�����̌^�␔�̃`�F�b�N�Ȃǂ͍s���܂��� ( �������^�A����m�点����@������܂��� )�B�������A���x������ str �^�ƐM���Ĉ������g�p���Ă���\���͂���܂��B�����ӂ��������B
�ȗ����ꂽ�����ɂ́Aint(0) ���n����܂��B�������A#deffunc ���g�p���Ă���ꍇ�́A�ȗ����ꂽ�����̃G�C���A�X�͖����ɂȂ�܂��B

#deffunc �����x���̑O�ɒu�����ƂŁA�G�C���A�X�@�\���g�p���邱�Ƃ��\�ł��B
����ɂ��A������ÓI�ȕϐ��ŊǗ�����K�v���Ȃ��Ȃ�܂��B���R�A�����̈����� argv �ȂǂŎQ�Ƃ��邱�Ƃ��\�ł��B���̏ꍇ�A�����̌^�ɂ͂��ׂ� var �� array ���g�p���Ă��������B�萔( �ϐ��ȊO )�� var �ł��B�z��ϐ����󂯎��ꍇ�� array �ɂ��܂��B
�����̃v���O�C���́A�����ň����l�����ׂāAHSP�̕ϐ��Ɠ������@�ŊǗ����Ă��邽�߁A���̂悤�Ȏd�l�ɂȂ��Ă��܂��B
������ #deffunc �Œ�`���ꂽ���߂͒��ڌĂяo�����Ƃ��ł��܂����A���S���͕ۏ؂��܂���B
��local �͎g�p�ł��܂���B
�������Acall_dec �ɂ���ĉ��������錾�ς݂ł���ꍇ�́Avar �ł͂Ȃ��A�ʏ�̃^�C�v���g�p���Ă������� (int, str, var, array �Ȃ�)�B

�܂��Acall �̂�����̋@�\�Ƃ��āAlabel �̑���ɁAdefidOf() �Ŏ擾�����l���w�肷�邱�Ƃ��\�ł��B���̏ꍇ�A�Ăяo�����̂̓��x�����߁E�֐��ł͂Ȃ����[�U�薽�߁E�֐��ɂȂ�܂��B

%sample

%href
call
call_dec

defidOf

%group
�g���v���O�������䖽��

;-----------------------------
%index
call
���x���֐��Ăяo��

%prm
(dst, ...)
label dst	: �W�����v�惉�x��
any   ...	: ���x���֐��̈������X�g

%inst
���x���ɁA�����t���ŃT�u���[�`���Ăяo�����s���܂��B

�֐�(call)�̕Ԓl�́A�ʏ�ʂ� return �ŕԂ����Ƃ��\�ł��Breturn ���ł��Ȃ� label �^��Ԃ������ꍇ�́Acall_retval ���߂��g�p���Areturn�ŉ����Ԃ��Ȃ��ł��������B�܂��A���O�� call �̖߂�l�� call_result() �Ŏ擾���邱�Ƃ��ł��܂��B

����ȊO�́A���ߌ`���� call �Ɠ��l�ł��B��������Q�Ƃ��Ă��������B

�Ȃ��AHSP3.1�����ňȑO�ł́A�����ɒ��ڃ��x�������������ނƃv���v���Z�b�T�ɒe����Ă��܂����߁A���x���^�ϐ��Ƀ��x���������Ă���A�����Ɏw�肷��K�v������܂��B
�� HSP3.2 �ȍ~�ł͖�肠��܂���B

%sample

%href
call
call_retval
call_result

%group
�g���v���O�������䖽��

;-----------------------------
%index
call_dec
���x�����߁E�֐��̉������錾

%prm
*lbDst, ...
label   lbDst : �Ăяo���惉�x��
prmtype ...   : ���������X�g

%inst
���x�����߁E�֐��̉������錾���s���܂��B
���������錾����Ă���ꍇ�A�ȉ��̓_���A�ʏ�ƈقȂ�܂��B

�E�����̏ȗ����Ɋ���l������܂��B
  str(""), double(0.0), int(0) �ł��B���͏ȗ��ł��܂���B
�Estr �^���ȗ��ł��܂��B����l�͋󕶎���("")�ł��B
�E�^�`�F�b�N�����܂��B�������Aint <-> double �̌^�ϊ��͍s���܂���B
�E#deffunc �̃G�C���A�X�ɁAvar �ł͂Ȃ� int �� str ���g�p���܂��B

�g���鉼�����^�C�v�́A�ȉ��̒ʂ�ł��B�^���� "" �ł�����A������ɂ��Ă��������B
���ꉼ�����́APRM_TYPE_* �Ƃ����萔�ł��BVAR, ARRAY, ANY, FLEX ���g�p�ł��܂��B
html{
<table>
	<thead>
		<tr>
			<th>�萔</th>
			<th>����</th>
			<th>�Ӗ�</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>PRM_TYPE_LABEL</td>
			<td>"label"</td>
			<td>label�^�B�ȗ��ł��܂���B</td>
		</tr><tr>
			<td>PRM_TYPE_STR</td>
			<td>"str"</td>
			<td>str�^�B����l ""�B</td>
		</tr><tr>
			<td>PRM_TYPE_DOUBLE</td>
			<td>"double"</td>
			<td>double�^�B����l 0.0�B</td>
		</tr><tr>
			<td>PRM_TYPE_INT</td>
			<td>"int"</td>
			<td>int�^�B����l 0�B</td>
		</tr><tr>
			<td>PRM_TYPE_VAR</td>
			<td>"var"</td>
			<td>�z��łȂ��ϐ����󂯎��܂��B</td>
		</tr><tr>
			<td>PRM_TYPE_ARRAY</td>
			<td>"array"</td>
			<td>�z��ϐ����󂯎��܂��B</td>
		</tr><tr>
			<td>PRM_TYPE_ANY</td>
			<td>"any"</td>
			<td>�Ȃ�ł��󂯎��܂��B��{�͒l�n���ł��Bbyref ���g���ƁA�ϐ����Q�Ɠn�����܂��B<br>
				�܂�A�������錾���Ă��Ȃ����x�����߂̈����Ɠ��������ł��B
			</td>
		</tr><tr>
			<td>PRM_TYPE_FLEX</td>
			<td>"..."</td>
			<td>�ϒ�������\���܂��B�������X�g�̍Ō�ɂ̂ݎw��ł��܂��B<br>
				�ϒ��̕����̈����^�C�v�́A���ׂ� any �ł��B
			</td>
		</tr>
	</tbody>
</table>
}html
�萔�ł��A�������p���Ă������ł��B

%href
call

method_add

%group
�g���v���O�������䖽��

;-----------------------------
%index
call_alias
�����̃G�C���A�X���쐬����

%prm
vAlias, idxArg = 0
var vAlias : �G�C���A�X������ϐ�
int	idxArg : �����̔ԍ�( 0 �` )

%inst
�ϐ� vAlias ���A(idxArg + 1) �Ԗڂ̈����̃G�C���A�X�ɂ��܂��B��{�I�ɁA#deffunc �̃G�C���A�X�Ɠ����ƍl���Ă�����Ă����܂��܂���B
���������� 0�A�������� 1 �c�c�Ƃ�����ł��B
���Q�Ɠn���̏ꍇ�́Avar �����B

�w�肵���ԍ��̈����ɒl���n����Ă��Ȃ������ꍇ�A����l�ł��� int(0) �ɂȂ�܂��B
�w�肵���ϐ����ʂ̏ꏊ�� call_alias ���ꂽ�ꍇ�A�㏑������Ă��܂��܂��B���̂悤�Ȋ댯������A������ō���ꍇ�́Aargv() �� refarg() ���g�p������������ł��B

��HSP2.xx �� mref ���߂Ǝ����悤�Ȃ��̂ł��B

%sample

%href
call
;call_alias
call_aliasAll

%group
�g���������Ǘ�����

;-----------------------------
%index
call_aliasAll
�����̃G�C���A�X���쐬����( �ꊇ )

%prm
...
var ... : �G�C���A�X������ϐ����X�g

%inst
���ׂĂ̕ϐ����A�����Ɠ������ԂŃG�C���A�X�ɂ��܂��B�s�v�Ȉ����͏ȗ����Ă����܂��܂���B�܂��A�n����Ă��Ȃ������͊���l�Ƃ��� int(0) �ɂȂ�܂��B

�v����ɁAcall_alias ����C�ɍs�����߂ł��B

�����̐�( argc )��葽���̕ϐ���n�����ꍇ�̓���́A����`�ł��B

%sample

%href
call
call_alias
;call_aliasAll

%group
�g���������Ǘ�����

;-----------------------------
%index
call_retval
���x���֐��̕Ԓl��ݒ�

%prm
result
any result : �Ԓl

%inst
���s���̃��x���֐��̕Ԓl��ݒ肵�܂��B���̏ꍇ�́Areturn ���߂̈������ȗ�����
�������� ( return �̕����D�悳��邽�� )�B
�܂��Acall_retval ���g���΁A���x���^��Ԃ����Ƃ��\�ł��B

%sample

%href
call
;call_retval
call_result

%group
�g���������Ǘ�����

;-----------------------------
%index
call_result
���x���֐��̕Ԓl�𓾂�

%prm

%inst
���O�̃��x���֐��̕Ԓl��Ԃ��܂��B

���x�����߂̕Ԓl�͕Ԃ��Ȃ��̂Œ��ӂ��Ă��������B

%sample

%href
call
call_retval
;call_result

%group
�g���������Ǘ��֐�

;-----------------------------
%index
call_arginfo
�����̏��𓾂�

%prm
(p1, p2 = -1)
p1 = int	: ���ID ( ARGINFOID_* )
p2 = int	: �����̔ԍ�( 0 �` )

%inst
�{�U�� �� arginfo

%sample
%href
arginfo
argc
argv
refarg

%group
�g���������Ǘ��֐�

;-----------------------------
%index
arginfo
�����̏��𓾂�

%prm
(idInfo, idxArg = -1)
int idInfo	: ���ID ( ARGINFOID_* )
int idxArg	: �����̔ԍ�( 0 �` )

%inst
���x�����߁E�֐��ɓn���ꂽ�����̏����擾���܂��B
�����̔ԍ� idxArg ������( �܂��͏ȗ� )�̏ꍇ�A�����S�̂̏����擾���܂��B

�ʂ̏��ɂ́A�ȉ��̎�ނ�����܂��B

ARGINFOID_FLAG	: vartype
ARGINFOID_MODE	: �ϐ����[�h( 0 = ����, 1 = �ʏ�, 2 = �N���[�� )
ARGINFOID_LEN1	: �ꎟ���ڗv�f��
ARGINFOID_LEN2	: �񎟌��ڗv�f��
ARGINFOID_LEN3	: �O�����ڗv�f��
ARGINFOID_LEN4	: �l�����ڗv�f��
ARGINFOID_SIZE	: �S�̂̃o�C�g��
ARGINFOID_PTR	: ���̂ւ̃|�C���^
ARGINFOID_BYREF	: �Q�Ɠn��(byref)���ۂ�

������ȊO�ɁA�擾�o����悤�ɂ��ė~�������̂�����΁AURL�̃T�C�g�̌f���ň˗�
���Ă��������B( �s�\�ȏꍇ������܂��B )

�S�̂̏��́A���݁u�����̐� (argc)�v�݂̂ł��B

%sample

%href
;arginfo
argc
argv
refarg

%group
�g���������Ǘ��֐�

;-----------------------------
%index
argcount
�����̐�

%prm

%inst
�{�U�� �� argc

%sample

%href
arginfo
argc
argv
refarg

%group
���[�U��`�V�X�e���ϐ�

;-----------------------------
%index
argc
�����̐�

%prm

%inst
call �ɓn���ꂽ�������̐���Ԃ��܂��B

%sample

%href
arginfo
;argc
argv
refarg

%group
���[�U��`�V�X�e���ϐ�

;-----------------------------
%index
call_argv
�����̒l���擾����

%prm
(idxArg = 0)
int idxArg : �����̔ԍ�( 0 �` )

%inst
�{�U�� �� argv

%sample

%href
arginfo
argc
argv
refarg

%group
�g���������Ǘ��֐�

;-----------------------------
%index
argv
�����̒l���擾����

%prm
(idxArg = 0)
int idxArg	: �����̔ԍ�( 0 �` )

%inst
�w�肵���ԍ��̈����̒l���擾���܂��B
�������Q�Ɠn���ł��A�l�݂̂����o���܂��B( �� refarg() )

�ċA�ȂǁA���x�����߁E�֐��̒��ł���� call ����ꍇ�́Acall_alias �Ȃǂ̖��߂ł͂Ȃ��A���̊֐��Œl���擾����悤�ɂ��Ă��������B
( �G�C���A�X�ɂȂ��Ă���ϐ����㏑�������댯�����邽�� )�B

%sample

%href
arginfo
argc
argv
refarg

%group
�g���������Ǘ��֐�

;-----------------------------
%index
refarg
�Q�Ɠn���̈������擾����

%prm
(idxArg = 0)
int idxArg	: �����̔ԍ�( 0 �` )

%inst
�Q�Ɠn���̈����ɁA�l��������Ƃ��Ɏg�p���܂��B�K��������̍��ӂɏ����Ă��������B
( argv �Ƃ͈Ⴂ�܂��B )

����̑��ɁAcall_alias ���g�p������@������܂��B

%sample
*SetRange
	repeat argv(1) - argv(0), argv(0)
		refarg(cnt) = cnt
	loop
	
%href
call_alias
call_aliasAll
argv
;refarg

%group
�g���������Ǘ��֐�

;-----------------------------
%index
call_thislb
�Ăяo���惉�x��

%prm

%inst
�{�U�� �� thislb

%sample

%href
call
thislb

%group
���[�U��`�V�X�e���ϐ�

;-----------------------------
%index
thislb
�Ăяo���惉�x��

%prm

%inst
call���߁E�֐��ŌĂяo���ꂽ���x����Ԃ��܂��B�ċA�ł̏������s�������Ƃ��ȂǂɁA�g�p����ƕ֗���������܂���B

%sample
// �K������߂�֐� ( �Ȃ����ċA�����܂� )
*fact_f
	if ( 0 != argv(0) ) {
		return call( thislb, (argv(0) - 1) ) * argv(0)
	} else {
		return 1.0
	}
	return
	
%href
call
;thislb

%group
���[�U��`�V�X�e���ϐ�


;###########################################################
;        stream �Ăяo��
;###########################################################
%index
call_stream_begin
stream call �J�n

%prm
[dst]
label dst : �W�����v��

%inst
�X�g���[���Ăяo���̊J�n��\���܂��B���łɁA�W�����v��̃��x���̐ݒ���ł��܂��B

�X�g���[���Ăяo���Ƃ́A�����𓮓I�Ȍ��Œǉ����邽�߂̋@�\�ł��B���� call_stream_begin ���߂���n�܂�Acall_stream_add �ň�����ǉ����A�Ō�ɒǉ����ꂽ���ׂĂ̈����������āAcall_stream �Ń��x�����߁E�֐����Ăяo���܂��B
����ɂ��A�ϒ������̌������[�v�Ō��߂�A�Ȃǂ��\�ɂȂ�܂��B

%sample
#include "call.as"

	randomize
	call_stream_begin *textcat
	call_stream_add "var x $list := {", "\n\t"
	repeat rnd(10)
		call_stream_add strf("%3d, ", rnd(100))
	loop
	call_stream_add "\n};"
	mes call_stream()		// �֐��`��
	stop
	
// �������S���q����֐�
*textcat
	sdim stmp
	repeat argc
		stmp += argv(cnt)
	loop
	return stmp
	
%href
call_stream_begin
call_stream_label
call_stream_add
call_stream

%group
���[�U�g������

;-----------------------------
%index
call_stream_label
stream call ���x���ݒ�

%prm
dst
label dst : �W�����v�惉�x��

%inst
�X�g���[���Ăяo���ɂ����āA�W�����v��̃��x����ݒ肵�܂��B���łɐݒ�ς݂̏ꍇ���A���x�ł��㏑�����邱�Ƃ��\�ł��B

���x�����ݒ肳��Ă��Ȃ��ꍇ�Acall_stream �͎��s���܂��B

%href
call_stream_begin
call_stream_label
call_stream_add
call_stream

%group
���[�U�g������

;-----------------------------
%index
call_stream_add
stream call �����̒ǉ�

%prm
[...]
any ... : ���������X�g

%inst
�X�g���[���Ăяo���̎�������ǉ����܂��B���̖��߂͉��x�ł����s�ł��܂��B�Ăяo���Ƃ��̈����̏��Ԃ́A�ǉ����ꂽ���Ɠ����ɂȂ�܂��B

%sample

%href
call_stream_begin
call_stream_label
call_stream_add
call_stream

%group
���[�U�g������

;-----------------------------
%index
call_stream
stream call ���s

%prm

%inst
�X�g���[���Ăяo���̎��s���������܂��Bcall_stream_add �Œǉ����ꂽ�����������āAcall_stream_begin �܂��� call_stream_label �Őݒ肳�ꂽ���x���ɃW�����v���܂��B

�� call_stream_end �ł�����̏������\�ł��B

%sample

%href
call_stream_begin
call_stream_label
call_stream_add
call_stream

%group
�g���v���O�������䖽��


;###########################################################
;        method
;###########################################################
;-----------------------------
%index
method_replace
���\�b�h�@�\�̗��D

%prm
vt
vartype vt : �^�^�C�v�l or �^��

%inst
�^�������\�b�h�Ăяo���@�\��D�����܂��B����ŒD��������ꍇ�Amethod_add �Ń��\�b�h��Ǝ��ɒǉ��ł���悤�ɂȂ�܂��B���ɒD���Ă���ꍇ�́A�Ȃɂ����܂���B

HSP3.2 �ł́Acomobj �ȊO�̌^�ɂ̓��\�b�h�Ăяo���@�\��������Ă��Ȃ����߁A�D���Ė�肠��܂���B
���D��������Ăяo���@�\�͌��ɖ߂��܂���B
	�� �߂���悤�ɂ��ł��܂��̂ŁA���v������Ȃ�f���Ȃǂŗv�]���Ă��������B

%sample
#include "call.as"
	
	method_replace "int"	// int �^�̃��\�b�h�Ăяo���@�\��D��
	
%href
method_replace
method_add

%group
���[�U�g������

;-----------------------------
%index
method_add
���\�b�h�̒ǉ�

%prm
vt, "name", dst, ...
vartype vt     : �^�^�C�v�l or �^��
str     method : ���\�b�h��
label   dst    : ���\�b�h�̒�`�����郉�x��
any     ...    : ���������X�g

%inst
vt �̌^�Ƀ��\�b�h��ǉ����܂��B���̌^�ɂ́A���炩���� method_replace ���߂��g���Ă����K�v������܂��B

���������X�g�́Acall_dec �̂���Ɠ����ł��Bcall_dec ���Q�Ƃ��Ă��������B

%sample
#include "call.as"
	
	method_replace "int"	// int �^�̃��\�b�h�Ăяo���@�\��D��
	method_add     "int", "print", *method_int_print, "int"
	
	n = 0x0077FF00
	n->"print" 16	// 16 �i���ŕ\��
	stop
	
#deffunc _method_int_print var this
*method_int_print
	call_alias radix, 1
	if ( radix < 0 || radix > 32 ) { radix = 10 }
	
	if ( radix == 10 ) {
		mes this
	} else : if ( radix == 16 ) {
		mes strf("0x%08X", this)
	} else {
		// ��ϊ������Ȃǂ΂����藪
		mes this	// 10 �i���̂܂܂ŕ\��
	}
	return
	
%href
method_replace
method_add

call_dec

%group
���[�U�g������


;###########################################################
;        call-cmd
;###########################################################
;-----------------------------
%index
callcs
�R�}���h�Ăяo�� (���ߌ`��)

%prm
 (id) ...
defid id      : �R�}���hId
...   arglist : ���������X�g

%inst
id �̎����R�}���h���A���߂Ƃ��ČĂяo���܂��B

%sample
#include "call.hpi"

	callcs( defidOf(mes) ) "Hello, world!"
	
%href
;callcs
callcf

defidOf

%group
�g���v���O�������䖽��

;-----------------------------
%index
callcf
�R�}���h�Ăяo�� (�֐��`��)

%prm
(id [, (...)])
defid id    : �R�}���hId
... arglist : ���������X�g

%inst
id �������R�}���h���A�֐��܂��̓V�X�e���ϐ��Ƃ��ČĂяo���܂��B

�������� (...) ���ȗ������ꍇ�́A�V�X�e���ϐ��Ăяo���ł��B

%sample
#include "call.hpi"

#module

#defcfunc opAdd int lhs, int rhs
	return lhs + rhs
	
#global

	cmd_opBin = defidOf(opAdd)	// id �l�͕ϐ��Ɋi�[�ł���
	lhs =  2943
	rhs = 18782
	val = callcf( cmd_opBin, (lhs, rhs) )
	
	mes strf( "%d + %d = %d", lhs, rhs, val )
	mes "stat = " + callcf( defidOf(stat) )
	
	// �ϐ��̃R�}���hID (����͕s��)
	mes "lhs = " + callcf( defidOf(lhs) )
	
	stop
	
%href
callcs
;callcf

defid

%group
�g���v���O�������䖽��


;###########################################################
;        deff
;###########################################################
;-----------------------------
%index
defidOf
�R�}���h�� defid �̎擾

%prm
(cmd)
cmd p1 : �R�}���h

%inst
�R�}���h���� id �l���擾���܂��B

�R�}���h�Ƃ́A���߂�֐��̃L�[���[�h�A�ϐ��A�萔�A�ȂǁA�X�N���v�g���\������1��1�̂��̂ł� (�������L���͏���)�B
���̊֐��́A����� id �l�ɂ������̂�Ԃ��܂��Bid �l�� int �^�ł��B

���� p1 �Ƀ��[�U��`���߁E�֐����w�肵�ē��� id �l�� ModcmdId �ƌĂт܂��BisModcmdId(id) ���^��Ԃ��Ƃ��Aid �� ModcmdId �ł��B
���̒l�́Acall �R�}���h�Ȃǂ́u�W�����v��v�ɁA���x���̑���Ƃ��Ďg�p�ł��܂��B

���̑��̃R�}���h���X�N���v�g�Ƃ��Ď��s����ɂ́A(callcs, callcf) ���g�p���Ă��������B

%sample

%href
call
callcs
callcf

isModcmdId

#deffunc
#defcfunc
#modfunc
#modcfunc

%group
���[�U�g���֐�

;-----------------------------
%index
isModcmdId
ModcmdId ���ǂ���

%prm
(defid)
int defid : defidOf() �œ����l

%inst
�����̒l���AdefidOf �Ń��[�U��`���߁E�֐����瓾���l���ǂ�����Ԃ��܂��B

%sample
%href
call
defidOf

%group
���[�U�g���֐�

;-----------------------------
%index
labelOf
���[�U��`���߁E�֐��̃��x���𓾂�

%prm
(p1)
(some) p1 : ���[�U��`���߁E�֐�

%inst
p1 �ɂ́A���[�U��`���߁E�֐��A���x���AdefidOf()�̒l�A�̂����ꂩ���w�肵�A���ꂪ��`����Ă���ʒu�̃��x����Ԃ��܂��B

%sample
#include "call.as"

	method_replace "int"
	method_add     "int", "mes", labelOf(method_mes)
	
	// �T���v��
	n = 72
	n->"mes"
	stop
	
#deffunc method_mes var this
	mes this
	return
	
%href
call
defidOf

%group
���[�U�g���֐�

;-----------------------------
%index
byref
�Q�Ɠn��

%prm
(p1)
var p1 : �ϐ�

%inst
�ϐ����Q�Ɠn������L�[���[�h�ł��B
call �̈����̒��ł̂ݎg�p�ł��܂��B

�������Acall_dec �Ȃǂɂ��Q�Ɠn�����邱�Ƃ����܂��Ă���ꍇ�́Abyref ���g���Ă͂����܂���B

%sample
#include "call.as"

	// �T���v��
	a = 1
	
	call *LAssign, byref(b), byref(a)
	
	mes b	//=> 1
	stop
	
*LAssign
	refarg(0) = argv(1)
	return
	
%href
call

%group
���[�U�g���L�[���[�h

;-----------------------------
