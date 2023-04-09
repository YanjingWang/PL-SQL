DROP PROCEDURE GKDW.GK_MANUAL_RECEIVE_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_manual_receive_po_proc as

cursor c1 is
select h.segment1,l.line_num,'R12PRD' db_sid,
       sum(d.quantity_ordered) quantity,
       sum(d.quantity_delivered) qty_deliv
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
 where h.segment1 in ('878877','880002','880588','880723','884619','884742','886354')
   and l.closed_date is null
 group by h.segment1,l.line_num
 having sum(d.quantity_ordered) > sum(d.quantity_delivered)
 order by 1,2;


begin

for r1 in c1 loop
  gk_receive_po_line_proc(r1.segment1,r1.line_num,r1.db_sid);
end loop;
commit;

gk_receive_request_proc('R12PRD');

end;
/


