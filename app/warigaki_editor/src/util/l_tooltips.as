/*--------------------------------------------------------------------------

	[HSP3] �c�[���`�b�v�\�����W���[�� v2
	by Kpan
	http://lhsp.s206.xrea.com/ (Let's HSP!)


	�� SetToolTips p1
		p1=�X�^�C���̎w��

	�c�[���`�b�v�R���g���[�����쐬���܂��B�ŏ���1�x�����Ă�ł��������B
	stat�ɂ́A�c�[���`�b�v�R���g���[���̃I�u�W�F�N�gID���Ԃ�܂��B
	p1�̓X�^�C���̎w��ł��B���ׂẴc�[���`�b�v�ɓK�p�����`�ɂȂ�
	�܂��B�ȉ��̐��l��g�ݍ��킹�Ă��������B���w��̏ꍇ�͕��ʂ̃c�[��
	�`�b�v���\������܂��B

	$1  : ���E�B���h�E���A�N�e�B�u�ɂȂ��Ă��Ȃ����ł���Ƀc�[���`�b�v
	      ��\���B
	$40 : �c�[���`�b�v���o���[���^�C�v�ŕ\���B(�vIE5�ȍ~)


	�� AddToolTips p1, "������", p2
		p1=�c�[���`�b�v��\������I�u�W�F�N�gID�B
		p2=�c�[���`�b�v���I�u�W�F�N�g�̐^���ɕ\���B($2���w��)

	�c�[���`�b�v�R���g���[���ɕ\���������o�^���܂��B�w�肵���I�u
	�W�F�N�g�Ƀc�[���`�b�v���\������܂��B�������64�o�C�g���̗̈��
	�ꉞ�p�ӂ��Ă��܂��B	

--------------------------------------------------------------------------*/

#module


;	�ʓruser32.as���C���N���[�h���Ă���ꍇ�̓R�����g�A�E�g��
#uselib "user32"
#func GetClientRect "GetClientRect" int, int


#deffunc SetToolTips int p1
	winobj "tooltips_class32", "", , p1
	hTooltips = objinfo (stat, 2)

	dim RECT, 4

	return stat

#deffunc AddToolTips int p1, str p2, int p3
	hObject = objinfo (p1, 2)

	GetClientRect hObject, varptr (RECT)

	sdim lpszText
	lpszText = p2

	TOOLINFO = 40, $10 | p3, hObject, 0, 0, 0, RECT.2, RECT.3, 0, varptr (lpszText)
	sendmsg hTooltips, $404, , varptr (toolinfo)

	return

#global