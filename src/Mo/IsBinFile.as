#ifndef __IS_BIN_FILE_FUNCTION__
#define __IS_BIN_FILE_FUNCTION__

#module

#enum FT_UNKNOWN = -1
#enum FT_BINARY  = 0
#enum FT_TEXT

//------------------------------------------------
// �t�@�C�����o�C�i���`�������ׂ� 
//------------------------------------------------
#defcfunc IsBinFile str Path
	exist Path
	if ( strsize <= 0 ) { return -1 }		// ������Ȃ�
	
	sdim  buf, strsize + 2
	bload Path, buf, strsize			// �ǂݍ���
	bool = FT_TEXT						// �^�ɃZ�b�g
	
	// ���ׂ� NULL ����Ȃ���� OK
	repeat strsize
		if ( peek( buf, cnt ) == 0 ) {			// NULL ����
			
			// ����ȍ~�����ׂ�
			for i, cnt + 1, strsize
				if ( peek( buf, i ) != 0 ) {	// �܂��L���Ȓl���c���Ă����
					bool = FT_BINARY			// �o�C�i���t�@�C�����ƌ�����
					break
				}
			next
			
			break
		}
	loop
	
	sdim buf, 0
	
	return bool		// Binary = 0 : Text = 1 : Unknown = -1
#global

#endif
