// �uHSP �g���}�N�����g�p����v�� ON �Ȃ�

#ifdef __hspdef__

#ifndef        __UserDefHeader__
#define global __UserDefHeader__

#ifdef _DEBUG
	// ���蓖�Ă�
	mref myint, 64	// stat
	mref mystr, 65	// refstr
#endif
	
	// �}�N��
	#define global elsif else : if
	#define global TwoSet(%1,%2=0,%3,%4) %1(%2,0) = %3 : %1(%2,1) = %4// %1(%2, 0) �� %1(%2, 1) �� %3,%4 ��������
	#define global IntSwap(%1,%2) if((%1)!=(%2)){%1 ^= %2 : %2 ^= %1 : %1 ^= %2}//int�^�� %1 �� %2 ����������
;	#define global PMSwap(%1,%2) if(%1!=%2){%1 += %2 : %2 = %1 - %2 : %1 -= %2}// �����Z�Ō�������
	#define global exdel(%1) exist(%1):if(strsize >= 0){delete(%1)}
	#define global color32(%1=0) color GETBYTE(%1),GETBYTE((%1) >> 8),GETBYTE((%1) >> 16)
	#define global dupmv(%1,%2) dupptr %1, varptr(%2), 16 * length(%2), vartype("struct")
	#define global delmodall(%1) foreach %1 : delmod %1(cnt) : loop
	#define global ctype numrg(%1,%2=0,%3=MAX_INT) (((%2) <= (%1)) && ((%1) <= (%3)))// %1 �� %2 �` %3 ���ǂ���
	#define global Lim ??"Lim �͔p�~����܂����Bnumrg �ɕύX���Ă�������"??
	#define global ctype boxin(%1=0,%2=0,%3=640,%4=480,%5=mousex,%6=mousey) ( (((%1) <= (%5)) && ((%5) <= (%3))) && (((%2) <= (%6)) && ((%6) <= (%4))) )
	#define global ctype IsInRect(%1=RECT,%2=mousex,%3=mousey) ( boxin((%1(0)), (%1(1)), (%1(2)), (%1(3)), (%2), (%3)) )
	#define global ctype which(%1,%2,%3) if(%1){%2}else{%3}
	#define global ctype cwhich_int(%1,%2,%3) ( ((%2) * ((%1) != 0)) | ((%3) * ((%1) == false)) )
	#define global ctype RectTo4prm(%1) %1(0), %1(1), %1(2), %1(3)
	
	#define global ctype MAXVAL(%1,%2) ((%1) * ((%1) > (%2)) | (%2) * (((%1) > (%2)) == false))
	#define global ctype MINVAL(%1,%2) ((%1) * ((%1) < (%2)) | (%2) * (((%1) < (%2)) == false))
	
	#define global mousex2 (ginfo(0)-(ginfo(4)+(ginfo(10)-ginfo(12))/2))
	#define global mousey2 (ginfo(1)-(ginfo(5)+(ginfo(11)-ginfo(13))-(ginfo(10)-ginfo(12))/2))
	
	#define global ctype AppendFlag(%1=flags,%2=0) ((%1(%2 / 32) & (1 << (%2 \ 32))) != 0)// ���蓖�Ď��Ɏg�p
	#define global FlagSw(%1=flags,%2=0,%3=true) if(%3){ %1((%2) /32) |= 1 << ((%2) \ 32) } else { %1((%2)/32) = BitOff(%1((%2) / 32), 1 << ((%2) \ 32)) }myint@=(%3):
	#define global ctype ff(%1=flags,%2=0) ((%1((%2) / 32) & (1 << ((%2) \ 32))) != 0)// �y�[�W���t���O������
	#define global ctype flag_on(%1,%2=0) (((%1) & (1 << (%2))) != 0)// 32bit �̃t���O���݂�
;	#define global SetFlag(%1,%2=flags,%3=0) #define global %1 AppendFlag(%2,%3)// �g�p�s��
	
	// API �ȗ��n
	#define global SetStyle(%1,%2=-16,%3=0,%4=0) SetWindowLong (%1),(%2),BitOff(GetWindowLong((%1),(%2)) | (%3), (%4))
	#define global ChangeVisible(%1=hwnd,%2=1) SetStyle %1, -16, 0x10000000 * (%2), 0x10000000 * ((%2) == 0)// Visible �؂�ւ�
	
	// ���l����}�N��
	#define global ctype Radian(%1) ((3.14159 * (%1)) / 180)
	#define global ctype BoolEqual(%1,%2) ( ((%1)!=0) == ((%2)!=0) )
		// 32Bit �n
	#define global ctype MAKELONG(%1,%2) (LOWORD(%1) | (LOWORD(%2) << 16))
	#define global ctype MAKELONG2(%1=0,%2=0,%3=0,%4=0) MAKELONG(MAKEWORD((%1),(%2)),MAKEWORD((%3),(%4)))
	#define global ctype HIWORD(%1) (((%1) >> 16) & 0xFFFF)
	#define global ctype LOWORD(%1) ((%1) & 0xFFFF)
	#define global GetHigh HIWORD
	#define global GetLow  LOWORD
;	#define global ctype BITOFF(%1,%2=0) ( (%1) & (%2) ^ (%1) )//	: (%1) ��2��]������
;	#define global ctype BITOFF(%1,%2=0) ( (%1) | (%2) ^ (%2) )//	: (%2) ��2��]������
	#define global ctype BITOFF(%1,%2=0) ( bturn(%2) & (%1) )//		: �ő�
	#define global ctype RGB(%1,%2,%3) (GETBYTE(%1) | GETBYTE(%2) << 8 | GETBYTE(%3) << 16)
	#define global ctype BITNUM(%1) (1 << (%1))
	#define global ctype bturn(%1) ((%1) ^ 0xFFFFFFFF)
		// 16Bit �n
	#define global ctype MAKEWORD(%1,%2) (GETBYTE(%1) | GETBYTE(%2) << 8)
	#define global ctype GetAByte(%1,%2=0) (( (%1) >> ((%2) * 8) ) & 0x00FF)
	#define global ctype GetABit(%1,%2=0) (((%1) >> (%2)) & 1)
	
	#define global ctype GETBYTE(%1) (%1 & 0xFF)
	
	// �����񑀍�}�N��
;	#define global StrDel(%1,%2=offset,%3=size) memcpy %1,%1,strlen(%1)-((%2)+(%3)),(%2),(%2)+(%3) : memset %1,0,%3,strlen(%1)-(%3)
;	#define global StrInsert(%1=strvar,%2="",%3=offset) _StrInsert_len@userdef = strlen(%2):\
;		sdim _StrInsert_temp@userdef, _StrInsert_len@userdef +2 : _StrInsert_temp@userdef = %2 :\
;		memexpand %1, strlen(%1) + (%3) + _StrInsert_len@userdef + 2 :\
;		memcpy %1,%1, strlen(%1) - (%3), (%3) + _StrInsert_len@userdef, %3 :\
;		memcpy %1, _StrInsert_temp@userdef, _StrInsert_len@userdef, %3, 0
	
	// �ʃ}�N��
	#define global _time strf("%%02d", gettime(5)) +" : "+ strf("%%02d", gettime(6)) +" : "+ strf("%%03d", gettime(7))
	
	// �f�o�b�O�p
	#ifdef  _DEBUG
	#define global DbgBox(%1) dialog %1,2,"DbgBox Line="+ __LINE__+" : FILE="+ __FILE__ : if (stat==7){dialog "��~���܂���":assert 0}
	#define global logmes2(%1,%2) logmes "(%1, %2) = ("+ (%1) +", "+ (%2) +")"
	#define global ctype logv(%1) ("%1 = "+ (%1))
	#define global ctype logp(%1,%2) ("("+ (%1) +", "+ (%2) +")")
	#else
	#define global DbgBox(%1) :
	#define global logmes2(%1,%2) :
	#define global ctype logv(%1) ""
	#define global ctype logp(%1,%2) ""
	#endif
	
	// �u������������
	
	// �萔
	#define global NULL   0	// �������� 0 �ł͂Ȃ����A�֋X��0�Ƃ���
	#define global true   1	// ��0
	#define global false  0	//   0
	
	#define global MAX_INT  0x7FFFFFFF	//  2147483647
	#define global MIN_INT  0x80000000	// -2147483648
	#define global MAX_PATH 260
	
	// ����W�J�}�N�� ------------------------------------------------------------------------------
	//---- def �` plus ���[�v --------------------
	//---- �v���[�����[�v (����q�\���ɏo���Ȃ�)--
	#define global lpcnt PlainLoop_counter@userdef
	#define global Start_loop(%1=0,%2=0) %tPlainLoop lpcnt=%2:%i0 *%i %i0:exgoto lpcnt,1,%1,*%p2:if(1)
	#define global More_loop(%1="") %tPlainLoop if(1){if(""==(%1)){lpcnt++}else{lpcnt=%1}goto *%p1}
	#define global Exit_loop(%1=1) %tPlainLoop if(%1){lpcnt=-1}:goto *%p2
	#define global Back_loop %tPlainLoop lpcnt++:*%o:goto *%o:*%o
	#define global Back_loop_Minus %tPlainLoop lpcnt--:*%o:goto*%o:*%o// Back_Loop �̌��Z��
	//---- NoteRepeat ���[�v (����q�\���͕s��)---
	#define global note %tNoteLoop _note_noteloop@userdef
	#define global noteIndex _noteIndex_noteloop@userdef
	#define global ntcnt _ntcnt_noteloop@userdef
	#define global ntlen _ntlen_noteloop@userdef
	#define global NoteRepeat(%1="strvar",%2=0,%3=ntcnt,%4=1,%5=0,%6=0)%tbreak%i0 %tcontinue%i0 %tNoteLoop noteIndex=%5:%3=%2:ntlen=strlen@hsp(%1):%s3%s4 %i0 *%i:getstr@hsp note,%1,noteIndex,%6:noteIndex+=strsize
	#define global NoteLoop %tcontinue *%o:%tNoteLoop %p3+=%p2 : if(noteIndex < ntlen){goto@hsp *%o} %o0%o0:if(0){%tbreak *%o : %tNoteLoop %p=(%p^0xFFFFFFFF)+1} %o0
	//---- �O���Ɗu��(?) -------------------------
	#define global FalseModule %tFMod goto *%i
	#define global FalseGlobal %tFMod *%o
	//--------------------------------------------
	
	// �W���N���[���A�b�v����
	#ifdef _DEBUG	// �X�N���v�g����̎��s���̂�
	#module
	#deffunc __Normal_CleanUpState__X_ onexit
		exdel "obj"
		exdel "hsptmp"
		return
	#global
	#endif
	
#endif /* <- #ifndef __UserDefHeader__ */

#endif /* <- #ifdef __hspdef__ */
