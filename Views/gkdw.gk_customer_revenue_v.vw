DROP VIEW GKDW.GK_CUSTOMER_REVENUE_V;

/* Formatted on 29/01/2021 11:38:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CUSTOMER_REVENUE_V
(
   GROUP_ACCT_NAME,
   REV_RANK,
   TOTAL_REVENUE
)
AS
     SELECT   UPPER (NVL (n.group_acct_name, ad.acct_name)) group_acct_name,
              RANK () OVER (ORDER BY SUM (NVL (f.book_amt, 0)) DESC) rev_rank,
              SUM (NVL (f.book_amt, 0)) total_revenue
       FROM                  cust_dim cd
                          INNER JOIN
                             account_dim ad
                          ON cd.acct_id = ad.acct_id
                       INNER JOIN
                          order_fact f
                       ON cd.cust_id = f.cust_id
                    INNER JOIN
                       event_dim ed
                    ON f.event_id = ed.event_id
                 INNER JOIN
                    time_dim td
                 ON f.book_date = td.dim_date
              LEFT OUTER JOIN
                 gk_account_groups_naics n
              ON ad.acct_id = n.acct_id
      WHERE   td.dim_year >= 2007
   GROUP BY   UPPER (NVL (n.group_acct_name, ad.acct_name))
     HAVING   SUM (NVL (f.book_amt, 0)) > 0
   ORDER BY   total_revenue DESC;


