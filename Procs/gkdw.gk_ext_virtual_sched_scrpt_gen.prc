DROP PROCEDURE GKDW.GK_EXT_VIRTUAL_SCHED_SCRPT_GEN;

CREATE OR REPLACE PROCEDURE GKDW.gk_ext_virtual_sched_scrpt_gen as

cursor c1 is
select distinct l.schedule_id,substr(country,1,2) country,pla."product_line_area" product_line_area,15 product_line_mode,'000000' vg_colour,'DD00DD' hg_colour,
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
       case when l.instructor_id is null then 'N' else 'Y' end inst_assign_flag,
       sp."schedule" schedule
  from gk_ext_virtual_sched_sessn l,
       "product"@rms_prod p,
       "product_product_line_area"@rms_prod pla, 
       "product_modality_lab_request"@rms_prod lr,
       "room_req_additional_fields"@rms_prod rr,
       "schedule_private_course"@rms_prod sp
 where substr(l.course_code,1,4) = p."us_code"
   and p."id" = pla."product"
   and p."id" = lr."product" (+)
   and lr."product_line_category" (+) = 2
   and p."id" = rr."product" (+)
   and rr."mode_id" (+) = 3
   and substr(l.schedule_id,1,6)  =sp."schedule" (+);
   -- and l.course_code = '5590Z'
--   and not exists (select 1 from gk_ext_virtual_schedule vs where l.course_code = vs.course_code and to_date(l.day1,'yyyy-mm-dd') = vs.day1 
--                             and to_date(l.lastday,'yyyy-mm-dd') = vs.lastday
--                             and to_char(to_date(l.start_time,'hh24:mi'),'fmhhfm:mi AM') = vs.start_time)
--   and not exists (select 1 from "schedule"@rms_prod s where p."id" = s."product" and s."product_line_mode" = 15
--                      and s."start" = l.day1
--                      and s."end" = l.lastday
--                      and s."status" != 'Cancelled');

cursor c2 is
select distinct l.schedule_id,
       l.day1 startdate,l.lastday enddate,
       l.duration,l.day1,l.day2,l.day3,l.day4,l.day5,l.day6,l.day7,l.day8,
       l.start_time,l.end_time,
       case when l.instructor_id is null then 'N' else 'Y' end inst_assign_flag
  from gk_ext_virtual_sched_sessn l
 where not exists (select 1 from "schedule_sessions"@rms_prod ss where ss."schedule" = substr(l.schedule_id,1,6));

r1 c1%rowtype;
r2 c2%rowtype;
v_curr_date varchar2(50);
--r1.schedule number;
--v_instructor number;

begin
rms_link_set_proc;

open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;

  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh:mi:ss AM');

if r1.schedule is null then
  insert into "schedule_private_course"@rms_prod ("changed","schedule","vendor","product_id","product_title","type","bill_print","bill_paid","custom","slx_transfer")
  values (v_curr_date,r1.schedule_id,r1.vendor,r1.product_id,r1.product_title,'Onsite','no','no','no','yes');
end if;

  -- select max("id") into v_instructor from "instructor_func"@rms_prod where "slx_contact_id" = r1.instructor_id;
end loop;
close c1;
commit;

open c2;
loop
  fetch c2 into r2;
  exit when c2%notfound;

  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh:mi:ss AM');
  if r2.day1 is not null then
  --  insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day1,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day1||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');

  end if;
  
  if r2.day2 is not null then
  --  insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day2,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day2||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');
  end if;
  
  if r2.day3 is not null then
  --  insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day3,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day3||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');
    

  end if;
  
  if r2.day4 is not null then
  --  insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day4,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day4||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');

  end if;
  
  if r2.day5 is not null then
   -- insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day5,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day5||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');
  end if;
  
  if r2.day6 is not null then
  --  insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day6,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day6||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');
  end if;
  
  if r2.day7 is not null then
   -- insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day7,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day7||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');
  end if;
  
  if r2.day8 is not null then
   -- insert into "schedule_sessions"@rms_prod ("changed","schedule","day","start_time","end_time") values (v_curr_date,r2.schedule_id,r2.day8,r2.start_time,r2.end_time);
    dbms_output.put_line('insert into schedule_sessions (changed,schedule,day,start_time,end_time) values (now(),'||r2.schedule_id||',STR_TO_DATE('||''''||r2.day8||''','||''''||'%m/%d/%Y'||'''),'||''''||r2.start_time||''','||''''||r2.end_time||''');');
  end if;
--  commit;

end loop;

close c2;
--commit;
--  
--exception
--when others then 
--dbms_OUTPUT.PUT_LINE('ERROR');
end;
/


