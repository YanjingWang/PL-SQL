DROP MATERIALIZED VIEW GKDW.RMS_EVENT_POD_MV;
CREATE MATERIALIZED VIEW GKDW.RMS_EVENT_POD_MV 
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
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:19:56 (QP5 v5.115.810.9015) */
SELECT   s."id" schedule_id,
         s."slx_id" slx_event_id,
         l."name" pod_name,
         lp."id" pod_id,
         s."lab_date_type" lab_date_type,
         s."start" eventstart,
         s."end" eventend,
         sl."due_date" due_date,
         s."comment" event_comment
  FROM            "schedule"@rms_prod s
               INNER JOIN
                  "schedule_lab"@rms_prod sl
               ON s."id" = sl."schedule"
            INNER JOIN
               "lab_pod"@rms_prod lp
            ON sl."lab_pod" = lp."id"
         INNER JOIN
            "lab"@rms_prod l
         ON lp."lab" = l."id"
 WHERE   lp."type" = 'pod'
         AND TRUNC (s."start") >= TO_CHAR (SYSDATE - 30, 'dd-MON-yyyy');

COMMENT ON MATERIALIZED VIEW GKDW.RMS_EVENT_POD_MV IS 'snapshot table for snapshot GKDW.RMS_EVENT_POD_MV';

CREATE INDEX GKDW.RMS_EVENT_POD_MV_IDX1 ON GKDW.RMS_EVENT_POD_MV
(SLX_EVENT_ID)
LOGGING
TABLESPACE GDWIDX
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
NOPARALLEL;

GRANT SELECT ON GKDW.RMS_EVENT_POD_MV TO DWHREAD;

