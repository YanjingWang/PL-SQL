DROP PROCEDURE GKDW.GK_CONF_REMINDER_PROC_SB_TEST;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_reminder_proc_sb_test as

cursor c1 is
select distinct replace(ec.txfeeid,'Q6UJ9','REMND') attachment_id,
       ec.evxevenrollid,ec.enrollstatus,ec.createdate,ec.startdate,ec.starttime,ec.enddate,ec.endtime,ec.evxeventid,ec.eventname,ec.contactid,
       ec.firstname,ec.lastname,ec.email,ec.eventtype,ec.evxfacilityid,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode,
       ec.workphone,ec.evxcourseid,ec.leadsourcedesc,ec.feetype,ec.txfeeid,ec.tzgenericname,ec.tzabbreviation,ec.hour_offset,ec.gmt_hour_offset,ec.hvxuserid,ec.enrollstatusdesc,
       cd.course_code,cd.course_name,cd.short_name,
       case when ed.start_date = ed.end_date then to_char(ed.start_date,'Mon dd, yyyy')
            when to_char(ed.start_date,'Mon') = to_char(ed.end_date,'Mon') then to_char(ed.start_date,'Mon dd')||'-'||to_char(ed.end_date,'dd, yyyy')
            else to_char(ed.start_date,'Mon dd')||' - '||to_char(ed.end_date,'Mon dd, yyyy')
       end disp_date_range,cd.pl_num,
       ed.start_date-trunc(sysdate) days_to_start,
       ec.tzgenericname tz_desc,
       ed.start_time,ed.end_time,
       to_char(starttime+(ec.hour_offset/24),'hh24miss') cal_start,
       to_char(endtime+(ec.hour_offset/24),'hh24miss') cal_end,
       to_char(to_number(to_char(endtime,'hh24')-to_char(starttime,'hh24'))+to_number((to_char(endtime,'mi')-to_char(starttime,'mi'))/60)) duration,
       cp.dmoc dmoc_flag,
       case when cd.ch_num = '10' and cd.md_num = '10' then 'Classroom Live course'
            when cd.ch_num = '10' and cd.md_num = '20' then 'Virtual Classroom Live course'
            when cd.ch_num = '20' and cd.md_num = '10' then 'onsite group training'
            when cd.ch_num = '20' and cd.md_num = '20' then 'virtual group training'
       end offer_type,
       cd.md_num,
       case when p.channel_email is not null then p.channel_email
            when hl.evxeventid is not null then hl.channel_poc_email
            when ec.group_email_address is not null then ec.group_email_address
            else ec.email
       end conf_email,
       ec.secondaryemail,
       case when ec.eventtype = 'VCEL' or cd.md_num in ('20','32','33','34','42','44') then 'Y' else 'N' end vcl_flag,
       gk_conf_hdr_func() conf_hdr,
       gk_conf_reg_hdr_func(ed.event_id,'REM') rem_hdr,
       gk_conf_reg_body_func(ed.event_id,'REM',ec.firstname,cp.dmoc,null,ec.hvxuserid,ec.contactid) rem_body,
       gk_conf_num_func(ed.event_id,ec.evxevenrollid) cd_conf_num,
       gk_conf_course_func(ed.event_id) cd_course_name,
       gk_conf_facility_func(ed.event_id,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode) cd_fac_name,
       gk_conf_student_func(ed.event_id,initcap(ec.firstname),initcap(ec.lastname),ec.email) cd_stud_name,
       gk_conf_cust_serv_func(ed.event_id,ec.leadsourcedesc) quest_cust_serv,
       gk_conf_tech_asst_func(ed.event_id,ec.leadsourcedesc) quest_tech_asst,
       gk_conf_addl_res_func(ed.event_id) quest_add_resc
  from gk_enroll_reminder_v@slx ec
       inner join gk_conf_email_audit ea on ec.evxevenrollid = ea.evxevenrollid
       inner join event_dim ed on ec.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       left outer join (select distinct course_id,mygk_profile,'Y' dmoc from gk_mygk_course_profile_v) cp on cd.course_id = cp.course_id
       left outer join gk_channel_partner_conf p on ec.leadsourcedesc = p.channel_keycode
       left outer join gk_conf_onsite_lookup hl on ed.event_id = hl.evxeventid
 where ec.enrollstatus = 'Confirmed'
 and ec.evxevenrollid ='Q6UJ90B8PA24'
  -- and ed.start_date >= trunc(sysdate)+7
   and facilityname != 'Location to be Determined'
   and ec.email is not null
  -- and ea.reminder_date is null
   and ea.channel_flag = 'N'
   and not exists (select 1 from mygk_event_conf_exclude mc where ed.event_id = mc.event_id)
   order by evxevenrollid;

cursor c2(v_course_id varchar2) is
select *
  from course_specialinfo_v@slx
 where evxcourseid = v_course_id
   and trim(specialinfo) is not null;

cursor c3(v_enroll_id varchar2) is
select '<tr><th align=right>Session '||row_number() over (order by session_date)||':</th><td align=left>'||to_char(session_date,'fmdd-Mon-YYYY')||' '||nvl(session_start,start_time)||'-'||nvl(session_end,end_time)||' '||ec.tzgenericname||'</td></tr>' session_line
  from gk_event_days_mv e
       inner join gk_enroll_reminder_v@slx ec on e.event_id = ec.evxeventid
where ec.evxevenrollid = v_enroll_id
order by session_date,session_start;

v_msg_body long;
v_file_name varchar2(250);
v_file utl_file.file_type;
v_attach_desc varchar2(500);
v_curr_time varchar2(250);
r2 c2%rowtype;
r3 c3%rowtype;
v_attach_cnt number := 0;
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop

  select r1.evxevenrollid||'_RemindLetter_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-Event-Remind-Email--Conf#-'||r1.evxevenrollid||'-('||r1.firstname||'-'||r1.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');


/******* REMINDER EMAIL ********/
  v_msg_body := r1.conf_hdr;
  v_msg_body := v_msg_body||r1.rem_hdr;
  v_msg_body := v_msg_body||r1.rem_body;
  v_msg_body := v_msg_body||r1.cd_conf_num;
  v_msg_body := v_msg_body||r1.cd_course_name;
  open c3(r1.evxevenrollid);fetch c3 into r3;
  if c3%found then
    v_msg_body := v_msg_body||'<tr><td colspan=2 align=left><p><hr align="left"></td></tr>';
  end if;
  close c3;
  for r3 in c3(r1.evxevenrollid) loop
    v_msg_body := v_msg_body||r3.session_line;
  end loop;
  if r1.vcl_flag = 'N' then
    v_msg_body := v_msg_body||r1.cd_fac_name;
  end if;
  v_msg_body := v_msg_body||r1.cd_stud_name;
  v_msg_body := v_msg_body||r1.quest_cust_serv;
  v_msg_body := v_msg_body||r1.quest_tech_asst;
  v_msg_body := v_msg_body||r1.quest_add_resc;
  v_msg_body := v_msg_body||v_html_end;

/******* Additional Information **********/
  open c2(r1.evxcourseid);fetch c2 into r2;
  if c2%found and nvl(r1.pl_num,'00') != '19' then
    v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';
    v_msg_body := v_msg_body||'<tr><th colspan=2 align=left><font color="CE9900" size=4>Additional Information</font></th></tr>';
    v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';
    v_msg_body := v_msg_body||'<tr><td align=left colspan=2>'||replace(replace(r2.specialinfo,'</HTML>',''),'<HTML>','')||'</td></tr>';
    v_msg_body := v_msg_body||'<tr><td colspan=2 align=left>&nbsp</td></tr>';
  end if;
  close c2;

  v_msg_body := v_msg_body||v_html_end;

  send_mail('ConfirmAdmin.NAm@globalknowledge.com','smaranika.baral@globalknowledge.com','CC-Your Global Knowledge course is next week',v_msg_body);
  

end loop;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','smaranika.baral@globalknowledge.com','GK_CONF_REMINDER_PROC Failed',SQLERRM);
--    send_mail('alan.frelich@globalknowledge.com','alan.frelich@globalknowledge.com','GK_CONF_EMAIL_PROC Failed',SQLERRM);

end;
/


