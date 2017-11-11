// Clrtxt ���W���[��

#ifndef __CLRTXT_OPTIMIZE_AS__
#define __CLRTXT_OPTIMIZE_AS__

#include "Mo/ini.as"

#module ClrtxtOptimize_mod

//---- �}�N�����` ------------------------------
// �����񑀍�}�N��
#define StrDel(%1,%2=offset,%3=size) memcpy %1,%1,strlen(%1)-((%2)+(%3)),(%2),(%2)+(%3) : memset %1,0,%3,strlen(%1)-(%3)
#define StrInsert(%1=strvar,%2="",%3=offset) _StrInsert_len = strlen(%2):\
	sdim _StrInsert_temp, _StrInsert_len +2 : _StrInsert_temp = %2 :\
	memexpand %1, strlen(%1) + (%3) + _StrInsert_len + 2 :\
	memcpy %1,%1, strlen(%1) - (%3), (%3) + _StrInsert_len, %3 :\
	memcpy %1, _StrInsert_temp, _StrInsert_len, %3, 0
	
#define PrmLast getstr mystr, tmp, 8, 0, 17

#define ctype LibName(%1=1) ""+ ClrtxtLib +"ClrtxtLib"+ str(%1) +".ini"
#define InputStr(%1) poke Clrtxt, WriteSize, (%1)+"\n" : WriteSize += strsize
#define InputLine    poke Clrtxt, WriteSize, tmp +"\n" : WriteSize += strsize
//-----
#define Input10Num(%1) \
	getstr tmp(1), tmp, 8, 0, 32			/* �ǂݍ��� */:\
	if (peek(tmp(1), 0) == '-') {			/* �擪�� - �Ȃ� */:\
		InputStr "@("+ %1 +")-1"			/* ����(�S����) */:\
	} else {\
		num = strsize, 0					/* �ǂݍ��񂾃T�C�Y */:\
		repeat num							/* 2�i����10�i���ɕϊ� */:\
			num(1) += (peek(tmp(1), num-(cnt+1))=='1') * (1 << cnt):\
		loop : InputStr "@("+ %1 +")"+ num(1)		/* 10�i���œ��� */\
	}
//-----
#define LoadSomePrms(%1,%2=11) sdim prm, 64, 2 :\
	num = 8, 0, 0									/* ������ */:\
	repeat											/**/:\
		memset prm, 0, 11							/* �m�� */:\
		getstr prm, tmp, num, ',', 64				/* �萔�ǂݏo�� */:\
		if ( prm == "" ) { break }					/* �󕶎���Ȃ�I�� */:\
		num += strsize								/* �C���f�b�N�X���� */:\
		GetINI %1, prm, prm(1), %2, "0", LibName(1)	/* prm(1) �ɓǂݍ��� */:\
		num(1) |= int(prm.1)						/* �ǉ� */:\
	loop : InputStr "@(C"+ %1 +")"+ num(1)			/* */:\
//-----
#define NEXTX_Start /* Renzoku �J�n���̏��� */:\
	if ( Renzoku <= 0 ) {					/* ���߂̌�Ȃ� */:\
		InputStr "@(NEXTX)0000000000"		/* 10 ���m�� */:\
		RenzokuStart = WriteSize - 20		/* �L�����Ă��� */:\
	}

#define NX_MIN 4		// NEXTX �𖄂ߍ��ލŏ��̐�
//------------------------------------------------

//####### Clrtxt �̈ʒu��m�点��
#deffunc ClrtxtLibIs var LibVar
	dup  ClrtxtLib,      LibVar
	return
	
//######## Clrtxt ���œK������ #####################################################################
#deffunc ClrtxtOptimize str p1, var _buf, local index, local WriteSize, local Renzoku, local len, local dir
	mref mystr, 65
	dim num, 3
	sdim dir, MAX_PATH
	if ( getpath(p1, 32) == "" ) {		// ���΃p�X
		dir = ""+ ClrtxtLib +""+ p1		// ���C�u�����̃p�X������
	} else {							// ��΃p�X
		dir = p1						// ���̂܂�
	}
	
	// �t�@�C������ǂݍ���
	exist ""+ dir								// �T�C�Y�𒲂ׂ�
	if (strsize == -1) { return -1 }			// �����Ȃ�I���
	
	sdim Clrtxt, strsize + MAX_PATH + 5			// �m��
	bload dir, Clrtxt, strsize					// �ǂݍ���
	len = strsize								// �����擾
	if (strmid(Clrtxt, 0, 8) != "@(CLRTS)") {	// clrtxt �̋L��(CoLoR Text Start)
		return -1								// �ʃA�v���Ǝv���� (�قڂ��蓾�Ȃ�����)
	}
	sdim tmp, 64
		 tmp = "@(RESET)"
	memcpy    Clrtxt, tmp, 8, 0, 0				// @(RESET) �ŏ㏑�� ( @(CLRTS) ���폜 )
	StrInsert Clrtxt, dir, 8					// �p�X����������
	len += strlen(dir)							// �p�X���T�C�Y���L�т�
	
	// �œK���������s��
	dim    num, 3
	sdim   tmp, 64, 3				// tmp = 1 line (1 & 2) = any
	sdim   buf, strlen(Clrtxt) +1	// �ړ]�p�Ɋm��
	memcpy buf, Clrtxt,  len		// �R�s�[
	memset Clrtxt, NULL, len		// ����
	
//---- @(INPUT) ��W�J���� -----------------------
	sdim filebuf
	index = 0
	while
		num = instr(buf, index, "@(INPUT)")
		if ( num < 0 ) { _break }
		
		index += num
		
		// @ �̑O�����s���ǂ���
		if ( index > 2 ) {
			if ( peek(buf, index - 1) != 0x0D && peek(buf, index - 1) != 0x0A ) {
				index += 8
				_continue
			}
		}
		
		getstr tmp, buf, index + 8			// �t�@�C���p�X���擾����
		
		if ( getpath(tmp, 32) == "" ) {
			tmp = ClrtxtLib +"\\"+ tmp		// ��΃p�X�ɂ���
		}
		
		exist tmp
		if ( strsize < 0 ) { index += 8 : _continue }	// �Ȃ���Ζ���
		
		notesel  filebuf
		noteload tmp		// ���[�h
		noteunsel
		
		// @(INPUT)... ���폜
		StrDel    buf, index, 8 + strlen(tmp)
		
		// �t�@�C���̕��͂�}��
		StrInsert buf, filebuf, index
		
		index += strlen(filebuf)
		
	wend
	
	sdim filebuf
	
//---- Clrtxt �ɏ������� -------------------------
	dim  num, 3
	sdim tmp, 64, 3				// tmp = 1 line (1 & 2) = any
	sdim prm, 64, 2				// �p�����[�^�p
	fCom  = false				// �����s�R�����g
	index = 0
	len   = strlen(buf)
	memexpand Clrtxt, len + 256
	
	do
		getstr tmp, buf, index		// ��s�擾
		index += strsize
		
		if ( fCom ) {
			// �����s�R�����g���[�h( @*/ �ŏI�� )
			if ( peek(tmp, 0) == '@' && wpeek(tmp, 1) == 0x2F2A ) {
				fCom = false
			}
			_continue
		}
		
		// ���߂��H
		if ( peek(tmp, 0) == '@' ) {			// ���߂Ȃ�
			switch ( strmid(tmp, 2, 5) )		// ���ߕ������擾
			// Entry
			case "ENTRY"
				NEXTX_Start							// NEXTX ���ߍ��ݗp����
				num = 8								// �J�n�ʒu( ���߂̎� )
				repeat
					getstr tmp(1), tmp, num, ','		// CSV
					num += strsize						//
					if ( peek(tmp(1)) == 0 ) { break }	// �󕶎����擾����
					InputStr  tmp(1)					// �������œW�J
					Renzoku ++
				loop
				_continue : swbreak
			case "COLOR"
				PrmLast
				GetIni "Color", refstr, tmp(1), 12, "", LibName(2)	// ClrtxtLib2 ���g��
				InputStr "@(CCREF)"+ tmp(1)							// CCREF ���߂ɒu�����Ă���
				swbreak
			// nColorRef
			case "CCREF"
				getstr   tmp(1), tmp, 8, , 20					// 20byte �܂�
				if( peek(tmp(1)) == '$') {							// �擪�� $ �Ȃ� $BBGGRR
					InputStr "@(CCREF)"+ int(tmp(1))				// 16�i�� -> 10�i��
				} else {
					InputStr tmp									// ���̂܂ܓ���
				}
				swbreak
			// nPermission
			case "KYOKA" : Input10Num "KYOKA"		: swbreak	// nPermission
			case "LEVEL" : InputLine				: swbreak	// nLevel
			case "CFLAG" : LoadSomePrms "FLAG", 12	: swbreak	// nFlag
			case "CIDPD" : LoadSomePrms "IDPD", 12	: swbreak	// nIndependence
			
			// nType
			case "CTYPE" // (nType) �萔����������
				PrmLast
				GetINI "TYPE", refstr, prm, 64, "0", LibName(1)	// �萔��ǂݍ���
				InputStr "@(CTYPE)"+   prm
				swbreak
			case "RESET" : InputLine				: swbreak	// Reset
			case "LDEND" : InputLine	: _break	: swbreak	// �ǂݍ��ݏI��
			default
				if ( wpeek(tmp, 1) == 0x2F2F ) { _continue }	// "@//" �̃R�����g
				if ( wpeek(tmp, 1) == 0x2A2F ) {				// "@/*" �̕����s�R�����g
					fCom = true
					_continue
				}
				goto *def@ClrtxtOptimize_mod
			swend
			
			if ( Renzoku > 0 ) {				// ��ȏ�Ȃ�
				if ( Renzoku < NX_MIN ) {		// ���Ȃ����
					StrDel Clrtxt, RenzokuStart, 20			// �m�ۂ��������폜
					WriteSize -= 20							// ����������߂�
				} else {
					tmp(1) = strf("%010d", Renzoku)			//
					memcpy Clrtxt, tmp(1), 10, RenzokuStart + 8	// �R�s�[
				}
				Renzoku = 0
			}
		} else {
			*def@ClrtxtOptimize_mod
			// ��`
			num = strlen(tmp)								// ����
			if ( num ) {									// ����������
				NEXTX_Start									// NEXTX ���ߍ��ݗp����
				memexpand Clrtxt, WriteSize + num + 2		// NULL �������Ċm��
				InputLine									// ��s����������
				Renzoku ++			// �J�E���^
			}
		}
	until (index >= len)
	
	// �Ō�� NEXTX ����
	if ( Renzoku > 0 ) {				// ��ȏ�Ȃ�
		if ( Renzoku < NX_MIN ) {		// ���Ȃ����
			StrDel Clrtxt, RenzokuStart, 20			// �m�ۂ��������폜
			WriteSize -= 20							// ����������߂�
		} else {
			tmp(1) = strf("%010d", Renzoku)				//
			memcpy Clrtxt, tmp(1), 10, RenzokuStart + 8	// �R�s�[
		}
		Renzoku = 0
	}
	
	sdim   _buf,         WriteSize + 1
	memcpy _buf, Clrtxt, WriteSize, 0, 0
	
	sdim buf   , 0
	sdim Clrtxt, 0
	
	return WriteSize
	
//######## Clrtxt ����菜�� #######################################################################
#deffunc ClrtxtDelete var _buf, str p2, local len, local dir
	sdim tmp, 320	// ��s
	dim  num, 3		// Start, index, End
	sdim dir, 260
	
	if (getpath(p2, 32) == "") {			// ���΃p�X�Ȃ�
		dir = ClrtxtLib + p2				// Library �̃f�B���N�g����ǉ�
	} else {								// ��΃p�X�Ȃ�
		dir = p2							// ���̂܂܊i�[
	}
	len = strlen(_buf)						// Clrtxt �̒���
	num = instr( _buf, 0, "@(RESET)"+ dir )	// �폜�̐擪��T��
	if ( num < 0 || len <= 0 ) {
		return -1							// ���� = Error
	}
	
	num(2) = num + strlen(dir) + 10			// �I�[�{���̋N�_ ( @(RESET)PATH �̎��̍s )
	// �I�[��T��
	repeat
		num(1) = instr(_buf, num(2), "@(RESET)")
		if (num(1) == -1) {					// �����Ȃ�
			num(2) = len					// �I�[�܂ō폜����
			break
		}
		num(2) += num(1)
		
		if ( num(2) >= len ) { num(2) = len : break }
		
		getstr tmp, _buf, num(2)			// ��s�擾
		if (   tmp != "@(RESET)") {			// �p�X�t���Ȃ�
			break							// �I���
		} else {
			num(2) += strlen(tmp)			// ��s���i�߂�
		}
	loop
	
	// ����
	StrDel _buf, num, num(2) - num		// num �` �I�[ - �擪
	
	return (num(2) - num)	// ���������T�C�Y��Ԃ�
	
//######## �œK���ς� Clrtxt ����� ################################################################
#ifdef Footy2Create	// ��`����Ă�����
#define ctype RGB(%1,%2,%3) ((%1) | (%2) << 8 | (%3) << 16)
#define ClrLoadReset Ctls = EMP_WORD -1, EMPFLAG_NON_CS, 1, 0b0001, -1, RGB(255, 255, 255)
// COLORTXTLOAD �\���̗p�̃}�N����`
#define nType Ctls(0)
#define nFlag Ctls(1)
#define Level Ctls(2)
#define Kyoka Ctls(3)
#define nIdpd Ctls(4)
#define ColorRef Ctls(5)
#deffunc ClrtxtInput int FootyID, str p2, int bRefresh, local Ctls, local i, local word
	mref mystr, 65
	dim  Ctls, 6		// ClrTxtLoadStruct
	sdim tmp,  64, 2
	sdim word, 64, 2
	
	ClrtxtLength = strlen(p2)		// ����
	
	sdim Clrtxt, ClrtxtLength + 1
		 Clrtxt = p2				// �R�s�[
	do
		getstr tmp, Clrtxt, i		// ��s�擾
		i += strsize
		
		if (peek(tmp, 0) == '@') {
			tmp(1) = strmid(tmp, 2, 5)		// ���ߕ�����ǂݏo��
			switch tmp(1)
			case "NEXTX"						// ���� X �𖳏����œo�^
				getstr mystr, tmp, 8, ' ', 10
				num = int(refstr)				// ��(10 ��)
				if (nType < EMP_LINE_AFTER) {
					repeat num								// ��C�ɓǂݍ���
						getstr word(0), Clrtxt, i, 0
						i += strsize
					;	logmes word(0)
						Footy2AddEmphasis FootyID, word(0), "", nType +1, nFlag, Level, Kyoka, nIdpd, ColorRef
					loop
				} else {
					repeat num								// ��C�ɓǂݍ���
						getstr tmp    , Clrtxt,    i : i += strsize
						getstr word(0),    tmp,       0, ' '
						getstr word(1),    tmp, strsize, 0
					;	logmes word(0) +"\t"+ word(1)
						Footy2AddEmphasis FootyID, word(0), word(1), nType +1, nFlag, Level, Kyoka, nIdpd, ColorRef
					loop
				}
				swbreak
			case "CCREF" : PrmLast : ColorRef= int( refstr )	: swbreak	// nColorRef
			case "CTYPE" : PrmLast : nType   = int( refstr )	: swbreak	// nType
			case "KYOKA" : PrmLast : Kyoka   = int( refstr )	: swbreak	// nPermission
			case "LEVEL" : PrmLast : Level   = int( refstr )	: swbreak	// nLevel
			case "CFLAG" : PrmLast : nFlag   = int( refstr )	: swbreak	// nFlag
			case "CIDPD" : PrmLast : nIdpd   = int( refstr )	: swbreak	// nIndependence
			case "RESET" : ClrLoadReset							: swbreak	// Reset
			case "LDEND" : _break								: swbreak	// �ǂݍ��ݏI��
			default : goto *@f
			swend
		} else {
			*@
			if (nType < EMP_LINE_AFTER) {
				// �P�ꋭ��
				getstr word(0), tmp
			;	logmes word(0) +"\t"+ word(1)
				Footy2AddEmphasisW FootyID, word(0), "", nType +1, nFlag, Level, Kyoka, nIdpd, ColorRef
			} else {
				// �͈͋���
				getstr word(0), tmp,       0, ' '
				getstr word(1), tmp, strsize, NULL
			;	logmes word(0) +"\t"+ word(1)
				Footy2AddEmphasisW FootyID, word(0), word(1), nType +1, nFlag, Level, Kyoka, nIdpd, ColorRef
			}
		}
	until ( i >= ClrtxtLength ) 	// �����𒴂���܂�
	
	if ( bRefresh ) {
		Footy2FlushEmphasis FootyID		// �F�����m��
		Footy2Refresh       FootyID
	}
	return
#endif	/* Footy2Create */

#global

#if 0

#uselib "winmm.dll"
#cfunc timeGetTime "timeGetTime"

	sdim ClrtxtLib, MAX_PATH
	ClrtxtLib = "D:/Docs/prg/hsp/Project/����ł�HTML/Owner/ClrtxtLib"
	ClrtxtLibIs ClrtxtLib		// �ϐ����N���[��������
	
	sdim buf, 320
	time = timeGetTime()
	ClrtxtOptimize "ClrtxtBasic.clrtxt", buf
	time = timeGetTime() - time
	logmes "strsize\t : "+ stat
	logmes "strlen\t : " + strlen(buf)
	logmes "time\t : "   + time
	
	sdim   Clrtxt, strlen(buf) * 2
	memcpy Clrtxt, buf, strlen(buf)
	
	sdim buf
	
	ClrtxtOptimize ClrtxtLib +"Hold/HSPDA.clrtxt", buf
	Clrtxt += buf
	
	mesbox Clrtxt, ginfo(12), ginfo(13)
;	mesbox buf, ginfo(12), ginfo(13)
	
	assert 0
	
	ClrtxtDelete Clrtxt, "ClrtxtBasic.clrtxt"
	objprm 0, Clrtxt; +"\nend"
	
	stop
#endif

#endif
