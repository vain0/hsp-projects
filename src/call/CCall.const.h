// CCall - const

#ifndef IG_CLASS_CALL_CONST_H
#define IG_CLASS_CALL_CONST_H

// CCall ���g�p����萔�ŁA���J�������́B

//------------------------------------------------
// arginfo dataID
//------------------------------------------------
enum ARGINFOID
{
	ARGINFOID_FLAG = 0,		// vartype
	ARGINFOID_MODE,			// �ϐ����[�h( 0 = ��������, 1 = �ʏ�, 2 = �N���[�� )
	ARGINFOID_LEN1,			// �ꎟ���ڗv�f��
	ARGINFOID_LEN2,			// �񎟌��ڗv�f��
	ARGINFOID_LEN3,			// �O�����ڗv�f��
	ARGINFOID_LEN4,			// �l�����ڗv�f��
	ARGINFOID_SIZE,			// �S�̂̃o�C�g��
	ARGINFOID_PTR,			// ���̂ւ̃|�C���^
	ARGINFOID_BYREF,		// �Q�Ɠn����
	ARGINFOID_NOBIND,		// nobind ������
	ARGINFOID_MAX
};

#endif
