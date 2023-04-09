DROP PROCEDURE GKDW.GK_CONF_CANC_SUB_CCC_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_conf_canc_sub_ccc_proc as

cursor c3 is
select replace(nvl(ec.txfeeid,ec.evxevenrollid),'Q6UJ9','CANCL') attachment_id,
       ec.*,cd.course_code,cd.short_name,ed.start_date-trunc(sysdate) days_to_start,--cp.mygk_profile,
       to_char(ed.start_date,'FMMonth ddth, yyyy') start_date_disp,
       ec.tzgenericname tz_desc,
       ed.start_time,ed.end_time,
       to_char(starttime+(hour_offset/24),'hh24miss') cal_start,
       to_char(endtime+(hour_offset/24),'hh24miss') cal_end,
       to_char(to_number(to_char(endtime,'hh24')-to_char(starttime,'hh24'))+to_number((to_char(endtime,'mi')-to_char(starttime,'mi'))/60)) duration,
       cp.dmoc dmoc_flag,
       case when cd.md_num in ('32','33','34','44') then 'N'
            when tzgenericname is null then 'N'
            else 'Y'
       end cal_reminder,
       cd.md_num,
       ea.channel_flag,
       case when ea.channel_flag = 'Y' then ea.conf_email
            when ec.group_email_address is not null then ec.group_email_address
            else ec.email
       end conf_email,
       p.channel_cc1_email,
       p.channel_cc2_email,
       ea.channel_keycode,
       gk_conf_hdr_func() conf_hdr,
       gk_conf_reg_hdr_func(ed.event_id,'CCC') canc_hdr,
       gk_conf_canc_func('CCC',ed.event_id,initcap(ec.firstname),ea.channel_flag,trim(ec.enrollstatusdesc),ec.eventname) canc_body,
       gk_conf_cust_serv_func(ed.event_id,ec.leadsourcedesc) quest_cust_serv
  from gk_enroll_conf_v@slx ec
       inner join event_dim ed on ec.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_conf_email_audit ea on ec.evxevenrollid = ea.evxevenrollid and ea.enrollstatus = 'Confirmed'
       inner join cust_dim c on ec.contactid = c.cust_id
       left outer join gk_mygk_course_profile_v cp on cd.course_id = cp.course_id
       left outer join gk_channel_partner_conf p on ea.channel_keycode = p.channel_keycode
 where ec.enrollstatus = 'Cancelled'
   and ec.email is not null
   and ec.enrollstatusdesc = 'CONTENT CHANGE R/N';

v_msg_body long;
v_file_name varchar2(250);
v_file utl_file.file_type;
v_attach_desc varchar2(500);
v_curr_time varchar2(250);
v_ical_event varchar2(32767);
v_attach_cnt number := 0;
v_html_end varchar2(250) := '</table><p></body></html>';


begin

for r3 in c3 loop

  select r3.evxevenrollid||'_GlobalKnowledgeSubstitutionLetter_'||to_char(sysdate,'yyyy-mm-dd_hh24_mi_ss')||'.html'
    into v_file_name
    from dual;

  v_attach_desc := 'Global-Knowledge-Event-Substitution-Letter--Conf#-'||r3.evxevenrollid||'-('||r3.firstname||'-'||r3.lastname||')';
  v_curr_time := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');

/******* CANCELLATION EMAIL ***********/
  v_msg_body := r3.conf_hdr;
  v_msg_body := v_msg_body||r3.canc_hdr;
  v_msg_body := v_msg_body||r3.canc_body;
  v_msg_body := v_msg_body||r3.quest_cust_serv;
  v_msg_body := v_msg_body||v_html_end;

  send_mail('ConfirmAdmin.NAm@globalknowledge.com','Confirmation.Test@globalknowledge.com','CC-Course Cancellation confirmation ('||r3.evxevenrollid||')',v_msg_body);
  send_mail('ConfirmAdmin.NAm@globalknowledge.com',r3.conf_email,'Course Cancellation confirmation ('||r3.evxevenrollid||')',v_msg_body); -- SR
  if r3.secondaryemail is not null then                                                                                                           --SR
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r3.secondaryemail,'Course Cancellation confirmation ('||r3.evxevenrollid||')',v_msg_body);
  end if;
  if r3.channel_flag = 'Y' then
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r3.channel_cc1_email,'Course Cancellation confirmation ('||r3.evxevenrollid||')',v_msg_body);
    send_mail('ConfirmAdmin.NAm@globalknowledge.com',r3.channel_cc2_email,'Course Cancellation confirmation ('||r3.evxevenrollid||')',v_msg_body);
  end if;

  update gk_conf_email_audit
     set enrollstatus = r3.enrollstatus,
         cancel_date = sysdate
   where evxevenrollid = r3.evxevenrollid;
  commit;


/******* OUTLOOK CANCELLATION ********/
  if r3.cal_reminder = 'Y' and r3.channel_flag = 'N' then
    v_ical_event := ical_event_new(
                    p_event_id      => r3.evxeventid,
                    p_prodid        => r3.evxevenrollid,
                    p_method        => 'CANCEL',
                    p_start_date    => r3.startdate,
                    p_end_date      => r3.enddate,
                    p_start_time    => r3.cal_start,
                    p_end_time      => r3.cal_end,
                    p_summary       => r3.eventname,
                    p_location      => r3.facilityname,
                    p_sequence      => 0,
                    p_organizer_name => 'Global Knowledge',
                    p_organizer_email => 'ConfirmAdmin.NAm@globalknowledge.com',
                    p_attendee_name => r3.firstname||' '||r3.lastname,
                    p_attendee_email => r3.conf_email);

      send_ical_email('ConfirmAdmin.NAm@globalknowledge.com',r3.conf_email,'Course Cancellation confirmation ('||r3.evxevenrollid||')',v_msg_body,v_ical_event);
  end if;

/******* CANCELLATION ATTACHMENT ********/
  v_file := utl_file.fopen('/mnt/nc10s079',v_file_name,'w',32767);

  utl_file.put_line(v_file,r3.conf_hdr);
  utl_file.put_line(v_file,r3.canc_hdr);
  utl_file.put_line(v_file,r3.canc_body);
  utl_file.put_line(v_file,r3.quest_cust_serv);
  utl_file.put_line(v_file,v_html_end);
  utl_file.put_line(v_file,v_html_end);

  utl_file.fclose(v_file);

  select count(*) into v_attach_cnt from attachment@slx where attachid = r3.attachment_id;

  if v_attach_cnt = 0 then
    insert into attachment@slx(attachid,attachdate,contactid,description,datatype,filesize,filename,userid)
    values (r3.attachment_id,v_curr_time,r3.contactid,v_attach_desc,'R',2425,v_file_name,'ADMIN');
    commit;
  else
    update attachment@slx
       set attachdate = v_curr_time,
           contactid = r3.contactid,
           description = v_attach_desc,
           filename = v_file_name
     where attachid = r3.attachment_id;
    commit;
  end if;

end loop;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_conf_canc_sub_ccc_proc Failed',SQLERRM);

end;
/


GRANT EXECUTE ON GKDW.GK_CONF_CANC_SUB_CCC_PROC TO COGNOS_RO;

