// exstrf.hpi - public header

#ifndef IG_EXSTRF_HPI_AS
#define IG_EXSTRF_HPI_AS

#regcmd "_hsp3hpi_init@4", "exstrf.hpi"
#cmd exstrf 0x000

// �T���v���E�X�N���v�g
#if 1

// %v : �l
// %p : �ϐ��A�h���X
// %c : ����
	
	x = 1 + 2
	mes exstrf( "%v + %v = %v", 1, 2, x )
	mes exstrf( "%v��%v�Ȃ��%v��%v���I", "������", "�A��", "exstrf", "�y��" )
	mes exstrf( "%c%c%c%c%c, world%c", 'H', 'e', 'l', 'l', 'o', '!' )
	mes exstrf( "&x = %p = %v", x, varptr(x) )
	mes
	
	// ���ߌ`���Ŏg��
	
	exstrf "%v + %v = %v", 1, 2, 1 + 2
	mes refstr
	exstrf "%v��%v�Ȃ��%v��%v���I", "������", "�A��", "exstrf", "�y��"
	mes refstr
	
	stop
	
#endif

#endif
