DROP VIEW GKDW.GK_NEW_BUYING_SITE_V;

/* Formatted on 29/01/2021 11:32:29 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NEW_BUYING_SITE_V
(
   ACCT_ID,
   INIT_ENROLL_DATE
)
AS
     SELECT   acct_id, MIN (min_book_date) init_enroll_date
       FROM   (  SELECT   cd.acct_id, MIN (book_date) min_book_date
                   FROM      order_fact f
                          INNER JOIN
                             cust_dim cd
                          ON f.cust_id = cd.cust_id
               -- where book_date >= to_date('1/1/2008','mm/dd/yyyy')
               GROUP BY   cd.acct_id
               UNION
                 SELECT   cd.acct_id, MIN (book_date)
                   FROM      sales_order_fact sf
                          INNER JOIN
                             cust_dim cd
                          ON sf.cust_id = cd.cust_id
               -- where book_date >= to_date('1/1/2008','mm/dd/yyyy')
               GROUP BY   cd.acct_id)
   GROUP BY   acct_id;


