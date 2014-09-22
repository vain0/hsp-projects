// vector - Command code

#include <functional>

#include "vt_vector.h"
#include "cmd_vector.h"
#include "sub_vector.h"

#include "mod_makepval.h"
#include "mod_argGetter.h"
#include "reffuncResult.h"
#include "mod_varutil.h"

using namespace hpimod;

static vector_t g_pResultVector { nullptr };

static void VectorMovingImpl( vector_t& self, int cmd );

//------------------------------------------------
// vector �^�̒l��ԋp����
// 
// @ ���̂܂ܕԋp����ƃX�^�b�N�ɏ��B
//------------------------------------------------
int SetReffuncResult( PDAT** ppResult, vector_t const& self )
{
	g_pResultVector = self;
	*ppResult = VtTraits::asPDAT<vtVector>(&g_pResultVector);
	return g_vtVector;
}

int SetReffuncResult( PDAT** ppResult, vector_t&& self )
{
	g_pResultVector = std::move(self);
	*ppResult = VtTraits::asPDAT<vtVector>(&g_pResultVector);
	return g_vtVector;
}

//------------------------------------------------
// vector �^�̒l���󂯎��
//------------------------------------------------
vector_t code_get_vector()
{
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	if ( mpval->flag != g_vtVector ) puterror( HSPERR_TYPE_MISMATCH );
	return std::move(VtTraits::getMaster<vtVector>(mpval));
}

//------------------------------------------------
// vector �̓����ϐ����󂯎��
//------------------------------------------------
PVal* code_get_vector_inner()
{
	PVal* const pval = code_get_var();
	if ( pval->flag != g_vtVector ) puterror( HSPERR_TYPE_MISMATCH );

	PVal* const pvInner = getInnerPVal( pval );
	if ( !pvInner ) puterror( HSPERR_VARIABLE_REQUIRED );
	return pvInner;
}

//------------------------------------------------
// vector �͈̔͂����o��
//------------------------------------------------
std::pair<size_t, size_t> code_get_vector_range(vector_t const& self)
{
	bool const bNull = self.isNull();

	int const iBgn = code_getdi(0);
	int const iEnd = code_getdi((!bNull ? self->size() : 0));
	if ( (!bNull && !isValidRange(self, iBgn, iEnd))
		|| (bNull && (iBgn != 0 || iEnd != 0)) ) puterror(HSPERR_ILLEGAL_FUNCTION);
	return { iBgn, iEnd };
}

//#########################################################
//        ����
//#########################################################
//------------------------------------------------
// �j��
//------------------------------------------------
void VectorDelete()
{
	PVal* const pval = code_get_var();
	if ( pval->flag != g_vtVector ) puterror(HSPERR_TYPE_MISMATCH);

	VtTraits::getMaster<vtVector>(pval).reset();
	return;
}

//------------------------------------------------
// ���e����������
//------------------------------------------------
int VectorMake(PDAT** ppResult)
{
	auto&& self = vector_t::make();

	for ( size_t i = 0; code_isNextArg(); ++i ) {
		int const chk = code_getprm();
		assert(chk != PARAM_END && chk != PARAM_ENDSPLIT);

		self->resize(i + 1);
		if ( chk != PARAM_DEFAULT ) {
			PVal* const pvInner = self->at(i).getVar();
			PVal_assign(pvInner, mpval->pt, mpval->flag);
		}
		// else: �����l�̂܂�
	}

	return SetReffuncResult(ppResult, std::move(self.beTmpObj()));
}

//------------------------------------------------
// �X���C�X
//------------------------------------------------
int VectorSlice(PDAT** ppResult)
{
	auto&& self = code_get_vector();
	auto const&& range = code_get_vector_range(self);

	auto&& result = vector_t::make();
	chainShallow(result, self, range);
	return SetReffuncResult(ppResult, std::move(result.beTmpObj()));
}

//------------------------------------------------
// �X���C�X�E�A�E�g
//------------------------------------------------
int VectorSliceOut(PDAT** ppResult)
{
	auto&& self = code_get_vector();
	auto const&& range = code_get_vector_range(self);

	size_t const len = self->size();
	size_t const lenRange = range.second - range.first;

	auto&& result = vector_t::make();
	if ( len > lenRange ) {
		result->reserve(len - lenRange);
		chainShallow(result, self, { 0, range.first });
		chainShallow(result, self, { range.second, len });
	}
	return SetReffuncResult(ppResult, std::move(result.beTmpObj()));
}

//------------------------------------------------
// ����
//------------------------------------------------
int VectorDup(PDAT** ppResult)
{
	auto&& src = code_get_vector();
	auto&& range = code_get_vector_range(src);

	// PVal �̒l�𕡐����� vector ����������
	auto&& self = vector_t::make();

	chainDeep(self, src, range);
	return SetReffuncResult(ppResult, std::move(self.beTmpObj()));
}

//------------------------------------------------
// vector �̏��
//------------------------------------------------
int VectorIsNull(PDAT** ppResult)
{
	auto&& self = code_get_vector();
	return SetReffuncResult(ppResult, HspBool(!self.isNull()));
}

int VectorSize(PDAT** ppResult)
{
	auto&& self = code_get_vector();
	assert(!self.isNull());

	return SetReffuncResult(ppResult, static_cast<int>(self->size()));
}

//------------------------------------------------
// �����ϐ��ւ̂��ꂱ��
//------------------------------------------------
void VectorDimtype()
{
	PVal* const pvInner = code_get_vector_inner();
	code_dimtype(pvInner, code_geti());
	return;
}

void VectorClone()
{
	PVal* const pvalSrc = code_get_vector_inner();
	PVal* const pvalDst = code_getpval();

	PVal_cloneVar( pvalDst, pvalSrc );
	return;
}

int VectorVarinfo(PDAT** ppResult)
{
	PVal* const pvInner = code_get_vector_inner();
	return SetReffuncResult(ppResult, code_varinfo(pvInner));
}

//#########################################################
//        �R���e�i����
//#########################################################
//------------------------------------------------
// �A��
//------------------------------------------------
void VectorChain(bool bClear)
{
	auto&& dst = code_get_vector();
	auto&& src = code_get_vector();

	if ( bClear ) dst->clear();

	auto const&& range = code_get_vector_range(src);
	chainDeep(dst, src, range);
	return;
}

#if 0

//------------------------------------------------
// �R���e�i���쏈���e���v���[�g
//------------------------------------------------
// ���

//------------------------------------------------
// �v�f����
//------------------------------------------------
void VectorMoving( int cmd )
{
	PVal* const pval = code_get_var();
	if ( pval->flag != g_vtVector ) puterror( HSPERR_TYPE_MISMATCH );

	auto& src = VtTraits::getMaster<vtVector>(pval);
	if ( !src.isNull() ) puterror( HSPERR_ILLEGAL_FUNCTION );

	VectorMovingImpl( src, cmd );
	return;
}

static void VectorMovingImpl( vector_t& self, int cmd )
{
	switch ( cmd ) {
		case VectorCmdId::Move:
		{
			int const iDst = code_geti();
			int const iSrc = code_geti();
			if ( isValidIndex(self, iDst) || !isValidIndex(self, iSrc) ) puterror( HSPERR_ILLEGAL_FUNCTION );

			std::move(
				self->begin() + iSrc,
				self->begin() + (iSrc + 1),
				self->begin() + iDst
			);
			break;
		}
		case VectorCmdId::Swap:
		{
			int const idx1 = code_geti();
			int const idx2 = code_geti();

			std::swap(self->begin() + idx1, self->begin() + idx2);
			break;
		}
		case VectorCmdId::Rotate:
		{
			int const step = code_getdi(1);
			assert(false);
			//std::rotate(self->begin(), self->end());
			break;
		}
		case VectorCmdId::Reverse:
		{
			auto&& range = code_get_vector_range(self);
			std::reverse(self->begin() + range.first, self->begin() + range.second);
			break;
		}
	}
	return;
}

int VectorMovingFunc( PDAT** ppResult, int cmd )
{
	auto&& src = code_get_vector();
	if ( !src.isNull() ) puterror( HSPERR_ILLEGAL_FUNCTION );

	// �S��ԃX���C�X
	auto self = vector_t::make();
	CVector* const self = CVector::NewTemp();
	{
		chain(self, src, { 0, src->size() });
		VectorMovingImpl( self, cmd );
	}

	return SetReffuncResult( ppResult, self );
}

//------------------------------------------------
// �v�f: �ǉ�, ����
// 
// @t-prm idProc: �����Ŏg���̂݁B
// @	0: Insert
// @	1: Insert1
// @	2: PushFront
// @	3: PushBack
// @	4: Remove
// @	5: Remove1
// @	6: PopFront
// @	7: PopBack
// @	8: Replace
//------------------------------------------------
template<int idProc>
static void VectorElemProcImpl( CVector* self )
{
	switch ( idProc ) {
		// ��ԃA�N�Z�X => ��Ԃ��K�v; ���� insert => �����l���X�g����� (�ȗ���)
		case 0:
		case 4:
		{
			int const iBgn = code_geti();
			int const iEnd = code_geti();
			if ( iBgn == iEnd ) break;

			if ( idProc == 0 ) {
				self->Insert( iBgn, iEnd );

				// �����l���X�g (�ȗ���)
				bool   const bReversed = (iBgn > iEnd);
				size_t const cntElems  = ( !bReversed ? iEnd - iBgn : iBgn - iEnd );
				for ( size_t i = 0; i < cntElems; ++ i ) {
					int const chk = code_getprm();
					if ( chk <= PARAM_END ) {
						if ( chk == PARAM_DEFAULT ) continue; else break;
					}
					PVal_assign( self->AtSafe( (!bReversed ? iBgn + i : iBgn - i) ), mpval->pt, mpval->flag );
				}

			} else {
				self->Remove( iBgn, iEnd );
			}
			break;
		}
		// �P��A�N�Z�X => �Y�����K�v; ���� insert1 => �����l����� (�ȗ���)
		case 1:
		case 5:
		{
			int const idx = code_geti();

			if ( idProc == 1 ) {
				PVal* const pvdat = self->Insert( idx );

				// �����l
				if ( code_getprm() > PARAM_END ) {
					PVal_assign( pvdat, mpval->pt, mpval->flag );
				}

			} else {
				self->Remove( idx );
			}
			break;
		}
		// push => �����l����� (�ȗ���)
		case 2:
		case 3:
		{
			PVal* const pvdat = (idProc == 2)
				? self->PushFront()
				: self->PushBack();

			if ( code_getprm() > PARAM_END )  {
				PVal_assign( pvdat, mpval->pt, mpval->flag );
			}
			break;
		}
		// pop
		case 6: self->PopFront(); break;
		case 7: self->PopBack();  break;

		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
	}

	return;
}

// ����
template<int idProc>
static void VectorElemProc()
{
	auto&& self = code_get_vector();
	if ( isNull( self ) ) puterror( HSPERR_ILLEGAL_FUNCTION );

	VectorElemProcImpl<idProc>( self );
	return;
}

void VectorInsert()    { VectorElemProc<0>(); }
void VectorInsert1()   { VectorElemProc<1>(); }
void VectorPushFront() { VectorElemProc<2>(); }
void VectorPushBack()  { VectorElemProc<3>(); }
void VectorRemove()    { VectorElemProc<4>(); }
void VectorRemove1()   { VectorElemProc<5>(); }
void VectorPopFront()  { VectorElemProc<6>(); }
void VectorPopBack()   { VectorElemProc<7>(); }

// �֐�
template<int idProc>
static int VectorElemProc( PDAT** ppResult )
{
	auto&& src = code_get_vector();
	if ( isNull( src ) ) puterror( HSPERR_ILLEGAL_FUNCTION );

	CVector* const self = CVector::NewTemp();		// ���l�Ȉꎞ�I�u�W�F�N�g�𐶐�
	self->Chain( *src );

	VectorElemProcImpl<idProc>( self );

	return SetReffuncResult( ppResult, self );
}

int VectorInsert   ( PDAT** ppResult ) { return VectorElemProc<0>( ppResult ); }
int VectorInsert1  ( PDAT** ppResult ) { return VectorElemProc<1>( ppResult ); }
int VectorPushFront( PDAT** ppResult ) { return VectorElemProc<2>( ppResult ); }
int VectorPushBack ( PDAT** ppResult ) { return VectorElemProc<3>( ppResult ); }
int VectorRemove   ( PDAT** ppResult ) { return VectorElemProc<4>( ppResult ); }
int VectorRemove1  ( PDAT** ppResult ) { return VectorElemProc<5>( ppResult ); }
int VectorPopFront ( PDAT** ppResult ) { return VectorElemProc<6>( ppResult ); }
int VectorPopBack  ( PDAT** ppResult ) { return VectorElemProc<7>( ppResult ); }

//------------------------------------------------
// �v�f�u��
//------------------------------------------------
// ����
void VectorReplace()
{
	PVal* const pval = code_get_var();
	if ( pval->flag != g_vtVector ) puterror( HSPERR_TYPE_MISMATCH );

	auto const self = Vector_getPtr(pval);
	if ( isNull( self ) ) puterror( HSPERR_ILLEGAL_FUNCTION );

	int const iBgn = code_getdi( 0 );
	int const iEnd = code_getdi( self->Size() );
	if ( !self->IsValid(iBgn, iEnd) ) puterror( HSPERR_ILLEGAL_FUNCTION );

	auto&& src = code_get_vector();	// null-able

	self->Replace( iBgn, iEnd, src );
	return;
}

// �֐�
int VectorReplace( PDAT** ppResult )
{
	auto&& self = code_get_vector();
	if ( isNull( self ) ) puterror( HSPERR_ILLEGAL_FUNCTION );

	int const iBgn = code_getdi(0);
	int const iEnd = code_getdi(self->Size());
	if ( !self->IsValid(iBgn, iEnd) ) puterror( HSPERR_ILLEGAL_FUNCTION );

	auto&& src = code_get_vector();	// null-able

	if ( !self->IsValid(iBgn, iEnd) ) {
		return SetReffuncResult( ppResult, CVector::Null );

	} else {
		// ���l�Ȉꎞ�I�u�W�F�N�g�𐶐�����
		CVector* const result = CVector::NewTemp();
		{
			result->Chain(*self);
			result->Replace(iBgn, iEnd, src);
		}
		return SetReffuncResult( ppResult, result );
	}
}
#endif

//#########################################################
//        �֐�
//#########################################################
//------------------------------------------------
// �����ϐ��̏��𓾂�
//------------------------------------------------
//------------------------------------------------
// vector �ԋp�֐�
//------------------------------------------------
static int const VectorResultExprMagicNumber = 0x31EC100A;

int VectorResult( PDAT** ppResult )
{
	g_pResultVector = code_get_vector();

	return SetReffuncResult(ppResult, VectorResultExprMagicNumber);
}

int VectorExpr( PDAT** ppResult )
{
	// ������ VectorResult() �����s�����͂�
	if ( code_geti() != VectorResultExprMagicNumber ) puterror(HSPERR_ILLEGAL_FUNCTION);

	return (g_pResultVector.isTmpObj()
		? SetReffuncResult( ppResult, std::move(g_pResultVector) )
		: SetReffuncResult( ppResult, g_pResultVector) );
}

//------------------------------------------------
// �����񌋍�(Join)
//------------------------------------------------
int VectorJoin( PDAT** ppResult )
{
	auto&& self = code_get_vector();

	// todo: use sdt::string?

	char const* const _splitter = code_getds(", ");
	char splitter[0x80];
	strcpy_s(splitter, _splitter);
	size_t const lenSplitter = std::strlen(splitter);

	char const* const _leftBracket = code_getds("");
	char leftBracket[0x10];
	strcpy_s(leftBracket, _leftBracket);
	size_t const lenLeftBracket = std::strlen(leftBracket);

	char const* const _rightBracket = code_getds("");
	char rightBracket[0x10];
	strcpy_s(rightBracket, _rightBracket);
	size_t const lenRightBracket = std::strlen(rightBracket);

	// �����񉻏���
	std::function<void(vector_t&, char*, int, size_t&)> impl
		= [&](vector_t const& self, char* buf, int bufsize, size_t& idx)
	{
		strcpy_s(&buf[idx], bufsize - idx, leftBracket); idx += lenLeftBracket;

		// foreach
		for ( size_t i = 0; i < self->size(); ++ i ) {
			if ( i != 0 ) {
				// ��؂蕶��
				strcpy_s( &buf[idx], bufsize - idx, splitter ); idx += lenSplitter;
			}

			PVal* const pvdat = self->at(i).getVar();

			if ( pvdat->flag == g_vtVector ) {
				impl( VtTraits::getMaster<vtVector>(pvdat), buf, bufsize, idx );

			} else {
				// �����񉻂��ĘA��
				char const* const pStr = (char const*)Valptr_cnvTo(PVal_getptr(pvdat), pvdat->flag, HSPVAR_FLAG_STR);
				size_t const lenStr = std::strlen( pStr );
				strcpy_s( &buf[idx], bufsize - idx, pStr ); idx += lenStr;
			}
		}

		strcpy_s(&buf[idx], bufsize - idx, rightBracket); idx += lenRightBracket;
	};

	auto const lambda = [&self, &impl](char* buf, int bufsize) {
		size_t idx = 0;				// ������̕�����̒���
		impl( self, buf, bufsize, idx );
		buf[idx ++] = '\0';
	};

	return SetReffuncResultString( ppResult, lambda );
}

//------------------------------------------------
// �Y���֐�
//------------------------------------------------
int VectorAt( PDAT** ppResult )
{
	auto&& self = code_get_vector();

	int vtype;
	if ( PDAT* const pResult = Vector_indexRhs(self, &vtype) ) {
		*ppResult = pResult;
		return vtype;
	} else {
		return SetReffuncResult(ppResult, self);
	}
}


//------------------------------------------------
// �I����
//------------------------------------------------
void VectorCmdTerminate()
{
	g_pResultVector.nullify();
	return;
}
