DROP PROCEDURE GKDW.GK_GO_NOGO_PROC_TEST;

CREATE OR REPLACE PROCEDURE GKDW.gk_go_nogo_proc_test as

cursor c0 is
  select l.event_id,sum(nvl(book_amt,0)) rev_amt,
         sum(case when f.enroll_id is not null and f.book_amt > 0 then 1 else 0 end) enroll_cnt,
         sum(case when f.enroll_id is not null and f.book_amt = 0 and f.keycode <> 'ALLACCESS' then 1 else 0 end) guest_cnt,
         sum(case when f.enroll_id is not null and f.book_amt = 0 and f.keycode = 'ALLACCESS' then 1 else 0 end) allaccess_cnt
    from gk_go_nogo l
         left outer join order_fact f on l.event_id = f.event_id and f.enroll_status != 'Cancelled'
   where l.end_date >= trunc(sysdate)
   group by l.event_id
  minus
  select event_id,rev_amt,enroll_cnt,guest_cnt,allaccess_cnt
    from gk_go_nogo;

cursor c0_6 is
  select l.event_id,sum(f.book_amt) rev_amt
    from gk_go_nogo l
         inner join order_fact f on l.event_id = f.event_id and f.book_date <= start_date-42
   where l.end_date >= trunc(sysdate)
   group by l.event_id;

cursor c0_loc is
  select ed.event_id,ed.location_id,ed.city,ed.state,ed.zipcode,ed.facility_region_metro,ed.facility_code,
         cd.course_code,cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.short_name
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
         inner join gk_go_nogo l on ed.event_id = l.event_id
   where ed.end_date >= trunc(sysdate)
  minus
  select event_id,location_id,event_city,event_state,event_zipcode,facility_region_metro,facility_code,
         course_code,course_ch,course_mod,course_pl,ch_num,md_num,pl_num,short_name
    from gk_go_nogo l;
    
cursor c10 is
select l.event_id nested_event,l2.event_id master_event
  from gk_go_nogo l
       inner join gk_nested_courses nc on l.course_code = nc.nested_course_code
       inner join gk_go_nogo l2 on nc.master_course_code = l2.course_code
                                         and l.location_id = l2.location_id
                                         and l.start_date between l2.start_date and l2.end_date
 where l.end_date >= trunc(sysdate);
 
cursor c24 is
  select l.event_id connected_event,l2.event_id master_event
    from gk_go_nogo l
         inner join "connected_events"@rms_prod c on l.event_id = c."child_evxeventid"
         inner join gk_go_nogo l2 on c."parent_evxeventid" = l2.event_id
   where l.end_date >= trunc(sysdate);

cursor c21 is
select l.event_id,ed.start_date new_start_date,start_week,td.dim_year||'-'||lpad(td.dim_week,2,'0') new_start_week,
       ed.end_date
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id
       inner join time_dim td on ed.start_date = td.dim_date
 where (l.start_date <> ed.start_date
    or l.end_date <> ed.end_date
    or l.start_week != td.dim_year||'-'||lpad(td.dim_week,2,'0'))
   and l.end_date >= trunc(sysdate);

cursor c6 is
select gil.event_id,ie.contactid,nvl(rim.metro_level,0) metro_level,
       upper(cd.first_name||' '||cd.last_name) ins_name,
       upper(city) ins_city,upper(state) ins_state,upper(zipcode) ins_zipcode,'RC' assigned_by,
       case when (cd.acct_name like 'GLOBAL KNOWLEDGE%' or cd.acct_name like 'NEXIENT%') then 'Internal' else 'External' end inst_type
  from gk_go_nogo  gil
       inner join instructor_event_v ie on ie.evxeventid = gil.event_id
       inner join rmsdw.rms_instructor ri on ie.contactid = ri.slx_contact_id
       inner join cust_dim cd on ie.contactid = cd.cust_id
       left outer join rmsdw.rms_instructor_metro rim on ri.rms_instructor_id = rim.rms_instructor_id
                                                     and rim.metro_code = gil.facility_region_metro
 where ie.feecode in ('SI','INS')
   and gil.end_date >= trunc(sysdate)
   and cancelled_date is null;

cursor c8 is
select l.event_id,
       (ed.meeting_days)*case when l.course_code = '2413C' then 1500  /** Alison Email 9/5 **/
                              when l.ops_country = 'CANADA' and cd.course_pl in ('MICROSOFT','MICROSOFT APPS') and cd.course_type = 'MS Office' then 400
                              when ir.daily_rate is not null then ir.daily_rate
                              when dr.max_daily_rate is not null then dr.max_daily_rate
                              else cr.rate
                         end event_rate,
       cr.rate_plan,
       cr.rate,
       dr.max_daily_rate,
       ir.daily_rate
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id
       inner join course_dim cd on l.course_id = cd.course_id and l.ops_country = cd.country
       inner join gk_inst_course_rate_mv cr on l.course_id = cr.evxcourseid and l.instructor_id = cr.instructor_id
                                          and l.start_date between cr.start_date and cr.end_date
       left outer join gk_inst_max_daily_rate dr on l.course_code = dr.course_code and l.ops_country = 'USA'
       left outer join gk_can_course_rate ir on l.course_code = ir.course_code and l.ops_country = 'CANADA'
 where nested_with is null
   and l.end_date >= trunc(sysdate);
   
cursor c8_i is
select event_id,(ed.meeting_days)*case when l.course_code = '2413C' then 1500 else int_inst_rate end inst_cost
  from gk_go_nogo l
       inner join gk_int_inst_rate_pl r on l.pl_num = r.pl_num and l.inst_type = 'Internal'
       inner join event_dim ed on l.event_id = ed.event_id
 where l.end_date >= trunc(sysdate);
 
cursor c9 is
select l.event_id,(ed.meeting_days)*
       (case when l.course_code = '2413C' then 1500  /** Alison Email 9/5 **/
             when l.ops_country = 'CANADA' and cd.course_pl in ('MICROSOFT','MICROSOFT APPS') and cd.course_type = 'MS Office' then 400
             when ir.daily_rate is not null then ir.daily_rate
             when dr.max_daily_rate is not null then dr.max_daily_rate
             when l.course_pl = 'CLOUDERA' then 1050
             else trunc(avg(cr.rate))
       end) event_rate
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id
       inner join gk_inst_course_rate_mv cr on l.course_id = cr.evxcourseid and l.start_date between cr.start_date and cr.end_date
       inner join course_dim cd on l.course_id = cd.course_id and l.ops_country = cd.country
       left outer join gk_inst_max_daily_rate dr on l.course_code = dr.course_code and l.ops_country = 'USA'
       left outer join gk_can_course_rate ir on l.course_code = ir.course_code and l.ops_country = 'CANADA'
 where l.end_date >= trunc(sysdate)
   and l.nested_with is null
   and l.inst_cost is null
 group by l.ops_country,l.course_code,cd.course_pl,cd.course_type,l.event_id,l.end_date-l.start_date+1,max_daily_rate,ir.daily_rate,l.course_pl,ed.meeting_days;

cursor c9_can is
select l.event_id,(ed.meeting_days)*
       case when cd.course_pl in ('MICROSOFT','MICROSOFT APPS') and cd.course_type = 'MS Office' then 400 
            when l.course_code = '2413C' then 1500 
            else daily_rate 
       end event_rate
  from gk_go_nogo l
       inner join course_dim cd on l.course_id = cd.course_id and cd.country = 'CANADA'
       inner join gk_can_course_rate cr on l.course_code = cr.course_code
       inner join event_dim ed on l.event_id = ed.event_id
 where l.ops_country = 'CANADA'
   and l.end_date >= trunc(sysdate)
   and l.nested_with is null
   and l.inst_cost is null
   and cancelled_date is null;

cursor c11 is
select l.event_id,facility_region_metro,
       (ed.meeting_days)*avg_hotel_day hotel_cost,
       case when nvl(metro_level,0) != 2 then avg_airfare else 0 end avg_airfare,
       (end_date-start_date+1)*avg_rental rental_cost
  from gk_go_nogo l
       left outer join gk_inst_hotel_rate_v h on l.facility_region_metro = h.metroarea
       left outer join gk_inst_airfare_v a on l.facility_region_metro = a.metroarea
       left outer join gk_inst_rental_rate_v r on l.facility_region_metro = r.metroarea
       inner join event_dim ed on l.event_id = ed.event_id
 where nvl(metro_level,0) != 1
   and l.end_date >= trunc(sysdate)
   and nested_with is null;

cursor c7(sdate number,edate number) is
select l.event_id,
       case when enroll_cnt < min_enroll_cnt then 'RED'
            when enroll_cnt between min_enroll_cnt and trunc(avg_fill_rate) then 'YELLOW'
            when enroll_cnt >= trunc(avg_fill_rate) then 'GREEN'
       end event_run_status
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id
       inner join gk_course_fill_std_v fs on ed.course_code = fs.course_code
                                         and ed.event_channel = fs.event_channel
                                         and ed.event_modality = fs.event_modality
                                         and ed.start_date-trunc(sysdate) between sdate and edate
 where nested_with is null;

cursor c12 is
select l.event_id,
       (l.enroll_cnt-l.allaccess_cnt)*c.cw_per_stud cw_cost,
       (l.enroll_cnt-l.allaccess_cnt)*cs.avg_shipping cw_shipping_cost
  from gk_go_nogo l
       inner join gk_student_cw_v c on l.course_code = c.coursecode and substr(l.ops_country,1,3) = substr(c.country,1,3)
       left outer join gk_student_cw_shipping_v cs on l.course_code = cs.coursecode and l.facility_region_metro = cs.facilityregionmetro
 where l.end_date >= trunc(sysdate);

cursor c12_1 is
select l.event_id,round((l.enroll_cnt-l.allaccess_cnt)*sum(total_shipping)/sum(total_shipped),2) cw_shipping_cost
  from gk_go_nogo l
       inner join gk_student_cw_shipping_v s on l.facility_region_metro = s.facilityregionmetro
 where cw_shipping_cost is null
   and l.end_date >= trunc(sysdate)
 group by l.event_id,l.enroll_cnt,l.allaccess_cnt;

cursor c13 is
select l.event_id,
       f.freight_avg
  from gk_go_nogo l
       inner join gk_event_freight_v f on l.course_code = f.coursecode and l.facility_region_metro = f.facilityregionmetro
 where nested_with is null
   and l.end_date >= trunc(sysdate)
   and md_num = '10';

cursor c13_1 is
select l.event_id,round(sum(freight_total)/sum(event_cnt),2) freight_avg
  from gk_go_nogo l
       inner join gk_event_freight_v f on l.course_code = f.coursecode
 where l.freight_cost is null
   and l.end_date >= trunc(sysdate)
   and nested_with is null
   and md_num = '10'
 group by l.event_id;

cursor c14 is
select l.event_id,
       (l.enroll_cnt-l.allaccess_cnt)*v.voucher_cost voucher_event_cost
  from gk_go_nogo l
       inner join gk_course_voucher_v v on l.course_code = v.course_code
 where l.end_date >= trunc(sysdate)
   and (l.enroll_cnt-l.allaccess_cnt)*v.voucher_cost > 0;

cursor c15 is
select l.event_id,l.course_code,sum(m.roy_amt) cdw_cost
  from gk_go_nogo l
       inner join gk_cdw_monthly_v m on l.event_id = m.event_id
 where l.end_date >= trunc(sysdate)
 group by l.event_id,l.course_code;

cursor c16 is
select l.event_id,
       case when fu.facility_daily_fee is null then 0
            else ((ed.meeting_days)*fu.facility_daily_fee)+
                 nvl(((ed.meeting_days)*fa.facility_daily_fee),0)+
                 nvl(((ed.meeting_days)*ff.fac_fb_per_stud*l.enroll_cnt),0)+
                 case when substr(l.course_code,1,4) in ('5952','5951') then (ed.meeting_days)*400 else 0 end 
       end facility_cost
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id and ed.internalfacility = 'F'
       left outer join gk_facility_usage_v fu on l.facility_code = fu.facility_code
       left outer join gk_facility_av_v fa on l.facility_code = fa.facility_code
       left outer join gk_facility_fb_v ff on l.facility_code = ff.facility_code
 where md_num = '10'
   and l.end_date >= trunc(sysdate)
   and l.facility_region_metro not in ('CAL','EDM','KIT','MSS','SJF','VAN','VIC')
   and nested_with is null
union
select l.event_id,
       case when fu.facility_daily_fee is null then 0
            else ((ed.meeting_days)*avg(fu.facility_daily_fee))+
                 nvl(((ed.meeting_days)*avg(fa.facility_daily_fee)),0)+
                 nvl(((ed.meeting_days)*avg(ff.fac_fb_per_stud)*l.enroll_cnt),0)+
                 case when substr(l.course_code,1,4) in ('5952','5951') then (ed.meeting_days)*400 else 0 end 
       end facility_cost
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id and ed.internalfacility = 'F'
       left outer join gk_facility_usage_v fu on l.facility_region_metro = fu.facility_region_metro
       left outer join gk_facility_av_v fa on l.facility_region_metro = fa.facility_region_metro
       left outer join gk_facility_fb_v ff on l.facility_region_metro = ff.facility_region_metro
 where md_num = '10'
   and l.end_date >= trunc(sysdate)
   and facility_region_metro not in ('ONS','CAL','EDM','KIT','MSS','SJF','VAN','VIC')
   and not exists (select 1 from gk_facility_usage_v fu2 where l.facility_code = fu2.facility_code)
   and nested_with is null
 group by l.event_id,l.facility_region_metro,l.end_date,l.start_date,l.enroll_cnt,l.course_code,l.facility_code,fu.facility_daily_fee, ed.meeting_days
union
select l.event_id,
      (l.end_date-l.start_date+1)*
      case when l.facility_region_metro = 'CAL' then 500
           when l.facility_region_metro = 'EDM' then 800
           when l.facility_region_metro = 'KIT' then 800
           when l.facility_region_metro = 'MSS' then 500
           when l.facility_region_metro = 'SJF' then 800
           when l.facility_region_metro = 'VAN' then 500
           when l.facility_region_metro = 'VIC' then 600
      end facility_cost
  from gk_go_nogo l
       inner join event_dim ed on l.event_id = ed.event_id
 where md_num = '10'
   and l.end_date >= trunc(sysdate)
   and l.facility_region_metro in ('CAL','EDM','KIT','MSS','SJF','VAN','VIC')
   and nested_with is null;

cursor c18 is
select l2.event_id,
       case when b.second_course is not null then 0 else nvl(l2.freight_cost,0) end freight_cost
  from gk_go_nogo l1
       inner join gk_go_nogo l2 on l1.end_date+1 = l2.start_date
                                          and l1.instructor_id = l2.instructor_id
                                          and l1.location_id = l2.location_id
       left outer join gk_back_to_back_courses b on l1.course_code = b.first_course and l2.course_code = b.second_course
 where l2.nested_with is null
   and l1.end_date >= trunc(sysdate)
   and l1.md_num = '10';

cursor c20 is
select event_id, rev_amt, enroll_cnt, sum(misc_cw_cost) misc_cw_cost from (
select il.event_id,il.rev_amt,il.enroll_cnt,
       sum(case when mc.cost_type = 'Per Event' then mc.cw_cost else 0 end +
           case when mc.cost_type = 'Per Student' then (il.enroll_cnt-il.allaccess_cnt)*mc.cw_cost else 0 end
          ) misc_cw_cost
  from gk_go_nogo il
       inner join gk_misc_cw_costs mc on substr(il.course_code,1,4) = mc.course_code
       where mc.course_mod is null
group by il.event_id,il.rev_amt,il.enroll_cnt
having sum(case when mc.cost_type = 'Per Event' then mc.cw_cost else 0 end +
           case when mc.cost_type = 'Per Student' then (il.enroll_cnt-il.allaccess_cnt)*mc.cw_cost else 0 end
          ) > 0
union
select il.event_id,il.rev_amt,il.enroll_cnt,
       sum(case when mc.cost_type = 'Per Event' then mc.cw_cost else 0 end +
           case when mc.cost_type = 'Per Student' then (il.enroll_cnt-il.allaccess_cnt)*mc.cw_cost else 0 end
          ) misc_cw_cost
  from gk_go_nogo il
       inner join gk_misc_cw_costs mc on substr(il.course_code,1,4) = mc.course_code and substr(il.course_code,5,1) = mc.course_mod
       where mc.course_mod is not null
group by il.event_id,il.rev_amt,il.enroll_cnt
having sum(case when mc.cost_type = 'Per Event' then mc.cw_cost else 0 end +
           case when mc.cost_type = 'Per Student' then (il.enroll_cnt-il.allaccess_cnt)*mc.cw_cost else 0 end
          ) > 0
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       ((ed.meeting_days)*(i.enroll_cnt-i.allaccess_cnt)*125) misc_cw_cost
  from gk_go_nogo i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
       inner join event_dim ed on i.event_id = ed.event_id
 where enroll_cnt > 0
   and cd.pl_num = '15' -- CLOUDERA
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       (cd.list_price*.15*((i.enroll_cnt-i.allaccess_cnt))) misc_cw_cost
  from gk_go_nogo i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where enroll_cnt > 0
   and cd.pl_num = '14' -- CITRIX
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       (((i.enroll_cnt-i.allaccess_cnt))*8) misc_cw_cost
  from gk_go_nogo i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where enroll_cnt > 0
   and cd.pl_num = '02' -- MICROSOFT
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       (ed.meeting_days*((i.enroll_cnt-i.allaccess_cnt))*100) misc_cw_cost
  from gk_go_nogo i
       inner join event_dim ed on i.event_id = ed.event_id
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where enroll_cnt > 0
   and cd.pl_num = '20' -- AMAZON WEB SERVICES
union
select i.event_id,i.rev_amt,i.enroll_cnt,
       (((i.enroll_cnt-i.allaccess_cnt))*5) misc_cw_cost
  from gk_go_nogo i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where enroll_cnt > 0
   and cd.pl_num = '17') -- MICROSOFT APPS
group by event_id, rev_amt, enroll_cnt; 

cursor c22 is
select l.event_id,l.enroll_cnt,ed.meeting_days event_length,
       ((l.enroll_cnt-l.allaccess_cnt))*(ed.meeting_days)*60 misc_cw_cost
  from gk_go_nogo l
  inner join event_dim ed on l.event_id = ed.event_id
  where l.end_date >= trunc(sysdate)
   and l.pl_num = '06'
   and (l.enroll_cnt-l.allaccess_cnt)*(ed.meeting_days)*60 > 0;

cursor c23 is
  select l.event_id,l.rev_amt -
         sum(case when ep.appliedamount > f.book_amt then f.book_amt
              else nvl(ep.appliedamount,0)
             end) amt_due_remain
    from gk_go_nogo l
         inner join order_fact f on l.event_id = f.event_id
         left outer join slxdw.evxpmtapplied ep on f.enroll_id = ep.evxevenrollid
   where f.enroll_status != 'Cancelled'
     and l.end_date >= trunc(sysdate)
   group by l.event_id,l.rev_amt;
   
   
cursor c25 is /** REMOTE LAB RENTAL **/
select i.event_id,i.rev_amt,i.enroll_cnt,
       case when (i.enroll_cnt-i.allaccess_cnt) <= 8 then 1175 else 1825 end lab_rental
  from gk_go_nogo i
       inner join course_dim cd on i.course_id = cd.course_id and i.ops_country = cd.country
 where i.end_date >= trunc(sysdate)
   and cd.course_code = '3136C';

cursor c27 is  /** IBM LAB RENTAL COST **/
select * 
  from gk_ibm_lab_cost;
  
cursor c32 is  /** NON-IBM LAB RENTAL COST **/
select * 
  from gk_lab_cost;

cursor c26 is  /** SALES COMMISSION **/
select i.event_id,i.rev_amt,i.enroll_cnt,
       round(i.rev_amt*.05,2) comm_amt
  from gk_go_nogo i
 where i.end_date >= trunc(sysdate);
    
cursor c28 is  /** CREDIT CARD FEE **/
select i.event_id, i.rev_amt
  from gk_go_nogo i
 where i.rev_amt > 0
 and i.end_date >= trunc(sysdate);
 
cursor c29 is  /** FOOD AND BEV **/
select i.event_id, i.enroll_cnt, i.start_date, ed.meeting_days
  from gk_go_nogo i LEFT JOIN event_dim ed
  ON i.event_id = ed.event_id
 where upper(ed.location_name) like '%GLOBAL KNOWLEDGE%'
 and i.enroll_cnt > 0
 and i.end_date >= trunc(sysdate);
 
cursor c30 is  /** PROMO COST **/
select event_id, sum(unit_price*enroll_cnt) promo_cost
  from gk_promo_enrollments_mv gpe
 group by event_id;
        
cursor c31 is  /** CD FEE **/
select i.event_id, 
       sum(case upper(cdf.payment_unit) when '% OF REVENUE' then trunc(i.rev_amt*cdf.fee_rate/100, 2)
                                    when 'PER STUDENT' then trunc(i.enroll_cnt*cdf.fee_rate,2)
                                    else 0
           end) fee_amt
  from gk_go_nogo i
       inner join gk_course_director_fees_mv cdf ON substr(i.course_code,1,4) = cdf.prod_code 
                                                and substr(i.course_code,5,1) = cdf.prod_mod 
                                                and i.start_date between cdf.from_date and cdf.to_date 
                                                and upper(fee_status) = 'ACTIVE'
 group by i.event_id
 having sum(case upper(cdf.payment_unit) when '% OF REVENUE' then trunc(i.rev_amt*cdf.fee_rate/100, 2)
                                    when 'PER STUDENT' then trunc(i.enroll_cnt*cdf.fee_rate,2)
                                    else 0
           end) > 0;


avail_events varchar2(1) := 'Y';
pweek varchar2(30);

begin
rms_link_set_proc;
--dbms_snapshot.refresh('gkdw.gk_promo_enrollments_mv');
--dbms_snapshot.refresh('gkdw.gk_course_director_fees_mv');
--dbms_output.put_line('test1');
--/**** UPDATE FOR ANY EVENT CANCELLATIONS ****/
--update gk_go_nogo
--   set cancelled_date = null
-- where event_id in (
--       select l.event_id
--         from gk_go_nogo l
--              inner join event_dim ed on l.event_id = ed.event_id
--        where l.cancelled_date is not null
--          and ed.status != 'Cancelled');
--
--update gk_go_nogo
--   set cancelled_date = trunc(sysdate)
-- where event_id in
--      (select l.event_id
--         from gk_go_nogo l
--              inner join event_dim ed on l.event_id = ed.event_id
--        where ed.status = 'Cancelled');
--
--/**** INSERT ALL NEW EVENTS INTO THE GO-NO GO TABLE ****/
--insert into gk_go_nogo
--(start_week,event_id,course_id,location_id,start_date,end_date,event_city,event_state,event_zipcode,
-- facility_region_metro,facility_code,ops_country,course_code,course_ch,course_mod,course_pl,ch_num,
-- md_num,pl_num,short_name,rev_amt,enroll_cnt,unlimited_cnt,nex_enroll_cnt,gk_enroll_cnt,guest_cnt,allaccess_cnt)
--select td.dim_year||'-'||lpad(td.dim_week,2,'0') start_week,
--       ed.event_id,ed.course_id,ed.location_id,ed.start_date,ed.end_date,ed.city event_city,
--       ed.state event_state,ed.zipcode event_zipcode,
--       ed.facility_region_metro,ed.facility_code,ed.ops_country,cd.course_code,
--       cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.short_name,
--       sum(nvl(book_amt,0)) rev_amt,sum(case when f.enroll_id is not null then 1 else 0 end) enroll_cnt,
--       0,
--       sum(case when f.enroll_id is not null and upper(f.source) = 'NEXIENT' then 1 else 0 end) nex_enroll_cnt,
--       sum(case when f.enroll_id is not null and upper(nvl(f.source,'GK')) != 'NEXIENT' then 1 else 0 end) gk_enroll_cnt,
--       sum(case when f.enroll_id is not null and f.book_amt = 0 and f.keycode <> 'ALLACCESS' then 1 else 0 end) guest_cnt,
--       sum(case when f.enroll_id is not null and f.book_amt = 0 and f.keycode = 'ALLACCESS' then 1 else 0 end) allaccess_cnt
--  from event_dim ed
--       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
--       inner join time_dim td on ed.start_date = td.dim_date
--       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled'
-- where td.dim_date between trunc(sysdate) and trunc(sysdate)+120
--   and ed.status != 'Cancelled'
--   and cd.ch_num = '10'
--   and cd.md_num in ('10','20')
--   and cd.pl_num != '01'
--   and not exists (select 1 from gk_go_nogo l where ed.event_id = l.event_id)
-- group by td.dim_year||'-'||lpad(td.dim_week,2,'0'),
--          ed.event_id,ed.course_id,ed.location_id,ed.start_date,ed.end_date,ed.city,
--          ed.state,ed.zipcode,ed.facility_region_metro,ed.facility_code,ed.ops_country,cd.course_code,
--          cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.short_name,ed.ops_country
-- order by facility_region_metro,facility_code,course_pl;
--
--/**** REVENUE AMOUNT UPDATES ****/
--for r0 in c0 loop
--  update gk_go_nogo
--     set rev_amt = r0.rev_amt,
--         enroll_cnt = r0.enroll_cnt,
--         gk_enroll_cnt = r0.enroll_cnt,
--         guest_cnt = r0.guest_cnt,
--         allaccess_cnt = r0.allaccess_cnt
--   where event_id = r0.event_id;
--end loop;

--dbms_output.put_line('test2');

--for r0_6 in c0_6 loop
--  update gk_go_nogo
--     set rev_6_weeks_out = r0_6.rev_amt
--   where event_id = r0_6.event_id;
--end loop;
--
--/**** EVENT LOCATION UPDATE ****/
--for r0_loc in c0_loc loop
--  update gk_go_nogo
--     set location_id = r0_loc.location_id,
--         event_city = r0_loc.city,
--         event_state = r0_loc.state,
--         event_zipcode = r0_loc.zipcode,
--         facility_region_metro = r0_loc.facility_region_metro,
--         facility_code = r0_loc.facility_code,
--         course_code = r0_loc.course_code,
--         course_ch = r0_loc.course_ch,
--         course_mod = r0_loc.course_mod,
--         course_pl = r0_loc.course_pl,
--         ch_num = r0_loc.ch_num,
--         md_num = r0_loc.md_num,
--         pl_num = r0_loc.pl_num,
--         short_name = r0_loc.short_name
--   where event_id = r0_loc.event_id;
--end loop;
--
--/**** NESTED EVENT UPDATE ****/
--for r10 in c10 loop
--  update gk_go_nogo
--     set nested_with = r10.master_event
--   where event_id = r10.nested_event;
--end loop;
--dbms_output.put_line('test3');
----/**** CONNECTED EVENT UPDATE ****/
--update gk_go_nogo
--   set connected_to = null,
--       connected_event = null;
--
--for r24 in c24 loop
--  update gk_go_nogo
--     set connected_to = r24.master_event
--   where event_id = r24.connected_event;
--   
--  update gk_go_nogo
--     set connected_event = 'Y'
--   where event_id = r24.master_event;
--end loop;
--
--/**** EVENT START AND END DATE UPDATES FOR ANY RESCHEDULED EVENTS ****/
--for r21 in c21 loop
--  update gk_go_nogo
--     set start_date = r21.new_start_date,
--         end_date = r21.end_date,
--         start_week = r21.new_start_week
--   where event_id = r21.event_id;
--end loop;
--
--/*** RESET INSTRUCTOR INFORMATION AND COST DATA FIELDS ****/
--update gk_go_nogo
--  set instructor_id = null,
--      metro_level = null,
--      inst_name = null,
--      inst_city = null,
--      inst_state = null,
--      inst_zipcode = null,
--      assigned_by = null,
--      inst_cost = null,
--      hotel_cost = null,
--      airfare_cost = null,
--      rental_cost = null,
--      cw_cost = null,
--      cw_shipping_cost = null,
--      freight_cost = null,
--      voucher_cost = null,
--      cdw_cost = null,
--      facility_cost = null,
--      hotel_promo_cost = null,
--      proctor_exam_cost = null,
--      misc_cw_cost = null,
--      food_and_bev = null,
--      credit_card_fee = null,
--      cd_fee = null
--where end_date >= trunc(sysdate);
--commit;
--
--/**** UPDATE INSTRUCTOR INFORMATION ****/
--for r6 in c6 loop
--  update gk_go_nogo
--     set instructor_id = r6.contactid,
--         metro_level = r6.metro_level,
--         inst_name = r6.ins_name,
--         inst_city = r6.ins_city,
--         inst_state = r6.ins_state,
--         inst_zipcode = r6.ins_zipcode,
--         assigned_by = r6.assigned_by,
--         inst_type = r6.inst_type
--   where event_id = r6.event_id;
--end loop;
--commit;
--
--/**** ASSIGN INSTRUCTOR COST FOR ASSIGNED INSTRUCTOR ****/
--for r8 in c8 loop
--  update gk_go_nogo
--     set inst_cost = r8.event_rate,
--         rate_plan = r8.rate_plan,
--         max_daily_rate = r8.max_daily_rate
--   where event_id = r8.event_id
--     and connected_to is null;
--end loop;
--
--/**** ASSIGN INTERNAL INSTRUCTOR RATE ****/
--for r8_i in c8_i loop
--  update gk_go_nogo
--     set inst_cost = r8_i.inst_cost,
--         rate_plan = 'Internal'
-- where event_id = r8_i.event_id
--   and connected_to is null;
--end loop;
--
--/**** ASSIGN AVERAGE RATE FOR COURSES THAT DO NOT HAVE AN INSTRUCTOR ASSIGNED ****/
--for r9 in c9 loop
--  update gk_go_nogo
--     set inst_cost = r9.event_rate
--   where event_id = r9.event_id
--     and connected_to is null;
--end loop;
--
--for r9 in c9_can loop
--  update gk_go_nogo
--     set inst_cost = r9.event_rate
--   where event_id = r9.event_id
--     and connected_to is null;
--end loop;

--dbms_output.put_line('test4');

/**** RESET INSTRUCTOR TRAVEL COSTS ****/
--update gk_go_nogo
--   set hotel_cost = 0,
--       airfare_cost = 0,
--       rental_cost = 0
-- where end_date >= trunc(sysdate)
--   and metro_level = 1
--   and nested_with is null;
--
--/**** ASSIGN INSTRUCTOR TRAVEL COSTS ****/
--for r11 in c11 loop
--  update gk_go_nogo
--     set hotel_cost = r11.hotel_cost,
--         airfare_cost = r11.avg_airfare,
--         rental_cost = r11.rental_cost
--   where event_id = r11.event_id;
--end loop;
--
--/**** NO TRAVEL COSTS FOR VIRTUAL CLASSES OR MS APPS CLASSES ****/
--update gk_go_nogo
--   set hotel_cost = 0,
--       airfare_cost = 0,
--       rental_cost = 0
-- where end_date >= trunc(sysdate)
--   and (md_num = '20' or pl_num = '17');
--
--/**** UPDATE COURSEWARE, SHIPPING, FREIGHT, VOUCHER COSTS FROM EVENT PORTAL ****/
--for r12 in c12 loop
--  update gk_go_nogo
--     set cw_cost = r12.cw_cost,
--         cw_shipping_cost = r12.cw_shipping_cost
--   where event_id = r12.event_id;
--end loop;
--
--for r12_1 in c12_1 loop
--  update gk_go_nogo
--     set cw_shipping_cost = r12_1.cw_shipping_cost
--   where event_id = r12_1.event_id;
--end loop;
--
--for r13 in c13 loop
--  update gk_go_nogo
--     set freight_cost = r13.freight_avg
--   where event_id = r13.event_id;
--end loop;
--
--for r13_1 in c13_1 loop
--  update gk_go_nogo
--     set freight_cost = r13_1.freight_avg
--   where event_id = r13_1.event_id;
--end loop;
--
--for r14 in c14 loop
--  update gk_go_nogo
--     set voucher_cost = r14.voucher_event_cost
--   where event_id = r14.event_id;
--end loop;
--
--/**** UPDATE CISCO DERIVATIVE WORKS ****/
--for r15 in c15 loop
--  update gk_go_nogo
--     set cdw_cost = r15.cdw_cost
--   where event_id = r15.event_id;
--end loop;
--dbms_output.put_line('test5');
--/**** UPDATE FACILITY COST, FACILITY AV, FACILITY FB FOR EXTERNAL FACILITIES ****/
--for r16 in c16 loop
--  update gk_go_nogo
--     set facility_cost = r16.facility_cost
--   where event_id = r16.event_id;
--end loop;
--
--/**** UPDATE FREIGHT COST FOR BACK-TO-BACK CLASSES ****/
--for r18 in c18 loop
--  update gk_go_nogo
--     set airfare_cost = 0,
--         freight_cost = r18.freight_cost
--   where event_id = r18.event_id;
--end loop;
--
--/**** MISC CW COURSE COSTS ****/
--for r20 in c20 loop
--  update gk_go_nogo
--     set misc_cw_cost = r20.misc_cw_cost
--   where event_id = r20.event_id;
--end loop;
--
--for r22 in c22 loop
--  update gk_go_nogo
--     set misc_cw_cost = nvl(misc_cw_cost,0) + r22.misc_cw_cost
--   where event_id = r22.event_id;
--end loop;
--
--/**** UPDATE AMOUNT DUE FOR ENROLLMENT ****/
--for r23 in c23 loop
--  update gk_go_nogo
--     set amt_due_remain = r23.amt_due_remain
--   where event_id = r23.event_id;
--end loop;
--
--/**** LAB RENTAL COSTS ****/
--for r25 in c25 loop
--  update gk_go_nogo
--     set lab_rental = r25.lab_rental
--   where event_id = r25.event_id;
--end loop;
--
--for r27 in c27 loop
--  update gk_go_nogo
--     set lab_rental =  
-- case 
--     when r27.price_unit = 'per Student' then (enroll_cnt-allaccess_cnt)*r27.price_per_day*(end_date-start_date+1)
--     when r27.price_unit = 'per Lab' then 
--        case 
--           when enroll_cnt = 0 then 0
--           when mod((enroll_cnt-allaccess_cnt), r27.students_per_unit) <> 0 then trunc((enroll_cnt-allaccess_cnt) /r27.students_per_unit+1)*r27.price_per_day*(end_date-start_date+1)
--           when mod((enroll_cnt-allaccess_cnt), r27.students_per_unit) = 0 then ((enroll_cnt-allaccess_cnt) / r27.students_per_unit) * r27.price_per_day*(end_date-start_date+1)
--           else r27.price_per_day*(end_date-start_date+1) end
--     else r27.price_per_day*(end_date-start_date+1) end
--   where upper(short_name) = r27.course_code;
--end loop;

dbms_output.put_line('test6');
for r32 in c32 loop
  update gk_go_nogo
     set lab_rental =  
 case 
     when r32.cost_type like '%per student%' and (enroll_cnt-allaccess_cnt) > 0 then (enroll_cnt-allaccess_cnt)*r32.lab_cost
     when r32.cost_type like '%per session%' and (enroll_cnt-allaccess_cnt) > 0 then r32.lab_cost
     else 0 end
   where course_code = r32.coursecode;
end loop;

/**** COMMISSIONS ****/
for r26 in c26 loop
  update gk_go_nogo
     set sales_comm = r26.comm_amt
   where event_id = r26.event_id;
end loop;

/**** CREDIT CARD FEES ****/
for r28 in c28 loop
  update gk_go_nogo
     set credit_card_fee = round((r28.rev_amt * .0075),2)
     where event_id = r28.event_id and rev_amt = r28.rev_amt;
end loop;

/**** FOOD AND BEVERAGE FOR GK FACILITIES ****/
for r29 in c29 loop
  update gk_go_nogo
     set food_and_bev = round((r29.enroll_cnt * r29.meeting_days * 6.5),2)
     where event_id = r29.event_id and enroll_cnt = r29.enroll_cnt;
end loop;

/*** ALL PROMO COSTS ****/
for r30 in c30 loop
  update gk_go_nogo
     set hotel_promo_cost = r30.promo_cost
     where event_id = r30.event_id;
end loop;

/**** COURSE DIRECTOR FEES ****/
for r31 in c31 loop
  update gk_go_nogo
     set cd_fee = r31.fee_amt
     where event_id = r31.event_id;
end loop;

update gk_go_nogo
   set total_cost = nvl(inst_cost,0)+
       nvl(hotel_cost,0)+nvl(airfare_cost,0)+nvl(rental_cost,0)+
       nvl(cw_cost,0)+nvl(cw_shipping_cost,0)+nvl(misc_cw_cost,0)+
       nvl(freight_cost,0)+
       nvl(voucher_cost,0)+
       nvl(cdw_cost,0)+
       round(nvl(facility_cost,0),2)+
       nvl(hotel_promo_cost,0)+
       nvl(lab_rental,0)+
       nvl(sales_comm,0)+
       nvl(credit_card_fee,0)+
       nvl(food_and_bev,0);

commit;

update gk_go_nogo
   set margin = case when rev_amt = 0 then 0 else (rev_amt-total_cost)/rev_amt end;

commit;

dbms_snapshot.refresh('gkdw.gk_course_to_watch_mv');

end;
/


