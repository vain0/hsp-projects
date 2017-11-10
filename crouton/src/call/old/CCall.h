// call �N���X
#if 0
#ifndef IG_CLASS_CALL_H
#define IG_CLASS_CALL_H

/**
@summary:
	call �Ɋւ��邷�ׂĂ̏����Ǘ�����N���X�B
	CCaller �ɂ���Ă̂ݐ����A��́A���L�����B

@role:
	1. call �Ɋւ��邷�ׂĂ̏��̊֘A�Â��B
		0. �Ăяo����   functor_t
			�����ݒ肵�Ȃ��ƈ�����^�����Ȃ��B
		1. ���������   CPrmInfo
			functor_t ����ԐړI�ɓ�����B
		2. �������f�[�^ CArgData
		3. �Ԓl��� (�ȗ���)
			call_retval �ɂ���ė^����ꂽ�Ԓl�̕ۑ���S������B
			return �ɂ���ē�����Ԓl�� caller ���������Ă����B
	2. prmstk �̊Ǘ��B
		ctx->prmstack �ւ̑���A�� prmstack �̕ێ����A���ꂪ�s���B
		prmstk ��̃f�[�^ (char* �� local �� PVal) �́ACArgData ���Ǘ�����̂ŉ������K�v�͂Ȃ��B
**/

#include "hsp3plugin_custom.h"
using namespace hpimod;

#include "CCall.const.h"
#include "Functor.h"

class CCaller;
class CPrmInfo;

class CCall
{
private:
	class CArgData;

	// �����o�ϐ�
private:
	functor_t  mFunctor;		// �֐�
	CArgData* mpArg;		// �������f�[�^
	PVal*     mpRetVal;		// �Ԓl (���s���ɗ^����ꂽ�Ԓl�̕ۑ�)
	bool      mbRetValOwn;	// mpRetVal ���A���� Call �����L���Ă��� PVal ���ۂ�

	// prmstack �֘A
	void* mpOldPrmStack;	// �ȑO�� ctx->prmstack �l
	void* mpPrmStack;		// �Ǝ��� prmstack

	// ���̑�
	bool mbUnCallable;		// �Ăяo���s�\���H

public:
	//--------------------------------------------
	// �\�z�E���
	//--------------------------------------------
	CCall();
	~CCall();

	//--------------------------------------------
	// �R�}���h����
	//--------------------------------------------
	void alias( PVal* pval, int iArg ) const;
	PVal* getArgv( int iArg ) const;

	//--------------------------------------------
	// ����
	//--------------------------------------------
	void call( CCaller& caller );
	void callLabel( label_t lb );		// ���x���֐��̎��s���� (functor ����̂݋N���\)

	// �Ăяo���֐��̐ݒ�
	void setFunctor( functor_t const& functor );

	// �������f�[�^�̐ݒ�
	void addArgByVal( void const* val, vartype_t vt );
	void addArgByVal( PVal* pval );
	void addArgByRef( PVal* pval );
	void addArgByRef( PVal* pval, APTR aptr );
	void addArgByVarCopy( PVal* pval );
	void addArgSkip ( int lparam = 0 );
	void addLocal   ( PVal* pval );

	void completeArg();
	void clearArg();

	// �Ԓl�f�[�^�̐ݒ�
	void setResult( void* pRetVal, vartype_t vt );
	void setRetValTransmit( CCall& callSrc );		// �]��(�J��グ)

	// prmstack (���x���֐��̂Ƃ�)
private:
	void pushPrmStack();
	void popPrmStack();

	void createPrmStack();
	void destroyPrmStack();

	static void* newPrmStack( CCall* _this, char*(*pfAllocator)(int) );

	//--------------------------------------------
	// �擾
	//--------------------------------------------
public:
	functor_t const& getFunctor()  const { return mFunctor; }

	// ���������̎擾
	CPrmInfo const& getPrmInfo() const { return mFunctor->getPrmInfo(); }
	int   getPrmType    ( int iPrm ) const;
	PVal* getDefaultArg ( int iPrm ) const;
	void checkCorrectArg( PVal const* pvArg, int iArg, bool bByRef = false ) const;

	// �������f�[�^�̎擾
	size_t getCntArg() const;
	PVal* getArgPVal( int nArg ) const;
	APTR  getArgAptr( int iArg ) const;
	int   getArgInfo( ARGINFOID id, int iArg = -1 ) const;
	bool  isArgSkipped( int iArg ) const;
	PVal* getLocal( int iLocal ) const;

	// �Ԓl�f�[�^�̎擾
	PVal* getRetVal() const;

private:
	// ��n��
	void freeRetVal();

private:
	// ����
	CCall( CCall const& );
	CCall& operator = ( CCall const& );
};

#endif

#endif