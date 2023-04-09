DROP MATERIALIZED VIEW GKDW.GK_FACILITY_REGION_MV;
CREATE MATERIALIZED VIEW GKDW.GK_FACILITY_REGION_MV 
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
/* Formatted on 29/01/2021 12:25:04 (QP5 v5.115.810.9015) */
SELECT   DISTINCT e.facilityregionmetro,
                  f.evxfacilityid,
                  f.facilitycode,
                  f.facilitycity,
                  a.postalcode,
                  CASE
                     WHEN UPPER (a.country) = 'CANADA' THEN 'Canada'
                     WHEN e.facilityregionmetro = 'VCL' THEN 'VCL'
                     ELSE md.region
                  END
                     region
  FROM            slxdw.evxevent e
               INNER JOIN
                  slxdw.evxfacility f
               ON e.evxfacilityid = f.evxfacilityid
            INNER JOIN
               slxdw.address a
            ON f.facilityaddressid = a.addressid
         LEFT OUTER JOIN
            market_dim md
         ON CASE
               WHEN a.postalcode LIKE '%-%'
               THEN
                  SUBSTR (a.postalcode, 1, INSTR (a.postalcode, '-') - 1)
               ELSE
                  a.postalcode
            END = md.zipcode
 WHERE   e.facilityregionmetro IS NOT NULL;

COMMENT ON MATERIALIZED VIEW GKDW.GK_FACILITY_REGION_MV IS 'snapshot table for snapshot GKDW.GK_FACILITY_REGION_MV';

GRANT SELECT ON GKDW.GK_FACILITY_REGION_MV TO DWHREAD;

