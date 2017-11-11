// OwnerDraw Listbox Dll

#ifndef __ODLISTBOX_AS__
#define __ODLISTBOX_AS__

#uselib "ODListbox.dll"
#func   ODLbCreate  "ODLbCreate"  int,int,int,int,int
#func   ODLbDestroy "ODLbDestroy" int
#func   ODLbMove    "ODLbMove"    int,int,int,int,int
#func   ODLbProc    "ODLbProc"    int,int,int,int

#func  _ODLbInsertItem "ODLbInsertItem" int,wstr,int
#define ODLbInsertItem(%1,%2,%3=-1) _ODLbInsertItem %1,%2,%3
#func  _ODLbDeleteItem "ODLbDeleteItem" int,int
#define ODLbDeleteItem(%1,%2=-1) _ODLbDeleteItem %1,%2
#func   ODLbClearItem  "ODLbClearItem"  int
#func   ODLbMoveItem   "ODLbMoveItem"   int,int,int
#func   ODLbSwapItem   "ODLbSwapItem"   int,int,int

#func  _ODLbSetMarginColor "ODLbSetMarginColor" int,int,int
#define ODLbSetMarginColor(%1,%2=-1,%3) _ODLbSetMarginColor %1,%2,%3
#func  _ODLbSetItemColor   "ODLbSetItemColor"   int,int,int,int
#define ODLbSetItemColor(%1,%2=0,%3=0x000000,%4=0xFFFFFF) _ODLbSetItemColor %1,%2,%3,%4
#func   ODLbSetItemPadding "ODLbSetItemPadding" int,int,int,int,int
#func   ODLbSetItemMargin  "ODLbSetItemMargin"  int,int
#func   ODLbSetItemHeight  "ODLbSetItemHeight"  int,int
#func   ODLbSetItemIcon    "ODLbSetItemIcon"    int,int,int
#func   ODLbSetItemLParam  "ODLbSetItemLPARAM"  int,int,int

#func   ODLbUseIcon       "ODLbUseIcon"        int,int
#func   ODLbSetTextFormat "ODLbSetTextFormat"  int,int,int
#func   ODLbSetFont       "ODLbSetFont"        int,int

#func   ODLbSetItemNum      "ODLbSetItemNum"      int,int
#func  _ODLbSetItemNumColor "ODLbSetItemNumColor" int,int,int,int
#define ODLbSetItemNumColor(%1,%2=-1,%3=-1,%4=-1) _ODLbSetItemColor %1,%2,%3,%4
#func   ODLbSetItemNumWidth "ODLbSetItemNumWidth" int,int

#cfunc  ODLbGetHandle       "ODLbGetHandle"       int
#cfunc  ODLbGetLParam       "ODLbGetLPARAM"       int,int

#cfunc  ODLbGetItemHeight   "ODLbGetItemHeight"   int
#cfunc  ODLbGetPadding      "ODLbGetPadding"      int,int
#cfunc  ODLbGetMargin       "ODLbGetMargin"       int
#cfunc  ODLbGetItemNumWidth "ODLbGetItemNumWidth" int
#cfunc  ODLbIsUseIcon       "ODLbIsUseIcon"       int
#cfunc  ODLbGetItemColor    "ODLbGetItemColor"    int,int,int

// �E�B���h�E�N���X
#define WC_ODLISTBOX "LISTBOX"

// ODListbox ��p�ʒm�R�[�h
#enum ODLBN_FIRST        = 0x0100
#enum ODLBN_CREATE       = ODLBN_FIRST	// ��������钼�O
#enum ODLBN_ITEMINSERTED				// �}�����ꂽ
#enum ODLBN_ITEMDELETED					// �폜���ꂽ
#enum ODLBN_ITEMMOVED					// �ړ����ꂽ
#enum ODLBN_ITEMSWAPPED					// �������ꂽ
#enum ODLBN_ITEMREDRAWN					// �ĕ`�悳�ꂽ
#enum ODLBN_LAST

// �֌W���肻���ł܂������Ȃ��萔
#const SELMARKWIDTH 5	// �I�����ڂɕt����̕�
#const ICON_SIZE    16	// �\���ł���A�C�R���̃T�C�Y

#endif
