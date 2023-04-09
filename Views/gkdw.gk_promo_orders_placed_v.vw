DROP VIEW GKDW.GK_PROMO_ORDERS_PLACED_V;

/* Formatted on 29/01/2021 11:28:27 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_ORDERS_PLACED_V
(
   BOOK_DATE,
   ENROLL_ID,
   KEYCODE,
   EMAIL
)
AS
   SELECT   TO_CHAR (book_date, 'mm/dd/yyyy') book_date,
            enroll_id,
            keycode,
            cd.email
     FROM      order_fact f
            INNER JOIN
               cust_dim cd
            ON f.cust_id = cd.cust_id
    WHERE       keycode = 'IPADMINI2013'
            AND enroll_status = 'Confirmed'
            AND book_date IS NOT NULL
            AND NOT EXISTS (SELECT   1
                              FROM   promo_orders_placed@mkt_catalog p
                             WHERE   f.enroll_id = TRIM (p."evxenrollid"));


