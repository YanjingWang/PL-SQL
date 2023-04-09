DROP MATERIALIZED VIEW GKDW.LAB_COURSE_SCHED_MV;
CREATE MATERIALIZED VIEW GKDW.LAB_COURSE_SCHED_MV 
TABLESPACE GDWSML
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
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:20:46 (QP5 v5.115.810.9015) */
SELECT   * FROM "lab_course_sched_v"@rms_prod;

COMMENT ON MATERIALIZED VIEW GKDW.LAB_COURSE_SCHED_MV IS 'snapshot table for snapshot GKDW.LAB_COURSE_SCHED_MV';

GRANT SELECT ON GKDW.LAB_COURSE_SCHED_MV TO DWHREAD;

