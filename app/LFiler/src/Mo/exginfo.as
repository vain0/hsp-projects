// exginfo - ���삵�Ă��Ȃ��E�B���h�E�̏��ł��擾�\

#ifndef __EXGINFO_AS__
#define __EXGINFO_AS__

#module exginfo_mod

#define global ctype exginfo(%1,%2=ginfo_sel) _exginfo(%1,%2)
#defcfunc _exginfo int p1, int p2
	act = ginfo_sel : gsel  p2
	ret = ginfo(p1) : gsel act
	return ret
	
#global
	
#if 0

	screen 0, 320, 240 : mes "ID 0"
	screen 1, 240, 160 : mes "ID 1"
	mes "scr ID 0 �̃T�C�Y ("+ exginfo(12, 0) +", "+ exginfo(13, 0) +")"
	stop
	
#endif

#endif
