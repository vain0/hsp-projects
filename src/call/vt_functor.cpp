// vartype - functor

#include "vt_functor.h"
#include "cmd_call.h"
#include "cmd_sub.h"
#include "iface_call.h"

#include "Invoker.h"
#include "CCaller.h"
#include "CBound.h"
#include "axcmd.h"

#include "hsp3plugin_custom.h"
#include "mod_argGetter.h"

#include <new>

using namespace hpimod;

vartype_t g_vtFunctor;
HspVarProc* g_hvpFunctor;
functor_t g_resFunctor { nullptr };

static void invokeFunctor(functor_t f, PDAT** ppResult, int* mptype)
{
	Invoker inv { f };
	inv.code_get_arguments();
	inv.invoke();
	if ( ppResult ) {
		assert(mptype);
		PVal* const pval = inv.getResult();
		*ppResult = pval->pt; *mptype = pval->flag;
	}
	return;
}

//------------------------------------------------
// �g�p��(varuse)
//------------------------------------------------
static int HspVarFunctor_getUsing( PDAT const* pdat )
{
	functor_t const& functor = FunctorTraits::derefValptr(pdat);
	return functor->getUsing();
}

//------------------------------------------------
// PVal�̕ϐ����������m�ۂ���
// 
// @ pval �͖��m�� or ����ς݁B
// @ pval2 != NULL => pval2 ���p���B
// @ �z��͈ꎟ���̂݁B
//------------------------------------------------
static void HspVarFunctor_alloc(PVal* pval, PVal const* pval2)
{
	if ( pval->len[1] < 1 ) pval->len[1] = 1;		// �z����Œ� 1 �͊m�ۂ���
	if ( pval->len[2] != 0 ) puterror(HSPERR_ARRAY_OVERFLOW);

	size_t const cntElems = pval->len[1];
	size_t const size     = cntElems * FunctorTraits::basesize;
	
	functor_t* const pt = (functor_t*)hspmalloc( size );
	size_t offset = 0;

	// �p��
	if ( pval2 ) {
		offset = ( static_cast<size_t>(pval2->size) / sizeof(functor_t) );
		std::memcpy( pt, pval2->pt, pval2->size );		// �����Ă����f�[�^���R�s�[
		hspfree( pval2->pt );							// ���̃o�b�t�@�����
	}

	// pt �̏����� (null ������)
	for ( size_t i = offset; i < cntElems; ++ i ) {
		functor_t const* const p = new( &pt[i] ) functor_t;
	}

	pval->flag   = g_vtFunctor;
	pval->mode   = HSPVAR_MODE_MALLOC;
	pval->size   = size;
	pval->pt     = FunctorTraits::asPDAT(pt);
//	pval->master = nullptr;
	return;
}

//------------------------------------------------
// PVal�̕ϐ����������������
//------------------------------------------------
static void HspVarFunctor_free(PVal* pval)
{
	if ( pval->mode == HSPVAR_MODE_MALLOC ) {
		// �f�X�g���N�^�N��
		auto const pt = FunctorTraits::asValptr(pval->pt);
		for ( int i = 0; i < pval->len[1]; ++ i ) {
			pt[i].~Managed();
		}
		hspfree( pval->pt );
	}

	pval->mode = HSPVAR_MODE_NONE;
	pval->pt   = nullptr;
	return;
}

//------------------------------------------------
// �^�ϊ�����
// 
// @ �� -> functor
// @ g_resFunctor �� SetReffuncResult �Ƌ��p�B
//------------------------------------------------
static PDAT* HspVarFunctor_cnv(PDAT const* pdat, int flag)
{
	static functor_t& stt_cnv = g_resFunctor;

	switch ( flag ) {
		case HSPVAR_FLAG_LABEL:
			stt_cnv = Functor::New(VtTraits<label_t>::derefValptr(pdat));
			break;

		case HSPVAR_FLAG_INT:
		{
			stt_cnv = Functor::New(VtTraits<int>::derefValptr(pdat));
			break;
		}
		default:
			if ( flag == g_vtFunctor ) {
				stt_cnv = FunctorTraits::derefValptr(pdat);

			} else {
				puterror( HSPERR_TYPE_MISMATCH );
			}
			break;
	}

	return FunctorTraits::asPDAT(&stt_cnv);
}

//------------------------------------------------
// �^�ϊ�����
// 
// @ functor -> ��
//------------------------------------------------
static PDAT* HspVarFunctor_cnvCustom(PDAT const* pdat, int flag)
{
	auto const& functor = FunctorTraits::derefValptr(pdat);
	PDAT* pResult = nullptr;

	switch ( flag ) {
		case HSPVAR_FLAG_LABEL:
		{
			static label_t stt_label;

			stt_label = functor->getLabel();
			if ( stt_label ) pResult = VtTraits<label_t>::asPDAT(&stt_label);
			break;
		}
		case HSPVAR_FLAG_INT:
		{
			static int stt_int;

			stt_int = functor->getAxCmd();
			if ( AxCmd::isOk(stt_int) ) pResult = VtTraits<int>::asPDAT(&stt_int);
			break;
		}

		default:
			if ( flag == g_vtFunctor ) {
				pResult = const_cast<PDAT*>(pdat);
			}
			break;
	}

	functor.beNonTmpObj();	// �X�^�b�N����~���

	if ( pResult ) {
		return pResult;
	} else {
		puterror(HSPERR_TYPE_MISMATCH);
	}
}

//------------------------------------------------
// �A�z�z�� : �Q�� (�E)
// 
// @ �P�� => �֐��`���Ăяo��
// @ �z�� => �v�f�擾
//------------------------------------------------
static PDAT* HspVarFunctor_arrayObjectRead( PVal* pval, int* mptype )
{
	// �z�� => �Y���ɑΉ�����v�f�� functor �l�����o��
	if ( pval->len[1] > 1 ) {
		int const idx = code_geti();
		code_index_int_rhs( pval, idx );

		*mptype = g_vtFunctor;
		return FunctorTraits::asPDAT(FunctorTraits::getValptr( pval ));
	}

	// �Ăяo��
	auto const pf = FunctorTraits::getValptr( pval );
	functor_t functor = *pf;

	// ��Ăяo���Y�� (�o�O�ւ̑΍�)
	if ( *type == g_pluginType_call && *val == CallCmd::Id::noCall ) {
		code_get_singleToken();
		*mptype = g_vtFunctor;
		return FunctorTraits::asPDAT(pf);
	}

	if ( functor->getUsing() == 0 ) {
		puterror(HSPERR_ILLEGAL_FUNCTION);	// �p�����[�^�̒l���ُ�
	}

	// �Ăяo��
	PDAT* pResult = nullptr;
	invokeFunctor(functor, &pResult, mptype);
	assert(pResult);
	return pResult;
}

//------------------------------------------------
// �A�z�z�� : �Q�� (��)
//------------------------------------------------
static void HspVarFunctor_arrayObject( PVal* pval )
{
	int const idx = code_geti();
	code_index_int_lhs( pval, idx );
	return;
}

/*
//------------------------------------------------
// �i�[����
//------------------------------------------------
static void HspVarFunctor_objectWrite( PVal* pval, void* data, int vtype )
{
	functor_t& functor = *FunctorTraits::getValptr( pval );
	functor = FunctorTraits::derefValptr(HspVarFunctor_cnv(data, vtype));

	// �A�����
	code_assign_multi( pval );
	return;
}
//*/

//------------------------------------------------
// ���\�b�h����
//------------------------------------------------
static void HspVarFunctor_method(PVal* pval)
{
	char const* const psMethod = code_gets();

	if ( !strcmp(psMethod, "call") ) {
		invokeFunctor( *FunctorTraits::getValptr(pval), nullptr, nullptr );

	} else {
		puterror( HSPERR_ILLEGAL_FUNCTION );
	}
	return;
}

//------------------------------------------------
// ����֐�
//------------------------------------------------
static void  HspVarFunctor_set(PVal* pval, PDAT* pdat, PDAT const* in)
{
	auto& lhs = FunctorTraits::derefValptr(pdat);
	auto& rhs = FunctorTraits::derefValptr(in);

	lhs = rhs;
	return;
}

//------------------------------------------------
// ��r�֐�
//------------------------------------------------
//static
int HspVarFunctor_CmpI(PDAT* pdat, PDAT const* val)
{
	auto& lhs = FunctorTraits::derefValptr(pdat);
	auto& rhs = FunctorTraits::derefValptr(val);

	int const cmp = HspBool( lhs != rhs );

	g_hvpFunctor->aftertype = HSPVAR_FLAG_INT;
	return cmp;
}

//------------------------------------------------
// HspVarProc�������֐�
//------------------------------------------------
void HspVarFunctor_init(HspVarProc* p)
{
	g_vtFunctor = p->flag;
	g_hvpFunctor = p;

	p->GetPtr       = HspVarTemplate_GetPtr<functor_tag>;
	p->GetSize      = HspVarTemplate_GetSize<functor_tag>;
	p->GetUsing     = HspVarFunctor_getUsing;

	p->GetBlockSize = HspVarTemplate_GetBlockSize<functor_tag>;
	p->AllocBlock   = HspVarTemplate_AllocBlock<functor_tag>;

	p->Cnv          = HspVarFunctor_cnv;
	p->CnvCustom    = HspVarFunctor_cnvCustom;

	p->Alloc        = HspVarFunctor_alloc;
	p->Free         = HspVarFunctor_free;

	p->ArrayObjectRead = HspVarFunctor_arrayObjectRead;
	p->ArrayObject  = HspVarFunctor_arrayObject;
//	p->ObjectWrite  = HspVarFunctor_objectWrite;
	p->ObjectMethod = HspVarFunctor_method;

	p->Set          = HspVarFunctor_set;

//	p->AddI         = HspVarFunctor_addI;
//	p->SubI         = HspVarFunctor_subI;
//	p->MulI         = HspVarFunctor_mulI;
//	p->DivI         = HspVarFunctor_divI;
//	p->ModI         = HspVarFunctor_modI;

//	p->AndI         = HspVarFunctor_andI;
//	p->OrI          = HspVarFunctor_orI;
//	p->XorI         = HspVarFunctor_xorI;

	HspVarTemplate_InitCmpI_Equality< HspVarFunctor_CmpI >(p);

//	p->RrI          = HspVarFunctor_rrI;
//	p->LrI          = HspVarFunctor_lrI;

	p->vartype_name	= "functor_k";			// �^��
	p->version      = 0x001;				// VarType RuntimeVersion(0x100 = 1.0)
	p->support      = HSPVAR_SUPPORT_STORAGE
					| HSPVAR_SUPPORT_FLEXARRAY
					| HSPVAR_SUPPORT_ARRAYOBJ
					//| HSPVAR_SUPPORT_NOCONVERT
	                | HSPVAR_SUPPORT_VARUSE
					;						// �T�|�[�g�󋵃t���O(HSPVAR_SUPPORT_*)
	p->basesize = FunctorTraits::basesize;	// 1�̃f�[�^��bytes / �ϒ��̎���-1
	return;
}

//##############################################################################
//                �������֐�
//##############################################################################
//------------------------------------------------
// �֐��q���擾����
//------------------------------------------------
functor_t code_get_functor()
{
	{
		int const chk = code_getprm();
		if ( chk <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);
	}

	// label
	if ( mpval->flag == HSPVAR_FLAG_LABEL ) {
		return Functor::New(VtTraits<label_t>::derefValptr(mpval->pt));

	// deffid
	} else if ( mpval->flag == HSPVAR_FLAG_INT ) {
		int const axcmd = *reinterpret_cast<int*>(mpval->pt);

		if ( AxCmd::getType(axcmd) != TYPE_MODCMD ) puterror(HSPERR_ILLEGAL_FUNCTION);

		return Functor::New(axcmd);

	// functor
	} else if ( mpval->flag == g_vtFunctor ) {
		return FunctorTraits::derefValptr(mpval->pt);

	} else {
		puterror(HSPERR_LABEL_REQUIRED);
	}
}

//-----------------------------------------------
// �֐��R�}���h�̐ݒ肷��
//------------------------------------------------
int SetReffuncResult(PDAT** ppResult, functor_t const& src)
{
	g_resFunctor = src;
	*ppResult = FunctorTraits::asPDAT(&g_resFunctor);
	return g_vtFunctor;
}

int SetReffuncResult(PDAT** ppResult, functor_t&& src)
{
	g_resFunctor = std::move(src.beTmpObj());
	*ppResult = FunctorTraits::asPDAT(&g_resFunctor);
	return g_vtFunctor;
}
