// FifPz - public header

#ifndef __FIFPZ_HEADER_AS__
#define __FIFPZ_HEADER_AS__

#uselib "user32.dll"
#func   PostMessage      "PostMessageA" int,int,int,sptr
#func   GetKeyboardState "GetKeyboardState" int

#uselib "shell32.dll"
#func   DragAcceptFiles "DragAcceptFiles" int,int
#func   DragQueryFile   "DragQueryFileA"  int,int,int,int
#func   DragQueryPoint  "DragQueryPoint"  int,int
#func   DragFinish      "DragFinish"      int

#define WM_DROPFILES 0x0233

//##############################################################################
//        �萔�E�}�N��
//##############################################################################

#const global MAX_SHARDS_NUMBER 7

// ID of Window
#enum global IDW_MAIN = 0			// ���C�����
#enum global IDW_PUZZLE				// �p�Y�����
#enum global IDW_PICFULL			// �摜�S��
#enum global IDW_PICSHARD_ENABLE	// �����Ȓf��
#enum global IDW_PICSHARD_TOP		// �摜�f��

// XY
#const global x 0
#const global y 1

// ����
#enum global DIR_UPPER = 0	// ��
#enum global DIR_RIGHT		// �E
#enum global DIR_LOWER		// ��
#enum global DIR_LEFT		// ��
#enum global DIR_MAX

// ID of MenuItem
#enum global IDM_NONE = 0
#enum global IDM_OPEN
#enum global IDM_CLOSE
#enum global IDM_QUIT
#enum global IDM_SHUFFLE
#enum global IDM_PLACE_ANS
#enum global IDM_CHGCLR_DISSHARD
#enum global IDM_SHARDS_NUMBER
#enum global IDM_SHARDS_NUMBER_END = IDM_SHARDS_NUMBER + MAX_SHARDS_NUMBER
#enum global IDM_MAX

//##############################################################################
//        userdef�݊�
//##############################################################################
#ifndef __UserDefHeader__
 #define global color32(%1=0) color GETBYTE(%1),GETBYTE((%1) >> 8),GETBYTE((%1) >> 16)
 #define global ctype numrg(%1,%2=0,%3=MAX_INT) (((%2) <= (%1)) && ((%1) <= (%3)))
 #define global ctype MAKELONG(%1,%2) (LOWORD(%1) | (LOWORD(%2) << 16))
 #define global ctype HIWORD(%1) (((%1) >> 16) & 0xFFFF)
 #define global ctype LOWORD(%1) ((%1) & 0xFFFF)
 #define global ctype BITOFF(%1,%2=0) ( bturn(%2) & (%1) )//		: �ő�
 #define global ctype RGB(%1,%2,%3) (GETBYTE(%1) | GETBYTE(%2) << 8 | GETBYTE(%3) << 16)
 #define global ctype BITNUM(%1) (1 << (%1))
 #define global ctype bturn(%1) ((%1) ^ 0xFFFFFFFF)
 #define global ctype GETBYTE(%1) (%1 & 0xFF)
 #define global NULL   0
 #define global true   1
 #define global false  0
 #define global MAX_PATH 260
#endif

#endif
