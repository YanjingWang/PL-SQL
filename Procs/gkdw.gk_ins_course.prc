DROP PROCEDURE GKDW.GK_INS_COURSE;

CREATE OR REPLACE PROCEDURE GKDW.gk_ins_course as

cursor c1 is
 select c.firstname||chr(9)||replace(c.lastname,'1','')||chr(9)||c.account||chr(9)||
     e.coursecode||chr(9)||co.shortname||chr(9)||co.coursecategory||chr(9)||e.startdate c_line
   from slxdw.contact c
       inner join slxdw.qg_eventinstructors ei on c.contactid = ei.contactid
       inner join slxdw.evxevent e on ei.evxeventid = e.evxeventid
       inner join slxdw.evxcourse co on e.evxcourseid = co.evxcourseid
  where to_char(startdate,'YYYY-WW') = to_char(sysdate+14,'YYYY-WW')
    and not exists (select 1 from slxdw.evxevent e2
                          inner join slxdw.qg_eventinstructors ei2 on e2.evxeventid = ei2.evxeventid
                    where e.coursecode = e2.coursecode
                      and ei.contactid = ei2.contactid
                      and to_char(startdate,'YYYY-WW') < to_char(sysdate+14,'YYYY-WW'))
 order by startdate;

ins_file varchar2(50);
ins_file_full varchar2(250);
ins_hdr varchar2(1000);
c_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);

begin

select 'INST_FIRST_COURSE.xls','/usr/tmp/'||'INST_FIRST_COURSE.xls'
    into ins_file,ins_file_full
    from dual;

c_file := utl_file.fopen('/usr/tmp',ins_file,'w');

select 'Firstname'||chr(9)||'Lastname'||chr(9)||'Account'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||
        'Product Line'||chr(9)||'Start Date'
    into ins_hdr
    from dual;

utl_file.put_line(c_file,ins_hdr);

for r1 in c1 loop
   utl_file.put_line(c_file,r1.c_line);
end loop;

utl_file.fclose(c_file);

  v_mail_hdr := 'First Course Instructor';

  v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'nc10s250.globalknowledge.com',
                Sender    => 'SQLService@globalknowledge.com',
                Recipient => 'ResourceCoordinator.NAM@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => 'alan.frelich@globalknowledge.com',
                Subject   => v_mail_hdr,
                Body => 'First time course taught by instructor.',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(ins_file_full));

exception
  when others then
    rollback;
    utl_file.fclose(c_file);
    dbms_output.put_line(SQLERRM);

end;
/


