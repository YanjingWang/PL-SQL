DROP PROCEDURE GKDW.GK_C_L_SCHED_LOAD_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_c_l_sched_load_proc as

cursor c1 is
select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') createdate,to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') modifydate,
       ed2.event_id parent_evxeventid,ed.event_id child_evxeventid,'AutoCreated' createuser,'AutoCreated' modifyuser,ed.event_id l_event_id
  from gk_c_l_sched_load l
       inner join event_dim ed on l.course_code = ed.course_code 
                               and to_date(l.start_date,'yyyy-mm-dd') = ed.start_date
                               and to_date(l.end_date,'yyyy-mm-dd') = ed.end_date
                               and l.metro = ed.facility_region_metro
                               and l.country = substr(ed.ops_country,1,2)
                               and lpad(l.start_time,5,'0') = substr(ed.start_time,1,5)
                               and ed.status = 'Open'
       inner join event_dim ed2 on replace(l.course_code,'L','C') = ed2.course_code
                               and to_date(l.start_date,'yyyy-mm-dd') = ed2.start_date
                               and to_date(l.end_date,'yyyy-mm-dd') = ed2.end_date
                               and substr(l.c_metro,1,3) = ed2.facility_region_metro
                               and ed2.status = 'Open'
 where not exists (select 1 from "connected_events"@rms_prod ce where ed.event_id = ce."child_evxeventid");


r1 c1%rowtype;

begin
rms_link_set_proc;

open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;

  insert into "connected_events"@rms_prod("createdate","modifydate","parent_evxeventid","child_evxeventid","createuser","modifyuser","gk_connected_eventsid")
  values(r1.createdate,r1.modifydate,r1.parent_evxeventid,r1.child_evxeventid,r1.createuser,r1.modifyuser,r1.l_event_id);
  commit;
  
  insert into "GK_CONNECTED_EVENTS"@slx
  values(r1.l_event_id,'RMS_SLX_CONN',r1.createdate,'RMS_SLX_CONN',r1.modifydate,r1.parent_evxeventid,r1.child_evxeventid,r1.createuser,r1.modifyuser);
  commit;
  
  update evxevent@slx
     set connected_learning = 'T'
   where evxeventid = r1.child_evxeventid;
  commit;

  update evxevent@slx
     set connected_learning = 'T'
   where evxeventid = r1.parent_evxeventid;
  commit;
  
  update "schedule"@rms_prod
     set "connected_parent" = 'Y'
   where "slx_id" = r1.parent_evxeventid;
  commit;
  
  update "schedule"@rms_prod
     set "connected_child" = 'Y'
   where "slx_id" = r1.child_evxeventid;
  commit;
   
end loop;
close c1;

end;
/


