DROP PROCEDURE GKDW.GK_SOFTLAYER_DAILY_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_softlayer_daily_proc as

cursor c1 is
select ed.event_id,ed.start_date,ed.end_date,cd.course_code,ed.location_name,ed.facility_code,ed.city,ed.state,ed.country,f.enroll_id,f.enroll_date,f.enroll_status,c.firstname,c.lastname,c.title,c.account,c.email,
       ed.event_id||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||cd.course_code||chr(9)||ed.location_name||chr(9)||ed.facility_code||chr(9)||ed.city||chr(9)||
       ed.state||chr(9)||ed.country||chr(9)||f.enroll_id||chr(9)||f.enroll_date||chr(9)||f.enroll_status||chr(9)||c.firstname||chr(9)||c.lastname||chr(9)||c.title||chr(9)||c.account||chr(9)||c.email v_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join order_fact f on ed.event_id = f.event_id
       inner join slxdw.contact c on f.cust_id = c.contactid
 where substr(ed.course_code,1,4) in ('5947','5950','1459','3417','3573') --'0741','0748'
   and ed.status != 'Cancelled'
   and f.fee_type != 'Ons - Base'
 order by ed.start_date,ed.event_id,c.lastname,c.firstname;
 
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
x varchar2(1000);

begin

select 'softlayer_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/softlayer_'||to_char(sysdate,'yyyymmdd')||'.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Event ID'||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'Course Code'||chr(9)||'Location Name'||chr(9)||'Facility Code'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Country'||chr(9)||
       'Enroll ID'||chr(9)||'Enroll Date'||chr(9)||'Enroll Status'||chr(9)||'First Name'||chr(9)||'Last Name'||chr(9)||'Title'||chr(9)||'Account'||chr(9)||'Email'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

for r1 in c1 loop
  utl_file.put_line(v_file,r1.v_line);
end loop;

utl_file.fclose(v_file);

v_error := SendMailJPkg.SendMail(
           SMTPServerName => 'corpmail.globalknowledge.com',
           Sender    => 'DW.Automation@globalknowledge.com',
           Recipient => 'patti.hedgspeth@globalknowledge.com',
           CcRecipient => '',
           BccRecipient => 'michelle.jones@globalknowledge.com',
           Subject   => 'Softlayer Roster Report',
           Body => 'Open Excel Attachment to view report.',
           ErrorMessage => v_error_msg,
           Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));


end;
/


