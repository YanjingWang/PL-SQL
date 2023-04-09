DROP PROCEDURE GKDW.GET_FLEX_VALUE;

CREATE OR REPLACE PROCEDURE GKDW.Get_Flex_Value(inventory_item_id_in        number,
                                                  flex_value_set_id_in     number,
                                           country_in                varchar2,                               
                                           flex_description_out out varchar2 )
as
        fvt_description VARCHAR2(240);
        org_id1  number;
        org_id2  number;
        sql_stmt VARCHAR2(3000);
begin

     if (inventory_item_id_in is null or flex_value_set_id_in is null) 
     then
             flex_description_out := null;
          return;
    end if;     
     /*
    case
    when upper(country_in) = 'CANADA'
    then org_id1 := 103 ; org_id2 := 104 ;
    else org_id1 := 101; org_id2 := 102;
    end case ;
       */  
     case  flex_value_set_id_in
     when 1007697 then  -- Channel, GCC - Segment4 
     sql_stmt := 'SELECT fvt.description '
             || ' FROM mtl_system_items_b@r12prd msi, '
             || ' gl_code_combinations@r12prd gcc, '
             || ' fnd_flex_values@r12prd fv, fnd_flex_values_tl@r12prd fvt ' 
             || ' WHERE msi.INVENTORY_ITEM_ID = ' || inventory_item_id_in
              || ' AND msi.organization_id = 88'
             || ' AND msi.invoiceable_item_flag = ''Y'' ' 
             || ' AND msi.invoice_enabled_flag = ''Y'' ' 
                || ' AND gcc.code_combination_id = msi.sales_account'
             || ' AND gcc.segment4 = fv.flex_value '
             || ' AND fv.flex_value_id = fvt.flex_value_id ' 
             || ' AND fv.flex_value_set_id = ' ||  flex_value_set_id_in ;
     when 1007698 then -- Prod line, GCC.Segment5 
          sql_stmt := 'SELECT fvt.description '
             || ' FROM mtl_system_items_b@r12prd msi, '
             || ' gl_code_combinations@r12prd gcc, '
             || ' fnd_flex_values@r12prd fv, fnd_flex_values_tl@r12prd fvt ' 
             || ' WHERE msi.INVENTORY_ITEM_ID = ' || inventory_item_id_in
             || ' AND msi.organization_id = 88'
             || ' AND msi.invoiceable_item_flag = ''Y'' ' 
             || ' AND msi.invoice_enabled_flag = ''Y'' ' 
                || ' AND gcc.code_combination_id = msi.sales_account'
             || ' AND gcc.segment5 = fv.flex_value '
             || ' AND fv.flex_value_id = fvt.flex_value_id ' 
             || ' AND fv.flex_value_set_id = ' ||  flex_value_set_id_in ;
     when 1007699 then -- Modality, GCC Segment6 
          sql_stmt := 'SELECT fvt.description '
             || ' FROM mtl_system_items_b@r12prd msi, '
             || ' gl_code_combinations@r12prd gcc, '
             || ' fnd_flex_values@r12prd fv, fnd_flex_values_tl@r12prd fvt ' 
             || ' WHERE msi.INVENTORY_ITEM_ID = ' || inventory_item_id_in
             || ' AND msi.organization_id = 88'
             || ' AND msi.invoiceable_item_flag = ''Y'' ' 
             || ' AND msi.invoice_enabled_flag = ''Y'' ' 
                || ' AND gcc.code_combination_id = msi.sales_account'
             || ' AND gcc.segment6 = fv.flex_value '
             || ' AND fv.flex_value_id = fvt.flex_value_id ' 
             || ' AND fv.flex_value_set_id = ' ||  flex_value_set_id_in ; 
     else 
     begin
           flex_description_out := null;
         return ;
     end;
     end case;
 
--    DBMS_OUTPUT.PUT_LINE(org_id); 
                  
    EXECUTE IMMEDIATE sql_stmt into fvt_description;
  
    flex_description_out := fvt_description;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         fvt_description := null;
         
    WHEN OTHERS THEN
      -- Consider logging the error and then re-raise
      RAISE ;
end;
/


