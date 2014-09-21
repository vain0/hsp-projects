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

// vartype tag
struct vector_tag
{
	// interfaces
	using value_t  = vector_t;
	using valptr_t = value_t*;
	using const_valptr_t = value_t const*;

	using master_t = value_t;	// ���̒l

	static int const basesize = sizeof(value_t);

	// special indexes
	static int const IdxBegin = 0;
	static int const IdxLast  = (-0x031EC10A);	// �Ō�̗v�f��\���Y���R�[�h
	static int const IdxEnd   = (-0x031EC10B);	// (�Ō�̗v�f + 1)��\���Y���R�[�h
};

// VtTraits<> �̓��ꉻ
namespace hpimod
{
	template<> struct VtTraits<vector_tag> : public VtTraitsBase<vector_tag>
	{
		//------------------------------------------------
		// �����ϐ��̎擾
		// 
		// @ �{�̂��Q�Ƃ���Ă���Ƃ��� nullptr ��Ԃ��B
		//------------------------------------------------
		static PVal* getInnerPVal(PVal* pval, APTR aptr)
		{
			return getMaster(pval)->at(aptr).getPVal();
		}

		static PVal* getInnerPVal(PVal* pval)
		{
			if ( pval->arraycnt == 0 ) return nullptr;
			return getInnerPVal(pval, pval->offset);
		}

	};
}

using VectorTraits = hpimod::VtTraits<vector_tag>;

// �O���[�o���ϐ�
extern vartype_t g_vtVector;
extern HspVarProc* g_pHvpVector;

// �֐�
extern void HspVarVector_Init( HspVarProc* p );
extern int SetReffuncResult( PDAT** ppResult, vector_t self );

extern PDAT* Vector_indexRhs( vector_t self, int* mptype );

#endif
