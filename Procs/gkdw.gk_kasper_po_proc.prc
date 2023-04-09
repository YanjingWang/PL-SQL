DROP PROCEDURE GKDW.GK_KASPER_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_kasper_po_proc(p_test varchar2 default 'N') as

cursor c1(p_sid varchar2) is
select gk_get_curr_po(84,p_sid) curr_po,1198001 vendor_id,'WOBURN' vendor_site_code,84 org_id,101 inv_org_id,264 agent_id,183 requestor,'USD' curr_code
  from event_dim ed
       inner join order_fact f  on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where substr(cd.course_Code,1,4) = '4960'
 and upper(f.source) != 'KASPERWEB' 
   and cd.ch_num in ('10','20')
   and cd.md_num in ('10','20')
   and ed.start_date+2 = trunc(sysdate) 
   and enroll_status not in ('Cancelled','Did Not Attend')
   group by 1198001,84,101,264,'USD';

cursor c2 is
   select distinct ed.event_id, 
   count(f.enroll_id) over (partition by f.event_id order by f.event_id) stud_cnt,
   cd.course_code,cd.course_name,cd.short_name,cd.course_ch,cd.course_mod,cd.course_pl,
       ed.start_date,ed.facility_code,ed.facility_region_metro metro,ed.ops_country,
       220 po_unit_price,
       '210' le,
       '130' fe,
       '62405' acct,
       cd.ch_num ch,
       cd.md_num md,
       cd.pl_num pl,
       cd.act_num act,
       '200' cc,
       'KASPERLAB PO-'||cd.course_code||'-'||to_char(ed.start_date,'yyyymmdd')||'-'||ed.event_id po_line_desc
  from event_dim ed
       inner join order_fact f  on f.event_id = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where substr(cd.course_Code,1,4) = '4960'
 and upper(f.source) != 'KASPERWEB'
   and cd.ch_num in ('10','20')
   and cd.md_num in ('10','20')
   and ed.start_date+2 = trunc(sysdate)
   and f.book_amt > 0
   and f.enroll_status not in ('Cancelled','Did Not Attend')
 order by event_id;

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

--cursor c4(p_sid varchar2,v_po_num varchar2) is
--select distinct h.segment1,h.po_header_id,l.po_line_id,h.vendor_id,h.vendor_site_id,
--       d.deliver_to_person_id,trunc(sysdate) ship_date,d.destination_organization_id,l.category_id,
--       l.line_num,l.item_description,l.quantity,trunc(sysdate) deliv_date,
--       l.quantity qty_deliv,
--       l.unit_meas_lookup_code,u.uom_code
--  from po_headers_all@r12dev h
--       inner join po_lines_all@r12dev l on h.po_header_id = l.po_header_id
--       inner join po_distributions_all@r12dev d on l.po_line_id = d.po_line_id
--       inner join mtl_units_of_measure@r12dev u on l.unit_meas_lookup_code = u.unit_of_measure
-- where h.segment1 = v_po_num
--   and p_sid = 'R12DEV'
--union
--select distinct h.segment1,h.po_header_id,l.po_line_id,h.vendor_id,h.vendor_site_id,
--       d.deliver_to_person_id,trunc(sysdate) ship_date,d.destination_organization_id,l.category_id,
--       l.line_num,l.item_description,l.quantity,trunc(sysdate) deliv_date,
--       l.quantity qty_deliv,
--       l.unit_meas_lookup_code,u.uom_code
--  from po_headers_all@r12prd h
--       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
--       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
--       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
-- where h.segment1 = v_po_num
--   and p_sid = 'R12PRD';

v_sid varchar2(10);
--curr_po varchar2(25);
vneed_date date;
vpo_hdr varchar2(250);
vline_num number;
r1 c1%rowtype;
v_msg_body long;
vcode_comb_id number;
l_req_id number;
loop_cnt number := 1;
r3 c3%rowtype;
--v_rcv_header number;
--v_rcv_interface number;
--v_rcv_transaction number;
--po_cnt number;

begin

if p_test = 'Y' then
  v_sid := 'R12DEV';
else
  v_sid := 'R12PRD';
end if;

open c1(v_sid);fetch c1 into r1;

if c1%found then
  gk_update_curr_po(84,v_sid);
  commit;

  vneed_date := trunc(sysdate)+1;
  vpo_hdr := 'KASPERLAB PO';
  vline_num := 1;

  v_msg_body := '';

  v_msg_body := v_msg_body||'<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr align=left><td colspan=2><img src="http://images.globalknowledge.com/wwwimages/gk_logo.gif" alt="Global Knowledge IT Training" width=165 height=90 border=0></td></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left colspan=2>Global Knowledge - KL ATC License Payment</th></tr>';
  v_msg_body := v_msg_body||'<tr align=left><th align=left>PO Number:</th><td>'||r1.curr_po||'</td></tr>';
  v_msg_body := v_msg_body||'</table><p>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th>Line</th><th>Event ID</th><th>Metro</th><th>Course</th><th>Start Date</th><th>Stud<br>Cnt</th><th>Line Amt</th></tr>';

  if p_test = 'Y' then
    gkn_po_create_hdr_proc@r12dev(r1.curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);
  else
    gkn_po_create_hdr_proc@r12prd(r1.curr_po,r1.vendor_id,r1.vendor_site_code,r1.org_id,r1.agent_id,r1.curr_code);
  end if;

  for r2 in c2 loop
    v_msg_body := v_msg_body||'<tr><td align=right>'||vline_num||'</td><td align=center>'||r2.event_id||'('||r2.course_code||')</td>';-- <td align=left>'||r2.cust_name||'</td>';
    v_msg_body := v_msg_body||'<td align=center>'||r2.metro||'</td><td align=left>'||r2.course_name||'</td>';
    v_msg_body := v_msg_body||'<td>'||r2.start_date||'</td><td align=right>'||r2.stud_cnt||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||to_char(r2.stud_cnt*r2.po_unit_price,'$999,990.00')||'</td></tr>';

    if p_test = 'Y' then
      vcode_comb_id := gkn_get_account@r12dev(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
      gkn_po_create_line_proc@r12dev(vline_num,null,r2.po_line_desc,'EACH',r2.stud_cnt,r2.po_unit_price,vneed_date,r1.inv_org_id,r1.org_id,
                                   vcode_comb_id,'CARY',r1.requestor,r2.event_id,125);
    else
      vcode_comb_id := gkn_get_account@r12prd(r2.le,r2.fe,r2.acct,r2.ch,r2.md,r2.pl,r2.act,r2.cc);
      gkn_po_create_line_proc@r12prd(vline_num,null,r2.po_line_desc,'EACH',r2.stud_cnt,r2.po_unit_price,vneed_date,r1.inv_org_id,r1.org_id,
                                  vcode_comb_id,'CARY',r1.requestor,r2.event_id,125);
    end if;
    commit;

    vline_num := vline_num + 1;

  end loop;
  v_msg_body := v_msg_body||'</table>';
  v_msg_body := v_msg_body||'</body></html>';

  if p_test = 'Y' then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','Global Knowledge - KL ATC License Payment',v_msg_body);
  else
    send_mail('DW.Automation@globalknowledge.com','Maria.Kochetkova@kaspersky.com','Global Knowledge - KL ATC License Payment',v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','ambra.motilall@globalknowledge.com','Global Knowledge - KL ATC License Payment',v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Michalina.DeBoard@globalknowledge.com','Global Knowledge - KL ATC License Payment',v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','bala.subramanian@globalknowledge.com','Global Knowledge - KL ATC License Payment',v_msg_body);
  end if;

  if p_test = 'Y' then
    fnd_global_apps_init@r12dev(1111,20707,201,'PO',84) ;

    l_req_id := fnd_request.submit_request@r12dev('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
                NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  else
    fnd_global_apps_init@r12prd(1111,20707,201,'PO',86) ;

    l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
                NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
                '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
  end if;
  commit;

  /*while loop_cnt < 5 loop
    open c3(v_sid,l_req_id);
    fetch c3 into r3;
    if r3.phase_code = 'C' then
      loop_cnt := 5;
      dbms_lock.sleep(30);
      gk_receive_po_proc(r1.curr_po,v_sid);
      gk_receive_request_proc(v_sid);
    else
      loop_cnt := loop_cnt+1;
      dbms_lock.sleep(30);
    end if;
    close c3;
  end loop;*/--------------------changes made by SBARAl to disable Oracle Auto-Receiving
  
end if;

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_kasper_po_proc failed',SQLERRM);

end;
/


