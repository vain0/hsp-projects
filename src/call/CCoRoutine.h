// �R���[�`���N���X
#if 0
// IFunctor ���p������K�v������B

#ifndef IG_CLASS_CO_ROUTINE_H
#define IG_CLASS_CO_ROUTINE_H

#include <vector>

#include "hsp3plugin_custom.h"
#include "IFunctor.h"
#include "Functor.h"

//	#define DBGOUT_CO_ROUTINE_ADDREF_OR_RELEASE	// AddRef, Release �� dbgout �ŕ񍐂���

class CCoRoutine;
class CCaller;

using coroutine_t = CCoRoutine*;

class CCoRoutine
	: public IFunctor
{
	// �����o�ϐ�
private:
	CCaller* mpCaller;		// �p�����Ă���Ăяo��
	functor_t mNext;			// ���ɌĂяo�����x��

	CCaller const* mpCallerGiven;	// ���ۂ̌Ăяo���ւ̎Q��

	static PVal const* stt_pvNextVar;	// next ���󂯎��ϐ��ւ̎Q��

	// �\�z
private:
	CCoRoutine();
	~CCoRoutine();

public:
	CCaller* getCaller()  const { return mpCaller; }
	CPrmInfo const& getPrmInfo() const;

	// �p��
	label_t getLabel() const { return mNext.getLabel(); }
	int     getAxCmd() const { return mNext.getAxCmd(); }
	int     getUsing() const { return 1; }

	// ����
	void call( CCaller& callerGiven );		// �ǉ�����

	// ���b�p�[
	static coroutine_t New();

	static void setNextVar( PVal const* pv )	// co_yield_impl ���s���ɃR���[�`�����Q�Ƃ�����@�͂Ȃ� (���ۂɌĂ΂�Ă���͎̂��̂Ȃ킯����)
	{ stt_pvNextVar = pv; }
};

#endif

#endif