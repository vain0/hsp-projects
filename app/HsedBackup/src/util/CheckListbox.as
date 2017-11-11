//---------------------------------------------------------------------
//	�`�F�b�N�{�b�N�X�t�����X�g�r���[�\�����W���[��
//	by Kpan (Let's HSP!)
//	http://lhsp.s206.xrea.com/
//
//	�IWindows 9x�nOS�͗vIE3�ȍ~
//
//
//	�� CL_SetObject p1, p2, p3, p4, p5
//		p1, p2 = ���X�g�r���[�̃T�C�Y(�h�b�g�P��)
//		p3 = ���X�g�r���[���̍��ڕ����� (���ڂ��Ƃ� [\n] ��؂�)
//		p4 = �ǉ��̃X�^�C��
//			+ 0x0008 = �t�H�[�J�X���Ȃ��ꍇ���I�����ڂ�W�F�\����
//			+ 0x0010 = ���ڕ���������Ƃɕ\����������\�[�g
//			+ 0x0020 = ���ڕ���������Ƃɕ\������~���\�[�g
//		p5 = �ǉ��̊g���X�^�C��
//			+ 0x0001 = �O���b�h����\��
//			+ 0x0020 = �I�����ڂ̏ꍇ�ɗ�S�̂�I����Ԃ�
//			+ 0x0840 = �J�[�\�����̍��ڕ�����ɉ�����\�� (�vIE4�ȍ~)
//	
//	�@�`�F�b�N�{�b�N�X���ڂ��t�������X�g�r���[��\�����܂��B
//	stat�ɂ́A�I�u�W�F�N�gID ���Ԃ�܂��B
//	�@(Windows XP�ȍ~) ���ڂ̕����񕔕���I�����Ă��A�`�F�b�N�{�b�N�X
//	�̏�Ԃ͕ω����܂���B
//	
//	�� CL_SetCheckState p1, p2, p3
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = ���ڂ̃C���f�b�N�X�ԍ�(-1, 0�`)
//		p3 = False (�`�F�b�N���O��) or True(�`�F�b�N����)
//	
//	�@�`�F�b�N�{�b�N�X�̏�Ԃ�ݒ肵�܂��B��Ԃ�ݒ肵�������ڂ�
//	�C���f�b�N�X�ԍ�(0�`)���w�肵�Ă��������B
//	-1�̏ꍇ�́A���ׂĂ̍��ڂɓK�p����܂��B
//	
//	�� CL_GetCheckState p1, p2
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = ���ڂ̃C���f�b�N�X�ԍ�(0�`)
//	
//	�@�`�F�b�N�{�b�N�X�̏�Ԃ��擾���܂��B��Ԃ��擾���������ڂ�
//	�C���f�b�N�X�ԍ�(0�`)���w�肵�Ă��������B
//	stat ��False(�`�F�b�N�Ȃ�) or True(�`�F�b�N����)���Ԃ�܂��B
//	
//	�� CL_GetNextItem p1
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//
//	���X�g�r���[���̑I����ԂɂȂ��Ă��鍀�ڂ̃C���f�b�N�X�ԍ�
//	(0�`)���擾���܂��Bstat �ɒl���Ԃ�܂��B-1�̏ꍇ�́A�I������
//	���Ȃ����Ƃ��Ӗ����܂��B
//	
//	�� CL_GetItemCount p1
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//	
//	���X�g�r���[���̍��ڐ����擾���܂��Bstat�ɒl���Ԃ�܂��B
//	
//	�� CL_GetItemText p1, p2
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = ���ڂ̃C���f�b�N�X�ԍ�(0�`)
//
//	���X�g�r���[�̓��荀�ڂ̕�������擾���܂��B�擾���鍀�ڂ̃C��
//	�f�b�N�X�ԍ�(0�`)���w�肵�Ă��������Brefstr�ɕ����񂪕Ԃ�܂��B
//	
//	�� CL_SetItemText p1, p2, p3
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = ���ڂ̃C���f�b�N�X�ԍ�(0�`)
//		p3 = ���ڕ�����
//	
//	���X�g�r���[�̓��荀�ڂ̕������ύX(�����ւ�)���܂��B�ύX����
//	���ڂ̃C���f�b�N�X�ԍ�(0�`)���w�肵�Ă��������B
//	
//	�� CL_InsertItem p1, p2, p3
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = ���ڂ̃C���f�b�N�X�ԍ�(0�`)
//		p3 = ���ڕ�����
//	
//	���X�g�r���[�̓��荀�ڂɐV���ȕ������}�����܂��B��x�ɕ�����
//	���ڂ�}�����邱�Ƃ͂ł��܂���B�}�����鍀�ڂ̃C���f�b�N�X�ԍ�
//	(0�`)���w�肵�Ă��������B
//	
//	�� CL_DeleteItem p1, p2
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = ���ڂ̃C���f�b�N�X�ԍ�(0�`)
//	
//	���X�g�r���[�̓��荀�ڂ��폜���܂��B�폜���������ڂ̃C���f�b�N�X
//	�ԍ�(0�`)���w�肵�Ă��������B
//	
//	�� CL_DeleteAllItem p1
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//	
//	���X�g�r���[�̂��ׂĂ̍��ڂ��폜���܂��B
//	
//	�� CL_SetTextColor p1, p2
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = �F�R�[�h (0xBBGGRR�`��)
//	
//	���X�g�r���[�S�̂̕����F��ݒ肵�܂��B�F�R�[�h�́A���Ƃ��΁A
//	�u0xFF0000�v�Ȃ�A�u0xFF00FF�v�Ȃ�s���N�ł��BRGB�}�N�����ʓr
//	�p�ӂ��Ă��܂��B
//	���ڂ��ƂɈقȂ镶���F���w�肷�鏈���͗p�ӂ��Ă��܂���B
//	
//	�� CL_SetBkColor p1, p2
//		p1 = ���X�g�r���[�̃I�u�W�F�N�gID
//		p2 = �F�R�[�h (0xBBGGRR�`��)
//		
//	���X�g�r���[�S�̂̔w�i�F��ݒ肵�܂��B
//	���ڂ��ƂɈقȂ�w�i�F���w�肷�鏈���͗p�ӂ��Ă��܂���B
//	
//	�� RGB (p1, p2, p3)
//		p1,p2,p3 = R�AG�AB�̋P�x�l (0�`255)
//		
//	RGB�l��COLORREF�l(0xBBGGRR�`��)�ɕϊ�����}�N���ł��B
//	
//---------------------------------------------------------------------


#module

#define ctype RGB(%1,%2,%3) (%1 | (%2 << 8) | (%3 << 16))

#deffunc CL_SetObject int p1, int p2, str p3, int p4, int p5,  \
	local LVCOLUMN
	
	winobj "syslistview32", "", $200, $50004005 | p4, p1, p2
	IDObject = stat
	hObject = objinfo (stat, 2)
	
;	LVM_SETEXTENDEDLISTVIEWSTYLE
	sendmsg hObject, $1036, , $4 | p5
	
;	LVM_INSERTCOLUMN
	sendmsg hObject, $101B, , varptr (LVCOLUMN)
	
	sdim pszText_list, 512
	pszText_list = p3
	sdim pszText, 128
	
	i = 0
	repeat
		getstr pszText, pszText_list, i, $0D
		if strsize = 0 : break
		i += strsize + 1
		
;		LVM_INSERTITEM
		LVITEM = 0x01, cnt, 0, 0, 0, varptr (pszText)
		sendmsg hObject, 0x1007, , varptr (LVITEM)
	loop
	
;	LVM_SETCOLUMNWIDTH
	sendmsg hObject, $101E, , -2
	
	return IDObject
	
	
#deffunc CL_SetCheckState int p1, int p2, int p3
;	LVM_SETITEMSTATE
	LVITEM.3 = p3 + 1 << 12, $F000
	sendmsg objinfo (p1, 2), $102B, p2, varptr (LVITEM)
	
	return
	
	
#deffunc CL_GetCheckState int p1, int p2
;	LVM_GETITEMSTATE
	sendmsg objinfo (p1, 2), $102C, p2, $F000
	
	return (stat >> 12) - 1
	
	
#deffunc CL_GetNextItem int p1
;	LVM_GETNEXTITEM
	sendmsg objinfo (p1, 2), $100C, -1, $2

	return stat


#deffunc CL_GetItemCount int p1
;	LVM_GETITEMCOUNT
	sendmsg objinfo (p1, 2), 0x1004

	return (stat)
	
	
#deffunc CL_GetItemText int p1, int p2
;	LVM_GETITEMTEXT
	LVITEM = $1, 0, 0, 0, 0, varptr (pszText), 128
	sendmsg objinfo (p1, 2), $102D, p2, varptr (LVITEM)
	
	return pszText
	
	
#deffunc CL_SetItemText int p1, int p2, str p3
;	LVM_SETITEMTEXT
	pszText = p3
	LVITEM = $1, 0, 0, 0, 0, varptr (pszText)
	sendmsg objinfo (p1, 2), $102E, p2, varptr (LVITEM)

	return


#deffunc CL_InsertItem int p1, int p2, str p3
;	LVM_INSERTITEM
	pszText = p3
	LVITEM = $1, p2, 0, 0, 0, varptr (pszText)
	sendmsg hObject, $1007, , varptr (LVITEM)

;	LVM_SETCOLUMNWIDTH
	sendmsg hObject, $101E, , -2

	return


#deffunc CL_DeleteItem int p1, int p2
;	LVM_DELETEITEM
	sendmsg objinfo (p1, 2), $1008, p2

	return


#deffunc CL_DeleteAllItem int p1
;	LVM_DELETEALLITEMS
	sendmsg objinfo (p1, 2), $1009

	return


#deffunc CL_SetTextColor int p1, int p2
;	LVM_SETTEXTCOLOR
	sendmsg objinfo (p1, 2), $1024, , p2

;	LVM_UPDATE
	sendmsg objinfo (p1, 2), $102A

	return


#deffunc CL_SetBkColor int p1, int p2
;	LVM_SETBKCOLOR
	sendmsg objinfo (p1, 2), $1001, , p2

;	LVM_SETTEXTBKCOLOR
	sendmsg objinfo (p1, 2), $1026, , p2

;	LVM_UPDATE
	sendmsg objinfo (p1, 2), $102A

	return

#global


#if 0
	sdim list_text, 128
	list_text = "HSP3\n���X�g�r���[\n�`�F�b�N���X�g\n�X�N���v�g\nLet's HSP!"

;	�`�F�b�N�{�b�N�X�t�����X�g�r���[�ݒu
	pos 10, 10
	CL_SetObject 200, 100, list_text
	idListview = stat

;	�����F��Ԃ�
	CL_SetTextColor idListview, RGB ($FF, 0, 0)

;	�ォ�獀�ڒǉ�
	CL_InsertItem idListview, 1, "(�ǉ�) �T���v���R�[�h"

;	�C���f�b�N�X�ԍ��Q�̍��ڂ��`�F�b�N
	CL_SetCheckState idListview, 2, 1

	button "�`�F�b�N���", *getstate
	button "�`�F�b�N���]", *setstate

	stop


*getstate
;	���ڐ��擾
	CL_GetItemCount idListview

	result = ""
	repeat stat
;		���ڏ�Ԏ擾
		CL_GetCheckState idListview, cnt
		result += "["+stat+"]"
	loop
	mes result

	stop


*setstate
;	���ڐ��擾
	CL_GetItemCount idListview

	repeat stat
;		���ڏ�Ԏ擾
		CL_GetCheckState idListview, cnt
		if stat {
;			��ԕύX (�`�F�b�N�O��)
			CL_SetCheckState idListview, cnt
		} else {
;			��ԕύX (�`�F�b�N�t����)
			CL_SetCheckState idListview, cnt, 1
		}
	loop

	stop
#endif