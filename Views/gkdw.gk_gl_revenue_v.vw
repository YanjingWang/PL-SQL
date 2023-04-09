DROP VIEW GKDW.GK_GL_REVENUE_V;

/* Formatted on 29/01/2021 11:35:56 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GL_REVENUE_V
(
   ACCT,
   CH,
   MD,
   PL,
   PERIOD_NAME,
   PERIOD_NUM,
   PERIOD_YEAR,
   GL_AMT
)
AS
     SELECT   x.segment3 acct,
              x.segment4 ch,
              x.segment5 md,
              x.segment6 Pl,
              y.period_name,
              y.period_num,
              y.period_year,
              SUM (y.period_net_cr - y.period_net_dr) Gl_amt
       FROM      gl_code_combinations@r12prd x
              INNER JOIN
                 gl_balances@r12prd y
              ON x.code_combination_id = y.code_combination_id
      --inner join fnd_flex_values z on x.segment6 = z.flex_value and z.flex_value_set_id = 1007699
      WHERE       x.segment1 = '210'
              AND x.SEGMENT3 BETWEEN '40000' AND '49999'
              AND x.segment3 NOT IN ('41315', '41210')
              --and x.segment3 = '41105'
              --and x.segment6 = '04'
              AND y.period_year = '2012'
              AND y.currency_code = 'USD'
              AND actual_flag = 'A'
              --and y.set_of_books_id = 2
              AND x.segment4 = '10'
   --and x.segment5 = '31'
   GROUP BY   y.period_year,
              y.period_num,
              y.period_name,
              x.segment3,
              x.segment6,
              x.segment5,
              x.segment4
     HAVING   SUM (y.period_net_cr - y.period_net_dr) <> 0
   ORDER BY   y.period_num,
              2,
              3,
              4,
              1;


GRANT SELECT ON GKDW.GK_GL_REVENUE_V TO COGNOS_RO;

GRANT SELECT ON GKDW.GK_GL_REVENUE_V TO EXCEL_RO;

GRANT SELECT ON GKDW.GK_GL_REVENUE_V TO PORTAL;

