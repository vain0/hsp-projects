// LightFiler - UserMessage

#ifndef __LFILER_USERMESSAGE_AS__
#define __LFILER_USERMESSAGE_AS__

#enum global UWM_FIRST = 0x0500
#enum global UWM_OPENNEWVIEW = UWM_FIRST	// �V�����r���[���J��( iTab, sptr )
#enum global UWM_SETPATH					// �p�X�������ݒ� ( 0, sptr )
#enum global UWM_ACTVIEW_CHANGE				// �r���[���A�N�e�B�u�ɂ���( iTab, 0 )
##enum global UWM_
#enum global UWM_LAST

#const global UWM_COUNT ( UWM_LAST - UWM_FIRST )

#endif
