DROP PROCEDURE GKDW.GK_STATFILE_GEN;

CREATE OR REPLACE PROCEDURE GKDW.gk_statfile_gen(pname varchar2) as

cursor c1(v_pname varchar2) is
  select s.period_name||chr(9)||s.event_id||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
           facility_code||chr(9)||ed.start_date||chr(9)||ad.acct_desc||chr(9)||
           decode(s.le_num,'210',2,'220',4)||chr(9)||'Revenue'||chr(9)||
           'Statistical'||chr(9)||s.le_num||chr(9)||s.fe_num||chr(9)||s.acct_num||chr(9)||s.ch_num||chr(9)||
           s.md_num||chr(9)||s.pl_num||chr(9)||s.act_num||chr(9)||s.cc_num||chr(9)||s.fut_num||chr(9)||
           to_char(debit)||chr(9)||decode(s.le_num,'210','Month end US statistics','220','Month end CAN statistics') stat_line
  from gk_stats_v s
          left outer join event_dim ed on s.event_id = ed.event_id and ed.course_code not in ('3163N','3164N','3163C','3164C')
          inner join acct_dim ad on s.acct_num = ad.acct_value
  where s.period_name = v_pname
  order by s.event_id,s.acct_num;

per_name varchar2(20);
stat_file varchar2(50);
stat_file_gl varchar2(250);
stat_file_tc varchar2(250);
stat_file_inst varchar2(250);
stat_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);

begin

select 'STATLOAD-'||pname||'.xls','/usr/tmp/'||'STATLOAD-'||pname||'.xls'
  into stat_file,stat_file_gl
  from dual;

v_file := utl_file.fopen('/usr/tmp',stat_file,'w');

select 'Period Name'||chr(9)||'Event ID'||chr(9)||'Course Code'||chr(9)||'Metro Area'||chr(9)||
          'Facility Code'||chr(9)||'Start Date'||chr(9)||'Stat Account'||chr(9)||
          'SOB ID'||chr(9)||'Category'||chr(9)||'Source'||chr(9)||'LE'||chr(9)||'FE'||chr(9)||'ACCT'||chr(9)||'CH'||chr(9)||
          'MD'||chr(9)||'PL'||chr(9)||'ACT'||chr(9)||'CC'||chr(9)||'FUT'||chr(9)||
          'STAT AMT'||chr(9)||'Reference'
    into stat_hdr
   from dual;

utl_file.put_line(v_file,stat_hdr);

for r1 in c1(pname) loop
   utl_file.put_line(v_file,r1.stat_line);
end loop;

utl_file.fclose(v_file);

v_mail_hdr := pname||' Statistic Files';

v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'coprmail.globalknowledge.com',
                Sender    => 'DW.Automation@globalknowledge.com',
                Recipient => 'connie.cook@globalknowledge.com',
                CcRecipient => 'john.nealis@globalknowledge.com',
                BccRecipient => 'christy.murdock@globalknowledge.com',
                Subject   => v_mail_hdr,
                Body => 'Monthly Statistic Files',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(stat_file_gl));

exception
  when others then
    rollback;
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);

end;
/


