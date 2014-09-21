// assoc - Command header

#ifndef IG_ASSOC_COMMAND_H
#define IG_ASSOC_COMMAND_H

#include "vt_assoc.h"

extern void AssocTerm();

extern int SetReffuncResult( PDAT** ppResult, CAssoc* const& pAssoc );

// ����
extern void AssocNew();		// �\�z
extern void AssocDelete();	// �j��
extern void AssocClear();	// ����
extern void AssocChain();	// �A��
extern void AssocCopy();	// ����

extern void AssocImport();	// �O���ϐ��̃C���|�[�g
extern void AssocInsert();	// �L�[��}������
extern void AssocRemove();	// �L�[����������

extern void AssocDim();		// �����ϐ���z��ɂ���
extern void AssocClone();	// �����ϐ��̃N���[�������

// �֐�
extern int AssocNewTemp(PDAT** ppResult);
extern int AssocNewTempDup(PDAT** ppResult);

extern int AssocVarinfo(PDAT** ppResult);
extern int AssocSize(PDAT** ppResult);
extern int AssocExists(PDAT** ppResult);
extern int AssocIsNull(PDAT** ppResult);
extern int AssocForeachNext(PDAT** ppResult);

extern int AssocResult( PDAT** ppResult );	// assoc �ԋp
extern int AssocExpr( PDAT** ppResult );	// assoc ��

// �V�X�e���ϐ�

// �萔
enum VARINFO {
	VARINFO_NONE = 0,
	VARINFO_FLAG = VARINFO_NONE,
	VARINFO_MODE,
	VARINFO_LEN,
	VARINFO_SIZE,
	VARINFO_PT,
	VARINFO_MASTER,
	VARINFO_MAX
};

#endif
