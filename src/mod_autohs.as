// hs �����������W���[��

#ifndef IG_MODULE_AUTO_HS_AS
#define IG_MODULE_AUTO_HS_AS

#include "Mo/HPM_split.as"
#include "Mo/MCLongString.as"

//##############################################################################
//                ���W���[��
//##############################################################################
/**+
 * @name     : mod_autohs
 * @author   : ue-dai
 * @date     : 2009 09/01 (Tue)
 * @version  : 1.0��
 * @type     : autohs �������W���[��
 * @group    : 
 * @note     : #include "mod_autohs.as" ���K�v�ł��B
 * @url      : http://prograpark.ninja-web.net/
 * @port
 * @	Win
 * @	Cli
 * @	Let
 * @portinfo : ���ɂȂ��B
 **/

#module autohs_mod

#include "Mo/HPM_header.as"
#include "Mo/hpm_deftype.hsp"

#define STR_HS_HEADER stt_hsHeader

//------------------------------------------------
// DocData
//------------------------------------------------
#enum DocData_Name = 0		// hs ����
#enum DocData_Author		// author	: ��Җ�
#enum DocData_Date			// date		: ���t
#enum DocData_Version		// version	: �o�[�W�������
#enum DocData_Type			// type		: %type �ȗ��l
#enum DocData_Group			// group	: %group �ȗ��l
#enum DocData_Note			// note		: ���l
#enum DocData_Url			// url		: URL
#enum DocData_Port			// port		: �Ή���
#enum DocData_MAX

//------------------------------------------------
// ���W���[��������
//------------------------------------------------
#deffunc AutohsInitialize
	stt_docdata_identlist = "name", "author", "date", "version", "type", "group", "note", "url", "port"
	return
	
//------------------------------------------------
// �w�b�_�������ݒ肷��
//------------------------------------------------
#deffunc SetHsHeader str hsHeader
	stt_hsHeader = hsHeader
	strrep stt_hsHeader, "\\n", "\n"
	return
	
//------------------------------------------------
// hs ��������
//------------------------------------------------
#define nowTkType tktypelist(idx)
#define nowTkStr  tkstrlist (idx)
#define NextToken GetNextToken idx, tktypelist, tkstrlist, docdata, cntToken

#deffunc CreateHs var result, var script,  \
	local hs, local fSplit, local tktypelist, local tkstrlist, local docdata, local cntToken, local idx, local deftype, local sDefIdent, local prmlist, local cntPrm, local bGlobal, local bInModule
	
	// ������
	fSplit  = HPM_SPLIT_FLAG_NO_RESERVED
;	fSplit |= HPM_SPLIT_FLAG_NO_BLANK
;	fSplit |= HPM_SPLIT_FLAG_NO_COMMENT
;	fSplit |= HPM_SPLIT_FLAG_NO_SCOPE
	
	hpm_split tktypelist, tkstrlist, script, fSplit
	cntToken = stat
	
	// hs ����
	dim deftype
	dim idx
	dim bInModule
	sdim docdata, , DOCDATA_MAX
	
	LongStr_new hs
	LongStr_add hs, STR_HS_HEADER	// �w�b�_�������ݒ肷��
	
	repeat
		gosub *LProcToken
		NextToken
		if ( idx >= cntToken ) {
			break
		}
	loop
	
	LongStr_tobuf  hs, result
	LongStr_delete hs
	
	// ���ߍ��݃h�L�������g���̓W�J
	if ( docdata(DocData_Name) != "" ) {
		repeat DocData_MAX
			strrep result, ";$("+ stt_docdata_identlist(cnt) +")", docdata(cnt)
		loop
	}
	
	return
	
*LProcToken
	switch ( nowTkType )
		//--------------------
		// �v���v���Z�b�T����
		//--------------------
		case TKTYPE_PREPROC
			deftype  = DEFTYPE_NONE
			nowTkStr = CutPreprocIdent( nowTkStr )		// ���ʎq���������ɂ���
			bGlobal  = true
			
			switch ( nowTkStr )
				case "modfunc"  : deftype  = DEFTYPE_MODULE
				case "deffunc"  : deftype |= DEFTYPE_FUNC                    : goto *LAddDefinition
				case "modcfunc" : deftype  = DEFTYPE_MODULE
				case "defcfunc" : deftype |= DEFTYPE_FUNC  | DEFTYPE_CTYPE   : goto *LAddDefinition
				case "define"   : deftype  = DEFTYPE_MACRO : bGlobal = false : goto *LAddDefinition
				case "const"
				case "enum"     : deftype  = DEFTYPE_CONST : bGlobal = false : goto *LAddDefinition
				case "cfunc"    : deftype  = DEFTYPE_CTYPE
				case "func"     : deftype |= DEFTYPE_DLL   : bGlobal = false : goto *LAddDefinition
				case "cmd"      : deftype  = DEFTYPE_CMD   :                 : goto *LAddDefinition
				case "comfunc"  : deftype  = DEFTYPE_COM   : bGlobal = false : goto *LAddDefinition
				case "usecom"   : deftype  = DEFTYPE_IFACE : bGlobal = false : goto *LAddDefinition
				
				case "module":
					bInModule = true
					deftype = DEFTYPE_NSPACE
					goto *LAddDefinition
				case "global":
					bInModule = false
					swbreak
				
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
							
							// ���ɃX�R�[�v����������ꍇ
							idx ++
							if ( nowTkType == TKTYPE_SCOPE ) {
								if ( nowTkStr != "@" ) {
									bGlobal = false
								}
							}
							idx --
							
							// #module
							if ( deftype == DEFTYPE_NSPACE ) {
								sDefIdent = strtrim(sDefIdent, 0, '"')
								
								// �����o�ϐ�������΃N���X
								if ( nowTkType == TKTYPE_IDENT ) {
									deftype = DEFTYPE_CLASS
								}
							}
							
							// ���̃g�[�N��
							NextToken
							swbreak
					swend
					
					// �O���Ɍ����Ȃ����͖̂�������
					if ( bInModule && bGlobal == false ) {
						swbreak
					}
					
					// ���X�g�ɒǉ�
					gosub *LAddDeflist
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
	// �萔�ƃ��W���[�����͖�������
	if ( deftype == DEFTYPE_CONST || deftype == DEFTYPE_NSPACE || deftype == DEFTYPE_CLASS ) {
		return
	}
	
	// ���������X�g���쐬����
	CreatePrmlist prmlist, deftype, tktypelist, tkstrlist, docdata, idx, cntToken
	cntPrm = stat
	
	// �o��
	LongStr_add hs, ";--------------------\n%index\n"+ sDefIdent +"\n\n\n%prm\n"
	
	// ���������X�g
	if ( deftype & DEFTYPE_CTYPE ) {
		LongStr_add hs, "("
	}
	
	repeat cntPrm
		if ( cnt ) { LongStr_add hs, ", " }
		
		LongStr_add hs, prmlist(cnt, 0)
		
		// �ȗ��l
		if ( prmlist(cnt, 2) != "" ) {
			LongStr_add hs, " = "+ prmlist(cnt, 2)
		}
	loop
	
	if ( deftype & DEFTYPE_CTYPE ) {
		LongStr_add hs, ")"
	}
	LongStr_add hs, "\n"
	
	// �������ڍ�
	repeat cntPrm
		LongStr_add hs, prmlist(cnt, 1) +" "+ prmlist(cnt, 0) +" : \n"
	loop
	
	// �c��
	LongStr_add hs, "\n%inst\n\n\n%href\n\n%group\n\n"
	return
	
//------------------------------------------------
// ���������X�g�̍쐬
//------------------------------------------------
#define AddPrmlist(%1,%2="",%3="",%4="") %1(cntPrm, 0) = %2 : %1(cntPrm, 1) = %3 : %1(cntPrm, 2) = %4 :\
/**/	logmes strf("AddPrmlist[%1] %%s, %%s, %%s", %2, %3, %4) /**/	:\
	cntPrm ++
	
#deffunc CreatePrmlist@autohs_mod array prmlist, int deftype, array tktypelist, array tkstrlist, array docdata, var idx, int cntToken,  local cntPrm, local sType, local sIdent, local sDefault
	sdim prmlist, , 20, 3
	dim  cntPrm
	sdim sIdent
	sdim sType
	sdim sDefault
	
	if ( deftype & DEFTYPE_MACRO ) {
		if ( nowTkType != TKTYPE_CIRCLE_L ) { return 0 }
		NextToken
	}
	if ( deftype & DEFTYPE_MODULE ) { AddPrmlist prmlist, "self", "modvar" }
	if ( deftype & DEFTYPE_DLL    ) { NextToken }
	if ( deftype & DEFTYPE_COM    ) { NextToken }
	if ( deftype & DEFTYPE_CMD    ) { return 0 }
	if ( deftype & DEFTYPE_IFACE  ) { return 0 }
	
	repeat
		if ( nowTkType == TKTYPE_END ) { break }
		
		// ���[�U��`���߁E�֐�
		if ( deftype & DEFTYPE_FUNC ) {
			
			sType = nowTkStr : NextToken
			
			if ( nowTkType == TKTYPE_IDENT ) {
				sIdent = nowTkStr
				NextToken
				
			} else {
				poke sIdent
			}
			
			// ���[�J�������͒ǉ����Ȃ�
			if ( sType != "local" ) {
				AddPrmlist prmlist, sIdent, sType
			}
			
		// Dll ���߁E�֐�
		} else : if ( deftype & DEFTYPE_DLL ) {
			
			if ( nowTkType != TKTYPE_IDENT ) { break }
			
			AddPrmlist prmlist, "p"+ (cntPrm + 1), nowTkStr
			NextToken
			
		// �}�N��
		} else : if ( deftype & DEFTYPE_MACRO ) {
			if ( nowTkType != TKTYPE_MACRO_PRM ) { break }
			
			NextToken
			if ( nowTkStr == "=" ) {
				NextToken
				sDefault = nowTkStr
				NextToken
			} else {
				poke sDefault
			}
			
			AddPrmlist prmlist, "p"+ (cntPrm + 1), "any", sDefault
		}
		
		// , ���΂�
		if ( nowTkType == TKTYPE_COMMA ) {
			NextToken
		} else {
			break
		}
	loop
	
	return cntPrm
	
//------------------------------------------------
// idx �̑���
//------------------------------------------------
#deffunc GetNextToken var idx, array tktypelist, array tkstrlist, array docdata, int cntToken,  local index
*LNextToken_core
	idx ++
	
	if ( idx >= cntToken ) {
		nowTkType = TKTYPE_ERROR
		nowTkStr  = ""
		return
	}
	
	switch ( nowTkType )
		case TKTYPE_COMMENT
			// ���ߍ��݃h�L�������g���̏ꍇ
			if ( lpeek(nowTkStr) == 0x2B2A2A2F ) {	// long("/**+")
				index       = 4
				len_max     = strlen(nowTkStr)
				typeDocdata = -1
				
				repeat
					index += CntSpaces(nowTkStr, index, true)	// ���s�𕶎���ƔF�߂�
					
					if ( (len_max - 2) <= index ) { break }
					
					if ( peek(nowTkStr, index) != '*' ) { break }
					index ++
					index += CntSpaces(nowTkStr, index)
					
					// ���ʎq�̎擾 ( ���^�C�v )
					if ( peek(nowTkStr, index) != '@' ) { continue }
					index ++
					index += CutIdent( stt_sIdent, nowTkStr, index )
					index += CntSpaces(nowTkStr, index)
					
					stt_sIdent = getpath(stt_sIdent, 16)
					
					// ':' ������
					if ( peek(nowTkStr, index) == ':' ) {
						index ++
						index += CntSpaces(nowTkStr, index)
						stt_bPermitEmptyLine = true			// ��s�ł���������Ȃ�
					} else {
						stt_bPermitEmptyLine = false
					}
					
					// doc data �̎擾 ( �s���܂� )
					getstr stt_sData, nowTkStr, index : index += strsize
					
					if ( stt_sIdent != "" ) {		// �ێ�
						typeDocdata = -1
						repeat DocData_MAX
							if ( stt_sIdent == stt_docdata_identlist(cnt) ) {
								typeDocdata = cnt
								break
							}
						loop
					}
					
					// �h�L�������g���̔z��ɒǉ�
					if ( typeDocdata < 0 ) {
						break
						
					} else {
						// �R����(:)���Ȃ�����̍s �� ��������
						if ( stt_bPermitEmptyLine == false && stt_sData == "" ) {
							continue
						}
						
						if ( docdata( typeDocdata ) != "" ) {
							docdata( typeDocdata ) += "\n"
						}
						docdata( typeDocdata ) += stt_sData
					}
				loop
			}
			
			goto *LNextToken_core
			swbreak
			
		case TKTYPE_BLANK
		case TKTYPE_SCOPE
			goto *LNextToken_core
			
		case TKTYPE_ESC_LINEFEED
			idx ++
			gosub *LNextToken_core	// ���s�̎��ɐi��
			swbreak
			
		default
			swbreak
	swend
	
	return
	
#global

	AutohsInitialize

#endif
