// autohs - header and module

#ifndef __AUTO_HS_AS__
#define __AUTO_HS_AS__

#define global HSED_TEMPFILE_DIR (ownpath +"\\"+ HSED_TEMPFILE_NAME)
#define global HSED_TEMPFILE_HSP (ownpath +"\\"+ HSED_TEMPFILE_NAME +".hsp")
#define global HSED_TEMPFILE_HS  (ownpath +"\\"+ HSED_TEMPFILE_NAME +".hs")
#define global HSED_TEMPFILE_NAME "hsedtmp"

//------------------------------------------------
// �G���[�萔
//------------------------------------------------
#enum global Error_None = 0
#enum global Error_NeedCmdline
#enum global Error_NoExists
#enum global Error_NoHsed
#enum global Error_MAX

#module

//------------------------------------------------
// �G���[���b�Z�[�W�̏o��
//------------------------------------------------
#deffunc PutErrorMessage int error
	print GetErrorMessage( error )
	return
	
//------------------------------------------------
// �G���[���b�Z�[�W�̎擾
//------------------------------------------------
#defcfunc GetErrorMessage int error
	switch ( error )
		case Error_None        : return ""
		case Error_NeedCmdline : return "Cmdline:\n\t\"output-file-name\" \"input-file-name\""
		case Error_NoExists    : return "The file is not exists."
		case Error_NoHsed      : return "Basic Script Editor 'hsed3' is not executed."
	swend
	logmes "GetErrorMessage\n�����ȃG���[�萔���g���Ă���\n"+ error
	assert
	return ""
	
#global

#endif
