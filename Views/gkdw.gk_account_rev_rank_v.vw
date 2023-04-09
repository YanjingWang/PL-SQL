DROP VIEW GKDW.GK_ACCOUNT_REV_RANK_V;

/* Formatted on 29/01/2021 11:43:19 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ACCOUNT_REV_RANK_V
(
   ACCT_NAME,
   REV_AMT,
   REV_RANK
)
AS
     SELECT   acct_name,
              SUM (rev_amt) rev_amt,
              RANK () OVER (ORDER BY SUM (rev_amt) DESC) rev_rank
       FROM   gk_account_revenue_mv
      WHERE   dim_year BETWEEN 2006 AND 2010
   GROUP BY   acct_name;


