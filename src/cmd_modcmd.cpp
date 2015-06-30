// var_modcmd - command

#include "hpimod/hsp3plugin_custom.h"
#include "hpimod/reffuncResult.h"
#include "hpimod/mod_moddata.h"

#include "iface_modcmd.h"
#include "cmd_modcmd.h"
#include "vt_modcmd.h"

using namespace hpimod;

//------------------------------------------------
// modcmd �^�̈������擾����
//------------------------------------------------
modcmd_t code_get_modcmd()
{
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	if ( mpval->flag != g_vtModcmd ) puterror( HSPERR_TYPE_MISMATCH );
	return VtModcmd::at(mpval);
}

//------------------------------------------------
// �Ăяo������
// 
// @prm ppResult:
// @	nullptr �Ȃ疽�ߌĂяo���ŁA���̊֐��͖��Ӗ��Ȓl��Ԃ�
//------------------------------------------------
int modcmdCall( modcmd_t modcmd, PDAT** ppResult )
{
	if ( !VtModcmd::isValid(modcmd) ) puterror(HSPERR_INVALID_ARRAY);
	
	stdat_t const stdat = getSTRUCTDAT(modcmd);
	
	if ( ppResult && stdat->index == STRUCTDAT_INDEX_FUNC ) {	// ���߂̊֐��`���Ăяo�����֎~
		puterror( HSPERR_SYNTAX);
	}
	
	// ����������o��
	void* const prmstk = hspmalloc( stdat->size );
	code_expandstruct( prmstk, stdat, CODE_EXPANDSTRUCT_OPT_LOCALVAR );	// local �� variant �����Ƃ��ēW�J����ݒ�
	
	if ( !(*exinfo->npexflg & EXFLG_1) && !(*type == TYPE_MARK && *val == ')') ) {
		puterror(HSPERR_TOO_MANY_PARAMETERS);
	}
	
	// prmstack �������ւ��Ď��s
	{
		void* const prmstk_bak = ctx->prmstack;
		ctx->prmstack = prmstk;
		
		code_call( getLabel(stdat->otindex) );
		
		ctx->prmstack = prmstk_bak;
	}

	// prmstack �����
	customstack_delete(stdat, prmstk);
	
	// �Ԓl��ݒ�
	// return �ŕԒl���ݒ肳��Ȃ������ꍇ �� HSPERR_NO_RETVAL ; ���m����̂�(�����p�Ȃ��ł�)����H
	PVal* const mpval = *exinfo->mpval;
	
	if ( ppResult ) {
		*ppResult = mpval->pt;
		return mpval->flag;
	} else {
		return 0; //dummy value
	}
}

//------------------------------------------------
// �Ăяo�� (forward)
// 
// ���ߌ`���F
//	call modcmd : call_nocall args...
// �֐��`���F
//	call( modcmd, call_nocall(args...) )
//------------------------------------------------
void modcmdCallForwardSttm()
{
	modcmd_t const modcmd = code_get_modcmd();
	if ( !VtModcmd::isValid(modcmd) ) puterror(HSPERR_INVALID_ARRAY);
	
	*type = TYPE_MODCMD;
	*val  = modcmd;
	*exinfo->npexflg = EXFLG_1;
	return;
}

int modcmdCallForwardFunc(PDAT** ppResult)
{
	modcmd_t const modcmd = code_get_modcmd();
	if ( !VtModcmd::isValid(modcmd) ) puterror(HSPERR_INVALID_ARRAY);
	
	*type = TYPE_MODCMD;
	*val  = modcmd;
	*exinfo->npexflg = 0;
	if ( code_getprm() <= PARAM_END ) puterror( HSPERR_NO_DEFAULT );
	
	*ppResult = mpval->pt;
	return mpval->flag;
}

//------------------------------------------------
// ���[�U��`���߁E�֐��� ID �����o��
//------------------------------------------------
int code_get_modcmdId()
{
	if ( *type != TYPE_MODCMD ) puterror(HSPERR_TYPE_MISMATCH);
	int const modcmdId = *val;
	code_next();
	
	// ���������⎮���ł͂Ȃ��A')' �ł��Ȃ� �� �^����ꂽ��������2����ȏ�łł��Ă���
	if ( !((*exinfo->npexflg & (EXFLG_1 | EXFLG_2)) != 0 || (*type == TYPE_MARK && *val == ')')) )
		puterror(HSPERR_ILLEGAL_FUNCTION);
	
	// ���W���[���N���X���ʎq�͔F�߂Ȃ�
	if ( getSTRUCTDAT(modcmdId)->index == STRUCTDAT_INDEX_STRUCT ) puterror(HSPERR_ILLEGAL_FUNCTION);
	
	return modcmdId;
}
