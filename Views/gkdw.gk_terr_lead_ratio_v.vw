DROP VIEW GKDW.GK_TERR_LEAD_RATIO_V;

/* Formatted on 29/01/2021 11:25:13 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TERR_LEAD_RATIO_V
(
   TERR_ID,
   SALESREP,
   ZIP_CODE,
   REGION,
   REGION_MGR,
   LEAD_CNT,
   TERR_LEAD_TOTAL,
   LEAD_RATIO
)
AS
     SELECT   z.terr_id,
              salesrep,
              zip_code,
              region,
              region_mgr,
              lead_cnt,
              terr_lead_total,
              lead_cnt / terr_lead_total lead_ratio
       FROM      gk_territory_zip_mv z
              INNER JOIN
                 gk_terr_lead_total_v lt
              ON z.terr_id = lt.terr_id
      WHERE   z.terr_id BETWEEN '01' AND '99'
   ORDER BY   1;


