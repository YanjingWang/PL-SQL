DROP PROCEDURE GKDW.GK_INSTRUCTOR_AUTO_SCHED_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_instructor_auto_sched_proc as

cursor c0 is
select s.dim_year,s.dim_week,s.event_id,s.gtr_flag,s.course_code,s.connected_c,facility_code,s.start_date,end_date,nvl(im.metro_level,3) metro,facility_tz,s.enroll_cnt,
       sum(case when c1.course_cnt > 0 then 1 else 0 end) course_cnt,
       sum(case when c1.connected_cnt > 0 then 1 else 0 end) connected_course_cnt,
       sum(case when s.connected_c = 'Y' and c1.connected_cnt > 0 then 1
                when s.connected_c is null and c1.course_cnt > 0 then 1
                else 0
           end) inst_cnt
  from gk_instructor_auto_schedule s
       inner join gk_instructor_course_v c1 on s.course_id = c1.course_id
       left outer join rmsdw.rms_instructor ri on c1.contactid = ri.slx_contact_id
       left outer join rmsdw.rms_instructor_metro im on ri.rms_instructor_id = im.rms_instructor_id and s.facility_region_metro = im.metro_code
 where s.inst_assigned is null
   and s.connected_c is null
   and s.connected_v_to_c is null
   and not exists (select 1 from gk_instructor_off_podium_v p where ri.rms_instructor_id = p.rms_instructor_id and s.start_date between p.start_date and p.end_date)
 group by s.dim_year,s.dim_week,s.event_id,s.gtr_flag,s.course_code,s.connected_c,facility_code,s.start_date,end_date,nvl(im.metro_level,3),facility_tz,s.enroll_cnt
 having sum(case when s.connected_c = 'Y' and c1.connected_cnt > 0 then 1
                 when s.connected_c is null and c1.course_cnt > 0 then 1
                 else 0
            end) > 0
union
select s.dim_year,s.dim_week,s.event_id,s.gtr_flag,s.course_code,s.connected_c,s.facility_code,s.start_date,s.end_date,nvl(im.metro_level,3) metro,s.facility_tz,
       s.enroll_cnt+s1.enroll_cnt enroll_cnt,
       sum(case when c1.course_cnt > 0 then 1 else 0 end) course_cnt,
       sum(case when c1.connected_cnt > 0 then 1 else 0 end) connected_course_cnt,
       sum(case when s.connected_c = 'Y' and c1.connected_cnt > 0 then 1
                when s.connected_c is null and c1.course_cnt > 0 then 1
                else 0
           end) inst_cnt
  from gk_instructor_auto_schedule s
       left outer join gk_instructor_auto_schedule s1 on s.event_id = s1.connected_v_to_c
       inner join gk_instructor_course_v c1 on s.course_id = c1.course_id
       left outer join rmsdw.rms_instructor ri on c1.contactid = ri.slx_contact_id
       left outer join rmsdw.rms_instructor_metro im on ri.rms_instructor_id = im.rms_instructor_id and s.facility_region_metro = im.metro_code
 where s.inst_assigned is null
   and s.connected_c = 'Y'
   and s.connected_v_to_c is null
   and not exists (select 1 from gk_instructor_off_podium_v p where ri.rms_instructor_id = p.rms_instructor_id and s.start_date between p.start_date and p.end_date)
 group by s.dim_year,s.dim_week,s.event_id,s.gtr_flag,s.course_code,s.connected_c,s.facility_code,s.start_date,s.end_date,nvl(im.metro_level,3),s.facility_tz,s.enroll_cnt+s1.enroll_cnt
 having sum(case when s.connected_c = 'Y' and c1.connected_cnt > 0 then 1
                 when s.connected_c is null and c1.course_cnt > 0 then 1
                 else 0
            end) > 0
 order by dim_year,dim_week,gtr_flag desc,connected_c,enroll_cnt desc,metro,start_date,connected_course_cnt,course_cnt asc,facility_tz asc;

cursor c1(v_event_id varchar2) is
select s.event_id,ri.slx_contact_id,c.rate inst_rate,
       s.facility_code,s.facility_region_metro metro,s.location_name,
       s.start_date,s.end_date,nvl(im.metro_level,3) metro_level,
       case when s.connected_c = 'Y' and c1.connected_cnt > 0 then 1
            when s.connected_c is null and c1.course_cnt > 0 then 1
            else 0
       end course_cnt,
       facility_tz,t2.timezone,abs(facility_tz-t2.timezone) tz_value,
       case when upper(ct.account) like 'GLOBAL KNOWLEDGE%' then 'Y' else 'N' end int_inst,
       case when nvl(im.metro_level,3) = 1 and upper(ct.account) like 'GLOBAL KNOWLEDGE%' then 1
            when nvl(im.metro_level,3) = 1 and upper(ct.account) not like 'GLOBAL KNOWLEDGE%' then 2
            when nvl(im.metro_level,3) = 2 and upper(ct.account) like 'GLOBAL KNOWLEDGE%' then 3
            when nvl(im.metro_level,3) = 2 and upper(ct.account) not like 'GLOBAL KNOWLEDGE%' then 4
            when nvl(im.metro_level,3) = 3 and upper(ct.account) like 'GLOBAL KNOWLEDGE%' then 5
            when nvl(im.metro_level,3) = 3 and upper(ct.account) not like 'GLOBAL KNOWLEDGE%' then 6
            else 7
       end sched_priority,
       nvl(cc1.class_week_cnt,0)+nvl(cc2.class_week_cnt,0)+nvl(cc3.class_week_cnt,0)+nvl(cc4.class_week_cnt,0) total_week_cnt,
       nvl(cc1.metro_level,0)+nvl(cc2.metro_level,0)+nvl(cc3.metro_level,0)+nvl(cc4.metro_level,0) total_metro_cnt,
       ita.avg_airfare
  from gk_instructor_auto_schedule s
       inner join gk_instructor_course_v c1 on s.course_id = c1.course_id
       inner join rmsdw.rms_instructor ri on c1.contactid = ri.slx_contact_id
       inner join rmsdw.rms_instructor_metro im on ri.rms_instructor_id = im.rms_instructor_id and s.facility_region_metro = im.metro_code
       inner join slxdw.contact ct on ri.slx_contact_id = ct.contactid
       inner join slxdw.address a on ct.addressid = a.addressid
       left outer join gk_inst_course_rate_mv c on s.course_id = c.evxcourseid and ri.slx_contact_id = c.instructor_id and s.start_date between c.start_date and c.end_date
       left outer join gk_timezone_lookup_v t2 on case when upper(a.country) = 'USA' then substr(a.postalcode,1,5) else upper(a.postalcode) end = t2.zipcode
       left outer join gk_inst_class_count_v cc1 on ri.slx_contact_id = cc1.contactid and s.dim_year = cc1.dim_year and s.dim_week-1 = cc1.dim_week
       left outer join gk_inst_class_count_v cc2 on ri.slx_contact_id = cc2.contactid and s.dim_year = cc2.dim_year and s.dim_week-2 = cc2.dim_week
       left outer join gk_inst_class_count_v cc3 on ri.slx_contact_id = cc3.contactid and s.dim_year = cc3.dim_year and s.dim_week-3 = cc3.dim_week
       left outer join gk_inst_class_count_v cc4 on ri.slx_contact_id = cc4.contactid and s.dim_year = cc4.dim_year and s.dim_week-4 = cc4.dim_week
       left outer join gk_inst_travel_airfare_v ita on s.facility_region_metro = ita.facility_region_metro and substr(a.postalcode,1,3) = ita.inst_zip_3
 where s.event_id = v_event_id
   and inst_assigned is null
   and case when s.connected_c = 'Y' and c1.connected_cnt > 0 then 1
            when s.connected_c is null and c1.course_cnt > 0 then 1
            else 0
       end > 0
   and not exists (select 1 from gk_instructor_auto_schedule s2 where ri.slx_contact_id = s2.inst_assigned and s.dim_year = s2.dim_year and s.dim_week = s2.dim_week)
   and not exists (select 1 from gk_instructor_off_podium_v p where ri.rms_instructor_id = p.rms_instructor_id and s.start_date between p.start_date and p.end_date)
order by course_cnt desc,sched_priority,metro_level,int_inst desc,total_week_cnt,total_metro_cnt,tz_value asc,c.rate,avg_airfare;

cursor c2(v_event_id varchar2) is
select event_id
  from gk_instructor_auto_schedule 
 where connected_v_to_c = v_event_id;
 
--cursor c2(v_event_id varchar2) is
--select ed2.event_id
--  from gk_instructor_auto_schedule s
--       inner join event_dim ed1 on s.event_id = ed1.event_id
--       inner join event_dim ed2 on ed1.course_code = ed2.course_code and ed1.start_date = ed2.start_date and ed1.facility_region_metro = ed2.facility_region_metro and ed1.ops_country != ed2.ops_country
-- where s.event_id = v_event_id
--   and ed1.facility_region_metro = 'VCL';

--cursor c3(v_inst_id varchar2,v_facility varchar2,v_location varchar2,v_metro varchar2,v_end_date date) is
--select s.event_id,c.slx_contact_id
--  from gk_instructor_auto_schedule s
--       inner join gk_instructor_cert_v c on s.course_id = c.course_id and substr(s.country,1,2) = c.instr_country
-- where c.slx_contact_id = v_inst_id
--   and s.location_name = v_location
--   and s.facility_code = v_facility
--   and s.facility_region_metro = v_metro
--   and s.start_date >= v_end_date+1
--   and inst_assigned is null
-- order by s.start_date;

--cursor c4 is
--select s.event_id
--  from gk_instructor_auto_schedule s
--       inner join time_dim td on td.dim_date = trunc(sysdate)
-- where s.dim_year = td.dim_year
--   and s.dim_week = td.dim_week+12
--   and cert_cnt is not null
--   and inst_assigned is null
--order by enroll_cnt desc,start_date;

--cursor c5(v_event_id varchar2) is
--select s.event_id,s.facility_code,s.start_date,s.end_date,c.slx_contact_id,c.int_inst,nvl(im.metro_level,3) metro,
--       ic.contactid,ic.course_cnt,nvl(c.slx_contact_id,ic.contactid) assign_inst,facility_tz,t2.timezone,abs(facility_tz-t2.timezone) tz_value
--  from gk_instructor_auto_schedule s
--       left outer join gk_instructor_cert_v c on s.course_id = c.course_id and substr(s.country,1,2) = c.instr_country
--       left outer join gk_instructor_course_v ic on s.course_id = ic.course_id and s.country = ic.ops_country
--       left outer join rmsdw.rms_instructor_metro im on c.rms_instructor_id = im.rms_instructor_id and s.facility_region_metro = im.metro_code
--       left outer join slxdw.contact ct on nvl(c.slx_contact_id,ic.contactid) = ct.contactid
--       left outer join slxdw.address a on ct.addressid = a.addressid
--       left outer join gk_timezone_lookup_v t2 on case when upper(a.country) = 'USA' then substr(a.postalcode,1,5) else upper(a.postalcode) end = t2.zipcode
--       inner join time_dim td on td.dim_date = trunc(sysdate)
-- where s.event_id = v_event_id
--   and not exists (select 1 from gk_instructor_off_podium_v p where c.rms_instructor_id = p.rms_instructor_id
--                                                               and s.start_date between p.start_date and p.end_date)
--   and nvl(c.slx_contact_id,ic.contactid) is not null
--   and nvl(c.slx_contact_id,ic.contactid) in (
--       select s2.inst_assigned from gk_instructor_auto_schedule s2
--        where s.dim_year = s2.dim_year
--          and s.dim_week = s2.dim_week
--          and s2.inst_assigned is not null
--        group by s2.inst_assigned
--        having count(*) <= 2)
-- order by metro,tz_value asc,int_inst desc,course_cnt desc;

cursor c6 is
select event_id,substr(s.country,1,2) rms_country,
       start_date,end_date,end_date-start_date event_dur,inst_assigned,
       f."id" rms_instructor,sc."id" rms_schedule
  from gk_instructor_auto_schedule s
       inner join time_dim td on td.dim_date = trunc(sysdate)
       inner join course_dim cd on s.course_id = cd.course_id and s.country = cd.country,
       "instructor_func"@rms_dev f,
       "schedule"@rms_dev sc
 where s.event_id = sc."slx_id"
   and s.inst_assigned = f."slx_contact_id"
   and s.dim_year||'-'||lpad(s.dim_week,2,'0') between td.dim_year||'-'||lpad(td.dim_week+6,2,'0') and td.dim_year||'-'||lpad(td.dim_week+12,2,'0')
   and inst_assigned is not null
   and end_date-start_date+1 <= cd.duration_days
   and not exists (select 1 from "schedule"@rms_dev sc
                                 inner join "date_value"@rms_dev dv on sc."id" = dv."schedule" 
                           where s.event_id = sc."slx_id")
 order by event_dur desc,start_date;

r1 c1%rowtype;
--r2 c2%rowtype;
--r3 c3%rowtype;
--r5 c5%rowtype;
r6 c6%rowtype;
v_curr_date varchar2(25);
v_day_value varchar2(25);
rms_slx_id varchar2(25);

begin

insert into gk_instructor_auto_schedule
select td.dim_year,td.dim_week,ed.event_id,cd.course_id,cd.course_code,ed.start_date,ed.end_date,ed.end_date-ed.start_date+1 dur,
       cd.course_ch,cd.course_mod,cd.course_pl,
       upper(ed.location_name) location_name,upper(ed.city) city,upper(ed.state) state,upper(ed.province) province,
       ed.country,ed.facility_code,ed.facility_region_metro,
       count(distinct f.enroll_id) enroll_cnt,null,count(distinct ic.contactid) course_cnt,t1.timezone,null,null,
       cv.canc_pct,ed.connected_c,ed.connected_v_to_c,
       case when ge.event_id is not null then 'Y' else 'N' end gtr_flag,null
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td1 on td1.dim_date = trunc(sysdate)
       inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
       inner join slxdw.address a on f.facilityaddressid = a.addressid
       left outer join gk_timezone_lookup_v t1 on case when ed.country = 'USA' then substr(a.postalcode,1,5) else upper(a.postalcode) end = t1.zipcode
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed'
       left outer join gk_instructor_course_v ic on cd.course_id = ic.course_id
       left outer join gk_course_canc_v cv on ed.course_id = cv.course_id and ed.ops_country = cv.ops_country and ed.facility_region_metro = cv.facility_region_metro
       left outer join gk_gtr_events ge on ed.event_id = ge.event_id
 where ed.status = 'Open'
   and cd.ch_num in ('10')
   and cd.md_num in ('10','20')
   and td.dim_year||'-'||lpad(td.dim_week,2,'0') between td1.dim_year||'-'||lpad(td1.dim_week+6,2,'0') and td1.dim_year||'-'||lpad(td1.dim_week+12,2,'0')
   and not exists (select 1 from gk_nested_courses nc where ed.course_id = nc.nested_course_id)
   and not exists (select 1 from "schedule"@rms_dev sc
                                 inner join "date_value"@rms_dev dv on sc."id" = dv."schedule" 
                           where ed.event_id = sc."slx_id")
   and not exists (select 1 from gk_instructor_auto_schedule s where ed.event_id = s.event_id)
 group by td.dim_year,td.dim_week,ed.event_id,cd.course_id,cd.course_code,ed.start_date,ed.end_date,ed.end_date-ed.start_date+1,
          cd.course_ch,cd.course_mod,cd.course_pl,ed.location_name,ed.city,ed.state,ed.province,ed.country,ed.facility_code,
          ed.facility_region_metro,t1.timezone,cv.canc_pct,ed.connected_c,ed.connected_v_to_c,ge.event_id
 having count(distinct f.enroll_id) >= 2 or ge.event_id = 'Y'
 order by td.dim_week,course_pl,course_code;

commit;

for r0 in c0 loop
  open c1(r0.event_id); fetch c1 into r1;
  if c1%FOUND then
    update gk_instructor_auto_schedule
       set inst_assigned = r1.slx_contact_id,
           instructor_tz = r1.timezone,
           tz_val = r1.tz_value
     where event_id = r1.event_id;
    
    if r0.connected_c = 'Y' then
      for r2 in c2(r0.event_id) loop
        update gk_instructor_auto_schedule
           set inst_assigned = r1.slx_contact_id,
               instructor_tz = r1.timezone,
               tz_val = r1.tz_value
         where event_id = r2.event_id;
      end loop;
    end if;

--    open c2(r1.event_id); fetch c2 into r2;
--    if c2%FOUND then
--      update gk_instructor_auto_schedule
--         set inst_assigned = r1.slx_contact_id,
--             instructor_tz = r1.timezone,
--             tz_val = r1.tz_value
--       where event_id = r2.event_id;
--    end if;
--    close c2;
--
--    for r3 in c3(r1.slx_contact_id,r1.facility_code,r1.location_name,r1.metro,r1.end_date) loop
--      update gk_instructor_auto_schedule
--         set inst_assigned = r1.slx_contact_id,
--           instructor_tz = r1.timezone,
--           tz_val = r1.tz_value
--       where event_id = r3.event_id;
--
--      open c2(r3.event_id); fetch c2 into r2;
--      if c2%FOUND then
--        update gk_instructor_auto_schedule
--           set inst_assigned = r1.slx_contact_id,
--               instructor_tz = r1.timezone,
--               tz_val = r1.tz_value
--         where event_id = r2.event_id;
--      end if;
--      close c2;
--
--    end loop;
  end if;
  close c1;
  commit;
end loop;

--for r4 in c4 loop
--  open c5(r4.event_id); fetch c5 into r5;
--    if c5%found then
--      update gk_instructor_auto_schedule
--         set inst_assigned = r5.assign_inst,
--             instructor_tz = r5.timezone,
--             tz_val = r5.tz_value
--       where event_id = r5.event_id;
--    end if;
--  close c5;
--  commit;
--end loop;

open c6;
loop
  fetch c6 into r6;
  exit when c6%notfound;

  for i in 0..r6.event_dur loop
    v_curr_date := to_char(sysdate,'yyyy-mm-dd hh:mi:ss AM');
    v_day_value := to_char(r6.start_date+i,'yyyy-mm-dd');

    if i = 0 then
      rms_slx_id := r6.event_id;
    else
      rms_slx_id := null;
    end if;

    insert into "date_value"@rms_dev
      values (null,v_curr_date,r6.rms_country,v_day_value,r6.rms_instructor,r6.rms_schedule,1,'no','Auto-Schedule-',null,'no',rms_slx_id);

  end loop;
  commit;
  update gk_instructor_auto_schedule
     set rms_schedule = r6.rms_schedule
   where event_id = r6.event_id;
  commit;
end loop;
close c6;

end;
/


