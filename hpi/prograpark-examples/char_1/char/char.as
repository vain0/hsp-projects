// char - public header

#ifndef __CHAR_HPI_AS__
#define __CHAR_HPI_AS__

#regcmd "_hsp3hpi_init@4", "char.hpi", 1
#cmd char 0x000

// �T���v���E�X�N���v�g
#if 0

;	char c(14)		// char c[14];
	char c, 14		// dim �I�p�@
	
	c = char('x')	// 'x' �� int �^�Ȃ̂ŁA�ϊ����đ������
	mes c			// char('1')->str("1") �Ɏ����ϊ�
	
	c(0) = char( 72), char(101), char(108), char(108), char(111), char(44), char(32), char(119)
	c(8) = char(111), char(114), char(108), char(100), char(33)
	sdim s
	foreach c
		s += c(cnt)	// char -> str �ɕϊ����Ă��� s �ɘA��
	loop
	mes s
	
	stop
	
#endif

#endif
