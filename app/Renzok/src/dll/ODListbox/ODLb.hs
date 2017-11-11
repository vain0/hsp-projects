%dll
ODListbox.dll
%ver
1.00
%date
2008 9/12 (Fri)
%author
Ue-dai
%url
http://prograpark.ninja-web.net/
%note
ODListbox.as �� #include ���邱��
%type
�g���R���g���[���E���C�u����
%port
Win
%portinfo

%index
ODLbCreate
�I�[�i�[�`�惊�X�g�{�b�N�X�̐���
%prm
p1, p2, p3, p4, p5
p1 = hwnd	: ���X�g�{�b�N�X��u���E�B���h�E�̃n���h��
p2 = int	: ���X�g�{�b�N�X�̍���w���W
p3 = int	: ���X�g�{�b�N�X�̍���x���W
p4 = int	: ����
p5 = int	: �c��

return = lbID	: ODListbox��ID

%inst
ODListbox �𐶐����܂��B
stat �ɁA���ꂽ���X�g�{�b�N�X�� ID ���Ԃ�܂��B�K���ϐ��ɑ�����āA�ۑ����Ă��������B0 ���珇�Ԃ� 0, 1, 2 ... �ƂȂ�ۏ؂͂ł��܂���B

%sample
#include "ODListbox.as"
	ODLbCreate hwnd, 10, 10, 200, 400
	lbID = stat
	stop

%href
;ODLbCreate
ODLbDestroy
ODLbProc
%group
ODLb����n�֐�
%index
ODLbDestroy
�I�[�i�[�`�惊�X�g�{�b�N�X�̔j��
%prm
p1
p1 = lbID	: ODListbox��ID
%inst
�I�[�i�[�`�惊�X�g�{�b�N�X��j�����܂��B
�I�����ɂ��̖��߂��Ăяo���ׂ��ł��B
%href
ODLbCreate
;ODLbDestroy
ODLbProc
%group
ODLb����n�֐�
%index
ODLbProc
�I�[�i�[�`�惊�X�g�{�b�N�X�̃v���V�[�W��
%prm
p1, p2, p3, p4
p1 = lbID	: ODListbox��ID
p2 = int	: �E�B���h�E���b�Z�[�W
p3 = WPARAM	: wparam�l
p4 = LPARAM	: lparam�l
%inst
���̃{�b�N�X�ɑ����Ă������b�Z�[�W���������邽�߂̃v���V�[�W���ł��B
WM_DRAWITEM �� WM_MEASUREITEM ���e�E�B���h�E�ɑ����Ă����ꍇ�A
����� WPARAM �� LPARAM �����̂܂܎w�肵�āA���̊֐����Ăяo���Ă��������B
���̊֐��̂Ȃ��ŁA�`��Ȃǂ̕K�v�ȏ������s���Ă��܂��B

�K���AODLbCreate ���Ăяo���O�ɁA���̖��߂����s�ł���悤�ɂ��Ă����Ă��������B
(�T���v���Q��)

�����������Ăяo���Ȃ��Ă������悤�ɂ��悤�ƕ������c�c�B
%sample
#include "ODListbox.as"
	
	// ��Ɋ��荞�݂�ݒ肷��
	oncmd gosub *OnDrawItem,    0x002B	// WM_DRAWITEM
	oncmd gosub *OnMeasureItem, 0x002C	// WM_MEASUREITEM
	
	// ��������
	ODLbCreate hwnd, 10, 10, 200, 400
	lbID = stat
	hListbox = ODLbGetHandle(lbID)
	stop
	
*OnDrawItem
	dupptr dis, lparam, 12		// DRAWITEMSTRUCT �\����
	if ( hListbox == dis(5) ) {	// �n���h���������ꍇ
		ODLbProc lbID, iparam, wparam, lparam
	}
	return
	
*OnMeasureItem
	// ���̃{�b�N�X�����Ȃ��Ȃ�A�P�Ɂ������ł�����
	ODLbProc lbID, iparam, wparam, lparam
	return
	
%href
ODLbCreate
ODLbDestroy
;ODLbProc
%group
ODLb����n�֐�
%index
ODLbInsertItem
�I�[�i�[�`�惊�X�g�{�b�N�X�ɍ��ڂ�}������
%prm
p1, p2, p3 = -1
p1 = lbID	: ODListbox��ID
p2 = str	: �}�����镶����
p3 = int	: �}�����鍀�ڂ̔ԍ��B�ȗ��������Ȃ��Ԍ��B
%inst
�I�[�i�[�`�惊�X�g�{�b�N�X�ɍ��ڂ�ǉ��E�}�����܂��B
���ꂮ��� LB_INSERTSTRING �� LB_ADDSTRING �𑗐M���Ȃ��悤�ɂ��Ă��������B
�����̃f�[�^�̈�Ŋe���ڂ̏����Ǘ����Ă���̂ŁA���ꂪ�����Ă��܂��܂��B
%href
;ODLbInsertItem
ODLbDeleteItem
ODLbMoveItem
ODLbSwapItem
%group
ODLb���ڑ���n�֐�
%index
ODLbDeleteItem
�I�[�i�[�`�惊�X�g�{�b�N�X���獀�ڂ���菜��
%prm
p1, p2 = -1
p1 = lbID	: ODListbox��ID
p2 = int	: ��菜�����ڂ̃C���f�b�N�X (��ԏオ0�ŁA1����������)
%inst
�I�[�i�[�`�惊�X�g�{�b�N�X���獀�ڂ���菜���܂��B
���ꂮ��� LB_DELETESTRING �� LB_RESETCONTENT �𑗐M���Ȃ��悤�ɂ��Ă��������B
�����̃f�[�^�̈�Ŋe���ڂ̏����Ǘ����Ă���̂ŁA���ꂪ�����Ă��܂��܂��B
%href
ODLbInsertItem
;ODLbDeleteItem
ODLbMoveItem
ODLbSwapItem
%group
ODLb���ڑ���n�֐�
%index
ODLbMoveItem
�I�[�i�[�`�惊�X�g�{�b�N�X�̍��ڂ��ړ�����
%prm
p1, p2, p3
p1 = lbID	: ODListbox��ID
p2 = int	: �ړ������ڂ̃C���f�b�N�X (��ԏオ0�ŁA1����������)
p3 = int	: �ړ��捀�ڂ̃C���f�b�N�X (�V)
%inst
�C���f�b�N�X p2 �̍��ڂ��Ap3 �̈ʒu�Ɉړ������܂��B
����ȊO�̍��ڂ̏��Ԃ͈ړ����܂���B
%href
ODLbInsertItem
ODLbDeleteItem
;ODLbMoveItem
ODLbSwapItem
%group
ODLb���ڑ���n�֐�
%index
ODLbSwapItem
�I�[�i�[�`�惊�X�g�{�b�N�X�̍��ڂ���������
%prm
p1, p2, p3
p1 = lbID	: ODListbox��ID
p2 = int	: ���ڃC���f�b�N�X (��ԏオ0�ŁA1����������)
p3 = int	: �V
%inst
���ڃC���f�b�N�X p2, p3 �̍��ڂ��������܂��B
%href
ODLbInsertItem
ODLbDeleteItem
ODLbMoveItem
;ODLbSwapItem
%group
ODLb���ڑ���n�֐�
%index
ODLbSetMarginColor
�}�[�W���F��ݒ肷��
%prm
p1, p2 = -1, p3
p1 = lbID	: ODListbox��ID
p2 = int	: �ݒ肷�鍀�ڂ̃C���f�b�N�X (��ԏオ�O)
p3 = int	: (COLORREF) �}�[�W���F
%inst
�I�[�i�[�`�惊�X�g�{�b�N�X�̃}�[�W���̐F��ݒ肵�܂��B
�}�[�W���Ƃ́A���ڂƍ��ڂ̊Ԃɂ���A���ڂł͂Ȃ������̂��Ƃł��B
�ʏ�͂Ȃ����߁AODLbSetItemMargin ���߂��Ă΂Ȃ��ƌ����܂���B

p2 �ɍ��ڃC���f�b�N�X���w�肵���ꍇ�A
���̍��ڂƁA���̉��ɂ��鍀�ڂƂ̊Ԃ̃}�[�W���̐F���ύX����܂��B
p2 ���ȗ����邩�A����(-1)�ɂ����ꍇ�A���ׂĂ̍��ڂ̃}�[�W���F���ύX����A
��{�}�[�W���F�� p3 �̐F�ɕύX����܂��B
��{�}�[�W���F�Ƃ́A�ǉ����ꂽ���ڂ̍ŏ��̃}�[�W���F�ɂȂ�F�̂��Ƃł��B

COLORREF �Ƃ́A�F��\�����l�ł��B
����́ARGB �}�N�����g�p���� RGB( r, g, b ) �ƁA�w�肵�Ă��������B
16�i���� 0xBBGGRR �Ƃ��ł��܂��B
%href
;ODLbSetMarginColor
ODLbSetItemColor
ODLbSetItemPadding
ODLbSetItemMargin
ODLbSetItemHeight
ODLbSetTextFormat
ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbSetItemColor
���ڂ̐F��ݒ肷��
%prm
p1, p2 = 0, p3 = ��, p4 = ��
p1 = lbID	: ODListbox��ID
p2 = int	: ���ڃC���f�b�N�X ( ��ԏオ�O )
p3 = int	: �����F
p4 = int	: �w�i�F
%inst
�w�肵�����ڂ̕����F�Ɣw�i�F��ύX���܂��B
%href
ODLbSetMarginColor
;ODLbSetItemColor
ODLbSetItemPadding
ODLbSetItemMargin
ODLbSetItemHeight
ODLbSetTextFormat
ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbSetItemPadding
���ڂ̃p�f�B���O��ݒ肷��
%prm
p1, p2 = -1, p3 = -1, p4 = -1, p5 = -1
p1 = lbID	: ODListbox��ID
p2 = int	: ���̃p�f�B���O (px)
p3 = int	: ��̃p�f�B���O (px)
p4 = int	: �E�̃p�f�B���O (px)
p5 = int	: ���̃p�f�B���O (px)

%inst
���ׂĂ̍��ڂɊ܂܂��p�f�B���O��ݒ肵�܂��B
�ȗ��������A�����ɂ����p�����[�^�̃p�f�B���O�͕ύX����܂���B

�p�f�B���O�̓}�[�W���Ɠ������u�]���v�ł����A
�}�[�W���Ƃ͈���āA�u���ڂ̈ꕔ�v�ł��B

%href
ODLbSetMarginColor
ODLbSetItemColor
;ODLbSetItemPadding
ODLbSetItemMargin
ODLbSetItemHeight
ODLbSetTextFormat
ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbSetItemMargin
���ڊԃ}�[�W���̑傫����ݒ肷��
%prm
p1, p2
p1 = lbID	: ODListbox��ID
p2 = int	: �}�[�W���̑傫�� (px)
%inst
�����̖��߂��g���ꍇ�́A�K��ODLbSetItemHeight���߂��ĂԕK�v������܂��B

�}�[�W���̑傫����ݒ肵�܂��B
�ʂɎw�肷�邱�Ƃ͂ł��܂���B
���̗̈�̔w�i�F�́AODLbSetMarginColor ���߂Őݒ肵�Ă��������B

%href
ODLbSetMarginColor
ODLbSetItemColor
ODLbSetItemPadding
;ODLbSetItemMargin
ODLbSetItemHeight
ODLbSetTextFormat
ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbSetItemHeight
���ڂ̍�����ݒ肷��
%prm
p1, p2
p1 = lbID	: ODListbox��ID
p2 = int	: ���� (px)
%inst
���ڂ̍�����ݒ肵�܂��B�f�t�H���g�ł�20�ɂ���A�኱�����ł��B
���ۂ̍��ڂ̍����́A����ɏ㉺�̃p�f�B���O�ƃ}�[�W���𑫂����l�ɂȂ�A
�ꍇ�ɂ���ẮA���̒l�𐮐��{���Ē������܂��B
%href
ODLbSetMarginColor
ODLbSetItemColor
ODLbSetItemPadding
ODLbSetItemMargin
;ODLbSetItemHeight
ODLbSetTextFormat
ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbSetTextFormat
���ڂɕ`�悷�镶����̃I�v�V������ύX����
%prm
p1, p2, p3
p1 = lbID	: ODListbox��ID
p2 = int	: �ǉ����鏑���̃t���O
p3 = int	: ��菜�������̃t���O
%inst
���ڂɕ������`�悷��Ƃ��Ɏg���AWin32 API �� DrawItem �֐��Ɏw�肷�鏑����ύX���܂��B
�f�t�H���g�� (DT_LEFT | DT_END_ELLIPSIS) �ł��B
�����̃t���O�́A��������Ă��� ODListbox.as �̃T���v�������ɒ�`������܂��B
��������p���Ă��������B

��p2 �� p3 �ɓ����l���w�肵���ꍇ�A���̒l�͒ǉ�����܂���B

%href
ODLbSetMarginColor
ODLbSetItemColor
ODLbSetItemPadding
ODLbSetItemMargin
ODLbSetItemHeight
;ODLbSetTextFormat
ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbSetItemLParam
���ڂɒl���֘A�Â���
%prm
p1, p2
p1 = lbID	: ODListbox��ID
p2 = int	: �A�v���P�[�V������`�l
%inst
%href
ODLbSetMarginColor
ODLbSetItemColor
ODLbSetItemPadding
ODLbSetItemMargin
ODLbSetItemHeight
ODLbSetTextFormat
;ODLbSetItemLParam
%group
ODLb�ݒ�n�֐�
%index
ODLbGetHandle
�I�[�i�[�`�惊�X�g�{�b�N�X�̃n���h�����擾
%prm
(p1)
p1 = lbID	: ODListbox��ID
return hwnd	: �I�[�i�[�`�惊�X�g�{�b�N�X�̃n���h��

%inst
�w�肵��ID�̃��X�g�{�b�N�X�̃n���h�����擾���܂��B
%href
;ODLbGetHandle
ODLbGetLParam
%group
ODLb�擾�n�֐�
%index
ODLbGetLParam
���ڂɊ֘A�Â���ꂽ�l���擾����
%prm
(p1, p2)
p1 = lbID	: ODListbox��ID
p2 = int	: ���ڃC���f�b�N�X (��ԏオ�O)
return int	: �֘A�Â����Ă���l
%inst
�w�肵�����ڂɊ֘A�Â����Ă���l���擾���܂��B
�Ȃɂ��֘A�Â��Ă��Ȃ��ꍇ�́A�O���Ԃ�܂��B
%href
ODLbGetHandle
;ODLbGetLParam
%group
ODLb�擾�n�֐�
