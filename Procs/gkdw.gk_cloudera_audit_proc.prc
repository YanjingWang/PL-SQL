DROP PROCEDURE GKDW.GK_CLOUDERA_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_cloudera_audit_proc as

cursor c1 is
select ed.course_code,cd.course_name,ed.start_date,ed.facility_region_metro,ed.status,count(f.enroll_id) enroll_cnt,
       case when ge.gtr_level is not null then 'Y' else 'N' end gtr_flag,
       ed.course_code||chr(9)||cd.course_name||chr(9)||ed.start_date||chr(9)||ed.facility_region_metro||chr(9)||
       ed.status||chr(9)||count(f.enroll_id)||chr(9)||case when ge.gtr_level is not null then 'Y' else 'N' end v_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed' and f.book_amt > 0
       left outer join gk_gtr_events ge on ed.event_id = ge.event_id
 where cd.pl_num = '15'
   and cd.ch_num in ('10','20')
   and cd.md_num in ('10','20','41','42') --added modality 41 and 42 per request from Susan Cipollini FP#111682
   and ed.status = 'Open'
   and ed.start_date between trunc(sysdate) and trunc(sysdate)+180
 group by ed.course_code,cd.course_name,ed.start_date,ed.facility_region_metro,ed.status,
          case when ge.gtr_level is not null then 'Y' else 'N' end
union
select ed.course_code,cd.course_name,ed.start_date,ed.facility_region_metro,ed.status,count(f.enroll_id) enroll_cnt,
       'N' gtr_flag,
       ed.course_code||chr(9)||cd.course_name||chr(9)||ed.start_date||chr(9)||ed.facility_region_metro||chr(9)||ed.status||chr(9)||count(f.enroll_id)||chr(9)||'N' v_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed' and f.book_amt > 0
 where cd.pl_num = '15'
   and cd.ch_num in ('10','20')
   and cd.md_num in ('10','20','41','42')--added modality 41 and 42 per request from Susan Cipollini FP#111682
   and ed.status = 'Cancelled'
   and ed.start_date between trunc(sysdate) and trunc(sysdate)+180
 group by ed.course_code,cd.course_name,ed.start_date,ed.facility_region_metro,ed.status
 order by start_date;

cursor c2 is
select f.cust_id||' - '||cd.course_code cust_grp,f.cust_id,c.first_name,c.last_name,c.acct_name,c.address1,c.city,c.state,c.zipcode,f.enroll_id,
       cd.course_code,f.enroll_status_desc,f.book_date,f.book_amt,f.enroll_status,f.event_id,ed.start_date,ed.status,cd.short_name,
       ed.facility_region_metro,f.enroll_type,
       f.cust_id||' - '||cd.course_code||chr(9)||f.cust_id||chr(9)||c.first_name||chr(9)||c.last_name||chr(9)||c.acct_name||chr(9)||c.address1||chr(9)||
       c.city||chr(9)||c.state||chr(9)||c.zipcode||chr(9)||f.enroll_id||chr(9)||cd.course_code||chr(9)||f.enroll_status_desc||chr(9)||f.book_date||chr(9)||
       f.book_amt||chr(9)||f.enroll_status||chr(9)||f.event_id||chr(9)||ed.start_date||chr(9)||ed.status||chr(9)||cd.short_name||chr(9)||
       ed.facility_region_metro||chr(9)||f.enroll_type v_line
  from slxdw.gk_webenrollment w
       inner join order_fact f on w.attendeecontactid = f.cust_id
       inner join event_dim ed on f.event_id = ed.event_id and w.coursecode = substr(ed.course_code,1,4)
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join cust_dim c on f.cust_id = c.cust_id
where w.advertising_cookie in ('CLDweb3901','CLDweb3902','CLDweb3903','CLDweb3904','CLDweb3905','CLDweb3906','CLDweb3907','CLDweb3909')
  and f.enroll_status != 'Cancelled'
union
select f.cust_id||' - '||cd.course_code cust_grp,f.cust_id,c.first_name,c.last_name,c.acct_name,c.address1,c.city,c.state,c.zipcode,f.enroll_id,
       cd.course_code,f.enroll_status_desc,f.book_date,f.book_amt,f.enroll_status,f.event_id,ed.start_date,ed.status,cd.short_name,
       ed.facility_region_metro,f.enroll_type,
       f.cust_id||' - '||cd.course_code||chr(9)||f.cust_id||chr(9)||c.first_name||chr(9)||c.last_name||chr(9)||c.acct_name||chr(9)||c.address1||chr(9)||c.city||chr(9)||
       c.state||chr(9)||c.zipcode||chr(9)||f.enroll_id||chr(9)||cd.course_code||chr(9)||f.enroll_status_desc||chr(9)||f.book_date||chr(9)||f.book_amt||chr(9)||f.enroll_status||chr(9)||
       f.event_id||chr(9)||ed.start_date||chr(9)||ed.status||chr(9)||cd.short_name||chr(9)||ed.facility_region_metro||chr(9)||f.enroll_type v_line
  from order_fact f
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join cust_dim c on f.cust_id = c.cust_id
where f.keycode = 'C09901022'
  and f.enroll_status != 'Cancelled'
order by cust_id,book_date;


v_fcst_name varchar2(50);
v_fcst_full varchar2(250);
v_roster_name varchar2(50);
v_roster_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;

begin

select 'cloudera_forecast_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/cloudera_forecast_'||to_char(sysdate,'yyyymmdd')||'.xls',
       'CLDWEB_registrations_roster_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/CLDWEB_registrations_roster_'||to_char(sysdate,'yyyymmdd')||'.xls'
  into v_fcst_name,v_fcst_full,v_roster_name,v_roster_full
  from dual;

select 'Course Code'||chr(9)||'Course Name'||chr(9)||'Start Date'||chr(9)||'Metro'||chr(9)||'Status'||chr(9)||'Enroll Cnt'||chr(9)||'GTR'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_fcst_name,'w');

utl_file.put_line(v_file,v_hdr);

for r1 in c1 loop
  utl_file.put_line(v_file,r1.v_line);
end loop;
utl_file.fclose(v_file);

send_mail_attach('susan.cipollini@globalknowledge.com','Gina.Neal@globalknowledge.com','',null,'Global Knowledge Cloudera Forecast','Open Excel Attachment.',v_fcst_full);
send_mail_attach('susan.cipollini@globalknowledge.com','actp@cloudera.com','susan.cipollini@globalknowledge.com','ron.wen@globalknowledge.com','Global Knowledge Cloudera Forecast','Open Excel Attachment.',v_fcst_full);
--send_mail_attach('susan.cipollini@globalknowledge.com','charlie.baird@globalknowledge.com',null,null,'Global Knowledge Cloudera Forecast','Open Excel Attachment.',v_fcst_full);
--send_mail_attach('susan.cipollini@globalknowledge.com','michele.bench@globalknowledge.com',null,null,'Global Knowledge Cloudera Forecast','Open Excel Attachment.',v_fcst_full);
--send_mail_attach('susan.cipollini@globalknowledge.com','ron.wen@globalknowledge.com',null,null,'Global Knowledge Cloudera Forecast','Open Excel Attachment.',v_fcst_full);



select 'Cust Grp'||chr(9)||'Cust ID'||chr(9)||'First Name'||chr(9)||'Last Name'||chr(9)||'Acct Name'||chr(9)||'Address1'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Zipcode'||chr(9)||
       'Enroll ID'||chr(9)||'Course Code'||chr(9)||'Enroll Status Desc'||chr(9)||'Book Date'||chr(9)||'Book Amt'||chr(9)||'Enroll Status'||chr(9)||'Event ID'||chr(9)||'Start Date'||chr(9)||
       'Status'||chr(9)||'Short Name'||chr(9)||'Metro'||chr(9)||'Enroll Type'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_roster_name,'w');

utl_file.put_line(v_file,v_hdr);

for r2 in c2 loop
  utl_file.put_line(v_file,r2.v_line);
end loop;
utl_file.fclose(v_file);

send_mail_attach('susan.cipollini@globalknowledge.com','joy.pruitt@globalknowledge.com','susan.cipollini@globalknowledge.com','ron.wen@globalknowledge.com','Global Knowledge Cloudera Forecast','Open Excel Attachment.',v_roster_full);

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CLOUDERA_AUDIT_PROC FAILED',SQLERRM);

end;
/


