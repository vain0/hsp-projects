// ini�Ǘ����W���[��

#ifndef __INI_FILE_AS__
#define __INI_FILE_AS__

#uselib "kernel32.dll"
#func   global WritePrivateProfileString_mod_ini "WritePrivateProfileStringA" sptr,sptr,sptr,sptr
#func   global GetPrivateProfileString_mod_ini   "GetPrivateProfileStringA"   sptr,sptr,sptr,int,int,sptr
#cfunc  global GetPrivateProfileInt_mod_ini      "GetPrivateProfileIntA"      sptr,sptr,int,sptr

#define global SetIniName(%1) sdim INIPATH, 260 : INIPATH = str(%1)
#define global INIPATH _ininame@

#define global WriteIni(%1,%2,%3,%4=INIPATH) WritePrivateProfileString_mod_ini %1,%2,str(%3),%4

#define global GetIni(%1,%2,%3,%4=64,%5="",%6=INIPATH) GetPrivateProfileString_mod_ini %1,%2,str(%5),varptr(%3),%4,%6
#define global ctype GetIntIni(%1,%2,%3=0,%4=INIPATH)  GetPrivateProfileInt_mod_ini(%1,%2,%3,%4)

#define global DelSectionIni(%1,%2=INIPATH) WritePrivateProfileString_mod_ini %1,0,0,%2
#define global DelKeyIni(%1,%2,%3=INIPATH) WritePrivateProfileString_mod_ini %1,%2,0,%3

#define global ctype IsExistKeyIni(%1,%2,%3=INIPATH) ( GetIntIni(%1,%2,0,%3) != 0 && GetIntIni(%1,%2,1,%3) != 1 )

#module mod_ini

//------------------------------------------------
// INI ����ǂݍ��� ( �֐��`�� )
//------------------------------------------------
#define global ctype IniLoad(%1,%2,%3=3200,%4="",%5=INIPATH) _IniLoad_mod_ini(%1,%2,%3,%4,%5)
#defcfunc _IniLoad_mod_ini str p1, str p2, int p3, str p4, str p5
	GetIni p1, p2, stmp_mod_ini@, p3, p4, p5
	return stmp_mod_ini@
	
#global
sdim stmp_mod_ini@, 3201

/***

�����t�@�����X

�����ׂĂɊւ���
	�E�Z�N�V�������A�L�[���A�t�@�C���p�X�́A���p�A���t�@�x�b�g�̑啶���E����������ʂ��܂���B
	�E�s���R�����g�̓Z�~�R���� ; �����ł��B�i���o�[�v���[�X # ��v�X���b�V�� // �͗L���ȋL���ł��B
	
��INI�̐ݒ�
	�ESetIniName "�t�@�C���p�X"
	
	�J�����g�EINI�t�@�C����ݒ肵�܂��B�p�X�ɂ̓t�@�C�����ł͂Ȃ��A��΃p�X�����΃p�X���w�肵�Ă��������B
	
��INI�ւ̏�������
	�EWriteIni "sec", "key", "value", maxlen, ["inipath"]
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l�� "value" �ɐݒ肵�܂��Bstr/int �₢�܂���B
	maxlen �́A�o�^���镶����̒���(�ő�)�ł��B�ʏ�� 64 �ł����A����ȏ�̏ꍇ��
	�w�肵�Ă��������B�����񒷂Ƃ҂�����ł���K�v�͂���܂���B
	
��INI����̓ǂݍ���
	�EGetIni "sec", "key", variable, maxlen, "default", ["inipath"]
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l���A������Ƃ��� variable �ɕԂ��܂��Bint �ɂ��g���܂��B
	maxlen �́A�ǂݍ��ޕ�����̍ő�̒����ł��B�ʏ�� 64 �ł����A����ȏ�̏ꍇ��
	�w�肵�Ă��������B�����񒷂Ƃ҂�����ł���K�v�͂���܂���B
	�w�肵���L�[�����݂��Ȃ��ꍇ�́A"default"�̒l���Ԃ�܂��B�ȗ������ "" (�󕶎���)�ł��B
	
	�EGetIntIni("sec", "key", default, ["inipath"])
	
	�Z�N�V���� "sec" �̃L�[ "key" �̒l���A���l�Ƃ��ēǂݏo���ĕԂ��܂��Bstr ���Ǝg���܂���B
	�w�肵���L�[�����݂��Ȃ��ꍇ�Adefault �̒l���Ԃ�܂��B�ȗ������ 0 �ł��B
	
	�EIniLoad("sec", "key", maxlen, "default", ["inipath"])
	
	GetIni �̊֐��o�[�W�����ł��B�኱�ᑬ�ɂȂ�܂��Bmaxlen �́A�ȗ������ 3200 �ɂȂ�܂��B
	
��INI�f�[�^�̍폜
	�EDelSectionIni "sec", ["inipath"]
	
	�Z�N�V���� "sec" ���폜���܂��B���ɖ߂��܂���B
	
	�EDelKeyIni "sec", "key", ["inipath"]
	
	�Z�N�V���� "sec" �̃L�[ "key" ���폜���܂��B���ɖ߂��܂���B
	
�����̑�
	�EIsExistKeyIni("sec", "key", ["inipath"])
	
	�Z�N�V���� "sec" �̃L�[ "key" �����݂��邩�ǂ����B���݂���Ȃ�^��Ԃ��܂��B
	���l�̂Ȃ��L�[( "key=" ���� )�́A���݂��Ȃ����̂Ƃ��Ĉ����܂��B
	
***/
#endif
