DROP PROCEDURE GKDW.GK_INST_AUDIT;

CREATE OR REPLACE PROCEDURE GKDW.gk_inst_audit as

cursor c1 is
select e.evxeventid||chr(9)||coursecode||chr(9)||facilityregionmetro||chr(9)||shortname
    ||chr(9)||startdate||chr(9)||firstname||chr(9)||lastname||chr(9)||feecode c_line
from slxdw.evxevent e
  inner join slxdw.qg_eventinstructors ei on e.evxeventid = ei.evxeventid
  inner join slxdw.contact c on ei.contactid = c.contactid
  inner join slxdw.evxcourse co on e.evxcourseid = co.evxcourseid
where to_char(sysdate+7,'YYYY-WW') = to_char(startdate,'YYYY-WW')
   and e.evxeventid in (select e2.evxeventid from slxdw.evxevent e2
                  inner join slxdw.qg_eventinstructors i2 on e2.evxeventid = i2.evxeventid
         where upper(feecode) in ('AUD','FA','PI','CT'))
order by e.evxeventid,feecode desc;

inst_file varchar2(50);
inst_file_full varchar2(250);
inst_hdr varchar2(1000);
c_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);

begin

select 'INST_AUDIT.xls','/usr/tmp/'||'INST_AUDIT.xls'
    into inst_file,inst_file_full
    from dual;

c_file := utl_file.fopen('/usr/tmp',inst_file,'w');

select 'Event_ID'||chr(9)||'Course Code'||chr(9)||'Metro'||chr(9)||'Short Name'||chr(9)||'Start Date'||chr(9)||'First Name'||chr(9)||
        'Last Name'||chr(9)||'Fee Code'
    into inst_hdr
    from dual;

utl_file.put_line(c_file,inst_hdr);

for r1 in c1 loop
   utl_file.put_line(c_file,r1.c_line);
end loop;

utl_file.fclose(c_file);

  v_mail_hdr := 'Auditing Instructors';

  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'SQLService@globalknowledge.com',
                Recipient => 'tcmgrs@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Auditing Instructors',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(inst_file_full));

exception
  when others then
    rollback;
    utl_file.fclose(c_file);
    dbms_output.put_line(SQLERRM);

end;
/


