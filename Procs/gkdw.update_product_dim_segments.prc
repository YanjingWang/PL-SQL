DROP PROCEDURE GKDW.UPDATE_PRODUCT_DIM_SEGMENTS;

CREATE OR REPLACE PROCEDURE GKDW.Update_Product_Dim_Segments 
as

ch_desc VARCHAR2(240);
md_desc VARCHAR(240);
pl_desc VARCHAR(240);
        
cursor c1 is
select pd.product_id,  pd.prod_num, 'USA' country
       ,msi.INVENTORY_ITEM_ID
       ,gcc.segment2 || '.' || gcc.segment1 || '.' || gcc.segment3 || '.' || gcc.segment4 || '.' || gcc.segment5 Item_num
       ,gcc.segment1 le, gcc.segment2 fe 
       ,gcc.segment4 ch, gcc.segment5 md, gcc.segment6 pl
       ,gcc.segment7 act 
from product_dim pd 
join MTL_SYSTEM_ITEMS_B@r12prd msi on pd.prod_num = msi.ATTRIBUTE1 
     AND msi.organization_id = 88
     AND msi.invoiceable_item_flag = 'Y'
     AND msi.invoice_enabled_flag = 'Y'  
join gl_code_combinations@r12prd gcc on gcc.code_combination_id = msi.sales_account
where ((pd.CH_NUM is null or pd.PL_NUM is null or pd.MD_NUM is null)
and (gcc.segment1 is not null and gcc.segment2 is not null and gcc.segment3 is not null))
--or (pd.ORACLE_ITEM_ID is not null and  (pd.ORACLE_ITEM_ID <> msi.inventory_item_id))
or (pd.ch_NUM <> gcc.segment4 or pd.md_NUM <> gcc.segment5 or  pd.pl_NUM <> gcc.segment6);


begin

for r1 in c1 loop

    ch_desc := null;
    md_desc := null;
    pl_desc := null;
    
    GET_FLEX_VALUE(r1.INVENTORY_ITEM_ID, 1007697, r1.country, ch_desc);
    GET_FLEX_VALUE(r1.INVENTORY_ITEM_ID, 1007698, r1.country, md_desc);
    GET_FLEX_VALUE(r1.INVENTORY_ITEM_ID, 1007699, r1.country, pl_desc);
    
    update product_dim cd
    set ITEM_ID = r1.INVENTORY_ITEM_ID ,
           ORACLE_ITEM_NUM = r1.item_num,                                  
        le_num  = '210', --default to 210 
        fe_num  = r1.fe,
        ch_num  = r1.ch,
        md_num  = r1.md,
        pl_num  = r1.pl,
        act_num = r1.act,
        prod_channel = ch_desc, 
        prod_modality = md_desc,
        prod_line = pl_desc 
	where product_id = r1.product_id;
 
commit;

end loop;

	EXCEPTION
    		 WHEN OTHERS THEN
	RAISE ;

end;
/


