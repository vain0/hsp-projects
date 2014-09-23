﻿// vector - VarProc code

#include <functional>

#include "vt_vector.h"
#include "sub_vector.h"

#include "mod_makepval.h"
#include "mod_argGetter.h"

#include "for_knowbug.var_vector.h"

using namespace hpimod;

vartype_t g_vtVector;
HspVarProc* g_pHvpVector;

static void HspVarVector_AddI(PDAT* pdat, void const* src);
static PVal** HspVarVector_GetVectorList( PDAT const* src, int* );	// void* user

//------------------------------------------------
// 実体ポインタ
//------------------------------------------------
static PDAT* HspVarVector_GetPtr(PVal* pval)
{
	return pval->pt;
}

//------------------------------------------------
// Using
//------------------------------------------------
static int HspVarVector_GetUsing(PDAT const* pdat)
{
	return HspBool(!VtTraits::derefValptr<vtVector>(pdat).isNull());
}

//------------------------------------------------
// PValの変数メモリを確保する
//
// @ pval は未確保 or 解放済みの状態。
// @ pval2 != nullptr => pval2の内容を継承する。
//------------------------------------------------
static void HspVarVector_Alloc(PVal* pval, PVal const* pval2)
{
	assert(pval);
	size_t const cntElems = std::max(0, pval->len[1]);
	pval->len[1] = 1;

	//dbgout("pval = %08X, pval2 = %08X, pval->pt = %08X, cntElems = %d", pval, pval2, pval->pt, cntElems );

	// 継承
	// len[1] = 1 なので何度も呼ばれてしまう
	if ( pval2 ) {
		assert(pval == pval2);
		auto& vec = VtTraits::derefValptr<vtVector>(pval2->pt);
		
		if ( vec->size() < cntElems ) {
			vec->resize(cntElems);
		}

	} else {
		// pval->master が実体になる
		auto const p = &VtTraits::getMaster<vtVector>(pval);

		// mpval なら inst = nullptr で初期化
		if ( pval->support & HSPVAR_SUPPORT_TEMPVAR ) {
			new(p) vector_t { nullptr };

		// 長さ cntElems で初期化、各要素は既定値
		} else {
			new(p) vector_t { vector_t::make(cntElems) };
		}

		pval->flag = g_vtVector;
		pval->mode = HSPVAR_MODE_MALLOC;
		pval->size = VtTraits::basesize<vtVector>::value;
		pval->pt  = VtTraits::asPDAT<vtVector>(p);
	}
	return;
}

//------------------------------------------------
// PVALポインタの変数メモリを解放する
//------------------------------------------------
static void HspVarVector_Free(PVal* pval)
{
	if ( pval->mode == HSPVAR_MODE_MALLOC ) {
		VtTraits::derefValptr<vtVector>(pval->pt).~Managed();
	}

	pval->pt     = nullptr;
	pval->master = nullptr;
	pval->mode   = HSPVAR_MODE_NONE;
	return;
}

//------------------------------------------------
// 型変換：flag → this
// 
// @ 変換前の値を [0] に持つ vector を生成する。(おせっかいすぎるのでやめた)
//------------------------------------------------
#if 0
static void* HspVarVector_Cnv( const void *buffer, int flag )
{
	static CVector* result = nullptr;

	result = CVector::NewTemp();		// 一時オブジェクト

	result->Alloc( 1 );
	PVal_assign( result->at(0), (void*)buffer, flag );

	return &result;
}
#endif

//------------------------------------------------
// 型変換：this → flag
//------------------------------------------------
#if 0
static void* HspVarVector_CnvCustom( const void *buffer, int flag )
{
	CVector const* const self = (CVector const*)buffer;
	//...
	CVector::ReleaseIfTmpObj(pVec);
	return;
}
#endif

//------------------------------------------------
// 代入 (=)
//------------------------------------------------
static void HspVarVector_Set(PVal* pval, PDAT* pdat, PDAT const* in)
{
	if ( pval->offset != 0 ) puterror( HSPERR_ARRAY_OVERFLOW );

	auto& dst = VtTraits::derefValptr<vtVector>(pdat);
	auto& src = VtTraits::derefValptr<vtVector>(in);

	// テンポラリ変数 => 参照共有
	if ( pval->support & HSPVAR_SUPPORT_TEMPVAR ) {
		dst = src;

	// 右辺が一時オブジェクトなら move
	} else if ( src.isTmpObj() ) {
		dst = std::move(src);
		
	// すべての要素を共有する列にする
	} else {
		dst.reset();
		chainShallow(dst, src, { 0, src->size() });
	}
	
	// スタックを降りる
	src.beNonTmpObj();
	return;
}

//------------------------------------------------
// 連結 (Add)
//------------------------------------------------
void HspVarVector_AddI( PDAT* pdat, PDAT const* val )
{
	auto& lhs = VtTraits::derefValptr<vtVector>(pdat);
	auto  rhs = VtTraits::derefValptr<vtVector>(val);

	assert( !lhs.isNull() && !rhs.isNull() );

	auto const result = vector_t::make().beTmpObj();

	result->reserve(lhs->size() + rhs->size());
	result->insert(result->end(), lhs->begin(), lhs->end());
	result->insert(result->end(), rhs->begin(), rhs->end());

	lhs = std::move(result);	// 返値
	rhs.beNonTmpObj();			// スタックから降りる

	g_pHvpVector->aftertype = g_vtVector;
	return;
}

//------------------------------------------------
// 比較
// 
// @ 形式的に比較する。内部変数の個数と、それぞれの参照と、順番が全て等しければ、等しいとする。
// @ pdat は vector の PVal::pt なので、返値( true or false )を代入すると、
// @	左辺の参照が1つ勝手に消えることになる。そのため、左辺の参照を Release しておく。
//------------------------------------------------
static int Compare(vector_t const& lhs, vector_t const& rhs) 
{
	bool const bNullLhs = lhs.isNull();
	bool const bNullRhs = rhs.isNull();

	if ( bNullLhs ) {
		return (bNullRhs ? 0 : -1);
	} else if ( bNullRhs ) {
		return (bNullLhs ? 0 : 1);
	} else {
		size_t const lenLhs = lhs->size();
		size_t const lenRhs = rhs->size();

		if ( lenLhs != lenRhs ) return (lenLhs < lenRhs ? -1 : 1);

		for ( size_t i = 0; i < lenLhs; ++i ) {
			if ( lhs->at(i).getPVal() != rhs->at(i).getPVal() ) return -1;	// 違ったらとりあえず左のが小さいことにする
		}
		return 0;
	}
}

/*static*/ int HspVarVector_CmpI( PDAT* pdat, PDAT const* val )
{
	auto& lhs = VtTraits::derefValptr<vtVector>(pdat);
	auto& rhs = VtTraits::derefValptr<vtVector>(val);

	int const cmp = Compare( lhs, rhs );

	lhs.nullify();		// 破壊される
	rhs.beNonTmpObj();	// スタックから降りる

	g_pHvpVector->aftertype = HSPVAR_FLAG_INT;
	return cmp;
}

//------------------------------------------------
// メソッド呼び出し
//
// @ 内部変数へのメソッドとして扱う。
//------------------------------------------------
static void HspVarVector_ObjectMethod( PVal* pval )
{
	PVal* const pvInner = getInnerPVal(pval);
	if ( !pvInner ) puterror( HSPERR_UNSUPPORTED_FUNCTION );

	getHvp(pvInner->flag)->ObjectMethod( pvInner );
	return;
}

//#########################################################
//        連想配列用の関数群
//#########################################################
//------------------------------------------------
// 連想配列::添字処理
// 
// @ ( idx, inner-var's-idxes... )
// @ 内部変数の添字を処理する部分は、右辺値か左辺値かによって変わってくるため
// @	ここでは処理せず、呼び出し元に委ねる。
// @ *_ArrayObjectImpl で vector の分の添字(1つ目)を処理し、
// @	その後の内部変数の添字は、呼び出し元の *_ArrayObject, *_ArrayObjectRead に任せる。
//------------------------------------------------
// vector 自身への添字を受け取る
static int code_vectorIndex(vector_t const& self)
{
	int const idx = code_getdi(vtVector::IdxFullSlice);
	if ( idx < 0 ) {
		if ( idx == vtVector::IdxFullSlice ) {
			return -1;
		} else if ( idx == vtVector::IdxLast ) {
			if ( self->empty() ) puterror( HSPERR_ARRAY_OVERFLOW );
			return self->size() - 1;
		} else if ( idx == vtVector::IdxEnd ) {
			return self->size();
		} else {
			puterror( HSPERR_ARRAY_OVERFLOW ); throw;
		}
	} else {
		return idx;
	}
}

// 内部変数を取得
// getVar 関数が内部変数の添字状態は array->cnt による。
template<bool bAsLhs>
static PVal* HspVarVector_ArrayObjectImplInner(vector_t const& self, size_t idx)
{
	if ( self->size() <= idx ) {
		if ( bAsLhs ) {
			// 自動拡張
			self->resize(idx + 1);
		} else {
			puterror(HSPERR_ARRAY_OVERFLOW);
		}
	}
	return self->at(idx).getVar();
}

// vector の添字を処理し、その内部変数か nullptr(vector自体が参照される) を返却する
template<bool bAsLhs>
static PVal* HspVarVector_ArrayObjectImpl( PVal* pval )
{
	auto& vec = VtTraits::getMaster<vtVector>(pval);

	HspVarCoreReset( pval );
	int const idx = code_vectorIndex( vec );
	if ( idx < 0 ) {
		return nullptr;			// vector 自体へのポインタ

	} else {
		pval->offset   = idx;
		pval->arraycnt = 1;
		return HspVarVector_ArrayObjectImplInner<bAsLhs>( vec, static_cast<size_t>(idx) );
	}
}

//------------------------------------------------
// 連想配列::参照 (左)
//------------------------------------------------
void HspVarVector_ArrayObject( PVal* pval )
{
	PVal* const pvInner = HspVarVector_ArrayObjectImpl<true>( pval );

	if ( pvInner ) {
		if ( code_isNextArg() ) {
			if ( pvInner->arraycnt > 0 ) puterror(HSPERR_INVALID_ARRAY);
			code_expand_index_lhs(pvInner);
		}
		//else { code_index_reset(pvInner); }
	}
	return;
}

//------------------------------------------------
// 連想配列::参照 (右)
//------------------------------------------------
// 内部変数の添字の処理
static PDAT* HspVarVector_ArrayObjectReadImpl( PVal* pvInner, int* mptype )
{
	if ( code_isNextArg() ) {
		if ( pvInner->arraycnt > 0 ) puterror(HSPERR_INVALID_ARRAY);
		return code_expand_index_rhs( pvInner, *mptype );

	} else {
		//code_index_reset(pvInner);

		*mptype = pvInner->flag;
		return PVal_getPtr(pvInner);
	}
}

PDAT* HspVarVector_ArrayObjectRead( PVal* pval, int* mptype )
{
	PVal* const pvInner = HspVarVector_ArrayObjectImpl<false>( pval );

	if ( pvInner ) {
		return HspVarVector_ArrayObjectReadImpl(pvInner, mptype);

	// vector 自体の参照
	} else {
		*mptype = g_vtVector;
		return pval->pt;
	}
}

//------------------------------------------------
// 連想配列::参照 (右; from 関数)
//------------------------------------------------
PDAT* Vector_indexRhs( vector_t self, int* mptype )
{
	int const idx = code_vectorIndex( self );
	if ( idx < 0 ) {
		*mptype = g_vtVector;
		// vector 自体の参照のときは nullptr を返す。
		// pSelf はもしかしたら (C++の) ローカル変数を指しているかもしれないので注意を促したい。
		return nullptr;

	} else {
		PVal* const pvInner = HspVarVector_ArrayObjectImplInner<false>( self, static_cast<size_t>(idx) );
		return HspVarVector_ArrayObjectReadImpl( pvInner, mptype );
	}
}

//------------------------------------------------
// 連想配列::格納処理
//------------------------------------------------
static void HspVarVector_ObjectWrite( PVal* pval, PDAT const* data, int vflag )
{
	PVal* const pvInner = getInnerPVal(pval);

	DbgArea {
		auto& self = VtTraits::derefValptr<vtVector>(pval->pt);
	//	dbgout("ow pval=%p, data=%p, vflag=%d; len = %d, offset=%d", pval, data, vflag, self->size(), pval->offset);
	}

	// 参照なし (vector 自体への代入)
	if ( !pvInner ) {
		if ( vflag != g_vtVector ) puterror( HSPERR_INVALID_ARRAYSTORE );	// 右辺の型が不一致

		HspVarVector_Set( pval, VtTraits::asPDAT<vtVector>(&VtTraits::getMaster<vtVector>(pval)), data );

	// 内部変数を参照している場合
	} else {
	//	if ( code_isNextArg() && !(pvInner->support & HSPVAR_SUPPORT_ARRAYOBJ) && pvInner->flag != vflag ) {
	//		puterror( HSPERR_INVALID_ARRAYSTORE );	// 連続代入時は型変換不可
	//	}

		bool const bToVector = ( pvInner->arraycnt == 0 );		// (内部変数に添字がついていない)
		
		// 内部変数への代入処理へ移動 (ここで pvInner の添字状態が変化)
		PVal_assign( pvInner, data, vflag );

		// 連続代入
		if ( bToVector ) {
			auto& vec = VtTraits::getMaster<vtVector>(pval);
			while ( code_isNextArg() ) {
				int const chk = code_getprm();
				assert(chk != PARAM_END && chk != PARAM_ENDSPLIT);
				if ( chk == PARAM_DEFAULT ) continue;

				++pval->offset;
				// 自動拡張
				if ( static_cast<size_t>(pval->offset) >= vec->size() ) {
					vec->resize(pval->offset + 1);
				}
				HspVarVector_ObjectWrite(pval, mpval->pt, mpval->flag);
			}
		} else {
			code_assign_multi(pvInner);
		}
	}
	return;
}

//------------------------------------------------
// vector 登録関数
//------------------------------------------------
void HspVarVector_Init(HspVarProc* p)
{
	g_pHvpVector = p;
	g_vtVector = p->flag;

	// 関数ポインタを登録
	p->GetPtr       = HspVarVector_GetPtr;
	p->GetSize      = HspVarTemplate_GetSize<vtVector>;
	p->GetUsing     = HspVarVector_GetUsing;
	p->GetBlockSize = HspVarTemplate_GetBlockSize<vtVector>;
	p->AllocBlock   = HspVarTemplate_AllocBlock<vtVector>;

	p->Alloc = HspVarVector_Alloc;
	p->Free = HspVarVector_Free;

	//	p->Cnv          = HspVarVector_Cnv;
	//	p->CnvCustom    = HspVarVector_CnvCustom;

	// 演算関数
	p->Set = HspVarVector_Set;
	p->AddI = HspVarProcOperatorCast(HspVarVector_AddI);

	HspVarTemplate_InitCmpI_Full< HspVarVector_CmpI >(p);

	// 連想配列用
	p->ArrayObject     = HspVarVector_ArrayObject;		// 参照(左)
	p->ArrayObjectRead = HspVarVector_ArrayObjectRead;	// 参照(右)
	p->ObjectWrite     = HspVarVector_ObjectWrite;		// 格納処理
	p->ObjectMethod    = HspVarVector_ObjectMethod;		// メソッド処理

	// 拡張データ
	p->user = reinterpret_cast<char*>(HspVarVector_GetVectorList);

	// その他設定
	p->vartype_name = "vector_k";		// タイプ名
	p->version = 0x001;			// 型type runtime ver(0x100 = 1.0)

	p->support							// サポート状況フラグ(HSPVAR_SUPPORT_*)
		= HSPVAR_SUPPORT_STORAGE		// 固定長ストレージ
		| HSPVAR_SUPPORT_FLEXARRAY		// 可変長配列
		| HSPVAR_SUPPORT_ARRAYOBJ		// 連想配列サポート
		| HSPVAR_SUPPORT_NOCONVERT		// ObjectWriteで格納
		| HSPVAR_SUPPORT_VARUSE			// varuse関数を適用
		;
	p->basesize = VtTraits::basesize<vtVector>::value;	// size / 要素 (byte)
	return;
}

//------------------------------------------------
// knowbug に内部変数列を渡す
// 
// @ リストを削除してはいけない。
// @ 後方互換性のために残す。
// @ 内部リークするが気にしない。
//------------------------------------------------
// [[deprecated]]
static PVal** HspVarVector_GetVectorList( PDAT const* _src, int* pSize )
{
	auto const& src = VtTraits::derefValptr<vtVector>(_src);

	if ( src.isNull() ) {
		if ( pSize ) { *pSize = 0; }
		return nullptr;

	} else {
		size_t const len = src->size();

		if ( pSize ) { *pSize = len; }
		PVal** const buf = reinterpret_cast<PVal**>(hspmalloc(len * sizeof(PVal*)));

		for ( size_t i = 0; i < len; ++ i ) {
			buf[i] = src->at(i).getPVal();
		}
		return const_cast<PVal**>(buf);
	}
}

//------------------------------------------------
// knowbug の拡張表示に対応する
//------------------------------------------------
#include "knowbug/knowbugForHPI.h"

EXPORT void WINAPI knowbugVsw_addVarVector(vswriter_t _w, char const* name, PVal const* pval)
{
	auto const kvswm = knowbug_getVswMethods();

	// 必ず単体扱いする
	kvswm->addVarScalar(_w, name, pval, 0);
	return;
}

EXPORT void WINAPI knowbugVsw_addValueVector(vswriter_t _w, char const* name, PDAT const* ptr)
{
	auto const kvswm = knowbug_getVswMethods();
	auto const& src = VtTraits::derefValptr<vtVector>(ptr);

	if ( src.isNull() ) {
		kvswm->catLeafExtra(_w, name, "null_vector");
		return;
	}

	kvswm->catNodeBegin(_w, name, "[");
	{
		auto const len = src->size();

		char stmp[16];
		size_t const lenStmp = sprintf_s(stmp, "%d", len);
		kvswm->catAttribute(_w, "length", stmp);

		for ( size_t i = 0; i < len; ++i ) {
			sprintf_s(stmp, "(%d)", i);
			kvswm->addVar(_w, stmp, src->at(i).getPVal());
			//dbgout("%p: idx = %d, pval = %p, next = %p", list, idx, list->pval, list->next );
		}
	}
	kvswm->catNodeEnd(_w, "]");
	return;
}
