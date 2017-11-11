// userdef

#ifndef        __UserDefHeader__
#define global __UserDefHeader__

#ifdef _DEBUG
	mref myint, 64	// stat
	mref mystr, 65	// refstr
#endif
	// �}�N��
	#define global elsif else : if
	#define global TwoSet(%1,%2=0,%3,%4) %1(%2,0) = %3 : %1(%2,1) = %4// %1(%2, 0) �� %1(%2, 1) �� %3,%4 ��������
	#define global IntSwap(%1,%2) if((%1)!=(%2)){%1 ^= %2 : %2 ^= %1 : %1 ^= %2}//int�^�� %1 �� %2 ����������
;	#define global PMSwap(%1,%2) if(%1!=%2){%1 += %2 : %2 = %1 - %2 : %1 -= %2}// �����Z�Ō�������
	#define global exdel(%1) exist(%1) : if ( strsize >= 0 ) { delete (%1) }
	#define global color32(%1=0) color GETBYTE(%1), GETBYTE((%1) >> 8), GETBYTE((%1) >> 16)
	#define global dupmv(%1,%2) dupptr %1, varptr(%2), 16 * length(%2), vartype("struct")
	#define global delmodall(%1) foreach %1 : delmod %1(cnt) : loop
	#define global ctype numrg(%1,%2=0,%3=MAX_INT) (((%2) <= (%1)) && ((%1) <= (%3)))// %1 �� %2 �` %3 ���ǂ���
	#define global Lim !!"Lim()�͔p�~���ꂽ�Bnumrg()�Ɉڍs����B"!!
	#define global ctype boxin(%1=0,%2=0,%3=640,%4=480,%5=mousex,%6=mousey) ( (((%1) <= (%5)) && ((%5) <= (%3))) && (((%2) <= (%6)) && ((%6) <= (%4))) )
	#define global ctype IsInRect(%1=RECT,%2=mousex,%3=mousey) ( boxin((%1(0)), (%1(1)), (%1(2)), (%1(3)), (%2), (%3)) )
;	#define global ctype which(%1,%2,%3) if(%1){%2}else{%3}
	#define global ctype cwhich_int(%1,%2,%3) ( ((%2) * ((%1) != 0)) | ((%3) * ((%1) == false)) )
	#define global ctype RectTo4prm(%1) %1(0), %1(1), %1(2), %1(3)
	
	#define global ctype MAXVAL(%1,%2) ((%1) * ((%1) > (%2)) | (%2) * (((%1) > (%2)) == false))
	#define global ctype MINVAL(%1,%2) ((%1) * ((%1) < (%2)) | (%2) * (((%1) < (%2)) == false))
	
	#define global mousex2 ( ginfo(0) - (ginfo(4) + (ginfo(10) - ginfo(12)) / 2) )
	#define global mousey2 ( ginfo(1) - (ginfo(5) + (ginfo(11) - ginfo(13)) - (ginfo(10) - ginfo(12)) / 2) )
	
;	#define global ctype AppendFlag(%1=flags,%2=0) ((%1(%2 / 32) & (1 << (%2 \ 32))) != 0)// ���蓖�Ď��Ɏg�p
;	#define global FlagSw(%1=flags,%2=0,%3=true) if(%3){ %1((%2) /32) |= 1 << ((%2) \ 32) } else { %1((%2)/32) = BitOff(%1((%2) / 32), 1 << ((%2) \ 32)) }myint@=(%3):
;	#define global ctype ff(%1=flags,%2=0) ((%1((%2) / 32) & (1 << ((%2) \ 32))) != 0)// �y�[�W���t���O������
;	#define global ctype flag_on(%1,%2=0) (((%1) & (1 << (%2))) != 0)// 32bit �̃t���O���݂�
;	#define global SetFlag(%1,%2=flags,%3=0) #define global %1 AppendFlag(%2,%3)// �g�p�s��
	
	#define global ctype SUM_OF(%1=0,%2=MAX_INT) (((%1) + (%2)) * ((%2) - (%1) + 1) / 2 )
	
	// API �ȗ��n
	#define global SetStyle(%1,%2=-16,%3=0,%4=0) SetWindowLong (%1),(%2),BITOFF(GetWindowLong((%1),(%2)) | (%3), (%4))
	#define global ChangeVisible(%1=hwnd,%2=1) SetStyle (%1), -16, 0x10000000 * (%2), 0x10000000 * ((%2) == 0)// Visible �؂�ւ�
	
	// ���l����}�N��
	#define global ctype Radian(%1) ((M_PI * (%1)) / 180)
	#define global ctype BoolEqual(%1,%2) ( ((%1) != 0) == ((%2) != 0) )
		// 32Bit �n
	#define global ctype MAKELONG(%1,%2) (LOWORD(%1) | (LOWORD(%2) << 16))
	#define global ctype MAKELONG2(%1=0,%2=0,%3=0,%4=0) MAKELONG(MAKEWORD((%1),(%2)),MAKEWORD((%3),(%4)))
	#define global ctype HIWORD(%1) (((%1) >> 16) & 0xFFFF)
	#define global ctype LOWORD(%1) ((%1) & 0xFFFF)
	#define global GetHigh !!"GetHigh() �͔p�~���ꂽ�BHIWORD �ֈڍs����B"!!
	#define global GetLow  !!"GetLow()  �͔p�~���ꂽ�BLOWORD �ֈڍs����B"!!
	#define global ctype BITOFF(%1,%2=0) ((%1) & bturn(%2))
	#define global ctype RGB(%1,%2,%3) (GETBYTE(%1) | GETBYTE(%2) << 8 | GETBYTE(%3) << 16)
	#define global ctype BITNUM(%1) (1 << (%1))
	#define global ctype bturn(%1) ((%1) ^ 0xFFFFFFFF)
	#define global ctype to32b_from16b(%1) cwhich_int( (%1) & 0x8000, 0 - ((%1) ^ 0xFFFF) - 1, (%1) )
;	#define global ctype complementOf2(%1) (bturn(%1) + 1)		// 2 �̕␔
		// 16Bit �n
	#define global ctype MAKEWORD(%1,%2) (GETBYTE(%1) | GETBYTE(%2) << 8)
	#define global ctype HIBYTE(%1) LOBYTE((%1) >> 8)
	#define global ctype LOBYTE(%1) GETBYTE(%1)
	#define global ctype GetAByte(%1,%2=0) (( (%1) >> ((%2) * 8) ) & 0x00FF)
	#define global ctype GetABit(%1,%2=0) (((%1) >> (%2)) & 1)
	
	#define global ctype GETBYTE(%1) (%1 & 0xFF)
	
	// ���̏C��
	#define global delfile delete
	
	// �@�\�C��
	#undef  gradf
	#define global gradf(%1=0,%2=0,%3,%4,%5=0,%6,%7) gradf@hsp %1, %2, (%3) - (%1), (%4) - (%2), %5, %6, %7
	
	// �f�o�b�O�p
	#ifdef  _DEBUG
	 #define global DbgBox(%1) dialog (%1), 2, "DbgBox Line\t= "+ __LINE__+"\nFILE\t = "+ __FILE__ : if ( stat == 7 ) { dialog "��~���܂���" : assert 0 }
	 #define global ctype logv(%1) ({"%1 = "}+ (%1))
	 #define global ctype logpair(%1,%2) ({"(%1, %2) = ("}+ (%1) +", "+ (%2) +")")
	 #define global ctype loghex(%1) strf({"%1 = 0x%%08X"}, (%1))
	 #define global ctype logchar(%1) strf({"%1 = '%%c'"}, (%1))
	#else
	 #define global DbgBox(%1) :
	 #define global ctype logv(%1) ""
	 #define global ctype logpair(%1,%2) ""
	 #define global ctype loghex(%1) ""
	 #define global ctype logchar(%1) ""
	#endif
	
	#define global dbgstr  logv
	#define global dbgpair logpair
	#define global dbghex  loghex
	#define global dbgchar logchar
	
	// �u������������
	
	// �萔
	#define global NULL     0	// �������� 0 �ł͂Ȃ����A�֋X��0�Ƃ���
	#ifndef __clhsp__
	 #define global true    1	// ��0
	 #define global false   0	//   0
	 #define global success 1	// true
	 #define global failure 0	// false
	#endif
	
	#define global MAX_INT  0x7FFFFFFF	//  2147483647
	#define global MIN_INT  0x80000000	// -2147483648
	#define global MAX_PATH 260
	
	#define global INFINITY (logf@hsp(0))
	
	// ����W�J�}�N�� ----------------------------------------------------------
	//---- def �` plus ���[�v --------------------
	//---- �v���[�����[�v (����q�\���ɏo���Ȃ�)--
;	#define global lpcnt PlainLoop_counter@userdef
;	#define global Start_loop(%1=0,%2=0) %tPlainLoop lpcnt = %2 : %i0 *%i %i0 : exgoto lpcnt, 1, %1, *%p2 : if ( true )
;	#define global More_loop(%1="") %tPlainLoop if ( true ) { if ( "" == (%1) ) { lpcnt ++ } else { lpcnt = %1 } goto *%p1 }
;	#define global Exit_loop(%1=1)  %tPlainLoop if ( %1 ) { lpcnt = -1 } goto *%p2
;	#define global Back_loop        %tPlainLoop lpcnt ++ : *%o : goto *%o : *%o
;	#define global Back_loop_Minus  %tPlainLoop lpcnt -- : *%o : goto *%o : *%o// Back_Loop �̌��Z��
	//---- NoteLoop (����q�s��) -----------------
;	#define global note  %tNoteLoop _note_noteloop@userdef
;	#define global noteIndex _noteIndex_noteloop@userdef
;	#define global ntcnt _ntcnt_noteloop@userdef
;	#define global ntlen _ntlen_noteloop@userdef
;	#define global ntRepeat(%1="strvar",%2=0,%3=ntcnt,%4=1,%5=0,%6=0)%tbreak%i0 %tcontinue%i0 %tNoteLoop noteIndex=%5:%3=%2:ntlen=strlen@hsp(%1):%s3%s4 %i0 *%i:getstr@hsp note,%1,noteIndex,%6:noteIndex+=strsize
;	#define global ntLoop %tcontinue *%o:%tNoteLoop %p3+=%p2 : if(noteIndex < ntlen){goto@hsp *%o} %o0%o0:if(0){%tbreak *%o : %tNoteLoop %p=(%p^0xFFFFFFFF)+1} %o0
	//---- �^���u�� ------------------------------
	#define global false_module %tFalseModule goto *%i
	#define global false_global %tFalseModule *%o
	//--------------------------------------------
	
	// �W���N���[���A�b�v����
	#ifdef _DEBUG
	#module  _userdef_cleanup
	#deffunc _userdef_cleanup_sttm onexit
		exdel "obj"
		exdel "hsptmp"
		return
	#global
	#endif
	
#endif /* <- #ifndef __UserDefHeader__ */
