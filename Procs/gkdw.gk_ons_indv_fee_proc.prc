DROP PROCEDURE GKDW.GK_ONS_INDV_FEE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ons_indv_fee_proc as

cursor c1 is
 select c.evxcourseid||chr(9)||c.coursecode||chr(9)||c.coursename||chr(9)||currency c_line
 from evxcourse c
    inner join evxcoursefee cf on c.evxcourseid = cf.evxcourseid 
 where isinactive = 'F'
    and feetype = 'Ons - Base'
    and c.coursecode <> '4729G'
    and not exists
        (
        select 1 from evxcoursefee cf2 
        where c.evxcourseid = cf2.evxcourseid 
            and feetype = 'Ons - Individual'
        )
 order by coursecode;

fee_file varchar2(50);
fee_file_full varchar2(250);
fee_hdr varchar2(1000);
c_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
recct number;

begin
    recct := 0;
    select 'MISSING_ONS_INDV_FEE_REPORT.xls','/usr/tmp/'||'MISSING_ONS_INDV_FEE_REPORT.xls'
        into fee_file,fee_file_full
        from dual;

    c_file := utl_file.fopen('/usr/tmp',fee_file,'w');

    select 'Course ID'||chr(9)||'Course Code'||chr(9)||'Course Name'||chr(9)||'Fee Country'
        into fee_hdr
     from dual;

    utl_file.put_line(c_file,fee_hdr);

    for r1 in c1 loop
    utl_file.put_line(c_file,r1.c_line);
    recct := recct +1;
    end loop;

    utl_file.fclose(c_file);

    v_mail_hdr := 'Courses Missing Onsite Individual Fee';

    if recct > 0 then
    v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'SQLService@globalknowledge.com',
                Recipient => 'pm@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Missing Onsite Individual Fees',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(fee_file_full));
    end if;
    exception
      when others then
        rollback;
        utl_file.fclose(c_file);
        dbms_output.put_line(SQLERRM);

end;
/


