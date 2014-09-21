// Call(Method) - Command
#if 0
#include <vector>
#include <map>
#include <string>

#include "cmd_method.h"
#include "cmd_sub.h"

#include "CCaller.h"
#include "CCall.h"
#include "CPrmInfo.h"

using methods_t = std::map<std::string, functor_t>;
static std::map<vartype_t, methods_t> g_distribute;

static void ObjectMethodCustom(PVal* pval);

//------------------------------------------------
// ���\�b�h�Ăяo���֐��̂���ւ�
// 
// @prm p1 = vt : �^�^�C�v�l
//------------------------------------------------
static void replaceProc(vartype_t vtype)
{
	HspVarProc* const vp = getHvp( vtype );

	// �����o�̎��֐��|�C���^������������
	vp->ObjectMethod = ObjectMethodCustom;

	// ��̃��\�b�h�N���X�����A�o�^���Ă���
	auto const iter = g_distribute.find(vtype);
	if ( iter == g_distribute.end() ) {
		g_distribute.insert({ vtype, methods_t {} });

	} else {
		dbgout("�^ %s �̃��\�b�h�͊��ɂ���ւ����Ă���B", vp->vartype_name);
		puterror(HSPERR_ILLEGAL_FUNCTION);
	}
	return;
}

void Method::replace()
{
	int const vt = code_get_vartype();
	replaceProc(vt);
	return;
}

//------------------------------------------------
// ���\�b�h�̒ǉ�
// 
// @prm p1 = vt  : �^�^�C�v�l
// @prm p2 = str : ���\�b�h���� (or default)
// @prm p3 = def : ��` (���x�� + ���������X�g, axcmd)
//------------------------------------------------
void Method::add()
{
	vartype_t const vtype = code_get_vartype();
	std::string const name = code_gets();

	// �Ăяo���� or ���x���֐��錾�̎擾
	functor_t&& functor = code_get_functor();

	// ���x�� => ���������X�g���󂯎��
	if ( functor.getType() == FuncType_Label ) {
		CPrmInfo::prmlist_t&& prmlist = code_get_prmlist();
		prmlist.insert( prmlist.begin(), PrmType::Var );		// �擪�� var this ��ǉ�
		DeclarePrmInfo( functor.getLabel(), std::move(CPrmInfo(&prmlist)) );
	}

	// CMethod �ɒǉ�
	auto const iter = g_distribute.find(vtype);
	if ( iter != g_distribute.end() ) {
		auto& methods = iter->second;

		methods.insert({ name, functor });

	} else {
		dbgout("Method::replace ����Ă��܂���I");
		puterror(HSPERR_UNSUPPORTED_FUNCTION);
	}
	return;
}

//------------------------------------------------
// ���\�b�h�Ăяo�����̕ϐ��̃N���[�������
//------------------------------------------------
void Method::cloneThis()
{
	CCall* const pCall     = TopCallStack();
	PVal*  const pvalClone = code_getpval();

	PVal_clone( pvalClone, pCall->getArgPVal(0), pCall->getArgAptr(0) );
	return;
}

//##############################################################################
//                method ������
//##############################################################################
//------------------------------------------------
// ���\�b�h�Ăяo���֐� ( method.hpi �� )
//------------------------------------------------
static void ObjectMethodCustom(PVal* pval)
{
	vartype_t const vtype = pval->flag;
	std::string const name = code_gets();

	auto const iter = g_distribute.find(vtype);
	if ( iter == g_distribute.end() ) {
		auto& methods = iter->second;
		
		auto const iter = methods.find(name);
		if ( iter != methods.end() ) {
			auto& functor = iter->second;

			dbgout("������");
#if 0
			// �Ăяo��
			{
				CCaller caller;
				caller.setFunctor(functor);

				// this ������ǉ�����
				caller.addArgByRef(pvThis, pvThis->offset);

				caller.setArgAll();
				caller.call();
			}
#endif
		} else {
			puterror(HSPERR_UNSUPPORTED_FUNCTION);
		}

	} else {
		// Method::replace ���Ă��Ȃ��^�̃��\�b�h
		puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}
	return;
}
#endif
