DROP PROCEDURE GKDW.GET_DIR_LIST;

CREATE OR REPLACE PROCEDURE GKDW.get_dir_list( p_directory in varchar2 )
as language java
name 'DirList.getList( java.lang.String )';
/


