// ���������N���X

#ifndef IG_CLASS_PARAMETER_INFORMATION_H
#define IG_CLASS_PARAMETER_INFORMATION_H

#include <vector>
#include "PrmType.h"
#include "cmd_call.h"

/**
@summary:
	�����������Ǘ�����B
	�����Ăяo�����͒m��Ȃ��BCCall �ɏ����E�g�p�����B
	cmd_sub.cpp, CBound �Ȃǂ��A�Ăяo����Ƒ΂ɂ��Đ����E�Ǘ�����B
	�S�̓I�� constexpr �������͂��Ȃ̂ɁB

	��̏����̕K�v���Ȃ��l�����������Ă���B
**/
class CPrmInfo
{
public:
	using prmlist_t = std::vector<int>;
	using offset_t  = std::vector<size_t>;

private:
	size_t cntPrms_;		// �󂯎��������̐�
	size_t cntCaptures_;	// �L���v�`���l�̐�
	size_t cntLocals_;		// ���[�J���ϐ��̐�
	bool bFlex_;			// �ϒ��������ۂ�

	// ���������X�g
	prmlist_t prmlist_;

	// �I�t�Z�b�g�l�̃L���b�V�� (PrmStk ���Q�Ƃ��邽�тɕK�v�Ȃ̂ŁA�������ɂ��ׂČv�Z���Ă���)
	offset_t offsetlist_;
	size_t stkOffsetCapture_;
	size_t stkOffsetLocal_;
	size_t stkOffsetFlex_;
	size_t stkSize_;

public:
	//--------------------------------------------
	// �\�z
	//--------------------------------------------
	CPrmInfo() : CPrmInfo(nullptr) { }
	CPrmInfo(prmlist_t const* pPrmlist);

	CPrmInfo(prmlist_t&& prmlist) : CPrmInfo(&prmlist) { }
#if 0
	CPrmInfo(CPrmInfo&&) = default;
#else
	CPrmInfo(CPrmInfo&& src)
		: cntPrms_ { src.cntPrms_ }
		, cntCaptures_ { src.cntCaptures_ }
		, cntLocals_ { src.cntLocals_ }
		, bFlex_ { src.bFlex_ }
		, prmlist_( std::move(src.prmlist_) )
		, offsetlist_( std::move(src.offsetlist_) )
		, stkOffsetCapture_ { src.stkOffsetCapture_ }
		, stkOffsetLocal_ { src.stkOffsetLocal_ }
		, stkOffsetFlex_ { src.stkOffsetFlex_ }
		, stkSize_ { src.stkSize_ }
	{}

	CPrmInfo(CPrmInfo const&) = delete;
	CPrmInfo& operator=(CPrmInfo const&) = delete;
#endif

private:
	void calcOffsets();
	void setPrmlist(prmlist_t const& prmlist);

public:
	//--------------------------------------------
	// �擾�n
	//--------------------------------------------
	size_t cntPrms()     const { return cntPrms_; }
	size_t cntCaptures() const { return cntCaptures_; }
	size_t cntLocals()   const { return cntLocals_; }
	bool   isFlex()      const { return bFlex_; }

	int getPrmType( size_t idx ) const;

	size_t getStackSize() const { return stkSize_; }
	size_t getStackOffset(size_t idx) const;
	size_t getStackOffsetParam(size_t idx) const;
	size_t getStackOffsetCapture(size_t idx) const;
	size_t getStackOffsetLocal(size_t idx) const;
	size_t getStackOffsetFlex() const { return stkOffsetFlex_; }

	//--------------------------------------------
	// ���̑�
	//--------------------------------------------
	PVal* getDefaultArg( size_t iArg ) const;
	void checkCorrectArg( PVal const* pvArg, size_t iArg, bool bByRef = false ) const;

	//--------------------------------------------
	// ���Z�q�I�[�o�[���[�h
	//--------------------------------------------
	int compare( CPrmInfo const& rhs ) const;
	bool operator ==( CPrmInfo const& rhs ) const { return compare( rhs ) == 0; }
	bool operator !=( CPrmInfo const& rhs ) const { return !( *this == rhs ); }

	// ���̑�
public:
	static CPrmInfo Create(hpimod::stdat_t);

	// ���錾�֐��̉�����
	static CPrmInfo const undeclaredFunc;

	// ��������1�������Ȃ��֐��̉�����
	static CPrmInfo const noprmFunc;
};

#endif
