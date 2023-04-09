DROP PROCEDURE GKDW.GK_CONF_SUPPRESS_EVENT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_suppress_event_proc(p_event_id varchar2,p_flag varchar) is

begin

if p_flag = 'FDC' then
  insert into mygk_event_conf_exclude
  select ed.event_id
    from slxdw.gk_onsitereq_courses c
         inner join event_dim ed on c.evxeventid = ed.event_id
   where gk_onsitereq_fdcid = p_event_id
     and not exists (select 1 from mygk_event_conf_exclude ce where c.evxeventid = ce.event_id);

  dbms_output.put_line('FDC: '||p_event_id||' successfully saved in mygk_event_conf_exclude.');

elsif p_flag = 'IDR' then
  insert into mygk_event_conf_exclude
  select ed.event_id
    from slxdw.gk_onsitereq_courses c
         inner join event_dim ed on c.evxeventid = ed.event_id
   where gk_onsitereq_idrid = p_event_id
     and not exists (select 1 from mygk_event_conf_exclude ce where c.evxeventid = ce.event_id);  
  
  dbms_output.put_line('IDR: '||p_event_id||' successfully saved in mygk_event_conf_exclude.');

elsif p_flag = 'ORDER' then
  insert into mygk_event_conf_exclude
  select ed.event_id
    from order_fact f
         inner join event_dim ed on f.event_id = ed.event_id
   where f.enroll_id = p_event_id
     and not exists (select 1 from mygk_event_conf_exclude ce where ed.event_id = ce.event_id);  
  
  dbms_output.put_line('IDR: '||p_event_id||' successfully saved in mygk_event_conf_exclude.');
  
elsif p_flag = 'EVENT' then
  insert into mygk_event_conf_exclude
  select ed.event_id
    from event_dim ed
   where event_id = p_event_id
     and not exists (select 1 from mygk_event_conf_exclude ce where ed.event_id = ce.event_id);
  
  dbms_output.put_line('Event: '||p_event_id||' successfully saved in mygk_event_conf_exclude.');
else
  dbms_output.put_line('Nothing saved in mygk_event_conf_exclude.');
end if;

commit;

end;
/


