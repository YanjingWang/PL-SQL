DROP MATERIALIZED VIEW GKDW.GK_SALES_OB_REP_LOOKUP_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SALES_OB_REP_LOOKUP_MV 
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
/* Formatted on 29/01/2021 12:22:36 (QP5 v5.115.810.9015) */
SELECT   INITCAP (TRIM (SALES_REP)) sales_ob_rep, 'field' rep_type
  FROM   GK_ACCOUNT_SEGMENT_LOOKUP_MV
 WHERE   sales_rep IS NOT NULL
UNION
SELECT   INITCAP (TRIM (OB_REP)) sales_ob_rep, 'inside' rep_type
  FROM   GK_ACCOUNT_SEGMENT_LOOKUP_MV
 WHERE   ob_rep IS NOT NULL;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SALES_OB_REP_LOOKUP_MV IS 'snapshot table for snapshot GKDW.GK_SALES_OB_REP_lOOKUP_MV';

GRANT SELECT ON GKDW.GK_SALES_OB_REP_LOOKUP_MV TO DWHREAD;
