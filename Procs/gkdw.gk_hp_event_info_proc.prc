DROP PROCEDURE GKDW.GK_HP_EVENT_INFO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_hp_event_info_proc as

cursor c1 is
select ed.event_id||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||to_char(ed.start_date,'mm/dd/yyyy')||chr(9)||ed.start_time||chr(9)||to_char(ed.end_date,'mm/dd/yyyy')||chr(9)||
       ed.end_time||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||ed.address1||chr(9)||ed.address2||chr(9)||ed.city||chr(9)||ed.state||chr(9)||ed.zipcode v_cancel_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where course_pl = 'MICROSOFT'
   and cd.ch_num in ('10')
   and cd.md_num in ('10','20')
   and start_date >= trunc(sysdate)
   and ed.cancel_date >= trunc(sysdate)-1
   and ed.status = 'Cancelled'
 order by ed.start_date;

cursor c2 is
select ed.event_id||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||to_char(ed.start_date,'mm/dd/yyyy')||chr(9)||ed.start_time||chr(9)||to_char(ed.end_date,'mm/dd/yyyy')||chr(9)||
       ed.end_time||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||ed.address1||chr(9)||ed.address2||chr(9)||ed.city||chr(9)||ed.state||chr(9)||ed.zipcode v_new_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where course_pl = 'MICROSOFT'
   and cd.ch_num in ('10')
   and cd.md_num in ('10','20')
   and start_date >= trunc(sysdate)
   and ed.creation_date >= trunc(sysdate)-1
   and ed.status = 'Open'
 order by start_date;
 
cursor c3 is
select f.enroll_id,f.enroll_status,
       f.enroll_id||chr(9)||ed.course_code||chr(9)||cd.short_name||chr(9)||to_char(ed.start_date,'mm/dd/yyyy')||chr(9)||to_char(ed.end_date,'mm/dd/yyyy')||chr(9)||c.cust_name||chr(9)||
       c.email||chr(9)||c.acct_name||chr(9)||f.enroll_status v_verify_line
  from gk_conf_email_audit ea
       inner join order_fact f on ea.evxevenrollid = f.enroll_id
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join cust_dim c on f.cust_id = c.cust_id
 where f.enroll_status in ('Attended','Did Not Attend')
   and f.keycode = 'C09901018'
   and trunc(f.enroll_status_date) = trunc(sysdate)-1
union
select f.enroll_id,f.enroll_status,
       f.enroll_id||chr(9)||ed.course_code||chr(9)||cd.short_name||chr(9)||to_char(ed.start_date,'mm/dd/yyyy')||chr(9)||to_char(ed.end_date,'mm/dd/yyyy')||chr(9)||c.cust_name||chr(9)||
       c.email||chr(9)||c.acct_name||chr(9)||f.enroll_status v_verify_line
  from gk_channel_conf_email_audit ea
       inner join order_fact f on ea.evxevenrollid = f.enroll_id
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join cust_dim c on f.cust_id = c.cust_id
 where f.enroll_status in ('Attended','Did Not Attend')
   and trunc(f.enroll_status_date) = trunc(sysdate)-1
   and f.keycode = 'C09901018'
 order by 1;

v_cancel_name varchar2(50);
v_cancel_full varchar2(250);
v_cancel_file utl_file.file_type;
v_new_name varchar2(50);
v_new_full varchar2(250);
v_new_file utl_file.file_type;
v_verify_name varchar2(50);
v_verify_full varchar2(250);
v_verify_file utl_file.file_type;
v_hdr varchar2(1000);
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_canc_flag varchar2(1) := 'N';
v_new_flag varchar2(1) := 'N';
v_verify_flag varchar2(1) := 'N';

begin

v_cancel_name := 'gk_msft_event_cancellations_'||to_char(sysdate,'yyyy_mm_dd')||'.xls';
v_cancel_full := '/usr/tmp/gk_msft_event_cancellations_'||to_char(sysdate,'yyyy_mm_dd')||'.xls';
v_new_name := 'gk_msft_event_inserts_'||to_char(sysdate,'yyyy_mm_dd')||'.xls';
v_new_full := '/usr/tmp/gk_msft_event_inserts_'||to_char(sysdate,'yyyy_mm_dd')||'.xls';
v_verify_name := 'gk_student_verify_'||to_char(sysdate,'yyyy_mm_dd')||'.xls';
v_verify_full := '/usr/tmp/gk_student_verify_'||to_char(sysdate,'yyyy_mm_dd')||'.xls';


v_hdr := 'GK Event ID'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||'Start Date'||chr(9)||'Start Time'||chr(9)||'End Date'||chr(9)||'End Time'||chr(9)||'Status'||chr(9)||'Location'||chr(9)||'Address1'||chr(9)||'Address2'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Zipcode';

v_cancel_file := utl_file.fopen('/usr/tmp',v_cancel_name,'w');

utl_file.put_line(v_cancel_file,v_hdr);

for r1 in c1 loop
  utl_file.put_line(v_cancel_file,r1.v_cancel_line);
  v_canc_flag := 'Y';
end loop;

utl_file.fclose(v_cancel_file);


v_new_file := utl_file.fopen('/usr/tmp',v_new_name,'w');

utl_file.put_line(v_new_file,v_hdr);

for r2 in c2 loop
  utl_file.put_line(v_new_file,r2.v_new_line);
  v_new_flag := 'Y';
end loop;

utl_file.fclose(v_new_file);

v_verify_file := utl_file.fopen('/usr/tmp',v_verify_name,'w');

v_hdr := 'GK Enroll ID'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'Student'||chr(9)||'Email'||chr(9)||'Account'||chr(9)||'Enroll Status';

utl_file.put_line(v_verify_file,v_hdr);

for r3 in c3 loop
  utl_file.put_line(v_verify_file,r3.v_verify_line);
  v_verify_flag := 'Y';
  
  update gk_channel_conf_email_audit
     set enrollstatus = r3.enroll_status
   where evxevenrollid = r3.enroll_id;
  commit;
end loop;

utl_file.fclose(v_verify_file);

if v_canc_flag = 'Y' then
  send_mail_attach('DW.Automation@globalknowledge.com','Education.gk.usca@hpe.com','erin.scalia@globalknowledge.com','Beth.Norton@globalknowledge.com','GK MSFT Event Cancellation File','Open Excel Attachment.',v_cancel_full);
  send_mail_attach('DW.Automation@globalknowledge.com','Alan.frelich@globalknowledge.com','Smaranika.baral@globalknowledge.com','bala.subramanian@globalknowledge.com','GK MSFT Event Cancellation File','Open Excel Attachment.',v_cancel_full);
end if;

if v_new_flag = 'Y' then
  send_mail_attach('DW.Automation@globalknowledge.com','Education.gk.usca@hpe.com','erin.scalia@globalknowledge.com','Beth.Norton@globalknowledge.com','GK MSFT Event File','Open Excel Attachment.',v_new_full);
  send_mail_attach('DW.Automation@globalknowledge.com','Alan.frelich@globalknowledge.com','Smaranika.baral@globalknowledge.com','bala.subramanian@globalknowledge.com','GK MSFT Event File','Open Excel Attachment.',v_new_full);
end if;

if v_verify_flag = 'Y' then
  send_mail_attach('DW.Automation@globalknowledge.com','Education.gk.usca@hpe.com','erin.scalia@globalknowledge.com','Beth.Norton@globalknowledge.com','GK Student Verification File','Open Excel Attachment.',v_verify_full);
  send_mail_attach('DW.Automation@globalknowledge.com','Alan.frelich@globalknowledge.com','Smaranika.baral@globalknowledge.com','bala.subramanian@globalknowledge.com','GK Student Verification File','Open Excel Attachment.',v_verify_full);
end if;

end;
/


