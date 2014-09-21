// vector - Command header

#ifndef IG_VECTOR_COMMAND_H
#define IG_VECTOR_COMMAND_H

#include "hsp3plugin_custom.h"
using namespace hpimod;

#include "vt_vector.h"

extern vector_t code_get_vector();

// �R�}���h�p�֐��̃v���g�^�C�v�錾
extern void VectorDelete();				// �j��

extern int VectorMake( PDAT** ppResult );			// as literal
extern int VectorSlice( PDAT** ppResult );
extern int VectorSliceOut( PDAT** ppResult );
extern int VectorDup( PDAT** ppResult );

extern int VectorIsNull( PDAT** ppResult );
extern int VectorVarinfo( PDAT** ppResult );
extern int VectorSize( PDAT** ppResult );

extern void VectorDimtype();
extern void VectorClone();

extern void VectorChain(bool bClear);	// �A�� (or ����)
#if 0
extern void VectorMoving( int cmd );	// �v�f��������n
extern int  VectorMovingFunc( PDAT** ppResult, int cmd );

extern void VectorInsert();				// �v�f�ǉ�
extern void VectorInsert1();
extern void VectorPushFront();
extern void VectorPushBack();
extern void VectorRemove();				// �v�f�폜
extern void VectorRemove1();
extern void VectorPopFront();
extern void VectorPopBack();
extern void VectorReplace();
extern int VectorInsert( PDAT** ppResult ) ;
extern int VectorInsert1( PDAT** ppResult ) ;
extern int VectorPushFront( PDAT** ppResult );
extern int VectorPushBack( PDAT** ppResult );
extern int VectorRemove( PDAT** ppResult );
extern int VectorRemove1( PDAT** ppResult );
extern int VectorPopFront( PDAT** ppResult );
extern int VectorPopBack( PDAT** ppResult );
extern int VectorReplace( PDAT** ppResult );
#endif

extern int VectorResult( PDAT** ppResult );
extern int VectorExpr( PDAT** ppResult );
extern int VectorJoin( PDAT** ppResult );
extern int VectorAt( PDAT** ppResult );

// �I����
extern void VectorCmdTerminate();

// �V�X�e���ϐ�

// �萔
namespace VectorCmdId {
	int const
		Move    = 0x20,
		Swap    = 0x21,
		Rotate  = 0x22,
		Reverse = 0x23;
};

#endif
