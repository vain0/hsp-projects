// Caller - header

#ifndef IG_CLASS_CALLER_H
#define IG_CLASS_CALLER_H

/**
@summary:
	call �������s���ۂɕK�{�̃N���X�B
	���ۂ� call �������s�����߂̃C���^�[�t�F�[�X�B

@role:
	- ���ԃR�[�h�� ctx �ւ̑���� CCaller ���s���B
	- �������̏����B
	- call-jump �����B
		1. prmstk �̏��������B
		2. gosub �����B
		3. �Ԓl�̎󂯎��B

@impl:
	- ���ۂ̃f�[�^�Ǘ��́A���L���� CCall �ɂ��ׂĔC����B
		call �f�[�^�ւ̃A�N�Z�X���ACCall* �ւ̃A�N�Z�X�ɂ���čs���悤�ɂ���B
	- �ē��\���͂Ȃ��B
**/

#if 0
#include <stack>
#include <memory>
#include "hsp3plugin_custom.h"

#include "CCall.h"

using namespace hpimod;

extern CCall* TopCallStack();

class CCaller
{
public:
	enum class CallMode {
		Proc = 0,
		Bind,
	};

private:
	CallMode mMode;
	std::unique_ptr<CCall> mpCall;

	// caller ���S��Ɏg������ static �����o�ɂ��Ă���
	static PVal* stt_respval;

public:
	CCaller();
	CCaller( CallMode mode );

	// ����
	void call();

	void setFunctor();
	void setFunctor( functor_t const& functor );

	void setArgAll();
	bool setArgNext();
	void addArgByVal( void const* val, vartype_t vt );
	void addArgByRef( PVal* pval );
	void addArgByRef( PVal* pval, APTR aptr );
	void addArgByVarCopy( PVal* pval );

	// �擾
	CCall& getCall() const { return *mpCall; }

	PVal* getRetVal() const;
	vartype_t getCallResult(PDAT** ppResult);

	static PVal* getLastRetVal();
	static void releaseLastRetVal();

private:
	CCaller( CCaller const& ) = delete;
	CCaller& operator = ( CCaller const& ) = delete;
};

#endif
#endif
