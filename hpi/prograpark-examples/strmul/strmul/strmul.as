// strmul - public header

#ifndef __STRMUL_HPI_AS__
#define __STRMUL_HPI_AS__

#regcmd "_hsp3hpi_init@4", "strmul.hpi"
#cmd strmul 0x000

// �T���v���E�X�N���v�g
#if 1
	x = "strmul.hpi's sample!\n"
	
	mes strmul("STRING : ", 5)
	mes strmul(x, 2)
	
	// ���ߌ`��( refstr �Ɋi�[ )
	strmul x, 4
	mes refstr
	stop
	
#endif

#endif
