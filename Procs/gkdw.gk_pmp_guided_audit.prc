DROP PROCEDURE GKDW.GK_PMP_GUIDED_AUDIT;

CREATE OR REPLACE PROCEDURE GKDW.gk_pmp_guided_audit as
cursor c1 is
  select distinct cust_id from gk_pmp_v;
cursor c2(p_cust varchar2) is
  select g.course_code||chr(9)||p.event_id||chr(9)||p.start_date||chr(9)||p.cust_name||chr(9)||
         p.acct_name||chr(9)||p.enroll_date||chr(9)||p.enroll_status||chr(9)||p.sales_rep p_line
    from gk_pmp_guided g
    left outer join gk_pmp_v p on g.course_code = p.course_code and p.cust_id = p_cust
  order by g.course_code;
v_file_name varchar2(50);
v_file_full varchar2(250);
v_hdr varchar2(500);
v_file utl_file.file_type;
v_mail_hdr varchar2(500) := 'PMP Guided Program Audit Report';
v_error number;
v_error_msg varchar2(500);
begin
v_file_name := 'PMPGuidedAudit.xls';
v_file_full := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
select 'Course Code'||chr(9)||'Event ID'||chr(9)||'Start Date'||chr(9)||'Customer'||chr(9)||'Account'||chr(9)||
       'Enroll Date'||chr(9)||'Status'||chr(9)||'Sales Rep'
  into v_hdr
  from dual;
utl_file.put_line(v_file,v_hdr);
for r1 in c1 loop
  for r2 in c2(r1.cust_id) loop
    utl_file.put_line(v_file,r2.p_line);
  end loop;
  utl_file.put_line(v_file,null);
end loop;
utl_file.fclose(v_file);
v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'cait.bauer@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'PMP Guided Program Audit Report',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));

exception
  when others then
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);
end;
/


