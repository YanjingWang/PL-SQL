DROP PROCEDURE GKDW.GK_SPACE_AVAIL_NOTIFY_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_space_avail_notify_proc as

cursor c0 is
select ee.evxeventid,ee.eventstatus,ee.coursecode,ee.maxenrollment,ee.startdate,ed.facility_region_metro,
       me.enroll_cnt orig_enroll_cnt,count(eh.evxevenrollid) curr_enroll_cnt
 from evxevent@slx ee,
      evxenrollhx@slx eh,
      event_dim ed,
      course_dim cd,
      gk_max_enroll_events me
where ee.evxeventid = eh.evxeventid
and ee.evxeventid = ed.event_id
and ed.course_id = cd.course_id and ed.ops_country = cd.country
and ee.evxeventid = me.evxeventid
and ee.eventstatus = 'Open'
and eh.enrollstatus = 'Confirmed'
and cd.ch_num = '10'
and cd.md_num in ('10','20')
group by ee.evxeventid,ee.eventstatus,ee.coursecode,ee.maxenrollment,ee.startdate,ed.facility_region_metro,
         me.maxenrollment,me.enroll_cnt
having count(eh.evxevenrollid) < me.enroll_cnt and count(eh.evxevenrollid) < ee.maxenrollment;

v_msg_body long;
v_mail_hdr varchar2(500) := 'Event Enrollment Space Available';
v_email_flag varchar2(1) := 'N';


begin

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=9>Enrollment Space Now Available For:</th></tr>';
v_msg_body := v_msg_body||'<tr><th>Event ID</th><th>Course Code</th><th>Start Date</th><th>Metro</th><th>Cap</th><th>Enroll Cnt</th></tr>';

for r0 in c0 loop
  v_msg_body := v_msg_body||'<tr align="center"><td>'||r0.evxeventid||'</td><td>'||r0.coursecode||'</td><td>'||r0.startdate||'</td>';
  v_msg_body := v_msg_body||'<td>'||r0.facility_region_metro||'</td><td>'||r0.maxenrollment||'</td><td>'||r0.curr_enroll_cnt||'</td></tr>';
  v_email_flag := 'Y';
end loop;

v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';

if v_email_flag = 'Y' then
  send_mail('DW.Automation@globalknowledge.com','jack.broeren@globalknowledge.com',v_mail_hdr,v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','krissi.fields@globalknowledge.com',v_mail_hdr,v_msg_body);
end if;

delete from gk_max_enroll_events;

insert into gk_max_enroll_events
select ee.evxeventid,ee.eventstatus,ee.coursecode,ee.maxenrollment,ee.startdate,ed.facility_region_metro,
       count(eh.evxevenrollid) enroll_cnt
 from evxevent@slx ee,
      evxenrollhx@slx eh,
      event_dim ed,
      course_dim cd
where ee.evxeventid = eh.evxeventid
and ee.evxeventid = ed.event_id
and ed.course_id = cd.course_id and ed.ops_country = cd.country
and ee.eventstatus = 'Open'
and eh.enrollstatus = 'Confirmed'
and cd.ch_num = '10'
and cd.md_num in ('10','20')
group by ee.evxeventid,ee.eventstatus,ee.coursecode,ee.maxenrollment,ee.startdate,ed.facility_region_metro
having count(eh.evxevenrollid) = ee.maxenrollment;
commit;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_SPACE_AVAIL_NOTIFY_PROC FAILED','Check Procedure');

end;
/


