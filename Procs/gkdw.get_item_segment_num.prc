DROP PROCEDURE GKDW.GET_ITEM_SEGMENT_NUM;

CREATE OR REPLACE PROCEDURE GKDW.Get_Item_Segment_num(inventory_item_id_in number,
                   country_in varchar2,
              item_num_out out varchar2,
           le_num_out  out varchar2,
           fe_num_out  out varchar2,
           ch_num_out  out varchar2,
           md_num_out  out varchar2,
           pl_num_out  out varchar2,
           act_num_out out varchar2)
as
    item_num varchar2(50);
  le_num varchar2(3);
  fe_num varchar2(3);
  ch_num varchar2(2);
  md_num varchar2(2);
     pl_num varchar2(2);
     act_num varchar2(6);
  sql_stmt VARCHAR2(3000);
begin

 if (inventory_item_id_in is null )
 then
       item_num_out := null;
    return;
 end if;

 SELECT msi.segment2 || '.' || msi.segment1 || '.' || msi.segment3 || '.' || msi.segment4 || '.' || msi.segment5
 INTO item_num
 FROM mtl_system_items_b@r12prd msi
 WHERE msi.INVENTORY_ITEM_ID = inventory_item_id_in
 AND organization_id = 88 --decode(upper(country_in), 'CANADA', 103, 101)
    AND msi.invoiceable_item_flag = 'Y'
    AND invoice_enabled_flag = 'Y' ;



    SELECT  gcc.segment2, gcc.segment4 ch, gcc.segment5 md, gcc.segment6 pl, gcc.segment7 act
 INTO fe_num ,
  ch_num ,
  md_num ,
     pl_num ,
     act_num
 FROM mtl_system_items_b@r12prd msi,
    gl_code_combinations@r12prd gcc
 WHERE msi.INVENTORY_ITEM_ID = inventory_item_id_in
 AND organization_id = 88 -- decode(upper(country_in), 'CANADA', 103, 101)
 AND msi.invoiceable_item_flag = 'Y'
    AND invoice_enabled_flag = 'Y'
 AND gcc.code_combination_id = msi.sales_account ;

    -- DEfault LE to 220 for CAnADA and 210 for US
    select decode(upper(country_in), 'CANADA', '220', '210') into le_num from dual;

    item_num_out := item_num;
 le_num_out := le_num;
 fe_num_out := fe_num;
 ch_num_out := ch_num;
 md_num_out := md_num;
 pl_num_out := pl_num;
 act_num_out:= act_num;


    EXCEPTION
 WHEN NO_DATA_FOUND THEN
   item_num := null;
   le_num   := null;
   fe_num   := null;
   ch_num   := null;
   md_num   := null;
      pl_num   := null;
      act_num  := null;

    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
   RAISE ;
end;
/


