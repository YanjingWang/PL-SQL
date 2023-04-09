DROP PROCEDURE GKDW.GK_MV_REFRESH_GK_ALL_ORDERS;

CREATE OR REPLACE PROCEDURE GKDW.gk_mv_refresh_gk_all_orders as

begin
DBMS_SNAPSHOT.REFRESH('gkdw.gk_all_orders_mv');
dbms_output.put_line('gk_all_orders_mv complete: '||to_char(sysdate,'hh24:mi:ss'));
commit;

end;
/


