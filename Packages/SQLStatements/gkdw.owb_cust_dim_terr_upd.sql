MERGE
/*+ APPEND PARALLEL("CUST_DIM") */
INTO
  "CUST_DIM"
USING
  (SELECT
  "QG_CONTACT"."CONTACTID" "CONTACTID$1",
  "QG_CONTACT"."OB_NATIONAL_TERR_NUM" "OB_NATIONAL_TERR_NUM$1",
  "QG_CONTACT"."OB_NATIONAL_REP_ID" "OB_NATIONAL_REP_ID$2",
  "GET_USER_NAME"("QG_CONTACT"."OB_NATIONAL_REP_ID") "OB_NATIONAL_REP_ID$3",
  "QG_CONTACT"."OB_TERR_NUM" "OB_TERR_NUM$1",
  "QG_CONTACT"."OB_REP_ID" "OB_REP_ID$2",
  "GET_USER_NAME"("QG_CONTACT"."OB_REP_ID") "OB_REP_ID$3",
  "QG_CONTACT"."OSR_TERR_NUM" "OSR_TERR_NUM$1",
  "QG_CONTACT"."OSR_ID" "OSR_ID$2",
  "GET_USER_NAME"("QG_CONTACT"."OSR_ID") "OSR_ID$3",
  "QG_CONTACT"."ENT_NATIONAL_TERR_NUM" "ENT_NATIONAL_TERR_NUM$1",
  "QG_CONTACT"."ENT_NATIONAL_REP_ID" "ENT_NATIONAL_REP_ID$2",
  "GET_USER_NAME"("QG_CONTACT"."ENT_NATIONAL_REP_ID") "ENT_NATIONAL_REP_ID$3",
  "QG_CONTACT"."ENT_INSIDE_TERR_NUM" "ENT_INSIDE_TERR_NUM$1",
  "QG_CONTACT"."ENT_INSIDE_REP_ID" "ENT_INSIDE_REP_ID$2",
  "GET_USER_NAME"("QG_CONTACT"."ENT_INSIDE_REP_ID") "ENT_INSIDE_REP_ID$3",
  "QG_CONTACT"."ENT_FEDERAL_TERR_NUM" "ENT_FEDERAL_TERR_NUM$1",
  "QG_CONTACT"."ENT_FEDERAL_REP_ID" "ENT_FEDERAL_REP_ID$2",
  "GET_ORA_TRX_NUM"("QG_CONTACT"."ENT_FEDERAL_REP_ID") "ENT_FEDERAL_REP_ID$3",
  "QG_CONTACT"."BTSR_TERR_NUM" "BTSR_TERR_NUM$2",
  "QG_CONTACT"."BTSR_REP_ID" "BTSR_REP_ID$1",
  "GET_USER_NAME"("QG_CONTACT"."BTSR_TERR_NUM") "BTSR_TERR_NUM$3",
  "QG_CONTACT"."BTA_TERR_NUM" "BTA_TERR_NUM$2",
  "QG_CONTACT"."BTA_REP_ID" "BTA_REP_ID$1",
  "GET_USER_NAME"("QG_CONTACT"."BTA_TERR_NUM") "BTA_TERR_NUM$3"
FROM
  "SLXDW"."QG_CONTACT" "QG_CONTACT"
  WHERE 
  ( "QG_CONTACT"."CREATEDATE" >= "OWB_CUST_DIM_TERR_UPD"."PREMAPPING_1_CREATE_DATE_OUT" or "QG_CONTACT"."MODIFYDATE" >= "OWB_CUST_DIM_TERR_UPD"."PREMAPPING_2_MODIFY_DATE_OUT" )
  )
    MERGE_SUBQUERY
ON (
  "CUST_DIM"."CUST_ID" = "MERGE_SUBQUERY"."CONTACTID$1"
   )
  
  WHEN MATCHED THEN
    UPDATE
    SET
                  "OB_NATIONAL_TERR_NUM" = "MERGE_SUBQUERY"."OB_NATIONAL_TERR_NUM$1",
  "OB_NATIONAL_REP_ID" = "MERGE_SUBQUERY"."OB_NATIONAL_REP_ID$2",
  "OB_NATIONAL_REP_NAME" = "MERGE_SUBQUERY"."OB_NATIONAL_REP_ID$3",
  "OB_TERR_NUM" = "MERGE_SUBQUERY"."OB_TERR_NUM$1",
  "OB_REP_ID" = "MERGE_SUBQUERY"."OB_REP_ID$2",
  "OB_REP_NAME" = "MERGE_SUBQUERY"."OB_REP_ID$3",
  "OSR_TERR_NUM" = "MERGE_SUBQUERY"."OSR_TERR_NUM$1",
  "OSR_ID" = "MERGE_SUBQUERY"."OSR_ID$2",
  "OSR_REP_NAME" = "MERGE_SUBQUERY"."OSR_ID$3",
  "ENT_NATIONAL_TERR_NUM" = "MERGE_SUBQUERY"."ENT_NATIONAL_TERR_NUM$1",
  "ENT_NATIONAL_REP_ID" = "MERGE_SUBQUERY"."ENT_NATIONAL_REP_ID$2",
  "ENT_NATIONAL_REP_NAME" = "MERGE_SUBQUERY"."ENT_NATIONAL_REP_ID$3",
  "ENT_INSIDE_TERR_NUM" = "MERGE_SUBQUERY"."ENT_INSIDE_TERR_NUM$1",
  "ENT_INSIDE_REP_ID" = "MERGE_SUBQUERY"."ENT_INSIDE_REP_ID$2",
  "ENT_INSIDE_REP_NAME" = "MERGE_SUBQUERY"."ENT_INSIDE_REP_ID$3",
  "ENT_FEDERAL_TERR_NUM" = "MERGE_SUBQUERY"."ENT_FEDERAL_TERR_NUM$1",
  "ENT_FEDERAL_REP_ID" = "MERGE_SUBQUERY"."ENT_FEDERAL_REP_ID$2",
  "ENT_FEDERAL_REP_NAME" = "MERGE_SUBQUERY"."ENT_FEDERAL_REP_ID$3",
  "BTSR_TERR_NUM" = "MERGE_SUBQUERY"."BTSR_TERR_NUM$2",
  "BTSR_REP_ID" = "MERGE_SUBQUERY"."BTSR_REP_ID$1",
  "BTSR_REP_NAME" = "MERGE_SUBQUERY"."BTSR_TERR_NUM$3",
  "BTA_TERR_NUM" = "MERGE_SUBQUERY"."BTA_TERR_NUM$2",
  "BTA_REP_ID" = "MERGE_SUBQUERY"."BTA_REP_ID$1",
  "BTA_REP_NAME" = "MERGE_SUBQUERY"."BTA_TERR_NUM$3"
       
  ;
