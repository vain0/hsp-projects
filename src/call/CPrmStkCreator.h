// prmstack �����N���X

#ifndef IG_CLASS_PARAMETER_STACK_CREATOR_H
#define IG_CLASS_PARAMETER_STACK_CREATOR_H

/**
@summary:
	prmstk �Ɠ����`���Ńf�[�^���i�[���鏈���̃C���^�[�t�F�[�X�ƂȂ�N���X�B
**/

#include "hsp3plugin.h"

class CPrmStkCreator
{
private:
	char*  ptr_;		// �X�^�b�N�̐擪�ւ̃|�C���^
	size_t usingSize_;	// �g�p���ꂽ�T�C�Y
	size_t bufSize_;	// �m�ۍς݂̃T�C�Y

public:
	CPrmStkCreator( void* buf, size_t bufSize )
		: ptr_( reinterpret_cast<char*>( buf ) )
		, bufSize_( bufSize )
		, usingSize_( 0 )
	{ }
	~CPrmStkCreator() { }

	// �擾
	void*  getptr()   const { return ptr_; }
	size_t capacity() const { return bufSize_; }
	size_t size()     const { return usingSize_; }

	// �i�[
	template<typename T> T* allocValue();		// �̈悾���m�ہA�������͂��Ȃ�
	template<typename T> void pushValue( T&& value );

	void pushPVal( PVal* pval, APTR aptr ) {
		pushValue( pval );
		pushValue( aptr );
	}
	void pushPVal( MPVarData const* pVarDat ) {
		pushValue(*pVarDat);
	}
	void pushThismod( PVal* pval, APTR aptr, int idStDat ) {
		pushValue(MPModVarData { idStDat, MODVAR_MAGICCODE, pval, aptr });
	}

	PVal* allocLocal() {
		return allocValue<PVal>();
	}

private:
	void needAdditionalSize( size_t sizeAdditional ) {		// �g�p����T�C�Y�̐錾
		if ( bufSize_ < (usingSize_ + sizeAdditional) ) {
			puterror( HSPERR_OUT_OF_MEMORY );
		}
	}

	void* begin() const { return ptr_; }
	void* end() const { return ptr_ + usingSize_; }

protected:
	// for CPrmStk
	void* allocBlank(size_t size) {
		needAdditionalSize(size);
		void* const p = end();
		usingSize_ += size;
		return p;
	}

private:
	CPrmStkCreator( CPrmStkCreator const& obj ) = delete;
	CPrmStkCreator& operator = ( CPrmStkCreator const& obj ) = delete;
};

//------------------------------------------------
// �P���ɒl���v�b�V������
//------------------------------------------------
template<typename T>
void CPrmStkCreator::pushValue(T&& value)
{
	using value_type = std::decay_t<T>;

	value_type* const p = allocValue<value_type>();
	*p = std::forward<T>(value);
	return;
}

template<typename T>
T* CPrmStkCreator::allocValue()
{
	return reinterpret_cast<T*>(allocBlank(sizeof(T)));
}

#endif
