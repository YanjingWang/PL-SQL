DROP PROCEDURE GKDW.GK_EXT_VIRTUAL_SCHED_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_ext_virtual_sched_proc as

cursor c1 is
select distinct substr(country,1,2) country,pla."product_line_area" product_line_area,15 product_line_mode,'000000' vg_colour,'DD00DD' hg_colour,
       'Open' status,926 location_func,'no' show_in_slx,'no' show_in_web,lr."lab_request" lab_request,
       case when lr."lab_request" is not null then 'yes' else 'no' end lab_resource,
       0 lab_date_type,'session' day_session,0 pods,0 prov_book,'VCL Course' type,'no' international,
       p."id" product,1 language,0 minpart,12 maxpart,
       l.day1 startdate,l.lastday enddate,
       l.duration,2 student_ratio1,2 student_ratio2,2 student_ratio3,0 lab_special,
       158 rms_user,158 create_user,'yes' certificates_need,'yes' instructor_resource,
       'no' internal_facility,'no' pc_request,'no' projector_request,
       rr."audio_option" audio_option,rr."virtual_platform" virtual_platform,rr."remote_lab_provider" remote_lab_provider,
       l.day1,l.day2,l.day3,l.day4,l.day5,l.day6,l.day7,l.day8,
       l.start_time,l.end_time,l.instructor_id,
       p."vendor" vendor,p."product_code" product_id,p."description" product_title,
       case when l.instructor_id is null then 'N' else 'Y' end inst_assign_flag
  from gk_ext_virtual_sched_load l,
       "product"@rms_prod p,
       "product_product_line_area"@rms_prod pla, 
       "product_modality_lab_request"@rms_prod lr,
       "room_req_additional_fields"@rms_prod rr
 where substr(l.course_code,1,4) = p."us_code"
   and p."id" = pla."product"
   and p."id" = lr."product" (+)
   and lr."product_line_category" (+) = 2
   and p."id" = rr."product" (+)
   and rr."mode_id" (+) = 3
--   and not exists (select 1 from gk_ext_virtual_schedule vs where l.course_code = vs.course_code and to_date(l.day1,'yyyy-mm-dd') = vs.day1 
--                             and to_date(l.lastday,'yyyy-mm-dd') = vs.lastday
--                             and to_char(to_date(l.start_time,'hh24:mi'),'fmhhfm:mi AM') = vs.start_time)
   and not exists (select 1 from "schedule"@rms_prod s where p."id" = s."product" and s."product_line_mode" = 15
                      and s."start" = l.day1
                      and s."end" = l.lastday
                      and s."status" != 'Cancelled');

cursor c2 is
select vs.event_id,substr(l.country,1,2) country,s."id" schedule_id,
       l.instructor_id,l.instructor_name,f."id" rms_instructor,
       l.day1,l.day2,l.day3,l.day4,l.day5,l.day6,l.day7,l.day8
  from gk_ext_virtual_sched_load l,
       gk_ext_virtual_schedule vs,
       "schedule"@rms_prod s,
       "instructor_func"@rms_prod f
 where l.course_code = vs.course_code 
   and to_date(l.day1,'mm/dd/yyyy') = vs.day1 --  to_date(l.day1,'yyyy-mm-dd')
   and to_date(l.lastday,'mm/dd/yyyy') = vs.lastday -- to_date(l.lastday,'yyyy-mm-dd')
   and to_char(to_date(l.start_time,'hh24:mi'),'fmhhfm:mi AM') = vs.start_time
   and to_char(to_date(l.end_time,'hh24:mi'),'fmhhfm:mi AM') = vs.end_time
   and vs.event_id = s."slx_id"
   and l.instructor_id = f."slx_contact_id"
  -- and vs.instructor_id is null
   and not exists (select 1 from "date_value"@rms_prod dv where s."id" = dv."schedule");

r1 c1%rowtype;
r2 c2%rowtype;
v_curr_date varchar2(50);
v_schedule number;
v_instructor number;

begin
rms_link_set_proc;

--open c1;
--loop
--  fetch c1 into r1;
--  exit when c1%notfound;
--
--  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh:mi:ss AM');
--    
--  insert into "schedule"@rms_prod ("country","changed","booking_date","product_line_area","product_line_mode","vg_colour","hg_colour","status","location_func","show_in_slx",
--                                  "show_in_web","lab_type","lab_resource","lab_date_type","day_session","pods","prov_book","type","international","product","language",
--                                  "minpart","maxpart","start","end","duration","student_ratio1","student_ratio2","student_ratio3","lab_special","user","create_user",
--                                  "cerfiticates_need","instructor_resource","internal_facility","pc_request","projector_request","audio_option","virtual_platform","remote_lab_provider")
--  values (r1.country,v_curr_date,v_curr_date,r1.product_line_area,r1.product_line_mode,r1.vg_colour,r1.hg_colour,r1.status,r1.location_func,r1.show_in_slx,r1.show_in_web,r1.lab_request,
--          r1.lab_resource,r1.lab_date_type,r1.day_session,r1.pods,r1.prov_book,r1.type,r1.international,r1.product,r1.language,r1.minpart,r1.maxpart,r1.startdate,r1.enddate,r1.duration,
--          r1.student_ratio1,r1.student_ratio2,r1.student_ratio3,r1.lab_special,r1.rms_user,r1.create_user,r1.certificates_need,r1.instructor_resource,r1.internal_facility,r1.pc_request,
--          r1.projector_request,r1.audio_option,r1.virtual_platform,r1.remote_lab_provider);
--  commit;
--  
--  select max("id") into v_schedule from "schedule"@rms_prod;
--  
--  dbms_output.put_line('Schedule Created: '||v_schedule);
-- 
--  insert into "schedule_private_course"@rms_prod ("changed","schedule","vendor","product_id","product_title","type","bill_print","bill_paid","custom","slx_transfer")
--  values (v_curr_date,v_schedule,r1.vendor,r1.product_id,r1.product_title,'Onsite','no','no','no','yes');
--  commit;
--  
--  select max("id") into v_instructor from "instructor_func"@rms_prod where "slx_contact_id" = r1.instructor_id;
--  
--  dbms_output.put_line('Schedule Session Day1: '||r1.day1);
--  
--  if r1.day1 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day1,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day1,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day2 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day2,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day2,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day3 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day3,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day3,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day4 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day4,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day4,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day5 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day5,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day5,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day6 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day6,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day6,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day7 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day7,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day7,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  
--  if r1.day8 is not null then
--    insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,v_schedule,r1.day8,r1.start_time,r1.end_time);
--    
--    if r1.inst_assign_flag = 'Y' then
--      insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") values (v_curr_date,r1.country,r1.day8,v_instructor,v_schedule,1,'no','no');
--    end if;
--  end if;
--  commit;
--end loop;
--close c1;
--commit;

open c2;
loop
  fetch c2 into r2;
  exit when c2%notfound;

  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh:mi:ss AM');
  if r2.day1 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day1,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day1);
  end if;

  if r2.day2 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day2,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day2);
  end if;
  
  if r2.day3 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day3,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day3);
  end if;

  if r2.day4 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day4,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day4);
  end if;
  
  if r2.day5 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day5,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day5);
  end if;
  
  if r2.day6 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day6,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day6);
  end if;

  if r2.day7 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day7,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day7);
  end if;
  
  if r2.day8 is not null then
    insert into "date_value"@rms_prod ("changed","country","day_value","instructor","schedule","art","date_active","including_weekend") 
      values (v_curr_date,r2.country,r2.day8,r2.rms_instructor,r2.schedule_id,1,'no','no');
    dbms_output.put_line('Instructor '||r2.rms_instructor||' assigned to schedule '||r2.schedule_id||' for day '||r2.day8);
  end if;
  
  commit;
  
  update gk_ext_virtual_schedule
     set instructor_name = r2.instructor_name,
         instructor_id = r2.instructor_id
   where event_id = r2.event_id;
  
  commit;
end loop;
close c2;
  

end;
/


