DROP PROCEDURE GKDW.GK_CONF_FACILITY_CHANGE_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_facility_change_proc as

cursor c1 is
select replace(txfeeid,'Q6UJ9','FCCHG') attachment_id,
       ea.contactid,ea.evxevenrollid,ec.evxfacilityid,ec.startdate,ec.enddate,to_char(ec.starttime,'hh:mi:ss AM') starttime,to_char(ec.endtime,'hh:mi:ss AM') endtime,
       ed.event_name eventname,ec.facilityname facilityname,ec.address1,ec.address2,ed.city,ec.state,ec.postalcode,initcap(c.first_name) firstname,initcap(c.last_name) lastname,
       c.email,ed.event_type eventtype,ea.evxeventid,ec.evxcourseid,ec.tzgenericname tz_desc,ec.tzgenericname,ed.course_code,ec.tzabbreviation,
       to_char(starttime+(hour_offset/24),'hh24miss') cal_start,
       to_char(endtime+(hour_offset/24),'hh24miss') cal_end,
       to_char(to_number(to_char(endtime,'hh24')-to_char(starttime,'hh24'))+to_number((to_char(endtime,'mi')-to_char(starttime,'mi'))/60)) duration,
       cp.dmoc dmoc_flag,ec.hvxuserid,
       case when cd.md_num in ('32','33','34','44') then 'N'
            when tzgenericname is null then 'N'
            else 'Y'
       end cal_reminder,
       cd.md_num,ea.channel_flag,
       case when ea.channel_flag = 'Y' then ea.conf_email
            when ec.group_email_address is not null then ec.group_email_address
            else c.email
       end conf_email,
       p.channel_cc1_email,p.channel_cc2_email,ea.channel_keycode,ec.secondaryemail,
       case when ec.eventtype = 'VCEL' or cd.md_num in ('20','32','33','34','42','44') then 'Y' else 'N' end vcl_flag,
       gk_conf_hdr_func() conf_hdr,
       gk_conf_reg_hdr_func(ed.event_id,'LOC') reg_hdr,
       gk_loc_change_body_func(initcap(c.first_name),to_char(ec.startdate,'Mon. dd, yyyy'),ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode) fac_change_info,
       gk_conf_mygk_func(ed.event_id,'REG',ec.hvxuserid,ec.email,ec.contactid) mygk_access,
       gk_conf_num_func(ed.event_id,ec.evxevenrollid) cd_conf_num,
       gk_conf_course_func(ed.event_id) cd_course_name,
       gk_conf_facility_func(ed.event_id,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode) cd_fac_name,
       gk_conf_student_func(ed.event_id,initcap(ec.firstname),initcap(ec.lastname),ec.email) cd_stud_name,
       gk_conf_cust_serv_func(ed.event_id,ec.leadsourcedesc) quest_cust_serv,
       gk_conf_tech_asst_func(ed.event_id,ec.leadsourcedesc) quest_tech_asst,
       gk_conf_addl_res_func(ed.event_id) quest_add_resc
  from gk_enroll_event_change_v@slx ec
       inner join gk_conf_email_audit ea on ec.evxevenrollid = ea.evxevenrollid
       inner join order_fact f on ea.evxevenrollid = f.enroll_id
       inner join event_dim ed on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join slxdw.evxfacility ef on ea.evxfacilityid = ef.evxfacilityid
       inner join slxdw.address a on ef.facilityaddressid = a.addressid
       left outer join gk_mygk_course_profile_v cp on cd.course_id = cp.course_id
       left outer join gk_channel_partner_conf p on ea.channel_keycode = p.channel_keycode
 where ea.enrollstatus = 'Confirmed'
   and ec.enrollstatus = 'Confirmed'
   and cd.md_num not in ('32','33','34','44')
   and c.email is not null
   and ec.evxfacilityid <> ea.evxfacilityid
 order by 1;

cursor c2(v_course_id varchar2) is
select *
  from course_specialinfo_v@slx
 where evxcourseid = v_course_id;

cursor c3(v_enroll_id varchar2) is
select '<tr><th align=right>Session '||row_number() over (order by session_date)||':</th><td align=left>'||to_char(session_date,'fmdd-Mon-YYYY')||' '||nvl(session_start,start_time)||'-'||nvl(session_end,end_time)||' '||ec.tzgenericname||'</td></tr>' session_line
  from gk_event_days_mv e
       inner join gk_enroll_event_change_v@slx ec on e.event_id = ec.evxeventid
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
v_attach_cnt number;
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop

  select r1.evxevenrollid||'_GlobalKnowledgeFacilityChangeLetter_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-Facility-Change-Letter--Conf#-'||r1.evxevenrollid||'-('||r1.firstname||'-'||r1.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

  select r1.evxevenrollid||'_FacilityChange_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-Facility-Change--Conf#-'||r1.evxevenrollid||'-('||r1.firstname||'-'||r1.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

/******* EVENT CHANGE EMAIL ********/
  v_msg_body := r1.conf_hdr;
  v_msg_body := v_msg_body||r1.reg_hdr;
  v_msg_body := v_msg_body||r1.fac_change_info;
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

  send_mail('ConfirmAdmin.NAm@globalknowledge.com','Confirmation.Test@globalknowledge.com','CC-Notification of Course Location Change',v_msg_body);
  send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.conf_email,'Notification of Course Location Change',v_msg_body);
  if r1.secondaryemail is not null then
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.secondaryemail,'Notification of Course Location Change',v_msg_body);
  end if;
  if r1.channel_flag = 'Y' then
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.channel_cc1_email,'Notification of Course Location Change - Conf# '||r1.evxevenrollid,v_msg_body);
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.channel_cc2_email,'Notification of Course Location Change - Conf# '||r1.evxevenrollid,v_msg_body);
  end if;

  update gk_conf_email_audit
     set evxfacilityid = r1.evxfacilityid,
         fac_change_date = sysdate
   where evxevenrollid = r1.evxevenrollid;
  commit;

/******* OUTLOOK ENROLLMENT ********/
  if r1.cal_reminder = 'Y' and r1.channel_flag = 'N' then

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

      send_ical_email('ConfirmAdmin.NAm@globalknowledge.com',r1.conf_email,'Notification of Course Location Change ('||r1.evxevenrollid||')',v_msg_body,v_ical_event);

  end if;

/******* EVENT CHANGE ATTACHMENT ********/
    v_file := utl_file.fopen('/mnt/nc10s079',v_file_name,'w',32767);
--    v_file := utl_file.fopen('/usr/tmp',v_file_name,'w',32767);


/******* EVENT CHANGE EMAIL ********/
  utl_file.put_line(v_file,r1.conf_hdr);
  utl_file.put_line(v_file,r1.reg_hdr);
  utl_file.put_line(v_file,r1.fac_change_info);
  utl_file.put_line(v_file,r1.mygk_access);
  utl_file.put_line(v_file,r1.cd_conf_num);
  utl_file.put_line(v_file,r1.cd_course_name);
  for r3 in c3(r1.evxevenrollid) loop
    utl_file.put_line(v_file,r3.session_line);
  end loop;
  if r1.vcl_flag = 'N' then
    utl_file.put_line(v_file,r1.cd_fac_name);
  end if;
  utl_file.put_line(v_file,r1.cd_stud_name);
  utl_file.put_line(v_file,r1.quest_cust_serv);
  utl_file.put_line(v_file,r1.quest_tech_asst);
  utl_file.put_line(v_file,r1.quest_add_resc);
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

end loop;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_EVENT_CHANGE_PROC Failed',SQLERRM);

end;
/


GRANT EXECUTE ON GKDW.GK_CONF_FACILITY_CHANGE_PROC TO COGNOS_RO;

