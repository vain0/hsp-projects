﻿// vartype - functor

#include "vt_functor.h"
#include "cmd_call.h"
#include "cmd_sub.h"
#include "iface_call.h"

#include "Invoker.h"
#include "CBound.h"
#include "axcmd.h"

#include "hsp3plugin_custom.h"
#include "mod_argGetter.h"

#include <new>

using namespace hpimod;

vartype_t g_vtFunctor;
HspVarProc* g_hvpFunctor;
functor_t g_resFunctor { nullptr };

//------------------------------------------------
// 使用状況(varuse)
//------------------------------------------------
static int HspVarFunctor_getUsing( PDAT const* pdat )
{
	functor_t const& functor = VtTraits::derefValptr<vtFunctor>(pdat);
	return (!functor.isNull() ? functor->getUsing() : 0);
}

//------------------------------------------------
// f の呼び出し
//------------------------------------------------
static void callFunctor(functor_t f, PDAT** ppResult, int* mptype)
{
	assert(HspVarFunctor_getUsing(VtTraits::asPDAT<vtFunctor>(&f)));
	
	Caller caller { f };
	caller.code_get_arguments();
	caller.invoke();
	if ( ppResult ) {
		assert(mptype);
		PVal* const pval = caller.getResult();
		*ppResult = pval->pt; *mptype = pval->flag;
	}
	return;
}

//------------------------------------------------
// PValの変数メモリを確保する
// 
// @ pval は未確保 or 解放済み。
// @ pval2 != NULL => pval2 を継承。
// @ 配列は一次元のみ。
//------------------------------------------------
static void HspVarFunctor_alloc(PVal* pval, PVal const* pval2)
{
	if ( pval->len[1] < 1 ) pval->len[1] = 1;		// 配列を最低 1 は確保する
	if ( pval->len[2] != 0 ) puterror(HSPERR_ARRAY_OVERFLOW);

	size_t const cntElems = pval->len[1];
	size_t const size     = cntElems * VtTraits::basesize<vtFunctor>::value;
	
	functor_t* const pt = (functor_t*)hspmalloc( size );
	size_t offset = 0;

	// 継承
	if ( pval2 ) {
		offset = ( static_cast<size_t>(pval2->size) / sizeof(functor_t) );
		std::memcpy( pt, pval2->pt, pval2->size );		// 持っていたデータをコピー
		hspfree( pval2->pt );							// 元のバッファを解放
	}

	// pt の初期化 (null 初期化)
	for ( size_t i = offset; i < cntElems; ++ i ) {
		functor_t const* const p = new( &pt[i] ) functor_t;
	}

	pval->flag   = g_vtFunctor;
	pval->mode   = HSPVAR_MODE_MALLOC;
	pval->size   = size;
	pval->pt     = VtTraits::asPDAT<vtFunctor>(pt);
//	pval->master = nullptr;
	return;
}

//------------------------------------------------
// PValの変数メモリを解放する
//------------------------------------------------
static void HspVarFunctor_free(PVal* pval)
{
	if ( pval->mode == HSPVAR_MODE_MALLOC ) {
		// デストラクタ起動
		auto const pt = VtTraits::asValptr<vtFunctor>(pval->pt);
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
// 型変換処理
// 
// @ 他 -> functor
// @ g_resFunctor は SetReffuncResult と共用。
//------------------------------------------------
static PDAT* HspVarFunctor_cnv(PDAT const* pdat, int flag)
{
	static functor_t& stt_cnv = g_resFunctor;

	switch ( flag ) {
		case HSPVAR_FLAG_LABEL:
			stt_cnv = Functor::New(VtTraits::derefValptr<vtLabel>(pdat));
			break;

		case HSPVAR_FLAG_INT:
		{
			stt_cnv = Functor::New(VtTraits::derefValptr<vtInt>(pdat));
			break;
		}
		default:
			if ( flag == g_vtFunctor ) {
				stt_cnv = VtTraits::derefValptr<vtFunctor>(pdat);

			} else {
				puterror( HSPERR_TYPE_MISMATCH );
			}
			break;
	}

	return VtTraits::asPDAT<vtFunctor>(&stt_cnv);
}

//------------------------------------------------
// 型変換処理
// 
// @ functor -> 他
//------------------------------------------------
static PDAT* HspVarFunctor_cnvCustom(PDAT const* pdat, int flag)
{
	auto const& functor = VtTraits::derefValptr<vtFunctor>(pdat);
	PDAT* pResult = nullptr;

	switch ( flag ) {
		case HSPVAR_FLAG_LABEL:
		{
			static label_t stt_label;

			stt_label = functor->getLabel();
			if ( stt_label ) pResult = VtTraits::asPDAT<vtLabel>(&stt_label);
			break;
		}
		case HSPVAR_FLAG_INT:
		{
			static int stt_int;

			stt_int = functor->getAxCmd();
			if ( AxCmd::isOk(stt_int) ) pResult = VtTraits::asPDAT<vtInt>(&stt_int);
			break;
		}

		default:
			if ( flag == g_vtFunctor ) {
				pResult = const_cast<PDAT*>(pdat);
			}
			break;
	}

	functor.beNonTmpObj();	// スタックから降りる

	if ( pResult ) {
		return pResult;
	} else {
		puterror(HSPERR_TYPE_MISMATCH);
	}
}

//------------------------------------------------
// 連想配列 : 参照 (右)
// 
// @ 単体 => 関数形式呼び出し
// @ 配列 => 要素取得
//------------------------------------------------
static PDAT* HspVarFunctor_arrayObjectRead( PVal* pval, int* mptype )
{
	// 配列 => 添字に対応する要素の functor 値を取り出す
	if ( pval->len[1] > 1 ) {
		int const idx = code_geti();
		code_index_int_rhs( pval, idx );

		*mptype = g_vtFunctor;
		return VtTraits::asPDAT<vtFunctor>(VtTraits::getValptr<vtFunctor>( pval ));
	}

	// 呼び出し
	auto const pf = VtTraits::getValptr<vtFunctor>( pval );
	functor_t functor = *pf;

	// 非呼び出し添字 (バグへの対策)
	if ( *type == g_pluginType_call && *val == CallCmd::Id::noCall ) {
		code_get_singleToken();
		*mptype = g_vtFunctor;
		return VtTraits::asPDAT<vtFunctor>(pf);
	}

	if ( functor->getUsing() == 0 ) {
		puterror(HSPERR_ILLEGAL_FUNCTION);	// パラメータの値が異常
	}

	// 呼び出し
	PDAT* pResult = nullptr;
	callFunctor(functor, &pResult, mptype);
	assert(pResult);
	return pResult;
}

//------------------------------------------------
// 連想配列 : 参照 (左)
//------------------------------------------------
static void HspVarFunctor_arrayObject( PVal* pval )
{
	int const idx = code_geti();
	code_index_int_lhs( pval, idx );
	return;
}

/*
//------------------------------------------------
// 格納処理
//------------------------------------------------
static void HspVarFunctor_objectWrite( PVal* pval, void* data, int vtype )
{
	functor_t& functor = *VtTraits::getValptr<vtFunctor>( pval );
	functor = VtTraits::derefValptr<vtFunctor>(HspVarFunctor_cnv(data, vtype));

	// 連続代入
	code_assign_multi( pval );
	return;
}
//*/

//------------------------------------------------
// メソッド処理
//------------------------------------------------
static void HspVarFunctor_method(PVal* pval)
{
	char const* const psMethod = code_gets();

	if ( !strcmp(psMethod, "call") ) {
		callFunctor( *VtTraits::getValptr<vtFunctor>(pval), nullptr, nullptr );

	} else {
		puterror( HSPERR_ILLEGAL_FUNCTION );
	}
	return;
}

//------------------------------------------------
// 代入関数
//------------------------------------------------
static void  HspVarFunctor_set(PVal* pval, PDAT* pdat, PDAT const* in)
{
	auto& lhs = VtTraits::derefValptr<vtFunctor>(pdat);
	auto& rhs = VtTraits::derefValptr<vtFunctor>(in);

	lhs = rhs;
	return;
}

//------------------------------------------------
// 比較関数
//------------------------------------------------
//static
int HspVarFunctor_CmpI(PDAT* pdat, PDAT const* val)
{
	auto& lhs = VtTraits::derefValptr<vtFunctor>(pdat);
	auto& rhs = VtTraits::derefValptr<vtFunctor>(val);

	int const cmp = HspBool( lhs != rhs );

	g_hvpFunctor->aftertype = HSPVAR_FLAG_INT;
	return cmp;
}

//------------------------------------------------
// HspVarProc初期化関数
//------------------------------------------------
void HspVarFunctor_init(HspVarProc* p)
{
	g_vtFunctor = p->flag;
	g_hvpFunctor = p;

	p->GetUsing     = HspVarFunctor_getUsing;
	p->GetPtr       = HspVarTemplate_GetPtr<vtFunctor>;
	p->GetSize      = HspVarTemplate_GetSize<vtFunctor>;
	p->GetBlockSize = HspVarTemplate_GetBlockSize<vtFunctor>;
	p->AllocBlock   = HspVarTemplate_AllocBlock<vtFunctor>;

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

	p->vartype_name	= "functor_k";			// 型名
	p->version      = 0x001;				// VarType RuntimeVersion(0x100 = 1.0)
	p->support      = HSPVAR_SUPPORT_STORAGE
					| HSPVAR_SUPPORT_FLEXARRAY
					| HSPVAR_SUPPORT_ARRAYOBJ
					//| HSPVAR_SUPPORT_NOCONVERT
	                | HSPVAR_SUPPORT_VARUSE
					;						// サポート状況フラグ(HSPVAR_SUPPORT_*)
	p->basesize = VtTraits::basesize<vtFunctor>::value;	// 1つのデータのbytes / 可変長の時は-1
	return;
}

//##############################################################################
//                下請け関数
//##############################################################################
//------------------------------------------------
// 関数子を取得する
//------------------------------------------------
functor_t code_get_functor()
{
	{
		int const chk = code_getprm();
		if ( chk <= PARAM_END ) puterror(HSPERR_NO_DEFAULT);
	}

	// label
	if ( mpval->flag == HSPVAR_FLAG_LABEL ) {
		return Functor::New(VtTraits::derefValptr<vtLabel>(mpval->pt));

	// axcmd
	} else if ( mpval->flag == HSPVAR_FLAG_INT ) {
		int const axcmd = VtTraits::derefValptr<vtInt>(mpval->pt);

		if ( AxCmd::getType(axcmd) != TYPE_MODCMD ) puterror(HSPERR_ILLEGAL_FUNCTION);

		return Functor::New(axcmd);

	// functor
	} else if ( mpval->flag == g_vtFunctor ) {
		return VtTraits::derefValptr<vtFunctor>(mpval->pt);

	} else {
		puterror(HSPERR_LABEL_REQUIRED);
	}
}

//-----------------------------------------------
// 関数コマンドの設定する
//------------------------------------------------
int SetReffuncResult(PDAT** ppResult, functor_t&& src)
{
	g_resFunctor = std::move(src.beTmpObj());
	*ppResult = VtTraits::asPDAT<vtFunctor>(&g_resFunctor);
	return g_vtFunctor;
}
