DROP MATERIALIZED VIEW GKDW.GK_CDW_CURR_AUTH_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CDW_CURR_AUTH_MV 
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
START WITH TO_DATE('29-Jan-2021 07:43:44','dd-mon-yyyy hh24:mi:ss')
NEXT SYSDATE+1/24    
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:26:16 (QP5 v5.115.810.9015) */
  SELECT   p."us_code" prod_code,
           plm."mode" prod_mod,
           pmm."slx_id" course_id,
           MAX (cf."to_date") TO_DATE
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
   WHERE   cf."fee_type" = 'Derivative Works'
GROUP BY   p."us_code", plm."mode", pmm."slx_id";

COMMENT ON MATERIALIZED VIEW GKDW.GK_CDW_CURR_AUTH_MV IS 'snapshot table for snapshot GKDW.GK_CDW_CURR_AUTH_MV';

GRANT SELECT ON GKDW.GK_CDW_CURR_AUTH_MV TO DWHREAD;

