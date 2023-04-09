DROP PROCEDURE GKDW.GET_ORACLE_ITEM_ID;

CREATE OR REPLACE PROCEDURE GKDW.Get_Oracle_Item_Id(course_code_in varchar2,
                                                            country_in varchar2,                                                                     
                                       inventory_item_id_out out number )
as
          inventory_item_id number;                                                                        
begin

    if (course_code_in is null ) 
    then
             inventory_item_id_out := null;
          return;
    end if;     
     
    SELECT msi.INVENTORY_ITEM_ID
    INTO inventory_item_id
    FROM mtl_system_items_b@r12prd msi
    WHERE msi.attribute1 = course_code_in
    AND organization_id = 88 -- decode(upper(country_in), 'CANADA', 103, 101)
    AND invoiceable_item_flag = 'Y' 
    AND invoice_enabled_flag = 'Y';
 
    inventory_item_id_out := inventory_item_id;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         inventory_item_id := null;
         
    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
      RAISE ;
end;
/


