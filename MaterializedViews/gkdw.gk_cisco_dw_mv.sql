DROP MATERIALIZED VIEW GKDW.GK_CISCO_DW_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CISCO_DW_MV 
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
REFRESH FORCE
START WITH TO_DATE('29-Jan-2021 07:58:45','dd-mon-yyyy hh24:mi:ss')
NEXT SYSDATE+1/24    
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:26:01 (QP5 v5.115.810.9015) */
SELECT   p."us_code" prod_code,
         plm."mode" prod_mod,
         pmm."slx_id" course_id,
         p."description" prod_name,
         p."product_code" short_name,
         cf."fee_type" fee_type,
         cf."status" fee_status,
         cf."content_type" content_type,
         cf."payment_unit" payment_unit,
         TO_NUMBER (cf."rate_amount") fee_rate,
         TO_NUMBER (cf."cisco_dur_days") cisco_dur_days,
         cf."dw_auth_code" dw_auth_code,
         cf."from_date" from_date,
         cf."to_date" TO_DATE
  FROM            "course_fee"@rms_prod cf
               INNER JOIN
                  "product_modality_mode"@rms_prod pmm
               ON cf."product_modality_mode" = pmm."id"
            INNER JOIN
               "product_line_mode"@rms_prod plm
            ON pmm."product_line_mode" = plm."id"
         INNER JOIN
            "product"@rms_prod p
         ON cf."product" = p."id"
 WHERE   cf."fee_type" = 'Derivative Works';

COMMENT ON MATERIALIZED VIEW GKDW.GK_CISCO_DW_MV IS 'snapshot table for snapshot GKDW.GK_CISCO_DW_MV';

GRANT SELECT ON GKDW.GK_CISCO_DW_MV TO DWHREAD;

