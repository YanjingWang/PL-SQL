DROP PROCEDURE GKDW.GK_UPD_EVENT_MEETING_DAYS;

CREATE OR REPLACE PROCEDURE GKDW.gk_upd_event_meeting_days
as
cursor c1 is
select event_id,start_date,start_time,end_time,--adj_meeting_days,
(CASE
                          WHEN     ed.end_time LIKE '%PM'
                               AND SUBSTR (ed.end_time, 1, 2) < '12'
                          THEN
                             TO_NUMBER (SUBSTR (ed.end_time, 1, 2)) + 12
                          WHEN     ed.end_time LIKE '%AM'
                               AND ed.start_time LIKE '%PM'
                               AND SUBSTR (ed.end_time, 1, 2) < '12'
                          THEN
                             TO_NUMBER (SUBSTR (ed.end_time, 1, 2)) + 12
                          WHEN      ed.end_time LIKE '%PM'
                            AND ED.START_TIME LIKE '%AM'
                               AND SUBSTR (ed.end_time, 1, 2) = '12'
                               AND SUBSTR (ed.START_time, 1, 2) = '12'
                           THEN 24
                          ELSE
                             TO_NUMBER (SUBSTR (ed.end_time, 1, 2))
                       END
                     + CASE
                          WHEN SUBSTR (ed.end_time, 4, 2) = '15' THEN .25
                          WHEN SUBSTR (ed.end_time, 4, 2) = '30' THEN .5
                          WHEN SUBSTR (ed.end_time, 4, 2) = '45' THEN .75
                          ELSE .0
                       END  )-
 (CASE
                          WHEN     ed.start_time LIKE '%PM'
                               AND ed.end_time NOT LIKE '%AM'
                               AND SUBSTR (ed.start_time, 1, 2) < '12'
                          THEN
                             TO_NUMBER (SUBSTR (ed.start_time, 1, 2)) + 12
                          WHEN     ed.end_time LIKE '%AM'
                               AND ed.start_time LIKE '%PM'
                          THEN
                             TO_NUMBER (SUBSTR (ed.start_time, 1, 2))
                          ELSE
                             TO_NUMBER (SUBSTR (ed.start_time, 1, 2))
                       END
                     + CASE
                          WHEN SUBSTR (ed.start_time, 4, 2) = '15' THEN .25
                          WHEN SUBSTR (ed.start_time, 4, 2) = '30' THEN .5
                          WHEN SUBSTR (ed.start_time, 4, 2) = '45' THEN .75
                          ELSE .0
                       END) total_hrs
from event_dim ed
where ADJ_MEETING_DAYS is null
and gkdw_source = 'SLXDW';

r1 c1%rowtype;

begin
for r1 in c1 loop
update event_dim
set adj_meeting_days =
case when r1.total_hrs <=2 then .25
when r1.total_hrs <=4 then .5
when r1.total_hrs <=6 then .75
else 1
end
where event_id = r1.event_id;

end loop;
commit;

Exception
when others then 
rollback;
send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_upd_event_meeting_days Failed',SQLERRM);
end;
/


