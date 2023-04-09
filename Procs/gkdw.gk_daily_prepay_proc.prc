DROP PROCEDURE GKDW.GK_DAILY_PREPAY_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_daily_prepay_proc(p_bookdate varchar2 default null) is
cursor c1(v_book date) is
  select upper(es.billtocountry) billtocountry,
         upper(esd.productname) productname,
         upper(es.orderedbyaccount) orderedbyaccount,
         es.total,         
         pd.obprepay ob,
         pd.camprepay cam,
         pd.icamprepay icam,
         pd.fsdprepay fsd,
         pd.tamprepay tam,
         pd.namprepay nam,
         pd.iamprepay iam,
         pd.teaming,pd.new_account,
         to_char(es.total,'$999,990.00') total_disp,
         pd.ppcard_id,
         case when osr_rep_name is not null then osr_rep_name
              when cam_rep_name is not null then cam_rep_name
              when ob_rep_name is not null then ob_rep_name
              when icam_rep_name is not null then icam_rep_name
              when iam_rep_name is not null then iam_rep_name
              when tam_rep_name is not null then tam_rep_name
              when nam_rep_name is not null then nam_rep_name
              when fsd_rep_name is not null then fsd_rep_name
         end rep_name
    from slxdw.evxso es
         inner join slxdw.evxsodetail esd on es.evxsoid = esd.evxsoid
         inner join ppcard_dim pd on es.evxsoid = pd.sales_order_id
   where recordtype = 'Prepay Order'
     and trunc(es.createdate) = v_book
     and sostatus is null
   order by 1;
v_msg_body long;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
v_bookdate date;
v_audit_file varchar2(50);
v_audit_file_full varchar2(250);
v_file utl_file.file_type;
v_total number := 0;
v_total_disp varchar2(100);
begin
if p_bookdate is null then
  v_bookdate := trunc(sysdate)-1;
else
  v_bookdate := to_date(p_bookdate,'mm/dd/yyyy');
end if;
v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=15></th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=11>Daily Prepay Audit Report - '||v_bookdate||'</th></tr>';
v_msg_body := v_msg_body||'<tr align="left"><th>Bill Country</th><th>Short Name</th><th>Account</th><th>Prepay ID</th><th>Prepay Amt</th><th>OB</th>';
v_msg_body := v_msg_body||'<th>CAM</th><th>ICAM</th><th>FSD</th><th>TAM</th><th>NAM</th><th>IAM</th><th>New Acct</th><th>Rep Name</th>';
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=15></th></tr>';
for r1 in c1(v_bookdate) loop
  v_msg_body := v_msg_body||'<tr align="left"><td>'||r1.billtocountry||'</td><td>'||r1.productname||'</td><td>'||r1.orderedbyaccount||'</td><td>'||r1.ppcard_id||'</td>';
  v_msg_body := v_msg_body||'<td align=right>'||r1.total_disp||'</td><td align=center>'||r1.ob||'</td>';
  v_msg_body := v_msg_body||'<td align=center>'||r1.cam||'</td><td align=center>'||r1.icam||'</td>';
  v_msg_body := v_msg_body||'<td align=center>'||r1.fsd||'</td><td align=center>'||r1.tam||'</td><td align=center>'||r1.nam||'</td><td align=center>'||r1.iam||'</td>';
  v_msg_body := v_msg_body||'<td align=center>'||r1.new_account||'</td><td>'||r1.rep_name||'</td></tr>';
  v_total := v_total + r1.total;
end loop;
v_total_disp := to_char(v_total,'$999,990.00');
v_msg_body := v_msg_body||'<tr><th bgcolor="black" colspan=15></th></tr>';
v_msg_body := v_msg_body||'<tr><th colspan=4 align="right">'||v_total_disp||'</tr>';
v_msg_body := v_msg_body||'</table><p>';
v_mail_hdr := v_bookdate||'-- Daily Prepay Card Audit Report';
--send_mail('DW.Automation@globalknowledge.com','jeanette.ragland@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','jonathan.hensley@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','bob.kalainikas@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','cheryl.anderson@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','ada.meadows@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','Kathleen.Riker@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','dwayne.sparks@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','kyle.williford@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','gayle.zajac@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','krissi.fields@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','dan.endres@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','christiaan.filoon@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','chris.iraca@globalknowledge.com',v_mail_hdr,v_msg_body);
send_mail('DW.Automation@globalknowledge.com','mark.baker@globalknowledge.com',v_mail_hdr,v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','justin.avery@globalknowledge.com',v_mail_hdr,v_msg_body);

end;
/


