DROP PROCEDURE GKDW.GK_CANADIAN_ONSITE_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_canadian_onsite_audit_proc as

cursor c1 is
select gk_sales_opportunityid||chr(9)||createdate||chr(9)||createdby||chr(9)||curr_idr_status||chr(9)||curr_fdc_status||chr(9)||
       evxeventid||chr(9)||eventstatus||chr(9)||coursecode||chr(9)||startdate||chr(9)||enddate||chr(9)||city||chr(9)||stprov||chr(9)||
       numattendees||chr(9)||account||chr(9)||nettprice||chr(9)|| --replace(replace(facilitynotes,chr(13),''),chr(10),'')||chr(9)||
       country||chr(9)||coursename||chr(9)||description||chr(9)||evxevenrollid||chr(9)||enrollqty||chr(9)||
       enrollstatus||chr(9)||attendeetype||chr(9)||salesrep v_line
  from gk_onsite_audit_v@slx
 where evxevenrollid is null
 order by createdate desc;

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
r1 c1%rowtype;


begin

select 'gk_can_onsite_audit_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/gk_can_onsite_audit_'||to_char(sysdate,'yyyymmdd')||'.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'GK_SALES_OPPORTUNITYID'||chr(9)||'CREATEDATE'||chr(9)||'CREATEDBY'||chr(9)||'CURR_IDR_STATUS'||chr(9)||'CURR_FDC_STATUS'||chr(9)||
       'EVXEVENTID'||chr(9)||'EVENTSTATUS'||chr(9)||'COURSECODE'||chr(9)||'STARTDATE'||chr(9)||'ENDDATE'||chr(9)||'CITY'||chr(9)||
       'STPROV'||chr(9)||'NUMATTENDEES'||chr(9)||'ACCOUNT'||chr(9)||'NETTPRICE'||chr(9)||'COUNTRY'||chr(9)||
       'COURSENAME'||chr(9)||'DESCRIPTION'||chr(9)||'EVXEVENROLLID'||chr(9)||'ENROLLQTY'||chr(9)||'ENROLLSTATUS'||chr(9)||
       'ATTENDEETYPE'||chr(9)||'SALESREP'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

open c1; loop
  fetch c1 into r1; exit when c1%NOTFOUND;
  utl_file.put_line(v_file,r1.v_line);
end loop;
close c1;
commit;


utl_file.fclose(v_file);

v_error := SendMailJPkg.SendMail(
           SMTPServerName => 'corpmail.globalknowledge.com',
           Sender    => 'DW.Automation@globalknowledge.com',
           Recipient => 'stella.corbett@globalknowledge.com',
           CcRecipient => '',
           BccRecipient => '',
           Subject   => 'Canadian Onsite Audit Report',
           Body => 'Automated email with Canadian Onsite Audit Data.',
           ErrorMessage => v_error_msg,
           Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));


exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CANADIAN_ONSITE_AUDIT_PROC Procedure Failed',SQLERRM);

end;
/


