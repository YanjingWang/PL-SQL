DROP VIEW GKDW.GK_STUDENT_CW_V;

/* Formatted on 29/01/2021 11:25:40 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_STUDENT_CW_V
(
   COURSECODE,
   COUNTRY,
   CW_PER_STUD
)
AS
     SELECT   coursecode,
              country,
              ROUND (
                 SUM(CASE
                        WHEN quantity = 0 THEN 0
                        ELSE cb.kit_price / quantity
                     END),
                 2
              )
                 cw_per_stud
       FROM      cw_course_part@gkprod cp
              INNER JOIN
                 cw_bom@gkprod cb
              ON cp.part_num = cb.kit_num
   GROUP BY   coursecode, country;


