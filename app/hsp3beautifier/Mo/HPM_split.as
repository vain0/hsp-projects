// HSP parse module - split

#ifndef IG_HSP_PARSE_MODULE_SPLIT_AS
#define IG_HSP_PARSE_MODULE_SPLIT_AS

#include "strutil.as"
#include "extendTab.as"
#include "HPM_sub.as"
#include "HPM_getToken.as"

#module hpmod_split

#include "HPM_header.as"

#define true  1
#define false 0

#define global HPM_SPLIT_FLAG_NONE			0x0000		// �w��Ȃ�
#define global HPM_SPLIT_FLAG_NO_BLANK		0x0001		// TKTYPE_BLANK   �𖳎�����
#define global HPM_SPLIT_FLAG_NO_COMMENT	0x0002		// TKTYPE_BOMMENT �𖳎�����
#define global HPM_SPLIT_FLAG_NO_SCOPE		0x0004		// TKTYPE_SCOPE   �𖳎�����
#define global HPM_SPLIT_FLAG_NO_RESERVED	0x0008		// TKTYPE_NAME ���\��ꂩ�ǂ����̔�������Ȃ�
#define global HPM_SPLIT_FLAG_EXTEND_TAB	0x0010		// �^�u�����𔼊p�X�y�[�X�ɓW�J����
;#define global HPM_SPLIT_FLAG_
;#define global HPM_SPLIT_FLAG_

//------------------------------------------------
// �X�N���v�g����
// 
// @prm tktypelist = int[] : TKTYPE �̔z��
// @prm tkstrlist  = str[] : �g�[�N��������̔z��
// @prm script     = str   : �X�N���v�g
//------------------------------------------------
#deffunc hpm_split array tktypelist, array tkstrlist, str prm_script, int fSplit, int nTabSize,  local script, local lenScript, local cntToken, local tkstr, local tklen, local tktype, local bPreprocLine, local index, local befTkType, local posALine, local bNoBlank, local bNoComment, local bNoScope, local bNoReserved, local bExtendTab
	sdim tkstr
	dim  tktype
	
	dim tktypelist
	sdim tkstrlist
	
	bPreprocLine  = false
	script    = prm_script
	lenScript = strlen(script)
	index     = 0
	tktype    = TKTYPE_END
	befTkType = TKTYPE_END
	cntToken  = 0
	
	bNoBlank    = ( fSplit & HPM_SPLIT_FLAG_NO_BLANK    ) != false
	bNoComment  = ( fSplit & HPM_SPLIT_FLAG_NO_COMMENT  ) != false
	bNoScope    = ( fSplit & HPM_SPLIT_FLAG_NO_SCOPE    ) != false
	bNoReserved = ( fSplit & HPM_SPLIT_FLAG_NO_RESERVED ) != false
	bExtendTab  = ( fSplit & HPM_SPLIT_FLAG_EXTEND_TAB  ) != false		// related: nTabSize, posALine
	
	repeat
		// �Ō�܂Ŏ擾������I������
		if ( lenScript <= index ) { break }
		
		// ���̃g�[�N�����擾
		hpm_getNextToken tkstr, script, index, befTkType, bPreprocLine
		tktype = stat
		tklen  = strlen(tkstr)
		index += tklen
		
		if ( bExtendTab ) { tkstr = extendTab(tkstr, nTabSize, posALine) : posALine += strlen(tkstr) }
		
		// ���������g�[�N�� �� ��΂�
		if ( ( bNoBlank && tktype == TKTYPE_BLANK ) || ( bNoComment && tktype == TKTYPE_COMMENT ) || ( bNoScope && tktype == TKTYPE_SCOPE ) ) {
			continue
		}
		
;		if ( tktype == TKTYPE_ERROR ) {
;			cntToken = -1
;			break
;		}
		
;		logmes "type\t= "+ tktype
;		logmes "str\t= "+  tkstr
;		logmes "beftype\t= "+ befTkType
;		logmes "index\t= "+ index
;		logmes ""
		
		tktypelist(cntToken) = tktype
		tkstrlist (cntToken) = tkstr
		
		// �g�[�N�����ƂɕK�{�̏���
		gosub *LProcToken
		
		// �X�V
		befTkType = tktype
		cntToken ++
	loop
	
	return cntToken
	
*LProcToken
	switch ( tktype )
		
		// �� or �R�����g
		case TKTYPE_BLANK
		case TKTYPE_COMMENT
			tktype = befTkType
			swbreak
			
		// ���̏I��
		case TKTYPE_END
			if ( IsNewLine( peek(tkstr) ) ) {			// ���s
				if ( bPreprocLine ) { bPreprocLine = false }
				if ( bExtendTab   ) { posALine = 0 }
			}
			swbreak
			
		// �v���v���Z�b�T����
		case TKTYPE_PREPROC
			if ( IsPreproc(tkstr) ) {
				bPreprocLine = true
			} else {
				tktype               = TKTYPE_PREPROC_DISABLE
				tktypelist(cntToken) = tktype
			}
			swbreak
			
		// ���ʎq
		case TKTYPE_NAME
			if ( bNoReserved ) { swbreak }
			
			// �v���v���Z�b�T�s�L�[���[�h��
			if ( bPreprocLine ) {
				if ( IsPreprocWord( tkstr ) ) {
					tktype = TKTYPE_EX_PREPROC_KEYWORD
					goto *LChangeTkTypeList
				}
			}
			
			// �W������
			if ( IsStatement( tkstr ) ) {
				tkType = TKTYPE_EX_STATEMENT
				
			// �W���֐�
			} else : if ( IsFunction( tkstr ) ) {
				tkType = TKTYPE_EX_FUNCTION
				
			// �V�X�e���ϐ�
			} else : if ( IsSysvar( tkstr ) ) {
				tktype = TKTYPE_EX_SYSVAR
				
			// �W���}�N��
			} else : if ( IsMacro( tkstr ) ) {
				tktype = TKTYPE_EX_MACRO
				
			// ����ȊO
			} else {
;				tktype = TKTYPE_NAME
			}
			
			// �z��Ɏw�肵���l��ύX����
		:*LChangeTkTypeList
			tktypelist(cntToken) = tktype
			swbreak
			
	swend
	
	return
	
#global

//##############################################################################
//                �e�X�g
//##############################################################################
#if 0

#include "MCLongString.as"

	s = {"
		// ���ʎq��؂�o���ĕԂ�
		#defcfunc CutName var sSrc, int iOffset,  \\
			local n
		\	
		\	FTM_CutToken ( IsIdent(c) || IsSJIS1st(c) || c == '`' ), IsSJIS1st(c)
		\	return \"Hello, world!\"
	"}
	
	LongStr_new ls
	
;	fSplit = HPM_SPLIT_FLAG_EXTEND_TAB
	
	hpm_split tktypelist, tkstrlist, s, fSplit, 4
	foreach tktypelist
		
		LongStr_add ls, "type\t= "+ tktypelist(cnt) +"\n"
		LongStr_add ls, "str\t= "+  tkstrlist (cnt)  +"\n"
		LongStr_add ls, "\n"
		
	loop
	
	LongStr_toBuf  ls, buf
	LongStr_delete ls
	
	objmode 2
	font msgothic, 12
	mesbox buf, ginfo(12), ginfo(13)
	stop
	
#endif
