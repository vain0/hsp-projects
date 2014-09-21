// call - command.cpp

#include <stack>
#include <set>

#include "hsp3plugin_custom.h"
#include "reffuncResult.h"
#include "mod_argGetter.h"
#include "mod_varutil.h"
#include "axcmd.h"

#include "CCall.h"
#include "CCaller.h"

#include "Functor.h"
#include "Invoker.h"

#include "CBound.h"
#include "CStreamCaller.h"
#include "CLambda.h"
#include "CCoRoutine.h"

#include "cmd_call.h"
#include "cmd_sub.h"

#include "vt_functor.h"

using namespace hpimod;

//------------------------------------------------
// ���x�����߁E�֐��̌Ăяo��
//------------------------------------------------
int CallCmd::call( PDAT** ppResult )
{
	auto&& f = code_get_functor();
	Invoker inv { std::move(f) };
	inv.code_get_arguments();
//	dbgout("%d", inv.getArgs().cntArgs());
	inv.invoke();

	if ( ppResult ) {
		PVal* const pval = inv.getResult();
		*ppResult = pval->pt;
		return pval->flag;
	} else {
		return HSPVAR_FLAG_NONE;
	}
}

//------------------------------------------------
// ���x�����߁E�֐��̉������錾
//------------------------------------------------
static label_t declareImpl()
{
	label_t const lb = code_getlb();
	if ( !lb ) puterror( HSPERR_ILLEGAL_FUNCTION );

	CPrmInfo::prmlist_t&& prmlist = code_get_prmlist();		// ��������

	// �o�^
	DeclarePrmInfo( lb, CPrmInfo(&prmlist) );
	return lb;
}

int CallCmd::declare(PDAT** ppResult)
{
	if ( ppResult ) {
		return SetReffuncResult(ppResult, Functor::New(declareImpl()));
	} else {
		declareImpl();
		return HSPVAR_FLAG_NONE;
	}
}

//##########################################################
//        �������擾
//##########################################################
//------------------------------------------------
// arginfo
//------------------------------------------------
static int getArgInfo(Invoker const& inv, int id, size_t idxArg)
{
	auto const prmtype = inv.getPrmInfo().getPrmType(idxArg);

	switch ( id ) {
		case ArgInfoId::IsVal:
			if ( PrmType::isVartype(prmtype) ) {
				return HspTrue;

			} else if ( prmtype == PrmType::Any ) {
				return HspBool( ManagedPVal::isManagedValue(inv.getArgs().peekRefArgAt(idxArg)) );
			} else {
				return HspFalse;
			}
		case ArgInfoId::IsRef:
			if ( PrmType::isRef(prmtype) ) {
				return HspTrue;

			} else if ( prmtype == PrmType::Any ) {
				return HspBool(getArgInfo(inv, ArgInfoId::IsVal, idxArg) == HspFalse);

			} else {
				return HspFalse;
			}
		case ArgInfoId::IsMod:
			return prmtype == PrmType::Modvar;

		default: puterror(HSPERR_ILLEGAL_FUNCTION);
	}
}

//------------------------------------------------
// �Ăяo�����������擾����֐�
//------------------------------------------------
int CallCmd::arginfo(PDAT** ppResult)
{
	auto& inv = Invoker::top();

	auto const id = code_geti();	// �f�[�^�̎��
	int const idxArg = code_geti();
	if ( !(0 <= idxArg && static_cast<size_t>(idxArg) < inv.getArgs().cntArgs()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

	return SetReffuncResult( ppResult, getArgInfo(inv, id, idxArg) );
}

//------------------------------------------------
// ���x���֐��̕Ԓl��ݒ肷��
//------------------------------------------------
void CallCmd::call_setResult_()
{
	auto& inv = Invoker::top();
	if ( code_getprm() <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);

	inv.setResult(mpval->pt, mpval->flag);
	return;
}

//------------------------------------------------
// ���x���֐��̕Ԓl�ƂȂ����l�����o��
// 
// @ call �I����ɂ����Ăяo�����B
//------------------------------------------------
int CallCmd::call_getResult_(PDAT** ppResult)
{
	PVal* const pvResult = Invoker::getLastResult();
	if ( pvResult ) {
		*ppResult = pvResult->pt;
		return pvResult->flag;

	} else {
		puterror(HSPERR_NORETVAL);
	}
}

//------------------------------------------------
// �����̒l���擾����
//
// @ �Q�Ɠn�������̒l�͎��o���Ȃ��B
//------------------------------------------------
int CallCmd::argVal(PDAT** ppResult)
{
	auto& inv = Invoker::top();
	auto& args = inv.getArgs();

	int const idxArg = code_getdi(0);
	if ( !(0 <= idxArg && static_cast<size_t>(idxArg) < args.cntArgs()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

	// �Ԓl��ݒ肷��
	vartype_t vtype;
	*ppResult = args.peekValArgAt(idxArg, vtype);
	return vtype;
}

//------------------------------------------------
// �Q�ƈ����̃N���[�������
//------------------------------------------------
void CallCmd::argClone()
{
	auto& inv = Invoker::top();
	auto& args = inv.getArgs();

	PVal* const pval = code_getpval();
	int const idxArg = code_geti();
	if ( !(0 <= idxArg && static_cast<size_t>(idxArg) < args.cntArgs()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

	PVal* const pvalSrc = args.peekRefArgAt(idxArg);
	PVal_clone(pval, pvalSrc, pvalSrc->offset);
	return;
}

//------------------------------------------------
// �G�C���A�X�����ꊇ���ĕt����
//------------------------------------------------
void CallCmd::argCloneAll()
{
	auto& inv = Invoker::top();
	auto& args = inv.getArgs();

	// �񋓂��ꂽ�ϐ����G�C���A�X�ɂ���
	for ( size_t i = 0
		; code_isNextArg() && (i < args.cntArgs())
		; ++i
		) {
		try {
			PVal* const pval = code_getpval();
			PVal* const pvalSrc = args.peekRefArgAt(i);
			PVal_clone(pval, pvalSrc, pvalSrc->offset);

		} catch ( HSPERROR e ) {
			if ( e == HSPERR_VARIABLE_REQUIRED ) continue;
			puterror(e);
		}
	}
	return;
}

//------------------------------------------------
// local �ϐ��̒l���擾����
//
// @ �ŏ��̃��[�J���ϐ��� 0 �Ƃ���B
//------------------------------------------------
int CallCmd::localVal( PDAT** ppResult )
{
	auto& inv = Invoker::top();

	int const idxLocal = code_geti();
	if ( !(0 <= idxLocal && static_cast<size_t>(idxLocal) < inv.getPrmInfo().cntLocals()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

	PVal* const pvLocal = inv.getArgs().peekLocalAt(idxLocal);
	if ( !pvLocal ) puterror( HSPERR_ILLEGAL_FUNCTION );

	*ppResult = pvLocal->pt;
	return pvLocal->flag;
}

void CallCmd::localClone()
{
	PVal* pval = code_getpval();

	auto& inv = Invoker::top();
	int const idxLocal = code_geti();
	if ( !(0 <= idxLocal && static_cast<size_t>(idxLocal) < inv.getPrmInfo().cntLocals()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

	PVal* const pvLocal = inv.getArgs().peekLocalAt(idxLocal);
	if ( !pvLocal ) puterror( HSPERR_ILLEGAL_FUNCTION );

	PVal_clone(pval, pvLocal);
	return;
}

#if 0
int CallCmd::localVector(PDAT** ppResult)
{
	auto& inv = Invoker::top();

	vector_t vec {};
	for ( size_t i = 0; i < inv.getPrmInfo().cntLocals(); ++i ) {
		vec->push_back({ inv.getArgs().peekLocalAt(i), 0 });
	}
	return SetReffuncResult(ppResult, std::move(vec));
}
#endif


//------------------------------------------------
// �ϒ������̒l
//------------------------------------------------
int CallCmd::flexVal(PDAT** ppResult)
{
	auto& inv = Invoker::top();

	if ( auto pFlex = inv.getArgs().peekFlex() ) {
		auto& flex = *pFlex;

		int const idxFlex = code_geti();
		if ( !(0 <= idxFlex && static_cast<size_t>(idxFlex) < flex->size()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

		PVal* const pval = flex->at(idxFlex).getVar();
		*ppResult = pval->pt;
		return pval->flag;
	} else {
		puterror(HSPERR_ILLEGAL_FUNCTION);
	}
}

//------------------------------------------------
// �ϒ������̃N���[��
//------------------------------------------------
void CallCmd::flexClone()
{
	auto& inv = Invoker::top();

	if ( auto pFlex = inv.getArgs().peekFlex() ) {
		auto& flex = *pFlex;

		int const idxFlex = code_geti();
		if ( !(0 <= idxFlex && static_cast<size_t>(idxFlex) < flex->size()) ) puterror(HSPERR_ILLEGAL_FUNCTION);

		PVal* const pvalDst = code_getpval();
		PVal* const pvalSrc = flex->at(idxFlex).getVar();
		PVal_clone(pvalDst, pvalSrc, pvalSrc->offset);
		return;

	} else {
		puterror(HSPERR_ILLEGAL_FUNCTION);
	}
}

#if 0
//------------------------------------------------
// �ϒ������� vector
//------------------------------------------------
int CallCmd::flexVector(PDAT** ppResult)
{
	auto& inv = Invoker::top();
	if ( auto pFlex = inv.getArgs().peekFlex() ) {
		return SetReffuncResult(ppResult, *pFlex);

	} else {
		puterror(HSPERR_ILLEGAL_FUNCTION);
	}
}
#endif

//------------------------------------------------
// �Ăяo���ꂽ���x��
//------------------------------------------------
int CallCmd::thislb(PDAT** ppResult)
{
	return SetReffuncResult( ppResult, Invoker::top().getFunctor()->getLabel() );
}

int CallCmd::thisfunc(PDAT** ppResult)
{
	return SetReffuncResult( ppResult, Invoker::top().getFunctor() );
}

#if 0
//##########################################################
//        �����X�g���[���Ăяo��
//##########################################################
static std::stack<CCaller*> g_stkStream;

//------------------------------------------------
// �����X�g���[���Ăяo��::�J�n
//------------------------------------------------
void CallCmd::streamBegin()
{
	// �Ăяo���O�̏���
	g_stkStream.push( new CCaller() );
	CCaller* const pCaller = g_stkStream.top();

	// ���x���̐ݒ�
	if ( code_isNextArg() ) {
		CallCmd::streamLabel();
	}
	return;
}


//------------------------------------------------
// �����X�g���[���Ăяo��::���x���ݒ�
//------------------------------------------------
void CallCmd::streamLabel()
{
	if ( g_stkStream.empty() ) puterror( HSPERR_NO_DEFAULT );

	CCaller* const pCaller = g_stkStream.top();

	// �W�����v��̌���
	pCaller->setFunctor();
	return;
}


//------------------------------------------------
// �����X�g���[���Ăяo��::�ǉ�
//------------------------------------------------
void CallCmd::streamAdd()
{
	if ( g_stkStream.empty() ) puterror( HSPERR_NO_DEFAULT );

	CCaller* const pCaller = g_stkStream.top();

	// ������ǉ�����
	pCaller->setArgAll();

	return;
}


//------------------------------------------------
// �����X�g���[���Ăяo��::����
// 
// @ ���ߌ`���̏ꍇ�� ppResult == nullptr �B
//------------------------------------------------
int CallCmd::streamEnd(PDAT** ppResult)
{
	if ( g_stkStream.empty() ) puterror( HSPERR_NO_DEFAULT );

	CCaller* const pCaller = g_stkStream.top();

	// �Ăяo��
	pCaller->call();

	// �㏈��
	g_stkStream.pop();

	vartype_t const restype = pCaller->getCallResult( ppResult );

	delete pCaller;
	return restype;
}


//------------------------------------------------
// �X�g���[���Ăяo���I�u�W�F�N�g::����
//------------------------------------------------
int CallCmd::streamCallerNew( PDAT** ppResult )
{
	stream_t const stream = CStreamCaller::New();

	// ��������
	CCaller* const caller = stream->getCaller();
	{
		caller->setFunctor();
	}

	// functor �^�Ƃ��ĕԋp����
	return SetReffuncResult( ppResult, functor_t::make(stream) );
}


//------------------------------------------------
// �X�g���[���Ăяo���I�u�W�F�N�g::�ǉ�
//------------------------------------------------
void CallCmd::streamCallerAdd()
{
	functor_t&& functor = code_get_functor();
	stream_t const stream = functor->safeCastTo<stream_t>();

	stream->getCaller()->setArgAll();		// �S�Ă̈�����ǉ�����
	return;
}
#endif

//##########################################################
//    functor �^�֌W
//##########################################################
//------------------------------------------------
// functor
//------------------------------------------------
int FunctorCmd::functor(PDAT** ppResult, bool bSysvar)
{
	if ( ppResult && bSysvar ) {
		// �^�^�C�v�l

		return SetReffuncResult(ppResult, g_vtFunctor);

	} else if ( ppResult && !bSysvar ) {
		// �^�ϊ�

		int const chk = code_getprm();
		if ( chk <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);

		*ppResult = g_hvpFunctor->Cnv(mpval->pt, mpval->flag);
		assert(*ppResult == FunctorTraits::asPDAT(&g_resFunctor));
		return g_vtFunctor;

	} else {
		// �ϐ�������
		
		code_dimtypeEx(g_vtFunctor);
		return HSPVAR_FLAG_NONE;
	}
}

//------------------------------------------------
// ���������
//------------------------------------------------
namespace PrmInfoId
{
	static int const
		PrmTypeOf = 0,

		CntPrms = 2,	// �������牼�������X�g�S�̂Ɋւ�����
		CntLocals = 3,
		IsFlex = 4
	;
}

static int getPrmInfo(CPrmInfo const& prminfo, int id, int idxPrm)
{
	if ( id >= PrmInfoId::CntPrms
		&& !(0 <= idxPrm && static_cast<size_t>(idxPrm) < prminfo.cntPrms()) ) puterror(HSPERR_ILLEGAL_FUNCTION);
	switch ( id ) {
		case PrmInfoId::PrmTypeOf:  return prminfo.getPrmType(idxPrm);
		case PrmInfoId::CntPrms:    return static_cast<int>( prminfo.cntPrms() );
		case PrmInfoId::CntLocals:  return static_cast<int>( prminfo.cntLocals() );
		case PrmInfoId::IsFlex:     return HspBool(prminfo.isFlex());
		default: puterror(HSPERR_ILLEGAL_FUNCTION);
	}
}

int FunctorCmd::prminfo(PDAT** ppResult)
{
	functor_t&& f = code_get_functor();
	int const id = code_geti();
	int const idxPrm = code_getdi(-1);
	return SetReffuncResult( ppResult, getPrmInfo(f->getPrmInfo(), id, idxPrm) );
}

//##########################################################
//    ���̑�
//##########################################################
#if 0
//------------------------------------------------
// ��������
//------------------------------------------------
int CallCmd::argBind( PDAT** ppResult )
{
	bound_t const bound = CBound::New();

	// ��������
	CCaller* const caller = bound->getCaller();
	{
		caller->setFunctor();	// �X�N���v�g����푩���֐������o��
		caller->setArgAll();	// �X�N���v�g����^����ꂽ������S�Ď󂯎�� (�s�����������󂯕t����)
	}
	bound->bind();

	// functor �^�Ƃ��ĕԋp����
	return SetReffuncResult( ppResult, functor_t::make(bound) );
}

//------------------------------------------------
// ��������
//------------------------------------------------
int CallCmd::unBind( PDAT** ppResult )
{
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	if ( mpval->flag != g_vtFunctor ) puterror( HSPERR_TYPE_MISMATCH );

	auto const functor = FunctorTraits::derefValptr(mpval->pt);
	auto const bound   = functor->safeCastTo<bound_t>();

	return SetReffuncResult( ppResult, bound->unbind() );
}

//------------------------------------------------
// �����_��
// 
// @ funcexpr(args...) �� function() { lambdaBody args... : return }
//------------------------------------------------
int CallCmd::lambda( PDAT** ppResult )
{
	auto const lambda = CLambda::New();

	lambda->code_get();

	return SetReffuncResult( ppResult, functor_t::make(lambda) );
}

//------------------------------------------------
// lambda �������ŗp����R�}���h
// 
// @ LambdaBody:
// @	���������Ɏ��o���A���ꂼ��� local �ϐ��ɑ�����Ă����B
// @	�Ō�̈����͕Ԓl�Ƃ��Ď󂯎��B
// @	�䂦�ɁA���̖��߂̈����͕K�� (local �ϐ��̐� + 1) ���݂���B
// @ LambdaValue:
// @	idx �Ԗڂ� local �ϐ������o���B
//------------------------------------------------
void CallCmd::lambdaBody()
{
	auto& inv = Invoker::top();
	size_t const cntLocals = inv.getPrmInfo().cntLocals();

	for ( size_t i = 0; i < cntLocals; ++ i ) {
		int const chk = code_getprm();
		assert(chk > PARAM_END);
		PVal* const pvLocal = inv.getArgs().peekLocalAt(i);
		PVal_assign( pvLocal, mpval->pt, mpval->flag );
	}

	CallCmd::retval();
	return;
}

//------------------------------------------------
// �R���[�`��::����
//------------------------------------------------
int CallCmd::coCreate( PDAT** ppResult )
{
	auto coroutine = CCoRoutine::New();

	CCaller* const caller = coroutine->getCaller();
	caller->setFunctor();		// functor ���󂯂�
	caller->setArgAll();

	return SetReffuncResult( ppResult, functor_t::make(coroutine) );
}

//------------------------------------------------
// �R���[�`��::���f����
//------------------------------------------------
void CallCmd::coYieldImpl()
{
	CallCmd::retval();		// �Ԓl���󂯎��

	// newlab �����ϐ����R���[�`���ɓn��
	PVal* const pvNextLab = code_get_var();
	CCoRoutine::setNextVar( pvNextLab );	// static �ϐ��Ɋi�[����

	return;
}
#endif

//##########################################################
//        ��ʐ��̂���R�}���h
//##########################################################
//------------------------------------------------
// �R�}���h�𐔒l�����Ď擾����
//------------------------------------------------
int CallCmd::axcmdOf(PDAT** ppResult)
{
	int const axcmd = code_get_axcmd();
	if ( axcmd == 0 ) puterror(HSPERR_TYPE_MISMATCH);
	return SetReffuncResult(ppResult, axcmd);
}

//------------------------------------------------
// ���[�U��`���߁E�֐��Ȃǂ��烉�x�����擾����
//------------------------------------------------
static label_t code_labelOfImpl(int axcmd)
{
	if ( AxCmd::isOk(axcmd) ) {
		int const code = AxCmd::getCode(axcmd);
		switch ( AxCmd::getType(axcmd) ) {
			case TYPE_LABEL: return getLabel(code);
			case TYPE_MODCMD:
			{
				stdat_t const stdat = getSTRUCTDAT(code);
				if ( stdat->index == STRUCTDAT_INDEX_FUNC || stdat->index == STRUCTDAT_INDEX_CFUNC ) {
					return getLabel(stdat->otindex);
				}
			}
		}
	}
	puterror(HSPERR_ILLEGAL_FUNCTION);
}

static label_t code_labelOf()
{
	// ���[�U��`�R�}���h
	if ( *type == TYPE_MODCMD ) {
		return code_labelOfImpl(code_get_axcmd());

		// ���̑�
	} else {
		if ( code_getprm() <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);

		// axcmd
		if ( mpval->flag == HSPVAR_FLAG_INT ) {
			return code_labelOfImpl(VtTraits<int>::derefValptr(mpval->pt));

			// label
		} else if ( mpval->flag == HSPVAR_FLAG_LABEL ) {
			return VtTraits<label_t>::derefValptr(mpval->pt);

			// functor
		} else if ( mpval->flag == g_vtFunctor ) {
			return FunctorTraits::derefValptr(mpval->pt)->getLabel();
		}
		puterror(HSPERR_TYPE_MISMATCH);
	}
}

int CallCmd::labelOf(PDAT** ppResult)
{
	return SetReffuncResult(ppResult, code_labelOf());
}

//------------------------------------------------
// �R�}���h�̌Ăяo��
//------------------------------------------------
int CallCmd::forwardCmd_( PDAT** ppResult )
{
	int const id = code_geti();
	if ( !AxCmd::isOk(id) ) puterror(HSPERR_ILLEGAL_FUNCTION);

	if ( ppResult ) {
		// �֐����Ăяo�� (���̕Ԓl�����ꎩ�̂̕Ԓl�Ƃ���)
		{
			*type = AxCmd::getType(id);
			*val = AxCmd::getCode(id);
			*exinfo->npexflg = 0;

			if ( code_getprm() <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);
		}
		*ppResult = mpval->pt;
		return mpval->flag;

	} else {
		// �w�肵�����߃R�}���h�����邱�Ƃɂ��� (����ɂ��1�̃R�[�h�ׂ��̂ŁA�_�~�[��z�u���ׂ�)
		{
			*type = AxCmd::getType(id);
			*val = AxCmd::getCode(id);
			*exinfo->npexflg = EXFLG_1;
		}
		return HSPVAR_FLAG_NONE;
	}
}

//##########################################################
//    �e�X�g�R�[�h
//##########################################################
#ifdef _DEBUG

int CallCmd::test(PDAT** ppResult)
{
	//

	puterror(HSPERR_UNSUPPORTED_FUNCTION);

	if ( ppResult ) {

	} else {
		return HSPVAR_FLAG_NONE;
	}
}

#endif
