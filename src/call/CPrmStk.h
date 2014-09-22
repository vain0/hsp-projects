// prmstk �N���X

/**
HSP �� prmstk �Ɠ����`���Ńf�[�^���i�[����R���e�i�B

prmstk �̓����`�����Q�Ƃ��邷�ׂĂ̋@�\�������ɕ����߂�B
prmstk �o�b�t�@�Astr �����A�l�n�����ꂽ any �����p�� PVal�Aflex �p�� vector�Alocal �ϐ����Ǘ�����@�\�����B
���I�Ȓl(prmtype)�ɂ���Č^�����܂�Ƃ����A���Ȃ�i�C�[�u�Ȏd�l�Ȃ̂ŁA�����ɒ��ӂ���B

�o�b�t�@�́u�������v�u�I�[���v��2���琬��B
�u�������v�͗^����ꂽ��������ς�ł��������B
�u�I�[���v�́A���ׂĂ̎������̌�ɁA�R�[�h������������󂯎��Ȃ��Ă����������^�C�v�ɑΉ�����̈��ς�ł��������B
	��̓I�ɂ́APrmType::Capture, PrmType::Local, PrmType::Flex �̂��߂̗̈悪(���̏���)�ς܂��B
�Ȃ��o�b�t�@�͌Œ蒷�ł���A�������̎��_�ŃT�C�Y���m�肵�Ă���B

idx �� flex ���܂܂Ȃ��B
todo: �^����ꂽ MPVarData (Managed ��������Ȃ�) �����L����ׂ�
todo: ManagedBuffer (strbuf �|�C���^���Q�ƃJ�E���^�����ŊǗ�)
todo: �������o������(Invoker)��2�d�� prmtype ���Q�Ƃ���̂����������Ȃ������B
//*/

#ifndef IG_CLASS_PARAMETER_STACK_CREATOR_MANAGED_H
#define IG_CLASS_PARAMETER_STACK_CREATOR_MANAGED_H

#include <vector>

#include "hsp3plugin_custom.h"
#include "CPrmInfo.h"
#include "CPrmStkCreator.h"
#include "ManagedPVal.h"

#include "../var_vector/vt_vector.h"

namespace ArgInfoId
{
	static int const
		IsVal = 0,
		IsRef = 1,
		IsMod = 2,
		Ptr = 3
		;
}

class CPrmStk;
using arguments_t = CPrmStk;

//------------------------------------------------
// ������ prmstk 
//------------------------------------------------
class CPrmStk
	: private CPrmStkCreator
{
private:
	CPrmInfo const& prminfo_;

	// ���݁A�ǉ����ꂽ�������̌� (flex �͏���)
	size_t cntArgs_;

	// �I�[�����ǉ����ꂽ���ۂ�
	bool finalized_;

	using super_t = CPrmStkCreator;

	// �w�b�_
	struct header_t {
		unsigned short magicCode;
	};
	static size_t const headerSize = sizeof(header_t);
	static int const MagicCode = 0x55AC;

public:
	CPrmStk(CPrmInfo const& prminfo)
		: super_t(hspmalloc(prminfo.getStackSize() + headerSize) + headerSize, prminfo.getStackSize() + headerSize)
		, prminfo_ { prminfo }
		, cntArgs_ { 0 }
		, finalized_ { false }
	{
		std::memset(getptr(), 0x00, capacity());
		getHeader(super_t::getptr()).magicCode = MagicCode;
	}

	~CPrmStk() { free(); }

	void* getPrmStkPtr() { return super_t::getptr(); }
	void const* getPrmStkPtr() const { return super_t::getptr(); }

	size_t cntArgs() const { return cntArgs_; }
	bool hasFinalized() const { return finalized_; }

	CPrmInfo const& getPrmInfo() const { return prminfo_; }
	int getNextPrmType() const {
		return prminfo_.getPrmType(cntArgs());
	}

	void incCntArgs() { ++cntArgs_; }

	static bool hasMagicCode(void* prmstk) {
		return (getHeader(prmstk).magicCode == MagicCode);
	}
private:
	static header_t& getHeader(void* prmstk) {
		return reinterpret_cast<header_t*>(prmstk)[-1];
	}

public:
	//------------------------------------------------
	// �������l�� push �e��
	//------------------------------------------------
	// �P���Ȓl
	template<typename VartypeTag>
	void pushValue(PDAT const* pdat)
	{
		assert(!hasFinalized());
		int const prmtype = getNextPrmType();
		assert(prmtype == VtTraits<VartypeTag>::vartype() && prmtype != HSPVAR_FLAG_STR);

		incCntArgs();
		super_t::pushValue(VtTraits<VartypeTag>::derefValptr(pdat));
	}
	template<> void pushValue<str_tag>(PDAT const* pdat);

	// ������ (prmstk �p�ɃR�s�[�����)
	void pushString(char const* src)
	{
		assert(!hasFinalized());
		assert(getNextPrmType() == HSPVAR_FLAG_STR);
		incCntArgs();

		char** const p = allocValue<char*>();
		size_t const len = std::strlen(src);
		size_t const size = len * sizeof(char) + 1;
		*p = hspmalloc(size);
		strcpy_s(*p, size, src);
		return;
	}

	// �l�n���� any (PVal* �ɕۑ�����)
	void pushAnyByVal(PDAT const* pdat, hpimod::vartype_t vtype)
	{
		assert(!hasFinalized());

		int const prmtype = getNextPrmType();
		assert(prmtype == PrmType::Any || PrmType::isExtendedVartype(prmtype));

		incCntArgs();
		hpimod::ManagedPVal pval;
		hpimod::PVal_assign(pval.valuePtr(), pdat, vtype);
		pushPVal(pval.valuePtr(), 0);
		pval.incRef();	// prmstk �ɂ�鏊�L
		return;
	}

	// �Q�Ɠn���� any (�Ǘ��̕K�v�͂Ȃ�)
	void pushAnyByRef(PVal* pval, APTR aptr)
	{
		assert(!hasFinalized());
		assert(getNextPrmType() == PrmType::Any);

		incCntArgs();
		pushPVal(pval, aptr);
		return;
	}

	// �ϐ��Q��
	void pushPVal(PVal* pval, APTR aptr)
	{
		assert(!hasFinalized());
		assert(getNextPrmType() == PrmType::Var);

		incCntArgs();
		super_t::pushPVal(pval, aptr);
		return;
	}
	void pushPVal(PVal* pval)
	{
		assert(!hasFinalized());
		assert(getNextPrmType() == PrmType::Array);

		incCntArgs();
		super_t::pushPVal(pval, 0);
		return;
	}
	void pushThismod(PVal* pval, APTR aptr)
	{
		assert(!hasFinalized());

		if ( getNextPrmType() != PrmType::Modvar ) puterror(HSPERR_ILLEGAL_FUNCTION);
		if ( pval->flag != HSPVAR_FLAG_STRUCT ) puterror(HSPERR_TYPE_MISMATCH);

		incCntArgs();
		auto const fv = VtTraits<struct_tag>::getValptr(pval);
		super_t::pushThismod(pval, aptr, FlexValue_getModuleTag(fv)->subid);
		return;
	}

	// �����_�֐��������I�Ɏ��L���v�`�����X�g�𗬂�����
	// prmstk �͂����� ManagedVarData �����L���Ȃ�
	void importCaptures(vector_t const& captured)
	{
		assert(hasFinalized());
		assert(prminfo_.cntCaptures() == captured->size());

		for ( size_t i = 0; i < captured->size(); ++ i ) {
			auto const vardata = peekCaptureAt(i);
			auto const& iter = captured->at(i);

			assert(!vardata->pval);
			*vardata = { iter.getPVal(), iter.getAptr() };
		}
		return;
	}

	// push final parameters
	void finalize()
	{
		assert(!hasFinalized());
		
		// �c��̐��������������ς�
		for ( size_t i = cntArgs(); i < prminfo_.cntPrms(); ++i ) {
			pushArgByDefault();
		}

		// captures (only allocating)
		for ( size_t i = 0; i < prminfo_.cntCaptures(); ++i ) {
			super_t::pushPVal(nullptr, 0);
		}

		// locals
		for ( size_t i = 0; i < prminfo_.cntLocals(); ++i ) {
			PVal* const pval = super_t::allocLocal();
			hpimod::PVal_init(pval, HSPVAR_FLAG_INT);
		}

		// flex
		if ( prminfo_.isFlex() ) {
			vector_t* const vec = allocValue<vector_t>();
			new(vec)vector_t {};
		}

		finalized_ = true;
		return;
	}

	//------------------------------------------------
	// �������l�̓��I�� push
	//------------------------------------------------

	// push (prmtype) byVal
	void pushArgByVal(PDAT const* pdat, vartype_t vtype)
	{
		int const prmtype = getNextPrmType();

		if ( PrmType::isNativeVartype(prmtype) ) {
			if ( vtype != prmtype ) puterror(HSPERR_TYPE_MISMATCH);

			switch ( prmtype ) {
				case HSPVAR_FLAG_LABEL:  return pushValue<label_t>(pdat);
				case HSPVAR_FLAG_DOUBLE: return pushValue<double >(pdat);
				case HSPVAR_FLAG_INT:    return pushValue<int    >(pdat);
				case HSPVAR_FLAG_STR:    return pushString(VtTraits<str_tag>::derefValptr(pdat));
				default: assert(false);
			}

		} else if ( prmtype == PrmType::Any ) {
			return pushAnyByVal(pdat, vtype);

		} else {
			// �g���^ => �^�`�F�b�N�t�� any
			if ( PrmType::isExtendedVartype(prmtype) ) {
				if ( vtype != prmtype ) puterror(HSPERR_TYPE_MISMATCH);
				return pushAnyByVal(pdat, vtype);
			}
			puterror((PrmType::isRef(prmtype) ? HSPERR_VARIABLE_REQUIRED : HSPERR_ILLEGAL_FUNCTION));
		}
	}

	// push (prmtype) byRef
	void pushArgByRef(PVal* pval, APTR aptr)
	{
		int const prmtype = getNextPrmType();

		switch ( prmtype ) {
			case PrmType::Var:    pushPVal(pval, aptr); break;
			case PrmType::Array:  pushPVal(pval); break;
			case PrmType::Any:    pushAnyByRef(pval, aptr); break;
			case PrmType::Modvar: pushThismod(pval, aptr); break;
			default:
				puterror(HSPERR_ILLEGAL_FUNCTION);
		}
	}

	void pushArgByDefault()
	{
		int const prmtype = getNextPrmType();

		switch ( prmtype ) {
			case HSPVAR_FLAG_LABEL:  puterror(HSPERR_LABEL_REQUIRED);
			case HSPVAR_FLAG_STRUCT: puterror(HSPERR_STRUCT_REQUIRED);

			case HSPVAR_FLAG_INT:
			case PrmType::Any:
			{
				static int const zero = 0;
				pushArgByVal(VtTraits<int>::asPDAT(&zero), HSPVAR_FLAG_INT);
				break;
			}
			default:
#if 0
				// �^�^�C�v�l�̈��� => ���̌^�̊���l
				if ( PrmType::isVartype(prmtype) ) {
					PVal* const pvalDefault = hpimod::PVal_getDefault(prmtype);
					pushArgByVal(pvalDefault->pt, pvalDefault->flag);
					break;
				}
#endif
				puterror((PrmType::isRef(prmtype) ? HSPERR_VARIABLE_REQUIRED : HSPERR_NO_DEFAULT));
		}
	}

	// �s��������
	void allocArgNoBind(unsigned short magiccode, unsigned short priority)
	{
		int const prmtype = getNextPrmType();
		size_t const size = PrmType::sizeOf(prmtype);
		assert(size >= sizeof(int));

		int* const p = static_cast<int*>(allocBlank(size));
		*p = MAKELONG(priority, magiccode);
		return;
	}

	//------------------------------------------------
	// �������l�� peek �e��
	//------------------------------------------------
	
	// �l or any(byVal)
	// local ��Q�Ɠn�������̒l�͎��o���Ȃ��B
	PDAT* peekValArgAt(size_t idx, vartype_t& vtype) const
	{
		int const prmtype = prminfo_.getPrmType(idx);
		auto const ptr = getArgPtrAt(idx);
		if ( PrmType::isNativeVartype(prmtype) ) {
			vtype = prmtype;
			return ( prmtype == HSPVAR_FLAG_STR )
				? VtTraits<str_tag>::asPDAT(*reinterpret_cast<char**>(ptr))
				: reinterpret_cast<PDAT*>(ptr);

		} else if ( PrmType::isExtendedVartype(prmtype) || prmtype == PrmType::Any || prmtype == PrmType::Var ) {
			auto& vardata = *reinterpret_cast<MPVarData*>(getArgPtrAt(idx));
			assert(vardata.aptr <= 0);
			vtype = vardata.pval->flag;
			return vardata.pval->pt;

		} else {
			puterror(HSPERR_TYPE_MISMATCH);
		}
	}

	// �ϐ�
	PVal* peekRefArgAt(size_t idx) const
	{
		int const prmtype = prminfo_.getPrmType(idx);
		switch ( prmtype ) {
			case PrmType::Var:
			case PrmType::Array:
			case PrmType::Any:
			{
				auto& vardata = *reinterpret_cast<MPVarData*>(getArgPtrAt(idx));
				assert(vardata.aptr >= 0);
				vardata.pval->offset = vardata.aptr;
				return vardata.pval;
			}
			case PrmType::Modvar:
			{
				auto& thismod = *reinterpret_cast<MPModVarData*>(getArgPtrAt(idx));
				assert(thismod.magic == MODVAR_MAGICCODE);
				thismod.pval->offset = thismod.aptr;
				return thismod.pval;
			}
			case PrmType::Local:
				return peekLocalAt(idx - prminfo_.cntPrms());

			default: puterror(HSPERR_VARIABLE_REQUIRED);
		}
	}

	ManagedVarData peekAnyAt(size_t idx) const
	{
		assert( idx < cntArgs() );
		assert(prminfo_.getPrmType(idx) == PrmType::Any);
		return ManagedVarData { *reinterpret_cast<MPVarData*>(getArgPtrAt(idx)) };
	}

	MPVarData* peekCaptureAt(size_t idx) const
	{
		assert(hasFinalized());
		return reinterpret_cast<MPVarData*>(getOffsetPtr(prminfo_.getStackOffsetCapture(idx)));
	}
	PVal* peekLocalAt(size_t idx) const
	{
		assert(hasFinalized());
		return reinterpret_cast<PVal*>(getOffsetPtr(prminfo_.getStackOffsetLocal(idx)));
	}
	vector_t* peekFlex() const
	{
		return ( prminfo_.isFlex() && hasFinalized() ) 
			? reinterpret_cast<vector_t*>(getOffsetPtr(prminfo_.getStackOffsetFlex()))
			: nullptr;
	}

private:
	//------------------------------------------------
	// prmstk ��ւ̃|�C���^
	//------------------------------------------------
	void* getOffsetPtr(size_t offset) const {
		assert(offset <= size());
		return &reinterpret_cast<char*>(getptr())[ offset ];
	}
	void* getArgPtrAt(size_t idx) const
	{
		assert(idx < cntArgs());
		return getOffsetPtr(prminfo_.getStackOffsetParam(idx));
	}

	//------------------------------------------------
	// ���
	//
	// @ �������̎��o���̓r���Ŏ��S���邱�Ƃ�����̂Œ��ӂ������B
	//------------------------------------------------
	void free()
	{
		void* const prmstk = getPrmStkPtr();
		assert(!!prmstk);

		// �X�^�b�N��̊Ǘ����ꂽ�I�u�W�F�N�g���������
		for ( size_t i = 0; i < cntArgs(); ++i ) {
			int const prmtype = prminfo_.getPrmType(i);

			switch ( prmtype ) {
				case HSPVAR_FLAG_STR:
				{
					vartype_t vtype;
					auto const p = VtTraits<str_tag>::derefValptr(peekValArgAt(i, vtype));
					assert(!!p && vtype == HSPVAR_FLAG_STR);
					hspfree(p);
					break;
				}
				case PrmType::Any:
				{
					auto&& pval = ManagedPVal::ofValptr(peekRefArgAt(i));
					pval.decRef();
					break;
				}
			}
		}
		if ( hasFinalized() ) {
			for ( size_t i = 0; i < prminfo_.cntCaptures(); ++i ) {
				ManagedPVal::ofValptr(peekCaptureAt(i)->pval).decRef();
			}
			for ( size_t i = 0; i < prminfo_.cntLocals(); ++i ) {
				PVal_free(peekLocalAt(i));
			}
			if ( vector_t* const flex = peekFlex() ) {
				flex->decRef();
			}
		}

		hspfree(prmstk);
	}
};

#endif
