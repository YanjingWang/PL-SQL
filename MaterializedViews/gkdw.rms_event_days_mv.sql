DROP MATERIALIZED VIEW GKDW.RMS_EVENT_DAYS_MV;
CREATE MATERIALIZED VIEW GKDW.RMS_EVENT_DAYS_MV 
TABLESPACE GDWMED
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
START WITH TO_DATE('29-Jan-2021 22:30:00','dd-mon-yyyy hh24:mi:ss')
NEXT TRUNC(SYSDATE+1)+22.5/24          
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:20:00 (QP5 v5.115.810.9015) */
SELECT   ed.event_id,
         s."id" rms_schedule,
         ss."day" event_date,
         TO_CHAR (ss."start_time", 'hh:mi:ss AM') start_time,
         TO_CHAR (ss."end_time", 'hh:mi:ss AM') end_time
  FROM   event_dim ed, "schedule"@rms_prod s, "schedule_sessions"@rms_prod ss
 WHERE   ed.event_id = s."slx_id" AND s."id" = ss."schedule";

COMMENT ON MATERIALIZED VIEW GKDW.RMS_EVENT_DAYS_MV IS 'snapshot table for snapshot GKDW.RMS_EVENT_DAYS_MV';

GRANT SELECT ON GKDW.RMS_EVENT_DAYS_MV TO DWHREAD;

