DROP PROCEDURE GKDW.GK_TX_BOOK_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_tx_book_audit_proc(p_bookdate varchar2 default null) as
cursor c0(vbook date) is
  select distinct source
    from oracletx_history
   where trunc(createdate) = vbook
     and source != 'Undefined'
   order by source desc;

cursor c1(vsource varchar2,vbook date) is
  select ordertype,event_modality,
         sum(tx_cnt) tx_cnt,
         sum(bk_cnt) bk_cnt,
         sum(tx_amt) tx_amt,sum(bk_amt) bk_amt
    from gk_tx_book_audit_v
   where source = vsource
     and bookdate = vbook
   group by ordertype,event_modality
   order by event_modality,ordertype desc;

cursor c2(vsource varchar2,vbook date) is
  select md_desc event_modality,
         status_desc,
         count(enrollid) bk_cnt,
         sum(round(enroll_amt)) bk_amt
    from gk_daily_bookings_v
   where trunc(bookdate) = vbook
     and ch_desc = 'INDIVIDUAL/PUBLIC'
     and orderstatus = 'Cancelled'
     and case when upper(country) = 'CANADA' then 'CA_OPS'
              else 'US_OPS'
         end = vsource
   group by md_desc,status_desc
   order by 1,2;

cursor c3(vsource varchar2,vbook date) is
select es.sotype,count(es.evxsoid) prepay_cnt,sum(esd.actualamount) prepay_amt,
       to_char(sum(esd.actualamount),'$9,999,999,990.00') prepay_amt_disp
  from slxdw.evxso es
       inner join slxdw.evxsodetail esd on es.evxsoid = esd.evxsoid
 where recordtype = 'Prepay Order'
   and trunc(es.createdate) = vbook
   and sostatus is null
   and case when es.billtocountry='Canada' then 'CA_OPS'
            else 'US_OPS'
       end = vsource
 group by es.sotype;

v_msg_body long;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
curr_pl varchar2(250) := 'FIRST';
curr_mod varchar2(250);
tx_cnt_mod_tot number := 0;
tx_amt_mod_tot number := 0;
bk_cnt_mod_tot number := 0;
bk_amt_mod_tot number := 0;
bk_amt_pl_tot number := 0;
v_bookdate date;
v_audit_file varchar2(50);
v_audit_file_full varchar2(250);
v_file utl_file.file_type;
begin

if p_bookdate is null then
  v_bookdate := trunc(sysdate)-1;
else
  v_bookdate := to_date(p_bookdate,'mm/dd/yyyy');
end if;

for r0 in c0(v_bookdate) loop
  v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
  v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';
  v_msg_body := v_msg_body||'<tr><th colspan=9>'||r0.source||' Open Enrollment Bookings Audit - '||v_bookdate||'</th></tr>';
  v_msg_body := v_msg_body||'<tr height=1><th bgcolor="black" colspan=9></th></tr>';
  tx_cnt_mod_tot := 0;
  tx_amt_mod_tot := 0;
  bk_cnt_mod_tot := 0;
  bk_amt_mod_tot := 0;
  bk_amt_pl_tot := 0;

  v_msg_body := v_msg_body||'<tr valign="top"><th>Order</th><th>Modality</th><th>TX Cnt</th><th>TX Amt</th><th>Book Cnt</th><th>Book Amt</th><th>Mod Total</th><th>PL Total</th></tr>';
  curr_mod := 'FIRST';
  for r1 in c1(r0.source,v_bookdate) loop
    bk_amt_pl_tot := bk_amt_pl_tot + r1.bk_amt;
    if r1.event_modality = curr_mod then
      bk_amt_mod_tot := bk_amt_mod_tot + r1.bk_amt;
    else
      v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';
      bk_amt_mod_tot := r1.bk_amt;
      curr_mod := r1.event_modality;
    end if;
    if r1.ordertype = 'Credit' then
      v_msg_body := v_msg_body||'<tr bgcolor="#FFFF33">';
    else
      v_msg_body := v_msg_body||'<tr>';
    end if;
    v_msg_body := v_msg_body||'<td>'||r1.ordertype||'</td>';
    v_msg_body := v_msg_body||'<td>'||r1.event_modality||'</td><td align=right>'||r1.tx_cnt||'</td><td align=right>'||to_char(r1.tx_amt,'$9,999,990.00')||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||r1.bk_cnt||'</td><td align=right>'||to_char(r1.bk_amt,'$9,999,990.00')||'</td>';
    v_msg_body := v_msg_body||'<td align=right>'||to_char(bk_amt_mod_tot,'$9,999,990.00')||'</td><td align=right>'||to_char(bk_amt_pl_tot,'$9,999,990.00')||'</td></tr>';
  end loop;
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr></table>';

  v_msg_body := v_msg_body||'</table><p>';
  curr_mod := '';

  v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
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
    v_msg_body := v_msg_body||'<tr><td>'||r2.event_modality||'</td><td>'||r2.status_desc||'</td><td align=right>'||r2.bk_cnt||'</td><td align=right>'||to_char(r2.bk_amt,'$9,999,990.00')||'</td></tr>';
  end loop;
  v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=4></th></tr></table>';
  v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
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
  v_mail_hdr := v_bookdate||'--'||r0.source||' Oracle TX - Bookings Report Open Enrollment Audit';

  if r0.source in ('CA_OPS','CA_NEST') then
   send_mail('DW.Automation@globalknowledge.com','Marie.Lee@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','krissi.fields@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','nick.livy@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Tiffany.Taylor@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Tara.Pegram@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Ashley.Wheeler@globalknowledge.com',v_mail_hdr,v_msg_body);
     send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com',v_mail_hdr,v_msg_body);
  else
   send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','doug.stevens@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','erin.riley@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','bob.kalainikas@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Marie.Lee@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','jonathan.hensley@globalknowledge.com',v_mail_hdr,v_msg_body);
  --  send_mail('DW.Automation@globalknowledge.com','jeanette.ragland@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','dave.knier@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','john.kernodle@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','dwayne.sparks@globalknowledge.com',v_mail_hdr,v_msg_body);
   -- send_mail('DW.Automation@globalknowledge.com','pamela.crowell@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','krissi.fields@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','frank.anastasio@globalknowledge.com',v_mail_hdr,v_msg_body);
  --  send_mail('DW.Automation@globalknowledge.com','kyle.williford@globalknowledge.com',v_mail_hdr,v_msg_body);
  --  send_mail('DW.Automation@globalknowledge.com','jeremy.mcmillan@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','alan.frelich@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','sruthi.reddy@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Tiffany.Taylor@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Tara.Pegram@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Jeff.Kongs@globalknowledge.com',v_mail_hdr,v_msg_body);
    send_mail('DW.Automation@globalknowledge.com','Ashley.Wheeler@globalknowledge.com',v_mail_hdr,v_msg_body);

   end if;
end loop;
end;
/


