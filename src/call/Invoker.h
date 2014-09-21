#ifndef IG_CLASS_FUNCTION_CALLER_H
#define IG_CLASS_FUNCTION_CALLER_H

// �֐��Ăяo���̃I�u�W�F�N�g
// �������璼�� prmstack �̐������s���B
// CCaller, CCall �̑���ɂ������B

// CStreamCaller �Ɏ��Ă��邪�A�Ăяo�����ɒǉ��̈�����^�����Ȃ��B

// �Ƃ�������ō�������A�̂� CPrmStk (�������f�[�^) �����L���A�R�[�h��������������o���@�\�������Ƃł���B
// argument �^�I�u�W�F�N�g�Ƃ������Ƃɂ����������܂肪�����C������B

#include "hsp3plugin_custom.h"
#include "Functor.h"
#include "CPrmStk.h"
#include "ManagedPVal.h"

#include "mod_makepval.h"

enum class InvokeMode : unsigned char
{
	Call = 0,
	Bind,
};

class Invoker
{
private:
	// �]����
	functor_t functor_;

	// �������f�[�^
	arguments_t args_;

	InvokeMode invmode_;

	// �Ԓl�f�[�^
	ManagedPVal result_;

	static ManagedPVal lastResult;

public:
	// �\�z
	// @prm f: must be non-null
	Invoker(functor_t f, InvokeMode invmode_ = InvokeMode::Call)
		: functor_ { f }
		, args_ { f->getPrmInfo() }
		, invmode_ { invmode_ }
		, result_ { nullptr }
	{ }

//	Invoker(Invoker const&) = delete;

public:
	void invoke() { push(*this); functor_->invoke(*this); pop(); }

	functor_t const& getFunctor() const { return functor_; }
	CPrmInfo const& getPrmInfo() const { return args_.getPrmInfo(); }

	// ������
	arguments_t& getArgs() { return args_; }
	arguments_t const& getArgs() const { return args_; }

	// �Ԓl
	bool hasResult() const { return !result_.isNull(); }
	PVal* getResult() const {
		if ( !hasResult() ) puterror(HSPERR_NORETVAL);
		return result_.valuePtr();
	}
	PVal* setResult(PVal* pval)
	{
		result_ = ManagedPVal::ofValptr(pval);
		return getResult();
	}
	PVal* setResult(PDAT const* pdat, vartype_t vtype)
	{
		result_.reset();
		PVal_assign(result_.valuePtr(), pdat, vtype);
		return getResult();
	}

	// �R�[�h�̎��o��
	void code_get_arguments();

private:
	bool code_get_nextArgument();

	// �Ăяo���X�^�b�N
	static void push(Invoker&);
	static void pop();
public:
	static Invoker& top();

	// �Ԓl
	static PVal* getLastResult() { return lastResult.valuePtr(); }
	static void clearLastResult() { lastResult.nullify(); }
};

#endif
