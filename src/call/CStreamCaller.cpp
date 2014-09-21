// �X�g���[���Ăяo���N���X
#if 0
#include "CStreamCaller.h"

#include "CCall.h"
#include "CCaller.h"

#include "mod_makepval.h"

using namespace hpimod;

static void AddAllArgsByRef( CCaller& caller, CCall const& callStream );

//------------------------------------------------
// �\�z (���b�p�[)
//------------------------------------------------
stream_t CStreamCaller::New()
{
	return new CStreamCaller();
}

//------------------------------------------------
// �\�z
//------------------------------------------------
CStreamCaller::CStreamCaller()
	: IFunctor()
	, mpCaller( new CCaller )
{ }

//------------------------------------------------
// �j��
//------------------------------------------------
CStreamCaller::~CStreamCaller()
{
	delete mpCaller; mpCaller = nullptr;
	return;
}

//------------------------------------------------
// �Ăяo������
// 
// @ �����Ȃ� => �X�g���[���̈���(�̎Q��)������p���ČĂяo��
// @ �������� => �X�g���[���̈����Ɨ^�����̘A��������ČĂяo��
//------------------------------------------------
void CStreamCaller::call( CCaller& callerGiven )
{
	CCall& callStream = mpCaller->getCall();
	CCall& callGiven  = callerGiven.getCall();

	// �����Ȃ� : �ȈՌĂяo�� (callerGiven ���g���܂킹��)
	if ( callGiven.getCntArg() == 0 ) {
		callerGiven.setFunctor( callStream.getFunctor() );		// �X�g���[�����Ă�ł���֐�

		AddAllArgsByRef( callerGiven, callStream );

		// �Ăяo��
		callerGiven.call();

	// ��������
	} else {
		CCaller caller;

		caller.setFunctor( callStream.getFunctor() );

		// ������ : �X�g���[���̈����Ɨ^��������ׂ�
		{
			AddAllArgsByRef( caller, callStream );
			AddAllArgsByRef( caller, callerGiven.getCall() );
		}

		// �Ăяo��
		caller.call();

		// �Ԓl�� callerGiven �ɓ]������
		callGiven.setRetValTransmit( caller.getCall() );
	}

	return;
}

//------------------------------------------------
// �X�g���[������������ caller �ɒǉ�����
//------------------------------------------------
static void AddAllArgsByRef( CCaller& caller, CCall const& callStream )
{
	// �X�g���[���ɗ^�����Ă��������������̂܂܈����n��
	for ( size_t i = 0; i < callStream.getCntArg(); ++ i ) {
		caller.addArgByRef(
			callStream.getArgPVal(i),
			callStream.getArgAptr(i)
		);
	}
	return;
}

#if 0
	/* �{�c
		// �^����ꂽ������S�ăX�g���[���ɒǉ����A��菜��
		for ( int i = 0; i < callNow->getCntArg(); ++ i ) {
			PVal* const pval = callNow->getArgPVal(i);
			APTR  const aptr = callNow->getArgAptr(i);

			if ( callNow->getArgInfo( ARGINFOID_BYREF, i ) ) {	// �Q�Ɠn��
				mpCaller->addArgByRef( pval, aptr );
			} else {
				mpCaller->addArgByVal( PVal_getptr(pval, aptr), pval->flag );
			}
		}
		callNow->clearArg();
	//*/
#endif

//------------------------------------------------
// �擾�n
//------------------------------------------------
label_t         CStreamCaller::getLabel()   const { return getCaller()->getCall().getFunctor().getLabel(); }
int             CStreamCaller::getAxCmd()   const { return getCaller()->getCall().getFunctor().getAxCmd(); }
CPrmInfo const& CStreamCaller::getPrmInfo() const { return getCaller()->getCall().getFunctor().getPrmInfo(); }
int             CStreamCaller::getUsing()   const { return 1; }

//------------------------------------------------
// 
//------------------------------------------------

//------------------------------------------------
// 
//------------------------------------------------
#endif