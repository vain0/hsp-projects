; WarigakiEditor ��p�̐V�K���߁E�֐��ł��B
;
;-------------------------------------------------------------------------------
#deffunc faceup int FaceUp_p1, int FaceUp_p2
	faceupmode = limit(FaceUp_p1, 0, 2)
	if mode = 0 {
		gsel wid_split_edit, faceupmode
	} else {
		gsel wid_tab_edit, faceupmode
		if FaceUp_p2 >= 1 : gsel wid_tab_first + actobj, FaceUp_p2
	}
	return
	
;-------------------------------------------------------------------------------
#deffunc ResetSwitch
; �ꎞ�ێ��p�ϐ������Z�b�g
	sdim ms, 1024, 50, 20, 5, 5		; �����ϐ�
	dim  mi,  100, 50, 20, 5		; �����ϐ�
	sdim edit_buf, 500000, 2		; ����������Ƃ��A�ꎞ�I��edit�̓��e�𗭂߂Ă����ϐ�
	dim  edit_long, 2				; �ǉ�����Ƃ��A���̂������܂ł̃I�t�Z�b�g�l��strlen�֐��ŗ��߂Ă����ϐ��B0�����A1����B
	n = 0 							; note �̗��B���������ɂ�����
	sdim file_Ext, 24				; extention(�g���q)���ꎞ�ۑ����邽�߂̂���
	sdim savedl, 510				; �Z�[�u����t�@�C���f�B���N�g�����B
	
; �X�C�b�`�����Z�b�g
	dim LastStr
	dim Position
	dim TBC			; TabBoxCanger �^�u�̔��̃i���o�[�B�`�����тɈꑝ�₵�A�Ō�Ƀ��Z�b�g����B
	dim makeonly 	; �G�f�B�b�g�{�b�N�X���ĕ`�悷��Ƃ��ɂ̂ݎg�p
	dim bmonly		; back color Brush Make ONLY �̗�
	dim wc			; Word Color type �̗� 0�͔w�i�F�A1���ƕ����F
	dim new_end		; NEW END�@[�V�K]�̎��ɏI���Z�[�u���s�����߂Ɏg�p
	return
	
;-------------------------------------------------------------------------------
#deffunc SBfunction int SB_p1, int SB_p2
	SetButtonPosx = SB_p1
	SetButtonPosy = SB_p2
	repeat 3
		button gosub box_symbol(cnt), routine	; ID 0�`2
	loop
	
	pos SetButtonPosx, SetButtonPosy	; 130, 50
	
	repeat 3
		button gosub box_symbol(cnt+3), routine	; ID 3�`5
	loop
	return
	
#define global SetButton(%1=130,%2=50) SBfunction %1, %2
	
;-------------------------------------------------------------------------------
#deffunc DelButton
	; �s�v�Ȗ��{�^�����폜
	if boxs = 1 			: clrobj 1,5
	if boxs = 2 and btw = 0 : clrobj 2,5
	if boxs = 2 and btw = 1 : clrobj 1,2 : clrobj 4,5
	if boxs = 3 			: clrobj 3,5
	if boxs = 4 and bju = 0 : clrobj 4,5
	if boxs = 4 and bju = 1 : clrobj 2,2 : clrobj 5,5
	if boxs = 5 			: clrobj 5,5
	return
	
;-------------------------------------------------------------------------------
#deffunc Back
	faceup 1
	
	// �c�[����ʏ�����
	gsel wid_tool
	esr , 1
	gsel wid_tool, -1
	
	faceup 0
	return
	
;-------------------------------------------------------------------------------
#deffunc b
	
	return
	
;-------------------------------------------------------------------------------
#deffunc c
	
	return
	
;-------------------------------------------------------------------------------
#deffunc d
	
	return
	
;-------------------------------------------------------------------------------
; �N���[���A�b�v����
; end ���߂ł��K�p�����B
#deffunc CleanUpper onexit
	; �ז��t�@�C��������
	delfile_if_exists "�����ݒ�t�@�C����.dat"
	gosub *Delete_Brush	; �u���V�폜
	return
	