DROP PROCEDURE GKDW.GK_GTR_EVENTS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_gtr_events_proc as

cursor c0 is
  select e.event_id,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') change_date,e.ops_country,
         e.ops_country||chr(9)||start_week||chr(9)||e.start_date||chr(9)||e.event_id||chr(9)||metro||chr(9)||e.facility_code||chr(9)||
         e.course_code||chr(9)||course_ch||chr(9)||course_mod||chr(9)||course_pl||chr(9)||course_type||chr(9)||inst_type||chr(9)||
         inst_name||chr(9)||revenue||chr(9)||total_cost||chr(9)||enroll_cnt||chr(9)||margin v_audit_line,
         e.ops_country||chr(9)||start_week||chr(9)||e.start_date||chr(9)||e.event_id||chr(9)||metro||chr(9)||
         e.course_code||chr(9)||course_mod||chr(9)||course_pl||chr(9)||course_type||chr(9)||
         inst_name||chr(9)||ed.connected_c||chr(9)||ed.connected_v_to_c v_rc_line
    from gk_gtr_events e
         inner join event_dim ed on e.event_id = ed.event_id
   where gtr_create_date >= trunc(sysdate)
     and course_mod not like 'RESELLER%'
     and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = e.event_id) -- SR 06/08/2018
   order by e.start_date,e.course_code,e.ops_country;

v_audit_file_name varchar2(50);
v_audit_file_name_full varchar2(250);
v_rc_file_name varchar2(50);
v_rc_file_name_full varchar2(250);
v_audit_hdr varchar2(1000);
v_rc_hdr varchar2(1000);
v_audit_file utl_file.file_type;
v_rc_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_results varchar2(1) := 'N';
r0 c0%rowtype;

begin
rms_link_set_proc;

gk_gtr_manual_load; --evaluate file
gk_gtr_manual_load; --level 3 file
gk_gtr_manual_load; --level 0 file

insert into gk_gtr_events
select gn.ops_country,gn.start_week,gn.start_date,gn.event_id,gn.metro,gn.facility_code,
       gn.course_code,gn.course_ch,gn.course_mod,gn.course_pl,gn.course_type,
       gn.inst_type,gn.inst_name,gn.revenue,gn.total_cost,gn.enroll_cnt,
       round(gn.margin*100,2) margin,sysdate gtr_create_date,'1' gtr_level
from gk_go_nogo_v gn
     inner join event_dim ed on gn.event_id = ed.event_id
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
where gn.ops_country = 'CANADA'
  and gn.start_date between trunc(sysdate) and trunc(sysdate)+14
  and gn.course_pl != 'OTHER - NEST; SECURITY-EMEA'
  and inst_name is not null
  and substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947')
  and not (cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))  /** DAVE K. REQUEST 7/16 **/
  and not (cd.course_pl = 'MICROSOFT APPS')  /* Erika Powell Request 01/25/2018 */
 --  and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
  and not exists (select 1 from gk_gtr_events ge where gn.event_id = ge.event_id)
  and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id); -- SR 06/25/2018
commit;

insert into gk_gtr_events
select gn.ops_country,gn.start_week,gn.start_date,gn.event_id,gn.metro,gn.facility_code,
       gn.course_code,gn.course_ch,gn.course_mod,gn.course_pl,gn.course_type,
       gn.inst_type,gn.inst_name,gn.revenue,gn.total_cost,gn.enroll_cnt,
       round(gn.margin*100,2) margin,sysdate gtr_create_date,'2' gtr_level
from gk_go_nogo_v gn
     inner join event_dim ed on gn.event_id = ed.event_id
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
where gn.ops_country = 'CANADA'
  and gn.start_date >= trunc(sysdate)
  and gn.course_mod = 'C-LEARNING'
  and inst_name is not null
  and margin >= .45
  and enroll_cnt >= 4
  and substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947')
  and not (cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))  /** DAVE K. REQUEST 7/16 **/
  and not (cd.course_pl = 'MICROSOFT APPS')  /* Erika Powell Request 01/25/2018 */
 --  and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
  and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id) -- SR 06/25/2018
  and not exists (select 1 from gk_gtr_events ge where gn.event_id = ge.event_id);
commit;

insert into gk_gtr_events /** SELECT RESELLER EVENTS THAT HAVE BEEN MANUALLY TAGGED AS GTR IN THE RMS **/
select ed.ops_country,td.dim_year||'-'||lpad(td.dim_week,2,'0') start_week,ed.start_date,ed.event_id,ed.facility_region_metro,ed.facility_code,
       ed.course_code,cd.course_ch,cd.course_mod,cd.course_pl,cd.course_type,null,null,null,null,null,null,sysdate,'Auto' gtr_level
from "schedule"@rms_prod s
     inner join event_dim ed on s."slx_id" = ed.event_id
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
     inner join time_dim td on ed.start_date = td.dim_date
where ed.start_date >= trunc(sysdate)
and s."jeopardyflag" = 'GTR'
and not exists (select 1 from gk_gtr_events e where s."slx_id" = e.event_id)
and substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947')
and not (cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))
and not (cd.course_pl = 'MICROSOFT APPS')  /* Erika Powell Request 01/25/2018 */
-- and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id); -- SR 06/25/2018
commit;

/****  US GTR PHASE 1, 2, 3 *******/
insert into gk_gtr_events
select p.* 
  from gk_gtr_daily_pull_v p
       inner join event_dim ed on p.event_id = ed.event_id and ed.status != 'Cancelled'
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947')
   and not (cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))   /*** PAM H. REQUEST 7/2/13 ***/
   and not (cd.course_pl = 'MICROSOFT APPS')  /* Erika Powell Request 01/25/2018 */
 --  and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
   and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id); -- SR 06/25/2018
commit;

insert into gk_gtr_events
select distinct g.ops_country,g.start_week,g.start_date,g.event_id,g.metro,g.facility_code,g.course_code,g.course_ch,g.course_mod,g.course_pl,g.course_type,
       g.inst_type,g.inst_name,g.revenue,g.total_cost,g.enroll_cnt,g.margin,sysdate,p.gtr_level 
  from gk_gtr_daily_pull_v p
       inner join event_dim ed on p.event_id = ed.connected_v_to_c
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_go_nogo_v g on ed.event_id = g.event_id
 where not exists (select 1 from gk_gtr_daily_pull_v p1 where ed.event_id = p1.event_id)
   and ed.status != 'Cancelled'
   and not exists (select 1 from gk_gtr_events ge where g.event_id = ge.event_id)
   and substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947')
   and not (cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))
   and not (cd.course_pl = 'MICROSOFT APPS')  /* Erika Powell Request 01/25/2018 */
 --   and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
   and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id); -- SR 06/25/2018
commit;

/****** MARK THE C+V VIRTUAL EVENTS THAT HAVE NOT BEEN PULLED ******/
insert into gk_gtr_events
select gn.ops_country,gn.start_week,gn.start_date,gn.event_id,gn.metro,gn.facility_code,
       gn.course_code,gn.course_ch,gn.course_mod,gn.course_pl,gn.course_type,
       gn.inst_type,gn.inst_name,gn.revenue,gn.total_cost,gn.enroll_cnt,
       round(gn.margin*100,2) margin,sysdate,e.gtr_level
  from gk_gtr_events e
       inner join event_dim ed on e.event_id = ed.event_id and ed.connected_c = 'Y'
       inner join event_dim ed1 on ed1.connected_v_to_c = ed.event_id
       inner join course_dim cd on ed1.course_id = cd.course_id and ed1.ops_country = cd.country
       inner join gk_go_nogo_v gn on ed1.event_id = gn.event_id
 where not exists (select 1 from gk_gtr_events e1 where ed1.event_id = e1.event_id)
   and substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947') 
   and not ((cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))
          or (cd.course_pl = 'MICROSOFT APPS'))   /* Erika Powell Request 01/25/2018 */
 --          and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
   and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id); -- SR 06/25/2018
commit;

/****** ADD NESTED EVENTS THAT PASS GO-NOGO ******/
insert into gk_gtr_events
select gn.ops_country,gn.start_week,gn.start_date,gn.event_id,ed.facility_region_metro,gn.facility_code,
       gn.course_code,gn.course_ch,gn.course_mod,gn.course_pl,cd.course_type,
       gn.inst_type,gn.inst_name,gn.rev_amt,gn.total_cost,gn.enroll_cnt,
       round(gn.margin*100,2) margin,sysdate gtr_create_date,'1' gtr_level
from gk_go_nogo gn
     inner join event_dim ed on gn.event_id = ed.event_id
     inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
where gn.start_date between trunc(sysdate) and trunc(sysdate)+14
and ed.status != 'Cancelled'
and cd.course_pl != 'OTHER - NEST; SECURITY-EMEA'
and ed.facility_region_metro != 'ONS'
and not exists (select 1 from gk_gtr_events e where ed.event_id = e.event_id)
and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id) -- SR 06/25/2018
and substr(ed.course_code,1,4) not in ('3232','0741','0748','3573','5947')
and not (cd.course_pl = 'CISCO' and cd.course_type in ('Telepresence','Optical Networking'))
and not (cd.course_pl = 'MICROSOFT APPS')  /* Erika Powell Request 01/25/2018 */
-- and not (cd.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
order by start_date;
commit;

/******* ADD NESTED COURSES WITH A MASTER COURSE THAT IS GTR ********/
insert into gk_gtr_events
select ed2.ops_country,ge.start_week,ed2.start_date,ed2.event_id,ed2.facility_region_metro,ed2.facility_code,
       ed2.course_code,ge.course_ch,ge.course_mod,ge.course_pl,cd2.course_type,
       ge.inst_type,ge.inst_name,sum(nvl(book_amt,0)) revenue,0 total_cost,count(distinct f.enroll_id) enroll_cnt,
       0 margin,sysdate gtr_create_date,ge.gtr_level gtr_level
  from gk_gtr_events ge
       inner join event_dim ed on ge.event_id = ed.event_id
       inner join gk_nested_courses nc on ge.course_code = nc.master_course_code
       inner join event_dim ed2 on nc.nested_course_code = ed2.course_code and ed2.start_date between ed.start_date and ed.end_date 
                                                                           and ed2.end_date between ed.start_date and ed.end_date 
                                                                           and ed.facility_region_metro = ed2.facility_region_metro
                                                                           and ed.start_time = ed2.start_time
                                                                           and ed.end_time = ed2.end_time
                                                                           and ed2.status = 'Open'
       inner join course_dim cd2 on ed2.course_id = cd2.course_id and ed2.ops_country = cd2.country
       left outer join order_fact f on ed2.event_id = f.event_id and f.enroll_status = 'Confirmed'
 where ed.end_date >= trunc(sysdate)
   and not exists (select 1 from gk_gtr_events ge2 where ed2.event_id = ge2.event_id)
      and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = ed.event_id) -- SR 06/25/2018
--       and not (cd2.course_pl = 'VMWARE') -- 11/12/2018 3610 fp# 7716
 group by ed2.ops_country,ge.start_week,ed2.start_date,ed2.event_id,ed2.facility_region_metro,ed2.facility_code,
       ed2.course_code,ge.course_ch,ge.course_mod,ge.course_pl,cd2.course_type,
       ge.inst_type,ge.inst_name,ge.gtr_level
 order by start_date,event_id;
commit;

delete from gk_gtr_events where event_id in ('Q6UJ9APXW0GV','Q6UJ9APXVZCW','Q6UJ9APXVZCL','QGKID09XGF44');
commit;

delete from gk_gtr_events where event_id in (select event_id from gk_gtr_events_exclude); -- SR 06/25/2018
commit;

select 'gtr_events_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/gtr_events_'||to_char(sysdate,'yyyymmdd')||'.xls',
       'ca_audit_gtr_events_'||to_char(sysdate,'yyyymmdd')||'.xls',
       '/usr/tmp/ca_audit_gtr_events_'||to_char(sysdate,'yyyymmdd')||'.xls'
  into v_rc_file_name,v_rc_file_name_full,v_audit_file_name,v_audit_file_name_full
  from dual;

select 'Country'||chr(9)||'Start Week'||chr(9)||'Start Date'||chr(9)||'Event ID'||chr(9)||'Metro'||chr(9)||'Facility'||chr(9)||
       'Course Code'||chr(9)||'Channel'||chr(9)||'Modality'||chr(9)||'Prod Line'||chr(9)||'Course Type'||chr(9)||'Inst Type'||chr(9)||
       'Instructor'||chr(9)||'Revenue'||chr(9)||'Total Cost'||chr(9)||'Enroll Cnt'||chr(9)||'Margin',
       'Country'||chr(9)||'Start Week'||chr(9)||'Start Date'||chr(9)||'Event ID'||chr(9)||'Metro'||chr(9)||'Course Code'||chr(9)||
       'Modality'||chr(9)||'Prod Line'||chr(9)||'Course Type'||chr(9)||'Instructor'||chr(9)||'Connected C'||chr(9)||'Connected V'
  into v_audit_hdr,
       v_rc_hdr
  from dual;

v_audit_file := utl_file.fopen('/usr/tmp',v_audit_file_name,'w');
v_rc_file := utl_file.fopen('/usr/tmp',v_rc_file_name,'w');

utl_file.put_line(v_audit_file,v_audit_hdr);
utl_file.put_line(v_rc_file,v_rc_hdr);

open c0;
loop
  fetch c0 into r0;
  exit when c0%notfound;

  update "schedule"@rms_prod
     set "jeopardyflag" = 'GTR',
         "comment" = 'GTR - AUTO',
         "changed" = r0.change_date
   where "slx_id" = r0.event_id;
  commit;

  update qg_event@slx
     set gtr = 'Y',
         modifydate = r0.change_date
   where evxeventid = r0.event_id;
  commit;

  if r0.ops_country = 'CANADA' then
    utl_file.put_line(v_audit_file,r0.v_audit_line);
  end if;
  utl_file.put_line(v_rc_file,r0.v_rc_line);
  v_results := 'Y';
end loop;
close c0;
commit;

utl_file.fclose(v_audit_file);
utl_file.fclose(v_rc_file);

if v_results = 'Y' then
  send_mail_attach('james.nash@globalknowledge.com','erika.powell@globalknowledge.com','jalene.lumb@globalknowledge.com',null,'CA GTR Events - Audit File','See attached Canadian GTR file.',v_audit_file_name_full);
  send_mail_attach('james.nash@globalknowledge.com','james.nash@globalknowledge.com','chris.pichler@globalknowledge.com',null,'CA GTR Events - Audit File','See attached Canadian GTR file.',v_audit_file_name_full);
  send_mail_attach('james.nash@globalknowledge.com','krissi.fields@globalknowledge.com',null,null,'CA GTR Events - Audit File','CA GTR Events - Audit File.',v_audit_file_name_full);
  send_mail_attach('james.nash@globalknowledge.com','tanya.baggio@globalknowledge.com',null,null,'CA GTR Events - Audit File','See attached Canadian GTR file.',v_audit_file_name_full);
  send_mail_attach('DW.Automation@globalknowledge.com','ResourceCoordinator.NAM@globalknowledge.com','erika.powell@globalknowledge.com',null,'GTR Events - Audit File','See attached GTR file.',v_rc_file_name_full);

end if;

exception
  when others then
  rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_gtr_events_proc Procedure Failed',SQLERRM);


end;
/


