DROP MATERIALIZED VIEW GKDW.GK_EVENT_DAYS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_EVENT_DAYS_MV 
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
/* Formatted on 29/01/2021 12:25:10 (QP5 v5.115.810.9015) */
SELECT   ed.event_id,
         ed.status,
         ss."day" session_date,
         TO_CHAR (TO_DATE (ed.start_time, 'hh:mi:ss AM'), 'fmhh:')
         || TO_CHAR (TO_DATE (ed.start_time, 'hh:mi:ss AM'), 'mi AM')
            start_time,
         TO_CHAR (TO_DATE (ed.end_time, 'hh:mi:ss AM'), 'fmhh:')
         || TO_CHAR (TO_DATE (ed.end_time, 'hh:mi:ss AM'), 'mi AM')
            end_time,
         TO_CHAR (ss."start_time", 'fmhh:')
         || TO_CHAR (ss."start_time", 'mi AM')
            session_start,
         TO_CHAR (ss."end_time", 'fmhh:') || TO_CHAR (ss."end_time", 'mi AM')
            session_end
  FROM   event_dim ed,
         course_dim cd,
         "schedule"@rms_prod s,
         "schedule_sessions"@rms_prod ss
 WHERE       ed.course_id = cd.course_id
         AND ed.ops_country = cd.country
         AND ed.event_id = s."slx_id"
         AND s."id" = ss."schedule"
         AND ed.end_date >= TRUNC (SYSDATE) - 180
         AND cd.md_num IN ('10', '20', '41', '42', '21');

COMMENT ON MATERIALIZED VIEW GKDW.GK_EVENT_DAYS_MV IS 'snapshot table for snapshot GKDW.GK_EVENT_DAYS_MV';

GRANT SELECT ON GKDW.GK_EVENT_DAYS_MV TO DWHREAD;

