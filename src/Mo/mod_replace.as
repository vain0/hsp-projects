// �u�����W���[�� (HSP�J��Wiki) 2007/06/05      ver1.3

#ifndef        __MODULE_REPLACE_AS__
#define global __MODULE_REPLACE_AS__

#module modReplace
// �y�ϐ��̐����z
//    var sTarget       �u������������������^�ϐ�
//    str sBefore       �������镶���񂪊i�[���ꂽ�ϐ�
//    str sAfter        �u����̕����񂪊i�[���ꂽ�ϐ�
//    str sResult       �ꎞ�I�ɒu�����ʂ�������ϐ�
//    int iIndex        sResult�̕�����̒���
//    int iIns          instr�̎��s���ʂ��i�[�����ϐ�
//    int iStat         �������Č�������������̐�
//    int iNowSize      sResult�Ƃ��Ċm�ۂ���Ă��郁�����T�C�Y
//    int iTargetLen    sTarget�̕�����̒����i���񒲂ׂ�̂͌����������j
//    int iAfterLen     sAfter�̕�����̒��� �i�V�j
//    int iBeforeLen    sBefore�̕�����̒����i�V�j
#const FIRST_SIZE       64000   // �͂��߂Ɋm�ۂ���sResult�̒���
#const EXPAND_SIZE      32000   // memexpand���߂Ŋg�����钷���̒P��

// �������Ċm�ۂ̔��f�y�ю��s�̂��߂̖��߁i���W���[�������Ŏg�p�j
#deffunc _expand var sTarget, var iNowSize, int iIndex, int iPlusSize
	if (iNowSize <= iIndex + iPlusSize) {
		iNowSize += EXPAND_SIZE * (1 + iPlusSize / EXPAND_SIZE)
		memexpand sTarget, iNowSize
	}
	return
	
// ��������̑Ώە�����S�Ă�u�����閽��
#deffunc replace var sTarget, str sBefore, str sAfter, local sResult, local iIndex, local iIns, \
	local iStat, local iTargetLen, local iAfterLen, local iBeforeLen, local iNowSize
	
	sdim sResult, FIRST_SIZE
	iTargetLen = strlen(sTarget)
	iAfterLen  = strlen(sAfter)
	iBeforeLen = strlen(sBefore)
	iNowSize   = FIRST_SIZE
	iStat  = 0
	iIndex = 0
	
	repeat iTargetLen       // �����E�u���̊J�n
		iIns = instr(sTarget, cnt, sBefore)
		if (iIns < 0) {         // ����������Ȃ��̂ŁA�܂�sResult�ɒǉ����Ă��Ȃ�����ǉ�����break
			_expand sResult, iNowSize, iIndex, iTargetLen - cnt // �I�[�o�[�t���[������邽�߁A���������Ċm��
			poke sResult, iIndex, strmid(sTarget, cnt, iTargetLen - cnt)
			iIndex += iTargetLen - cnt
			break
		} else {                // ���������̂ŁA�u�����đ��s
			_expand sResult, iNowSize, iIndex, iIns + iAfterLen // �I�[�o�[�t���[������邽�߁A���������Ċm��
			poke sResult, iIndex, strmid(sTarget, cnt, iIns) + sAfter
			iIndex += iIns + iAfterLen
			iStat++
			continue cnt + iIns + iBeforeLen
		}
	loop
	
	sdim   sTarget, iIndex + 1
	memcpy sTarget, sResult, iIndex
	return iStat            // ���܂��B�u�����������V�X�e���ϐ�stat�ɑ���B
#global

#if 0
	note = "HSP�̍ŐV�o�[�W������2.61�ł��B"
	mes note
	replace note, "2.61", "3.0"
	mes note
	mes str(stat) + "��u�����܂����B"
	stop
#endif

#endif
