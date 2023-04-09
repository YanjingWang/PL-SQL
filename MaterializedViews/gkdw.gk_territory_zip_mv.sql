DROP MATERIALIZED VIEW GKDW.GK_TERRITORY_ZIP_MV;
CREATE MATERIALIZED VIEW GKDW.GK_TERRITORY_ZIP_MV 
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
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:21:36 (QP5 v5.115.810.9015) */
  SELECT   LPAD (territory_id, 2, '0') terr_id,
           salesrep,
           SUBSTR (cd.zipcode, 1, 5) zip_code,
           zip_start,
           zip_end,
           region,
           region_mgr,
           COUNT (DISTINCT cust_id) lead_cnt
    FROM      gk_territory t
           INNER JOIN
              cust_dim cd
           ON cd.zipcode BETWEEN t.zip_start AND t.zip_end
   WHERE   territory_type = 'OB'
GROUP BY   LPAD (territory_id, 2, '0'),
           salesrep,
           SUBSTR (cd.zipcode, 1, 5),
           zip_start,
           zip_end,
           region,
           region_mgr;

COMMENT ON MATERIALIZED VIEW GKDW.GK_TERRITORY_ZIP_MV IS 'snapshot table for snapshot GKDW.GK_TERRITORY_ZIP_MV';

GRANT SELECT ON GKDW.GK_TERRITORY_ZIP_MV TO DWHREAD;

