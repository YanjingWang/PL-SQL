DROP PROCEDURE GKDW.GK_MICROTEK_FEES_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_microtek_fees_proc(p_test varchar2 default 'N') as

cursor c0 is
select distinct ed.ops_country
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_micro_event_cnt_v oa on ed.event_id = oa.event_id
       inner join rmsdw.rms_event re on ed.event_id = re.slx_event_id and upper(re.contract_status) in ('CONTRACT ON FILE','DEDICATED ROOM')
       inner join gk_microtek_location ml on ed.location_id = ml.location_id
       inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       inner join gk_microtek_days_v md on 1=1
       inner join gk_microtek_rates mr on md.microtek_days between mr.start_days and mr.end_days
                                      and oa.enroll_cnt between mr.student_start and mr.student_end
                                      and ed.ops_country = mr.ops_country
       left outer join gk_microtek_proctor mp on cd.course_code = mp.course_code
 where status in ('Open','Verified')
   and td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = td.dim_year||'-'||lpad(td.dim_week,2,'0')
   and not exists (select 1 from gk_nested_courses nc where cd.course_code = nc.nested_course_code)
   and (case when upper(re.contract_status) = 'DEDICATED ROOM' then 0 else mr.daily_rate*(ed.end_date-ed.start_date+1) end +
       gk_microtek_hvac_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi'))+
       gk_microtek_ext_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi'))+
       nvl(mp.proctor_hours,0)*50) > 0
 order by 1 desc;
 
cursor c1(v_ops_country varchar2) is
select 7596 vendor_id,
       case when ed.ops_country = 'CANADA' then 'CDN-DOWNERS GRV' else 'REMIT-CHICAGO' end vendor_site_code,
       case when ed.ops_country = 'CANADA' then 86 else 84 end org_id,
       case when ed.ops_country = 'CANADA' then 103 else 101 end inv_org_id,
       264 agent_id,15259 requestor,
       case when ed.ops_country = 'CANADA' then 'CAD' else 'USD' end curr_code,
       case when ed.ops_country = 'CANADA' then '220' else '210' end le,
       ml.microtek_facility,ed.facility_region_metro metro,ed.event_id,cd.course_code,cd.course_ch,cd.course_mod,cd.course_pl,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       ed.start_date,to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi') start_time24,to_char(ed.start_date,'d') start_day,
       ed.end_date,to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi') end_time24,to_char(ed.end_date,'d') end_day,
       to_char(ed.start_date,'d')+ed.end_date-ed.start_date end_day_actual,
       upper(ed.location_name) location_name,
       nvl(oa.enroll_cnt,0) enroll_cnt,case when mr2.metro is not null then mr2.daily_rate else mr.daily_rate end daily_rate,ed.end_date-ed.start_date+1 class_dur,
       case when upper(re.contract_status) = 'DEDICATED ROOM' then 0 else (case when mr2.metro is not null then mr2.daily_rate else mr.daily_rate end)*(ed.end_date-ed.start_date+1) end total_fee,
       gk_microtek_hvac_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')) hvac_fee,
       gk_microtek_ext_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')) ext_fee,
       nvl(mp.proctor_hours,0)*50 proctor_fee,
       case when substr(cd.course_code,1,4) in ('5951','5952') then 400*(ed.end_date-ed.start_date+1) 
       when cd.course_code in ('1395N','4501N','4503N','4504N','1980N','1978N','2375N','3338N','1395C','4501C','4503C','4504C','1980C','1978C','2375C','3338C',
       '1395H','4501H','4503H','4504H','1980H','1978H','2375H','3338H') then 450*(ed.end_date-ed.start_date+1) -- SR 07/10/2017 requested by Alison Harding
       else 0 end bandwidth_fee,
       ml.microtek_facility||chr(9)||ed.facility_region_metro||chr(9)||ed.event_id||chr(9)||cd.course_code||chr(9)||ed.start_date||chr(9)||
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||end_date||chr(9)||
       to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||
       nvl(oa.enroll_cnt,0)||chr(9)||case when mr2.metro is not null then mr2.daily_rate else mr.daily_rate end||chr(9)||to_char(ed.end_date-ed.start_date+1)||chr(9)||
       (case when mr2.metro is not null then mr2.daily_rate else mr.daily_rate end)*(ed.end_date-ed.start_date+1)||chr(9)||
       gk_microtek_hvac_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi'))||chr(9)||
       gk_microtek_ext_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi'))||chr(9)||
       nvl(mp.proctor_hours,0)*50||chr(9)||
       case when substr(cd.course_code,1,4) in ('5951','5952') then 400*(ed.end_date-ed.start_date+1) else 0 end po_line,
       ml.microtek_facility||chr(9)||ed.facility_region_metro||chr(9)||ed.event_id||chr(9)||cd.course_code||chr(9)||ed.start_date||chr(9)||
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||end_date||chr(9)||
       to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||
       nvl(oa.enroll_cnt,0)||chr(9)||to_char(ed.end_date-ed.start_date+1) mt_po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_micro_event_cnt_v oa on ed.event_id = oa.event_id
       inner join rmsdw.rms_event re on ed.event_id = re.slx_event_id and upper(re.contract_status) in ('CONTRACT ON FILE','DEDICATED ROOM')
       inner join gk_microtek_location ml on ed.location_id = ml.location_id
       inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       inner join gk_microtek_days_v md on 1=1
       left outer join gk_microtek_rates mr on md.microtek_days between mr.start_days and mr.end_days
                                      and oa.enroll_cnt between mr.student_start and mr.student_end
                                      and ed.ops_country = mr.ops_country and mr.metro is null
      left outer join gk_microtek_rates mr2 on md.microtek_days between mr2.start_days and mr2.end_days -- SR 09/28/2018 added for NYC metro prices
                                      and oa.enroll_cnt between mr2.student_start and mr2.student_end
                                      and ed.ops_country = mr2.ops_country and nvl(mr2.metro,'0') <> '0'
       left outer join gk_microtek_proctor mp on cd.course_code = mp.course_code
 where ed.ops_country = v_ops_country
   and status in ('Open','Verified')
   and ed.location_id not in ('Q6UJ9A1L6Y0B','Q6UJ9AD8LVDG','Q6UJ9AD8MG2Y','Q6UJ9A83RRIN')
   and td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = td.dim_year||'-'||lpad(td.dim_week,2,'0')
   and not exists (select 1 from gk_nested_courses nc where cd.course_code = nc.nested_course_code)
   and (case when upper(re.contract_status) = 'DEDICATED ROOM' then 0 else (case when mr2.metro is not null then mr2.daily_rate else mr.daily_rate end)*(ed.end_date-ed.start_date+1) end +
       gk_microtek_hvac_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi'))+
       gk_microtek_ext_fees(ml.microtek_facility,to_number(to_char(ed.start_date,'d')),to_number(to_char(ed.start_date,'d')+ed.end_date-ed.start_date),
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi'),to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi'))+
       nvl(mp.proctor_hours,0)*50) > 0
union
select 7596 vendor_id,'DOWNERS GROVE' vendor_site_code,84 org_id,101 inv_org_id,
       264 agent_id,15259 requestor_id,'USD' curr_code,
       case when ed.ops_country = 'CANADA' then '220' else '210' end le,
       upper(ed.location_name)||'-'||upper(ed.city)||','||upper(ed.state) microtek_facility,ed.facility_region_metro metro,
       ed.event_id,cd.course_code,cd.course_ch,cd.course_mod,cd.course_pl,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       ed.start_date,to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi') start_time24,to_char(ed.start_date,'d') start_day,
       ed.end_date,to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi') end_time24,to_char(ed.end_date,'d') end_day,
       to_char(ed.start_date,'d')+ed.end_date-ed.start_date end_day_actual,
       upper(ed.location_name) location_name,
       nvl(oa.enroll_cnt,0) enroll_cnt,1125+((125+260)/(ed.end_date-ed.start_date+1)) daily_rate,ed.end_date-ed.start_date+1 class_dur,
       case when upper(re.contract_status) = 'DEDICATED ROOM' then 0 else 1125*(ed.end_date-ed.start_date+1)+125+260 end total_fee,
       0 hvac_fee,
       0 ext_fee,
       nvl(mp.proctor_hours,0)*50 proctor_fee,
       case when substr(cd.course_code,1,4) in ('5951','5952') then 400*(ed.end_date-ed.start_date+1) 
       when cd.course_code in ('1395N','4501N','4503N','4504N','1980N','1978N','2375N','3338N','1395C','4501C','4503C','4504C','1980C','1978C','2375C','3338C',
       '1395H','4501H','4503H','4504H','1980H','1978H','2375H','3338H') then 450*(ed.end_date-ed.start_date+1) -- SR 07/10/2017 requested by Alison Harding
       else 0 end bandwidth_fee,
       upper(ed.location_name)||'-'||upper(ed.city)||','||upper(ed.state)||chr(9)||ed.facility_region_metro||chr(9)||ed.event_id||chr(9)||
       cd.course_code||chr(9)||ed.start_date||chr(9)||
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||end_date||chr(9)||
       to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||
       nvl(oa.enroll_cnt,0)||chr(9)||to_char(1125+((125+260)/(ed.end_date-ed.start_date+1)))||chr(9)||to_char(ed.end_date-ed.start_date+1)||chr(9)||
       to_char(1125*(ed.end_date-ed.start_date+1)+125+260)||chr(9)||0||chr(9)||0||chr(9)||nvl(mp.proctor_hours,0)*50||chr(9)||
       case when substr(cd.course_code,1,4) in ('5951','5952') then 400*(ed.end_date-ed.start_date+1) else 0 end,
       upper(ed.location_name)||'-'||upper(ed.city)||','||upper(ed.state)||chr(9)||ed.facility_region_metro||chr(9)||ed.event_id||chr(9)||
       cd.course_code||chr(9)||ed.start_date||chr(9)||
       to_char(to_date(ed.start_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||end_date||chr(9)||
       to_char(to_date(ed.end_time,'hh:mi:ss pm'),'hh24:mi')||chr(9)||
       nvl(oa.enroll_cnt,0)||chr(9)||to_char(ed.end_date-ed.start_date+1)
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_micro_event_cnt_v oa on ed.event_id = oa.event_id
       inner join rmsdw.rms_event re on ed.event_id = re.slx_event_id and upper(re.contract_status) in ('CONTRACT ON FILE','DEDICATED ROOM')
       inner join time_dim td on ed.start_date = td.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       left outer join gk_microtek_proctor mp on cd.course_code = mp.course_code
 where ed.ops_country = v_ops_country
   and status in ('Open','Verified')
   and td2.dim_year||'-'||lpad(td2.dim_week,2,'0') = td.dim_year||'-'||lpad(td.dim_week,2,'0')
   and not exists (select 1 from gk_nested_courses nc where cd.course_code = nc.nested_course_code)
   and ed.location_id in ('Q6UJ9A1L6Y0B','Q6UJ9AD8LVDG','Q6UJ9AD8MG2Y','Q6UJ9A83RRIN')
   and (case when upper(re.contract_status) = 'DEDICATED ROOM' then 0 else 1125*(ed.end_date-ed.start_date+1) end +
       nvl(mp.proctor_hours,0)*50) > 0
order by microtek_facility,start_date,class_dur desc,end_day desc,course_code;

cursor c3(p_sid varchar2,v_req_id number) is
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12dev
   where request_id = v_req_id
     and p_sid = 'R12DEV'
  union
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id
     and p_sid = 'R12PRD';

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_mt_file_name varchar2(50);
v_mt_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_mt_hdr varchar2(1000);
v_file utl_file.file_type;
v_mt_file utl_file.file_type;
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
r3 c3%rowtype;


begin
rms_link_set_proc;


for r0 in c0 loop
  select 'microtek_fees_'||dim_year||'-'||lpad(dim_week,2,'0')||'-'||r0.ops_country||'.xls',
         '/usr/tmp/microtek_fees_'||dim_year||'-'||lpad(dim_week,2,'0')||'-'||r0.ops_country||'.xls',
         'microtek_po_detail_'||dim_year||'-'||lpad(dim_week,2,'0')||'-'||r0.ops_country||'.xls',
         '/usr/tmp/microtek_po_detail_'||dim_year||'-'||lpad(dim_week,2,'0')||'-'||r0.ops_country||'.xls'
    into v_file_name,v_file_name_full,v_mt_file_name,v_mt_file_name_full
    from time_dim
   where dim_date = trunc(sysdate);

  select 'Microtek Facility'||chr(9)||'Metro'||chr(9)||'Event ID'||chr(9)||'Course Code'||chr(9)||'Start Date'||chr(9)||'Start Time'||chr(9)||
         'End Date'||chr(9)||'End Time'||chr(9)||'Enroll Cnt'||chr(9)||'Daily Rate'||chr(9)||'Dur'||chr(9)||'Fac Fee'||chr(9)||
         'HVAC Fee'||chr(9)||'Ext Fee'||chr(9)||'Proctor Fee'||chr(9)||'Bandwith Fee'||chr(9)||'PO Num'
    into v_hdr
    from dual;

  select 'Microtek Facility'||chr(9)||'Metro'||chr(9)||'Event ID'||chr(9)||'Course Code'||chr(9)||'Start Date'||chr(9)||'Start Time'||chr(9)||
         'End Date'||chr(9)||'End Time'||chr(9)||'Enroll Cnt'||chr(9)||'Dur'||chr(9)||'PO Num'
    into v_mt_hdr
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  v_mt_file := utl_file.fopen('/usr/tmp',v_mt_file_name,'w');

  utl_file.put_line(v_file,v_hdr);
  utl_file.put_line(v_mt_file,v_mt_hdr);

  for r1 in c1(r0.ops_country) loop
    select gk_get_curr_po(r1.org_id,v_sid) into v_curr_po from dual;
    gk_update_curr_po(r1.org_id,v_sid);
    commit;

    dbms_output.put_line(v_curr_po||'-'||r1.event_id);

    vneed_date := trunc(sysdate)+1;
    vpo_hdr := 'MICROTEK FACILITY PO';
    vline_num := 1;

    gkn_po_create_hdr_proc@r12prd(v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);

    update "schedule"@rms_prod
       set "po" = v_curr_po
     where "slx_id" = r1.event_id;
    commit;

    insert into gk_autoreceive_pos
      select v_curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code,v_sid,sysdate,'N','MICROTEK'
        from dual;

    commit;

    if r1.total_fee > 0 then
      vcode_comb_id := gkn_get_account@r12prd(r1.le,'145','64105',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
      gkn_po_create_line_proc@r12prd(vline_num,null,'FAC FEE '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                     'DAY(S)',r1.class_dur,r1.daily_rate,vneed_date,r1.inv_org_id,r1.org_id,
                                     vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
      vline_num := vline_num + 1;
    end if;
    commit;

    if r1.hvac_fee > 0 then
      vcode_comb_id := gkn_get_account@r12prd(r1.le,'145','64105',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
      gkn_po_create_line_proc@r12prd(vline_num,null,'HVAC FEE '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                    'EACH',1,r1.hvac_fee,vneed_date,r1.inv_org_id,r1.org_id,
                                    vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
      vline_num := vline_num + 1;
    end if;
    commit;

    if r1.ext_fee > 0 then
      vcode_comb_id := gkn_get_account@r12prd(r1.le,'145','64105',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
      gkn_po_create_line_proc@r12prd(vline_num,null,'EXTD FEE '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                     'EACH',1,r1.ext_fee,vneed_date,r1.inv_org_id,r1.org_id,
                                     vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
      vline_num := vline_num + 1;
    end if;
    commit;

    if r1.proctor_fee > 0 then
      vcode_comb_id := gkn_get_account@r12prd(r1.le,'145','62305',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
      gkn_po_create_line_proc@r12prd(vline_num,null,'PROCTOR '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                    'EACH',1,r1.proctor_fee,vneed_date,r1.inv_org_id,r1.org_id,
                                    vcode_comb_id,'CARY',r1.requestor,r1.event_id,130);
      vline_num := vline_num + 1;
    end if;
    commit;

    if r1.bandwidth_fee > 0 then
      vcode_comb_id := gkn_get_account@r12prd(r1.le,'145','64205',r1.ch_num,r1.md_num,r1.pl_num,r1.act_num,'210');
      gkn_po_create_line_proc@r12prd(vline_num,null,'BWTH FEE '||r1.course_code||' '||r1.metro||' '||to_char(r1.start_date,'yyyymmdd'),
                                     'EACH',1,r1.bandwidth_fee,vneed_date,r1.inv_org_id,r1.org_id,
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

    fnd_global_apps_init@r12prd(1111,50248,201,'PO',86) ;  -- CANADIAN REQUEST

    l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
                NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
    commit;


    loop_cnt := 1;
    while loop_cnt < 5 loop
      open c3(v_sid,l_req_id);
      fetch c3 into r3;
      if r3.phase_code = 'C' then
        loop_cnt := 5;
        dbms_lock.sleep(15);
        gk_receive_po_proc(v_curr_po,v_sid);
        gk_receive_request_proc(v_sid);
      else
        loop_cnt := loop_cnt+1;
        dbms_lock.sleep(15);
      end if;
      close c3;
    end loop;
    commit;

    utl_file.put_line(v_file,r1.po_line||chr(9)||v_curr_po);
    utl_file.put_line(v_mt_file,r1.mt_po_line||chr(9)||v_curr_po);

  end loop;

  utl_file.fclose(v_file);
  utl_file.fclose(v_mt_file);

  send_mail_attach('erika.powell@globalknowledge.com','erika.powell@globalknowledge.com','alison.harding@globalknowledge.com',
                   'abigail.campbell@globalknowledge.com','Microtek Fee File-'||r0.ops_country,'Open Excel Attachment to view microtek fees.',v_file_name_full);

  send_mail_attach('erika.powell@globalknowledge.com','kathrynd@mclabs.com',null,null,'Microtek Detail File'||r0.ops_country,
                   'Open Excel Attachment to view microtek details.',v_mt_file_name_full);

  send_mail_attach('erika.powell@globalknowledge.com','erika.powell@globalknowledge.com','alison.harding@globalknowledge.com',
                   'abigail.campbell@globalknowledge.com','Microtek Detail File-'||r0.ops_country,'Open Excel Attachment to view microtek details.',v_mt_file_name_full);

end loop;

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_MICROTEK_FEES_PROC FAILED',SQLERRM);

end;
/


