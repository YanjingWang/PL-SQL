DROP PROCEDURE GKDW.GK_AUTO_RECEIVING_PROC;

CREATE OR REPLACE PROCEDURE GKDW.GK_AUTO_RECEIVING_PROC
as
cursor c0 is
 select distinct  c.po_num,c.line_num from po_headers_all@r12prd h 
 inner join gk_auto_po_rcv_stg c on h.segment1 = c.po_num 
  inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
inner join RCV_TRANSACTIONS@r12prd r on h.po_header_id  = r.po_header_id and c.line_num = l.line_num
where po_received = 'N'; --and h.segment1 = '1013108'

cursor c1 is
select distinct h.segment1 curr_po,'R12PRD' db_sid,r.line_num,--d.quantity_ordered,d.quantity_delivered,
       sum(d.quantity_ordered) quantity,
       sum(d.quantity_delivered) qty_deliv
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
       inner join gk_auto_po_rcv_stg r on h.segment1 = r.po_num and r.line_num = l.line_num
 where --mp.db_sid in ('R12PRD','PRD')
   r.po_received = 'N'
    and not exists (select 1 from rcv_transactions@r12prd rt where rt.po_header_id = h.po_header_id and rt.po_line_id = l.po_line_id)
 --  and l.closed_date is null
 group by h.segment1,r.line_num
 having sum(d.quantity_ordered) > sum(d.quantity_delivered);
 
cursor c4(p_sid varchar2,v_po_num varchar2,v_line_num varchar2) is
select distinct h.segment1,h.po_header_id,l.po_line_id,h.vendor_id,h.vendor_site_id,
       d.deliver_to_person_id,trunc(sysdate) ship_date,d.destination_organization_id,l.category_id,
       l.line_num,l.item_description,l.quantity,trunc(sysdate) deliv_date,
       l.quantity qty_deliv,
       l.unit_meas_lookup_code,u.uom_code
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
       inner join gk_auto_po_rcv_stg r on h.segment1 = r.po_num and r.line_num = l.line_num
 where h.segment1 = v_po_num
 and l.line_num = v_line_num
   and l.closed_date is null
   and not exists (select 1 from rcv_transactions@r12prd rt where rt.po_header_id = h.po_header_id and rt.po_line_id = l.po_line_id)
   and p_sid = 'R12PRD';

--v_sid varchar2(10);
--p_po_num varchar2(20);
--p_line_num number;
v_rcv_header number;
v_rcv_interface number;
v_rcv_transaction number;
lb_file_exist      BOOLEAN; --1.0
ln_size            NUMBER;  --1.0
ln_block_size      NUMBER;  --1.0
 
begin
dbms_output.put_line('Test0'); 
sys.UTL_FILE.fgetattr ('GDW_INTERFACE',              -- 1.0
                          'GK_AUTO_RECEIVE_LOAD.csv',
                          lb_file_exist,
                          ln_size,
                          ln_block_size);
                          
                         

IF lb_file_exist THEN    
dbms_output.put_line('Test1');               -- 1.0
insert into gk_auto_po_rcv_stg c
select po_num,app_name,po_receive,line_num,item_description,sysdate from GK_AUTO_RECEIVE_LOAD l where l.PO_receive = 'N'
and not exists (select 1 from gk_auto_po_rcv_stg r where r.po_num = l.po_num and r.line_num = l.line_num);
commit;

sys.system_run ('mv /mnt/nc10s038/GDW_Interface/GK_AUTO_RECEIVE_LOAD.csv /mnt/nc10s038/GDW_Interface/GDW_Interface_Archive');
else null;
dbms_output.put_line('File does not exists');
end if;                         
                          
for r0 in c0 loop
update gk_auto_po_rcv_stg
set po_received = 'Y'
where po_num = r0.po_num
and line_num = r0.line_num
and po_received = 'N';
end loop;
commit;

--DBMS_OUTPUT.PUT_LINE('Test0');
for r1 in c1 loop
--DBMS_OUTPUT.PUT_LINE('Test1');
  if r1.quantity > r1.qty_deliv then
--  DBMS_OUTPUT.PUT_LINE('Test2');

    for r4 in c4(r1.db_sid,r1.curr_po,r1.line_num) loop
  --  DBMS_OUTPUT.PUT_LINE('Test3');
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
dbms_output.put_line(v_rcv_transaction);
  commit;
    
    end loop;
--DBMS_OUTPUT.PUT_LINE('Test4');
  end if;

end loop;
--DBMS_OUTPUT.PUT_LINE('Test5');
gk_receive_request_proc('R12PRD');

exception
  when others then
    send_mail('DW.Automation@globalknowledge.com','DW.Automation@globalknowledge.com','GK_AUTO_RECEIVING_PROC FAILED',SQLERRM);
end;
/


