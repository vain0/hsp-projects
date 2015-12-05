/* trayicon.as */

#ifndef IG_TRAYICON_AS
#define IG_TRAYICON_AS

#module trayicon

// HSP3 �� �^�X�N�g���C�A�C�R������郂�W���[�� 0.02 / ���e�Ƃ� 2005. 8.12

#define WM_TRAYEVENTSTART 0x0900
#define MAX_ICONS  16		// ���A�C�R���ő吔��`
#define POPUP_TIME 30		// �^�C���A�E�g����(sec)

#define NIF_MESSAGE	0x0001
#define NIF_ICON	0x0002
#define NIF_TIP		0x0004

#define NIM_ADD		0x000
#define NIM_MODIFY	0x001
#define NIM_DELETE	0x002

#define ERROR_TIMEOUT 1460	// This operation returned because the timeout period expired.

// �g�p����API�̒�`�B
#uselib "Kernel32.dll"
#func   GetModuleFileName@trayicon "GetModuleFileNameA" nullptr,prefstr,int	// �������g�̖��O�𓾂�API
#cfunc  GetLastError@trayicon      "GetLastError"

#uselib "Shell32.dll"
#func   ExtractIconEx@trayicon    "ExtractIconExA" sptr,int,nullptr,var,int	// �t�@�C������A�C�R���𒊏o����
#func   Shell_NotifyIcon@trayicon "Shell_NotifyIconA" int,int				// �^�X�N�g���C�A�C�R���𐧌䂷��

#uselib "user32.dll"
#func   DestroyIcon@trayicon "DestroyIcon" int		// ���o�����A�C�R����j������

//------------------------------------------------
// �^�X�N�g���C�ɃA�C�R����ǉ�����
// 
// @prm tooltip : �c�[���`�b�v������B�ő� 63 [byte]
// @prm idxIcon : �w�肵���t�@�C���Ɋ܂܂��A�C�R���̔ԍ�
// @prm idIcon  : �A�C�R��ID
//------------------------------------------------
#deffunc CreateTrayIcon str sTooltip, int idxIcon, int idIcon
	if ( hIcon(idIcon) ) { DestroyTrayIcon idIcon }			// ���łɐݒ肳��Ă������x�폜����
	ExtractIconEx icofile, idxIcon, hIcon(idIcon), 1		// �t�@�C������A�C�R�������o���B
	
	dim nfid, 88 / 4			// NOTIFYICONDATA �\���̂����B
	// size of struct, hWindow, idIcon, Flag, MsgID, hIcon, Tooltips
	nfid = 88, hWnd_, idIcon, 7, WM_TRAYEVENTSTART, hIcon(idIcon)
	poke nfid, 4 * 6, sTooltip
	
	// �A�C�R����o�^����
	repeat
		Shell_NotifyIcon NIM_ADD, varptr(nfid)		// �A�C�R����o�^����B
		if ( stat ) { break }						// �^�Ȃ�I���
		
		// �^�C���A�E�g���ǂ������ׂ�
		if ( GetLastError() != ERROR_TIMEOUT ) {
			// �A�C�R���o�^�G���[
			logmes "�ʒm�̈�ɃA�C�R����o�^�ł��܂���ł���"
			break
		}
		
		// �o�^�ł��Ă��Ȃ����Ƃ��m�F����
		Shell_NotifyIcon NIM_MODIFY, varptr(nfid)
		if ( stat ) { break }
		
		wait 10
	loop
	
	// �A�C�R����M��ꂽ�炱�̃��x���ɔ�Ԃ悤�w�肷��
	oncmd gosub *OnTrayIconEvent@, WM_TRAYEVENTSTART
	
	return
	
//------------------------------------------------
// �^�X�N�g���C�̃A�C�R�����폜����
//------------------------------------------------
#deffunc DestroyTrayIcon int idIcon 
	dim nfid, 88 / 4							// NOTIFYICONDATA �\����
	nfid = 88, hWnd, idIcon
	Shell_NotifyIcon NIM_DELETE, varptr(nfid)	// �A�C�R�����폜����B
	if ( hIcon(idIcon) ) {
		DestroyIcon hIcon( idIcon )				// �g���C�����菜��
		hIcon( idIcon ) = 0						// �A�C�R���n���h���j��
	}
	return
	
//------------------------------------------------
// �A�C�R���Ƀo���[���`�b�v��t����
// 
// @ CreateTrayIcon�ς݂̃A�C�R������A�o���[���`�b�v���|�b�v�A�b�v������B
// @ Windows Me/2000/XP �݂̂ŗL���A98SE�ȑO�ł͎��s���Ă������N����Ȃ����B
// @prm baloonInfoTitle : �o���[���`�b�v�̃^�C�g�����̕�����B�ő� 63 [byte]
// @prm balloonInfo     : �o���[���`�b�v�̖{���B�ő� 255 [byte]
// @prm baloonIcon      : 0 => none, 1 => info(i),  2 => warn(!), 3 => err(X)
// @prm idIcon          : �Ώۂ̃A�C�R��ID
//------------------------------------------------
#deffunc PopupBalloonTip str balloonInfoTitle, str balloonInfo, int balloonIcon, int idIcon
	dim  nfid,  488 / 4
		 nfid = 488, hWnd_, idIcon, 0x0010
	poke nfid,  4 * 40, balloonInfo
		 nfid(104) = 1000 * POPUP_TIME			// �^�C���A�E�g����
	poke nfid,  4 * 105, balloonInfoTitle
		 nfid(121) = balloonIcon
	
	Shell_NotifyIcon NIM_MODIFY, varptr(nfid)	// �A�C�R����ύX����B
	return
	
//------------------------------------------------
// �A�C�R�������t�@�C����I������
// 
// @prm filename : �t�@�C���p�X�B"" => �������g
//------------------------------------------------
#deffunc SetTrayIconFile str filename 
	sdim icofile, 260 + 1			// MAX_PATH
	if ( filename == "" ) {
		GetModuleFileName 260
		icofile = refstr
	} else {
		icofile = filename
	}
	return
	
//------------------------------------------------
// ���W���[������
//------------------------------------------------
#deffunc _init@trayicon
	mref    bmscr, 96
	hWnd_ = bmscr(13)
	dim hIcon, MAX_ICONS
	SetTrayIconFile ""
	return
	
//------------------------------------------------
// ���W���[���j��
//------------------------------------------------
#deffunc _term@trayicon onexit	// �I�����ɑS���̃A�C�R�����폜�B
	foreach hIcon
		if ( hIcon(cnt) ) {
			DestroyTrayIcon cnt
		}
	loop
	return
	
#global

	_init@trayicon

// �T���v���E�X�N���v�g
#if 0
	
	CreateTrayIcon  "����Ղ邠������ 0"	// �Ƃ肠��������Ă݂�B
	PopupBalloonTip "�΂�[��", "����̓o���[���`�b�v�̃T���v���ł��B", 3, 0
	
	SetTrayIconFile "user32.dll"
	CreateTrayIcon  "����Ղ邠������ 1", 1, 1
	CreateTrayIcon  "����Ղ邠������ 2", 4, 2
	
	SetTrayIconFile "winmine.exe"
	CreateTrayIcon  "����Ղ邠������ 3", 0, 3
	mes "�g���C�ɃA�C�R�������܂����B"
	stop
	
*OnTrayIconEvent@
	// �R���Ǝ����悤�Ȃ���A�g�����ō���Ă��������B
	idIcon = wparam
	switch ( lparam )
		case 0x0200 : swbreak		// �}�E�X���A�C�R����G���������B
		case 0x0201 : mes "�A�C�R��("+ idIcon +")�ō��{�^������������܂���"				: swbreak
		case 0x0202 : mes "�A�C�R��("+ idIcon +")�ō��{�^�����������܂���"				: swbreak
		case 0x0203 : mes "�A�C�R��("+ idIcon +")�ō��{�^�����_�u���N���b�N����܂���"		: swbreak
		case 0x0204 : mes "�A�C�R��("+ idIcon +")�ŉE�{�^������������܂���"				: swbreak
		case 0x0205 : mes "�A�C�R��("+ idIcon +")�ŉE�{�^�����������܂���"				: swbreak
		case 0x0206 : mes "�A�C�R��("+ idIcon +")�ŉE�{�^�����_�u���N���b�N����܂���"		: swbreak
		case 0x0207 : mes "�A�C�R��("+ idIcon +")�Ő^�񒆂̃{�^����������܂���"			: swbreak
		case 0x0208 : mes "�A�C�R��("+ idIcon +")�Ő^�񒆂̃{�^����������܂���"			: swbreak
		case 0x0209 : mes "�A�C�R��("+ idIcon +")�Ő^�񒆂̃{�^�����_�u���N���b�N����܂���": swbreak
	swend
	return
	
#endif

#endif
