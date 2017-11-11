#ifndef IG_MODULE_REFERENCE_ENVIRONMENTAL_VARIABLE_AS
#define IG_MODULE_REFERENCE_ENVIRONMENTAL_VARIABLE_AS

#module mod_refEnvar

#uselib "kernel32.dll"
#func   GetEnvironmentVariable@mod_refEnvar   "GetEnvironmentVariableA"   sptr,int,int
#func   SetEnvironmentVariable@mod_refEnvar   "SetEnvironmentVariableA"   sptr,sptr
#func   ExpandEnvironmentStrings@mod_refEnvar "ExpandEnvironmentStringsA" sptr,sptr,int
#cfunc  GetLastError "GetLastError"

#define true  1
#define false 0
#define null  0

//------------------------------------------------
// ���ϐ��̕�����𓾂�
// 
// @prm envarName: �ϐ���
//------------------------------------------------
#defcfunc GetEnvar str envarName,  local lenString
	
	GetEnvironmentVariable envarName, null, 0 : lenString = stat
	if ( lenString == 0 ) { // ���ϐ������݂��Ȃ�
		return "%" + envarName + "%"
	}
	
	AllocResultBuf lenString + 3
	
	GetEnvironmentVariable envarName, varptr(stt_buf), lenString + 1
	return stt_buf
	
//------------------------------------------------
// ���ϐ��̕������ύX����
// 
// ���݂��Ȃ��ϐ������w�肷��ƁA ���̕ϐ����V���ɍ쐬����܂��B
// @prm envarName : �ϐ���
// @prm newString : ������镶����
// @result stat   : ��������Ɛ^
//------------------------------------------------
#deffunc SetEnvar str envarName, str newString
	SetEnvironmentVariable envarName, newString
	return stat
	
//------------------------------------------------
// ���ϐ����폜����
//------------------------------------------------
#deffunc DestroyEnvar str envarName
	SetEnvironmentVariable envarName, null
	return
	
//------------------------------------------------
// �����񒆂Ɋ܂܂����ϐ���W�J����
// 
// ���ϐ��� %envar-name% �̌`���ŕ\�����B
// '%' �� %% �ŕ\���B
//------------------------------------------------
#defcfunc ExpandEnvar str _sInput,  local sInput, local lenString
	sInput = _sInput
	
	ExpandEnvironmentStrings varptr(sInput), null, 0 : lenString = stat
	
*LRetry
	AllocResultBuf lenString + 3
	
	ExpandEnvironmentStrings varptr(sInput), varptr(stt_buf), lenString + 1
	
	if ( stat == 0 && GetLastError() == 234 ) { // ERROR_MORE_DATA
		lenString *= 2
		goto *LRetry
	}
	
	return stt_buf
	
//------------------------------------------------
// stt_sResult ���m�ہE�g������
//------------------------------------------------
#deffunc AllocResultBuf@mod_refEnvar int size
	
	if ( stt_bufsize <= size ) {
		stt_bufsize = size + 1
		
		if ( vartype(stt_buf) != vartype("str") ) {
			sdim stt_buf, stt_bufsize + 1
			
		} else {
			memexpand stt_buf, stt_bufsize + 1
		}
	}
	return
	
#global

	AllocResultBuf@mod_refEnvar 256

#endif
