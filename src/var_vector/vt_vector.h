// vector - VarProc header

#ifndef IG_VECTOR_VARPROC_H
#define IG_VECTOR_VARPROC_H

#include <vector>
#include "vp_template.h"
#include "Managed.h"
#include "ManagedPVal.h"
#include "HspAllocator.h"

//#include "CVector.h"

using namespace hpimod;

using vector_t = Managed< std::vector<ManagedVarData, HspAllocator<ManagedVarData>>, false >;

// vartype traits
struct vtVector {

	// special indexes
	static int const IdxBegin = 0;
	static int const IdxLast  = (-0x031EC10A);	// �Ō�̗v�f��\���Y���R�[�h
	static int const IdxEnd   = (-0x031EC10B);	// (�Ō�̗v�f + 1)��\���Y���R�[�h

};

namespace hpimod
{
	namespace VtTraits
	{
		namespace Impl
		{
			template<> struct value_type<vtVector> { using type = vector_t; };
			template<> struct const_value_type<vtVector> { using type = vector_t const; };
			template<> struct valptr_type<vtVector> { using type = vector_t*; };
			template<> struct const_valptr_type<vtVector> { using type = vector_t const*; };
			template<> struct master_type<vtVector> { using type = vector_t; };	// ���̒l
			template<> struct basesize<vtVector> { static int const value = sizeof(vector_t); };
		}
	}
}

//------------------------------------------------
// �����ϐ��̎擾
// 
// @ �{�̂��Q�Ƃ���Ă���Ƃ��� nullptr ��Ԃ��B
//------------------------------------------------
static PVal* getInnerPVal(PVal* pval, APTR aptr)
{
	return hpimod::VtTraits::getMaster<vtVector>(pval)->at(aptr).getPVal();
}

static PVal* getInnerPVal(PVal* pval)
{
	if ( pval->arraycnt == 0 ) return nullptr;
	return getInnerPVal(pval, pval->offset);
}

// �O���[�o���ϐ�
extern vartype_t g_vtVector;
extern HspVarProc* g_pHvpVector;

// �֐�
extern void HspVarVector_Init( HspVarProc* p );
extern int SetReffuncResult( PDAT** ppResult, vector_t const& self );
extern int SetReffuncResult( PDAT** ppResult, vector_t&& self );

extern PDAT* Vector_indexRhs( vector_t self, int* mptype );

#endif
