DROP PROCEDURE GKDW.GK_IBM_AFF_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ibm_aff_proc as

cursor c1 is
select null title,first_name,last_name,userid,email,null email_address_cc,null manager_name,
       orgid,null accesscode,language,workphone,coursecode,modality,class_num,customer_num,oid,start_date,
       end_date,studentid,log_num,enrollstat,contact_name,customer_name,email_type,brand_id,insertts,
       create_time,quantity,delivery_type,null course_title,org_id,inv_org_id,le,fe,acct,ch,md,pl,act,cc,
       po_line_desc,po_line_amt,country_id,
       null||chr(44)||first_name||chr(44)||last_name||chr(44)||email||chr(44)||null||chr(44)||email||chr(44)||null||chr(44)||orgid||chr(44)||null||chr(44)||
       'EN'||chr(44)||workphone||chr(44)||coursecode||chr(44)||class_num||chr(44)||customer_num||chr(44)||oid||chr(44)||
       to_char(start_date,'yyyy-mm-dd')||chr(44)||to_char(end_date,'yyyy-mm-dd')||chr(44)||studentid||chr(44)||log_num||chr(44)||
       enrollstat||chr(44)||contact_name||chr(44)||customer_name||chr(44)||
       country_id||chr(44)||email_type||chr(44)||brand_id||chr(44)||insertts||chr(44)||create_time||chr(44)||quantity||chr(44)||
       delivery_type||chr(44)||null aff_line
from gk_ibm_aff_data_mv a
where not exists (select 1 from gk_ibm_aff_exceptions e where a.enroll_id = e.enroll_id);

cursor c2 is
select distinct cd.course_code,cd.mfg_course_code,f.enroll_id,f.cust_id,ed.event_id,
       f.book_date,c.cust_name,c.email
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id
 where cd.md_num = '32'
   and cd.course_pl = 'IBM'
   and f.enroll_status != 'Cancelled'
   and cd.mfg_course_code not in ('ZM645G','6S133G','6S130G','VW005G','ZB727G','ZB728G','0Q206G','9S323G','TOS51G','ZB562G','ZU802G','9W720G','2T204G','DW001G+DW002G')
   and not exists (select 1 from gk_ibm_aff_audit a where f.enroll_id = a.enroll_id)
   and not exists (select 1 from ibm_tier_xml tx where cd.mfg_course_code = tx.coursecode);
   
cursor c3(v_req_id number) is   
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id;
   
aff_file utl_file.file_type;
aff_file_name varchar2(100);
aff_file_name_full varchar2(250);
v_hdr varchar2(2000);
v_error number;
v_error_msg varchar2(500);
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;
v_curr_po varchar2(25);
v_line_num number := 1;
vcode_comb_id number;
l_req_id number;
loop_cnt number;
v_msg_body long;
v_requestor number := 10470; --Thomas Foschi


begin

gk_mfg_course_update_proc;
dbms_snapshot.refresh('gkdw.gk_ibm_aff_data_mv');

open c1;fetch c1 into r1;
if c1%found then
  close c1;
  
  select gk_get_curr_po(84,'R12PRD') into v_curr_po from dual;
  gk_update_curr_po(84,'R12PRD');

  gkn_po_create_hdr_proc@r12prd(v_curr_po,7899,'REMIT-ATLANTA53',84,264,'USD','IBM SPEL WEB - AFF FEED PO');

  commit;
    
  select 'gk_ibm_aff_us.csv',
         '/mnt/nc10s210_ibm_aff/gk_ibm_aff_us.csv'
    into aff_file_name,aff_file_name_full
    from dual;
  
  aff_file := utl_file.fopen('/mnt/nc10s210_ibm_aff',aff_file_name,'w');

  v_hdr := 'Title'||chr(44)||'First Name'||chr(44)||'Surname'||chr(44)||'UserID'||chr(44)||'Email address'||chr(44)||'Email address CC'||chr(44)||'Manager Name'||chr(44);
  v_hdr := v_hdr||'OrgID'||chr(44)||'AccessCode'||chr(44)||'Language'||chr(44)||'Phone'||chr(44)||'Course Code '||chr(44)||'Class Num'||chr(44)||'Customer Num'||chr(44)||'OID'||chr(44);
  v_hdr := v_hdr||'Start Date'||chr(44)||'End Date'||chr(44)||'StudentID'||chr(44)||'Log Num'||chr(44)||'EnrolStat'||chr(44)||'Contact Name'||chr(44)||'Customer Name'||chr(44)||'Country'||chr(44);
  v_hdr := v_hdr||'EmailType'||chr(44)||'BrandID'||chr(44)||'InsertTS'||chr(44)||'Create Time'||chr(44)||'Quantity'||chr(44)||'DeliveryType'||chr(44)||'CourseTitle';

  utl_file.put_line(aff_file,v_hdr);

  for r1 in c1 loop
    utl_file.put_line(aff_file,r1.aff_line);
  
    insert into gk_ibm_aff_audit
      select r1.log_num,r1.userid,r1.email,r1.start_date,sysdate,v_curr_po,v_line_num from dual;   
    commit;
    
    vcode_comb_id := gkn_get_account@r12prd(r1.le,r1.fe,r1.acct,r1.ch,r1.md,r1.pl,r1.act,r1.cc);
  
    gkn_po_create_line_proc@r12prd(v_line_num,null,r1.po_line_desc,'EACH',r1.quantity,r1.po_line_amt,r1.start_date,r1.inv_org_id,r1.org_id,vcode_comb_id,'CARY',v_requestor,r1.class_num,126);

    commit;
    
    v_line_num := v_line_num + 1;
  
  end loop;
  utl_file.fclose(aff_file);


  fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;  -- US REQUEST

  l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');

  commit;
  
  v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'DW.Automation@globalknowledge.com',
          Recipient => 'TechSupport@globalknowledge.com',
          CcRecipient => '',
          BccRecipient => '',
          Subject   => 'SPEL WEB AFF FILE FEED SENT: '||to_char(sysdate,'yyyy-mm-dd hh24miss'),
          Body => 'PO CREATED: '||v_curr_po,
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(aff_file_name_full));
          
  loop_cnt := 1;
  while loop_cnt < 5 loop
    open c3(l_req_id);
    fetch c3 into r3;
    if r3.phase_code = 'C' then
      loop_cnt := 5;
      dbms_lock.sleep(15);
      gk_receive_po_proc(v_curr_po,'R12PRD');
      gk_receive_request_proc('R12PRD');
    else
      loop_cnt := loop_cnt+1;
      dbms_lock.sleep(15);
    end if;
    close c3;
  end loop;
  commit;

end if;

open c2;fetch c2 into r2;
if c2%found then

  v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=8></th></tr>';
  v_msg_body := v_msg_body||'<tr><th colspan=8>IBM SPeL Web Course Issues</th></tr>';
  v_msg_body := v_msg_body||'<tr height=1><th bgcolor="black" colspan=8></th></tr>';
  v_msg_body := v_msg_body||'<tr valign="top"><th>Course Code</th><th>Mfg Course Code</th><th>Enroll ID</th><th>Cust ID</th><th>Event ID</th><th>Book Date</th><th>Cust Name</th><th>Email</th></tr>';
  close c2;
  for r2 in c2 loop
    v_msg_body := v_msg_body||'<tr valign="top"><td>'||r2.course_code||'</td><td>'||r2.mfg_course_code||'</td><td>'||r2.enroll_id||'</td><td>'||r2.cust_id||'</td>';
    v_msg_body := v_msg_body||'<td>'||r2.event_id||'</td><td>'||r2.book_date||'</td><td>'||r2.cust_name||'</td><td>'||r2.email||'</td></tr>'; 
  end loop;
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=8></th></tr></table>';
  v_msg_body := v_msg_body||'<p></body></html>';
  
  send_mail('DW.Automation@globalknowledge.com','TechSupport@globalknowledge.com','IBM SPeL Web Course Issue',v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','kimberly.freeman@globalknowledge.com','IBM SPeL Web Course Issue',v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','katherine.milan@globalknowledge.com','IBM SPeL Web Course Issue',v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','donovan.scott@globalknowledge.com','IBM SPeL Web Course Issue',v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','wanda.mills@globalknowledge.com','IBM SPeL Web Course Issue',v_msg_body);
else
  close c2;
end if;


exception
  when others then
    rollback;
    utl_file.fclose(aff_file);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_IBM_AFF_PROC Failed',SQLERRM);


end;
/


