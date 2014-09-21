// CAssoc ����

#include "CAssoc.h"
#include "mod_makepval.h"

using namespace hpimod;

//------------------------------------------------
// ����
//------------------------------------------------
CAssoc::CAssoc()
	: map_()
	, cnt_(0)
{
#ifdef DBGOUT_ASSOC_ADDREF_OR_RELEASE
	static int stt_counter = 1;
	id_ = stt_counter ++;
//	dbgout("[%d] new", id_);
#endif
	return;
}

CAssoc* CAssoc::New()
{
	return new CAssoc();
}

//------------------------------------------------
// �j��
//------------------------------------------------
CAssoc::~CAssoc()
{
	Clear();
	return;
}

void CAssoc::Delete( CAssoc* self )
{
	delete self;
	return;
}

//------------------------------------------------
// �v�f�A�N�Z�X
//------------------------------------------------
PVal* CAssoc::AtSafe( Key_t const& key ) const
{
	auto iter = map_.find( key );
	return ( iter != map_.end() )
		? iter->second
		: nullptr;
}

// ���݂��Ȃ���ΐV�K�v�f��}������
PVal* CAssoc::At( Key_t const& key )
{
	return Insert( key );
}

//------------------------------------------------
// �v�f�̑���
//------------------------------------------------
bool CAssoc::Exists( Key_t const& key ) const
{
	return (map_.find(key) != map_.end());
}

//------------------------------------------------
// �v�f�̐����E�폜
//------------------------------------------------
PVal* CAssoc::NewElem()
{
	PVal* pval = (PVal*)hspmalloc( sizeof(PVal) );
	// HSPVAR_SUPPORT_USER_ELEM �̕t�����`��
	return pval;
}

PVal* CAssoc::NewElem( int vflag )
{
	PVal* pval = NewElem();
	PVal_init( pval, vflag );
	pval->support |= HSPVAR_SUPPORT_USER_ELEM;
	return pval;
}

PVal* CAssoc::ImportElem( PVal* pval )
{
	return pval;
}

void CAssoc::DeleteElem( PVal* pval )
{
	if ( pval->support & HSPVAR_SUPPORT_USER_ELEM ) {
		PVal_free( pval );
		hspfree( pval );
	}
	return;
}

//------------------------------------------------
// �v�f�̑}���E����
//------------------------------------------------
PVal* CAssoc::Insert( Key_t const& key )
{
	PVal* pvElem = AtSafe(key);
	if ( pvElem ) return pvElem;

	PVal* const pval = NewElem(HSPVAR_FLAG_INT);
	map_.insert({ key, pval });
	return pval;
}

PVal* CAssoc::Insert( Key_t const& key, PVal* pval )
{
	PVal* pvElem = AtSafe(key);
	if ( pvElem || !pval ) return pvElem;

	map_.insert({ key, pval });
	return pval;
}

void CAssoc::Remove( Key_t const& key )
{
	DeleteElem( AtSafe(key) );
	map_.erase( key );
	return;
}

//------------------------------------------------
// assoc �A��
//
// @ �d���v�f�͏㏑������
//------------------------------------------------
void CAssoc::Chain( CAssoc const* src )
{
	if ( !src ) return;

	for ( auto iter : map_ ) {
		if ( !iter.second ) continue;

		// �d�� => �����v�f����������
		auto elem = map_.find( iter.first );
		if ( elem != map_.end() ) {
			Remove( iter.first );
		}

		// �����ϐ��̕��������
		PVal* pvElem;
		if ( iter.second->support & HSPVAR_SUPPORT_USER_ELEM ) {
			pvElem = NewElem( HSPVAR_FLAG_INT );		// �y�ʏ�����
			PVal_copy( pvElem, iter.second );			// �ϐ��͍Ċm�ۂ����
			pvElem->support |= HSPVAR_SUPPORT_USER_ELEM;
		} else {
			pvElem = iter.second;		// ���L
		}

		// �L�[�̓����v�f�𐶐�����
		Insert( iter.first, pvElem );
	}

	return;
}

//------------------------------------------------
// assoc ����
//
// @ �S�Ă̗v�f����菜���B
//------------------------------------------------
void CAssoc::Clear()
{
	for ( auto iter : *this ) {
		DeleteElem( iter.second );
	}
	map_.clear();
	return;
}
