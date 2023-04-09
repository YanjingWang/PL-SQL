DROP PROCEDURE GKDW.GK_ITP_EXAMS_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_itp_exams_proc is

--ITP VOUCHER EVENT DATA SET
cursor c0 is
select 269 requestor_id, --15139 Carrie Prince
       43258 vendor_id,'SMITHTOWN' vendor_site_code,84 v_org_id,101 v_inv_org_id,
       case when cd.course_code in ('2754W','2761W') then '000' else '130' end fe_num,
       case when cd.course_code in ('2754W','2761W') then '41315' else '62405' end acct_num,
       cd.ch_num,
       case when cd.course_code in ('2754W','2761W') then '44' else cd.md_num end md_num,
       cd.pl_num,
       cd.act_num,
       case when cd.course_code in ('2754W','2761W') then '000' else '200' end cc_num,
       cp.usd_fee unit_price,'USD' curr_code,
       'ITP Exam '||to_char(ed.start_date,'mm/dd/yy')||' '||cd.course_code||' '||ed.city||', '||ed.state po_line_desc,
       'TAX '||to_char(ed.start_date,'mm/dd/yy')||' '||cd.course_code||' '||ed.city||', '||ed.state po_tax_desc,
       ed.event_id, ed.capacity enroll_cnt, --count(distinct f.enroll_id) enroll_cnt, -- SR 08/03/2017 requested by Sheila Jacobs
       cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,ed.status,ed.location_name,a.city,a.state,a.county,a.postalcode,
       ed.start_date,ed.end_date,ie.firstname||' '||ie.lastname instructor,ie.email,
       'N' retake_flag,
       'ITP EXAMS'||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||ed.facility_region_metro||chr(9)||
       count(distinct f.enroll_id)||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||
       a.address1||chr(9)||a.city||chr(9)||a.state||chr(9)||a.postalcode||chr(9)||upper(a.country)||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||
       ie.firstname||' '||ie.lastname||chr(9)||ie.email||chr(9)||ie.feecode po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_itp_courses cp on cd.course_code = cp.course_code and cp.voucher_flag = 'Y'
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
       inner join slxdw.address a on f.facilityaddressid = a.addressid
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status in ('Confirmed','Attended') --and f.fee_type not in ('Ons - Base','Ons-Additional','Ons - Additional')
       inner join cust_dim c on f.cust_id = c.cust_id
 where td1.dim_year = case when td2.dim_week+1>52 then td2.dim_year+1 else td2.dim_year end
   and td1.dim_week = case when td2.dim_week+1>52 then td2.dim_week+1-52 else td2.dim_week+1 end
   and ed.status != 'Cancelled'
   and cd.ch_num = '10'
   and to_char(sysdate,'d') = '5' -- Thursday
   and substr(cp.course_code,-1,1) not in ('V','L')  -- SR 06/19/2018 turned of V and L
   and not exists (select 1 from gk_itp_exam_audit ea where ed.event_id = ea.event_id)
 group by ed.capacity,ed.ops_country,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,cp.cad_fee,cp.usd_fee,cd.vendor_code,cd.course_code,cd.short_name,
       ed.facility_region_metro,ed.status,ed.location_name,a.address1,a.city,a.state,a.county,a.postalcode,upper(a.country),ed.start_date,ed.end_date,
       ie.firstname,ie.lastname,ie.email,ed.city,ed.state,ed.event_id,ie.feecode
union
select 269 requestor_id,
       43258 vendor_id,'SMITHTOWN' vendor_site_code,84 v_org_id,101 v_inv_org_id,
        case when cd.course_code in ('2754W','2761W') then '000' else '130' end fe_num,
       case when cd.course_code in ('2754W','2761W') then '41315' else '62405' end acct_num,
       cd.ch_num,
       case when cd.course_code in ('2754W','2761W') then '44' else cd.md_num end md_num,
       cd.pl_num,
       cd.act_num,
       case when cd.course_code in ('2754W','2761W') then '000' else '200' end cc_num,
       cp.usd_fee unit_price,'USD' curr_code,
       'ITP Exam '||to_char(ed.start_date,'mm/dd/yy')||' '||cd.course_code||' '||ed.city||', '||ed.state po_line_desc,
       'TAX '||to_char(ed.start_date,'mm/dd/yy')||' '||cd.course_code||' '||ed.city||', '||ed.state po_tax_desc,
       ed.event_id,ed.capacity enroll_cnt, --oa.enroll_cnt enroll_cnt, SR 08/03/2017 requested by Sheila Jacobs
       cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,ed.status,ed.location_name,a.city,a.state,a.county,a.postalcode,
       ed.start_date,ed.end_date,ie.firstname||' '||ie.lastname instructor,ie.email,
       'N' retake_flag,
       'ITP EXAMS'||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||ed.facility_region_metro||chr(9)||
       ed.capacity --oa.enroll_cnt -- SR 08/03/2017 requested by Sheila Jacobs
       ||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||
       a.address1||chr(9)||a.city||chr(9)||a.state||chr(9)||a.postalcode||chr(9)||upper(a.country)||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||
       ie.firstname||' '||ie.lastname||chr(9)||ie.email||chr(9)||ie.feecode po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_itp_courses cp on cd.course_code = cp.course_code and cp.voucher_flag = 'Y'
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
       inner join slxdw.address a on f.facilityaddressid = a.addressid
       inner join gk_onsite_attended_cnt_v oa on ed.event_id = oa.event_id
 where td1.dim_year = case when td2.dim_week+1>52 then td2.dim_year+1 else td2.dim_year end
   and td1.dim_week = case when td2.dim_week+1>52 then td2.dim_week+1-52 else td2.dim_week+1 end
   and ed.status != 'Cancelled'
   and cd.ch_num = '20'
   and to_char(sysdate,'d') = '5' -- Thursday
   and substr(cp.course_code,-1,1) not in ('V','L')  -- SR 06/19/2018 turned of V and L
   and not exists (select 1 from gk_itp_exam_audit ea where ed.event_id = ea.event_id) 
 order by ch_num,md_num,event_id;

--ITP VOUCHER DETAIL DATA SET   
cursor c1(v_event_id varchar2) is
select ed.ops_country,ed.event_id,cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,
       ed.start_date,ed.end_date,ie.firstname||' '||ie.lastname instructor,ie.feecode,
       c.cust_name,c.acct_name,c.address1,c.address2,c.city,c.state,c.zipcode,c.country,
       c.email,f.enroll_status,
       case when upper(c.country) in ('CA','CANADA','CAN') or ed.ops_country in ('CA','CANADA','CAN') then '220' else '210' end le_num,
       'ITP EXAMS-'||chr(9)||ed.event_id||'-'||cd.course_code||'-'||c.cust_name po_line_desc,
       td.dim_year||'-'||lpad(td.dim_week,2,'0')||chr(9)||ed.event_id||chr(9)||cd.vendor_code||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||
       ed.facility_region_metro||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||ie.firstname||' '||ie.lastname||chr(9)||ie.feecode||chr(9)||
       c.cust_name||chr(9)||c.acct_name||chr(9)||c.address1||chr(9)||c.address2||chr(9)||c.city||chr(9)||c.state||chr(9)||c.zipcode||chr(9)||
       c.country||chr(9)||c.email||chr(9)||f.enroll_status detail_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
       left outer join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled' and f.fee_type not in ('Ons - Base','Ons-Additional','Ons - Additional')
       left outer join cust_dim c on f.cust_id = c.cust_id
       left outer join time_dim td on ed.start_date = td.dim_date
 where ed.event_id = v_event_id;

--ITP VOUCHER FUTURE EVENT DATA SET
cursor c2 is
select ed.ops_country,ed.event_id,
       ed.capacity enroll_cnt, --case when cd.ch_num = '10' then oe.enroll_cnt else ed.capacity end enroll_cnt, -- SR 08/03/2017 requested by Sheila Jacobs
       cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,ed.status,ed.location_name,a.city,a.state,a.county,a.postalcode,
       ed.start_date,ed.end_date,ie.firstname||' '||ie.lastname instructor,ie.email,
       'ITP EXAMS'||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||ed.facility_region_metro||chr(9)||
       ed.capacity --case when cd.ch_num = '10' then oe.enroll_cnt else ed.capacity end -- SR 08/03/2017 requested by Sheila Jacobs
       ||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||
       a.address1||chr(9)||a.city||chr(9)||a.state||chr(9)||a.postalcode||chr(9)||upper(a.country)||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||
       ie.firstname||' '||ie.lastname||chr(9)||ie.email||chr(9)||ie.feecode po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_itp_courses cp on cd.course_code = cp.course_code and cp.voucher_flag = 'Y'
       inner join instructor_event_v ie on ed.event_id = ie.evxeventid and ie.feecode in ('INS','SI')
       inner join time_dim td1 on ed.start_date = td1.dim_date
       inner join time_dim td2 on td2.dim_date = trunc(sysdate)
       inner join slxdw.evxfacility f on ed.location_id = f.evxfacilityid
       inner join slxdw.address a on f.facilityaddressid = a.addressid
       left outer join gk_onsite_attended_cnt_v oa on ed.event_id = oa.event_id
       left outer join gk_oe_attended_cnt_v oe on ed.event_id = oe.event_id
 where td1.dim_year = case when td2.dim_week+2>52 then td2.dim_year+1 else td2.dim_year end
   and td1.dim_week = case when td2.dim_week+2>52 then td2.dim_week+2-52 else td2.dim_week+2 end
   and ed.status != 'Cancelled'
   and to_char(sysdate,'d') = '5' -- Thursday
   and substr(cp.course_code,-1,1) not in ('V','L')  -- SR 06/19/2018 turned of V and L
 order by ed.start_date,cd.course_code;

-- ITP RETAKE EVENT DATA SET
cursor c3 is
select 269 requestor_id,
       43258 vendor_id,'SMITHTOWN' vendor_site_code,84 v_org_id,101 v_inv_org_id,
        case when cd.course_code in ('2754W','2761W') then '000' else '130' end fe_num,
       case when cd.course_code in ('2754W','2761W') then '41315' else '62405' end acct_num,
       cd.ch_num,
       case when cd.course_code in ('2754W','2761W') then '44' else cd.md_num end md_num,
       cd.pl_num,
       cd.act_num,
       case when cd.course_code in ('2754W','2761W') then '000' else '200' end cc_num,
       cp.usd_fee unit_price,'USD' curr_code,
       'ITP Retake '||to_char(ed.start_date,'mm/dd/yy')||' '||cd.course_code||' '||ed.city||', '||ed.state po_line_desc,
       'TAX '||to_char(ed.start_date,'mm/dd/yy')||' '||cd.course_code||' '||ed.city||', '||ed.state po_tax_desc,
       ed.event_id,
       ed.capacity enroll_cnt,-- count(distinct f.enroll_id) enroll_cnt, -- SR 08/03/2017 requested by Sheila Jacobs
       cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,ed.status,ed.location_name,a.city,a.state,a.county,a.postalcode,
       ed.start_date,ed.end_date,null instructor,null email,
       'Y' retake_flag,
       'ITP RETAKE'||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||ed.facility_region_metro||chr(9)||
       count(distinct f.enroll_id)||chr(9)||ed.status||chr(9)||ed.location_name||chr(9)||
       a.address1||chr(9)||a.city||chr(9)||a.state||chr(9)||a.postalcode||chr(9)||upper(a.country)||chr(9)||ed.start_date||chr(9)||ed.end_date po_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join gk_itp_courses cp on cd.course_code = cp.course_code and cp.retake_flag = 'Y'
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled'
       inner join cust_dim c on f.cust_id = c.cust_id
       left outer join slxdw.evxfacility fa on ed.location_id = fa.evxfacilityid
       left outer join slxdw.address a on fa.facilityaddressid = a.addressid
 where ed.status != 'Cancelled'
   and f.enroll_date >= '17-JAN-2016' --Go-Live
   and substr(cp.course_code,-1,1) not in ('V','L')  -- SR 06/19/2018 turned of V and L
   and not exists (select 1 from gk_itp_retake_audit ir where f.enroll_id = ir.enroll_id)
 group by ed.capacity,ed.ops_country,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,ed.start_date,cd.course_code,ed.city,ed.state,
          ed.event_id,cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,ed.status,ed.location_name,
          a.address1,a.city,a.state,a.county,a.postalcode,upper(a.country),ed.end_date,
          cp.cad_fee,cp.usd_fee
 order by event_id;

cursor c4(v_event_id varchar2) is
select ed.ops_country,ed.event_id,cd.vendor_code,cd.course_code,cd.short_name,ed.facility_region_metro,
       f.book_date,null instructor,null feecode,
       c.cust_name,c.acct_name,c.address1,c.address2,c.city,c.state,c.zipcode,c.country,
       c.email,f.enroll_id,f.enroll_status,
       case when upper(c.country) in ('CA','CANADA','CAN') then '220' else '210' end le_num,
       'ITP Retake-'||cd.course_code||'-'||c.cust_name||'-'||c.acct_name po_line_desc,
       td.dim_year||'-'||lpad(td.dim_week,2,'0')||chr(9)||ed.event_id||chr(9)||cd.vendor_code||chr(9)||cd.course_code||chr(9)||cd.short_name||chr(9)||
       ed.facility_region_metro||chr(9)||f.enroll_date||chr(9)||f.enroll_date||chr(9)||null||chr(9)||null||chr(9)||
       c.cust_name||chr(9)||c.acct_name||chr(9)||c.address1||chr(9)||c.address2||chr(9)||c.city||chr(9)||c.state||chr(9)||c.zipcode||chr(9)||
       c.country||chr(9)||c.email||chr(9)||f.enroll_status||chr(9)||'Y' detail_line
  from event_dim ed
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
       inner join order_fact f on ed.event_id = f.event_id and f.enroll_status != 'Cancelled' and f.fee_type not in ('Ons - Base','Ons-Additional','Ons - Additional')
       inner join cust_dim c on f.cust_id = c.cust_id
       inner join time_dim td on f.enroll_date = td.dim_date
 where ed.event_id = v_event_id
   and f.enroll_date >= '17-JAN-2016' --Go-Live
   and not exists (select 1 from gk_itp_retake_audit ir where f.enroll_id = ir.enroll_id)
 order by dim_week,start_date,event_id,instructor;


v_sid varchar2(10) := 'R12PRD';
v_file utl_file.file_type;
v_file_name varchar2(100);
v_file_name_full varchar2(250);
v_detail_file utl_file.file_type;
v_detail_name varchar2(100);
v_detail_name_full varchar2(250);
v_hdr varchar2(2000);
v_detail_hdr varchar2(2000);
v_error number;
v_error_msg varchar2(500);
v_curr_po varchar2(25);
v_po_week varchar2(25);
vcode_comb_id number;
l_req_id number;
v_rate number;
v_jur varchar2(250);
v_geo number;
v_curr_week number := 0;
v_curr_event varchar2(25) := 'NONE';
v_detail_line varchar2(2000);
r0 c0%rowtype;
r3 c3%rowtype;
v_line_num number;

begin

open c0;fetch c0 into r0;
if c0%FOUND then
close c0;

--WEEKLY ITP EXAM VOUCHER PROCESS
select 'itp_exam_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
       '/usr/tmp/itp_exam_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
       'itp_exam_detail_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
       '/usr/tmp/itp_exam_detail_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls'
  into v_file_name,v_file_name_full,v_detail_name,v_detail_name_full
  from dual;

select distinct td.dim_year||'-'||lpad(td.dim_week,2,'0') into v_po_week
  from time_dim td
       inner join time_dim td1 on td.dim_year = case when td1.dim_week>52 then td1.dim_year+1 else td1.dim_year end 
                               and td.dim_week = case when td1.dim_week+2>52 then td1.dim_week+2-52 else td1.dim_week+2 end
 where td1.dim_date = trunc(sysdate);

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
v_detail_file := utl_file.fopen('/usr/tmp',v_detail_name,'w');

v_hdr := 'Vendor Code'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||'Metro'||chr(9)||'Conf Enrollments';
v_hdr := v_hdr||chr(9)||'Status'||chr(9)||'Location'||chr(9)||'Address1'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Zipcode'||chr(9)||'Country';
v_hdr := v_hdr||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'Instructor'||chr(9)||'Email'||chr(9)||'Feecode'||chr(9)||'PO Num';
utl_file.put_line(v_file,v_hdr);

v_detail_hdr := 'Week'||chr(9)||'Event ID'||chr(9)||'Vendor Code'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||'Metro'||chr(9)||'Start Date'||chr(9)||'End Date';
v_detail_hdr := v_detail_hdr||chr(9)||'Instructor'||chr(9)||'Feecode'||chr(9)||'Cust Name'||chr(9)||'Acct Name'||chr(9)||'Address1'||chr(9)||'Address2'||chr(9)||'City';
v_detail_hdr := v_detail_hdr||chr(9)||'State'||chr(9)||'Zipcode'||chr(9)||'Country'||chr(9)||'Email'||chr(9)||'Enroll Status';
utl_file.put_line(v_detail_file,v_detail_hdr);

for r0 in c0 loop
  select gk_get_curr_po(r0.v_org_id,v_sid) into v_curr_po from dual;
  gk_update_curr_po(r0.v_org_id,v_sid);

  gkn_po_create_hdr_proc@r12prd(v_curr_po,r0.vendor_id,r0.vendor_site_code,r0.v_org_id,264,r0.curr_code,r0.po_line_desc);

  utl_file.put_line(v_file,r0.po_line||chr(9)||v_curr_po);
  
  v_line_num := 1;
  for r1 in c1(r0.event_id) loop
    vcode_comb_id := gkn_get_account@r12prd(r1.le_num,r0.fe_num,r0.acct_num,r0.ch_num,r0.md_num,r0.pl_num,r0.act_num,r0.cc_num);
    gkn_po_create_line_proc@r12prd(v_line_num,null,r1.po_line_desc,'EACH',1,r0.unit_price,r0.start_date,r0.v_inv_org_id,r0.v_org_id,vcode_comb_id,'CARY',r0.requestor_id,r0.event_id,126);
    
    utl_file.put_line(v_detail_file,r1.detail_line);
    v_line_num := v_line_num + 1;
  end loop;

--  gk_calc_tax_gilmore@vertex(r0.v_org_id,r0.city,r0.state,r0.postalcode,r0.county,'S',r0.state,null,r0.start_date,v_rate,v_jur,v_geo);
--  commit;
--  if v_rate > 0 and r0.md_num = '10' and r0.v_org_id = 84 then
--     v_line_num := v_line_num+1;
--     gkn_po_create_line_proc@r12prd(v_line_num,null,r0.po_tax_desc,'EACH',1,(r0.unit_price*r0.enroll_cnt)*v_rate,r0.start_date,r0.v_inv_org_id,r0.v_org_id,vcode_comb_id,'CARY',r0.requestor_id,r0.event_id,126);
--  end if;
  
  insert into gk_itp_exam_audit
    select r0.event_id,v_curr_po,r0.enroll_cnt,r0.unit_price,sysdate,r0.curr_code from dual;
  commit;
  
end loop;

for r2 in c2 loop
  utl_file.put_line(v_file,r2.po_line);
end loop;

utl_file.fclose(v_file);
utl_file.fclose(v_detail_file);

v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'cait.bauer@globalknowledge.com',
          Recipient => 'cait.bauer@globalknowledge.com',
          CcRecipient => 'Christa.Joyce@globalknowledge.com',
          BccRecipient => '',
          Subject   => 'ITP EXAM PO FOR WEEK OF '||v_po_week,
          Body => 'Open Attached File',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));
          
v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'cait.bauer@globalknowledge.com',
          Recipient => 'ginny.oswald@globalknowledge.com',
          CcRecipient => 'Kayla.Walker@globalknowledge.com',
          BccRecipient => '',
          Subject   => 'ITP EXAM PO FOR WEEK OF '||v_po_week,
          Body => 'Open Attached File',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));

v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'cait.bauer@globalknowledge.com',
          Recipient => 'Education.NA@ITpreneurs.com',
          CcRecipient => '',
          BccRecipient => '',
          Subject   => 'ITP EXAM PO FOR WEEK OF '||v_po_week,
          Body => 'Open Attached File',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));
          
v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'cait.bauer@globalknowledge.com',
          Recipient => 'halina.pacynko@globalknowledge.com',
          CcRecipient => 'Madalene.Wilson@globalknowledge.com',
          BccRecipient => 'sruthi.reddy@globalknowledge.com',
          Subject   => 'ITP EXAM PO FOR WEEK OF '||v_po_week,
          Body => 'Open Attached File',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));
else
  close c0;
end if;

--WEEKLY ITP RETAKE VOUCHER PROCESS

open c3;fetch c3 into r3;
if c3%FOUND then
close c3;

  select 'itp_retake_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
         '/usr/tmp/itp_retake_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
         'itp_retake_detail_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls',
         '/usr/tmp/itp_retake_detail_'||to_char(sysdate,'yyyymmddhh24miss')||'.xls'
    into v_file_name,v_file_name_full,v_detail_name,v_detail_name_full
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  v_detail_file := utl_file.fopen('/usr/tmp',v_detail_name,'w');

  v_hdr := 'Vendor Code'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||'Metro'||chr(9)||'Conf Enrollments';
  v_hdr := v_hdr||chr(9)||'Status'||chr(9)||'Location'||chr(9)||'Address1'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Zipcode'||chr(9)||'Country';
  v_hdr := v_hdr||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'PO Num';
  utl_file.put_line(v_file,v_hdr);

  v_detail_hdr := 'Week'||chr(9)||'Event ID'||chr(9)||'Vendor Code'||chr(9)||'Course Code'||chr(9)||'Short Name'||chr(9)||'Metro'||chr(9)||'Start Date'||chr(9)||'End Date';
  v_detail_hdr := v_detail_hdr||chr(9)||'Instructor'||chr(9)||'Feecode'||chr(9)||'Cust Name'||chr(9)||'Acct Name'||chr(9)||'Address1'||chr(9)||'Address2'||chr(9)||'City';
  v_detail_hdr := v_detail_hdr||chr(9)||'State'||chr(9)||'Zipcode'||chr(9)||'Country'||chr(9)||'Email'||chr(9)||'Enroll Status'||chr(9)||'Retake';
  utl_file.put_line(v_detail_file,v_detail_hdr);
  
  for r3 in c3 loop
    select gk_get_curr_po(r3.v_org_id,v_sid) into v_curr_po from dual;
    gk_update_curr_po(r3.v_org_id,v_sid);

    gkn_po_create_hdr_proc@r12prd(v_curr_po,r3.vendor_id,r3.vendor_site_code,r3.v_org_id,264,r3.curr_code,r3.po_line_desc);

    utl_file.put_line(v_file,r3.po_line||chr(9)||v_curr_po);
  
    v_line_num := 1;
    for r4 in c4(r3.event_id) loop
      vcode_comb_id := gkn_get_account@r12prd(r4.le_num,r3.fe_num,r3.acct_num,r3.ch_num,r3.md_num,r3.pl_num,r3.act_num,r3.cc_num);
      gkn_po_create_line_proc@r12prd(v_line_num,null,r4.po_line_desc,'EACH',1,r3.unit_price,r4.book_date,r3.v_inv_org_id,r3.v_org_id,vcode_comb_id,'CARY',r3.requestor_id,r3.event_id,126);

      utl_file.put_line(v_detail_file,r4.detail_line);
 
      insert into gk_itp_retake_audit
        select r4.enroll_id,v_curr_po,r3.unit_price,sysdate,r3.curr_code from dual;

      v_line_num := v_line_num+1;
    end loop;
    commit;
    
--    gk_calc_tax_gilmore@vertex(r3.v_org_id,r3.city,r3.state,r3.postalcode,r3.county,'S',r3.state,null,r3.start_date,v_rate,v_jur,v_geo);
--    if v_rate > 0 and r3.md_num = '10' and r3.v_org_id = 84 then
--       v_line_num := v_line_num +1;
--       gkn_po_create_line_proc@r12prd(2,null,r3.po_tax_desc,'EACH',1,r3.unit_price*v_rate,r3.start_date,r3.v_inv_org_id,r3.v_org_id,vcode_comb_id,'CARY',r3.requestor_id,r3.event_id,126);
--    end if;
--    commit;
  end loop;

  utl_file.fclose(v_file);
  utl_file.fclose(v_detail_file);

  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'cait.bauer@globalknowledge.com',
            Recipient => 'cait.bauer@globalknowledge.com',
            CcRecipient => '',
            BccRecipient => '',
            Subject   => 'ITP RETAKE '||to_char(sysdate,'dd-Mon-yy'),
            Body => 'Open Attached File',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));
          
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'cait.bauere@globalknowledge.com',
            Recipient => 'ginny.oswald@globalknowledge.com',
            CcRecipient => '',
            BccRecipient => '',
            Subject   => 'ITP RETAKE '||to_char(sysdate,'dd-Mon-yy'),
            Body => 'Open Attached File',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));

  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'cait.bauer@globalknowledge.com',
            Recipient => 'Education.NA@ITpreneurs.com',
            CcRecipient => '',
            BccRecipient => '',
            Subject   => 'ITP RETAKE '||to_char(sysdate,'dd-Mon-yy'),
            Body => 'Open Attached File',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));
          
  v_error:= SendMailJPkg.SendMail(
            SMTPServerName => 'corpmail.globalknowledge.com',
            Sender    => 'cait.bauer@globalknowledge.com',
            Recipient => 'halina.pacynko@globalknowledge.com',
            CcRecipient => '',
            BccRecipient => 'sruthi.reddy@globalknowledge.com',
            Subject   => 'ITP RETAKE '||to_char(sysdate,'dd-Mon-yy'),
            Body => 'Open Attached File',
            ErrorMessage => v_error_msg,
            Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_name_full,v_detail_name_full));

  fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;  -- US REQUEST

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
else
  close c3;
end if;

exception
  when others then
    rollback;
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_ITP_EXAMS_PROC Failed',SQLERRM);
    
end;
/


