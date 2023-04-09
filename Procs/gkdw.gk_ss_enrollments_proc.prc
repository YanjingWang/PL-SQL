DROP PROCEDURE GKDW.GK_SS_ENROLLMENTS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ss_enrollments_proc(p_date varchar2 default null) as

cursor c1(vv_date date) is
  select ed.event_id,ed.course_code,ed.start_date,ed.location_name,ed.facility_region_metro,
         ed.ops_country,f.enroll_id,f.book_date,f.book_amt,f.salesperson,f.enroll_status,
         cd.cust_name,cd.acct_name,
         ed.ops_country||chr(9)||ed.event_id||chr(9)||ed.course_code||chr(9)||ed.start_date||chr(9)||ed.location_name||chr(9)||ed.facility_region_metro||chr(9)||
         f.enroll_id||chr(9)||f.book_date||chr(9)||f.book_amt||chr(9)||f.salesperson||chr(9)||f.enroll_status||chr(9)||cd.cust_name||chr(9)||
         cd.acct_name v_line
    from gk_event_cnt_v@slx e
         inner join event_dim ed on e.evxeventid = ed.event_id
         inner join order_fact f on ed.event_id = f.event_id
         inner join cust_dim cd on f.cust_id = cd.cust_id
   where trunc(f.book_date) = vv_date
     and e.jeopardyflag = 'Enroll'
   order by ed.start_date,ed.event_id,f.enroll_id;

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_date date;
v_email varchar2(1) := 'N';

begin

if p_date is null then
  v_date := trunc(sysdate)-1;
else
  v_date := to_date(p_date,'mm/dd/yyyy');
end if;


select 'event_enrollments_'||to_char(v_date,'yyyymmdd')||'.xls',
       '/usr/tmp/event_enrollments_'||to_char(v_date,'yyyymmdd')||'.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Country'||chr(9)||'Event ID'||chr(9)||'Course Code'||chr(9)||'Start Date'||chr(9)||'Location'||chr(9)||'Metro'||chr(9)||'Enroll ID'||chr(9)||
       'Book Date'||chr(9)||'Book Amt'||chr(9)||'SalesPerson'||chr(9)||'Status'||chr(9)||'Customer'||chr(9)||'Account'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

for r1 in c1(v_date) loop
  utl_file.put_line(v_file,r1.v_line);
  v_email := 'Y';
end loop;

utl_file.fclose(v_file);

if v_email = 'Y' then
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'nc10s250.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'krissi.fields@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Event Enrollments',
             Body => 'Open Excel Attachment to view enrollments/cancellations for events that are coded as "Enroll" in SalesLogix.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
end if;

end;
/


