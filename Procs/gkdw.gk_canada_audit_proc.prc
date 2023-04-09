DROP PROCEDURE GKDW.GK_CANADA_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_canada_audit_proc(p_bookdate varchar2 default null) as

cursor c1(vbook date) is
select trunc(bookdate) bookdate,
       'CA_OPS' source,
       case when orderstatus in ('Attended','Confirmed') then 'Invoice'
            when enroll_status = 'Shipped' then 'Invoice'
            when orderstatus = 'Cancelled' then 'Credit'
            else enroll_status end ordertype,
       ch_desc event_channel,
       md_desc event_modality,
       pl_desc event_prod_line,
       count(distinct enrollid) bk_cnt,sum(round(enroll_amt)) bk_amt
  from gk_daily_bookings_v b
 where ch_value = '10'
   and country = 'Canada'
--   and nvl(attendeetype,'Registration') != 'Nexient'
   and trunc(bookdate) = vbook
 group by trunc(bookdate),
          case when orderstatus in ('Attended','Confirmed') then 'Invoice'
               when enroll_status = 'Shipped' then 'Invoice'
               when orderstatus = 'Cancelled' then 'Credit'
               else enroll_status
          end,
          ch_desc,md_desc,pl_desc
 order by event_prod_line,event_modality,ordertype desc;
 
cursor c2(vbook date) is
select trunc(bookdate) bookdate,
       md_desc event_modality,
       count(distinct enrollid) bk_cnt,sum(round(enroll_amt)) bk_amt
  from gk_daily_bookings_v b
 where ch_value = '10'
   and country = 'Canada'
--   and nvl(attendeetype,'Registration') != 'Nexient'
   and trunc(bookdate) = vbook
 group by trunc(bookdate),md_desc
 order by event_modality;
 
v_msg_body long;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
curr_pl varchar2(250) := 'FIRST';
curr_mod varchar2(250) := 'FIRST';
bk_cnt_mod_tot number := 0;
bk_amt_mod_tot number := 0;
bk_amt_pl_tot number := 0;
bk_total number := 0;
v_bookdate date;
v_audit_file varchar2(50);
v_audit_file_full varchar2(250);
v_file utl_file.file_type;
v_inv_total number := 0;
v_credit_total number := 0;


begin
if p_bookdate is null then
  v_bookdate := trunc(sysdate)-1;
else
  v_bookdate := to_date(p_bookdate,'mm/dd/yyyy');
end if;

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=9>Canadian Open Enrollment SalesLogix Bookings (Minus TP Enrollments) - '||v_bookdate||'</th></tr>';
v_msg_body := v_msg_body||'<tr height=1><th bgcolor="black" colspan=9></th></tr>';
v_msg_body := v_msg_body||'<tr align="left"><th>Prod Line</td><th>Order</th><th>Modality</th><th align=right>Book Cnt</th><th align=right>Book Amt</th></tr>';
--v_msg_body := v_msg_body||'<th>Mod Total</th><th>PL Total</th><th>Daily Total</th></tr>';
for r1 in c1(v_bookdate) loop
  bk_total := bk_total + r1.bk_amt;
  if r1.ordertype = 'Credit' then
     v_msg_body := v_msg_body||'<tr bgcolor="#FFFF33">';
     v_credit_total := v_credit_total + r1.bk_amt;
  else
     v_msg_body := v_msg_body||'<tr>';
     v_inv_total := v_inv_total + r1.bk_amt;
  end if;
  if r1.event_prod_line = curr_pl then
    bk_amt_pl_tot := bk_amt_pl_tot + r1.bk_amt;
    v_msg_body := v_msg_body||'<td bgcolor="#FFFFFF"></td>';
  else
    v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';
    v_msg_body := v_msg_body||'<td bgcolor="#FFFFFF">'||r1.event_prod_line||'</td>';
    bk_amt_pl_tot := r1.bk_amt;
    curr_pl := r1.event_prod_line;
  end if;
  if r1.event_modality = curr_mod then
    bk_amt_mod_tot := bk_amt_mod_tot + r1.bk_amt;
  else
    bk_amt_mod_tot := r1.bk_amt;
    curr_mod := r1.event_modality;
  end if;
  v_msg_body := v_msg_body||'<td>'||r1.ordertype||'</td>';
  v_msg_body := v_msg_body||'<td>'||r1.event_modality||'</td>';
  v_msg_body := v_msg_body||'<td align=right>'||r1.bk_cnt||'</td><td align=right>'||to_char(r1.bk_amt,'$999,990.00')||'</td></tr>';
--  v_msg_body := v_msg_body||'<td align=right>'||to_char(bk_amt_mod_tot,'$999,990.00')||'</td><td align=right>'||to_char(bk_amt_pl_tot,'$999,990.00')||'</td><td align=right>'||to_char(bk_total,'$999,990.00')||'</td></tr>';
end loop;
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=9></th></tr>';
v_msg_body := v_msg_body||'<tr><td colspan=4 align="left">Invoice Total</th><td align=right>'||to_char(v_inv_total,'$999,990.00')||'</th></tr>';
v_msg_body := v_msg_body||'<tr><td colspan=4 align="left">Credit Total</th><td align=right>'||to_char(v_credit_total,'$999,990.00')||'</th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=4 align="left">SLX Daily Total</th><th align=right>'||to_char(bk_total,'$999,990.00')||'</th></tr>';
v_msg_body := v_msg_body||'</table><p>';

v_msg_body := v_msg_body||'<table border=0 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr height=1><th bgcolor="black" colspan=3></th></tr>';
v_msg_body := v_msg_body||'<tr align="left"><th>Modality</th><th align=right>Book Cnt</th><th align=right>Book Amt</th></tr>';
v_msg_body := v_msg_body||'<tr height=1><th bgcolor="black" colspan=3></th></tr>';
for r2 in c2(v_bookdate) loop
  v_msg_body := v_msg_body||'<tr><td align=left>'||r2.event_modality||'</td><td align=right>'||r2.bk_cnt||'</td><td align=right>'||to_char(r2.bk_amt,'$999,990.00')||'</td></tr>';
end loop;
v_msg_body := v_msg_body||'<tr height=1><th bgcolor="black" colspan=3></th></tr>';
v_msg_body := v_msg_body||'</table>';

v_mail_hdr := v_bookdate||' -- Canadian Open Enrollment SalesLogix Bookings';
send_mail('DW.Automation@globalknowledge.com','erin.riley@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','doug.stevens@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','bob.kalainikas@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','jonathan.hensley@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','jeanette.ragland@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','dave.knier@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','john.kernodle@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','pamela.crowell@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','scott.williams@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','tanya.baggio@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','nick.livy@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','amanda.gladieux@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','jeff.varrone@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','kyle.williford@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','Jeffrey.a.cole@globalknowledge.com',v_mail_hdr,v_msg_body);

end;
/


