#ifndef IG_ABDATA_JSON_HEADER_INNER_AS
#define IG_ABDATA_JSON_HEADER_INNER_AS

// �����w�b�_

#define true 1
#define false 0
#define NULL 0

#define _b_dbgout true ;* 0
#if     _b_dbgout
 #define ctype dbgout(%1) logmes ( "" + (%1) )
#else
 #define ctype dbgout(%1) :
#endif

//------------------------------------------------
// �g�[�N���̎��
//------------------------------------------------
#enum TkType_Error = (-1)
#enum TkType_None  = 0
#enum TkType_Final = TkType_None
#enum TkType_Blank				// ��
#enum TkType_Comment			// �R�����g
#enum TkType_ParenL				// (
#enum TkType_ParenR				// )
#enum TkType_BrkArrL			// [
#enum TkType_BrkArrR			// ]
#enum TkType_BrkObjL			// {
#enum TkType_BrkObjR			// }
#enum TkType_Colon				// :
#enum TkType_Comma				// ,
#enum TkType_Period				// .
#enum TkType_Digit				// [0123456789]+
#enum TkType_Frac				// '.' ������
#enum TkType_Exp				// e, e+, e- (e �� E)
#enum TkType_String				// "string\n\t\\"
#enum TkType_Ident				// ���ʎq

// parse �Ȍ�̂�
#enum TkType_Members
#enum TkType_Elems
#enum TkType_Pair
#enum TkType_Number

#enum TkType_MAX

#endif
