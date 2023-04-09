DROP MATERIALIZED VIEW GKDW.INSTRUCTOR_COURSE_LOOKUP_MV;
CREATE MATERIALIZED VIEW GKDW.INSTRUCTOR_COURSE_LOOKUP_MV 
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
/* Formatted on 29/01/2021 12:21:04 (QP5 v5.115.810.9015) */
SELECT   DISTINCT "instructor_id" INSTRUCTOR_ID,
                  "firstname" FIRSTNAME,
                  "lastname" LASTNAME,
                  "country" COUNTRY,
                  "product_id" PRODUCT_ID,
                  "us_code" PROD_CODE,
                  "course_name" COURSE_NAME,
                  "duration" COURSE_DUR,
                  "postalcode" ZIP_CODE
  FROM   "instructor_course_lookup_v"@rms_prod;

COMMENT ON MATERIALIZED VIEW GKDW.INSTRUCTOR_COURSE_LOOKUP_MV IS 'snapshot table for snapshot GKDW.INSTRUCTOR_COURSE_LOOKUP_MV';

GRANT SELECT ON GKDW.INSTRUCTOR_COURSE_LOOKUP_MV TO DWHREAD;

