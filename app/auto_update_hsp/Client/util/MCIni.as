// ini �Ǘ����W���[���N���X

#ifndef IG_MODULECLASS_INI_HSP
#define IG_MODULECLASS_INI_HSP

#module MCIni path_

#uselib "kernel32.dll"
#func   WritePrivateProfileString "WritePrivateProfileStringA" sptr,sptr,sptr,sptr
#func   GetPrivateProfileString   "GetPrivateProfileStringA"   sptr,sptr,sptr,int,int,sptr
#cfunc  GetPrivateProfileInt      "GetPrivateProfileIntA"      sptr,sptr,int,sptr

#define true  1
#define false 0
#define null  0
#define int_max 0x7FFFFFFF

#define BufCapacity_Default 1023

//���ʌ݊��p
#define global ini_getsv         ini_gets_v
#define global ini_existsKey     ini_exists_key
#define global ini_enumSection   ini_enum_sections
#define global ini_enumKey       ini_enum_keys
#define global ini_removeSection ini_remove_section
#define global ini_removekey     ini_remove_key
#define global ini_getPath       ini_get_path
#define global ini_getArray      ini_get_array
#define global ini_putArray      ini_put_array

#ifdef _DEBUG //�x������
	sdim stt_stmp
#endif

/**
* INI�t�@�C�����J��
*
* @prm this: �V�����C���X�^���X������z��ϐ��B
*	�ق��� ini_ �n���߂�֐����g���Ƃ��A������ŏ��̈����Ɏw�肷��B
* @prm path: INI�t�@�C���̃p�X�B�K�����΃p�X�Ŏw�肷�邱�ƁB
*/
#define global ini_new(%1, %2) newmod %1, MCIni@, %2

#modinit str fname
	path_ = fname
	
	//�Ȃ���΋�t�@�C��������Ă���
	exist fname
	if ( strsize < 0 ) { bsave fname, path_, 0 }
	return
	
#define global ini_delete(%1) delmod %1

/**
* ������f�[�^��ǂݏo�� (���ߌ`��)
*
* @param (this)
* @prm dst: �l���������܂��ϐ�
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm def: ���蕶���� (�L�[���Ȃ��Ƃ��͂��ꂪ�Ԃ����)
*/
#define global ini_gets_v(%1, %2, %3, %4, %5 = "", %6 = 0) \
	ini_gets_v_ %1, %2, %3, %4, %5, %6

#modfunc ini_gets_v_ var dst, str sec, str key, str def, int maxlen_,  \
	local maxlen
	
	maxlen = limit(maxlen_, BufCapacity_Default, int_max)
	do
		if ( maxlen > BufCapacity_Default ) { memexpand stt_stmp, maxlen + 1 }
		
		GetPrivateProfileString sec, key, def, varptr(stt_stmp), maxlen, varptr(path_)
		
		if ( maxlen_ <= 0 && stat == maxlen - 1 ) { // �o�b�t�@������Ȃ�����
			maxlen += maxlen / 2
			_continue
		}
	until true
	dst = stt_stmp
	return
	
/**
* ������f�[�^��ǂݏo��
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm def: ���蕶���� (�L�[���Ȃ��Ƃ��͂��ꂪ�Ԃ����)
*/
#define global ctype ini_gets(%1, %2, %3, %4 = "", %5 = BufCapacity_Default@MCIni) \
	ini_gets_(%1, %2, %3, %4, %5)

#modcfunc ini_gets_ str sec, str key, str def, int maxlen
	if ( maxlen > BufCapacity_Default ) { memexpand stt_stmp, maxlen + 1 }
	
	ini_gets_v thismod, stt_stmp, sec, key, def, maxlen
	return stt_stmp
	
/**
* �����l�f�[�^��ǂݏo��
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm def: ����l (�L�[���Ȃ��Ƃ��͂��̒l���Ԃ����)
*/
#modcfunc ini_getd str sec, str key, double def
	GetPrivateProfileString sec, key, str(def), varptr(stt_stmp), 32, varptr(path_)
	return double(stt_stmp)
	
/**
* �����l�f�[�^��ǂݏo��
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm def: ����l (�L�[���Ȃ��Ƃ��͂��̒l���Ԃ����)
*/
#modcfunc ini_geti str sec, str key, int def
	return GetPrivateProfileInt( sec, key, def, varptr(path_) )
	
/**
* ������f�[�^����������
*
* �f�[�^�𕶎���Ƃ��ď������݂܂��B
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm value: �������ރf�[�^
*/
#modfunc ini_puts str sec, str key, str data
	WritePrivateProfileString sec, key, "\"" + data + "\"", varptr(path_)
	return
	
/**
* �����l�f�[�^����������
*
* �L������16���ŏ������܂�܂��B
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm value: �������ރf�[�^
*/
#modfunc ini_putd str sec, str key, double data
	WritePrivateProfileString sec, key, strf("%.16e", data), varptr(path_)
	return
	
/**
* �����l�f�[�^����������
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm value: �������ރf�[�^
*/
#modfunc ini_puti str sec, str key, int data
	WritePrivateProfileString sec, key, str(data), varptr(path_)
	return
	
/**
* �Z�N�V�����̗�
* 
* @prm (this)
* @prm dst: �Z�N�V�������̔z��ɂȂ�z��ϐ�
* @return: �Z�N�V�����̌�
*/
#define global ini_enum_sections(%1, %2, %3 = 0) \
	ini_enum_impl %1, %2, "", %3
	
/**
* �L�[�̗�
*
* @prm (this)
* @prm dst: �L�[���̔z��ɂȂ�z��ϐ�
* @prm sec: �Z�N�V������
* @return: �L�[�̌�
*/
#define global ini_enum_keys(%1, %2, %3, %4 = 0) \
	ini_enum_impl %1, %2, (%3) + " ", %4
	
// �Z�N�V���� [] �̃L�[��񋓂���Ƃ��A�Z�N�V�������̗񋓂����N�G�X�g�����ƌ�F����Ă��܂�Ȃ��悤�ɁA���O�ɋ󔒂��������Ă���B���̋󔒂͖��������̂Ŗ��Ȃ��B

#modfunc ini_enum_impl array dst, str sec_, int maxlen_,  \
	local maxlen, local pSec, local sec
	
	maxlen = limit(maxlen_, BufCapacity_Default, int_max)
	
	if ( sec_ == "" ) { pSec = null } else { sec = sec_ : pSec = varptr(sec) }
	do
		if ( maxlen > BufCapacity_Default ) { memexpand stt_stmp, maxlen + 1 }
		
		GetPrivateProfileString pSec, null, null, varptr(stt_stmp), maxlen, varptr(path_)
		
		if ( maxlen_ <= 0 && stat == maxlen - 2 ) {		// �o�b�t�@������Ȃ�����
			maxlen += maxlen / 2						// 1.5�{�ɍL���čă`�������W
			_continue
		}
	until true
	
	SplitByNull dst, stt_stmp, stat
	return ;stat
	
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
	return length(dst) - (idx <= 1)			// �v�f��; ������ dst[0] ����̂Ƃ� 0
	
#ifdef _DEBUG
/**
* ���ׂẴL�[�E�l�̑΂�񋓂���B (�f�o�b�O�p)
*/
#modfunc ini_dbglog  local buf
 	ini_dbglogv thismod, buf
	logmes "\n(ini_dbglog): @" + path_
 	logmes buf
 	return
 
#modfunc ini_dbglogv var buf,  \
	local seclist, local sec, local keylist, local key, local stmp
	
	ini_enum_sections thismod, seclist
	repeat stat : sec = seclist(cnt)
		buf += strf("[%s]\n", sec)
		
		ini_enum_keys thismod, keylist, sec
		repeat stat : key = keylist(cnt)
			ini_gets_v thismod, stmp, sec, key, , BufCapacity_Default
			buf += "\t" + key + " = \"" + stmp + "\"\n"
		loop
		
	loop
	return
#else
 #define global ini_dbglog :
 #define global ini_dbglogv :
#endif //defined(_DEBUG)

/**
* �L�[�����݂��邩�H
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @return: �w�肳�ꂽ�L�[������ΐ^(0�ȊO)���A�Ȃ���΋U(0)��Ԃ��B
*/

#modcfunc ini_exists_key str sec, str key
	GetPrivateProfileString sec, key, "__", varptr(stt_stmp), 2, varptr(path_)
	return ( stat < 2 )
	
/*
GetPrivateProfileString �� ����l("__"), nSize(2) ��^����Ƃ��A
�L�[�����݂���ΕԒl 1 or 0�A���Ȃ���� 2 �ƂȂ�B
//*/

/**
* �Z�N�V��������������
*
* @prm (this)
* @prm sec: �Z�N�V������
*/
#modfunc ini_remove_section str sec
	WritePrivateProfileString sec, null, null, varptr(path_)
	return
	
/**
* �L�[����������
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
*/
#modfunc ini_remove_key str sec, str key
	WritePrivateProfileString sec, key, null, varptr(path_)
	return
	
/**
* INI�t�@�C���p�X
*
* @prm (this)
* @return: ini_new �Ŏw�肳�ꂽ�p�X
*/
#modcfunc ini_get_path
	return path_
	
#global

#module

#enum global IniValtype_None = 0
#enum global IniValtype_Indeterminate = 0
#enum global IniValtype_String = 2			// vartype �̒l�ƈ�v
#enum global IniValtype_Double
#enum global IniValtype_Int
#enum global IniValtype_MAX

#define stt_stmp stt_stmp@MCIni

/**
* �w�肵���^�̃f�[�^��ǂݏo��
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm def: ���蕶���� (�L�[���Ȃ��Ƃ��͂��ꂪ�Ԃ����)
*/
#define global ctype ini_get(%1, %2, %3, %4 = "", %5 = 0) \
	ini_get_( %1, %2, %3, str(%4), %5 )

#defcfunc ini_get_ var self, str sec, str key, str def, int valtype
	ini_gets_v self, stt_stmp, sec, key, def
	return CastFromString@MCIni( stt_stmp, valtype )
	
/**
* �w�肵���^�̃f�[�^����������
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm value: �������ރf�[�^
* @param valtype: �f�[�^�̌^ (�ȗ����́Avalue �̌^���g�p����܂�)
*/
#define global ini_put(%1, %2, %3, %4, %5 = 0) \
	stt_tmp@MCIni = (%4) :\
	ini_putv %1, %2, %3, stt_tmp@MCIni, %5

#deffunc ini_putv var self, str sec, str key, var data, int valtype_,  local valtype
	if ( valtype_ ) { valtype = valtype_ } else { valtype = ValtypeByString@MCIni(str(data)) }
	switch ( valtype )
		case IniValtype_String: ini_puts self, sec, key,       (data) : swbreak
		case IniValtype_Double: ini_putd self, sec, key, double(data) : swbreak
		case IniValtype_Int:    ini_puti self, sec, key,    int(data) : swbreak
	swend
	return
	
// �����񂪕\���f�[�^�̌^�𐄒肷��
// 16�i���`���̐����l�Ȃǂɂ͖��Ή�
#defcfunc ValtypeByString@MCIni str data
	if ( data == int(data) ) { return IniValtype_Int }
	if ( double(data) != 0 ) {
		if ( IsDoubleImpl@MCIni(data) ) { return IniValtype_Double }
	}
	return IniValtype_String
	
#defcfunc IsDoubleImpl@MCIni str data_, local data
	data = data_
	return ( instr(data, , ".") >= 0 || instr(data, , "e") >= 0 )
	
// �����񂩂�w�肵���^�Ɍ^�ϊ�����
#defcfunc CastFromString@MCIni str data, int valtype_,  local valtype
	if ( valtype_ ) { valtype = valtype_ } else { valtype = ValtypeByString@MCIni(stt_stmp) }
	switch ( valtype )
		case IniValtype_String: return       (data)
		case IniValtype_Double: return double(data)
		case IniValtype_Int:    return    int(data)
	swend
#global

#module

#define ctype IniKeyArrayIdx(%1, %2) ((%1) + "#" + (%2))
#define ctype IniKeyMember(%1, %2) ((%1) + "." + (%2))

/**
* �z��f�[�^��ǂݏo��
*
* ini_put_array ���߂ɂ���ď������񂾁A�z��f�[�^��ǂݍ��݂܂��B
*
* @prm (this)
* @prm dst: �l���������܂��z��ϐ�
* @prm sec: �Z�N�V������
* @prm key: �z��̖��O
*/
#deffunc ini_get_array var self, array dst, str sec, str key,  \
	local len, local valtype
	
	len     = ini_geti( self, sec, IniKeyMember(key, "$length"),  0 )
	valtype = ini_geti( self, sec, IniKeyMember(key, "$valtype"), IniValtype_Indeterminate )
	
	if ( valtype == IniValtype_Indeterminate ) {
		valtype = ValtypeByString@MCIni( ini_gets( self, sec, IniKeyArrayIdx(key, 0) ) )
	}
	
	dimtype dst, valtype, len
	repeat len
		dst(cnt) = ini_get( self, sec, IniKeyArrayIdx(key, cnt), , valtype )
	loop
	return
	
/**
* �z��f�[�^����������
*
* �z��ϐ��́Astr, double, int �^��1�����z��ϐ��ɂ�����܂��B
* �f�[�^�̓ǂݍ��݂ɂ� ini_get_array ���g�p���Ă��������B
*
* @prm (this)
* @prm sec: �Z�N�V������
* @prm key: �L�[��
* @prm arr: �������ޔz��ϐ�
*/
#deffunc ini_put_array var self, str sec, str key, array src,  \
	local len, local valtype
	
	len     = length(src)
	valtype = vartype(src)
	
	ini_puti self, sec, IniKeyMember(key, "$length"),  len
	ini_puti self, sec, IniKeyMember(key, "$valtype"), valtype
	
	repeat len
		ini_putv self, sec, IniKeyArrayIdx(key, cnt), src(cnt), valtype
	loop
	return
	
#global

	sdim stt_stmp@MCIni, BufCapacity_Default@MCIni + 1

#endif
