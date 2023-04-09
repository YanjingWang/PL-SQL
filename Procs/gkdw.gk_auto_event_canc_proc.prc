DROP PROCEDURE GKDW.GK_AUTO_EVENT_CANC_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_auto_event_canc_proc as

cursor c0 is
select ed.event_id,ed.ops_country,ed.course_code,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
       cd.short_name,cd.course_pl,ed.connected_c,ed.connected_v_to_c,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
       ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
  from gk_event_cnt_v@slx ge
       inner join event_dim ed on ge.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
                               and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week,2,'0')
                               and case when td2.dim_week+4 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+4-52,2,'0')
                                        else  td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
                                   end
 where cd.ch_num = '10'
   and cd.md_num = '10'
   and nvl(cd.pl_num,'0') not in ('07','17') -- Development exclusion requested by Doug -- SR 01/12/2018 Requested by Chris Barefoot
   and ed.ops_country = 'USA'
   and to_char(sysdate,'D') = '4'
   and ge.enroll_cnt = 0
   and ge.jeopardyflag != 'Special'
   and ed.course_code not in (
       select master_course_code from gk_nested_courses
       union
       select nested_course_code from gk_nested_courses)
   and substr(ed.course_code,1,4) not in ('3330','6282','8268','8558','8673','8557','8614','8615','8270','8269','2459','2460','2461',
                                          '0580','0581','0582','0583','0584','0585','0586','0587','0588','0589','0590','6563','0741',
                                          '0748','1837','1958','2057','2058','2059','3573','6336','6337','6338','6339','6341','9888') -- SR 08/01 added '6336','6337','6338','6339','6341' - C modality
   and ed.event_id not in ('Q6UJ9APXZMNF','Q6UJ9APXZMNG','Q6UJ9APXZMNH','Q6UJ9APXZMNI','Q6UJ9APY0BG0','Q6UJ9APY4ORQ','Q6UJ9APY4OQS','Q6UJ9APY4OQR',
                           'Q6UJ9APY4OQQ','Q6UJ9APY4OQP','Q6UJ9APY4OQJ','Q6UJ9APY4OQ9','Q6UJ9APY4OQ8','Q6UJ9APY4OQ7','Q6UJ9APY4OQ6')
   and upper(cd.course_type) not in ('CITRIX','VIRTUAL SHORT COURSE')
 order by 2,5;

cursor c1 is
select ed.event_id,ed.ops_country,ed.course_code,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
       cd.short_name,cd.course_pl,ed.connected_c,ed.connected_v_to_c,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
       ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
  from gk_event_cnt_v@slx ge
       inner join event_dim ed on ge.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
                               and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week,2,'0')
                               and case when td2.dim_week+4 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+4-52,2,'0')
                                        else  td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
                                   end where cd.ch_num = '10'
   and cd.md_num = '10'
   and nvl(cd.pl_num,'0') not in ('07','17') -- Development exclusion requested by Doug -- SR 01/12/2018 Requested by Chris Barefoot
   and ed.ops_country = 'CANADA'
   and ed.facility_region_metro != 'SJF'
   and to_char(sysdate,'D') = '4'
   and ge.enroll_cnt = 0
   and ge.jeopardyflag != 'Special'
   and ed.course_code not in (
       select master_course_code from gk_nested_courses
       union
       select nested_course_code from gk_nested_courses)
   and substr(ed.course_code,1,4) not in ('3330','6282','8268','8558','8673','8557','8614','8615','8270','8269','2459','2460','2461',
                                          '0580','0581','0582','0583','0584','0585','0586','0587','0588','0589','0590','6563','0741',
                                          '0748','1837','1958','2057','2058','2059','3573','6336','6337','6338','6339','6341','9888') -- SR 08/01 added '6336','6337','6338','6339','6341' - C modality
   and ed.event_id not in ('Q6UJ9APXZMNF','Q6UJ9APXZMNG','Q6UJ9APXZMNH','Q6UJ9APXZMNI','Q6UJ9APY0BG0','Q6UJ9APY4ORQ','Q6UJ9APY4OQS','Q6UJ9APY4OQR',
                           'Q6UJ9APY4OQQ','Q6UJ9APY4OQP','Q6UJ9APY4OQJ','Q6UJ9APY4OQ9','Q6UJ9APY4OQ8','Q6UJ9APY4OQ7','Q6UJ9APY4OQ6')
   and upper(cd.course_type) not in ('CITRIX','VIRTUAL SHORT COURSE')
 union
 select ed.event_id,ed.ops_country,ed.course_code,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
        cd.short_name,cd.course_pl,ed.connected_c,ed.connected_v_to_c,
        ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
        ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
   from gk_event_cnt_v@slx ge
        inner join event_dim ed on ge.evxeventid = ed.event_id
        inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
  where cd.course_code like '88%G'
    and ed.ops_country = 'CANADA'
    and ed.facility_region_metro != 'SJF'
    and ed.event_id not in ('Q6UJ9APXZMNF','Q6UJ9APXZMNG','Q6UJ9APXZMNH','Q6UJ9APXZMNI','Q6UJ9APY0BG0','Q6UJ9APY4ORQ','Q6UJ9APY4OQS','Q6UJ9APY4OQR',
                           'Q6UJ9APY4OQQ','Q6UJ9APY4OQP','Q6UJ9APY4OQJ','Q6UJ9APY4OQ9','Q6UJ9APY4OQ8','Q6UJ9APY4OQ7','Q6UJ9APY4OQ6')
    and ge.enroll_cnt = 0
  order by 2,5;

cursor c2(p_country varchar2) is 
select ed.event_id,ed.ops_country,ed.course_code,cd.short_name,cd.course_pl,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
       ed.connected_c,ed.connected_v_to_c,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
       ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
  from gk_event_cnt_v@slx ge
       inner join event_dim ed on ge.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
                               and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week,2,'0') and
                                   case --when ed.ops_country = 'CANADA' and td2.dim_week+4 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+4-52,2,'0') -- SR 02/16 ticket# 124738
                                        --when ed.ops_country = 'CANADA' then td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
                                        when td2.dim_week+6 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+6-52,2,'0')
                                        else td2.dim_year||'-'||lpad(td2.dim_week+6,2,'0')
                                   end
 where cd.ch_num = '10'
   and cd.md_num = '10'
   and nvl(cd.pl_num,'0') not in ('07','17') -- Development exclusion requested by Doug -- SR 01/12/2018 Requested by Chris Barefoot
   and ed.ops_country = p_country
   and ge.enroll_cnt = 0
   and trunc(ed.creation_date) < trunc(sysdate)-7
   and ed.facility_region_metro != 'SJF'
   and ge.jeopardyflag != 'Special'
   and ed.course_code not in (
       select master_course_code from gk_nested_courses
       union
       select nested_course_code from gk_nested_courses)
   and substr(ed.course_code,1,4) not in ('3330','6282','8268','8558','8673','8557','8614','8615','8270','8269','2459','2460','2461',
                                          '0580','0581','0582','0583','0584','0585','0586','0587','0588','0589','0590','6563','0741',
                                          '0748','1837','1958','2057','2058','2059','3573','6336','6337','6338','6339','6341','7260','7265','7264','9888') -- SR 08/01 added '6336','6337','6338','6339','6341' - C modality #SR 03/27/18
   and ed.event_id not in ('Q6UJ9APXZMNF','Q6UJ9APXZMNG','Q6UJ9APXZMNH','Q6UJ9APXZMNI','Q6UJ9APY0BG0','Q6UJ9APY4ORQ','Q6UJ9APY4OQS','Q6UJ9APY4OQR',
                           'Q6UJ9APY4OQQ','Q6UJ9APY4OQP','Q6UJ9APY4OQJ','Q6UJ9APY4OQ9','Q6UJ9APY4OQ8','Q6UJ9APY4OQ7','Q6UJ9APY4OQ6')
   and upper(cd.course_type) not in ('CITRIX','VIRTUAL SHORT COURSE')
union   
   -- C modality courses for product line MS apps at 3 weeks -- SR 05/03/2018 ticket# 145302
select ed.event_id,ed.ops_country,ed.course_code,cd.short_name,cd.course_pl,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
       ed.connected_c,ed.connected_v_to_c,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
       ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
  from gk_event_cnt_v@slx ge
       inner join event_dim ed on ge.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
                              and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week,2,'0') and
                                   case --when ed.ops_country = 'CANADA' and td2.dim_week+4 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+4-52,2,'0') -- SR 02/16 ticket# 124738
--                                        --when ed.ops_country = 'CANADA' then td2.dim_year||'-'||lpad(td2.dim_week+4,2,'0')
                                        when td2.dim_week+3 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+3-52,2,'0')
                                        else td2.dim_year||'-'||lpad(td2.dim_week+3,2,'0')
                                  end
 where cd.ch_num = '10'
   and cd.md_num = '10'
   and cd.pl_num ='17' 
   and ed.ops_country = p_country
   and ge.enroll_cnt = 0
   and trunc(ed.creation_date) < trunc(sysdate)-7
   and ed.facility_region_metro != 'SJF'
   and ge.jeopardyflag != 'Special'
   and ed.course_code not in (
       select master_course_code from gk_nested_courses
       union
       select nested_course_code from gk_nested_courses)
union
select ed.event_id,ed.ops_country,ed.course_code,cd.short_name,cd.course_pl,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
       ed.connected_c,ed.connected_v_to_c,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
       ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
  from gk_event_cnt_v@slx ge
       inner join event_dim ed on ge.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
                               and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week,2,'0')
                               and case when td2.dim_week+5 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+5-52,2,'0')
                                        else  td2.dim_year||'-'||lpad(td2.dim_week+5,2,'0')
                                   end
 where cd.ch_num = '10'
   and cd.md_num = '20'
   and nvl(cd.pl_num,'0') not in ('07','17') -- Development exclusion requested by Doug -- SR 01/12/2018 Requested by Chris Barefoot
   and ed.ops_country = p_country
   and ge.enroll_cnt = 0
   and trunc(ed.creation_date) < trunc(sysdate)-7
   and ed.connected_v_to_c is null
   and ge.jeopardyflag != 'Special'
   and ed.course_code not in (
       select master_course_code from gk_nested_courses
       union
       select nested_course_code from gk_nested_courses)
   and substr(ed.course_code,1,4) not in ('3330','6282','8268','8558','8673','8557','8614','8615','8270','8269','2459','2460','2461',
                                          '0580','0581','0582','0583','0584','0585','0586','0587','0588','0589','0590','6563','0741',
                                          '0748','1837','1958','2057','2058','2059','3573','6341','9888')-- SR 08/01 added 6341L
   and ed.event_id not in ('Q6UJ9APXZMNF','Q6UJ9APXZMNG','Q6UJ9APXZMNH','Q6UJ9APXZMNI','Q6UJ9APY0BG0','Q6UJ9APY4ORQ','Q6UJ9APY4OQS','Q6UJ9APY4OQR',
                           'Q6UJ9APY4OQQ','Q6UJ9APY4OQP','Q6UJ9APY4OQJ','Q6UJ9APY4OQ9','Q6UJ9APY4OQ8','Q6UJ9APY4OQ7','Q6UJ9APY4OQ6')
   and upper(cd.course_type) not in ('CITRIX','VIRTUAL SHORT COURSE')
   and not exists (select 1 from gk_ext_events_v s where ed.event_id = s.event_id)
union
select ed.event_id,ed.ops_country,ed.course_code,cd.short_name,cd.course_pl,ed.facility_code,ed.location_name,ed.start_date,ge.enroll_cnt,
       ed.connected_c,ed.connected_v_to_c,
       ed.event_id||chr(9)||ed.ops_country||chr(9)||ed.course_code||chr(9)||ed.facility_region_metro||chr(9)||
       ed.facility_code||chr(9)||ed.location_name||chr(9)||ed.start_date||chr(9)||ed.reseller_event_id v_line
  from gk_event_cnt_v@slx ge
       inner join event_dim ed on ge.evxeventid = ed.event_id
       inner join gk_event_cnt_v@slx ge2 on ed.connected_v_to_c = ge2.evxeventid and ge2.enroll_cnt = 0
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
                               and td1.dim_year||'-'||lpad(td1.dim_week,2,'0') between td2.dim_year||'-'||lpad(td2.dim_week,2,'0')
                               and case when td2.dim_week+5 > 52 then td2.dim_year+1||'-'||lpad(td2.dim_week+5-52,2,'0')
                                        else  td2.dim_year||'-'||lpad(td2.dim_week+5,2,'0')
                                   end
 where cd.ch_num = '10'
   and cd.md_num = '20'
   and nvl(cd.pl_num,'0') not in ('07','17') -- Development exclusion requested by Doug -- SR 01/12/2018 Requested by Chris Barefoot
   and ed.ops_country = p_country
   and ge.enroll_cnt = 0
   and trunc(ed.creation_date) < trunc(sysdate)-7
   and ge.jeopardyflag != 'Special'
   and ed.course_code not in (
       select master_course_code from gk_nested_courses
       union
       select nested_course_code from gk_nested_courses)
   and substr(ed.course_code,1,4) not in ('3330','6282','8268','8558','8673','8557','8614','8615','8270','8269','2459','2460','2461',
                                          '0580','0581','0582','0583','0584','0585','0586','0587','0588','0589','0590','6563','0741',
                                          '0748','1837','1958','2057','2058','2059','3573','6341','9888') -- SR 08/01 added 6341L
   and upper(cd.course_type) not in ('CITRIX','VIRTUAL SHORT COURSE')
   and ed.event_id not in ('Q6UJ9APXZMNF','Q6UJ9APXZMNG','Q6UJ9APXZMNH','Q6UJ9APXZMNI','Q6UJ9APY0BG0','Q6UJ9APY4ORQ','Q6UJ9APY4OQS','Q6UJ9APY4OQR',
                           'Q6UJ9APY4OQQ','Q6UJ9APY4OQP','Q6UJ9APY4OQJ','Q6UJ9APY4OQ9','Q6UJ9APY4OQ8','Q6UJ9APY4OQ7','Q6UJ9APY4OQ6')
   and not exists (select 1 from gk_ext_events_v s where ed.event_id = s.event_id)
 order by course_pl,course_code;

r0 c0%rowtype;
r1 c1%rowtype;
r2 c2%rowtype;
v_modify_date varchar2(50);
v_cancel_date varchar2(50);
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
x varchar2(1000);
v_email varchar2(1) := 'N';

begin

rms_link_set_proc;

execute immediate 'alter session set nls_date_format = "DD-MON-YYYY HH24:MI:SS"';

select to_char(sysdate+7/1440,'yyyy-mm-dd HH24:MI:SS') into v_modify_date from dual;
select to_char(sysdate,'yyyy-mm-dd') into v_cancel_date from dual;

select 'auto_event_canc_'||to_char(sysdate,'yyyymmdd')||'_USA.xls',
       '/usr/tmp/auto_event_canc_'||to_char(sysdate,'yyyymmdd')||'_USA.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Event ID'||chr(9)||'Country'||chr(9)||'Course Code'||chr(9)||'Metro'||chr(9)||'Facility Code'||chr(9)||'Facility'||chr(9)||'Start Date'||chr(9)||'Reseller Event ID'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

open c0; loop
  fetch c0 into r0; exit when c0%NOTFOUND;
    
  insert into gk_auto_event_canc_audit values
  (r0.event_id,r0.ops_country,r0.course_code,r0.short_name,r0.course_pl,r0.facility_code,r0.location_name,r0.start_date,r0.enroll_cnt,r0.connected_c,r0.connected_v_to_c,sysdate);
  commit;

  utl_file.put_line(v_file,r0.v_line);

  update evxevent@slx
     set modifyuser = 'ADMIN',
         modifydate = v_modify_date,
         eventstatus = 'Cancelled',
         allowenrollment = 'F',
         allowtransferin = 'F',
         permitenrollment = 'F',
         permittransferin = 'F',
         canceldate = v_cancel_date,
         cancelreason = 'Low Enrollment'
   where evxeventid = r0.event_id;
  commit;
  v_email := 'Y';
end loop;
close c0;
commit;

open c2('USA'); loop
  fetch c2 into r2; exit when c2%NOTFOUND;
  
  insert into gk_auto_event_canc_audit values
  (r2.event_id,r2.ops_country,r2.course_code,r2.short_name,r2.course_pl,r2.facility_code,r2.location_name,r2.start_date,r2.enroll_cnt,r2.connected_c,r2.connected_v_to_c,sysdate);
  commit;
  
  utl_file.put_line(v_file,r2.v_line);

  update evxevent@slx
     set modifyuser = 'ADMIN',
         modifydate = v_modify_date,
         eventstatus = 'Cancelled',
         allowenrollment = 'F',
         allowtransferin = 'F',
         permitenrollment = 'F',
         permittransferin = 'F',
         canceldate = v_cancel_date,
         cancelreason = 'Low Enrollment'
   where evxeventid = r2.event_id;
  commit;
  
  if r2.connected_c = 'Y' then
    delete from "connected_events"@rms_prod where "parent_evxeventid" = r2.event_id;
    commit;
    
    update "schedule"@rms_prod
       set "connected_parent" = 'F'
     where "slx_id" = r2.event_id;
    commit;
    
    delete from gk_connected_events@slx where parent_evxeventid = r2.event_id;
    commit;
    
  end if;
  
  if r2.connected_v_to_c is not null then
    delete from "connected_events"@rms_prod where "child_evxeventid" = r2.event_id;
    commit;
    
    update "schedule"@rms_prod
       set "connected_child" = 'F'
     where "slx_id" = r2.event_id;
    commit;
    
    delete from gk_connected_events@slx where child_evxeventid = r2.event_id;
    commit;
    
  end if;
  v_email := 'Y';
end loop;
close c2;
commit;

utl_file.fclose(v_file);

if v_email = 'Y' then
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'krissi.fields@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Auto Event Cancellation Complete',
             Body => 'Open Excel Attachment to view events that were cancelled.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'erika.powell@globalknowledge.com',
             CcRecipient => 'alison.harding@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Auto Event Cancellation Complete',
             Body => 'Open Excel Attachment to view events that were cancelled.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));
end if;
v_email := 'N';

select 'auto_event_canc_'||to_char(sysdate,'yyyymmdd')||'_CANADA.xls',
       '/usr/tmp/auto_event_canc_'||to_char(sysdate,'yyyymmdd')||'_CANADA.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Event ID'||chr(9)||'Country'||chr(9)||'Course Code'||chr(9)||'Metro'||chr(9)||'Facility Code'||chr(9)||'Facility'||chr(9)||'Start Date'||chr(9)||'Reseller Event ID'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

open c1; loop
  fetch c1 into r1; exit when c1%NOTFOUND;
  
  insert into gk_auto_event_canc_audit values
  (r1.event_id,r1.ops_country,r1.course_code,r1.short_name,r1.course_pl,r1.facility_code,r1.location_name,r1.start_date,r1.enroll_cnt,r1.connected_c,r1.connected_v_to_c,sysdate);
  commit;

  utl_file.put_line(v_file,r1.v_line);

  update evxevent@slx
     set modifyuser = 'ADMIN',
         modifydate = v_modify_date,
         eventstatus = 'Cancelled',
         allowenrollment = 'F',
         allowtransferin = 'F',
         permitenrollment = 'F',
         permittransferin = 'F',
         canceldate = v_cancel_date,
         cancelreason = 'Low Enrollment'
   where evxeventid = r1.event_id;
  commit;
  v_email := 'Y';
end loop;
close c1;
commit;

open c2('CANADA'); loop
  fetch c2 into r2; exit when c2%NOTFOUND;
  
  insert into gk_auto_event_canc_audit values
  (r2.event_id,r2.ops_country,r2.course_code,r2.short_name,r2.course_pl,r2.facility_code,r2.location_name,r2.start_date,r2.enroll_cnt,r2.connected_c,r2.connected_v_to_c,sysdate);
  commit;
  
  utl_file.put_line(v_file,r2.v_line);

  update evxevent@slx
     set modifyuser = 'ADMIN',
         modifydate = v_modify_date,
         eventstatus = 'Cancelled',
         allowenrollment = 'F',
         allowtransferin = 'F',
         permitenrollment = 'F',
         permittransferin = 'F',
         canceldate = v_cancel_date,
         cancelreason = 'Low Enrollment'
   where evxeventid = r2.event_id;
  commit;
  
  if r2.connected_c = 'Y' then
    delete from "connected_events"@rms_prod where "parent_evxeventid" = r2.event_id;
    commit;
    
    update "schedule"@rms_prod
       set "connected_parent" = 'F'
     where "slx_id" = r2.event_id;
    commit;
    
    delete from gk_connected_events@slx where parent_evxeventid = r2.event_id;
    commit;
    
  end if;
  
  if r2.connected_v_to_c is not null then
    delete from "connected_events"@rms_prod where "child_evxeventid" = r2.event_id;
    commit;
    
    update "schedule"@rms_prod
       set "connected_child" = 'F'
     where "slx_id" = r2.event_id;
    commit;
    
    delete from gk_connected_events@slx where child_evxeventid = r2.event_id;
    commit;
    
  end if;
  v_email := 'Y';
end loop;
close c2;
commit;

utl_file.fclose(v_file);

if v_email = 'Y' then
  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'krissi.fields@globalknowledge.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Auto Event Cancellation Complete',
             Body => 'Open Excel Attachment to view events that were cancelled.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));


  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'erika.powell@globalknowledge.com',
             CcRecipient => 'alison.harding@globalknowledge.com',
             BccRecipient => '',
             Subject   => 'Auto Event Cancellation Complete',
             Body => 'Open Excel Attachment to view events that were cancelled.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

  v_error := SendMailJPkg.SendMail(
             SMTPServerName => 'corpmail.globalknowledge.com',
             Sender    => 'DW.Automation@globalknowledge.com',
             Recipient => 'jnash@nexientlearning.com',
             CcRecipient => '',
             BccRecipient => '',
             Subject   => 'Auto Event Cancellation Complete',
             Body => 'Open Excel Attachment to view events that were cancelled.',
             ErrorMessage => v_error_msg,
             Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full));

end if;

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_AUTO_EVENT_CANC_PROC Failed',SQLERRM);

end;
/


