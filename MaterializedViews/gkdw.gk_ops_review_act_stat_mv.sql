DROP MATERIALIZED VIEW GKDW.GK_OPS_REVIEW_ACT_STAT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_OPS_REVIEW_ACT_STAT_MV 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:23:55 (QP5 v5.115.810.9015) */
  SELECT   gp.period_year,
           gp.period_year || '-' || LPAD (gp.quarter_num, 2, '0') period_qtr,
           gp.period_year || '-' || LPAD (gp.period_num, 2, '0') period_num,
           gp.period_name,
           CASE
              WHEN ad.acct_desc LIKE 'Travel%' THEN 'Travel'
              ELSE ad.acct_desc
           END
              acct_rollup,
           ad.acct_desc,
           gcc.segment1 le_num,
           gcc.segment2 fe_num,
           gcc.segment3 acct_num,
           gcc.segment4 ch_num,
           gcc.segment5 md_num,
           gcc.segment6 pl_num,
           gcc.segment7 act_num,
           fd.fe_desc course_fe,
           NVL (cp.course_ch, cd.ch_desc) course_ch,
           NVL (cp.course_mod, md.md_desc) course_mod,
           NVL (cp.course_pl, pd.pl_desc) course_pl,
           cp.course_type,
           ac.act_desc,
           SUM( (  begin_balance_dr
                 - begin_balance_cr
                 + period_net_dr
                 - period_net_cr))
              actual_stat
    FROM                                 gl_balances@prd gb
                                      INNER JOIN
                                         gl_periods@prd gp
                                      ON     gb.period_name = gp.period_name
                                         AND gp.period_set_name = 'GKNET ACCTG'
                                         AND gp.end_date < TRUNC (SYSDATE)
                                   INNER JOIN
                                      gl_code_combinations@prd gcc
                                   ON gb.code_combination_id =
                                         gcc.code_combination_id
                                INNER JOIN
                                   acct_dim ad
                                ON gcc.segment3 = ad.acct_value
                             LEFT OUTER JOIN
                                le_dim ld
                             ON gcc.segment1 = ld.le_value
                          LEFT OUTER JOIN
                             fe_dim fd
                          ON gcc.segment2 = fd.fe_value
                       LEFT OUTER JOIN
                          ch_dim cd
                       ON gcc.segment4 = cd.ch_value
                    LEFT OUTER JOIN
                       md_dim md
                    ON gcc.segment5 = md.md_value
                 LEFT OUTER JOIN
                    pl_dim pd
                 ON gcc.segment6 = pd.pl_value
              LEFT OUTER JOIN
                 act_dim ac
              ON gcc.segment7 = ac.act_value
           LEFT OUTER JOIN
              gk_course_prod_lookup_v cp
           ON     gcc.segment4 = cp.ch_num
              AND gcc.segment5 = cp.md_num
              AND gcc.segment6 = cp.pl_num
              AND gcc.segment7 = cp.act_num
   WHERE       gp.period_year = 2012
           AND gb.actual_flag = 'A'
           AND gcc.segment1 = '210'
           AND gcc.segment3 IN
                    ('92050',
                     '92060',
                     '92122',
                     '92220',
                     '92222',
                     '92230',
                     '92232')
           AND gcc.segment4 IN ('10', '20')
--  and gcc.segment5 not in ('60')
--  and gcc.segment7 != '000000'
GROUP BY   gp.period_year,
           gp.period_year || '-' || LPAD (gp.quarter_num, 2, '0'),
           gp.period_year || '-' || LPAD (gp.period_num, 2, '0'),
           gp.period_name,
           ad.acct_desc,
           gcc.segment1,
           gcc.segment2,
           gcc.segment3,
           gcc.segment4,
           gcc.segment5,
           gcc.segment6,
           gcc.segment7,
           fd.fe_desc,
           NVL (cp.course_ch, cd.ch_desc),
           NVL (cp.course_mod, md.md_desc),
           NVL (cp.course_pl, pd.pl_desc),
           cp.course_type,
           cp.course_type,
           ac.act_desc
  HAVING   SUM(  begin_balance_dr
               - begin_balance_cr
               + period_net_dr
               - period_net_cr) <> 0;

COMMENT ON MATERIALIZED VIEW GKDW.GK_OPS_REVIEW_ACT_STAT_MV IS 'snapshot table for snapshot GKDW.GK_OPS_REVIEW_ACT_STAT_MV';

GRANT SELECT ON GKDW.GK_OPS_REVIEW_ACT_STAT_MV TO DWHREAD;

