// Call - SubCommand header

// todo: ���̃t�@�C���̋@�\�����ׂēK�؂ȏꏊ�Ɉړ�����B

#ifndef IG_CALL_SUB_COMMAND_H
#define IG_CALL_SUB_COMMAND_H

#include "hsp3plugin_custom.h"
#include "CPrmInfo.h"

using namespace hpimod;

// ���������X�g�֘A
extern CPrmInfo const& DeclarePrmInfo(label_t lb, CPrmInfo&& prminfo);
extern CPrmInfo const& GetPrmInfo(stdat_t stdat);
extern CPrmInfo const& GetPrmInfo(label_t);

extern CPrmInfo::prmlist_t code_get_prmlist();
extern CPrmInfo const& code_get_prminfo();

#endif
