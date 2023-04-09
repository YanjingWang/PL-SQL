DROP MATERIALIZED VIEW GKDW.GK_COURSE_REV_DATES_MV;
CREATE MATERIALIZED VIEW GKDW.GK_COURSE_REV_DATES_MV 
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
/* Formatted on 29/01/2021 12:25:29 (QP5 v5.115.810.9015) */
  SELECT   SUBSTR (ed.course_code, 0, LENGTH (ed.course_code) - 1) course_code,
           MIN (rev_date) rev_date
    FROM      order_fact f
           INNER JOIN
              event_dim ed
           ON f.event_id = ed.event_id
GROUP BY   SUBSTR (ed.course_code, 0, LENGTH (ed.course_code) - 1);

COMMENT ON MATERIALIZED VIEW GKDW.GK_COURSE_REV_DATES_MV IS 'snapshot table for snapshot GKDW.GK_COURSE_REV_DATES_MV';

GRANT SELECT ON GKDW.GK_COURSE_REV_DATES_MV TO DWHREAD;

