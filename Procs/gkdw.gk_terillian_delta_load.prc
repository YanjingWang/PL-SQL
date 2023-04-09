DROP PROCEDURE GKDW.GK_TERILLIAN_DELTA_LOAD;

CREATE OR REPLACE PROCEDURE GKDW.gk_terillian_delta_load as


 last_run_date_out date;
 
cursor c1 is
    select distinct  gte.class_ID, f.ATTENDEECONTACTID cust_id, f.EVXEVENROLLID enroll_id, 
        initcap(cd.FIRSTNAME)  First_Name, initcap(cd.LASTNAME)  Last_Name, 
        cd.ACCOUNTID acct_id, initcap(cd.ACCOUNT) Acct_Name, 
        cd.EMAIL, lower(cd.LASTNAME) || lower(substr(cd.FIRSTNAME  ,1,1)) password, 
        h.ENROLLSTATUS enroll_status , f.CREATEDATE enroll_date
    from gk_terillian_events_mv gte
    join evxev_txfee@slx f on gte.class_ID = f.evxeventid
    join evxenrollhx@slx h on f.EVXEVENROLLID = h.evxevenrollid
    join contact@slx cd on f.ATTENDEECONTACTID  = cd.contactid
   -- join address@slx a on cd.addressid = a.addressid
    where (
        trunc(gte.end_DATE) between trunc(sysdate) - 1 and trunc(sysdate) + 45
--        or 
--        gte.class_id =  'Q6UJ9AS5XW2T' -- SR 01/23/2019 FP# 6572
            )
     and gte.start_Date <= trunc(sysdate)       
     and (f.createdate >= LAST_RUN_DATE_OUT or f.modifydate >= LAST_RUN_DATE_OUT) 
     and replace(upper(f.feetype), ' ') not in ('ONS - BASE', 'ONS - ADDITIONAL','ONS-ADDITIONAL') 
     order by gte.class_id, f.attendeecontactid, f.evxevenrollid ;

     

cursor c2 is
    select distinct gte.course_code,  
        gte.CLASS_ID, replace(gte.EVENT_NAME, ',') Event_name, gte.STATUS, gte.LOCATION_ID, 
        COMPANY_ID, MAXSEATS, MINSEAT, START_TIME, END_TIME,
        CONNECTED_C, CONNECTED_V_TO_C, 
        START_DATE, END_DATE, TZGENERICNAME, country
    from gk_terillian_events_mv gte
    join evxev_txfee@slx f on gte.class_ID = f.evxeventid
    where (
        trunc(gte.end_DATE) between trunc(sysdate) - 1 and trunc(sysdate) + 90 
--        or 
--        gte.class_id =  'Q6UJ9AS5XW2T' -- SR 01/23/2019 FP# 6572
            )
     and gte.start_Date <= trunc(sysdate)       
     and (f.createdate >= LAST_RUN_DATE_OUT or f.modifydate >= LAST_RUN_DATE_OUT) 
     and replace(upper(f.feetype), ' ') not in ('ONS - BASE', 'ONS - ADDITIONAL','ONS-ADDITIONAL') 
     order by course_code, start_date, class_id;


cursor c3 is
    select distinct gte.CLASS_ID, 
        ie.CONTACTID,  ie.FIRSTNAME, ie.LASTNAME, ie.ACCOUNTID, replace(ie.ACCOUNT, ',') Acct_Name, 
        ie.FEECODE, ie.EMAIL, lower(ie.lastname) || lower(substr(ie.firstname,1,1)) password 
    from gk_terillian_events_mv gte
    join evxev_txfee@slx f on gte.class_ID = f.evxeventid
    join INSTRUCTOR_EVENT_V ie on gte.CLASS_ID = ie.EVXEVENTID
    where (
        trunc(gte.end_DATE) between trunc(sysdate) - 1 and trunc(sysdate) + 45 
--        or 
--        gte.class_id =  'Q6UJ9AS5XW2T' -- SR 01/23/2019 FP# 6572
            )
     and gte.start_Date <= trunc(sysdate)
    and (f.createdate >= LAST_RUN_DATE_OUT or f.modifydate >= LAST_RUN_DATE_OUT) 
    and replace(upper(f.feetype), ' ') not in ('ONS - BASE', 'ONS - ADDITIONAL','ONS-ADDITIONAL')  
    order BY class_id, contactid ;
    


--msg_body varchar2(5000);
v_error number;
v_error_msg varchar2(500);

v_audit_file varchar2(50);
v_audit_file_full varchar2(250);
v_file utl_file.file_type;

begin


    LAST_RUN_DATE_OUT := NULL;
    
    select nvl(last_run_date, trunc(sysdate)) into last_run_date_out from GK_TERILLIAN_TIMESTAMP ;
    DBMS_OUTPUT.Put_Line('LAST_RUN_DATE_OUT = ' || LAST_RUN_DATE_OUT || sysdate);


    update GK_TERILLIAN_TIMESTAMP
    set last_run_date = sysdate ;
    
    commit;

    select 'students_delta.txt'
    into v_audit_file
    from dual;

    v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_audit_file,'w');

  --  v_bookdate := trunc(sysdate)-1;



    utl_file.put_line(v_file,'CLASS_ID' || '|' || 
                    'CUST_ID' || '|' || 'ENROLL_ID' || '|' || 
                    'FIRST_NAME' || '|' || 'LAST_NAME' || '|' || 'ACCT_ID' || '|' || 'ACCT_NAME' || '|' || 
                    'EMAIL' || '|' || 'PASSWORD' || '|' || 'ENROLL_STATUS' || '|' || 'ENROLL_DATE') ; --|| '|' || 'COUNTRY');
                        
      
for r1 in c1 loop
  
  utl_file.put_line(v_file, 
                    r1.CLASS_ID  || '|'||  
                    r1.CUST_ID || '|' || r1.ENROLL_ID || '|' ||  r1.FIRST_NAME || '|'|| r1.LAST_NAME || '|'|| 
                    r1.ACCT_ID || '|'|| r1.Acct_Name || '|'|| 
                    r1.EMAIL || '|'|| r1.password || '|' || 
                    r1.ENROLL_STATUS || '|' || r1.ENROLL_DATE 
                    );  --|| '|' || r1.cOUNTRY
                  
                           

end loop;


 

utl_file.fclose(v_file);

/***************** Build Events File ****************************/

    select 'events_delta.txt'
    into v_audit_file
    from dual;

    v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_audit_file,'w');

  --  v_bookdate := trunc(sysdate)-1;



    utl_file.put_line(v_file,'COURSE_CODE' || '|' || 'CLASS_ID' || '|' || 'EVENT_NAME' || '|' || 'STATUS' || '|' || 'LOCATION_ID' ||
                            '|' || 'COMPANY_ID' || '|' || 'MAXSEATS' || '|' || 'MINSEAT' || '|' || 'START_TIME' || '|' || 'END_TIME' ||
                            '|' || 'CONNECTED_C' || '|' || 'CONNECTED_V_TO_C' || '|' || 'START_DATE' || '|' || 'END_DATE' || 
                            '|' || 'TZGENERICNAME'||'|' || 'COUNTRY');
                        
      
    for r1 in c2 loop
  
    utl_file.put_line(v_file, 
                    r1.course_code || '|' ||   
                    r1.CLASS_ID || '|' || r1.Event_name || '|' || r1.STATUS || '|' || r1.LOCATION_ID || '|' || 
                    r1.COMPANY_ID || '|' || r1.MAXSEATS || '|' || r1.MINSEAT || '|' || r1.START_TIME || '|' || r1.END_TIME || '|' ||
                    r1.CONNECTED_C || '|' || r1.CONNECTED_V_TO_C || '|' || 
                    r1.START_DATE || '|' || r1.END_DATE || '|' || r1.TZGENERICNAME || '|' ||
                    r1.country                      
                    );
                           

    end loop;



    utl_file.fclose(v_file);

/**************** Build Instructors Delta *************************/

    select 'instructors_delta.txt'
    into v_audit_file
    from dual;

    v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_audit_file,'w');


    utl_file.put_line(v_file,'CLASS_ID' || '|' || 
                    'CUST_ID' || '|' || 'FIRST_NAME' || '|' || 'LAST_NAME' || '|' || 
                    'ACCT_ID' || '|' || 'ACCT_NAME' || '|' || 'FEECODE' || '|' || 'EMAIL' || '|' || 'PASSWORD');
                        
      
    for r1 in c3 loop
  
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
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK Terillian  DELTA Load Failed',SQLERRM);

end;
/


