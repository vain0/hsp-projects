// opex - public header

#ifndef        IG_OPEX_HPI_AS
#define global IG_OPEX_HPI_AS

#define HPI_OPEX_VERSION 1.2	// last update: 2011 09/12 (Mon)

;#define IF_OPEX_HPI_RELEASE

#ifndef STR_OPEX_HPI_PATH
 #ifdef IF_OPEX_HPI_RELEASE
  #define STR_OPEX_HPI_PATH "opex.hpi"
 #else
  #define STR_OPEX_HPI_PATH "D:/Docs/prg/cpp/MakeHPI/opex/Debug/opex.hpi"
 #endif
#endif

#regcmd "_hsp3typeinfo_opex@4", STR_OPEX_HPI_PATH
#cmd assign      0x000		// ���
#cmd swap        0x001		// ����
#cmd clone       0x002		// ��Q��
#cmd cast_to_    0x003		// �L���X�g
#cmd memberOf    0x004		// �����o�ϐ��̎Q��
#cmd memberClone 0x005		// �����o�ϐ��̃N���[��(��Q��)

#cmd short_and   0x100		// �Z�� and
#cmd short_or    0x101		// �Z�� or
#cmd eq_and      0x102		// ��r and
#cmd eq_or       0x103		// ��r or
#cmd which       0x104		// �������Z
#cmd what        0x105		// ���򉉎Z
#cmd exprs       0x106		// ���X�g��
#cmd vtname      0x110		// �ϐ��^�̖��O

#cmd _kw_constptr   0x200	// (kw) �萔�|�C���^

#define globala ctype cast_to(%1, %2) cast_to_(%2, %1)
#define global ctype value_cast(%1) cast_to_.(vartype("%1")).

#define global constptr _kw_constptr ||

#endif
