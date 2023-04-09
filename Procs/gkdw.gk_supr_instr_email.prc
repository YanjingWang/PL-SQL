DROP PROCEDURE GKDW.GK_SUPR_INSTR_EMAIL;

CREATE OR REPLACE PROCEDURE GKDW.gk_supr_instr_email as
cursor c1 is
select e.evxeventid,coursecode,facilityregionmetro,shortname,
    startdate,firstname,lastname,feecode,email
from slxdw.evxevent e 
  inner join slxdw.qg_eventinstructors ei on e.evxeventid = ei.evxeventid
  inner join slxdw.contact c on ei.contactid = c.contactid
  inner join slxdw.evxcourse co on e.evxcourseid = co.evxcourseid
where to_char(sysdate+14,'YYYY-DDD') = to_char(startdate,'YYYY-DDD') 
 and eventstatus = 'Open'
 and feecode = 'SI'
 and e.evxeventid in (select distinct e2.evxeventid 
             from slxdw.evxevent e2 
                         inner join slxdw.qg_eventinstructors i2 on e2.evxeventid = i2.evxeventid
              where upper(feecode) in ('AUD','FA','PI','CT'))
union
select e.evxeventid,coursecode,facilityregionmetro,shortname
    ,startdate,firstname,lastname,feecode,email
from slxdw.evxevent e 
  inner join slxdw.qg_eventinstructors ei on e.evxeventid = ei.evxeventid
  inner join slxdw.contact c on ei.contactid = c.contactid
  inner join slxdw.evxcourse co on e.evxcourseid = co.evxcourseid
where feecode = 'SI'
   and e.evxeventid in (select distinct e2.evxeventid 
             from slxdw.evxevent e2 
                         inner join slxdw.qg_eventinstructors i2 on e2.evxeventid = i2.evxeventid
              where trunc(i2.modifydate) between trunc(startdate)-14 and trunc(startdate)
          and trunc(i2.modifydate) = trunc(sysdate)-1
          and upper(feecode) in ('AUD','FA','PI','CT'))
order by 1,8 desc;
cursor c2 (v_eventid varchar2) is
select distinct e.evxeventid,firstname,lastname,email
from slxdw.evxevent e 
  inner join slxdw.qg_eventinstructors ei on e.evxeventid = ei.evxeventid
  inner join slxdw.contact c on ei.contactid = c.contactid
where e.evxeventid = v_eventid
 and upper(feecode) in ('AUD','FA','PI','CT')
order by 1;
sname varchar2(32);
metro varchar2(32);
stdate varchar2(25);
si_fullname varchar2(100);
exp_chart_file  varchar2(100);
checklist_file  varchar2(100);
inst_inv_file varchar2(100);
v_file_name varchar2(250);
v_file_full varchar2(250);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
begin
for r1 in c1 loop
 sname := null;
 metro := null;
 stdate := null;
 si_fullname := null;
 sname := r1.shortname;
 metro := r1.facilityregionmetro;
 stdate := to_char(r1.startdate,'MM/DD/YYYY');
 si_fullname := r1.firstname || ' ' || r1.lastname;
 select 'Instructions-'||si_fullname||'.html','/usr/tmp/'||'Instructions-'||si_fullname||'.html'
    into v_file_name,v_file_full
   from dual;
 v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
 utl_file.put_line(v_file,'<head><style>.style2 {color: #0033CC}</style></head><body>');
 utl_file.put_line(v_file,'<p class="style1">' || r1.firstname || ',</p>');
 utl_file.put_line(v_file,'<p>You are scheduled to be the supervising instructor for the following auditors:</p><ol>');
  for r2 in c2(r1.evxeventid) loop
    utl_file.put_line(v_file,'<li>' || r2.firstname || ' ' || r2.lastname || ' - ' || r2.email || '</a></li>');
  end loop;
 utl_file.put_line(v_file,'</ol><p>Attached  are the documents needed.</p><p>');
 utl_file.put_line(v_file,'<p><span class="style2"><strong>Dennis Pinto</strong><strong><br />');
 utl_file.put_line(v_file,'<strong>Instructor Recruiter</strong><br /></strong><br />');
 utl_file.put_line(v_file,'9000 Regency Pkwy <br />Suite 500 <br />Cary, NC 27511 <br />800 268 7737<br />');
 utl_file.put_line(v_file,'919 460 3277 <br />f- 919 468 4977 <br />');
 utl_file.put_line(v_file,'<a href="mailto:dennis.pinto@globalknowledge.com" title="mailto:dennis.pinto@globalknowledge.com">dennis.pinto@globalknowledge.com</a>');
 utl_file.put_line(v_file,'<br /><br />LEARNING. To Make a Difference <br />');
 utl_file.put_line(v_file,'<a href="http://www.globalknowledge.com" title="http://www.globalknowledge.com/">http://www.globalknowledge.com</a></span></p>');
 utl_file.put_line(v_file,'</body></html>');
 utl_file.fclose(v_file);
 v_mail_hdr := 'Supervising Instructor - ' || sname || ' ' || metro || ' ' || stdate;
 exp_chart_file := '/usr/tmp/Expense Chart.pdf';
 checklist_file := '/usr/tmp/New Instructor Audit Checklist.pdf';
 inst_inv_file := '/usr/tmp/Instructor Invoice.xls';
 v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'SQLService@globalknowledge.com',
                Recipient => r1.email,
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Open the HTML attachment to view the instructions.',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full,exp_chart_file,checklist_file,inst_inv_file));
end loop;
end;
/


