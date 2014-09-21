// call - ModCls, functor
#if 0
#ifndef IG_CLASS_MODCLS_CONSTRUCTOR_H
#define IG_CLASS_MODCLS_CONSTRUCTOR_H

#include "IFunctor.h"

class CModClsCtor;
using modctor_t = CModClsCtor*;

struct STRUCTDAT;
struct STRUCTPRM;

class CModClsCtor
	: public IFunctor
{
	// �����o�ϐ�
private:
	stdat_t mpStDat;	// nullptr �̂Ƃ� nullmod �N���X
	CPrmInfo* mpPrmInfo;

	// �\�z
private:
	CModClsCtor();
	explicit CModClsCtor( stdat_t pStDat );
	explicit CModClsCtor( int modcls );

public:
	~CModClsCtor();

	CPrmInfo const& getPrmInfo() const;

	// �擾
	label_t getLabel() const;
	int     getAxCmd() const;
	int     getUsing() const { return 1; }

	stdat_t getCtor() const;
	int getCtorId() const;

	bool isBottom() const { return mpStDat == nullptr; }	// nullmod �̌^�ł���

	// ����
	void call( CCaller& caller );

	// ���b�p�[
	static modctor_t New();
	static modctor_t New( stdat_t pStDat );
	static modctor_t New( int modcls );

private:
	stprm_t getStPrm() const;

	void initialize();
	void createPrmInfo();

private:
	CModClsCtor( CModClsCtor const& );
	CModClsCtor& operator = ( CModClsCtor const& );
};

#endif
#endif
