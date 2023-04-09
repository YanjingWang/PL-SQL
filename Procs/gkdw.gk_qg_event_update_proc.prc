DROP PROCEDURE GKDW.GK_QG_EVENT_UPDATE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_qg_event_update_proc as

cursor c0 is
select ee.evxeventid 
  from qg_event@slx qe
       inner join evxevent@slx ee on qe.evxeventid = ee.evxeventid
where ee.startdate >= trunc(sysdate)
  and (connected_c is not null or connected_v_to_c is not null);

cursor c1 is
select event_id,connected_c 
from event_dim
where start_date >= trunc(sysdate)
and connected_c is not null;

cursor c2 is
select event_id,connected_v_to_c 
from event_dim
where start_date >= trunc(sysdate)
and connected_v_to_c is not null;

begin

for r0 in c0 loop
  update qg_event@slx
     set connected_c = null,
         connected_v_to_c = null
   where evxeventid = r0.evxeventid;
end loop;
commit;

for r1 in c1 loop
  update qg_event@slx
     set connected_c = r1.connected_c
   where evxeventid = r1.event_id;
end loop;
commit;

for r2 in c2 loop
  update qg_event@slx
     set connected_v_to_c = r2.connected_v_to_c
   where evxeventid = r2.event_id;
end loop;
commit;


/** MANUAL UPDATE FOR N+V EVENT **/
update event_dim
   set connected_c = 'Y'
where event_id in ('Q6UJ9AS5YHYW','Q6UJ9AS5YEDX');

update event_dim
   set connected_v_to_c = 'Q6UJ9AS5YHYW'
 where event_id = 'Q6UJ9AS5YHYV';
 
update event_dim
   set connected_v_to_c = 'Q6UJ9AS5YEDX'
 where event_id = 'Q6UJ9AS5YEDW';
commit;

update qg_event@slx
   set connected_c = 'Y'
where evxeventid in ('Q6UJ9AS5YHYW','Q6UJ9AS5YEDX');
commit;

update qg_event@slx
   set connected_v_to_c = 'Q6UJ9AS5YHYW'
 where evxeventid = 'Q6UJ9AS5YHYV';
 
update qg_event@slx
   set connected_v_to_c = 'Q6UJ9AS5YEDX'
 where evxeventid = 'Q6UJ9AS5YEDW';
commit;
   

end;
/


