DROP PROCEDURE GKDW.GK_DAILY_EVENT_CANCEL_PROC_SB;

CREATE OR REPLACE PROCEDURE GKDW.gk_daily_event_cancel_proc_SB(p_cancel_date varchar2 default null) as
cursor c1(v_date date) is
select ed.cancel_date||chr(9)||ed.start_date||chr(9)||START_TIME||chr(9)||ed.country||chr(9)||et.billtocontact||chr(9)||et.billtoaccount||chr(9)||c2.country||chr(9)||et.currencytype||chr(9)||
       f.enroll_id||chr(9)||c2.address1||chr(9)||f.ppcard_id||chr(9)||
       c.cust_id||chr(9)||c.acct_name||chr(9)||c.cust_name||chr(9)||c.email||chr(9)||cd.course_code||chr(9)||
       cd.course_name||chr(9)||ui.username||chr(9)||
       ed.facility_region_metro||chr(9)||f.keycode||chr(9)||
       f.source||chr(9)||f.book_amt||chr(9)||f.fee_type||chr(9)||f.enroll_type||chr(9)||f.payment_method||chr(9)||f.po_number||chr(9)||eb.checknumber||chr(9)||f.sf_opportunity_id v_line     
 from course_dim cd
      inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
      inner join order_fact f on ed.event_id=f.event_id
      inner join cust_dim c on f.cust_id = c.cust_id
      left outer join slxdw.evxev_txfee et on f.txfee_id = et.evxev_txfeeid
      left outer join slxdw.evxbillpayment eb on et.evxbillingid = eb.evxbillingid
      left outer join cust_dim c2 on et.billtocontactid = c2.cust_id
      LEFT OUTER JOIN (SELECT accountid,
                                  ob_national_rep_id,
                                  ob_rep_id,
                                  ent_national_rep_id,
                                  ent_inside_rep_id,
                                  gk_segment segment,
                                  rep_4_id,
                                  rep_3_id
                             FROM qg_account@slx) qa
             ON c.acct_id = qa.accountid
       --   LEFT OUTER JOIN GK_ACCOUNT_SEGMENTS_MV sl
       --      ON c.acct_id = sl.accountid
       --   LEFT OUTER JOIN gk_territory gt
      --       ON     c.zipcode BETWEEN gt.zip_start AND gt.zip_end
      --          AND SUBSTR (c.country, 1, 2) IN ('US', 'CA')
          LEFT OUTER JOIN userinfo@slx ui ON ui.userid = qa.ob_rep_id
 where upper(ed.status) = 'CANCELLED'
  -- and trunc(ed.last_update_date) = v_date; -- SR 11/02/2016 new logic 
-- f.enroll_status_desc='EVENT CANCELLATION'
   and f.enroll_status='Cancelled'
   and trunc(f.LAST_UPDATE_DATE) >= v_date
    and trunc(ed.cancel_date) >= v_date -- SR 12/15/2016 Adding this to avoid enrollments being included in the report which were cancelled in the past
   and f.book_amt <= 0
   UNION -- FP:4256 SR 01/07/2018 Added this to include enrollments that are cancelled witha  status of Event Cancellation
   select ed.cancel_date||chr(9)||ed.start_date||chr(9)||ed.start_time||chr(9)||ed.country||chr(9)||et.billtocontact||chr(9)||et.billtoaccount||chr(9)||c2.country||chr(9)||et.currencytype||chr(9)||
       f.enroll_id||chr(9)||c2.address1||chr(9)||f.ppcard_id||chr(9)||
       c.cust_id||chr(9)||c.acct_name||chr(9)||c.cust_name||chr(9)||c.email||chr(9)||cd.course_code||chr(9)||
       cd.course_name||chr(9)||ui.username||chr(9)||
       ed.facility_region_metro||chr(9)||f.keycode||chr(9)||
       f.source||chr(9)||f.book_amt||chr(9)||f.fee_type||chr(9)||f.enroll_type||chr(9)||f.payment_method||chr(9)||f.po_number||chr(9)||eb.checknumber||chr(9)||f.sf_opportunity_id v_line     
 from course_dim cd
      inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
      inner join order_fact f on ed.event_id=f.event_id
      inner join cust_dim c on f.cust_id = c.cust_id
      left outer join slxdw.evxev_txfee et on f.txfee_id = et.evxev_txfeeid
      left outer join slxdw.evxbillpayment eb on et.evxbillingid = eb.evxbillingid
      left outer join cust_dim c2 on et.billtocontactid = c2.cust_id
      LEFT OUTER JOIN (SELECT accountid,
                                  ob_national_rep_id,
                                  ob_rep_id,
                                  ent_national_rep_id,
                                  ent_inside_rep_id,
                                  gk_segment segment,
                                  rep_4_id,
                                  rep_3_id
                             FROM qg_account@slx) qa
             ON c.acct_id = qa.accountid
      LEFT OUTER JOIN userinfo@slx ui ON ui.userid = qa.ob_rep_id
 where f.enroll_status_desc='EVENT CANCELLATION'
   and f.enroll_status='Cancelled'
   and trunc(f.enroll_status_date) >= v_date
   and f.book_amt <= 0;
   
v_file_name varchar2(50);
v_file_full varchar2(250);
v_hdr varchar2(500);
v_file utl_file.file_type;
v_msg_body varchar2(2000);
v_error number;
v_error_msg varchar2(500);
v_cancel_date date;
begin
if p_cancel_date is null then
  v_cancel_date := trunc(sysdate)-2;
else
  v_cancel_date := to_date(p_cancel_date,'mm/dd/yyyy');
end if;
v_file_name := 'DailyEventCancellations_'||to_char(trunc(sysdate)-1,'yyyymmdd')||'.xls';
v_file_full := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
v_hdr := 'Cancel Date'||chr(9)||'Start Date'||chr(9)||'Start Time'||chr(9)||'Event Country'||chr(9)||'Bill Contact'||chr(9)||'Bill Account'||chr(9)||'Bill Country'||chr(9)||'Currency'||chr(9)||'Enroll ID'||chr(9)||'Bill Address'||chr(9)||'PP Card';
v_hdr := v_hdr||chr(9)||'Contact ID'||chr(9)||'Account Name'||chr(9)||'Contact Name'||chr(9)||'Email'||chr(9)||'Course Code'||chr(9)||'Course Name'||chr(9)||'Salesrep'||chr(9)||'Metro'||chr(9)||'Keycode';
v_hdr := v_hdr||chr(9)||'Source'||chr(9)||'Book Amt'||chr(9)||'Fee Type'||chr(9)||'Type'||chr(9)||'Pay Method'||chr(9)||'PO Num'||chr(9)||'Check Number'||chr(9)||'SF Opportunity ID';

utl_file.put_line(v_file,v_hdr);
for r1 in c1(v_cancel_date) loop
  utl_file.put_line(v_file,r1.v_line);
end loop;
utl_file.fclose(v_file);


v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'smtp.globalknowledge.com',
          Sender    => 'DW.Automation@globalknowledge.com',
          Recipient => 'jack.broeren@globalknowledge.com',
          CcRecipient => 'katharine.braak@globalknowledge.com',
          BccRecipient => 'DW.Automation@globalknowledge.com',
          Subject   => 'Daily Event Cancellation Report-'||v_cancel_date,
          Body => 'Open Attachment',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'smtp.globalknowledge.com',
          Sender    => 'DW.Automation@globalknowledge.com',
          Recipient => 'krissi.fields@globalknowledge.com',
          CcRecipient => '',
          BccRecipient => 'cassie.hall@globalknowledge.com',
          Subject   => 'Daily Event Cancellation Report-'||v_cancel_date,
          Body => 'Open Attachment',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
          
          
--v_error:= SendMailJPkg.SendMail(
--          SMTPServerName => 'corpmail.globalknowledge.com',
--          Sender    => 'DW.Automation@globalknowledge.com',
--          Recipient => 'crystal.phillips@globalknowledge.com',
--          CcRecipient => '',
--          BccRecipient => '',
--          Subject   => 'Daily Event Cancellation Report-'||v_cancel_date,
--          Body => 'Open Attachment',
--          ErrorMessage => v_error_msg,
--          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
--v_error:= SendMailJPkg.SendMail(
--          SMTPServerName => 'corpmail.globalknowledge.com',
--          Sender    => 'DW.Automation@globalknowledge.com',
--          Recipient => 'alan.frelich@globalknowledge.com',
--          CcRecipient => '',
--          BccRecipient => '',
--          Subject   => 'Daily Event Cancellation Report-'||v_cancel_date,
--          Body => 'Open Attachment',
--          ErrorMessage => v_error_msg,
--          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
--v_error:= SendMailJPkg.SendMail(
--          SMTPServerName => 'corpmail.globalknowledge.com',
--          Sender    => 'DW.Automation@globalknowledge.com',
--          Recipient => 'sruthi.reddy@globalknowledge.com',
--          CcRecipient => '',
--          BccRecipient => '',
--          Subject   => 'Daily Event Cancellation Report-'||v_cancel_date,
--          Body => 'Open Attachment',
--          ErrorMessage => v_error_msg,
--          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));          
end;
/


