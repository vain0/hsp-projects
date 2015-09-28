// HSP Identer

#ifndef IG_MODULECLASS_HSP_IDENTIFY_COLLECTOR_AS
#define IG_MODULECLASS_HSP_IDENTIFY_COLLECTOR_AS

#include "Mo/easyhash.as"
#include "Mo/SearchFileEx.as"
#include "Mo/mod_array.as"

#module MCHspIdenter mlistTkType, mlistTkStr, mfOpt, mpathCommon, mSearchPath, \
keylist_all, keylist_sttm, keylist_func, keylist_sysvar, keylist_preproc, keylist_macro, keylist_modname, \
keylist_ppword, keylist_const, keylist_defsttm, keylist_deffunc, keylist_dllfunc, keylist_iface, keylist_var

#include "HspLexer_header.as"

#define true  1
#define false 0

//------------------------------------------------
// �\�z
//------------------------------------------------
#modinit array listTkType, array listTkStr
	sdim mSearchPath, 260
	mSearchPath = ""
	mfOpt       = 0
	
	keylist_all       = "," + KeyWords_All
	keylist_sttm      = "," + KeyWords_Sttm
	keylist_func      = "," + KeyWords_Func
	keylist_sysvar    = "," + KeyWords_Sysvar
	keylist_preproc   = "," + KeyWords_PreProc
	keylist_macro     = "," + KeyWords_Macro
	keylist_modname   = "," + KeyWords_ModName
	keylist_ppword    = "," + KeyWords_PPWord
	keylist_const     = "," + KeyWords_Const
	keylist_defsttm   = ","
	keylist_deffunc   = ","
	keylist_dllfunc   = ","
	keylist_iface     = ","
	keylist_var       = ","
	
	ArrayCopy mlistTkType, listTkType
	ArrayCopy mlistTkStr,  listTkStr
	
	return
	
//------------------------------------------------
// �ݒ�
//------------------------------------------------
#modfunc hspIdenter_set int fOpt
	mfOpt = fOpt
	return
	
//------------------------------------------------
// common �p�X
//------------------------------------------------
#modfunc hspIdenter_setCommonPath str pathCommon
	mpathCommon = pathCommon
	hspIdenter_appendSearchPath thismod, mpathCommon
	return
	
//------------------------------------------------
// �����p�X��ǉ�����
//------------------------------------------------
#modfunc hspIdenter_appendSearchPath str path_,  local path, local c, local len
	sdim path, MAX_PATH
	path = path_
	len  = strlen(path)
	c    = peek(path, len - 1)
	if ( c == '/' ) { len -- }
	if ( c != '\\') { wpoke path, len, '\\' : len ++ }
	if ( instr(mSearchPath, 0, ";" + path + ";") < 0 ) {
		mSearchPath += path + ";"
	}
	return
	
//------------------------------------------------
// �\���̒ǉ�
//------------------------------------------------
#define ctype FTC_add(%1, %2, %3) xcase %1: if ( instr(%2, 0, "," + (%3) + ",") >= 0 ) { %2 += (%3) }
#modfunc hspIdenter_reserveIdent str src_, int type,  local src
	src = getpath(src_, 16)
	if ( peek(src, strlen(src) - 1) != ',' ) { src += "," }
	
	switch ( type )
		FTC_add( TkTypeEx_Sttm,    keylist_sttm,    src )
		FTC_add( TkTypeEx_Func,    keylist_func,    src )
		FTC_add( TkTypeEx_Sysvar,  keylist_sysvar,  src )
		FTC_add( TkTypeEx_PreProc, keylist_preproc, src )
		FTC_add( TkTypeEx_Macro,   keylist_macro,   src )
		FTC_add( TkTypeEx_Modname, keylist_modname, src )
		FTC_add( TkTypeEx_PPWord,  keylist_ppword,  src )
		FTC_add( TkTypeEx_Const,   keylist_const,   src )
		FTC_add( TkTypeEx_DefSttm, keylist_defsttm, src )
		FTC_add( TkTypeEx_DefFunc, keylist_deffunc, src )
		FTC_add( TkTypeEx_DllFunc, keylist_dllfunc, src )
		FTC_add( TkTypeEx_IFace,   keylist_iface,   src )
		FTC_add( TkTypeEx_Var,     keylist_var,     src )
	swend
	return
	
#undef FTC_add
	
//------------------------------------------------
// ���ʎq�̃^�C�v�̗L��
//------------------------------------------------
#define ctype FT_exists(%1, %2, %3) if ( instr(%2, 0, "," + (%3) + ",") >= 0 ) { return %1 }
#modcfunc hspIdenter_exists str src_,  local src
	src = getpath(src_, 16)
	
	FT_exists( TkTypeEx_Sttm,    keylist_sttm,    src )
	FT_exists( TkTypeEx_Func,    keylist_func,    src )
	FT_exists( TkTypeEx_Sysvar,  keylist_sysvar,  src )
	FT_exists( TkTypeEx_PreProc, keylist_preproc, src )
	FT_exists( TkTypeEx_Macro,   keylist_macro,   src )
	FT_exists( TkTypeEx_Modname, keylist_modname, src )
	FT_exists( TkTypeEx_PPWord,  keylist_ppword,  src )
	FT_exists( TkTypeEx_Const,   keylist_const,   src )
	FT_exists( TkTypeEx_DefSttm, keylist_defsttm, src )
	FT_exists( TkTypeEx_DefFunc, keylist_deffunc, src )
	FT_exists( TkTypeEx_DllFunc, keylist_dllfunc, src )
	FT_exists( TkTypeEx_IFace,   keylist_iface,   src )
	FT_exists( TkTypeEx_Var,     keylist_var,     src )
	
	return 0
	
#undef FT_exists
	
//------------------------------------------------
// ��`�����W����
// 
// @prm tktypelist = int[] : TkType �̔z��
// @prm tkstrlist  = str[] : �g�[�N��������̔z��
// @prm script     = str   : �X�N���v�g
//------------------------------------------------
#modfunc hspIdenter_collectDefs array mdeflist, array listIncludeToLoad, int bFirstCall,  local listInclude, local filename, local idx, local bListed, local ident, local tktype
	
	// ����̏ꍇ�A�n�b�V���l�̔z����폜
	if ( bFirstCall ) {
		dim deflister			// ������
		dim hashListed, 32
		cntList = 0
	}
	
	foreach listIncludeToLoad
		
		// ���̃t�@�C���̃t���p�X���擾
		if ( peek(listIncludeToLoad(cnt), 1) != ':' ) {		// "x:/.." �Ȃ���Ƀt���p�X
			SearchFileEx mSearchPath, listIncludeToLoad(cnt)
			if ( refstr == "" ) { continue }
			listIncludeToLoad(cnt) = refstr
			hspIdenter_appendSearchPath thismod, getpath(refstr, 32)	// ���ꌟ���p�X���g�����Ă���
		}
		
		// �t�@�C�����݂̂��擾���Ă���
		filename = getpath(listIncludeToLoad(cnt), 8)
		
		// ���ɊJ����Ă���t�@�C���͖���
		bListed = false
		hash    = EasyHash( listIncludeToLoad(cnt) )		// �t���p�X
		if ( bFirstCall == false ) {
			repeat cntList
				if ( hashListed(cnt) == hash ) {
					// �O�̂��߃t�@�C���p�X�ł���r����
					if ( hspDeflister_GetFileName( deflister(cnt) ) == filename ) {
						bListed = true
						break
					}
				}
			loop
			if ( bListed ) { continue }			// ��`�ς݂Ȃ̂Ŗ�������
		}
		
		// �J�������X�g�ɒǉ�
		if ( bListed == false ) {
			hashListed(cntList) = hash
			cntList ++
		}
		
		// ��`���X�g���쐬����
		hspDeflister_new deflister, listIncludeToLoad(cnt)
		idx = stat
		
		// ��`���X�g�� identer �ɔ��f����
		repeat hspDeflister_getCount( deflister(idx) )
			ident  = hspDeflister_getIdent( deflister(idx), cnt ) + "@" + hspDeflister_getScope( deflister(idx), cnt )
			tktype = getTkTypeFromDefType( hspDeflister_getDefType(deflister(idx), cnt) )
			hspIdenter_reserveIdent thismod, ident, tktype
		loop
		
		// �ċA�I�Ɍ������ꂽ�t�@�C�������`�����o��
		if ( hspDeflister_getCntInclude( deflister(idx) ) ) {
			hspDeflister_getIncludeArray    deflister(idx), listInclude		// #include �w�����ꂽ�t�@�C���̃��X�g�𓾂�
			hspIdenter_collectDefs thismod, deflister(idx), listInclude, false
		}
		
	loop
	
	return
	
#global

#endif
