DROP PROCEDURE GKDW.GK_TERILLIAN_INSTRUC_LOAD_T1;

CREATE OR REPLACE PROCEDURE GKDW.gk_terillian_instruc_load_t1 as

cursor c1 is
    SELECT gte.CLASS_ID, 
        ie.CONTACTID,  ie.FIRSTNAME, ie.LASTNAME, ie.ACCOUNTID, replace(ie.ACCOUNT, ',') Acct_Name, 
        ie.FEECODE, ie.EMAIL, lower(ie.lastname) || lower(substr(ie.firstname,1,1)) password 
    fROM GK_TERILlIAN_EVENTS_v_test gte
    join INSTRUCTOR_EVENT_V_test ie on gte.CLASS_ID = ie.EVXEVENTID
    where trunc(gte.end_DATE) between trunc(sysdate) - 1 and trunc(sysdate) + 120 -- SR 12/10/2016 
    or    (GTE.COURSE_CODE in ( '9995L',  '9995V') and trunc(gte.end_date) > trunc(sysdate) - 1)
 or GTE.CLASS_ID = 'Q6UJ9APY2BRN'
    /*** Event ids added for Extended MS Pilot *********/
    or GTE.CLASS_ID in (
    'Q6UJ9AD8NFZD',
    'Q6UJ9AD8NG4H',
    'Q6UJ9AD8NDTH',
    'Q6UJ9AD8NG4M',
    'Q6UJ9AD8NFZA',
    'Q6UJ9AD8NI42',
    'Q6UJ9AD8NHYL',
    'Q6UJ9AD8NFZB',
    'Q6UJ9AD8NG4W',
    'Q6UJ9AD8NI3U',
    'Q6UJ9AD8NG4Y',
    'Q6UJ9AD8NG50',
    'Q6UJ9AD8NG4X',
    'Q6UJ9AD8NI41'
    )
    order BY class_id, contactid ;
    

msg_body varchar2(5000);
v_error number;
v_error_msg varchar2(500);

v_audit_file varchar2(50);
v_audit_file_full varchar2(250);
v_file utl_file.file_type;

begin

    select 'instructors_test.txt'
    into v_audit_file
    from dual;

    v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_audit_file,'w');

  --  v_bookdate := trunc(sysdate)-1;



    utl_file.put_line(v_file,'CLASS_ID' || '|' || 
                    'CUST_ID' || '|' || 'FIRST_NAME' || '|' || 'LAST_NAME' || '|' || 
                    'ACCT_ID' || '|' || 'ACCT_NAME' || '|' || 'FEECODE' || '|' || 'EMAIL' || '|' || 'PASSWORD');
                        
      
for r1 in c1 loop
  
  utl_file.put_line(v_file, 
                    r1.CLASS_ID  || '|'||  
                    r1.CONTACTID || '|'||  r1.FIRSTNAME || '|'|| r1.LASTNAME || '|'|| 
                    r1.ACCOUNTID || '|'|| r1.Acct_Name || '|'|| 
                    r1.FEECODE || '|'|| r1.EMAIL || '|'|| r1.password 
                    );
                           

end loop;



utl_file.fclose(v_file);



exception
  when no_data_found then
    utl_file.fclose(v_file);
--    x:=system.OSCommand_Run(cmd_string);

  when others then
    utl_file.fclose(v_file);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK Terillian Instructor Load Failed',SQLERRM);

end;
/


