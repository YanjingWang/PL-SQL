DROP PROCEDURE GKDW.EDGE_ENROLLMENT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.edge_enrollment_proc(p_edge_id varchar2 default null) as

cursor c0 is
select ea.enroll_id
  from edge_enrollment_data@gkhub ed
       inner join edge_enrollment_audit ea on ed.evxevenrollid = ea.enroll_id
 where ea.cancel_date is not null
   and ed.cancel_date is null;
     
cursor c1 is
select enroll_id,cust_id,email,to_char(access_date,'yyyy-mm-dd HH24:MI:SS') access_date,to_char(expiration_date,'yyyy-mm-dd HH24:MI:SS') expiration_date
  from edge_enrollment_audit ee
 where ee.enroll_status = 'Attended'
   and ee.md_num in ('10','20','41','42')
   and ee.email is not null
   and ee.cancel_date is null
   and not exists (select 1 from edge_enrollment_data@gkhub ed where ee.enroll_id = ed.evxevenrollid)
union
select enroll_id,cust_id,email,to_char(access_date,'yyyy-mm-dd HH24:MI:SS') access_date,to_char(expiration_date,'yyyy-mm-dd HH24:MI:SS') expiration_date
  from edge_enrollment_audit ee
 where ee.enroll_status = 'Confirmed'
   and ee.md_num in ('41','42')
   and ee.email is not null
   and ee.cancel_date is null
   and not exists (select 1 from edge_enrollment_data@gkhub ed where ee.enroll_id = ed.evxevenrollid);
   
cursor c2 is
select enroll_id,access_date,access_date+180 expiration_date
  from edge_enrollment_audit
 where enroll_id = p_edge_id;

r0 c0%rowtype;  
r1 c1%rowtype;
r2 c2%rowtype;  
v_modify_date varchar2(25);

begin

select to_char(sysdate,'yyyy-mm-dd HH24:MI:SS') into v_modify_date from dual;

update edge_enrollment_audit
   set cancel_flag = 'Y',
       cancel_date = sysdate,
       enroll_status = 'Cancelled'
 where cancel_date is null
   and enroll_id in (select f.enroll_id 
                       from order_fact f
                            inner join edge_enrollment_audit ee on f.enroll_id = ee.enroll_id
                      where f.enroll_status = 'Cancelled'
                        and ee.cancel_date is null);
commit;
         
insert into edge_enrollment_audit
select sysdate create_date,ed.event_id,ed.start_date,ed.end_date,cd.course_code,cd.course_id,cd.ch_num,cd.course_ch,cd.md_num,cd.course_mod,
       case when cd.md_num in ('20','42') and c.country = 'CANADA' then c.country
            else ed.ops_country
       end ops_country,
       c.cust_id,c.cust_name,c.email,c.address1,c.city,c.state,c.zipcode,f.enroll_id,rc.customer_trx_id,rc.trx_number,
       ed.start_date access_date,ed.start_date+180 expiration_date,cd.oracle_item_id,cd.oracle_item_num,
       gcc2.code_combination_id sales_account,f.list_price,f.book_amt,
       case when ch_num = '10' then round(case when f.list_price = 0 then 0 else (f.list_price-f.book_amt)/f.list_price end,4) 
            when ch_num = '20' then .4
       end disc_pct,
       40 edge_price,
       'N' cancel_flag,null cancel_date,null,cd.pl_num,cd.course_pl,f.keycode,c.first_name,c.last_name,f.enroll_status,
       null,null,null
  from order_fact f 
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join mtl_system_items@r12prd msi on cd.oracle_item_id = msi.inventory_item_id and case when ed.ops_country = 'CANADA' then 103 else 101 end = msi.organization_id
       inner join gl_code_combinations@r12prd gcc on msi.sales_account = gcc.code_combination_id
       inner join gl_code_combinations@r12prd gcc2 on gcc.segment1 = gcc2.segment1 and gcc2.segment2 = '000' and gcc2.segment3 = '41215' and gcc.segment4 = gcc2.segment4
                                                        and gcc2.segment5 = '10' and gcc2.segment6 = '01' and gcc2.segment7 = '000000' and gcc.segment8 = '000' and gcc.segment9 = '000'
       left outer join ra_customer_trx_all@r12prd rc on f.enroll_id = rc.interface_header_attribute1
 where (ed.event_id = p_edge_id or f.enroll_id = p_edge_id)
   and f.enroll_status = 'Attended'
   and ed.start_date >= '06-APR-2015'
   and (f.book_amt >= 500 or f.list_price >= 500 or cd.ch_num = '20')
   and cd.pl_num != '17'
   and cd.md_num in ('10','20','41','42')
   and c.acct_id not in ('A6UJ9A00P1ZL','A6UJ9A00XXT1','A6UJ9A01L6PV') --JPMC exclusion
   and not exists (select 1 from edge_enrollment_audit ee where f.enroll_id = ee.enroll_id)
   and not exists (select 1 from gk_channel_partner cp where f.keycode = cp.partner_key_code and nvl(cp.ob_comm_type,'--') not in ('APOC','CA-CENT2','Federal','Named Account','student'))
   and not exists (select 1 from gk_french_courses fc where cd.course_id = fc.course_id);
commit;

--update edge_enrollment_audit ea
--   set hvxuserid = (select max(h.hvxuserid) 
--                               from hvxuser@gkhub h 
--                              where ea.cust_id = h.contactid)
-- where ea.hvxuserid is null;
--commit;

open c0; loop
  fetch c0 into r0; exit when c0%NOTFOUND;
    update edge_enrollment_data@gkhub
       set cancel_date = v_modify_date
     where evxevenrollid = r0.enroll_id; 
end loop;
close c0;
commit;

open c1; loop
  fetch c1 into r1; exit when c1%NOTFOUND;
  
  insert into edge_enrollment_data@gkhub(evxevenrollid,contactid,email,access_date,expiration_date)
    values (r1.enroll_id,r1.cust_id,r1.email,r1.access_date,r1.expiration_date);
  commit;
end loop;
close c1;
commit;

open c2; loop
  fetch c2 into r2; exit when c2%NOTFOUND;
  
  update edge_enrollment_audit
     set expiration_date = r2.expiration_date
   where enroll_id = r2.enroll_id;
  commit;
  
  update edge_enrollment_data@gkhub
     set expiration_date = r2.expiration_date
   where evxevenrollid = r2.enroll_id;
  commit;
end loop;
close c2;
commit;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','EDGE_ENROLLMENT_PROC FAILED',SQLERRM);

end;
/


