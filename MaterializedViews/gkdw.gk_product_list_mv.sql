DROP MATERIALIZED VIEW GKDW.GK_PRODUCT_LIST_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PRODUCT_LIST_MV 
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
/* Formatted on 29/01/2021 12:23:12 (QP5 v5.115.810.9015) */
SELECT   DISTINCT "PRODUCT_ID" product_id,
                  "PRODUCT_MODE" product_mode,
                  "PRODUCT_CATEGORY" product_category,
                  "VENDOR_NAME" vendor_name,
                  "PRODUCT_LINE" product_line,
                  "COURSE_TITLE" course_title,
                  "SHORT_TITLE" short_title,
                  "PRODUCT_CODE" product_code,
                  "LOB" lob,
                  "PRODUCT_MANAGER" product_manager,
                  "ROOT_CODE" root_code,
                  "TECH_TYPE" tech_type,
                  "SUBTECH_TYPE1" subtech_type1,
                  "SUBTECH_TYPE2" subtech_type2,
                  "MODALITY" modality,
                  "MODALITY_DESC" modality_desc,
                  "MODALITY_STATUS" modality_status,
                  "MFG_COURSE_CODE" mfg_course_code,
                  "DURATION" duration,
                  "DURATION_HOURS" duration_hours,
                  "DURATION_UNIT" duration_unit,
                  "PARTNERCODE" partnercode,
                  "category" category,
                  "START_TIME" start_time,
                  "END_TIME" end_time,
                  "MIN_STUDENT" min_student,
                  "MAX_STUDENT" max_student,
                  "HARD_CAP" hard_cap,
                  "BOOK_SUPPLIER" book_supplier,
                  "ROSTER_SUPPLIER" toster_supplier,
                  "CERT_SUPPLIER" cert_supplier,
                  "EVAL_SUPPLIER" eval_supplier,
                  "LAB_REQUEST" lab_request,
                  "REMOTE_LAB_PROVIDER" remote_lab_provider,
                  "AUDIO_OPTION" audio_option,
                  "VIRTUAL_PLATFORM" virtual_platform,
                  "PC_PROVIDER" pc_provider,
                  "STUDENT_PC_RATIO" student_pc_ratio,
                  "PC_REQUIREMENTS" pc_requirements,
                  "DERAVATIVE_WORKS" deravative_works,
                  "COURSEWARE_DELIVERY_TYPE" courseware_delivery_type,
                  "INTERNET_ACCESS" internet_access,
                  "BANDWIDTH" bandwidth,
                  "SPECIAL_SETUP" special_setup,
                  "C_PLUS_V_READY" c_plus_v_ready,
                  "C_PLUS_V_MAX_CAP" c_plus_v_max_cap,
                  "INSTRUCTOR_REQUEST" instructor_request,
                  "VOUCHER_TESTING" voucher_testing,
                  "INSTRUCTOR_QUALIFICATIONS" instructor_qualifications,
                  "MCMASTERS_ELIGIBLE" mcmasterts_eligible,
                  "SLX_COURSE_ID" six_course_id,
                  "IBM_TECH_GROUP" ibm_tech_group,
                  "INACTIVE_REASON" inactive_reason,
                  pct."price",
                  pct."currency",
                  pct."publish_to_web" AS PUBLISH_TO_WEB,
                  pct."price_comment" AS CAP,
                  pt."name" AS PRICE_TYPE,
                  pl."DISCOUNT_ELIGIBLE_FLAG" AS DISCOUNT_ELIGIBLE_FLAG
  FROM               "gk_product_list"@rms_prod pl
                  LEFT JOIN
                     "product_country"@rms_prod pc
                  ON pl."PRODUCT_ID" = pc."product"
               LEFT JOIN
                  "product_country_mode"@rms_prod pcm
               ON pcm."product_country" = pc."id"
                  AND pcm."product_line_mode" = pl."PRODUCT_MODE"
            LEFT JOIN
               "product_country_price"@rms_prod pct
            ON pct."product_country" = pc."id"
               AND pct."product_line_mode" = pl."PRODUCT_MODE"
         LEFT JOIN
            "price_type"@rms_prod pt
         ON pt."id" = pct."price_type"
 WHERE   pct."valid_from" =
            (SELECT   MAX ("valid_from")
               FROM   "product_country_price"@rms_prod pcv
              WHERE       pcv."product_country" = pc."id"
                      AND pcv."product_line_mode" = pl."PRODUCT_MODE"
                      AND pcv."price_type" = pt."id"
                      AND pcv."valid_from" <= TRUNC (SYSDATE));

COMMENT ON MATERIALIZED VIEW GKDW.GK_PRODUCT_LIST_MV IS 'snapshot table for snapshot GKDW.GK_PRODUCT_LIST_MV';

GRANT SELECT ON GKDW.GK_PRODUCT_LIST_MV TO DWHREAD;

