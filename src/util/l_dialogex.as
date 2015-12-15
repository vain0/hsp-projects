/*--------------------------------------------------------------------------

	[HSP3] �g�������t�@�C���̊J��/�ۑ��_�C�A���O ���W���[��
	by Kpan
	http://lhsp.s206.xrea.com/ (Let's HSP!)

	dialogEx p1, p2, p3, p4, p5
		p1=�_�C�A���O�̎�� {�J��(0) / �ۑ�(1)}
		p2=[�t�@�C���̎��]�ŕ\�����镶����
		p3=[�t�@�C����]�ŕ\�����镶����
		p4=�_�C�A���O�̃^�C�g����
		p5=�����t�H���_�p�X

	�t�@�C���̊J���_�C�A���O(dialog���߂̃^�C�v16����)�A�ۑ��_�C�A
	���O(�^�C�v17����)��\�����܂��B�t�@�C���̑I��������ɍs����ƁA
	stat��1�Arefstr�Ƀt�@�C���p�X���Ԃ�܂��B�L�����Z����G���[��
	�ꍇ��stat��0���Ԃ�܂��B

	p2�̓_�C�A���O��[�t�@�C���̎��]���ڂŕ\�����镶����ł��B���X�g
	�{�b�N�X�ɕ����̊g���q��p�ӂł��܂��B�������|*.�g���q|�`��Ƃ���
	�`���ŏ����Ă��������B(�ڂ����̓T���v���Q��)

	p3�̓_�C�A���O��[�t�@�C����]���ڂŕ\�����镶����ł��Bdialog����
	�ł͊g���q�������I�ɕ\������镔���ł��B

	p4�̓_�C�A���O�̃^�C�g�����ł��B�""��Ƃ����`�ŏȗ������ꍇ�A����
	�I�ɢ�t�@�C�����J����A����O�����ĕۑ���ɂȂ�܂��B

	p5�͏����t�H���_�̃p�X�ł��Bchdir���߂ɑ������܂��B

	(��) ���W���[�����g�p����ɓ������āA�X�N���v�g�G�f�B�^��[HSP]
	���j���[��[HSP�g���}�N�����g�p����]��L���ɂ��Ă����Ă��������B

--------------------------------------------------------------------------*/


#module


#uselib "comdlg32"
#func GetOpenFileName "GetOpenFileNameA" int
#func GetSaveFileName "GetSaveFileNameA" int


#deffunc dialogEx int v0, str v1, str v2, str v3, str v4

	sdim lpstrFilter, 256 : lpstrFilter = v1
	sdim lpstrInitialDir, 128 : lpstrInitialDir = v4
	sdim lpstrFile, 128 : lpstrFile = v2
	sdim lpstrTitle, 64 : lpstrTitle = v3

	repeat strlen (lpstrFilter)
		x = peek (lpstrFilter, cnt)
		if x>$80 & x<$A0 | x>$DF & x<$FD : continue cnt+2
		if x = $7C : poke lpstrFilter, cnt, $00
	loop

	prm = 76, hwnd, hinstance, varptr (lpstrFilter), 0, 0, 0, varptr (lpstrFile), 256, 0, 0, varptr (lpstrInitialDir), varptr (lpstrTitle)

	if v0 {
		prm.13 = $806 : GetSaveFileName varptr (prm)
	} else {
		prm.13 = $1004 : GetOpenFileName varptr (prm)
	}

	if stat = 0 : return
	return lpstrFile

#global
