DROP PROCEDURE GKDW.GK_ROYALTY_FEED;

CREATE OR REPLACE PROCEDURE GKDW.gk_royalty_feed(p_week varchar2 default null,p_test varchar2 default 'N') as
cursor c0 is
  select distinct p.vendor_code,p.primary_contact,p.alternate_contact,
                  p.po_active,p.event_audit,p.roster_audit,
                  p.audit_mgr,p.po_mgr_id,p.long_rpt
    from gk_partner_royalty p
   where (roster_audit = 'Y' or po_active = 'Y' or event_audit = 'Y')
   order by vendor_code;
   
cursor c1(vcode varchar2,vweek varchar2) is
  select ops_country,org_id,inv_org_id,curr_code,oracle_vendor_id,oracle_vendor_site
    from gk_partner_orders_v
   where vendor_code = vcode
     and po_active = 'Y'
     and ((dim_week = vweek and upper(po_create_meth) = 'DELIVERY' and to_char(sysdate,'d') = '5')
      or  (upper(po_create_meth) = 'ORDER' and book_date = trunc(sysdate)-1))
   group by ops_country,org_id,inv_org_id,curr_code,oracle_vendor_id,oracle_vendor_site
  union
  select ops_country,org_id,inv_org_id,curr_code,oracle_vendor_id,oracle_vendor_site
    from gk_partner_orders_v
   where vendor_code = vcode
     and substr(course_code,1,4) in ('5378','5384')
     and book_date = trunc(sysdate)-1
   group by ops_country,org_id,inv_org_id,curr_code,oracle_vendor_id,oracle_vendor_site;
   
cursor c2(vcode varchar2,vweek varchar2,vops_country varchar2) is
  select event_id,ops_country,org_id,inv_org_id,curr_code,royalty_fee,course_code,
         vpo_desc,start_date,book_date,1 stud_cnt, -- SR 11/15 added book_date
         p.le,'000' fe,'41315' acct,nvl(g.segment4,'10') ch,nvl(g.segment5,'10') md,nvl(g.segment6,'01') pl,
         nvl(g.segment7,p.act) act,'000' cc,
         p.event_id||chr(9)||p.event_name||chr(9)||p.reseller_event_id||chr(9)||p.course_code||chr(9)||
         p.start_date||chr(9)||p.facility_code||chr(9)||p.location_name||chr(9)||p.enroll_id||chr(9)||
         p.enroll_status||chr(9)||p.royalty_fee||chr(9)||p.cust_name||chr(9)||p.acct_name||chr(9)||replace(p.address1,chr(10),' ')||chr(9)||
         replace(p.address2,chr(10),' ')||chr(9)||p.city||chr(9)||p.state||chr(9)||p.zipcode v_line
    from gk_partner_orders_v p
         left outer join mtl_system_items@r12prd m on m.attribute1 = p.course_code and m.organization_id = 88
         left outer join gl_code_combinations@r12prd g on m.sales_account = g.code_combination_id
   where vendor_code = vcode
     and po_active = 'Y'
     and ops_country = vops_country
     and ((dim_week = vweek and upper(po_create_meth) = 'DELIVERY' and to_char(sysdate,'d') = '5')
      or  (upper(po_create_meth) = 'ORDER' and book_date = trunc(sysdate)-1))
union
  select event_id,ops_country,org_id,inv_org_id,curr_code,60 royalty_fee,course_code,
         vpo_desc,start_date,book_date,1 stud_cnt, -- SR 11/15 added book_date
         p.le,'000' fe,'41315' acct,nvl(g.segment4,'10') ch,nvl(g.segment5,'10') md,nvl(g.segment6,'01') pl,
         nvl(g.segment7,p.act) act,'000' cc,
         p.event_id||chr(9)||p.event_name||chr(9)||p.reseller_event_id||chr(9)||p.course_code||chr(9)||
         p.start_date||chr(9)||p.facility_code||chr(9)||p.location_name||chr(9)||p.enroll_id||chr(9)||
         p.enroll_status||chr(9)||'60.00'||chr(9)||p.cust_name||chr(9)||p.acct_name||chr(9)||replace(p.address1,chr(10),' ')||chr(9)||
         replace(p.address2,chr(10),' ')||chr(9)||p.city||chr(9)||p.state||chr(9)||p.zipcode v_line
    from gk_partner_orders_v p
         left outer join mtl_system_items@r12prd m on m.attribute1 = p.course_code and m.organization_id = 88
         left outer join gl_code_combinations@r12prd g on m.sales_account = g.code_combination_id
   where substr(course_code,1,4) in ('5378','5384')
     and vendor_code = vcode
     and ops_country = vops_country
     and book_date = trunc(sysdate)-1;
     
cursor c3(vcode varchar2) is
  select cd.course_code||chr(9)||
         ed.reseller_event_id||chr(9)||
         cd.course_name||chr(9)||
         to_char(ed.start_date,'mm/dd/yy')||chr(9)||
         ed.facility_region_metro||chr(9)||
         f.enroll_status||chr(9)||
         replace(c.lastname,chr(13),'')||chr(9)||
         replace(c.firstname,chr(13),'')||chr(9)||
         case when rp.long_rpt = 'Y' then replace(c.account,chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(replace(a.address1,chr(10),' '),chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(replace(a.address2,chr(10),' '),chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(a.city,chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(a.state,chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(a.postalcode,chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(c.email,chr(13),'') else null end||chr(9)||
         case when rp.long_rpt = 'Y' then replace(c.workphone,chr(13),'') else null end||chr(9)||
         to_char(ed.end_date,'mm/dd/yy')||chr(9)||
         ed.status||chr(9)||
         to_char(cd.list_price)||chr(9)||
         to_char(f.book_date,'mm/dd/yy')||chr(9)||
         ed.event_id||chr(9)||
         f.fee_type||chr(9)||
         f.bill_status||chr(9)||
         to_char(f.bill_date,'mm/dd/yy')||chr(9)||
         f.enroll_id||chr(9)||
         cd.pl_num||chr(9)||
         vcode v_line
    from order_fact f
         inner join event_dim ed on f.event_id = ed.event_id
         inner join course_dim cd on ed.course_id = cd.course_id and ed.country = cd.country
         inner join slxdw.contact c on f.cust_id = c.contactid
         inner join slxdw.address a on c.addressid = a.addressid
         inner join gk_royalty_lookup rl on cd.course_code = rl.course_code
                and f.book_date between rl.active_date and rl.inactive_date
         inner join gk_partner_royalty rp on rl.vendor_code = rp.vendor_code
   where course_group = vcode
     and ed.start_date > trunc(sysdate)-7
   order by ed.start_date,ed.event_id,f.enroll_id,f.bill_date;
   
cursor c4(vcode varchar2) is
  select cd.course_code||chr(9)||
         ed.reseller_event_id||chr(9)||
         cd.course_name||chr(9)||
         to_char(ed.start_date,'mm/dd/yy')||chr(9)||
         ed.facility_region_metro||chr(9)||
         ed.status||chr(9)||
         sum(case when f.enroll_status = 'Confirmed' and book_amt>0 then 1 else 0 end)||chr(9)||
         sum(case when f.enroll_status = 'Cancelled' and book_amt<0 then 1 else 0 end)||chr(9)||
         sum(case when f.enroll_status = 'Confirmed' and book_amt=0 then 1 else 0 end)||chr(9)||
         to_char(ed.end_date-ed.start_date+1)||chr(9)||
         ed.start_time||chr(9)||
         ed.location_name||chr(9)||
         ed.address1||chr(9)||
         ed.address2||chr(9)||
         ed.city||chr(9)||
         ed.state||chr(9)||
         to_char(cd.list_price)||chr(9)||
         to_char(ed.end_date,'mm/dd/yy')||chr(9)||
         cd.course_id||chr(9)||
         ed.event_id||chr(9)||
         vcode v_line
    from event_dim ed
         inner join course_dim cd on ed.course_id = cd.course_id and ed.country = cd.country
         inner join gk_royalty_lookup rl on cd.course_code = rl.course_code
                and ed.start_date between rl.active_date and rl.inactive_date
         left outer join order_fact f on ed.event_id = f.event_id
   where rl.vendor_code = vcode
     and ed.start_date > trunc(sysdate)-7
   group by ed.event_id,ed.reseller_event_id,cd.course_name,cd.course_id,to_char(cd.list_price),cd.course_code,to_char(ed.start_date,'mm/dd/yy'),
            to_char(ed.end_date,'mm/dd/yy'),ed.start_time,to_char(ed.end_date-ed.start_date+1),ed.status,ed.location_name,
            ed.address1,ed.address2,ed.city,ed.state,ed.facility_region_metro
   order by ed.status,to_char(ed.start_date,'mm/dd/yy');
   
cursor c5 is
  select vendor_code||chr(9)||course_code v_line
    from course_dim cd
   where inactive_flag = 'F'
     and vendor_code is not null
     and exists (select 1 from gk_partner_royalty r where r.vendor_code = cd.vendor_code)
  minus
  select vendor_code||chr(9)||course_code
    from gk_royalty_lookup
   where inactive_date >= trunc(sysdate);
   
cursor c6 is
  select vendor_code||chr(9)||course_code||chr(9)||us_fee||chr(9)||ca_fee||chr(9)||active_date||chr(9)||inactive_date v_line
    from gk_royalty_lookup ll
   where exists (select 1 from gk_partner_royalty pr where ll.vendor_code = pr.vendor_code)
   order by vendor_code,course_code,active_date;
   
v_hdr varchar2(500);
v_file_name_enroll varchar2(100);
v_file_full_enroll varchar2(100);
v_file_name_po varchar2(100);
v_file_full_po varchar2(100);
v_file_name_event varchar2(100);
v_file_full_event varchar2(100);
v_file utl_file.file_type;
v_file_audit varchar2(100);
v_file_full_audit varchar2(100);
v_file_price varchar2(100);
v_file_full_price varchar2(100);
v_mail_hdr varchar2(100);
v_error number;
v_error_msg varchar2(500);
curr_po number;
vneed_date date;
vpo_hdr varchar2(100);
vcode_comb_id number;
v_curr_week varchar2(25);
v_sid varchar2(10);
vline_num number;
l_req_id number;

begin

if p_week is not null then
  v_curr_week := p_week;
else
  select td.dim_year||'-'||lpad(td.dim_week,2,'0') into v_curr_week from time_dim td where trunc(sysdate) = dim_date;
end if;

select case when p_test = 'Y' then 'R12DEV' else 'R12PRD' end into v_sid from dual;

for r0 in c0 loop

--dbms_output.put_line(r0.vendor_code);

  for r1 in c1(r0.vendor_code,v_curr_week) loop
    select gk_get_curr_po(r1.org_id,v_sid) into curr_po from dual;
    gk_update_curr_po(r1.org_id,v_sid);
    commit;
    vneed_date := trunc(sysdate)+1;
    vpo_hdr := 'VENDOR FEES';
    vline_num := 1;
    if p_test = 'Y' then
      gkn_po_create_hdr_proc@r12dev(curr_po,r1.oracle_vendor_id,r1.oracle_vendor_site,r1.org_id,264,r1.curr_code);
    else
      gkn_po_create_hdr_proc@r12prd(curr_po,r1.oracle_vendor_id,r1.oracle_vendor_site,r1.org_id,264,r1.curr_code);
    end if;
    select 'PO Num'||chr(9)||'PO Line'||chr(9)||'Event ID'||chr(9)||'Event Name'||chr(9)||'Reseller Event ID'||chr(9)||'Course Code'||chr(9)||
           'Start Date'||chr(9)||'Facility Code'||chr(9)||'Location'||chr(9)||'Enroll ID'||chr(9)||'Enroll Status'||chr(9)||
           'Royalty Fee'||chr(9)||'Customer'||chr(9)||'Account'||chr(9)||'Address 1'||chr(9)||'Address 2'||chr(9)||
           'City'||chr(9)||'State'||chr(9)||'Zip Code'
      into v_hdr
      from dual;
    v_file_name_po := 'GK_PO_'||to_char(curr_po)||'_'||r0.vendor_code||'_'||to_char(sysdate,'mmddyy')||'.xls';
    v_file_full_po := '/usr/tmp/'||v_file_name_po;
    v_file := utl_file.fopen('/usr/tmp',v_file_name_po,'w');
    utl_file.put_line(v_file,v_hdr);
    for r2 in c2(r0.vendor_code,v_curr_week,r1.ops_country) loop
      if r0.vendor_code = '6SIG' then
        vneed_date := r2.start_date;
      end if;
      if r2.course_code = '4993W' then -- SR 11/15
      vneed_date := r2.book_date;
      end if;
      utl_file.put_line(v_file,curr_po||chr(9)||vline_num||chr(9)||r2.v_line);
      if p_test = 'Y' then
        vcode_comb_id := gkn_get_account@r12dev(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
        gkn_po_create_line_proc@r12dev(vline_num,null,r2.vpo_desc,'EACH',r2.stud_cnt,r2.royalty_fee,vneed_date,r2.inv_org_id,r2.org_id,
                                     vcode_comb_id,'CARY',r0.po_mgr_id,r2.event_id,125,'Y');
      else
        vcode_comb_id := gkn_get_account@r12prd(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
        gkn_po_create_line_proc@r12prd(vline_num,null,r2.vpo_desc,'EACH',r2.stud_cnt,r2.royalty_fee,vneed_date,r2.inv_org_id,r2.org_id,
                                    vcode_comb_id,'CARY',r0.po_mgr_id,r2.event_id,125,'Y');
      end if;
      commit;
      vline_num := vline_num + 1;
    end loop;
    utl_file.fclose(v_file);
    v_mail_hdr := 'Purchase Order Report - '||r0.vendor_code||' - '||to_char(sysdate,'mmddyy')||'.xls';
    if p_test = 'Y' then
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => 'DW.Automation@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Weekly Enrollment Audit',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_po));
    else
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => 'Marion.Kennelly@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => 'Purchasing.Requests.US@globalknowledge.com',
                Subject   => v_mail_hdr,
                Body => 'Weekly Enrollment Audit',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_po));
--      v_error:= SendMailJPkg.SendMail(
--                SMTPServerName => 'corpmail.globalknowledge.com',
--                Sender    => r0.audit_mgr,
--                Recipient => 'Marion.Kennelly@globalknowledge.com',
--                CcRecipient => '',
--                BccRecipient => '',
--                Subject   => v_mail_hdr,
--                Body => 'Weekly Enrollment Audit',
--                ErrorMessage => v_error_msg,
--                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_po));
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => r0.primary_contact,
                CcRecipient => r0.alternate_contact,
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Weekly Enrollment Audit',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_po));
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => 'Partner.Schedules.nam@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Weekly Enrollment Audit',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_po));
--      v_error:= SendMailJPkg.SendMail(
--                SMTPServerName => 'corpmail.globalknowledge.com',
--                Sender    => r0.audit_mgr,
--                Recipient => ''--'lindsay.kanwisher@globalknowledge.com',
--                CcRecipient => '',
--                BccRecipient => '',
--                Subject   => v_mail_hdr,
--                Body => 'Weekly Enrollment Audit',
--                ErrorMessage => v_error_msg,
--                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_po));
    end if;
    commit;
  end loop;
  
  if r0.event_audit = 'Y' and to_char(sysdate,'d') = '5' then
    select 'Course Code'||chr(9)||'Reseller Event ID'||chr(9)||'Course Name'||chr(9)||'Start Date'||chr(9)||'Metro Area'||chr(9)||'Enroll Status'||chr(9)||
           'Last Name'||chr(9)||'First Name'||chr(9)||'Acct Name'||chr(9)||'Address1'||chr(9)||'Address2'||chr(9)||'City'||chr(9)||'State'||chr(9)||
           'Zipcode'||chr(9)||'Email'||chr(9)||'Workphone'||chr(9)||'End Date'||chr(9)||'Event Status'||chr(9)||'List Price'||chr(9)||'Enroll Date'||chr(9)||
           'Event ID'||chr(9)||'Fee Type'||chr(9)||'Bill Status'||chr(9)||'Status Date'||chr(9)||'Enroll ID'||chr(9)||'Prod Line'||chr(9)||'Vendor'
      into  v_hdr
      from  dual;
    v_file_name_enroll := 'GK_RosterAudit_'||r0.vendor_code||'_'||to_char(sysdate,'mmddyy')||'.xls';
    v_file_full_enroll := '/usr/tmp/'||v_file_name_enroll;
    v_file := utl_file.fopen('/usr/tmp',v_file_name_enroll,'w');
    utl_file.put_line(v_file,v_hdr);
    for r3 in c3(r0.vendor_code) loop
      utl_file.put_line(v_file,r3.v_line);
    end loop;
    utl_file.fclose(v_file);
    select 'Course Code'||chr(9)||'Reseller Event ID'||chr(9)||'Course Name'||chr(9)||'Start Date'||chr(9)||'Metro Area'||chr(9)||'Event Status'||chr(9)||
           'Confirmed'||chr(9)||'Cancelled'||chr(9)||'Guest'||chr(9)||'Length'||chr(9)||'Start Time'||chr(9)||'Location'||chr(9)||'Address1'||chr(9)||
           'Address2'||chr(9)||'City'||chr(9)||'State'||chr(9)||'List Price'||chr(9)||'End Date'||chr(9)||'Course ID'||chr(9)||'Event ID'||chr(9)||'Vendor'
      into  v_hdr
      from  dual;
    v_file_name_event := 'GK_EventAudit_'||r0.vendor_code||'_'||to_char(sysdate,'mmddyy')||'.xls';
    v_file_full_event := '/usr/tmp/'||v_file_name_event;
    v_file := utl_file.fopen('/usr/tmp',v_file_name_event,'w');
    utl_file.put_line(v_file,v_hdr);
    for r4 in c4(r0.vendor_code) loop
      utl_file.put_line(v_file,r4.v_line);
    end loop;
    utl_file.fclose(v_file);
    v_mail_hdr := 'Weekly Audit Reports - '||r0.vendor_code||' - '||to_char(sysdate,'mmddyy');
    if p_test = 'Y' then
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => '',
                CcRecipient => '',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Weekly Audit Reports',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_enroll,v_file_full_event,v_file_full_audit));
    else
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => 'Partner.Schedules.Nam@globalknowledge.com',
                CcRecipient => '',
                BccRecipient => 'DW.Automation@globalknowledge.com',
                Subject   => v_mail_hdr,
                Body => 'Weekly Audit Reports',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_enroll,v_file_full_event,v_file_full_audit));
--            v_error:= SendMailJPkg.SendMail(
--                SMTPServerName => 'corpmail.globalknowledge.com',
--                Sender    => r0.audit_mgr,
--                Recipient => 'Marion.Kennelly@globalknowledge.com',
--                CcRecipient => '',
--                BccRecipient => '',
--                Subject   => v_mail_hdr,
--                Body => 'Weekly Audit Reports',
--                ErrorMessage => v_error_msg,
--                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_enroll,v_file_full_event,v_file_full_audit));
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => r0.primary_contact,
                CcRecipient => r0.alternate_contact,
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Weekly Audit Reports',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_enroll,v_file_full_event));
      v_error:= SendMailJPkg.SendMail(
                SMTPServerName => 'corpmail.globalknowledge.com',
                Sender    => r0.audit_mgr,
                Recipient => 'Partner.Schedules.nam@globalknowledge.com',
                CcRecipient => 'Partner.Schedules.nam@globalknowledge.com',
                BccRecipient => '',
                Subject   => v_mail_hdr,
                Body => 'Weekly Audit Reports',
                ErrorMessage => v_error_msg,
                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_enroll,v_file_full_event,v_file_full_audit));
--      v_error:= SendMailJPkg.SendMail(
--                SMTPServerName => 'corpmail.globalknowledge.com',
--                Sender    => r0.audit_mgr,
--                Recipient => ''--'lindsay.kanwisher@globalknowledge.com',
--                CcRecipient => '',
--                BccRecipient => '',
--                Subject   => v_mail_hdr,
--                Body => 'Weekly Audit Reports',
--                ErrorMessage => v_error_msg,
--                Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_enroll,v_file_full_event,v_file_full_audit));
    end if;
    commit;
  end if;
end loop;
if p_test = 'Y' then
  fnd_global.apps_initialize@r12dev(1111,20707,201,'PO',84) ;
  l_req_id := fnd_request.submit_request@r12dev('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
else
  fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;
  l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
end if;
commit;
if p_test = 'Y' then
  fnd_global_apps_init@r12dev(1111,50248,201,'PO',86) ;
  l_req_id := fnd_request.submit_request@r12dev('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
else
  fnd_global_apps_init@r12prd(1111,50248,201,'PO',86) ;
  l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
              NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
              '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
end if;
commit;
if to_char(sysdate,'d') = '5' then
  select  'Vendor Code'||chr(9)||
          'Course Code'
    into  v_hdr
    from  dual;
  v_file_audit := 'GK_ExceptionAudit_'||to_char(sysdate,'mmddyy')||'.xls';
  v_file_full_audit := '/usr/tmp/'||v_file_audit;
  v_file := utl_file.fopen('/usr/tmp',v_file_audit,'w');
  utl_file.put_line(v_file,v_hdr);
  for r5 in c5 loop
    utl_file.put_line(v_file,r5.v_line);
  end loop;
  utl_file.fclose(v_file);
  select  'Vendor Code'||chr(9)||'Course Code'||chr(9)||'US Fee'||chr(9)||'CA Fee'||chr(9)||'Active Date'||chr(9)||'Inactive Date'
    into  v_hdr
    from  dual;
  v_file_price := 'GK_RoyaltyList_'||to_char(sysdate,'mmddyy')||'.xls';
  v_file_full_price := '/usr/tmp/'||v_file_price;
  v_file := utl_file.fopen('/usr/tmp',v_file_price,'w');
  utl_file.put_line(v_file,v_hdr);
  for r6 in c6 loop
    utl_file.put_line(v_file,r6.v_line);
  end loop;
  utl_file.fclose(v_file);
  v_mail_hdr := 'GK Audit Reports - '||to_char(sysdate,'mmddyy');
  if p_test = 'Y' then
    v_error:= SendMailJPkg.SendMail(
              SMTPServerName => 'corpmail.globalknowledge.com',
              Sender    => 'DW.Automation@globalknowledge.com',
              Recipient => 'Partner.Schedules.Nam@globalknowledge.com',
              CcRecipient => 'Rebecca.Mangum@globalknowledge.com',
              BccRecipient => '',
              Subject   => v_mail_hdr,
              Body => 'GK Weekly Audit Reports',
              ErrorMessage => v_error_msg,
              Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_audit,v_file_full_price));
  else
    v_error:= SendMailJPkg.SendMail(
              SMTPServerName => 'corpmail.globalknowledge.com',
              Sender    => 'DW.Automation@globalknowledge.com',
              Recipient => 'Partner.Schedules.nam@globalknowledge.com', --'erica.loring@globalknowledge.com',
              CcRecipient => '',
              BccRecipient => 'DW.Automation@globalknowledge.com',
              Subject   => v_mail_hdr,
              Body => 'GK Weekly Audit Reports',
              ErrorMessage => v_error_msg,
              Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_audit,v_file_full_price));
--    v_error:= SendMailJPkg.SendMail(
--              SMTPServerName => 'corpmail.globalknowledge.com',
--              Sender    => 'DW.Automation@globalknowledge.com',
--              Recipient => 'jenna.doss@globalknowledge.com',
--              CcRecipient => 'Marion.Kennelly@globalknowledge.com',
--              BccRecipient => '',
--              Subject   => v_mail_hdr,
--              Body => 'GK Weekly Audit Reports',
--              ErrorMessage => v_error_msg,
--              Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_audit,v_file_full_price));
--    v_error:= SendMailJPkg.SendMail(
--              SMTPServerName => 'corpmail.globalknowledge.com',
--              Sender    => 'DW.Automation@globalknowledge.com',
--              Recipient => 'Heather.Hinson@globalknowledge.com',--'lindsay.kanwisher@globalknowledge.com',
--              CcRecipient => 'DW.Automation@globalknowledge.com',
--              BccRecipient => '',
--              Subject   => v_mail_hdr,
--              Body => 'GK Weekly Audit Reports',
--              ErrorMessage => v_error_msg,
--              Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_file_full_audit,v_file_full_price));
  end if;
end if;

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_ROYALTY_FEED FAILED',SQLERRM);

end;
/


