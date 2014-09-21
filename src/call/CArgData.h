// CArgData - header
#if 0
#ifndef IG_CLASS_ARGDATA_H
#define IG_CLASS_ARGDATA_H

#include <vector>
#include "hsp3plugin_custom.h"

#include "CCall.h"

//##############################################################################
//               �錾�� : CArgData
//##############################################################################
// ���x�����߁E�֐��ɗ^����������̏��
class CCall::CArgData
{
	//############################################
	//    �����o�ϐ�
	//############################################
private:
	CCall* mpCall;					// owner

	int mCntArg;					// �����̐�
	std::vector<PVal*> mArgVal;		// �����̒l or �Q�ƁA���邢�� nullptr(nobind ��\��)
	std::vector<APTR>  mIdxRef;		// �Q�Ɠn���� aptr �l ( �l�n���Ȃ畉�� )
	std::vector<PVal*>* mpLocals;	// ���[�J���ϐ��Q (prmstack ��ւ̃|�C���^; �s�v�ȂƂ��� new ���Ȃ�)

	std::vector<PVal*>* const mpArgVal;	// �|�C���^�o�R�ŎQ�Ƃ��邱�Ƃɂ��� (���܂Ń|�C���^�������̂�)
	std::vector<APTR>*  const mpIdxRef;

	//############################################
	//    �����o�֐�
	//############################################
public:
	explicit CArgData( CCall* pCall );
	CArgData( CArgData const& obj );
	~CArgData();

	// ����n

	// �ݒ�n
	void addArgByVal( void const* val, vartype_t vt );
	void addArgByVal( PVal* pval );
	void addArgByRef( PVal* pval ) { addArgByRef( pval, pval->offset ); }
	void addArgByRef( PVal* pval, APTR aptr );
	void addArgByVarCopy( PVal* pval );
	void addArgSkip( int lparam = 0 );
	void addLocal( PVal* pval );
	void clearArg();

	void reserveArgs( size_t cnt );
	void reserveLocals( size_t cnt );

	// �擾�n
	size_t getCntArg() const { return mCntArg; }
	PVal* getArgPVal( int iArg ) const;
	APTR  getArgAptr( int iArg ) const;
	int   getArgInfo( ARGINFOID id, int iArg = -1 ) const;
	bool   isArgSkipped( int iArg ) const;
	PVal* getLocal( int iLocal ) const;

private:
	CArgData();
	CArgData& operator = ( CArgData const& obj );

	//############################################
	//    ���������o�֐�
	//############################################
private:
	CArgData& opCopy( CArgData const& obj );

	// ����

	// ��n��
	void freeArgPVal();

};

#endif
#endif