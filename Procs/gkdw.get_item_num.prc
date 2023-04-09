DROP PROCEDURE GKDW.GET_ITEM_NUM;

CREATE OR REPLACE PROCEDURE GKDW.Get_Item_num(inventory_item_id_in number,
                         country_in varchar2,
              item_num_out out varchar2 )
as
    item_num varchar2(50);
  sql_stmt VARCHAR2(3000);
begin

 if (inventory_item_id_in is null )
 then
       item_num_out := null;
    return;
 end if;

 SELECT gcc.segment2 || '.' || gcc.segment1 || '.' || gcc.segment3 || '.' || gcc.segment4 || '.' || gcc.segment5
 INTO item_num
 FROM mtl_system_items_b@r12prd msi,
    gl_code_combinations@r12prd gcc
 WHERE msi.INVENTORY_ITEM_ID = inventory_item_id_in
 AND organization_id = 88
 AND invoiceable_item_flag = 'Y'
 AND gcc.code_combination_id = msi.sales_account ;

    item_num_out := item_num;

    EXCEPTION
 WHEN NO_DATA_FOUND THEN
   item_num := null;

    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
   RAISE ;
end;
/


