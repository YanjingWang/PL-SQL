DROP VIEW GKDW.GK_NEW_BUYER_V;

/* Formatted on 29/01/2021 11:32:33 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NEW_BUYER_V (CUST_ID, INIT_ENROLL_DATE)
AS
     SELECT   cust_id, MIN (min_book_date) init_enroll_date
       FROM   (  SELECT   f.cust_id, MIN (book_date) min_book_date
                   FROM   order_fact f
               -- where book_date >= to_date('1/1/2008','mm/dd/yyyy')
               GROUP BY   f.cust_id
               UNION
                 SELECT   sf.cust_id, MIN (book_date)
                   FROM   sales_order_fact sf
               -- where book_date >= to_date('1/1/2008','mm/dd/yyyy')
               GROUP BY   sf.cust_id)
   GROUP BY   cust_id;


