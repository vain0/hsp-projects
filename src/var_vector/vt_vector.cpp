// vector - VarProc code

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
// ���̃|�C���^
//------------------------------------------------
static PDAT* HspVarVector_GetPtr(PVal* pval)
{
	return reinterpret_cast<PDAT*>(pval->pt);
}

//------------------------------------------------
// Using
//------------------------------------------------
static int HspVarVector_GetUsing(PDAT const* pdat)
{
	return HspBool(!VtTraits::derefValptr<vtVector>(pdat).isNull());
}

//------------------------------------------------
// PVal�̕ϐ����������m�ۂ���
//
// @ pval �͖��m�� or ����ς݂̏�ԁB
// @ pval2 != nullptr => pval2�̓��e���p������B
//------------------------------------------------
static void HspVarVector_Alloc(PVal* pval, PVal const* pval2)
{
	assert(pval);
	size_t const cntElems = std::max(0, pval->len[1]);
	pval->len[1] = 1;

	//dbgout("pval = %08X, pval2 = %08X, pval->pt = %08X, cntElems = %d", pval, pval2, pval->pt, cntElems );

	// �p��
	// len[1] = 1 �Ȃ̂ŉ��x���Ă΂�Ă��܂�
	if ( pval2 ) {
		assert(pval == pval2);
		auto& vec = VtTraits::derefValptr<vtVector>(pval2->pt);
		
		if ( vec->size() < cntElems ) {
			vec->resize(cntElems);
		}

	} else {
		// pval->master �����̂ɂȂ�
		auto const p = &VtTraits::getMaster<vtVector>(pval);

		// mpval �Ȃ� inst = nullptr �ŏ�����
		if ( pval->support & HSPVAR_SUPPORT_TEMPVAR ) {
			new(p) vector_t { nullptr };

		// ���� cntElems �ŏ������A�e�v�f�͊���l
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
// PVAL�|�C���^�̕ϐ����������������
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
// �^�ϊ��Fflag �� this
// 
// @ �ϊ��O�̒l�� [0] �Ɏ��� vector �𐶐�����B(����������������̂ł�߂�)
//------------------------------------------------
#if 0
static void* HspVarVector_Cnv( const void *buffer, int flag )
{
	static CVector* result = nullptr;

	result = CVector::NewTemp();		// �ꎞ�I�u�W�F�N�g

	result->Alloc( 1 );
	PVal_assign( result->at(0), (void*)buffer, flag );

	return &result;
}
#endif

//------------------------------------------------
// �^�ϊ��Fthis �� flag
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
// ��� (=)
//------------------------------------------------
static void HspVarVector_Set(PVal* pval, PDAT* pdat, PDAT const* in)
{
	if ( pval->offset != 0 ) puterror( HSPERR_ARRAY_OVERFLOW );

	auto& dst = VtTraits::derefValptr<vtVector>(pdat);
	auto& src = VtTraits::derefValptr<vtVector>(in);

	// �e���|�����ϐ� => �Q�Ƌ��L
	if ( pval->support & HSPVAR_SUPPORT_TEMPVAR ) {
		dst = src;

	// �E�ӂ��ꎞ�I�u�W�F�N�g�Ȃ� move
	} else if ( src.isTmpObj() ) {
		dst = std::move(src);
		
	// ���ׂĂ̗v�f�����L�����ɂ���
	} else {
		dst.reset();
		chainShallow(dst, src, { 0, src->size() });
	}
	
	// �X�^�b�N���~���
	src.beNonTmpObj();
	return;
}

//------------------------------------------------
// �A�� (Add)
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

	lhs = std::move(result);	// �Ԓl
	rhs.beNonTmpObj();			// �X�^�b�N����~���

	g_pHvpVector->aftertype = g_vtVector;
	return;
}

//------------------------------------------------
// ��r
// 
// @ �`���I�ɔ�r����B�����ϐ��̌��ƁA���ꂼ��̎Q�ƂƁA���Ԃ��S�ē�������΁A�������Ƃ���B
// @ pdat �� vector �� PVal::pt �Ȃ̂ŁA�Ԓl( true or false )��������ƁA
// @	���ӂ̎Q�Ƃ�1����ɏ����邱�ƂɂȂ�B���̂��߁A���ӂ̎Q�Ƃ� Release ���Ă����B
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
			if ( lhs->at(i).getPVal() != rhs->at(i).getPVal() ) return -1;	// �������Ƃ肠�������̂����������Ƃɂ���
		}
		return 0;
	}
}

/*static*/ int HspVarVector_CmpI( PDAT* pdat, PDAT const* val )
{
	auto& lhs = VtTraits::derefValptr<vtVector>(pdat);
	auto& rhs = VtTraits::derefValptr<vtVector>(val);

	int const cmp = Compare( lhs, rhs );

	lhs.nullify();		// �j�󂳂��
	rhs.beNonTmpObj();	// �X�^�b�N����~���

	g_pHvpVector->aftertype = HSPVAR_FLAG_INT;
	return cmp;
}

//------------------------------------------------
// ���\�b�h�Ăяo��
//
// @ �����ϐ��ւ̃��\�b�h�Ƃ��Ĉ����B
//------------------------------------------------
static void HspVarVector_ObjectMethod( PVal* pval )
{
	PVal* const pvInner = getInnerPVal(pval);
	if ( !pvInner ) puterror( HSPERR_UNSUPPORTED_FUNCTION );

	getHvp(pvInner->flag)->ObjectMethod( pvInner );
	return;
}

//#########################################################
//        �A�z�z��p�̊֐��Q
//#########################################################
//------------------------------------------------
// �A�z�z��::�Y������
// 
// @ ( idx, inner-var's-idxes... )
// @ �����ϐ��̓Y�����������镔���́A�E�Ӓl�����Ӓl���ɂ���ĕς���Ă��邽��
// @	�����ł͏��������A�Ăяo�����Ɉς˂�B
// @ *_ArrayObjectImpl �� vector �̕��̓Y��(1��)���������A
// @	���̌�̓����ϐ��̓Y���́A�Ăяo������ *_ArrayObject, *_ArrayObjectRead �ɔC����B
//------------------------------------------------
// vector ���g�ւ̓Y�����󂯎��
static int code_vectorIndex(vector_t const& self)
{
	int const idx = code_getdi(-1);
	if ( idx < 0 ) {
		if ( idx == vtVector::IdxLast ) {
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

// �����ϐ����擾
// getVar �֐��������ϐ��̓Y����Ԃ� array->cnt �ɂ��B
template<bool bAsLhs>
static PVal* HspVarVector_ArrayObjectImplInner(vector_t const& self, size_t idx)
{
	if ( self->size() <= idx ) {
		if ( bAsLhs ) {
			// �����g��
			self->resize(idx + 1);
		} else {
			puterror(HSPERR_ARRAY_OVERFLOW);
		}
	}
	return self->at(idx).getVar();
}

// vector �̓Y�����������A���̓����ϐ��� nullptr(vector���̂��Q�Ƃ����) ��ԋp����
template<bool bAsLhs>
static PVal* HspVarVector_ArrayObjectImpl( PVal* pval )
{
	auto& vec = VtTraits::getMaster<vtVector>(pval);

	HspVarCoreReset( pval );
	int const idx = code_vectorIndex( vec );
	if ( idx < 0 ) {
		return nullptr;			// vector ���̂ւ̃|�C���^

	} else {
		pval->offset   = idx;
		pval->arraycnt = 1;
		return HspVarVector_ArrayObjectImplInner<bAsLhs>( vec, static_cast<size_t>(idx) );
	}
}

//------------------------------------------------
// �A�z�z��::�Q�� (��)
//------------------------------------------------
void HspVarVector_ArrayObject( PVal* pval )
{
	PVal* const pvInner = HspVarVector_ArrayObjectImpl<true>( pval );

	if ( pvInner ) {
		if ( code_isNextArg() ) {
			code_expand_index_lhs(pvInner);
		}
		//else { code_index_reset(pvInner); }
	}
	return;
}

//------------------------------------------------
// �A�z�z��::�Q�� (�E)
//------------------------------------------------
// �����ϐ��̓Y���̏���
static PDAT* HspVarVector_ArrayObjectReadImpl( PVal* pvInner, int* mptype )
{
	if ( code_isNextArg() ) {
		return code_expand_index_rhs( pvInner, *mptype );

	} else {
		//code_index_reset(pvInner);

		*mptype = pvInner->flag;
		return getHvp( pvInner->flag )->GetPtr( pvInner );
	}
}

PDAT* HspVarVector_ArrayObjectRead( PVal* pval, int* mptype )
{
	PVal* const pvInner = HspVarVector_ArrayObjectImpl<false>( pval );

	if ( pvInner ) {
		return HspVarVector_ArrayObjectReadImpl(pvInner, mptype);

	// vector ���̂̎Q��
	} else {
		*mptype = g_vtVector;
		return pval->pt;
	}
}

//------------------------------------------------
// �A�z�z��::�Q�� (�E; from �֐�)
//------------------------------------------------
PDAT* Vector_indexRhs( vector_t self, int* mptype )
{
	int const idx = code_vectorIndex( self );
	if ( idx < 0 ) {
		*mptype = g_vtVector;
		// vector ���̂̎Q�Ƃ̂Ƃ��� nullptr ��Ԃ��B
		// pSelf �͂����������� (C++��) ���[�J���ϐ����w���Ă��邩������Ȃ��̂Œ��ӂ𑣂������B
		return nullptr;

	} else {
		PVal* const pvInner = HspVarVector_ArrayObjectImplInner<false>( self, static_cast<size_t>(idx) );
		return HspVarVector_ArrayObjectReadImpl( pvInner, mptype );
	}
}

//------------------------------------------------
// �A�z�z��::�i�[����
//------------------------------------------------
static void HspVarVector_ObjectWrite( PVal* pval, PDAT const* data, int vflag )
{
	PVal* const pvInner = getInnerPVal(pval);

	DbgArea {
		auto& self = VtTraits::derefValptr<vtVector>(pval->pt);
	//	dbgout("ow pval=%p, data=%p, vflag=%d; len = %d, offset=%d", pval, data, vflag, self->size(), pval->offset);
	}

	// �Q�ƂȂ� (vector ���̂ւ̑��)
	if ( !pvInner ) {
		if ( vflag != g_vtVector ) puterror( HSPERR_INVALID_ARRAYSTORE );	// �E�ӂ̌^���s��v

		HspVarVector_Set( pval, VtTraits::asPDAT<vtVector>(&VtTraits::getMaster<vtVector>(pval)), data );

	// �����ϐ����Q�Ƃ��Ă���ꍇ
	} else {
	//	if ( code_isNextArg() && !(pvInner->support & HSPVAR_SUPPORT_ARRAYOBJ) && pvInner->flag != vflag ) {
	//		puterror( HSPERR_INVALID_ARRAYSTORE );	// �A��������͌^�ϊ��s��
	//	}

		bool const bToVector = ( pvInner->arraycnt == 0 );		// (�����ϐ��ɓY�������Ă��Ȃ�)
		
		// �����ϐ��ւ̑�������ֈړ� (������ pvInner �̓Y����Ԃ��ω�)
		PVal_assign( pvInner, data, vflag );

		// �A�����
		if ( bToVector ) {
			auto& vec = VtTraits::getMaster<vtVector>(pval);
			while ( code_isNextArg() ) {
				int const chk = code_getprm();
				assert(chk != PARAM_END && chk != PARAM_ENDSPLIT);
				if ( chk == PARAM_DEFAULT ) continue;

				++pval->offset;
				// �����g��
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
// vector �o�^�֐�
//------------------------------------------------
void HspVarVector_Init(HspVarProc* p)
{
	g_pHvpVector = p;
	g_vtVector = p->flag;

	// �֐��|�C���^��o�^
	p->GetPtr       = HspVarVector_GetPtr;
	p->GetSize      = HspVarTemplate_GetSize<vtVector>;
	p->GetUsing     = HspVarVector_GetUsing;
	p->GetBlockSize = HspVarTemplate_GetBlockSize<vtVector>;
	p->AllocBlock   = HspVarTemplate_AllocBlock<vtVector>;

	p->Alloc = HspVarVector_Alloc;
	p->Free = HspVarVector_Free;

	//	p->Cnv          = HspVarVector_Cnv;
	//	p->CnvCustom    = HspVarVector_CnvCustom;

	// ���Z�֐�
	p->Set = HspVarVector_Set;
	p->AddI = HspVarProcOperatorCast(HspVarVector_AddI);

	HspVarTemplate_InitCmpI_Full< HspVarVector_CmpI >(p);

	// �A�z�z��p
	p->ArrayObject     = HspVarVector_ArrayObject;		// �Q��(��)
	p->ArrayObjectRead = HspVarVector_ArrayObjectRead;	// �Q��(�E)
	p->ObjectWrite     = HspVarVector_ObjectWrite;		// �i�[����
	p->ObjectMethod    = HspVarVector_ObjectMethod;		// ���\�b�h����

	// �g���f�[�^
	p->user = reinterpret_cast<char*>(HspVarVector_GetVectorList);

	// ���̑��ݒ�
	p->vartype_name = "vector_k";		// �^�C�v��
	p->version = 0x001;			// �^type runtime ver(0x100 = 1.0)

	p->support							// �T�|�[�g�󋵃t���O(HSPVAR_SUPPORT_*)
		= HSPVAR_SUPPORT_STORAGE		// �Œ蒷�X�g���[�W
		| HSPVAR_SUPPORT_FLEXARRAY		// �ϒ��z��
		| HSPVAR_SUPPORT_ARRAYOBJ		// �A�z�z��T�|�[�g
		| HSPVAR_SUPPORT_NOCONVERT		// ObjectWrite�Ŋi�[
		| HSPVAR_SUPPORT_VARUSE			// varuse�֐���K�p
		;
	p->basesize = VtTraits::basesize<vtVector>::value;	// size / �v�f (byte)
	return;
}

//------------------------------------------------
// knowbug �ɓ����ϐ����n��
// 
// @ ���X�g���폜���Ă͂����Ȃ��B
// @ ����݊����̂��߂Ɏc���B
// @ �������[�N���邪�C�ɂ��Ȃ��B
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
// knowbug �̊g���\���ɑΉ�����
//------------------------------------------------
#include "knowbug/knowbugForHPI.h"

EXPORT void WINAPI knowbugVsw_addVarVector(vswriter_t _w, char const* name, PVal const* pval)
{
	auto const kvswm = knowbug_getVswMethods();

	// �K���P�̈�������
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
