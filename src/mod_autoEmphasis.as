// emphasis code �����������W���[��

#ifndef IG_MODULE_AUTO_HS_AS
#define IG_MODULE_AUTO_HS_AS

#include "Mo/HPM_split.as"

#include "Mo/mod_replace.as"
#include "Mo/MCLongString.as"

//##############################################################################
//                ���W���[��
//##############################################################################
/**+
 * @name     : mod_autoEmphasis
 * @author   : ue-dai
 * @date     : 2011 12/25 (Sun)
 * @version  : 1.0��
 * @type     : autoEmphasis �������W���[��
 * @group    : 
 * @note     : #include "mod_autoEmphasis.as" ���K�v�Bautohs ����̔h���B
 * @url      : http://prograpark.ninja-web.net/
 * @port
 * @	Win
 * @	Cli
 * @	Let
 * @portinfo : ���ɂȂ��B
 **/

#module autohs_mod

#include "Mo/HPM_header.as"

//------------------------------------------------
// DEFTYPE
//------------------------------------------------
#const DEFTYPE_NONE			0x0000
#const DEFTYPE_LABEL		0x0001		// ���x��
#const DEFTYPE_MACRO		0x0002		// �}�N��
#const DEFTYPE_CONST		0x0004		// �萔
#const DEFTYPE_FUNC			0x0008		// ���߁E�֐�
#const DEFTYPE_DLL			0x0010		// DLL����
#const DEFTYPE_CMD			0x0020		// HPI�R�}���h
#const DEFTYPE_COM			0x0040		// COM����
#const DEFTYPE_IFACE		0x0080		// �C���^�[�t�F�[�X
#const DEFTYPE_NAMESPACE	0x0100		// ���W���[��(���O���)
#const DEFTYPE_CLASS		0x0200		// ���W���[��(�N���X)

#const DEFTYPE_CTYPE		0x1000		// CTYPE
#const DEFTYPE_MODULE		0x2000		// ���W���[�������o

//------------------------------------------------
// hs ��������
//------------------------------------------------
#define nowTkType tktypelist(idx)
#define nowTkStr  tkstrlist (idx)
#define NextToken GetNextToken idx, tktypelist, tkstrlist, cntToken

#deffunc CreateHs var result, var script,  \
	local hs, local fSplit, local tktypelist, local tkstrlist, local cntToken, local idx, local deftype, local sDefIdent, local prmlist, local cntPrm, local bGlobal, local bInModule
	
	// ������
	fSplit  = HPM_SPLIT_FLAG_NO_RESERVED
	fSplit |= HPM_SPLIT_FLAG_NO_BLANK
	fSplit |= HPM_SPLIT_FLAG_NO_COMMENT
;	fSplit |= HPM_SPLIT_FLAG_NO_SCOPE
	
	hpm_split tktypelist, tkstrlist, script, fSplit
	cntToken = stat
	
	// hs ����
	dim deftype
	dim idx
	dim bInModule
	
	LongStr_new hs
	
	repeat
		gosub *LProcToken
		NextToken
		if ( idx >= cntToken ) {
			break
		}
	loop
	
	LongStr_tobuf  hs, result
	LongStr_delete hs
	
	return
	
*LProcToken
	switch ( nowTkType )
		//--------------------
		// ���x��
		//--------------------
		/*
		case TKTYPE_LABEL
			deftype = DEFTYPE_LABEL
			
			// �s���̏ꍇ�̂�
			if ( befTkType == TKTYPE_END ) {
				sIdent = nowTkStr
				
			;	gosub *LDecideModuleName
				
				// ���X�g�ɒǉ�
				deftype = DEFTYPE_LABEL
				gosub *LAddDeflist
			}
			
			swbreak
		//*/
		
		//--------------------
		// �v���v���Z�b�T����
		//--------------------
		case TKTYPE_PREPROC
			deftype  = DEFTYPE_NONE
			nowTkStr = CutPreprocIdent( nowTkStr )		// ���ʎq���������ɂ���
			bGlobal  = true
			
			switch ( nowTkStr )
				case "modfunc"  :
				case "deffunc"  : deftype  = DEFTYPE_FUNC                    : goto *LAddDefinition
				case "modcfunc" :
				case "defcfunc" : deftype  = DEFTYPE_FUNC  | DEFTYPE_CTYPE   : goto *LAddDefinition
				case "const"    :
				case "enum"     :
				case "define"   : deftype  = DEFTYPE_MACRO : bGlobal = false : goto *LAddDefinition
				case "cfunc"    : deftype  = DEFTYPE_CTYPE
				case "func"     : deftype |= DEFTYPE_DLL   : bGlobal = false : goto *LAddDefinition
				case "cmd"      : deftype  = DEFTYPE_CMD   :                 : goto *LAddDefinition
				case "comfunc"  : deftype  = DEFTYPE_COM   : bGlobal = false : goto *LAddDefinition
				case "usecom"   : deftype  = DEFTYPE_IFACE : bGlobal = false : goto *LAddDefinition
				
				case "module"   : bInModule = true
					deftype = DEFTYPE_NAMESPACE
					goto *LAddDefinition
				case "global"   : bInModule = false : swbreak	// ��`���Ȃ�
				
			:*LAddDefinition
					NextToken
					
					switch ( nowTkStr )
						case "ctype"  : deftype |= DEFTYPE_CTYPE : goto *LAddDefinition
						case "global" : bGlobal  = true          : goto *LAddDefinition
						case "local"  : bGlobal  = false         : goto *LAddDefinition
						case "double"
							goto *LAddDefinition
						
						// ��`����鎯�ʎq
						default:
							sDefIdent = nowTkStr
							
							// �����X�R�[�v���� => ��O���[�o��
							idx ++
							if ( nowTkType == TKTYPE_SCOPE ) {
								if ( nowTkStr != "@" ) {
									bGlobal = false
								}
							}
							idx --
							
							// (#module):
							if ( deftype == DEFTYPE_NAMESPACE ) {
								// ���� (���O��� or �N���X)
								if ( nowTkType == TKTYPE_IDENT ) {
									deftype = DEFTYPE_CLASS
								}
								// "" ���O��
								if ( peek(sDefIdent) == '"' ) {
									sDefIdent = strmid(sDefIdent, 1, strlen(sDefIdent) - 2)
								}
							}
							
							// ���̃g�[�N��
							NextToken
							swbreak
					swend
					
					// �O���Ɍ����Ȃ����͖̂������� (opt)
					if ( bInModule && bGlobal == false && bIgnoreInnerDefinition@ ) {
						swbreak
					}
					
					// ���X�g�ɒǉ�
					gosub *LAddDeflist
					swbreak
					
				// uselib
				case "uselib"
					if ( bExplicitUselib@ ) {
						NextToken
						LongStr_add hs, "; #uselib " + nowTkStr + "\n"
					}
					swbreak
					
			swend
			swbreak
	swend
	return
	
*LAddDeflist
	// �擪 or ���� �� _ �Ȃ�A��������
	if ( peek(sDefIdent) == '_' || peek(sDefIdent, strlen(sDefIdent) - 1) == '_' ) {
		return
	}
	
	// ��`�^�C�v�̕�����𓾂�
	deftypeString = MakeDefTypeString( deftype )
	
	// ��`�^�C�v �� (�Ɨ���, �F)
	foreach keylist@
		if ( keylist@(cnt) == deftypeString ) {
			dependency = depenId@(cnt)
			clrText    = clrTxId@(cnt)
			break
		}
	loop
	
	// �o��
	if ( dependency != "" && clrText != "" ) {
		LongStr_add hs, sDefIdent + " " + dependency + " " + clrText + "\n"
	}
	
	return
	
//------------------------------------------------
// ��`�^�C�v���當����𐶐�����
// @static
// @from deflister
//------------------------------------------------
#defcfunc MakeDefTypeString int deftype,  local stype, local bCType
	sdim stype, 320
	bCType = ( deftype & DEFTYPE_CTYPE ) != false
	
	if ( deftype & DEFTYPE_LABEL ) { stype = "Label" }
	if ( deftype & DEFTYPE_MACRO ) { stype = "Macro" }
	if ( deftype & DEFTYPE_CONST ) { stype = "Const" }
	if ( deftype & DEFTYPE_CMD   ) { stype = "Cmd"   }
	if ( deftype & DEFTYPE_COM   ) { stype = "COM"   }
	if ( deftype & DEFTYPE_IFACE ) { stype = "IFace" }
	
	if ( deftype & DEFTYPE_NAMESPACE ) { stype = "NameSpace" }
	if ( deftype & DEFTYPE_CLASS     ) { stype = "Class" }
	
	if ( deftype & DEFTYPE_DLL ) {
		if ( bCType ) { stype = "Func<dll>" } else { stype = "Sttm<dll>" }
		
	} else : if ( deftype & DEFTYPE_FUNC ) {
		if ( bCType ) { stype = "Func" } else { stype = "Sttm" }
		
		// �ÓI or �����o
		if ( deftype & DEFTYPE_MODULE ) {
			stype += "<member>"
		} else {
			stype += "<static>"
		}
		
	} else {
		if ( bCType ) { stype += "<ctype>" }
	}
	
	return stype
	
//------------------------------------------------
// idx �̑���
//------------------------------------------------
#deffunc GetNextToken var idx, array tktypelist, array tkstrlist, int cntToken
*LNextToken_core
	idx ++
	
	if ( idx >= cntToken ) {
		nowTkType = TKTYPE_ERROR
		nowTkStr  = ""
		return
	}
	
;	switch ( nowTkType )
;		default
;			swbreak
;	swend
	
	return
	
#global

#endif
