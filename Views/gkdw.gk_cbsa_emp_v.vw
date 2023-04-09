DROP VIEW GKDW.GK_CBSA_EMP_V;

/* Formatted on 29/01/2021 11:41:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CBSA_EMP_V
(
   DIM_YEAR,
   CBSA_NAME,
   CBSA_CODE,
   IT_CATEGORY,
   EMP_CNT
)
AS
     SELECT   2006 dim_year,
              area_name cbsa_name,
              area_number cbsa_code,
              it_category,
              SUM (occ_emp_cnt) emp_cnt
       FROM   gk_occ_mv m
      WHERE   occ_year = 2006
   GROUP BY   area_name, area_number, it_category
   UNION ALL
     SELECT   2007,
              area_name,
              area_number,
              it_category,
              SUM (occ_emp_cnt)
       FROM   gk_occ_mv m
      WHERE   occ_year = 2007
   GROUP BY   area_name, area_number, it_category
   UNION ALL
     SELECT   2008,
              area_name,
              area_number,
              it_category,
              SUM (occ_emp_cnt)
       FROM   gk_occ_mv m
      WHERE   occ_year = 2008
   GROUP BY   area_name, area_number, it_category
   UNION ALL
     SELECT   2009,
              area_name,
              area_number,
              it_category,
              SUM (occ_emp_cnt)
       FROM   gk_occ_mv m
      WHERE   occ_year = 2009
   GROUP BY   area_name, area_number, it_category
   UNION ALL
     SELECT   2010,
              area_name,
              area_number,
              it_category,
              SUM (occ_emp_cnt)
       FROM   gk_occ_mv m
      WHERE   occ_year = 2010
   GROUP BY   area_name, area_number, it_category
   UNION ALL
     SELECT   2011,
              area_name,
              area_number,
              it_category,
              SUM (occ_emp_cnt)
       FROM   gk_occ_mv m
      WHERE   occ_year = 2010
   GROUP BY   area_name, area_number, it_category;


