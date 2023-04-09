DROP VIEW GKDW.GK_COURSE_HARD_CAP_V;

/* Formatted on 29/01/2021 11:39:48 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_HARD_CAP_V
(
   GK_COURSE_CODE,
   HARD_CAP
)
AS
     SELECT   DISTINCT gk_course_code, hard_cap
       FROM   lab_course_lookup_mv_qa
   ORDER BY   1;


