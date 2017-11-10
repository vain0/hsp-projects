// opex - command header

#ifndef IG_COMMAND_OPEX_H
#define IG_COMMAND_OPEX_H

#include "hsp3plugin_custom.h"

// ����
extern int assign( void** ppResult );
extern int   swap( void** ppResult );

// �֐�
extern int shortLogOp( void** ppResult, bool bAnd );
extern int   cmpLogOp( void** ppResult, bool bAnd );

extern int which(void** ppResult);
extern int what(void** ppResult);

extern int exprs( void** ppResult );

// �V�X�e���ϐ�

// �萔
enum OPTYPE
{
	OPTYPE_MIN = 0,
	OPTYPE_ADD = OPTYPE_MIN,
	OPTYPE_SUB,
	OPTYPE_MUL,
	OPTYPE_DIV,
	OPTYPE_MOD,
	OPTYPE_AND,
	OPTYPE_OR,
	OPTYPE_XOR,
	OPTYPE_EQ,
	OPTYPE_NE,
	OPTYPE_GT,
	OPTYPE_LT,
	OPTYPE_GTEQ,
	OPTYPE_LTEQ,
	OPTYPE_RR,
	OPTYPE_LR,
	OPTYPE_MAX
};

#endif
