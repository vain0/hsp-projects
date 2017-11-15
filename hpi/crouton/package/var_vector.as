// var_vector - public header

#ifndef        IG_VAR_VECTOR_HPI_AS
#define global IG_VAR_VECTOR_HPI_AS

#define HPI_VAR_VECTOR_VERSION 1.0		// last update: 2011 07/28 (Thu)

;#define IF_VAR_VECTOR_HPI_RELEASE

#ifndef STR_VAR_VECTOR_HPI_PATH
 #ifdef IF_VAR_VECTOR_HPI_RELEASE
  #define STR_VAR_VECTOR_HPI_PATH "var_vector.hpi"
 #else
  #define STR_VAR_VECTOR_HPI_PATH "C:/Users/Owner/Source/Repos/var_vector/Debug/var_vector.hpi"
 #endif
#endif

#regcmd "_hpi_vector@4", STR_VAR_VECTOR_HPI_PATH, 1
#cmd vector            0x000		// vector�^�ϐ����쐬; vector���e����; vector�^�̌^�^�C�v�l
#cmd VectorClear       0x001		// �j�� (v = vector() �Ɠ���)
#cmd VectorChain       0x002		// �A�� (v += VectorDup(src, range) �Ɠ���)
#cmd VectorCopy        0x003		// ���� (v = VectorDup(src, range) �Ɠ���)
#cmd VectorDup         0x003		// ����

#cmd VectorDim         0x010		// vector�^�̓����ϐ���z��ɂ���
#cmd VectorClone       0x011		// vector�^�̓����ϐ��̃N���[�������

#cmd VectorInsert      0x020		// �v�f�ǉ�
#cmd VectorInsertOne   0x021		// 
#cmd VectorPushFront   0x022		// 
#cmd VectorPushBack    0x023		// 
#cmd VectorRemove      0x024		// �v�f����
#cmd VectorRemoveOne   0x025		// 
#cmd VectorPopFront    0x026		// 
#cmd VectorPopBack     0x027		// 
#cmd VectorReplace     0x028		// �v�f�u��

#cmd VectorSwap        0x030		// ����
#cmd VectorRotate      0x031		// ����
#cmd VectorReverse     0x032		// ���]
#cmd VectorRelocate    0x033		// �ړ�

#cmd VectorInfo        0x100		// �����ϐ��̏����擾����
#cmd VectorSize        0x101		// �v�f��
#cmd VectorSlice       0x102		// �X���C�X
#cmd VectorSliceOut    0x103		// �X���C�X�r��
#cmd VectorResult      0x104		// vector �ԋp�֐�
#cmd VectorExpr        0x105		// vector ��
#cmd VectorJoin        0x106		// �����񌋍�
#cmd VectorAt          0x107		// �Y�����Z

;#cmd VectorNull        0x200		// null �I�u�W�F�N�g

// �u���}�N��

;#define global VectorInit(%1, %2 = "", %3 = 4) VectorDim %1(%2), %3

#define global VectorReturn(%1) return VectorResult(%1)
#define global VectorForeach(%1) %tVectorForeach repeat VectorSize(%1)
#define global VectorForeachEnd  %tVectorForeach loop

;#define global VectorPush    VectorPushBack
;#define global VectorPop     VectorPopBack
#define global VectorEnqueue VecotrPushBack
#define global VectorDequeue VectorPopFront

#define global ctype VectorVartype(%1) VectorInfo(%1, VarInfo_Flag@)
#define global ctype VectorVarmode(%1) VectorInfo(%1, VarInfo_Mode@)
#define global ctype VectorLen0(%1)    VectorInfo(%1, VarInfo_Len0@)
#define global ctype VectorLen1(%1)    VectorInfo(%1, VarInfo_Len1@)
#define global ctype VectorLen2(%1)    VectorInfo(%1, VarInfo_Len2@)
#define global ctype VectorLen3(%1)    VectorInfo(%1, VarInfo_Len3@)
#define global ctype VectorLen4(%1)    VectorInfo(%1, VarInfo_Len4@)
;#define global ctype VectorSize(%1)    VectorInfo(%1, VarInfo_Size@)
#define global ctype VectorPtr(%1)     VectorInfo(%1, VarInfo_Ptr@)
#define global ctype VectorMaster(%1)  VectorInfo(%1, VarInfo_Master@)

#define global VectorLen VectorLen1

#define ctype VectorToString(%1) VectorJoin((%1), ", ", "[ ", " ]")
;#define global ctype VectorSliceOut(%1, %2, %3) (VectorSlice(%1, , %2) + VectorSlice(%1, %3, ))
;#define global ctype VectorReplace(%1, %2, %3, %4) (VectorSlice(%1, , %2) + (%4) + VectorSlice(%1, %3, ))

// �萔�E�}�N��

#define global VectorLast (-0x031EC10A)
#define global VectorEnd  (-0x031EC10B)

// ���W���[��

#module __vector_mod

// @static
	dim ref_v@__vector_mod
;	dimtype ref_vector@__vector_mod, vector

#define global ctype VectorRef(%1) ref_v@__vector_mod( VectorClone(%1, ref_v@__vector_mod) )
;#defcfunc VectorRef_core@__vector_mod array p1
;	VectorClone ref_v, p1()
;	return 0

// vector ����
#define global ctype vector_reserved(%1) VectorExpr( vector_reserved_(%1) )
#defcfunc vector_reserved_ int size,  local it
	vector it, size
	VectorReturn it()
	
#define global ctype vector_from_array(%1) VectorExpr( vector_from_array_(%1) )
#defcfunc vector_from_array_ array src,  local it
	vector it, length(src)
	foreach src
		it(cnt) = src(cnt)
	loop
	VectorReturn it()
	
#global

// ����݊�
#define global VectorVtName "vector_k"
#define global VectorInsert1 VectorInsertOne
#define global VectorRemove1 VectorRemoveOne
#define global ctype VectorMove(%1, %2, %3) VectorRelocate(%1, %3, %2)

#endif
