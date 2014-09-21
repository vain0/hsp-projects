// call - SubCommand

#include <stack>
#include <map>

#include "hsp3plugin_custom.h"
#include "mod_varutil.h"
#include "mod_argGetter.h"

#include "cmd_sub.h"

#include "CCaller.h"
#include "CCall.h"
#include "CPrmInfo.h"
#include "Functor.h"

#include "CBound.h"

#include "vt_functor.h"

using namespace hpimod;

//##########################################################
//       ���������X�g
//##########################################################
// �������錾�f�[�^
static std::map<label_t, CPrmInfo> g_prmlistLabel;

//------------------------------------------------
// ���������X�g�̐錾
//------------------------------------------------
CPrmInfo const& DeclarePrmInfo(label_t lb, CPrmInfo&& prminfo)
{
	if ( &GetPrmInfo(lb) != &CPrmInfo::undeclaredFunc ) {
		dbgout("���d��`�ł��B");
		puterror(HSPERR_ILLEGAL_FUNCTION);
	}
	return g_prmlistLabel.insert({ lb, std::move(prminfo) }).first->second;
}

//------------------------------------------------
// �������̎擾 (���x��)
//------------------------------------------------
CPrmInfo const& GetPrmInfo(label_t lb)
{
	auto const iter = g_prmlistLabel.find(lb);
	return (iter != g_prmlistLabel.end())
		? iter->second
		: CPrmInfo::undeclaredFunc;
}

CPrmInfo const& GetPrmInfo(stdat_t stdat)
{
	assert(stdat->index == STRUCTDAT_INDEX_FUNC || stdat->index == STRUCTDAT_INDEX_CFUNC);
	auto const lb = hpimod::getLabel(stdat->otindex);

	auto const iter = g_prmlistLabel.find(lb);
	if ( iter != g_prmlistLabel.end() ) {
		return iter->second;
	} else {
		return DeclarePrmInfo(lb, CPrmInfo::Create(stdat));
	}
}

#if 0
//------------------------------------------------
// CPrmInfo <- ���ԃR�[�h
// 
// @prm: [ label, (prmlist) ]
//------------------------------------------------
CPrmInfo const& code_get_prminfo()
{
	{
		int const chk = code_getprm();
		if ( chk <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);
	}

	// label
	if ( mpval->flag == HSPVAR_FLAG_LABEL ) {
		auto const lb = VtTraits<label_t>::derefValptr(mpval->pt);
		CPrmInfo::prmlist_t&& prmlist = code_get_prmlist();
		return CPrmInfo(&prmlist);

	// axcmd
	} else if ( mpval->flag == HSPVAR_FLAG_INT ) {
		int const axcmd = VtTraits<int>::derefValptr(mpval->pt);

		if ( AxCmd::getType(axcmd) != TYPE_MODCMD ) puterror(HSPERR_ILLEGAL_FUNCTION);
		return GetPrmInfo(getSTRUCTDAT(AxCmd::getCode(axcmd)));

	// functor
	} else if ( mpval->flag == g_vtFunctor ) {
		return FunctorTraits::derefValptr(mpval->pt)->getPrmInfo();

	} else {
		puterror(HSPERR_LABEL_REQUIRED);
	}
}
#endif

//------------------------------------------------
// ����������擾����
//------------------------------------------------
CPrmInfo::prmlist_t code_get_prmlist()
{
	CPrmInfo::prmlist_t prmlist;

	// ���������X�g
	while ( code_isNextArg() ) {
		auto const prmtype = code_get_prmtype(PrmType::None);
		if ( prmtype == PrmType::None ) puterror(HSPERR_ILLEGAL_FUNCTION);

		prmlist.push_back(prmtype);
	}

	return std::move(prmlist);
}
