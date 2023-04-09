DROP PROCEDURE GKDW.GK_PARTNER_PORTAL_LOAD_PROC_BK;

CREATE OR REPLACE PROCEDURE GKDW.gk_partner_portal_load_proc_bk(p_partner varchar2) as

cursor c1 is 
select pl.event_schedule_id,course_code,event_id,course_name,ibm_course_code,ibm_ww_course_code,start_date,end_date,start_time,end_time,
       time_zone,city,state_id,country_id,course_url,class_language,delivery_method,event_type,partner_id,active,status,student_cnt,region_id,odr_slx_id,
       pl.end_date-pl.start_date+1 dur_days,line_id,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end gtr 
  from gk_partner_portal_load_mv pl
 where pl.partner_code = p_partner
   and status = 'Open'
   and not exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id)
   and end_date >= trunc(sysdate)
union
select pl.event_schedule_id,course_code,event_id,course_name,ibm_course_code,ibm_ww_course_code,start_date,end_date,start_time,end_time,
       timezone,city,state_id,country_id,course_url,class_language,delivery_method,event_type,partner_id,active,status,student_cnt,region_id,null,
       pl.end_date-pl.start_date+1 dur_days,'BLI2014120914123401279416' line_id,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end gtr 
  from gk_ibm_emea_portal_load_mv pl
 where pl.status in ('Open','Update')
   and pl.delivery_method not in ('SPVC','WBT')
  and not exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id)
  and end_date >= trunc(sysdate);
  
cursor c2 is
select pl.event_schedule_id,course_code,event_id,course_name,ibm_course_code,ibm_ww_course_code,start_date,end_date,start_time,end_time,
       time_zone,city,state_id,country_id,course_url,class_language,delivery_method,event_type,partner_id,active,status,student_cnt,region_id,odr_slx_id,
       pl.end_date-pl.start_date+1 dur_days,line_id,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end gtr
  from gk_partner_portal_load_mv pl
where partner_code = p_partner
  and status = 'Open'
  and exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id)
  and last_update_date >= trunc(sysdate)-1
  and end_date >= trunc(sysdate)
union
select pl.event_schedule_id,course_code,event_id,course_name,ibm_course_code,ibm_ww_course_code,start_date,end_date,start_time,end_time,
       timezone,city,state_id,country_id,course_url,class_language,delivery_method,event_type,partner_id,active,status,student_cnt,region_id,null,
       pl.end_date-pl.start_date+1 dur_days,'BLI2014120914123401279416' line_id,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end gtr 
  from gk_ibm_emea_portal_load_mv pl
 where pl.status = 'Update'
   and pl.delivery_method not in ('SPVC','WBT')
   and exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id)
   and end_date >= trunc(sysdate);
  
cursor c3 is
select pl.event_schedule_id,pl.line_id 
 from gk_partner_portal_load_mv pl
where partner_code = p_partner
  and status = 'Cancelled'
  and exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id and es.status != 'Cancelled')
union
select event_schedule_id,'BLI2014120914123401279416' line_id
  from gk_ibm_emea_portal_load_mv pl
 where status = 'Cancelled'
   and exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id and es.status != 'Cancelled');

cursor c4 is
select pl.event_schedule_id,pl.line_id  
  from gk_partner_portal_load_mv pl
 where partner_code = p_partner
   and status = 'Verified'
   and exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id and es.status != 'Verified')
union
select event_schedule_id,'BLI2014120914123401279416' line_id
  from gk_ibm_emea_portal_load_mv pl
 where pl.status = 'Complete'
   and exists (select 1 from event_schedule@part_portals es where pl.event_id = es.event_id and es.status != 'Verified');

cursor c5 is
select pl.event_schedule_id,es.gtr portal_gtr,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end new_gtr_flag
 from gk_partner_portal_load_mv pl
      inner join event_schedule@part_portals es on pl.event_id = es.event_id and pl.line_id = es.line_id
where partner_code = p_partner
  and pl.end_date >= trunc(sysdate)
  and case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end <> es.gtr
union
select pl.event_schedule_id,es.gtr portal_gtr,
       case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end new_gtr_flag
 from gk_ibm_emea_portal_load_mv pl
      inner join event_schedule@part_portals es on pl.event_id = es.event_id
where pl.end_date >= trunc(sysdate)
  and (case when nvl(trim(pl.gtr_flag),'0') = '1' then 'T' else 'F' end <> es.gtr or es.gtr is null);
 
cursor c6 is
select p.* 
from gk_partner_odr_id_v@slx  p
inner  join event_schedule@part_portals es on p.evxeventid = es.event_schedule_id
minus
select event_schedule_id,odr_slx_id from event_schedule@part_portals;

v_curr_date varchar2(25);

begin

dbms_snapshot.refresh('gkdw.gk_partner_portal_load_mv');
gk_emea_mv_rebuild_proc;

for r1 in c1 loop
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

  insert into event_schedule@part_portals(event_schedule_id,createdate,modifydate,course_code,event_id,course_name,ibm_course_code,ibm_ww_course_code,start_date,end_date,start_time,end_time,time_zone,city,
                                              state,country,course_url,class_language,delivery_method,event_type,partner_id,active,status,student_count,region_id,modifyby_id,line_id,duration_days,
                                              odr_slx_id,gtr)
  values (r1.event_schedule_id,v_curr_date,v_curr_date,r1.course_code,r1.event_id,r1.course_name,r1.ibm_course_code,r1.ibm_ww_course_code,r1.start_date,r1.end_date,r1.start_time,r1.end_time,r1.time_zone,
          r1.city,r1.state_id,r1.country_id,r1.course_url,r1.class_language,r1.delivery_method,r1.event_type,r1.partner_id,r1.active,'Open',r1.student_cnt,r1.region_id,r1.partner_id,r1.line_id,r1.dur_days,
          r1.odr_slx_id,r1.gtr);
end loop;
commit;

for r2 in c2 loop
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
  
  delete from event_schedule@part_portals where event_schedule_id = r2.event_schedule_id;

  insert into event_schedule@part_portals(event_schedule_id,createdate,modifydate,course_code,event_id,course_name,ibm_course_code,ibm_ww_course_code,start_date,end_date,start_time,end_time,time_zone,city,
                                              state,country,course_url,class_language,delivery_method,event_type,partner_id,active,status,student_count,region_id,modifyby_id,line_id,duration_days,
                                              odr_slx_id,gtr)
  values (r2.event_schedule_id,v_curr_date,v_curr_date,r2.course_code,r2.event_id,r2.course_name,r2.ibm_course_code,r2.ibm_ww_course_code,r2.start_date,r2.end_date,r2.start_time,r2.end_time,r2.time_zone,
          r2.city,r2.state_id,r2.country_id,r2.course_url,r2.class_language,r2.delivery_method,r2.event_type,r2.partner_id,r2.active,'Open',r2.student_cnt,r2.region_id,r2.partner_id,r2.line_id,r2.dur_days,
          r2.odr_slx_id,r2.gtr);
end loop;
commit;

for r5 in c5 loop
  update event_schedule@part_portals
     set gtr = r5.new_gtr_flag
   where event_schedule_id = r5.event_schedule_id;
end loop;
commit;

for r3 in c3 loop
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
  
  update event_schedule@part_portals 
     set status = 'Cancelled',
         modifydate = v_curr_date
   where event_schedule_id = r3.event_schedule_id
     and line_id = r3.line_id;
end loop;
commit;

for r4 in c4 loop
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
  
  update event_schedule@part_portals 
     set status = 'Verified',
         modifydate = v_curr_date
   where event_schedule_id = r4.event_schedule_id
     and line_id = r4.line_id;
end loop;
commit;

for r6 in c6 loop
  update event_schedule@part_portals
     set odr_slx_id = r6.odr_slx_id
   where event_schedule_id = r6.evxeventid;
end loop;
commit;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_PARTNER_PORTAL_LOAD_PROC Failed',SQLERRM);


end;
/


