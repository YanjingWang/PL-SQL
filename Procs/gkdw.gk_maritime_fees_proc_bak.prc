DROP PROCEDURE GKDW.GK_MARITIME_FEES_PROC_BAK;

CREATE OR REPLACE PROCEDURE GKDW.gk_maritime_fees_proc_BAK(p_test varchar2 default 'N') as

cursor c1 is
select 7414 vendor_id,'LINTHICUM HEIGH' vendor_site_code,84 org_id,101 inv_org_id,
       264 agent_id,15259 requestor,'USD' curr_code,ed.event_id,ed.course_id,ed.start_date,ed.end_date,ed.status,ed.ops_country,ed.city,ed.state,
       ed.facility_region_metro metro,cd.course_code,cd.short_name,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       cd.vendor_code,ed.facility_code,r."name" room_name,r."room_type" room_type,r."comment" room_comment,ed.capacity,
       case when vendor_code = 'FSTONE' then (ed.end_date-ed.start_date+2) else (ed.end_date-ed.start_date+1) end rent_days,
      500 room_rate, --case when r."comment" is not null then '500' else null end room_rate, --to_number(replace(r."comment",'$','')) room_rate, -- SR 01/09/2018 ticket# 139238
       /*to_number(replace(r."comment",'$','')) case when r."comment" is not null then '500' else null end */ 500*case when vendor_code = 'FSTONE' then (ed.end_date-ed.start_date+2) else (ed.end_date-ed.start_date+1) end room_rent,
       20*ed.capacity*(ed.end_date-ed.start_date+1) room_fb,20*ed.capacity fb_rate,
       case when cd.vendor_code = 'FSTONE' then 130 else 90 end av_rate,
       ed.end_date-ed.start_date+1 av_days,
       case when cd.vendor_code = 'FSTONE' then 130 else 90 end*(ed.end_date-ed.start_date+1) room_av,
       ed.event_id||chr(9)||cd.course_code||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||ed.facility_code||chr(9)||r."name"||chr(9)||500--case when r."comment" is not null then '500' else null end --to_number(replace(r."comment",'$',''))
       ||chr(9)||ed.capacity||chr(9)||/*case when r."comment" is not null then '500' else null end to_number(replace(r."comment",'$',''))*/ 500*case when vendor_code = 'FSTONE' then (ed.end_date-ed.start_date+2) else (ed.end_date-ed.start_date+1) end||chr(9)||
       20*ed.capacity*(ed.end_date-ed.start_date+1)||chr(9)||case when cd.vendor_code = 'FSTONE' then 130 else 90 end*(ed.end_date-ed.start_date+1) po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join "schedule"@rms_prod s on ed.event_id = s."slx_id"
       left join "location_rooms"@rms_prod r on s."location_rooms" = r."id"
       inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
 where status in ('Open','Verified')
   and td2.dim_year||'-'||lpad(td2.dim_week+1,2,'0') = td.dim_year||'-'||lpad(td.dim_week,2,'0')
   and not exists (select 1 from gk_nested_courses nc where cd.course_code = nc.nested_course_code)
   and location_id = 'Q6UJ9A08N1D6'
   and start_date >= trunc(sysdate)-1
   and status = 'Open'
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

select 'maritime_po_detail_'||dim_year||'-'||lpad(dim_week,2,'0')||'.xls',
       '/usr/tmp/maritime_po_detail_'||dim_year||'-'||lpad(dim_week,2,'0')||'.xls'
  into v_file_name,v_file_name_full
  from time_dim
 where dim_date = trunc(sysdate);

select 'Event ID'||chr(9)||'Course Code'||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'Facility Code'||chr(9)||'Room Name'||chr(9)||'Room Rate'||chr(9)||'Capacity'||chr(9)||
       'Room Rent'||chr(9)||'Room FB'||chr(9)||'Room AV'||chr(9)||'PO Num'
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
  vpo_hdr := 'MARITIME ROOM RENTAL PO';
  vline_num := 1;

  gkn_po_create_hdr_proc@r12prd(v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);
  update "schedule"@rms_prod
     set "po" = v_curr_po
   where "slx_id" = r1.event_id;
  commit;

  insert into gk_autoreceive_pos
    select v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code,v_sid,sysdate,'N','MARITIME'
      from dual;

  commit;

  if r1.room_rent > 0 then
    vcode_comb_id := gkn_get_account@r12prd('210','145','64105',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
    gkn_po_create_line_proc@r12prd(vline_num,null,'FAC FEE '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                   'DAY(S)',r1.rent_days,r1.room_rate,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
    vline_num := vline_num + 1;
  end if;
  commit;

  if r1.room_fb > 0 then
    vcode_comb_id := gkn_get_account@r12prd('210','145','64305',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
    gkn_po_create_line_proc@r12prd(vline_num,null,'F&B '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                   'EACH',r1.av_days,r1.fb_rate,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
    vline_num := vline_num + 1;
  end if;
  commit;


  if r1.room_av > 0 then
    vcode_comb_id := gkn_get_account@r12prd('210','145','64205',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
    gkn_po_create_line_proc@r12prd(vline_num,null,'AV '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                   'EACH',r1.av_days,r1.av_rate,vneed_date,r1.inv_org_id,r1.org_id,
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

 /* loop_cnt := 1;
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
  commit;*/ --changes made by subramanianb to disable Oracle Auto-Receiving

  utl_file.put_line(v_file,r1.po_line||chr(9)||v_curr_po);

end loop;

utl_file.fclose(v_file);

send_mail_attach('Erika.Powell@globalknowledge.com','Erika.Powell@globalknowledge.com',null,null,'Maritime Detail File','Open Excel Attachment to view Maritime details.',v_file_name_full);
send_mail_attach('Erika.Powell@globalknowledge.com','cmitchell@CCMIT.ORG','Alison.Harding@globalknowledge.com','','Maritime Detail File','Open Excel Attachment to view Maritime details.',v_file_name_full);

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_MARITIME_FEES_PROC FAILED',SQLERRM);

end;
/


