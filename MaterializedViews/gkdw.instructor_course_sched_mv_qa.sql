DROP MATERIALIZED VIEW GKDW.INSTRUCTOR_COURSE_SCHED_MV_QA;
CREATE MATERIALIZED VIEW GKDW.INSTRUCTOR_COURSE_SCHED_MV_QA 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
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
/* Formatted on 29/01/2021 12:20:56 (QP5 v5.115.810.9015) */
SELECT   "dim_date" DIM_DATE,
         "instructor_id" INSTRUCTOR_ID,
         "firstname" FIRSTNAME,
         "lastname" LASTNAME,
         "country" COUNTRY,
         "product_id" PRODUCT_ID,
         "pmm_id" PMM_ID,
         "us_code" PROD_CODE,
         "course_name" COURSE_NAME,
         "modality" MODALITY,
         "modality_desc" MODALITY_DESC,
         "gk_course_code" COURSE_CODE,
         "duration" COURSE_DUR,
         "duration_unit" DUR_UNIT
  FROM   "instructor_course_sched_v"@rms_dev;

COMMENT ON MATERIALIZED VIEW GKDW.INSTRUCTOR_COURSE_SCHED_MV_QA IS 'snapshot table for snapshot GKDW.INSTRUCTOR_COURSE_SCHED_MV_QA';

GRANT SELECT ON GKDW.INSTRUCTOR_COURSE_SCHED_MV_QA TO DWHREAD;

