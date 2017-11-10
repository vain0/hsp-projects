// var_modcmd - VarProc

#include "hpimod/hsp3plugin_custom.h"
#include "hpimod/mod_makepval.h"
#include "hpimod/mod_argGetter.h"

#include "iface_modcmd.h"
#include "cmd_modcmd.h"
#include "vt_modcmd.h"

using namespace hpimod;

// �ϐ��̒�`
vartype_t   g_vtModcmd;
HspVarProc* g_pHvpModcmd;

// �֐��̐錾
extern PDAT* HspVarModcmd_GetPtr         ( PVal* pval) ;
extern int   HspVarModcmd_GetSize        ( const PDAT* pdat );
extern int   HspVarModcmd_GetUsing       ( const PDAT* pdat );
extern void* HspVarModcmd_GetBlockSize   ( PVal* pval, PDAT* pdat, int* size );
extern void  HspVarModcmd_AllocBlock     ( PVal* pval, PDAT* pdat, int  size );
extern void  HspVarModcmd_Alloc          ( PVal* pval, const PVal* pval2 );
extern void  HspVarModcmd_Free           ( PVal* pval);
extern PDAT* HspVarModcmd_ArrayObjectRead( PVal* pval, int* mptype );
extern void  HspVarModcmd_ArrayObject    ( PVal* pval);
extern void  HspVarModcmd_ObjectWrite    ( PVal* pval, void* data, int vflag );
extern void  HspVarModcmd_ObjectMethod   ( PVal* pval);

namespace VtModcmd {
	value_t& at(PVal* pval)
	{
		return *VtTraits::getValptr<vtModcmd>(pval);
	}
}

//------------------------------------------------
// Core
//------------------------------------------------
static PDAT* HspVarModcmd_GetPtr( PVal* pval )
{
	return VtTraits::asPDAT<vtModcmd>( &VtModcmd::at(pval) );
}

//------------------------------------------------
// Size
//------------------------------------------------
static int HspVarModcmd_GetSize( const PDAT* pdat )
{
	return VtTraits::basesize<vtModcmd>::value;
}

//------------------------------------------------
// Using
//------------------------------------------------
static int HspVarModcmd_GetUsing( const PDAT* pdat )
{
	return HspBool(VtTraits::derefValptr<vtModcmd>(pdat) != VtModcmd::null);
}

//------------------------------------------------
// �u���b�N������
//------------------------------------------------
static void* HspVarModcmd_GetBlockSize( PVal* pval, PDAT* pdat, int* size )
{
	*size = pval->size - ( ((char*)pdat) - ((char*)pval->pt) );
	return pdat;
}

static void HspVarModcmd_AllocBlock( PVal* pval, PDAT* pdat, int size )
{
}

//------------------------------------------------
// PVal�̕ϐ����������m�ۂ���
//
// @ pval �͖��m�� or ����ς݂̏�ԁB
// @ pval2 != nullptr �Ȃ�Apval2 �̓��e�������p���B
//------------------------------------------------
static void HspVarModcmd_Alloc(PVal* pval, const PVal* pval2)
{
	if ( pval->len[1] < 1 ) { pval->len[1] = 1; }
	size_t const cntElems = PVal_cntElems(pval);
	size_t const     size = cntElems * VtTraits::basesize<vtModcmd>::value;
	size_t const oldSize = pval2 ? pval2->size : 0;

	// �o�b�t�@�m��
	modcmd_t* const pt = reinterpret_cast<modcmd_t*>(hspmalloc(size));

	// �����l�Ŗ��߂�
	memset(pt + oldSize, 0xFF, size - oldSize);
#ifdef _DEBUG
	for ( size_t i = 0; i < cntElems; ++i ) { assert(pt[i] == VtModcmd::null); }
#endif

	// �����p��
	if ( pval2 ) {
		memcpy( pt, pval2->pt, pval2->size );
		hspfree( pval2->pt );
	}
	
	// pval �֐ݒ�
	pval->flag   = g_vtModcmd;
	pval->mode   = HSPVAR_MODE_MALLOC;
	pval->size   = size;
	pval->pt     = VtTraits::asPDAT<vtModcmd>(pt);
	pval->master = nullptr;
}

//------------------------------------------------
// PVal�̕ϐ����������������
//------------------------------------------------
static void HspVarModcmd_Free( PVal* pval )
{
	if ( pval->mode == HSPVAR_MODE_MALLOC ) {
		hspfree( pval->pt );
	}
	
	pval->pt   = nullptr;
	pval->mode = HSPVAR_MODE_NONE;
}

//------------------------------------------------
// ��� (=)
//------------------------------------------------
static void HspVarModcmd_Set( PVal* pval, PDAT* pdat, const PDAT* in )
{
	auto& dst = VtTraits::derefValptr<vtModcmd>(pdat);
	auto& src = VtTraits::derefValptr<vtModcmd>(in);
	
	dst = src;
	g_pHvpModcmd->aftertype = g_vtModcmd;
}

//------------------------------------------------
// ��r�֐� (���l���̂�)
// 
// @ �Q�ƃJ�E���^���g��Ȃ��̂ł�₱�����Ȃ��B
//------------------------------------------------
static void HspVarModcmd_EqI( PDAT* pdat, const PDAT* val )
{
	auto& lhs = VtTraits::derefValptr<vtModcmd>(pdat);
	auto& rhs = VtTraits::derefValptr<vtModcmd>(val);
	
	*reinterpret_cast<int*>(pdat) = HspBool(lhs == rhs);
	g_pHvpModcmd->aftertype = HSPVAR_FLAG_INT;
}

static void HspVarModcmd_NeI( PDAT* pdat, const PDAT* val )
{
	HspVarModcmd_EqI(pdat, val);
	VtTraits::derefValptr<vtInt>(pdat) = HspBool(VtTraits::derefValptr<vtInt>(pdat) == HspFalse);
}

//------------------------------------------------
// �o�^�֐�
//------------------------------------------------
void HspVarModcmd_Init( HspVarProc* p )
{
	g_pHvpModcmd     = p;
	g_vtModcmd       = p->flag;
	
	p->GetPtr       = HspVarModcmd_GetPtr;
	p->GetSize      = HspVarModcmd_GetSize;
	p->GetUsing     = HspVarModcmd_GetUsing;
	
	p->Alloc        = HspVarModcmd_Alloc;
	p->Free         = HspVarModcmd_Free;
	p->GetBlockSize = HspVarModcmd_GetBlockSize;
	p->AllocBlock   = HspVarModcmd_AllocBlock;
	
	p->Set          = HspVarModcmd_Set;
//	p->AddI         = HspVarModcmd_AddI;
	p->EqI          = HspVarModcmd_EqI;
	p->NeI          = HspVarModcmd_NeI;
	
	p->ArrayObjectRead = HspVarModcmd_ArrayObjectRead;	// �Q��(�E)
	p->ArrayObject     = HspVarModcmd_ArrayObject;		// �Q��(��)
//	p->ObjectWrite     = HspVarModcmd_ObjectWrite;		// �i�[
	
	// ���̑��ݒ�
	p->vartype_name = "modcmd_k";
	p->version      = 0x001;			// runtime ver(0x100 = 1.0)
	
	p->support							// �T�|�[�g�󋵃t���O(HSPVAR_SUPPORT_*)
		= HSPVAR_SUPPORT_STORAGE		// �Œ蒷�X�g���[�W
		| HSPVAR_SUPPORT_FLEXARRAY		// �ϒ��z��
	    | HSPVAR_SUPPORT_ARRAYOBJ		// �A�z�z��T�|�[�g
//	    | HSPVAR_SUPPORT_NOCONVERT		// ObjectWrite�Ŋi�[
	    | HSPVAR_SUPPORT_VARUSE			// varuse�֐���K�p
	    ;
	p->basesize = VtModcmd::basesize;	// size / �v�f (byte)
	return;
}

//#########################################################
//        �A�z�z��p�̊֐��Q
//#########################################################
//------------------------------------------------
// �A�z�z��::�Q�� (���Ӓl)
//------------------------------------------------
static void HspVarModcmd_ArrayObject( PVal* pval )
{
	code_expand_index_int( pval, false );
}

//------------------------------------------------
// �A�z�z��::�Q�� (�E�Ӓl)
//------------------------------------------------
static PDAT* HspVarModcmd_ArrayObjectRead( PVal* pval, int* mptype )
{
	// �z�� => �Y���ɑΉ�����v�f�̒l�����o���A�Ăяo���͍s��Ȃ�
	if ( pval->len[1] != 1 ) {
		code_expand_index_int( pval, true );
		
		*mptype = g_vtModcmd;
		return VtTraits::asPDAT<vtModcmd>(&VtModcmd::at(pval));
	}
	
	auto& modcmd = VtModcmd::at(pval);
	
	// �Ăяo�����s��Ȃ� (�o�O�΍�@�\)
	if ( *type == g_pluginModcmd && *val == ModcmdCmd::NoCall ) {
		code_next();
		*mptype = g_vtModcmd;
		return VtTraits::asPDAT<vtModcmd>(&modcmd);
		
	// �Ăяo��
	} else {
		PDAT* pResult = nullptr;
		*mptype = modcmdCall( modcmd, &pResult );
		return pResult;
	}
}

//------------------------------------------------
// �A�z�z��::�i�[
//------------------------------------------------
/*
static void HspVarModcmd_ObjectWrite( PVal* pval, void* data, int vflag )
{
	// �z�� => �Y���ɑΉ�����v�f�֑������A�Ăяo���͍s��Ȃ�
	if ( pval->len[1] != 1 ) {
		code_expand_index_int( pval, false );
		Modcmd::at(pval) = *reinterpret_cast<modcmd_t*>(data);
	}
	//
	throw;
}
//*/
