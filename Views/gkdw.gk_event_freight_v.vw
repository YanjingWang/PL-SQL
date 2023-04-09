DROP VIEW GKDW.GK_EVENT_FREIGHT_V;

/* Formatted on 29/01/2021 11:37:04 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_FREIGHT_V
(
   FACILITYREGIONMETRO,
   COURSECODE,
   EVENT_CNT,
   FREIGHT_TOTAL,
   FREIGHT_AVG
)
AS
     SELECT   facilityregionmetro,
              coursecode,
              COUNT (evxeventid) event_cnt,
              ROUND (SUM (pl.unit_price * pl.quantity), 2) freight_total,
              ROUND (SUM (pl.unit_price * pl.quantity) / COUNT (evxeventid), 2)
                 freight_avg
       FROM               gilmore.freight_order@gkprod f
                       INNER JOIN
                          event@gkprod e
                       ON f.de_sess = e.evxeventid
                    INNER JOIN
                       gilmore.freight_po@gkprod fp
                    ON f.fr_order_num = fp.fr_order_num
                 INNER JOIN
                    po_headers_all@r12prd ph
                 ON fp.po_num = ph.segment1
              INNER JOIN
                 po_lines_all@r12prd pl
              ON ph.po_header_id = pl.po_header_id
      WHERE   e.startdate >= TRUNC (SYSDATE) - 365
   GROUP BY   facilityregionmetro, coursecode;


