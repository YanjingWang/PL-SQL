DROP VIEW GKDW.GK_TERR_LEAD_TOTAL_V;

/* Formatted on 29/01/2021 11:25:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TERR_LEAD_TOTAL_V
(
   TERR_ID,
   TERR_LEAD_TOTAL
)
AS
     SELECT   terr_id, SUM (lead_cnt) terr_lead_total
       FROM   gk_territory_zip_mv
   GROUP BY   terr_id;


