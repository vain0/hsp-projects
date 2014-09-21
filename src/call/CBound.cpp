// �����֐��N���X
#if 0
#include <map>
#include <vector>
#include <queue>

#include "CBound.h"

#include "CCall.h"
#include "CCaller.h"
#include "CPrmInfo.h"

using namespace hpimod;

template<class TLhs, class TRhs>
struct LessOfPairLhsPriority	// for createRemains() : �u���ӂ�D��x�Ƃ���΂̔�r "<"�v
	: public std::binary_function< std::pair<TLhs, TRhs>, std::pair<TLhs, TRhs>, int >
{
	typedef const std::pair<TLhs, TRhs>& prm_t;
	bool operator ()( prm_t lhs, prm_t rhs ) const {		// lhs �̕������������H
		return (lhs.first != rhs.first) ? lhs.first > rhs.first : lhs.second > rhs.second;
	}
};

// �ÓI�ϐ�
//static std::vector<bound_t> g_allBounds;	// �����֐��̎��̌Q

//------------------------------------------------
// �\�z (���b�p�[)
//------------------------------------------------
bound_t CBound::New()
{
	return new CBound();
}

//------------------------------------------------
// �\�z
//------------------------------------------------
CBound::CBound()
	: IFunctor()
	, mpCaller( new CCaller( CCaller::CallMode::Bind ) )
	, mpPrmIdxAssoc( new prmidxAssoc_t() )
{}

//------------------------------------------------
// �j��
//------------------------------------------------
CBound::~CBound()
{
	delete mpCaller;      mpCaller      = nullptr;
	delete mpRemains;     mpRemains     = nullptr;
	delete mpPrmIdxAssoc; mpPrmIdxAssoc = nullptr;
	return;
}

//------------------------------------------------
// �����ݒ�
//------------------------------------------------
void CBound::bind()
{
	createRemains();
	return;
}

//------------------------------------------------
// �����֐��̉��������X�g�𐶐�����
// 
// @ �O����̂ݑ����ł���B
//------------------------------------------------
void CBound::createRemains()
{
	CCaller const&  callerBinder = *mpCaller;
	CCall const&    callBinder   = callerBinder.getCall();
	CPrmInfo const& srcPrminfo   = callBinder.getPrmInfo();

	int const cntPrms = srcPrminfo.cntPrms();
	int const cntArgs = callerBinder.getCall().getCntArg();
//	dbgout("(prms, args) = (%d, %d) -> %d", cntPrms, cntArgs, cntPrms - cntArgs );

	// ���������X�g����c�������X�g�𐶐�����
	CPrmInfo::prmlist_t prmlist;

	auto const addRemainPrm = [&]( int i ) {		// ���̉����� [i] ���c�����Ƃ��Ēǉ�����֐�
		mpPrmIdxAssoc->push_back( i );
		prmlist.push_back( srcPrminfo.getPrmType( i ) );
	};

	{
		// �s�������� (�������w�肳�ꂽ���̂̂����Anobind �ł������)
		{
			// [��₱�����̂ŏڍ׃���]
			// @ todo: argbind() �̈����ɕs�������� nobind ���w�肳��Ă�����̂��������A
			// @	�����D�揇�ɕ��בւ���B
			// @	�����āA�D��l�̒Ⴂ���̂����ɁA�c�������X�g�ɒǉ�����B
			// @	�D��l���������ꍇ�́A���X�̈����ԍ������������ɒǉ�����B
			// @ impl: �� < int �D��l, int �����ԍ� > ��v�f�Ƃ���D��x�t���L���[ argNobind ��
			// @	���ׂĂ̕s����������ǉ�����B
			// @	�D��x�t���L���[����l������ pop ����ƁA�����ԍ����D�揇 (�D��l�̏�������) �œ�����B
			// @	( �L���[�̗D��x�́A�΂̍���(�D��x)�̑傫���Ō��܂�; �悤�� LessOfPairLhsPriority<> ���������� )
			// @	( std::priority_queue<T> �͍~��(�D��x�̍�����)�œ����� )

			typedef std::pair<int, int> thePair_t;
			std::priority_queue< thePair_t, std::vector<thePair_t>, LessOfPairLhsPriority<int, int>>
				argsNobind;		// �s�����������X�g 

			for ( int i = 0; i < cntArgs; ++ i ) {
				if ( callBinder.isArgSkipped(i) ) {
					// < �D��l, �������ł̈����ԍ� >
					argsNobind.push({ callBinder.getArgAptr(i), i });
				//	dbgout("nobind-arg; push (%d, %d)", callBinder.getArgAptr(i), i);
				}
			}

			while ( !argsNobind.empty() ) {
			//	dbgout("nobind-arg; pop (%d, %d)", argsNobind.top().first, argsNobind.top().second);
				addRemainPrm( argsNobind.top().second );
				argsNobind.pop();
			}
		}

		// �㔼���� (�������̂����A�������Ƃ��s�����Ƃ��w�肳��Ȃ���������)
		for ( int i = cntArgs; i < cntPrms; ++ i ) {
			addRemainPrm( i );
	//		dbgout("remain #%d : %d", i, srcPrmInfo().getPrmType(i) );
		}
	}

	// �����o�ϐ��ɐݒ肷��
	mpRemains = new CPrmInfo( &prmlist, srcPrminfo.isFlex() );

	return;
};

//------------------------------------------------
// �Ăяo������
// 
// @ caller �̈����� mpCaller �̈������܂Ƃ߂āA
// @	�V���ɐ������� CCaller �Ŕ푩���֐����Ăяo���B
// @prm callerRemain:
// @	{ functor: this, args: this.remains }
// @	�����֐��̌Ăяo���̂��߂ɁA�O���Ő������ꂽ����
//------------------------------------------------
void CBound::call( CCaller& callerRemain )
{
	CCall& callBinder = mpCaller->getCall();
	CCall& callRemain = callerRemain.getCall();

	CCaller caller;
	{
		caller.setFunctor( callBinder.getFunctor() );	// �푩���֐�

		// �����̏���
		{
			size_t const cntPrmsBinder = callBinder.getPrmInfo().cntPrms();	// �푩���֐��̉������̐�
			size_t const cntArgsBinder = callBinder.getCntArg();
			size_t const cntArgsRemain = callRemain.getCntArg();
			size_t const cntPrmsAll    = cntArgsBinder;	// �푩���֐��ɗ^������������̐� (�ϕ�������)
			
			// �ŏI�I�ɔ푩���֐��ɗ^������������X�g (�ϕ��͌�Ŋg��)
			std::vector< std::pair<PVal*, APTR> >
				argsAll( std::max(cntPrmsBinder, cntPrmsAll) );

			// ����������ǉ� (mpCaller �����������Q�Ɠn������)
			for ( size_t i = 0; i < cntArgsBinder; ++ i ) {
				if ( callBinder.isArgSkipped(i) ) continue;
				PVal* const pval = callBinder.getArgPVal(i);
				APTR  const aptr = callBinder.getArgAptr(i);

			//	dbgout("set #%d", i);
				argsAll[i] = { pval, aptr };
			}

			// �]�������ǉ� (callerRemain �����������Q�Ɠn������)
			for ( size_t i = 0; i < cntArgsRemain; ++ i ) {
				if ( callRemain.isArgSkipped(i) ) continue;
				PVal* const pval = callRemain.getArgPVal(i);
				APTR  const aptr = callRemain.getArgAptr(i);
			//	dbgout("aptr = %d", aptr);
				auto const&& elem = std::make_pair(pval, aptr);

				// �s���������𖄂߂���� (�c�����̈ꕔ)
				if ( i < mpPrmIdxAssoc->size() ) {
					// mpPrmIdxAssoc: �c�����̈����ԍ����푩���֐��̉������̈����ԍ�
					argsAll[ mpPrmIdxAssoc->at(i) ] = std::move(elem);

				// �ϒ������̒ǉ�����
				} else {
					argsAll.push_back( std::move(elem) );
				}
			}

			// ������������Q�Ɠn���Œǉ�����
			for ( size_t i = 0; i < argsAll.size(); ++ i ) {
				caller.addArgByRef( argsAll[i].first, argsAll[i].second );
			}
		}

		// �Ăяo��
		caller.call();

		// �Ԓl�� callerRemain �ɓ]������
		callRemain.setRetValTransmit( caller.getCall() );
	}
	return;
}

//------------------------------------------------
// ��������
// 
// @ �푩���֐��������֐��Ȃ炻�� unbind() ��ԋp����B
// @	�����łȂ���Δ푩���֐���ԋp����B
//------------------------------------------------
functor_t const& CBound::unbind() const
{
	auto&      bound  = getBound();
	auto const casted = bound.castTo<bound_t>();

	if ( !casted ) {
		return bound;
	} else {
		return casted->unbind();
	}
}

//------------------------------------------------
// �푩���֐�
//------------------------------------------------
functor_t const& CBound::getBound() const
{
	return mpCaller->getCall().getFunctor();
}


//------------------------------------------------
// 
//------------------------------------------------

//------------------------------------------------
// 
//------------------------------------------------

#endif
