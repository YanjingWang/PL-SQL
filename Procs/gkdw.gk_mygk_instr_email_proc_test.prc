DROP PROCEDURE GKDW.GK_MYGK_INSTR_EMAIL_PROC_TEST;

CREATE OR REPLACE PROCEDURE GKDW.gk_mygk_instr_email_proc_test as

cursor c0 is
select distinct ie.contactid,ie.firstname||' '||ie.lastname inst_name,ie.email inst_email
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
       inner join gk_mygk_course_profile_v p on cd.course_id = p.course_id
 where ed.status = 'Open'
   and ed.start_date = trunc(sysdate)
   and ie.email is not null
   and ed.event_id = 'QGKID0AYYEPJ'
 order by ie.contactid;

cursor c1(v_contactid varchar2) is
select ed.event_id,ed.facility_region_metro,ed.location_name,ed.facility_code,
       cd.course_code,cd.short_name,
       ed.start_date,ed.end_date,c.cust_name,c.acct_name,lower(c.email) email,
       case when facility_region_metro = 'VCL' then 1 else 0 end sort_order,
       case when facility_region_metro = 'VCL' then 'Y' else 'N' end virtual_flag,
       'https://mygk.globalknowledge.com/Account/CreateAccount.aspx?ContactID='||c.cust_id mygk_url,
       ie.firstname||' '||ie.lastname inst_name,
       ie.email inst_email
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id 
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and feecode in ('INS','SI')
       inner join gk_mygk_course_profile_v p on cd.course_id = p.course_id
 where ed.start_date = trunc(sysdate)
   and ie.contactid = v_contactid
   and f.enroll_status = 'Confirmed'
   and ed.event_id = 'QGKID0AYYEPJ'
 order by sort_order,cd.course_code,cust_name;
 
cursor c2 is
select c.last_name,c.first_name,c.acct_name,lower(c.email) email,
       case when facility_region_metro = 'VCL' then 'Y' else 'N' end virtual_flag,
       'https://mygk.globalknowledge.com/Account/CreateAccount.aspx?ContactID='||c.cust_id mygk_url,
       ed.event_id,ed.facility_region_metro,ed.location_name,ed.facility_code,
       cd.course_code,cd.short_name,ed.start_date,ed.end_date,
       c.last_name||chr(9)||c.first_name||chr(9)||c.acct_name||chr(9)||lower(c.email)||chr(9)||case when facility_region_metro = 'VCL' then 'Y' else 'N' end||chr(9)||
       'https://mygk.globalknowledge.com/Account/CreateAccount.aspx?ContactID='||c.cust_id||chr(9)||ed.event_id||chr(9)||ed.facility_region_metro||chr(9)||ed.location_name||chr(9)||
       ed.facility_code||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||ed.start_date||chr(9)||ed.end_date v_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id 
       inner join gk_mygk_course_profile_v p on cd.course_id = p.course_id
 where ed.start_date = trunc(sysdate)
   and f.enroll_status = 'Confirmed'
   and ed.event_id = 'QGKID0AYYEPJ'
 order by c.last_name,c.first_name,cd.course_code;
 
cursor c3(v_contactid varchar2) is
select max(case when facility_region_metro = 'VCL' then 'Y' else 'N' end) virtual_flag
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id 
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and feecode in ('INS','SI')
       inner join gk_mygk_course_profile_v p on cd.course_id = p.course_id
 where ed.start_date = trunc(sysdate)
   and ie.contactid = v_contactid
   and ed.event_id = 'QGKID0AYYEPJ'
   and f.enroll_status = 'Confirmed';

v_inst varchar2(250);
v_inst_email varchar2(250);
v_course varchar2(250);
v_location varchar2(250);
v_class_date varchar2(250);
v_msg_body long;
r1 c1%rowtype;
r3 c3%rowtype;
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_file utl_file.file_type;
v_hdr varchar2(500);
v_mail_flag varchar2(1) := 'N';

begin
for r0 in c0 loop
  v_inst := r0.inst_name;
  v_inst_email := r0.inst_email;

  v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana" width=300>';
  v_msg_body := v_msg_body||'<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/Header_LOGO.jpg" alt="Global Knowledge IT Training" border=0></td></tr>';
  v_msg_body := v_msg_body||'</table>';

  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th align=left>Instructor: '||v_inst||'</td></tr>';
  
  open c3(r0.contactid);fetch c3 into r3;
  if r3.virtual_flag = 'Y' then
    v_msg_body := v_msg_body||'<tr><td><table border=0 style="font-size: 8pt;font-family:verdana">';
    v_msg_body := v_msg_body||'<tr><th align=left>VIRTUAL CLASSROOM ACCESS:</th></tr>';
    v_msg_body := v_msg_body||'<tr><td align=left>As you are teaching a virtual or connected (classroom and virtual) event, access to your Adobe session is through the Learn on Demand (LOD) link below.</td></tr>';
    v_msg_body := v_msg_body||'<tr><td align=left>https://globalknowledge.learnondemand.net</td></tr>';
    v_msg_body := v_msg_body||'</table></td></tr><p>';
  end if;
  close c3;
 
  v_course := 'New';
  for r1 in c1(r0.contactid) loop
    if r1.short_name||'('||r1.course_code||')' <> v_course then
      v_msg_body := v_msg_body||'</table><br>';
      v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
      v_msg_body := v_msg_body||'<tr bgcolor=yellow><th align=left>Course:</th><td align=left>'||r1.short_name||'('||r1.course_code||')'||'</td>';
      v_msg_body := v_msg_body||'<th align=left>Location:</th><td align=left>'||r1.facility_region_metro||'-'||r1.location_name||'('||r1.facility_code||')'||'</td>';
      v_msg_body := v_msg_body||'<th align=left>Class Date:</th><td align=left>'||to_char(r1.start_date,'mm/dd/yyyy')||'-'||to_char(r1.end_date,'mm/dd/yyyy')||'</td></tr>';
      v_msg_body := v_msg_body||'</table>';
      v_course := r1.short_name||'('||r1.course_code||')';
      
      v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
      v_msg_body := v_msg_body||'<tr><th align=left>Student</th><th align=left>Account</th><th align=left>Email</th><th align=left>Virtual</th><th align=left>MyGK Access URL</th></tr>';
    end if; 
         
    v_msg_body := v_msg_body||'<tr align=left><td>'||r1.cust_name||'</td><td>'||r1.acct_name||'</td>';
    v_msg_body := v_msg_body||'<td>'||r1.email||'</td><td align=center>'||r1.virtual_flag||'</td><td>'||r1.mygk_url||'</td></tr>';
  end loop;
  v_msg_body := v_msg_body||'</table>';
  v_msg_body := v_msg_body||'</body></html>';
  
  send_mail('ConfirmAdmin.NAM@globalknowledge.com','DW.Automation@globalknowledge.com','MyGK Access URLs',v_msg_body);
end loop;

select 'mygk_student_access_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/mygk_student_access_'||to_char(sysdate,'yyyymmdd')||'.xls'
  into v_file_name,v_file_name_full
  from dual;
  
v_hdr := 'LastName'||chr(9)||'FirstName'||chr(9)||'AccountName'||chr(9)||'Email'||chr(9)||'Virtual'||chr(9)||'MyGK Access URL'||chr(9)||'EventID'||chr(9)||'Metro'||chr(9)||'LocationName'||chr(9)||'FacilityCode'||chr(9)||'CourseCode'||chr(9)||'ShortName'||chr(9)||'StartDate'||chr(9)||'EndDate';

  
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

for r2 in c2 loop
  utl_file.put_line(v_file,r2.v_line);
  v_mail_flag := 'Y';
end loop;
utl_file.fclose(v_file);

if v_mail_flag = 'Y' then
  send_mail_attach('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','','',v_file_name,'Open Excel Attachment.',v_file_name_full);
end if;

end;
/


