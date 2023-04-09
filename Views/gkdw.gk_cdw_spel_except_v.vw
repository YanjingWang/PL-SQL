DROP VIEW GKDW.GK_CDW_SPEL_EXCEPT_V;

/* Formatted on 29/01/2021 11:41:07 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CDW_SPEL_EXCEPT_V
(
   EXCEPT_GRP,
   PERIOD_NAME,
   BATCH_NAME,
   JE_CATEGORY,
   JE_SOURCE,
   JE_LINE_NUM,
   DESCRIPTION,
   OPS_COUNTRY,
   CH,
   MD,
   PRODUCT_NUM,
   PROD_NAME,
   GROSS_REVENUE
)
AS
   SELECT   'EX-SPEL_NOT_ON_MASTER' except_grp,
            j.period_name,
            b.NAME batch_name,
            h.je_category,
            h.je_source,
            j.je_line_num,
            j.description,
            CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END
               ops_country,
            gcc.segment4 ch,
            gcc.segment5 md,
            CASE
               WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
               THEN
                  SUBSTR (gcc.segment7, 3, 4) || 'S'
               ELSE
                  gcc.segment7
            END
               product_num,
            pd.prod_name,
            NVL (accounted_cr, 0) - NVL (accounted_dr, 0) gross_revenue
     FROM                  gl_je_lines@r12prd j
                        INNER JOIN
                           gl_je_headers@r12prd h
                        ON j.je_header_id = h.je_header_id
                     INNER JOIN
                        gl_je_batches@r12prd b
                     ON h.je_batch_id = b.je_batch_id
                  INNER JOIN
                     gl_code_combinations@r12prd gcc
                  ON j.code_combination_id = gcc.code_combination_id
               LEFT OUTER JOIN
                  gk_cdw_interface c
               ON gcc.segment7 =
                     CASE
                        WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
                        THEN
                           LPAD (SUBSTR (c.gk_course_num, 1, 4), 6, '00')
                        ELSE
                           c.gk_course_num
                     END
                  AND c.spel_rate IS NOT NULL
            LEFT OUTER JOIN
               product_dim pd
            ON gk_course_num = pd.prod_num AND pd.status = 'Available'
    WHERE       gcc.segment3 = '41105'
            AND gcc.segment5 = '31'
            AND gcc.segment6 = '04'
            AND c.gk_course_num IS NULL
   UNION
   SELECT   'EX-SPEL_NOT_ON_MASTER',
            j.period_name,
            b.name batch_name,
            h.je_category,
            h.je_source,
            j.je_line_num,
            j.description,
            CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END
               ops_country,
            gcc.segment4 ch,
            gcc.segment5 md,
            CASE
               WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
               THEN
                  SUBSTR (gcc.segment7, 3, 4) || 'W'
               ELSE
                  gcc.segment7 || 'W'
            END
               product_num,
            cd.short_name,
            NVL (accounted_cr, 0) - NVL (accounted_dr, 0) gross_revenue
     FROM                  gl_je_lines@r12prd j
                        INNER JOIN
                           gl_je_headers@r12prd h
                        ON j.je_header_id = h.je_header_id
                     INNER JOIN
                        gl_je_batches@r12prd b
                     ON h.je_batch_id = b.je_batch_id
                  INNER JOIN
                     gl_code_combinations@r12prd gcc
                  ON j.code_combination_id = gcc.code_combination_id
               LEFT OUTER JOIN
                  gk_cdw_interface c
               ON gcc.segment7 =
                     CASE
                        WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
                        THEN
                           LPAD (SUBSTR (c.gk_course_num, 1, 4), 6, '00')
                        ELSE
                           c.gk_course_num
                     END
                  AND c.spel_rate IS NOT NULL
            LEFT OUTER JOIN
               course_dim cd
            ON CASE
                  WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
                  THEN
                     SUBSTR (gcc.segment7, 3, 4) || 'W'
                  ELSE
                     gcc.segment7 || 'W'
               END = cd.course_code
               AND CASE
                     WHEN gcc.segment1 = '220' THEN 'CANADA'
                     ELSE 'USA'
                  END = cd.country
    WHERE       gcc.segment3 = '41105'
            AND gcc.segment5 = '32'
            AND gcc.segment6 = '04'
            AND c.gk_course_num IS NULL
--   SELECT 'EX-SPEL_NOT_ON_MASTER', j.period_name, b.NAME batch_name,
--          h.je_category, h.je_source, j.je_line_num, j.description,
--          CASE
--             WHEN gcc.segment1 = '220'
--                THEN 'CAN'
--             ELSE 'USA'
--          END ops_country, gcc.segment4 ch, gcc.segment5 md,
--          CASE
--             WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
--                THEN SUBSTR (gcc.segment7, 3, 4) || 'W'
--             ELSE gcc.segment7 || 'W'
--          END product_num,
--          pd.prod_name,
--          NVL (accounted_cr, 0) - NVL (accounted_dr, 0) gross_revenue
--     FROM gl_je_lines@r12prd j INNER JOIN gl_je_headers@r12prd h
--          ON j.je_header_id = h.je_header_id
--          INNER JOIN gl_je_batches@r12prd b ON h.je_batch_id = b.je_batch_id
--          INNER JOIN gl_code_combinations@r12prd gcc
--          ON j.code_combination_id = gcc.code_combination_id
--          LEFT OUTER JOIN gk_cdw_interface c
--          ON gcc.segment7 =
--               CASE
--                  WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
--                     THEN LPAD (SUBSTR (c.gk_course_num, 1, 4), 6, '00')
--                  ELSE c.gk_course_num
--               END
--        AND c.spel_rate IS NOT NULL
--          LEFT OUTER JOIN product_dim pd
--          ON gk_course_num = pd.prod_num AND pd.status = 'Available'
--    WHERE gcc.segment3 = '41105'
--      AND gcc.segment5 = '32'
--      AND gcc.segment6 = '04'
--      AND c.gk_course_num IS NULL;;;


