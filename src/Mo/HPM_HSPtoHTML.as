// HSP parse module - HSP to HTML

#ifndef __HSP_PARSE_MODULE_HSP_TO_HTML_AS__
#define __HSP_PARSE_MODULE_HSP_TO_HTML_AS__

#include "Mo/MCLongString.as"	// ���������������
#include "Mo/ToSR_ForHTML.as"	// ���̎Q��
#include "HPM_getToken.as"		// [���ʕt��] ���ʎq���o�����W���[��
#include "HPM_split.as"			// HSP�X�N���v�g�������W���[��

#module hpmod_HSPtoHTML

#include "HPM_header.as"		// �w�b�_�t�@�C��

#define ctype STR_STARTTAG(%1) "<span class=\""+ (%1) +"\">"
#define STR_ENDTAG "</span>"

#const  LENGTH_STARTTAG 15
#const  LENGTH_ENDTAG   7
#const  LENGTH_TAG      LENGTH_STARTTAG + LENGTH_ENDTAG

#define success 1
#define failure 0

//------------------------------------------------
// HSP �X�N���v�g�� HTML �ɕϊ�����
//------------------------------------------------
#define nxtTkStr  tkstrlist (idx + 1)
#define nxtTkType tktypelist(idx + 1)
#define nowTkStr  tkstrlist (idx)
#define nowTkType tktypelist(idx)
#define befTkStr  tkstrlist (idx - 1)
#define befTkType tktypelist(idx - 1)

#deffunc hpm_HSPtoHTML var outbuf, str in_script, int bEscSpace, int fSplit, int nTabSize,  local tkstrlist, local tktypelist, local ls, local idx, local bSetTag, local bPreprocLine
	
	hpm_split tktypelist, tkstrlist, in_script,  fSplit, nTabSize
	
	// �ϐ����m�ۂ���
	LongStr_new ls
	
	idx = 0
	repeat length(tktypelist)
		
		// �g�[�N���̎�ނ��Ƃɏ������킯��
		gosub *LProcToken
		
		// �X�N���v�g�ɏ�������
		LongStr_cat ls, nowTkStr
		
		idx ++
	loop
	
	LongStr_tobuf  ls, outbuf
	LongStr_delete ls
	return success
	
//------------------------------------------------
// �g�[�N�����Ƃɏ���������
//------------------------------------------------
#define INTO_TAG(%1=nowTkType) nowTkStr = STR_STARTTAG(stt_tagname(%1)) + nowTkStr + STR_ENDTAG : bSetTag = false
#define ToSR(%1,%2=0) ToSubstanceReference (%1), (%2)
*LProcToken
	
	bSetTag = true		// �Ō�� INTO_TAG ���邩�ǂ���
	
	switch ( nowTkType )
	
	// ���̏I��
	case TKTYPE_END
		if ( IsNewLine( peek(nowTkStr) ) ) {
			bPreprocLine = false
		}
		swbreak
		
	// �� or �R�����g or ������ or ���Z�q => ���̎Q�Ƃɕϊ�����K�v������ ( ���� )
	case TKTYPE_BLANK
	case TKTYPE_COMMENT
	case TKTYPE_STRING
	case TKTYPE_OPERATOR
		ToSR nowTkStr, bEscSpace
		swbreak
		
	// �v���v���Z�b�T����
	case TKTYPE_PREPROC
		// preproc ���ʎq������`�ȏꍇ�́A�F�������Ȃ�
		if ( IsPreproc(nowTkStr) == false ) {
			bSetTag      = false
		} else {
			bPreprocLine = true
		}
		swbreak
		
	// ���ʎq
;	case TKTYPE_NAME
;		swbreak
	
	swend
	
	// �^�O�Ŋ���
	if ( bSetTag ) {
		if ( stt_tagname(nowTkType) != "" ) {	// ��Ȃ炵�Ȃ�
			INTO_TAG
		}
	}
	
	return
	
//------------------------------------------------
// ���W���[��������
//------------------------------------------------
#deffunc _init@hpmod_HSPtoHTML
	
	// �^�O���̃��X�g
	sdim stt_tagname, TKTYPE_MAX
;	stt_tagname(TKTYPE_OPERATOR)     = ""
;	stt_tagname(TKTYPE_CIRCLE_L)     = ""
;	stt_tagname(TKTYPE_CIRCLE_R)     = ""
;	stt_tagname(TKTYPE_MACRO_PRM)    = ""
;	stt_tagname(TKTYPE_MACRO_SP)     = ""
;	stt_tagname(TKTYPE_NUMBER)       = ""
	stt_tagname(TKTYPE_STRING)       = "string"
	stt_tagname(TKTYPE_CHAR)         = "char"
	stt_tagname(TKTYPE_LABEL)        = "label"
	stt_tagname(TKTYPE_PREPROC)      = "preproc"
;	stt_tagname(TKTYPE_KEYWORD)      = ""
;	stt_tagname(TKTYPE_VARIABLE)     = ""		// ����
;	stt_tagname(TKTYPE_NAME)         = ""		// �V
	stt_tagname(TKTYPE_COMMENT)      = "comment"
;	stt_tagname(TKTYPE_COMMA)        = ""
;	stt_tagname(TKTYPE_PERIOD)       = ""
	stt_tagname(TKTYPE_SCOPE)        = "scope"
;	stt_tagname(TKTYPE_ESC_LINEFEED) = ""
	
	stt_tagname(TKTYPE_EX_STATEMENT)       = "statement"
	stt_tagname(TKTYPE_EX_FUNCTION)        = "function"
	stt_tagname(TKTYPE_EX_SYSVAR)          = "sysvar"
	stt_tagname(TKTYPE_EX_MACRO)           = "macro"
	stt_tagname(TKTYPE_EX_PREPROC_KEYWORD) = "ppword"
;	stt_tagname(TKTYPE_EX_CONST)           = "const"
;	stt_tagname(TKTYPE_EX_USER_STTM)       = "defsttm"
;	stt_tagname(TKTYPE_EX_USER_FUNC)       = "deffunc"
;	stt_tagname(TKTYPE_EX_DLLFUNC)         = "dllfunc"
;	stt_tagname(TKTYPE_EX_IFACE)           = "iface"
;	stt_tagname(TKTYPE_EX_MODNAME)         = "modname"
;	stt_tagname(TKTYPE_EX_VAR)             = "var"
	return
	
#global
_init@hpmod_HSPtoHTML

#endif
