// �f�[�^�e�[�u����A�z�z��Ƃ��Ďg�p����

// @need: sqlele

#ifndef IG_USE_TABLE_AS_ASSOC_AS
#define IG_USE_TABLE_AS_ASSOC_AS

#module

//------------------------------------------------
// �A�z�z��e�[�u��
// 
// @ TABLE ( Id INTEGER PRIMARY KEY, Key, Value )
// @ sqlele �̎����ˑ�
// @ ����l�͕K�{
//------------------------------------------------
#deffunc sql_assoc_createTable str name
	sql_q "CREATE TABLE IF NOT EXISTS " + name + "( Id INTEGER PRIMARY KEY, Key, Value )"
	return
	
#define global sql_assoc_begin(%1, %2 = tmparr) sql_assoc_begin_impl (%1), %2
#deffunc sql_assoc_begin_impl str name, var records
	sql_q "SELECT * From " + name, records
	return
	
#defcfunc sql_assoc_find str key, str def, array records
	n@sqle = -1
	
	repeat length2(records)		// ���R�[�h��
		if ( records(1, cnt) == key ) {
			___t@sqle = records(2, cnt)		// 'Value' �̒l�𓾂�
			i@sqle = 1			//= 'Key'
			n@sqle = cnt		// ���R�[�h�ԍ�
			break
		}
	loop
	
	if ( n@sqle < 0 ) {
	;	dialog "key [" + key + "] does not exist.", , "SQL ERR" : end : end
		___t@sqle = def
	}
	return 0
	
#define global ctype sql_assoc_v(%1, %2 = "", %3 = tmparr) ___t@sqle( sql_assoc_find(%1, str(%2), %3) )
#define global ctype sql_assoc_i(%1, %2 = "", %3 = tmparr)    int( sql_assoc_v(%1, str(%2), %3) )
#define global ctype sql_assoc_f(%1, %2 = "", %3 = tmparr) double( sql_assoc_v(%1, str(%2), %3) )

#global
sdim ___t@sqle

#endif
