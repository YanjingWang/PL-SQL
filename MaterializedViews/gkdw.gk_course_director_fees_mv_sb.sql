DROP MATERIALIZED VIEW GKDW.GK_COURSE_DIRECTOR_FEES_MV_SB;
CREATE MATERIALIZED VIEW GKDW.GK_COURSE_DIRECTOR_FEES_MV_SB 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
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
/* Formatted on 29/01/2021 12:25:39 (QP5 v5.115.810.9015) */
SELECT   p."us_code" prod_code,
         plm."mode" prod_mod,
         pmm."slx_id" course_id,
         p."description" prod_name,
         p."product_code" short_name,
         pla."area" prod_line,
         cf."fee_type" fee_type,
         cf."status" fee_status,
         cf."content_type" content_type,
         cf."payment_unit" payment_unit,
         TO_NUMBER (cf."rate_amount") fee_rate,
         TO_NUMBER (cf."cisco_dur_days") cisco_dur_days,
         cf."dw_auth_code" dw_auth_code,
         cf."from_date" from_date,
         cf."to_date" TO_DATE,
         v."oracle_supplier_num" vendor_num,
         v."vendor_name" vendor_name,
         v."payment_currency" payment_curr,
         v."vendor_site_code" vendor_site_code,
         v."primary_poc_name" primary_poc,
         v."primary_poc_email" primary_poc_email,
         pmg."name" product_manager,
         pmg."product_manager_email" pm_email
  FROM                        "course_fee"@rms_prod cf
                           INNER JOIN
                              "vendor_data"@rms_prod v
                           ON cf."vendor" = v."vendor"
                        INNER JOIN
                           "product_modality_mode"@rms_prod pmm
                        ON cf."product_modality_mode" = pmm."id"
                     INNER JOIN
                        "product_line_mode"@rms_prod plm
                     ON pmm."product_line_mode" = plm."id"
                  INNER JOIN
                     "product"@rms_prod p
                  ON cf."product" = p."id"
               LEFT JOIN
                  "product_product_line_area"@rms_prod ppla
               ON p."id" = ppla."product"
            LEFT JOIN
               "product_line_area"@rms_prod pla
            ON ppla."product_line_area" = pla."id"
         LEFT JOIN
            "product_manager"@rms_prod pmg
         ON p."product_manager" = pmg."id"
 WHERE   cf."fee_type" IN
               ('Course Director Fee',
                'Vendor Royalty Fee',
                'Derivative Works',
                'Misc Fee',
                'Courseware',
                'Courseware Bundle',
                'Labs',
                'Vouchers',
                'Reseller Fee');

COMMENT ON MATERIALIZED VIEW GKDW.GK_COURSE_DIRECTOR_FEES_MV_SB IS 'snapshot table for snapshot GKDW.GK_COURSE_DIRECTOR_FEES_MV_SB';

