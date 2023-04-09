DROP MATERIALIZED VIEW GKDW.GK_INST_UNAVAILABLE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_INST_UNAVAILABLE_MV 
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
/* Formatted on 29/01/2021 12:24:32 (QP5 v5.115.810.9015) */
SELECT   DISTINCT
         cd.cust_id instructor_id,
         vt."art" inst_desc,
         s."slx_id" event_id,
         s."start" start_date,
         s."end" end_date,
         td1.dim_year || '-' || LPAD (td1.dim_week, 2, '0') start_week,
         td2.dim_year || '-' || LPAD (td2.dim_week, 2, '0') end_week
  FROM   rmsdw.rms_instructor ri,
         cust_dim cd,
         "date_value"@rms_prod v,
         "date_value_type"@rms_prod vt,
         "schedule"@rms_prod s,
         time_dim td1,
         time_dim td2
 WHERE       ri.slx_contact_id = cd.cust_id
         AND ri.rms_instructor_id = v."instructor"
         AND v."art" = vt."id"
         AND v."schedule" = s."id"
         AND s."start" = td1.dim_date
         AND s."end" = td2.dim_date
         AND td1.dim_year >= 2007;

COMMENT ON MATERIALIZED VIEW GKDW.GK_INST_UNAVAILABLE_MV IS 'snapshot table for snapshot GKDW.GK_INST_UNAVAILABLE_MV';

GRANT SELECT ON GKDW.GK_INST_UNAVAILABLE_MV TO DWHREAD;

