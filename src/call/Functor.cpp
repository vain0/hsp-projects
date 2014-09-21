
#include <map>
#include "Functor.h"
#include "CLabelFunc.h"

namespace Functor
{

// �L���b�V��
static std::map<label_t, functor_t> stt_functorCache;

//------------------------------------------------
// �L���b�V������� functor �̐���
//------------------------------------------------
functor_t const& New(label_t lb)
{
	auto const iter = stt_functorCache.find(lb);
	if ( iter != stt_functorCache.end() ) {
		return iter->second;

	} else {
		functor_t&& f = functor_t::makeDerived<CLabelFunc>(lb);
		return stt_functorCache.insert({ lb, std::move(f) }).first->second;
	}
}

functor_t const& New(int axcmd)
{
	assert(AxCmd::isOk(axcmd));

	switch ( AxCmd::getType(axcmd) ) {
		case TYPE_LABEL: return New(hpimod::getLabel(AxCmd::getCode(axcmd)));
		case TYPE_MODCMD:
		{
			auto const stdat = hpimod::getSTRUCTDAT(AxCmd::getCode(axcmd));
			if ( stdat->index == STRUCTDAT_INDEX_FUNC || stdat->index == STRUCTDAT_INDEX_CFUNC ) {
				// ���������X�g���L���b�V�������Ă���
				static_cast<void>(GetPrmInfo(stdat));

				return New(hpimod::getLabel(stdat->otindex));
			}
			break;
		}
	}
	dbgout("axcmd ���� functor �̐����Ɏ��s�����B(%d, %d)", AxCmd::getType(axcmd), AxCmd::getCode(axcmd));
	puterror(HSPERR_UNSUPPORTED_FUNCTION);
}

//------------------------------------------------
//------------------------------------------------

//------------------------------------------------
//------------------------------------------------
void Terminate()
{
	stt_functorCache.clear();
}

} // namespace Functor
