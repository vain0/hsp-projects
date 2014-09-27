// call.hpi - import header

#ifndef        IG_IMPORT_HEADER_CALL_AS
#define global IG_IMPORT_HEADER_CALL_AS

#define HPI_CALL_VERSION 1.3	// last update: 

;#define IF_CALL_HPI_RELEASE

#ifndef STR_CALL_HPI_PATH
 #ifdef IF_CALL_HPI_RELEASE
  #define STR_CALL_HPI_PATH "call.hpi"
 #else
  #define STR_CALL_HPI_PATH "C:/Users/Owner/Source/Repos/call/Debug/call.hpi";"D:/Docs/prg/cpp/MakeHPI/call/Debug/call.hpi"
 #endif
#endif

//##############################################################################
//                �R�}���h��`
//##############################################################################
#define       HpiCmdlistBegin //
#define       HpiCmdlistEnd //
#define ctype HpiCmdlistSectionBegin(%1) //
#define       HpiCmdlistSectionEnd //
#define ctype HpiCmd___(%1, %2) #cmd %2@ %1
#define ctype HpiCmdS__(%1, %2) #cmd %2@ %1
#define ctype HpiCmd_F_(%1, %2) #cmd %2@ %1
#define ctype HpiCmdSF_(%1, %2) #cmd %2@ %1
#define ctype HpiCmd__V(%1, %2) #cmd %2@ %1
#define ctype HpiCmdS_V(%1, %2) #cmd %2@ %1
#define ctype HpiCmd_FV(%1, %2) #cmd %2@ %1
#define ctype HpiCmdSFV(%1, %2) #cmd %2@ %1

#regcmd "_hsp3typeinfo_call@4", STR_CALL_HPI_PATH, 1

#include "callcmd.cmdlist.txt"

// call core
/*
#cmd call              0x000	// ���x�����߁E�֐����Ăяo��
#cmd call_alias        0x001	// �ϐ��������̃G�C���A�X�ɂ���
#cmd call_aliasAll     0x002	// �V( �ꊇ )
#cmd call_retval       0x003	// ���x���֐��̖߂�l��ݒ�
#cmd call_dec          0x004	// ���x�����߁E�֐��̉������錾

#cmd call_arginfo      0x100	// ���������擾����( �ȉ��� ARGINFOID_* �Q�� )
#cmd call_argv         0x101	// �����̒l�Ǝ擾����
#cmd call_getlocal     0x102	// local �ϐ��̒l���擾����
#cmd call_result       0x103	// ���O�̃��x���֐��ŕԋp���ꂽ�l���擾����

#cmd call_thislb       0x200	// �Ăяo���ꂽ���x��

// call extra
#cmd functor           0x030	// functor �^�ϐ��̐錾�A�^�ϊ��A�^�^�C�v�l
#cmd functor_prminfo   0x130	// functor �̉��������

#cmd argbind           0x120	// ���������E�����K�p
#cmd unbind            0x121	// �������� (�푩���֐��̎擾)
#cmd call_funcexpr     0x12A	// ������̊֐�����

#cmd call_stream_begin 0x010	// �X�g���[���Ăяo��::����
#cmd call_stream_label 0x011	// �X�g���[���Ăяo��::�W�����v�惉�x���̐ݒ�
#cmd call_stream_add   0x012	// �X�g���[���Ăяo��::�����̒ǉ�
#cmd call_stream_end   0x013	// �X�g���[���Ăяo��::�Ăяo������
#cmd call_stream       0x013	// �V
#cmd stream_call_new   0x126	// �X�g���[���Ăяo���I�u�W�F�N�g�̐���
#cmd stream_call_add   0x014	// �X�g���[���Ăяo���I�u�W�F�N�g::�����ǉ�

#cmd co_begin          0x060	// (�\��)
#cmd co_end            0x061	// (�\��)
;#cmd co_yield         0x062	// ���f
#cmd co_yield_impl     0x063	// 
;#cmd co_exit          0x064	// �I��
#cmd co_create         0x140	// �V���� coroutine �𐶐�����

// method jack
#cmd method_replace    0x020	// ���\�b�h�Ăяo���֐��𗩒D����
#cmd method_add        0x021	// ���\�b�h�ǉ�
#cmd method_cloneThis  0x022	// this �ϐ����N���[��

// modcls jack
#cmd modcls_init       0x050	// modcls �@�\�̏�����
#cmd modcls_term       0x051	// modcls �@�\�̏I������
#cmd modcls_register_  0x052	// ���Z�֐��̓o�^
#cmd modcls_newmod     0x053	// newmod
#cmd modcls_delmod     0x054	// delmod
#cmd modcls_nullmod    0x054	// nullmod
#cmd modcls_dupmod     0x055	// dupmod (�����֐�)
#cmd modcls_identity   0x150	// �N���X����
#cmd modcls_name       0x151	// �N���X��
#cmd modinst_cls       0x15A	// �N���X����
#cmd modinst_clsname   0x15B	// �N���X��
#cmd modinst_identify  0x15C	// �Q�Ɠ��ꐫ��r
#cmd modcls_thismod    0x250	// thismod (�E�Ӓl�p)

#cmd call_byref        0x210	// (kw-prefix) �ϐ��̎Q�Ɠn���𖾎�����
;#cmd call_bythismod    0x211	// (kw-prefix) �V modvar �����Ɩ�������
#cmd call_bydef        0x212	// (extra-arg) �ȗ������ł���Ɩ�������
#cmd call_nobind       0x213	// (extra-arg) �������Ȃ����Ƃ𖾎����� (for argbind)
#cmd call_prmof        0x214	// (extra-val) �󂯎�鉼�����𖾎����� (for funcexpr)
#cmd call_valof        0x215	// (extra-val) �����ł������l���Q�Ƃ��� (for funcexpr)
#cmd call_nocall       0x216	// (extra-idx) functor �ŁA�Y�����������Ăяo�������Ȃ����Ƃ�����
#cmd call_byflex       0x217	// (extra-arg) �ϒ������ւ̘A���𖾎�����

#cmd call_test         0x0FF	// �e�X�g

// utility for call
#cmd axcmdOf           0x110	// �R�}���h�𐔒l������
#cmd labelOf           0x111	// ���[�U��`���߁E�֐����烉�x���𓾂�

// extra commands
#cmd callcmd           0x0FF	// �R�}���h�Ăяo��

//*/


//##########################################################
//    �}�N��
//##########################################################
#define global __call_empty__// empty

// �L�[���[�h
#define global byref     call_byref_     ||	// �Q�Ɠn������ (����)
#define global bythismod call_bythismod_ ||	// thismod �n�� (����)
/*
#define global arginfo   call_arginfo
#define global thislb    call_thislb
#define global bydef     call_bydef			// �ȗ�����     (����)
#define global nobind    call_nobind		// �s��������   (����)
#define global nocall    call_nocall		// �Ăяo���Ȃ� (�t���O)
//*/

#define global argcount arginfo(-1)		// �������̐�
#define global argc argcount
//#define global argv argVal

#define global call_return(%1) call_setResult_@ (%1) : return

// �����_��
#define global __p0 ( call_prmof_@(0) )
#define global __p1 ( call_prmof_@(1) )
#define global __p2 ( call_prmof_@(2) )
#define global __p3 ( call_prmof_@(3) )
#define global __p4 ( call_prmof_@(4) )
#define global __p5 ( call_prmof_@(5) )
#define global __p6 ( call_prmof_@(6) )
#define global __p7 ( call_prmof_@(7) )

#define global __v0 ( lambdaValue_@(0) )
#define global __v1 ( lambdaValue_@(1) )
#define global __v2 ( lambdaValue_@(2) )
#define global __v3 ( lambdaValue_@(3) )
#define global __v4 ( lambdaValue_@(4) )
#define global __v5 ( lambdaValue_@(5) )
#define global __v6 ( lambdaValue_@(6) )
#define global __v7 ( lambdaValue_@(7) )

#define global functor_id axcmdOf( _functor_id@__callmod )	// �P���ʑ�; ���Œ�`���Ă���

// �R�}���h
#define global ctype callcs(%1) callcmd(%1) : call_byref@	// call_byref �̓_�~�[(�Ȃ�ł���������1�K�v)
#define global ctype callcf(%1, %2 = __call_empty__) callcmd(%1, call_byref@ %2)	// �V

#define global insub %tinsub *%i : if(0) : %o :

// �R���[�`��
#define global coYield(%1) \
	coYield_@ (%1), co_next_label@__callmod :\
	newlab co_next_label@__callmod, 1 :\
	return :

#define global coExit return

//##############################################################################
//                �萔���`
//##############################################################################
#define global functor_vtname "functor_k"
#enum global FuncType_None = 0
#enum global FuncType_Label
#enum global FuncType_AxCmd
#enum global FuncType_Ex
#enum global FuncType_MAX

// arginfo dataID
#enum global ARGINFOID_FLAG = 0	// vartype
#enum global ARGINFOID_MODE		// �ϐ����[�h( 0 = ��������, 1 = �ʏ�, 2 = �N���[�� )
#enum global ARGINFOID_LEN1		// �ꎟ���ڗv�f��
#enum global ARGINFOID_LEN2		// �񎟌��ڗv�f��
#enum global ARGINFOID_LEN3		// �O�����ڗv�f��
#enum global ARGINFOID_LEN4		// �l�����ڗv�f��
#enum global ARGINFOID_SIZE		// �S�̂̃o�C�g��
#enum global ARGINFOID_PTR		// ���̂ւ̃|�C���^
#enum global ARGINFOID_BYREF	// �Q�Ɠn����
#enum global ARGINFOID_MAX

// �������^�C�v
#define global PrmType_None    0
#define global PrmType_Var     (-2)	// �ϐ��Q�Ƃ̗v��
#define global PrmType_Array   (-3)	// �z��Q�Ƃ̗v��
#define global PrmType_Modvar  (-4)	// modvar ����
#define global PrmType_Any     (-5)	// �C�ӂ̈���
#define global PrmType_Capture (-6)
#define global PrmType_Local   (-7)	// ���[�J���ϐ� ( �������s�v )
#define global PrmType_Flex    (-1)	// �ϒ������̋���

#define global PrmType_Label  1	// �^�^�C�v�l
#define global PrmType_Str    2
#define global PrmType_Double 3
#define global PrmType_Int    4
#define global PrmType_Struct 5
#define global PrmType_Functor (functor)

// �}�W�b�N�R�[�h
#const global MagicCode_AxCmd     0x20000000
;#const global MagicCode_ModcmdId (0x000C0000 | MagicCode_AxCmd)

;#define global ctype isModcmdId(%1) ( ((%1) & 0xFFFF0000) == MagicCode_ModcmdId )

//##############################################################################
//                ���W���[��
//##############################################################################
#module __callmod

dim co_next_label@__callmod

// ������
;#deffunc local _init
;	return

//------------------------------------------------	
// �����ւ̎Q��
// 
// @ �E�Ӓl�Ƃ��Ďg�p�ł��Ȃ��B
//   ���Ȃ킿�A�K��������̍��ӂɂ��邱�ƁB
//------------------------------------------------
#define global ctype refarg(%1=0) refarg_var@__callmod(refarg_core(%1))
#defcfunc refarg_core int iArg
	call_alias refarg_var, iArg
	return 0
	
/*
//------------------------------------------------	
// ���\�b�h�Ăяo�����ϐ��ւ̎Q��
// 
// @ �E�Ӓl�Ƃ��Ďg�p�ł��Ȃ��B
//------------------------------------------------	
//#define global thisref thisref_var@__callmod(thisref_core())
#defcfunc thisref_core
	method_clonethis thisref_var
	return 0
	
//------------------------------------------------
// ���\�b�h�Ăяo�����ϐ��̒l
// 
// @ ���Ӓl�ł͂Ȃ��B
//------------------------------------------------
#define global getthis getthis_core()
#defcfunc getthis_core
	method_clonethis thisref_var
	return           thisref_var
	
//*/

#global
;_init@__callmod

#module

#deffunc _functor_id@__callmod var x
	call_return x

#global

// ����݊��p

#define global funcexpr lambda
#define global argv argVal
#define global call_alias argClone
#define global call_aliasAll argPeekAll
#define global call_setprm(%1, %2) \
dupptr %1, \
	arginfo(ARGINFOID_PTR,  (%2) + 1), \
	arginfo(ARGINFOID_SIZE, (%2) + 1), \
	arginfo(ARGINFOID_FLAG, (%2) + 1)  :
#define global defidOf !!"replace 'defidOf' to 'axcmdOf'"!!

// �������^�C�v
#define global PRM_TYPE_NONE    PrmType_None
#define global PRM_TYPE_FLEX    PrmType_Flex
#define global PRM_TYPE_VAR     PrmType_Var
#define global PRM_TYPE_ARRAY   PrmType_Array
#define global PRM_TYPE_MODVAR  PrmType_Modvar
#define global PRM_TYPE_ANY     PrmType_Any
#define global PRM_TYPE_LOCAL   PrmType_Local

#define global PRM_TYPE_LABEL  PrmType_Label
#define global PRM_TYPE_STR    PrmType_Str
#define global PRM_TYPE_DOUBLE PrmType_Double
#define global PRM_TYPE_INT    PrmType_Int
#define global PRM_TYPE_STRUCT PrmType_Struct

	// label �^�̔�r���Z���`
	call_defineLabelComparison

#endif
