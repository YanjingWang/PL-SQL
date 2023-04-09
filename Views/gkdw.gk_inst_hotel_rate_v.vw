DROP VIEW GKDW.GK_INST_HOTEL_RATE_V;

/* Formatted on 29/01/2021 11:33:53 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_HOTEL_RATE_V
(
   METROAREA,
   HOTEL_DAYS,
   TOTAL_HOTEL,
   AVG_HOTEL_DAY
)
AS
     SELECT   metroarea,
              SUM (ed.end_date - ed.start_date + 1) hotel_days,
              SUM(  NVL (hotel_total1, 0)
                  + NVL (hotel_total2, 0)
                  + NVL (hotel_total3, 0))
                 total_hotel,
              ROUND(SUM(  NVL (hotel_total1, 0)
                        + NVL (hotel_total2, 0)
                        + NVL (hotel_total3, 0))
                    / SUM (ed.end_date - ed.start_date + 1))
                 avg_hotel_day
       FROM      inst_travel@gkprod t
              INNER JOIN
                 event_dim ed
              ON t.evxeventid = ed.event_id
      WHERE     NVL (hotel_total1, 0)
              + NVL (hotel_total2, 0)
              + NVL (hotel_total3, 0) > 0
              AND create_date >= TRUNC (SYSDATE) - 365
   GROUP BY   metroarea;


