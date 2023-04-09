DROP PROCEDURE GKDW.GK_CONF_PROCESS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_process_proc as

cursor c1 is
  select evxevenrollid,email
    from gk_conf_email_mygk_audit
   where result_flag = 'FAILED';

begin
dbms_snapshot.refresh('gk_event_days_mv');

gk_conf_cancel_proc;
gk_conf_canc_sub_ccc_proc; -- SR 11/22/2016
gk_conf_canc_sub_proc;
gk_conf_email_proc;
gk_conf_reminder_proc;
gk_conf_event_change_proc;
gk_conf_facility_change_proc;
gk_conf_dm_reminder_proc;

for r1 in c1 loop
  gk_conf_email_mygk_proc(r1.evxevenrollid,r1.email);
end loop;

if to_char(sysdate,'dd:hh') = '01:01' then
  insert into gk_conf_email_audit_arch
    select ea.*
      from gk_conf_email_audit ea
           inner join event_dim ed on ea.evxeventid = ed.event_id
     where ed.end_date+30 < trunc(sysdate)
       and not exists (select 1 from gk_conf_email_audit_arch eaa where ea.evxevenrollid = eaa.evxevenrollid);

  delete from gk_conf_email_audit ea
   where evxevenrollid in (
         select evxevenrollid from gk_conf_email_audit_arch eaa
          where ea.evxevenrollid = eaa.evxevenrollid);
  commit;
end if;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_PROCESS_PROC Failed',SQLERRM);

end;
/


GRANT EXECUTE ON GKDW.GK_CONF_PROCESS_PROC TO COGNOS_RO;

