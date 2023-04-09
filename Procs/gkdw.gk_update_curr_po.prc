DROP PROCEDURE GKDW.GK_UPDATE_CURR_PO;

CREATE OR REPLACE PROCEDURE GKDW.gk_update_curr_po(p_org_id number,p_sid varchar2) as

begin
--if p_sid = 'R12PRD' then
  update po_unique_identifier_cont_all@r12prd
     set current_max_unique_identifier = current_max_unique_identifier + 1
   where table_name = 'PO_HEADERS'
     and org_id = p_org_id;
--else
--  update po_unique_identifier_cont_all@r12dev
--     set current_max_unique_identifier = current_max_unique_identifier + 1
--   where table_name = 'PO_HEADERS'
--     and org_id = p_org_id;
--end if;

end;
/


