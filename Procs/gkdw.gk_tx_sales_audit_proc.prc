DROP PROCEDURE GKDW.GK_TX_SALES_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_tx_sales_audit_proc(p_bookdate varchar2 default null) as
cursor c0(vbook date) is
  select distinct source from oracletx_history 
   where trunc(createdate) = vbook
     and source != 'Undefined'
   order by source desc;
cursor c1(vsource varchar2,vbook date) is
  select source,ordertype,event_channel,event_modality,tx_cnt,method,to_char(tx_amt,'$999,990') tx_amt_disp,
         bk_cnt,to_char(bk_amt,'$999,990') bk_amt_disp,tx_amt,bk_amt
    from gk_tx_book_audit_v
   where source = vsource
     and bookdate = vbook
   order by source,event_modality,ordertype desc,method desc;
cursor c2(vsource varchar2,vbook date) is
  select md_desc event_modality,
       status_desc,
       count(enrollid) bk_cnt,
       sum(round(enroll_amt)) bk_amt,
       to_char(sum(round(enroll_amt)),'$999,990.00') bk_amt_disp
  from gk_daily_bookings_v
 where ch_desc = 'INDIVIDUAL/PUBLIC'
   and trunc(bookdate) = vbook
   and orderstatus = 'Cancelled'
   and case when country='Canada' then 'CA_OPS'
            else 'US_OPS'
       end = vsource
 group by md_desc,status_desc
 order by 1,2;
cursor c3(vsource varchar2,vbook date) is
select es.sotype,count(es.evxsoid) prepay_cnt,sum(esd.actualamount) prepay_amt,
       to_char(sum(esd.actualamount),'$999,999,990.00') prepay_amt_disp
  from slxdw.evxso es
       inner join slxdw.evxsodetail esd on es.evxsoid = esd.evxsoid
 where recordtype = 'Prepay Order'
   and trunc(es.createdate) = vbook
   and sostatus is null
   and case when es.billtocountry='Canada' then 'CA_OPS'
            else 'US_OPS'
       end = vsource
 group by es.sotype;
v_msg_body long := null;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
curr_mod varchar2(250) := '';
tx_cnt_mod_tot number := 0;
tx_amt_mod_tot number := 0;
bk_cnt_mod_tot number := 0;
bk_amt_mod_tot number := 0;
bk_amt_mod_tot_disp varchar2(50);
v_bookdate date;
begin
if p_bookdate is null then
  v_bookdate := trunc(sysdate)-1;
else
  v_bookdate := to_date(p_bookdate,'mm/dd/yyyy');
end if;
for r0 in c0(v_bookdate) loop
  v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=10></th></tr>';
  v_msg_body := v_msg_body||'<tr><th colspan=10>'||r0.source||' OracleTX - Sales Audit - '||v_bookdate||'</th></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>Source</th><th>Order</th><th>Channel</th><th>Modality</th><th>Method</th>';
  v_msg_body := v_msg_body||'<th>TX Cnt</th><th>TX Amt</th><th>Book Cnt</th><th>Book Amt</th><th>Book Subtotal</th></tr>';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=10></th></tr>';
  for r1 in c1(r0.source,v_bookdate) loop
    if r1.event_modality = curr_mod then
      bk_amt_mod_tot := bk_amt_mod_tot + r1.bk_amt;
    else
      v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=10></th></tr>';
      bk_amt_mod_tot := r1.bk_amt;
      curr_mod := r1.event_modality;
    end if;
    bk_amt_mod_tot_disp := to_char(bk_amt_mod_tot,'$999,990.00');
    if r1.ordertype = 'Credit' then
      v_msg_body := v_msg_body||'<tr bgcolor="#FFFF33">';
    else
      v_msg_body := v_msg_body||'<tr>';
    end if;
    v_msg_body := v_msg_body||'<td>'||r1.source||'</td><td>'||r1.ordertype||'</td><td>'||r1.event_channel||'</td>';
    v_msg_body := v_msg_body||'<td>'||r1.event_modality||'</td><td>'||r1.method||'</td><td align=right>'||r1.tx_cnt||'</td><td align=right>'||r1.tx_amt_disp||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||r1.bk_cnt||'</td><td align=right>'||r1.bk_amt_disp||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||bk_amt_mod_tot_disp||'</td></tr>';
  end loop;
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=10></th></tr>';
  v_msg_body := v_msg_body||'</table><p>';
  curr_mod := '';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr>';
  v_msg_body := v_msg_body||'<tr><th colspan=4>Cancellation Detail</th></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>Modality</th><th>Cancellation Reason</th><th>Count</th><th>Amount</th>';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr>';
  for r2 in c2(r0.source,v_bookdate) loop
    if r2.event_modality = curr_mod then
      bk_amt_mod_tot := bk_amt_mod_tot + r2.bk_amt;
    else
      v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr>';
      bk_amt_mod_tot := r2.bk_amt;
      curr_mod := r2.event_modality;
    end if;
    v_msg_body := v_msg_body||'<tr><td>'||r2.event_modality||'</td><td>'||r2.status_desc||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||r2.bk_cnt||'</td><td align=right>'||r2.bk_amt_disp||'</td></tr>';
  end loop;
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr></table>';
  v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr>';
  v_msg_body := v_msg_body||'<tr><th colspan=4>Prepay Card Orders</th></tr>';
  v_msg_body := v_msg_body||'<tr align="left"><th>Card Type</th><th>Count</th><th>Amount</th>';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr>';
  for r3 in c3(r0.source,v_bookdate) loop
    v_msg_body := v_msg_body||'<tr><td>'||r3.sotype||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||r3.prepay_cnt||'</td><td align=right>'||r3.prepay_amt_disp||'</td></tr>';
  end loop;
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr></table>';
  v_msg_body := v_msg_body||'<p></body></html>';
  v_mail_hdr := v_bookdate||'--'||r0.source||' Oracle TX - Sales Open Enrollment Audit';
  send_mail('DW.Automation@globalknowledge.com','jonathan.hensley@globalknowledge.com',v_mail_hdr,v_msg_body);
 -- send_mail('DW.Automation@globalknowledge.com','jeanette.ragland@globalknowledge.com',v_mail_hdr,v_msg_body);
  send_mail('DW.Automation@globalknowledge.com','elizabeth.cardona@globalknowledge.com',v_mail_hdr,v_msg_body);

end loop;
gk_enroll_audit_proc(v_bookdate);
end;
/


