// �����_�֐��N���X
#if 0
#ifndef IG_CLASS_LAMBDA_FUNC_H
#define IG_CLASS_LAMBDA_FUNC_H

#include "hsp3plugin_custom.h"
#include <vector>
#include <memory>

#include "CCaller.h"
#include "CHspCode.h"
#include "CPrmInfo.h"
#include "IFunctor.h"

class CLambda;
using myfunc_t = CLambda*;

class CLambda
	: public IFunctor
{
	// �����o�ϐ�
private:
	// ����֐��̖{�̃R�[�h�A������
	std::unique_ptr<CHspCode> mpBody;		
	std::unique_ptr<CPrmInfo> mpPrmInfo;

	// �������̎�������ۑ��������
	std::unique_ptr<CCaller> mpArgCloser;

	// �\�z
private:
	CLambda();

	CCaller* argCloser();

public:
	void call( CCaller& caller );

	void code_get();

	CHspCode const& getBody()    const { return *mpBody; }
	CPrmInfo const& getPrmInfo() const;
	label_t         getLabel()   const;

	int getUsing() const { return 1; }

	// ���b�p�[
	static myfunc_t New();
};

#endif

#endif