// HSP parse module - GatherIdent

#ifndef __HSP_PARSE_MODULE_GATHER_IDENT_AS__
#define __HSP_PARSE_MODULE_GATHER_IDENT_AS__

#include "Mo/MCStrSet.as"
#include "Mo/strutil.as"
#include "Mo/SearchFileEx.as"
#include "HPM_CutToken.as"
#include "HPM_Sub.as"

#module hpmod_gatherIdent mScript, mLength, mNews, mSttms, mFuncs, mMacros, mPreprocs, mVars, mLabels, mModnames, mIFaces, mIncludes, mSearchPath, mbPreLine

#uselib "user32.dll"
#func   CharLower@hpmod_gatherIdent "CharLowerA" sptr

#include "HPM_Header.as"

#define mv modvar hpmod_gatherIdent@
#define MAX_PATH 260

#deffunc local _init
	newmod ssDefined,   MCStrSet, KEYWORDS_ALL,       ","
	newmod ssDStates,   MCStrSet, KEYWORDS_STATEMENT, ","
	newmod ssDFuncs,    MCStrSet, KEYWORDS_FUNCTION,  ","
	newmod ssDMacros,   MCStrSet, KEYWORDS_MACRO,     ","
	newmod ssDPreprocs, MCStrSet, KEYWORDS_PREPROC,   ","
	return
	
//##############################################################################
//        �R���X�g���N�^�E�f�X�g���N�^
//##############################################################################
//------------------------------------------------
// ~i
//------------------------------------------------
#define global hpmgi_new(%1,%2,%3="") newmod %1, hpmod_gatherIdent@, %2, %3
#modinit str p2, str csv_news
	// �����o�̏���
	sdim   mScript, MAX_TEXTLEN + 1
	       mScript = p2
	
	sdim   mSearchPath, MAX_PATH
	newmod mNews,     MCStrSet, csv_news, ","
	newmod mSttms,    MCStrSet, "", ","
	newmod mFuncs,    MCStrSet, "", ","
	newmod mMacros,   MCStrSet, "", ","
	newmod mPreprocs, MCStrSet, "", ","
	newmod mVars,     MCStrSet, "", ","
	newmod mLabels,   MCStrSet, "", ","
	newmod mModnames, MCStrSet, "hsp", ","
	newmod mIFaces,   MCStrSet, "", ","
	newmod mIncludes, MCStrSet, "", ","
	
	mLength = strlen(mScript)
	
	return
	
//------------------------------------------------
// ~t
//------------------------------------------------
#define global hpmgi_delete(%1) delmod %1
;#modterm
;	return

//##############################################################################
//        ���������o�֐�
//##############################################################################
//------------------------------------------------
// ���̃g�[�N�����擾����
//------------------------------------------------
#modfunc hpmgi_getNextToken@hpmod_gatherIdent var tk, int index, int befTT
	c = peek(mScript, index)
	
	// �s���̏ꍇ
	if ( befTT == TKTYPE_NONE ) {
		if ( c == '#' ) {
			iFound = 1 + CntSpaces(mScript, index + 1)		// ��
			tk     = strmid(mScript, index, iFound) + CutName(mScript, index + iFound)
			return TKTYPE_PREPROC
		}
		
		if ( c == '*' ) {
			if ( peek(mScript, index + 1) == '@' ) {
				tk = "*@"+ CutName(mScript, index + 2)		// *@ �̎��͍D���Ȃ������o��
			} else {
				tk = "*" + CutName(mScript, index + 1)		// ���x����
			}
			return TKTYPE_LABEL
		}
	}
	
	// ���ʎq
	if ( IsIdentTop(c) ) {
		tk = CutName(mScript, index)
		return TKTYPE_NAME
	}
	
	// ����
	if ( c == ':' || c == '{' || c == '}' || IsNewLine(c) ) {
		if ( c == 0x0D && peek(mScript, index + 1) == 0x0A ) {
			lpoke tk, 0, 0x00000A0D		// CRLF
		} else {
			tk = strf("%c", c)
		}
		return TKTYPE_END
	}
	
	// ���l
	if ( c == '%' ) {
		if ( mbPreLine ) {
			if ( IsDigit( peek(mScript, index + 1) ) ) {
				tk = "%"+ CutNum_Dgt(mScript, index + 1)
			} else {
				tk = "%"+ CutName(mScript, index + 1)
			}
			return TKTYPE_PARAMETER
		} else {
			tk = "%"+ CutNum_Bin(mScript, index + 1)
			return TKTYPE_NUMBER
		}
	}
	if ( c == '$' ) {
		tk = "$"+ CutNum_Hex(mScript, index + 1)
		return TKTYPE_NUMBER
	}
	if ( IsDigit(c) ) {
		if ( c == '0' ) {
			c2 = peek(mScript, index + 1)
			
			if ( c2 == 'x' || c2 == 'X' ) {
				tk = strmid(mScript, index, 2) + CutNum_Hex(mScript, index + 2)
			} else : if ( c2 == 'b' || c2 == 'B' ) {
				tk = strmid(mScript, index, 2) + CutNum_Bin(mScript, index + 2)
			} else {
				tk = CutNum_Dgt(mScript, index)
			}
		} else {
			tk = CutNum_Dgt(mScript, index)
		}
		return TKTYPE_NUMBER 
	}
	
	// ������ or �����萔
	if ( c == '"' || c == '\'' ) {
		tk = CutStr_or_Char(mScript, index, c)
		return cwhich_int(c == '\'', TKTYPE_CHAR, TKTYPE_STRING)
	}
	
	// �����s������
	if ( c == '{' && peek(mScript, index + 1) == '"' ) {
		tk = CutStrMulti(mScript, index)
		return TKTYPE_STRING
	}
	
	// Comment
	if ( c == ';' || wpeek(mScript, index) == 0x2F2F ) {
		getstr tk, mScript, index		// ���s�܂Ŏ��o��
		return TKTYPE_COMMENT
	}
	
	// Comment (multi)
	if ( wpeek(mScript, index) == 0x2A2F ) {
		iFound = instr(mScript, index + 2, "*/")
		if ( iFound < 0 ) {
			tk = strmid(mScript, index, mLength - index)	// �ȍ~���ׂăR�����g
		} else {
			tk = strmid(mScript, index, iFound + 4)			// �J�n�E�I�����܂�
		}
		return TKTYPE_COMMENT
	}
	
	// @Scope
	if ( c == '@' ) {
		// module �w��
		if ( IsIdentTop(peek(mScript, index + 1)) ) {
			tk = "@"+ CutName(mScript, index + 1)
			return TKTYPE_SCOPE
			
		// global �w��
		} else {
			poke tk					// NULL �ɂ���
			return TKTYPE_ANY
		}
	}
	
	// ����ȊO�̋L���̏ꍇ
	if ( IsIdent(c) == 0 ) {
		poke tk		// NULL �ɂ���
		return TKTYPE_ANY
	}
	
	// �H�H�H
	if ( IsSJIS1st(c) ) {
		tk = strmid(mScript, index, 2)	// ��������
	} else {
		tk = strf("%c", c)
	}
	logmes "Error!! : "+ logv(tk) +" : "+ logv(c)
	return TKTYPE_ERROR
	
//##############################################################################
//                �����o�֐�
//##############################################################################
//------------------------------------------------
// �����o�ϐ���Ԃ�
//------------------------------------------------
#define ctype mIdents(%1) mIdents_var(mIdents_core(thismod,%1))
#modcfunc mIdents_core@hpmod_gatherIdent int p2
//*
	switch p2
		case IDENTTYPE_OTHER     : mIdents_var = mNews     : swbreak
		case IDENTTYPE_STATEMENT : mIdents_var = mSttms    : swbreak
		case IDENTTYPE_FUNCTION  : mIdents_var = mFuncs    : swbreak
		case IDENTTYPE_MACRO     : mIdents_var = mMacros   : swbreak
		case IDENTTYPE_PREPROC   : mIdents_var = mPreprocs : swbreak
		case IDENTTYPE_VARIABLE  : mIdents_var = mVars     : swbreak
		case IDENTTYPE_LABEL     : mIdents_var = mLabels   : swbreak
		case IDENTTYPE_MODNAME   : mIdents_var = mModnames : swbreak
		case IDENTTYPE_IFACE     : mIdents_var = mIFaces   : swbreak
	swend
	return 0
/*/
	switch p2
		case IDENTTYPE_OTHER     : dup mIdents_var, mNews     : swbreak
		case IDENTTYPE_STATEMENT : dup mIdents_var, mSttms    : swbreak
		case IDENTTYPE_FUNCTION  : dup mIdents_var, mFuncs    : swbreak
		case IDENTTYPE_MACRO     : dup mIdents_var, mMacros   : swbreak
		case IDENTTYPE_PREPROC   : dup mIdents_var, mPreprocs : swbreak
		case IDENTTYPE_VARIABLE  : dup mIdents_var, mVars     : swbreak
		case IDENTTYPE_LABEL     : dup mIdents_var, mLabels   : swbreak
		case IDENTTYPE_MODNAME   : dup mIdents_var, mModnames : swbreak
		case IDENTTYPE_IFACE     : dup mIdents_var, mIFaces   : swbreak
	swend
	return 0
//*/
	
//------------------------------------------------
// �`�F�b�N�E�e���v���[�g
//------------------------------------------------
#define ctype TM_CheckIsfunc1(%1) return( StrSet_findStr(%1, p2) >= 0 )
#define ctype TM_CheckIsfunc2(%1,%2) if ( StrSet_findStr(%2, p2) >= 0 ) { return true } TM_CheckIsfunc1(%1)

//------------------------------------------------
// is �`
//------------------------------------------------
#modcfunc hpmgi_isIdent_type str p2, int ident_type
	switch ident_type
		case IDENTTYPE_OTHER     : TM_CheckIsfunc2( mNews,     ssDefined )
		case IDENTTYPE_STATEMENT : TM_CheckIsfunc2( mSttms,    ssDStates )
		case IDENTTYPE_FUNCTION  : TM_CheckIsfunc2( mFuncs,    ssDFuncs )
		case IDENTTYPE_MACRO     : TM_CheckIsfunc2( mMacros,   ssDMacros )
		case IDENTTYPE_PREPROC   : TM_CheckIsfunc2( mPreprocs, ssDPreprocs )
		case IDENTTYPE_VARIABLE  : TM_CheckIsfunc1( mVars )
		case IDENTTYPE_LABEL     : TM_CheckIsfunc1( mLabels )
		case IDENTTYPE_MODNAME   : TM_CheckIsfunc1( mModnames )
		case IDENTTYPE_IFACE     : TM_CheckIsfunc1( mIFaces )
	swend
	return false
	
#define global ctype hpmgi_isReserved(%1,%2)  hpmgi_isIdent_type(%1, %2, IDENTTYPE_OTHER@hpmod_gatherIdent)
#define global ctype hpmgi_isStatement(%1,%2) hpmgi_isIdent_type(%1, %2, IDENTTYPE_STATEMENT@hpmod_gatherIdent)
#define global ctype hpmgi_isFunction(%1,%2)  hpmgi_isIdent_type(%1, %2, IDENTTYPE_FUNCTION@hpmod_gatherIdent)
#define global ctype hpmgi_isMacro(%1,%2)     hpmgi_isIdent_type(%1, %2, IDENTTYPE_MACRO@hpmod_gatherIdent)
#define global ctype hpmgi_isVariable(%1,%2)  hpmgi_isIdent_type(%1, %2, IDENTTYPE_VARIABLE@hpmod_gatherIdent)
#define global ctype hpmgi_isLabel(%1,%2)     hpmgi_isIdent_type(%1, %2, IDENTTYPE_LABEL@hpmod_gatherIdent)
#define global ctype hpmgi_isModname(%1,%2)   hpmgi_isIdent_type(%1, %2, IDENTTYPE_MODNAME@hpmod_gatherIdent)
#define global ctype hpmgi_isIFace(%1,%2)     hpmgi_isIdent_type(%1, %2, IDENTTYPE_IFACE@hpmod_gatherIdent)

//------------------------------------------------
// ���X�g�𓾂�
//------------------------------------------------
#modfunc hpmgi_getTokenList var p2, int ident_type, local _sbuf
	sdim _sbuf, MAX_TEXTLEN + 1
	StrSet_getall_tobuf mIdents(ident_type), _sbuf
	
	dim        p2
	StrSet_new p2, _sbuf, ","
	return
	
#define global hpmgi_getNews(%1,%2)       hpmgi_getTokenList %1,%2,IDENTTYPE_OTHER@hpmod_gatherIdent
#define global hpmgi_getStatements(%1,%2) hpmgi_getTokenList %1,%2,IDENTTYPE_STATEMENT@hpmod_gatherIdent
#define global hpmgi_getFunctions(%1,%2)  hpmgi_getTokenList %1,%2,IDENTTYPE_FUNCTION@hpmod_gatherIdent
#define global hpmgi_getMacros(%1,%2)     hpmgi_getTokenList %1,%2,IDENTTYPE_MACRO@hpmod_gatherIdent
#define global hpmgi_getVariables(%1,%2)  hpmgi_getTokenList %1,%2,IDENTTYPE_VARIABLE@hpmod_gatherIdent
#define global hpmgi_getLabels(%1,%2)     hpmgi_getTokenList %1,%2,IDENTTYPE_LABEL@hpmod_gatherIdent
#define global hpmgi_getModnames(%1,%2)   hpmgi_getTokenList %1,%2,IDENTTYPE_MODNAME@hpmod_gatherIdent
#define global hpmgi_getIFaces(%1,%2)     hpmgi_getTokenList %1,%2,IDENTTYPE_IFACE@hpmod_gatherIdent

//##############################################################################
//                �ǉ��E�폜�֐�
//##############################################################################
//------------------------------------------------
// ���ʎq�̓o�^
//------------------------------------------------
#modfunc hpmgi_entry str p2, int ident_type
	if ( hpmgi_isReserved(thismod, p2) ) { return false }
	
	StrSet_add mNews,               p2		// �\��ꈵ��
	StrSet_add mIdents(ident_type), p2		// �d�����Ȃ��悤�ɂ���
	return stat								// �ǉ�������^
	
//------------------------------------------------
// ���ʎq�̓o�^����
//------------------------------------------------
#modfunc hpmgi_remove str p2, int ident_type
	if ( hpmgi_isReserved  (thismod, p2) == false ) { return false }
	if ( hpmgi_isIdent_type(thismod, p2, ident_type) ) {
		StrSet_delstr mNews,               p2		// �\��Ȃ��ɕύX
		StrSet_delstr mIdents(ident_type), p2		// �폜����
	}
	return true
	
//------------------------------------------------
// include �����p�X��ǉ�����
//------------------------------------------------
#modfunc hpmgi_addSearchPath str p2, local path, local len
	len  = strlen(p2)
	sdim path, len + 1
	path = p2
	c    = peek(path, len - 1)
	if ( c == '/' || c == '\\' ) { wpoke path, len - 1, 0 }
	StrReplace path, "/", "\\"
	
	if ( instr(mSearchPath, 0, path) < 0 ) {
		mSearchPath = path +";"
		return true
	}
	return false
	
//##############################################################################
//                ���W�֐�
//##############################################################################
//------------------------------------------------
// ���W�֐�
//------------------------------------------------
#modfunc hpmgi_gather  local index, local n, local nowtk, local tklen, local nowTT, local befTT, local stmp, local scope, local bRet
	sdim nowtk
	sdim scope
	index = 0
	n     = 0
	tklen = 0
	nowTT = TKTYPE_NONE
	befTT = TKTYPE_NONE
	bRet  = false
	
	sdim stmp, 64
	
	repeat
		// �󔒂��΂�
		index += CntSpaces(mScript, index, false)
		
		// �Ō�܂Ŏ擾�ł�����I������
		if ( mLength <= index ) { break }
		
		// ���̃g�[�N�����擾
		repeat
			hpmgi_getNextToken thismod, nowtk, index, befTT : nowTT = stat
			if ( nowTT == TKTYPE_ERROR ) {
				bRet = true
				break
			}
			
			// �����Ƃ����g�[�N���Ȃ�n�j
			if ( peek(nowtk) ) { break }
			
			// �L���̏ꍇ
			index ++
			if ( peek(mScript, index) == 0 ) { break }
		loop
		
		// ���ɍŌ�܂Ŏ擾����Ă���
		if ( peek(mScript, index) == 0 || bRet ) { break }
		
;		logmes "taken : "+ logv(nowtk) ;+"\t: "+ logv(nowTT)
		
		CharLower varptr(nowtk)
		tklen =   strlen(nowtk)
		
		// �g�[�N���̎�ނ��Ƃɏ������킯��
		gosub *L_ProcToken
		
		// �ʒu��i�߂�
		index += tklen		// �V�����g�[�N���̒���������
		
		befTT = nowTT
;		await 0
	loop
	
	return bRet
	
//------------------------------------------------
// �g�[�N�����Ƃ̏���������
//------------------------------------------------
*L_ProcToken
	switch nowTT
	
	// ���̏I��
	case TKTYPE_END
		nowTT = TKTYPE_NONE
		swbreak
		
	// ���x��
	case TKTYPE_LABEL
		if ( peek(nowtk, 1) == '@' ) { swbreak }
		
		stmp = strmid(nowtk, 1, tklen - 1)			// * ���Ȃ�
		tklen --
		index ++
		
		// �o�^
		hpmgi_remove thismod, stmp, IDENTTYPE_VARIABLE	// �ϐ��ł͂Ȃ�����
		hpmgi_entry  thismod, stmp, IDENTTYPE_LABEL
		swbreak
		
	// �R�����g
	case TKTYPE_COMMENT
		nowTT = befTT			// ���S�ɖ���
		swbreak
		
	// �v���v���Z�b�T����
	case TKTYPE_PREPROC
		index += tklen						// ��ɐi�߂Ă���
		index += CntSpaces(mScript, index)	// skip
		
		poke nowtk, 0, ' '					// '#' ���󔒕����ɏ㏑��
		StripBlanks nowtk, tklen			// �O���̋󔒂�����
		tklen = stat						// ��蕥������̒���
		
		// �L�[���[�h�ɂ���ĕς��
		switch nowtk
			case "define"   : 
			case "const"    : 
			case "enum"     : bMacro = true : gosub *LDefineFunction : bMacro = false : swbreak
			case "func"     : 
			case "deffunc"  : 
			case "modfunc"  : 
			case "comfunc"  : gosub *LDefineFunction : swbreak
			case "cfunc"    : 
			case "defcfunc" : bFunc  = true : gosub *LDefineFunction : bFunc  = false : swbreak
			case "cmd"      : bCmd   = true : gosub *LDefineFunction : bCmd   = false : swbreak
			case "usecom"	: bIFace = true : gosub *LDefineFunction : bIFace = false : swbreak
			case "module"
				// ���W���[�����̎擾
				if ( peek(mScript, index) == '"' ) {
					nowtk = CutStr(mScript, index)		// ������Ƃ��Ď擾����
					tklen = strlen(nowtk)
					nowtk = strmid(nowtk, 1, tklen - 2)
				} else {
					tklen = CutIdent(nowtk, mScript, index)
				}
				CharLower varptr(nowtk)
				
				// �o�^
				hpmgi_entry thismod, nowtk, IDENTTYPE_MODNAME
				
				// �ݒ�
				scope = nowtk
				swbreak
				
			case "global" : poke scope : swbreak
			
			case "include"
			case "addition"
				// �t�@�C�������擾����
				if ( peek(mScript, index) == '"' ) {
					getstr stmp, mScript, index + 1, '"'
					
					StrReplace stmp, "\\\\", "\\"
					tklen = strlen(stmp)
					
					StrSet_xadd mIncludes, stmp
					if ( stat ) {					// �ǉ������ꍇ
						// �t�@�C����ǂݍ���
						SearchFileEx mSearchPath, stmp
						if ( refstr != "" ) {
							stmp = getpath(refstr, 16)
							exist stmp
							sdim        filedata, strsize + 1
							bload stmp, filedata, strsize
							StrInsert mScript, index, "\n"+ filedata, mLength, strsize
							mLength = stat
							
							hpmgi_addSearchPath thismod, getpath(stmp, 32)
						}
					}
				}
				swbreak
		swend
		tklen = 0
		
		swbreak
		
	// ���ʎq
	case TKTYPE_NAME
;		logmes "nameToken : "+ nowtk
		
		// ����`�Ȃ�ϐ�
		hpmgi_entry thismod, nowtk, IDENTTYPE_VARIABLE
		if ( stat ) {
			nowTT = TKTYPE_VARIABLE
		} else {
			nowTT = TKTYPE_KEYWORD
		}
		swbreak
		
	// ���W���[����
	case TKTYPE_SCOPE
		hpmgi_entry thismod, strmid(nowtk, 1, tklen - 1), IDENTTYPE_MODNAME
		if ( stat ) {
			logmes "SCOPE : "+ nowtk
		}
		swbreak
		
	swend
	
	return
	
//------------------------------------------------
// ���ʎq�o�^�̏���
// 
// @ enum, const, define, deffunc, defcfunc,
//   modfunc, func, cfunc, usecom
//------------------------------------------------
*LDefineFunction
	// ���ʎq���擾
	index += CutIdent(nowtk, mScript, index)
	index += CntSpaces(mScript, index)
	
	// �������ɂ���
	CharLower varptr(nowtk)
	
	// ����̃L�[���[�h�Ȃ疳������
	switch nowtk
	case "ctype"
	case "global"
	case "local"
		goto *LDefineFunction
	swend
	
	// �X�R�[�v���Z�b�g����
	gosub *LSetScope
	
	// �o�^����
	if ( hpmgi_isReserved( thismod, nowtk ) == false ) {
		
		if ( bMacro ) {
			hpmgi_entry thismod, nowtk, IDENTTYPE_MACRO		// �}�N��
		} else : if ( bFunc ) {
			hpmgi_entry thismod, nowtk, IDENTTYPE_FUNCTION	// �֐�
		} else : if ( bIFace ) {
			hpmgi_entry thismod, nowtk, IDENTTYPE_IFACE		// �C���^�[�t�F�[�X
		} else : if ( bCmd ) {
			hpmgi_entry thismod, nowtk, IDENTTYPE_OTHER		// �Ƃ肠�����o�^����
		} else {
			hpmgi_entry thismod, nowtk, IDENTTYPE_STATEMENT	// ����
		}
	}
	tklen = 0
	return
	
//------------------------------------------------
// �X�R�[�v��ݒ肷��
//------------------------------------------------
*LSetScope
	if ( peek(mScript, index) == '@' ) {
		index ++
		index += CutIdent(stmp, mScript, index)
	} else {
		stmp = scope
	}
	nowtk += "@"+ getpath(stmp, 16)
	return
	
#global
_init@hpmod_gatherIdent
hpmgi_new mdefgi, ""

//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

#include "HPM_header.as"
	
	sdim   buf
	sdim   script, MAX_TEXTLEN + 1
	
	mesbox script, ginfo(12), ginfo(13) - 30, 1, MAX_TEXTLEN + 1
	button gosub "Run", *go
	stop
	
*go
	hpmgi_new    gi, script
	hpmgi_gather gi
	hpmgi_getStatements gi, ss		// ��`���ꂽ���ʎq�����ׂĎ��o��
	
	StrSet_chgChar      ss, "\n"
	StrSet_getall_tobuf ss, buf
	objprm 0, buf
	
	hpmgi_delete gi
	return
	
#endif

#endif
