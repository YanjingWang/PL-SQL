DROP PROCEDURE GKDW.GET_MAX_DATE;

CREATE OR REPLACE PROCEDURE GKDW.Get_Max_Date(p_tablename_in varchar2, 
                                                  create_date_out out date, 
                                        modify_date_out out date )
                                        as
        max_create_date date;
        max_modify_date date;
        sql_stmt VARCHAR2(2000);
begin
     sql_stmt := 'SELECT trunc(max(creation_date)), trunc(max(last_update_date)) FROM '
                  || p_TableName_In  
                  || ' WHERE GKDW_SOURCE in (''SLXDW'', ''NEST'')' 
                  || ' AND creation_date <= trunc(sysdate) and last_update_date <= trunc(sysdate)';

                  
--    DBMS_OUTPUT.PUT_LINE(sql_stmt);
                  
EXECUTE IMMEDIATE sql_stmt into max_create_date, max_modify_date;


    create_date_out := nvl(max_create_date -1, to_date('01/01/2014', 'mm/dd/yyyy')) ;
    modify_date_out := nvl(max_modify_date -1, to_date('01/01/2014', 'mm/dd/yyyy'));

--create_date_out := to_date('09/29/2015', 'mm/dd/yyyy') ;
--modify_date_out := to_date('09/29/2015', 'mm/dd/yyyy') ;

    EXCEPTION
     WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
      RAISE ;
end;
/


