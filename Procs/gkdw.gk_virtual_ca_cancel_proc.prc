DROP PROCEDURE GKDW.GK_VIRTUAL_CA_CANCEL_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_virtual_ca_cancel_proc as

cursor c0 is
select ed.event_id,ed.ops_country,ed.course_code,ed.facility_region_metro,ed.facility_code,ed.start_date,ed.capacity,count(f.enroll_id) enroll_cnt,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||ed.facility_code||chr(9)||ed.start_date v_line
from event_dim ed
     inner join ca_virtual_cancel vc on ed.event_id = vc.event_id
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled'
where ed.ops_country = 'CANADA'
and cd.ch_num = '10'
and cd.md_num = '20'
and ed.status = 'Open'
group by ed.event_id,ed.ops_country,ed.course_code,ed.facility_region_metro,ed.facility_code,ed.start_date,ed.capacity
having count(f.enroll_id) = 0;

v_modify_date varchar2(50);
v_cancel_date varchar2(50);
r0 c0%rowtype;v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
x varchar2(1000);
v_email varchar2(1) := 'N';


begin
execute immediate 'alter session set nls_date_format = "DD-MON-YYYY HH24:MI:SS"';

select to_char(sysdate+7/1440,'yyyy-mm-dd HH24:MI:SS') into v_modify_date from dual;
select to_char(sysdate,'yyyy-mm-dd') into v_cancel_date from dual;

select 'ca_virtual_event_canc_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/ca_virtual_event_canc_'||to_char(sysdate,'yyyymmdd')||'.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Event ID'||chr(9)||'Country'||chr(9)||'Course Code'||chr(9)||'Metro'||chr(9)||'Facility Code'||chr(9)||'Start Date'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

open c0; loop
  fetch c0 into r0; exit when c0%NOTFOUND;

  utl_file.put_line(v_file,r0.v_line);

  update evxevent@slx
     set modifyuser = 'ADMIN',
         modifydate = v_modify_date,
         eventstatus = 'Cancelled',
         allowenrollment = 'F',
         allowtransferin = 'F',
         permitenrollment = 'F',
         permittransferin = 'F',
         canceldate = v_cancel_date,
         cancelreason = 'Course Discontinued'
   where evxeventid = r0.event_id;
end loop;
close c0;
commit;

utl_file.fclose(v_file);

v_error := SendMailJPkg.SendMail(
           SMTPServerName => 'corpmail.globalknowledge.com',
           Sender    => 'DW.Automation@globalknowledge.com',
           Recipient => 'ben.harris@globalknowledge.com',
           CcRecipient => '',
           BccRecipient => '',
           Subject   => 'Canadian Virtual Event Cancellation Complete',
           Body => 'Open Excel Attachment to view events that were cancelled.',
           ErrorMessage => v_error_msg,
           Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
           
end;
/


