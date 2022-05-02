DROP VIEW GKDW.GK_ACCOUNT_REVENUE_V;

/* Formatted on 29/01/2021 11:43:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ACCOUNT_REVENUE_V
(
   REV_RANK,
   ACCT_NAME,
   REV_AMT
)
AS
     SELECT   RANK () OVER (ORDER BY SUM (rev_amt) DESC) rev_rank,
              acct_name,
              SUM (rev_amt) rev_amt
       FROM   (  SELECT   NVL (r.rollup_acct_name, c.acct_name) acct_name,
                          SUM(CASE
                                 WHEN f.attendee_type = 'Unlimited'
                                      AND book_amt = 0
                                 THEN
                                    u.book_amt
                                 ELSE
                                    f.book_amt
                              END)
                             rev_amt
                   FROM                  order_fact f
                                      INNER JOIN
                                         event_dim ed
                                      ON f.event_id = ed.event_id
                                   INNER JOIN
                                      cust_dim c
                                   ON f.cust_id = c.cust_id
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             LEFT OUTER JOIN
                                gk_unlimited_avg_book_v u
                             ON f.cust_id = u.cust_id
                          LEFT OUTER JOIN
                             gk_acct_rollup r
                          ON c.acct_id = r.acct_id
                  WHERE       td.dim_year >= 2006
                          AND f.enroll_status != 'Cancelled'
                          AND c.acct_name IS NOT NULL
               GROUP BY   NVL (r.rollup_acct_name, c.acct_name)
               UNION
                 SELECT   NVL (r.rollup_acct_name, c.acct_name) acct_name,
                          SUM (f.book_amt) rev_amt
                   FROM            sales_order_fact f
                                INNER JOIN
                                   cust_dim c
                                ON f.cust_id = c.cust_id
                             INNER JOIN
                                time_dim td
                             ON f.book_date = td.dim_date
                          LEFT OUTER JOIN
                             gk_acct_rollup r
                          ON c.acct_id = r.acct_id
                  WHERE       td.dim_year >= 2006
                          AND f.record_type = 'SalesOrder'
                          AND f.so_status != 'Cancelled'
                          AND acct_name IS NOT NULL
               GROUP BY   NVL (r.rollup_acct_name, c.acct_name))
   GROUP BY   acct_name
   ORDER BY   3 DESC;
