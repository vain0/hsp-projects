// �R���[�`���N���X
#if 0
#include "CCoRoutine.h"

#include "CCall.h"
#include "CCaller.h"
#include "Functor.h"
#include "CPrmInfo.h"

using namespace hpimod;

PVal const* CCoRoutine::stt_pvNextVar = nullptr;

//------------------------------------------------
// �\�z (���b�p�[)
//------------------------------------------------
coroutine_t CCoRoutine::New()
{
	return new CCoRoutine();
}

//------------------------------------------------
// �\�z
//------------------------------------------------
CCoRoutine::CCoRoutine()
	: mpCaller( new CCaller )
{ }

//------------------------------------------------
// �j��
//------------------------------------------------
CCoRoutine::~CCoRoutine()
{
	delete mpCaller; mpCaller = nullptr;
	return;
}

//------------------------------------------------
// �Ăяo������
// 
// @ �֐����Ăяo�� or ���s���ĊJ����B
//------------------------------------------------
void CCoRoutine::call( CCaller& callerGiven )
{
	mpCallerGiven = &callerGiven;

	{
		// �Ăяo��
		mpCaller->call();

		// ���̌Ăяo������Đݒ肷��
		if ( stt_pvNextVar ) {
			if ( stt_pvNextVar->flag != HSPVAR_FLAG_LABEL ) puterror( HSPERR_TYPE_MISMATCH );
			label_t const lb = VtTraits::derefValptr<vtLabel>(stt_pvNextVar->pt);

			mpCaller->setFunctor(Functor::New(lb));		// ���̌Ăяo������m��
			stt_pvNextVar = nullptr;
		}

		// �Ԓl�� callerGiven �ɓ]������
		callerGiven.getCall().setRetValTransmit( mpCaller->getCall() );
	}
	return;
}

//------------------------------------------------
// ������
//------------------------------------------------
CPrmInfo const& CCoRoutine::getPrmInfo() const
{
	return CPrmInfo::noprmFunc;
}

//------------------------------------------------
// 
//------------------------------------------------

#endif