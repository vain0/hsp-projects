/***********************************************************

	�v���Z�X�̎��s�D��x�ݒ胂�W���[��

		�y2006/7/6 �X�V�z

***********************************************************/
#ifndef __PRIORITY_AS__
#define __PRIORITY_AS__

#module priority

#uselib "kernel32.dll"
#cfunc   GetCurrentProcess "GetCurrentProcess"
#cfunc   GetCurrentThread  "GetCurrentThread"
#func    SetPriorityClass  "SetPriorityClass"	int,int
#func    SetThreadPriority "SetThreadPriority" int,int

// �v���Z�X�̗D��x�N���X
#define global REALTIME_PRIORITY_CLASS		0x00000100	// ���A���^�C�� (�D��x : �ō�) ! �g�p���ׂ��łȂ� !
#define global HIGH_PRIORITY_CLASS			0x00000080	// �D��N���X	(�D��x : ����) ! �g�p���ׂ��łȂ� !
#define global ABOVE_NORMAL_PRIORITY_CLASS	0x00008000	// �ʏ�ȏ�		(�D��x : �㍂) XP �ȍ~
#define global NORMAL_PRIORITY_CLASS		0x00000020	// �ʏ�			(�D��x : ����) �W��
#define global BELOW_NORMAL_PRIORITY_CLASS	0x00004000	// �ʏ�ȉ�		(�D��x : ���) XP �ȍ~
#define global IDLE_PRIORITY_CLASS			0x00000040	// �A�C�h��		(�D��x : �Ⴂ) �풓�A�v��

// �X���b�h�̑��ΗD��x ( HSP�̏ꍇ��ɃV���O���X���b�h�Ȃ̂Ŏw�肵�Ă����Ԃ�Ӗ��Ȃ� )
#define global THREAD_PRIORITY_IDLE				(-15)	// �v���Z�X�̗D��x�N���X�� REALTIME_PRIORITY_CLASS �̂Ƃ��A�X���b�h�D��x�� 16 �ɂ��܂��B����ȊO�̂Ƃ��̓X���b�h�D��x�� 1 �ɂ��܂�
#define global THREAD_PRIORITY_LOWEST			(-2)	// �X���b�h�D��x���v���Z�X�̗D��x�N���X�̒ʏ�̗D��x��� 2 �Ⴍ�ݒ肵�܂��B
#define global THREAD_PRIORITY_BELOW_NORMAL		(-1)	// �X���b�h�D��x���v���Z�X�̗D��x�N���X�̒ʏ�̗D��x��� 1 �Ⴍ�ݒ肵�܂��B
#define global THREAD_PRIORITY_NORMAL			0		// �X���b�h�D��x���v���Z�X�̗D��x�N���X�̒ʏ�̗D��x�ɐݒ肵�܂��B
#define global THREAD_PRIORITY_HIGHEST			1		// �X���b�h�D��x���v���Z�X�̗D��x�N���X�̒ʏ�̗D��x��� 1 �����ݒ肵�܂��B
#define global THREAD_PRIORITY_ABOVE_NORMAL		2		// �X���b�h�D��x���v���Z�X�̗D��x�N���X�̒ʏ�̗D��x��� 2 �����ݒ肵�܂��B
#define global THREAD_PRIORITY_TIME_CRITICAL	15		// �v���Z�X�̗D��x�N���X�� REALTIME_PRIORITY_CLASS �̂Ƃ��A�X���b�h�D��x�� 31 �ɂ��܂��B����ȊO�̂Ƃ��̓X���b�h�D��x�� 15 �ɂ��܂��B

// ���ʂ̃A�v���P�[�V�����̃f�t�H���g�D��x��
// NORMAL_PRIORITY_CLASS, THREAD_PRIORITY_NORMAL
#define global NormalPriority SetPriority NORMAL_PRIORITY_CLASS, THREAD_PRIORITY_NORMAL//	�ʏ�
#define global IdlePriority SetPriority IDLE_PRIORITY_CLASS, THREAD_PRIORITY_IDLE//			�Œ�

/**********************************************************/
// ���W���[���������i�t�@�C�������ŌĂяo���ς݁j
/**********************************************************/
#deffunc _init_priority_mod
	hProc   = GetCurrentProcess()	// �v���Z�X�E�n���h�����擾
	hThread = GetCurrentThread()	// �X���b�h�E�n���h�����擾
	return
	
/**********************************************************/
// �������g�̎��s�D��x��ݒ�
//  p1 = �v���Z�X�̗D��x�N���X�i��L�̒萔����w��j
//  p2 = �X���b�h�̑��ΗD��x�i��L�̒萔����w��j
/**********************************************************/
#deffunc SetPriority int p1,int p2
	error = 0
	Prior = p1
	RelativePrior = p2
	
	SetPriorityClass hProc, Prior
	if (stat == 0) {	// ���s
		error += 1
	}
	
	SetThreadPriority hThread, RelativePrior
	if (stat == 0) {	// ���s
		error += 2
	}
	
	return error
	
/**********************************************************/
#global
_init_priority_mod

#endif
