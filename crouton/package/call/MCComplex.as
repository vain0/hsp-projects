// ���f���N���X

#ifndef IG_MODULECLASS_COMPLEX_AS
#define IG_MODULECLASS_COMPLEX_AS

#include "call_modcls.as"

#module MCComplex mSize, mArg

#define VAR_TEMP _stt_temp@MCComplex

#const  M_PI2 (M_PI * 2)
#define ctype RegularizeArg(%1) (((%1) \ M_PI2 + M_PI2) \ M_PI2)

//##########################################################
//                �\�z�E���
//##########################################################
//------------------------------------------------
// �\�z
// 
// @ �����l (0.0, 0.0)
//------------------------------------------------
#deffunc complex_New array self
	newmod self, MCComplex@, 0, 0
	return
	
#modinit double size, double arg
	complex_SetArg  thismod, arg
	complex_SetSize thismod, size
	return
	
#deffunc complex_NewPoint array self, double size, double arg
	newmod self, MCComplex@, size, arg
	return
	
// ��������
#deffunc complex_NewReal array self, double size
	complex_NewPoint self, size, 0.0
	return
	
// �P�ʉ~��
#deffunc complex_NewUnit array self, double arg
	complex_NewPoint self, 1, arg
	return
	
//------------------------------------------------
// �j��
//------------------------------------------------
#deffunc complex_Delete var self
	delmod self
	return
	
//##########################################################
//                ����
//##########################################################

//##########################################################
//                �擾
//##########################################################

//------------------------------------------------
// �����o�̒l�̎擾
//------------------------------------------------
// �Ɍ`��
#modcfunc complex_size
	return mSize
	
#modcfunc complex_arg
	return mArg
	
#modfunc complex_GetPolar var _size, var _arg
	_size = mSize
	_arg  = mArg
	return
	
// �������W
#modcfunc complex_re
	return cos(mArg) * mSize
	
#modcfunc complex_im  local tmp
	return sin(mArg) * mSize
	
#modfunc complex_GetRect var re, var im,  local size, local arg
	re = complex_re(thismod)
	im = complex_im(thismod)
	return
	
//------------------------------------------------
// �����o�ւ̑��
//------------------------------------------------
#modfunc complex_SetSize  double size_,  local size, local vt
	
	if ( size_ == 0 ) {
		complex_Clear thismod
		return
		
	} elsif ( size_ < 0 ) {
		size = -size_			// ��
		complex_Minus thismod	// ����������
		
	} else {
		size = size_
	}
	
	mSize = size
	return
	
#modfunc complex_SetArg double arg
	mArg = RegularizeArg(arg)
	return
	
#modfunc complex_SetRe double re
	complex_SetRect thismod, re, complex_im(thismod)
	return
	
#modfunc complex_SetIm double im
	complex_SetRect thismod, complex_re(thismod), im
	return
	
#modfunc complex_SetPolar double size, double arg
	if ( size == 0 ) {
		complex_Clear thismod
	} else {
		complex_SetSize thismod, size
		complex_SetArg  thismod, arg
	}
	return
	
#modfunc complex_SetRect double re, double im
	complex_SetPolar thismod, sqrt( re * re + im * im ), argof( re, im )
	return
	
//------------------------------------------------
// �Ίp
//
// @ ���_����_ (x, y) �Ɉ������L�������̕Ίp
// @	������ (x, y) = (0, 0) �̂Ƃ� 0.0
// @result: double [rad], �l�� [0, 2��)
//------------------------------------------------
#defcfunc argof@MCComplex double x, double y
	switch ( sgn(x) )		// x �̕����ŕ���
		case  0:
			switch ( sgn(y) )	// y �̕����ŕ���
				case 0:  return 0.0				// �E: 0
				case  1: return M_PI / 2		// ��: (1/2)��
				case -1: return M_PI * 1.5		// ��: (3/2)��
			swend
		case  1: return atan( y, x )
		case -1: return atan( y, -x ) + M_PI
	swend
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#modcfunc complex_IsRe
	return ( mArg \ M_PI == 0 )
	
#modcfunc complex_IsIm
	return ( mArg \ M_PI != 0 )
	
//------------------------------------------------
// �^�ϊ�
//------------------------------------------------
#modcfunc complex_ToDouble
	if ( complex_IsRe(thismod) ) {
		return complex_re(thismod)
	} else {
		mSize(1) = ""	// �^�s��v�G���[���o������
	}
	
#modcfunc complex_ToInt
	return int( complex_ToDouble(thismod) )
	
//##########################################################
//                ���Z
//##########################################################
//------------------------------------------------
// ������
//------------------------------------------------
#modfunc complex_Minus
	mArg = RegularizeArg( mArg + M_PI )
	return
	
//------------------------------------------------
// ������
// 
// @ //z = (r�Ee^(i��))^(1/2) = (��r)�Ee^(i(��/2))
//------------------------------------------------
#modfunc complex_Sqrt
	mSize = sqrt(mSize)		// �^�� int -> double �ɂȂ�\�������邽�߃N���[�����Ȃ�
	mArg /= 2				// mArg/2 �� [0, 2��) ��� RegularizeArg �s�v
	return
	
//------------------------------------------------
// �t��(^-1)
// 
// @ /z = (r�Ee^(i��))^(-1) = (r^-1)�Ee^(i(-��))
//------------------------------------------------
#modfunc complex_Inv
	complex_SetSize   thismod, 1.0 / mSize
	complex_Conjugate thismod
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#modfunc complex_Conjugate
	mArg = RegularizeArg( -mArg )
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#modfunc complex_Add var rhs,  local lhsPair, local rhsPair
	ddim lhsPair, 2
	ddim rhsPair, 2
	complex_GetRect thismod, lhsPair(0), lhsPair(1)
	complex_GetRect rhs,     rhsPair(0), rhsPair(1)
	complex_SetRect thismod, lhsPair(0) + rhsPair(0), lhsPair(1) + rhsPair(1)
	return
	
#modfunc complex_Sub var rhs,  local lhsPair, local rhsPair
	ddim lhsPair, 2
	ddim rhsPair, 2
	complex_GetRect thismod, lhsPair(0), lhsPair(1)
	complex_GetRect rhs,     rhsPair(0), rhsPair(1)
	complex_SetRect thismod, lhsPair(0) - rhsPair(0), lhsPair(1) - rhsPair(1)
	return
	
//------------------------------------------------
// �揜
//------------------------------------------------
#modfunc complex_MulWithReal double r		// �����{
	mSize = r * mSize
	return
	
#modfunc complex_Mul var rhs
	mSize = double( mSize ) * complex_size(rhs)
	mArg  = RegularizeArg( mArg + complex_arg(rhs) )
	return
	
#modfunc complex_Div var rhs
	mSize = double( mSize ) / complex_size(rhs)
	mArg = RegularizeArg( mArg - complex_arg(rhs) )
	return
	
//------------------------------------------------
// �p
//------------------------------------------------
#modfunc complex_Pow var rhs,  local r, local t, local a, local b
	complex_GetPolar thismod, r, t
	complex_GetRect  rhs,     a, b
	
	complex_PowImpl thismod, r, t, a, b
	return
	
#modfunc complex_PowWithReal double x,  local r, local t
	complex_GetPolar thismod, r, t
	complex_PowImpl  thismod, r, t, x, 0	// ������
	return
	
#modfunc complex_PowImpl double r, double t, double a, double b
	if ( r == 0 ) {
		if ( a == 0 && b == 0 ) {
			complex_SetPolar thismod, 1, 0
		} else {
			complex_Clear thismod
		}
	} else {
		complex_SetPolar thismod, ( powf(r, a) / expf(b * t) ), ( b * logf(r) + a * t )
	}
	return
	
#modfunc complex_Exp  local a, local b
	complex_GetRect  thismod, a, b
	complex_SetPolar thismod, expf(a), b	// e^(a + i b) = (e^a) * e^(i b)
	return
	
//------------------------------------------------
// �p��
// 
// @ [lhs]��rhs = rhs^(/lhs) �Ƃ������Ƃɂ���B
//------------------------------------------------
#modfunc complex_Root int rhs,  local r, local t, local a, local b, local s
	complex_GetPolar thismod, r, t
	complex_GetRect  rhs,  a, b
	
	// (a + ib) �̋t�����Ƃ�
	s = (a * a + b * b)
	complex_PowImpl thismod, r, t, a / s, -b / s
	return
	
#modfunc complex_RootWithReal double x
	complex_PowWithReal thismod, 1.0 / x
	return
	
//------------------------------------------------
// �ΐ�
//------------------------------------------------
#modcfunc complex_Log var base
	complex_SetRect thismod, logf(mSize - base), mArg / logf(base)
	return
	
#modcfunc complex_Ln double base
	complex_SetRect thismod, logf(mSize), mArg
	return
	
#modcfunc complex_LogWithReal double base
	complex_SetRect thismod, logf(mSize - base), mArg / logf(base)
	return
	
//------------------------------------------------
// �O�p�֐�
// 
// @ tan x = (sin x) / (cos x)
//------------------------------------------------
#modfunc complex_Sin  local x, local y
	complex_GetRect thismod, x, y
	complex_SetRect thismod, sin(x) * cosh(y), cos(x) * sinh(y)
	return
	
#modfunc complex_Cos  local x, local y
	complex_GetRect thismod, x, y
	complex_SetRect thismod, cos(x) * cosh(y), - sin(x) * sinh(y)
	return
	
#modfunc complex_Tan  local x
	dupmod      thismod, x
	complex_Cos x
	complex_Sin thismod
	complex_Div thismod, x
	return
	
#defcfunc sinh@MCComplex double x
	return ( expf(x) - expf(-x) ) / 2
	
#defcfunc cosh@MCComplex double x
	return ( expf(x) + expf(-x) ) / 2
	
//------------------------------------------------
// ��r
// 
// @ �e�L�g�[�ɒ�߂�
// @result: ��r�l
//------------------------------------------------
#modcfunc complex_Cmp var rhs, int opId
	return sgn(mSize - complex_size(rhs)) * 2 + sgn(mArg - complex_arg(rhs))
	
#defcfunc sgn@MCComplex double x
	return (x > 0) - (x < 0)
	
//##########################################################
//                �R���e�i
//##########################################################
//------------------------------------------------
// ������
//------------------------------------------------
#modfunc complex_Clear
	mSize = 0
	mArg  = 0.0
	return
	
//------------------------------------------------
// ���� Factory
//------------------------------------------------
#modfunc complex_DupFact var obj
	complex_New      obj
	complex_SetPolar obj, mSize, mArg
	return
	
//------------------------------------------------
// �o�^
//------------------------------------------------
#deffunc complex_Register
	modcls_register MCComplex, OpId_Add, complex_Add
	modcls_register MCComplex, OpId_Sub, complex_Sub
	modcls_register MCComplex, OpId_Mul, complex_Mul
	modcls_register MCComplex, OpId_Div, complex_Div
;	modcls_register MCComplex, OpId_Mod, complex_Mod
	
	modcls_register MCComplex, OpId_Dup, complex_DupFact
	modcls_register MCComplex, OpId_Cmp, complex_Cmp
	
	modcls_register MCComplex, OpId_ToInt,    complex_ToInt
	modcls_register MCComplex, OpId_ToDouble, complex_ToDouble
	
	// �萔
	complex_NewUnit complex_i@, M_PI / 2		// �����P��
	complex_j@ = dupmod_of(complex_i@)
	
	return
	
#global

	complex_Register
	
#if 1

	i = complex_i
	
	// �v�Z
	mes int(i * i)	//=> -1 (i^2)
	
	stop

#endif

#endif

