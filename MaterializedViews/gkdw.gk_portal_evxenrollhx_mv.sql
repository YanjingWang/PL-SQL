DROP MATERIALIZED VIEW GKDW.GK_PORTAL_EVXENROLLHX_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PORTAL_EVXENROLLHX_MV 
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
/* Formatted on 29/01/2021 12:23:23 (QP5 v5.115.810.9015) */
SELECT   * FROM gk_portal_enroll_v@slx;

COMMENT ON MATERIALIZED VIEW GKDW.GK_PORTAL_EVXENROLLHX_MV IS 'snapshot table for snapshot GKDW.GK_PORTAL_EVXENROLLHX_MV';

GRANT SELECT ON GKDW.GK_PORTAL_EVXENROLLHX_MV TO DWHREAD;
