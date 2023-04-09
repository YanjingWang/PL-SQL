DROP PROCEDURE GKDW.GK_ENROLL_AUDIT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_enroll_audit_proc(p_date date) as

cursor c1 is
  select f1.enroll_id,f1.event_id,f1.enroll_date,f1.keycode,f1.book_date,f1.rev_date,f1.book_amt,f1.curr_code,
         f1.salesperson,f1.territory,f1.region,f1.sales_rep,f1.region_rep,f1.enroll_status,f1.fee_type,
         f1.payment_method,e1.ops_country,e1.course_code,e1.event_channel,e1.event_modality,e1.event_prod_line,
         ui.username,ui.title,ui.department,
         f1.enroll_id||chr(9)||f1.event_id||chr(9)||f1.enroll_date||chr(9)||f1.keycode||chr(9)||f1.book_date||chr(9)||f1.rev_date||chr(9)||f1.book_amt||chr(9)||f1.curr_code||chr(9)||
         f1.salesperson||chr(9)||f1.territory||chr(9)||f1.region||chr(9)||f1.sales_rep||chr(9)||f1.region_rep||chr(9)||f1.enroll_status||chr(9)||f1.fee_type||chr(9)||
         f1.payment_method||chr(9)||e1.ops_country||chr(9)||e1.course_code||chr(9)||e1.event_channel||chr(9)||e1.event_modality||chr(9)||e1.event_prod_line||chr(9)||
         ui.username||chr(9)||ui.title||chr(9)||ui.department v_line
    from order_fact f1
         inner join event_dim e1 on f1.event_id = e1.event_id
         inner join slxdw.userinfo ui on f1.create_user = ui.userid
   where book_date = p_date
     and pp_sales_order_id is null
     and payment_method not in ('100% Credit')
     and enroll_status = 'Confirmed'
     and username not in ('Julie Annis','Kate Hyjek','Elizabeth Cardona','Betsy Kelsch','Kylie Graves')
     and not exists (
         select 1 from order_fact f2
                       inner join event_dim e2 on f2.event_id = e2.event_id
                 where f1.cust_id = f2.cust_id
                   and e1.course_code = e2.course_code
                   and f2.enroll_status = 'Cancelled'
                   and f1.enroll_date >= f2.enroll_date);

cursor c2 is
  select ops_country,event_channel,event_modality,department,sum(book_amt) book_raw,
         to_char(sum(book_amt),'$999,990.00') book_disp
    from order_fact f1
         inner join event_dim e1 on f1.event_id = e1.event_id
         inner join slxdw.userinfo ui on f1.create_user = ui.userid
   where book_date = p_date
     and pp_sales_order_id is null
     and payment_method not in ('100% Credit')
     and enroll_status = 'Confirmed'
     and username not in ('Julie Annis','Kate Hyjek','Elizabeth Cardona','Betsy Kelsch','Kylie Graves')
     and not exists (
         select 1 from order_fact f2
                  inner join event_dim e2 on f2.event_id = e2.event_id
            where f1.cust_id = f2.cust_id
              and e1.course_code = e2.course_code
              and f2.enroll_status = 'Cancelled'
              and f1.enroll_date >= f2.enroll_date)
   group by ops_country,event_channel,event_modality,department
   having sum(book_amt) > 0;

v_msg_body long;
v_mod_rollup number := 0;
v_ch_rollup number := 0;
v_ops_rollup number := 0;
v_mod varchar2(250) := 'NEW';
v_ch varchar2(250) := 'NEW';
v_ops varchar2(250) := 'NEW';
v_rep_file_name varchar2(250);
v_rep_file_full varchar2(250);
v_rep_file utl_file.file_type;
v_error number;
v_error_msg varchar2(500);
v_hdr varchar2(500) := 'Enroll ID'||chr(9)||'Event ID'||chr(9)||'Enroll Date'||chr(9)||'Keycode'||chr(9)||'Book Date'||chr(9)||'Rev Date'||chr(9)||'Amount'||chr(9)||'Currency'||chr(9)||'Sales Person'||chr(9)||'Territory'||chr(9)||'Region'||chr(9)||'Sales Rep'||chr(9)||'Region Rep'||chr(9)||'Enroll Status'||chr(9)||'Fee Type'||chr(9)||'Payment Method'||chr(9)||'Country'||chr(9)||'Course Code'||chr(9)||'Channel'||chr(9)||'Modality'||chr(9)||'Product Line'||chr(9)||'User'||chr(9)||'Title'||chr(9)||'Department';


begin

v_msg_body := '<html><head><link rel="stylesheet" href="http://www.globalknowledge.com/training/styles.css" type="text/css"></head><body>';
v_msg_body := v_msg_body||'<table border=0 cellspacing=2 cellpadding=2 style="font-size: 10pt;font-family:verdana">';
v_msg_body := v_msg_body||'<tr><th>New Enrollment Audit Report for '||p_date||':</th></tr>';

for r2 in c2 loop
  if r2.ops_country != v_ops then
    v_msg_body := v_msg_body||'</table><p><table border=1 bgcolor="#29006B" bordercolor="#FEEDC8" cellspacing=2 cellpadding=2 style="font-size: 8pt;font-family:verdana">';
    v_msg_body := v_msg_body||'<tr bgcolor="#FEEDC8"><th>Country</th><th>Channel</th><th>Modality</th><th>Department</th><th>Amount</th><th>MOD Rollup</th><th>CH Rollup</th><th>Country Rollup</th></tr>';
  elsif (r2.event_channel != v_ch or r2.event_modality != v_mod) and v_ops != 'NEW' then
    v_msg_body := v_msg_body||'<tr><th colspan=8></th></tr>';
  end if;

  if r2.ops_country = v_ops then
    v_ops_rollup := v_ops_rollup + r2.book_raw;
    v_ops := r2.ops_country;
  else
    v_ops_rollup := r2.book_raw;
    v_ops := r2.ops_country;
  end if;

  if r2.event_channel = v_ch then
    v_ch_rollup := v_ch_rollup + r2.book_raw;
    v_ch := r2.event_channel;
  else
    v_ch_rollup := r2.book_raw;
    v_ch := r2.event_channel;
  end if;

  if r2.event_modality = v_mod then
    v_mod_rollup := v_mod_rollup + r2.book_raw;
    v_mod := r2.event_modality;
  else
    v_mod_rollup := r2.book_raw;
    v_mod := r2.event_modality;
  end if;
  
  v_msg_body := v_msg_body||'<tr  bgcolor="#FFFFFF" align=left><td>'||r2.ops_country||'</td><td>'||r2.event_channel||'</td><td>'||r2.event_modality||'</td>';
  v_msg_body := v_msg_body||'<td>'||r2.department||'</td><td align=right>'||r2.book_disp||'</td>';
  v_msg_body := v_msg_body||'<td align=right>'||to_char(v_mod_rollup,'$999,990.00')||'</td>';
  v_msg_body := v_msg_body||'<td align=right>'||to_char(v_ch_rollup,'$999,990.00')||'</td>';
  v_msg_body := v_msg_body||'<td align=right>'||to_char(v_ops_rollup,'$999,990.00')||'</td></tr>';
end loop;

v_msg_body := v_msg_body||'</table><p>'; 
v_msg_body := v_msg_body||'</body></html>';

send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','Global Knowledge New Enrollment Summary Report',v_msg_body);
--send_mail('DW.Automation@globalknowledge.com','jeanette.ragland@globalknowledge.com','Global Knowledge New Enrollment Summary Report',v_msg_body);
send_mail('DW.Automation@globalknowledge.com','jonathan.hensley@globalknowledge.com','Global Knowledge New Enrollment Summary Report',v_msg_body);


select 'NewEnrollment_Detail_'||to_char(p_date,'yyyymmdd')||'.xls',
       '/usr/tmp/NewEnrollment_Detail_'||to_char(p_date,'yyyymmdd')||'.xls'
  into v_rep_file_name,v_rep_file_full
  from dual;

v_rep_file := utl_file.fopen('/usr/tmp',v_rep_file_name,'w');

utl_file.put_line(v_rep_file,v_hdr);

for r1 in c1 loop
  utl_file.put_line(v_rep_file,r1.v_line);
end loop;

utl_file.fclose(v_rep_file);

--v_error:= SendMailJPkg.SendMail(
--          SMTPServerName => 'nc10s250.globalknowledge.com',
--          Sender    => 'DW.Automation@globalknowledge.com',
--          Recipient => 'jeanette.ragland@globalknowledge.com',
--          CcRecipient => '',
--          BccRecipient => '',
--          Subject   => 'Global Knowledge New Enrollment Detail',
--          Body => 'Open Attachment to View Details',
--          ErrorMessage => v_error_msg,
--          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(v_rep_file_full));

end;
/


