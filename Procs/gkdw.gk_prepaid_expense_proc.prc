DROP PROCEDURE GKDW.GK_PREPAID_EXPENSE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_prepaid_expense_proc as
cursor c1 is
  select org_id,req_num,creation_date,full_name,authorization_status,vendor_name,unit_price,quantity,
         line_amt,dist_code,description,
         org_id||chr(9)||req_num||chr(9)||creation_date||chr(9)||full_name||chr(9)||authorization_status||chr(9)||vendor_name||chr(9)||
         unit_price||chr(9)||quantity||chr(9)||line_amt||chr(9)||dist_code||chr(9)||description v_line
    from gk_prepaid_expense_v@r12prd
   where req_type = 'ACCT'
   order by creation_date;
   
cursor c2 is
  select org_id,req_num,creation_date,full_name,authorization_status,vendor_name,unit_price,quantity,
         line_amt,dist_code,description,
         org_id||chr(9)||req_num||chr(9)||creation_date||chr(9)||full_name||chr(9)||authorization_status||chr(9)||vendor_name||chr(9)||
         unit_price||chr(9)||quantity||chr(9)||line_amt||chr(9)||dist_code||chr(9)||description v_line
    from gk_prepaid_expense_v@r12prd
   where req_type = 'IT'
   order by creation_date;
   
cursor c3 is
  select org_id,req_num,creation_date,full_name,authorization_status,vendor_name,unit_price,quantity,
         line_amt,dist_code,description,
         org_id||chr(9)||req_num||chr(9)||creation_date||chr(9)||full_name||chr(9)||authorization_status||chr(9)||vendor_name||chr(9)||
         unit_price||chr(9)||quantity||chr(9)||line_amt||chr(9)||dist_code||chr(9)||description v_line
    from gk_prepaid_expense_v@r12prd
   where req_type = 'DMOC'
   order by creation_date;
   
v_file_name varchar2(50);
v_file_full varchar2(250);
v_hdr varchar2(500);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;
begin
open c1;fetch c1 into r1;
if c1%found then
  v_file_name := 'ReqPrepaidExpense.xls';
  v_file_full := '/usr/tmp/'||v_file_name;
  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  v_mail_hdr := 'Prepaid Expense Requisition Audit Report';
  select 'Org ID'||chr(9)||'Req Num'||chr(9)||'Created'||chr(9)||'Requestor'||chr(9)||'Status'||chr(9)||'Vendor'||chr(9)||'Unit Price'||chr(9)||
         'Quantity'||chr(9)||'Line Amt'||chr(9)||'Distribution Code'||chr(9)||'Description'
    into v_hdr
    from dual;
  utl_file.put_line(v_file,v_hdr);
  close c1;
  for r1 in c1 loop
    utl_file.put_line(v_file,r1.v_line);
  end loop;
  utl_file.fclose(v_file);
  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'sheila.jacobs@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Requisition Prepaid Expense Audit Report',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'Al.Koltas@globalknowledge.com',
                CcRecipient => '', --'Joy.Pruitt@globalknowledge.com',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Requisition Prepaid Expense Audit Report',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
end if;

open c2;fetch c2 into r2;
if c2%found then
  v_file_name := 'SoftwareExpenses.xls';
  v_file_full := '/usr/tmp/'||v_file_name;
  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  v_mail_hdr := 'Software Requisition Audit Report';
  select 'Org ID'||chr(9)||'Req Num'||chr(9)||'Created'||chr(9)||'Requestor'||chr(9)||'Status'||chr(9)||'Vendor'||chr(9)||'Unit Price'||chr(9)||
         'Quantity'||chr(9)||'Line Amt'||chr(9)||'Distribution Code'||chr(9)||'Description'
    into v_hdr
    from dual;
  utl_file.put_line(v_file,v_hdr);
  close c2;
  for r2 in c2 loop
    utl_file.put_line(v_file,r2.v_line);
  end loop;
  utl_file.fclose(v_file);
  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'DW.Automation@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Software Requisition Audit Report',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
end if;

open c3;fetch c3 into r3;
if c3%found then
  v_file_name := 'DMOCExpense.xls';
  v_file_full := '/usr/tmp/'||v_file_name;
  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  v_mail_hdr := 'DMOC PO Audit Report';
  select 'Org ID'||chr(9)||'Req Num'||chr(9)||'Created'||chr(9)||'Requestor'||chr(9)||'Status'||chr(9)||'Vendor'||chr(9)||'Unit Price'||chr(9)||
         'Quantity'||chr(9)||'Line Amt'||chr(9)||'Distribution Code'||chr(9)||'Description'
    into v_hdr
    from dual;
  utl_file.put_line(v_file,v_hdr);
  close c3;
  for r3 in c3 loop
    utl_file.put_line(v_file,r3.v_line);
  end loop;
  utl_file.fclose(v_file);
  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'Al.Koltas@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'DMOC PO Audit Report',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));

end if;


end;
/


