// assoc - VarProc code

#include "CAssoc.h"
#include "vt_assoc.h"

#include "hsp3plugin_custom.h"
#include "mod_makepval.h"
#include "mod_argGetter.h"
#include "vp_template.h"

#include "for_knowbug.var_assoc.h"

using namespace hpimod;

// �ϐ��̒�`
int g_vtAssoc;
HspVarProc* g_hvpAssoc;

// �֐��̐錾
extern PDAT* HspVarAssoc_GetPtr         ( PVal* pval) ;
extern int   HspVarAssoc_GetSize        ( PDAT const* pdat );
extern int   HspVarAssoc_GetUsing       ( PDAT const* pdat );
extern PDAT* HspVarAssoc_GetBlockSize   ( PVal* pval, PDAT* pdat, int* size );
extern void  HspVarAssoc_AllocBlock     ( PVal* pval, PDAT* pdat, int  size );
extern void  HspVarAssoc_Alloc          ( PVal* pval, PVal const* pval2 );
extern void  HspVarAssoc_Free           ( PVal* pval);
extern PDAT* HspVarAssoc_ArrayObjectRead( PVal* pval, int* mptype );
extern void  HspVarAssoc_ArrayObject    ( PVal* pval);
extern void  HspVarAssoc_ObjectWrite    ( PVal* pval, PDAT const* data, int vflag );
extern void  HspVarAssoc_ObjectMethod   ( PVal* pval);

static StAssocMapList* HspVarAssoc_GetMapList( CAssoc* src );	// void* user

//------------------------------------------------
// Core
//------------------------------------------------
static PDAT* HspVarAssoc_GetPtr( PVal* pval )
{
	return AssocTraits::asPDAT(AssocTraits::getValptr(pval));
}

//------------------------------------------------
// Using
//------------------------------------------------
static int HspVarAssoc_GetUsing( PDAT const* pdat )
{
	return HspBool(AssocTraits::derefValptr(pdat) != nullptr);
}

//------------------------------------------------
// PVal�̕ϐ����������m�ۂ���
//
// @ pval �͖��m�� or ����ς݂̏�ԁB
// @ pval2 != nullptr => pval2�̓��e���p������B
//------------------------------------------------
static void HspVarAssoc_Alloc( PVal* pval, PVal const* pval2 )
{
	if ( pval->len[1] < 1 ) pval->len[1] = 1;		// �Œ�1�v�f�͊m�ۂ���
	size_t const cntElems = PVal_cntElems( pval );
	size_t const     size = cntElems * sizeof(CAssoc*);

	// �o�b�t�@�m��
	auto const pt = reinterpret_cast<CAssoc**>(hspmalloc(size));
	std::memset(pt, 0, size);

	// �p��
	if ( pval2 ) {
		std::memcpy( pt, pval2->pt, pval2->size );
		hspfree( pval2->pt );
	}

	// ������
	for ( size_t i = 0; i < cntElems; ++ i ) {
		if ( !pt[i] ) {
			pt[i] = CAssoc::New();
			pt[i]->AddRef();
		}
	}

	// pval �֐ݒ�
	pval->flag   = g_vtAssoc;	// assoc �̌^�^�C�v�l
	pval->mode   = HSPVAR_MODE_MALLOC;
	pval->size   = size;
	pval->pt     = AssocTraits::asPDAT(pt);
	pval->master = nullptr;		// ��Ŏg��
	return;
}

//------------------------------------------------
// PVal�̕ϐ����������������
//------------------------------------------------
static void HspVarAssoc_Free( PVal* pval )
{
	if ( pval->mode == HSPVAR_MODE_MALLOC ) {
		// �S�Ă̗v�f�� Release
		auto const pt = reinterpret_cast<CAssoc**>(pval->pt);
		size_t const cntElems = PVal_cntElems( pval );

		for ( size_t i = 0; i < cntElems; ++ i ) {
			CAssoc::Release( pt[i] );
		}

		// �o�b�t�@�����
		hspfree( pval->pt );
	}

	pval->pt   = nullptr;
	pval->mode = HSPVAR_MODE_NONE;
	return;
}

//------------------------------------------------
// ��� (=)
// 
// @ �Q�Ƌ��L
//------------------------------------------------
static void HspVarAssoc_Set( PVal* pval, PDAT* pdat, PDAT const* in )
{
	auto& dst = AssocTraits::derefValptr(pdat);
	auto& src = AssocTraits::derefValptr(in);

	if ( dst != src ) {
		CAssoc::Release( dst );
		dst = src;
		CAssoc::AddRef( dst );
	}

	g_hvpAssoc->aftertype = g_vtAssoc;
	return;
}

/*
//------------------------------------------------
// �}�[�W (+)
// 
// @ ���E�̎��L�[�𕹂����� Assoc �𐶐����A�Ԃ��B
//------------------------------------------------
static void HspVarAssoc_AddI( PDAT* pdat, void const* val )
{

}
//*/

/*
//------------------------------------------------
// ��r�֐� (�Q�Ɠ��l����r)
// 
// @ pdat �� Assoc �̃e���|�����ϐ��� mpval->pt �Ȃ̂ŁA
// @	�l��������ƁA���ӂ̎Q�Ƃ�1����ɏ����邱�ƂɂȂ�B
// @	���̂��߁A�\�ߍ��ӂ̎Q�Ƃ� Release ���Ă����B
//------------------------------------------------
static void HspVarAssoc_EqI( PDAT* pdat, void const* val )
{
	CAssoc*& lhs = *(CAssoc**)pdat;
	CAssoc*& rhs = *(CAssoc**)val;

	if (lhs) lhs->Release();

	*(int*)pdat = (int)( (lhs == rhs) ? CAssoc::New() : NULL );
	g_hvpAssoc->aftertype = HSPVAR_FLAG_INT;
	return;
}

static void HspVarAssoc_NeI( PDAT* pdat, void const* val )
{
	CAssoc*& lhs = *(CAssoc**)pdat;
	CAssoc*& rhs = *(CAssoc**)val;

	if (lhs) lhs->Release();

	*(int*)pdat = (int)( (lhs != rhs) ? CAssoc::New() : NULL );
	g_hvpAssoc->aftertype = HSPVAR_FLAG_INT;
	return;
}
//*/

//------------------------------------------------
// Assoc �o�^�֐�
//------------------------------------------------
void HspVarAssoc_Init( HspVarProc* p )
{
	g_hvpAssoc      = p;
	g_vtAssoc       = p->flag;

	// �֐��|�C���^��o�^
	p->GetUsing = HspVarAssoc_GetUsing;

	p->Alloc = HspVarAssoc_Alloc;
	p->Free  = HspVarAssoc_Free;

	p->GetPtr       = HspVarTemplate_GetPtr<assoc_tag>;
	p->GetSize      = HspVarTemplate_GetSize<assoc_tag>;
	p->GetBlockSize = HspVarTemplate_GetBlockSize<assoc_tag>;
	p->AllocBlock   = HspVarTemplate_AllocBlock<assoc_tag>;

	// ���Z�֐�
	p->Set  = HspVarAssoc_Set;
//	p->AddI = HspVarAssoc_AddI;
//	p->EqI  = HspVarAssoc_EqI;
//	p->NeI  = HspVarAssoc_NeI;

	// �A�z�z��p
	p->ArrayObjectRead = HspVarAssoc_ArrayObjectRead;	// �Q��(�E)
	p->ArrayObject     = HspVarAssoc_ArrayObject;		// �Q��(��)
	p->ObjectWrite     = HspVarAssoc_ObjectWrite;		// �i�[
	p->ObjectMethod    = HspVarAssoc_ObjectMethod;		// ���\�b�h

	// �g���f�[�^
	p->user = reinterpret_cast<char*>(HspVarAssoc_GetMapList);

	// ���̑��ݒ�
	p->vartype_name = "assoc_k";		// �^�C�v�� (�Փ˂��Ȃ��悤�ɕςȖ��O�ɂ���)
	p->version      = 0x001;			// runtime ver(0x100 = 1.0)

	p->support							// �T�|�[�g�󋵃t���O(HSPVAR_SUPPORT_*)
		= HSPVAR_SUPPORT_STORAGE		// �Œ蒷�X�g���[�W
		| HSPVAR_SUPPORT_FLEXARRAY		// �ϒ��z��
	    | HSPVAR_SUPPORT_ARRAYOBJ		// �A�z�z��T�|�[�g
	    | HSPVAR_SUPPORT_NOCONVERT		// ObjectWrite�Ŋi�[
	    | HSPVAR_SUPPORT_VARUSE			// varuse�֐���K�p
	    ;
	p->basesize = AssocTraits::basesize;	// size / �v�f (byte)
	return;
}

//#########################################################
//        �A�z�z��p�̊֐��Q
//#########################################################
//------------------------------------------------
// �A�z�z��::�Y������
// 
// @ ( (idx...(0�`4��), "�L�[", (idx...(�����ϐ�)) )
// @ �����ϐ��̓Y���̏����́A�Ăяo�������s���B
// @result: �����ϐ� or nullptr(assoc���̂��Q�Ƃ��ꂽ)
//------------------------------------------------
template<bool bAsRhs>
static PVal* HspVarAssoc_IndexImpl( PVal* pval )
{
	if ( *type == TYPE_MARK && *val == ')' ) return nullptr;	// �Y����Ԃ��X�V���Ȃ�

	bool bKey = false;		// �L�[����������

	// [1] assoc ���̂̓Y���ƁA�L�[���擾

	HspVarCoreReset( pval );		// �Y���ݒ�̏�����
	for ( int i = 0; i < (ArrayDimMax + 1) && code_isNextArg(); ++ i )
	{
		PVal pvalTemp;
		HspVarCoreCopyArrayInfo( &pvalTemp, pval );		// �Y����Ԃ�ۑ�
		int const chk = code_getprm();
		HspVarCoreCopyArrayInfo( pval, &pvalTemp );

		if ( chk == PARAM_DEFAULT ) {
			// �ϐ����̂̎Q�� ( (, idxFullSlice) )
			if ( i == 0 && code_getdi(0) == assocIndexFullslice ) {
				pval->master = nullptr; return nullptr;
			}
			puterror(HSPERR_NO_DEFAULT);
		}
		if ( chk <= PARAM_END ) break;

		// int (�ő�4�A��)
		if ( mpval->flag == HSPVAR_FLAG_INT ) {
			if ( pval->len[i + 1] <= 0 || i == 4 ) puterror( HSPERR_ARRAY_OVERFLOW );

			code_index_int( pval, VtTraits<int>::derefValptr(mpval->pt), !bAsRhs );

		// str (�L�[)
		} else if ( mpval->flag == HSPVAR_FLAG_STR ) {
			bKey = true;
			++ pval->arraycnt;
			break;
		}
	}

	// [2] �Q�Ɛ� (assoc or �����ϐ�) ������

	if ( !bKey ) {		// �L�[�Ȃ� => assoc ���̂ւ̎Q��
		pval->master = nullptr;
		return nullptr;
	}

	assert(mpval->flag == HSPVAR_FLAG_STR);
	static CAssoc::Key_t stt_key;
	stt_key = (char*)mpval->pt;		// �����̕ϐ��Ɋi�[������������ (�ꎞ�I�u�W�F�N�g�����Ȃ�����)

	auto const pAssoc = AssocTraits::getValptr(pval);
	if ( !*pAssoc ) {
		(*pAssoc) = CAssoc::New();
		(*pAssoc)->AddRef();
	}

	PVal* const pvInner = (!bAsRhs
		? (*pAssoc)->At( stt_key )		// ���Ӓl => �����g������
		: (*pAssoc)->AtSafe( stt_key )	// �E�Ӓl => �����g���Ȃ�
	);

	if ( bAsRhs && !pvInner ) puterror( HSPERR_ARRAY_OVERFLOW );

	pval->master = pvInner;
	return pvInner;
}

//------------------------------------------------
// �A�z�z��::�Q�� (���Ӓl)
//------------------------------------------------
static void HspVarAssoc_ArrayObject( PVal* pval )
{
	PVal* const pvInner = HspVarAssoc_IndexImpl<false>( pval );
	if ( !pvInner ) return;

	// [3] �����ϐ��̓Y��������
	if ( code_isNextArg() ) {			// �Y���������ꍇ
		code_expand_index_lhs( pvInner );
	} else {
		if ( PVal_supportArray(pvInner) && !(pvInner->support & HSPVAR_SUPPORT_ARRAYOBJ) ) {	// �W���z��T�|�[�g
			HspVarCoreReset( pvInner );		// �Y����Ԃ̏������������Ă���
		}
	}

	return;
}

//------------------------------------------------
// �A�z�z��::�Q�� (�E�Ӓl)
//------------------------------------------------
static PDAT* HspVarAssoc_ArrayObjectRead( PVal* pval, int* mptype )
{
	PVal* const pvInner = HspVarAssoc_IndexImpl<true>( pval );

	// assoc ���̂̎Q��
	if ( !pvInner ) {
		*mptype = g_vtAssoc;
		return AssocTraits::asPDAT(AssocTraits::getValptr( pval ));
	}

	// [3] �����ϐ��̓Y��������
	if ( code_isNextArg() ) {			// �Y���������ꍇ
		return code_expand_index_rhs( pvInner, *mptype );
	} else {
		if ( PVal_supportArray(pvInner) && !(pvInner->support & HSPVAR_SUPPORT_ARRAYOBJ) ) {	// �W���z��T�|�[�g
			HspVarCoreReset( pvInner );		// �Y����Ԃ̏������������Ă���
		}

		*mptype = pvInner->flag;
		return getHvp( pvInner->flag )->GetPtr( pvInner );
	}
}

//------------------------------------------------
// �A�z�z��::�i�[
//------------------------------------------------
static void HspVarAssoc_ObjectWrite( PVal* pval, PDAT const* data, int vflag )
{
	PVal* const pvInner = AssocTraits::getMaster(pval);

	// assoc �ւ̑��
	if ( !pvInner ) {
		if ( vflag != g_vtAssoc ) puterror( HSPERR_INVALID_ARRAYSTORE );	// �E�ӂ̌^���s��v

		HspVarAssoc_Set( pval, HspVarAssoc_GetPtr(pval), data );
		code_assign_multi( pval );				// �A������̏���

	// �����ϐ����Q�Ƃ��Ă���ꍇ
	} else {
		int const fUserElem = pvInner->support & CAssoc::HSPVAR_SUPPORT_USER_ELEM;

		PVal_assign( pvInner, data, vflag );	// �����ϐ��ւ̑������
		code_assign_multi( pvInner );

		pvInner->support |= fUserElem;
	}

	return;
}

//------------------------------------------------
// ���\�b�h�Ăяo��
// 
// @ �����ϐ��̌^�Œ񋟂���Ă��郁�\�b�h���g��
//------------------------------------------------
static void HspVarAssoc_ObjectMethod(PVal* pval)
{
	PVal* const pvInner = AssocTraits::getMaster(pval);
	if ( !pvInner ) puterror( HSPERR_UNSUPPORTED_FUNCTION );

	// �����ϐ��̏����ɓ]��
	getHvp(pvInner->flag)->ObjectMethod( pvInner );
	return;
}

//------------------------------------------------
// ���ׂẴL�[��񋓂���
// 
// @ for knowbug
// @ ���X�g�̍폜�����͌Ăяo�����ɂ���B
//------------------------------------------------
// [[deprecated]]
static StAssocMapList* HspVarAssoc_GetMapList( CAssoc* src )
{
	if ( !src || src->Empty() ) return nullptr;

	StAssocMapList* head = nullptr;
	StAssocMapList* tail = nullptr;

	for ( auto iter : *src ) {
		auto const list = reinterpret_cast<StAssocMapList*>(hspmalloc(sizeof(StAssocMapList)));

		lstrcpy( list->key, iter.first.c_str() );
		list->pval = iter.second;

		// �A��
		if ( !head ) {
			head = list;
		} else {
			tail->next = list;
		}
		tail = list;
	}
	if ( tail ) tail->next = nullptr;

	return head;
}

//------------------------------------------------
// knowbug �ł̊g���^�\���ɑΉ�����
//------------------------------------------------
#include "knowbug/knowbugForHPI.h"

EXPORT void WINAPI knowbugVsw_addValueAssoc(vswriter_t _w, char const* name, PDAT const* ptr)
{
	auto const kvswm = knowbug_getVswMethods();
	if ( !kvswm ) return;

	auto const src = AssocTraits::derefValptr(ptr);

	// null
	if ( !src) {
		kvswm->catLeafExtra(_w, name, "null_assoc");
	}

	// �v�f�Ȃ�
	if ( src->Empty() ) {
		kvswm->catLeafExtra(_w, name, "empty_assoc");
		return;
	}

	for ( auto iter : *src ) {
		auto const& key = iter.first;
		auto const pval = iter.second;

		if ( kvswm->isLineformWriter(_w) ) {
			// pair: �ukey: value...�v
			kvswm->catNodeBegin(_w, nullptr, (key + ": ").c_str());
			kvswm->addVar(_w, nullptr, pval);
			kvswm->catNodeEnd(_w, "");
		} else {
			kvswm->addVar(_w, key.c_str(), pval);
		}

	}
	return;

#if 0
	if ( !ptr ) {
		knowbugVsw_catLeafExtra(_w, name, "null_assoc");
		return;
	}

	auto const hvp = hpimod::seekHvp(assoc_vartype_name);
	StAssocMapList* const head = (reinterpret_cast<GetMapList_t>(hvp->user))(src);

	// �v�f�Ȃ�
	if ( !head ) {
		knowbugVsw_catLeafExtra(_w, name, "empty_assoc");
		return;
	}

	// �S�L�[�̃��X�g
	knowbugVsw_catNodeBegin(_w, name, "[");
	{
		// ��
		for ( StAssocMapList* list = head; list != nullptr; list = list->next ) {
			if ( knowbugVsw_isLineformWriter(_w) ) {
				// pair: �ukey: value...�v
				knowbugVsw_catNodeBegin(_w, CStructedStrWriter::stc_strUnused,
					strf("%s: ", list->key).c_str());
				knowbugVsw_addVar(_w, CStructedStrWriter::stc_strUnused, list->pval);
				knowbugVsw_catNodeEnd(_w, "");
			} else {
				knowbugVsw_addVar(_w, list->key, list->pval);
			}
			//	dbgout("%p: key = %s, pval = %p, next = %p", list, list->key, list->pval, list->next );
		}

		// ���X�g�̉��
		for ( StAssocMapList* list = head; list != nullptr; ) {
			StAssocMapList* const next = list->next;
			exinfo->HspFunc_free(list);
			list = next;
		}
	}
	knowbugVsw_catNodeEnd(_w, "]");
	return;
#endif

}