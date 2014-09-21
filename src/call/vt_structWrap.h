// Call(ModCls) - vartype(struct)

#if 0
#ifndef IG_VARTYPE_STRUCT_WRAP_H
#define IG_VARTYPE_STRUCT_WRAP_H

#include <map>
#include "hsp3plugin_custom.h"
#include "Functor.h"

using namespace hpimod;
// HspVarProc(struct) �̏����֐��͂��ׂĒu��������B
// @ HSP�{�̂Ƃ̌݊����͈ێ�����B
// @ FlexValue::ptr (�����o�o�b�t�@) �́A�Q�ƃJ�E���^�̂��߂ɗ]���� 8[byte] �m�ۂ���B
// @ -	�����o����у����o�o�b�t�@�͎Q�ƃJ�E���^�� 0 �ɂȂ����Ƃ��ɏ��߂Ĕj������B
// @ -	�����o�o�b�t�@����������ꍇ�A��������L���Ă����S�ẴC���X�^���X�� nullptr �ɂ���B
// @	�Q�ƃJ�E���^�� 0 �Ȃ�A�Q�ƃJ�E���^�𓾂邽�߂Ƀ����o�o�b�t�@���Q�Ƃ��邪�A����͉������Ă���̂ŁA������B
// @ FlexValue::clonetype �͑S�� 1 �ɂ��āA�I�����̎����I�f�X�g���N�g���s��Ȃ��B
// @ -	�������A�X�N���v�g���ŁAclonetype == 0 �ł���C���X�^���X(termer)��1�����������A
// @	����̎����N���f�X�g���N�^�ŁAModOp_Term() ���ĂԁB�����őS�Ă̐����C���X�^���X���n������B

// @ �~ mpval �̓N���[���ϐ��Ƃ��Ă̂ݓ��삷��
// @	�Ō�ɉ�̂����Ƃ��Ampval ���Q�Ƃ������Ă�����A�e���|�����ϐ��̂Ȃ���ԂŃf�X�g���N�^���ĂԂ��ƂɂȂ邽�߁B
// @	( mpval �ɒ��ڎQ�Ƃł����Ȃ�AModOp_Term() �ŉ�̂ł���̂Ŗ��Ȃ����c�c )
// @�� ���ڎQ�Ƃł���悤�ɂ����̂� mpval �����ʂ� modinst �^�ϐ��Ƃ��ċ@�\����B

extern void HspVarStructWrap_Init( HspVarProc* vp );
extern void HspVarStructWrap_Dup( FlexValue* result, FlexValue* fv );

namespace ModCls {

using OpFuncDefs   = std::map<int, functor_t>;	// ���Z�֐��̘A�z�z�� (�Y��: OpId_*)
using CModOperator = std::map<int, OpFuncDefs>;	// (���W���[���N���X, ���Z�֐�)

// �N���X�Ɖ��Z�֐��̑Ή���ێ�����N���X
extern CModOperator const* getModOperator();

// �e���|�����ϐ��̎Q��
extern PVal* getMPValStruct();
extern PVal* getMPVal(vartype_t type);

// nullmod �ϐ�
extern PVal const* getNullmod();

// traits
using StructTraits = VtTraits<struct_tag>;

}

#endif
#endif