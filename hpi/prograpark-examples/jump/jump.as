// jump - public header

#ifndef __JUMP_HPI_AS__
#define __JUMP_HPI_AS__

#regcmd "_hsp3hpi_init@4", "jump.hpi"
#cmd jump 0x000

// �T���v���E�X�N���v�g
#if 1

	mes "�T���v���J�n"
	
	lb_a = *a
	lb_b = *b
	
	jump *a
	jump *a, res
	mes      res   +"    "+ refstr
	mes jump(lb_a) +"    "+ refstr
	mes jump(lb_b)
	mes "�� �� "+ jump(lb_b)
	
	mes "�T���v���I��"
	stop
	
*a
	mes "*a"
	return "str : *a's result string."
	
*b
	mes "*b"
	return 3.141592		// �������n�j
	
#endif

#endif


