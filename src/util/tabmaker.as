;    ��@�\�ȃ^�u�R���g���[���쐬���W���[�� (by Kpan) ���Q�l�ɂ��܂���
;
#module

#uselib "user32"
#func GetClientRect "GetClientRect" int, int
#func SetWindowLong "SetWindowLongA" int, int, int
#func SetParent "SetParent" int, int

#uselib "gdi32"
#cfunc GetStockObject "GetStockObject" int

	; CreateTab p1, p2, p3, p4
	; �^�u�R���g���[����ݒu���܂��Bstat�Ƀ^�u�R���g���[���̃n���h�����Ԃ�܂��B
	; p1�`p2=�^�u�R���g���[����X/Y�����̃T�C�Y
	; p3(1)=�^�u�̍��ڂƂ��ē\��t����bgscr���߂̏���E�B���h�EID�l
	; p4=�^�u�R���g���[���̒ǉ��E�B���h�E�X�^�C��
	
#deffunc CreateTab int p1, int p2, int p3, int p4
	winobj "systabcontrol32", "", , $52000000 | p4, p1, p2
	hTab = objinfo (stat, 2)
	sendmsg hTab, $30, GetStockObject (17)
	
	TabID = p3
	if TabID = 0 : TabID = 1
	
	dim rect, 4
	
		return hTab	; ���̒l�� stat �ɑ�������

	; InsertTab "�^�u�܂ݕ����̕�����"
	; �^�u�R���g���[���ɍ��ڂ�ǉ����܂��B
	
#deffunc InsertTab str p2
	pszText = p2 : tcitem = 1, 0, 0, varptr (pszText)
	sendmsg hTab, $1307, TabItem, varptr (tcitem)
	
	GetClientRect hTab, varptr (rect)
	sendmsg hTab, $1328, , varptr (rect)

bgscr TabID + TabItem, rect.2 - rect.0, rect.3 - rect.1, 2, rect.0, rect.1
	SetWindowLong hwnd, -16, $40000000
	SetParent hwnd, hTab

	TabItem = TabItem + 1
		return

	; �^�u�؂�ւ������p
	
#deffunc ChangeTab
	gsel wID + TabID, -1
	
	sendmsg hTab, $130B
	wID = stat
	gsel wID + TabID, 1
	
		return

#global