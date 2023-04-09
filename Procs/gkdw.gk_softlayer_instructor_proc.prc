DROP PROCEDURE GKDW.GK_SOFTLAYER_INSTRUCTOR_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_softlayer_instructor_proc as

-- Partner Portal INSTRUCTOR and PRODUCT_LINE_INSTRUCTOR tables
cursor c1 is
select distinct si.contactid instructor_id,sysdate createdate,sysdate modifydate,null loginid,null password,si.firstname fname,
       si.lastname lname,null phone,si.email email,si.address1,si.address2,si.city,si.state,si.zipcode,
       co.country_id,'T' active,null language_setting,'T' approved,'F' declined,null modify_id,null approved_id,
       null last_login,'PAR2014060910063208301257' partner_id,sysdate approve_decline_date,
       'REG2014010813015501871482' region_id,'BLI2014120914122805276504' line_id 
  from gk_softlayer_instructors_mv si
       left outer join countries@part_portals co on upper(si.country) = upper(co.name)
       and si.inst_status = 'yes'
  where not exists (select 1 from instructor@part_portals i where si.contactid = i.instructor_id);

-- Partner Portal INSTRUCTOR_COURSE table
cursor c2 is
select contactid instructor_id,sysdate createdate,sysdate modifydate,null modifyby_id,'T' active,'T' approved,'F' declined,
       null approved_id,'BLI2014120914122805276504' line_id,prod_code course_id,sysdate approve_decline_date,null prep_start_date,
       null prep_end_date,null prep_type 
  from gk_softlayer_instructors_mv si
 where si.inst_prod_status = 'certready'
   and not exists (select 1 from instructor_course@part_portals ic where si.contactid = ic.instructor_id and si.prod_code = ic.course_id);

-- Partner Portal INSTRUCTOR_EVENT table
cursor c3 is
select si.contactid instructor_id,ie.evxeventid event_schedule_id,sysdate createdate,sysdate modifydate,'T' active,null modifyby_id,
       'BLI2014120914122805276504' line_id,ie.feecode instructor_type,null change_type
  from gk_softlayer_instructors_mv si
       inner join instructor_event_v ie on si.contactid = ie.contactid
       inner join event_schedule@part_portals es on ie.evxeventid = es.event_schedule_id and es.line_id = 'BLI2014120914122805276504' and si.prod_code = es.ibm_course_code
 where es.status != 'Cancelled'
   and not exists (select 1 from instructor_event@part_portals ie2 where ie.evxeventid = ie2.event_schedule_id and si.contactid = ie2.instructor_id and ie.feecode = ie2.instructor_type);

cursor c4 is
select contactid,
       case when inst_status = 'yes' then 'T' else 'F' end active
  from gk_softlayer_instructors_mv
minus
select i.instructor_id,active
  from instructor@part_portals i;
  
v_sysdate date;

begin 
dbms_snapshot.refresh('gkdw.gk_softlayer_instructors_mv');

for r1 in c1 loop
  insert into instructor@part_portals(instructor_id,createdate,modifydate,fname,lname,email,address1,address2,
                                          city,state,zipcode,country_id,active,approved,declined,partner_id,
                                          approve_decline_date,region_id)
   values (r1.instructor_id,r1.createdate,r1.modifydate,r1.fname,r1.lname,r1.email,r1.address1,r1.address2,r1.city,
           r1.state,r1.zipcode,r1.country_id,r1.active,r1.approved,r1.declined,r1.partner_id,r1.approve_decline_date,r1.region_id);

  insert into product_line_instructor@part_portals(line_id,instructor_id,createdate,modifydate,active)
   values (r1.line_id,r1.instructor_id,r1.createdate,r1.modifydate,r1.active);
end loop;
commit;

for r2 in c2 loop   
  insert into instructor_course@part_portals(instructor_id,createdate,modifydate,active,approved,declined,line_id,course_id,approve_decline_date)
   values (r2.instructor_id,r2.createdate,r2.modifydate,r2.active,r2.approved,r2.declined,r2.line_id,r2.course_id,r2.approve_decline_date);
end loop;

for r3 in c3 loop
  insert into instructor_event@part_portals(instructor_id,event_schedule_id,createdate,modifydate,active,line_id,instructor_type)
   values (r3.instructor_id,r3.event_schedule_id,r3.createdate,r3.modifydate,r3.active,r3.line_id,r3.instructor_type);
end loop;
commit;

v_sysdate := sysdate;
for r4 in c4 loop
  update instructor@part_portals
     set active = r4.active,
         modifydate = v_sysdate
   where instructor_id = r4.contactid;
end loop;
commit;

end;
/


