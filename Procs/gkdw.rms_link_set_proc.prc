DROP PROCEDURE GKDW.RMS_LINK_SET_PROC;

CREATE OR REPLACE PROCEDURE GKDW.rms_link_set_proc as
 ret integer; 
 c integer; 
 BEGIN 
   c := dbms_hs_passthrough.open_cursor@rms_prod; 
   dbms_hs_passthrough.parse@rms_prod(c, 'SET SESSION SQL_MODE=''ANSI_QUOTES'';'); 
   ret := dbms_hs_passthrough.execute_non_query@rms_prod(c); 
   dbms_output.put_line(ret ||' passthrough output'); 
   dbms_hs_passthrough.close_cursor@rms_prod(c); 
   commit;
 END;
/


