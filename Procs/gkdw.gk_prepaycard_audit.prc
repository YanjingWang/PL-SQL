DROP PROCEDURE GKDW.GK_PREPAYCARD_AUDIT;

CREATE OR REPLACE PROCEDURE GKDW.gk_prepaycard_audit as
cursor c1 is
  select pc.evxppcardid||chr(9)||pc.issueddate||chr(9)||u.username||chr(9)||pc.expiresondate||chr(9)||pc.evxsoid||chr(9)||
         rct1.trx_number||chr(9)||rct1.trx_date||chr(9)||pc.cardstatus||chr(9)||pc.cardtype||chr(9)||pc.comments||chr(9)||
         pc.eventpasscounttotal||chr(9)||pc.eventpasscountavailable||chr(9)||replace(pc.issuedtoaccount,chr(10),'')||chr(9)||
         replace(pc.issuedtocontact,chr(10),'')||chr(9)||a.postalcode||chr(9)||pc.valuepurchasedbase||chr(9)||pc.valuebalancebase||chr(9)||
         aps.amount_due_remaining||chr(9)||t.territory_id audit_line
    from slxdw.evxppcard pc
         inner join ra_customer_trx_all@r12prd rct1 on pc.evxppcardid = rct1.ct_reference
         inner join ra_cust_trx_types_all@r12prd rctt1 on rct1.cust_trx_type_id = rctt1.cust_trx_type_id
                and rct1.org_id = rctt1.org_id and rctt1.type = 'DEP'
         inner join ar_payment_schedules_all@r12prd aps on rct1.customer_trx_id = aps.customer_trx_id
         inner join slxdw.userinfo u on pc.createuser = u.userid
         left outer join slxdw.contact c on pc.issuedtocontactid = c.contactid
         left outer join slxdw.address a on c.addressid = a.addressid
         left outer join gk_territory t on a.postalcode between t.zip_start and t.zip_end
   where cardstatus != 'Complete'
     and pc.eventpasscountavailable > 0
     and pc.expiresondate <= trunc(sysdate)+90
   order by pc.expiresondate asc;
audit_file varchar2(50);
audit_file_full varchar2(250);
audit_hdr varchar2(1000);
v_file utl_file.file_type;
v_mail_hdr varchar2(500);
v_error number;
v_error_msg varchar2(500);
begin
select 'PREPAY_AUDITFILE-'||to_char(sysdate,'yyyymmdd')||'.xls','/usr/tmp/PREPAY_AUDITFILE-'||to_char(sysdate,'yyyymmdd')||'.xls'
  into audit_file,audit_file_full
  from dual;
v_file := utl_file.fopen('/usr/tmp',audit_file,'w');
select 'Prepay Card ID'||chr(9)||'Date Issued'||chr(9)||'Taker'||chr(9)||'Expiration Date'||chr(9)||'Sales Order ID'||chr(9)||'Trx Number'||chr(9)||
       'Trx Date'||chr(9)||'Card Status'||chr(9)||'Card Type'||chr(9)||'Comments'||chr(9)||'Total Passes'||chr(9)||'Passes Avail'||chr(9)||
       'Issued to Account'||chr(9)||'Issued to Contact'||chr(9)||'Postal Code'||chr(9)||'Purchased Amt'||chr(9)||'Balance Amt'||chr(9)||'Amount Due'||chr(9)||'Terr ID'
    into audit_hdr
   from dual;
utl_file.put_line(v_file,audit_hdr);
for r1 in c1 loop
  utl_file.put_line(v_file,r1.audit_line);
end loop;
utl_file.fclose(v_file);
v_mail_hdr := to_char(sysdate,'yyyy-mm-dd')||' Prepay Card Audit';
v_error:= SendMailJPkg.SendMail(
          SMTPServerName => 'corpmail.globalknowledge.com',
          Sender    => 'DW.Automation@globalknowledge.com',
          Recipient => 'ada.meadows@globalknowledge.com',
          CcRecipient => '',
          BccRecipient => '',
          Subject   => v_mail_hdr,
          Body => 'Weekly Prepay Card Audit File',
          ErrorMessage => v_error_msg,
          Attachments  => SendMailJPkg.ATTACHMENTS_LIST(audit_file_full));

exception
  when others then
    utl_file.fclose(v_file);
    dbms_output.put_line(SQLERRM);
end;
/


