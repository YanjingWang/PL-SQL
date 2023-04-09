DROP VIEW GKDW.GK_REP_LEAD_TOTAL_V;

/* Formatted on 29/01/2021 11:27:56 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REP_LEAD_TOTAL_V
(
   SALESREP,
   REP_LEAD_TOTAL
)
AS
     SELECT   salesrep, SUM (lead_cnt) rep_lead_total
       FROM   gk_territory_zip_mv
   GROUP BY   salesrep;


