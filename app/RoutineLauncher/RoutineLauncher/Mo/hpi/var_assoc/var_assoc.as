// var_assoc - public header

#ifndef IG_ASSOC_HPI_AS
#define IG_ASSOC_HPI_AS

#define HPI_ASSOC_VERSION 1.01	// 2011 12/25 (Sun)

#define IF_ASSOC_HPI_RELEASE

#ifdef IF_ASSOC_HPI_RELEASE
 #define STR_ASSOC_HPI_PATH "var_assoc.hpi"
#else
 #define STR_ASSOC_HPI_PATH "H:/Docs/prg/cpp/MakeHPI/var_assoc/Debug/var_assoc.hpi"
#endif

#regcmd "_hpi_assoc@4", STR_ASSOC_HPI_PATH, 1
#cmd assoc            0x000		// assoc�^�ϐ����쐬 : assoc�^�̌^�^�C�v�l
#cmd AssocDelete      0x001		// �j��
#cmd AssocClear       0x002		// ���� (AllRemove)
#cmd AssocChain       0x003		// �A��
#cmd AssocCopy        0x004		// ����
#cmd AssocDup         0x004		// �V (��Ɋ֐��`��(����)�ŗp����)

#cmd AssocImport      0x010		// �O���ϐ��̃C���|�[�g
#cmd AssocInsert      0x011		// �L�[��}������
#cmd AssocRemove      0x012		// �L�[����������

#cmd AssocDim         0x020		// �����ϐ���z��ɂ���
#cmd AssocClone       0x021		// �����ϐ��ɃN���[������

#cmd AssocInfo        0x100		// �����ϐ��̏����擾����
#cmd AssocSize        0x101		// �v�f��
#cmd AssocExists      0x102		// ����
#cmd AssocForeachNext 0x103		// foreach: �X�V

#cmd AssocNull        0x200		// null �I�u�W�F�N�g

//######## �u���}�N�� ######################################
#define global AssocInit(%1, %2 = "", %3 = 4) AssocDim %1(%2), %3
#define global AssocNewCom(%1, %2, %3 = 0, %4 = 0) newcom _temp_com@assoc_mod, %2, %3, %4 : %1 = _temp_com@assoc_mod
#define global AssocDelCom(%1) delcom AssocRef(%1)

#define global ctype AssocVarType(%1) AssocInfo(%1, VARINFO_FLAG)
#define global ctype AssocVarMode(%1) AssocInfo(%1, VARINFO_MODE)
#define global ctype AssocLen(%1,%2=0)AssocInfo(%1, VARINFO_LEN, %2)
;#define global ctype AssocSize(%1)    AssocInfo(%1, VARINFO_SIZE)		// AssocSize (�v�f��) �ƏՓ�
#define global ctype AssocPtr(%1)     AssocInfo(%1, VARINFO_PT)

#define global AssocForeach(%1, %2 = key_) %tAssocForeach repeat : if ( AssocForeachNext(%1, %2, cnt) ) {
#define global AssocForeachEnd %tAssocForeach } else { break } loop

//######## �萔�E�}�N�� ####################################
// �萔
#ifndef VARINFO
#define VARINFO
 #enum global VARINFO_NONE = 0
 #enum global VARINFO_FLAG = VARINFO_NONE
 #enum global VARINFO_MODE
 #enum global VARINFO_LEN
 #enum global VARINFO_SIZE
 #enum global VARINFO_PT
 #enum global VARINFO_MASTER
 #enum global VARINFO_MAX
#endif

//######## ���W���[�� ######################################
//*
#module assoc_mod

// @static
	dim ref_v@assoc_mod
	dim ref_assoc@assoc_mod
	
//------------------------------------------------
// assoc �Q�� : assoc �v�f��ϐ��Ƃ��ĎQ�Ƃ��郉�b�p
// 
// @ �������݁E�Q�Ɠn����p
// @ �ǂݎ��֎~
//------------------------------------------------
#define global ctype AssocRef(%1) ref_v@assoc_mod(AssocRef_core@assoc_mod(%1))
#defcfunc AssocRef_core@assoc_mod array self
	AssocClone ref_v, self()
	return 0
	
//------------------------------------------------
// assoc �^�̊֐��p�̃��b�p
// 
// @ �g�ݍ��݌^�� assoc �^�̂ݕԋp�ł���B
// @cf: ex05_func_of_assoc
//------------------------------------------------
#define global AssocExpr ref_assoc@assoc_mod
#defcfunc AssocResult var self
	if ( vartype(p1) != assoc ) { return }
	ref_assoc = self		// ����� AssocExpr �ŎQ�Ƃ����
	return 0				// ref_assoc �̓Y���ƂȂ�
	
#global
;	dimtype ref_assoc@assoc_mod, assoc
//*/

#endif