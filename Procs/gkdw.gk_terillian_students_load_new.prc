DROP PROCEDURE GKDW.GK_TERILLIAN_STUDENTS_LOAD_NEW;

CREATE OR REPLACE PROCEDURE GKDW.gk_terillian_students_load_new as

cursor c1 is
select gte.class_id,f.cust_id,f.enroll_id,initcap(cd.first_name) first_name,
       initcap(cd.last_name) last_name,cd.acct_id,replace(initcap(cd.acct_name),',') acct_name, 
       lower(cd.email) email,lower(cd.last_name)||lower(substr(cd.first_name ,1,1)) password,f.enroll_status, 
       f.enroll_date
  from gk_terillian_events_v gte
       inner join order_fact f on gte.class_id = f.event_id
       inner join cust_dim cd on f.cust_id = cd.cust_id
 where  (trunc(gte.end_date) between trunc(sysdate) - 1 and trunc(sysdate) + 120  
 or GTE.CLASS_ID = 'Q6UJ9APY2BRN'
        or        (GTE.COURSE_CODE = '9995L' and trunc(gte.end_date) > trunc(sysdate) - 1)--- TTT CourseCode
        or     GTE.CLASS_ID in (
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
    ))
   and enroll_status not in ('Cancelled','Did Not Attend')
   and f.fee_type not in ('Ons - Base','Ons - Additional','Ons-Additional')
   and cd.email is not null
union all
select gte.class_id,f.cust_id,max(f.enroll_id),initcap(cd.first_name) first_name,
       initcap(cd.last_name) last_name,cd.acct_id,replace(initcap(cd.acct_name),',') acct_name, 
       lower(cd.email) email,lower(cd.last_name)||lower(substr(cd.first_name ,1,1)) password,f.enroll_status, 
       max(f.enroll_date)
  from gk_terillian_events_v gte
       inner join order_fact f on gte.class_id = f.event_id
       inner join cust_dim cd on f.cust_id = cd.cust_id
 where (trunc(gte.end_date) between trunc(sysdate) - 1 and trunc(sysdate) + 45  
    or  (GTE.COURSE_CODE = '9995L' and trunc(gte.end_date) > trunc(sysdate) - 1) --- TTT CourseCode
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
    ))
   and enroll_status in ('Cancelled','Did Not Attend')
   and f.fee_type not in ('Ons - Base','Ons - Additional','Ons-Additional')
   and cd.email is not null
   and not exists (
       select 1 
         from order_fact f1
              inner join cust_dim cd1 on f1.cust_id = cd1.cust_id
        where f.event_id = f1.event_id and f.enroll_id != f1.enroll_id and lower(cd.email) = lower(cd1.email) and f1.enroll_status != 'Cancelled')
group by gte.class_id,f.cust_id,initcap(cd.first_name),initcap(cd.last_name),cd.acct_id,replace(initcap(cd.acct_name),','), 
       lower(cd.email),lower(cd.last_name)||lower(substr(cd.first_name ,1,1)),f.enroll_status;
/*union all
select ed.event_id class_id,f.cust_id,max(f.enroll_id) enroll_id,initcap(cd.first_name) first_name,
       initcap(cd.last_name) last_name,cd.acct_id,replace(initcap(cd.acct_name),',') acct_name, 
       lower(cd.email) email,lower(cd.last_name)||lower(substr(cd.first_name ,1,1)) password,f.enroll_status, 
       max(f.enroll_date) enroll_date
  from event_dim ed
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim cd on f.cust_id = cd.cust_id
 where ed.event_id =  'Q6UJ9AS5XW2T'
   and cd.email is not null
   and enroll_status not in ('Cancelled','Did Not Attend')
   and f.fee_type not in ('Ons - Base','Ons - Additional','Ons-Additional')
 group by ed.event_id,f.cust_id,initcap(cd.first_name),initcap(cd.last_name),cd.acct_id,replace(initcap(cd.acct_name),','), 
       lower(cd.email),lower(cd.last_name)||lower(substr(cd.first_name ,1,1)),f.enroll_status
union all
select ed.event_id class_id,f.cust_id,max(f.enroll_id) enroll_id,initcap(cd.first_name) first_name,
       initcap(cd.last_name) last_name,cd.acct_id,replace(initcap(cd.acct_name),',') acct_name, 
       lower(cd.email) email,lower(cd.last_name)||lower(substr(cd.first_name ,1,1)) password,f.enroll_status, 
       max(f.enroll_date) enroll_date
  from event_dim ed
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim cd on f.cust_id = cd.cust_id
 where ed.event_id =  'Q6UJ9AS5XW2T'
   and enroll_status in ('Cancelled','Did Not Attend')
   and f.fee_type not in ('Ons - Base','Ons - Additional','Ons-Additional')
   and cd.email is not null
 group by ed.event_id,f.cust_id,initcap(cd.first_name),initcap(cd.last_name),cd.acct_id,replace(initcap(cd.acct_name),','), 
       lower(cd.email),lower(cd.last_name)||lower(substr(cd.first_name ,1,1)),f.enroll_status
 order by class_id,cust_id,enroll_id; */ -- SR 01/23/2019 FP# 6572
       
--    select distinct  gte.CLASS_ID, f.CUST_ID, f.ENROLL_ID, 
--        initcap(cd.FIRST_NAME) First_Name, initcap(cd.LAST_NAME) Last_Name, cd.ACCT_ID, replace(initcap(cd.ACCT_NAME), ',') Acct_Name, 
--        cd.EMAIL, lower(cd.LAST_NAME) || lower(substr(cd.FIRST_NAME ,1,1)) password, 
--        f.ENROLL_STATUS, f.ENROLL_DATE --, cd.COUNTRY
--    from GK_TERILLIAN_EVENTS_v gte
--    join order_fact f on gte.CLASS_ID = f.EVENT_ID
--    join cust_dim cd on f.CUST_ID = cd.CUST_ID
--    where replace(upper(f.FEE_TYPE), ' ') not in ('ONS-BASE', 'ONS-ADDITIONAL')
--    and trunc(gte.end_DATE) between trunc(sysdate) - 1 and trunc(sysdate) + 45
--    union /** Added for live train the trainer  enrollments */
--    select distinct  gte.event_ID, f.ATTENDEECONTACTID , f.EVXEVENROLLID, 
--        initcap(cd.FIRSTNAME)  First_Name, initcap(cd.LASTNAME)  Last_Name, cd.ACCOUNTID, initcap(cd.ACCOUNT) Acct_Name, 
--        cd.EMAIL, lower(cd.LASTNAME) || lower(substr(cd.FIRSTNAME  ,1,1)) password, 
--        h.ENROLLSTATUS , h.CREATEDATE --, a.country
--    from event_dim gte
--    join evxev_txfee@slx f on gte.event_ID = f.evxeventid
--    join evxenrollhx@slx h on f.EVXEVENROLLID = h.evxevenrollid
--    join contact@slx cd on f.ATTENDEECONTACTID  = cd.contactid
--    --join address@slx a on cd.addressid = a.addressid
--    where --trunc(gte.end_DATE) between trunc(sysdate) - 1 and trunc(sysdate) + 90 and 
--     gte.event_id =  'Q6UJ9AS5XW2T'
--    order by class_id, cust_id, enroll_id ;
    

msg_body varchar2(5000);
v_error number;
v_error_msg varchar2(500);

v_audit_file varchar2(50);
v_audit_file_full varchar2(250);
v_file utl_file.file_type;

begin

    select 'students_test.txt'
    into v_audit_file
    from dual;

    v_file := utl_file.fopen('/mnt/shared_ww_lods',v_audit_file,'w');
    
  --      v_file := utl_file.fopen('/mnt/nc10s210_terillian',v_audit_file,'w');

  --  v_bookdate := trunc(sysdate)-1;



    utl_file.put_line(v_file,'CLASS_ID' || '|' || 
                    'CUST_ID' || '|' || 'ENROLL_ID' || '|' || 
                    'FIRST_NAME' || '|' || 'LAST_NAME' || '|' || 'ACCT_ID' || '|' || 'ACCT_NAME' || '|' || 
                    'EMAIL' || '|' || 'PASSWORD' || '|' || 'ENROLL_STATUS' || '|' || 'ENROLL_DATE' ) ; --|| '|' || 'COUNTRY' );
                        
      
for r1 in c1 loop
  
  utl_file.put_line(v_file, 
                    r1.CLASS_ID  || '|'||  
                    r1.CUST_ID || '|' || r1.ENROLL_ID || '|' ||  r1.FIRST_NAME || '|'|| r1.LAST_NAME || '|'|| 
                    r1.ACCT_ID || '|'|| r1.Acct_Name || '|'|| 
                    r1.EMAIL || '|'|| r1.password || '|' || 
                    r1.ENROLL_STATUS || '|' || r1.ENROLL_DATE ) ; --|| '|' || r1.country
                   
                           

end loop;



utl_file.fclose(v_file);



exception
  when no_data_found then
    utl_file.fclose(v_file);
--    x:=system.OSCommand_Run(cmd_string);

  when others then
    utl_file.fclose(v_file);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK Terillian Students Load Failed',SQLERRM);

end;
/


