DROP PROCEDURE GKDW.GK_CONF_EMAIL_MYGK_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_email_mygk_proc(p_enroll_id varchar2,p_email_address varchar2) as

cursor c1 is
select replace(nvl(ec.txfeeid,ec.evxevenrollid),'Q6UJ9','CONFR') attachment_id,
       ec.evxevenrollid,ec.enrollstatus,ec.createdate,ec.startdate,ec.starttime,ec.enddate,ec.endtime,ec.evxeventid,ec.eventname,ec.contactid,
       ec.firstname,ec.lastname,ec.email,ec.cust_state,ec.cust_country,ec.eventtype,ec.evxfacilityid,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode,
       ec.workphone,ec.evxcourseid,ec.leadsourcedesc,ec.feetype,ec.txfeeid,ec.tzgenericname,ec.tzabbreviation,ec.hour_offset,ec.gmt_hour_offset,ec.hvxuserid,ec.enrollstatusdesc,
       cd.course_code,cd.course_name,cd.short_name,
       case when to_char(ed.start_date,'Mon') = to_char(ed.end_date,'Mon') then to_char(ed.start_date,'Mon dd')||'-'||to_char(ed.end_date,'dd, yyyy') else to_char(ed.start_date,'Mon dd')||' - '||to_char(ed.end_date,'Mon dd, yyyy') end disp_date_range,
       ed.start_date-trunc(sysdate) days_to_start,ec.tzgenericname tz_desc,ed.start_time,ed.end_time,
       to_char(starttime+(ec.hour_offset/24),'hh24miss') cal_start,
       to_char(endtime+(ec.hour_offset/24),'hh24miss') cal_end,
       to_char(to_number(to_char(endtime,'hh24')-to_char(starttime,'hh24'))+to_number((to_char(endtime,'mi')-to_char(starttime,'mi'))/60)) duration,
       cp.dmoc dmoc_flag,ec.channel_partner_flag,cd.pl_num,
       case when (ec.list_price >= 500 or cd.ch_num = '20') and cd.pl_num != '17' and p.channel_keycode is null then 'Y' else 'N' end pe_flag,
       case when cd.md_num in ('32','33','34','44') then 'N'
            when tzgenericname is null then 'N'
            when ec.group_email_address is not null then 'N'
            else 'Y'
       end cal_reminder,
       cd.md_num,
       case when p.channel_email is not null then 'Y'
            when hl.evxeventid is not null then 'Y'
            else 'N'
       end channel_flag,
       case when p.channel_email is not null then p.channel_email
            when hl.evxeventid is not null then hl.channel_poc_email
            when ec.group_email_address is not null then ec.group_email_address
            else ec.email
       end conf_email,
       case when hl.evxeventid is not null then hl.gk_cc1_email
            else p.channel_cc1_email
       end channel_cc1_email,
       case when hl.evxeventid is not null then hl.gk_cc2_email
            else p.channel_cc2_email
       end channel_cc2_email,
       case when hl.evxeventid is not null then hl.channel_keycode
            else ec.leadsourcedesc
       end keycode,
       case when ec.eventtype = 'VCEL' or cd.md_num in ('20','32','33','34','42','44') then 'Y' else 'N' end vcl_flag,
       ec.secondaryemail,
       gk_conf_hdr_func() conf_hdr,
       gk_conf_reg_hdr_func(ed.event_id,'REG') reg_hdr,
       gk_conf_cal_reg_hdr_func(ed.event_id) cal_reg_hdr,
       gk_conf_reg_body_func(ed.event_id,'REG',ec.firstname,cp.dmoc,ec.cust_state,ec.hvxuserid,ec.contactid) reg_body,
       gk_conf_mygk_func(ed.event_id,case when cp.mygk_profile is not null then 'REG' else 'NONMYGK' end,ec.hvxuserid,ec.email,ec.contactid) mygk_access,
       gk_conf_mygk_outlook_func(ed.event_id,case when cp.mygk_profile is not null then 'REG' else 'NONMYGK' end,ec.hvxuserid,ec.contactid) cal_mygk_access,
       gk_conf_num_func(ed.event_id,ec.evxevenrollid) cd_conf_num,
       gk_conf_course_func(ed.event_id) cd_course_name,
       gk_conf_facility_func(ed.event_id,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode) cd_fac_name,
       gk_conf_student_func(ed.event_id,initcap(ec.firstname),initcap(ec.lastname),ec.email) cd_stud_name,
       gk_conf_cust_serv_func(ed.event_id,ec.leadsourcedesc) quest_cust_serv,
       gk_conf_tech_asst_func(ed.event_id,ec.leadsourcedesc) quest_tech_asst,
       gk_conf_addl_res_func(ed.event_id) quest_add_resc
  from gk_enroll_conf_v@slx ec
       inner join event_dim ed on ec.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       left outer join gk_mygk_course_profile_v cp on cd.course_id = cp.course_id
       left outer join gk_channel_partner_conf p on ec.leadsourcedesc = p.channel_keycode
       left outer join gk_conf_onsite_lookup hl on ed.event_id = hl.evxeventid
 where ec.evxevenrollid = p_enroll_id
 order by ec.evxevenrollid;

cursor c2(v_course_id varchar2) is
select *
  from course_specialinfo_v@slx
 where evxcourseid = v_course_id
   and trim(specialinfo) is not null;

cursor c3(v_enroll_id varchar2) is
select '<tr><th align=right>Session '||row_number() over (order by session_date)||':</th><td align=left>'||to_char(session_date,'fmdd-Mon-YYYY')||' '||nvl(session_start,start_time)||'-'||nvl(session_end,end_time)||' '||ec.tzgenericname||'</td></tr>' session_line
  from gk_event_days_mv e
       inner join gk_enroll_conf_v@slx ec on e.event_id = ec.evxeventid
where ec.evxevenrollid = v_enroll_id
order by session_date,session_start;

v_msg_body long;
r2 c2%rowtype;
r3 c3%rowtype;
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop

/******* ENROLLMENT EMAIL ********/
  v_msg_body := r1.conf_hdr;
  v_msg_body := v_msg_body||r1.reg_hdr;
  v_msg_body := v_msg_body||r1.reg_body;
  v_msg_body := v_msg_body||r1.mygk_access;
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

  send_mail('ConfirmAdmin.NAm@globalknowledge.com',p_email_address,'Important Course Access Details from Global Knowledge ('||r1.evxevenrollid||')',v_msg_body); 

end loop;

insert into gk_conf_email_mygk_audit
  select p_enroll_id,p_email_address,'SUCCESS',sysdate from dual;

delete from gk_conf_email_mygk_audit where evxevenrollid = p_enroll_id and result_flag = 'FAILED';

commit;
  
exception
  when others then
    rollback;

    insert into gk_conf_email_mygk_audit
      select p_enroll_id,p_email_address,'FAILED',sysdate from dual
       where not exists (select 1 from gk_conf_email_mygk_audit a where p_enroll_id = a.evxevenrollid);
    commit;
    
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_EMAIL_MYGK_PROC Failed',p_enroll_id||'|'||p_email_address||'|'||SQLERRM);

end;
/


GRANT EXECUTE ON GKDW.GK_CONF_EMAIL_MYGK_PROC TO COGNOS_RO;

