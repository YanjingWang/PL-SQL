DROP PROCEDURE GKDW.GK_CD_FEE_PROC_DEC_SB;

CREATE OR REPLACE PROCEDURE GKDW.gk_cd_fee_proc_dec_sb(p_name varchar2) as

cursor c0 is
select cd.course_code,cf.primary_poc contact_name,cf.primary_poc_email contact_email,cf.vendor_name contact_company,cf.vendor_num,cf.vendor_name,
       cf.vendor_site_code,cf.fee_type,upper(cf.payment_unit) payment_unit,cf.content_type payment_type,cf.fee_rate payment_amount,cf.to_date expiration,
       cf.product_manager product_manager,ed.ops_country country,cf.payment_curr currency,
       case when cf.vendor_num = '10258' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else '210' 
       end le_num,
       '130' fe_num,
       case when cf.vendor_num = '20863' then '62405' else '62425' end acct_num,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       '200' cc_num,
       ed.event_id,ed.start_date,ed.end_date,ed.ops_country,ed.facility_region_metro,
       sum(sc.numstudents),
       sum(sc.revamt),
       case when upper(cf.payment_unit) = 'PER STUDENT' then cf.fee_rate*sum(sc.numstudents)
            when upper(cf.payment_unit) like '% OF REVENUE' then (cf.fee_rate/100)*sum(sc.revamt)
       end cd_fee_amt,
       case when vs.vendor_site_id is not null then 'Y' else 'N' end valid_vendor_site,
       cf.pm_email,
       cf.vendor_name||chr(9)||cf.primary_poc||chr(9)||cf.primary_poc_email||chr(9)||cf.vendor_num||chr(9)||cf.vendor_name||chr(9)||
       cf.vendor_site_code||chr(9)||cd.course_code||chr(9)||cf.fee_type||chr(9)||cf.payment_unit||chr(9)||cf.content_type||chr(9)||cf.fee_rate||chr(9)||
       cf.product_manager||chr(9)||ed.event_id||chr(9)||ed.start_date||chr(9)||ed.end_date||chr(9)||ed.ops_country||chr(9)||ed.facility_region_metro||chr(9)||
       sum(sc.numstudents)||chr(9)||sum(sc.revamt)||chr(9)||
       case when upper(cf.payment_unit) = 'PER STUDENT' then cf.fee_rate*sum(sc.numstudents)
            when upper(cf.payment_unit) like '% OF REVENUE' then (cf.fee_rate/100)*sum(sc.revamt)
       end cd_line
  from gk_course_director_fees_mv cf
       inner join event_dim ed on cf.course_id = ed.course_id
       inner join course_dim cd on cd.course_id = ed.course_id and ed.ops_country = cd.country and cd.gkdw_source = 'SLXDW'
       inner join time_dim td on ed.start_date = td.dim_date
       inner join gk_cd_fee_stud_cnt_v sc on ed.event_id = sc.event_id
       inner join po_vendors@r12prd v on cf.vendor_num = v.segment1
       inner join po_vendor_sites_all@r12prd vs on v.vendor_id = vs.vendor_id and upper(cf.vendor_site_code) = vs.vendor_site_code
                  and case when substr(ed.ops_country,1,2) = 'CA' and v.vendor_id not in (select vendor_id from po_vendors@r12prd where vendor_id = '819002') then '86' else '84' end = vs.org_id
 where td.dim_period_name = upper(p_name)
   and trunc(sysdate-6) between nvl(cf.from_date,sysdate-6) and nvl(cf.to_date,sysdate-6)
   and td.dim_date not in (to_date('02/26/2018','mm/dd/yyyy'),to_date('02/27/2018','mm/dd/yyyy')) -- SR 03/19/2018 This can be removed after 3/28/2018 
   and cf.fee_status = 'Active'
   and ed.status != 'Cancelled' 
   and upper(cf.payment_unit) not in ( select distinct payment_unit from gk_course_director_fees_mv where payment_unit =  'FIXED')
 group by cd.course_code,cf.primary_poc,cf.primary_poc_email,cf.vendor_num,cf.vendor_name,
          cf.vendor_site_code,cf.fee_type,cf.payment_unit,cf.content_type,cf.fee_rate,cf.to_date,
          ed.ops_country,cf.payment_curr,
          case when ed.ops_country = 'CANADA' then '220' else '210' end,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
          ed.event_id,ed.start_date,ed.end_date,ed.ops_country,ed.facility_region_metro,
          case when vs.vendor_site_id is not null then 'Y' else 'N' end,
          cf.product_manager,cf.pm_email
 order by pm_email,contact_name,course_code;

cursor c1 is
select pv.vendor_id,upper(q.vendor_site_code) vendor_site_code,
       case when q.currency = 'CAD' then 86 else 84 end org_id,
       case when q.currency = 'CAD' then 103 else 101 end inv_org_id,
       264 agent_id, --264 Sheila Jacobs -- 183 Tori Easterl. SR - updated on 9/1/2017
       q.requestor_id,
       q.currency,
       q.vendor_num,
       upper(q.contact_name) contact_name,
       upper(replace(q.contact_email,' ')) contact_email,
       q.pm_email,
       upper(q.contact_company) contact_company,
       upper(q.product_manager) product_manager,
       upper(contact_name)||' - COURSE DIRECTOR FEES - '||upper(p_name) po_hdr
  from (
select cd.course_code,cf.primary_poc contact_name,cf.primary_poc_email contact_email,cf.vendor_name contact_company,cf.vendor_num,cf.vendor_name,
       cf.vendor_site_code,cf.fee_type,upper(cf.payment_unit) payment_unit,cf.content_type payment_type,cf.fee_rate payment_amount,cf.to_date expiration,
       cf.product_manager product_manager,ed.ops_country country,cf.payment_curr currency,
       case when cf.vendor_num = '10258' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else '210' 
       end le_num,
       '130' fe_num,
       case when cf.vendor_num = '20863' then '62405' else '62425' end acct_num,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       '200' cc_num,
       sum(sc.numstudents),
       sum(sc.revamt),
       case when upper(cf.payment_unit) = 'PER STUDENT' then cf.fee_rate*sum(sc.numstudents)
            when upper(cf.payment_unit) like '% OF REVENUE' then (cf.fee_rate/100)*sum(sc.revamt)
       end cd_fee_amt,
       nvl(pp.person_id,264) requestor_id,
       cf.pm_email
  from gk_course_director_fees_mv cf
       inner join event_dim ed on cf.course_id = ed.course_id
       inner join course_dim cd on cd.course_id = ed.course_id and ed.ops_country = cd.country and cd.gkdw_source = 'SLXDW'
       inner join time_dim td on ed.start_date = td.dim_date
       inner join gk_cd_fee_stud_cnt_v sc on ed.event_id = sc.event_id
       inner join po_vendors@r12prd v on cf.vendor_num = v.segment1
       inner join po_vendor_sites_all@r12prd vs on v.vendor_id = vs.vendor_id and upper(cf.vendor_site_code) = vs.vendor_site_code
                  and case when (substr(ed.ops_country,1,2) = 'CA' and v.vendor_id != 819002) then 86 else 84 end = vs.org_id
       left outer join per_all_people_f@r12prd pp on upper(cf.pm_email) = upper(pp.email_address) 
                                                  and pp.effective_end_date >= trunc(sysdate) and pp.current_employee_flag = 'Y'
 where td.dim_period_name = upper(p_name)
   and trunc(sysdate-6) between nvl(cf.from_date,sysdate-6) and nvl(cf.to_date,sysdate-6)
   and td.dim_date not in (to_date('02/26/2018','mm/dd/yyyy'),to_date('02/27/2018','mm/dd/yyyy')) -- SR 03/19/2018 This can be removed after 3/28/2018 
   and cf.fee_status = 'Active'
   and ed.status != 'Cancelled'
   and (upper(cf.payment_unit) !=  'FIXED'
   or not exists (select 1 from gk_course_director_fees_mv t1 where t1.payment_unit = cf.payment_unit and upper(t1.payment_unit) = 'FIXED'))
 group by cd.course_code,cf.primary_poc,cf.primary_poc_email,cf.vendor_num,cf.vendor_name,cf.vendor_site_code,cf.fee_type,cf.payment_unit,cf.content_type,
          cf.fee_rate,cf.to_date,ed.ops_country,cf.payment_curr,
          case when ed.ops_country = 'CANADA' then '220' else '210' end,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
          cf.product_manager,pp.person_id,cf.pm_email
union
select cd.course_code,cf.primary_poc contact_name,cf.primary_poc_email contact_email,cf.vendor_name contact_company,cf.vendor_num,cf.vendor_name,
       cf.vendor_site_code,cf.fee_type,upper(cf.payment_unit) payment_unit,cf.content_type payment_type,cf.fee_rate payment_amount,cf.to_date expiration,
       cf.product_manager product_manager,cd.country country,cf.payment_curr currency,
       case when cf.vendor_num = '10258' then '210'
            when cd.country = 'CANADA' then '220' 
            else '210' 
       end le_num,
       '130' fe_num,
       case when cf.vendor_num = '20863' then '62405' else '62425' end acct_num,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       '200' cc_num,
       null,
       null,
       cf.fee_rate cd_fee_amt,
       nvl(pp.person_id,264) requestor_id,
       cf.pm_email
  from gk_course_director_fees_mv cf
       inner join course_dim cd on cd.course_id = cf.course_id and cd.gkdw_source = 'SLXDW'
                                and case when cf.payment_curr = 'CAD' then 'CANADA' else 'USA' end = cd.country
       inner join po_vendors@r12prd v on cf.vendor_num = v.segment1
       inner join po_vendor_sites_all@r12prd vs on v.vendor_id = vs.vendor_id and upper(cf.vendor_site_code) = vs.vendor_site_code
                  and case when (substr(cd.country,1,2) = 'CA' and v.vendor_id != 819002) then 86 else 84 end = vs.org_id  -- SR 05/26/2017 Added 'and v.vendor_id != 819002'. May have to remove this when requested
       left outer join per_all_people_f@r12prd pp on upper(cf.pm_email) = upper(pp.email_address) 
                                                  and pp.effective_end_date >= trunc(sysdate) and pp.current_employee_flag = 'Y'
 where upper(cf.payment_unit) = 'FIXED'
   and trunc(sysdate-6) between nvl(cf.from_date,sysdate-6) and nvl(cf.to_date,sysdate-6)
  and cf.from_date not in (to_date('02/26/2018','mm/dd/yyyy'),to_date('02/27/2018','mm/dd/yyyy')) -- SR 03/19/2018 This can be removed after 3/28/2018 
   and cf.fee_status = 'Active'
 group by cd.course_code,cf.primary_poc,cf.primary_poc_email,cf.vendor_num,cf.vendor_name,
          cf.vendor_site_code,cf.fee_type,cf.payment_unit,cf.content_type,cf.fee_rate,cf.to_date,
          cd.country,cf.payment_curr,
          case when cd.country = 'CANADA' then '220' else '210' end,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
          cf.product_manager,nvl(pp.person_id,264),cf.pm_email
) q
inner join po_vendors@r12prd pv on q.vendor_num = pv.segment1
group by q.currency,pv.vendor_id,upper(q.vendor_site_code),q.vendor_num,upper(q.contact_name),q.requestor_id,
         upper(replace(q.contact_email,' ')),upper(q.contact_company),upper(q.product_manager),q.pm_email;

cursor c2(p_vendor_num varchar2,p_contact_name varchar2,p_contact_company varchar2,p_pm_email varchar2) is
select cd.course_code,cd.short_name,cf.primary_poc contact_name,cf.primary_poc_email contact_email,cf.vendor_name contact_company,cf.vendor_num,cf.vendor_name,
       cf.vendor_site_code,cf.fee_type,upper(cf.payment_unit) payment_unit,cf.content_type payment_type,cf.fee_rate payment_amount,cf.to_date expiration,
       cf.product_manager product_manager,ed.ops_country country,cf.payment_curr currency,
       case when cf.vendor_num = '10258' then '210'
            when ed.ops_country = 'CANADA' then '220' 
            else '210' 
       end le_num,
       '130' fe_num,
       case when cf.vendor_num = '20863' then '62405' else '62425' end acct_num,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       '200' cc_num,
       sum(sc.numstudents) stud_cnt,
       sum(sc.revamt) rev_amt,
       case when upper(cf.payment_unit) = 'PER STUDENT' then cf.fee_rate*sum(sc.numstudents)
            when upper(cf.payment_unit) like '% OF REVENUE' then (cf.fee_rate/100)*sum(sc.revamt)
       end cd_fee_amt,
       cd.course_code||chr(9)||cf.primary_poc||chr(9)||cf.primary_poc_email||chr(9)||cf.vendor_name||chr(9)||cf.vendor_name||chr(9)||
       cf.vendor_site_code||chr(9)||cf.fee_type||chr(9)||upper(cf.payment_unit)||chr(9)||cf.content_type||chr(9)||cf.fee_rate||chr(9)||
       cf.to_date||chr(9)||cf.product_manager||chr(9)||sum(sc.numstudents)||chr(9)||sum(sc.revamt)||chr(9)||
       case when upper(cf.payment_unit) = 'PER STUDENT' then cf.fee_rate*sum(sc.numstudents)
            when upper(cf.payment_unit) like '% OF REVENUE' then (cf.fee_rate/100)*sum(sc.revamt)
       end v_line,
       cd.course_code||'-CD FEE ('||cf.fee_type||')-'||upper(p_name) vpo_desc,
       cf.pm_email
  from gk_course_director_fees_mv cf
       inner join event_dim ed on cf.course_id = ed.course_id
       inner join course_dim cd on cd.course_id = ed.course_id and ed.ops_country = cd.country and cd.gkdw_source = 'SLXDW'
       inner join time_dim td on ed.start_date = td.dim_date
       inner join gk_cd_fee_stud_cnt_v sc on ed.event_id = sc.event_id
 where td.dim_period_name = upper(p_name)
   and trunc(sysdate-6) between nvl(cf.from_date,sysdate-6) and nvl(cf.to_date,sysdate-6)
   and td.dim_date not in (to_date('02/26/2018','mm/dd/yyyy'),to_date('02/27/2018','mm/dd/yyyy')) -- SR 03/19/2018 This can be removed after 3/28/2018 
   and cf.fee_status = 'Active'
   and cf.vendor_num = p_vendor_num
   and upper(cf.primary_poc) = p_contact_name
   and upper(cf.vendor_name) = p_contact_company
   and upper(cf.pm_email) = upper(p_pm_email)
   and ed.status != 'Cancelled'
  and (upper(cf.payment_unit) !=  'FIXED'
   or not exists (select 1 from gk_course_director_fees_mv t1 where t1.payment_unit = cf.payment_unit and upper(t1.payment_unit) = 'FIXED'))
 group by cd.course_code,cd.short_name,cf.primary_poc,cf.primary_poc_email,cf.vendor_num,cf.vendor_name,
          cf.vendor_site_code,cf.fee_type,upper(cf.payment_unit),cf.content_type,cf.fee_rate,cf.to_date,
          ed.ops_country,cf.payment_curr,
          case when ed.ops_country = 'CANADA' then '220' else '210' end,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
          cf.product_manager,cf.pm_email
union
select cd.course_code,cd.short_name,cf.primary_poc,cf.primary_poc_email,cf.vendor_name,cf.vendor_num,cf.vendor_name,
       cf.vendor_site_code,cf.fee_type,upper(cf.payment_unit),cf.content_type,cf.fee_rate,cf.to_date,
       cf.product_manager product_manager,cd.country,cf.payment_curr,
       case when cf.vendor_num = '10258' then '210'
            when cd.country = 'CANADA' then '220' 
            else '210' 
       end le_num,
       '130' fe_num,
       case when cf.vendor_num = '20863' then '62405' else '62425' end acct_num,
       cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
       '200' cc_num,
       null,
       null,
       cf.fee_rate cd_fee_amt,
       cd.course_code||chr(9)||cf.primary_poc||chr(9)||cf.primary_poc_email||chr(9)||cf.vendor_name||chr(9)||cf.vendor_name||chr(9)||
       cf.vendor_site_code||chr(9)||cf.fee_type||chr(9)||upper(cf.payment_unit)||chr(9)||cf.content_type||chr(9)||cf.fee_rate||chr(9)||
       cf.to_date||chr(9)||cf.product_manager||chr(9)||null||chr(9)||null||chr(9)||cf.fee_rate,
       cd.course_code||'-CD FEE ('||cf.fee_type||')-'||upper(p_name),
       cf.pm_email
  from gk_course_director_fees_mv cf
       inner join course_dim cd on cd.course_id = cf.course_id and cd.gkdw_source = 'SLXDW'
                                   and case when cf.payment_curr = 'CAD' then 'CANADA' else 'USA' end = cd.country
 where upper(cf.payment_unit) = 'FIXED'
   and trunc(sysdate-6) between nvl(cf.from_date,sysdate-6) and nvl(cf.to_date,sysdate-6)
   and cf.from_date not in (to_date('02/26/2018','mm/dd/yyyy'),to_date('02/27/2018','mm/dd/yyyy')) -- SR 03/19/2018 This can be removed after 3/28/2018 
   and cf.fee_status = 'Active'
   and cf.vendor_num = p_vendor_num
   and upper(cf.primary_poc) = p_contact_name
   and upper(cf.vendor_name) = p_contact_company
   and upper(cf.pm_email) = upper(p_pm_email)
 group by cd.course_code,cd.short_name,cf.primary_poc,cf.primary_poc_email,cf.vendor_num,cf.vendor_name,cf.vendor_site_code,cf.fee_type,
          upper(cf.payment_unit),cf.content_type,cf.fee_rate,cf.to_date,cd.country,cf.payment_curr,
          case when cd.country = 'CANADA' then '220' else '210' end,cd.ch_num,cd.md_num,cd.pl_num,cd.act_num,
          cf.product_manager,cf.pm_email;

cursor c3(v_req_id number) is
  select request_id,phase_code,status_code
    from fnd_concurrent_requests@r12prd
   where request_id = v_req_id;

cursor c4(v_po_num varchar2) is
select distinct h.segment1,h.po_header_id,l.po_line_id,h.vendor_id,h.vendor_site_id,
       d.deliver_to_person_id,trunc(sysdate) ship_date,d.destination_organization_id,l.category_id,
       l.line_num,l.item_description,l.quantity,trunc(sysdate) deliv_date,
       l.quantity qty_deliv,
       l.unit_meas_lookup_code,u.uom_code
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
 where h.segment1 = v_po_num;


v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_file_name_po varchar2(50);
v_file_name_full_po varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_msg_body long;
x varchar2(1000);
v_sid varchar2(25);
vcode_comb_id number;
curr_po varchar2(25);
vneed_date date;
vline_num number;
l_req_id number;
v_total number;
type po_arr is table of varchar2(25) index by binary_integer;
po_nums po_arr;
po_cnt number := 1;
loop_cnt number := 1;
r3 c3%rowtype;
v_rcv_header number;
v_rcv_interface number;
v_rcv_transaction number;

begin

dbms_snapshot.refresh('gk_course_director_fees_mv');
rms_link_set_proc;

select 'course_director_variable_fees_'||p_name||'.xls',
       '/usr/tmp/course_director_variable_fees_'||p_name||'.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Contact Company'||chr(9)||'Contact Name'||chr(9)||'Contact Email'||chr(9)||'Vendor Name'||chr(9)||'Vendor Num'||chr(9)||'Vendor Site'||chr(9)||
       'Course Code'||chr(9)||'Fee Type'||chr(9)||'Payment Unit'||chr(9)||'Payment Type'||chr(9)||'Payment Amt'||chr(9)||'Product Mgr'||chr(9)||
       'Event ID'||chr(9)||'Start Date'||chr(9)||'End Date'||chr(9)||'Ops Country'||chr(9)||'Metro'||chr(9)||'Stud Cnt'||chr(9)||'Rev Amt'||chr(9)||
       'CD Total'||chr(9)||'Valid Vendor Site'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

for r0 in c0 loop
  utl_file.put_line(v_file,r0.cd_line||chr(9)||r0.valid_vendor_site);
end loop;

utl_file.fclose(v_file);

send_mail_attach('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com',null,null,'Course Director Variable Fee Audit File','Open Excel Attachment to view variable fee events.',v_file_name_full);

select 'PO Num'||chr(9)||'Line'||chr(9)||'Course Code'||chr(9)||'Contact Name'||chr(9)||'Contact Email'||chr(9)||'Contact Company'||chr(9)||
         'Vendor Name'||chr(9)||'Vendor Site'||chr(9)||'Fee Type'||chr(9)||'Payment Unit'||chr(9)||'Payment Type'||chr(9)||
         'Payment Amt'||chr(9)||'Expiration'||chr(9)||'Product Mgr'||chr(9)||'Stud Cnt'||chr(9)||'Rev Amt'||chr(9)||'Total CD Fee'
  into v_hdr
  from dual;

v_file_name_po := 'CourseDirectorFees_'||upper(p_name)||'.xls';
v_file_name_full_po := '/usr/tmp/'||v_file_name_po;
v_file := utl_file.fopen('/usr/tmp',v_file_name_po,'w');
utl_file.put_line(v_file,v_hdr);

for r1 in c1 loop
  select gk_get_curr_po(r1.org_id,'R12PRD') into curr_po from dual;
  gk_update_curr_po(r1.org_id,'R12PRD');
  commit;

  po_nums(po_cnt) := curr_po;

  vneed_date := trunc(sysdate-6)+1;
  vline_num := 1;
  v_total := 0;

  gkn_po_create_hdr_proc@r12prd(curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.currency,r1.po_hdr);

  insert into gk_autoreceive_pos
    select curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.currency,v_sid,sysdate,'N','COURSE DIRECTOR FEE'
      from dual;
  commit;

  v_msg_body := '';
  v_msg_body := v_msg_body||'<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/gk_logo.gif" alt="Global Knowledge IT Training" width=165 height=90 border=0></td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left colspan=2>Course Director Fees - '||upper(p_name)||'</th></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left>Course Director:</th><td>'||r1.contact_name||'</td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left>Company:</th><td>'||r1.contact_company||'</td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left>Product Manager:</th><td>'||r1.product_manager||'</td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left>PO Number:</th><td>'||curr_po||'</td></tr>';
  v_msg_body := v_msg_body||'</table><p>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr valign=bottom><th>Line</th><th>Course</th><th>Fee<br>Type</th><th>Payment<br>Unit</th><th>Payment<br>Amt</th>';
  v_msg_body := v_msg_body||'<th>Student<br>Count</th><th>Revenue<br>Amount</th><th>Line<br>Amount</th></tr>';

  for r2 in c2(r1.vendor_num,r1.contact_name,r1.contact_company,r1.pm_email) loop
    v_msg_body := v_msg_body||'<tr><td align=right>'||vline_num||'</td><td align=left>'||r2.short_name||'('||r2.course_code||')</td>';
    v_msg_body := v_msg_body||'<td align=left>'||r2.fee_type||'</td><td>'||r2.payment_unit||'</td><td align=right>'||r2.payment_amount||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||r2.stud_cnt||'</td>';
    if upper(r2.payment_unit) = '% OF REVENUE' then
      v_msg_body := v_msg_body||'<td align=right>'||case when r2.rev_amt is not null then to_char(r2.rev_amt,'$999,999,990.00') else null end||'</td>';
    else
      v_msg_body := v_msg_body||'<td align=right>&nbsp</td>';
    end if;
    v_msg_body := v_msg_body||'<td align=right>'||to_char(r2.cd_fee_amt,'$999,990.00')||'</td></tr>';

    utl_file.put_line(v_file,curr_po||chr(9)||vline_num||chr(9)||r2.v_line);

    vcode_comb_id := gkn_get_account@r12prd(r2.le_num,r2.fe_num,r2.acct_num,r2.ch_num,r2.md_num,r2.pl_num,r2.act_num,r2.cc_num);
    gkn_po_create_line_proc@r12prd(vline_num,null,r2.vpo_desc,'EACH',1,r2.cd_fee_amt,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor_id,r2.course_code,137,'Y');
    commit;
    vline_num := vline_num + 1;
    v_total := v_total + r2.cd_fee_amt;
  end loop;
  v_msg_body := v_msg_body||'<tr><th align=left colspan=7>Purchase Order Total:</th><th align=right>'||to_char(v_total,'$999,990.00')||'</th></tr>';
  v_msg_body := v_msg_body||'</table>';
  v_msg_body := v_msg_body||'</body></html>';

  send_mail(r1.pm_email,r1.pm_email,'Global Knowledge Course Director Fee Purchase Order',v_msg_body);
  send_mail(r1.pm_email,r1.contact_email,'Global Knowledge Course Director Fee Purchase Order',v_msg_body);

  po_cnt := po_cnt + 1;
end loop;

utl_file.fclose(v_file);

v_mail_hdr := 'Course Director Fee - PO Report - '||upper(p_name)||'.xls';


send_mail_attach('DW.Automation@globalknowledge.com','sheila.jacobs@globalknowledge.com','DW.Automation@globalknowledge.com',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','Purchasing.Requests.US@globalknowledge.com','Steve.Cox@globalknowledge.com',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','jennifer.parker@globalknowledge.com','Joy.Pruitt@globalknowledge.com','Michalina.DeBoard@globalknowledge.com',v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','ambra.motilall@globalknowledge.com','Wanda.Mills@globalknowledge.com',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','brad.connor@globalknowledge.com','tori.easterly@globalknowledge.com',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','Brad.Puckett@globalknowledge.com','Jenna.Doss@globalknowledge.com',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','Dan.Stober@globalknowledge.com','',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','Lia.Byers@globalknowledge.com','',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','lisa.jones@globalknowledge.com','',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','Susan.Cipollini@globalknowledge.com','',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);
send_mail_attach('DW.Automation@globalknowledge.com','smaranika.baral@globalknowledge.com','',null,v_mail_hdr,'CD Fee PO Report',v_file_name_full_po);

fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;  -- US REQUEST

l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
            NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');

commit;

loop_cnt := 1;
while loop_cnt < 5 loop
  open c3(l_req_id);
  fetch c3 into r3;
  if r3.phase_code = 'C' then
    loop_cnt := 5;
  else
    loop_cnt := loop_cnt + 1;
    dbms_lock.sleep(15);
  end if;
  close c3;
end loop;

fnd_global_apps_init@r12prd(1111,50248,201,'PO',86) ;

l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
            NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');

commit;

loop_cnt := 1;
while loop_cnt < 5 loop
  open c3(l_req_id);
  fetch c3 into r3;
  if r3.phase_code = 'C' then
    loop_cnt := 5;
  else
    loop_cnt := loop_cnt + 1;
    dbms_lock.sleep(15);
  end if;
  close c3;
end loop;

for i in 1..po_nums.count loop
  gk_receive_po_proc(po_nums(i),'R12PRD');
end loop;

gk_receive_request_proc('R12PRD');

exception
  when others then
    rollback;
    v_msg_body := v_msg_body||'<tr><td align=right>'||SQLERRM||'</td></tr>';
    v_msg_body := v_msg_body||'</table>';
    v_msg_body := v_msg_body||'</body></html>';
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_CD_FEE_PROC FAILED',v_msg_body);

end;
/


