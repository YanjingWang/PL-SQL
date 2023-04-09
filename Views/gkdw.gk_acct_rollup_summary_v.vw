DROP VIEW GKDW.GK_ACCT_ROLLUP_SUMMARY_V;

/* Formatted on 29/01/2021 11:43:14 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ACCT_ROLLUP_SUMMARY_V
(
   FORTUNE_1000,
   ROLLUP_ACCT_NAME,
   ACCT_CNT
)
AS
     SELECT   fortune_1000, rollup_acct_name, COUNT ( * ) acct_cnt
       FROM   gk_acct_rollup
   GROUP BY   fortune_1000, rollup_acct_name;


