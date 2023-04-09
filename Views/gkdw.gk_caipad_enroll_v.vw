DROP VIEW GKDW.GK_CAIPAD_ENROLL_V;

/* Formatted on 29/01/2021 11:42:16 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CAIPAD_ENROLL_V
(
   ENROLL_ID,
   EMAIL,
   COUNTRY
)
AS
   SELECT   enroll_id, c.email, 'CA' country
     FROM      order_fact f
            INNER JOIN
               cust_dim c
            ON f.cust_id = c.cust_id
    WHERE       keycode = 'CAIPAD2012P'
            AND f.enroll_status != 'Cancelled'
            AND NOT EXISTS (SELECT   1
                              FROM   promo2012ca_orders_placed@mkt_catalog p
                             WHERE   f.enroll_id = TRIM (p."evxenrollid"))
            AND NOT EXISTS
                  (SELECT   1
                     FROM   gk_ipad_enroll e
                    WHERE   f.enroll_id = e.enroll_id AND e.country = 'CA');


