DROP PROCEDURE GKDW.GK_CUST_PREPAY_RPT;

CREATE OR REPLACE PROCEDURE GKDW.gk_cust_prepay_rpt as
cursor c0 is
select "TYPE"||chr(9)||
DEP_NUMBER||chr(9)||
DEP_DATE||chr(9)||
DEP_AMOUNT||chr(9)||
TRX_NUM||chr(9)||
CT_REFERENCE||chr(9)||
LINE_NUM||chr(9)||
ENROLLMENT_ID||chr(9)||
LINE_AMOUNT||chr(9)||
TAX_AMOUNT||chr(9)||
TRX_DATE||chr(9)||
AMOUNT_DUE_ORIGINAL||chr(9)||
ORACLE_ACCOUNT_NUMBER||chr(9)||
CUST_NAME||chr(9)||
SLX_CONTACT_ID||chr(9)||
replace(SLX_CONTACT_NAME,',',' ')||chr(9)||
SLX_PREPAY_ID v_line from XXGK_CUST_DEP_INV_V@R12PRD;

cursor c1 is
select ORACLE_ACCOUNT_NUMBER||chr(9)||
CUST_NAME||chr(9)||
DEP_NUMBER||chr(9)||
DEP_DATE||chr(9)||
DEP_AMOUNT||chr(9)||
SLX_CONTACT_ID||chr(9)||
replace(SLX_CONTACT_NAME,',',' ')||chr(9)||
AMT_USED||chr(9)||
AMT_REMAINING||chr(9)||
SLX_PREPAY_ID||chr(9)||
PREPAY_TYPE||chr(9)||
PREPAY_METHOD v_line from XXGK_CUST_DEP_SUMMARY@R12PRD;

v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;
v_file_name_1 varchar2(50);
v_file_name_full_1 varchar2(250);
v_hdr_1 varchar2(1000);
v_file_1 utl_file.file_type;
v_msg_body long;

begin

-- Generate Customer Deposit Invoice (Detailed) report
select 'Customer_Deposit_invoice.xls',
       '/mnt/nc10s141_ibm/ww/rss-ibm/Customer_Deposit_invoice.xls'
  into v_file_name,v_file_name_full
  from dual;

select 'Contact Company'||chr(9)||'TYPE'||chr(9)||'DEP_NUMBER'||chr(9)||'DEP_DATE'||chr(9)||'DEP_AMOUNT'||chr(9)||'TRX_NUM'||chr(9)||
       'CT_REFERENCE'||chr(9)||'LINE_NUM'||chr(9)||'ENROLLMENT_ID'||chr(9)||'LINE_AMOUNT'||chr(9)||'TAX_AMOUNT'||chr(9)||'TRX_DATE'||chr(9)||
       'AMOUNT_DUE_ORIGINAL'||chr(9)||'ORACLE_ACCOUNT_NUMBER'||chr(9)||'CUST_NAME'||chr(9)||'SLX_CONTACT_ID'||chr(9)||'SLX_CONTACT_NAME'||chr(9)||
       'SLX_PREPAY_ID'
  into v_hdr
  from dual;

v_file := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',v_file_name,'w');

utl_file.put_line(v_file,v_hdr);

for r0 in c0 loop
  utl_file.put_line(v_file,r0.v_line);
end loop;

utl_file.fclose(v_file);
commit;

sys.system_run('mv /mnt/nc10s141_ibm/ww/rss-ibm/Customer_Deposit_invoice.xls /mnt/nc10s038/PrepayReports/Customer_Deposit_invoice.xls');

-- Generate Customer Deposit Summary report
select 'Customer_Deposit_Summary.xls',
       '/mnt/nc10s141_ibm/ww/rss-ibm/Customer_Deposit_Summary.xls'
  into v_file_name_1,v_file_name_full_1
  from dual;

select 'CUST_NAME'||chr(9)||'DEP_NUMBER'||chr(9)||'DEP_DATE'||chr(9)||'DEP_AMOUNT'||chr(9)||'SLX_CONTACT_ID'||chr(9)||'SLX_CONTACT_NAME'||chr(9)||
       'AMT_USED'||chr(9)||'AMT_REMAINING'||chr(9)||'SLX_PREPAY_ID'||chr(9)||'PREPAY_TYPE'||chr(9)||'PREPAY_METHOD'
  into v_hdr_1
  from dual;

v_file_1 := utl_file.fopen('/mnt/nc10s141_ibm/ww/rss-ibm',v_file_name_1,'w');

utl_file.put_line(v_file_1,v_hdr_1);

for r1 in c1 loop
  utl_file.put_line(v_file_1,r1.v_line);
end loop;

utl_file.fclose(v_file_1);

sys.system_run('mv /mnt/nc10s141_ibm/ww/rss-ibm/Customer_Deposit_Summary.xls /mnt/nc10s038/PrepayReports/Customer_Deposit_Summary.xls');


exception
  when others then
    rollback;
    raise;
  --  send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','gk_cust_prepay_rpt FAILED',v_msg_body);

end;
/


