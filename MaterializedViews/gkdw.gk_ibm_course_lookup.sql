DROP MATERIALIZED VIEW GKDW.GK_IBM_COURSE_LOOKUP;
CREATE MATERIALIZED VIEW GKDW.GK_IBM_COURSE_LOOKUP 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:24:58 (QP5 v5.115.810.9015) */
SELECT   TO_CHAR (country) country,
         TO_CHAR (course_code) course_code,
         TO_CHAR (ibm_course_code) ibm_course_code,
         TO_CHAR (ibm_ww_course_code) ibm_ww_course_code,
         TO_CHAR (ibm_title) ibm_title,
         TO_CHAR (language) language
  FROM   gk_ibm_course_lookup_v@slx;

COMMENT ON MATERIALIZED VIEW GKDW.GK_IBM_COURSE_LOOKUP IS 'snapshot table for snapshot GKDW.gk_ibm_course_lookup';

GRANT SELECT ON GKDW.GK_IBM_COURSE_LOOKUP TO DWHREAD;

