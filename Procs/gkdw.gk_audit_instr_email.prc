DROP PROCEDURE GKDW.GK_AUDIT_INSTR_EMAIL;

CREATE OR REPLACE PROCEDURE GKDW.gk_audit_instr_email as
cursor c1 is
select e.evxeventid,shortname,facilityregionmetro,startdate,
  firstname,lastname,email
from slxdw.evxevent e 
  inner join slxdw.qg_eventinstructors ei on e.evxeventid = ei.evxeventid
  inner join slxdw.contact c on ei.contactid = c.contactid
  inner join slxdw.evxcourse co on e.evxcourseid = co.evxcourseid
where to_char(sysdate+14,'YYYY-DDD') = to_char(startdate,'YYYY-DDD') 
  and eventstatus = 'Open'  
  and upper(feecode) in ('AUD','FA','PI','CT')
union
select e.evxeventid,shortname,facilityregionmetro,startdate,
  firstname,lastname,email
from slxdw.evxevent e 
  inner join slxdw.qg_eventinstructors ei on e.evxeventid = ei.evxeventid
  inner join slxdw.contact c on ei.contactid = c.contactid
  inner join slxdw.evxcourse co on e.evxcourseid = co.evxcourseid
where trunc(ei.modifydate) between trunc(startdate)-14 and trunc(startdate)
  and trunc(ei.modifydate) = trunc(sysdate)-1
  and upper(feecode) in ('AUD','FA','PI','CT')
order by 1 desc;
sname varchar2(32);
metro varchar2(32);
stdate varchar2(25);
fullname varchar2(100);
inst_inv_file  varchar2(100);
checklist_file  varchar2(100);
questionnaire_file varchar2(100);
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
 fullname := null;
 sname := r1.shortname;
 metro := r1.facilityregionmetro;
 stdate := to_char(r1.startdate,'MM/DD/YYYY');
 fullname := r1.firstname || ' ' || r1.lastname;
 select 'Instructions-'||fullname||'.html','/usr/tmp/'||'Instructions-'||fullname||'.html'
    into v_file_name,v_file_full
   from dual;
 v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
 utl_file.put_line(v_file,'<html><head><style>.style1 {font-size:10.0pt;font-family:Arial}.style2 {color: #0033CC}</style></head><body>');
 utl_file.put_line(v_file,'<p class="style1">' || r1.firstname || ',</p>');
 utl_file.put_line(v_file,'<p class="style1">Congratulations on getting through the first phase of our instructor acceptance program. I would like to invite you to a live session.</p>');
 utl_file.put_line(v_file,'<p class="style1">Attached  is:</p>');
 utl_file.put_line(v_file,'<ol start="1" type="1" class="style1">');
 utl_file.put_line(v_file,'<li><strong>New Instructor Audit Checklist</strong>. Please refer to this to ensure you are getting the most out of your scheduled audit. </li>');
 utl_file.put_line(v_file,'<li><strong>Instructor Invoice Form.</strong> On Friday of the event you will receive a PO # to invoice against. </li>');
 utl_file.put_line(v_file,'<li><strong>Allowable expense chart</strong>. Please consult. </li>');
 utl_file.put_line(v_file,'<li><strong>Supervising Questionnaire and Checklist</strong>: These two documents are for the Supervising Instructor to complete and return to me. ');
 utl_file.put_line(v_file,'Please review them as they will be the basis of your evaluation.</li></ol>');
 utl_file.put_line(v_file,'<p class="style1">You will receive the instructor manuals, travel and lodging confirmation a week or so prior to the class. If you are');
 utl_file.put_line(v_file,'co-teaching a session you will be paid at $250 per day plus allowable expenses. <br /><br />');
 utl_file.put_line(v_file,'Please feel free to contact me if you have any questions or concerns throughout this next phase of acceptance. I will be in touch with you after the class. </p>');
 utl_file.put_line(v_file,'<p class="style1"></p><span class="style1"><span class="style2"><strong>Dennis Pinto<br />');
 utl_file.put_line(v_file,'<strong>Instructor Recruiter</strong><br />');
 utl_file.put_line(v_file,'</strong><br />9000 Regency Pkwy <br />Suite 500 <br />Cary, NC 27511 <br />');
 utl_file.put_line(v_file,'800 268 7737<br />919 460 3277 <br />f- 919 468 4977 <br />');
 utl_file.put_line(v_file,'<a href="mailto:dennis.pinto@globalknowledge.com" title="mailto:dennis.pinto@globalknowledge.com">dennis.pinto@globalknowledge.com</a><br><br />');
 utl_file.put_line(v_file,'LEARNING. To Make a Difference <br />');
 utl_file.put_line(v_file,'<a href="http://www.globalknowledge.com" title="http://www.globalknowledge.com/">http://www.globalknowledge.com</a></span></span>');
 utl_file.put_line(v_file,'</body></html>');
 utl_file.fclose(v_file);
 v_mail_hdr := 'Global Knowledge Audit Schedule - ' || sname || ' ' || metro || ' ' || stdate;
 questionnaire_file := '/usr/tmp/Supervising Instructor Questionnaire.doc';
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
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full,questionnaire_file,checklist_file,inst_inv_file));
end loop;
end;
/


