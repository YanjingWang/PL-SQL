DROP PROCEDURE GKDW.GK_WELCOME_LETTER_EMAIL;

CREATE OR REPLACE PROCEDURE GKDW.gk_welcome_letter_email as
cursor c1 is 
select e.evxeventid,startdate,enddate,coursename,testing,proctor,email
from evxevent e 
    inner join rmsdw.rms_event re on e.evxeventid = re.slx_event_id
    inner join rmsdw.rms_course rc on e.evxcourseid = rc.slx_course_id
    inner join evxenrollhx hx on e.evxeventid = hx.evxeventid
    inner join evxevticket t on hx.evxevticketid = t.evxevticketid
    inner join contact c on t.billtocontactid = c.contactid
where welcome_letter = 'T'
    and trunc(e.createdate) + 3 = trunc(sysdate)
    and eventstatus = 'Open'
    and email_sent is null
union
select e.evxeventid,startdate,enddate,coursename,testing,proctor,email
from evxevent e 
    inner join rmsdw.rms_event re on e.evxeventid = re.slx_event_id
    inner join rmsdw.rms_course rc on e.evxcourseid = rc.slx_course_id
    inner join evxenrollhx hx on e.evxeventid = hx.evxeventid
    inner join evxevticket t on hx.evxevticketid = t.evxevticketid
    inner join contact c on t.billtocontactid = c.contactid
where welcome_letter = 'T'
    and trunc(sysdate) > trunc(e.createdate) + 3
    and eventstatus = 'Open'
    and email_sent is null;
email varchar2(128);
eventdate varchar(25);
v_file_name varchar2(250);
v_file_full varchar2(250);
v_file utl_file.file_type;
v_error number;
v_error_msg varchar2(500);
begin
for r1 in c1 loop
 eventdate := null;
 eventdate := to_char(trunc(r1.startdate),'MM/DD/YYYY') || ' - ' || to_char(trunc(r1.enddate),'MM/DD/YYYY');
 select 'Welcome Letter.html','/usr/tmp/Welcome Letter.html'
  into v_file_name,v_file_full
  from dual;
  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  utl_file.put_line(v_file,'<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>');
  utl_file.put_line(v_file,'<table border=0 size=700 cellspacing=3 cellpadding=3><tr><td rowspan="6" valign="top"><img src=');
  utl_file.put_line(v_file,'"http://images.globalknowledge.com/wwwimages/gk_logo_ltmd.gif" alt="Global Knowledge IT Training" ');
  utl_file.put_line(v_file,'width=165 height=90 border=0></td></tr></table><p></p>');
  utl_file.put_line(v_file,'<div style="width:600px; padding:5px;"><p>Thank you for choosing Global Knowledge to be your on site training provider! We value your business and will');
  utl_file.put_line(v_file,'work with you to ensure you receive a quality training experience. This notice confirms the following: </p>');
  utl_file.put_line(v_file,'<p>Course: ' || r1.coursename || '<br>');
  utl_file.put_line(v_file,'Dates: ' || eventdate || '</p>');
  utl_file.put_line(v_file,'<p>This training will require a room that is approximately  800-1,000 square feet and can be completely secured after hours. A large whiteboard ');
  utl_file.put_line(v_file,'or flip charts with  markers and a projection screen (located independently from the white board) must be provided.');
  if r1.testing = 'T' and r1.proctor = 'F' then
    utl_file.put_line(v_file,'This specific course will also require a testing room with 3 feet between each student.</p>');
      elsif r1.testing = 'F' and r1.proctor = 'T' then 
        utl_file.put_line(v_file,'This specific course will also require a certified proctor. </p>');
          elsif r1.testing = 'T' and r1.proctor = 'T' then 
            utl_file.put_line(v_file,'This specific course will also require a testing room with 3 feet between each student and a certified proctor.</p>');
   else utl_file.put_line(v_file,'</p>'); 
  end if;  
  utl_file.put_line(v_file,'<p>Please reply to this email to confirm the specific facility  address information where the training will take ');
  utl_file.put_line(v_file,'place, including facility name, street address, room number, city, state and zip code. </p>');
  utl_file.put_line(v_file,'<p>We will contact you three to four weeks prior to the start  date of the course to confirm delivery logistics. Please let us know as');
  utl_file.put_line(v_file,'soon as possible if you  are not the primary point of contact along with the name and telephone number of the appropriate person.</p>');
  utl_file.put_line(v_file,'<p>We look forward to working with you. Please feel free to contact us with any questions.</p>');
  utl_file.put_line(v_file,'<p>Onsite Coordination Team<br>OnsiteResponse@globalknowledge.com</p></div></body></html>');
  utl_file.fclose(v_file);
  update rmsdw.rms_event
  set email_sent = 'T'
  where slx_event_id = r1.evxeventid;
v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => 'OnsiteResponse@globalknowledge.com',
                Recipient => r1.email,
                CcRecipient => '',
                BccRecipient => '',
                Subject   => 'Global Knowledge Welcome Letter',
                Body => 'Open the HTML attachment to view your welcome letter.',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full));
end loop;
commit;
end;
/


