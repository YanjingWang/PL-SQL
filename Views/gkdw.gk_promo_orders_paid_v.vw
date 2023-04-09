DROP VIEW GKDW.GK_PROMO_ORDERS_PAID_V;

/* Formatted on 29/01/2021 11:28:31 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_ORDERS_PAID_V
(
   ENROLL_ID,
   DATE_PAID
)
AS
   SELECT   f.enroll_id, TO_CHAR (b.modifydate - 1, 'mm/dd/yyyy') date_paid
     FROM            order_fact f
                  INNER JOIN
                     cust_dim c
                  ON f.cust_id = c.cust_id
               INNER JOIN
                  slxdw.qg_billingpayment b
               ON f.enroll_id = b.evxevenrollid
            INNER JOIN
               promo_orders_placed@mkt_catalog p
            ON f.enroll_id = TRIM (p."evxenrollid")
    WHERE       keycode = 'IPADMINI2013'
            AND b.oraclestatus = 'Paid'
            AND NOT EXISTS (SELECT   1
                              FROM   promo_orders_paid@mkt_catalog o
                             WHERE   f.enroll_id = TRIM (o."evxenrollid"))
   UNION
   SELECT   f.enroll_id, TO_CHAR (f.book_date, 'mm/dd/yyyy') date_paid
     FROM   order_fact f
    WHERE       keycode = 'IPADMINI2013'
            AND payment_method IN ('Cisco Learning Credits', 'Credit Card')
            AND NOT EXISTS (SELECT   1
                              FROM   promo_orders_paid@mkt_catalog o
                             WHERE   f.enroll_id = TRIM (o."evxenrollid"))
   UNION
   SELECT   f.sales_order_id, TO_CHAR (f.book_date, 'mm/dd/yyyy') date_paid
     FROM   sales_order_fact f
    WHERE       keycode = 'IPADMINI2013'
            AND payment_method IN ('Cisco Learning Credits', 'Credit Card')
            AND book_date IS NOT NULL
            AND NOT EXISTS
                  (SELECT   1
                     FROM   promo_orders_paid@mkt_catalog o
                    WHERE   f.sales_order_id = TRIM (o."evxenrollid"));


