DROP MATERIALIZED VIEW GKDW.RMS_INST_USAGE_MV;
CREATE MATERIALIZED VIEW GKDW.RMS_INST_USAGE_MV 
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
/* Formatted on 29/01/2021 12:19:53 (QP5 v5.115.810.9015) */
SELECT   DISTINCT s."slx_id" event_id,
                  f."slx_contact_id" inst_id,
                  vt."art" sched_desc,
                  s."start" start_date,
                  s."end" end_date,
                  vt."short_art" inst_type,
                  v."comment" sched_comment,
                  v."long_comment" long_comment
  FROM   "date_value_type"@rms_prod vt,
         "gk_date_value_v"@rms_prod v,
         "schedule"@rms_prod s,
         "instructor_func"@rms_prod f
 WHERE       v."art" = vt."id"
         AND v."instructor" = f."id"
         AND v."schedule" = s."id"(+);

COMMENT ON MATERIALIZED VIEW GKDW.RMS_INST_USAGE_MV IS 'snapshot table for snapshot GKDW.RMS_INST_USAGE_MV';

GRANT SELECT ON GKDW.RMS_INST_USAGE_MV TO DWHREAD;

