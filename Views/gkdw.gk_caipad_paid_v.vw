DROP VIEW GKDW.GK_CAIPAD_PAID_V;

/* Formatted on 29/01/2021 11:42:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CAIPAD_PAID_V
(
   ENROLL_ID,
   MODIFYDATE,
   COUNTRY
)
AS
   SELECT   f.enroll_id, b.modifydate, 'CA' country
     FROM            order_fact f
                  INNER JOIN
                     cust_dim c
                  ON f.cust_id = c.cust_id
               INNER JOIN
                  slxdw.qg_billingpayment b
               ON f.enroll_id = b.evxevenrollid
            INNER JOIN
               promo2012ca_orders_placed@mkt_catalog p
            ON f.enroll_id = TRIM (p."evxenrollid")
    WHERE       keycode = 'CAIPAD2012P'
            AND b.oraclestatus = 'Paid'
            AND NOT EXISTS (SELECT   1
                              FROM   promo2012ca_orders_paid@mkt_catalog o
                             WHERE   f.enroll_id = TRIM (o."evxenrollid"))
   UNION
   SELECT   f.enroll_id, f.book_date, 'CA'
     FROM   order_fact f
    WHERE       keycode = 'CAIPAD2012P'
            AND payment_method IN ('Cisco Learning Credits', 'Credit Card')
            AND NOT EXISTS (SELECT   1
                              FROM   promo2012ca_orders_paid@mkt_catalog o
                             WHERE   f.enroll_id = TRIM (o."evxenrollid"));


