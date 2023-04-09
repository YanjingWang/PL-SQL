DROP PACKAGE BODY GKDW.OWB_ACCOUNT_DIM_NEW_SB;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_ACCOUNT_DIM_NEW_SB" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "FLTR_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c" IS
  SELECT
  "ACCOUNT"."ACCOUNTID" "ACCOUNTID",
  "ACCOUNT"."ACCOUNT" "ACCOUNT",
  "ADDRESS"."COUNTY" "COUNTY",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."ADDRESS3" "ADDRESS3",
  "ADDRESS"."CITY" "CITY",
  "ADDRESS"."COUNTRY" "COUNTRY",
  "ADDRESS"."STATE" "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  "ACCOUNT"."CREATEDATE" "CREATEDATE",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE",
  "ACCOUNT"."INDUSTRY" "INDUSTRY"
FROM
    "SLXDW"."ACCOUNT"  "ACCOUNT"   
 LEFT OUTER JOIN   "SLXDW"."ADDRESS"  "ADDRESS" ON ( ( ( "ADDRESS"."ADDRESSID" = "ACCOUNT"."ADDRESSID" ) ) )
  WHERE 
  (  accountid='AGKSQ1099520' ); 

---------------------------------------------------------------------------
--
-- "FLTR_c$1" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c$1" IS
  SELECT
  "ACCOUNT"."ACCOUNTID" "ACCOUNTID$1",
  UPPER(TRIM( "ACCOUNT"."ACCOUNT" ))/* EXPR.OUTGRP1.ACCOUNT_NAME */ "ACCOUNT_NAME",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."ADDRESS3" "ADDRESS3",
  "ADDRESS"."CITY" "CITY",
  case upper(trim("ADDRESS"."COUNTRY"))
when 'CANADA' 
then null 
when 'CAN' 
then null 
else "ADDRESS"."STATE"  
end/* EXPR_1.OUTGRP1.STATE */ "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  case upper(trim("ADDRESS"."COUNTRY" ))  when 'CANADA'  then   "ADDRESS"."STATE"   when 'CAN'  then "ADDRESS"."STATE"   else null  end/* EXPR_1.OUTGRP1.PROVINCE */ "PROVINCE",
  UPPER( TRIM( "ADDRESS"."COUNTRY" ) )/* EXPR_1.OUTGRP1.COUNTRY */ "COUNTRY",
  UPPER(TRIM( "ADDRESS"."COUNTY"  ))/* EXPR.OUTGRP1.COUNTY */ "COUNTY",
  "ACCOUNT"."CREATEDATE" "CREATEDATE$1",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE$1",
  "ACCOUNT"."INDUSTRY" "INDUSTRY$1",
  "GET_NATL_TERR_ID"("ACCOUNT"."ACCOUNTID") "ACCOUNTID$2"
FROM
    "SLXDW"."ACCOUNT"  "ACCOUNT"   
 LEFT OUTER JOIN   "SLXDW"."ADDRESS"  "ADDRESS" ON ( ( ( "ADDRESS"."ADDRESSID" = "ACCOUNT"."ADDRESSID" ) ) )
  WHERE 
  (  accountid='AGKSQ1099520'); 


a_table_to_analyze a_table_to_analyze_type;


PROCEDURE EXEC_AUTONOMOUS_SQL(CMD IN VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  EXECUTE IMMEDIATE (CMD);
  COMMIT;
END;

-- Access functions for user-defined variables via mapping Variable components,
--            and package global storage for user-defined mapping input parameters
FUNCTION "GET_CONST_0_TABLE_NAME" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_0_TABLE_NAME";
END "GET_CONST_0_TABLE_NAME";
FUNCTION "GET_CONST_1_SOURCE" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_1_SOURCE";
END "GET_CONST_1_SOURCE";
FUNCTION "get_PREMAPPING_1_CREATE_DATE_O" RETURN DATE IS
BEGIN
  RETURN "PREMAPPING_1_CREATE_DATE_OUT";
END "get_PREMAPPING_1_CREATE_DATE_O";
FUNCTION "get_PREMAPPING_2_MODIFY_DATE_O" RETURN DATE IS
BEGIN
  RETURN "PREMAPPING_2_MODIFY_DATE_OUT";
END "get_PREMAPPING_2_MODIFY_DATE_O";



---------------------------------------------------------------------------
-- Function "ACCOUNT_DIM_Bat"
--   performs batch extraction
--   Returns TRUE on success
--   Returns FALSE on failure
---------------------------------------------------------------------------
FUNCTION "ACCOUNT_DIM_Bat"
 RETURN BOOLEAN IS
  batch_selected        NUMBER(22) := 0;
  batch_errors          NUMBER(22) := 0;
  batch_inserted        NUMBER(22) := 0;
  batch_merged          NUMBER(22) := 0;
  batch_action          VARCHAR2(20);
  actual_owner          VARCHAR2(30);
  actual_name           VARCHAR2(30);
  num_fk_err            NUMBER(22);
  l_rowkey              NUMBER(22) := 0;
  l_table               VARCHAR2(30) := 'CREATE';
  l_rowid               ROWID;
  l_owner               VARCHAR2(30);
  l_tablename           VARCHAR2(30);
  l_constraint          VARCHAR2(30);
  sql_excp_stmt         VARCHAR2(32767);
  batch_exception       BOOLEAN := FALSE;
  get_map_num_rows      NUMBER(22) := 0;
  TYPE exceptionsCurType IS REF CURSOR;
  exceptions_cursor     exceptionsCurType;
  batch_auditd_id       NUMBER(22) := 0;

BEGIN
  IF get_abort THEN
    RETURN FALSE;
  END IF;
  get_abort_procedure := FALSE;
  IF NOT (get_audit_level = AUDIT_NONE) THEN
    batch_auditd_id := WB_RT_MAPAUDIT.auditd_begin(  -- Template BatchAuditDetailBegin
      p_rta=>get_runtime_audit_id,
      p_step=>0,
      p_name=>'"ACCOUNT_DIM_Bat"',
      p_source=>'*',
      p_source_uoid=>'*',
      p_target=>'"ACCOUNT_DIM"',
      p_target_uoid=>'A41FFB198D8A5678E040007F01006C7D',
      p_stm=>NULL,p_info=>NULL,
      
      p_exec_mode=>MODE_SET
    );
    get_audit_detail_id := batch_auditd_id;
  	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198D8A5678E040007F01006C7D', -- Operator ACCOUNT_DIM
    p_parent_object_name=>'ACCOUNT_DIM',
    p_parent_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'ACCOUNT_DIM',
    p_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198D5B5678E040007F01006C7D', -- Operator ACCOUNT
    p_parent_object_name=>'ACCOUNT',
    p_parent_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
    p_parent_object_type=>'Table',
    p_object_name=>'ACCOUNT',
    p_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198D5A5678E040007F01006C7D', -- Operator ADDRESS
    p_parent_object_name=>'ADDRESS',
    p_parent_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
    p_parent_object_type=>'Table',
    p_object_name=>'ADDRESS',
    p_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198C165678E040007F01006C7D', -- Operator ACCOUNT
    p_parent_object_name=>'ACCOUNT',
    p_parent_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
    p_parent_object_type=>'Table',
    p_object_name=>'ACCOUNT',
    p_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198E375678E040007F01006C7D', -- Operator ACCOUNT_DIM
    p_parent_object_name=>'ACCOUNT_DIM',
    p_parent_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'ACCOUNT_DIM',
    p_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198EBC5678E040007F01006C7D', -- Operator ADDRESS
    p_parent_object_name=>'ADDRESS',
    p_parent_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
    p_parent_object_type=>'Table',
    p_object_name=>'ADDRESS',
    p_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
  );
    
  END IF;
  IF NOT get_use_hc AND NOT get_no_commit THEN
    COMMIT; -- commit no.26
  END IF;

  IF NOT get_use_hc AND NOT get_no_commit THEN
    IF get_enable_parallel_dml THEN
      EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    ELSE
      EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
    END IF;
  END IF;

  BEGIN
  
    IF NOT "ACCOUNT_DIM_St" THEN
    
      batch_action := 'BATCH MERGE';
batch_selected := SQL%ROWCOUNT;
MERGE
INTO
  "ACCOUNT_DIM"
USING
  (SELECT
  "ACCOUNT"."ACCOUNTID" "ACCOUNTID$3",
  UPPER(TRIM( "ACCOUNT"."ACCOUNT" ))/* EXPR.OUTGRP1.ACCOUNT_NAME */ "ACCOUNT_NAME",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."ADDRESS3" "ADDRESS3",
  "ADDRESS"."CITY" "CITY",
  case upper(trim("ADDRESS"."COUNTRY"))
when 'CANADA' 
then null 
when 'CAN' 
then null 
else "ADDRESS"."STATE"  
end/* EXPR_1.OUTGRP1.STATE */ "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  case upper(trim("ADDRESS"."COUNTRY" ))  when 'CANADA'  then   "ADDRESS"."STATE"   when 'CAN'  then "ADDRESS"."STATE"   else null  end/* EXPR_1.OUTGRP1.PROVINCE */ "PROVINCE",
  UPPER( TRIM( "ADDRESS"."COUNTRY" ) )/* EXPR_1.OUTGRP1.COUNTRY */ "COUNTRY",
  UPPER(TRIM( "ADDRESS"."COUNTY"  ))/* EXPR.OUTGRP1.COUNTY */ "COUNTY",
  "ACCOUNT"."CREATEDATE" "CREATEDATE$2",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE$2",
  "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE" "SOURCE",
  "ACCOUNT"."INDUSTRY" "INDUSTRY$2",
  "GET_NATL_TERR_ID"("ACCOUNT"."ACCOUNTID") "ACCOUNTID$4"
FROM
    "SLXDW"."ACCOUNT"  "ACCOUNT"   
 LEFT OUTER JOIN   "SLXDW"."ADDRESS"  "ADDRESS" ON ( ( ( "ADDRESS"."ADDRESSID" = "ACCOUNT"."ADDRESSID" ) ) )
  WHERE 
  ( accountid='AGKSQ1099520' )
  )
    MERGE_SUBQUERY
ON (
  "ACCOUNT_DIM"."ACCT_ID" = "MERGE_SUBQUERY"."ACCOUNTID$3"
   )
  
  WHEN MATCHED THEN
    UPDATE
    SET
                  "ACCT_NAME" = "MERGE_SUBQUERY"."ACCOUNT_NAME",
  "ADDRESS1" = "MERGE_SUBQUERY"."ADDRESS1",
  "ADDRESS2" = "MERGE_SUBQUERY"."ADDRESS2",
  "ADDRESS3" = "MERGE_SUBQUERY"."ADDRESS3",
  "CITY" = "MERGE_SUBQUERY"."CITY",
  "STATE" = "MERGE_SUBQUERY"."STATE",
  "ZIPCODE" = "MERGE_SUBQUERY"."POSTALCODE",
  "PROVINCE" = "MERGE_SUBQUERY"."PROVINCE",
  "COUNTRY" = "MERGE_SUBQUERY"."COUNTRY",
  "COUNTY" = "MERGE_SUBQUERY"."COUNTY",
  "CREATION_DATE" = "MERGE_SUBQUERY"."CREATEDATE$2",
  "LAST_UPDATE_DATE" = "MERGE_SUBQUERY"."MODIFYDATE$2",
  "GKDW_SOURCE" = "MERGE_SUBQUERY"."SOURCE",
  "SIC_CODE" = "MERGE_SUBQUERY"."INDUSTRY$2",
  "NATIONAL_TERR_ID" = "MERGE_SUBQUERY"."ACCOUNTID$4"
       
  WHEN NOT MATCHED THEN
    INSERT
      ("ACCOUNT_DIM"."ACCT_ID",
      "ACCOUNT_DIM"."ACCT_NAME",
      "ACCOUNT_DIM"."ADDRESS1",
      "ACCOUNT_DIM"."ADDRESS2",
      "ACCOUNT_DIM"."ADDRESS3",
      "ACCOUNT_DIM"."CITY",
      "ACCOUNT_DIM"."STATE",
      "ACCOUNT_DIM"."ZIPCODE",
      "ACCOUNT_DIM"."PROVINCE",
      "ACCOUNT_DIM"."COUNTRY",
      "ACCOUNT_DIM"."COUNTY",
      "ACCOUNT_DIM"."CREATION_DATE",
      "ACCOUNT_DIM"."LAST_UPDATE_DATE",
      "ACCOUNT_DIM"."GKDW_SOURCE",
      "ACCOUNT_DIM"."SIC_CODE",
      "ACCOUNT_DIM"."NATIONAL_TERR_ID")
    VALUES
      ("MERGE_SUBQUERY"."ACCOUNTID$3",
      "MERGE_SUBQUERY"."ACCOUNT_NAME",
      "MERGE_SUBQUERY"."ADDRESS1",
      "MERGE_SUBQUERY"."ADDRESS2",
      "MERGE_SUBQUERY"."ADDRESS3",
      "MERGE_SUBQUERY"."CITY",
      "MERGE_SUBQUERY"."STATE",
      "MERGE_SUBQUERY"."POSTALCODE",
      "MERGE_SUBQUERY"."PROVINCE",
      "MERGE_SUBQUERY"."COUNTRY",
      "MERGE_SUBQUERY"."COUNTY",
      "MERGE_SUBQUERY"."CREATEDATE$2",
      "MERGE_SUBQUERY"."MODIFYDATE$2",
      "MERGE_SUBQUERY"."SOURCE",
      "MERGE_SUBQUERY"."INDUSTRY$2",
      "MERGE_SUBQUERY"."ACCOUNTID$4")
  ;
batch_merged := SQL%ROWCOUNT;
batch_selected := SQL%ROWCOUNT;

      
      IF get_errors + batch_errors > get_max_errors THEN
        get_abort := TRUE;
      END IF;
      IF NOT get_use_hc AND NOT get_no_commit THEN
        COMMIT; -- commit no.5
      END IF;
    END IF;
  
  EXCEPTION WHEN OTHERS THEN
      last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
    IF NOT get_no_commit THEN
      ROLLBACK;
    END IF;
    batch_errors := batch_errors + 1;
    IF get_errors + batch_errors > get_max_errors THEN
      get_abort := TRUE;
    END IF;
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      WB_RT_MAPAUDIT.error(
        p_rta=>get_runtime_audit_id,
        p_step=>0,
        p_rtd=>batch_auditd_id,
        p_rowkey=>0,
        p_table=>'"ACCOUNT_DIM"',
        p_column=>'*',
        p_dstval=>NULL,
        p_stm=>'TRACE 37: ' || batch_action,
        p_sqlerr=>SQLCODE,
        p_sqlerrm=>SQLERRM,
        p_rowid=>NULL
      );
    END IF;
    get_errors := get_errors + batch_errors;
    get_selected := get_selected + batch_selected;
    
  
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        WB_RT_MAPAUDIT.auditd_end(
          p_rtd=>batch_auditd_id,
          p_sel=>batch_selected,
          p_ins=>NULL,
          p_upd=>NULL,
          p_del=>NULL,
          p_err=>batch_errors,
          p_dis=>NULL,  -- BatchErrorAuditDetailEnd
          p_mer=>NULL
        );
      END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.6
    END IF;
    batch_exception := TRUE;
  END;
  
  IF batch_exception THEN
    RETURN FALSE;
  END IF;
  get_inserted := get_inserted + batch_inserted;
  get_errors := get_errors + batch_errors;
  get_selected := get_selected + batch_selected;
  get_merged := get_merged + batch_merged;
  

  IF NOT (get_audit_level = AUDIT_NONE) THEN
    WB_RT_MAPAUDIT.auditd_end(
      p_rtd=>batch_auditd_id,
      p_sel=>batch_selected,
      p_ins=>batch_inserted,
      p_upd=>NULL,
      p_del=>NULL,
      p_err=>batch_errors,
      p_dis=>NULL,
      p_mer=>batch_merged, -- BatchAuditDetailEnd
      p_autotrans=>(NOT get_use_hc) 
    );
  END IF;
  IF NOT get_use_hc AND NOT get_no_commit THEN
    COMMIT; -- commit no.3
  END IF;
  RETURN TRUE;
END "ACCOUNT_DIM_Bat";



-- Procedure "FLTR_p" is the entry point for map "FLTR_p"

PROCEDURE "FLTR_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"FLTR_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB198D5B5678E040007F01006C7D,A41FFB198D5A5678E040007F01006C7D';
get_step_number            CONSTANT NUMBER(22) := 1;

cursor_exhausted           BOOLEAN := FALSE;
get_close_cursor           BOOLEAN := TRUE;
exit_loop_normal           BOOLEAN := FALSE;
exit_loop_early            BOOLEAN := FALSE;
loop_count                 NUMBER(22);

get_map_selected           NUMBER(22) := 0;
get_map_errors             NUMBER(22) := 0;
get_map_num_rows           NUMBER(22) := 0;
actual_owner               VARCHAR2(30);
actual_name                VARCHAR2(30);

-- Constraint management
num_fk_err                 NUMBER(22);
l_rowkey                   NUMBER(22) := 0;
l_table                    VARCHAR2(30) := 'CREATE';
l_rowid                    ROWID;
l_owner                    VARCHAR2(30);
l_tablename                VARCHAR2(30);
l_constraint               VARCHAR2(30);
l_exec_mode                BINARY_INTEGER := MODE_ROW;
sql_excp_stmt              VARCHAR2(32767);
TYPE exceptionsCurType IS REF CURSOR;
exceptions_cursor          exceptionsCurType;

normal_action              VARCHAR2(20);
extended_action            VARCHAR2(2000);
error_action               VARCHAR2(20);
-- The get_audit_detail_id variable has been moved to a package-level variable
-- get_audit_detail_id        NUMBER(22) := 0;
get_target_name            VARCHAR2(80);
error_column               VARCHAR2(80);
error_value                VARCHAR2(2000);
error_rowkey               NUMBER(22) := 0;

-- Scalar variables for auditing

"ACCOUNT_DIM_id" NUMBER(22) := 0;
"ACCOUNT_DIM_ins" NUMBER(22) := 0;
"ACCOUNT_DIM_upd" NUMBER(22) := 0;
"ACCOUNT_DIM_del" NUMBER(22) := 0;
"ACCOUNT_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"ACCOUNT_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"ACCOUNT_DIM_ir"  index_redirect_array;
"SV_ACCOUNT_DIM_srk" NUMBER;
"ACCOUNT_DIM_new"  BOOLEAN;
"ACCOUNT_DIM_nul"  BOOLEAN := FALSE;

-- Bulk processing
error_index                NUMBER(22);
update_bulk                WB_RT_MAPAUDIT.NUMBERLIST;
update_bulk_index          NUMBER(22) := 0;
insert_bulk_index          NUMBER(22) := 0;
last_successful_index      NUMBER(22) := 0;
feedback_bulk_limit        NUMBER(22) := 0;
get_row_status             BOOLEAN; 
dml_bsize                  NUMBER; 
row_count                  NUMBER(22);
bulk_count                 NUMBER(22);

"FLTR_si" NUMBER(22) := 0;

"FLTR_i" NUMBER(22) := 0;


"ACCOUNT_DIM_si" NUMBER(22) := 0;

"ACCOUNT_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_0_ACCOUNTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_2_ACCOUNT" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_10_COUNTY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_2_ACCOUNT_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_3_COUNTY" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_5_ADDRESS1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_6_ADDRESS2" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_18_ADDRESS3" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_7_CITY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_11_COUNTRY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_8_STATE" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_2_STATE" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_3_PROVINCE" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_4_COUNTRY" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_9_POSTALCODE" IS TABLE OF VARCHAR2(24) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_11_CREATEDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_12_MODIFYDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DUMMY_TABLE_CURSOR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_7_INDUSTRY" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_GET_NATL_TERR_ID_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_0_ACCT_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_1_ACCT_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_3_ADDRESS1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_4_ADDRESS2" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_5_ADDRESS3" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_6_CITY" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_7_STATE" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_8_ZIPCODE" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_9_PROVINCE" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_10_COUNTRY" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_11_COUNTY" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_12_CREATION_DATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT__13_LAST_UPD" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_18_GKDW_SOURCE" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_22_SIC_CODE" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT__25_NATIONAL" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_0_ACCOUNTID"  CHAR(12);
"SV_ROWKEY_FLTR"  VARCHAR2(18);
"SV_FLTR_2_ACCOUNT"  VARCHAR2(128);
"SV_ADDRESS_10_COUNTY"  VARCHAR2(32);
"SV_EXPR_2_ACCOUNT_NAME"  VARCHAR2(250);
"SV_EXPR_3_COUNTY"  VARCHAR2(50);
"SV_ADDRESS_5_ADDRESS1"  VARCHAR2(64);
"SV_ADDRESS_6_ADDRESS2"  VARCHAR2(64);
"SV_ADDRESS_18_ADDRESS3"  VARCHAR2(64);
"SV_ADDRESS_7_CITY"  VARCHAR2(32);
"SV_ADDRESS_11_COUNTRY"  VARCHAR2(32);
"SV_ADDRESS_8_STATE"  VARCHAR2(32);
"SV_EXPR_1_2_STATE"  VARCHAR2(60);
"SV_EXPR_1_3_PROVINCE"  VARCHAR2(100);
"SV_EXPR_1_4_COUNTRY"  VARCHAR2(60);
"SV_ADDRESS_9_POSTALCODE"  VARCHAR2(24);
"SV_FLTR_11_CREATEDATE"  DATE;
"SV_FLTR_12_MODIFYDATE"  DATE;
"SV_ROWKEY_DUMMY_TABLE_CURSOR"  VARCHAR2(18);
"SV_FLTR_7_INDUSTRY"  VARCHAR2(64);
"SV_GET_NATL_TERR_ID_1_VALUE"  VARCHAR2(32767);
"SV_ACCOUNT_DIM_0_ACCT_ID"  VARCHAR2(50);
"SV_ACCOUNT_DIM_1_ACCT_NAME"  VARCHAR2(250);
"SV_ACCOUNT_DIM_3_ADDRESS1"  VARCHAR2(250);
"SV_ACCOUNT_DIM_4_ADDRESS2"  VARCHAR2(250);
"SV_ACCOUNT_DIM_5_ADDRESS3"  VARCHAR2(250);
"SV_ACCOUNT_DIM_6_CITY"  VARCHAR2(250);
"SV_ACCOUNT_DIM_7_STATE"  VARCHAR2(60);
"SV_ACCOUNT_DIM_8_ZIPCODE"  VARCHAR2(60);
"SV_ACCOUNT_DIM_9_PROVINCE"  VARCHAR2(100);
"SV_ACCOUNT_DIM_10_COUNTRY"  VARCHAR2(60);
"SV_ACCOUNT_DIM_11_COUNTY"  VARCHAR2(100);
"SV_ACCOUNT_DIM_12_CREATION_DA"  DATE;
"SV_ACCOUNT__13_LAST_UPD"  DATE;
"SV_ACCOUNT_DIM_18_GKDW_SOURCE"  VARCHAR2(20);
"SV_ACCOUNT_DIM_22_SIC_CODE"  VARCHAR2(50);
"SV_ACCOUNT__25_NATIONAL"  VARCHAR2(100);

-- Bulk: intermediate collection variables
"FLTR_0_ACCOUNTID" "T_FLTR_0_ACCOUNTID";
"ROWKEY_FLTR" "T_ROWKEY_FLTR";
"FLTR_2_ACCOUNT" "T_FLTR_2_ACCOUNT";
"ADDRESS_10_COUNTY" "T_ADDRESS_10_COUNTY";
"EXPR_2_ACCOUNT_NAME" "T_EXPR_2_ACCOUNT_NAME";
"EXPR_3_COUNTY" "T_EXPR_3_COUNTY";
"ADDRESS_5_ADDRESS1" "T_ADDRESS_5_ADDRESS1";
"ADDRESS_6_ADDRESS2" "T_ADDRESS_6_ADDRESS2";
"ADDRESS_18_ADDRESS3" "T_ADDRESS_18_ADDRESS3";
"ADDRESS_7_CITY" "T_ADDRESS_7_CITY";
"ADDRESS_11_COUNTRY" "T_ADDRESS_11_COUNTRY";
"ADDRESS_8_STATE" "T_ADDRESS_8_STATE";
"EXPR_1_2_STATE" "T_EXPR_1_2_STATE";
"EXPR_1_3_PROVINCE" "T_EXPR_1_3_PROVINCE";
"EXPR_1_4_COUNTRY" "T_EXPR_1_4_COUNTRY";
"ADDRESS_9_POSTALCODE" "T_ADDRESS_9_POSTALCODE";
"FLTR_11_CREATEDATE" "T_FLTR_11_CREATEDATE";
"FLTR_12_MODIFYDATE" "T_FLTR_12_MODIFYDATE";
"ROWKEY_DUMMY_TABLE_CURSOR" "T_ROWKEY_DUMMY_TABLE_CURSOR";
"FLTR_7_INDUSTRY" "T_FLTR_7_INDUSTRY";
"GET_NATL_TERR_ID_1_VALUE" "T_GET_NATL_TERR_ID_1_VALUE";
"ACCOUNT_DIM_0_ACCT_ID" "T_ACCOUNT_DIM_0_ACCT_ID";
"ACCOUNT_DIM_1_ACCT_NAME" "T_ACCOUNT_DIM_1_ACCT_NAME";
"ACCOUNT_DIM_3_ADDRESS1" "T_ACCOUNT_DIM_3_ADDRESS1";
"ACCOUNT_DIM_4_ADDRESS2" "T_ACCOUNT_DIM_4_ADDRESS2";
"ACCOUNT_DIM_5_ADDRESS3" "T_ACCOUNT_DIM_5_ADDRESS3";
"ACCOUNT_DIM_6_CITY" "T_ACCOUNT_DIM_6_CITY";
"ACCOUNT_DIM_7_STATE" "T_ACCOUNT_DIM_7_STATE";
"ACCOUNT_DIM_8_ZIPCODE" "T_ACCOUNT_DIM_8_ZIPCODE";
"ACCOUNT_DIM_9_PROVINCE" "T_ACCOUNT_DIM_9_PROVINCE";
"ACCOUNT_DIM_10_COUNTRY" "T_ACCOUNT_DIM_10_COUNTRY";
"ACCOUNT_DIM_11_COUNTY" "T_ACCOUNT_DIM_11_COUNTY";
"ACCOUNT_DIM_12_CREATION_DATE" "T_ACCOUNT_DIM_12_CREATION_DATE";
"ACCOUNT__13_LAST_UPD" "T_ACCOUNT__13_LAST_UPD";
"ACCOUNT_DIM_18_GKDW_SOURCE" "T_ACCOUNT_DIM_18_GKDW_SOURCE";
"ACCOUNT_DIM_22_SIC_CODE" "T_ACCOUNT_DIM_22_SIC_CODE";
"ACCOUNT__25_NATIONAL" "T_ACCOUNT__25_NATIONAL";

PROCEDURE Main_ES(p_step_number IN NUMBER, p_rowkey IN NUMBER, p_table IN VARCHAR2, p_col IN VARCHAR2, p_value IN VARCHAR2 default 'VALUE DISABLED') IS
BEGIN
  get_column_seq := get_column_seq + 1;
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>p_rowkey,
    p_seq=>get_column_seq,
    p_instance=>1,
    p_table=>SUBSTR(p_table,0,80),
    p_column=>SUBSTR(p_col,0,80),
    p_value=>SUBSTRB(p_value,0,2000),
    p_step=>p_step_number,
    p_role=>'T'
  );
END;

---------------------------------------------------------------------------
-- This procedure records column values of one erroneous source row
-- into an audit trail table named WB_RT_ERROR_SOURCES.  Each column is
-- recorded by one row in the audit trail.  To collect all source column
-- values corresponding to one erroneous source row, query the audit
-- trail and specify:
--    RTA_IID, uniquely identifies one audited run,
--    RTE_ROWKEY, uniquely identifies a source row within and audited run
---------------------------------------------------------------------------
PROCEDURE "FLTR_ES"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_0_ACCOUNTID',0,80),
    p_value=>SUBSTRB("FLTR_0_ACCOUNTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_2_ACCOUNT',0,80),
    p_value=>SUBSTRB("FLTR_2_ACCOUNT"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_10_COUNTY',0,80),
    p_value=>SUBSTRB("ADDRESS_10_COUNTY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_5_ADDRESS1',0,80),
    p_value=>SUBSTRB("ADDRESS_5_ADDRESS1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_6_ADDRESS2',0,80),
    p_value=>SUBSTRB("ADDRESS_6_ADDRESS2"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_18_ADDRESS3',0,80),
    p_value=>SUBSTRB("ADDRESS_18_ADDRESS3"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_7_CITY',0,80),
    p_value=>SUBSTRB("ADDRESS_7_CITY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_11_COUNTRY',0,80),
    p_value=>SUBSTRB("ADDRESS_11_COUNTRY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_8_STATE',0,80),
    p_value=>SUBSTRB("ADDRESS_8_STATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_9_POSTALCODE',0,80),
    p_value=>SUBSTRB("ADDRESS_9_POSTALCODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_11_CREATEDATE',0,80),
    p_value=>SUBSTRB("FLTR_11_CREATEDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_12_MODIFYDATE',0,80),
    p_value=>SUBSTRB("FLTR_12_MODIFYDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_7_INDUSTRY',0,80),
    p_value=>SUBSTRB("FLTR_7_INDUSTRY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "FLTR_ES";

---------------------------------------------------------------------------
-- Procedure "FLTR_ER" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "FLTR_ER"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
l_source_target_name VARCHAR2(80);
BEGIN
  IF p_auditd_id IS NULL THEN
    l_source_target_name := SUBSTR(get_source_name,0,80);
  ELSE
    l_source_target_name := get_target_name;
  END IF;

  IF p_error_index = 0 THEN  
  get_rowkey_error := 0;
ELSE  
  get_rowkey_error := get_rowkey + p_error_index - 1;
END IF;

  IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
    WB_RT_MAPAUDIT.error(
      p_rta=>get_runtime_audit_id,
      p_step=>get_step_number,
      p_rtd=>p_auditd_id,
      p_rowkey=>get_rowkey_error,
      p_table=>l_source_target_name,
      p_column=>p_column,
      p_dstval=>p_col_value,
      p_stm=>'TRACE 38: ' || p_statement,
      p_sqlerr=>p_sqlcode,
      p_sqlerrm=>p_sqlerrm,
      p_rowid=>NULL
    );
  END IF;

  IF ( get_audit_level = AUDIT_COMPLETE ) AND (get_rowkey_error > 0) THEN
    WB_RT_MAPAUDIT.register_feedback(
      p_rta=>get_runtime_audit_id,
      p_step=>get_step_number,
      p_rowkey=>get_rowkey_error,
      p_status=>'ERROR',
      p_table=>l_source_target_name,
      p_role=>'T',
      p_action=>SUBSTR(p_statement,0,30)
    );
  END IF;

  IF ( get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE ) AND (get_rowkey_error > 0) THEN
    "FLTR_ES"(p_error_index);
  END IF;
END "FLTR_ER";



---------------------------------------------------------------------------
-- Procedure "FLTR_SU" opens and initializes data source
-- for map "FLTR_p"
---------------------------------------------------------------------------
PROCEDURE "FLTR_SU" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "FLTR_c"%ISOPEN) THEN
    OPEN "FLTR_c";
  END IF;
  get_read_success := TRUE;
END "FLTR_SU";

---------------------------------------------------------------------------
-- Procedure "FLTR_RD" fetches a bulk of rows from
--   the data source for map "FLTR_p"
---------------------------------------------------------------------------
PROCEDURE "FLTR_RD" IS
BEGIN
  IF NOT get_read_success THEN
    get_abort := TRUE;
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      WB_RT_MAPAUDIT.error(
        p_rta=>get_runtime_audit_id,
        p_step=>0,
        p_rtd=>NULL,
        p_rowkey=>0,
        p_table=>NULL,
        p_column=>NULL,
        p_dstval=>NULL,
        p_stm=>NULL,
        p_sqlerr=>-20007,
        p_sqlerrm=>'CursorFetchMapTerminationRTV20007',
        p_rowid=>NULL
      );
    END IF;
                END IF;

  IF get_abort OR get_abort_procedure THEN
    RETURN;
  END IF;

  BEGIN
    "FLTR_0_ACCOUNTID".DELETE;
    "FLTR_2_ACCOUNT".DELETE;
    "ADDRESS_10_COUNTY".DELETE;
    "ADDRESS_5_ADDRESS1".DELETE;
    "ADDRESS_6_ADDRESS2".DELETE;
    "ADDRESS_18_ADDRESS3".DELETE;
    "ADDRESS_7_CITY".DELETE;
    "ADDRESS_11_COUNTRY".DELETE;
    "ADDRESS_8_STATE".DELETE;
    "ADDRESS_9_POSTALCODE".DELETE;
    "FLTR_11_CREATEDATE".DELETE;
    "FLTR_12_MODIFYDATE".DELETE;
    "FLTR_7_INDUSTRY".DELETE;

    FETCH
      "FLTR_c"
    BULK COLLECT INTO
      "FLTR_0_ACCOUNTID",
      "FLTR_2_ACCOUNT",
      "ADDRESS_10_COUNTY",
      "ADDRESS_5_ADDRESS1",
      "ADDRESS_6_ADDRESS2",
      "ADDRESS_18_ADDRESS3",
      "ADDRESS_7_CITY",
      "ADDRESS_11_COUNTRY",
      "ADDRESS_8_STATE",
      "ADDRESS_9_POSTALCODE",
      "FLTR_11_CREATEDATE",
      "FLTR_12_MODIFYDATE",
      "FLTR_7_INDUSTRY"
    LIMIT get_bulk_size;

    IF "FLTR_c"%NOTFOUND AND "FLTR_0_ACCOUNTID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_0_ACCOUNTID".COUNT;
    END IF;
    
    IF get_audit_level = AUDIT_COMPLETE THEN
      WB_RT_MAPAUDIT.register_feedback_bulk(
        p_rta=>get_runtime_audit_id,
        p_step=>get_step_number,
        p_rowkey=>get_rowkey,
        p_status=>'NEW',
        p_table=>get_source_name,
        p_role=>'S',
        p_action=>'SELECT'
      );
    END IF;
    get_map_selected := get_map_selected + "FLTR_0_ACCOUNTID".COUNT;
  EXCEPTION
    WHEN OTHERS THEN
        last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
      get_read_success := FALSE;
      -- register error
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        one_rowkey := rowkey_counter;
        rowkey_counter := rowkey_counter + 1;
        WB_RT_MAPAUDIT.error(
          p_rta=>get_runtime_audit_id,
          p_step=>get_step_number,
          p_rtd=>NULL,
          p_rowkey=>one_rowkey,
          p_table=>get_source_name,
          p_column=>'*',
          p_dstval=>NULL,
          p_stm=>'TRACE 39: SELECT',
          p_sqlerr=>SQLCODE,
          p_sqlerrm=>SQLERRM,
          p_rowid=>NULL
        );
      END IF;
      
      -- register feedback for the erroneous row
      IF get_audit_level = AUDIT_COMPLETE THEN
        WB_RT_MAPAUDIT.register_feedback(
          p_rta=>get_runtime_audit_id,
          p_step=>get_step_number,
          p_rowkey=>one_rowkey,
          p_status=>'ERROR',
          p_table=>get_source_name,
          p_role=>'S',
          p_action=>'SELECT'
        );
      END IF;
      get_errors := get_errors + 1;
      IF get_errors > get_max_errors THEN get_abort := TRUE; END IF;
  END;
END "FLTR_RD";

---------------------------------------------------------------------------
-- Procedure "FLTR_DML" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "FLTR_DML"(si NUMBER, firstround BOOLEAN) IS
  "ACCOUNT_DIM_ins0" NUMBER := "ACCOUNT_DIM_ins";
  "ACCOUNT_DIM_upd0" NUMBER := "ACCOUNT_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "ACCOUNT_DIM_St" THEN
  -- Update/Insert DML for "ACCOUNT_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"ACCOUNT_DIM"';
    get_audit_detail_id := "ACCOUNT_DIM_id";
    "ACCOUNT_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "ACCOUNT_DIM_i" > get_bulk_size 
   OR "FLTR_c"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "ACCOUNT_DIM_si".."ACCOUNT_DIM_i" - 1 
            UPDATE
              "ACCOUNT_DIM"
            SET
  
  						"ACCOUNT_DIM"."ACCT_NAME" = "ACCOUNT_DIM_1_ACCT_NAME"
  (i),						"ACCOUNT_DIM"."ADDRESS1" = "ACCOUNT_DIM_3_ADDRESS1"
  (i),						"ACCOUNT_DIM"."ADDRESS2" = "ACCOUNT_DIM_4_ADDRESS2"
  (i),						"ACCOUNT_DIM"."ADDRESS3" = "ACCOUNT_DIM_5_ADDRESS3"
  (i),						"ACCOUNT_DIM"."CITY" = "ACCOUNT_DIM_6_CITY"
  (i),						"ACCOUNT_DIM"."STATE" = "ACCOUNT_DIM_7_STATE"
  (i),						"ACCOUNT_DIM"."ZIPCODE" = "ACCOUNT_DIM_8_ZIPCODE"
  (i),						"ACCOUNT_DIM"."PROVINCE" = "ACCOUNT_DIM_9_PROVINCE"
  (i),						"ACCOUNT_DIM"."COUNTRY" = "ACCOUNT_DIM_10_COUNTRY"
  (i),						"ACCOUNT_DIM"."COUNTY" = "ACCOUNT_DIM_11_COUNTY"
  (i),						"ACCOUNT_DIM"."CREATION_DATE" = "ACCOUNT_DIM_12_CREATION_DATE"
  (i),						"ACCOUNT_DIM"."LAST_UPDATE_DATE" = "ACCOUNT__13_LAST_UPD"
  (i),						"ACCOUNT_DIM"."GKDW_SOURCE" = "ACCOUNT_DIM_18_GKDW_SOURCE"
  (i),						"ACCOUNT_DIM"."SIC_CODE" = "ACCOUNT_DIM_22_SIC_CODE"
  (i),						"ACCOUNT_DIM"."NATIONAL_TERR_ID" = "ACCOUNT__25_NATIONAL"
  (i)
    
            WHERE
  
  						"ACCOUNT_DIM"."ACCT_ID" = "ACCOUNT_DIM_0_ACCT_ID"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "ACCOUNT_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "ACCOUNT_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "ACCOUNT_DIM_srk"(rowkey_index);
                rowkey_bulk_index := rowkey_bulk_index + 1;
              END IF;
            END IF;
          END LOOP;
          
          
IF get_audit_level = AUDIT_COMPLETE THEN
  WB_RT_MAPAUDIT.register_feedback_bulk(
    p_rta=>get_runtime_audit_id,
    p_step=>get_step_number,
    p_rowkey=>get_rowkey_bulk,
    p_status=>'NEW',
    p_table=>get_target_name,
    p_role=>'T',
    p_action=>normal_action,
    p_rowid=>get_rowid
  );
END IF;
  
          "ACCOUNT_DIM_upd" := "ACCOUNT_DIM_upd" + get_rowid.COUNT;
          "ACCOUNT_DIM_si" := "ACCOUNT_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "ACCOUNT_DIM_si".."ACCOUNT_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "ACCOUNT_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "ACCOUNT_DIM_srk"(rowkey_index);
                  rowkey_bulk_index := rowkey_bulk_index + 1;
                END IF;
              END IF;
            END LOOP;
            
            
IF get_audit_level = AUDIT_COMPLETE THEN
  WB_RT_MAPAUDIT.register_feedback_bulk(
    p_rta=>get_runtime_audit_id,
    p_step=>get_step_number,
    p_rowkey=>get_rowkey_bulk,
    p_status=>'NEW',
    p_table=>get_target_name,
    p_role=>'T',
    p_action=>normal_action,
    p_rowid=>get_rowid
  );
END IF;
            "ACCOUNT_DIM_upd" := "ACCOUNT_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "ACCOUNT_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                  "ACCOUNT_DIM"
                SET
  
  								"ACCOUNT_DIM"."ACCT_NAME" = "ACCOUNT_DIM_1_ACCT_NAME"
  (last_successful_index),								"ACCOUNT_DIM"."ADDRESS1" = "ACCOUNT_DIM_3_ADDRESS1"
  (last_successful_index),								"ACCOUNT_DIM"."ADDRESS2" = "ACCOUNT_DIM_4_ADDRESS2"
  (last_successful_index),								"ACCOUNT_DIM"."ADDRESS3" = "ACCOUNT_DIM_5_ADDRESS3"
  (last_successful_index),								"ACCOUNT_DIM"."CITY" = "ACCOUNT_DIM_6_CITY"
  (last_successful_index),								"ACCOUNT_DIM"."STATE" = "ACCOUNT_DIM_7_STATE"
  (last_successful_index),								"ACCOUNT_DIM"."ZIPCODE" = "ACCOUNT_DIM_8_ZIPCODE"
  (last_successful_index),								"ACCOUNT_DIM"."PROVINCE" = "ACCOUNT_DIM_9_PROVINCE"
  (last_successful_index),								"ACCOUNT_DIM"."COUNTRY" = "ACCOUNT_DIM_10_COUNTRY"
  (last_successful_index),								"ACCOUNT_DIM"."COUNTY" = "ACCOUNT_DIM_11_COUNTY"
  (last_successful_index),								"ACCOUNT_DIM"."CREATION_DATE" = "ACCOUNT_DIM_12_CREATION_DATE"
  (last_successful_index),								"ACCOUNT_DIM"."LAST_UPDATE_DATE" = "ACCOUNT__13_LAST_UPD"
  (last_successful_index),								"ACCOUNT_DIM"."GKDW_SOURCE" = "ACCOUNT_DIM_18_GKDW_SOURCE"
  (last_successful_index),								"ACCOUNT_DIM"."SIC_CODE" = "ACCOUNT_DIM_22_SIC_CODE"
  (last_successful_index),								"ACCOUNT_DIM"."NATIONAL_TERR_ID" = "ACCOUNT__25_NATIONAL"
  (last_successful_index)
  
                WHERE
  
  								"ACCOUNT_DIM"."ACCT_ID" = "ACCOUNT_DIM_0_ACCT_ID"
  (last_successful_index)
  
  ;
              update_bulk(update_bulk_index) := last_successful_index;
              update_bulk_index := update_bulk_index + 1;
              last_successful_index := last_successful_index + 1;
            EXCEPTION
              WHEN OTHERS THEN
                  last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  error_rowkey := "ACCOUNT_DIM_srk"(last_successful_index);
                  WB_RT_MAPAUDIT.error(
                    p_rta=>get_runtime_audit_id,
                    p_step=>get_step_number,
                    p_rtd=>get_audit_detail_id,
                    p_rowkey=>error_rowkey,
                    p_table=>get_target_name,
                    p_column=>'*',
                    p_dstval=>NULL,
                    p_stm=>'TRACE : ' || error_action,
                    p_sqlerr=>SQLCODE,
                    p_sqlerrm=>SQLERRM,
                    p_rowid=>NULL
                  );
                  get_column_seq := 0;
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ACCT_NAME"',0,80),SUBSTRB("ACCOUNT_DIM_1_ACCT_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS1"',0,80),SUBSTRB("ACCOUNT_DIM_3_ADDRESS1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS2"',0,80),SUBSTRB("ACCOUNT_DIM_4_ADDRESS2"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS3"',0,80),SUBSTRB("ACCOUNT_DIM_5_ADDRESS3"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CITY"',0,80),SUBSTRB("ACCOUNT_DIM_6_CITY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."STATE"',0,80),SUBSTRB("ACCOUNT_DIM_7_STATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ZIPCODE"',0,80),SUBSTRB("ACCOUNT_DIM_8_ZIPCODE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."PROVINCE"',0,80),SUBSTRB("ACCOUNT_DIM_9_PROVINCE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTRY"',0,80),SUBSTRB("ACCOUNT_DIM_10_COUNTRY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTY"',0,80),SUBSTRB("ACCOUNT_DIM_11_COUNTY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CREATION_DATE"',0,80),SUBSTRB("ACCOUNT_DIM_12_CREATION_DATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("ACCOUNT__13_LAST_UPD"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("ACCOUNT_DIM_18_GKDW_SOURCE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."SIC_CODE"',0,80),SUBSTRB("ACCOUNT_DIM_22_SIC_CODE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."NATIONAL_TERR_ID"',0,80),SUBSTRB("ACCOUNT__25_NATIONAL"(last_successful_index),0,2000));
                  
                END IF;
                IF get_audit_level = AUDIT_COMPLETE THEN
                  WB_RT_MAPAUDIT.register_feedback(
                    p_rta=>get_runtime_audit_id,
                    p_step=>get_step_number,
                    p_rowkey=>error_rowkey,
                    p_status=>'ERROR',
                    p_table=>get_target_name,
                    p_role=>'T',
                    p_action=>error_action
                  );
                END IF;
                "ACCOUNT_DIM_err" := "ACCOUNT_DIM_err" + 1;
                
                IF get_errors + "ACCOUNT_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "ACCOUNT_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "ACCOUNT_DIM_si" >= "ACCOUNT_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "ACCOUNT_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"ACCOUNT_DIM_0_ACCT_ID"(insert_bulk_index) := "ACCOUNT_DIM_0_ACCT_ID"(update_bulk(j));
  		"ACCOUNT_DIM_1_ACCT_NAME"(insert_bulk_index) := "ACCOUNT_DIM_1_ACCT_NAME"(update_bulk(j));
  		"ACCOUNT_DIM_3_ADDRESS1"(insert_bulk_index) := "ACCOUNT_DIM_3_ADDRESS1"(update_bulk(j));
  		"ACCOUNT_DIM_4_ADDRESS2"(insert_bulk_index) := "ACCOUNT_DIM_4_ADDRESS2"(update_bulk(j));
  		"ACCOUNT_DIM_5_ADDRESS3"(insert_bulk_index) := "ACCOUNT_DIM_5_ADDRESS3"(update_bulk(j));
  		"ACCOUNT_DIM_6_CITY"(insert_bulk_index) := "ACCOUNT_DIM_6_CITY"(update_bulk(j));
  		"ACCOUNT_DIM_7_STATE"(insert_bulk_index) := "ACCOUNT_DIM_7_STATE"(update_bulk(j));
  		"ACCOUNT_DIM_8_ZIPCODE"(insert_bulk_index) := "ACCOUNT_DIM_8_ZIPCODE"(update_bulk(j));
  		"ACCOUNT_DIM_9_PROVINCE"(insert_bulk_index) := "ACCOUNT_DIM_9_PROVINCE"(update_bulk(j));
  		"ACCOUNT_DIM_10_COUNTRY"(insert_bulk_index) := "ACCOUNT_DIM_10_COUNTRY"(update_bulk(j));
  		"ACCOUNT_DIM_11_COUNTY"(insert_bulk_index) := "ACCOUNT_DIM_11_COUNTY"(update_bulk(j));
  		"ACCOUNT_DIM_12_CREATION_DATE"(insert_bulk_index) := "ACCOUNT_DIM_12_CREATION_DATE"(update_bulk(j));
  		"ACCOUNT__13_LAST_UPD"(insert_bulk_index) := "ACCOUNT__13_LAST_UPD"(update_bulk(j));
  		"ACCOUNT_DIM_18_GKDW_SOURCE"(insert_bulk_index) := "ACCOUNT_DIM_18_GKDW_SOURCE"(update_bulk(j));
  		"ACCOUNT_DIM_22_SIC_CODE"(insert_bulk_index) := "ACCOUNT_DIM_22_SIC_CODE"(update_bulk(j));
  		"ACCOUNT__25_NATIONAL"(insert_bulk_index) := "ACCOUNT__25_NATIONAL"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "ACCOUNT_DIM_srk"(insert_bulk_index) := "ACCOUNT_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "ACCOUNT_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "ACCOUNT_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "ACCOUNT_DIM_si"..insert_bulk_index
          INSERT INTO
            "ACCOUNT_DIM"
            ("ACCOUNT_DIM"."ACCT_ID",
            "ACCOUNT_DIM"."ACCT_NAME",
            "ACCOUNT_DIM"."ADDRESS1",
            "ACCOUNT_DIM"."ADDRESS2",
            "ACCOUNT_DIM"."ADDRESS3",
            "ACCOUNT_DIM"."CITY",
            "ACCOUNT_DIM"."STATE",
            "ACCOUNT_DIM"."ZIPCODE",
            "ACCOUNT_DIM"."PROVINCE",
            "ACCOUNT_DIM"."COUNTRY",
            "ACCOUNT_DIM"."COUNTY",
            "ACCOUNT_DIM"."CREATION_DATE",
            "ACCOUNT_DIM"."LAST_UPDATE_DATE",
            "ACCOUNT_DIM"."GKDW_SOURCE",
            "ACCOUNT_DIM"."SIC_CODE",
            "ACCOUNT_DIM"."NATIONAL_TERR_ID")
          VALUES
            ("ACCOUNT_DIM_0_ACCT_ID"(i),
            "ACCOUNT_DIM_1_ACCT_NAME"(i),
            "ACCOUNT_DIM_3_ADDRESS1"(i),
            "ACCOUNT_DIM_4_ADDRESS2"(i),
            "ACCOUNT_DIM_5_ADDRESS3"(i),
            "ACCOUNT_DIM_6_CITY"(i),
            "ACCOUNT_DIM_7_STATE"(i),
            "ACCOUNT_DIM_8_ZIPCODE"(i),
            "ACCOUNT_DIM_9_PROVINCE"(i),
            "ACCOUNT_DIM_10_COUNTRY"(i),
            "ACCOUNT_DIM_11_COUNTY"(i),
            "ACCOUNT_DIM_12_CREATION_DATE"(i),
            "ACCOUNT__13_LAST_UPD"(i),
            "ACCOUNT_DIM_18_GKDW_SOURCE"(i),
            "ACCOUNT_DIM_22_SIC_CODE"(i),
            "ACCOUNT__25_NATIONAL"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "ACCOUNT_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "ACCOUNT_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "ACCOUNT_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 40: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ACCT_ID"',0,80),SUBSTRB("ACCOUNT_DIM_0_ACCT_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ACCT_NAME"',0,80),SUBSTRB("ACCOUNT_DIM_1_ACCT_NAME"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS1"',0,80),SUBSTRB("ACCOUNT_DIM_3_ADDRESS1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS2"',0,80),SUBSTRB("ACCOUNT_DIM_4_ADDRESS2"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS3"',0,80),SUBSTRB("ACCOUNT_DIM_5_ADDRESS3"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CITY"',0,80),SUBSTRB("ACCOUNT_DIM_6_CITY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."STATE"',0,80),SUBSTRB("ACCOUNT_DIM_7_STATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ZIPCODE"',0,80),SUBSTRB("ACCOUNT_DIM_8_ZIPCODE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."PROVINCE"',0,80),SUBSTRB("ACCOUNT_DIM_9_PROVINCE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTRY"',0,80),SUBSTRB("ACCOUNT_DIM_10_COUNTRY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTY"',0,80),SUBSTRB("ACCOUNT_DIM_11_COUNTY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CREATION_DATE"',0,80),SUBSTRB("ACCOUNT_DIM_12_CREATION_DATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("ACCOUNT__13_LAST_UPD"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("ACCOUNT_DIM_18_GKDW_SOURCE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."SIC_CODE"',0,80),SUBSTRB("ACCOUNT_DIM_22_SIC_CODE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."NATIONAL_TERR_ID"',0,80),SUBSTRB("ACCOUNT__25_NATIONAL"(error_index),0,2000));
            
          END IF;
          IF get_audit_level = AUDIT_COMPLETE THEN
            WB_RT_MAPAUDIT.register_feedback(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rowkey=>error_rowkey,
              p_status=>'ERROR',
              p_table=>get_target_name,
              p_role=>'T',
              p_action=>error_action
            );
          END IF;
          "ACCOUNT_DIM_err" := "ACCOUNT_DIM_err" + 1;
          
          IF get_errors + "ACCOUNT_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "ACCOUNT_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "ACCOUNT_DIM_srk"(rowkey_index);
          rowkey_bulk_index := rowkey_bulk_index + 1;
        END LOOP;
      END IF;
      
IF get_audit_level = AUDIT_COMPLETE THEN
  WB_RT_MAPAUDIT.register_feedback_bulk(
    p_rta=>get_runtime_audit_id,
    p_step=>get_step_number,
    p_rowkey=>get_rowkey_bulk,
    p_status=>'NEW',
    p_table=>get_target_name,
    p_role=>'T',
    p_action=>normal_action,
    p_rowid=>get_rowid
  );
END IF;
  
      "ACCOUNT_DIM_ins" := "ACCOUNT_DIM_ins" + get_rowid.COUNT;
      "ACCOUNT_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "ACCOUNT_DIM_ins" := "ACCOUNT_DIM_ins0"; 
    "ACCOUNT_DIM_upd" := "ACCOUNT_DIM_upd0";
  END IF;

END "FLTR_DML";

---------------------------------------------------------------------------
-- "FLTR_p" main
---------------------------------------------------------------------------

BEGIN
  IF get_abort OR get_abort_procedure THEN
    
    RETURN;
  END IF;

  
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.7
  sql_stmt := 'ALTER SESSION DISABLE PARALLEL DML';
  EXECUTE IMMEDIATE sql_stmt;
END IF;

  IF NOT "ACCOUNT_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "ACCOUNT_DIM_St" THEN
          "ACCOUNT_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"ACCOUNT_DIM"',
              p_target_uoid=>'A41FFB198D8A5678E040007F01006C7D',
              p_stm=>'TRACE 42',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "ACCOUNT_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198D8A5678E040007F01006C7D', -- Operator ACCOUNT_DIM
              p_parent_object_name=>'ACCOUNT_DIM',
              p_parent_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT_DIM',
              p_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198D5B5678E040007F01006C7D', -- Operator ACCOUNT
              p_parent_object_name=>'ACCOUNT',
              p_parent_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT',
              p_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198D5A5678E040007F01006C7D', -- Operator ADDRESS
              p_parent_object_name=>'ADDRESS',
              p_parent_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_parent_object_type=>'Table',
              p_object_name=>'ADDRESS',
              p_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198C165678E040007F01006C7D', -- Operator ACCOUNT
              p_parent_object_name=>'ACCOUNT',
              p_parent_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT',
              p_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198E375678E040007F01006C7D', -- Operator ACCOUNT_DIM
              p_parent_object_name=>'ACCOUNT_DIM',
              p_parent_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT_DIM',
              p_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198EBC5678E040007F01006C7D', -- Operator ADDRESS
              p_parent_object_name=>'ADDRESS',
              p_parent_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_parent_object_type=>'Table',
              p_object_name=>'ADDRESS',
              p_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
            );
        END IF;
        IF NOT get_no_commit THEN
          COMMIT; -- commit no.10
        END IF;
      END IF;

      

      -- Initialize buffer variables
      get_buffer_done.DELETE;
      get_buffer_done_index := 1;

    END IF; -- End if cursor not open

    -- Initialize internal loop index variables
    "FLTR_si" := 0;
    "ACCOUNT_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU";

      LOOP
        IF "FLTR_si" = 0 THEN
          "FLTR_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_0_ACCOUNTID".COUNT - 1;
          ELSE
            bulk_count := "FLTR_0_ACCOUNTID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "ACCOUNT_DIM_ir".DELETE;
"ACCOUNT_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i" := "FLTR_si";
        BEGIN
          
          LOOP
            EXIT WHEN "ACCOUNT_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i" := "FLTR_i" + 1;
            "FLTR_si" := "FLTR_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "ACCOUNT_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("FLTR_c"%NOTFOUND AND
               "FLTR_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "FLTR_i" > bulk_count THEN
            
              "FLTR_si" := 0;
              EXIT;
            END IF;


            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_2_ACCOUNT_NAME"
            ("FLTR_i") := 
            UPPER(TRIM( "FLTR_2_ACCOUNT"
            ("FLTR_i") ))/* EXPR.OUTGRP1.ACCOUNT_NAME */;
            
            ',0,2000);
            
            
            "EXPR_2_ACCOUNT_NAME"
            ("FLTR_i") := 
            UPPER(TRIM( "FLTR_2_ACCOUNT"
            ("FLTR_i") ))/* EXPR.OUTGRP1.ACCOUNT_NAME */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_3_COUNTY"
            ("FLTR_i") := 
            UPPER(TRIM( "ADDRESS_10_COUNTY"
            ("FLTR_i")  ))/* EXPR.OUTGRP1.COUNTY */;
            
            ',0,2000);
            
            
            "EXPR_3_COUNTY"
            ("FLTR_i") := 
            UPPER(TRIM( "ADDRESS_10_COUNTY"
            ("FLTR_i")  ))/* EXPR.OUTGRP1.COUNTY */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_2_STATE"
            ("FLTR_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("FLTR_i")))
when ''CANADA'' 
then null 
when ''CAN'' 
then null 
else "ADDRESS_8_STATE"
            ("FLTR_i")  
end/* EXPR_1.OUTGRP1.STATE */;
            
            ',0,2000);
            
            
            "EXPR_1_2_STATE"
            ("FLTR_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("FLTR_i")))
when 'CANADA' 
then null 
when 'CAN' 
then null 
else "ADDRESS_8_STATE"
            ("FLTR_i")  
end/* EXPR_1.OUTGRP1.STATE */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_3_PROVINCE"
            ("FLTR_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("FLTR_i") ))  when ''CANADA''  then   "ADDRESS_8_STATE"
            ("FLTR_i")   when ''CAN''  then "ADDRESS_8_STATE"
            ("FLTR_i")   else null  end/* EXPR_1.OUTGRP1.PROVINCE */;
            
            ',0,2000);
            
            
            "EXPR_1_3_PROVINCE"
            ("FLTR_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("FLTR_i") ))  when 'CANADA'  then   "ADDRESS_8_STATE"
            ("FLTR_i")   when 'CAN'  then "ADDRESS_8_STATE"
            ("FLTR_i")   else null  end/* EXPR_1.OUTGRP1.PROVINCE */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_4_COUNTRY"
            ("FLTR_i") := 
            UPPER( TRIM( "ADDRESS_11_COUNTRY"
            ("FLTR_i") ) )/* EXPR_1.OUTGRP1.COUNTRY */;
            
            ',0,2000);
            
            
            "EXPR_1_4_COUNTRY"
            ("FLTR_i") := 
            UPPER( TRIM( "ADDRESS_11_COUNTRY"
            ("FLTR_i") ) )/* EXPR_1.OUTGRP1.COUNTRY */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "GET_NATL_TERR_ID_1_VALUE"
            ("FLTR_i") := 
            "GET_NATL_TERR_ID"((RTRIM("FLTR_0_ACCOUNTID"
            ("FLTR_i"))));
            
            ',0,2000);
            
            
            "GET_NATL_TERR_ID_1_VALUE"
            ("FLTR_i") := 
            "GET_NATL_TERR_ID"((RTRIM("FLTR_0_ACCOUNTID"
            ("FLTR_i"))));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            
get_target_name := '"ACCOUNT_DIM"';
            get_audit_detail_id := "ACCOUNT_DIM_id";
            IF NOT "ACCOUNT_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_0_ACCT_ID"("ACCOUNT_DIM_i") := 
            
            RTRIM("FLTR_0_ACCOUNTID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_0_ACCT_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_0_ACCOUNTID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_0_ACCT_ID"("ACCOUNT_DIM_i") :=
            
            RTRIM("FLTR_0_ACCOUNTID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_0_ACCT_ID" :=
            
            RTRIM("FLTR_0_ACCOUNTID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_1_ACCT_NAME"("ACCOUNT_DIM_i") := 
            
            "EXPR_2_ACCOUNT_NAME"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_1_ACCT_NAME"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_2_ACCOUNT_NAME"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_1_ACCT_NAME"("ACCOUNT_DIM_i") :=
            
            "EXPR_2_ACCOUNT_NAME"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_1_ACCT_NAME" :=
            
            "EXPR_2_ACCOUNT_NAME"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_3_ADDRESS1"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_5_ADDRESS1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_3_ADDRESS1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_5_ADDRESS1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_3_ADDRESS1"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_5_ADDRESS1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_3_ADDRESS1" :=
            
            "ADDRESS_5_ADDRESS1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_4_ADDRESS2"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_6_ADDRESS2"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_4_ADDRESS2"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_6_ADDRESS2"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_4_ADDRESS2"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_6_ADDRESS2"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_4_ADDRESS2" :=
            
            "ADDRESS_6_ADDRESS2"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_5_ADDRESS3"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_18_ADDRESS3"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_5_ADDRESS3"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_18_ADDRESS3"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_5_ADDRESS3"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_18_ADDRESS3"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_5_ADDRESS3" :=
            
            "ADDRESS_18_ADDRESS3"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_6_CITY"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_7_CITY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_6_CITY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_7_CITY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_6_CITY"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_7_CITY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_6_CITY" :=
            
            "ADDRESS_7_CITY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_7_STATE"("ACCOUNT_DIM_i") := 
            
            "EXPR_1_2_STATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_7_STATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_2_STATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_7_STATE"("ACCOUNT_DIM_i") :=
            
            "EXPR_1_2_STATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_7_STATE" :=
            
            "EXPR_1_2_STATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_8_ZIPCODE"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_9_POSTALCODE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_8_ZIPCODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_9_POSTALCODE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_8_ZIPCODE"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_9_POSTALCODE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_8_ZIPCODE" :=
            
            "ADDRESS_9_POSTALCODE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_9_PROVINCE"("ACCOUNT_DIM_i") := 
            
            "EXPR_1_3_PROVINCE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_9_PROVINCE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_3_PROVINCE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_9_PROVINCE"("ACCOUNT_DIM_i") :=
            
            "EXPR_1_3_PROVINCE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_9_PROVINCE" :=
            
            "EXPR_1_3_PROVINCE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_10_COUNTRY"("ACCOUNT_DIM_i") := 
            
            "EXPR_1_4_COUNTRY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_10_COUNTRY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_4_COUNTRY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_10_COUNTRY"("ACCOUNT_DIM_i") :=
            
            "EXPR_1_4_COUNTRY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_10_COUNTRY" :=
            
            "EXPR_1_4_COUNTRY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_11_COUNTY"("ACCOUNT_DIM_i") := 
            
            "EXPR_3_COUNTY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_11_COUNTY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_3_COUNTY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_11_COUNTY"("ACCOUNT_DIM_i") :=
            
            "EXPR_3_COUNTY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_11_COUNTY" :=
            
            "EXPR_3_COUNTY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_12_CREATION_DATE"("ACCOUNT_DIM_i") := 
            
            "FLTR_11_CREATEDATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_12_CREATION_DATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_11_CREATEDATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_12_CREATION_DATE"("ACCOUNT_DIM_i") :=
            
            "FLTR_11_CREATEDATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_12_CREATION_DA" :=
            
            "FLTR_11_CREATEDATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT__13_LAST_UPD"("ACCOUNT_DIM_i") := 
            
            "FLTR_12_MODIFYDATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT__13_LAST_UPD"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_12_MODIFYDATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT__13_LAST_UPD"("ACCOUNT_DIM_i") :=
            
            "FLTR_12_MODIFYDATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT__13_LAST_UPD" :=
            
            "FLTR_12_MODIFYDATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_18_GKDW_SOURCE"("ACCOUNT_DIM_i") := 
            
            "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE";',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_18_GKDW_SOURCE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_18_GKDW_SOURCE"("ACCOUNT_DIM_i") :=
            
            "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE";
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_18_GKDW_SOURCE" :=
            
            "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE";
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_22_SIC_CODE"("ACCOUNT_DIM_i") := 
            
            "FLTR_7_INDUSTRY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_22_SIC_CODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_7_INDUSTRY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_22_SIC_CODE"("ACCOUNT_DIM_i") :=
            
            "FLTR_7_INDUSTRY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_22_SIC_CODE" :=
            
            "FLTR_7_INDUSTRY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT__25_NATIONAL"("ACCOUNT_DIM_i") := 
            
            "GET_NATL_TERR_ID_1_VALUE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ACCOUNT__25_NATIONAL"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_NATL_TERR_ID_1_VALUE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT__25_NATIONAL"("ACCOUNT_DIM_i") :=
            
            "GET_NATL_TERR_ID_1_VALUE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT__25_NATIONAL" :=
            
            "GET_NATL_TERR_ID_1_VALUE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "ACCOUNT_DIM_srk"("ACCOUNT_DIM_i") := get_rowkey + "FLTR_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_ACCOUNT_DIM_srk" := get_rowkey + "FLTR_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "ACCOUNT_DIM_new" := TRUE;
                ELSE
                  "ACCOUNT_DIM_i" := "ACCOUNT_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER"('TRACE 43: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i");
                  
                  "ACCOUNT_DIM_err" := "ACCOUNT_DIM_err" + 1;
                  
                  IF get_errors + "ACCOUNT_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("ACCOUNT_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "ACCOUNT_DIM_new" 
            AND (NOT "ACCOUNT_DIM_nul") THEN
              "ACCOUNT_DIM_ir"(dml_bsize) := "ACCOUNT_DIM_i";
            	"ACCOUNT_DIM_0_ACCT_ID"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_0_ACCT_ID";
            	"ACCOUNT_DIM_1_ACCT_NAME"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_1_ACCT_NAME";
            	"ACCOUNT_DIM_3_ADDRESS1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_3_ADDRESS1";
            	"ACCOUNT_DIM_4_ADDRESS2"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_4_ADDRESS2";
            	"ACCOUNT_DIM_5_ADDRESS3"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_5_ADDRESS3";
            	"ACCOUNT_DIM_6_CITY"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_6_CITY";
            	"ACCOUNT_DIM_7_STATE"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_7_STATE";
            	"ACCOUNT_DIM_8_ZIPCODE"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_8_ZIPCODE";
            	"ACCOUNT_DIM_9_PROVINCE"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_9_PROVINCE";
            	"ACCOUNT_DIM_10_COUNTRY"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_10_COUNTRY";
            	"ACCOUNT_DIM_11_COUNTY"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_11_COUNTY";
            	"ACCOUNT_DIM_12_CREATION_DATE"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_12_CREATION_DA";
            	"ACCOUNT__13_LAST_UPD"("ACCOUNT_DIM_i") := "SV_ACCOUNT__13_LAST_UPD";
            	"ACCOUNT_DIM_18_GKDW_SOURCE"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_18_GKDW_SOURCE";
            	"ACCOUNT_DIM_22_SIC_CODE"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_22_SIC_CODE";
            	"ACCOUNT__25_NATIONAL"("ACCOUNT_DIM_i") := "SV_ACCOUNT__25_NATIONAL";
              "ACCOUNT_DIM_srk"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_srk";
              "ACCOUNT_DIM_i" := "ACCOUNT_DIM_i" + 1;
            ELSE
              "ACCOUNT_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "FLTR_DML"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "FLTR_DML"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "FLTR_ER"('TRACE 41: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "FLTR_c"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "FLTR_i" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "FLTR_i" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "FLTR_c";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "ACCOUNT_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"ACCOUNT_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"ACCOUNT_DIM_ins",
        p_upd=>"ACCOUNT_DIM_upd",
        p_del=>"ACCOUNT_DIM_del",
        p_err=>"ACCOUNT_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "ACCOUNT_DIM_ins";
    get_updated  := get_updated  + "ACCOUNT_DIM_upd";
    get_deleted  := get_deleted  + "ACCOUNT_DIM_del";
    get_errors   := get_errors   + "ACCOUNT_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "FLTR_p";



-- Procedure "FLTR_t" is the entry point for map "FLTR_t"

PROCEDURE "FLTR_t"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"FLTR_t"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB198D5B5678E040007F01006C7D,A41FFB198D5A5678E040007F01006C7D';
get_step_number            CONSTANT NUMBER(22) := 1;

cursor_exhausted           BOOLEAN := FALSE;
get_close_cursor           BOOLEAN := TRUE;
exit_loop_normal           BOOLEAN := FALSE;
exit_loop_early            BOOLEAN := FALSE;
loop_count                 NUMBER(22);

get_map_selected           NUMBER(22) := 0;
get_map_errors             NUMBER(22) := 0;
get_map_num_rows           NUMBER(22) := 0;
actual_owner               VARCHAR2(30);
actual_name                VARCHAR2(30);

-- Constraint management
num_fk_err                 NUMBER(22);
l_rowkey                   NUMBER(22) := 0;
l_table                    VARCHAR2(30) := 'CREATE';
l_rowid                    ROWID;
l_owner                    VARCHAR2(30);
l_tablename                VARCHAR2(30);
l_constraint               VARCHAR2(30);
l_exec_mode                BINARY_INTEGER := MODE_ROW_TARGET;
sql_excp_stmt              VARCHAR2(32767);
TYPE exceptionsCurType IS REF CURSOR;
exceptions_cursor          exceptionsCurType;

normal_action              VARCHAR2(20);
extended_action            VARCHAR2(2000);
error_action               VARCHAR2(20);
-- The get_audit_detail_id variable has been moved to a package-level variable
-- get_audit_detail_id        NUMBER(22) := 0;
get_target_name            VARCHAR2(80);
error_column               VARCHAR2(80);
error_value                VARCHAR2(2000);
error_rowkey               NUMBER(22) := 0;

-- Scalar variables for auditing

"ACCOUNT_DIM_id" NUMBER(22) := 0;
"ACCOUNT_DIM_ins" NUMBER(22) := 0;
"ACCOUNT_DIM_upd" NUMBER(22) := 0;
"ACCOUNT_DIM_del" NUMBER(22) := 0;
"ACCOUNT_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"ACCOUNT_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"ACCOUNT_DIM_ir"  index_redirect_array;
"SV_ACCOUNT_DIM_srk" NUMBER;
"ACCOUNT_DIM_new"  BOOLEAN;
"ACCOUNT_DIM_nul"  BOOLEAN := FALSE;

-- Bulk processing
error_index                NUMBER(22);
update_bulk                WB_RT_MAPAUDIT.NUMBERLIST;
update_bulk_index          NUMBER(22) := 0;
insert_bulk_index          NUMBER(22) := 0;
last_successful_index      NUMBER(22) := 0;
feedback_bulk_limit        NUMBER(22) := 0;
get_row_status             BOOLEAN; 
dml_bsize                  NUMBER; 
row_count                  NUMBER(22);
bulk_count                 NUMBER(22);

"FLTR_si$1" NUMBER(22) := 0;

"FLTR_i$1" NUMBER(22) := 0;


"ACCOUNT_DIM_si" NUMBER(22) := 0;

"ACCOUNT_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_0_ACCOUNTID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_2_ACCOUNT_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_5_ADDRESS1$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_6_ADDRESS2$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_18_ADDRESS3$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_7_CITY$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_2_STATE$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_9_POSTALCODE$1" IS TABLE OF VARCHAR2(24) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_3_PROVINCE$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_4_COUNTRY$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_3_COUNTY$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_11_CREATEDATE$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_12_MODIFYDATE$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DUMMY_TABLE_CURSOR$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_7_INDUSTRY$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_GET_NATL_TERR_ID_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_0_ACCT_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_1_ACCT_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_3_ADDRESS1$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_4_ADDRESS2$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_5_ADDRESS3$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_6_CITY$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_7_STATE$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_8_ZIPCODE$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_9_PROVINCE$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_10_COUNTRY$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_11_COUNTY$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_12_CREATION_DA" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT__13_LAST_UPD$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_18_GKDW_SOURCE$1" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_DIM_22_SIC_CODE$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT__25_NATIONAL$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_0_ACCOUNTID$1"  CHAR(12);
"SV_ROWKEY_FLTR$1"  VARCHAR2(18);
"SV_EXPR_2_ACCOUNT_NAME$1"  VARCHAR2(250);
"SV_ADDRESS_5_ADDRESS1$1"  VARCHAR2(64);
"SV_ADDRESS_6_ADDRESS2$1"  VARCHAR2(64);
"SV_ADDRESS_18_ADDRESS3$1"  VARCHAR2(64);
"SV_ADDRESS_7_CITY$1"  VARCHAR2(32);
"SV_EXPR_1_2_STATE$1"  VARCHAR2(60);
"SV_ADDRESS_9_POSTALCODE$1"  VARCHAR2(24);
"SV_EXPR_1_3_PROVINCE$1"  VARCHAR2(100);
"SV_EXPR_1_4_COUNTRY$1"  VARCHAR2(60);
"SV_EXPR_3_COUNTY$1"  VARCHAR2(50);
"SV_FLTR_11_CREATEDATE$1"  DATE;
"SV_FLTR_12_MODIFYDATE$1"  DATE;
"SV_ROWKEY_DUMMY_TABLE_CURSOR$1"  VARCHAR2(18);
"SV_FLTR_7_INDUSTRY$1"  VARCHAR2(64);
"SV_GET_NATL_TERR_ID_1_VALUE$1"  VARCHAR2(32767);
"SV_ACCOUNT_DIM_0_ACCT_ID$1"  VARCHAR2(50);
"SV_ACCOUNT_DIM_1_ACCT_NAME$1"  VARCHAR2(250);
"SV_ACCOUNT_DIM_3_ADDRESS1$1"  VARCHAR2(250);
"SV_ACCOUNT_DIM_4_ADDRESS2$1"  VARCHAR2(250);
"SV_ACCOUNT_DIM_5_ADDRESS3$1"  VARCHAR2(250);
"SV_ACCOUNT_DIM_6_CITY$1"  VARCHAR2(250);
"SV_ACCOUNT_DIM_7_STATE$1"  VARCHAR2(60);
"SV_ACCOUNT_DIM_8_ZIPCODE$1"  VARCHAR2(60);
"SV_ACCOUNT_DIM_9_PROVINCE$1"  VARCHAR2(100);
"SV_ACCOUNT_DIM_10_COUNTRY$1"  VARCHAR2(60);
"SV_ACCOUNT_DIM_11_COUNTY$1"  VARCHAR2(100);
"SV_ACCOUNT_DIM_12_CREATION_"  DATE;
"SV_ACCOUNT__13_LAST_UPD$1"  DATE;
"SV_ACCOUNT_DIM_18_GKDW_SOUR"  VARCHAR2(20);
"SV_ACCOUNT_DIM_22_SIC_CODE$1"  VARCHAR2(50);
"SV_ACCOUNT__25_NATIONAL$1"  VARCHAR2(100);

-- Bulk: intermediate collection variables
"FLTR_0_ACCOUNTID$1" "T_FLTR_0_ACCOUNTID$1";
"ROWKEY_FLTR$1" "T_ROWKEY_FLTR$1";
"EXPR_2_ACCOUNT_NAME$1" "T_EXPR_2_ACCOUNT_NAME$1";
"ADDRESS_5_ADDRESS1$1" "T_ADDRESS_5_ADDRESS1$1";
"ADDRESS_6_ADDRESS2$1" "T_ADDRESS_6_ADDRESS2$1";
"ADDRESS_18_ADDRESS3$1" "T_ADDRESS_18_ADDRESS3$1";
"ADDRESS_7_CITY$1" "T_ADDRESS_7_CITY$1";
"EXPR_1_2_STATE$1" "T_EXPR_1_2_STATE$1";
"ADDRESS_9_POSTALCODE$1" "T_ADDRESS_9_POSTALCODE$1";
"EXPR_1_3_PROVINCE$1" "T_EXPR_1_3_PROVINCE$1";
"EXPR_1_4_COUNTRY$1" "T_EXPR_1_4_COUNTRY$1";
"EXPR_3_COUNTY$1" "T_EXPR_3_COUNTY$1";
"FLTR_11_CREATEDATE$1" "T_FLTR_11_CREATEDATE$1";
"FLTR_12_MODIFYDATE$1" "T_FLTR_12_MODIFYDATE$1";
"ROWKEY_DUMMY_TABLE_CURSOR$1" "T_ROWKEY_DUMMY_TABLE_CURSOR$1";
"FLTR_7_INDUSTRY$1" "T_FLTR_7_INDUSTRY$1";
"GET_NATL_TERR_ID_1_VALUE$1" "T_GET_NATL_TERR_ID_1_VALUE$1";
"ACCOUNT_DIM_0_ACCT_ID$1" "T_ACCOUNT_DIM_0_ACCT_ID$1";
"ACCOUNT_DIM_1_ACCT_NAME$1" "T_ACCOUNT_DIM_1_ACCT_NAME$1";
"ACCOUNT_DIM_3_ADDRESS1$1" "T_ACCOUNT_DIM_3_ADDRESS1$1";
"ACCOUNT_DIM_4_ADDRESS2$1" "T_ACCOUNT_DIM_4_ADDRESS2$1";
"ACCOUNT_DIM_5_ADDRESS3$1" "T_ACCOUNT_DIM_5_ADDRESS3$1";
"ACCOUNT_DIM_6_CITY$1" "T_ACCOUNT_DIM_6_CITY$1";
"ACCOUNT_DIM_7_STATE$1" "T_ACCOUNT_DIM_7_STATE$1";
"ACCOUNT_DIM_8_ZIPCODE$1" "T_ACCOUNT_DIM_8_ZIPCODE$1";
"ACCOUNT_DIM_9_PROVINCE$1" "T_ACCOUNT_DIM_9_PROVINCE$1";
"ACCOUNT_DIM_10_COUNTRY$1" "T_ACCOUNT_DIM_10_COUNTRY$1";
"ACCOUNT_DIM_11_COUNTY$1" "T_ACCOUNT_DIM_11_COUNTY$1";
"ACCOUNT_DIM_12_CREATION_DATE$1" "T_ACCOUNT_DIM_12_CREATION_DA";
"ACCOUNT__13_LAST_UPD$1" "T_ACCOUNT__13_LAST_UPD$1";
"ACCOUNT_DIM_18_GKDW_SOURCE$1" "T_ACCOUNT_DIM_18_GKDW_SOURCE$1";
"ACCOUNT_DIM_22_SIC_CODE$1" "T_ACCOUNT_DIM_22_SIC_CODE$1";
"ACCOUNT__25_NATIONAL$1" "T_ACCOUNT__25_NATIONAL$1";

PROCEDURE Main_ES(p_step_number IN NUMBER, p_rowkey IN NUMBER, p_table IN VARCHAR2, p_col IN VARCHAR2, p_value IN VARCHAR2 default 'VALUE DISABLED') IS
BEGIN
  get_column_seq := get_column_seq + 1;
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>p_rowkey,
    p_seq=>get_column_seq,
    p_instance=>1,
    p_table=>SUBSTR(p_table,0,80),
    p_column=>SUBSTR(p_col,0,80),
    p_value=>SUBSTRB(p_value,0,2000),
    p_step=>p_step_number,
    p_role=>'T'
  );
END;

---------------------------------------------------------------------------
-- This procedure records column values of one erroneous source row
-- into an audit trail table named WB_RT_ERROR_SOURCES.  Each column is
-- recorded by one row in the audit trail.  To collect all source column
-- values corresponding to one erroneous source row, query the audit
-- trail and specify:
--    RTA_IID, uniquely identifies one audited run,
--    RTE_ROWKEY, uniquely identifies a source row within and audited run
---------------------------------------------------------------------------
PROCEDURE "FLTR_ES$1"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_0_ACCOUNTID',0,80),
    p_value=>SUBSTRB("FLTR_0_ACCOUNTID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('EXPR_2_ACCOUNT_NAME',0,80),
    p_value=>SUBSTRB("EXPR_2_ACCOUNT_NAME$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_5_ADDRESS1',0,80),
    p_value=>SUBSTRB("ADDRESS_5_ADDRESS1$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_6_ADDRESS2',0,80),
    p_value=>SUBSTRB("ADDRESS_6_ADDRESS2$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_18_ADDRESS3',0,80),
    p_value=>SUBSTRB("ADDRESS_18_ADDRESS3$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_7_CITY',0,80),
    p_value=>SUBSTRB("ADDRESS_7_CITY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('EXPR_1_2_STATE',0,80),
    p_value=>SUBSTRB("EXPR_1_2_STATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('ADDRESS_9_POSTALCODE',0,80),
    p_value=>SUBSTRB("ADDRESS_9_POSTALCODE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('EXPR_1_3_PROVINCE',0,80),
    p_value=>SUBSTRB("EXPR_1_3_PROVINCE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('EXPR_1_4_COUNTRY',0,80),
    p_value=>SUBSTRB("EXPR_1_4_COUNTRY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('EXPR_3_COUNTY',0,80),
    p_value=>SUBSTRB("EXPR_3_COUNTY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_11_CREATEDATE',0,80),
    p_value=>SUBSTRB("FLTR_11_CREATEDATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_12_MODIFYDATE',0,80),
    p_value=>SUBSTRB("FLTR_12_MODIFYDATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('FLTR_7_INDUSTRY',0,80),
    p_value=>SUBSTRB("FLTR_7_INDUSTRY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>15,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',0,80),
    p_column=>SUBSTR('GET_NATL_TERR_ID_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_NATL_TERR_ID_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "FLTR_ES$1";

---------------------------------------------------------------------------
-- Procedure "FLTR_ER$1" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "FLTR_ER$1"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
l_source_target_name VARCHAR2(80);
BEGIN
  IF p_auditd_id IS NULL THEN
    l_source_target_name := SUBSTR(get_source_name,0,80);
  ELSE
    l_source_target_name := get_target_name;
  END IF;

  IF p_error_index = 0 THEN  
  get_rowkey_error := 0;
ELSE  
  get_rowkey_error := get_rowkey + p_error_index - 1;
END IF;

  IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
    WB_RT_MAPAUDIT.error(
      p_rta=>get_runtime_audit_id,
      p_step=>get_step_number,
      p_rtd=>p_auditd_id,
      p_rowkey=>get_rowkey_error,
      p_table=>l_source_target_name,
      p_column=>p_column,
      p_dstval=>p_col_value,
      p_stm=>'TRACE 44: ' || p_statement,
      p_sqlerr=>p_sqlcode,
      p_sqlerrm=>p_sqlerrm,
      p_rowid=>NULL
    );
  END IF;

  IF ( get_audit_level = AUDIT_COMPLETE ) AND (get_rowkey_error > 0) THEN
    WB_RT_MAPAUDIT.register_feedback(
      p_rta=>get_runtime_audit_id,
      p_step=>get_step_number,
      p_rowkey=>get_rowkey_error,
      p_status=>'ERROR',
      p_table=>l_source_target_name,
      p_role=>'T',
      p_action=>SUBSTR(p_statement,0,30)
    );
  END IF;

  IF ( get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE ) AND (get_rowkey_error > 0) THEN
    "FLTR_ES$1"(p_error_index);
  END IF;
END "FLTR_ER$1";



---------------------------------------------------------------------------
-- Procedure "FLTR_SU$1" opens and initializes data source
-- for map "FLTR_t"
---------------------------------------------------------------------------
PROCEDURE "FLTR_SU$1" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "FLTR_c$1"%ISOPEN) THEN
    OPEN "FLTR_c$1";
  END IF;
  get_read_success := TRUE;
END "FLTR_SU$1";

---------------------------------------------------------------------------
-- Procedure "FLTR_RD$1" fetches a bulk of rows from
--   the data source for map "FLTR_t"
---------------------------------------------------------------------------
PROCEDURE "FLTR_RD$1" IS
BEGIN
  IF NOT get_read_success THEN
    get_abort := TRUE;
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      WB_RT_MAPAUDIT.error(
        p_rta=>get_runtime_audit_id,
        p_step=>0,
        p_rtd=>NULL,
        p_rowkey=>0,
        p_table=>NULL,
        p_column=>NULL,
        p_dstval=>NULL,
        p_stm=>NULL,
        p_sqlerr=>-20007,
        p_sqlerrm=>'CursorFetchMapTerminationRTV20007',
        p_rowid=>NULL
      );
    END IF;
                END IF;

  IF get_abort OR get_abort_procedure THEN
    RETURN;
  END IF;

  BEGIN
    "FLTR_0_ACCOUNTID$1".DELETE;
    "EXPR_2_ACCOUNT_NAME$1".DELETE;
    "ADDRESS_5_ADDRESS1$1".DELETE;
    "ADDRESS_6_ADDRESS2$1".DELETE;
    "ADDRESS_18_ADDRESS3$1".DELETE;
    "ADDRESS_7_CITY$1".DELETE;
    "EXPR_1_2_STATE$1".DELETE;
    "ADDRESS_9_POSTALCODE$1".DELETE;
    "EXPR_1_3_PROVINCE$1".DELETE;
    "EXPR_1_4_COUNTRY$1".DELETE;
    "EXPR_3_COUNTY$1".DELETE;
    "FLTR_11_CREATEDATE$1".DELETE;
    "FLTR_12_MODIFYDATE$1".DELETE;
    "FLTR_7_INDUSTRY$1".DELETE;
    "GET_NATL_TERR_ID_1_VALUE$1".DELETE;

    FETCH
      "FLTR_c$1"
    BULK COLLECT INTO
      "FLTR_0_ACCOUNTID$1",
      "EXPR_2_ACCOUNT_NAME$1",
      "ADDRESS_5_ADDRESS1$1",
      "ADDRESS_6_ADDRESS2$1",
      "ADDRESS_18_ADDRESS3$1",
      "ADDRESS_7_CITY$1",
      "EXPR_1_2_STATE$1",
      "ADDRESS_9_POSTALCODE$1",
      "EXPR_1_3_PROVINCE$1",
      "EXPR_1_4_COUNTRY$1",
      "EXPR_3_COUNTY$1",
      "FLTR_11_CREATEDATE$1",
      "FLTR_12_MODIFYDATE$1",
      "FLTR_7_INDUSTRY$1",
      "GET_NATL_TERR_ID_1_VALUE$1"
    LIMIT get_bulk_size;

    IF "FLTR_c$1"%NOTFOUND AND "FLTR_0_ACCOUNTID$1".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_0_ACCOUNTID$1".COUNT;
    END IF;
    
    IF get_audit_level = AUDIT_COMPLETE THEN
      WB_RT_MAPAUDIT.register_feedback_bulk(
        p_rta=>get_runtime_audit_id,
        p_step=>get_step_number,
        p_rowkey=>get_rowkey,
        p_status=>'NEW',
        p_table=>get_source_name,
        p_role=>'S',
        p_action=>'SELECT'
      );
    END IF;
    get_map_selected := get_map_selected + "FLTR_0_ACCOUNTID$1".COUNT;
  EXCEPTION
    WHEN OTHERS THEN
        last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
      get_read_success := FALSE;
      -- register error
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        one_rowkey := rowkey_counter;
        rowkey_counter := rowkey_counter + 1;
        WB_RT_MAPAUDIT.error(
          p_rta=>get_runtime_audit_id,
          p_step=>get_step_number,
          p_rtd=>NULL,
          p_rowkey=>one_rowkey,
          p_table=>get_source_name,
          p_column=>'*',
          p_dstval=>NULL,
          p_stm=>'TRACE 45: SELECT',
          p_sqlerr=>SQLCODE,
          p_sqlerrm=>SQLERRM,
          p_rowid=>NULL
        );
      END IF;
      
      -- register feedback for the erroneous row
      IF get_audit_level = AUDIT_COMPLETE THEN
        WB_RT_MAPAUDIT.register_feedback(
          p_rta=>get_runtime_audit_id,
          p_step=>get_step_number,
          p_rowkey=>one_rowkey,
          p_status=>'ERROR',
          p_table=>get_source_name,
          p_role=>'S',
          p_action=>'SELECT'
        );
      END IF;
      get_errors := get_errors + 1;
      IF get_errors > get_max_errors THEN get_abort := TRUE; END IF;
  END;
END "FLTR_RD$1";

---------------------------------------------------------------------------
-- Procedure "FLTR_DML$1" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "FLTR_DML$1"(si NUMBER, firstround BOOLEAN) IS
  "ACCOUNT_DIM_ins0" NUMBER := "ACCOUNT_DIM_ins";
  "ACCOUNT_DIM_upd0" NUMBER := "ACCOUNT_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "ACCOUNT_DIM_St" THEN
  -- Update/Insert DML for "ACCOUNT_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"ACCOUNT_DIM"';
    get_audit_detail_id := "ACCOUNT_DIM_id";
    "ACCOUNT_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "ACCOUNT_DIM_i" > get_bulk_size 
   OR "FLTR_c$1"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "ACCOUNT_DIM_si".."ACCOUNT_DIM_i" - 1 
            UPDATE
              "ACCOUNT_DIM"
            SET
  
  						"ACCOUNT_DIM"."ACCT_NAME" = "ACCOUNT_DIM_1_ACCT_NAME$1"
  (i),						"ACCOUNT_DIM"."ADDRESS1" = "ACCOUNT_DIM_3_ADDRESS1$1"
  (i),						"ACCOUNT_DIM"."ADDRESS2" = "ACCOUNT_DIM_4_ADDRESS2$1"
  (i),						"ACCOUNT_DIM"."ADDRESS3" = "ACCOUNT_DIM_5_ADDRESS3$1"
  (i),						"ACCOUNT_DIM"."CITY" = "ACCOUNT_DIM_6_CITY$1"
  (i),						"ACCOUNT_DIM"."STATE" = "ACCOUNT_DIM_7_STATE$1"
  (i),						"ACCOUNT_DIM"."ZIPCODE" = "ACCOUNT_DIM_8_ZIPCODE$1"
  (i),						"ACCOUNT_DIM"."PROVINCE" = "ACCOUNT_DIM_9_PROVINCE$1"
  (i),						"ACCOUNT_DIM"."COUNTRY" = "ACCOUNT_DIM_10_COUNTRY$1"
  (i),						"ACCOUNT_DIM"."COUNTY" = "ACCOUNT_DIM_11_COUNTY$1"
  (i),						"ACCOUNT_DIM"."CREATION_DATE" = "ACCOUNT_DIM_12_CREATION_DATE$1"
  (i),						"ACCOUNT_DIM"."LAST_UPDATE_DATE" = "ACCOUNT__13_LAST_UPD$1"
  (i),						"ACCOUNT_DIM"."GKDW_SOURCE" = "ACCOUNT_DIM_18_GKDW_SOURCE$1"
  (i),						"ACCOUNT_DIM"."SIC_CODE" = "ACCOUNT_DIM_22_SIC_CODE$1"
  (i),						"ACCOUNT_DIM"."NATIONAL_TERR_ID" = "ACCOUNT__25_NATIONAL$1"
  (i)
    
            WHERE
  
  						"ACCOUNT_DIM"."ACCT_ID" = "ACCOUNT_DIM_0_ACCT_ID$1"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "ACCOUNT_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "ACCOUNT_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "ACCOUNT_DIM_srk"(rowkey_index);
                rowkey_bulk_index := rowkey_bulk_index + 1;
              END IF;
            END IF;
          END LOOP;
          
          
IF get_audit_level = AUDIT_COMPLETE THEN
  WB_RT_MAPAUDIT.register_feedback_bulk(
    p_rta=>get_runtime_audit_id,
    p_step=>get_step_number,
    p_rowkey=>get_rowkey_bulk,
    p_status=>'NEW',
    p_table=>get_target_name,
    p_role=>'T',
    p_action=>normal_action,
    p_rowid=>get_rowid
  );
END IF;
  
          "ACCOUNT_DIM_upd" := "ACCOUNT_DIM_upd" + get_rowid.COUNT;
          "ACCOUNT_DIM_si" := "ACCOUNT_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "ACCOUNT_DIM_si".."ACCOUNT_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "ACCOUNT_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "ACCOUNT_DIM_srk"(rowkey_index);
                  rowkey_bulk_index := rowkey_bulk_index + 1;
                END IF;
              END IF;
            END LOOP;
            
            
IF get_audit_level = AUDIT_COMPLETE THEN
  WB_RT_MAPAUDIT.register_feedback_bulk(
    p_rta=>get_runtime_audit_id,
    p_step=>get_step_number,
    p_rowkey=>get_rowkey_bulk,
    p_status=>'NEW',
    p_table=>get_target_name,
    p_role=>'T',
    p_action=>normal_action,
    p_rowid=>get_rowid
  );
END IF;
            "ACCOUNT_DIM_upd" := "ACCOUNT_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "ACCOUNT_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                  "ACCOUNT_DIM"
                SET
  
  								"ACCOUNT_DIM"."ACCT_NAME" = "ACCOUNT_DIM_1_ACCT_NAME$1"
  (last_successful_index),								"ACCOUNT_DIM"."ADDRESS1" = "ACCOUNT_DIM_3_ADDRESS1$1"
  (last_successful_index),								"ACCOUNT_DIM"."ADDRESS2" = "ACCOUNT_DIM_4_ADDRESS2$1"
  (last_successful_index),								"ACCOUNT_DIM"."ADDRESS3" = "ACCOUNT_DIM_5_ADDRESS3$1"
  (last_successful_index),								"ACCOUNT_DIM"."CITY" = "ACCOUNT_DIM_6_CITY$1"
  (last_successful_index),								"ACCOUNT_DIM"."STATE" = "ACCOUNT_DIM_7_STATE$1"
  (last_successful_index),								"ACCOUNT_DIM"."ZIPCODE" = "ACCOUNT_DIM_8_ZIPCODE$1"
  (last_successful_index),								"ACCOUNT_DIM"."PROVINCE" = "ACCOUNT_DIM_9_PROVINCE$1"
  (last_successful_index),								"ACCOUNT_DIM"."COUNTRY" = "ACCOUNT_DIM_10_COUNTRY$1"
  (last_successful_index),								"ACCOUNT_DIM"."COUNTY" = "ACCOUNT_DIM_11_COUNTY$1"
  (last_successful_index),								"ACCOUNT_DIM"."CREATION_DATE" = "ACCOUNT_DIM_12_CREATION_DATE$1"
  (last_successful_index),								"ACCOUNT_DIM"."LAST_UPDATE_DATE" = "ACCOUNT__13_LAST_UPD$1"
  (last_successful_index),								"ACCOUNT_DIM"."GKDW_SOURCE" = "ACCOUNT_DIM_18_GKDW_SOURCE$1"
  (last_successful_index),								"ACCOUNT_DIM"."SIC_CODE" = "ACCOUNT_DIM_22_SIC_CODE$1"
  (last_successful_index),								"ACCOUNT_DIM"."NATIONAL_TERR_ID" = "ACCOUNT__25_NATIONAL$1"
  (last_successful_index)
  
                WHERE
  
  								"ACCOUNT_DIM"."ACCT_ID" = "ACCOUNT_DIM_0_ACCT_ID$1"
  (last_successful_index)
  
  ;
              update_bulk(update_bulk_index) := last_successful_index;
              update_bulk_index := update_bulk_index + 1;
              last_successful_index := last_successful_index + 1;
            EXCEPTION
              WHEN OTHERS THEN
                  last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  error_rowkey := "ACCOUNT_DIM_srk"(last_successful_index);
                  WB_RT_MAPAUDIT.error(
                    p_rta=>get_runtime_audit_id,
                    p_step=>get_step_number,
                    p_rtd=>get_audit_detail_id,
                    p_rowkey=>error_rowkey,
                    p_table=>get_target_name,
                    p_column=>'*',
                    p_dstval=>NULL,
                    p_stm=>'TRACE : ' || error_action,
                    p_sqlerr=>SQLCODE,
                    p_sqlerrm=>SQLERRM,
                    p_rowid=>NULL
                  );
                  get_column_seq := 0;
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ACCT_NAME"',0,80),SUBSTRB("ACCOUNT_DIM_1_ACCT_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS1"',0,80),SUBSTRB("ACCOUNT_DIM_3_ADDRESS1$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS2"',0,80),SUBSTRB("ACCOUNT_DIM_4_ADDRESS2$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS3"',0,80),SUBSTRB("ACCOUNT_DIM_5_ADDRESS3$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CITY"',0,80),SUBSTRB("ACCOUNT_DIM_6_CITY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."STATE"',0,80),SUBSTRB("ACCOUNT_DIM_7_STATE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ZIPCODE"',0,80),SUBSTRB("ACCOUNT_DIM_8_ZIPCODE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."PROVINCE"',0,80),SUBSTRB("ACCOUNT_DIM_9_PROVINCE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTRY"',0,80),SUBSTRB("ACCOUNT_DIM_10_COUNTRY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTY"',0,80),SUBSTRB("ACCOUNT_DIM_11_COUNTY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CREATION_DATE"',0,80),SUBSTRB("ACCOUNT_DIM_12_CREATION_DATE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("ACCOUNT__13_LAST_UPD$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("ACCOUNT_DIM_18_GKDW_SOURCE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."SIC_CODE"',0,80),SUBSTRB("ACCOUNT_DIM_22_SIC_CODE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."NATIONAL_TERR_ID"',0,80),SUBSTRB("ACCOUNT__25_NATIONAL$1"(last_successful_index),0,2000));
                  
                END IF;
                IF get_audit_level = AUDIT_COMPLETE THEN
                  WB_RT_MAPAUDIT.register_feedback(
                    p_rta=>get_runtime_audit_id,
                    p_step=>get_step_number,
                    p_rowkey=>error_rowkey,
                    p_status=>'ERROR',
                    p_table=>get_target_name,
                    p_role=>'T',
                    p_action=>error_action
                  );
                END IF;
                "ACCOUNT_DIM_err" := "ACCOUNT_DIM_err" + 1;
                
                IF get_errors + "ACCOUNT_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "ACCOUNT_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "ACCOUNT_DIM_si" >= "ACCOUNT_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "ACCOUNT_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"ACCOUNT_DIM_0_ACCT_ID$1"(insert_bulk_index) := "ACCOUNT_DIM_0_ACCT_ID$1"(update_bulk(j));
  		"ACCOUNT_DIM_1_ACCT_NAME$1"(insert_bulk_index) := "ACCOUNT_DIM_1_ACCT_NAME$1"(update_bulk(j));
  		"ACCOUNT_DIM_3_ADDRESS1$1"(insert_bulk_index) := "ACCOUNT_DIM_3_ADDRESS1$1"(update_bulk(j));
  		"ACCOUNT_DIM_4_ADDRESS2$1"(insert_bulk_index) := "ACCOUNT_DIM_4_ADDRESS2$1"(update_bulk(j));
  		"ACCOUNT_DIM_5_ADDRESS3$1"(insert_bulk_index) := "ACCOUNT_DIM_5_ADDRESS3$1"(update_bulk(j));
  		"ACCOUNT_DIM_6_CITY$1"(insert_bulk_index) := "ACCOUNT_DIM_6_CITY$1"(update_bulk(j));
  		"ACCOUNT_DIM_7_STATE$1"(insert_bulk_index) := "ACCOUNT_DIM_7_STATE$1"(update_bulk(j));
  		"ACCOUNT_DIM_8_ZIPCODE$1"(insert_bulk_index) := "ACCOUNT_DIM_8_ZIPCODE$1"(update_bulk(j));
  		"ACCOUNT_DIM_9_PROVINCE$1"(insert_bulk_index) := "ACCOUNT_DIM_9_PROVINCE$1"(update_bulk(j));
  		"ACCOUNT_DIM_10_COUNTRY$1"(insert_bulk_index) := "ACCOUNT_DIM_10_COUNTRY$1"(update_bulk(j));
  		"ACCOUNT_DIM_11_COUNTY$1"(insert_bulk_index) := "ACCOUNT_DIM_11_COUNTY$1"(update_bulk(j));
  		"ACCOUNT_DIM_12_CREATION_DATE$1"(insert_bulk_index) := "ACCOUNT_DIM_12_CREATION_DATE$1"(update_bulk(j));
  		"ACCOUNT__13_LAST_UPD$1"(insert_bulk_index) := "ACCOUNT__13_LAST_UPD$1"(update_bulk(j));
  		"ACCOUNT_DIM_18_GKDW_SOURCE$1"(insert_bulk_index) := "ACCOUNT_DIM_18_GKDW_SOURCE$1"(update_bulk(j));
  		"ACCOUNT_DIM_22_SIC_CODE$1"(insert_bulk_index) := "ACCOUNT_DIM_22_SIC_CODE$1"(update_bulk(j));
  		"ACCOUNT__25_NATIONAL$1"(insert_bulk_index) := "ACCOUNT__25_NATIONAL$1"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "ACCOUNT_DIM_srk"(insert_bulk_index) := "ACCOUNT_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "ACCOUNT_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "ACCOUNT_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "ACCOUNT_DIM_si"..insert_bulk_index
          INSERT INTO
            "ACCOUNT_DIM"
            ("ACCOUNT_DIM"."ACCT_ID",
            "ACCOUNT_DIM"."ACCT_NAME",
            "ACCOUNT_DIM"."ADDRESS1",
            "ACCOUNT_DIM"."ADDRESS2",
            "ACCOUNT_DIM"."ADDRESS3",
            "ACCOUNT_DIM"."CITY",
            "ACCOUNT_DIM"."STATE",
            "ACCOUNT_DIM"."ZIPCODE",
            "ACCOUNT_DIM"."PROVINCE",
            "ACCOUNT_DIM"."COUNTRY",
            "ACCOUNT_DIM"."COUNTY",
            "ACCOUNT_DIM"."CREATION_DATE",
            "ACCOUNT_DIM"."LAST_UPDATE_DATE",
            "ACCOUNT_DIM"."GKDW_SOURCE",
            "ACCOUNT_DIM"."SIC_CODE",
            "ACCOUNT_DIM"."NATIONAL_TERR_ID")
          VALUES
            ("ACCOUNT_DIM_0_ACCT_ID$1"(i),
            "ACCOUNT_DIM_1_ACCT_NAME$1"(i),
            "ACCOUNT_DIM_3_ADDRESS1$1"(i),
            "ACCOUNT_DIM_4_ADDRESS2$1"(i),
            "ACCOUNT_DIM_5_ADDRESS3$1"(i),
            "ACCOUNT_DIM_6_CITY$1"(i),
            "ACCOUNT_DIM_7_STATE$1"(i),
            "ACCOUNT_DIM_8_ZIPCODE$1"(i),
            "ACCOUNT_DIM_9_PROVINCE$1"(i),
            "ACCOUNT_DIM_10_COUNTRY$1"(i),
            "ACCOUNT_DIM_11_COUNTY$1"(i),
            "ACCOUNT_DIM_12_CREATION_DATE$1"(i),
            "ACCOUNT__13_LAST_UPD$1"(i),
            "ACCOUNT_DIM_18_GKDW_SOURCE$1"(i),
            "ACCOUNT_DIM_22_SIC_CODE$1"(i),
            "ACCOUNT__25_NATIONAL$1"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "ACCOUNT_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "ACCOUNT_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "ACCOUNT_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 46: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ACCT_ID"',0,80),SUBSTRB("ACCOUNT_DIM_0_ACCT_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ACCT_NAME"',0,80),SUBSTRB("ACCOUNT_DIM_1_ACCT_NAME$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS1"',0,80),SUBSTRB("ACCOUNT_DIM_3_ADDRESS1$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS2"',0,80),SUBSTRB("ACCOUNT_DIM_4_ADDRESS2$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ADDRESS3"',0,80),SUBSTRB("ACCOUNT_DIM_5_ADDRESS3$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CITY"',0,80),SUBSTRB("ACCOUNT_DIM_6_CITY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."STATE"',0,80),SUBSTRB("ACCOUNT_DIM_7_STATE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."ZIPCODE"',0,80),SUBSTRB("ACCOUNT_DIM_8_ZIPCODE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."PROVINCE"',0,80),SUBSTRB("ACCOUNT_DIM_9_PROVINCE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTRY"',0,80),SUBSTRB("ACCOUNT_DIM_10_COUNTRY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."COUNTY"',0,80),SUBSTRB("ACCOUNT_DIM_11_COUNTY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."CREATION_DATE"',0,80),SUBSTRB("ACCOUNT_DIM_12_CREATION_DATE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("ACCOUNT__13_LAST_UPD$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("ACCOUNT_DIM_18_GKDW_SOURCE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."SIC_CODE"',0,80),SUBSTRB("ACCOUNT_DIM_22_SIC_CODE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ACCOUNT_DIM"."NATIONAL_TERR_ID"',0,80),SUBSTRB("ACCOUNT__25_NATIONAL$1"(error_index),0,2000));
            
          END IF;
          IF get_audit_level = AUDIT_COMPLETE THEN
            WB_RT_MAPAUDIT.register_feedback(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rowkey=>error_rowkey,
              p_status=>'ERROR',
              p_table=>get_target_name,
              p_role=>'T',
              p_action=>error_action
            );
          END IF;
          "ACCOUNT_DIM_err" := "ACCOUNT_DIM_err" + 1;
          
          IF get_errors + "ACCOUNT_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "ACCOUNT_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "ACCOUNT_DIM_srk"(rowkey_index);
          rowkey_bulk_index := rowkey_bulk_index + 1;
        END LOOP;
      END IF;
      
IF get_audit_level = AUDIT_COMPLETE THEN
  WB_RT_MAPAUDIT.register_feedback_bulk(
    p_rta=>get_runtime_audit_id,
    p_step=>get_step_number,
    p_rowkey=>get_rowkey_bulk,
    p_status=>'NEW',
    p_table=>get_target_name,
    p_role=>'T',
    p_action=>normal_action,
    p_rowid=>get_rowid
  );
END IF;
  
      "ACCOUNT_DIM_ins" := "ACCOUNT_DIM_ins" + get_rowid.COUNT;
      "ACCOUNT_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "ACCOUNT_DIM_ins" := "ACCOUNT_DIM_ins0"; 
    "ACCOUNT_DIM_upd" := "ACCOUNT_DIM_upd0";
  END IF;

END "FLTR_DML$1";

---------------------------------------------------------------------------
-- "FLTR_t" main
---------------------------------------------------------------------------

BEGIN
  IF get_abort OR get_abort_procedure THEN
    
    RETURN;
  END IF;

  
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.7
  sql_stmt := 'ALTER SESSION DISABLE PARALLEL DML';
  EXECUTE IMMEDIATE sql_stmt;
END IF;

  IF NOT "ACCOUNT_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c$1"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "ACCOUNT_DIM_St" THEN
          "ACCOUNT_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"ACCOUNT_DIM"',
              p_target_uoid=>'A41FFB198D8A5678E040007F01006C7D',
              p_stm=>'TRACE 48',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "ACCOUNT_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198D8A5678E040007F01006C7D', -- Operator ACCOUNT_DIM
              p_parent_object_name=>'ACCOUNT_DIM',
              p_parent_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT_DIM',
              p_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198D5B5678E040007F01006C7D', -- Operator ACCOUNT
              p_parent_object_name=>'ACCOUNT',
              p_parent_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT',
              p_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198D5A5678E040007F01006C7D', -- Operator ADDRESS
              p_parent_object_name=>'ADDRESS',
              p_parent_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_parent_object_type=>'Table',
              p_object_name=>'ADDRESS',
              p_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198C165678E040007F01006C7D', -- Operator ACCOUNT
              p_parent_object_name=>'ACCOUNT',
              p_parent_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT',
              p_object_uoid=>'A41FFB18FCED5678E040007F01006C7D', -- Table ACCOUNT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198E375678E040007F01006C7D', -- Operator ACCOUNT_DIM
              p_parent_object_name=>'ACCOUNT_DIM',
              p_parent_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'ACCOUNT_DIM',
              p_object_uoid=>'A41FA16DAE32655CE040007F01006B9E', -- Table ACCOUNT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198EBC5678E040007F01006C7D', -- Operator ADDRESS
              p_parent_object_name=>'ADDRESS',
              p_parent_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_parent_object_type=>'Table',
              p_object_name=>'ADDRESS',
              p_object_uoid=>'A41FFB19111A5678E040007F01006C7D', -- Table ADDRESS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
            );
        END IF;
        IF NOT get_no_commit THEN
          COMMIT; -- commit no.10
        END IF;
      END IF;

      

      -- Initialize buffer variables
      get_buffer_done.DELETE;
      get_buffer_done_index := 1;

    END IF; -- End if cursor not open

    -- Initialize internal loop index variables
    "FLTR_si$1" := 0;
    "ACCOUNT_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU$1";

      LOOP
        IF "FLTR_si$1" = 0 THEN
          "FLTR_RD$1";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_0_ACCOUNTID$1".COUNT - 1;
          ELSE
            bulk_count := "FLTR_0_ACCOUNTID$1".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "ACCOUNT_DIM_ir".DELETE;
"ACCOUNT_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i$1" := "FLTR_si$1";
        BEGIN
          
          LOOP
            EXIT WHEN "ACCOUNT_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i$1" := "FLTR_i$1" + 1;
            "FLTR_si$1" := "FLTR_i$1";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "ACCOUNT_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("FLTR_c$1"%NOTFOUND AND
               "FLTR_i$1" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "FLTR_i$1" > bulk_count THEN
            
              "FLTR_si$1" := 0;
              EXIT;
            END IF;


            
get_target_name := '"ACCOUNT_DIM"';
            get_audit_detail_id := "ACCOUNT_DIM_id";
            IF NOT "ACCOUNT_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_0_ACCT_ID$1"("ACCOUNT_DIM_i") := 
            
            RTRIM("FLTR_0_ACCOUNTID$1"("FLTR_i$1"));',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_0_ACCT_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_0_ACCOUNTID$1"("FLTR_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_0_ACCT_ID$1"("ACCOUNT_DIM_i") :=
            
            RTRIM("FLTR_0_ACCOUNTID$1"("FLTR_i$1"));
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_0_ACCT_ID$1" :=
            
            RTRIM("FLTR_0_ACCOUNTID$1"("FLTR_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_1_ACCT_NAME$1"("ACCOUNT_DIM_i") := 
            
            "EXPR_2_ACCOUNT_NAME$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_1_ACCT_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_2_ACCOUNT_NAME$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_1_ACCT_NAME$1"("ACCOUNT_DIM_i") :=
            
            "EXPR_2_ACCOUNT_NAME$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_1_ACCT_NAME$1" :=
            
            "EXPR_2_ACCOUNT_NAME$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_3_ADDRESS1$1"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_5_ADDRESS1$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_3_ADDRESS1$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_5_ADDRESS1$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_3_ADDRESS1$1"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_5_ADDRESS1$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_3_ADDRESS1$1" :=
            
            "ADDRESS_5_ADDRESS1$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_4_ADDRESS2$1"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_6_ADDRESS2$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_4_ADDRESS2$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_6_ADDRESS2$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_4_ADDRESS2$1"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_6_ADDRESS2$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_4_ADDRESS2$1" :=
            
            "ADDRESS_6_ADDRESS2$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_5_ADDRESS3$1"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_18_ADDRESS3$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_5_ADDRESS3$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_18_ADDRESS3$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_5_ADDRESS3$1"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_18_ADDRESS3$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_5_ADDRESS3$1" :=
            
            "ADDRESS_18_ADDRESS3$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_6_CITY$1"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_7_CITY$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_6_CITY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_7_CITY$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_6_CITY$1"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_7_CITY$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_6_CITY$1" :=
            
            "ADDRESS_7_CITY$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_7_STATE$1"("ACCOUNT_DIM_i") := 
            
            "EXPR_1_2_STATE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_7_STATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_2_STATE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_7_STATE$1"("ACCOUNT_DIM_i") :=
            
            "EXPR_1_2_STATE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_7_STATE$1" :=
            
            "EXPR_1_2_STATE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_8_ZIPCODE$1"("ACCOUNT_DIM_i") := 
            
            "ADDRESS_9_POSTALCODE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_8_ZIPCODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_9_POSTALCODE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_8_ZIPCODE$1"("ACCOUNT_DIM_i") :=
            
            "ADDRESS_9_POSTALCODE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_8_ZIPCODE$1" :=
            
            "ADDRESS_9_POSTALCODE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_9_PROVINCE$1"("ACCOUNT_DIM_i") := 
            
            "EXPR_1_3_PROVINCE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_9_PROVINCE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_3_PROVINCE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_9_PROVINCE$1"("ACCOUNT_DIM_i") :=
            
            "EXPR_1_3_PROVINCE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_9_PROVINCE$1" :=
            
            "EXPR_1_3_PROVINCE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_10_COUNTRY$1"("ACCOUNT_DIM_i") := 
            
            "EXPR_1_4_COUNTRY$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_10_COUNTRY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_4_COUNTRY$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_10_COUNTRY$1"("ACCOUNT_DIM_i") :=
            
            "EXPR_1_4_COUNTRY$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_10_COUNTRY$1" :=
            
            "EXPR_1_4_COUNTRY$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_11_COUNTY$1"("ACCOUNT_DIM_i") := 
            
            "EXPR_3_COUNTY$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_11_COUNTY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_3_COUNTY$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_11_COUNTY$1"("ACCOUNT_DIM_i") :=
            
            "EXPR_3_COUNTY$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_11_COUNTY$1" :=
            
            "EXPR_3_COUNTY$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_12_CREATION_DATE$1"("ACCOUNT_DIM_i") := 
            
            "FLTR_11_CREATEDATE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_12_CREATION_DATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_11_CREATEDATE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_12_CREATION_DATE$1"("ACCOUNT_DIM_i") :=
            
            "FLTR_11_CREATEDATE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_12_CREATION_" :=
            
            "FLTR_11_CREATEDATE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT__13_LAST_UPD$1"("ACCOUNT_DIM_i") := 
            
            "FLTR_12_MODIFYDATE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT__13_LAST_UPD$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_12_MODIFYDATE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT__13_LAST_UPD$1"("ACCOUNT_DIM_i") :=
            
            "FLTR_12_MODIFYDATE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT__13_LAST_UPD$1" :=
            
            "FLTR_12_MODIFYDATE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_18_GKDW_SOURCE$1"("ACCOUNT_DIM_i") := 
            
            "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE";',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_18_GKDW_SOURCE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_18_GKDW_SOURCE$1"("ACCOUNT_DIM_i") :=
            
            "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE";
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_18_GKDW_SOUR" :=
            
            "OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_1_SOURCE";
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT_DIM_22_SIC_CODE$1"("ACCOUNT_DIM_i") := 
            
            "FLTR_7_INDUSTRY$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT_DIM_22_SIC_CODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_7_INDUSTRY$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT_DIM_22_SIC_CODE$1"("ACCOUNT_DIM_i") :=
            
            "FLTR_7_INDUSTRY$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT_DIM_22_SIC_CODE$1" :=
            
            "FLTR_7_INDUSTRY$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ACCOUNT__25_NATIONAL$1"("ACCOUNT_DIM_i") := 
            
            "GET_NATL_TERR_ID_1_VALUE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ACCOUNT__25_NATIONAL$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_NATL_TERR_ID_1_VALUE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ACCOUNT__25_NATIONAL$1"("ACCOUNT_DIM_i") :=
            
            "GET_NATL_TERR_ID_1_VALUE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ACCOUNT__25_NATIONAL$1" :=
            
            "GET_NATL_TERR_ID_1_VALUE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "ACCOUNT_DIM_srk"("ACCOUNT_DIM_i") := get_rowkey + "FLTR_i$1" - 1;
                  ELSIF get_row_status THEN
                    "SV_ACCOUNT_DIM_srk" := get_rowkey + "FLTR_i$1" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "ACCOUNT_DIM_new" := TRUE;
                ELSE
                  "ACCOUNT_DIM_i" := "ACCOUNT_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER$1"('TRACE 49: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i$1");
                  
                  "ACCOUNT_DIM_err" := "ACCOUNT_DIM_err" + 1;
                  
                  IF get_errors + "ACCOUNT_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("ACCOUNT_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "ACCOUNT_DIM_new" 
            AND (NOT "ACCOUNT_DIM_nul") THEN
              "ACCOUNT_DIM_ir"(dml_bsize) := "ACCOUNT_DIM_i";
            	"ACCOUNT_DIM_0_ACCT_ID$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_0_ACCT_ID$1";
            	"ACCOUNT_DIM_1_ACCT_NAME$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_1_ACCT_NAME$1";
            	"ACCOUNT_DIM_3_ADDRESS1$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_3_ADDRESS1$1";
            	"ACCOUNT_DIM_4_ADDRESS2$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_4_ADDRESS2$1";
            	"ACCOUNT_DIM_5_ADDRESS3$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_5_ADDRESS3$1";
            	"ACCOUNT_DIM_6_CITY$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_6_CITY$1";
            	"ACCOUNT_DIM_7_STATE$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_7_STATE$1";
            	"ACCOUNT_DIM_8_ZIPCODE$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_8_ZIPCODE$1";
            	"ACCOUNT_DIM_9_PROVINCE$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_9_PROVINCE$1";
            	"ACCOUNT_DIM_10_COUNTRY$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_10_COUNTRY$1";
            	"ACCOUNT_DIM_11_COUNTY$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_11_COUNTY$1";
            	"ACCOUNT_DIM_12_CREATION_DATE$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_12_CREATION_";
            	"ACCOUNT__13_LAST_UPD$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT__13_LAST_UPD$1";
            	"ACCOUNT_DIM_18_GKDW_SOURCE$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_18_GKDW_SOUR";
            	"ACCOUNT_DIM_22_SIC_CODE$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_22_SIC_CODE$1";
            	"ACCOUNT__25_NATIONAL$1"("ACCOUNT_DIM_i") := "SV_ACCOUNT__25_NATIONAL$1";
              "ACCOUNT_DIM_srk"("ACCOUNT_DIM_i") := "SV_ACCOUNT_DIM_srk";
              "ACCOUNT_DIM_i" := "ACCOUNT_DIM_i" + 1;
            ELSE
              "ACCOUNT_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "FLTR_DML$1"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "FLTR_DML$1"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "FLTR_ER$1"('TRACE 47: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i$1");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "FLTR_c$1"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "FLTR_i$1" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "FLTR_i$1" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "FLTR_c$1";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "ACCOUNT_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"ACCOUNT_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"ACCOUNT_DIM_ins",
        p_upd=>"ACCOUNT_DIM_upd",
        p_del=>"ACCOUNT_DIM_del",
        p_err=>"ACCOUNT_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "ACCOUNT_DIM_ins";
    get_updated  := get_updated  + "ACCOUNT_DIM_upd";
    get_deleted  := get_deleted  + "ACCOUNT_DIM_del";
    get_errors   := get_errors   + "ACCOUNT_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "FLTR_t";







PROCEDURE Initialize(p_env IN WB_RT_MAPAUDIT.WB_RT_NAME_VALUES)  IS
BEGIN
  get_selected := 0;
  get_inserted := 0;
  get_updated  := 0;
  get_deleted  := 0;
  get_merged   := 0;
  get_errors   := 0;
  get_logical_errors := 0;
  get_abort    := FALSE;
  get_abort_procedure  := FALSE;

  FOR i IN 1..p_env.COUNT LOOP
    IF p_env(i).param_value IS NOT NULL THEN
      IF p_env(i).param_name = 'MAX_NO_OF_ERRORS' THEN
        get_max_errors := p_env(i).param_value;

      ELSIF p_env(i).param_name = 'COMMIT_FREQUENCY' THEN
        get_commit_frequency := p_env(i).param_value;
      ELSIF p_env(i).param_name = 'OPERATING_MODE' THEN
        get_operating_mode := p_env(i).param_value;
      ELSIF p_env(i).param_name = 'BULK_SIZE' THEN
        get_bulk_size := p_env(i).param_value;
      ELSIF p_env(i).param_name = 'AUDIT_LEVEL' THEN
        get_audit_level := p_env(i).param_value;
      ELSIF p_env(i).param_name = 'AUDIT_ID' THEN
        get_audit_id := p_env(i).param_value;
      ELSIF p_env(i).param_name = 'PURGE_GROUP' THEN
        get_purge_group := p_env(i).param_value;
      ELSIF p_env(i).param_name = 'OBJECT_ID' THEN
        OWB$MAP_OBJECT_ID := p_env(i).param_value;
      END IF;
    END IF;
  END LOOP;




  IF NOT (get_audit_level = AUDIT_NONE) THEN
    get_runtime_audit_id := WB_RT_MAPAUDIT.audit_begin(  -- Template AuditBegin
      p_auditid=>get_audit_id,
      p_lob_uoid=>get_lob_uoid,
      p_lob_name=>get_model_name,
      p_purge_group=>get_purge_group,
      p_parent=>NULL,
      p_source=>'"SLXDW"."ACCOUNT","SLXDW"."ADDRESS"',
      p_source_uoid=>'A41FFB198D5B5678E040007F01006C7D,A41FFB198D5A5678E040007F01006C7D',
      p_target=>'"ACCOUNT_DIM"',
      p_target_uoid=>'A41FFB198D8A5678E040007F01006C7D',      p_info=>NULL,
      
            p_type=>'PLSQLMap',
      
      p_date=>get_cycle_date
    );
  END IF;



BEGIN
  -- Expression statement
      error_stmt := SUBSTRB('
  
      
      "GET_MAX_DATE"("OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_0_TABLE_NAME","OWB_ACCOUNT_DIM_NEW_SB"."PREMAPPING_1_CREATE_DATE_OUT","OWB_ACCOUNT_DIM_NEW_SB"."PREMAPPING_2_MODIFY_DATE_OUT");
  
  ',0,2000);
  
      
      "GET_MAX_DATE"("OWB_ACCOUNT_DIM_NEW_SB"."GET_CONST_0_TABLE_NAME","OWB_ACCOUNT_DIM_NEW_SB"."PREMAPPING_1_CREATE_DATE_OUT","OWB_ACCOUNT_DIM_NEW_SB"."PREMAPPING_2_MODIFY_DATE_OUT");
  
    -- End expression statement
    
    --"OWB_ACCOUNT_DIM_NEW_SB"."PREMAPPING_1_CREATE_DATE_OUT" := '01-JAN-2011';
    --"OWB_ACCOUNT_DIM_NEW_SB"."PREMAPPING_2_MODIFY_DATE_OUT" := '01-JAN-2011';
  
  
EXCEPTION WHEN OTHERS THEN
  last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
  IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
    WB_RT_MAPAUDIT.error(
      p_rta=>get_runtime_audit_id,
      p_step=>0,
      p_rtd=>NULL,
      p_rowkey=>0,
      p_table=>NULL,
      p_column=>NULL,
      p_dstval=>NULL,
      p_stm=>'PRE_MAP_TRIGGER',
      p_sqlerr=>SQLCODE,
      p_sqlerrm=>SQLERRM,
      p_rowid=>NULL
    );
  END IF;
  get_errors := get_errors + 1;
  get_abort  := TRUE;
  get_trigger_success := FALSE;
END;
  IF NOT get_no_commit THEN
    COMMIT; -- commit no.1
  END IF;
END Initialize;

PROCEDURE Analyze_Targets IS
BEGIN
  FOR i IN 1..tables_to_analyze.COUNT LOOP
    WB_RT_MAPAUDIT_UTIL_INVOKER.gather_table_stats(
      p_ownname          => tables_to_analyze(i).ownname,
      p_tabname          => tables_to_analyze(i).tabname,
      p_estimate_percent => tables_to_analyze(i).estimate_percent,
      p_granularity      => tables_to_analyze(i).granularity,
      p_cascade          => tables_to_analyze(i).cascade,
      p_degree           => tables_to_analyze(i).degree);
  END LOOP;
END Analyze_Targets;


PROCEDURE Finalize(p_env IN WB_RT_MAPAUDIT.WB_RT_NAME_VALUES)  IS
BEGIN
  IF NOT get_no_commit THEN
    COMMIT; -- commit no.13
  END IF;


  IF get_abort THEN
    get_status := 1;
  ELSIF get_errors > 0 THEN
    get_status := 2;
  ELSE
    get_status := 0;
  END IF;
  get_processed := get_inserted + get_deleted + get_updated + get_merged; 
  IF (get_errors = 0) THEN
    get_error_ratio := 0;
  ELSE
    get_error_ratio := (get_errors /(get_errors + get_processed)) * 100;
  END IF;

  IF NOT (get_audit_level = AUDIT_NONE) THEN
  IF get_status = 0 THEN
    WB_RT_MAPAUDIT.audit_end(
      p_rta=>get_runtime_audit_id,
      p_sel=>get_selected,
      p_ins=>get_inserted,
      p_upd=>get_updated,
      p_del=>get_deleted,
      p_err=>get_errors,
      p_dis=>NULL,
      p_logical_err=>get_logical_errors,
      p_mer=>get_merged
    );
  ELSE
    WB_RT_MAPAUDIT.audit_fail(
      p_rta=>get_runtime_audit_id,
      p_status=>get_status,
      p_sel=>get_selected,
      p_ins=>get_inserted,
      p_upd=>get_updated,
      p_del=>get_deleted,
      p_err=>get_errors,
      p_dis=>NULL,
      p_logical_err=>get_logical_errors,
      p_mer=>get_merged
    );
  END IF;
END IF;


  Analyze_Targets;
END Finalize;



FUNCTION Main(p_env IN WB_RT_MAPAUDIT.WB_RT_NAME_VALUES)  RETURN NUMBER IS
get_batch_status           BOOLEAN := TRUE;
BEGIN

  IF WB_RT_MAPAUDIT_UTIL.supportsDesignClient(p_designVersion=>'10.2.0.1.31', p_minRuntimeVersion=>'10.2.0.1.0') < 1 THEN
    raise_application_error(-20103, 'Incompatible runtime and design client versions.');
  END IF;
  Initialize(p_env);
  
  
  
  
  
  -- Initialize all batch status variables
  "ACCOUNT_DIM_St" := FALSE;
  IF get_trigger_success THEN

  --  Processing for different operating modes
  IF get_operating_mode = MODE_SET THEN
    IF get_use_hc AND NOT get_no_commit THEN
      IF get_enable_parallel_dml THEN
        EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
      ELSE
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
      END IF;
    END IF;
		
    IF NOT get_use_hc OR get_batch_status THEN
      "ACCOUNT_DIM_St" := "ACCOUNT_DIM_Bat";
      get_batch_status := get_batch_status AND "ACCOUNT_DIM_St";
    END IF;

    IF get_use_hc THEN
      IF NOT get_batch_status THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
      END IF;
    END IF;

  END IF;
  IF get_operating_mode = MODE_ROW THEN
		"FLTR_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "ACCOUNT_DIM_St" := "ACCOUNT_DIM_Bat";
        get_batch_status := get_batch_status AND "ACCOUNT_DIM_St";
      END IF;
    END IF;
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"ACCOUNT_DIM_St" := FALSE;

      END IF;
    END IF;

"FLTR_p";

  END IF;
  IF get_operating_mode = MODE_ROW_TARGET THEN
"FLTR_t";

  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW_TARGET THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "ACCOUNT_DIM_St" := "ACCOUNT_DIM_Bat";
        get_batch_status := get_batch_status AND "ACCOUNT_DIM_St";
      END IF;
    END IF;
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"ACCOUNT_DIM_St" := FALSE;

    END IF;
"FLTR_t";

  END IF;
END IF;

  Finalize(p_env);
  RETURN get_status;
  END;

FUNCTION encode_operating_mode(p_operating_mode IN VARCHAR2) RETURN NUMBER IS
BEGIN
  IF p_operating_mode IS NULL THEN
    RETURN get_operating_mode;
  END IF;
  IF p_operating_mode = 'SET_BASED' THEN
    RETURN MODE_SET;
  ELSIF p_operating_mode = 'ROW_BASED' THEN
    RETURN MODE_ROW;
  ELSIF p_operating_mode = 'ROW_BASED_TARGET_ONLY' THEN
    RETURN MODE_ROW_TARGET;
  ELSIF p_operating_mode = 'SET_BASED_FAIL_OVER_TO_ROW_BASED' THEN
    RETURN MODE_SET_FAILOVER_ROW;
  ELSE
    RETURN MODE_SET_FAILOVER_ROW_TARGET;
  END IF;
END encode_operating_mode;

FUNCTION encode_audit_level(p_audit_level IN VARCHAR2) RETURN NUMBER IS
BEGIN
  IF p_audit_level IS NULL THEN
    RETURN get_audit_level;
  END IF;
  IF p_audit_level = 'NONE' THEN
    RETURN AUDIT_NONE;
  ELSIF p_audit_level = 'STATISTICS' THEN
    RETURN AUDIT_STATISTICS;
  ELSIF p_audit_level = 'ERROR_DETAILS' THEN
    RETURN AUDIT_ERROR_DETAILS;
  ELSE
    RETURN AUDIT_COMPLETE;
  END IF;
END encode_audit_level;


PROCEDURE Main(p_status OUT VARCHAR2,
               p_max_no_of_errors IN VARCHAR2 DEFAULT NULL,
               p_commit_frequency IN VARCHAR2 DEFAULT NULL,
               p_operating_mode   IN VARCHAR2 DEFAULT NULL,
               p_bulk_size        IN VARCHAR2 DEFAULT NULL,
               p_audit_level      IN VARCHAR2 DEFAULT NULL,
               p_purge_group      IN VARCHAR2 DEFAULT NULL) IS

  x_schema      VARCHAR2(30);

  x_audit_id    NUMBER;
  x_object_id   NUMBER;

  x_env         wb_rt_mapaudit.wb_rt_name_values;
  x_param       wb_rt_mapaudit.wb_rt_name_value;

  x_result      NUMBER;
  x_return_code NUMBER;

BEGIN
  -- validate parameters

  IF NOT wb_rt_mapaudit_util.validate_runtime_parameter('MAX_NO_OF_ERRORS',
                                                        p_max_no_of_errors) OR
     NOT wb_rt_mapaudit_util.validate_runtime_parameter('COMMIT_FREQUENCY',
                                                        p_commit_frequency) OR
     NOT wb_rt_mapaudit_util.validate_runtime_parameter('OPERATING_MODE',
                                                        p_operating_mode)   OR
     NOT wb_rt_mapaudit_util.validate_runtime_parameter('BULK_SIZE',
                                                        p_bulk_size)        OR
     NOT wb_rt_mapaudit_util.validate_runtime_parameter('AUDIT_LEVEL',
                                                        p_audit_level) THEN
    p_status := 'FAILURE';
    RETURN;
  END IF;

  -- perform pre-run setup

  SELECT ao.owner INTO x_schema
  FROM   user_objects uo, all_objects ao
  WHERE  uo.object_type = 'PACKAGE'
  AND    uo.object_name = 'OWB_ACCOUNT_DIM_NEW_SB'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_ACCOUNT_DIM_NEW_SB', x_schema, x_audit_id, x_object_id);

  -- prepare parameters for Main:

  x_param.param_name := 'AUDIT_ID';
  x_param.param_value := x_audit_id;
  x_env(1) := x_param;

  x_param.param_name := 'OBJECT_ID';
  x_param.param_value := x_object_id;
  x_env(2) := x_param;

  x_param.param_name := 'MAX_NO_OF_ERRORS';
  x_param.param_value := p_max_no_of_errors;
  x_env(3) := x_param;

  x_param.param_name := 'COMMIT_FREQUENCY';
  x_param.param_value := p_commit_frequency;
  x_env(4) := x_param;

  x_param.param_name := 'OPERATING_MODE';
  x_param.param_value := encode_operating_mode(p_operating_mode);
  x_env(5) := x_param;

  x_param.param_name := 'BULK_SIZE';
  x_param.param_value := p_bulk_size;
  x_env(6) := x_param;

  x_param.param_name := 'AUDIT_LEVEL';
  x_param.param_value := encode_audit_level(p_audit_level);
  x_env(7) := x_param;

  x_param.param_name := 'PURGE_GROUP';
  x_param.param_value := p_purge_group;
  x_env(8) := x_param;

  -- register "system" parameters:
  FOR i IN 3..8 LOOP
    IF x_env(i).param_value IS NOT NULL THEN
      wb_rt_mapaudit_util.register_sys_param(x_audit_id,
                                             x_env(i).param_name,
                                             x_env(i).param_value);
    END IF;
  END LOOP;

  -- really run it:
  -- return code from mapping is
  --   0 - success
  --   1 - failure
  --   2 - completed (with errors/warnings)
  x_return_code := NULL;
  BEGIN
    x_result := Main(x_env);
  EXCEPTION
    WHEN OTHERS THEN
      x_result := 1;
      x_return_code := SQLCODE;
  END;

  -- perform post map cleanup

  wb_rt_mapaudit_util.postmap(x_audit_id, x_result, x_return_code);

  -- show results:
  wb_rt_mapaudit_util.show_run_results(x_audit_id);

  -- set return status
  IF x_result = 0 THEN
    p_status := 'OK';
  ELSIF x_result = 1 THEN
    p_status := 'FAILURE';
  ELSE
    p_status := 'OK_WITH_WARNINGS';
  END IF;

END Main;

PROCEDURE Close_Cursors IS
BEGIN
BEGIN
  IF "FLTR_c"%ISOPEN THEN
    CLOSE "FLTR_c";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;BEGIN
  IF "FLTR_c$1"%ISOPEN THEN
    CLOSE "FLTR_c$1";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;

END Close_Cursors;



END "OWB_ACCOUNT_DIM_NEW_SB";
/


