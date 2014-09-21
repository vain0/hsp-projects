// �����_�֐��N���X
#if 0
#include <map>
#include <vector>
#include <queue>

#include "CLambda.h"

#include "CCall.h"
#include "CCaller.h"
#include "Functor.h"

#include "CHspCode.h"

#include "iface_call.h"
#include "cmd_sub.h"

using namespace hpimod;

static void* GetReferedPrmstk(stprm_t pStPrm);

// �ÓI�ϐ�
//static std::vector<lambda_t> g_allLambdas;	// �����֐��̎��̌Q

//------------------------------------------------
// �\�z (���b�p�[)
//------------------------------------------------
myfunc_t CLambda::New()
{
	return new CLambda();
}

//------------------------------------------------
// �\�z
//------------------------------------------------
CLambda::CLambda()
	: IFunctor()
	, mpBody(nullptr)
	, mpPrmInfo(nullptr)
	, mpArgCloser(nullptr)
{
#ifdef DBGOUT_MY_FUNC_ADDREF_OR_RELEASE
	static int stt_id = 0; mid = ++ stt_id;
#endif
}

//------------------------------------------------
// �������ۑ��I�u�W�F�N�g�̎擾
//------------------------------------------------
CCaller* CLambda::argCloser()
{
	if ( !mpArgCloser ) mpArgCloser.swap( std::make_unique<CCaller>());
	return mpArgCloser.get();
}

//------------------------------------------------
// ���������X�g���擾����
//------------------------------------------------
CPrmInfo const& CLambda::getPrmInfo() const
{
	return (mpPrmInfo ? *mpPrmInfo : CPrmInfo::undeclaredFunc);
}

//------------------------------------------------
// ���x�����擾����
// 
// @ �R�[�h��ǉ�����ƁA���x�����ύX����邩������Ȃ��B
//------------------------------------------------
label_t CLambda::getLabel() const
{
	return (mpBody ? mpBody->getlb() : nullptr);
}

//------------------------------------------------
// �Ăяo������
// 
// @ �֐����Ăяo�� or ���s���ĊJ����B
//------------------------------------------------
void CLambda::call( CCaller& callerGiven )
{
	label_t   const lbDst   = getLabel();
//	CPrmInfo const& prminfo = getPrmInfo();

#if 0
	{// �{�̃R�[�h�̗�
		label_t mcs = lbDst;
		int _t, _v, _e;

		for ( int i = 0; ; ++ i ) {
			unsigned short a = *(mcs ++);
			_e = a & (EXFLG_0 | EXFLG_1 | EXFLG_2);
			_t = a & CSTYPE;
			if ( a & 0x8000 ) {
				_v = *(int*)mcs;
				mcs += 2;
			} else {
				_v = (int)*(mcs ++);
			}

			dbgout("code #%d (%d, %d, %X)", i, _t, _v, _e );
			if ( _t == TYPE_STRUCT ) {
				stprm_t const prm = &ctx->mem_minfo[_v];
				dbgout( "subid id: %d, mptype: %d", (int)prm->subid, (int)prm->mptype );
			}
			if ( i != 0 && _e & EXFLG_1 ) break;
		}
	}
#endif

	callerGiven.setFunctor( lbDst );

	// �ۑ����ꂽ�������ǉ�����
	if ( mpArgCloser ) {
		auto& callCloser = mpArgCloser->getCall();
		for ( size_t i = 0; i < callCloser.getCntArg(); ++ i ) {
			callerGiven.addArgByRef( callCloser.getArgPVal(i), callCloser.getArgAptr(i) );
		}
	}

	// �Ăяo��
	callerGiven.call();
	return;
}

//------------------------------------------------
// �X�N���v�g���� myfunc ��������
// 
// @ �������̒��ԃR�[�h�𕡎ʁB
// @ �����G�C���A�X�͎Q�Ƃł���悤�ɂ���B
// @ ( �����������Ȃ̂Ń����o�֐��ɂ������A�����ł����̂��� )
// @ ���s����铽���֐��� prmstk ��
// @	(lambda�֐��̈�����), (�L���v�`�����ꂽ�ϐ��̗�), (���Ԍv�Z�l�������[�J���ϐ���)
// @ �Ƃ�����ɂȂ�B
//------------------------------------------------
void CLambda::code_get()
{
	{
		// ������̏������͋�����Ȃ�
		assert(!mpBody);
		mpBody.swap(std::make_unique<CHspCode>());
	}
	CHspCode& body  = *mpBody;
	int&      exflg = *exinfo->npexflg;

	// �������A���[�J���ϐ��̌�
	size_t cntPrms   = 0;		
	size_t cntLocals = 0;
	
	// �u�L���v�`�����ꂽ�ϐ��v���Q�Ƃ���R�[�h�̈ʒu (��ŏC�����邽�߂Ɉʒu���L������)
	std::vector<std::pair<stprm_t, label_t>> outerArgs;

	// ��p�̖��߃R�}���h��z�u
	body.put( g_pluginType_call, CallCmd::Id::lambdaBody_, EXFLG_1 );
	
	// �����R�s�[����
	for ( int lvBracket = 0; ; ) {		
		if ( *type == TYPE_MARK ) {
			if ( *val == '(' ) lvBracket ++;
			if ( *val == ')' ) lvBracket --;
			if ( lvBracket < 0 ) break;
		}

		// �֐��{�̂̎��ɒǉ�����
		if ( lvBracket == 0 && exflg & EXFLG_2 ) {
			cntLocals++;	// ��������������A�܂肱�̈������͒��Ԍv�Z�l
		}
	//	dbgout("put (%d, %d, %X)", *type, *val, exflg );

		if ( *type == TYPE_STRUCT ) {
			// �\���̃p�����[�^�����ۂɎw���Ă���l���R�[�h�ɒǉ�����
			auto const pStPrm = getSTRUCTPRM(*val);
			char* const prmstk = (char*)GetReferedPrmstk(pStPrm);

			// ������W�J
			{
				char* const ptr    = prmstk + pStPrm->offset;
				int   const mptype = pStPrm->mptype;

				switch ( mptype ) {
					case MPTYPE_VAR:
					case MPTYPE_ARRAYVAR:
						return body.putVar( reinterpret_cast<MPVarData*>(ptr)->pval );

					case MPTYPE_LABEL:       return body.putVal( *reinterpret_cast<label_t*>(ptr) );
					case MPTYPE_LOCALSTRING: return body.putVal( *reinterpret_cast<char**>(ptr) );
					case MPTYPE_DNUM: return body.putVal( *reinterpret_cast<double*>(ptr) );
					case MPTYPE_INUM: return body.putVal( *reinterpret_cast<int*>(ptr) );

					case MPTYPE_SINGLEVAR:
					case MPTYPE_LOCALVAR:
					{
						auto const capturer = argCloser();

						// �ϐ��v�f�́A���e�����l�ŋL�q�ł��Ȃ��̂ŁAlambda�֐��� prmstk �ɏ悹�邽�߂ɕۑ�����
						if ( mptype == MPTYPE_SINGLEVAR ) {
							auto const vardata = reinterpret_cast<MPVarData*>(ptr);
							capturer->addArgByRef( vardata->pval, vardata->aptr );

						// ���[�J���ϐ��́A���s���ɏ��ł��邩���Ȃ̂ŃR�s�[�����
						} else {
							auto const pval = reinterpret_cast<PVal*>(ptr);
							capturer->addArgByVarCopy( pval );
						}

						// �L���v�`���������̂��L�^���Ă���
						outerArgs.push_back({ pStPrm, body.getlbNow() });
						body.put( TYPE_STRUCT, -1, exflg );
						// @ ���ꂪ lamda �֐��̉��Ԗڂ̎������ɂȂ邩�́A�������̐����m�肷��܂ŕ�����Ȃ�
						// @ short �ł͎��܂�Ȃ��l�����Ȃ̂ŁA(-1 �ɂ���) int �T�C�Y���g�p����
						break;
					}
					default: dbgout("mptype = %d", mptype );
						break;
				}
			}
			code_next();

		} else if ( *type == g_pluginType_call && *val == CallCmd::Id::call_prmOf_ ) {
			// �������v���[�X�z���_ [ call_prmof ( (�����ԍ�) ) ]
			int const exflg_here = exflg;
			code_next();
			 
			if ( !code_next_expect( TYPE_MARK, '(' ) ) puterror( HSPERR_SYNTAX );

			int const iPrm = code_geti();
			if ( iPrm < 0 ) puterror(HSPERR_ILLEGAL_FUNCTION);

			if ( !code_next_expect( TYPE_MARK, ')' ) ) puterror( HSPERR_SYNTAX );

			// �������̐����m��
			cntPrms = std::max<size_t>(cntPrms, iPrm + 1);

			// �Ή���������������o���R�[�h�uargv(n)�v���o��
			body.put( g_pluginType_call, CallCmd::Id::argVal, exflg_here );
			body.put( TYPE_MARK, '(', 0 );
			body.putVal( iPrm );
			body.put( TYPE_MARK, ')', 0 );

		} else if ( *type == g_pluginType_call && *val == CallCmd::Id::lambda ) {
			// lambda �֐�
			// @ ����̓����ɂ���\���̃p�����[�^�≼�����v���[�X�z���_�����͖������邽�߂ɁA��������P�����ʂ���
			body.put( *type, *val, exflg );
			code_next();

			if ( *type == TYPE_MARK && *val == '(' ) {
				for ( int lvBracket = 0; ; ) {		// �������[�v
					if ( *type == TYPE_MARK ) {
						if ( *val == '(' ) lvBracket ++;
						if ( *val == ')' ) lvBracket --;
					}
					body.put( *type, *val, exflg );
					code_next();
					if ( lvBracket == 0 ) break;
				}
			}

		} else {
			// (���̑�)
			body.put( *type, *val, exflg );
			code_next();
		}
	}

//	if ( exflg & EXFLG_2 ) puterror( HSPERR_TOO_MANY_PARAMETERS );

	// �R�[�h�̐�ǂ݂ɂ��I�[�o�[������h�����߂̔ԕ�
	body.putReturn();	
	body.putReturn();

	// lambda �֐����ĂԂ��߂̉��������X�g�̍\�z
	// ���� prmlist �Ƃ͋��p���Ȃ� (�L���v�`���ϐ��Ȃǂ������Ɏw��ł��Ă��܂�����)�B
	{
		CPrmInfo::prmlist_t prmlistBase(cntPrms, PrmType::Any);

		assert(!mpPrmInfo);
		mpPrmInfo.swap(std::make_unique<CPrmInfo>(&prmlistBase));
	}

	// �������� lamda �̖{�� call ����Ƃ��̉��������X�g�̍\�z
	{
		// �������`���F�ulambda����(_pN) + �L���v�`���ϐ� + ���[�J���ϐ�(_vN)�v
		// @ ���ׂĉϒ������ŏ����������Ƃ��낾���Aprmstack �ɐς܂Ȃ��Ⴂ���Ȃ��̂� (���[�J���ϐ���ςނȂ�ϒ������͐ς߂Ȃ��A�ς�ł��܂��� local �ɃG�C���A�X�ŃA�N�Z�X�ł��Ȃ�)

		CPrmInfo::prmlist_t prmlist;
		prmlist.resize(cntPrms + outerArgs.size() + cntLocals);

		// lamda ����
		std::fill(prmlist.begin(), prmlist.begin() + cntPrms, PrmType::Any);

		// �L���v�`���l
		for ( size_t i = 0; i < outerArgs.size(); ++i ) {
			prmlist.push_back(
				(outerArgs[cntPrms + i].first->mptype == MPTYPE_SINGLEVAR)
				? PrmType::Var
				: PrmType::Array
			);
		}

		// ���[�J���ϐ�
		std::fill(prmlist.end() - cntLocals, prmlist.end(), PrmType::Local);

		DeclarePrmInfo(body.getlb(), CPrmInfo(&prmlist, true));
	}

	// �����_�����Ɋ܂܂��A�u�L���v�`���ϐ����Q�Ƃ��Ă��� TYPE_STRUCT �R�[�h�v�� code �l��⊮����
	{
		// lamda �����̌��
		int offset = sizeof(MPVarData) * cntPrms;

		for ( size_t i = 0; i < outerArgs.size(); ++ i ) {
			*(int*)(outerArgs[i].second + 1) = body.putDsStPrm(
				STRUCTPRM_SUBID_STACK,
				((outerArgs[i].first->mptype) == MPTYPE_SINGLEVAR ? MPTYPE_SINGLEVAR : MPTYPE_ARRAYVAR),
				offset
			);
			offset += sizeof(MPVarData);
		}
	}
	return;
}

//------------------------------------------------
// �\���̃p�����[�^���Q�Ƃ��Ă��� prmstk ��(���݂̏�񂩂�)�擾����
// 
// @result: prmstk �̈�ւ̃|�C���^ (���s => nullptr)
//------------------------------------------------
void* GetReferedPrmstk(stprm_t stprm)
{
	void* const cur_prmstk = ctx->prmstack;
	if ( !cur_prmstk ) return nullptr;

	if ( stprm->subid == STRUCTPRM_SUBID_STACK ) {		// ������
		return cur_prmstk;

	} else if ( stprm->subid >= 0 ) {	// �����o�ϐ�
		auto const thismod = reinterpret_cast<MPModVarData*>(cur_prmstk);
		return reinterpret_cast<FlexValue*>(PVal_getptr(thismod->pval, thismod->aptr))->ptr;
	}

	return nullptr;
}
//------------------------------------------------
// 
//------------------------------------------------

//------------------------------------------------
// 
//------------------------------------------------


#endif
