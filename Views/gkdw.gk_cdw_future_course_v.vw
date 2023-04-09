DROP VIEW GKDW.GK_CDW_FUTURE_COURSE_V;

/* Formatted on 29/01/2021 11:41:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CDW_FUTURE_COURSE_V
(
   CDW_GROUP,
   SHORT_NAME,
   COURSE_CODE,
   CH_NUM,
   MD_NUM
)
AS
     SELECT   'EX-FUTURE_COURSES_NO_MASTER' cdw_group,
              short_name,
              course_code,
              ch_num,
              md_num
       FROM   gk_cdw_course_except_v
      WHERE   start_date >= TRUNC (SYSDATE)
   GROUP BY   short_name,
              course_code,
              ch_num,
              md_num;


