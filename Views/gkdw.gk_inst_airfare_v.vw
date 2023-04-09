DROP VIEW GKDW.GK_INST_AIRFARE_V;

/* Formatted on 29/01/2021 11:34:13 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_AIRFARE_V
(
   METROAREA,
   EVENT_CNT,
   TOTAL_AIRFARE,
   AVG_AIRFARE
)
AS
     SELECT   metroarea,
              COUNT ( * ) event_cnt,
              SUM(  NVL (air_cost1, 0)
                  + NVL (air_cost2, 0)
                  + NVL (air_cost3, 0)
                  + NVL (air_cost4, 0)
                  + NVL (air_cost5, 0))
                 total_airfare,
              ROUND(SUM(  NVL (air_cost1, 0)
                        + NVL (air_cost2, 0)
                        + NVL (air_cost3, 0)
                        + NVL (air_cost4, 0)
                        + NVL (air_cost5, 0))
                    / COUNT ( * ))
                 avg_airfare
       FROM   inst_travel@gkprod
      WHERE     NVL (air_cost1, 0)
              + NVL (air_cost2, 0)
              + NVL (air_cost3, 0)
              + NVL (air_cost4, 0)
              + NVL (air_cost5, 0) > 0
              AND create_date >= TRUNC (SYSDATE) - 365
   GROUP BY   metroarea;


