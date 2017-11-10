// CCall::CArgData
#if 0
#include <cstring>

#include "hsp3plugin_custom.h"
#include "mod_makepval.h"

#include "CCall.h"
#include "CArgData.h"
#include "CPrmInfo.h"

using namespace hpimod;

template<class T>
bool numrg(T const& val, T const& min, T const& max)
{
	return (min <= val && val <= max);
}
//#define LengthOf(arr) ( sizeof(arr) / sizeof(arr[0]) )

//#########################################################
//        �R���X�g���N�^�E�f�X�g���N�^
//#########################################################
//------------------------------------------------
// �\�z
//------------------------------------------------
CCall::CArgData::CArgData( CCall* pCall )
	: mpCall        ( pCall )
	, mpArgVal      ( &mArgVal )
	, mpIdxRef      ( &mIdxRef )
	, mpLocals      ( nullptr )
	, mCntArg       ( 0 )
{ }


//------------------------------------------------
// ���ʍ\�z
//------------------------------------------------
/*
CCall::CArgData::CArgData(const CCall::CArgData& obj)
{
	opCopy( obj );
	return;
}
//*/


//------------------------------------------------
// ���
// 
// @ �f�[�^�̉��
//------------------------------------------------
CCall::CArgData::~CArgData()
{
	// �����������ׂĉ������
	freeArgPVal();

	return;
}


//#########################################################
//        public�����o�֐��Q
//#########################################################
//------------------------------------------------
// = ( ���� )
//------------------------------------------------
/*
CCall::CArgData& CCall::CArgData::operator = (const CCall::CArgData& obj)
{
	return opCopy( obj );
}
//*/


//##########################################################
//    �ݒ�n
//##########################################################
//------------------------------------------------
// ������ǉ����� ( �Q�Ɠn�� )
//------------------------------------------------
void CCall::CArgData::addArgByRef( PVal* pval, APTR aptr )
{
	mpArgVal->push_back( pval );
	mpIdxRef->push_back( aptr );
	mCntArg ++;
	return;
}

//------------------------------------------------
// ������ǉ����� ( �l�n�� )
//------------------------------------------------
void CCall::CArgData::addArgByVal( void const* val, vartype_t vt )
{
	PVal* pvalarg  = new PVal;
	HspVarProc const* const vp = exinfo->HspFunc_getproc( vt );

	// �f�[�^�𕡎ʂ���( ������� )
	PVal_init( pvalarg, vt );
	vp->Set(
		pvalarg,
		vp->GetPtr(pvalarg),
		val
	);
//	code_setva( pvalarg, 0, pval->flag, vp->GetPtr(pval) );

	// �z��Ɋi�[
	mpArgVal->push_back(pvalarg);
	mpIdxRef->push_back(-1);
	mCntArg ++;
	return;
}

void CCall::CArgData::addArgByVal( PVal* pval )
{
	return addArgByVal( PVal_getptr(pval), pval->flag );
}

//------------------------------------------------
// ������ǉ����� ( �ϐ����� )
//------------------------------------------------
void CCall::CArgData::addArgByVarCopy( PVal* pval )
{
	PVal* pvalarg  = new PVal;
	HspVarProc* vp = exinfo->HspFunc_getproc( pval->flag );

	// �ϐ�����
	PVal_init( pvalarg, pval->flag );
	PVal_copy( pvalarg, pval );

	// �z��Ɋi�[
	mpArgVal->push_back(pvalarg);
	mpIdxRef->push_back(-1);
	mCntArg ++;
	return;
}

//------------------------------------------------
// ������ǉ����� ( �X�L�b�v )
//------------------------------------------------
void CCall::CArgData::addArgSkip( int lparam )
{
	// �z��Ɋi�[
	mpArgVal->push_back( nullptr );
	mpIdxRef->push_back( lparam );
	mCntArg ++;
	return;
}

//------------------------------------------------
// ���[�J���ϐ���ǉ�����
// 
// @ pval �� prmstack ��ɂ��� PVal �ւ̃|�C���^
//------------------------------------------------
void CCall::CArgData::addLocal( PVal* pval )
{
	PVal_init( pval, HSPVAR_FLAG_INT );

	if ( !mpLocals ) reserveLocals( 1 );
	mpLocals->push_back( pval );
	return;
}

//------------------------------------------------
// �����̐��� reserve ����
//------------------------------------------------
void CCall::CArgData::reserveArgs( size_t cnt )
{
	if ( cnt == 0 ) return;

	mpArgVal->reserve( cnt );
	mpIdxRef->reserve( cnt );
	return;
}

void CCall::CArgData::reserveLocals( size_t cnt )
{
	if ( cnt == 0 ) return;

	if ( !mpLocals ) mpLocals = new std::vector<PVal*>();

	mpLocals->reserve( cnt );
	return;
}

//------------------------------------------------
// �����������ׂď�������
//------------------------------------------------
void CCall::CArgData::clearArg()
{
	// �����������ׂĉ������
	for ( int i = 0; i < mCntArg; i ++ )
	 {
		PVal* const pArg = (*mpArgVal)[i];
		if ( !pArg ) continue;

		// �l�n�� => new PVal �Ȃ̂ŁA�������
		if ( (*mpIdxRef)[i] < 0 ) {
			PVal_free( pArg );
			delete pArg;
		}
	}

	// ���[�J���ϐ���S�ĉ������ (PVal ���̂� prmstack ��ɂ���̂ŉ�����Ȃ��Ă悢)
	if ( mpLocals ) {
		for ( size_t i = 0; i < mpLocals->size(); ++ i ) {
			PVal_free( (*mpLocals)[i] );
		}
		delete mpLocals; mpLocals = nullptr;
	}

	mCntArg = 0;

	mpArgVal->clear();
	mpIdxRef->clear();
	return;
}

//################################################
//    �擾�n
//################################################
//------------------------------------------------
// ������ PVal, APTR �𓾂�
//------------------------------------------------
PVal* CCall::CArgData::getArgPVal( int iArg ) const
{
	if ( !numrg(iArg, 0, mCntArg - 1) ) return nullptr;
	return (*mpArgVal)[ iArg ];
}


APTR CCall::CArgData::getArgAptr( int iArg ) const
{
	if ( !numrg(iArg, 0, mCntArg - 1) ) return 0;

	APTR aptr = (*mpIdxRef)[ iArg ];

	return (aptr >= 0 ? aptr : 0);
}


//------------------------------------------------
// �����̏����擾����
//------------------------------------------------
int CCall::CArgData::getArgInfo( ARGINFOID id, int iArg ) const
{
	// �����Ȃ�A�Ăяo���S�̂ɑ΂�����𓾂�
	if ( iArg < 0 ) {
		return mCntArg;		// �����̐�

	} else {
		PVal* const pval = (*mpArgVal)[iArg];
		switch ( id ) {
			case ARGINFOID_FLAG: return pval->flag;
			case ARGINFOID_MODE: return pval->mode;
			case ARGINFOID_LEN1: return pval->len[1];
			case ARGINFOID_LEN2: return pval->len[2];
			case ARGINFOID_LEN3: return pval->len[3];
			case ARGINFOID_LEN4: return pval->len[4];
			case ARGINFOID_SIZE: return pval->size;
			case ARGINFOID_PTR : 
			{
				HspVarProc* const vp = getHvp( pval->flag );
				return reinterpret_cast<int>(
					vp->GetPtr(pval)
				);
			}
			case ARGINFOID_BYREF: return HspBool( (*mpIdxRef)[ iArg ] >= 0 );

			default:
				return 0;
		}
	}
}

//------------------------------------------------
// �X�L�b�v���ꂽ�������H (�s��������)
//------------------------------------------------
bool CCall::CArgData::isArgSkipped( int iArg ) const
{
	if ( !numrg(iArg, 0, mCntArg - 1) ) return false;
	return ( getArgPVal( iArg ) == nullptr );
}

//------------------------------------------------
// ���[�J���ϐ����擾
//------------------------------------------------
PVal* CCall::CArgData::getLocal( int iLocal ) const
{
	if ( !mpLocals || !numrg<int>( iLocal, 0, mpLocals->size() - 1 ) ) return nullptr;
	return (*mpLocals)[ iLocal ];
}

//#########################################################
//        private�����o�֐��Q
//#########################################################
//------------------------------------------------
// ����
//------------------------------------------------
/*
CCall::CArgData& CCall::CArgData::opCopy(const CCall::CArgData& obj)
{
	this->~CArgData();
	mpArgVal = new std::vector<PVal*>;
	mpIdxRef = new std::vector<APTR>;

	// CCall �|�C���^�̕���
	mpCall = obj.mpCall;

	// this �f�[�^�̕���
	setThis( obj.getThisPVal(), obj.getThisAptr() );

	// �������f�[�^�̕���
	mpArgVal->reserve( obj.getCntArg() );
	mpIdxRef->reserve( obj.getCntArg() );

	for ( int i = 0; i < obj.getCntArg(); ++ i ) {
		PVal* pval = obj.getArgPVal(i);
		APTR aptr  = obj.getArgAptr(i);

		// �l�n��
		if ( aptr < 0 ) {
			addArgByVal( pval );

		// �Q�Ɠn��
		} else {
			addArgByRef( pval, aptr );
		}
	}

	return *this;
}
//*/

//------------------------------------------------
// �������̉��
//------------------------------------------------
void CCall::CArgData::freeArgPVal(void)
{
	clearArg();

//	delete mpArgVal; mpArgVal = nullptr;
//	delete mpIdxRef; mpIdxRef = nullptr;

	return;
}

//#########################################################
//        �������֐��Q
//#########################################################
#endif