// vartype - functor

#ifndef IG_VARTYPE_FUNCTOR_H
#define IG_VARTYPE_FUNCTOR_H

#include "hsp3plugin_custom.h"
#include "reffuncResult.h"

#include "vp_template.h"
#include "../var_vector/vt_vector.h"

#include "Functor.h"

// 変数
extern vartype_t g_vtFunctor;
extern HspVarProc* g_hvpFunctor;

// 関数
extern void HspVarFunctor_init(HspVarProc* vp);

// vartype tag
struct functor_tag
	: public NativeVartypeTag<functor_t>
{
	static vartype_t vartype() { return g_vtFunctor; }
};

// VtTraits<> の特殊化
namespace hpimod
{
	template<> struct VtTraits<functor_tag> : public VtTraitsBase<functor_tag>
	{
		static vartype_t vartype() { return g_vtFunctor; }
	};
}

using FunctorTraits = hpimod::VtTraits<functor_tag>;

// 返値設定関数
extern functor_t g_resFunctor;
extern int SetReffuncResult(PDAT** ppResult, functor_t const& src);
extern int SetReffuncResult(PDAT** ppResult, functor_t&& src);

// その他
extern vector_t code_get_vectorFromSequence();		// Invoker.cpp
extern functor_t code_get_functor();

#endif
