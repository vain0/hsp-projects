// �X�g���[���Ăяo���I�u�W�F�N�g
#if 0
#ifndef IG_CLASS_STREAM_CALLER_H
#define IG_CLASS_STREAM_CALLER_H

// �u�Ăяo���̓r���v��ۑ�����I�u�W�F�N�g

#include "hsp3plugin_custom.h"
#include "IFunctor.h"

class CCaller;
class CStreamCaller;

using stream_t = CStreamCaller*;

class CStreamCaller
	: public IFunctor
{
	// �����o�ϐ�
private:
	CCaller* mpCaller;		// �X�g���[���ɒǉ����ꂽ������ێ�����

	// �\�z
private:
	CStreamCaller();
	~CStreamCaller();

public:
	void call( CCaller& callerRemain );		// (���������������� + �Ăяo��)

	CCaller* getCaller()  const { return mpCaller; }
	label_t   getLabel() const;
	int       getAxCmd() const;
	int       getUsing() const;

	CPrmInfo const& getPrmInfo() const;			// ������

	// ���b�p�[
	static stream_t New();
};

#endif
#endif
