
#ifndef IG_HPIMOD_STRINGIZATION_H
#define IG_HPIMOD_STRINGIZATION_H

#include <string>
#include <vector>

namespace hpimod {

extern char const* nameFromMPType(int mptype);

//�����񃊃e����
extern std::string literalFormString(char const* s);

//�z��Y���̕�����̐���
extern std::string stringizeArrayIndex(std::vector<int> const& indexes);

//�C���q����菜�������ʎq
extern std::string nameExcludingScopeResolution(std::string const& name);

} //namespace hpimod

#endif
