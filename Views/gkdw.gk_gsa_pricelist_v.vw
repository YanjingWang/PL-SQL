DROP VIEW GKDW.GK_GSA_PRICELIST_V;

/* Formatted on 29/01/2021 11:35:25 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GSA_PRICELIST_V
(
   ID,
   PRODUCT_COUNTRY,
   PRODUCT_LINE_MODE,
   PRICE_TYPE,
   PRICE
)
AS
   SELECT   pcp1."id" id,
            pcp1."product_country" product_country,
            pcp1."product_line_mode" product_line_mode,
            pcp1."price_type" price_type,
            pcp1."price" price
     FROM   "product_country_price"@rms_prod pcp1
    WHERE   pcp1."price_type" = 29
            AND pcp1."id" IN
                     (SELECT   MAX (pcp."id")
                        FROM   "product_country_price"@rms_prod pcp
                       WHERE   pcp."product_country" = pcp1."product_country"
                               AND pcp."product_line_mode" =
                                     pcp1."product_line_mode"
                               AND pcp."price_type" = pcp1."price_type");


