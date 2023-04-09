DROP PROCEDURE GKDW.PORTAL_ROSTER_LOAD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.portal_roster_load_proc as

cursor c1 is
select f.enroll_id,es.partner_id,es.event_schedule_id,es.duration_days class_duration,null cw_req_conf,
       c.first_name,c.last_name,c.email,
       case when upper(email) like '%IBM%' then 'Emp'
            when upper(email) like '%SOFTLAYER%' then 'Emp'
            else 'Cus'
       end student_type,
       case when upper(email) like '%IBM%' then 'IBMD2015021411022303979092'
            when upper(email) like '%SOFTLAYER%' then 'IBMD2015021411022303979092'
            else null
       end  discount_type,
       case when upper(email) like '%IBM%' then 15
            when upper(email) like '%SOFTLAYER%' then 15
            else 0
       end  discount_percent,
       'T' isactive,
       'SLX' modifyby_id,
       case when upper(email) like '%IBM%' then c.first_name
            when upper(email) like '%SOFTLAYER%' then c.first_name
            else null
       end first_name_cc,
       case when upper(email) like '%IBM%' then c.last_name
            when upper(email) like '%SOFTLAYER%' then c.last_name
            else null
       end last_name_cc,  
       case when upper(email) like '%IBM%' then c.email
            when upper(email) like '%SOFTLAYER%' then c.email
            else null
       end email_cc,
       null serial_number,
       null customer_number,
       null department,
       c.acct_name,
       co.country_id,
       case when f.enroll_status = 'Attended' then 'Attended' else null end status,
       case when 2 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end mo_flag,
       case when 3 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end tu_flag,
       case when 4 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end we_flag,
       case when 5 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end th_flag,
       case when 6 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end fr_flag,
       case when 7 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end sa_flag,
       case when 1 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end su_flag,
       es.line_id,
       c.city,
       case when st1.state_id is not null then st1.state_id
            when st2.state_id is not null then st2.state_id
            else null
       end state,c.workphone,
       null job_function,
       c.title job_title,
       case when rs.roster_id is not null then 'Y' else 'N' end rs_flag
  from event_schedule@part_portals es
       inner join event_dim ed on es.event_id = ed.event_id
       inner join order_fact f on ed.event_id = f.event_id
       inner join cust_dim c on f.cust_id = c.cust_id
       left outer join countries@part_portals co on case when c.country = 'USA' then 'UNITED STATES' else upper(c.country) end = upper(co.name)
       left outer join states@part_portals st1 on 'US-'||upper(c.state) = st1.iso_code
       left outer join states@part_portals st2 on upper(c.province) = upper(st2.name)
       left outer join roster_softlayer_data@part_portals rs on f.enroll_id = rs.roster_id
 where es.line_id in ('BLI2014120914122805276504','BLI2014120914123401279416')  -- Softlayer & IBM LINE ID)
   and f.enroll_status in ('Confirmed','Attended')
   and not exists (select 1 from roster_ibm@part_portals ri 
                    where es.event_schedule_id = ri.event_schedule_id 
                      and ((upper(c.email) = upper(ri.email) or c.email is null) or f.enroll_id = ri.roster_id)
                      and case when f.enroll_status in ('Confirmed','Attended') then 'T' else 'F' end = ri.isactive);

cursor c2 is
select f.enroll_id,
       f.enroll_status status,
       case when 2 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end mo_flag,
       case when 3 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end tu_flag,
       case when 4 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end we_flag,
       case when 5 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end th_flag,
       case when 6 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end fr_flag,
       case when 7 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end sa_flag,
       case when 1 between to_char(ed.start_date,'d') and to_char(ed.end_date,'d') and enroll_status = 'Attended' then 'T' else null end su_flag
  from order_fact f, 
       event_dim ed,
       roster_ibm@part_portals ri
 where f.event_id = ed.event_id
   and f.enroll_id = ri.roster_id 
   and ri.status is null
   and f.enroll_status = 'Attended'
   and ri.line_id in ('BLI2014120914122805276504','BLI2014120914123401279416');  -- Softlayer & IBM LINE ID)
   
cursor c3 is
select f.enroll_id,
       f.enroll_status status,
       'F' isactive
  from order_fact f, 
       roster_ibm@part_portals ri
 where f.enroll_id = ri.roster_id 
   and f.enroll_status = 'Cancelled'
   and ri.line_id = 'BLI2014120914122805276504'; -- Softlayer Only (BLI2014120914123401279416 - IBM LINE ID)
   
v_curr_date varchar2(25);
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;

begin
open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;  
  
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
  
  insert into roster_ibm@part_portals(roster_id,partner_id,event_schedule_id,class_duration,first_name,last_name,email,student_type,isactive,createdate,
                                      modifydate,modifyby_id,first_name_cc,last_name_cc,email_cc,company,country,status,monday,tuesday,wednesday,thursday,
                                      friday,saturday,sunday,line_id,discount_type,discount_percent)
  values (r1.enroll_id,r1.partner_id,r1.event_schedule_id,r1.class_duration,r1.first_name,r1.last_name,r1.email,r1.student_type,r1.isactive,v_curr_date,v_curr_date,
          r1.modifyby_id,r1.first_name_cc,r1.last_name_cc,r1.email_cc,r1.acct_name,r1.country_id,r1.status,r1.mo_flag,r1.tu_flag,r1.we_flag,r1.th_flag,r1.fr_flag,
          r1.sa_flag,r1.su_flag,r1.line_id,r1.discount_type,r1.discount_percent);
  
  if r1.rs_flag = 'N' then         
    insert into roster_softlayer_data@part_portals(roster_id,city,state,phone,job_function_id,other_job_function)
    values (r1.enroll_id,r1.city,r1.state,r1.workphone,r1.job_function,r1.job_title);
  end if;
  
end loop;
close c1;
commit;

open c2;
loop
  fetch c2 into r2;
  exit when c2%notfound;  
  
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

  update roster_ibm@part_portals
     set status = r2.status,
         monday = r2.mo_flag,
         tuesday = r2.tu_flag,
         wednesday = r2.we_flag,
         thursday = r2.th_flag,
         friday = r2.fr_flag,
         saturday = r2.sa_flag,
         sunday = r2.su_flag,
         modifydate = v_curr_date
   where roster_id = r2.enroll_id;
end loop;
close c2;
commit;

open c3;
loop
  fetch c3 into r3;
  exit when c3%notfound;  
  
  v_curr_date := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

  update roster_ibm@part_portals
     set status = r3.status,
         isactive = r3.isactive
   where roster_id = r3.enroll_id;
end loop;
close c3;
commit;

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','PORTAL_ROSTER_LOAD_PROC Failed',SQLERRM);

end;
/


