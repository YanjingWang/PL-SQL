DROP VIEW GKDW.GK_CBSA_V;

/* Formatted on 29/01/2021 11:41:47 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CBSA_V
(
   ZIPCODE,
   CSA_CODE,
   CSA_NAME,
   CBSA_CODE,
   CBSA_NAME,
   CBSA_TYPE,
   DIV_CODE,
   DIV_NAME,
   COUNTY_FIPS,
   CBSA_NAME_RPT,
   TERRITORY_ID,
   SALESREP,
   REGION
)
AS
   SELECT   DISTINCT
            c.*,
            CASE
               WHEN o.area_name IS NULL THEN c.cbsa_name
               ELSE o.area_name
            END
               cbsa_name_rpt,
            t.territory_id,
            salesrep,
            region
     FROM         gk_cbsa c
               LEFT OUTER JOIN
                  gk_occ_mv o
               ON c.cbsa_code = o.area_number
            LEFT OUTER JOIN
               gk_territory t
            ON c.zipcode BETWEEN t.zip_start AND t.zip_end
               AND territory_type = 'OB';


