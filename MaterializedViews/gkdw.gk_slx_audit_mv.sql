DROP MATERIALIZED VIEW GKDW.GK_SLX_AUDIT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SLX_AUDIT_MV 
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
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:22:22 (QP5 v5.115.810.9015) */
SELECT   * FROM GK_SALESLOGIX_AUDIT_V;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SLX_AUDIT_MV IS 'snapshot table for snapshot GKDW.GK_SLX_AUDIT_MV';

GRANT SELECT ON GKDW.GK_SLX_AUDIT_MV TO DWHREAD;

