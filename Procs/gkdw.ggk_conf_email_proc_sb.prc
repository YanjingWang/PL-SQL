DROP PROCEDURE GKDW.GGK_CONF_EMAIL_PROC_SB;

CREATE OR REPLACE PROCEDURE GKDW.Ggk_conf_email_proc_sb as

cursor c1 is
select distinct replace(nvl(ec.txfeeid,ec.evxevenrollid),'Q6UJ9','CONFR') attachment_id,
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
       nvl(ed.extended_event,'N') ext_event,
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
       gk_conf_mygk_Refer_friend Refer_a_friend, -- SR  ticket# 139495 
  --   case when cd.md_num = '33' then null else gk_conf_mygk_survey_func(ed.event_id,ec.contactid) end event_survey, -- SR 09/19/2017 Added the new case statement --SR  removed on 01/09/2018 ticket# 139495 
       gk_conf_cust_serv_func(ed.event_id,ec.leadsourcedesc) quest_cust_serv,
       gk_conf_tech_asst_func(ed.event_id,ec.leadsourcedesc) quest_tech_asst,
       gk_conf_addl_res_func(ed.event_id) quest_add_resc
  from gk_enroll_conf_v@slx ec
       inner join event_dim ed on ec.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       left outer join (select distinct course_id,mygk_profile,'Y' dmoc from gk_mygk_course_profile_v) cp on cd.course_id = cp.course_id
       left outer join gk_channel_partner_conf p on ec.leadsourcedesc = p.channel_keycode
       left outer join gk_conf_onsite_lookup hl on ed.event_id = hl.evxeventid
 where ec.evxevenrollid not in ('Q6UJ90APLWWT','QGKID0ATPV06','Q6UJ90AZLVL6','QGKID0B06G4F','Q6UJ90B0BSEV')--'Q6UJ90A54NKN','QGKID0AG4KQZ') --, 'Q6UJ90AL309H')  
   and ec.enrollstatus = 'Confirmed'
   and ed.end_date >= trunc(sysdate)
   and cd.md_num is not null
   and facilityname != 'Location to be Determined'
   and ec.email is not null
   and not exists (select 1 from mygk_event_conf_exclude mc where ed.event_id = mc.event_id)
   and not exists (select 1 from gk_conf_email_audit ea where ec.evxevenrollid = ea.evxevenrollid)
   and not exists (select 1 from gk_conf_course_exclude cc where cd.course_code = cc.course_code)
   and not exists (select 1 from gk_conf_letter_exclude_v@slx le where cd.course_code = le.coursecode)
   and not exists (select 1 from course_dim cd1 where cd.course_code = cd1.course_code and cd1.md_num = '32' and cd1.pl_num = '19' and substr(upper(ec.cust_country),1,2) not in ('US','CA'))
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
v_file_name varchar2(250);
v_file utl_file.file_type;
v_attach_desc varchar2(500);
v_curr_time varchar2(250);
v_ical_event varchar2(32767);
r2 c2%rowtype;
r3 c3%rowtype;
v_attach_cnt number := 0;
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop
begin

--  select r1.evxevenrollid||'_ConfLetter_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
--    into v_file_name
--    from dual;

      select r1.evxevenrollid||'_ConfLetter_'||to_char(sysdate,'yyyy-mm-dd')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-Event-Conf-Email--Conf#-'||r1.evxevenrollid||'-('||r1.firstname||'-'||r1.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

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
  v_msg_body := v_msg_body||r1.refer_a_friend; -- SR 01/09/2018
  --v_msg_body := v_msg_body||r1.event_survey; -- SR 05/09/2017
  v_msg_body := v_msg_body||r1.quest_cust_serv;
  v_msg_body := v_msg_body||r1.quest_tech_asst;
  v_msg_body := v_msg_body||r1.quest_add_resc;

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

  send_mail_sb('ConfirmAdmin.NAm@globalknowledge.com','Confirmation.Test@globalknowledge.com','CC-Important Course Access Details from Global Knowledge ('||r1.evxevenrollid||')',v_msg_body);
  send_mail_sb('ConfirmAdmin.NAm@globalknowledge.com',r1.conf_email,'Important Course Access Details from Global Knowledge ('||r1.evxevenrollid||')',v_msg_body);
  if r1.secondaryemail is not null then
    send_mail_sb('ConfirmAdmin.NAm@globalknowledge.com',r1.secondaryemail,'Important Course Access Details from Global Knowledge ('||r1.evxevenrollid||')',v_msg_body);
  end if;
  if r1.channel_flag = 'Y' then
    send_mail_sb('ConfirmAdmin.NAm@globalknowledge.com',r1.channel_cc1_email,'Global Knowledge Order Confirmation ('||r1.evxevenrollid||'-'||r1.firstname||' '||r1.lastname||'-'||r1.course_code||')',v_msg_body);
    send_mail_sb('ConfirmAdmin.NAm@globalknowledge.com',r1.channel_cc2_email,'Global Knowledge Order Confirmation ('||r1.evxevenrollid||'-'||r1.firstname||' '||r1.lastname||'-'||r1.course_code||')',v_msg_body);
  end if;

/******* OUTLOOK ENROLLMENT ********/
  if r1.cal_reminder = 'Y' and r1.channel_flag = 'N' then

    v_msg_body := r1.conf_hdr;
    v_msg_body := v_msg_body||r1.cal_reg_hdr;
    v_msg_body := v_msg_body||r1.cal_mygk_access;
    v_msg_body := v_msg_body||r1.cd_conf_num;
    v_msg_body := v_msg_body||r1.cd_course_name;
    for r3 in c3(r1.evxevenrollid) loop
      v_msg_body := v_msg_body||r3.session_line;
    end loop;
    if r1.vcl_flag = 'N' then
      v_msg_body := v_msg_body||r1.cd_fac_name;
    end if;
    v_msg_body := v_msg_body||r1.cd_stud_name;
    v_msg_body := v_msg_body||r1.refer_a_friend; -- SR 01/09/2018
   -- v_msg_body := v_msg_body||r1.event_survey; -- SR 05/08/2017
    v_msg_body := v_msg_body||r1.quest_cust_serv;
    v_msg_body := v_msg_body||r1.quest_tech_asst;
    v_msg_body := v_msg_body||r1.quest_add_resc;
    v_msg_body := v_msg_body||v_html_end;

    v_ical_event := ical_event_new(
                    p_event_id      => r1.evxeventid,
                    p_prodid        => r1.evxevenrollid,
                    p_method        => 'REQUEST',
                    p_start_date    => r1.startdate,
                    p_end_date      => r1.enddate,
                    p_start_time    => r1.cal_start,
                    p_end_time      => r1.cal_end,
                    p_summary       => r1.eventname,
                    p_location      => r1.facilityname,
                    p_sequence      => 0,
                    p_organizer_name => 'Global Knowledge',
                    p_organizer_email => 'ConfirmAdmin.NAm@globalknowledge.com',
                    p_attendee_name => r1.firstname||' '||r1.lastname,
                    p_attendee_email => r1.conf_email);

    send_ical_email_sb('ConfirmAdmin.NAm@globalknowledge.com',r1.conf_email,'Global Knowledge Training Event ('||r1.evxevenrollid||')',v_msg_body,v_ical_event);

  end if;

  insert into gk_conf_email_audit(evxevenrollid,evxeventid,contactid,enrollstatus,evxfacilityid,conf_email,conf_date,reminder_date,channel_flag,channel_keycode,
                                  channel_email,start_time,end_time,ext_event,timezone,pe_flag,dm_rem_flag,start_date,end_date)
    select r1.evxevenrollid,r1.evxeventid,r1.contactid,r1.enrollstatus,r1.evxfacilityid,r1.conf_email,sysdate,
           case when r1.md_num in ('32','33','34','44') then sysdate
                when r1.days_to_start > 7 then null
                when r1.cal_reminder = 'N' then sysdate
                else sysdate
           end,
           r1.channel_flag,
           case when r1.channel_flag = 'Y' then r1.keycode else null end,
           case when r1.channel_flag = 'Y' then r1.conf_email else null end,
           to_char(r1.starttime,'hh:mi:ss AM'),to_char(r1.endtime,'hh:mi:ss AM') ,
           r1.ext_event,r1.tzabbreviation,
           r1.pe_flag,'N',r1.startdate,r1.enddate
      from dual;
  commit;

/******* ENROLLMENT ATTACHMENT ********/
  v_file := utl_file.fopen('/mnt/nc10s079',v_file_name,'w',32767);
--  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w',32767);

  utl_file.put_line(v_file,r1.conf_hdr);
  utl_file.put_line(v_file,r1.reg_hdr);
  utl_file.put_line(v_file,r1.reg_body);
  utl_file.put_line(v_file,r1.mygk_access);
  utl_file.put_line(v_file,r1.cd_conf_num);
  utl_file.put_line(v_file,r1.cd_course_name);
  for r3 in c3(r1.evxevenrollid) loop
    utl_file.put_line(v_file,r3.session_line);
  end loop;
  if r1.vcl_flag = 'N' --r1.eventtype != 'VCEL' SR 04/25/2017
   then
    utl_file.put_line(v_file,r1.cd_fac_name);
  end if;
  utl_file.put_line(v_file,r1.cd_stud_name);
  utl_file.put_line(v_file,r1.quest_cust_serv);
  utl_file.put_line(v_file,r1.quest_tech_asst);
  utl_file.put_line(v_file,r1.quest_add_resc);

/******* Additional Information **********/
  open c2(r1.evxcourseid);fetch c2 into r2;
  if c2%found and nvl(r1.pl_num,'00') != '19' then
    utl_file.put_line(v_file,'<tr><td colspan=2 align=left>&nbsp</td></tr>');
    utl_file.put_line(v_file,'<tr><th colspan=2 align=left><font color="CE9900" size=4>Additional Information</font></th></tr>');
    utl_file.put_line(v_file,'<tr><td colspan=2 align=left>&nbsp</td></tr>');
    utl_file.put_line(v_file,'<tr><td align=left colspan=2>'||replace(replace(r2.specialinfo,'</HTML>',''),'<HTML>','')||'</td></tr>');
    utl_file.put_line(v_file,'<tr><td colspan=2 align=left>&nbsp</td></tr>');
  end if;
  close c2;

  utl_file.put_line(v_file,v_html_end);

  utl_file.fclose(v_file);

  select count(*) into v_attach_cnt from attachment@slx where attachid = r1.attachment_id;

  if v_attach_cnt = 0 then
    insert into attachment@slx(attachid,attachdate,contactid,description,datatype,filesize,filename,userid)
    values (r1.attachment_id,v_curr_time,r1.contactid,v_attach_desc,'R',2425,v_file_name,'ADMIN');
    commit;
  else
    update attachment@slx
       set attachdate = v_curr_time,
           contactid = r1.contactid,
           description = v_attach_desc,
           filename = v_file_name
     where attachid = r1.attachment_id;
    commit;
  end if;

exception 
  when others then
    send_mail_sb('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_EMAIL_PROC error in evxevenrollid: '||r1.evxevenrollid,SQLERRM);  
end;

end loop;

exception
  when others then
    rollback;
    send_mail_sb('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_EMAIL_PROC Failed',SQLERRM);

end;
/


