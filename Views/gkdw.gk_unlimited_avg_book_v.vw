DROP VIEW GKDW.GK_UNLIMITED_AVG_BOOK_V;

/* Formatted on 29/01/2021 11:24:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_UNLIMITED_AVG_BOOK_V
(
   CUST_ID,
   ENROLL_CNT,
   BOOK_AMT
)
AS
     SELECT   cust_id, COUNT ( * ) enroll_cnt, 4400 / COUNT ( * ) book_amt
       FROM   order_fact
      WHERE       attendee_type = 'Unlimited'
              AND book_amt = 0
              AND enroll_status != 'Cancelled'
   GROUP BY   cust_id;


