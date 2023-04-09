DROP PROCEDURE GKDW.GK_MYGK_URL_EMAIL_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_mygk_url_email_proc(p_event_id varchar2,p_email varchar2) as

cursor c0 is
select c.cust_id contactid,c.last_name,c.first_name,lower(c.email) email,c.acct_name,
       'https://mygk.globalknowledge.com/Account/Redirector.ashx?ContactID='||c.cust_id mygk_url,
       ed.event_id,ed.facility_region_metro metro,ed.location_name,ed.facility_code,
       cd.course_code,cd.short_name,ed.start_date,ed.end_date,
       c.cust_id||chr(9)||c.last_name||chr(9)||c.first_name||chr(9)||c.acct_name||chr(9)||lower(c.email)||chr(9)||
       'https://mygk.globalknowledge.com/Account/Redirector.ashx?ContactID='||c.cust_id||chr(9)||ed.event_id||chr(9)||
       ed.facility_region_metro||chr(9)||ed.location_name||chr(9)||ed.facility_code||chr(9)||cd.course_code||chr(9)||
       cd.short_name||chr(9)||ed.start_date||chr(9)||ed.end_date v_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id 
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and feecode in ('INS','SI')
       inner join gk_mygk_course_profile_v p on cd.course_id = p.course_id
 where ed.event_id = p_event_id
   and f.enroll_status = 'Confirmed'
   and f.fee_type != 'Ons - Base'
 order by cd.course_code,last_name,first_name;

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_file utl_file.file_type;
v_hdr varchar2(500);

begin

select 'mygk_student_access_'||p_event_id||'.xls',
       '/usr/tmp/mygk_student_access_'||p_event_id||'.xls'
  into v_file_name,v_file_name_full
  from dual;
  
v_hdr := 'ContactID'||chr(9)||'LastName'||chr(9)||'FirstName'||chr(9)||'AccountName'||chr(9)||'Email'||chr(9)||'MyGK Access URL'||chr(9)||'EventID'||chr(9)||'Metro'||chr(9)||'LocationName'||chr(9)||'FacilityCode'||chr(9)||'CourseCode'||chr(9)||'ShortName'||chr(9)||'StartDate'||chr(9)||'EndDate';

  
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

for r0 in c0 loop
  utl_file.put_line(v_file,r0.v_line);
end loop;
utl_file.fclose(v_file);

send_mail_attach('DW.Automation@globalknowledge.com',p_email,null,null,v_file_name,'Open Excel Attachment.',v_file_name_full);

end;
/


