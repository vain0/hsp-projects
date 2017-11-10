// call - for sample header

// �T���v���̂��߂̃w�b�_

#ifndef        IG_CALL_FOR_SAMPLE_AS
#define global IG_CALL_FOR_SAMPLE_AS

#include "call.as"
#include "call_modcls.as"

// �}�N��
#ifndef __userdef__
	#define global do_not if ( 0 )
	#define global assert_sentinel logmes "assert sentinel " + __HERE__ : assert : end
	
	// �f�o�b�O�p
	#ifdef  _DEBUG
	 #define global DbgBox(%1) dialog (%1), 2, ("DbgBox Line\t= " + __LINE__ + "\nFILE\t = " + __FILE__) : if ( stat == 7 ) { dialog "��~���܂���" : assert 0 }
	 #define global ctype dbgstr(%1) ({"%1 = "} + (%1))
	 #define global ctype dbgpair(%1,%2) ({"(%1,%2) = ("} + (%1) + ", " + (%2) + ")")
	 #define global ctype dbghex(%1) strf({"%1 = 0x%%08X"}, (%1))
	 #define global ctype dbgchar(%1) strf({"%1 = '%%c'"}, (%1))
	 #define global ctype dbgcode(%1 = _empty, %2 = _empty) (%1)
	#else
	 #define global DbgBox(%1) :
	 #define global ctype dbgstr(%1) ""
	 #define global ctype dbgpair(%1,%2) ""
	 #define global ctype dbghex(%1) ""
	 #define global ctype dbgchar(%1) ""
	 #define global ctype dbgcode(%1 = _empty, %2 = _empty) (%2)
	#endif
	
	#define global __HERE__ (__FILE__ + " (#" + __LINE__ + ")")
	#define global true    1	// ��0
	#define global false   0	//   0
#endif

// �T���v���N���X
// �l value �����Bname, bDup �͕�����₷�����邽�߁B
#module Test value,  name, bDup

#modinit int _value, str _name, int _bDup
	bDup = _bDup
	name = _name
	if ( _name == "" ) { name = "instance" }
	test_set thismod, _value
	
	mes "new >> " + name + ": " + value + " $" + bDup
	return
	
#modterm
	mes "del << " +  name + ": " + value + " $" + bDup
	wait 60
	return
	
#modfunc test_set int x
	value = x
	return
	
#modcfunc test_get
	return value
	
#modcfunc test_getName
	return name
	
// �����֐�
// @ �ϐ� x �� thismod �̕����ɂ���B
// @ �܂�A�����l������ ( == �����藧�� ) �悤�ȃC���X�^���X��V���ɍ��΂悢�B
#modfunc test_dup_fact var x
	newmod x, Test@, value, name + "'", true
	return
	
// ���Z�֐�
// @ thismod ���A����Ɠ��͕ϐ������Z���ē�����l�ɂ���B
// @ �u+=�v�Ȃǂ̂Ƃ��ɁA�Ή�����֐����Ă΂��B
// @ �u+�v�Ȃǂ̕�������łȂ��񍀉��Z���s���ɂ́A�����֐�����`����Ă���K�v������B
// @ (�ua + b�v�́ua2 = dupmod(a) : a2 += b : return a2�v�Ƃ��ď��������B)
#modfunc test_add var x
	mes strf("add: %d(%s) + %d(%s)", value, name, test_get(x), test_getName(x))
	value += test_get(x)
	return
	
#modfunc test_mul var x
	mes strf("mul: %d(%s) * %d(%s)", value, name, test_get(x), test_getName(x))
	value *= test_get(x)
	return
	
#modfunc test_pow var x
	mes strf("pow: %d(%s) ^ %d(%s)", value, name, test_get(x), test_getName(x))
	value = int( powf( value, test_get(x) ) )
	return
	
// ��r�֐�
// thismod �� x �̑召�𒲂ׂāA�Ή����鐮���l(int)��ԋp����B
// 0. thismod == x �� 0
// 1. thismod <  x �� ��
// 2. thismod >  x �� ��
// opId �́A���ۂɔ�r�Ɏg���鉉�Z�q�� opId �BopId_Lt(<) �ȂǁB
// ��΂� x �� nullmod �łȂ��B
#modcfunc test_cmp var x, int opId
	mes strf("cmp: %d(%s) <> %d(%s)", value, name, test_get(x), test_getName(x))
	return value - test_get(x)
	
// �^�ϊ��֐�
#modcfunc test_toInt int flag
	return int(value)
	
#modcfunc test_toStr int flag
	return str(value)
	
#modcfunc test_toDouble int flag
	return double(value)
	
// ���\�b�h���U�֐�
// thismod->method a, b, c, ... �Ƃ������\�b�h�Ăяo���̍ۂɌĂ΂��B
// @ �^����ꂽ������ method �ɑΉ�����֐��q��ԋp����B
// @ �� ����������A���̃��\�b�h�Ɉ��� thismod, a, b, c, ... ���^�����ČĂяo�����B
// @ �����Ȓl��Ԃ����ꍇ�́A���̕�����ɑΉ����郁�\�b�h���Ȃ������Ƃ������Ƃɂ���B
#modfunc test_method str method
	switch ( method )
		case "print": return axcmdOf( test_method_print )
		case "times": call_return *test_method_times
	swend
	return 0
	
// ���\�b�h���s�֐�
// @ #modfunc �łȂ���΂����Ȃ��B
// @ ���x�����g���ɂ́A�������� PRM_TYPE_MODVAR �Ő錾���Ȃ���΂����Ȃ��B
#modfunc test_method_print
	mes name + " = " + value
	return
	
#modfunc test_method_times__ int n, var proc
*test_method_times
	assert( vartype(proc) == functor || vartype(proc) == vartype("label") || vartype(proc) == vartype("int") )
	repeat n
		call proc
	loop
	return
	
// �o�^
#deffunc test_init
	modcls_register Test, OpId_Add, test_add		// +
	modcls_register Test, OpId_Mul, test_mul		// *
	modcls_register Test, OpId_Xor, test_pow		// ^
	
	modcls_register Test, OpId_Dup, test_dup_fact	// �����֐�
	modcls_register Test, OpId_Cmp, test_cmp		// ��r�֐�
	
	modcls_register Test, OpId_ToStr,    test_toStr		// str()
	modcls_register Test, OpId_ToDouble, test_toDouble	// double()
	modcls_register Test, OpId_ToInt,    test_toInt		// int()
	
	modcls_register Test, OpId_Method, test_method	// ���\�b�h���U�֐�
	
	// ���̑��̐錾
	call_dec *test_method_times, PRM_TYPE_MODVAR, "int", "any"		// cf. ex10, ex11
	return
	
#global
	test_init
	
#endif
