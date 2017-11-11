// Header - TreeView

#ifndef IG_HEADER_TREEVIEW_AS
#define IG_HEADER_TREEVIEW_AS

#define global WC_TREEVIEWA	"SysTreeView32"
#define global WC_TREEVIEW	WC_TREEVIEWA

#define global TVM_INSERTITEM			0x1100		// �V�����A�C�e����ǉ�
#define global TVM_DELETEITEM			0x1101		// �A�C�e�����폜
#define global TVM_EXPAND				0x1102		// �A�C�e�����J���E����
#define global TVM_GETITEMRECT			0x1104		// �w�荀�ڂ�RECT���擾
#define global TVM_GETCOUNT				0x1105		// �A�C�e�����̎擾
#define global TVM_GETINDENT			0x1106		// �e���ڂɑ΂��鑊�ΓI�ȃC���f���g���擾
#define global TVM_SETINDENT			0x1107		// �C���f���g��ݒ肷��
#define global TVM_GETIMAGELIST			0x1108		// �C���[�W���X�g���擾
#define global TVM_SETIMAGELIST			0x1109		// �C���[�W���X�g��ݒ�
#define global TVM_GETNEXTITEM			0x110A		// �w�肳�ꂽ�A�C�e�����擾
#define global TVM_SELECTITEM			0x110B		// �A�C�e����I������
#define global TVM_GETITEM				0x110C		// �A�C�e���̑������擾
#define global TVM_SETITEM				0x110D		// �A�C�e���̑�����ݒ�
#define global TVM_EDITLABEL			0x110E		// 
#define global TVM_GETEDITCONTROL		0x110F		// �ҏW�Ɏg�p����Ă���EditControl�̃n���h���𓾂�
#define global TVM_GETVISIBLECOUNT		0x1110		// �\���\�ȃA�C�e�����̎擾
#define global TVM_HITTEST				0x1111		// �q�b�g�e�X�g
#define global TVM_CREATEDRAGIMAGE		0x1112		// 
#define global TVM_SORTCHILDREN			0x1113		// �q�A�C�e���̃\�[�g
#define global TVM_ENSUREVISIBLE		0x1114		// 
#define global TVM_SORTCHILDRENCB		0x1115		// 
#define global TVM_ENDEDITLABELNOW		0x1116		// 
#define global TVM_GETISEARCHSTRING		0x1117		// 
#define global TVM_SETTOOLTIPS			0x1118		// 
#define global TVM_GETTOOLTIPS			0x1119		// 
#define global TVM_SETINSERTMARK		0x111A		// 
#define global TVM_SETITEMHILIGHT		0x111B		// 
#define global TVM_GETITEMHILIGHT		0x111C		// 
#define global TVM_SETBKCOLOR			0x111D		// �w�i�F��ݒ�
#define global TVM_SETTEXTCOLOR			0x111E		// �����F��ݒ�
#define global TVM_GETBKCOLOR			0x111F		// �w�i�F���擾
#define global TVM_GETTEXTCOLOR			0x1120		// �����F���擾
#define global TVM_SETSCROLLTIME		0x1121		// 
#define global TVM_GETSCROLLTIME		0x1122		// 
#define global TVM_SETINSERTMARKCOLOR	0x1125		// 
#define global TVM_GETINSERTMARKCOLOR	0x1126		// 
#define global TVM_GETITEMSTATE			0x1127		// ���ڂ̏�Ԃ��擾����
#define global TVM_SETLINECOLOR			0x1128		// 
#define global TVM_GETLINECOLOR			0x1129		// 

// �`A ���b�Z�[�W
#define global TVM_INSERTITEMA			TVM_INSERTITEM
#define global TVM_GETITEMA				TVM_GETITEM
#define global TVM_SETITEMA				TVM_SETITEM
#define global TVM_GETISEARCHSTRINGA	TVM_GETISEARCHSTRING
#define global TVM_EDITLABELA			TVM_EDITLABEL

// �`W ���b�Z�[�W
#define global TVM_INSERTITEMW			0x1132
#define global TVM_GETITEMW				0x113E
#define global TVM_SETITEMW				0x113F
#define global TVM_GETISEARCHSTRINGW	0x1140
#define global TVM_EDITLABELW			0x1141

// �c���[�r���[�̃X�^�C��
#define global TVS_HASBUTTON			0x0001		// �� +-�{�^��
#define global TVS_HASLINES				0x0002		// �A�C�e������łȂ�
#define global TVS_LINESATROOT			0x0004		// ��ԏ�̃A�C�e���ɐ���t����B�v TVS_HASLINES
#define global TVS_EDITLABELS			0x0008		// ���A�C�e���ҏW
#define global TVS_DISABLEDRAGDROP		0x0010		// �~�h���b�O�h���b�v
#define global TVS_SHOWSELALWAYS		0x0020		// �t�H�[�J�X�Ȃ��ł��I��
#define global TVS_RTLREADING			0x0040		// �E���獶�ɕ�����\��(�����̌���̂�)
#define global TVS_NOTOOLTIPS			0x0080		// �~�c�[���`�b�v
#define global TVS_CHECKBOXES			0x0100		// ���`�F�b�N�{�b�N�X
#define global TVS_TRACKSELECT			0x0200		// ���z�b�g��Ԃ̉���
#define global TVS_SINGLEEXPAND			0x0400		// �r�N���b�N�ő������ׂĕ�����œV�E
#define global TVS_INFOTIP				0x0800		// ��₱�����Ƃ�����(�c�[���`�b�v���𓾂�ׁA�eWindow�� TVN_GETINFOTIP �ʒm���b�Z�[�W�𑗂����B)
#define global TVS_FULLROWSELECT		0x1000		// ��őI�� ( TVS_HASLINES �Ƌ��p�s�� )
#define global TVS_NOSCROLL				0x2000		// �~�X�N���[��
#define global TVS_NONEVENHEIGHT		0x4000		// TVM_SETITEMHEIGHT �ŁA�A�C�e���̍�����ݒ�\�B(�f�t�H���g�ł͋ϓ�)
#define global TVS_NOHSCROLL			0x8000		// TVS_NOSCROLL overrides this

// �ʒm�R�[�h
#define global TVN_SELCHANGING			(-401)		// �I�����ڂ��ς�낤�Ƃ��Ă���
#define global TVN_SELCHANGED			(-402)		// �I�����ڂ��ς����
#define global TVN_GETDISPINFO			(-403)		// 
#define global TVN_SETDISPINFO			(-404)		// 
#define global TVN_ITEMEXPANDING		(-405)		// �J�����Ƃ��Ă���
#define global TVN_ITEMEXPANDED			(-406)		// �J����
#define global TVN_BEGINDRAG			(-407)		// ���ڂ̃h���b�O���J�n���ꂽ
#define global TVN_BEGINRDRAG			(-408)		// 
#define global TVN_DELETEITEM			(-409)		// �A�C�e�����폜�����
#define global TVN_BEGINLABELEDIT		(-410)		// �e�L�X�g�̕ҏW���n�܂���
#define global TVN_ENDLABELEDIT			(-411)		// �e�L�X�g�̕ҏW���I������
#define global TVN_KEYDOWN				(-412)		// �L�[�����͂��ꂽ

// Wide �Œʒm�R�[�h
#define global TVN_SELCHANGINGW			(-450)
#define global TVN_SELCHANGEDW			(-451)
#define global TVN_GETDISPINFOW			(-452)
#define global TVN_ITEMEXPANDINGW		(-454)
#define global TVN_SETDISPINFOW			(-453)
#define global TVN_ITEMEXPANDEDW		(-455)
#define global TVN_BEGINDRAGW			(-456)
#define global TVN_BEGINRDRAGW			(-457)
#define global TVN_DELETEITEMW			(-458)
#define global TVN_BEGINLABELEDITW		(-459)
#define global TVN_ENDLABELEDITW		(-460)

// ���ڂ̏��( ItemStatus )
#define global TVIS_SELECTED			0x0002		// �I������Ă���
#define global TVIS_CUT					0x0004		// 
#define global TVIS_DROPHILITED			0x0008		// �n�C���C�g����Ă���
#define global TVIS_BOLD				0x0010		// ��������Ă���
#define global TVIS_EXPANDED			0x0020		// �J���Ă���
#define global TVIS_EXPANDEDONCE		0x0040		// 
#define global TVIS_EXPANDPARTIAL		0x0080		// 
#define global TVIS_OVERLAYMASK			0x0F00		// 
#define global TVIS_STATEIMAGEMASK		0xF000		// 
#define global TVIS_USERMASK			0xF000		// 

// TVITEM �\���̂� mask
#define global TVIF_TEXT				0x0001		// 
#define global TVIF_IMAGE				0x0002		// 
#define global TVIF_PARAM				0x0004		// 
#define global TVIF_STATE				0x0008		// 
#define global TVIF_HANDLE				0x0010		// 
#define global TVIF_SELECTEDIMAGE		0x0020		// 
#define global TVIF_CHILDREN			0x0040		// 
#define global TVIF_INTEGRAL			0x0080		// 

// ���ڂ̃C���f�b�N�X
#define global TVI_ROOT					0xFFFF0000	// ���[�g�v�f�̂Ƃ��AhParent �Ɏw�肷��
#define global TVI_FIRST				0xFFFF0001	// ���X�g�̐擪�ɒǉ�����
#define global TVI_LAST					0xFFFF0002	// ���X�g�̍Ō�ɒǉ�����
#define global TVI_SORT					0xFFFF0003	// ������Ń\�[�g���Ēǉ�����

#define global I_CHILDRENCALLBACK			1		// �q�v�f��e���`�悷��

// TVM_EXPAND �̒萔
#define global TVE_COLLAPSE				0x0001		// ����
#define global TVE_EXPAND				0x0002		// �J��
#define global TVE_TOGGLE				0x0003		// �J�؂�ւ�
#define global TVE_EXPANDPARTIAL		0x4000		// ( | TVE_EXPAND   ) �ꕔ�݂̂��J��
#define global TVE_COLLAPSERESET		0x8000		// ( | TVE_COLLAPSE ) ���č폜

// �C���[�W���X�g�̒萔
#define global TVSIL_NORMAL				0x0000		// ���ڂ̑I����ԂƔ�I����Ԃ̃C���[�W������
#define global TVSIL_STATE				0x0002		// ���[�U�[��`�̓���ȃC���[�W������

// TVM_GETNEXTITEM �̒萔
#define global TVGN_ROOT				0x0000		// ���m�[�h
#define global TVGN_NEXT				0x0001		// �Z�m�[�h
#define global TVGN_PREVIOUS			0x0002		// ��m�[�h
#define global TVGN_PARENT				0x0003		// �e�m�[�h
#define global TVGN_CHILD				0x0004		// �q�m�[�h�̐擪
#define global TVGN_FIRSTVISIBLE		0x0005		// ����Ԃ̍ŏ��̃m�[�h
#define global TVGN_NEXTVISIBLE			0x0006		// �w��m�[�h�̎��Ɍ����Ă���m�[�h( �w��m�[�h�͌����Ă���K�v���� )
#define global TVGN_PREVIOUSVISIBLE		0x0007		// �w��m�[�h�̑O�Ɍ����Ă���m�[�h( �w��m�[�h�͌����Ă���K�v���� )
#define global TVGN_DROPHILITE			0x0008		// �c���c�̑ΏۂɂȂ��Ă���m�[�h
#define global TVGN_CARET				0x0009		// �I������Ă���m�[�h
#define global TVGN_LASTVISIBLE			0x000A		// �Ō�ɊJ���ꂽ�m�[�h

// �q�b�g�e�X�g�̒萔 ( HitTest )
#define global TVHT_NOWHERE				0x0001		// �c���[�r���[��ł͂Ȃ�
#define global TVHT_ONITEMICON			0x0002		// ���ڂ̃A�C�R��
#define global TVHT_ONITEMLABEL			0x0004		// ���ڂ̃��x��
#define global TVHT_ONITEMINDENT		0x0008		// �}
#define global TVHT_ONITEMBUTTON		0x0010		// +- �{�^��
#define global TVHT_ONITEMRIGHT			0x0020		// ���ڂ̉E�ɂ����
#define global TVHT_ONITEMSTATEICON		0x0040		// 
#define global TVHT_ONITEM		(TVHT_ONITEMICON | TVHT_ONITEMLABEL | TVHT_ONITEMSTATEICON)
#define global TVHT_ABOVE				0x0100		// 
#define global TVHT_BELOW				0x0200		// 
#define global TVHT_TORIGHT				0x0400		// 
#define global TVHT_TOLEFT				0x0800		// 

// �ύX�̌��� ( Change )
#define global TVC_UNKNOWN				0x0000		// �Ȃɂ�
#define global TVC_BYMOUSE				0x0001		// �}�E�X����
#define global TVC_BYKEYBOARD			0x0002		// �L�[�{�[�h����

// ???
#define global TVNRET_DEFAULT				0		// 
#define global TVNRET_SKIPOLD				1		// 
#define global TVNRET_SKIPNEW				2		// 

#endif
