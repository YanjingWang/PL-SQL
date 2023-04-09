DROP PROCEDURE GKDW.LMSGK2TP_UPDATE_TIMESTAMP;

CREATE OR REPLACE PROCEDURE GKDW.LMSGK2TP_update_timestamp  as
 
LAST_RUN_DATE date;

begin  

    LAST_RUN_DATE:= trunc(sysdate) ;

    delete  LMSGK2TP_TIMESTAMP@dx_prod;
    commit;

      insert into LMSGK2TP_TIMESTAMP@dx_prod
       (LAST_RUN_DATE)
       values( LAST_RUN_DATE) ;

       
    
dbms_output.put_line('LMSGK2TP_TIMESTAMP has been loaded... .');

commit;

 EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE(' Error in LMSGK2TP_TIMESTAMP ...' ) ;
       RAISE;
       
end;
/


