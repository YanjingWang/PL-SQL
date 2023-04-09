DROP PROCEDURE GKDW.GK_PROMO_RECEIVE_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_promo_receive_po_proc as

cursor c1 is
select h.segment1,l.line_num,'R12PRD' db_sid,
       sum(d.quantity_ordered) quantity,
       sum(d.quantity_delivered) qty_deliv
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
       inner join gk_promo_fulfilled_orders pf on h.segment1 = pf.po_num and l.line_num = pf.po_line_num
 where pf.tracking_num is not null
   and l.closed_date is null
   and h.segment1 != '258384'
 group by h.segment1,l.line_num
 having sum(d.quantity_ordered) > sum(d.quantity_delivered)
 order by 1,2;

begin

for r1 in c1 loop
  gk_receive_po_line_proc(r1.segment1,r1.line_num,r1.db_sid);

  update gk_promo_fulfilled_orders
     set receive_date = sysdate
   where po_num = r1.segment1
     and po_line_num = r1.line_num;
end loop;
commit;

--gk_receive_request_proc('R12PRD');

end;
/


