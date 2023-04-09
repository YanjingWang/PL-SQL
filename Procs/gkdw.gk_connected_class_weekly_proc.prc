DROP PROCEDURE GKDW.GK_CONNECTED_CLASS_WEEKLY_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_connected_class_weekly_proc(p_week varchar2 default null) as

cursor c3(v_country varchar2,c_week varchar2) is
select ed.ops_country,ed.facility_code,ed.location_name||'('||ed.facility_code||')' location_name,ed.facility_region_metro,
       ed.event_id,ed.start_date,ed.end_date,cd.course_code,cd.short_name,
       case when cc.event_id is not null then 'CONNECTED-C' else null end cc_flag,
       rl.remote_lab_vendor rl_flag,
       cd.course_pl,rl.bandwidth,lr."name" room_name,
       ie.firstname||' '||ie.lastname inst_name
from event_dim ed
     left outer join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
     inner join time_dim td1 on ed.start_date = td1.dim_date
     inner join time_dim td2 on td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = c_week and td2.dim_day = 'Monday'
     inner join gk_remote_lab_courses_mv rl on cd.course_id = rl.course_id
     inner join "schedule"@rms_prod s on ed.event_id = s."slx_id"
     left outer join "location_rooms"@rms_prod lr on s."location_rooms" = lr."id"
     left outer join gk_connected_class_v cc on ed.event_id = cc.event_id and cc.connected_c = 'Y'
 where td1.dim_year = td2.dim_year
   and td1.dim_week = td2.dim_week
   and upper(f.facilityname) like 'GLOBAL KNOW%'
   and f.facilitystatus = 'Active'
   and ed.status != 'Cancelled'
   and ed.ops_country = v_country
union
select ed.ops_country,ed.facility_code,ed.location_name||'('||ed.facility_code||')' location_name,ed.facility_region_metro,
       ed.event_id,ed.start_date,ed.end_date,cd.course_code,cd.short_name,
       case when cc.event_id is not null then 'CONNECTED-C' else null end cc_flag,
       null rl_flag,
       cd.course_pl,null bandwidth,lr."name" room_name,
       ie.firstname||' '||ie.lastname inst_name
from event_dim ed
     left outer join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
     inner join time_dim td1 on ed.start_date = td1.dim_date
     inner join time_dim td2 on td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = c_week and td2.dim_day = 'Monday'
     inner join "schedule"@rms_prod s on ed.event_id = s."slx_id"
     left outer join "location_rooms"@rms_prod lr on s."location_rooms" = lr."id"
     inner join gk_connected_class_v cc on ed.event_id = cc.event_id and cc.connected_c = 'Y'
 where td1.dim_year = td2.dim_year
   and td1.dim_week = td2.dim_week
   and upper(f.facilityname) like 'GLOBAL KNOW%'
   and f.facilitystatus = 'Active'
   and ed.status != 'Cancelled'
   and ed.ops_country = v_country
   and not exists (select 1 from gk_remote_lab_courses_mv rl where cd.course_id = rl.course_id)
union
select ed.ops_country,ed.facility_code,ed.location_name||'('||ed.facility_code||')' location_name,ed.facility_region_metro,
       ed.event_id,ed.start_date,ed.end_date,cd.course_code,cd.short_name,
       case when cc.event_id is not null then 'CONNECTED-C' else null end cc_flag,
       rl.remote_lab_vendor rl_flag,
       cd.course_pl,rl.bandwidth,lr."name" room_name,
       ie.firstname||' '||ie.lastname inst_name
from event_dim ed
     left outer join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
     inner join gk_connected_class_v cc on ed.event_id = cc.event_id and cc.connected_c = 'Y'
     inner join time_dim td1 on ed.start_date = td1.dim_date
     inner join time_dim td2 on td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = c_week and td2.dim_day = 'Monday'
     inner join gk_remote_lab_courses_mv rl on cd.course_id = rl.course_id
     inner join "schedule"@rms_prod s on ed.event_id = s."slx_id"
     left outer join "location_rooms"@rms_prod lr on s."location_rooms" = lr."id"
 where td1.dim_year = td2.dim_year
   and td1.dim_week = td2.dim_week
   and upper(f.facilityname) not like 'GLOBAL KNOW%'
   and f.facilitystatus = 'Active'
   and ed.status != 'Cancelled'
   and ed.ops_country = v_country
order by 1 desc,2,6,14,8;

v_msg_body long;
v_email varchar2(250);
v_fac_code varchar2(250) := 'NONE';
v_week varchar2(25);
sdate varchar2(25);
edate varchar2(25);

begin

rms_link_set_proc;

dbms_snapshot.refresh('gkdw.gk_remote_lab_courses_mv');

if p_week is null then
  select dim_year||'-'||lpad(dim_week,2,'0') into v_week
    from time_dim
   where dim_date = trunc(sysdate);
else
  v_week := p_week;
end if;

select min(dim_date),max(dim_date) into sdate,edate
from time_dim
where dim_year||'-'||lpad(dim_week,2,'0') = v_week;

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><td colspan=5 align=left><img src="http://images.globalknowledge.com/wwwimages/gk_logo.gif" alt="Global Knowledge IT Training" width=165 height=90 border=0></td></tr>';
v_msg_body := v_msg_body||'<tr><td colspan=11>&nbsp</td></tr>';
v_msg_body := v_msg_body||'<tr><td colspan=11 align=left><b>US TRAINING CENTER EVENTS FOR WEEK - '||v_week||'('||sdate||' <-> '||edate||')</td></tr>';

v_msg_body := v_msg_body||'<tr><th align=left>Facility</th><th align=left>Metro</th><th align=left>Prod Line</th><th align=left>Short Name</th>';
v_msg_body := v_msg_body||'<th align=left>Course Code</th><th align=left>Event/Instructor</th><th align=left>Connected</th><th align=left>Remote Lab</th><th align=left>Room</th><th align=left>Bandwidth</th></tr>';

for r3 in c3('USA',v_week) loop
  if r3.facility_code = v_fac_code then
    v_msg_body := v_msg_body||'<tr align=left><td> </td><td>'||r3.facility_region_metro||'</td><td>'||r3.course_pl||'</td><td>'||r3.short_name||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.course_code||'</td><td>'||r3.event_id||'('||r3.inst_name||')</td><td>'||r3.cc_flag||'</td><td>'||r3.rl_flag||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.room_name||'</td><td align=right>'||r3.bandwidth||'</td></tr>';
  else 
    v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=11 height=1></th></tr>';
    v_msg_body := v_msg_body||'<tr align=left><td>'||r3.location_name||'</td><td>'||r3.facility_region_metro||'</td><td>'||r3.course_pl||'</td><td>'||r3.short_name||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.course_code||'</td><td>'||r3.event_id||'('||r3.inst_name||')</td><td>'||r3.cc_flag||'</td><td>'||r3.rl_flag||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.room_name||'</td><td align=right>'||r3.bandwidth||'</td></tr>';
    
    v_fac_code := r3.facility_code;  
  end if; 
end loop;

v_msg_body := v_msg_body||'<tr><td colspan=11>&nbsp</td></tr>';
v_msg_body := v_msg_body||'<tr><td colspan=11 align=left><b>CANADA TRAINING CENTER EVENTS FOR WEEK - '||v_week||'('||sdate||' <-> '||edate||')</td></tr>';

v_msg_body := v_msg_body||'<tr><th align=left>Facility</th><th align=left>Metro</th><th align=left>Prod Line</th><th align=left>Short Name</th>';
v_msg_body := v_msg_body||'<th align=left>Course Code</th><th align=left>Event</Instructor/th><th align=left>Connected</th><th align=left>Remote Lab</th><th align=left>Room</th><th align=left>Bandwidth</th></tr>';

for r3 in c3('CANADA',v_week) loop
  if r3.facility_code = v_fac_code then
    v_msg_body := v_msg_body||'<tr align=left><td> </td><td>'||r3.facility_region_metro||'</td><td>'||r3.course_pl||'</td><td>'||r3.short_name||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.course_code||'</td><td>'||r3.event_id||'('||r3.inst_name||')</td><td>'||r3.cc_flag||'</td><td>'||r3.rl_flag||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.room_name||'</td><td align=right>'||r3.bandwidth||'</td></tr>';
  else 
    v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=11 height=1></th></tr>';
    v_msg_body := v_msg_body||'<tr align=left><td>'||r3.location_name||'</td><td>'||r3.facility_region_metro||'</td><td>'||r3.course_pl||'</td><td>'||r3.short_name||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.course_code||'</td><td>'||r3.event_id||'('||r3.inst_name||')</td><td>'||r3.cc_flag||'</td><td>'||r3.rl_flag||'</td>';
    v_msg_body := v_msg_body||'<td>'||r3.room_name||'</td><td align=right>'||r3.bandwidth||'</td></tr>';
    
    v_fac_code := r3.facility_code;  
  end if; 
end loop;


v_msg_body := v_msg_body||'</table><p>';
v_msg_body := v_msg_body||'</body></html>';

send_mail('administrator@globalknowledge.com','administrator@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
send_mail('administrator@globalknowledge.com','Corporate.Helpdesk@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
send_mail('administrator@globalknowledge.com','Corporate.CERTTeam@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
send_mail('administrator@globalknowledge.com','michael.harward@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
--send_mail('administrator@globalknowledge.com','chris.gosk@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
send_mail('administrator@globalknowledge.com','frank.anastasio@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
--send_mail('administrator@globalknowledge.com','ben.johnson@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);
send_mail('administrator@globalknowledge.com','charles.carpenter@globalknowledge.com','Weekly Connected Classroom & Remote Lab Report',v_msg_body);

end;
/


