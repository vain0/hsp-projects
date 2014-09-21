// call - ModCls, functor

// ���W���[���N���X�\�z�֐��N���X
#if 0
#include "hsp3plugin_custom.h"

#include "Functor.h"
#include "CModClsCtor.h"

#include "CCall.h"
#include "CCaller.h"
#include "CPrmInfo.h"

#include "cmd_sub.h"

#include "cmd_modcls.h"
#include "modcls_FlexValue.h"
#include "vt_structWrap.h"

using namespace hpimod;

//------------------------------------------------
// �\�z (���b�p�[)
//------------------------------------------------
modctor_t CModClsCtor::New()
{
	return new CModClsCtor();
}

modctor_t CModClsCtor::New( stdat_t pStDat )
{
	return new CModClsCtor( pStDat );
}

modctor_t CModClsCtor::New( int modcls )
{
	return new CModClsCtor( modcls );
}

//------------------------------------------------
// �\�z
//------------------------------------------------
CModClsCtor::CModClsCtor()
	: IFunctor()
	, mpStDat( nullptr )
	, mpPrmInfo( nullptr )
{
	initialize();
}

CModClsCtor::CModClsCtor( stdat_t pStDat )
	: IFunctor()
	, mpStDat( pStDat )
	, mpPrmInfo( nullptr )
{
	initialize();
}

CModClsCtor::CModClsCtor( int modcls )
	: IFunctor()
	, mpStDat( nullptr )
	, mpPrmInfo( nullptr )
{
	if ( modcls & AxCmd::MagicCode ) {
		if ( AxCmd::getType(modcls) != TYPE_STRUCT ) puterror( HSPERR_TYPE_MISMATCH );
		modcls = AxCmd::getCode( modcls );
	}

	stprm_t const pStPrm = getSTRUCTPRM(modcls);
	mpStDat = hpimod::STRUCTPRM_getStDat(pStPrm);

	initialize();
	return;
}

void CModClsCtor::initialize()
{
	if ( !ModCls::isWorking() ) {
		dbgout("modcls �@�\���K�v");
		puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	if ( mpStDat && getStPrm()->mptype != MPTYPE_STRUCTTAG ) puterror( HSPERR_TYPE_MISMATCH );

	createPrmInfo();
	return;
}

//------------------------------------------------
// �j��
//------------------------------------------------
CModClsCtor::~CModClsCtor()
{
	delete mpPrmInfo; mpPrmInfo = nullptr;
//	dbgout("%s 's modclsctor destructed", mpStDat ? &ctx->mem_mds[mpStDat->nameidx] : "bottom");
	return;
}

//------------------------------------------------
// �Ăяo������
// 
// @ ������ĂԂ��߂ɗp���� callerInvoke �𗬗p���Ă������̂����A
// @	thismod �������ŏ��ɕt�������Ȃ���΂����Ȃ����߁A
// @	�V���� caller ���g���Ă���B
// @	( CCall �Ɂu�擪�Ɉ�����ǉ�����v���߂̊֐������̂͌� )
// @ �����I�� const �ȏ����B
//------------------------------------------------
void CModClsCtor::call( CCaller& callerInvoke )
{
	CCall& callInvoke = callerInvoke.getCall();

	if ( isBottom() ) {
		callInvoke.setResult( ModCls::getNullmod()->pt, HSPVAR_FLAG_STRUCT );
		return;
	}

	FlexValue self { };
	FlexValue_CtorWoCtorCalling( self, mpStDat );
	FlexValue_AddRefTmp( self );			// ��ŃX�^�b�N�ɐς܂��

	{
		CCaller caller;
		caller.setFunctor( AxCmd::make(TYPE_MODCMD, getCtor()->subid) );

		// thismod ����
		caller.addArgByVal( &self, HSPVAR_FLAG_STRUCT );

		// ctor ������n��
		for ( size_t i = 0; i < callInvoke.getCntArg(); ++ i ) {
			caller.addArgByRef( callInvoke.getArgPVal(i), callInvoke.getArgAptr(i) );
		}

		// �Ăяo��
		caller.call();
	}

	// �Ԓl
	callInvoke.setResult( &self, HSPVAR_FLAG_STRUCT );
	
	// �ϐ� self �ɂ�鏊�L�̏I��
	FlexValue_Release(self);
	return;
}

//------------------------------------------------
// �ŏ��� STRUCTPRM �𓾂�
//------------------------------------------------
stprm_t CModClsCtor::getStPrm() const
{
	return mpStDat ? &ctx->mem_minfo[ mpStDat->prmindex ] : nullptr;
}

//------------------------------------------------
// �R���X�g���N�^�̃��[�U��`�R�}���hID���擾����
//------------------------------------------------
int CModClsCtor::getCtorId() const
{
	auto const pStPrm = getStPrm();
	return pStPrm ? AxCmd::make( TYPE_MODCMD, pStPrm->offset ) : 0;
}

stdat_t CModClsCtor::getCtor() const
{
	int const id = getCtorId();
	return ( id & AxCmd::MagicCode ) ? getSTRUCTDAT( AxCmd::getCode(id) ) : nullptr;
}

//------------------------------------------------
// ��`ID
//------------------------------------------------
int CModClsCtor::getAxCmd() const
{
	return AxCmd::make( TYPE_STRUCT, mpStDat->prmindex );
}

//------------------------------------------------
// ���x��
//------------------------------------------------
label_t CModClsCtor::getLabel() const
{
	auto const ctor = getCtor();

	return ctor ? hpimod::getLabel( ctor->otindex ) : nullptr;
}

//------------------------------------------------
// ���������X�g
//------------------------------------------------
CPrmInfo const& CModClsCtor::getPrmInfo() const
{
	return mpPrmInfo ? *mpPrmInfo : CPrmInfo::noprmFunc;
}

//------------------------------------------------
// ���������X�g�̐���
//------------------------------------------------
void CModClsCtor::createPrmInfo()
{
	auto const ctor = getCtor();
	if ( !ctor ) return;

	CPrmInfo const& prminfo = GetPrmInfo( ctor );	// ctor ���̂� prminfo�@���擾����
	int const cntPrms   = prminfo.cntPrms();		// ctor ���������̐�
	int const cntLocals = prminfo.cntLocals();

	// ctor �� prmlist ����A�ŏ��� thismod ������������ prmlist �����
	CPrmInfo::prmlist_t prmlist;
	prmlist.reserve( (cntPrms - 1) + cntLocals );
	for ( int i =  1  ; i < cntPrms; ++ i ) {
		prmlist.push_back( prminfo.getPrmType(i) );
	}
	for ( int i = 0; i < cntLocals; ++ i ) prmlist.push_back( PrmType::Local );

	mpPrmInfo = new CPrmInfo( &prmlist, prminfo.isFlex() );

	return;
}
#endif