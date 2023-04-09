DROP VIEW GKDW.GK_STUDENT_CW_SHIPPING_V;

/* Formatted on 29/01/2021 11:25:44 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_STUDENT_CW_SHIPPING_V
(
   FACILITYREGIONMETRO,
   COURSECODE,
   TOTAL_SHIPPED,
   TOTAL_SHIPPING,
   AVG_SHIPPING
)
AS
     SELECT   e.facilityregionmetro,
              e.coursecode,
              SUM (ft.qty_shipped) total_shipped,
              SUM (ft.ship_cost) total_shipping,
              ROUND (SUM (ft.ship_cost) / SUM (ft.qty_shipped), 2) avg_shipping
       FROM         cw_fulfillment@gkprod cf
                 INNER JOIN
                    cw_fulfillment_tracking@gkprod ft
                 ON cf.gk_ref_num = ft.gk_ref_num
                    AND cf.part_number = ft.part_number
              INNER JOIN
                 event@gkprod e
              ON cf.event_id = e.evxeventid
      WHERE   ship_cost > 0 AND ft.ship_date >= TRUNC (SYSDATE) - 365
   GROUP BY   e.facilityregionmetro, e.coursecode;


