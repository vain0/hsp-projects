// �����擾���W���[��

#include "hsp3plugin_custom.h"
#include "mod_argGetter.h"
#include "mod_makepval.h"

//##########################################################
//    �錾
//##########################################################
//static void code_checkarray2( PVal* pval );

//##########################################################
//    �����̎擾
//##########################################################
/*
//------------------------------------------------
// �ϐ����擾����
//------------------------------------------------
bool code_getva_ex(PVal** pval, APTR* aptr)
{
	*pval = &ctx->mem_var[*val];					// �O���[�o���ϐ��̃f�[�^���� PVal �����o��
	if ( code_getprm() <= PARAM_END ) return false;	// �������U
	*aptr = (*pval)->offset;
	return true;
}
//*/

//------------------------------------------------
// ��������擾����( hspmalloc �Ŋm�ۂ��� )
// 
// @ ����`���͌Ăяo�����ɂ���B
//------------------------------------------------
int code_getds_ex(char** ppStr, const char* defstr)
{
	char* pStr = code_getds(defstr);
	size_t len = strlen(pStr);
	
	*ppStr = hspmalloc( (len + 1) * sizeof(char) );
	strncpy( *ppStr, pStr, len );
	(*ppStr)[len] = '\0';		// NULL�Ŏ~�߂�
	return len;
}

//------------------------------------------------
// �����񂩐��l���擾����
// 
// @ ������Ȃ� sbAlloc �Ŋm�ہA��������R�s�[����B
// @result = int
//		*ppStr �� NULL �Ȃ�A�Ԓl���L���B
//		�����łȂ��ꍇ�A*ppStr ���L���B
//------------------------------------------------
int code_getsi( char** ppStr )
{
	*ppStr = NULL;
	
	if ( code_getprm() <= PARAM_END ) return 0;
	
	switch ( mpval->flag ) {
		case HSPVAR_FLAG_INT:
			return *(int*)( mpval->pt );
			
		case HSPVAR_FLAG_DOUBLE:
			return static_cast<int>( *(double*)(mpval->pt) );
			
		case HSPVAR_FLAG_STR:
		{
			*ppStr = hspmalloc( PVal_size(mpval) + 1 );
			strcpy( *ppStr, (char*)PVal_getptr(mpval) );
			return 0;
		}
		default:
			puterror( HSPERR_TYPE_MISMATCH );
	}
	return 0;
}

//------------------------------------------------
// �^�^�C�v�l���擾����
// 
// @ ������ or ���l
// @ int �� str �Ȃǂ̊֐�������󂯕t���悤�Ƃ������A
// 		exflg �Ƃ����悭�킩��񂱂ƂɂȂ�̂ł�߁B
// @error ������Ŕ�^��        => HSPERR_ILLEGAL_FUNCTION
// @error ������ł����l�ł��Ȃ� => HSPERR_TYPE_MISMATCH
//------------------------------------------------
int code_getvartype( int deftype )
{
	int vflag = HSPVAR_FLAG_NONE;
	
	// �g�ݍ��݌^�ϊ��֐��̏ꍇ ( exflg ���������Ȃ�Ȃ����ۂ��̂ō폜 )
	/*
	if ( *type == TYPE_INTFUNC ) {
		switch ( *val ) {
			case 0x000: vflag = HSPVAR_FLAG_INT;    break;	// int()
			case 0x100: vflag = HSPVAR_FLAG_STR;    break;	// str()
			case 0x185: vflag = HSPVAR_FLAG_DOUBLE; break;	// double()
			default:
				vflag = HSPVAR_FLAG_NONE; break;
		}
		if ( vflag != HSPVAR_FLAG_NONE ) {
			code_next();
			return vflag;
		}
	}
	//*/
	
	// �Ƃ肠�����Ȃɂ��擾����
	int prm = code_getprm();
	if ( prm == PARAM_END || prm == PARAM_ENDSPLIT ) return HSPVAR_FLAG_NONE;
	if ( prm == PARAM_DEFAULT ) return deftype;
	
	switch ( mpval->flag ) {
		// �^�^�C�v�l
		case HSPVAR_FLAG_INT:
			vflag = *(int*)(mpval->pt);
			break;
			
		// �^��
		case HSPVAR_FLAG_STR:
		{
			HspVarProc* vp = SeekHvp( mpval->pt );
			if ( vp == NULL ) {
				puterror( HSPERR_ILLEGAL_FUNCTION );
			}
			
			vflag = vp->flag;
			break;
		}
		default:
			puterror( HSPERR_TYPE_MISMATCH );
			break;
	}
	return vflag;
}

//------------------------------------------------
// ���s�|�C���^���擾����( ���x���A�ȗ��\ )
//------------------------------------------------
label_t code_getdlb( label_t defLabel )
{
	try {
		return code_getlb();
		
	} catch( HSPERROR err ) {
		if ( err == HSPERR_LABEL_REQUIRED ) {
			return defLabel;
		}
		
		puterror( err );
		throw;
	}
	
	/*
	label_t lb = NULL;
	
	// ���e����( *lb )�̏ꍇ
	// @ *val �ɂ̓��x��ID ( ctx->mem_ot �̗v�f�ԍ� )�������Ă���B
	// @ code_getlb() �œ�����̂̓��x�����w�����s�|�C���^�Ȃ���́B
	if ( *type == TYPE_LABEL ) {	// ���x���萔
		
		lb = code_getlb();
		
	// ���x���^�ϐ��̏ꍇ
	// @ code_getlb() �Ɠ�������, mpval ���X�V����B
	// @ ���� ( *type == TYPE_VAR ) �ł́A���x���^��Ԃ��֐���V�X�e���ϐ��ɑΉ��ł��Ȃ��B
	} else {
		// ���x���̎w�����s�|�C���^���擾
		if ( code_getprm() <= PARAM_END )         return NULL;
		if ( mpval->flag   != HSPVAR_FLAG_LABEL ) return NULL;
		
		// ���x���̃|�C���^���擾����( �ϐ��̎��̂�����o�� )
		lb = *(label_t*)( mpval->pt );
	}
	
	return lb;
	//*/
}

//------------------------------------------------
// ���x�����s�|�C���^���擾����
// @ ???
//------------------------------------------------
//pExec_t code_getlb2(void)
//{
//	pExec_t pLbExec = code_getlb();
//	code_next();
//	*exinfo->npexflg &= ~EXFLG_2;
//	return pLbExec;
//}

//##########################################################
//    �z��Y���̉���
//##########################################################
static void code_index_impl( PVal* pval, bool bRhs );

//------------------------------------------------
// �z��v�f�̎��o�� (�ʏ�z��)
//------------------------------------------------
void code_index_lhs( PVal* pval ) { code_index_impl( pval, false ); }		// code_checkarray2
void code_index_rhs( PVal* pval ) { code_index_impl( pval, true  ); }		// code_checkarray

//------------------------------------------------
// �z��v�f�̎��o�� (�ʏ�z��, ���E)
//------------------------------------------------
void code_index_impl( PVal* pval, bool bRhs )
{
	HspVarCoreReset(pval);	// �z��Y���̏�������������
	
	if ( *type != TYPE_MARK || *val != '(' ) return;
	
	code_next();
	
	int n = 0;
	PVal tmpPVal;
	
	for (;;) {
		// �Y���̏�Ԃ��`�F�b�N
		HspVarCoreCopyArrayInfo( &tmpPVal, pval );
		
		int prm = code_getprm();	// �p�����[�^�[�����o��
		
		// �G���[�`�F�b�N
		if ( prm == PARAM_DEFAULT ) {
			n = 0;
			
		} else if ( prm <= PARAM_END ) {
			puterror( HSPERR_BAD_ARRAY_EXPRESSION );
			
		} else if ( mpval->flag != HSPVAR_FLAG_INT ) {
			puterror( HSPERR_TYPE_MISMATCH );
		}
		
		// �Y���̏�Ԃ��`�F�b�N
		HspVarCoreCopyArrayInfo( pval, &tmpPVal );
		
		if ( prm != PARAM_DEFAULT ) {
			n = *(int*)(mpval->pt);
		}
		
		code_index_int( pval, n, bRhs );	// �z��v�f�w�� (int)
		if ( prm == PARAM_SPLIT ) break;
	}
	
	code_next();	// ')'��ǂݔ�΂�
	return;
}

//------------------------------------------------
// �z��v�f�̎��o�� (�A�z�z��, ��)
// 
// @from: code_checkarray_obj2
//------------------------------------------------
void code_index_obj_lhs( PVal* pval )
{
	HspVarCoreReset( pval );	// �Y����Ԃ����Z�b�g����
	
	if ( *type == TYPE_MARK && *val == '(' ) {		// �Y��������ꍇ
		code_next();
		
		GetHvp(pval->flag)->ArrayObject( pval );	// �Y���Q��
		
		code_next();								// ')'��ǂݔ�΂�
	}
	
	return;
}

//------------------------------------------------
// �z��v�f�̎��o�� (�A�z�z��, �E)
// 
// @from: code_checkarray_obj
// @prm pval   : �Y���w�肳���z��ϐ�
// @prm mptype : �ėp�f�[�^�̌^�^�C�v�l��Ԃ�
// @result     : �ėp�f�[�^�ւ̃|�C���^
//------------------------------------------------
PDAT* code_index_obj_rhs( PVal* pval, int* mptype )
{
	HspVarCoreReset( pval );	// �Y����Ԃ����Z�b�g����
	
	// �Y���w�肪����ꍇ
	if ( *type == TYPE_MARK && *val == '(' ) {
		code_next();
		
		HspVarProc* vp = GetHvp( pval->flag );
		PDAT* pResult = (PDAT*)vp->ArrayObjectRead( pval, mptype );
		code_next();			// ')'��ǂݔ�΂�
		return pResult;
	}
	
	*mptype = pval->flag;
	return PVal_getptr(pval);
}

//------------------------------------------------
// �z��v�f�̎��o�� (���g����)
// 
// @ '(' �̎��o���͏I�����Ă���Ƃ���
//------------------------------------------------
void code_expand_index_impl( PVal* pval )
{
	// �A�z�z��^ => ArrayObject() ���Ă�
	if ( pval->support & HSPVAR_SUPPORT_ARRAYOBJ ) {
		( exinfo->HspFunc_getproc(pval->flag) )->ArrayObject( pval );
		
	// �ʏ�z��^ => �����̐������v�f�����o��
	} else {
		PVal pvalTemp;
		HspVarCoreReset( pval );
		
		for ( int i = 0; i < ArrayDimCnt && !(*type == TYPE_MARK && *val == ')'); ++ i ) {
			HspVarCoreCopyArrayInfo( &pvalTemp, pval );
			int idx = code_geti();
			HspVarCoreCopyArrayInfo( pval, &pvalTemp );
			
			code_index_int_lhs( pval, idx );
		}
	}
	
	return;
}

//------------------------------------------------
// �z��v�f�̐ݒ� (�ʏ�z��, 1����, ���E)
// 
// @ Reset ��Ɏ����������A���ŌĂ΂��B
//------------------------------------------------
void code_index_int( PVal* pval, int offset, bool bRhs )
{
	if ( !bRhs ) {
		code_index_int_lhs( pval, offset );			// �����g������
	} else {
		exinfo->HspFunc_array( pval, offset );		// �����g�����Ȃ�
	}
	return;
}

//------------------------------------------------
// �z��v�f�̐ݒ� (�ʏ�z��, 1����, �E)
// 
// @ �ʏ�^ (int) �̂݁B
// @ Reset ��Ɏ����������A���ŌĂ΂��B
// @ �����g���Ή��B
//------------------------------------------------
void code_index_int_lhs( PVal* pval, int offset )
{
	if ( pval->arraycnt >= 5 ) puterror( HSPVAR_ERROR_ARRAYOVER );
	if ( pval->arraycnt == 0 ) {
		pval->arraymul = 1;		// �{�������l
	} else {
		pval->arraymul *= pval->len[pval->arraycnt];
	}
	pval->arraycnt ++;
	if ( offset < 0 ) puterror( HSPVAR_ERROR_ARRAYOVER );
	if ( offset >= pval->len[pval->arraycnt] ) {						// �z��g�����K�v
		if ( pval->arraycnt >= 4 || pval->len[pval->arraycnt + 1] == 0	// �z��g�����\
			&& ( pval->support & HSPVAR_SUPPORT_FLEXARRAY )				// �ϒ��z��T�|�[�g => �z����g������
		) {
			exinfo->HspFunc_redim( pval, pval->arraycnt, offset + 1 );
			pval->offset += offset * pval->arraymul;
			return;
		}
		puterror( HSPVAR_ERROR_ARRAYOVER );
	}
	pval->offset += offset * pval->arraymul;
	return;
}

//------------------------------------------------
// 
//------------------------------------------------

//##########################################################
//    ��������G�~�����[�g
//##########################################################

//------------------------------------------------
// �A����� (�ʏ�)
// 
// @ 1�ڂ̑���͏I�����Ă���Ƃ���
// @ �������l���Ȃ� => do nothing
//------------------------------------------------
void code_assign_multi( PVal* pval )
{
	if ( !code_isNextArg() ) return;
	
	HspVarProc* pHvp = exinfo->HspFunc_getproc( pval->flag );
	
	int      len1 = pval->len[1];
	APTR     aptr = pval->offset;
	APTR baseaptr = (len1 == 0 ? aptr : aptr % len1);	// aptr = �ꎟ���ڂ̓Y�� + baseaptr ������
	
	aptr -= baseaptr;

	while ( code_isNextArg() ) {
		int prm = code_getprm();					// ���ɑ������l���擾
		if ( prm != PARAM_OK ) puterror( HSPERR_SYNTAX );
	//	if ( !(pval->support & HSPVAR_SUPPORT_ARRAYOBJ) && pval->flag != mpval->flag ) {
	//		puterror( HSPERR_INVALID_ARRAYSTORE );	// �^�ύX�͂ł��Ȃ�
	//	}
		
		baseaptr ++;

		pval->arraycnt = 0;							// �z��w��J�E���^�����Z�b�g
		pval->offset   = aptr;
		code_index_int_lhs( pval, baseaptr );		// �z��`�F�b�N

		// ���
		PVal_assign( pval, mpval->pt, mpval->flag );
	}
	
	return;
}

//##########################################################
//    ���̑�
//##########################################################
//------------------------------------------------
// �������������ǂ���
// 
// @ ���ߌ`���A�֐��`���ǂ���ł��n�j
//------------------------------------------------
bool code_isNextArg(void)
{
	return !( *exinfo->npexflg & EXFLG_1 || ( *type == TYPE_MARK && *val == ')' ) );
}

//------------------------------------------------
// ���̈�����ǂݔ�΂�
// 
// @ exflg ���Ȃ�Ƃ����悤�Ƃ��Ă݂�B
// @ result : PARAM_* (code_getprm �Ɠ���)
//------------------------------------------------
int code_skipprm(void)
{
	int& exflg = *exinfo->npexflg;
	
	// �I��, or �ȗ�
	if ( exflg & EXFLG_1 ) return PARAM_END;	// �p�����[�^�[�I�[
	if ( exflg & EXFLG_2 ) {					// �p�����[�^�[��؂�(�f�t�H���g��)
		exflg &= ~EXFLG_2;
		return PARAM_DEFAULT;
	}
	
	if ( *type == TYPE_MARK ) {
		// �p�����[�^�[�ȗ���('?')
		if ( *val == 63 ) {
			code_next();
			exflg &= ~EXFLG_2;
			return PARAM_DEFAULT;
			
		// �֐����̃p�����[�^�[�ȗ���
		} else if ( *val == ')' ) {
			exflg &= ~EXFLG_2;
			return PARAM_ENDSPLIT;
		}
	}
	
	// �����̓ǂݔ�΂�����
	for ( int lvBracket = 0; ; ) {
		if ( *type == TYPE_MARK ) {
			if ( *val == '(' ) lvBracket ++;
			if ( *val == ')' ) lvBracket --;
		}
		code_next();
		
		if ( lvBracket == 0
			&& ( exflg & EXFLG_1 || exflg & EXFLG_2 || *type == TYPE_MARK && *val == ')' )
		) {
			break;
		}
	}
	
	if ( exflg ) exflg &= ~EXFLG_2;
	
	// �I��
	if ( *type == TYPE_MARK && *val == ')' ) {
		return PARAM_SPLIT;
		
	} else {
		return PARAM_OK;
	}
}

//##########################################################
//    OpenHSP ����̈��p
//##########################################################
