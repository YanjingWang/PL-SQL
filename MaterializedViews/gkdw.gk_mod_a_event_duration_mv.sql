DROP MATERIALIZED VIEW GKDW.GK_MOD_A_EVENT_DURATION_MV;
CREATE MATERIALIZED VIEW GKDW.GK_MOD_A_EVENT_DURATION_MV 
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
/* Formatted on 29/01/2021 12:24:20 (QP5 v5.115.810.9015) */
SELECT   s."slx_id" event_id,
         s."changed" change_date,
         s."booking_date",
         s."status" event_status,
         s."start" AS start_date,
         s."end" end_date,
         s."duration" duration
  FROM   event_dim ed, course_dim cd, "schedule"@rms_prod s
 WHERE       ed.course_id = cd.course_id
         AND ed.ops_country = cd.country
         AND ed.event_id(+) = s."slx_id"
         AND CAST (s."end" AS date) >= TRUNC (SYSDATE) - 1
         AND s."slx_id" IS NOT NULL
         AND cd.md_num = 33;

COMMENT ON MATERIALIZED VIEW GKDW.GK_MOD_A_EVENT_DURATION_MV IS 'snapshot table for snapshot GKDW.GK_MOD_A_EVENT_DURATION_MV';

GRANT SELECT ON GKDW.GK_MOD_A_EVENT_DURATION_MV TO DWHREAD;

