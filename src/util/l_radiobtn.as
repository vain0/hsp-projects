/*--------------------------------------------------------------------------

	[HSP3] ���W�I�{�^���쐬���W���[��
	by Kpan
	http://lhsp.s206.xrea.com/ (Let's HSP!)
	
	radiobtn "������", p2, p3
		p2 = �`�F�b�N����ꂽ���ꍇ��1���w��
		p3 = �O���[�v�����J�n�������ꍇ��1���w�� (�J�n�t���O)
	
	���W�I�{�^����\�����܂��Bstat�ɃI�u�W�F�N�gID���Ԃ�܂��B
	���ꂮ����O���[�v���ɕʂ̃I�u�W�F�N�g�ݒu���߂��Ă΂Ȃ���
	���������B
	
	
	pushbtn "������", p2, p3
		p2 = �{�^�������܂������ꍇ��1���w��
		p3 = �O���[�v�����J�n�������ꍇ��1���w�� (�J�n�t���O)
	
	�v�b�V���{�^���^���W�I�{�^����\�����܂��Bstat�ɃI�u�W�F�N�g
	ID���Ԃ�܂��B���ꂮ����O���[�v���ɕʂ̃I�u�W�F�N�g�ݒu
	���߂��Ă΂Ȃ��ł��������B
	
	
	prmbtn p1, p2
		p1 = �O���[�v���̍ŏ��̃I�u�W�F�N�gID
		p2 = �O���[�v���̍Ō�̃I�u�W�F�N�gID

	���W�I�{�^���̏�Ԃ̊m�F���܂��B���ꂮ����w�肷��I�u�W�F
	�N�gID�l���ԈႦ�Ȃ��ł��������B
	stat�Ƀ`�F�b�N������(= �{�^��������ł���)�I�u�W�F�N�gID��
	�Ԃ�܂��B-1�̏ꍇ�̓`�F�b�N��1���Ȃ����Ƃ��Ӗ����܂��B
	
--------------------------------------------------------------------------*/

#ifndef __l_radiobtn_as
#define __l_radiobtn_as

#module

#uselib "user32"
#func   SetWindowLong "SetWindowLongA" int,int,int

#deffunc radiobtn str p1, int p2, int p3, local objID
	_p2 = p2
	chkbox p1, _p2
	objID = stat
	
	if ( p3 ) {
		SetWindowLong objinfo(objID, 2), -16, 0x50020009
	} else {
		sendmsg objinfo(objID, 2), 0x00F4, 0x0009
	}
	return objID
	
#deffunc pushbtn str p1, int p2, int p3, local objID
	_p2 = p2
	chkbox p1, _p2
	objID = stat

	if ( p3 ) {
		SetWindowLong objinfo(objID, 2), -16, 0x50021009
	} else {
		SetWindowLong objinfo(objID, 2), -16, 0x50001009
	}
	
	return objID
	
#deffunc prmbtn int p1, int p2, local nRet
	nRet = -1
	repeat p2 - p1 + 1, p1
		sendmsg objinfo(cnt, 2), 0x00F0
		if ( stat == 1 ) {
			nRet = cnt
			break
		}
	loop
	return nRet
	
#global
	
#endif
