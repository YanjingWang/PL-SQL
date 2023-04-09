DROP PROCEDURE GKDW.GK_UPDATE_CONNECTED_EVENTS;

CREATE OR REPLACE PROCEDURE GKDW.gk_update_connected_events as

cursor c1 is
select event_id,connected_c,connected_v_to_c 
  from gk_connected_class_v
minus
select event_id,connected_c,connected_v_to_c
  from event_dim;
  
cursor c2 is
select event_id,connected_c,connected_v_to_c
  from event_dim ed
 where connected_c = 'Y'
   and not exists (select 1 from gk_connected_class_v cc where ed.event_id = cc.event_id);

cursor c3 is
select event_id,connected_c,connected_v_to_c
  from event_dim ed
 where connected_v_to_c is not null
   and not exists (select 1 from gk_connected_class_v cc where ed.event_id = cc.event_id);
   
begin

for r1 in c1 loop
  update event_dim
     set connected_c = r1.connected_c,
         connected_v_to_c = r1.connected_v_to_c
   where event_id = r1.event_id;
end loop;
commit;

for r2 in c2 loop
  update event_dim
     set connected_c = null
   where event_id = r2.event_id;
end loop;
commit;

for r3 in c3 loop
  update event_dim
     set connected_v_to_c = null
   where event_id = r3.event_id;
end loop;
commit;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_UPDATE_CONNECTED_EVENTS FAILED',SQLERRM);
    
end;
/


