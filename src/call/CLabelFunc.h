// ���x���֐�

#ifndef IG_CLASS_LABEL_FUNC_H
#define IG_CLASS_LABEL_FUNC_H

#include "hsp3plugin_custom.h"

#include "axcmd.h"
#include "IFunctor.h"
#include "CCaller.h"
#include "CPrmStk.h"
#include "Invoker.h"

#include "cmd_sub.h"

using namespace hpimod;

class CLabelFunc
	: public IFunctor
{
	label_t lb_;

public:
	CLabelFunc(label_t lb) : lb_ { lb } {}

	// �擾
	label_t getLabel() const override { return lb_; }
	int getAxCmd() const override { return AxCmd::make(TYPE_LABEL, hpimod::getOTPtr(lb_)); }

	int getUsing() const override { return HspBool(lb_ != nullptr); }			// �g�p�� (0: ����, 1: �L��, 2: �N���[��)
	CPrmInfo const& getPrmInfo() const override {
		return GetPrmInfo(lb_);
	}

	// ����
	void invoke(Invoker& inv) override
	{
		auto const prmstk_bak = ctx->prmstack;
		auto const prmstk = const_cast<void*>(inv.getArgs().getPrmStkPtr());
		ctx->prmstack = prmstk;

		code_call(getLabel());

		// return ����Ԓl���󂯎�� (��⍕���p�H)
		if ( ctx->retval_level == (ctx->sublev + 1) ) {
			inv.setResult(*exinfo->mpval);
			ctx->retval_level = 0;
		}

		assert(ctx->prmstack == prmstk);
		ctx->prmstack = prmstk_bak;
		return;
	}
};

#endif
