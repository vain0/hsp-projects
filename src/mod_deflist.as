// definition list

#ifndef __DEFINITION_LIST_MODULE_AS__
#define __DEFINITION_LIST_MODULE_AS__

#include "Mo/strutil.as"
#include "Mo/HPM_GetToken.as"
#include "Mo/pvalptr.as"

#module deflist mScript, mCount, mFileName, mFilePath, mIdent, mLn, mType, mScope, mInclude, mCntInclude

#include "Mo/HPM_Header.as"

//######## �萔�E�}�N�� ########################################################
#define true  1
#define false 0

//------------------------------------------------
// DEFTYPE
//------------------------------------------------
#const global DEFTYPE_LABEL		0x0001		// ���x��
#const global DEFTYPE_MACRO		0x0002		// �}�N��
#const global DEFTYPE_CONST		0x0004		// �萔
#const global DEFTYPE_FUNC		0x0008		// ���߁E�֐�
#const global DEFTYPE_DLL		0x0010		// DLL����
#const global DEFTYPE_CMD		0x0020		// HPI�R�}���h

#const global DEFTYPE_CTYPE		0x0100		// CTYPE
#const global DEFTYPE_MODULE	0x0200		// ���W���[�������o

//------------------------------------------------
// ����ȋ�Ԗ�
//------------------------------------------------
#define global AREA_GLOBAL "global"
#define global AREA_ALL    "*"

//##############################################################################
//                �����o�֐�
//##############################################################################
//------------------------------------------------
// �ꊇ���Ċi�[����
// 
// @ p2 �𕉐��ɂ���ƒǉ��ɂȂ�
//------------------------------------------------
#define global DefList_set(%1,%2,%3,%4,%5,%6) _DefList_set %1,%2,%3,%4,%5,%6
#define global DefList_add(%1,%2,%3,%4,%5) _DefList_set %1,-1,%2,%3,%4,%5
#modfunc _DefList_set int p2, str ident, int linenum, int deftype, str scope, local iItem
	if ( p2 < 0 ) { iItem = mCount : mCount ++ } else { iItem = p2 }
	mIdent(iItem) = ident
	mLn   (iItem) = linenum
	mType (iItem) = deftype
	mScope(iItem) = scope
	return iItem
	
//------------------------------------------------
// �ꊇ���Ď擾����
//------------------------------------------------
#modfunc DefList_get int p2, var ident, var linenum, var deftype, var scope
	ident   = mIdent(p2)
	linenum = mLn   (p2)
	deftype = mType (p2)
	scope   = mScope(p2)
	return
	
//------------------------------------------------
// �e�����o���Ƃ� getter
//------------------------------------------------
#modfunc DefList_getScript var script
	script = mScript
	return
	
#modcfunc DefList_getCount
	return mCount
	
#modcfunc DefList_getFilePath
	return mFilePath
	
#modcfunc DefList_getFileName
	return mFileName
	
#modcfunc DefList_getIdent int p2
	return mIdent(p2)
	
#modcfunc DefList_getLn int p2
	return mLn(p2)
	
#modcfunc DefList_getDefType int p2
	return mType(p2)
	
#modcfunc DefList_getScope int p2
	return mScope(p2)
	
#modcfunc DefList_getCntInclude
	return mCntInclude
	
#modcfunc DefList_getInclude int p2
	return mInclude(p2)
	
//------------------------------------------------
// include �t�@�C����z��ɂ��ĕԂ�
//------------------------------------------------
#modfunc DefList_getIncludeArray array p2
	sdim p2,, mCntInclude
	repeat    mCntInclude
		p2(cnt) = mInclude(cnt)
	loop
	return
	
//##############################################################################
//                ��`�����X�g�A�b�v����
//##############################################################################
//------------------------------------------------
// �w�蕶���C���f�b�N�X�̂���s�ԍ����擾����
// @private
//------------------------------------------------
#defcfunc GetLinenumByIndex@deflist var text, int p2, int iStart, int iStartLineNum, local linenum, local c
	linenum = iStartLineNum
	
	if ( iStart > p2 ) { return iStartLineNum }
	
	repeat p2 - iStart, iStart
		c = peek( text, cnt )
		if ( c == 0x0D || c == 0x0A ) {		// ���s�R�[�h
			linenum ++
			if ( c == 0x0D && peek(text, cnt + 1) == 0x0A ) {
				continue cnt + 2			// CRLF �� 2byte
			}
		} else : if ( IsSJIS1st(c) ) {		// �S�p����
			continue cnt + 2				// ���� 1byte �͌���K�v�Ȃ�
			
		} else : if ( c == 0 ) {			// '\0' == �I�[
			break
		}
	loop
	
	return linenum
	
//------------------------------------------------	
// ���W���[����Ԗ������肷��
// @private
//------------------------------------------------
#defcfunc MakeModuleName@deflist var scope, var script, int offset, str defscope, local index
	index = offset
	if ( peek(script, index) == '@' ) {
		index ++
		index += CutIdent(scope, script, index)
		if ( stat == 0 ) { scope = AREA_GLOBAL }
	} else {
		scope = defscope
	}
	return index - offset
	
//------------------------------------------------
// �͈͖����쐬����
// @private
//------------------------------------------------
#deffunc MakeScope@deflist var scope, str defscope, int deftype, int bGlobal, int bLocal
	if ( bGlobal ) { scope = AREA_ALL : return }
	
	scope = defscope
	
	if ( bLocal ) { scope += " [local]" }
	return
	
//------------------------------------------------
// ��`�����X�g�A�b�v����
//------------------------------------------------
#modfunc ListupDefinition  local stmp, local index, local textlen, local areaScope, local scope, local linenum, local nowTT, local befTT, local bPreLine, local bGlobal, local bLocal, local deftype, local uniqueCount
	index   = 0
	textlen = strlen(mScript)
	sdim stmp, 250
	sdim name
	sdim scope
	sdim areaScope
	
	dim listIndex, 5	// �����C���f�b�N�X�̃��X�g( �������̂��߂Ɏg�� )
	
	uniqueCount = 0
	areaScope   = AREA_GLOBAL
	
	repeat
		// �󔒂��΂�
		index += CntSpaces(mScript, index)
		
		// �Ō�܂Ŏ擾�ł�����I������
		if ( textlen <= index ) { break }
		
		// ���̃g�[�N�����擾
		GetNextToken nowtk, mScript, index, befTT, bPreLine : nowTT = stat
		if ( nowTT == TOKENTYPE_ERROR ) {
			index += strlen(nowtk)
			continue				// �P���ɖ������邾��
		}
		
		// �g�[�N���̎�ނ��Ƃɏ������킯��
		gosub *L_ProcToken
		
		// �C���f�b�N�X��i�߂�
		index += strlen(nowtk)
		
		befTT = nowTT
	loop
	
	return mCount
	
*L_ProcToken
	switch nowTT
	
	case TOKENTYPE_COMMENT : nowTT = befTT : swbreak
	
	case TOKENTYPE_END		// ���̏I��
		nowTT = TOKENTYPE_NONE
		if ( bPreLine && IsNewLine( peek(nowtk) ) ) {
			bPreLine = false
		}
		swbreak
		
	case TOKENTYPE_LABEL	// ���x��
		if ( befTT == TOKENTYPE_NONE ) {	// �s���̏ꍇ�̂�
			
			index += strlen(nowtk)
			index += MakeModuleName(scope, mScript, index, areaScope)
			
			// ���X�g�ɒǉ�
			deftype = DEFTYPE_LABEL
			gosub *L_AddDefList
		}
		swbreak
		
	case TOKENTYPE_PREPROC	// �v���v���Z�b�T����
		
		if ( IsPreproc(nowtk) ) {
			bPreLine = true
			index   += strlen(nowtk)
			deftype  = 0
			bGlobal  = true
			bLocal   = false
			
			// # �Ƌ󔒂���������
			getstr nowtk, nowtk, 1 + CntSpaces(nowtk, 1)
			
			switch ( getpath(nowtk, 16) )
			case "module"
				index += CntSpaces(mScript, index)				// ignore ��
				if ( peek(mScript, index) == '"' ) { index ++ }	// #module "modname" �̌`���ɑΉ�
				index += CutIdent(areaScope, mScript, index)	// ��Ԗ�
				if ( stat == 0 ) {
					areaScope   = strf("m%02d [unique]", uniqueCount)	// ���j�[�N�ȋ�Ԗ�
					uniqueCount ++
				}
				swbreak
			case "global" : areaScope = AREA_GLOBAL : swbreak	// ���W���[����Ԃ���̒E�o
			
			case "include"
			case "addition"
				index += CntSpaces(mScript, index)
				if ( peek(mScript, index) == '"' ) { index ++ }
				getstr nowtk, mScript, index, '"'
				index                += strsize
				mInclude(mCntInclude) = nowtk
				mCntInclude ++
;				logmes "#include "+ nowtk
				swbreak
				
			case "modfunc"  : deftype  = DEFTYPE_MODULE
			case "deffunc"  : deftype |= DEFTYPE_FUNC                    : goto *L_AddDefinition
			case "modcfunc" : deftype  = DEFTYPE_MODULE
			case "defcfunc" : deftype |= DEFTYPE_FUNC   | DEFTYPE_CTYPE  : goto *L_AddDefinition
			case "define"   : deftype  = DEFTYPE_MACRO : bGlobal = false : goto *L_AddDefinition
			case "const"
			case "enum"     : deftype  = DEFTYPE_CONST : bGlobal = false : goto *L_AddDefinition
			case "cfunc"    : deftype  = DEFTYPE_CTYPE
			case "func"     : deftype |= DEFTYPE_DLL   : bGlobal = false : goto *L_AddDefinition
			case "cmd"      : deftype  = DEFTYPE_CMD   : bGlobal = true  : goto *L_AddDefinition
*L_AddDefinition
				index += CntSpaces(mScript, index)			// �� ignore
				index += CutIdent(nowtk, mScript, index)	// ���ʎq�����o��
				
				switch getpath( nowtk, 16 )
					case "global" : bGlobal  = true                  : goto *L_AddDefinition
					case "ctype"  : deftype |= DEFTYPE_CTYPE         : goto *L_AddDefinition
					case "local"  : bGlobal  = false : bLocal = true : goto *L_AddDefinition
					case "double" : goto *L_AddDefinition
				swend
				
				index += MakeModuleName(scope, mScript, index, areaScope)
				if ( stat ) {	// scope != areaScope ->("ident@scope")
					bGlobal = false
				}
				
				// �͈͂��쐬
				MakeScope scope, areaScope, deftype, bGlobal, bLocal
				
				// ���X�g�ɒǉ�
				gosub *L_AddDefList
				swbreak
			swend
			
			poke nowtk
		}
		swbreak
		
	swend
	return
	
*L_AddDefList
	gosub *L_SetLinenum			// linenum �ɓK�؂Ȓl��������
	listIndex(mCount) = index
	DefList_Add thismod, nowtk, linenum, deftype, scope
	return
	
*L_SetLinenum
	if ( mCount <= 0 ) {
		linenum = GetLinenumByIndex(mScript, index, 0, 0)
	} else {
		linenum = GetLinenumByIndex(mScript, index, listIndex(mCount - 1), mLn(mCount - 1))
	}
	return
	
//------------------------------------------------
// �R���X�g���N�^
//------------------------------------------------
#modinit str path
	// �����o�ϐ���������
	sdim mIdent,, 5
	dim  mLn,     5
	dim  mType,   5
	sdim mScope,, 5
	sdim mFileName
	sdim mFilePath, MAX_PATH
	sdim mInclude,  MAX_PATH
	dim  mCntInclude
	
	mFilePath = path
	mFileName = getpath(mFilePath, 8)
	
	// �X�N���v�g��ǂݍ���
	notesel  mScript
	noteload mFilePath
	noteunsel
	
	// ��`�����X�g�A�b�v
	ListupDefinition thismod
	
	return getaptr(thismod)
	
#global

#endif
