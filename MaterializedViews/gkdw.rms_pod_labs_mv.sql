DROP MATERIALIZED VIEW GKDW.RMS_POD_LABS_MV;
CREATE MATERIALIZED VIEW GKDW.RMS_POD_LABS_MV 
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
/* Formatted on 29/01/2021 12:19:50 (QP5 v5.115.810.9015) */
SELECT   s."id" schedule_id,
         s."slx_id" slx_event_id,
         l."name" pod_name,
         lp."id" pod_id,
         s."lab_date_type" lab_date_type,
         s."start" eventstart,
         s."end" eventend,
         s."country" country,
         s."status" event_status,
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
 WHERE   s."lab_date_type" > 0
         AND TRUNC (sl."due_date") >= TO_CHAR (SYSDATE - 30, 'dd-MON-yyyy');

COMMENT ON MATERIALIZED VIEW GKDW.RMS_POD_LABS_MV IS 'snapshot table for snapshot GKDW.RMS_POD_LABS_MV';

GRANT SELECT ON GKDW.RMS_POD_LABS_MV TO DWHREAD;

