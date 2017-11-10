// call.hpi - extra header (for modcls)

#ifndef        IG_CALL_HPI_MODCLS_AS
#define global IG_CALL_HPI_MODCLS_AS

#include "call.as"

// ���W���[���ϐ��@�\�̃��b�v
#undef newmod
#undef delmod
#define global newmod  modcls_newmod
#define global delmod  modcls_delmod
#define global nullmod modcls_nullmod
#define global dupmod  modcls_dupmod

#module
#deffunc ModCls_Term_Caller onexit
	modcls_term			// �������
	return
	
// �����֐� (���Ӓl�Ƃ��ĎQ�Ƃł���)
#define global dupmod_of(%1) dupped@__callmod( dupmod_of_impl(%1, dupped@__callmod) )
#defcfunc dupmod_of_impl var self, var it
	dupmod self, it
	return 0
#global
dimtype dupped@__callmod, 5

#define global modnew newmod-		// modnew Modcls(...)
#define global modcls_register(%1, %2, %3) modcls_register_ %1, %2, axcmdOf(%3)
#define global ctype isNullmod(%1) modinst_identify( %1, nullmod )

#define global modcls_bottom modinst_cls(nullmod)

// �萔
#define global OpFlag_Calc 0x0000	// (�����p)
#define global OpFlag_Cnv  0x0100
#define global OpFlag_Sp   0x0200

#define global OpId_Add  (OpFlag_Calc |  0)	// �Z�p���Z�q
#define global OpId_Sub  (OpFlag_Calc |  1)
#define global OpId_Mul  (OpFlag_Calc |  2)
#define global OpId_Div  (OpFlag_Calc |  3)
#define global OpId_Mod  (OpFlag_Calc |  4)
#define global OpId_And  (OpFlag_Calc |  5)	// �r�b�g���Z�q or �_�����Z�q
#define global OpId_Or   (OpFlag_Calc |  6)
#define global OpId_Xor  (OpFlag_Calc |  7)

#define global OpId_Eq   (OpFlag_Calc |  8)	// ��r���Z�q
#define global OpId_Ne   (OpFlag_Calc |  9)
#define global OpId_Gt   (OpFlag_Calc | 10)
#define global OpId_Lt   (OpFlag_Calc | 11)
#define global OpId_GtEq (OpFlag_Calc | 12)
#define global OpId_LtEq (OpFlag_Calc | 13)

#define global OpId_Rr   (OpFlag_Calc | 14)	// �V�t�g���Z�q
#define global OpId_Lr   (OpFlag_Calc | 15)

#define global OpId_ToLabel  (OpFlag_Cnv | 1)	// �^�ϊ��֐�
#define global OpId_ToStr    (OpFlag_Cnv | 2)
#define global OpId_ToDouble (OpFlag_Cnv | 3)
#define global OpId_ToInt    (OpFlag_Cnv | 4)
;#define global OpId_ToStruct (OpFlag_Cnv | 5)	// ����

#define global OpId_Dup    (OpFlag_Sp | 0)	// ����
#define global OpId_Cmp    (OpFlag_Sp | 1)	// ��r���
#define global Opid_Method (OpFlag_Sp | 2)	// ���\�b�h

	modcls_init

#endif
