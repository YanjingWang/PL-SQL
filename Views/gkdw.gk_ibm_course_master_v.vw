DROP VIEW GKDW.GK_IBM_COURSE_MASTER_V;

/* Formatted on 29/01/2021 11:34:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IBM_COURSE_MASTER_V
(
   IBM_WW_COURSE_CODE,
   IBM_TITLE,
   IBM_BRAND,
   PDM_FLAG
)
AS
   SELECT   ibm_ww_course_code,
            ibm_title,
            ibm_brand,
            'Y' pdm_flag
     FROM   gk_ibm_course_master m
    WHERE   EXISTS (SELECT   1
                      FROM   course_dim cd
                     WHERE   m.ibm_ww_course_code = cd.mfg_course_code)
   UNION
   SELECT   ibm_ww_course_code,
            ibm_title,
            ibm_brand,
            'N' pdm_flag
     FROM   gk_ibm_course_master m
    WHERE   NOT EXISTS (SELECT   1
                          FROM   course_dim cd
                         WHERE   m.ibm_ww_course_code = cd.mfg_course_code)
   ORDER BY   1;


