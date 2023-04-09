DROP VIEW GKDW.GK_REP_LEAD_RATIO_V;

/* Formatted on 29/01/2021 11:28:01 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REP_LEAD_RATIO_V
(
   SALESREP,
   ZIP_CODE,
   REGION,
   REGION_MGR,
   LEAD_CNT,
   REP_LEAD_TOTAL,
   LEAD_RATIO
)
AS
     SELECT   lt.salesrep,
              zip_code,
              region,
              region_mgr,
              lead_cnt,
              rep_lead_total,
              lead_cnt / rep_lead_total lead_ratio
       FROM      gk_territory_zip_mv z
              INNER JOIN
                 gk_rep_lead_total_v lt
              ON z.salesrep = lt.salesrep
      WHERE   z.terr_id BETWEEN '01' AND '99'
   ORDER BY   1;


