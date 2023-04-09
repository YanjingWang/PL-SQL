DROP PROCEDURE GKDW.IFRC_PROC;

CREATE OR REPLACE PROCEDURE GKDW.ifrc_proc as

cursor c1 is
select distinct sysdate creation_date,g.ops_country,g.start_week,f.enroll_id,f.cust_id,c.cust_name,c.acct_name,c.acct_id,c.email,c.workphone,
       g.start_date,ed.end_date,g.event_id,g.metro,g.facility_code,ed.tz_fulname,g.course_code,cd.short_name,c.first_name,c.last_name,
       f.payment_method,qb.oraclestatus,
       case when payment_method = 'Prepay Card' then 'Prepay Card'
            when payment_method = 'VMWARE Training Credits' then 'VMWARE Training Credits'
            when payment_method = 'Citrix Training Pass' then 'Citrix Training Pass'
            when payment_method = 'Microsoft SATV' then 'Microsoft SATV'
            when payment_method = 'Cisco Learning Credits' then 'Cisco Learning Credits'
            when qb.oraclestatus = 'Paid' then '100% Credit'
            else payment_method
       end new_payment_method
  from gk_go_nogo_v g
       inner join event_dim ed on g.event_id = ed.event_id and ed.ops_country = 'USA'
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td on td.dim_date = trunc(sysdate)
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed' and f.curr_code = 'USD'
       inner join slxdw.qg_billingpayment qb on f.enroll_id = qb.evxevenrollid
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join gk_go_nogo_v g2 on substr(g.course_code,1,4) = substr(g2.course_code,1,4) and g2.start_date between g.start_date-7 and g.start_date+42 
                                       and g2.enroll_cnt >= 4
       inner join event_dim ed2 on g2.event_id = ed2.event_id and ed.ops_country = ed2.ops_country
       inner join course_dim cd2 on ed2.course_id = cd2.course_id and ed2.ops_country = cd2.country
       inner join slxdw.evxcoursefee ef on cd2.course_id = ef.evxcourseid and f.fee_type = ef.feetype and ef.feeavailable = 'T' and f.curr_code = ef.currency
       left outer join gk_course_url_mv cu on g.course_code = cu.course_code and g.ops_country = cu.country
where g.start_week between td.dim_year||'-'||lpad(td.dim_week+3,2,'0') and td.dim_year||'-'||lpad(td.dim_week+8,2,'0')
  and g.enroll_cnt between 1 and 2
  and g.gtr_flag = 'N'
  and ed.connected_v_to_c is null
  and g.enroll_cnt+g2.enroll_cnt <= ed2.capacity
  and g.event_id <> g2.event_id
  and cd.ch_num = '10'
  and cd.md_num in ('10','20')
  and f.payment_method != 'Cisco Learning Credits'
  and not exists (select 1 from gk_ext_events_v s where ed.event_id = s.event_id)
  and not exists (select 1 from gk_channel_partner cp where f.keycode = cp.partner_key_code)
  and not exists (select 1 from ifrc_audit ia where f.enroll_id = ia.enroll_id)
order by payment_method,start_week desc,metro,event_id,enroll_id;


begin

for r1 in c1 loop

  insert into ifrc_audit(creation_date,ops_country,start_week,enroll_id,cust_id,cust_name,acct_name,acct_id,email,workphone,start_date,end_date,event_id,metro,
                         facility_code,tz_fulname,course_code,short_name,first_name,last_name)
  select r1.creation_date,r1.ops_country,r1.start_week,r1.enroll_id,r1.cust_id,r1.cust_name,r1.acct_name,r1.acct_id,r1.email,r1.workphone,
         r1.start_date,r1.end_date,r1.event_id,r1.metro,r1.facility_code,r1.tz_fulname,r1.course_code,r1.short_name,r1.first_name,r1.last_name
    from dual;
  commit;
  
--  ifrc_email_body(r1.enroll_id);
end loop;

delete from ifrc_queue;

insert into ifrc_queue
select g.ops_country,g.start_week,f.enroll_id,f.cust_id,c.cust_name,c.acct_name,c.acct_id,c.email,c.workphone,
       f.cust_city,f.cust_state,f.cust_zipcode,
       g.start_date,cd.md_num,ed.end_date,ed.start_time,ed.end_time,
       g.event_id,g.metro,g.facility_code,ed.tz_fulname,tz.tzabbreviation,
       ed.connected_c,ed.connected_v_to_c,
       g.course_code,cd.short_name,c.first_name,c.last_name,
       f.payment_method,qb.oraclestatus,
       case when payment_method = 'Prepay Card' then 'Prepay Card'
            when payment_method = 'VMWARE Training Credits' then 'VMWARE Training Credits'
            when payment_method = 'Citrix Training Pass' then 'Citrix Training Pass'
            when payment_method = 'Microsoft SATV' then 'Microsoft SATV'
            when payment_method = 'Cisco Learning Credits' then 'Cisco Learning Credits'
            when qb.oraclestatus = 'Paid' then '100% Credit'
            else payment_method
       end new_payment_method,
       f.book_amt,
       gk_calc_tax_func@vertex(case when upper(substr(f.cust_country,1,3)) = 'CAN' then '86' else '84' end,
                               case when cd.md_num in ('10','41') then ed.city else f.cust_city end,
                               case when cd.md_num in ('10','41') then ed.state else f.cust_state end,
                               case when cd.md_num in ('10','41') then ed.zipcode else f.cust_zipcode end,
                               case when cd.md_num in ('10','41') then ed.county else f.cust_county end,
                               substr(cd.course_code,-1),
                               case when cd.md_num in ('10','41') then ed.province else f.cust_state end,
                               f.acct_id) orig_tax_rate,
       gk_calc_tax_func@vertex(case when upper(substr(f.cust_country,1,3)) = 'CAN' then '86' else '84' end,
                               case when cd.md_num in ('10','41') then ed.city else f.cust_city end,
                               case when cd.md_num in ('10','41') then ed.state else f.cust_state end,
                               case when cd.md_num in ('10','41') then ed.zipcode else f.cust_zipcode end,
                               case when cd.md_num in ('10','41') then ed.county else f.cust_county end,
                               substr(cd.course_code,-1),
                               case when cd.md_num in ('10','41') then ed.province else f.cust_state end,
                               f.acct_id)*f.book_amt orig_tax_amt,
       f.curr_code,f.list_price,f.fee_type,
       case when f.list_price>0 then round(f.book_amt/f.list_price,2) else 1 end disc_pct,
       cd2.course_code new_course_code,ed2.event_id new_event_id,ed2.start_date new_start_date,ed2.end_date new_end_date,
       ed2.start_time new_start_time,ed2.end_time new_end_time,ed2.facility_region_metro new_metro,ed2.facility_code new_facility_code,
       ed2.tz_fulname new_tz_fulname,tz2.tzabbreviation new_tzabbreviation,
       ef.feetype,ef.amount,
       case when f.list_price <= ef.amount then f.book_amt
            when f.list_price>0 then round(f.book_amt/f.list_price,2)* ef.amount 
            else f.book_amt 
       end new_book_amt,
       gk_calc_tax_func@vertex(case when upper(substr(f.cust_country,1,3)) = 'CAN' then '86' else '84' end,
                               case when cd.md_num in ('10','41') then ed2.city else c.city end,
                               case when cd.md_num in ('10','41') then ed2.state else c.state end,
                               case when cd.md_num in ('10','41') then ed2.zipcode else c.zipcode end,
                               case when cd.md_num in ('10','41') then ed2.county else c.county end,
                               substr(cd2.course_code,-1),
                               case when cd.md_num in ('10','41') then ed2.province else c.province end,
                               f.acct_id) new_tax_rate,
       gk_calc_tax_func@vertex(case when upper(substr(f.cust_country,1,3)) = 'CAN' then '86' else '84' end,
                               case when cd.md_num in ('10','41') then ed2.city else c.city end,
                               case when cd.md_num in ('10','41') then ed2.state else c.state end,
                               case when cd.md_num in ('10','41') then ed2.zipcode else c.zipcode end,
                               case when cd.md_num in ('10','41') then ed2.county else c.county end,
                               substr(cd2.course_code,-1),
                               case when cd.md_num in ('10','41') then ed2.province else c.province end,
                               f.acct_id)*
                               case when f.list_price <= ef.amount then f.book_amt
                                    when f.list_price>0 then round(f.book_amt/f.list_price,2)* ef.amount 
                                    else f.book_amt 
                               end new_tax_amt,
       case when f.list_price <= ef.amount then 0
            when qb.oraclestatus = 'Paid' and f.list_price>0 then book_amt-(round(f.book_amt/f.list_price,2)* ef.amount)
            else 0
       end credit_amt,
       cu.course_url,
       g2.total_cost new_total_cost,g2.revenue new_revenue,g2.enroll_cnt new_enroll_cnt,ed2.capacity new_capacity,
       g2.gtr_flag new_gtr_flag
  from gk_go_nogo_v g
       inner join event_dim ed on g.event_id = ed.event_id and ed.ops_country = 'USA'
       inner join slxdw.evxevent ev on ed.event_id = ev.evxeventid
       inner join slxdw.evxtimezone tz on ev.evxtimezoneid = tz.evxtimezoneid
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td on td.dim_date = trunc(sysdate)
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status = 'Confirmed' and f.curr_code = 'USD'
       inner join ifrc_audit a on f.enroll_id = a.enroll_id and a.accept_date is null and a.decline_date is null
       inner join slxdw.qg_billingpayment qb on f.enroll_id = qb.evxevenrollid
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join gk_go_nogo_v g2 on substr(g.course_code,1,4) = substr(g2.course_code,1,4) and g2.start_date between g.start_date-7 and g.start_date+42 
                                       and g2.enroll_cnt >= 4
       inner join event_dim ed2 on g2.event_id = ed2.event_id and ed.ops_country = ed2.ops_country
       inner join slxdw.evxevent ev2 on ed2.event_id = ev2.evxeventid
       inner join slxdw.evxtimezone tz2 on ev2.evxtimezoneid = tz2.evxtimezoneid
       inner join course_dim cd2 on ed2.course_id = cd2.course_id and ed2.ops_country = cd2.country
       inner join slxdw.evxcoursefee ef on cd2.course_id = ef.evxcourseid and f.fee_type = ef.feetype and ef.feeavailable = 'T' and f.curr_code = ef.currency
       left outer join gk_course_url_mv cu on g.course_code = cu.course_code and g.ops_country = cu.country
where g.start_week between td.dim_year||'-'||lpad(td.dim_week+3,2,'0') and td.dim_year||'-'||lpad(td.dim_week+8,2,'0')
  and g.enroll_cnt between 1 and 2
  and g.gtr_flag = 'N'
  and ed.connected_v_to_c is null
  and g.enroll_cnt+g2.enroll_cnt <= ed2.capacity
  and g.event_id <> g2.event_id
  and cd.ch_num = '10'
  and cd.md_num in ('10','20')
  and f.payment_method != 'Cisco Learning Credits'
  and not exists (select 1 from gk_ext_events_v s where ed.event_id = s.event_id)
  and not exists (select 1 from gk_channel_partner cp where f.keycode = cp.partner_key_code)
order by payment_method,oraclestatus,enroll_id;
commit;

end;
/


