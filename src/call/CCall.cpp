// CCall
#if 0
#include "hsp3plugin_custom.h"
#include "mod_makepval.h"

#include "CCall.h"
#include "CArgData.h"
#include "CPrmInfo.h"
#include "CPrmStkCreator.h"

#include "CCaller.h"
#include "CBound.h"

#include "cmd_sub.h"

using namespace hpimod;

//##############################################################################
//                ��`�� : CCall
//##############################################################################
//------------------------------------------------
// �\�z
//------------------------------------------------
CCall::CCall()
	: mFunctor()
	, mpArg         ( nullptr )
	, mpRetVal      ( nullptr )
	, mbRetValOwn   ( false )
	, mpOldPrmStack ( nullptr )
	, mpPrmStack    ( nullptr )
	, mbUnCallable  ( false )
{
	mpArg = new CArgData( this );
	return;
}

//------------------------------------------------
// ���
//------------------------------------------------
CCall::~CCall()
{
	// �������f�[�^����� (prmstack ��̃f�[�^���܂�)
	delete mpArg; mpArg = nullptr;

	// prmstack �̉��
	destroyPrmStack();

	// �Ԓl�f�[�^�����
	freeRetVal();

	return;
}

//##########################################################
//    �R�}���h����
//##########################################################
//------------------------------------------------
// �G�C���A�X
//------------------------------------------------
void CCall::alias(PVal* pval, int iArg) const
{
	if ( !numrg<size_t>(iArg, 0, mpArg->getCntArg() - 1) ) return;

	// �G�C���A�X�ϐ����A�����l�̃N���[���Ƃ���
	PVal*  pvalArg = mpArg->getArgPVal( iArg );		// �����̕ϐ�
	APTR   aptr    = mpArg->getArgAptr( iArg );

	// �ϐ��N���[����
	PVal_cloneVar( pval, pvalArg, aptr );

	return;
}

//------------------------------------------------
// �������f�[�^���擾����
// 
// @result : ���������i�[���� PVal �ւ̃|�C���^
//------------------------------------------------
PVal* CCall::getArgv(int iArg) const
{
	PVal* pval = mpArg->getArgPVal( iArg );

	if ( !pval ) {
		pval = PVal_getDefault();	// ����l���g��
	}

	return pval;
}

//##########################################################
//    ����
//##########################################################
//------------------------------------------------
// call
// 
// @ ������Ă΂�邱�Ƃɒ��ӂ��Ă��Ȃ��B
// @	��������ꍇ�� CPrmStack ���g���񂷂ׂ��B
//------------------------------------------------
void CCall::call( CCaller& caller )
{
	if ( mFunctor.isNull() || mbUnCallable ) {
		dbgout("�Ăяo�����s\n����������: �֐������ݒ�� functor, nobind �������^����ꂽ, etc");
		puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}

	mFunctor->call( caller );
	return;
}

//------------------------------------------------
// ���x���̌Ăяo��
//------------------------------------------------
void CCall::callLabel( label_t lb )
{
	pushPrmStack();

	code_call( lb );	// �T�u���[�`���Ăяo��

	popPrmStack();
	return;
}

//------------------------------------------------
// �Ăяo���֐��̐ݒ�
//------------------------------------------------
void CCall::setFunctor( functor_t const& functor )
{
	mFunctor = functor;

	// �����̐��� reserve
	mpArg->reserveArgs( getPrmInfo().cntPrms() );
	mpArg->reserveLocals( getPrmInfo().cntLocals() );
	return;
}

//################################################
//    �������f�[�^�̐ݒ�
//################################################
//------------------------------------------------
// ������ǉ����� ( �Q�Ɠn�� )
//------------------------------------------------
void CCall::addArgByRef( PVal* pval )
{
	return addArgByRef( pval, pval->offset );
}

void CCall::addArgByRef( PVal* pval, APTR aptr )
{
	mpArg->addArgByRef( pval, aptr );
	return;
}

//------------------------------------------------
// ������ǉ����� ( �l�n�� )
//------------------------------------------------
void CCall::addArgByVal( void const* val, vartype_t vt )
{
	mpArg->addArgByVal( val, vt );
	return;
}

void CCall::addArgByVal(PVal* pval)
{
	mpArg->addArgByVal( pval );
	return;
}

//------------------------------------------------
// ������ǉ����� ( �ϐ����� )
//------------------------------------------------
void CCall::addArgByVarCopy( PVal* pval )
{
	return mpArg->addArgByVarCopy( pval );
}

//------------------------------------------------
// ������ǉ����� ( �X�L�b�v )
//------------------------------------------------
void CCall::addArgSkip( int lparam )
{
	mbUnCallable = true;
	mpArg->addArgByRef( nullptr, lparam );
	return;
}

//------------------------------------------------
// ���[�J���ϐ���ǉ�����
//------------------------------------------------
void CCall::addLocal( PVal* pval )
{
	mpArg->addLocal( pval );
	return;
}

//------------------------------------------------
// 
//------------------------------------------------

//------------------------------------------------
// ����Ȃ�����������l�ŕ₤
//------------------------------------------------
void CCall::completeArg(void)
{
	CPrmInfo const& prminfo = getPrmInfo();

	// �ϒ������ł͂Ȃ��̂ɁA��������������
	if ( !prminfo.isFlex() && prminfo.cntPrms() < mpArg->getCntArg() ) {
		puterror( HSPERR_TOO_MANY_PARAMETERS );
	}

	// ����l�Ŗ��߂�A���܂�Ȃ���΃G���[
	for ( size_t i = mpArg->getCntArg()
		; i < prminfo.cntPrms()
		; ++ i
	) {
		// �ȗ��l or �G���[
		mpArg->addArgByVal(
			prminfo.getDefaultArg(i)
		);
	}
	return;
}

//------------------------------------------------
// �������������ׂď�������
//------------------------------------------------
void CCall::clearArg()
{
	mpArg->clearArg();
	return;
}

//################################################
//    ���������
//################################################


//################################################
//    �Ԓl
//################################################
//------------------------------------------------
// �Ԓl�̐ݒ�
//------------------------------------------------
void CCall::setResult(void* pRetVal, vartype_t vt)
{
	if ( !mpRetVal && !mbRetValOwn ) {
		mpRetVal = new PVal;
		PVal_init( mpRetVal, vt );
		mbRetValOwn = true;
	}

	// ���
	code_setva( mpRetVal, 0, vt, pRetVal );
	return;
}

// �]�������
void CCall::setRetValTransmit( CCall& callSrc )
{
	std::swap( mpRetVal,    callSrc.mpRetVal );
	std::swap( mbRetValOwn, callSrc.mbRetValOwn );
	return;
}

//################################################
//    prmstack
//################################################
//------------------------------------------------
// prmstack push
//------------------------------------------------
void CCall::pushPrmStack()
{
	mpOldPrmStack = ctx->prmstack;	// �ȑO�� prmstack �̏��

	if ( !mpPrmStack ) createPrmStack();

	// prmstack �̕ύX
	ctx->prmstack = mpPrmStack;
	return;
}

//------------------------------------------------
// prmstack pop
//------------------------------------------------
void CCall::popPrmStack()
{
	ctx->prmstack = mpOldPrmStack;		// prmstack ��߂�
	return;
}

//------------------------------------------------
// prmstack ���� / �j��
//------------------------------------------------
void CCall::createPrmStack()
{
	destroyPrmStack();
	mpPrmStack = newPrmStack( this, hspmalloc );
	return;
}

void CCall::destroyPrmStack()
{
	if ( mpPrmStack ) {
		hspfree( mpPrmStack ); mpPrmStack = nullptr;
	}
	return;
}

//------------------------------------------------
// CPrmStk �̐ݒ�
// 
// @static
// @ ���錾 => �������^�C�v�ɉ������`���ŐςށA�ϒ������͐ς܂Ȃ� (���Ӗ��Ȃ̂�)�B
// @ ���錾 => ���ׂĐςށB
// @ �����̐��ɂ��ẮA�������擾���Ɍ����ς݁B
// @ �o�b�t�@�͎󂯎��������������邱�ƁB
//------------------------------------------------
void* CCall::newPrmStack( CCall* const pCall, char*(*pfAllocator)(int) )
{
	CPrmInfo const& prminfo = pCall->getPrmInfo();

	// ���������X�g�ʂ�ɐς� ( HSP�{�̂Ɠ����`�� )
	if ( &prminfo != &CPrmInfo::undeclaredFunc ) {
		size_t const sizeStack = prminfo.getStackSize();
		size_t const cntPrms   = prminfo.cntPrms();

		CPrmStkCreator prmstk( (*pfAllocator)( sizeStack ), sizeStack );

		for ( size_t i = 0; i < cntPrms; ++ i )
		 {
			PVal* const pval = pCall->getArgPVal(i);
			APTR  const aptr = pCall->getArgAptr(i);		// �l�n�������Ȃ畉

			int const prmtype = prminfo.getPrmType(i);

			switch ( prmtype ) {
				case HSPVAR_FLAG_LABEL:		// HSP���ł͖���������
					prmstk.pushValue( VtTraits<label_t>::derefValptr(pval->pt) );
					break;

				case HSPVAR_FLAG_STR:
					prmstk.pushValue( pval->pt );
					break;

				case HSPVAR_FLAG_DOUBLE:
					prmstk.pushValue( *reinterpret_cast<double*>(pval->pt) );
					break;

				case HSPVAR_FLAG_INT:
					prmstk.pushValue( *reinterpret_cast<int*>(pval->pt) );
					break;

				case PrmType::Var:
				case PrmType::Array:
				case PrmType::Any:
					prmstk.pushPVal( pval, aptr );
					break;

				case PrmType::Modvar:
				{
					auto const fv = reinterpret_cast<FlexValue*>( PVal_getPtr(pval) );
					prmstk.pushThismod( pval, aptr, FlexValue_getModuleTag(fv)->subid );
					break;
				}
				default:
					// ���̑��̌^�^�C�v�l
					if ( HSPVAR_FLAG_INT < prmtype && prmtype < (HSPVAR_FLAG_USERDEF + ctx->hsphed->max_varhpi) ) {
						if ( pval->flag != prmtype ) puterror( HSPERR_TYPE_MISMATCH );
						prmstk.pushPVal( pval, aptr );
						break;
					}

					// �ُ�
					puterror( HSPERR_ILLEGAL_FUNCTION );
			}
		}

		// ���[�J���ϐ���ς�
		size_t const cntLocals = prminfo.cntLocals();
		for ( size_t i = 0; i < cntLocals; ++ i ) {
			pCall->addLocal( prmstk.allocLocal() );
		}

		return prmstk.getptr();

	// �������Ȃ� => �^����ꂽ���������ׂĐς�
	} else {
		size_t const cntArgs   = pCall->getCntArg();
		size_t const sizeStack = prminfo.getStackSizeWithFlex( cntArgs );

		CPrmStkCreator prmstk( (*pfAllocator)( sizeStack ), sizeStack );

		for ( size_t i = 0; i < cntArgs; ++ i ) {
			PVal* const pval = pCall->getArgPVal( i );

			// ���ׂ� var, array �̌`���œn��
			prmstk.pushPVal( pval, pval->offset );
		}

		return prmstk.getptr();
	}
}

//##########################################################
//    �擾
//##########################################################
//------------------------------------------------
// 
//------------------------------------------------

//################################################
//    �������f�[�^�̎擾
//################################################
//------------------------------------------------
// �������̐�
//------------------------------------------------
size_t CCall::getCntArg() const
{
	return mpArg->getCntArg();
}

//------------------------------------------------
// �������f�[�^�� pval
//------------------------------------------------
PVal* CCall::getArgPVal(int iArg) const
{
	return mpArg->getArgPVal( iArg );
}


//------------------------------------------------
// �������f�[�^�� pval �� aptr
//------------------------------------------------
APTR CCall::getArgAptr(int iArg) const
{
	return mpArg->getArgAptr( iArg );
}


//------------------------------------------------
// ���������
//------------------------------------------------
int CCall::getArgInfo(ARGINFOID id, int iArg) const
{
	// �����Ȃ�A�Ăяo���S�̂Ɋւ�����𓾂�
	if ( iArg < 0 ) {
		return mpArg->getArgInfo(id);

	// �������Ƃ̏��𓾂�
	} else {
		// id �͈̔̓`�F�b�N
		if ( !numrg<int>( id, 0, ARGINFOID_MAX - 1 ) ) {
			puterror( HSPERR_ILLEGAL_FUNCTION );	// "�����̒l���ُ�ł�"
		}

		return mpArg->getArgInfo(id, iArg);
	}
}

//------------------------------------------------
// �X�L�b�v���ꂽ�������H
//------------------------------------------------
bool CCall::isArgSkipped( int iArg ) const
{
	return mpArg->isArgSkipped(iArg);
}

//------------------------------------------------
// ���[�J���ϐ����擾
//------------------------------------------------
PVal* CCall::getLocal( int iLocal ) const
{
	return mpArg->getLocal(iLocal);
}

//################################################
//    ���������̎擾
//################################################
//------------------------------------------------
// �������^�C�v
//------------------------------------------------
int CCall::getPrmType(int iPrm) const
{
	return getPrmInfo().getPrmType(iPrm);
}


//------------------------------------------------
// �f�t�H���g�l
//------------------------------------------------
PVal* CCall::getDefaultArg(int iPrm) const
{
	return getPrmInfo().getDefaultArg(iPrm);
}


//------------------------------------------------
// �������������ǂ���
//------------------------------------------------
void CCall::checkCorrectArg(PVal const* pvArg, int iArg, bool bByRef) const
{
	getPrmInfo().checkCorrectArg( pvArg, iArg, bByRef );
	return;
}


//################################################
//    �Ԓl�f�[�^�̎擾
//################################################
//------------------------------------------------
// �Ԓl�� PVal �𓾂�
//------------------------------------------------
PVal* CCall::getRetVal() const
{
	return mpRetVal;
}

//##########################################################
//    ���������o�֐�
//##########################################################
//------------------------------------------------
// �Ԓl(mpRetVal)�̉��
//------------------------------------------------
void CCall::freeRetVal()
{
	if ( !mpRetVal ) return;

	if ( mbRetValOwn ) {
		// ���g�̉��
		PVal_free( mpRetVal );

		// mpRetVal ���̂̉��
		delete mpRetVal; 
	}

	mpRetVal    = nullptr;
	mbRetValOwn = false;
	return;
}

//------------------------------------------------
// 
//------------------------------------------------
#endif
