DROP VIEW GKDW.GK_INST_COURSE_RATE_V;

/* Formatted on 29/01/2021 11:33:57 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_INST_COURSE_RATE_V
(
   EVXCOURSEID,
   RATE_PLAN,
   INSTRUCTOR_ID,
   RATE,
   START_DATE,
   END_DATE
)
AS
   SELECT   ic.evxcourseid,
            rp.rate_plan,
            ir.instructor_id,
            rate,
            start_date,
            NVL (end_date, TRUNC (SYSDATE) + 365) end_date
     FROM            inst_course_rate@gkprod ic
                  INNER JOIN
                     inst_rate_plan@gkprod rp
                  ON ic.rate_plan_id = rp.rate_plan_id
               INNER JOIN
                  inst_rate_plan_line@gkprod rpl
               ON rp.rate_plan_id = rpl.rate_plan_id
            INNER JOIN
               inst_instructor_rate@gkprod ir
            ON rp.rate_plan_id = ir.rate_plan_id
    WHERE   rpl.flat_rate = 'Y' AND ir.rate > 0
   UNION
   SELECT   ic.evxcourseid,
            rp.rate_plan,
            ir.instructor_id,
            rate,
            start_date,
            NVL (end_date, TRUNC (SYSDATE) + 365) end_date
     FROM            inst_course_rate@gkprod ic
                  INNER JOIN
                     inst_rate_plan@gkprod rp
                  ON ic.rate_plan_id = rp.rate_plan_id
               INNER JOIN
                  inst_rate_plan_line@gkprod rpl
               ON rp.rate_plan_id = rpl.rate_plan_id
            INNER JOIN
               inst_instructor_rate@gkprod ir
            ON rp.rate_plan_id = ir.rate_plan_id
    WHERE   rpl.flat_rate = 'N' AND rpl.pct_rate = 100 AND ir.rate > 0;


