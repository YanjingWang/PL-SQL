DROP VIEW GKDW.GK_PM_2010_PLAN_V;

/* Formatted on 29/01/2021 11:30:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PM_2010_PLAN_V
(
   COUNTRY,
   COURSECODE,
   PLAN_SCHED,
   PLAN_RUN,
   PLAN_FILLRATE
)
AS
     SELECT   CASE
                 WHEN p.le_num IN ('210', '214') THEN 'USA'
                 WHEN p.le_num IN ('220', '224') THEN 'CANADA'
              END
                 country,
              p.course_code coursecode,
              SUM (CASE WHEN p.acct_num = '92050' THEN p.amt_sum ELSE 0 END)
                 plan_sched,
              SUM (CASE WHEN p.acct_num = '92060' THEN p.amt_sum ELSE 0 END)
                 plan_run,
              CASE
                 WHEN SUM(CASE
                             WHEN p.acct_num = '92060' THEN p.amt_sum
                             ELSE 0
                          END) = 0
                 THEN
                    0
                 ELSE
                    (SUM(CASE
                            WHEN p.acct_num = '92122' AND p.ch_num = '20'
                            THEN
                               p.amt_sum
                            ELSE
                               0
                         END)
                     + SUM(CASE
                              WHEN p.acct_num = '92122' AND p.ch_num = '10'
                              THEN
                                 p.amt_sum
                              ELSE
                                 0
                           END))
                    / SUM(CASE
                             WHEN p.acct_num = '92060' THEN p.amt_sum
                             ELSE 0
                          END)
              END
                 plan_fillrate
       FROM   gk_us_plan p
      --       left outer join course_dim cd on p.course_code = cd.course_code and cd.country = case when p.le_num = '220' then 'CANADA' else 'USA' end and cd.gkdw_source = 'SLXDW'
      --       left outer join product_dim pd on p.course_code = pd.prod_num
      WHERE   p.period_year = TO_CHAR (SYSDATE, 'YYYY')
              AND p.acct_num IN ('41105', '92122', '92123', '92060', '92050')
   GROUP BY   CASE
                 WHEN p.le_num IN ('210', '214') THEN 'USA'
                 WHEN p.le_num IN ('220', '224') THEN 'CANADA'
              END, p.course_code;


