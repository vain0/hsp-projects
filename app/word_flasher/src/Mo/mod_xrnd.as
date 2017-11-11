// ���񗐐� ( �r���I ������ )

#ifndef IG_MODULE_EXCLUSIVE_RAND_AS
#define IG_MODULE_EXCLUSIVE_RAND_AS

#module mod_xrnd

#deffunc swap@mod_xrnd var lhs, var rhs,  local tmp
	tmp = lhs
	lhs = rhs
	rhs = tmp
	return
	
//------------------------------------------------
// ���񗐐��𓾂�
// 
// @ ���񗐐� := �����l�̌�������1�������Ȃ��A
// @	����������ׂȐ���B���� (by kz3����)�B
// @ [0, cntPtn) �̐������A�C�ӂ̏����ɕ��ׂ�B
// @alg: �����o���@
//------------------------------------------------
#deffunc xrnd array rndtbl, int cntPtn
	dim rndtbl, cntPtn
	repeat cntPtn
		rndtbl(cnt) = cnt
	loop
	
	prnd   = cntPtn
	repcnt = 0
	
	// ������
	repeat
		n = rnd(prnd)
		prnd --
		if ( prnd == 0 ) {
			prnd = cntPtn
			break
		}
		
		if ( n != prnd ) {
			swap rndtbl(n), rndtbl(prnd)
		}
	loop
	
	return
	
#global

	randomize
	
#endif
