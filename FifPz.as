// FifPz - public header

#ifndef __FIFPZ_HEADER_AS__
#define __FIFPZ_HEADER_AS__

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
#enum global IDM_REPLACE
#enum global IDM_PLACE_ANS
#enum global IDM_SHARDS_NUMBER
#enum global IDM_SHARDS_NUMBER_END = IDM_SHARDS_NUMBER + MAX_SHARDS_NUMBER
#enum global IDM_MAX

#endif
