DROP PROCEDURE GKDW.UPDATE_COURSE_DIM_SEGMENTS;

CREATE OR REPLACE PROCEDURE GKDW.Update_Course_Dim_Segments 
as

ch_desc VARCHAR2(240);
md_desc VARCHAR(240);
pl_desc VARCHAR(240);
        
cursor c1 is
select cd.course_id,  cd.COURSE_CODE, cd.country 
       ,msi.INVENTORY_ITEM_ID
       ,gcc.segment2 || '.' || gcc.segment1 || '.' || gcc.segment3 || '.' || gcc.segment4 || '.' || gcc.segment5 Item_num
    --   ,gcc.segment1 le, 
       ,gcc.segment2 fe 
       ,gcc.segment4 ch, gcc.segment5 md, gcc.segment6 pl
       ,gcc.segment7 act 
from course_dim cd 
join MTL_SYSTEM_ITEMS_B@r12prd msi on cd.COURSE_CODE = msi.ATTRIBUTE1 
     AND msi.organization_id = 88
     AND msi.invoiceable_item_flag = 'Y' 
    AND invoice_enabled_flag = 'Y' 
join gl_code_combinations@r12prd gcc on gcc.code_combination_id = msi.sales_account
where cd.GKDW_SOURCE <> 'SYSX' 
and (
       ((
        (cd.CH_NUM is null or cd.PL_NUM is null or cd.MD_NUM is null)
            or   (cd.COURSE_CH is null or cd.COURSE_PL is null or cd.COURSE_MOD is null)
        )
        and (gcc.segment1 is not null and gcc.segment2 is not null and gcc.segment3 is not null)
        )
    or (cd.ORACLE_ITEM_ID is not null and  (cd.ORACLE_ITEM_ID <> msi.inventory_item_id))
    or (cd.ch_NUM <> gcc.segment4 or cd.md_NUM <> gcc.segment5 or  cd.pl_NUM <> gcc.segment6)
    );

begin

for r1 in c1 loop
--DBMS_OUTPUT.PUT_LINE(r1.course_id || ' ' || r1.country || r1.le ) ;
    ch_desc := null;
    md_desc := null;
    pl_desc := null;
    
    GET_FLEX_VALUE(r1.INVENTORY_ITEM_ID, 1007697, r1.country, ch_desc);
    GET_FLEX_VALUE(r1.INVENTORY_ITEM_ID, 1007698, r1.country, md_desc);
    GET_FLEX_VALUE(r1.INVENTORY_ITEM_ID, 1007699, r1.country, pl_desc);
    
--DBMS_OUTPUT.PUT_LINE(ch_desc || ' ' || md_desc|| ' ' || pl_desc ) ;

    update course_dim cd
    set ORACLE_ITEM_ID = r1.INVENTORY_ITEM_ID ,
           ORACLE_ITEM_NUM = r1.item_num,                                  
        le_num  = decode(upper(r1.country), 'CANADA', '220', '210'),
        fe_num  = r1.fe,
        ch_num  = r1.ch,
        md_num  = r1.md,
        pl_num  = r1.pl,
        act_num = r1.act,
        COURSE_CH  = ch_desc, 
        COURSE_MOD = md_desc,
        COURSE_PL  = pl_desc 
    where cd.course_id = r1.course_id
    and cd.country = r1.country;
 
commit;

end loop;

	EXCEPTION
    		 WHEN OTHERS THEN
	RAISE ;

end;
/


