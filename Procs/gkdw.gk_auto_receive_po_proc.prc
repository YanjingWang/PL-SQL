DROP PROCEDURE GKDW.GK_AUTO_RECEIVE_PO_PROC;

CREATE OR REPLACE PROCEDURE GKDW.gk_auto_receive_po_proc as

cursor c1 is
select h.segment1 curr_po,mp.db_sid,
       sum(d.quantity_ordered) quantity,
       sum(d.quantity_delivered) qty_deliv
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
       inner join gk_autoreceive_pos mp on h.segment1 = mp.po_num
 where mp.db_sid in ('R12PRD','PRD')
   and mp.po_received = 'N'
--   and h.closed_date is null
 group by h.segment1,mp.db_sid
 having sum(d.quantity_ordered) > sum(d.quantity_delivered)
union
select h.segment1,'R12PRD',
       sum(d.quantity_ordered) quantity,
       sum(d.quantity_delivered) qty_deliv
  from po_headers_all@r12prd h
       inner join po_lines_all@r12prd l on h.po_header_id = l.po_header_id
       inner join po_distributions_all@r12prd d on l.po_line_id = d.po_line_id
       inner join mtl_units_of_measure@r12prd u on l.unit_meas_lookup_code = u.unit_of_measure
       inner join gk_sec_plus_user_info mp on h.segment1 = mp.po_num
-- where h.closed_date is null
 group by h.segment1
 having sum(d.quantity_ordered) > sum(d.quantity_delivered)
 order by 2,1;

v_sid_prd varchar2(1) := 'N';

begin

for r1 in c1 loop
  if r1.quantity > r1.qty_deliv then
    gk_receive_po_proc(r1.curr_po,r1.db_sid);
  else
    update gk_autoreceive_pos
       set po_received = 'Y'
     where po_num = r1.curr_po
       and db_sid = r1.db_sid;
  end if;
end loop;

gk_receive_request_proc('R12PRD');

end;
/


