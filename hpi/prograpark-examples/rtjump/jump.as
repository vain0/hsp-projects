// jump - import header

#ifndef IG_JUMP_HPI_AS
#define IG_JUMP_HPI_AS

#regcmd "_hsp3typeinit_jump@4", "jump.hpi"
#cmd jump 0x000

#if 1

	lb = *a
	jump *a		// ���x��
	jump lb		// ���x���^�ϐ�
	stop
	
*a
	mes "�W�����v�����I  (*a)"
	return
	
#endif

#endif
