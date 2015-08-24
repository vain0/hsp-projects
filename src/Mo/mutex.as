// Mutex Module

#ifndef __MUTEX_MODULE_AS__
#define __MUTEX_MODULE_AS__

// �E�~���[�e�b�N�X�̍쐬
//	"Mutex" �Ƃ���Windows �����I�u�W�F�N�g��
//	�쐬���A��d�N�����A���ɓ��� Mutex ���������璵�˕Ԃ��܂��B
//	�m����������A���g��DLL�͎g��Ȃ��A�����ȕ��@�ł��B
//
//	HANDLE CreateMutexA (
//		PSECURITY_ATTRIBUTES psa,	// �Z�L�����e�B�̍\���̂̃|�C���^�i����͕K�v�����j
//		BOOL    bInitialOwner,		// ���L�����擾���邩�i����͂ǂ���ł����܂�Ȃ��j
//		PCTSTR  pszMutexName,		// �쐬����~���[�e�b�N�X��
//	);

#module mutexmod

#define true  1
#define false 0
#define NULL  0

#uselib "kernel32.dll"
#func   CreateMutex@mutexmod  "CreateMutexA" nullptr,int,sptr
#cfunc  GetLastError@mutexmod "GetLastError"
#func   CloseHandle@mutexmod  "CloseHandle"  int

#deffunc CloseMutex		// Mutex �j��
	if ( hMutex ) { CloseHandle hMutex : hMutex = NULL }
	return false
	
#defcfunc IsUsedByMutex str p1
	// Mutex���쐬
	CreateMutex false, p1
	hMutex = stat
	if ( hMutex == NULL ) {
		dialog "MutexObject �̍쐬�Ɏ��s���܂����B", 1, "Error"
		end
	}
	
	// ���łɓ����� Mutex �����݂��Ă����I�i���݂��Ă��� Mutex ���쐬�ł��Ȃ������j
	if ( GetLastError() == 183 ) {	// ERROR_ALREADY_EXISTS
		CloseMutex					// �n���h�����N���[�Y����
		return true
	}
	return false
	
#global

#endif
