DROP PROCEDURE GKDW.GK_MSFT_PROFILE_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_msft_profile_audit_proc as

cursor c1 is
select cd.course_id,cd.course_code,short_name,min(ed.start_date) min_start_date,count(distinct ed.event_id) event_cnt,count(f.enroll_id) curr_enroll_cnt
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
       left outer join order_fact f on ed.event_id = f.event_id
 where cd.course_pl in ('MICROSOFT','MICROSOFT APPS')
   and not exists (select 1 from gk_mygk_course_profile_v p where cd.course_code = p.course_code)
   and ed.status = 'Open'
   and ed.start_date >= trunc(sysdate)
   and substr(cd.course_code,1,4) != '7016'
   and cd.md_num in ('10','20')
   and cd.ch_num in ('10','20')
 group by cd.course_id,cd.course_code,short_name
 order by min(ed.start_date);
 
cursor c2 is
select ed.event_id,cd.course_code,cd.short_name,ed.start_date,ed.facility_region_metro,cp.mygk_profile,cp.dmoc,cp.adobe_connect,
       count(f.enroll_id) enroll_cnt
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed' and f.fee_type not in ('Ons - Additional','Ons-Additional','Ons - Base')
       left outer join gk_mygk_course_profile_v cp on cd.course_id = cp.course_id
 where cd.course_pl in ('MICROSOFT','MICROSOFT APPS')
   and td1.dim_year = td2.dim_year
   and td1.dim_week = td2.dim_week+1
   and ed.status = 'Open'
   and substr(cd.course_code,1,4) != '7016'
   and cd.md_num in ('10','20')
   and cd.ch_num in ('10','20')
 group by cd.course_id,cd.course_code,cd.short_name,ed.event_id,ed.start_date,ed.facility_region_metro,cp.mygk_profile,cp.dmoc,cp.adobe_connect
 order by ed.start_date,cd.course_code,ed.facility_region_metro;
 
cursor c3 is
select distinct mygk_profile,dmoc 
  from gk_mygk_course_profile_v
 order by 1;

v_msg_body long;
 
begin

/*** MSFT COURSE PROFILE AUDIT ***/
v_msg_body := '<html><head></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=2 cellpadding=2 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th>Course Code</th><th>Short Name</th><th>Next Deliv</th><th>Event Cnt</th><th>Enroll Cnt</th></tr>';

for r1 in c1 loop
  v_msg_body:= v_msg_body||'<tr align=left>';
  v_msg_body := v_msg_body||'<td align=center>'||r1.course_code||'</td><td>'||r1.short_name||'</td><td align=center>'||r1.min_start_date||'</td>';
  v_msg_body := v_msg_body||'<td align=right>'||r1.event_cnt||'</td><td align=right>'||r1.curr_enroll_cnt||'</td></tr>';

end loop;

v_msg_body := v_msg_body||'</table><p>';
v_msg_body := v_msg_body||'</body></html>';

send_mail('DW.Automation@globalknowledge.com','linde.skinner@globalknowledge.com','MSFT Course Profile Audit Report',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','ashley.neace@globalknowledge.com','MSFT Course Profile Audit Report',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','ramona.sidharta@globalknowledge.com','MSFT Course Profile Audit Report',v_msg_body);


/*** MSFT WEEKLY EVENT PROFILE AUDIT ***/
v_msg_body := '<html><head></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=2 cellpadding=2 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr valign=bottom><th>Profile</th><th>DMOC</th></tr>';
for r3 in c3 loop
  v_msg_body:= v_msg_body||'<tr align=center>';
  v_msg_body := v_msg_body||'<td>'||r3.mygk_profile||'</td><td>'||r3.dmoc||'</td></tr>';
end loop;
v_msg_body := v_msg_body||'</table><p>';

v_msg_body := v_msg_body||'<table border=0 cellspacing=2 cellpadding=2 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th>Event ID</th><th>Course</th><th>Name</th><th>Start</th><th>Metro</th><th>Profile</th><th>Enroll</th></tr>';

for r2 in c2 loop
  v_msg_body:= v_msg_body||'<tr align=center>';
  v_msg_body := v_msg_body||'<td>'||r2.event_id||'</td><td>'||r2.course_code||'</td><td align=left>'||r2.short_name||'</td><td>'||r2.start_date||'</td><td>'||r2.facility_region_metro||'</td>';
  v_msg_body := v_msg_body||'<td>'||r2.mygk_profile||'</td><td align=right>'||r2.enroll_cnt||'</td></tr>';
end loop;

v_msg_body := v_msg_body||'</table><p>';
v_msg_body := v_msg_body||'</body></html>';

send_mail('DW.Automation@globalknowledge.com','linde.skinner@globalknowledge.com','MSFT Weekly Event Profile Audit Report',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','ashley.neace@globalknowledge.com','MSFT Weekly Event Profile Audit Report',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','ramona.sidharta@globalknowledge.com','MSFT Weekly Event Profile Audit Report',v_msg_body);

end;
/


