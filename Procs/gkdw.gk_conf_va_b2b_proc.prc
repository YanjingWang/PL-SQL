DROP PROCEDURE GKDW.GK_CONF_VA_B2B_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_va_b2b_proc(p_enroll_id varchar2 default null) as

cursor c1 is
select replace(nvl(ec.txfeeid,ec.evxevenrollid),'Q6UJ9','VAB2B') attachment_id,
       ec.evxevenrollid,ec.enrollstatus,ec.createdate,ec.startdate,ec.starttime,ec.enddate,ec.endtime,ec.evxeventid,ec.eventname,ec.contactid,
       ec.firstname,ec.lastname,ec.email,ec.cust_state,ec.eventtype,ec.evxfacilityid,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode,
       ec.workphone,ec.evxcourseid,ec.leadsourcedesc,ec.feetype,ec.txfeeid,ec.tzgenericname,ec.tzabbreviation,
       cd.course_code,cd.course_name,cd.short_name,ed.start_time,ed.end_time,cd.md_num,ec.email conf_email,ec.secondaryemail,
       '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>'||
       '<table border=0 cellspacing=3 cellpadding=3 style="font-size: 9pt;font-family:arial" width=300>'||
       '<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/Header_LOGO.jpg" alt="Global Knowledge IT Training" border=0></td></tr>'||
       '<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/FOOTER.jpg" border=0></td></tr>' conf_hdr,
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=4>Notification of Enrollment</font></th></tr>' notif_hdr,
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><td colspan=2 align=left>Hello '||initcap(ec.firstname)||',</td></tr>'||
       '<tr><td colspan=2 align=left>As a customer located in Virginia, we are contacting you to confirm that your training is funded by an employer. Global Knowledge is a business-to-business training provider and delivers learning services only to individuals who are sponsored by an employer.<p>No action is required by you if your training is employer-sponsored. If you have questions about your enrollment status in the case of a non-sponsored course, please contact us at 1-800-COURSES (1-800-268-7737).</td></tr>'||
       '<tr><td colspan=2 align=left>Your training partner,<br>Global Knowledge</td></tr><tr><td colspan=2 align=left>&nbsp</td></tr>' notif_body,
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=4>Course Details</font></th></tr>'||
       '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th align=right>Confirmation Number:</th><td align=left>'||ec.evxevenrollid||'</td></tr><tr><td colspan=2 align=left><p><hr align="left"></td></tr>' cd_conf_num,
       '<tr><th align=right>Start Date:</th><td align=left>'||to_char(ec.startdate,'Mon. dd, yyyy')||'</td></tr><tr><th align=right>End Date:</th><td align=left>'||to_char(ec.enddate,'Mon. dd, yyyy')||'</td></tr>'||
       '<tr><td colspan=2 align=left><p><hr align="left"></td></tr><tr><th align=right>Start Time:</th><td align=left>'||to_char(ec.starttime,'hh:mi AM')||' '||ec.tzgenericname||'</td></tr>'||
       '<tr><th align=right>End Time:</th><td align=left>'||to_char(ec.endtime,'hh:mi AM')||' '||ec.tzgenericname||'</td></tr>' notif_deliv_dates,
        '<tr><td colspan=2 align=left><p><hr align="left"></td></tr><tr><th align=right valign=top>Course Name:</th><td align=left>'||cd.course_name||'</td></tr>'||
        '<tr><th align=right valign=top>Course Code:</th><td align=left>'||cd.course_code||'</td></tr>' cd_course_name,
        '<tr><td colspan=2 align=left><p><hr align="left"></td></tr>'||
        '<tr><th align=right>Facility Name:</th><td align=left>'||
        case when upper(ed.location_name) like 'GLOBAL KNOWLEDGE TRAINING CENTER%' and ed.ops_country = 'USA' then '<a href="http://www.globalknowledge.com/training/locationdetail.asp?pageid=3&hotelid='||ed.location_id||'">'||ec.facilityname||'</a></td></tr>'
             when upper(ed.location_name) like 'GLOBAL KNOWLEDGE%' and ed.ops_country = 'CANADA' then '<a href="http://www.globalknowledge.ca/training/locationdetail.asp?pageid=58&hotelid='||ed.location_id||'">'||ec.facilityname||'</a></td></tr>'
             else ec.facilityname||'</td></tr>'
        end||       
        '<tr><th align=right>Address:</th><td align=left>'||ec.address1||
        case when ec.address2 is not null then ', '||ec.address2||'</td></tr></td></tr>' end||
        '<tr><th align=right>&nbsp</th><td align=left>'||ec.city||', '||ec.state||' '||ec.postalcode||'</td></tr>' cd_fac_name,
        '<tr><td colspan=2 align=left><p><hr align="left"></td></tr>'||
        '<tr><th align=right>Student Name:</th><td align=left>'||ec.firstname||' '||ec.lastname||'</td></tr><tr><th align=right>Student Email:</th><td align=left>'||ec.email||'</td></tr>' cd_stud_name,
        '<tr><td colspan=2 align=left>&nbsp</td></tr><tr><th colspan=2 align=left><font color="CE9900" size=4>Questions?</th></tr><tr><td colspan=2 align=left><i>Customer Service</i></td></tr>'||
        '<tr><th align=right>Toll Free:</th><td align=left>1-800-COURSES (1-800-268-7737)</td></tr><tr><th align=right>Email:</th><td align=left>Contact@globalknowledge.com</td></tr>' quest_cust_serv,
        '<tr><td colspan=2 align=left><p><hr align="left"></td></tr><tr><td colspan=2 align=left><i>Technical Support</i></td></tr><tr><th align=right>Phone Toll Free:</th><td align=left>1-866-825-8555</td></tr>'||
        '<tr><th align=right>Email:</th><td align=left>TechSupport@globalknowledge.com</td></tr>' quest_tech_asst,
        '<tr><td colspan=2 align=left><p><hr align="left"></td></tr><tr><td colspan=2 align=left><i>Additional Resources</i></td></tr>'||
        '<tr><td colspan=2 align=left><ul><li><a href=https://mygk.globalknowledge.com/Content/Help/FAQ.aspx>MyGK Frequently Asked Questions</a></li>'||
        '<li><a href=http://www.globalknowledge.com/training/policy>Attendance and Substitution Policy</a></li>'||
        case when upper(ed.location_name) like 'GLOBAL KNOWLEDGE TRAINING CENTER%' and ed.ops_country = 'USA'  then '<li><a href="http://www.globalknowledge.com/training/locationdetail.asp?pageid=3&hotelid='||ed.location_id||'">Training Center Information</a></li>'
             when upper(ed.location_name) like 'GLOBAL KNOWLEDGE%' and ed.ops_country = 'CANADA' then '<li><a href="http://www.globalknowledge.ca/training/locationdetail.asp?pageid=58&hotelid='||ed.location_id||'">Training Center Information</a></li>'
        end||
        '<li><a href=http://www.globalknowledge.com/training/privacy_popup.asp>Privacy Policy</a></li></ul></td></tr>' quest_add_resc
  from gk_enroll_conf_v@slx ec
       inner join event_dim ed on ec.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where ec.enrollstatus = 'Confirmed'
   and ec.createdate >= trunc(sysdate)-1 
   and ec.createdate < trunc(sysdate)
   and ec.cust_state = 'VA'
   and ec.email is not null
   and not exists (select 1 from gk_mygk_course_profile_v cp where cd.course_id = cp.course_id)
   and not exists (select 1 from gk_channel_partner_conf p where ec.leadsourcedesc = p.channel_keycode)
   and not exists (select 1 from gk_conf_email_audit ea where ec.evxevenrollid = ea.evxevenrollid)
  order by ec.evxevenrollid;
 
v_msg_body long;
v_file_name varchar2(250);
v_file_name_full varchar2(500);
v_file utl_file.file_type;
v_attach_desc varchar2(500);
v_curr_time varchar2(250);
v_ical_event varchar2(32767);
v_ical_body long;
v_attach_cnt number := 0;
v_conf_email varchar2(250);
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop
 
  select r1.evxevenrollid||'_B2BNotifLetter_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-B2B-Notification-Email--Conf#-'||r1.evxevenrollid||'-('||r1.firstname||'-'||r1.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

/******* ENROLLMENT EMAIL ********/
  v_msg_body := r1.conf_hdr;
  v_msg_body := v_msg_body||r1.notif_hdr;  
  v_msg_body := v_msg_body||r1.notif_body;
  v_msg_body := v_msg_body||r1.cd_conf_num;
  if r1.md_num not in ('32','44') then 
    v_msg_body := v_msg_body||r1.notif_deliv_dates;
  end if;
  v_msg_body := v_msg_body||r1.cd_course_name;
  if r1.eventtype != 'VCEL' then
    v_msg_body := v_msg_body||r1.cd_fac_name;
  end if;
  v_msg_body := v_msg_body||r1.cd_stud_name;
  v_msg_body := v_msg_body||r1.quest_cust_serv;
  v_msg_body := v_msg_body||r1.quest_tech_asst;
  v_msg_body := v_msg_body||r1.quest_add_resc;
   
  v_msg_body := v_msg_body||v_html_end;

  send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.conf_email,'Global Knowledge Notification',v_msg_body);
  if r1.secondaryemail is not null then
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.secondaryemail,'Global Knowledge Notification',v_msg_body);
  end if;

/******* ENROLLMENT ATTACHMENT ********/
  v_file := utl_file.fopen('/mnt/nc10s079',v_file_name,'w',32767);
--  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w',32767);
    
  utl_file.put_line(v_file,r1.conf_hdr);
  utl_file.put_line(v_file,r1.notif_hdr); 
  utl_file.put_line(v_file,r1.notif_body);
  utl_file.put_line(v_file,r1.cd_conf_num);
  if r1.md_num not in ('32','44') then 
    utl_file.put_line(v_file,r1.notif_deliv_dates);
  end if;
  utl_file.put_line(v_file,r1.cd_course_name);
  if r1.eventtype != 'VCEL' then
    utl_file.put_line(v_file,r1.cd_fac_name);
  end if;
  utl_file.put_line(v_file,r1.cd_stud_name);
  utl_file.put_line(v_file,r1.quest_cust_serv);
  utl_file.put_line(v_file,r1.quest_tech_asst);
  utl_file.put_line(v_file,r1.quest_add_resc);
     
  utl_file.put_line(v_file,v_html_end);
  
  utl_file.fclose(v_file);
    
  select count(*) into v_attach_cnt from attachment@slx where attachid = r1.attachment_id;
    
  if v_attach_cnt = 0 then
    insert into attachment@slx(attachid,attachdate,contactid,description,datatype,filesize,filename,userid)
    values (r1.attachment_id,v_curr_time,r1.contactid,v_attach_desc,'R',2425,v_file_name,'ADMIN');
    commit;
  else
    update attachment@slx
       set attachdate = v_curr_time,
           contactid = r1.contactid,
           description = v_attach_desc,
           filename = v_file_name
     where attachid = r1.attachment_id;
    commit;
  end if;

end loop;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_VA_B2B_PROC Failed',SQLERRM);
   
end;
/


