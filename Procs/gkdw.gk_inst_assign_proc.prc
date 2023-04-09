DROP PROCEDURE GKDW.GK_INST_ASSIGN_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_inst_assign_proc as

cursor c0 is
  select l.event_id,sum(nvl(book_amt,0)) rev_amt,
         sum(case when f.enroll_id is not null then 1 else 0 end) enroll_cnt,
         sum(case when f.enroll_id is not null and upper(f.source) = 'NEXIENT' then 1 else 0 end) nex_enroll_cnt,
         sum(case when f.enroll_id is not null and upper(nvl(f.source,'GK')) != 'NEXIENT' then 1 else 0 end) gk_enroll_cnt
    from gk_inst_localization l
         left outer join order_fact f on l.event_id = f.event_id and f.enroll_status != 'Cancelled' and f.book_amt > 0
   where l.end_date >= trunc(sysdate)
   group by l.event_id
  minus
  select event_id,rev_amt,enroll_cnt,nex_enroll_cnt,gk_enroll_cnt
    from gk_inst_localization;

cursor c0_u is
  select l.event_id,
         sum(case when f.attendee_type = 'Unlimited' then 1 else 0 end) unlimited_cnt
    from gk_inst_localization l
         inner join order_fact f on l.event_id = f.event_id and f.enroll_status != 'Cancelled'
   where exists (select 1 from gk_inst_localization l2 where l.event_id = l2.event_id)
     and l.end_date >= trunc(sysdate)
   group by l.event_id
  minus
  select event_id,unlimited_cnt
    from gk_inst_localization;

cursor c0_l is
  select l.event_id,
         sum(case when upper(promo_code) in ('LOCKIT40','LOCKIT50') then 1 else 0 end) lock_promo_cnt
    from gk_inst_localization l
         inner join order_fact f on l.event_id = f.event_id and f.enroll_status != 'Cancelled'
   where exists (select 1 from gk_inst_localization l2 where l.event_id = l2.event_id)
     and l.end_date >= trunc(sysdate)
   group by l.event_id
  minus
  select event_id,lock_promo_cnt
    from gk_inst_localization;

cursor c0_6 is
  select l.event_id,sum(f.book_amt) rev_amt
    from gk_inst_localization l
         inner join order_fact f on l.event_id = f.event_id and f.book_date <= start_date-42
   where l.end_date >= trunc(sysdate)
   group by l.event_id;

cursor c0_loc is
  select ed.event_id,ed.location_id,ed.city,ed.state,ed.zipcode,ed.facility_region_metro,ed.facility_code,
         cd.course_code,cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.short_name
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join gk_inst_localization l on ed.event_id = l.event_id
   where ed.end_date >= trunc(sysdate)
  minus
  select event_id,location_id,event_city,event_state,event_zipcode,facility_region_metro,facility_code,
         course_code,course_ch,course_mod,course_pl,ch_num,md_num,pl_num,short_name
    from gk_inst_localization l;


cursor c1 is
  select gil.event_id,gil.course_code,gil.facility_region_metro,gil.facility_code,rim.metro_level,
         count(distinct ri.slx_contact_id) inst_cnt,gil.enroll_cnt,gil.rev_amt,
         case when facility_region_metro = 'ONS' then 0 else 1 end metro_sort
    from gk_inst_localization gil
         inner join rmsdw.rms_instructor_cert ric on substr(gil.course_code,1,4) = ric.coursecode and gil.course_mod = ric.modality_group
         inner join rmsdw.rms_instructor_metro rim on ric.rms_instructor_id = rim.rms_instructor_id and rim.metro_code = gil.facility_region_metro
         inner join rmsdw.rms_instructor ri on rim.rms_instructor_id = ri.rms_instructor_id
         inner join cust_dim cd on ri.slx_contact_id = cd.cust_id and cd.country = gil.ops_country
   where ric.status = 'certready'
     and gil.instructor_id is null
     and gil.cancelled_date is null
     and gil.start_date > trunc(sysdate)
     and gil.course_code not in (select nested_course_code from gk_nested_courses)
     and not exists (select 1 from gk_inst_localization l where l.instructor_id = ri.slx_contact_id and gil.start_date between l.start_date and l.end_date)
     and not exists (select 1 from gk_inst_unavailable_mv u where gil.event_id = u.event_id)
     and not exists (select 1 from gk_inst_unavailable_mv u2 where cd.cust_id = u2.instructor_id and gil.start_week between u2.start_week and u2.end_week)
   group by gil.event_id,gil.course_code,gil.facility_region_metro,gil.facility_code,rim.metro_level,gil.enroll_cnt,gil.rev_amt,
         case when facility_region_metro = 'ONS' then 1 else 0 end
   having gil.rev_amt > 0
   order by metro_level,metro_sort,count(distinct ri.slx_contact_id),gil.rev_amt desc;

cursor c2(v_event_id varchar2,v_metro_level number) is
  select gil.event_id,gil.location_id,gil.start_date,gil.end_date,cd.cust_id,rim.metro_level,upper(cd.cust_name) inst_name,upper(cd.city) inst_city,
         upper(cd.state) inst_state,cd.zipcode,ric.rms_instructor_id,count(ric.rms_inst_cert_id) cert_cnt,
         case when (cd.acct_name like 'GLOBAL KNOWLEDGE%' or cd.acct_name like 'NEXIENT%') then 'Y' else 'N' end gk_emp,gil.course_code
    from gk_inst_localization gil
         inner join rmsdw.rms_instructor_cert ric on substr(gil.course_code,1,4) = ric.coursecode and gil.course_mod = ric.modality_group
         inner join rmsdw.rms_instructor_metro rim on ric.rms_instructor_id = rim.rms_instructor_id and rim.metro_code = gil.facility_region_metro
         inner join rmsdw.rms_instructor ri on rim.rms_instructor_id = ri.rms_instructor_id
         inner join cust_dim cd on ri.slx_contact_id = cd.cust_id and cd.country = gil.ops_country
         inner join rmsdw.rms_instructor_cert ric2 on ric.rms_instructor_id = ric2.rms_instructor_id and ric2.status = 'certready'
   where ric.status = 'certready'
     and gil.event_id = v_event_id
     and rim.metro_level = v_metro_level
     and not exists (select 1 from gk_inst_localization l where cd.cust_id = l.instructor_id and gil.start_date between l.start_date and l.end_date)
     and not exists (select 1 from gk_inst_unavailable_mv u2 where cd.cust_id = u2.instructor_id and gil.start_week between u2.start_week and u2.end_week)
   group by gil.event_id,gil.location_id,gil.start_date,gil.end_date,cd.cust_id,rim.metro_level,upper(cd.cust_name),upper(cd.city),
         upper(cd.state),cd.zipcode,ric.rms_instructor_id,
         case when (cd.acct_name like 'GLOBAL KNOWLEDGE%' or cd.acct_name like 'NEXIENT%') then 'Y' else 'N' end,gil.course_code
   order by gk_emp desc,count(ric.rms_inst_cert_id);

cursor c3(v_location_id varchar2,v_instructor_id varchar2,v_end_date date) is
  select gil.event_id,gil.location_id,gil.end_date,cd.cust_id,rim.metro_level,upper(cd.cust_name) inst_name,upper(cd.city) inst_city,
         upper(cd.state) inst_state,cd.zipcode
    from gk_inst_localization gil
         inner join rmsdw.rms_instructor_cert ric on substr(gil.course_code,1,4) = ric.coursecode and gil.course_mod = ric.modality_group
         inner join rmsdw.rms_instructor_metro rim on ric.rms_instructor_id = rim.rms_instructor_id and rim.metro_code = gil.facility_region_metro
         inner join rmsdw.rms_instructor ri on rim.rms_instructor_id = ri.rms_instructor_id
         inner join cust_dim cd on ri.slx_contact_id = cd.cust_id
   where ric.status = 'certready'
     and gil.location_id = v_location_id
     and cd.cust_id = v_instructor_id
     and gil.start_date = v_end_date+1
     and cancelled_date is null;

--cursor c4(v_course varchar2) is
--  select master_course_code,nested_course_code
--    from gk_nested_courses
--   where master_course_code = v_course;

--cursor c5 is
--  select to_char(td.dim_date,'yyyy-mm-dd') day_value,
--       ri.rms_instructor_id,
--       s."id" sched_id,
--       1 art_id,
--       'yes' date_active,
--       '(Auto-'||to_char(sysdate,'yymmdd')||') ' sched_comment,
--       l.course_code,
--       l.start_date,
--       l.facility_region_metro
--  from gk_inst_localization l,
--       rmsdw.rms_instructor ri,
--       "schedule"@rms_dev s,
--       time_dim td
--where instructor_id is not null
--  and l.instructor_id = ri.slx_contact_id
--  and s."slx_id" = l.event_id
--  and td.dim_date between l.start_date and l.end_date
--  and not exists (select 1 from "date_value"@rms_dev v where s."id"= v."schedule" and ri.rms_instructor_id = v."instructor")
--  order by ri.rms_instructor_id,s."id",td.dim_date;

cursor c6 is
select gil.event_id,ie.contactid,nvl(rim.metro_level,0) metro_level,
       upper(cd.first_name||' '||cd.last_name) ins_name,
       upper(city) ins_city,upper(state) ins_state,upper(zipcode) ins_zipcode,'RC' assigned_by,
       case when (cd.acct_name like 'GLOBAL KNOWLEDGE%' or cd.acct_name like 'NEXIENT%') then 'Internal' else 'External' end inst_type
  from gk_inst_localization  gil
       inner join instructor_event_v ie on ie.evxeventid = gil.event_id
       inner join rmsdw.rms_instructor ri on ie.contactid = ri.slx_contact_id
       inner join cust_dim cd on ie.contactid = cd.cust_id
       left outer join rmsdw.rms_instructor_metro rim on ri.rms_instructor_id = rim.rms_instructor_id
                                                     and rim.metro_code = gil.facility_region_metro
 where ie.feecode in ('SI','INS')
   and gil.end_date >= trunc(sysdate)
   and cancelled_date is null;

cursor c7(sdate number,edate number) is
select l.event_id,
       case when enroll_cnt < min_enroll_cnt then 'RED'
            when enroll_cnt between min_enroll_cnt and trunc(avg_fill_rate) then 'YELLOW'
            when enroll_cnt >= trunc(avg_fill_rate) then 'GREEN'
       end event_run_status
  from gk_inst_localization l
       inner join event_dim ed on l.event_id = ed.event_id
       inner join gk_course_fill_std_v fs on ed.course_code = fs.course_code
                                         and ed.event_channel = fs.event_channel
                                         and ed.event_modality = fs.event_modality
                                         and ed.start_date-trunc(sysdate) between sdate and edate
 where nested_with is null;

cursor c8 is
select l.event_id,
       (l.end_date-l.start_date+1)*case when l.course_code = '2413C' then 1500  /** Alison Email 9/5 **/
                                        when l.ops_country = 'CANADA' and cd.course_pl in ('MICROSOFT','MICROSOFT APPS') and cd.course_type = 'MS Office' then 400
                                        when ir.daily_rate is not null then ir.daily_rate
                                        when dr.max_daily_rate is not null then dr.max_daily_rate
                                        else cr.rate
                                   end event_rate,
       cr.rate_plan,
       cr.rate,
       dr.max_daily_rate,
       ir.daily_rate
  from gk_inst_localization l
       inner join course_dim cd on l.course_id = cd.course_id and l.ops_country = cd.country
       inner join gk_inst_course_rate_mv cr on l.course_id = cr.evxcourseid and l.instructor_id = cr.instructor_id
                                          and l.start_date between cr.start_date and cr.end_date
       left outer join gk_inst_max_daily_rate dr on l.course_code = dr.course_code and l.ops_country = 'USA'
       left outer join gk_can_course_rate ir on l.course_code = ir.course_code and l.ops_country = 'CANADA'
 where nested_with is null
   and l.end_date >= trunc(sysdate);

cursor c8_i is
select event_id,(l.end_date-l.start_date+1)*case when l.course_code = '2413C' then 1500 else int_inst_rate end inst_cost
  from gk_inst_localization l
       inner join gk_int_inst_rate_pl r on l.pl_num = r.pl_num and l.inst_type = 'Internal'
 where l.end_date >= trunc(sysdate);

cursor c9 is
select l.event_id,(l.end_date-l.start_date+1)*
       (case when l.course_code = '2413C' then 1500  /** Alison Email 9/5 **/
             when l.ops_country = 'CANADA' and cd.course_pl in ('MICROSOFT','MICROSOFT APPS') and cd.course_type = 'MS Office' then 400
             when ir.daily_rate is not null then ir.daily_rate
             when dr.max_daily_rate is not null then dr.max_daily_rate
             when l.course_pl = 'CLOUDERA' then 1050
             else trunc(avg(cr.rate))
       end) event_rate
  from gk_inst_localization l
       inner join gk_inst_course_rate_mv cr on l.course_id = cr.evxcourseid and l.start_date between cr.start_date and cr.end_date
       inner join course_dim cd on l.course_id = cd.course_id and l.ops_country = cd.country
       left outer join gk_inst_max_daily_rate dr on l.course_code = dr.course_code and l.ops_country = 'USA'
       left outer join gk_can_course_rate ir on l.course_code = ir.course_code and l.ops_country = 'CANADA'
 where l.end_date >= trunc(sysdate)
   and l.nested_with is null
 group by l.ops_country,l.course_code,cd.course_pl,cd.course_type,l.event_id,l.end_date-l.start_date+1,max_daily_rate,ir.daily_rate,l.course_pl;

cursor c9_can is
select l.event_id,(l.end_date-l.start_date+1)*
       case when cd.course_pl in ('MICROSOFT','MICROSOFT APPS') and cd.course_type = 'MS Office' then 400 
            when l.course_code = '2413C' then 1500 
            else daily_rate 
       end event_rate
  from gk_inst_localization l
       inner join course_dim cd on l.course_id = cd.course_id and cd.country = 'CANADA'
       inner join gk_can_course_rate cr on l.course_code = cr.course_code
 where l.ops_country = 'CANADA'
   and l.end_date >= trunc(sysdate)
   and l.nested_with is null
   and cancelled_date is null;

cursor c10 is
select l.event_id nested_event,l2.event_id master_event
  from gk_inst_localization l
       inner join gk_nested_courses nc on l.course_code = nc.nested_course_code
       inner join gk_inst_localization l2 on nc.master_course_code = l2.course_code
                                         and l.location_id = l2.location_id
                                         and l.start_date between l2.start_date and l2.end_date
 where l.end_date >= trunc(sysdate);

cursor c11 is
select l.event_id,facility_region_metro,
       (end_date-start_date+1)*avg_hotel_day hotel_cost,
       case when nvl(metro_level,0) != 2 then avg_airfare else 0 end avg_airfare,
       (end_date-start_date+1)*avg_rental rental_cost
  from gk_inst_localization l
       left outer join gk_inst_hotel_rate_v h on l.facility_region_metro = h.metroarea
       left outer join gk_inst_airfare_v a on l.facility_region_metro = a.metroarea
       left outer join gk_inst_rental_rate_v r on l.facility_region_metro = r.metroarea
 where nvl(metro_level,0) != 1
   and l.end_date >= trunc(sysdate)
   and nested_with is null;

cursor c12 is
select l.event_id,
       l.enroll_cnt*c.cw_per_stud cw_cost,
       l.enroll_cnt*cs.avg_shipping cw_shipping_cost
  from gk_inst_localization l
       inner join gk_student_cw_v c on l.course_code = c.coursecode and substr(l.ops_country,1,3) = substr(c.country,1,3)
       left outer join gk_student_cw_shipping_v cs on l.course_code = cs.coursecode and l.facility_region_metro = cs.facilityregionmetro
 where l.end_date >= trunc(sysdate);

cursor c12_1 is
select l.event_id,round(l.enroll_cnt*sum(total_shipping)/sum(total_shipped),2) cw_shipping_cost
  from gk_inst_localization l
       inner join gk_student_cw_shipping_v s on l.facility_region_metro = s.facilityregionmetro
 where cw_shipping_cost is null
   and l.end_date >= trunc(sysdate)
 group by l.event_id,l.enroll_cnt;

cursor c13 is
select l.event_id,
       f.freight_avg
  from gk_inst_localization l
       inner join gk_event_freight_v f on l.course_code = f.coursecode and l.facility_region_metro = f.facilityregionmetro
 where nested_with is null
   and l.end_date >= trunc(sysdate)
   and md_num = '10';

cursor c13_1 is
select l.event_id,round(sum(freight_total)/sum(event_cnt),2) freight_avg
  from gk_inst_localization l
       inner join gk_event_freight_v f on l.course_code = f.coursecode
 where l.freight_cost is null
   and l.end_date >= trunc(sysdate)
   and nested_with is null
   and md_num = '10'
 group by l.event_id;

cursor c14 is
select l.event_id,
       l.enroll_cnt*v.voucher_cost voucher_event_cost
  from gk_inst_localization l
       inner join gk_course_voucher_v v on l.course_code = v.course_code
 where l.end_date >= trunc(sysdate);

cursor c15 is
select l.event_id,l.course_code,m.roy_amt cdw_cost
  from gk_inst_localization l
       inner join gk_cdw_monthly_v m on l.event_id = m.event_id
 where l.end_date >= trunc(sysdate);

cursor c16 is
select l.event_id,
       case when l.facility_region_metro = 'CAL' then (l.end_date-l.start_date+1)*450
            else ((l.end_date-l.start_date+1)*fu.facility_daily_fee)+
                 nvl(((l.end_date-l.start_date+1)*fa.facility_daily_fee),0)+
                 nvl(((l.end_date-l.start_date+1)*ff.fac_fb_per_stud*l.enroll_cnt),0)+
                 case when substr(l.course_code,1,4) in ('5952','5951') then (l.end_date-l.start_date+1)*400 else 0 end 
       end facility_cost
  from gk_inst_localization l
       inner join event_dim ed on l.event_id = ed.event_id and ed.internalfacility = 'F'
       inner join gk_facility_usage_v fu on l.facility_code = fu.facility_code
       left outer join gk_facility_av_v fa on l.facility_code = fa.facility_code
       left outer join gk_facility_fb_v ff on l.facility_code = ff.facility_code
 where md_num = '10'
   and l.end_date >= trunc(sysdate)
   and nested_with is null
union
select l.event_id,
       case when l.facility_region_metro = 'CAL' then (l.end_date-l.start_date+1)*450
            else ((l.end_date-l.start_date+1)*avg(fu.facility_daily_fee))+
                 nvl(((l.end_date-l.start_date+1)*avg(fa.facility_daily_fee)),0)+
                 nvl(((l.end_date-l.start_date+1)*avg(ff.fac_fb_per_stud)*l.enroll_cnt),0)+
                 case when substr(l.course_code,1,4) in ('5952','5951') then (l.end_date-l.start_date+1)*400 else 0 end 
       end facility_cost
  from gk_inst_localization l
       inner join event_dim ed on l.event_id = ed.event_id and ed.internalfacility = 'F'
       inner join gk_facility_usage_v fu on l.facility_region_metro = fu.facility_region_metro
       left outer join gk_facility_av_v fa on l.facility_region_metro = fa.facility_region_metro
       left outer join gk_facility_fb_v ff on l.facility_region_metro = ff.facility_region_metro
 where md_num = '10'
   and l.end_date >= trunc(sysdate)
   and facility_region_metro != 'ONS'
   and not exists (select 1 from gk_facility_usage_v fu2 where l.facility_code = fu2.facility_code)
   and nested_with is null
 group by l.event_id,l.end_date,l.start_date,l.enroll_cnt,l.course_code,l.facility_code;

cursor c17 is
select event_id,sum(event_cost) event_cost
  from (
        select ed.event_id,sum(avg_hotel_day*(ed.end_date-ed.start_date+1)) event_cost
          from order_fact f
               inner join event_dim ed on f.event_id = ed.event_id
               inner join gk_inst_localization l on ed.event_id = l.event_id
               inner join gk_inst_hotel_rate_v h on ed.facility_region_metro = h.metroarea
         where l.end_date >= trunc(sysdate)
           and f.enroll_status in ('Confirmed','Attended')
           and f.keycode = 'HOTEL'
         group by ed.event_id
       union
       select l.event_id,
              sum(case when f.source = 'USAMX' then 260
                       when f.source = 'CAAMX' then 261.5
                        end) event_cost
         from order_fact f
              inner join gk_inst_localization l on f.event_id = l.event_id
        where l.end_date >= trunc(sysdate)
          and f.enroll_status in ('Confirmed','Attended')
          and f.source in ('CAAMX','USAMX')
        group by l.event_id
       union
       select l.event_id,
              count(f.enroll_id)*500 event_cost
         from order_fact f
              inner join gk_inst_localization l on f.event_id = l.event_id
        where l.end_date >= trunc(sysdate)
          and f.enroll_status in ('Confirmed','Attended')
          and f.source = 'DDDI'
        group by l.event_id
       union  /** IPAD PROMO COST **/
       select l.event_id,
              count(f.enroll_id)*520 event_cost
         from order_fact f
              inner join gk_inst_localization l on f.event_id = l.event_id
        where l.end_date >= trunc(sysdate)
          and f.enroll_status in ('Confirmed','Attended')
          and f.keycode = 'IPAD2012P'
        group by l.event_id
       union  /** IPADMINI PROMO COST **/
       select l.event_id,
              count(f.enroll_id)*336.45 event_cost
         from order_fact f
              inner join gk_inst_localization l on f.event_id = l.event_id
        where l.end_date >= trunc(sysdate)
          and f.enroll_status in ('Confirmed','Attended')
          and f.keycode = 'IPADMINI2013'
        group by l.event_id)
 group by event_id;


cursor c18 is
select l2.event_id,
       case when b.second_course is not null then 0 else nvl(l2.freight_cost,0) end freight_cost
  from gk_inst_localization l1
       inner join gk_inst_localization l2 on l1.end_date+1 = l2.start_date
                                          and l1.instructor_id = l2.instructor_id
                                          and l1.location_id = l2.location_id
       left outer join gk_back_to_back_courses b on l1.course_code = b.first_course and l2.course_code = b.second_course
 where l2.nested_with is null
   and l1.end_date >= trunc(sysdate)
   and l1.md_num = '10';

cursor c19 is
select event_id,(enroll_cnt*exam_fee)+proctor_fee proctor_exam_fee
  from gk_inst_localization l
       inner join gk_itil_course c on l.course_code = c.course_code
 where l.end_date >= trunc(sysdate);

cursor c20 is
select il.event_id,il.rev_amt,il.enroll_cnt,
       sum(case when mc.type = 'CD Pct of Revenue' then il.rev_amt*mc.cw_cost else 0 end +
           case when mc.type = 'CD Per Student' then il.enroll_cnt*mc.cw_cost else 0 end +
           case when mc.type = 'Per Event' then mc.cw_cost else 0 end +
           case when mc.type = 'Per Student' then il.enroll_cnt*mc.cw_cost else 0 end +
           case when mc.type = 'Per Student after Min' and il.enroll_cnt >= nvl(min_cnt,-1) then (il.enroll_cnt-min_cnt+1)*mc.cw_cost else 0 end +
           case when mc.type = 'Per Student and 2 Pct' then (il.enroll_cnt*mc.cw_cost)+(il.rev_amt*.02) else 0 end
          ) misc_cw_cost
  from gk_inst_localization il
       inner join gk_misc_cw_temp mc on substr(il.course_code,1,4) = mc.course_code
 where il.ch_num in ('10')
   and il.end_date >= trunc(sysdate)
   and (il.md_num = '10' or (il.md_num = '20' and il.ops_country = 'USA'))
--   and il.md_num in ('10','20')
group by il.event_id,il.rev_amt,il.enroll_cnt
having sum(case when mc.type = 'CD Pct of Revenue' then il.rev_amt*mc.cw_cost else 0 end +
           case when mc.type = 'CD Per Student' then il.enroll_cnt*mc.cw_cost else 0 end +
           case when mc.type = 'Per Event' then mc.cw_cost else 0 end +
           case when mc.type = 'Per Student' then il.enroll_cnt*mc.cw_cost else 0 end +
           case when mc.type = 'Per Student after Min' and il.enroll_cnt >= nvl(min_cnt,-1) then (il.enroll_cnt-min_cnt+1)*mc.cw_cost else 0 end +
           case when mc.type = 'Per Student and 2 Pct' then (il.enroll_cnt*mc.cw_cost)+(il.rev_amt*.02) else 0 end
          ) > 0
union  /** CLC MISC CW **/
select distinct i.event_id,i.rev_amt,i.enroll_cnt,
       case when i.enroll_cnt*q.cost_per_stud > 1750 then 1750
            else i.enroll_cnt*q.cost_per_stud
       end misc_cw
from (
select dim_year,dim_week,sum(enroll_cnt) enroll_cnt,
       round(case when sum(enroll_cnt) <= 26 then 1750/sum(enroll_cnt)
            else (1750/26)
       end) cost_per_stud
from (
select td.dim_year,td.dim_week,cd.ch_num,ed.capacity,
       count(distinct f.enroll_id) enroll_cnt
  from event_dim ed
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled'
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td on ed.start_date = td.dim_date
 where ed.start_date >= trunc(sysdate)
   and substr(cd.course_code,1,4) in ('0692','0691','0690','0697','0698','0699','0902','0925','0921','0911','0630','0629','0628')
   and cd.ch_num = '10'
 group by td.dim_year,td.dim_week,cd.ch_num,ed.capacity
union
select td.dim_year,td.dim_week,cd.ch_num,ed.capacity,
       ed.capacity enroll_cnt
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td on ed.start_date = td.dim_date
 where ed.start_date >= trunc(sysdate)
   and substr(cd.course_code,1,4) in ('0692','0691','0690','0697','0698','0699','0902','0925','0921','0911','0630','0629','0628')
   and cd.ch_num = '20'
 group by td.dim_year,td.dim_week,cd.ch_num,ed.capacity
)
group by dim_year,dim_week
having sum(enroll_cnt) > 0
) q
inner join gk_inst_localization i on q.dim_year||'-'||lpad(q.dim_week,2,'0') = i.start_week
                            and substr(i.course_code,1,4) in ('0692','0691','0690','0697','0698','0699','0902','0925','0921','0911','0630','0629','0628')
where i.enroll_cnt > 0
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       ((i.end_date-i.start_date+1)*i.enroll_cnt*125)+(100*i.enroll_cnt) misc_cw_cost
  from gk_inst_localization i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where enroll_cnt > 0
   and i.end_date >= trunc(sysdate)
   and cd.course_pl = 'CLOUDERA'
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       3000 misc_cw_cost
  from gk_inst_localization i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where enroll_cnt > 0
   and i.end_date >= trunc(sysdate)
   and cd.course_pl = 'CITRIX'
union  /** APPCELERATOR COURSE FEES **/
select q.event_id,i.rev_amt,i.enroll_cnt,
       sum(case when enroll_order <= 10 then book_amt*.2 else book_amt*.5 end) cw_misc_cost
  from (
select ed.event_id,f.book_amt,
       rank() over (partition by ed.event_id order by f.book_date asc) enroll_order
  from event_dim ed 
       inner join order_fact f on ed.event_id = f.event_id
 where ed.course_code in ('0475C','0476C','0477C')
   and ed.status != 'Cancelled'
   and f.enroll_status != 'Cancelled'
) q
inner join gk_inst_localization i on q.event_id = i.event_id
 where i.enroll_cnt > 0
   and i.end_date >= trunc(sysdate)
group by q.event_id,i.rev_amt,i.enroll_cnt;

cursor c21 is
select l.event_id,ed.start_date new_start_date,start_week,td.dim_year||'-'||lpad(td.dim_week,2,'0') new_start_week,
       ed.end_date
  from gk_inst_localization l
       inner join event_dim ed on l.event_id = ed.event_id
       inner join time_dim td on ed.start_date = td.dim_date
 where (l.start_date <> ed.start_date
    or l.end_date <> ed.end_date
    or l.start_week != td.dim_year||'-'||lpad(td.dim_week,2,'0'))
   and l.end_date >= trunc(sysdate);

--cursor c22 is
--select event_id,enroll_cnt,end_date-start_date+1 event_length,
--       enroll_cnt*(end_date-start_date+1)*60 misc_cw_cost
--  from gk_inst_localization
-- where end_date >= trunc(sysdate)
--   and pl_num = '06'
--   and enroll_cnt*(end_date-start_date+1)*60 > 0;

cursor c23 is
  select l.event_id,l.rev_amt -
         sum(case when ep.appliedamount > f.book_amt then f.book_amt
              else nvl(ep.appliedamount,0)
             end) amt_due_remain
    from gk_inst_localization l
         inner join order_fact f on l.event_id = f.event_id
         left outer join slxdw.evxpmtapplied ep on f.enroll_id = ep.evxevenrollid
   where f.enroll_status != 'Cancelled'
     and l.end_date >= trunc(sysdate)
   group by l.event_id,l.rev_amt;
   
cursor c24 is
  select l.event_id connected_event,l2.event_id master_event
    from gk_inst_localization l
         inner join "connected_events"@rms_prod c on l.event_id = c."child_evxeventid"
         inner join gk_inst_localization l2 on c."parent_evxeventid" = l2.event_id
   where l.end_date >= trunc(sysdate);
   
cursor c25 is /** REMOTE LAB RENTAL **/
select i.event_id,i.rev_amt,i.enroll_cnt,
       case when i.enroll_cnt <= 8 then 1175 else 1825 end lab_rental
  from gk_inst_localization i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where i.end_date >= trunc(sysdate)
   and cd.course_code = '3136C';
   
cursor c26 is  /** SALES COMMISSION **/
select i.event_id,i.rev_amt,i.enroll_cnt,
       round(i.rev_amt*.05,2) comm_amt
  from gk_inst_localization i
 where i.end_date >= trunc(sysdate);


avail_events varchar2(1) := 'Y';
pweek varchar2(30);
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;

begin
rms_link_set_proc;

update gk_inst_localization
   set cancelled_date = null
 where event_id in (
       select l.event_id
         from gk_inst_localization l
              inner join event_dim ed on l.event_id = ed.event_id
        where l.cancelled_date is not null
          and ed.status != 'Cancelled');

update gk_inst_localization
   set cancelled_date = trunc(sysdate)
 where event_id in
      (select l.event_id
         from gk_inst_localization l
              inner join event_dim ed on l.event_id = ed.event_id
        where ed.status = 'Cancelled');

insert into gk_inst_localization
(start_week,event_id,course_id,location_id,start_date,end_date,event_city,event_state,event_zipcode,
 facility_region_metro,facility_code,ops_country,course_code,course_ch,course_mod,course_pl,ch_num,
 md_num,pl_num,short_name,rev_amt,enroll_cnt,unlimited_cnt,nex_enroll_cnt,gk_enroll_cnt)
select td.dim_year||'-'||lpad(td.dim_week,2,'0') start_week,
       ed.event_id,ed.course_id,ed.location_id,ed.start_date,ed.end_date,ed.city event_city,
       ed.state event_state,ed.zipcode event_zipcode,
       ed.facility_region_metro,ed.facility_code,ed.ops_country,cd.course_code,
       cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.short_name,
       sum(nvl(book_amt,0)) rev_amt,sum(case when f.enroll_id is not null then 1 else 0 end) enroll_cnt,
       0,
       sum(case when f.enroll_id is not null and upper(f.source) = 'NEXIENT' then 1 else 0 end) nex_enroll_cnt,
       sum(case when f.enroll_id is not null and upper(nvl(f.source,'GK')) != 'NEXIENT' then 1 else 0 end) gk_enroll_cnt
from event_dim ed
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     inner join time_dim td on ed.start_date = td.dim_date
     left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled'
where td.dim_date between trunc(sysdate) and trunc(sysdate)+120
and ed.status != 'Cancelled'
and cd.ch_num = '10'
and cd.md_num in ('10','20')
and cd.pl_num != '01'
and not exists (select 1 from gk_inst_localization l where ed.event_id = l.event_id)
--and not exists (select 1 from gk_nested_courses nc where nc.nested_course_code = cd.course_code)
group by td.dim_year||'-'||lpad(td.dim_week,2,'0'),
         ed.event_id,ed.course_id,ed.location_id,ed.start_date,ed.end_date,ed.city,
         ed.state,ed.zipcode,ed.facility_region_metro,ed.facility_code,ed.ops_country,cd.course_code,
         cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.short_name,ed.ops_country
order by facility_region_metro,facility_code,course_pl;

for r0 in c0 loop
  update gk_inst_localization
     set rev_amt = r0.rev_amt,
         enroll_cnt = r0.enroll_cnt,
         nex_enroll_cnt = r0.nex_enroll_cnt,
         gk_enroll_cnt = r0.gk_enroll_cnt
   where event_id = r0.event_id;
end loop;

for r0_u in c0_u loop
  update gk_inst_localization
     set unlimited_cnt = r0_u.unlimited_cnt
   where event_id = r0_u.event_id;
end loop;

for r0_l in c0_l loop
  update gk_inst_localization
     set lock_promo_cnt = r0_l.lock_promo_cnt
   where event_id = r0_l.event_id;
end loop;

for r0_6 in c0_6 loop
  update gk_inst_localization
     set rev_6_weeks_out = r0_6.rev_amt
   where event_id = r0_6.event_id;
end loop;

for r0_loc in c0_loc loop
  update gk_inst_localization
     set location_id = r0_loc.location_id,
         event_city = r0_loc.city,
         event_state = r0_loc.state,
         event_zipcode = r0_loc.zipcode,
         facility_region_metro = r0_loc.facility_region_metro,
         facility_code = r0_loc.facility_code,
         course_code = r0_loc.course_code,
         course_ch = r0_loc.course_ch,
         course_mod = r0_loc.course_mod,
         course_pl = r0_loc.course_pl,
         ch_num = r0_loc.ch_num,
         md_num = r0_loc.md_num,
         pl_num = r0_loc.pl_num,
         short_name = r0_loc.short_name
   where event_id = r0_loc.event_id;
end loop;

for r10 in c10 loop
  update gk_inst_localization
     set nested_with = r10.master_event
   where event_id = r10.nested_event;
end loop;

update gk_inst_localization
   set connected_to = null,
       connected_event = null;

for r24 in c24 loop
  update gk_inst_localization
     set connected_to = r24.master_event
   where event_id = r24.connected_event;
   
  update gk_inst_localization
     set connected_event = 'Y'
   where event_id = r24.master_event;
end loop;

for r21 in c21 loop
  update gk_inst_localization
     set start_date = r21.new_start_date,
         end_date = r21.end_date,
         start_week = r21.new_start_week
   where event_id = r21.event_id;
end loop;

update gk_inst_localization
  set instructor_id = null,
      metro_level = null,
      inst_name = null,
      inst_city = null,
      inst_state = null,
      inst_zipcode = null,
      assigned_by = null,
      inst_cost = null,
      hotel_cost = null,
      airfare_cost = null,
      rental_cost = null,
      cw_cost = null,
      cw_shipping_cost = null,
      freight_cost = null,
      voucher_cost = null,
      cdw_cost = null,
      facility_cost = null,
      hotel_promo_cost = null,
      proctor_exam_cost = null,
      misc_cw_cost = null
where end_date >= trunc(sysdate);

commit;

for r6 in c6 loop
  update gk_inst_localization
     set instructor_id = r6.contactid,
         metro_level = r6.metro_level,
         inst_name = r6.ins_name,
         inst_city = r6.ins_city,
         inst_state = r6.ins_state,
         inst_zipcode = r6.ins_zipcode,
         assigned_by = r6.assigned_by,
         inst_type = r6.inst_type
   where event_id = r6.event_id;
end loop;
commit;

for r8 in c8 loop
  update gk_inst_localization
     set inst_cost = r8.event_rate,
         rate_plan = r8.rate_plan,
         max_daily_rate = r8.max_daily_rate
   where event_id = r8.event_id;
end loop;

for r8_i in c8_i loop
  update gk_inst_localization
     set inst_cost = r8_i.inst_cost,
         rate_plan = 'Internal'
 where event_id = r8_i.event_id;
end loop;

for r9 in c9 loop
  update gk_inst_localization
     set inst_cost = r9.event_rate
   where event_id = r9.event_id;
end loop;

for r9 in c9_can loop
  update gk_inst_localization
     set inst_cost = r9.event_rate
   where event_id = r9.event_id;
end loop;


update gk_inst_localization
   set hotel_cost = 0,
       airfare_cost = 0,
       rental_cost = 0
 where end_date >= trunc(sysdate)
   and metro_level = 1
   and nested_with is null;

for r11 in c11 loop
  update gk_inst_localization
     set hotel_cost = r11.hotel_cost,
         airfare_cost = r11.avg_airfare,
         rental_cost = r11.rental_cost
   where event_id = r11.event_id;
end loop;

update gk_inst_localization
   set hotel_cost = 0,
       airfare_cost = 0,
       rental_cost = 0
 where end_date >= trunc(sysdate)
   and md_num = '20';

update gk_inst_localization
   set hotel_cost = 0,
       airfare_cost = 0,
       rental_cost = 0
 where end_date >= trunc(sysdate)
   and course_code in (
       '8230C','8231C','8232C','8233C','8601C','8602C','8603C','8606C','8607C','8609C','8610C','8612C','8625C','8627C','8628C','8629C',
       '8630C','8631C','8632C','8633C','8635C','8636C','8651C','8652C','8654C','8655C','8656C','8657C','8658C','8659C','8660C','8661C',
       '8662C','8663C','8664C','8665C','8675C','8676C','8677C','8682C','8684C','8685C','8686C','8687C','8688C','8689C','8690C','8691C',
       '8701C','8703C','8704C','8707C','8708C','8715C','8716C','8717C','8718C','8719C','8720C','8721C','8732C','8733C','8734C','8735C',
       '8740C','8741C','8746C','8751C','8752C','8753C','8754C','8755C','8756C','8757C','8758C','8759C','8760C','8761C','8762C','8763C',
       '8764C','8766C','8767C','8768C','8769C','8773C','8774C','8775C','8813C','8814C','8815C','8816C','8822C'
       );

for r12 in c12 loop
  update gk_inst_localization
     set cw_cost = r12.cw_cost,
         cw_shipping_cost = r12.cw_shipping_cost
   where event_id = r12.event_id;
end loop;

for r12_1 in c12_1 loop
  update gk_inst_localization
     set cw_shipping_cost = r12_1.cw_shipping_cost
   where event_id = r12_1.event_id;
end loop;

for r13 in c13 loop
  update gk_inst_localization
     set freight_cost = r13.freight_avg
   where event_id = r13.event_id;
end loop;


for r13_1 in c13_1 loop
  update gk_inst_localization
     set freight_cost = r13_1.freight_avg
   where event_id = r13_1.event_id;
end loop;

for r14 in c14 loop
  update gk_inst_localization
     set voucher_cost = r14.voucher_event_cost
   where event_id = r14.event_id;
end loop;

for r15 in c15 loop
  update gk_inst_localization
     set cdw_cost = r15.cdw_cost
   where event_id = r15.event_id;
end loop;

for r16 in c16 loop
  update gk_inst_localization
     set facility_cost = r16.facility_cost
   where event_id = r16.event_id;
end loop;

for r17 in c17 loop
  update gk_inst_localization
     set hotel_promo_cost = r17.event_cost
   where event_id = r17.event_id;
end loop;

for r18 in c18 loop
  update gk_inst_localization
     set airfare_cost = 0,
         freight_cost = r18.freight_cost
   where event_id = r18.event_id;
end loop;


for r19 in c19 loop
  update gk_inst_localization
     set proctor_exam_cost = r19.proctor_exam_fee
   where event_id = r19.event_id;
end loop;

for r20 in c20 loop
  update gk_inst_localization
     set misc_cw_cost = r20.misc_cw_cost
   where event_id = r20.event_id;
end loop;

--for r22 in c22 loop
--  update gk_inst_localization
--     set misc_cw_cost = nvl(misc_cw_cost,0) + r22.misc_cw_cost
--   where event_id = r22.event_id;
--end loop;

for r23 in c23 loop
  update gk_inst_localization
     set amt_due_remain = r23.amt_due_remain
   where event_id = r23.event_id;
end loop;

for r25 in c25 loop
  update gk_inst_localization
     set lab_rental = r25.lab_rental
   where event_id = r25.event_id;
end loop;

for r26 in c26 loop
  update gk_inst_localization
     set sales_comm = r26.comm_amt
   where event_id = r26.event_id;
end loop;

update gk_inst_localization
   set total_cost = nvl(inst_cost,0)+
       nvl(hotel_cost,0)+nvl(airfare_cost,0)+nvl(rental_cost,0)+
       nvl(cw_cost,0)+nvl(cw_shipping_cost,0)+nvl(misc_cw_cost,0)+
       nvl(freight_cost,0)+
       nvl(voucher_cost,0)+
       nvl(cdw_cost,0)+
       round(nvl(facility_cost,0),2)+
       nvl(hotel_promo_cost,0)+
       nvl(proctor_exam_cost,0)+
       nvl(lab_rental,0)+
       nvl(sales_comm,0);

commit;

update gk_inst_localization
   set margin = case when rev_amt = 0 then 0 else (rev_amt-total_cost)/rev_amt end;

commit;

dbms_snapshot.refresh('gkdw.gk_course_to_watch_mv');

end;
/


