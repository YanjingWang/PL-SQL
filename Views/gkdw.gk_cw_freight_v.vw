DROP VIEW GKDW.GK_CW_FREIGHT_V;

/* Formatted on 29/01/2021 11:38:33 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CW_FREIGHT_V
(
   ADDRESS1,
   CITY,
   STATE,
   TOTAL_QTY,
   TOTAL_FREIGHT,
   FREIGHT_QTY
)
AS
     SELECT   address1,
              city,
              state,
              SUM (
                 CASE WHEN part_num = 'GK201-1' THEN 0 ELSE TO_NUMBER (qty) END
              )
                 total_qty,
              SUM (freight_cost) total_freight,
              CASE
                 WHEN SUM (CASE WHEN part_num = 'GK201-1' THEN 0 ELSE qty END) =
                         0
                 THEN
                    0
                 ELSE
                    SUM (freight_cost)
                    / SUM (CASE WHEN part_num = 'GK201-1' THEN 0 ELSE qty END)
              END
                 freight_qty
       FROM   gk_courseware_tax_out l
      WHERE   UPPER (part_num) NOT LIKE 'DUTY%BROKERAGE'
              AND UPPER (part_num) NOT LIKE 'ORDER%MANAGE%'
   GROUP BY   address1, city, state
--select address1,city,state,
--       sum(case when part_id = 'GK201-1' then 0 else qty end) total_qty,
--       sum(freight_cost) total_freight,
--       case when sum(case when part_id = 'GK201-1' then 0 else qty end)= 0 then 0
--            else sum(freight_cost)/sum(case when part_id = 'GK201-1' then 0 else qty end)
--       end freight_qty
-- from gk_gilmore_tax_load
-- where upper(part_id) not like 'DUTY%BROKERAGE'
--   and upper(part_id) not like 'ORDER%MANAGE%'
--group by address1,city,state;


