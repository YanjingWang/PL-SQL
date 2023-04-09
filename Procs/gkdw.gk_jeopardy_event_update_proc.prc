DROP PROCEDURE GKDW.GK_JEOPARDY_EVENT_UPDATE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_jeopardy_event_update_proc as
cursor c0 is
  select e.evxeventid event_id,'N/A' new_jeopardy_flag
    from evxevent@slx e
   where jeopardyflag in ('Consolidate','SIJ','Running','GTR')
   and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = e.evxeventid) -- SR 06/25/2018
     and e.eventstatus = 'Cancelled';

cursor c1 is
  select cc.event_id,cc.rev_amt,cc.total_cost,cc.enroll_cnt,cc.margin,cc.needed_rev_amt,
         ed.facility_region_metro,ed.course_code,ed.start_date,cc.jeopardy_flag new_jeopardy_flag,s.jeopardyflag,
         'Event ID: '||cc.event_id||'('||ed.course_code||'-'||to_char(ed.start_date,'yyyymmdd')||'-'||ed.facility_region_metro||') changed from '||s.jeopardyflag||' to '||cc.jeopardy_flag v_line
    from gk_rms_color_coding_v cc,
         evxevent@slx s,
         event_dim ed,
         course_dim cd
   where cc.event_id = s.evxeventid
     and cc.event_id = ed.event_id
     and ed.course_id = cd.course_id and ed.ops_country = cd.country -- SR 11/12/2018
     and cc.jeopardy_flag != s.jeopardyflag
     and s.jeopardyflag not in ('Consolidate','Running')
     and cd.course_pl not in ('VMWARE') -- 11/12/2018 3610
     and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = s.evxeventid) -- SR 06/25/2018
   order by ed.start_date;
   
cursor c3 is
  select evxeventid event_id
    from evxevent@slx e,
         event_dim ed,
         course_dim cd
   where e.evxeventid = ed.event_id
     and ed.course_id = cd.course_id and ed.ops_country = cd.country
     and maxenrollment = 0
     and cd.ch_num = '10'
     and cd.md_num in ('10','20')
     and eventstatus = 'Open'
     and jeopardyflag not in ('Consolidate','Running')
     and cd.course_pl not in ('VMWARE') -- 11/12/2018 3610
     and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = e.evxeventid) -- SR 06/25/2018
     and ed.start_date >= trunc(sysdate);
     
cursor c4 is
  select evxeventid event_id
    from evxevent@slx e,
         event_dim ed,
         course_dim cd
   where e.evxeventid = ed.event_id
     and ed.course_id = cd.course_id and ed.ops_country = cd.country
     and cd.ch_num = '10'
     and cd.md_num in ('10','20')
     and eventstatus = 'Open'
     and jeopardyflag not in ('Running','GTR')
     and cd.course_pl not in ('VMWARE') -- 11/12/2018 3610
     and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = e.evxeventid) -- SR 06/25/2018
     and ed.start_date between trunc(sysdate)-10 and trunc(sysdate);
     
cursor c5 is
  select distinct event_id 
    from gk_gtr_events ge,
         evxevent@slx e,
         course_dim cd -- 11/12/2018
   where ge.event_id = e.evxeventid
  and e.coursecode = cd.course_code -- 11/12/2018
     and e.eventstatus = 'Open'
     and cd.course_pl not in ('VMWARE') -- 11/12/2018 3610
     and not exists (select 1 from gk_gtr_events_exclude ee where ee.event_id = e.evxeventid) -- SR 06/25/2018
     and e.jeopardyflag not in ('GTR');


v_file utl_file.file_type;
v_file_name varchar2(50);
v_file_full varchar2(250);
f_name varchar2(100);
v_error number;
v_error_msg varchar2(500);
v_mail_flag varchar2(1) := 'N';
change_date varchar2(50);
r0 c0%rowtype;
r1 c1%rowtype;
r3 c3%rowtype;
r4 c4%rowtype;
r5 c5%rowtype;

begin
rms_link_set_proc;

v_file_name := 'slx_jeopardy.log';
v_file_full := '/usr/tmp/'||v_file_name;
v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') into change_date from dual;

open c0;
loop
  fetch c0 into r0;
  exit when c0%notfound;
  update "schedule"@rms_prod
     set "jeopardyflag" = r0.new_jeopardy_flag,
     "comment" = 'GTR AUTO - GKDW',
         "changed" = change_date
   where "slx_id" = r0.event_id;
  dbms_output.put_line(r0.event_id);
end loop;
close c0;
commit;

open c4;
loop
  fetch c4 into r4;
  exit when c4%notfound;
  update "schedule"@rms_prod
     set "jeopardyflag" = 'Running',
     "comment" = 'GTR AUTO - GKDW',
         "changed" = change_date
   where "slx_id" = r4.event_id;
  utl_file.put_line(v_file,r4.event_id||' Set to Running because within 10 days of start date.');
  v_mail_flag := 'Y';
end loop;
close c4;
commit;

open c5;
loop
  fetch c5 into r5;
  exit when c5%notfound;
  update "schedule"@rms_prod
     set "jeopardyflag" = 'GTR',
     "comment" = 'GTR AUTO - GKDW',
         "changed" = change_date
   where "slx_id" = r5.event_id;
  utl_file.put_line(v_file,r5.event_id||' Set to Running because event is designated GTR.');
  v_mail_flag := 'Y';
end loop;
close c5;
commit;

utl_file.fclose(v_file);

exception
  when others then
    rollback;
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_JEOPARDY_EVENT_UPDATE_PROC Failed',SQLERRM);
end;
/


