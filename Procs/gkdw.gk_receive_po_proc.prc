DROP PROCEDURE GKDW.GK_RECEIVE_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_receive_po_proc(p_po_num varchar2,v_sid varchar2 default 'R12PRD') is

cursor c4(p_sid varchar2,v_po_num varchar2) is
select distinct h.segment1,h.po_header_id,l.po_line_id,h.vendor_id,h.vendor_site_id,
       d.deliver_to_person_id,trunc(sysdate) ship_date,d.destination_organization_id,l.category_id,
       l.line_num,l.item_description,l.quantity,trunc(sysdate) deliv_date,
       l.quantity qty_deliv,
       l.unit_meas_lookup_code,u.uom_code
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
 where h.segment1 = v_po_num
   and l.closed_date is null
   and p_sid = 'R12PRD';

v_rcv_header number;
v_rcv_interface number;
v_rcv_transaction number;

begin

for r4 in c4(v_sid,p_po_num) loop
  select gk_rcv_header_val_func@r12prd,gk_rcv_interface_val_func@r12prd,gk_rcv_transactions_val_func@r12prd
    into v_rcv_header,v_rcv_interface,v_rcv_transaction
    from dual;

  insert into rcv_headers_interface@r12prd
    (header_interface_id,group_id,processing_status_code,receipt_source_code,transaction_type,
     auto_transact_code,last_update_date,last_updated_by,last_update_login,creation_date,
     created_by,vendor_id,vendor_site_id,validation_flag,employee_id,shipped_date,ship_to_organization_id,
     expected_receipt_date
    )
    select v_rcv_header,v_rcv_interface,
           'PENDING','VENDOR','NEW','DELIVER',sysdate,0,0,sysdate,0,r4.vendor_id,
           r4.vendor_site_id,'Y',r4.deliver_to_person_id,r4.ship_date,
           r4.destination_organization_id,trunc(sysdate)
      from dual;

  insert into rcv_transactions_interface@r12prd
    (interface_transaction_id,header_interface_id,group_id,last_update_date,last_updated_by,
     creation_date,created_by,transaction_type,transaction_date,processing_status_code,processing_mode_code,
     transaction_status_code,quantity,unit_of_measure,receipt_source_code,vendor_id,vendor_site_id,
     validation_flag,uom_code,auto_transact_code,document_num,source_document_code,po_line_id,category_id,
     primary_unit_of_measure,employee_id
    )
    select v_rcv_transaction,v_rcv_header,v_rcv_interface,
           sysdate,0,sysdate,0,'RECEIVE',trunc(sysdate),'PENDING','BATCH','PENDING',r4.qty_deliv,
           r4.unit_meas_lookup_code,'VENDOR',r4.vendor_id,r4.vendor_site_id,'Y',r4.uom_code,
           'DELIVER',r4.segment1,'PO',r4.po_line_id,r4.category_id,r4.unit_meas_lookup_code,
           r4.deliver_to_person_id
      from dual;

  commit;
end loop;

end;
/


