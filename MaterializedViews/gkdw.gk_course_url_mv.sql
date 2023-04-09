DROP MATERIALIZED VIEW GKDW.GK_COURSE_URL_MV;
CREATE MATERIALIZED VIEW GKDW.GK_COURSE_URL_MV 
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
REFRESH COMPLETE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:25:24 (QP5 v5.115.810.9015) */
SELECT   cd.course_code, cd.country, vc."url" course_url
  FROM      course_dim cd
         INNER JOIN
            us_urls_v@slx vc
         ON cd.course_code = vc."course_id" AND cd.country = 'USA'
UNION
SELECT   cd.course_code, cd.country, vc.url course_url
  FROM      course_dim cd
         INNER JOIN
            canada_urls_v@slx vc
         ON cd.course_code = vc.course_id AND cd.country = 'CANADA';

COMMENT ON MATERIALIZED VIEW GKDW.GK_COURSE_URL_MV IS 'snapshot table for snapshot GKDW.GK_COURSE_URL_MV';

GRANT SELECT ON GKDW.GK_COURSE_URL_MV TO DWHREAD;

