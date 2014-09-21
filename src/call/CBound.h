// �����֐��N���X
#if 0
#ifndef IG_CLASS_BOUND_H
#define IG_CLASS_BOUND_H

#include "hsp3plugin_custom.h"
#include <vector>

#include "Functor.h"
#include "IFunctor.h"

//	#define DBGOUT_BOUND_ADDREF_OR_RELEASE	// AddRef, Release �� dbgout �ŕ񍐂���

class CCaller;
class CPrmInfo;

class CBound;
using bound_t = CBound*;

class CBound
	: public IFunctor
{
	using prmidxAssoc_t = std::vector<int>;

	// �����o�ϐ�
private:
	CCaller*  mpCaller;				// ����������ێ�����
	CPrmInfo* mpRemains;			// �c���� (CBound ����������)

	prmidxAssoc_t* mpPrmIdxAssoc;	// �c�����ƌ������̈����ԍ��̑Ή������ (�e�v�f: �������̈����ԍ�)

	// �\�z
private:
	CBound();
	~CBound();

	void createRemains();

public:

	CCaller*  getCaller()  const { return mpCaller; }
	CPrmInfo& getPrmInfo() const { return *mpRemains; }

	// �p��
	label_t getLabel() const { return getBound()->getLabel(); }
	int     getAxCmd() const { return getBound()->getAxCmd(); }
	int     getUsing() const { return 1; }

	functor_t const& unbind() const;

	// ����
	void bind();							// ��������
	void call( CCaller& callerRemain );		// (���������������� + �Ăяo��)

	// ���b�p�[
	static bound_t New();

private:
	functor_t const& getBound() const;		// �푩���֐�

};

#endif
#endif