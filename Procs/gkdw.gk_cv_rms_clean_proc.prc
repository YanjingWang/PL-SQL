DROP PROCEDURE GKDW.GK_CV_RMS_CLEAN_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_cv_rms_clean_proc as

cursor c1 is
select "slx_id" event_id
  from "schedule"@rms_prod
 where "connected_child" = 'Y'
   and "status" = 'Cancelled';
 
cursor c2 is
select "slx_id" event_id
  from "schedule"@rms_prod
 where "connected_parent" = 'Y'
   and "status" = 'Cancelled';
   
cursor c3 is
select "slx_id" event_id 
  from "schedule"@rms_prod s
 where "connected_parent" = 'Y'
   and not exists (select 1 from "connected_events"@rms_prod ce where s."slx_id" = ce."parent_evxeventid");
   
r1 c1%rowtype;
r2 c2%rowtype;
r3 c3%rowtype;
curr_date varchar2(50) := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');


begin
rms_link_set_proc;

open c1;
loop
  fetch c1 into r1;
  exit when c1%notfound;
  
  delete from "connected_events"@rms_prod 
   where "child_evxeventid" = r1.event_id;
  
  update "schedule"@rms_prod
     set "connected_child" = null,
         "changed" = curr_date
   where "slx_id" = r1.event_id;
end loop;
close c1;
commit;

open c2;
loop
  fetch c2 into r2;
  exit when c2%notfound;
  
  delete from "connected_events"@rms_prod 
   where "parent_evxeventid" = r2.event_id;
  
  update "schedule"@rms_prod
     set "connected_parent" = null,
         "changed" = curr_date
   where "slx_id" = r2.event_id;
end loop;
close c2;
commit;

open c3;
loop
  fetch c3 into r3;
  exit when c3%notfound;
  
  update "schedule"@rms_prod
     set "connected_parent" = null,
         "changed" = curr_date
   where "slx_id" = r3.event_id;
end loop;
close c3;
commit;

end;
/


