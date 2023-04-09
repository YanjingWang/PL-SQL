DROP PROCEDURE GKDW.GK_DAILY_DISCONTINUED_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_daily_discontinued_proc as
cursor c1 is
select ed.cancel_date||chr(9)||ed.event_id||chr(9)||ed.start_date||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||
       ed.province||chr(9)||ed.country||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||cd.course_ch||chr(9)||cd.course_mod||chr(9)||
       cd.course_pl||chr(9)||f.enroll_id||chr(9)||c.cust_id||chr(9)||c.cust_name||chr(9)||c.acct_name||chr(9)||f.enroll_date||chr(9)||
       f.book_date||chr(9)||f.book_amt||chr(9)||f.curr_code||chr(9)||f.sales_rep||chr(9)||f.attendee_type||chr(9)||f.enroll_status_desc||chr(9)||
       ed.cancel_reason||chr(9)||f.payment_method||chr(9)||f.po_number||chr(9)||eb.checknumber||chr(9)||f.ppcard_id||chr(9)||c.email||chr(9)||
       f.enroll_type||chr(9)||f.keycode||chr(9)||f.source||chr(9)||ed.facility_region_metro||chr(9)||et.billtocontact||chr(9)||et.billtoaccount||chr(9)||
       c2.address1||chr(9)||c2.city||chr(9)||c2.state||chr(9)||c2.province||chr(9)||c2.country v_line
 from course_dim cd
      inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
      inner join order_fact f on ed.event_id=f.event_id
      inner join cust_dim c on f.cust_id = c.cust_id
      left outer join slxdw.evxev_txfee et on f.txfee_id = et.evxev_txfeeid
      left outer join slxdw.evxbillpayment eb on et.evxbillingid = eb.evxbillingid
      left outer join cust_dim c2 on et.billtocontactid = c2.cust_id
 where ed.cancel_reason in ('Course Discontinued','Course Version Update')
   and f.enroll_status='Cancelled'
   and f.creation_date >= trunc(sysdate)-1
   and f.book_amt < 0;
v_file_name varchar2(50);
v_file_full varchar2(250);
v_hdr varchar2(500);
v_file utl_file.file_type;
v_msg_body varchar2(2000);
v_error number;
v_error_msg varchar2(500);
v_mail_flag varchar2(1) := 'N';
begin
v_file_name := 'DailyCourseDiscontinuedCancellations_'||to_char(trunc(sysdate)-1,'yyyymmdd')||'.xls';
v_file_full := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
v_hdr := 'Cancel Date'||chr(9)||'Event ID'||chr(9)||'Start Date'||chr(9)||'Status'||chr(9)||'Location'||chr(9)||'Province'||chr(9)||'Country';
v_hdr := v_hdr||chr(9)||'Course Code'||chr(9)||'Short Name    '||chr(9)||'Channel'||chr(9)||'Modality'||chr(9)||'Prod Line'||chr(9)||'Enroll ID';
v_hdr := v_hdr||chr(9)||'Contact ID'||chr(9)||'Contact Name'||chr(9)||'Account Name'||chr(9)||'Enroll Date'||chr(9)||'Book Date';
v_hdr := v_hdr||chr(9)||'Book Amt'||chr(9)||'Curr Code'||chr(9)||'Sales Rep'||chr(9)||'Attendee Type'||chr(9)||'Status Desc';
v_hdr := v_hdr||chr(9)||'Reason'||chr(9)||'Pay Method'||chr(9)||'PO Num'||chr(9)||'Check Number'||chr(9)||'PP Card'||chr(9)||'Email'||chr(9)||'Enroll Type';
v_hdr := v_hdr||chr(9)||'Keycode'||chr(9)||'Source'||chr(9)||'Metro'||chr(9)||'Bill Contact'||chr(9)||'Bill Account'||chr(9)||'Address';
v_hdr := v_hdr||chr(9)||'City'||chr(9)||'State'||chr(9)||'Province'||chr(9)||'Country';
utl_file.put_line(v_file,v_hdr);
for r1 in c1 loop
  utl_file.put_line(v_file,r1.v_line);
  v_mail_flag := 'Y';
end loop;
utl_file.fclose(v_file);
if v_mail_flag = 'Y' then
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'DW.Automation@globalknowledge.com',
            Recipient => 'krissi.fields@globalknowledge.com',
            CcRecipient => 'jack.broeren@globalknowledge.com',
            BccRecipient => 'Jarka.Vystavelova@globalknowledge.com',
            Subject   => 'Daily Course Discontinued Report-'||trunc(sysdate-1),
            Body => 'Open Attachment',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
           
            
end if;
end;
/


