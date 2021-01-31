// PVal �̓Ǝ��Ǘ�

#include <stdlib.h>
#include <string.h>

#include "mod_makepval.h"

//##########################################################
//    �錾
//##########################################################
static PVal* PVal_initDefault(vartype_t vt);

//##########################################################
//    �֐�
//##########################################################
//------------------------------------------------
// PVal�\���̂̏�����
// 
// @ (pval == NULL) => �������Ȃ��B
// @prm pval: �����������(�S�����o���s��l)�ł���
//------------------------------------------------
void PVal_init(PVal* pval, vartype_t vflag)
{
	if ( pval == NULL ) return;
	
	pval->flag = vflag;
	pval->mode = HSPVAR_MODE_NONE;
	PVal_alloc( pval );
	return;
}

//------------------------------------------------
// �����ƊȒP�ŗL����PVal�\���̂ɂ���
// 
// @ (pval == NULL || vflag == ����) => �������Ȃ��B
// @ HspVarCoreDim �̑��� (�z��Y���͎w��ł��Ȃ���)�B
//------------------------------------------------
void PVal_alloc(PVal* pval, PVal* pval2, vartype_t vflag)
{
	if ( pval  == NULL ) return;
	if ( vflag <= HSPVAR_FLAG_NONE ) vflag = pval->flag;
	
	HspVarProc* vp = GetHvp( vflag );
	
	// pt ���m�ۂ���Ă���ꍇ�A�������
	if ( pval->flag != HSPVAR_FLAG_NONE && pval->mode == HSPVAR_MODE_MALLOC ) {
		PVal_free( pval );
	}
	
	// �m�ۏ���
	memset( pval, 0x00, sizeof(PVal) );
	pval->flag    = vflag;
	pval->mode    = HSPVAR_MODE_NONE;
	pval->support = vp->support;
	vp->Alloc( pval, pval2 );
	return;
}

//------------------------------------------------
// PVal�\���̂��ȒP�ɏ���������
// 
// @ �ł��ȒP�Ȍ`�Ŋm�ۂ����B
// @ HspVarCoreClear �̑���B
//------------------------------------------------
void PVal_clear(PVal* pval, vartype_t vflag)
{
	PVal_alloc( pval, NULL, vflag );
}

//------------------------------------------------
// PVal �\���̂̒��g���������
// 
// @ (pval == NULL) => �������Ȃ��B
// @ pval �|�C���^���͔̂j�󂳂�Ȃ��B
//------------------------------------------------
void PVal_free(PVal* pval)
{
	if ( pval == NULL ) return;
	
	HspVarProc* vp = GetHvp( pval->flag );
	vp->Free( pval );
	
	return;
}

//------------------------------------------------
// ����l��\�� PVal �\���̂�������
// @private
// @ vt �͕K���L���Ȓl (str �` int)�B
//------------------------------------------------
static PVal* PVal_initDefault(vartype_t vt)
{
	static PVal** stt_pDefPVal   = NULL;
	static int    stt_cntDefPVal = 0;
	
	// stt_pDefPVal �̊g��
	if ( stt_cntDefPVal <= vt ) {
		int cntNew = vt + 1;
		
		if ( stt_pDefPVal == NULL ) {
			stt_pDefPVal = (PVal**)hspmalloc( cntNew * sizeof(PVal*) );
			
		} else {
			stt_pDefPVal = (PVal**)hspexpand(
				reinterpret_cast<char*>( stt_pDefPVal ),
				cntNew * sizeof(PVal*)
			);
		}
		
		// �g������ NULL �ŏ���������
		for( int i = stt_cntDefPVal; i < cntNew; ++ i ) {
			stt_pDefPVal[i] = NULL;
		}
		
		stt_cntDefPVal = cntNew;
	}
	
	// ���������̏ꍇ�́APVal �̃��������m�ۂ��A����������
	if ( stt_pDefPVal[vt] == NULL ) {
		stt_pDefPVal[vt] = (PVal*)hspmalloc( sizeof(PVal) );
		PVal_init( stt_pDefPVal[vt], vt );
	}
	return stt_pDefPVal[vt];
}

//------------------------------------------------
// ����l��\�� PVal �\���̂ւ̃|�C���^�𓾂�
// 
// @ vt ���s���ȏꍇ�ANULL ��Ԃ��B
//------------------------------------------------
PVal* PVal_getDefault( vartype_t vt )
{
	if ( vt <= HSPVAR_FLAG_NONE ) {
		return NULL;
		
	} else {
		return PVal_initDefault( vt );
	}
}

//##########################################################
//        �ϐ����̎擾
//##########################################################
//------------------------------------------------
// �ϐ��̗v�f�̑�����Ԃ�
//------------------------------------------------
size_t PVal_cntElems( PVal* pval )
{
	int cntElems = 1;
	
	// �v�f���𒲂ׂ�
	for ( unsigned int i = 0; i < ArrayDimCnt; ++ i ) {
		if ( pval->len[i + 1] ) {
			cntElems *= pval->len[i + 1];
		}
	}
	
	return cntElems;
}

//------------------------------------------------
// �ϐ��̃T�C�Y��Ԃ�
// 
// @ pval->offset ������B
// @ �Œ蒷�^�Ȃ� HspVarProc::basesize ���A
// @	�ϒ��^�Ȃ�A�w��v�f�̃T�C�Y���B
//------------------------------------------------
size_t PVal_size( PVal* pval )
{
	HspVarProc* vp = GetHvp( pval->flag );
	
	if ( vp->basesize < 0 ) {
		return vp->GetSize( (PDAT*)(pval->pt) );
	} else {
		return vp->basesize;
	}
}

//------------------------------------------------
// �ϐ�������̃|�C���^�𓾂�
// 
// @ pval->offset ������B
//------------------------------------------------
PDAT* PVal_getptr( PVal* pval )
{
	return (GetHvp(pval->flag))->GetPtr( pval );
}

//##########################################################
//        �ϐ��ɑ΂��鑀��
//##########################################################
//------------------------------------------------
// PVal�֒l���i�[���� (�ėp)
// 
// @ pval �̓Y����Ԃ��Q�Ƃ���B
//------------------------------------------------
void PVal_assign( PVal* pval, void* pData, vartype_t vflag )
{
	// �Y������ => ObjectWrite
	if ( (pval->support & HSPVAR_SUPPORT_NOCONVERT) && (pval->arraycnt != 0) ) {
		(GetHvp( pval->flag ))->ObjectWrite( pval, pData, vflag );
		
	// �ʏ�̑��
	} else {
		code_setva( pval, pval->offset, vflag, pData );
	}
	return;
}

//------------------------------------------------
// PVal�̕���
// 
// @ �S�v�f�𕡎ʂ���B
//------------------------------------------------
void PVal_copy(PVal* pvDst, PVal* pvSrc)
{
	if ( pvDst == pvSrc ) return;
	
	int cntElems = PVal_cntElems(pvSrc);
	
	// pvDst ���m�ۂ���
	exinfo->HspFunc_dim(
		pvDst, pvSrc->flag, 0, pvSrc->len[1], pvSrc->len[2], pvSrc->len[3], pvSrc->len[4]
	);
	
	// �P���ϐ� => ���v�f��������̂�
	if ( cntElems == 1 ) {
		PVal_assign( pvDst, pvSrc->pt, pvSrc->flag );
		
	// �A��������� => ���ׂĂ̗v�f��������
	} else {
		HspVarProc* pHvpSrc = GetHvp( pvSrc->flag );
		
		pvDst->arraycnt = 1;
		for ( int i = 0; i < cntElems; ++ i ) {
			pvDst->offset = i;
			pvSrc->offset = i;
			
			PVal_assign( pvDst, pHvpSrc->GetPtr( pvSrc ), pvSrc->flag );
		}
	}
	return;
}

//------------------------------------------------
// �ϐ����N���[���ɂ���
// 
// @ HspVarCoreDup, HspVarCoreDupPtr
//------------------------------------------------
void PVal_clone( PVal* pvDst, PVal* pvSrc, APTR aptrSrc )
{
	HspVarProc* vp = GetHvp( pvSrc->flag );
	
	if ( aptrSrc >= 0 ) pvSrc->offset = aptrSrc;
	PDAT* pSrc = vp->GetPtr(pvSrc);			// ���̃|�C���^
	
	int size;								// �N���[���ɂ���T�C�Y
	vp->GetBlockSize( pvSrc, pSrc, &size );
	
	// ���̃|�C���^����N���[�������
	PVal_clone( pvDst, pSrc, pvSrc->flag, size );
	return;
}

void PVal_clone( PVal* pval, void* ptr, int flag, int size )
{
	HspVarProc* vp = GetHvp(flag);
	
	vp->Free( pval );
	pval->pt = (char*)ptr;
	pval->flag = flag;
	pval->size = size;
	pval->mode = HSPVAR_MODE_CLONE;
	pval->len[0] = 1;
	
	if ( vp->basesize < 0 ) {
		pval->len[1] = 1;
	} else {
		pval->len[1] = size / vp->basesize;
	}
	pval->len[2] = 0;
	pval->len[3] = 0;
	pval->len[4] = 0;
	pval->offset = 0;
	pval->arraycnt = 0;
	pval->support = HSPVAR_SUPPORT_STORAGE;
	return;
}

//------------------------------------------------
// �l���V�X�e���ϐ��ɑ������
//------------------------------------------------
void SetResultSysvar(const void* pValue, vartype_t vflag)
{
	if ( pValue == NULL ) return;
	
	ctx->retval_level = ctx->sublev;
	
	switch ( vflag ) {
		case HSPVAR_FLAG_INT:
			ctx->stat = *reinterpret_cast<const int*>( pValue );
			break;
			
		case HSPVAR_FLAG_STR:
			strncpy(
				ctx->refstr,
				reinterpret_cast<const char*>( pValue ),
				HSPCTX_REFSTR_MAX - 1
			);
			break;
			
		case HSPVAR_FLAG_DOUBLE:
			ctx->refdval = *reinterpret_cast<const double*>( pValue );
			break;
			
		default:
			puterror( HSPERR_TYPE_MISMATCH );
	}
	return;
}

//------------------------------------------------
// ���̃|�C���^���^�ϊ�����
//------------------------------------------------
const PDAT* Valptr_cnvTo( const PDAT* pValue, vartype_t vtSrc, vartype_t vtDst )
{
	return (const PDAT*)(
		( vtSrc < HSPVAR_FLAG_USERDEF )
			? GetHvp(vtDst)->Cnv( pValue, vtSrc )
			: GetHvp(vtSrc)->CnvCustom( pValue, vtDst )
	);
}
