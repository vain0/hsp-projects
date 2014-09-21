// assoc - Command code

#include "vt_assoc.h"
#include "cmd_assoc.h"
#include "CAssoc.h"

#include "mod_makepval.h"
#include "mod_argGetter.h"
#include "reffuncResult.h"

using namespace hpimod;

static CAssoc* g_pAssocResult = nullptr;	// �ԋp�l�����L����

//------------------------------------------------
// assoc �^�̒l���󂯎��
// 
// @ mpval �� assoc �^�ƂȂ�B
//------------------------------------------------
CAssoc* code_get_assoc()
{
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	if ( mpval->flag != g_vtAssoc ) puterror( HSPERR_TYPE_MISMATCH );
	return *AssocTraits::asValptr(mpval->pt);
}

//------------------------------------------------
// assoc �̓����ϐ����󂯎��
//
// @ �����ϐ����w���Y�������Ă��Ȃ���΁Anullptr�B
//------------------------------------------------
PVal* code_get_assoc_pval()
{
	PVal* const pval = hpimod::code_get_var();
	return AssocTraits::getMaster(pval);
}

//------------------------------------------------
// assoc �^�̒l��ԋp����
//------------------------------------------------
int SetReffuncResult( PDAT** ppResult, CAssoc* const& pAssoc )
{
	CAssoc::Release( g_pAssocResult );
	g_pAssocResult = pAssoc;
	CAssoc::AddRef( g_pAssocResult );

	*ppResult = AssocTraits::asPDAT(const_cast<CAssoc**>( &pAssoc ));
	return g_vtAssoc;
}

//#########################################################
//        ����
//#########################################################
//------------------------------------------------
// �\�z (dim)
//------------------------------------------------
void AssocNew()
{
	PVal* const pval = code_getpval();
	int len[4];
	for ( int i = 0; i < 4; ++ i ) {
		len[i] = code_getdi(0);
	}

	exinfo->HspFunc_dim( pval, g_vtAssoc, 0, len[0], len[1], len[2], len[3] );
	return;
}

//------------------------------------------------
// �j��
//------------------------------------------------
void AssocDelete()
{
	PVal* const pval = code_get_var();
	if ( pval->flag != g_vtAssoc ) puterror( HSPERR_TYPE_MISMATCH );

	CAssoc*& self = *AssocTraits::getValptr(pval);
	if ( self ) {
		self->Release();
		self = nullptr;
	}
	return;
}

//------------------------------------------------
// �O���ϐ��̃C���|�[�g
//------------------------------------------------
static void AssocImportImpl( CAssoc* self, char const* src );

void AssocImport()
{
	CAssoc* const self = code_get_assoc();
	if ( !self ) puterror( HSPERR_ILLEGAL_FUNCTION );

	while ( code_isNextArg() ) {
		char const* const src = code_gets();
		AssocImportImpl( self, src );
	}
	return;
}

static void AssocImportImpl( CAssoc* const self, char const* const src )
{
	// ���W���[����
	if ( src[0] == '@' ) {
		puterror( HSPERR_UNSUPPORTED_FUNCTION );
		/*
		bool bGlobal = ( src[1] == '\0' );

		// ���ׂĂ̐ÓI�ϐ�����i�荞�݌���
		for ( int i = 0; i < ctx->hsphed->max_val; ++ i ) {
			char const* const name   = exinfo->HspFunc_varname( i );
			char const* const nameAt = strchr(name, '@');

			if (   ( bGlobal && nameAt == NULL )			// �O���[�o���ϐ�
				|| (!bGlobal && nameAt != NULL && !strcmp(nameAt + 1, src + 1) )	// ���W���[�����ϐ� (���W���[������v)
			) {
				self->Insert( name, &ctx->mem_var[i] );
			}
		}
		//*/

	// �ϐ���
	} else {
		PVal* const pval = hpimod::seekSttVar(src);
		if ( pval ) {
			self->Insert( src, pval );
		}
	}

	return;
}

//------------------------------------------------
// �L�[��}���E��������
// 
// @ �L�[�͈�̈����Ƃ��Ď󂯎��B
// @ �}���͂قږ��Ӗ��B
//------------------------------------------------
void AssocInsert()
{
	CAssocHolder self = code_get_assoc();
	char const* const key = code_gets();

	if ( !self ) puterror( HSPERR_ILLEGAL_FUNCTION );

	// �Q�Ƃ��ꂽ�����ϐ�
	PVal* const pvInner = self->At( key );

	// �����l (�ȗ��\)
	if ( code_getprm() > PARAM_END ) {
		int const fUserElem = pvInner->support & CAssoc::HSPVAR_SUPPORT_USER_ELEM;

		PVal_assign( pvInner, mpval->pt, mpval->flag );

		pvInner->support |= fUserElem;
	}

	return;
}

void AssocRemove()
{
	CAssocHolder self = code_get_assoc();
	char const* const key = code_gets();

	if ( !self ) puterror( HSPERR_ILLEGAL_FUNCTION );

	self->Remove( key );
	return;
}

//------------------------------------------------
// �����ϐ��� dim
// 
// @prm: [ assoc("key"), vartype, len1..4 ]
//------------------------------------------------
void AssocDim()
{
	PVal* const pvInner = code_get_assoc_pval();
	if ( !pvInner ) puterror( HSPERR_ILLEGAL_FUNCTION );

	int const fUserElem = pvInner->support & CAssoc::HSPVAR_SUPPORT_USER_ELEM;

	int const vflag = code_getdi( pvInner->flag );	// �^�^�C�v�l
	int len[4];
	for ( int i = 0; i < hpimod::ArrayDimMax; ++ i ) {
		len[i] = code_getdi(0);		// �v�f��
	}

	// �z��Ƃ��ď���������
	exinfo->HspFunc_dim( pvInner, vflag, 0, len[0], len[1], len[2], len[3] );

	pvInner->support |= fUserElem;
	return;
}

//------------------------------------------------
// �����ϐ��̃N���[�������
//------------------------------------------------
void AssocClone()
{
	PVal* const pvInner = code_get_assoc_pval();	// �N���[����
	PVal* const pval    = code_getpval();			// �N���[����

	if ( !pvInner || !pval ) puterror( HSPERR_ILLEGAL_FUNCTION );

	PVal_cloneVar( pval, pvInner );
	return;
}

//------------------------------------------------
// assoc �A�� | ����
//------------------------------------------------
static void AssocChainOrCopy( bool bCopy )
{
	CAssocHolder dst = code_get_assoc();
	CAssoc* const src = code_get_assoc();
	if ( !dst || !src ) puterror( HSPERR_ILLEGAL_FUNCTION );

	if ( bCopy ) {
		dst->Copy( src );
	} else {
		dst->Chain( src );
	}
	return;
}

void AssocCopy()  { AssocChainOrCopy( true  ); }
void AssocChain() { AssocChainOrCopy( false ); }

//------------------------------------------------
// assoc ����
//------------------------------------------------
void AssocClear()
{
	CAssoc* const self = code_get_assoc();
	if ( !self ) puterror( HSPERR_ILLEGAL_FUNCTION );

	self->Clear();
	return;
}

//#########################################################
//        �֐�
//#########################################################
//------------------------------------------------
// �\�z (�ꎞ�ϐ�)
//------------------------------------------------
int AssocNewTemp(PDAT** ppResult)
{
	return SetReffuncResult( ppResult, CAssoc::New() );	// ����� mpval �ɏ��L�����
}

//------------------------------------------------
// �\�z (����)
//------------------------------------------------
int AssocNewTempDup(PDAT** ppResult)
{
	CAssoc* const src = code_get_assoc();
	if ( !src ) puterror( HSPERR_ILLEGAL_FUNCTION );

	CAssoc* const newOne = CAssoc::New();
	newOne->Chain( src );
	return SetReffuncResult( ppResult, newOne );	// ����� mpval �ɏ��L�����
}

//------------------------------------------------
// null ��
//------------------------------------------------
int AssocIsNull(PDAT** ppResult)
{
	CAssoc* const self = code_get_assoc();
	return SetReffuncResult( ppResult, HspBool(self != nullptr));
}

//------------------------------------------------
// �����ϐ��̏��𓾂�
//------------------------------------------------
int AssocVarinfo(PDAT** ppResult)
{
	PVal* const pvInner = code_get_assoc_pval();
	if ( !pvInner ) puterror( HSPERR_ILLEGAL_FUNCTION );

	int const varinfo = code_getdi( VARINFO_NONE );
	int const opt     = code_getdi( 0 );

	switch ( varinfo ) {
		case VARINFO_FLAG:   return SetReffuncResult( ppResult, (int)pvInner->flag );
		case VARINFO_MODE:   return SetReffuncResult( ppResult, (int)pvInner->mode );
		case VARINFO_LEN:    return SetReffuncResult( ppResult, pvInner->len[opt + 1] );
		case VARINFO_SIZE:   return SetReffuncResult( ppResult, pvInner->size );
		case VARINFO_PT:     return SetReffuncResult( ppResult, (int)(getHvp(pvInner->flag))->GetPtr(pvInner) );
		case VARINFO_MASTER: return SetReffuncResult( ppResult, (int)pvInner->master );
		default:
			puterror( HSPERR_UNSUPPORTED_FUNCTION );
			throw;
	}
}

//------------------------------------------------
// �v�f��
//------------------------------------------------
int AssocSize(PDAT** ppResult)
{
	CAssoc* const self = code_get_assoc();
	int const size = (self ? self->Size() : 0);
	return SetReffuncResult(ppResult, size);
}

//------------------------------------------------
// �w��L�[�����݂��邩
//------------------------------------------------
int AssocExists(PDAT** ppResult)
{
	CAssocHolder self = code_get_assoc();
	char const* const key  = code_gets();

	return SetReffuncResult( ppResult, (int)(self ? self->Exists(key) : false) );
}

//------------------------------------------------
// AssocForeach �X�V����
//------------------------------------------------
int AssocForeachNext(PDAT** ppResult)
{
	CAssocHolder self = code_get_assoc();	// assoc
	PVal* const pval = code_get_var();		// iter (key)
	int const idx  = code_geti();

	bool bContinue =			// �����邩�ۂ�
		( !!self && idx >= 0
		&& static_cast<size_t>(idx) < self->Size()
		);

	if ( bContinue ) {
		auto iter = self->begin();

		for ( int i = 0; i < idx; ++ i )	// �v�f [idx] �ւ̔����q���擾����
			++ iter;

		// �L�[�̕������������
		code_setva( pval, pval->offset, HSPVAR_FLAG_STR, iter->first.c_str() );
	}

	return SetReffuncResult( ppResult, HspBool(bContinue) );
}

//------------------------------------------------
// assoc ��
//------------------------------------------------
static int const AssocResultExprMagicNumber = 0xA550C;

int AssocResult( PDAT** ppResult )
{
	if ( g_pAssocResult ) {			// �O�̂��������
		CAssoc::Release( g_pAssocResult );
		g_pAssocResult = nullptr;
	}

	g_pAssocResult = code_get_assoc();
	CAssoc::AddRef( g_pAssocResult );

	return SetReffuncResult(ppResult, AssocResultExprMagicNumber);
}

int AssocExpr( PDAT** ppResult )
{
	// AssocResult ���Ă΂��͂�
	if ( code_geti() != AssocResultExprMagicNumber ) puterror(HSPERR_ILLEGAL_FUNCTION);

	*ppResult = AssocTraits::asPDAT(&g_pAssocResult);
	return g_vtAssoc;
}

//------------------------------------------------
// �I�����֐�
//------------------------------------------------
void AssocTerm()
{
	CAssoc::Release( g_pAssocResult ); g_pAssocResult = nullptr;
	return;
}
