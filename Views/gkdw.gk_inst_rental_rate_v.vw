DROP VIEW GKDW.GK_INST_RENTAL_RATE_V;

/* Formatted on 29/01/2021 11:33:49 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_RENTAL_RATE_V
(
   METROAREA,
   TOTAL_RENTAL_RAYS,
   TOTAL_RENTAL,
   AVG_RENTAL
)
AS
     SELECT   metroarea,
              SUM (ed.end_date - ed.start_date + 1) total_rental_rays,
              SUM (NVL (rental_total1, 0) + NVL (rental_total2, 0))
                 total_rental,
              ROUND(SUM (NVL (rental_total1, 0) + NVL (rental_total2, 0))
                    / SUM (ed.end_date - ed.start_date + 1))
                 avg_rental
       FROM      inst_travel@gkprod t
              INNER JOIN
                 event_dim ed
              ON t.evxeventid = ed.event_id
      WHERE   NVL (rental_total1, 0) + NVL (rental_total2, 0) > 0
              AND create_date >= TRUNC (SYSDATE) - 365
   GROUP BY   metroarea;


