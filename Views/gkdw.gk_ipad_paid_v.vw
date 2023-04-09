DROP VIEW GKDW.GK_IPAD_PAID_V;

/* Formatted on 29/01/2021 11:33:33 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IPAD_PAID_V
(
   ENROLL_ID,
   MODIFYDATE,
   COUNTRY
)
AS
   SELECT   f.enroll_id, b.modifydate, 'USA' country
     FROM            order_fact f
                  INNER JOIN
                     cust_dim c
                  ON f.cust_id = c.cust_id
               INNER JOIN
                  slxdw.qg_billingpayment b
               ON f.enroll_id = b.evxevenrollid
            INNER JOIN
               promo2012_orders_placed@mkt_catalog p
            ON f.enroll_id = TRIM (p."evxenrollid")
    WHERE       keycode = 'IPAD2012P'
            AND b.oraclestatus = 'Paid'
            AND NOT EXISTS (SELECT   1
                              FROM   promo2012_orders_paid@mkt_catalog o
                             WHERE   f.enroll_id = TRIM (o."evxenrollid"))
   UNION
   SELECT   f.enroll_id, f.book_date, 'USA'
     FROM   order_fact f
    WHERE       keycode = 'IPAD2012P'
            AND payment_method IN ('Cisco Learning Credits', 'Credit Card')
            AND NOT EXISTS (SELECT   1
                              FROM   promo2012_orders_paid@mkt_catalog o
                             WHERE   f.enroll_id = TRIM (o."evxenrollid"))
   UNION
   SELECT   f.sales_order_id, f.book_date, 'USA'
     FROM   sales_order_fact f
    WHERE       keycode = 'IPAD2012P'
            AND payment_method IN ('Cisco Learning Credits', 'Credit Card')
            AND book_date IS NOT NULL
            AND NOT EXISTS
                  (SELECT   1
                     FROM   promo2012_orders_paid@mkt_catalog o
                    WHERE   f.sales_order_id = TRIM (o."evxenrollid"));


