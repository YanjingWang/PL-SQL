DROP PROCEDURE GKDW.GK_PORTAL_MV_REBUILD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_portal_mv_rebuild_proc as
ddl_string_drop varchar2(4000);
ddl_string_create varchar2(4000);
begin
select dbms_metadata.get_ddl ('MATERIALIZED_VIEW','GK_IBM_PORTAL_LOAD_MV','GKDW')
     into ddl_string_create
     from dba_mviews
    where owner = 'GKDW' 
      and mview_name = 'GK_IBM_PORTAL_LOAD_MV';
ddl_string_drop := 'drop materialized view GKDW.GK_IBM_PORTAL_LOAD_MV';
execute immediate ddl_string_drop;
execute immediate ddl_string_create;
commit;
end;
/


