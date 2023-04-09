DROP PROCEDURE GKDW.GK_CAP_ALERT_SB;

CREATE OR REPLACE PROCEDURE GKDW.gk_cap_alert_sb as

cursor c1 is
 select e.coursecode||chr(9)||c.shortname||chr(9)||e.startdate||chr(9)||e.facilityregionmetro||chr(9)||
    e.facilityname||chr(9)||e.availenrollment||chr(9)||e.maxenrollment||chr(9)||amount||chr(9)||e.facilitycountry c_line
 from evxevent e
    inner join evxcourse c on e.evxcourseid = c.evxcourseid
    inner join evxcoursefee cf on c.evxcourseid = cf.evxcourseid
        and e.facilitycountry = cf.pricelist
 where e.eventstatus = 'Open'
    and e.startdate >= trunc(sysdate)
    and e.availenrollment <= 3
    and substr(e.coursecode,5,1) not in ('D','G','R','U','V')
    and cf.feetype = 'Primary'
    and cf.feeallowuse = 'T'
 order by e.coursecode,e.startdate;

cap_file varchar2(50);
cap_file_full varchar2(250);
cap_hdr varchar2(1000);
c_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);

begin

select 'CAP_REPORT.xls','/usr/tmp/'||'CAP_REPORT.xls'
    into cap_file,cap_file_full
    from dual;

c_file := utl_file.fopen('/usr/tmp',cap_file,'w');

select 'Course Code'||chr(9)||'Short Name'||chr(9)||'Start Date'||chr(9)||'Metro'||chr(9)||'Facility'||chr(9)||
        'Avail Enroll'||chr(9)||'Max Enroll'||chr(9)||'Primary Fee'||chr(9)||'Country'
    into cap_hdr
    from dual;

utl_file.put_line(c_file,cap_hdr);

for r1 in c1 loop
   utl_file.put_line(c_file,r1.c_line);
end loop;

utl_file.fclose(c_file);

  v_mail_hdr := 'Event Capacity Report';

  v_error:= sb_SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'SQLService@globalknowledge.com',
                Recipient => 'smaranika.baral@globalknowledge.com',
                CcRecipient => 'bala.subramanian@globalknowledge.com',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'gk_cap_alert_sb test',
                ErrorMessage => v_error_msg,
                Attachments  => sb_SendMailJPkg.ATTACHMENTS_LIST(cap_file_full));

exception
  when others then
    rollback;
    utl_file.fclose(c_file);
    dbms_output.put_line(SQLERRM);

end;
/


