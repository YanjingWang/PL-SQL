DROP PROCEDURE GKDW.IFRC_EMAIL_BODY;

CREATE OR REPLACE PROCEDURE GKDW.ifrc_email_body(p_enroll_id varchar2) is

cursor c1 is
select a.*,
       -- IFRC Header
       '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>'||
       '<table border=0 cellspacing=3 cellpadding=3 style="font-size: 9pt;font-family:arial" width=300>'||
       '<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/Header_LOGO.jpg" alt="Global Knowledge IT Training" border=0></td></tr>'||
       '<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/FOOTER.jpg" border=0></td></tr>' ifrc_hdr,
       -- IFRC Introduction Paragraph
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=4>Regarding your Scheduled Course</font></th></tr>'||
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>Hello '||initcap(a.first_name)||',</td></tr>'||
       '<tr><td colspan=2 align=left>We are contacting you to let you know that your upcoming '||ed.event_name||', scheduled to begin '||to_char(ed.start_date,'FMMonth ddth, yyyy')||', has not yet reached the attendance minimum and it may be canceled. In an effort to ensure you are registered for a <a href="http://www.globalknowledge.com/training/generic.asp?pageid=2250&country=United+States">Guaranteed Date<a/>, we have provided you with an upcoming schedule below.</td></tr>'||
       '<tr><td colspan=2 align=left>When you select the Complete Auto-Transfer button next to your preferred session, this course will become a Guaranteed Date <b>that cannot be canceled</b> due to attendance.</td></tr>' ifrc_para,
       -- Classroom Live Header
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=2>Recommended Classroom Live course(s) near you*:</font></th></tr>' ifrc_class_hdr,
       -- Virtual Classroom Live Header
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=2>Recommended Virtual Classroom Live course(s)*:</font></th></tr>' ifrc_virtual_hdr,
       -- Additional Options
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=2>Additional options:</font></th></tr>'||
       '<tr><td colspan=2 align=left>Your training advisor can guide you through other locations, times and courses available.</td></tr>'||
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=center><a href="mailto:DW.Automation@globalknowledge.com?Subject=IFRC%20Contact%20Me"><img src="http://images.globalknowledge.com/wwwimages/newsletter/Contact-button.png" border=0 width=100 height=20></a></td></tr>'||
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>If you prefer to remain in your current course, we will notify you at least two weeks prior to the start date if the course has been canceled. You will then be enrolled automatically in the next available session at your location.</td></tr>' ifrc_call_me,
       -- IFRC Closing
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>Your training partner,<br>Global Knowledge</td></tr>' ifrc_closing,
       -- Current Course Details
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=4>Course Details</font></th></tr>' ifrc_details,
       -- IFRC Confirmation Number
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th align=right>Confirmation Number:</th><td align=left>'||a.enroll_id||'</td></tr><tr><td colspan=2 align=left><p><hr align="left"></td></tr>' ifrc_conf_num,
       -- IFRC Course
       '<tr><th align=right>Start Date:</th><td align=left>'||to_char(ed.start_date,'Mon. dd, yyyy')||'</td></tr><tr><th align=right>End Date:</th><td align=left>'||to_char(ed.end_date,'Mon. dd, yyyy')||'</td></tr>'||
       '<tr><td colspan=2 align=left><p><hr align="left"></td></tr><tr><th align=right>Start Time:</th><td align=left>'||ed.start_time||' '||et.tzabbreviation||'</td></tr>'||
       '<tr><th align=right>End Time:</th><td align=left>'||ed.end_time||' '||et.tzabbreviation||'</td></tr>'||
       '<tr><td colspan=2 align=left><p><hr align="left"></td></tr><tr><th align=right valign=top>Course Name:</th><td align=left>'||cd.course_name||'</td></tr>'||
       '<tr><th align=right valign=top>Course Code:</th><td align=left>'||ed.course_code||'</td></tr>' ifrc_course,
       -- IFRC Location
       '<tr><td colspan=2 align=left><p><hr align="left"></td></tr>'||
       '<tr><th align=right>Facility Name:</th><td align=left>'||ed.location_name||'</td></tr>'||       
        '<tr><th align=right>Address:</th><td align=left>'||ed.address1||
        case when ed.address2 is not null then ', '||ed.address2||'</td></tr></td></tr>' end||
        '<tr><th align=right>&nbsp</th><td align=left>'||ed.city||', '||ed.state||' '||ed.zipcode||'</td></tr>' ifrc_facility,
        -- IFRC Student
        '<tr><td colspan=2 align=left><p><hr align="left"></td></tr>'||
        '<tr><th align=right>Student Name:</th><td align=left>'||initcap(a.first_name)||' '||initcap(a.last_name)||'</td></tr><tr><th align=right>Student Email:</th><td align=left>'||a.email||'</td></tr>' ifrc_student,
        -- IFRC Customer Service 
        '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=4>Questions?</th></tr><tr><td colspan=2 align=left><i>Customer Service</i></td></tr>'||
        '<tr><th align=right>Toll Free:</th><td align=left>1-800-COURSES (1-800-268-7737)</td></tr>'||
        '<tr><th align=right>Email:</th><td align=left>Contact@globalknowledge.com</td></tr>' ifrc_cust_serv,
        cd.md_num,ed.event_name
  from ifrc_audit a
       inner join event_dim ed on a.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
where enroll_id = p_enroll_id;
 
cursor c2(v_enrollid varchar2) is
select g2.event_id,g2.metro,ed2.location_name,ed2.address1,ed2.address2,ed2.city,ed2.state,ed2.zipcode,
       g2.facility_code p_fac_code,g2.start_date,ed2.end_date,ed2.start_time,ed2.end_time,ed2.tz_fulname,
       case when ed2.start_date = ed.end_date then to_char(ed2.start_date,'Mon dd, yyyy') 
            when to_char(ed2.start_date,'Mon') = to_char(ed2.end_date,'Mon') then to_char(ed2.start_date,'Mon dd')||'-<br>'||to_char(ed2.end_date,'dd, yyyy') 
            else to_char(ed2.start_date,'Mon dd')||'-<br>'||to_char(ed2.end_date,'Mon dd, yyyy') 
       end disp_date,
       to_char(to_date(ed2.start_time,'hh:mi:ss AM'),'hh:mi AM')||' to<br>'||to_char(to_date(ed2.end_time,'hh:mi:ss AM'),'hh:mi AM')||' '||et.tzabbreviation disp_time
  from ifrc_audit ia
       inner join event_dim ed on ia.event_id = ed.event_id 
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join alt_metro_lookup m on ia.metro = m.metro
       inner join time_dim td on td.dim_date = trunc(sysdate)
       inner join gk_go_nogo_v g2 on substr(ia.course_code,1,4) = substr(g2.course_code,1,4) and g2.start_date between ia.start_date-7 and ia.start_date+42 
                                       and g2.enroll_cnt >= 4
       inner join event_dim ed2 on g2.event_id = ed2.event_id and g2.metro = m.alt_metro
       left outer join gk_course_url_mv cu on ia.course_code = cu.course_code and ia.ops_country = cu.country
       inner join slxdw.evxevent ev on ed2.event_id = ev.evxeventid
       inner join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid
 where ia.enroll_id = v_enrollid
   and g2.metro != 'VCL'
   and g2.enroll_cnt < ed2.capacity
 order by start_date,metro;

cursor c3(v_enrollid varchar2) is
select g2.event_id,g2.metro,ed2.location_name,ed2.address1,ed2.address2,ed2.city,ed2.state,ed2.zipcode,
       g2.facility_code p_fac_code,g2.start_date,ed2.end_date,ed2.start_time,ed2.end_time,ed2.tz_fulname,
       case when ed2.start_date = ed.end_date then to_char(ed2.start_date,'Mon dd, yyyy') 
            when to_char(ed2.start_date,'Mon') = to_char(ed2.end_date,'Mon') then to_char(ed2.start_date,'Mon dd')||'-<br>'||to_char(ed2.end_date,'dd, yyyy') 
            else to_char(ed2.start_date,'Mon dd')||'-<br>'||to_char(ed2.end_date,'Mon dd, yyyy') 
       end disp_date,
       to_char(to_date(ed2.start_time,'hh:mi:ss AM'),'hh:mi AM')||' to<br>'||to_char(to_date(ed2.end_time,'hh:mi:ss AM'),'hh:mi AM')||' '||et.tzabbreviation disp_time
  from ifrc_audit ia
       inner join event_dim ed on ia.event_id = ed.event_id 
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join alt_metro_lookup m on ia.metro = m.metro
       inner join time_dim td on td.dim_date = trunc(sysdate)
       inner join gk_go_nogo_v g2 on substr(ia.course_code,1,4) = substr(g2.course_code,1,4) and g2.start_date between ia.start_date-7 and ia.start_date+42 
                                       and g2.enroll_cnt >= 4
       inner join event_dim ed2 on g2.event_id = ed2.event_id and g2.metro = m.alt_metro
       left outer join gk_course_url_mv cu on ia.course_code = cu.course_code and ia.ops_country = cu.country
       inner join slxdw.evxevent ev on ed2.event_id = ev.evxeventid
       inner join slxdw.evxtimezone et on ev.evxtimezoneid = et.evxtimezoneid 
 where ia.enroll_id = v_enrollid
   and g2.metro = 'VCL'
   and g2.enroll_cnt < ed2.capacity
 order by start_date,metro;
 
v_msg_body long;
v_conf_email varchar2(250);
v_html_end varchar2(250) := '</table><p></body></html>';

r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;

begin

open c1;fetch c1 into r1;
if c1%found then

/******* ENROLLMENT EMAIL ********/
  v_msg_body := r1.ifrc_hdr;
  v_msg_body := v_msg_body||r1.ifrc_para;
  
  open c2(r1.enroll_id);fetch c2 into r2;
  if c2%found then
    close c2;
    v_msg_body :=  v_msg_body||r1.ifrc_class_hdr;
    v_msg_body :=  v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left><u>'||r1.event_name||'</u></font></td></tr>';
    v_msg_body :=  v_msg_body||'<tr><td colspan=2 align=left><table border=0 cellspacing=5 cellpadding=1 style="font-size: 8pt;font-family:arial">';
    v_msg_body :=  v_msg_body||'<tr><th width=200 colspan=2>Location</th><th width=100>Date</th><th width=100>Time</th><th width=100>&nbsp</th></tr>';  

    for r2 in c2(r1.enroll_id) loop
      v_msg_body :=  v_msg_body||'<tr align=center valign=top><td>'||r2.location_name||'</td><td>'||r2.address1||'<br>'||r2.city||', '||r2.state||' '||r2.zipcode||'</td><td>'||r2.disp_date||'</td><td>'||r2.disp_time||'</td>';
      v_msg_body :=  v_msg_body||'<td><a href="http://nc10s029.globalknowledge.com/CancelEnroll/Default.aspx?enroll_id='||r1.enroll_id||'&p_eventid='||r2.event_id||'&redirectUrl=http://nc10s218.globalknowledge.com/pls/evp/ifrc_main.ifrc_conf?p_enrollid='||r1.enroll_id||'&p_eventid='||r2.event_id||'"><img src="http://images.globalknowledge.com/wwwimages/newsletter/Complete-button.png" border=0 width=100 height=20></a></td></tr>'; 
      v_msg_body :=  v_msg_body||'<tr><td colspan=5 align=left><p><hr align="left"></td></tr>'; 
    end loop;
    v_msg_body :=  v_msg_body||'</table></td></tr>';
  else
    close c2;
  end if;

  open c3(r1.enroll_id);fetch c3 into r3;
  if c3%found then
    close c3;
    v_msg_body :=  v_msg_body||r1.ifrc_virtual_hdr;
    v_msg_body :=  v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left><font size=2><u>'||r1.event_name||'</u></font></td></tr>';
    v_msg_body :=  v_msg_body||'<tr><td colspan=2 align=left><table border=0 cellspacing=5 cellpadding=1 style="font-size: 8pt;font-family:arial">';
    v_msg_body :=  v_msg_body||'<tr><th width=100>Date</th><th width=100>Time</th><th width=100>&nbsp</th></tr>';  

    for r3 in c3(r1.enroll_id) loop
      v_msg_body :=  v_msg_body||'<tr align=center valign=top><td>'||r3.disp_date||'</td><td>'||r3.disp_time||'</td>';
      v_msg_body :=  v_msg_body||'<td><a href="http://nc10s029.globalknowledge.com/CancelEnroll/Default.aspx?enroll_id='||r1.enroll_id||'&p_eventid='||r3.event_id||'&redirectUrl=http://nc10s218.globalknowledge.com/pls/evp/ifrc_main.ifrc_conf?p_enrollid='||r1.enroll_id||'&p_eventid='||r3.event_id||'"><img src="http://images.globalknowledge.com/wwwimages/newsletter/Complete-button.png" border=0 width=100 height=20></a></td></tr>'; 
      v_msg_body :=  v_msg_body||'<tr><td colspan=3 align=left><p><hr align="left"></td></tr>'; 
    end loop;
    v_msg_body :=  v_msg_body||'</table></td></tr>';
  else
    close c3;
  end if;

  v_msg_body :=  v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left><font size=1><i>*Within 48 hours of selecting your preferred session, you will receive an emailed confirmation of your re-enrollment. Upon receipt, please verify that all details are correct.</i></td></tr>';
  
  v_msg_body := v_msg_body||r1.ifrc_call_me;
  v_msg_body := v_msg_body||r1.ifrc_closing;
  v_msg_body := v_msg_body||r1.ifrc_details;
  v_msg_body := v_msg_body||r1.ifrc_conf_num;
  v_msg_body := v_msg_body||r1.ifrc_course;
  if r1.md_num = '10' then
    v_msg_body := v_msg_body||r1.ifrc_facility;
  end if;
  v_msg_body := v_msg_body||r1.ifrc_student;
  v_msg_body := v_msg_body||r1.ifrc_cust_serv;

  v_msg_body := v_msg_body||v_html_end;

  send_mail('ConfirmAdmin.NAm@globalknowledge.com','DW.Automation@globalknowledge.com','Important Course Notification',v_msg_body);

end if;
close c1;

end;
/


