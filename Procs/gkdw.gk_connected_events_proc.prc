DROP PROCEDURE GKDW.GK_CONNECTED_EVENTS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_connected_events_proc as

cursor c1 is
select el.* 
  from gk_connected_events_load el
       inner join event_dim ed on el.course_code = ed.course_code and el.start_date = ed.start_date and el.end_date = ed.end_date
                                  and el.child_country = substr(ed.ops_country,1,2)
 where not exists (select 1 from "connected_events"@rms_prod ce where ed.event_id = ce."child_evxeventid");

cursor c2(v_course_code varchar2,v_start_date varchar2,v_end_date varchar2,v_child_country varchar2,v_parent_metro varchar2) is
  select ce."parent_evxeventid" parent_evxeventid,ce."child_evxeventid" child_evxeventid,ce."gk_connected_eventsid" gk_conn_id
    from gk_get_connected_eventsid_v@slx ce
   where ce."child_coursecode" =  v_course_code
     and ce."child_startdate" = v_start_date
     and ce."child_enddate" = v_end_date
     and ce."event_country" = v_child_country
     and ce."parent_metro" = v_parent_metro;

r1 c1%rowtype;
r2 c2%rowtype;
curr_date varchar2(50) := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
v_parent varchar2(25);
v_child varchar2(25);
v_conn varchar2(25);

begin
rms_link_set_proc;

open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;

  open c2(r1.course_code,r1.start_date,r1.end_date,r1.child_country,r1.parent_metro);
  fetch c2 into r2;
  if c2%found then
  
    v_parent := r2.parent_evxeventid;
    v_child  := r2.child_evxeventid;
    v_conn   := r2.gk_conn_id;
  
    insert into "connected_events"@rms_prod("createdate","modifydate","parent_evxeventid","child_evxeventid","createuser","modifyuser","gk_connected_eventsid")
      values (curr_date,curr_date,v_parent,v_child,'John DellOmo','John DellOmo',v_conn);
    commit;
    
    update "schedule"@rms_prod
       set "connected_parent" = 'Y'
     where "slx_id" in v_parent;
    commit;
    
    update "schedule"@rms_prod
       set "connected_child" = 'Y'
     where "slx_id" in v_child;
    commit; 
    
    insert into "gk_connected_events"@slx
      values (v_conn,'RMS_SLX_CONN',curr_date,'RMS_SLX_CONN',curr_date,v_parent,v_child,'John DellOmo','John DellOmo');
    commit;
    
    update evxevent@slx
       set connected_learning = 'T'
     where evxeventid in (v_parent,v_child);
    commit;
    
    dbms_output.put_line(r2.child_evxeventid||' connected to '||r2.parent_evxeventid);
    
  end if;
  close c2;
end loop;
close c1;
commit;

end;
/


