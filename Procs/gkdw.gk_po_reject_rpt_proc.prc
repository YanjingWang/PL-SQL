DROP PROCEDURE GKDW.GK_PO_REJECT_RPT_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_po_Reject_rpt_proc as
   --=======================================================================
   -- Author Name:Sruthi Reddy
   -- Create date
   -- Description: This report gives a list of PO failed in the past 1 week
   -- every week.
   --=======================================================================
   -- Change History
   --=======================================================================
   -- Version   Date        Author             Description
   --  1.0      08/29/2018  Sruthi Reddy      Intital Version 
   --========================================================================
cursor c1 is
select distinct h.interface_header_id,h.process_code,h.org_id,h.document_num,h.currency_code,h.vendor_id,p.vendor_name,
h.vendor_site_code,l.interface_line_id,l.line_num,l.item_description,l.quantity,
error_message,Processing_date,e.column_name,e.token2_value
from po_headers_interface@r12prd h
inner join po_lines_interface@r12prd l on l.interface_header_id = h.interface_header_id
inner join po_interface_errors@r12prd e on h.interface_header_id = e.interface_header_id
inner join po_vendors@r12prd p on h.vendor_id = p.vendor_id
inner join time_dim td on trunc(e.processing_date) = td.dim_date
inner join time_dim td2 on td2.dim_date = trunc(sysdate)
where h.process_code = 'REJECTED'
and td.dim_week = td2.dim_week -1
order by h.document_num;


v_file_name varchar2(50);
v_file_name_full varchar2(250);
v_hdr varchar2(1000);
v_file utl_file.file_type;


begin


  select 'AUTO_PO_REJECT_REPORT_'||to_char(sysdate,'yyyy-mm-dd')||'.xls',
         '/usr/tmp/AUTO_PO_REJECT_REPORT_'||to_char(sysdate,'yyyy-mm-dd')||'.xls'
    into v_file_name,v_file_name_full
    from dual;

  select 'Interface Header ID'||chr(9)||'Process Code'||chr(9)||'Org ID'||chr(9)||'PO Num'||chr(9)||'Currency Code'||chr(9)||'Vendor ID'||chr(9)||'Vendor Name'||chr(9)||
         'Vendor Site Code'||chr(9)||'Interface Line ID'||chr(9)||'Item Description'||chr(9)||'Quantity'||chr(9)||'Error Message'||chr(9)||'Processing Code'
         ||chr(9)||'Error Column'||chr(9)||'Error Column Value'
    into v_hdr
    from dual;

  v_file := utl_file.fopen('/usr/tmp',v_file_name,'w');
    utl_file.put_line(v_file,v_hdr);

  for r1 in c1 loop 
  utl_file.put_line(v_file,r1.interface_header_id||chr(9)||r1.process_code||chr(9)||r1.org_id||chr(9)||r1.document_num||chr(9)||r1.currency_code||chr(9)||r1.vendor_id||chr(9)||r1.vendor_name||chr(9)||
    r1.vendor_site_code||chr(9)||r1.interface_line_id||chr(9)||r1.item_description||chr(9)||r1.quantity||chr(9)||
    r1.error_message||chr(9)||r1.Processing_date||chr(9)||r1.column_name||chr(9)||r1.token2_value );
  end loop;
  utl_file.fclose(v_file);

  send_mail_attach('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','','','Weekly Auto PO Reject Report','Open Excel Attachment.',v_file_name_full);   
  send_mail_attach('DW.Automation@globalknowledge.com','Tait.Hilliard@globalknowledge.com','','','Weekly Auto PO Reject Report','Open Excel Attachment.',v_file_name_full); 
   

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_PO_REJECT_RPT_PROC failed',SQLERRM);

end;
/


