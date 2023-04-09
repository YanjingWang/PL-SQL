DROP VIEW GKDW.GK_COURSE_PRICE_HISTORY;

/* Formatted on 29/01/2021 11:39:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_PRICE_HISTORY
(
   "id",
   "changed",
   "product_country",
   COUNTRY,
   "product",
   COURSE_CODE,
   "price",
   "currency",
   "valid_from",
   SLX_COURSEFEEID,
   "product_line_mode",
   "price_type",
   "name",
   "unitofmeasure"
)
AS
     SELECT   pcp."id",
              pcp."changed",
              pcp."product_country",
              DECODE (pc."country",
                      'CA',
                      'CANADA',
                      'US',
                      'USA')
                 country,
              pc."product",
              p."us_code" || plm."mode" course_code,
              --     pmm."slx_id" slx_course_id,
              pcp."price",
              pcp."currency",
              pcp."valid_from",
              pcp."slx_id" slx_coursefeeid,
              pcp."product_line_mode",                          -- plm."mode",
              pcp."price_type",
              pt."name",
              pt."unitofmeasure"
       FROM   "product_country_price"@rms_prod pcp,
              "price_type"@rms_prod pt,
              "product_line_mode"@rms_prod plm,
              "product_country"@rms_prod pc,
              "product"@rms_prod p
      --"product_modality_mode"@rms_prod pmm,
      WHERE       pcp."price_type" = pt."id"(+)
              AND pcp."product_line_mode" = plm."id"(+)
              AND pcp."product_country" = pc."id"(+)
              AND pc."product" = p."id"(+)
   --and p."us_code"||plm."mode" =  cd.COURSE_CODE -- and decode(pc."country", 'CA', 'CANADA', 'US', 'USA') = cd.COUNTRY
   ORDER BY   pc."product",
              p."us_code" || plm."mode",
              pcp."product_country",
              pcp."price_type",
              pcp."valid_from" DESC;


