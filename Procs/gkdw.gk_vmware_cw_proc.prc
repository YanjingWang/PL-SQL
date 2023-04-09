DROP PROCEDURE GKDW.GK_VMWARE_CW_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_vmware_cw_proc as

cursor c0 is
select distinct ed.event_id,cd.course_code||'_'||to_char(ed.start_date,'yyyy-mm-dd')||'_'||ed.facility_region_metro||'('||ed.event_id||')' fname
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.country
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
 where cd.pl_num = 11
   and cd.ch_num = 10
   and cd.md_num in (10,20)
   and td1.dim_year = td2.dim_year
   and td1.dim_week = td2.dim_week+1
 order by 1;
 
cursor c1(v_event_id varchar2) is
select ed.event_id,cd.course_code,ed.start_date,ed.end_date,ed.facility_code,
       c.first_name,c.last_name,c.email,c.acct_name,c.address1,c.address2,c.city,c.state,c.zipcode postal_code,c.country,
       c.first_name||chr(9)||c.last_name||chr(9)||c.email||chr(9)||c.acct_name||chr(9)||c.address1||chr(9)||c.address2||chr(9)||c.city||chr(9)||c.state||chr(9)||c.zipcode||chr(9)||c.country v_line
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.country
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
 where ed.event_id = v_event_id
 order by last_name,first_name;
 
v_file_name varchar2(250);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
x varchar2(1000);

begin

for r0 in c0 loop

  select 'vmware_digital_cw_'||r0.fname||'.xls',
         '/usr/tmp/vmware_digital_cw_'||r0.fname||'.xls'
    into v_file_name,v_file_name_full
    from dual;
    
  select 'First Name'||chr(9)||'Last Name'||chr(9)||'Email'||chr(9)||'Company'||chr(9)||'Address'||chr(9)||'Address2'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Postal Code'||chr(9)||'Country'
    into v_hdr
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

  utl_file.put_line(v_file,v_hdr);
  
  for r1 in c1(r0.event_id) loop
    utl_file.put_line(v_file,r1.v_line);
  end loop;
  
  utl_file.fclose(v_file);
  
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'DW.Automation@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'VMWARE Digitial Courseware File',
             Body => 'Open Excel Attachment to view courseware orders for VMWARE event.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
end loop;

end;
/


