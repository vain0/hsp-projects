
	call

�y  ��  ��  �zcall
�y  ��  ��  �zHSP3.2�g���v���O�C��
�y  ��  ��  �z���
�y ��舵�� �z�t���[�\�t�g�E�F�A
�y �J���� �zWindows XP HomeEdition SP3
�y ����m�F �zWindows XP
�y  �J����  �zhttp://prograpark.ninja-web.net/

���ڎ�
�E�T�v
�E����
�E����
�E�p�b�P�[�W
�E�@�\
�E�\�[�X�R�[�h
�E���쌠
�E�Q��

���T�v
	���x���������t���ŌĂяo�����Ƃ��\�ɂ���g���v���O�C���ł��B
	������̕��@���������g�p���Ă���̂ŁAHSP3.2�����ňȊO�ł̓���́A��ؕۏ�
	�ł��܂���B
	
������
	�_�E�����[�h�������k�t�@�C�����A�K���ȂƂ���ɉ𓀂��Ă��������B
	���ɓ��ʂȎ葱���͕K�v����܂���B
	
������
	�֌W�̂���t�@�C����t�H���_�����̂܂܍폜���Ă��������B
	���W�X�g���Ȃǂ͘M��܂���B
	�u���p�b�P�[�W�v�Q�ƁB
	
���p�b�P�[�W
�@�@[call]
�@�@�@�@�� [src]      �c�c HPI�̃\�[�X�R�[�h (C++; VC++)
�@�@�@�@�� call.as    �c�c ��p�w�b�_
�@�@�@�@�� call.hpi   �c�c �v���O�C��
�@�@�@�@�� call.hs    �c�c �w���v�E�t�@�C��
�@�@�@�@�� ex*.hsp    �c�c �T���v���E�X�N���v�g
�@�@�@�@�� readme.txt �c�c ���̃t�@�C���B�戵������
�@�@�@�@
���@�\
�E����
	�����^�C��( hsp3.exe )�� hspcmp.dll ������t�H���_�� call.hpi ���A
	hsphelp �t�H���_�� call.hs ���A���ꂼ��R�s�[���Ă������� ( ��҂͔C�� )�B
	
�E��{�I�Ȏg�p�@
	��������Ă��� call.as ���A�X�N���v�g�̍ŏ��̕��� #include
	���Ă��������BLike this:
		#include "call.as"
	
	���x���Œ�`�������߂��u���x�����߁v�A�֐����u���x���֐��v�ƌĂт܂��B
	���߂̏ꍇ:
		call ���x��, ����...
		call *sttm, 10, 20		// ����Ȋ���
	�֐��̏ꍇ:
		call(���x��, ����...)
		call(*func, 10, 20)		// ����Ȋ����B
	���̂悤�ɌĂяo���܂��B
	
	��`����Ƃ��́A�T�u���[�`�����L�q���銴�o�ŁA���߂̏����������Ă����A�I����
	��Ƃ��� return ���߂�p���܂��BLike this:
		*sttm
			mes "Hello, world!"
			return
	
	�������g�p����ɂ́Acall_aliasAll ���߂���� call_alias ���߂ŁA�ϐ���������
	�G�C���A�X�ɂł��܂��Bargv() �Œ��ڎQ�Ƃ��邱�Ƃ��\�ł��B�܂��Arefarg()��
	�����ɏ������ނ��Ƃ��\�ł��BLike this:
		*assign
			refarg(0) = argv(1)
			return
	
	����́A�ucall *assign, byref(a), b�v�ŁAb �̒l�� a �ɑ�����܂��B�܂�A
	��� = �Ƃقړ�������ł� ( refarg() �̓N���[�������̂ŁA�^��ς��邱�Ƃ�
	�ł��܂��� )�B
	
	�����͒l�n���ƎQ�Ɠn���̓�ʂ肠��܂��Bcall ���߂ŌĂяo���Ƃ��ɁA�萔�l��
	������Ă���ꍇ�́A���̒l���R�s�[����܂� (�l�n��)�B�萔�l�ł͂Ȃ��ϐ��E
	�z��ϐ����w�肳��Ă���ꍇ�́A�������l�n���ł����Abyref() �ň͂��Ďw�肷��
	�ƁA�Q�Ɠn�����܂��B�O�q�̒ʂ� refarg() �ł��̕ϐ��ւ̑�����ł��܂��B
	
	�֐����`����ꍇ�����l�ł��B���x���͊֐��`���ł����ߌ`���ł��Ăяo���܂��B
	Like this:
		*function
			mes "Hello, world!"
			return 3.14159		// �ȉ���
	
	�߂�l�ɂ́A�ʏ�ʂ� str, double, int ��3���g�p�\�ł��B�܂��Acall_retval
	���߂��g�p���邱�Ƃɂ���āA���x���^���Ԃ���悤�ɂȂ��Ă��܂��B
	
	�܂��A#deffunc �̃p�����[�^�̃G�C���A�X�������x�����߂ɂ��g�p�ł��܂��B
	Like this:
		#deffunc lbf_add var p1, var p2
		*add
			return p1 + p2
	
	�����̌^�ɂ́Avar �� array �̂ݎg�p�\�ł��B�萔��ϐ����󂯎��ꍇ�͕K��
	var �ɂ��A�z��ϐ����󂯎��ꍇ�̂� array �ɂ��܂��Blocal �͎g�p�ł��܂���B
	#defcfunc�ł��������Ƃ��\�ł��B�������A�Ăяo�����@�͕ς��܂���B
	���[�J���ϐ�( local �^�C�v )�͎g�p�ł��܂���̂ŁA�����ӂ��������B
	���g������ ex04_deffunc.hsp ���Q�ƁB
	
�E�������錾��
	call_dec ���߂ŁA���x�����߁E�֐���錾�ł��܂��BLike this:
		call_dec *add, "int", "int"
	
	�����܂ł� call_dec �͖��߂ł��邱�Ƃɒ��ӂ��Ă��������B�܂�A���s����܂�
	�L���ł͂���܂���B
	
	���������錾���郉�x���ŁA�������ȍ~�́A���������X�g�ł��B���̃��m���g�p
	�ł��܂��F
		label, str, double, int, var, array
		
	�Ăяo�����͓����ł����A�������^�C�v���^���Ɠ����ꍇ�A�������ȗ��ł��܂��B��
	���l�ɂ́A���̌^�̊���l���n����܂� ( ����l���Ȃ��ꍇ�̓G���[�ɂȂ�܂� )�B
	Like this:
		call_dec *add, "int", "int"
		mes call( *add )	// call( *add, int(0), int(0) ) �Ƃ����
		
		*add
			return argv(0) + argv(1)
		
	#deffunc �̃G�C���A�X���g�p����ꍇ�́Avar, array �����łȂ��A�ʏ�� int �� 
	str �𗘗p���܂��BLike this:
		#deffunc lbf_add int p1, int p2
		*add
			return p1 + p2
	
	�萔�� var, array �ɂ����ꍇ�̓���͖���`�ł��̂ŁA�C��t���Ă��������B
	
�E�T���v��
	��������Ă��� ex*_*.hsp �Ƃ����t�@�C���́A���ׂăT���v���ł��B
	
	�������� NYSL (�ς�Ȃ�Ă��Ȃ�D���ɂ��냉�C�Z���X) Version 0.9982 �ł��B
	
���\�[�X�R�[�h
	[src]�t�H���_�̓����̃t�@�C�����ׂĂł��B�s�v�ȏꍇ�́A�t�H���_���ƍ폜����
	�����܂��܂���B
	
	VisualC++ 2008 Express Edition (9.0)���g�p���Ă��܂��B�����C++�ł��B�o�O��
	�ԈႢ�������܂�����A�񍐂��Ă���������Ɣ��ɂ��肪�����ł��B
	( �u���Q�Ɓv���Q�� )
	
	�܂��A�R���p�C������ɂ� hspsdk ���K�v�ł��B�u���Q�Ɓv�́uHSPTV!�v������肵
	�Ă��������B
	
�����쌠
	���쌠�͍�҂ł����傪�����Ă��܂����A�v���O�����̓]�p�E���ρAhpi �̔z�z��
	�����܂��B���ɂ����񍐂���`���͂���܂���B
	
���Q��
	�E�v���O���L�� ( http://prograpark.ninja-web.net/ )
		�T�|�[�g�y�[�W�ł��B�ӌ���v�]�A�o�O�񍐂Ȃǂ͂����̌f���܂ł��肢����
		���B�܂��A�ŐV�ł̃_�E�����[�h�͂����́u���܂��v����s���܂��B
		HSP�v���O�C���u��������܂��B
		
	�EHSPTV! ( http://hsp.tv/ )
		HSP3�̌����T�C�g�ł��B
		
	�EHSP�J��wiki ( http://hspdev-wiki.net/ )
		�� ::SideMenu::TOPICS::�v���O�C��::���̑�::�v���O�C���쐬�K�C�h
		�b�{�{�ł̃v���O�C���쐬�u��������܂��B��傪�����b�ɂȂ����Ƃ���ł��B
		
���X�V����
2010 05/22 (Sat)
	�E�X�V (ver: 1.21)�B
	
2009 08/10 (Mon)
	�Emethod.hpi �Ɠ����B
	
2009 05/05 (Tue)
	�E����ƌ��J�B
	
2009 01/29 (Thu)
	�E����ƌ��J�ɓ��ݐ؂����B
	�@�Ǝv��������J����̖Y��Ă��B(2009 5/5)
	  
Copyright(C) uedai 2008 - 2010.
