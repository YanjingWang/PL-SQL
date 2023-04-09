DROP PROCEDURE GKDW.GK_NIU_FACILITY_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_niu_facility_po_proc(p_test varchar2 default 'N') as

cursor c1 is
select 24454 vendor_id,
       'REMIT-DEKALB' vendor_site_code,
       84 org_id,
       101 inv_org_id,
       264 agent_id,15259 requestor,
       'USD' curr_code,
       '210' le,
       ed.event_id,
       ed.facility_code,ed.facility_region_metro metro,cd.course_code,cd.course_ch,cd.course_mod,cd.course_pl,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,ed.status,ed.ops_country,ed.city,ed.state,
       ed.start_date,to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi') start_time24,to_char(ed.start_date,'d') start_day,
       ed.end_date,to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi') end_time24,to_char(ed.end_date,'d') end_day,
       to_char(ed.start_date,'d')+ed.end_date-ed.start_date end_day_actual,
       upper(ed.location_name) location_name,
       nvl(oa.enroll_cnt,0) enroll_cnt,'325' daily_rate,ed.end_date-ed.start_date+1 class_dur,
       325*(ed.end_date-ed.start_date+1) room_fee,
       100*(ed.end_date-ed.start_date+1) av_fee,
       20*nvl(oa.enroll_cnt,0)*(ed.end_date-ed.start_date+1)  fb_fee,
       ed.event_id||chr(9)||ed.facility_region_metro||chr(9)||cd.course_code||chr(9)||ed.start_date||chr(9)||
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||end_date||chr(9)||
       to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||
       nvl(oa.enroll_cnt,0)||chr(9)||ed.facility_code||chr(9)||'325'||chr(9)||to_char(ed.end_date-ed.start_date+1)||chr(9)||
       325*(ed.end_date-ed.start_date+1)||chr(9)||
       100*(ed.end_date-ed.start_date+1)||chr(9)||
       20*nvl(oa.enroll_cnt,0)*(ed.end_date-ed.start_date+1) po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join rmsdw.rms_event re on ed.event_id = re.slx_event_id and upper(re.contract_status) in ('CONTRACT ON FILE','DEDICATED ROOM')
      inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       inner join gk_niu_event_cnt_v oa on oa.event_id = ed.event_id
 where ed.status in ('Open','Verified') and 
 facility_code = 'NIU-CHI'
 and ed.ops_country = 'USA'
-- and start_date >= trunc(sysdate)-1
 and td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = td.dim_year||'-'||lpad(td.dim_week,2,'0')
 order by start_date;

cursor c2(v_req_id number) is
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id;

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
v_sid varchar2(10) := 'R12PRD';
v_curr_po varchar2(25);
vneed_date date;
vpo_hdr varchar2(250);
vline_num number;
l_req_id number;
vcode_comb_id number;
loop_cnt number;
r2 c2%rowtype;


begin
rms_link_set_proc;

select 'NIU_po_detail_'||dim_year||'-'||lpad(dim_week,2,'0')||'.xls',
       '/usr/tmp/NIU_po_detail_'||dim_year||'-'||lpad(dim_week,2,'0')||'.xls'
  into v_file_name,v_file_name_full
  from time_dim
 where dim_date = trunc(sysdate);

select 'Event ID'||chr(9)||'Metro'||chr(9)||'Course Code'||chr(9)||'Start Date'||chr(9)||'Start Time'||chr(9)||'End Date'||chr(9)||'End Time'||chr(9)||'Enroll Count'||chr(9)||'Facility Code'||chr(9)||'Room Rate'||chr(9)||'Number of days'||chr(9)||
       'Room Rent'||chr(9)||'Room AV'||chr(9)||'Room FB'||chr(9)||'PO Num'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
utl_file.put_line(v_file,v_hdr);

for r1 in c1 loop
  select gk_get_curr_po(84,v_sid) into v_curr_po from dual;
  gk_update_curr_po(84,v_sid);
  commit;

  dbms_output.put_line(v_curr_po||'-'||r1.event_id);

  vneed_date := trunc(sysdate)+1;
  vpo_hdr := 'NIU ROOM RENTAL PO';
  vline_num := 1;

  gkn_po_create_hdr_proc@r12prd(v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);
  update "schedule"@rms_prod
     set "po" = v_curr_po
   where "slx_id" = r1.event_id;
  commit;

  insert into gk_autoreceive_pos
    select v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code,v_sid,sysdate,'N','NIU'
      from dual;

  commit;

  if r1.room_fee > 0 then
    vcode_comb_id := gkn_get_account@r12prd('210','145','64105',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
    gkn_po_create_line_proc@r12prd(vline_num,null,'FAC FEE '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                   'DAY(S)',r1.class_dur,325,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
    vline_num := vline_num + 1;
  end if;
  commit;

  if r1.fb_fee > 0 then
    vcode_comb_id := gkn_get_account@r12prd('210','145','64305',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
    gkn_po_create_line_proc@r12prd(vline_num,null,'F&B '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                   'EACH',r1.enroll_cnt*r1.class_dur,20,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
    vline_num := vline_num + 1;
  end if;
  commit;


  if r1.av_fee > 0 then
    vcode_comb_id := gkn_get_account@r12prd('210','145','64205',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
    gkn_po_create_line_proc@r12prd(vline_num,null,'AV '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                   'EACH',r1.class_dur,100,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
    vline_num := vline_num + 1;
  end if;
  commit;

  fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;

  l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  commit;

  loop_cnt := 1;
  while loop_cnt < 5 loop
    open c2(l_req_id);
    fetch c2 into r2;
    if r2.phase_code = 'C' then
      loop_cnt := 5;
      dbms_lock.sleep(15);
      gk_receive_po_proc(v_curr_po,v_sid);
      gk_receive_request_proc(v_sid);
    else
      loop_cnt := loop_cnt+1;
      dbms_lock.sleep(15);
    end if;
    close c2;
  end loop;
  commit;

  utl_file.put_line(v_file,r1.po_line||chr(9)||v_curr_po);

end loop;

utl_file.fclose(v_file);

send_mail_attach('Alison.Harding@globalknowledge.com','meetingscary@globalknowledge.com','DW.Automation@globalknowledge.com',null,'NIU facility Detail File','Open Excel Attachment to view NIU facility details.',v_file_name_full);
send_mail_attach('Alison.Harding@globalknowledge.com','mkeyes@niu.edu','Erika.Powell@globalknowledge.com',null,'NIU facility Detail File','Open Excel Attachment to view NIU facility details.',v_file_name_full);

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_niu_facility_po_proc FAILED',SQLERRM);

end;
/


