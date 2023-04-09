DROP MATERIALIZED VIEW GKDW.GK_INST_COURSE_RATE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_INST_COURSE_RATE_MV 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE
START WITH TO_DATE('04-Feb-2021 09:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT TRUNC(SYSDATE+7)+9/24  
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:24:34 (QP5 v5.115.810.9015) */
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

COMMENT ON MATERIALIZED VIEW GKDW.GK_INST_COURSE_RATE_MV IS 'snapshot table for snapshot GKDW.GK_INST_COURSE_RATE_MV';

GRANT SELECT ON GKDW.GK_INST_COURSE_RATE_MV TO DWHREAD;

