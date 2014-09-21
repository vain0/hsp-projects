#ifndef IG_PARAMETER_TYPE_H
#define IG_PARAMETER_TYPE_H

#include "hsp3plugin_custom.h"

using prmtype_t = int;

extern prmtype_t code_get_prmtype(prmtype_t _default);

namespace PrmType {

//------------------------------------------------
// �������^�C�v (call.hpi �p)
// 
// @ HSPVAR_FLAG_* �ƕ��p�B
// @ None ���������l�B
//------------------------------------------------
static prmtype_t const
	Var     = (-2),		// var   �w�� (�Q�Ɠn���v��)
	Array   = (-3),		// array �w�� (�Q�Ɠn���v��)
	Modvar  = (-4),		// modvar�w�� (�Q�Ɠn���v��)
	Any     = (-5),		// any   �w�� (����Œl�n���v���Abyref �ŎQ�Ɠn�����\)
	Capture = (-6),		// (lambda �������I�ɗp����A�������s�v)
	Local   = (-7),		// local �w�� (�������s�v)
	Flex    = (-1),		// �ϒ�����
	None    = 0;		// ����

//------------------------------------------------
// �ϐ��^�̉������^�C�v��
//------------------------------------------------
static inline bool isNativeVartype(prmtype_t prmtype)
{
	return (HSPVAR_FLAG_NONE < prmtype && prmtype < HSPVAR_FLAG_STRUCT);
}

static inline bool isExtendedVartype(prmtype_t prmtype)
{
	return (HSPVAR_FLAG_STRUCT <= prmtype && prmtype <= HSPVAR_FLAG_USERDEF + ctx->hsphed->max_varhpi);
}

static inline bool isVartype(prmtype_t prmtype)
{
	return isNativeVartype(prmtype) || isExtendedVartype(prmtype);
}

//------------------------------------------------
// �Q�Ɠn���̉������^�C�v��
//
// @ Any �͎Q�Ɠn�������ł͂Ȃ��Ƃ���B
//------------------------------------------------
static bool isRef(prmtype_t prmtype)
{
	return prmtype == PrmType::Var
		|| prmtype == PrmType::Array
		|| prmtype == PrmType::Modvar
		;
}

//------------------------------------------------
// �������^�C�v�� prmstack �ɗv������T�C�Y
//------------------------------------------------
static size_t sizeOf(prmtype_t prmtype)
{
	switch ( prmtype ) {
		case HSPVAR_FLAG_LABEL:  return sizeof(hpimod::label_t);
		case HSPVAR_FLAG_STR:    return sizeof(char*);
		case HSPVAR_FLAG_DOUBLE: return sizeof(double);
		case HSPVAR_FLAG_INT:    return sizeof(int);
		case PrmType::Modvar:    return sizeof(MPModVarData);
		case PrmType::Local:     return sizeof(PVal);

		case PrmType::Var:
		case PrmType::Array:
		case PrmType::Any:
		case PrmType::Capture: return sizeof(MPVarData);
		case PrmType::Flex:    return sizeof(void*);
		default:
			// ���̑��̌^�^�C�v�l
			if ( HSPVAR_FLAG_INT < prmtype && prmtype < (HSPVAR_FLAG_USERDEF + ctx->hsphed->max_varhpi) ) {
				return sizeof(MPVarData);
			}
			return 0;
	}
}

//------------------------------------------------
// prmtype <- mptype (failure: None)
//------------------------------------------------
static prmtype_t fromMPType(prmtype_t mptype)
{
	switch ( mptype ) {
		case MPTYPE_LABEL:       return HSPVAR_FLAG_LABEL;
		case MPTYPE_LOCALSTRING: return HSPVAR_FLAG_STR;
		case MPTYPE_DNUM:        return HSPVAR_FLAG_DOUBLE;
		case MPTYPE_INUM:        return HSPVAR_FLAG_INT;
		case MPTYPE_SINGLEVAR:   return PrmType::Var;
		case MPTYPE_ARRAYVAR:    return PrmType::Array;
		case MPTYPE_IMODULEVAR:	//
		case MPTYPE_MODULEVAR:   return PrmType::Modvar;
		case MPTYPE_LOCALVAR:    return PrmType::Local;

		// (dtor �� mpval �̒l��ۑ�����̈�Ƃ��āAany ��1�����Ƃɂ��Ă���)
		case MPTYPE_TMODULEVAR:  return PrmType::Any;

		default:
			return PrmType::None;
	}
}

//------------------------------------------------
// prmtype <- string (failure: None)
//------------------------------------------------
extern prmtype_t fromString(char const* s);

} // namespace PrmType

#endif
