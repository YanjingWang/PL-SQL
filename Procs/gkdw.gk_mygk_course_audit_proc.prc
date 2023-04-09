DROP PROCEDURE GKDW.GK_MYGK_COURSE_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_mygk_course_audit_proc as

cursor c0 is
select cd.course_pl,cd.course_code,nvl(mfg_course_code,short_name) mfg_course_code,course_name,duration_days,min(start_date) next_start_date
  from course_dim cd
       inner join event_dim ed on cd.course_id = ed.course_id and cd.country = ed.ops_country and ed.status = 'Open'
 where cd.pl_num in ('02','03','04','06','08','09','10','11','13','14','15','17','19','20')
   and cd.md_num in ('10','20')
   and substr(cd.course_code,1,4) not in ('7016','7196','3639','7106','4508','9989')
   and substr(cd.course_code,5,1) in ('C','N','L','V','Z') /** ADDED FOR CISCO COURSE ISSUES **/
   and ed.end_date >= trunc(sysdate)
   and not exists (select 1 from gk_mygk_course_profile_v l where cd.course_code = l.course_code)
 group by cd.course_pl,cd.course_code,nvl(mfg_course_code,short_name),cd.course_code,course_name,duration_days,cd.pl_num
 order by next_start_date,course_pl,course_code;

v_msg_body long;
v_msg_body1 long;
v_email_flag varchar2(1) := 'N';

begin

v_msg_body := '<html><head></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=2 cellpadding=2 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th>Product Line</th><th>Course Code</th><th>MFG Course Code</th><th>Course Name</th><th>Duration Days</th><th>Next Event</th></tr>';

for r0 in c0 loop
  v_msg_body := v_msg_body||'<tr align=left><td>'||r0.course_pl||'</td><td>'||r0.course_code||'</td><td>'||r0.mfg_course_code||'</td><td>'||r0.course_name||'</td><td>'||r0.duration_days||'</td><td>'||r0.next_start_date||'</td></tr>';
  v_email_flag := 'Y';
end loop;
commit;

v_msg_body := v_msg_body||'</table><p>';
v_msg_body := v_msg_body||'</body></html>';


if v_email_flag = 'Y' then
  send_mail('DW.Automation@globalknowledge.com','travis.brisbon@globalknowledge.com','MyGK Course Profile Additions',v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','Fulfillment.US@globalknowledge.com','MyGK Course Profile Additions',v_msg_body);
end if;

end;
/


