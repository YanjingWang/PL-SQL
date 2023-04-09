DROP PROCEDURE GKDW.NULL_ACCT_ID_FIX_SB;

CREATE OR REPLACE PROCEDURE GKDW.Null_Acct_id_Fix_SB as

cursor C1 is
select * from master_ent_oe_booking_mv where trunc(book_date)>=trunc(sysdate-3) and acct_name is null; 
v_count number;
 v_msg_body   LONG := NULL;

begin

select count(*) into v_count from master_ent_oe_booking_mv where trunc(book_date)>=trunc(sysdate-3) and acct_name is null; 

insert into aact_status_audit_SB values ('Null_Acct_id_Fix',sysdate,v_count,null,null);

commit;

for R1 in C1 loop


insert into slxdw11g.account@SLXDW11G.REGRESS.RDBMS.DEV.US.ORACLE.COM  (

SELECT distinct
/*+ NO_MERGE */
/* ACCOUNT.INOUTGRP1, FLTR.INOUTGRP1, EXPR.OUTGRP1 */
  TO_CHAR( "ACCOUNT"."ACCOUNTID" )/* ATTRIBUTE EXPR.OUTGRP1.ACCOUNT_ID_CHAR: EXPRESSION */ "ACCOUNT_ID_CHAR",
  "ACCOUNT"."TYPE" "TYPE",
  "ACCOUNT"."ACCOUNT" "ACCOUNT$1",
  "ACCOUNT"."DIVISION" "DIVISION",
  "ACCOUNT"."MAINPHONE" "MAINPHONE",
  "ACCOUNT"."FAX" "FAX",
  to_char(  "ACCOUNT"."SECCODEID" )/* ATTRIBUTE EXPR.OUTGRP1.SECCODE_ID_CHAR: EXPRESSION */ "SECCODE_ID_CHAR",
  "ACCOUNT"."INDUSTRY" "INDUSTRY",
  "ACCOUNT"."ACCOUNTMANAGERID" "ACCOUNTMANAGERID",
  "ACCOUNT"."CREATEUSER" "CREATEUSER",
  "ACCOUNT"."MODIFYUSER" "MODIFYUSER",
  "ACCOUNT"."CREATEDATE" "CREATEDATE",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE",
  "ACCOUNT"."AKA" "AKA",
  "ACCOUNT"."CURRENCYCODE" "CURRENCYCODE",
  null,null,null,null,null,
  "ACCOUNT"."ADDRESSID" "ADDRESSID",
  "ACCOUNT"."USERFIELD1" "USERFIELD1",
  "ACCOUNT"."EMAIL" "EMAIL",
  "ACCOUNT"."WEBADDRESS" "WEBADDRESS"
FROM
  "sysdba"."ACCOUNT"@"SLX.REGRESS.RDBMS.DEV.US.ORACLE.COM"  "ACCOUNT"
  WHERE   ( "ACCOUNT"."ACCOUNTID" =R1.acct_id)
  and not exists (select  accountid from slxdw11g.account@SLXDW11G.REGRESS.RDBMS.DEV.US.ORACLE.COM t1
  where t1.accountid ="ACCOUNT"."ACCOUNTID")
 
  and "ACCOUNT"."ADDRESSID" IS NOT NULL); 
  
  
  
  
insert into slxdw.account
select * from slxdw11g.account@"SLXDW11G.REGRESS.RDBMS.DEV.US.ORACLE.COM" where accountid =R1.acct_id
and  not exists (select  accountid from slxdw.account t1
  where t1.accountid ="ACCOUNT"."ACCOUNTID");
  




  end loop;
  
  update aact_status_audit_SB 
set fix_status='Completed',
fix_date=sysdate
where process='Null_Acct_id_Fix'
and trunc(run_date)=trunc(sysdate);
  
  commit;
  
  Enroll_status_fix_sb;
  
  order_fact_addr_upd_proc_sb;
   DBMS_SNAPSHOT.REFRESH ('MASTER_OE_BOOKINGS_MV');
   DBMS_SNAPSHOT.REFRESH ('MASTER_ENT_BOOKINGS_MV');
   DBMS_SNAPSHOT.REFRESH ('MASTER_ENT_BOOKINGS_MV_$0');
   DBMS_SNAPSHOT.REFRESH ('gkdw.master_ent_oe_booking_mv');
   DBMS_SNAPSHOT.REFRESH ('GKDW.MASTER_ENT_OE_BOOKING_MV_$0');
  
  commit;
  
    send_mail ('DW.Automation@globalknowledge.com','Erin.Riley@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Rajesh.Jr@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
  send_mail ('DW.Automation@globalknowledge.com','Bindu.RaviKumar@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Keshia.Baker@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Tiffany.Taylor@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
  send_mail ('DW.Automation@globalknowledge.com','katie.santos@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');

send_mail ('DW.Automation@globalknowledge.com','Bala.Subramanian@globalknowledge.com','8:00AM Refresh-GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Alan.frelich@globalknowledge.com','8:00AM Refresh-GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','Smaranika.baral@globalknowledge.com','8:00AM Refresh-GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
   send_mail ('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_MV_REFRESH_PROC completed Successfully.','Warehouse MV refresh is now complete');
EXCEPTION
   WHEN OTHERS
   THEN
      v_msg_body :=
            v_msg_body
         || '<tr><td align=left>'
         || 'Error located at: '
         || v_count
         || '</td></tr>';
      v_msg_body :=
         v_msg_body || '<tr><td align=left>' || SQLERRM || '</td></tr>';
      v_msg_body := v_msg_body || '</table></body></html>';
      send_mail ('DW.Automation@globalknowledge.com',
                 'DW.Automation@globalknowledge.com',
                 '8:00AM Refresh-GK_MV_REFRESH_PROC FAILED',
                v_msg_body);
       send_mail ('DW.Automation@globalknowledge.com',
                 'smaranika.baral@globalknowledge.com',
                 '8:00AM Refresh-GK_MV_REFRESH_PROC FAILED',
                 v_msg_body);    
       send_mail ('DW.Automation@globalknowledge.com',
                'bala.subramanian@globalknowledge.com',
                 '8:00AM Refresh-GK_MV_REFRESH_PROC FAILED',
                 v_msg_body);   
  
  end;
/


