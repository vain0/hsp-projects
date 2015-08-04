// ini �Ǘ����W���[���N���X

#ifndef IG_MODULECLASS_INI_AS
#define IG_MODULECLASS_INI_AS

#module MCIni mfname

#uselib "kernel32.dll"
#func   WritePrivateProfileString "WritePrivateProfileStringA" sptr,sptr,sptr,sptr
#func   GetPrivateProfileString   "GetPrivateProfileStringA"   sptr,sptr,sptr,int,int,sptr
#cfunc  GetPrivateProfileInt      "GetPrivateProfileIntA"      sptr,sptr,int,sptr

#define true  1
#define false 0
#define null  0

#enum global IniValtype_None = 0
#enum global IniValtype_Indeterminate = 0
#enum global IniValtype_String = 2			// vartype �̒l�ƈ�v
#enum global IniValtype_Double
#enum global IniValtype_Int
#enum global IniValtype_MAX

#define ctype IniKeyArrayIdx(%1, %2) ((%1) + "#" + (%2))
#define ctype IniKeyMember(%1, %2) ((%1) + "." + (%2))

// @static
	stt_stmp = ""

//**********************************************************
//        �\�z�E���
//**********************************************************
#define global ini_new(%1, %2) newmod %1, MCIni@, %2
#modinit str fname
	mfname = fname
	
	exist fname
	if ( strsize < 0 ) { bsave fname, mfname, 0 }	// ��t�@�C���ō���Ă���
	return
	
#define global ini_delete(%1) delmod %1
	
//**********************************************************
//        �f�[�^�ǂݍ���
//**********************************************************
#define global ctype ini_get(%1, %2, %3, %4 = "", %5 = 0) ini_get_( %1, %2, %3, str(%4), %5 )

//------------------------------------------------
// ������ ( sttm-form )
// 
// @prm (this)
// @prm dst : �󂯎��ϐ�
// @prm sec : �Z�N�V������
// @prm key : �L�[��
// @prm def : ���蕶���� ( �L�[�����݂��Ȃ��Ƃ� )
// @prm max : �ő啶����
//------------------------------------------------
#define global ini_getsv(%1, %2, %3, %4, %5 = "", %6 = 1200) ini_getsv_ %1, %2, %3, %4, %5, %6
#modfunc ini_getsv_ var dst, str sec, str key, str def, int maxlen
	if ( maxlen > 1200 ) { memexpand stt_stmp, maxlen + 1 }
	
	GetPrivateProfileString sec, key, def, varptr(stt_stmp), maxlen, varptr(mfname)
	
	dst = stt_stmp
	return
	
//------------------------------------------------
// ������ ( func-form )
// 
// @prm (ini_getsv: dst �ȊO)
//------------------------------------------------
#define global ctype ini_gets(%1, %2, %3, %4 = "", %5 = 1200) ini_gets_(%1, %2, %3, %4, %5)
#modcfunc ini_gets_ str sec, str key, str def, int maxlen
	if ( maxlen > 1200 ) { memexpand stt_stmp, maxlen + 1 }
	
	ini_getsv thismod, stt_stmp, sec, key, def, maxlen
	return stt_stmp
	
//------------------------------------------------
// ���� ( func-form )
//------------------------------------------------
#modcfunc ini_getd str sec, str key, double def
	GetPrivateProfileString sec, key, str(def), varptr(stt_stmp), 32, varptr(mfname)
	return double(stt_stmp)
	
//------------------------------------------------
// ���� ( func-form )
//------------------------------------------------
#define global ctype ini_geti(%1, %2, %3, %4 = 0) ini_geti_( %1, %2, %3, %4 )
#modcfunc ini_geti_ str sec, str key, int def
	return GetPrivateProfileInt( sec, key, def, varptr(mfname) )
	
//------------------------------------------------
// �z��
// 
// @prm (this)
// @prm dst : �󂯎��ϐ� (�z��Ƃ��ď����������)
// @prm sec : �Z�N�V������
// @prm key : �L�[�� (�z��)
//------------------------------------------------
#modfunc ini_getArray array dst, str sec, str key,  local len, local valtype
	len     = ini_geti( thismod, sec, IniKeyMember(key, "$length"),  0 )
	valtype = ini_geti( thismod, sec, IniKeyMember(key, "$valtype"), IniValtype_Indeterminate )
	
	if ( valtype == IniValtype_Indeterminate ) {
		valtype = ValtypeByString( ini_gets( thismod, sec, IniKeyArrayIdx(key, 0) ) )	// [0] �̌^�Ŕ��肷��
	}
	
	dimtype dst, valtype, len
	
	repeat len
		dst(cnt) = ini_get( thismod, sec, IniKeyArrayIdx(key, cnt), , valtype )
	loop
	
	return
	
//------------------------------------------------
// any ( func-form )
//------------------------------------------------
// ini_get
#modcfunc ini_get_ str sec, str key, str def, int valtype_,  local valtype
	ini_getsv thismod, stt_stmp, sec, key, def
	return CastFromString( stt_stemp, valtype_ )
	
//**********************************************************
//        �f�[�^��������
//**********************************************************
//------------------------------------------------
// ������
//------------------------------------------------
#modfunc ini_puts str sec, str key, str data
	WritePrivateProfileString sec, key, "\"" + data + "\"", varptr(mfname)
	return
	
//------------------------------------------------
// ���� (�L������16��)
//------------------------------------------------
#modfunc ini_putd str sec, str key, double data
	WritePrivateProfileString sec, key, strf("%.16e", data), varptr(mfname)
	return
	
//------------------------------------------------
// ����
//------------------------------------------------
#modfunc ini_puti str sec, str key, int data
	WritePrivateProfileString sec, key, str(data), varptr(mfname)
	return
	
//------------------------------------------------
// any
//------------------------------------------------
#define global ini_put(%1, %2, %3, %4, %5 = 0) stt_tmp@MCIni = (%4) : ini_putv %1, %2, %3, stt_tmp@MCIni, %5
#modfunc ini_putv str sec, str key, var data, int valtype_,  local valtype
	if ( valtype_ ) { valtype = valtype_ } else { valtype = ValtypeByString(str(data)) }
	switch ( valtype )
		case IniValtype_String: ini_puts thismod, sec, key,       (data) : swbreak
		case IniValtype_Double: ini_putd thismod, sec, key, double(data) : swbreak
		case IniValtype_Int:    ini_puti thismod, sec, key,    int(data) : swbreak
	swend
	return
	
//**********************************************************
//        ��
//**********************************************************
//------------------------------------------------
// ��
// 
// @prm (this)
// @prm dst : �󂯎��ϐ� (�z��)
// @prm[sec : �Z�N�V������]
//------------------------------------------------
#define global ini_enumSection(%1, %2, %3 = 0) ini_enum_impl %1, %2, "", %3
#define global ini_enumKey(%1, %2, %3, %4 = 0) ini_enum_impl %1, %2, %3, %4

#modfunc ini_enum_impl array dst, str sec_, int maxlen_,  local maxlen, local pSec, local sec
	maxlen = limit(maxlen_, 1024, 0xFFFF)
	
	if ( sec_ == "" ) { pSec = null } else { sec = sec_ : pSec = varptr(sec) }
	
*LReTry:
	if ( maxlen > 1200 ) { memexpand stt_stmp, maxlen + 1 }
	
	GetPrivateProfileString pSec, null, null, varptr(stt_stmp), maxlen, varptr(mfname)
	
	if ( maxlen <= 0 && (stat == maxlen - 2) ) {
		maxlen *= 2
		goto *LReTry
	}
	
	SplitByNull dst, stt_stmp, stat			// �z��
	return
	
// cnv: '\0' ��؂蕶���� -> �z��
#deffunc SplitByNull@MCIni array dst, var buf, int maxsize,  local idx
	idx = 0
	sdim dst
	repeat
		getstr dst(cnt), buf, idx, , maxsize
	;	logmes dst(cnt)
		idx += strsize + 1
		if ( peek(buf, idx) == 0 ) { break }		// '\0' ��2�A���͏I�[�t���O
	loop
	return
	
#ifdef _DEBUG
// ���ׂẴZ�N�V�����̃L�[��񋓂��f�o�b�O�o�͂���
 #modfunc ini_dbglog  local seclist, local sec, local keylist, local key, local stmp
	logmes "\n(ini_dbglog): @" + mfname
	
	sdim seclist
	sdim keylist
	sdim stmp
	
	ini_enumSection thismod, seclist			// �Z�N�V�������
	
	foreach seclist : sec = seclist(cnt)
		logmes strf("[%s]", sec)
		
		ini_enumKey thismod, keylist, sec		// �L�[���
		foreach keylist : key = keylist(cnt)
			ini_getsv thismod, stmp, sec, key, , 512			// �Œ� 512 - 1 �Ƃ���B
			logmes ("\t" + key + " = \"" + stmp + "\"")
		loop
		
	loop
	return
#else
 #define global ini_dbglog :
#endif
	
	
//**********************************************************
//        ���̑��̑���
//**********************************************************
//------------------------------------------------
// �L�[�̗L��
// 
// @ GetPrivateProfileString �� ����l("__"), nSize(2) ��^����Ƃ��A
// @	�L�[�����݂���ΕԒl 1 or 0�A���Ȃ���� 2 �ƂȂ�B
//------------------------------------------------
#modcfunc ini_existsKey str sec, str key
	GetPrivateProfileString sec, key, "__", varptr(stt_stmp), 2, varptr(mfname)
	return ( stat < 2 )
;	return ( false == ( ini_geti( thismod, sec, key, 0 ) == 0 && ini_geti( thismod, sec, key, 1 ) == 1 ) )
	
//------------------------------------------------
// �Z�N�V��������
//------------------------------------------------
#modfunc ini_removeSection str sec
	WritePrivateProfileString sec, null, null, varptr(mfname)
	return
	
//------------------------------------------------
// �L�[����
//------------------------------------------------
#modfunc ini_removeKey str sec, str key
	WritePrivateProfileString sec, key, null, varptr(mfname)
	return
	
//**********************************************************
//        ���̑�
//**********************************************************
//------------------------------------------------
// �^�𔻒肷�� (from ������)
// 
// @ 0x* �Ȃǂɂ͖��Ή�
//------------------------------------------------
#defcfunc ValtypeByString@MCIni str data
	if ( data == int(data) ) { return IniValtype_Int }
	if ( double(data) != 0 ) {
		if ( IsDoubleImpl(data) ) { return IniValtype_Double }
	}
	return IniValtype_String
	
#defcfunc IsDoubleImpl@MCIni str data_, local data
	data = data_
	return ( instr(data, , ".") >= 0 || instr(data, , "e") >= 0 )
	
//------------------------------------------------
// �^�ϊ� (from str)
//------------------------------------------------
#defcfunc CastFromString@MCIni str data, int valtype_,  local valtype
	if ( valtype_ ) { valtype = valtype_ } else { valtype = ValtypeByString(stt_stmp) }
	switch ( valtype )
		case IniValtype_String: return       (data)
		case IniValtype_Double: return double(data)
		case IniValtype_Int:    return    int(data)
	swend
	
#global

	sdim stt_stmp@MCIni, 1200 + 1
	
//##############################################################################
//                �T���v���E�X�N���v�g
//##############################################################################
#if 0

	ini_new cfg, "C:/appdata.ini"	// �J�� ini �t�@�C�����p�X�Ŏw�肵�܂��B�Ȃ�������쐬���܂��B
//	( strsize = �J����ini�t�@�C���̃T�C�Y ; ���� => �Ȃ������̂ō���� )
	
	mes ini_geti( cfg, "appdata", "x" )
	ini_dbglog cfg
;	ini_delete cfg
	stop
	
#endif

/***

�����t�@�����X

��INI�Ɋւ���
	�E�Z�N�V�������A�L�[���A�t�@�C���p�X�́A���p�A���t�@�x�b�g�̑啶���E����������ʂ��܂���B
	�E�L�[����l�́A�擪����і����ɂ���󔒂͖�������܂� (���s������)�B
		�������A�L�[����l�̑S�̂� "" �Ŋ���ƁA���̓����̋󔒂͈ێ�����܂� (�L�[�� " " ���܂݂܂�)�B
		ex: { x = 3 } <=> (key: 'x', value: '3')
		ex: { " x " = " string " } <=> (key: '" x "', value: ' string ')
	�E�����l 0x... �́A16�i���Ƃ��Ĉ����܂��B
		�������A0... �Ƃ��Ă����8�i���Ƃ���@�\�͂���܂���B
	�E�s���R�����g�̓Z�~�R���� ; �����ł��B�i���o�[�T�C�� # ��v�X���b�V�� // �͗L���ȋL���ł��B
		�܂��A�Z�N�V�����ł��L�[�ł��Ȃ��ꏊ�͈Ӗ��Ȃ��킯�ł����B
	�E�g���q�� .ini �� .cfg ����ʓI�ł��B
	
�������A���
	�Eini_new self, "�t�@�C���p�X"
	
	ini �t�@�C�����J���܂��B�Ȃ��������̃t�@�C�������܂��B
	�p�X�ɂ̓t�@�C�����ł͂Ȃ��A��΃p�X�����΃p�X���w�肵�Ă������� (��F"./cfg.ini", "D:/Cfg/prjx.ini", etc)�B
	
	�Eini_delete self
	
	ini �t�@�C������܂��B�K�{�ł͂���܂���B
	�t�@�C�����폜����킯�ł͂��肹��B
	
����������
	�Eini_puts self, "sec", "key", "value"
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l���A������ value �ɐݒ肵�܂��B
	
	�Eini_puti self, "sec", "key", value
	�Eini_putv self, "sec", "key", value
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l���Avalue �̕�����\�L�ɐݒ肵�܂��B
	value �̌^�͖₢�܂��񂪁A�K��������Ƃ��ď������܂�܂��B
	
���ǂݍ���
	�Eini_getsv self, dst, "sec", "key", "default", maxlen
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l���A������Ƃ��ĕϐ� dst �Ɋi�[���܂��B
	( ���e�� int �ł��A������^�̂܂܊i�[����܂��B )
	maxlen �́A�ǂݍ��ޕ�����̍ő�̒����ł��B�ʏ�� 1200 [byte] �ł����A����ȏオ�K�v��
	�ꍇ�͏ȗ������Ɏw�肵�Ă��������B
	�w�肵���L�[�����݂��Ȃ��ꍇ�́A"default"�̒l���Ԃ�܂��B�ȗ������ "" (�󕶎���)�ł��B
	
	�Eini_geti( self, "sec", "key", default )
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l���A���l�Ƃ��ēǂݏo���ĕԂ��܂��Bstr ���� 0 ���Ԃ�܂��B
	�w�肵���L�[�����݂��Ȃ��ꍇ�Adefault �̒l���Ԃ�܂��B�ȗ������ 0 �ł��B
	
	�Eini_gets( self, "sec", "key", "default", maxlen )
	
	ini_getsv �̊֐��`���ł��Bmaxlen �́A�ȗ������ 1200 �ɂȂ�܂��B
	
��INI�f�[�^�̍폜
	�Eini_removeSection self, "sec"
	
	�Z�N�V���� "sec" ���폜���܂��B���ɖ߂��܂���B
	
	�Eini_removeKey self, "sec", "key"
	
	�Z�N�V���� "sec" �̃L�[ "key" ���폜���܂��B���ɖ߂��܂���B
	
�����̑�
	�Eini_existsKey( self, "sec", "key" )
	
	�Z�N�V���� "sec" �̃L�[ "key" �����݂��邩�ǂ����B���݂���Ȃ�^��Ԃ��܂��B
	@ �l�̂Ȃ��L�[ ("key=" ����) �́A���݂��Ȃ����̂Ƃ��Ĉ����܂��B
	
***/
#endif
