// CCaller
#if 0
#include <map>

#include "iface_call.h"		// for plugin-type, CallCmd::Id
#include "cmd_sub.h"

#include "hsp3plugin_custom.h"
#include "mod_argGetter.h"
#include "mod_makepval.h"

#include "CCaller.h"
#include "CCall.h"
#include "CPrmInfo.h"

#include "Functor.h"
#include "CBound.h"

using namespace hpimod;

static std::stack<CCall*> g_stkCall;

//------------------------------------------------
// �\�z
// 
// @ �Ăяo���J�n�O
//------------------------------------------------
CCaller::CCaller()
	: CCaller( CallMode::Proc )
{ }

CCaller::CCaller( CallMode mode )
	: mpCall( new CCall )
	, mMode ( mode )
{ }

//------------------------------------------------
// call
//------------------------------------------------
void CCaller::call(void)
{
	// ����Ȃ�������₤
	mpCall->completeArg();

	// �Ǝ���Call�X�^�b�N�ɐς�
	g_stkCall.push( mpCall.get() );

	// �Ăяo��
	mpCall->call( *this );

	// �Ǝ���Call�X�^�b�N����~�낷
	if ( g_stkCall.empty() ) puterror(HSPERR_STACK_OVERFLOW);
	g_stkCall.pop();
	return;
}

//------------------------------------------------
// �W�����v���ݒ肷��
// 
// @ ���ԃR�[�h�̎����瓾��
//------------------------------------------------
void CCaller::setFunctor()
{
	functor_t&& functor = code_get_functor();
	setFunctor( functor );
	return;
}

//------------------------------------------------
// �W�����v���ݒ肷��
// 
// @ functor_t ��p����
//------------------------------------------------
void CCaller::setFunctor( functor_t const& functor )
{
	mpCall->setFunctor( functor );
	return;
}

//------------------------------------------------
// ���ׂĂ̈��������o���Ēǉ�����
//------------------------------------------------
void CCaller::setArgAll()
{
	// ���������ׂĎ��o��
	while ( setArgNext() )
		;
	return;
}

//------------------------------------------------
// ���̈�������擾���A�ǉ����� [���ԃR�[�h]
// 
// @result: ���������o�������H
//------------------------------------------------
bool CCaller::setArgNext()
{
	if ( !code_isNextArg() ) return false;	// �����������Ȃ� (�������� or ')' ��) �ꍇ

	// ���̈�����1�擾����
	int const prmtype = mpCall->getPrmType( mpCall->getCntArg() );

	// �s�������� (nobind)
	if ( *type == g_pluginType_call && *val == CallCmd::Id::noBind ) {
		if ( mMode != CallMode::Bind ) puterror( HSPERR_ILLEGAL_FUNCTION );
		code_next();

		int priority = 0;		// (����: 0)

		if ( *type == TYPE_MARK && *val == '(' ) {
			// () ����
			code_next();

			priority = code_getdi( priority );	// �ȗ���

			if ( !code_next_expect( TYPE_MARK, ')') ) puterror( HSPERR_TOO_MANY_PARAMETERS );

		} else {
			// () �Ȃ� => �����̎��o���̊�������������
			if ( *exinfo->npexflg & EXFLG_2 ) {
				*exinfo->npexflg &= ~EXFLG_2;	// ���������o����

			// nobind �̌�ɋ��e�ł��Ȃ�����������
			} else if ( code_isNextArg() ) {
				puterror( HSPERR_SYNTAX );	
			}
		}

		mpCall->addArgSkip( std::max(priority + 0xFF00, 0) );			// �o�C�A�X�������Đ����ɂ���

	// �Q�Ɠn�� (����: byref or bythismod)
	} else if ( *type == g_pluginType_call && (*val == CallCmd::Id::call_byRef_ || *val == CallCmd::Id::call_byThismod_) ) {
		code_next();

		// [ call_byref || var ]
		PVal* const pval = code_get_var();

		if ( !code_next_expect( TYPE_MARK, CALCCODE_OR ) ) puterror( HSPERR_SYNTAX );

		mpCall->addArgByRef( pval );

	// �Q�Ɠn�� (�������Ɋ�Â�)
	} else if ( PrmType::isRef(prmtype) ) {
		PVal* pval;

		switch ( prmtype ) {
			case PrmType::Array:  pval = code_getpval(); break;
			case PrmType::Var:    //
			case PrmType::Modvar: pval = code_get_var(); break;
			default:
				puterror( HSPERR_SYNTAX );
		}

		mpCall->addArgByRef( pval );

	// �l�n��
	} else {
		int const iArg = mpCall->getCntArg();

		int prm;

		// �����ȗ� (����)
		if ( *type == g_pluginType_call && *val == CallCmd::Id::byDef ) {
			code_next();
			prm = PARAM_DEFAULT;

		} else {
			// ���̈���
			prm = code_getprm();
			if ( prm == PARAM_END || prm == PARAM_ENDSPLIT ) return false;
		}

		{
			PVal* const pval = ( prm == PARAM_DEFAULT )
				? ( mpCall->getDefaultArg( iArg ) )				// �ȗ���
				: mpval;

			mpCall->addArgByVal( pval );
		}

		// �������ɏ]���Č^�`�F�b�N
		{
			PVal* const pval = mpCall->getArgPVal(iArg);		// mpCall �ɒǉ����ꂽ�ϐ�

			//*
			// (���}���u) double �� int ������ : ��ɏC�����ׂ�
			if ( mpCall->getPrmInfo().getPrmType( iArg ) == HSPVAR_FLAG_DOUBLE
				&& pval->flag == HSPVAR_FLAG_INT
			) {
				double value = *(int*)pval->pt;
				code_setva( pval, 0, HSPVAR_FLAG_DOUBLE, &value );
			}
			//*/

			mpCall->checkCorrectArg( pval, iArg );		// mpCall �ɒǉ�����O�ɂ��������ǂ�
		}
	}

	return true;
}

//------------------------------------------------
// �l�n��������ǉ�����
// 
// @ �^�`�F�b�N�Ȃǂ��Ȃ��̂Œ���
//------------------------------------------------
void CCaller::addArgByVal( void const* val, vartype_t vt )
{
	return mpCall->addArgByVal( val, vt );
}

//------------------------------------------------
// �Q�Ɠn��������ǉ�����
// 
// @ �^�`�F�b�N�Ȃǂ��Ȃ��̂Œ���
//------------------------------------------------
void CCaller::addArgByRef( PVal* pval )
{
	return addArgByRef( pval, pval->offset );
}

void CCaller::addArgByRef( PVal* pval, APTR aptr )
{
	return mpCall->addArgByRef( pval, aptr );
}

//------------------------------------------------
// �ϐ�����������ǉ�����
//------------------------------------------------
void CCaller::addArgByVarCopy( PVal* pval )
{
	return mpCall->addArgByVarCopy( pval );
}

//##########################################################
//    �擾
//##########################################################
//------------------------------------------------
// �Ԓl���擾����
// 
// @ �Ăяo���I���̒���ɂ̂ݎg����B
// @ �󂯎�����Ԓl�̃|�C���^�͂����Ɏ��S����댯������B
// @ �Ԓl���Ȃ���� nullptr ���Ԃ�B
//------------------------------------------------
PVal* CCaller::getRetVal() const
{
	return ( ctx->retval_level == (ctx->sublev + 1) )
		? *exinfo->mpval			// return �ɐݒ肳��Ă���ꍇ�A�����D�悷��
		: mpCall->getRetVal();		// call_retval �ɂ���ė^����ꂽ�Ԓl
}

//------------------------------------------------
// call �̕Ԓl���擾����
// 
// @ �ÓI�ϐ��ɕ���(�o�b�N�A�b�v)���Ă��瓾��B
// @ ���� caller ���Ăяo�����I������܂Ŏ��ȂȂ��B
// @prm ppResult : �Ԓl�ւ̎��̃|�C���^���i�[���� void*  �^�̕ϐ��ւ̃|�C���^
// @result       : �Ԓl�̌^�^�C�v�l
//------------------------------------------------
vartype_t CCaller::getCallResult(PDAT** ppResult)
{
	if ( !ppResult ) return HSPVAR_FLAG_NONE;
	*ppResult = nullptr;

	PVal* const pvResult = getRetVal();
	if ( !pvResult ) return HSPVAR_FLAG_NONE;

	// �ŏ��̌Ăяo���̏ꍇ�Astt_respval ������������
	if ( !stt_respval ) {
		stt_respval = reinterpret_cast<PVal*>( hspmalloc(sizeof(PVal)) );
		PVal_init( stt_respval, pvResult->flag );
	}

	// �ÓI�ϐ��ɒl��ۑ����Ă���
	code_setva(
		stt_respval, 0, pvResult->flag,
		PVal_getptr(pvResult)
	);

	*ppResult = PVal_getptr( stt_respval );
	return stt_respval->flag;
}

//------------------------------------------------
// ���O�� call �̕Ԓl��Ԃ�
// @static
//------------------------------------------------
PVal* CCaller::getLastRetVal()
{
	return stt_respval;
}

void CCaller::releaseLastRetVal()
{
	if ( stt_respval ) {
		PVal_free( stt_respval );
		hspfree( stt_respval );
		stt_respval = nullptr;
	}
	return;
}

//##########################################################
//    �O���[�o���ϐ��̏�����
//##########################################################
PVal* CCaller::stt_respval = nullptr;

//##########################################################
//    �������֐�
//##########################################################
//------------------------------------------------
// �����X�^�b�N�̃g�b�v��Ԃ�
// 
// @ �X�^�b�N����Ȃ� nullptr ��Ԃ��B
//------------------------------------------------
CCall* TopCallStack()
{
	if ( g_stkCall.empty() ) return nullptr;

	return g_stkCall.top();
}
#endif