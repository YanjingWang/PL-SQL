DROP MATERIALIZED VIEW GKDW.GK_CBSA_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CBSA_MV 
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
/* Formatted on 29/01/2021 12:26:22 (QP5 v5.115.810.9015) */
SELECT   DISTINCT
         c.*,
         CASE
            WHEN o.area_name = 'Durham, NC'
            THEN
               'Raleigh-Cary-Durham, NC'
            WHEN o.area_name = 'Raleigh-Cary, NC'
            THEN
               'Raleigh-Cary-Durham, NC'
            WHEN o.area_name IS NULL
            THEN
               c.cbsa_name
            ELSE
               o.area_name
         END
            cbsa_name_rpt
  FROM      gk_cbsa c
         LEFT OUTER JOIN
            gk_occ_mv o
         ON c.cbsa_code = o.area_number;

COMMENT ON MATERIALIZED VIEW GKDW.GK_CBSA_MV IS 'snapshot table for snapshot GKDW.GK_CBSA_MV';

GRANT SELECT ON GKDW.GK_CBSA_MV TO DWHREAD;

