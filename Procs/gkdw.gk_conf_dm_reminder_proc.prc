DROP PROCEDURE GKDW.GK_CONF_DM_REMINDER_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_dm_reminder_proc as

cursor c1 is
select distinct replace(ec.txfeeid,'Q6UJ9','DMREM') attachment_id,ec.eventtype,
       ec.evxevenrollid,ec.enrollstatus,ec.startdate,ec.eventname,ec.contactid,ec.firstname,ec.lastname,ec.email,ec.hvxuserid,dp.dvxprofileid,
       case when p.channel_email is not null then p.channel_email
            when hl.evxeventid is not null then hl.channel_poc_email
            when ec.group_email_address is not null then ec.group_email_address
            else ec.email
       end conf_email,
       case when ec.hvxuserid is not null then 'Required: Access your account before your class begins'
            else 'Required: Activate your account before your class begins'
       end email_sub,
       case when ec.eventtype = 'VCEL' or cd.md_num in ('20','32','33','34','42','44') then 'Y' else 'N' end vcl_flag,
       gk_conf_hdr_func() dm_hdr,
       gk_conf_reg_hdr_func(ec.evxeventid,'REM') dm_rem_hdr,
       gk_conf_reg_body_func(ec.evxeventid,'DM',ec.firstname,null,null,ec.hvxuserid,ec.contactid) dm_body,
       gk_conf_num_func(ed.event_id,ec.evxevenrollid) cd_conf_num,
       gk_conf_course_func(ed.event_id) cd_course_name,
       gk_conf_facility_func(ed.event_id,ec.facilityname,ec.address1,ec.address2,ec.city,ec.state,ec.postalcode) cd_fac_name,
       gk_conf_student_func(ed.event_id,initcap(ec.firstname),initcap(ec.lastname),ec.email) cd_stud_name,
       gk_conf_cust_serv_func(ed.event_id,ec.leadsourcedesc) quest_cust_serv,
       gk_conf_tech_asst_func(ed.event_id,ec.leadsourcedesc) quest_tech_asst,
       gk_conf_addl_res_func(ed.event_id) quest_add_resc
  from gk_enroll_conf_v@slx ec
       inner join gk_conf_email_audit ea on ec.evxevenrollid = ea.evxevenrollid
       inner join event_dim ed on ec.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join dvxcourseprofile@gkhub cp on cd.course_id = cp.evxcourseid
       inner join dvxprofile@gkhub dp on cp.dvxprofileid = dp.dvxprofileid
       inner join dvxprofilemember@gkhub pm on dp.dvxprofileid = pm.dvxprofileid
       inner join dvxsystemprofile@gkhub sp on pm.dvxsystemprofileid = sp.dvxsystemprofileid and sp.type = 'Tips'
       left outer join dvxtracking@gkhub dt on sp.dvxsystemprofileid = dt.dvxsystemprofileid and ec.evxevenrollid = dt.evxevenrollid
       left outer join gk_channel_partner_conf p on ec.leadsourcedesc = p.channel_keycode
       left outer join gk_conf_onsite_lookup hl on ed.event_id = hl.evxeventid
 where ec.enrollstatus = 'Confirmed'
   and dp.code like 'CORE-FILE HOST-DM%' -- DevelopMentor MyGK profiles
   and dt.firstclickdate is null -- Student has not clicked on the informational tile
   and to_char(sysdate,'d') = 6 --Friday
   and ec.startdate between trunc(sysdate)+1 and trunc(sysdate)+7 --All classes starting the following week
   and ea.dm_rem_flag = 'N'
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
r2 c2%rowtype;
r3 c3%rowtype;
v_attach_desc varchar2(500);
v_curr_time varchar2(250);
v_attach_cnt number := 0;
v_html_end varchar2(250) := '</table><p></body></html>';

begin

for r1 in c1 loop

  select r1.evxevenrollid||'_DMRemindLetter_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-DM-Remind-Email--Conf#-'||r1.evxevenrollid||'-('||r1.firstname||'-'||r1.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');


/******* DM REMINDER EMAIL ********/
  v_msg_body := r1.dm_hdr;
  v_msg_body := v_msg_body||r1.dm_rem_hdr;
  v_msg_body := v_msg_body||r1.dm_body;
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

  send_mail('ConfirmAdmin.NAm@globalknowledge.com','Confirmation.Test@globalknowledge.com','CC-'||r1.email_sub,v_msg_body);
  send_mail('ConfirmAdmin.NAm@globalknowledge.com',r1.email,r1.email_sub,v_msg_body);

  update gk_conf_email_audit
     set reminder_date = sysdate,
         dm_rem_flag = 'Y'
   where evxevenrollid = r1.evxevenrollid;
  commit;

/******* ENROLLMENT ATTACHMENT ********/
  v_file := utl_file.fopen('/mnt/nc10s079',v_file_name,'w',32767);
--  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w',32767);

  utl_file.put_line(v_file,r1.dm_hdr);
  utl_file.put_line(v_file,r1.dm_rem_hdr);
  utl_file.put_line(v_file,r1.dm_body);
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
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CONF_DM_REMINDER_PROC Failed',SQLERRM);

end;
/


GRANT EXECUTE ON GKDW.GK_CONF_DM_REMINDER_PROC TO COGNOS_RO;

