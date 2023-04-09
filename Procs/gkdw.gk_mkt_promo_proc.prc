DROP PROCEDURE GKDW.GK_MKT_PROMO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_mkt_promo_proc as

cursor c0 is
select ps.evxevenrollid pvxeligibleorderid,pp.pvxpromoid,ps.evxevenrollid
from gk_promo_status@slx ps
inner join pvxpromo@gkhub pp on ps.promo_code = pp.keycode
where ps.createdate >= '17-JAN-2016'
and ps.step_num = 1
and not exists (select 1 from pvxeligibleorder@gkhub pe where ps.evxevenrollid = pe.evxevenrollid);

cursor c1 is
select po.evxevenrollid,eh.enrollstatus
from pvxeligibleorder@gkhub po
     inner join evxenrollhx@slx eh on po.evxevenrollid = eh.evxevenrollid
where po.orderstatus != 'Cancelled'
and eh.enrollstatus in ('Cancelled','Did Not Attend')
union
select po.evxevenrollid,'Cancelled'
from pvxeligibleorder@gkhub po
     inner join gk_mkt_promo_cancelled_v pc on po.evxevenrollid = pc.enroll_id
where po.orderstatus != 'Cancelled';

cursor c2 is
select ps.evxevenrollid,ps.step_num,ps.step_status,eh.enrollstatus,to_char(eh.enrollstatusdate,'yyyy-mm-dd') enrollstatusdate
from gk_promo_status@slx ps
     inner join evxenrollhx@slx eh on ps.evxevenrollid = eh.evxevenrollid
where ps.step = 'Promo Status'
and ps.step_status != 'Expired'
and eh.enrollstatus in ('Cancelled','Did Not Attend');

cursor c3 is
select enroll_id,step_num,'Paid' step_status,p.date_paid
  from gk_promo_orders_paid_mv p
       inner join gk_promo_status@slx s on p.enroll_id = s.evxevenrollid and s.step = 'Order Paid' and s.step_status is null;
       
cursor c4 is
select pc.*,ps.step_num
from gk_mkt_promo_cancelled_v pc
     inner join gk_promo_status@slx ps on pc.enroll_id = ps.evxevenrollid and ps.step = 'Promo Status'
     and (ps.step_status != 'Expired' or ps.step_status is null);

cursor c5 is
select keycode,itemname,file_name,vendor_id,vendor_site_code,org_id,inv_org_id,curr_code,agent_id,requestor_id,itemname mfg_part_num,mfg_price,
       primary_email,cc_email,bcc_email,le,
       'Global Knowledge '||itemname||' Order File' email_hdr,
       keycode||'-'||upper(itemname) po_hdr
  from gk_promo_fulfill_mv p
 where not exists (select 1 from gk_promo_fulfilled_orders f where p.evxevenrollid = f.enroll_id)
   and to_char(sysdate,'d') = 2
   and to_char(sysdate,'hh24') in ('08','09')
 group by keycode,itemname,file_name,vendor_id,vendor_site_code,org_id,inv_org_id,curr_code,agent_id,requestor_id,mfg_price,
       primary_email,cc_email,bcc_email,le
 order by 1,2;

cursor c6(v_keycode varchar2,v_item varchar2) is
select p.evxevenrollid enroll_id,p.firstname||' '||p.lastname cust_name,p.account acct_name,p.address1,p.address2,p.city,p.state,upper(p.postalcode) zipcode,
       p.workphone phone_number,p.email,p.evxeventid,p.evxcourseid,p.pvxeligibleorderid,p.deliverytype,
       p.evxevenrollid||chr(9)||cd.course_code||chr(9)||p.firstname||' '||p.lastname||chr(9)||p.account||chr(9)||p.address1||chr(9)||
       p.address2||chr(9)||p.city||chr(9)||p.state||chr(9)||
       upper(case when p.postalcode like '0%' then chr(39)||p.postalcode else p.postalcode end)||chr(9)||
       p.workphone||chr(9)||p.email v_po_line,
       p.evxevenrollid||'-'||p.firstname||' '||p.lastname v_po_desc,
       '150' fe,'63320' acct,cd.ch_num ch,cd.md_num md,cd.pl_num pl,cd.act_num act,'210' cc,cd.course_code,p.keycode
  from gk_promo_fulfill_mv p
       inner join event_dim ed on p.evxeventid = ed.event_id
       inner join course_dim cd on ed.course_id = cd.course_id and ed.ops_country = cd.country
 where p.keycode = v_keycode
   and p.itemname = v_item;
   
cursor c10 is 
select filename from dir_list where filename like '%.csv'
 order by 1;
   
cursor c7 is
select f.enroll_id,f.po_num,f.po_line_num,
       replace(replace(upper(nvl(l.tracking_num,'ERROR')),'=',''),'"','') tracking_num,
       to_date(l.date_shipped,'mm/dd/yyyy') ship_date,
       to_char(to_date(l.date_shipped,'mm/dd/yyyy'),'yyyy-mm-dd') ship_date_text,
       case when upper(f.promo_item) like '%GIFT%CARD%' then 'Email'
            when l.carrier is not null then l.carrier||' Tracking Number: '||replace(l.tracking_num,'*','')
            when upper(nvl(l.tracking_num,'ERROR')) like '1Z%' then 'UPS Tracking Number: '||replace(l.tracking_num,'*','')
            when upper(nvl(l.tracking_num,'ERROR')) like 'C%' then 'OnTrac Tracking Number: '||replace(l.tracking_num,'*','')
            when upper(nvl(l.tracking_num,'ERROR')) like 'J%' then 'Purolator Tracking Number: '||replace(l.tracking_num,'*','')
            when upper(nvl(l.tracking_num,'ERROR')) like 'DU%' then 'Dunham Express Tracking Number: '||replace(l.tracking_num,'*','')
            else 'FedEx Tracking Number: '||replace(l.tracking_num,'*','')
       end addl_info
  from gk_promo_return_load l
       inner join gk_promo_fulfilled_orders f on l.gk_order = f.enroll_id;
       
cursor c8 is
select p.pvxorderid,pe.pvxeligibleorderid,pe.evxevenrollid,pp.pvxpromoitemid,
       'Item Selected' ps_status,
		 p.modifydate ps_date,
		 pp.itemname ps_addl_info,
		 ps.step_num
 from pvxorder@gkhub p 
      inner join pvxpromoitem@gkhub pp on p.pvxpromoitemid = pp.pvxpromoitemid
		inner join pvxeligibleorder@gkhub pe on p.pvxeligibleorderid = pe.pvxeligibleorderid
		inner join gk_promo_status@slx ps on pe.evxevenrollid = ps.evxevenrollid and ps.step = 'Promo Status'
where ps.step_status is null;

cursor c11 is
select f.enroll_id,f.keycode,s.promo_code
  from order_fact f
       inner join gk_promo_status@slx s on f.enroll_id = s.evxevenrollid and s.step_num = 1
 where upper(nvl(f.keycode,'NONE')) != upper(s.promo_code);

v_msg_body long := null;
v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_sid varchar2(25) := 'R12PRD';
curr_po varchar2(25);
v_line_num number := 1;
vcode_comb_id number;
l_req_id number;
v_rec_cnt number := 0;
v_date varchar2(25) := to_char(sysdate,'yyyy-mm-dd hh24:mi:ss');
type pe_order_arr is table of varchar2(50) index by binary_integer;
pe_order_data pe_order_arr;
type ev_order_arr is table of varchar2(50) index by binary_integer;
ev_order_data ev_order_arr;
type deliv_type_arr is table of varchar2(50) index by binary_integer;
deliv_type_data deliv_type_arr;
fulfill_cnt number := 1;

begin

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=3 cellpadding=3 style="font-size: 8pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><td align=left>GK_MKT_PROMO_PROC Start Time: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';
v_msg_body := v_msg_body||'<tr><td align=left>*********************************************************************************************</td></tr>';

for r11 in c11 loop
  update order_fact
     set keycode = r11.promo_code
   where enroll_id = r11.enroll_id;
end loop;
commit;

dbms_snapshot.refresh('gk_promo_orders_paid_mv');
v_msg_body := v_msg_body||'<tr><td align=left>GK_PROMO_ORDERS_PAID_MV Refreshed: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';

dbms_snapshot.refresh('gk_promo_fulfill_mv');
v_msg_body := v_msg_body||'<tr><td align=left>GK_PROMO_FULFILL_MV Refreshed: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';
-- INSERT NEW ORDERS INTO PVXELIGIBLEORDER TABLE
v_rec_cnt := 0;
for r0 in c0 loop
  insert into pvxeligibleorder@gkhub values
  (r0.pvxeligibleorderid,r0.pvxpromoid,r0.evxevenrollid,null,1,'promo_proc',v_date,'promo_proc',v_date);
  v_rec_cnt := v_rec_cnt+1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>'||v_rec_cnt||' ORDERS INSERTED INTO PVXELIGIBLEORDER-'||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';

--UPDATE CANCELLED AND DID NOT ATTEND ENROLLMENTS IN PVXELIGIBLEORDER TABLE
v_rec_cnt := 0;
for r1 in c1 loop
  update pvxeligibleorder@gkhub
     set orderstatus = 'Cancelled',
         active = 0,
         modifydate = v_date,
         modifyuser = 'promo_proc'
   where evxevenrollid = r1.evxevenrollid;
  v_rec_cnt := v_rec_cnt+1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>'||v_rec_cnt||' ORDERS MARKED AS CANCELLED IN PVXELIGIBLEORDER-'||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';

--UPDATE GK_PROMO_STATUS TABLE TO EXPIRED FOR CANCELLED AND DID NOT ATTEND
v_rec_cnt := 0;
for r2 in c2 loop
  update gk_promo_status@slx
     set step_status = 'Expired',
         status_date = r2.enrollstatusdate,
         additional_info = null
   where evxevenrollid = r2.evxevenrollid
     and step_num = r2.step_num;
   v_rec_cnt := v_rec_cnt+1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>'||v_rec_cnt||' CANCEL/DID NOT ATTEND ORDERS MARKED AS EXPIRED IN GK_PROMO_STATUS-'||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';

--UPDATE GK_PROMO_STATUS TABLE FOR PAID ENROLLMENTS
v_rec_cnt := 0;
for r3 in c3 loop  
  update gk_promo_status@slx
     set step_status = r3.step_status,
         status_date = r3.date_paid
   where evxevenrollid = r3.enroll_id
     and step_num = r3.step_num;
  v_rec_cnt := v_rec_cnt+1;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>'||v_rec_cnt||' ORDERS MARKED AS PAID IN GK_PROMO_STATUS-'||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';

--UPDATE GK_PROMO_STATUS TABLE WITH SELECTED ITEM
v_rec_cnt := 0;
for r8 in c8 loop
  update gk_promo_status@slx
     set step_status = r8.ps_status,
         status_date = r8.ps_date,
         additional_info = r8.ps_addl_info
   where evxevenrollid = r8.evxevenrollid
     and step_num = r8.step_num;
  v_rec_cnt := v_rec_cnt+1;
end loop;
commit;
 
v_msg_body := v_msg_body||'<tr><td align=left>'||v_rec_cnt||' ITEMS SELECTED IN GK_PROMO_STATUS-'||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';
 
-- EXPIRATION OF ENROLLMENTS ON GK_PROMO_STATUS AND EVXELIGIBLEORDER
v_rec_cnt := 0;
for r4 in c4 loop  
  update gk_promo_status@slx
     set step_status = 'Expired',
         status_date = r4.status_date,
         additional_info = r4.addl_info
   where evxevenrollid = r4.enroll_id
     and step_num = r4.step_num;
end loop;
commit;

v_msg_body := v_msg_body||'<tr><td align=left>'||v_rec_cnt||' ORDERS MARKED AS EXPIRED IN GK_PROMO_STATUS-'||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';

-- PROMO FULFILLMENT PROCESSING
for r5 in c5 loop
  v_rec_cnt := 1;
  v_line_num := 1;

  select r5.file_name||to_char(sysdate,'yyyy-mm-dd')||'.xls',
         '/usr/tmp/'||r5.file_name||to_char(sysdate,'yyyy-mm-dd')||'.xls'
    into v_file_name,v_file_name_full
    from dual;

  select 'GK Order Num'||chr(9)||'Course Code'||chr(9)||'Name'||chr(9)||'Company Name'||chr(9)||'Address1'||chr(9)||'Address2'||chr(9)||'City'||chr(9)||'State'||chr(9)||'Zip'||chr(9)||
         'Phone Number'||chr(9)||'Email'||chr(9)||'PO Num'||chr(9)||'PO Line'||chr(9)||'Mfg Part#'||chr(9)||'Qty'||chr(9)||'Price'||chr(9)||'Tracking Num'||chr(9)||'Date Shipped'
    into v_hdr
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
  utl_file.put_line(v_file,v_hdr);

  select gk_get_curr_po(r5.org_id,v_sid) into curr_po from dual;
  gk_update_curr_po(r5.org_id,v_sid);
  commit;
  
  gkn_po_create_hdr_proc@r12prd(curr_po,r5.vendor_id,r5.vendor_site_code,r5.org_id,r5.agent_id,r5.curr_code,r5.po_hdr||'-'||to_char(sysdate,'YYYY-MM-DD'));

  for r6 in c6(r5.keycode,r5.itemname) loop
    utl_file.put_line(v_file,r6.v_po_line||chr(9)||curr_po||chr(9)||v_line_num||chr(9)||r5.itemname||chr(9)||'1'||chr(9)||r5.mfg_price);

    insert into gk_promo_fulfilled_orders(enroll_id,request_date,po_num,po_line_num,promo_code,promo_item)
      select r6.enroll_id,sysdate,curr_po,v_line_num,r5.keycode,r5.itemname from dual;

    vcode_comb_id := gkn_get_account@r12prd(r5.le,r6.fe,r6.acct,r6.ch,r6.md,r6.pl,r6.act,r6.cc);
    gkn_po_create_line_proc@r12prd(v_line_num,null,r6.v_po_desc,'EACH',1,r5.mfg_price,trunc(sysdate),r5.inv_org_id,r5.org_id,
                                   vcode_comb_id,'CARY',r5.requestor_id,r6.course_code,136);
    
    pe_order_data(fulfill_cnt) := r6.pvxeligibleorderid; 
    ev_order_data(fulfill_cnt) := r6.enroll_id;
    deliv_type_data(fulfill_cnt) := r6.deliverytype; 
   
    v_line_num := v_line_num+1;
    fulfill_cnt := fulfill_cnt+1;
  end loop;
  commit;
  
  utl_file.fclose(v_file);

  send_mail_attach('DW.Automation@globalknowledge.com',r5.primary_email,r5.cc_email,r5.bcc_email,r5.email_hdr,'See Attachment',v_file_name_full);
  send_mail_attach('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','','',r5.email_hdr,'See Attachment',v_file_name_full);

  --03/15/2018 Uma start of changes
  IF r5.itemname = 'Surface Pro'
  THEN
    send_mail_attach('DW.Automation@globalknowledge.com','christian.perry@connection.com','','',r5.email_hdr,'See Attachment',v_file_name_full); 
  END IF;
  --03/15/2018 Uma end of changes
  
  IF r5.keycode in ('COOL','COOLER','COOLEST') -- SR 04/02/2018
  then 
  send_mail_attach('DW.Automation@globalknowledge.com','Christian.Perry@connection.com','Fulfillment.us@globalknowledge.com','ipadpromo@globalknowledge.com',r5.email_hdr,'See Attachment',v_file_name_full);
  send_mail_attach('DW.Automation@globalknowledge.com','Taylor.bikowski@globalknowledge.com','','',r5.email_hdr,'See Attachment',v_file_name_full); 
  end if;
  
  v_msg_body := v_msg_body||'<tr><td align=left>'||r5.keycode||'-'||r5.itemname||' Processed: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';
end loop;

-- FULFILLMENT UPDATES IN MYGK DATABASE AND PROMO STATUS TABLE IN SLX
for i in 1..pe_order_data.count loop
  update pvxorder@gkhub
     set isprocessed = 1,
         modifyuser = 'promo_proc',
         modifydate = v_date
   where pvxeligibleorderid = pe_order_data(i);
end loop;  
commit;

for i in 1..pe_order_data.count loop
  update pvxeligibleorder@gkhub
     set orderstatus = 'Redeemed',
         modifyuser = 'promo_proc',
         modifydate = v_date
   where pvxeligibleorderid = pe_order_data(i);
end loop; 
commit;

dbms_output.put_line('test1');
--for i in 1..ev_order_data.count loop
--  update gk_promo_status@slx
--     set step_status = 'Item Delivered',
--         status_date = v_date,
--         additional_info = deliv_type_data(i)
--   where evxevenrollid = ev_order_data(i)
--     and step = 'Promo Fulfilled';
--end loop; 
--commit;

fnd_global_apps_init@r12prd(1111,20707,201,'PO',84) ;  -- US REQUEST
l_req_id := fnd_request.submit_request@r12prd('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
            NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
commit;

dbms_output.put_line('test2');  
--fnd_global_apps_init@r12prd(1111,50248,201,'PO',86) ;  -- CANADIAN REQUEST -- commented 06/03/2019  as R12DEV is down
--l_req_id := fnd_request.submit_request@r12dev('PO','POXPOPDOI','Import Standard Purchase Orders','',FALSE,
--            NULL,'STANDARD',NULL,'N',NULL,'APPROVED','','','',
--            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
--            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',
--            '','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');
commit;


dbms_output.put_line('test3');
get_dir_list('/mnt/nc10s210_ipad');

for r10 in c10 loop
--  dbms_output.put_line('Processing: '||r10.filename);
  
  v_file := utl_file.fopen('/mnt/nc10s210_ipad',r10.filename, 'r');
  
  sys.system_run('cp /mnt/nc10s210_ipad/'||r10.filename||' /d01/gkdw_load/ipad_mini_arch/'||r10.filename);
  sys.system_run('mv /mnt/nc10s210_ipad/'||r10.filename||' /d01/gkdw_load/gk_promo_load.csv');
  
  for r7 in c7 loop
    
    dbms_output.put_line(r7.enroll_id);
    
    update gk_promo_fulfilled_orders
       set tracking_num = r7.tracking_num,
           shipped_date = r7.ship_date
     where enroll_id = r7.enroll_id;
    commit;
     
    update gk_promo_status@slx
       set status_date = r7.ship_date_text,
           step_status = 'Item Shipped',
           additional_info = r7.addl_info
     where evxevenrollid = r7.enroll_id
       and step = 'Promo Fulfilled';
    commit;
  end loop;         
  commit;
  
  utl_file.fclose(v_file);
  
  v_msg_body := v_msg_body||'<tr><td align=left>'||r10.filename||' Processed: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';
  
end loop;

gk_promo_receive_po_proc;
gk_receive_request_proc('R12PRD');

dbms_snapshot.refresh('gk_promo_audit_mv');
dbms_snapshot.refresh('gk_promo_orders_mv');
send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','Promo Process Complete',v_msg_body);

v_msg_body := v_msg_body||'<tr><td align=left>*********************************************************************************************</td></tr>';
v_msg_body := v_msg_body||'<tr><td align=left>GK_MKT_PROMO_PROC End Time: '||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||'</td></tr>';
v_msg_body := v_msg_body||'</table></body></html>';

if to_char(sysdate,'hh24') = '09'
  then gk_promo_trans_email_proc;
end if;

exception
 when others then
    rollback;
    utl_file.fclose(v_file);
    v_msg_body := v_msg_body||'<tr><td align=left>'||SQLERRM||'</td></tr>';
    v_msg_body := v_msg_body||'</table></body></html>';
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_MKT_PROMO_PROC Failed',v_msg_body);

end;
/


