// �֐��q�C���^�[�t�F�[�X

// �u�Ăяo������́v��\�����߂ɁA�v���O�C�����ō쐬����N���X�����̊��N���X�B
// �Ⴆ�΁ACLabelFunc, CBound, CLambda �ȂǂɌp������Ă���B

// Managed<> �ɓ���� functor_t �Ƃ��Ďg����B

#ifndef IG_INTERFACE_FUNCTOR_H
#define IG_INTERFACE_FUNCTOR_H

#include "hsp3plugin_custom.h"
using namespace hpimod;

class CPrmInfo;
class CCaller;
class CPrmStk;
class Invoker;

//------------------------------------------------
// �֐��q��\���N���X
// 
// @ �p�����Ďg���B
// @ �����ł͊��蓮����`���Ă���B
//------------------------------------------------
class IFunctor
{
protected:
	IFunctor() = default;

public:
	virtual ~IFunctor() { clear(); }
	virtual void clear() { }

	// �擾
	virtual label_t getLabel() const { return nullptr; }
	virtual int getAxCmd() const { return 0; }

	virtual int getUsing() const { return 0; }			// �g�p�� (0: ����, 1: �L��, 2: �N���[��)
	virtual CPrmInfo const& getPrmInfo() const = 0;		// ������

	// �L���X�g
	template<typename T>       T*     castTo()       { return dynamic_cast<T*>(this); }
	template<typename T> const T*     castTo() const { return dynamic_cast<T*>(this); }
	template<typename T>       T* safeCastTo()       { return safeCastTo_Impl<T*>(); }
	template<typename T> const T* safeCastTo() const { return safeCastTo_Impl<T const*>(); }

	template<typename T> T safeCastTo_Impl() const {
		auto const result = castTo<T>();
		if ( !result ) puterror(HSPERR_TYPE_MISMATCH);
		return result;
	}

	// ����
	virtual void invoke(Invoker&) = 0;

	// �`���I��r
	virtual int compare(IFunctor const& obj) const { return this - &obj; }
};

#endif
