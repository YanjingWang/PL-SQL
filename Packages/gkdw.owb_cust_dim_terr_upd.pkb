DROP PACKAGE BODY GKDW.OWB_CUST_DIM_TERR_UPD;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_CUST_DIM_TERR_UPD" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "QG_CONTACT_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "QG_CONTACT_c" IS
  SELECT
  "QG_CONTACT"."CONTACTID" "CONTACTID",
  "QG_CONTACT"."CREATEUSER" "CREATEUSER",
  "QG_CONTACT"."CREATEDATE" "CREATEDATE",
  "QG_CONTACT"."MODIFYUSER" "MODIFYUSER",
  "QG_CONTACT"."MODIFYDATE" "MODIFYDATE",
  "QG_CONTACT"."TITLE_CODE" "TITLE_CODE",
  "QG_CONTACT"."ID_NUMBER" "ID_NUMBER",
  "QG_CONTACT"."LEGACY_NO" "LEGACY_NO",
  "QG_CONTACT"."DELEGATE" "DELEGATE",
  "QG_CONTACT"."DECISION_MAKER" "DECISION_MAKER",
  "QG_CONTACT"."INFLUENCER" "INFLUENCER",
  "QG_CONTACT"."BOOKING_CONTACT" "BOOKING_CONTACT",
  "QG_CONTACT"."EMAIL_NOT_AVAILABLE" "EMAIL_NOT_AVAILABLE",
  "QG_CONTACT"."EMAIL_NOT_AVAILABLE_REASON" "EMAIL_NOT_AVAILABLE_REASON",
  "QG_CONTACT"."CAMPAIGNID" "CAMPAIGNID",
  "QG_CONTACT"."DIRECTNUMBER" "DIRECTNUMBER",
  "QG_CONTACT"."GENDER" "GENDER",
  "QG_CONTACT"."EXTENSION" "EXTENSION",
  "QG_CONTACT"."LEADSOURCEID" "LEADSOURCEID",
  "QG_CONTACT"."QG_TERRITORYID" "QG_TERRITORYID",
  "QG_CONTACT"."ESMID" "ESMID",
  "QG_CONTACT"."UNVERIFIEDTEXT" "UNVERIFIEDTEXT",
  "QG_CONTACT"."VERIFIED" "VERIFIED",
  "QG_CONTACT"."OB_NATIONAL_REP_ID" "OB_NATIONAL_REP_ID",
  "QG_CONTACT"."OB_REP_ID" "OB_REP_ID",
  "QG_CONTACT"."OSR_ID" "OSR_ID",
  "QG_CONTACT"."ENT_NATIONAL_REP_ID" "ENT_NATIONAL_REP_ID",
  "QG_CONTACT"."ENT_INSIDE_REP_ID" "ENT_INSIDE_REP_ID",
  "QG_CONTACT"."ENT_FEDERAL_REP_ID" "ENT_FEDERAL_REP_ID",
  "QG_CONTACT"."NOPROMOGIFTS" "NOPROMOGIFTS",
  "QG_CONTACT"."BTSR_REP_ID" "BTSR_REP_ID",
  "QG_CONTACT"."BTA_REP_ID" "BTA_REP_ID",
  "QG_CONTACT"."EMAIL_STATUS" "EMAIL_STATUS",
  "QG_CONTACT"."ATT_FLAG" "ATT_FLAG",
  "QG_CONTACT"."MAX_STARTDATE" "MAX_STARTDATE",
  "QG_CONTACT"."OSR_FLAG" "OSR_FLAG",
  "QG_CONTACT"."SECTOR" "SECTOR",
  "QG_CONTACT"."OB_NATIONAL_TERR_NUM" "OB_NATIONAL_TERR_NUM",
  "QG_CONTACT"."SUBSECTOR" "SUBSECTOR",
  "QG_CONTACT"."OB_TERR_NUM" "OB_TERR_NUM",
  "QG_CONTACT"."OSR_TERR_NUM" "OSR_TERR_NUM",
  "QG_CONTACT"."ENT_NATIONAL_TERR_NUM" "ENT_NATIONAL_TERR_NUM",
  "QG_CONTACT"."ENT_INSIDE_TERR_NUM" "ENT_INSIDE_TERR_NUM",
  "QG_CONTACT"."ENT_FEDERAL_TERR_NUM" "ENT_FEDERAL_TERR_NUM",
  "QG_CONTACT"."BTSR_TERR_NUM" "BTSR_TERR_NUM",
  "QG_CONTACT"."BTA_TERR_NUM" "BTA_TERR_NUM"
FROM
  "SLXDW"."QG_CONTACT" "QG_CONTACT"; 

---------------------------------------------------------------------------
--
-- "FLTR_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c" IS
  SELECT
  "QG_CONTACT"."CONTACTID" "CONTACTID",
  "QG_CONTACT"."OB_NATIONAL_TERR_NUM" "OB_NATIONAL_TERR_NUM",
  "QG_CONTACT"."OB_NATIONAL_REP_ID" "OB_NATIONAL_REP_ID",
  "GET_USER_NAME"("QG_CONTACT"."OB_NATIONAL_REP_ID") "OB_NATIONAL_REP_ID$1",
  "QG_CONTACT"."OB_TERR_NUM" "OB_TERR_NUM",
  "QG_CONTACT"."OB_REP_ID" "OB_REP_ID",
  "GET_USER_NAME"("QG_CONTACT"."OB_REP_ID") "OB_REP_ID$1",
  "QG_CONTACT"."OSR_TERR_NUM" "OSR_TERR_NUM",
  "QG_CONTACT"."OSR_ID" "OSR_ID",
  "GET_USER_NAME"("QG_CONTACT"."OSR_ID") "OSR_ID$1",
  "QG_CONTACT"."ENT_NATIONAL_TERR_NUM" "ENT_NATIONAL_TERR_NUM",
  "QG_CONTACT"."ENT_NATIONAL_REP_ID" "ENT_NATIONAL_REP_ID",
  "GET_USER_NAME"("QG_CONTACT"."ENT_NATIONAL_REP_ID") "ENT_NATIONAL_REP_ID$1",
  "QG_CONTACT"."ENT_INSIDE_TERR_NUM" "ENT_INSIDE_TERR_NUM",
  "QG_CONTACT"."ENT_INSIDE_REP_ID" "ENT_INSIDE_REP_ID",
  "GET_USER_NAME"("QG_CONTACT"."ENT_INSIDE_REP_ID") "ENT_INSIDE_REP_ID$1",
  "QG_CONTACT"."ENT_FEDERAL_TERR_NUM" "ENT_FEDERAL_TERR_NUM",
  "QG_CONTACT"."ENT_FEDERAL_REP_ID" "ENT_FEDERAL_REP_ID",
  "GET_ORA_TRX_NUM"("QG_CONTACT"."ENT_FEDERAL_REP_ID") "ENT_FEDERAL_REP_ID$1",
  "QG_CONTACT"."BTSR_TERR_NUM" "BTSR_TERR_NUM",
  "QG_CONTACT"."BTSR_REP_ID" "BTSR_REP_ID",
  "GET_USER_NAME"("QG_CONTACT"."BTSR_TERR_NUM") "BTSR_TERR_NUM$1",
  "QG_CONTACT"."BTA_TERR_NUM" "BTA_TERR_NUM",
  "QG_CONTACT"."BTA_REP_ID" "BTA_REP_ID",
  "GET_USER_NAME"("QG_CONTACT"."BTA_TERR_NUM") "BTA_TERR_NUM$1"
FROM
  "SLXDW"."QG_CONTACT" "QG_CONTACT"
  WHERE 
  ( "QG_CONTACT"."CREATEDATE" >= "OWB_CUST_DIM_TERR_UPD"."PREMAPPING_1_CREATE_DATE_OUT" or "QG_CONTACT"."MODIFYDATE" >= "OWB_CUST_DIM_TERR_UPD"."PREMAPPING_2_MODIFY_DATE_OUT" ); 


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
-- Function "CUST_DIM_Bat"
--   performs batch extraction
--   Returns TRUE on success
--   Returns FALSE on failure
---------------------------------------------------------------------------
FUNCTION "CUST_DIM_Bat"
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
      p_name=>'"CUST_DIM_Bat"',
      p_source=>'*',
      p_source_uoid=>'*',
      p_target=>'"CUST_DIM"',
      p_target_uoid=>'A7D1882009AC6CAFE040007F01002A48',
      p_stm=>NULL,p_info=>NULL,
      
      p_exec_mode=>MODE_SET
    );
    get_audit_detail_id := batch_auditd_id;
  	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A7D188200AB96CAFE040007F01002A48', -- Operator CUST_DIM
    p_parent_object_name=>'CUST_DIM',
    p_parent_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'CUST_DIM',
    p_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A7D1882009426CAFE040007F01002A48', -- Operator QG_CONTACT
    p_parent_object_name=>'QG_CONTACT',
    p_parent_object_uoid=>'A41FFB190EF25678E040007F01006C7D', -- Table QG_CONTACT
    p_parent_object_type=>'Table',
    p_object_name=>'QG_CONTACT',
    p_object_uoid=>'A41FFB190EF25678E040007F01006C7D', -- Table QG_CONTACT
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A7D1882009AC6CAFE040007F01002A48', -- Operator CUST_DIM
    p_parent_object_name=>'CUST_DIM',
    p_parent_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'CUST_DIM',
    p_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
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
  
    IF NOT "CUST_DIM_St" THEN
    
      batch_action := 'BATCH MERGE';
batch_selected := SQL%ROWCOUNT;
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
        p_table=>'"CUST_DIM"',
        p_column=>'*',
        p_dstval=>NULL,
        p_stm=>'TRACE 199: ' || batch_action,
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
END "CUST_DIM_Bat";



-- Procedure "QG_CONTACT_p" is the entry point for map "QG_CONTACT_p"

PROCEDURE "QG_CONTACT_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"QG_CONTACT_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."QG_CONTACT"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A7D1882009426CAFE040007F01002A48';
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

"CUST_DIM_id" NUMBER(22) := 0;
"CUST_DIM_ins" NUMBER(22) := 0;
"CUST_DIM_upd" NUMBER(22) := 0;
"CUST_DIM_del" NUMBER(22) := 0;
"CUST_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"CUST_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"CUST_DIM_ir"  index_redirect_array;
"SV_CUST_DIM_srk" NUMBER;
"CUST_DIM_new"  BOOLEAN;
"CUST_DIM_nul"  BOOLEAN := FALSE;

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

"QG_CONTACT_si" NUMBER(22) := 0;

"QG_CONTACT_i" NUMBER(22) := 0;


"CUST_DIM_si" NUMBER(22) := 0;

"CUST_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_QG_CONTACT_0_CONTACTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_QG_CONTACT" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_1_CREATEUSER" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_2_CREATEDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_3_MODIFYUSER" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_4_MODIFYDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_5_TITLE_CODE" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_6_ID_NUMBER" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_7_LEGACY_NO" IS TABLE OF VARCHAR2(80) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_8_DELEGATE" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_9_DECISION_MAKER" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_10_INFLUENCER" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_11_BOOKING_CONTA" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_12_EMAIL_NO" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_13_EMAIL_NO" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_14_CAMPAIGNID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_15_DIRECTNUMBER" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_16_GENDER" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_17_EXTENSION" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_18_LEADSOURCEID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_19_QG_TERRITORYID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_20_ESMID" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_21_UNVERIFIEDTEXT" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_22_VERIFIED" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_23_OB_NATIO" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_24_OB_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_25_OSR_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_26_ENT_NATI" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_27_ENT_INSI" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_28_ENT_FEDE" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_29_NOPROMOGIFTS" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_30_BTSR_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_31_BTA_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_32_EMAIL_STATUS" IS TABLE OF VARCHAR2(5) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_33_ATT_FLAG" IS TABLE OF VARCHAR2(5) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_34_MAX_STARTDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_35_OSR_FLAG" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_36_SECTOR" IS TABLE OF VARCHAR2(120) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_37_OB_NATIO" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_38_SUBSECTOR" IS TABLE OF VARCHAR2(120) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_39_OB_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_40_OSR_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_41_ENT_NATI" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_42_ENT_INSI" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTA_43_ENT_FEDE" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_44_BTSR_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_QG_CONTACT_45_BTA_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_1_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_2_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_3_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_4_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ORA_TRX_NUM_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_5_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_6_1_VALUE" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_0_CUST_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_38_OB_NATIO" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_39_OB_NATIONAL_REP_" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_40_OB_NATIO" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_41_OB_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_42_OB_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_43_OB_REP_NAME" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_44_OSR_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_45_OSR_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_46_OSR_REP_NAME" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_47_ENT_NATI" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_48_ENT_NATI" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_49_ENT_NATI" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_50_ENT_INSI" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_51_ENT_INSIDE_REP_" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_52_ENT_INSI" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_53_ENT_FEDE" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_54_ENT_FEDERAL_REP_" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_55_ENT_FEDE" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_56_BTSR_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_57_BTSR_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_58_BTSR_REP_NAME" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_59_BTA_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_60_BTA_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_61_BTA_REP_NAME" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_QG_CONTACT_0_CONTACTID"  CHAR(12);
"SV_ROWKEY_QG_CONTACT"  VARCHAR2(18);
"SV_QG_CONTACT_1_CREATEUSER"  CHAR(12);
"SV_QG_CONTACT_2_CREATEDATE"  DATE;
"SV_QG_CONTACT_3_MODIFYUSER"  CHAR(12);
"SV_QG_CONTACT_4_MODIFYDATE"  DATE;
"SV_QG_CONTACT_5_TITLE_CODE"  VARCHAR2(32);
"SV_QG_CONTACT_6_ID_NUMBER"  VARCHAR2(32);
"SV_QG_CONTACT_7_LEGACY_NO"  VARCHAR2(80);
"SV_QG_CONTACT_8_DELEGATE"  CHAR(1);
"SV_QG_CONTACT_9_DECISION_MAKER"  CHAR(1);
"SV_QG_CONTACT_10_INFLUENCER"  CHAR(1);
"SV_QG_CONTACT_11_BOOKING_CONTA"  CHAR(1);
"SV_QG_CONTA_12_EMAIL_NO"  CHAR(1);
"SV_QG_CONTA_13_EMAIL_NO"  VARCHAR2(32);
"SV_QG_CONTACT_14_CAMPAIGNID"  CHAR(12);
"SV_QG_CONTACT_15_DIRECTNUMBER"  VARCHAR2(32);
"SV_QG_CONTACT_16_GENDER"  CHAR(1);
"SV_QG_CONTACT_17_EXTENSION"  VARCHAR2(32);
"SV_QG_CONTACT_18_LEADSOURCEID"  CHAR(12);
"SV_QG_CONTACT_19_QG_TERRITORY"  CHAR(12);
"SV_QG_CONTACT_20_ESMID"  VARCHAR2(32);
"SV_QG_CONTACT_21_UNVERIFIEDTE"  VARCHAR2(32);
"SV_QG_CONTACT_22_VERIFIED"  CHAR(1);
"SV_QG_CONTA_23_OB_NATIO"  CHAR(12);
"SV_QG_CONTACT_24_OB_REP_ID"  CHAR(12);
"SV_QG_CONTACT_25_OSR_ID"  CHAR(12);
"SV_QG_CONTA_26_ENT_NATI"  CHAR(12);
"SV_QG_CONTA_27_ENT_INSI"  CHAR(12);
"SV_QG_CONTA_28_ENT_FEDE"  CHAR(12);
"SV_QG_CONTACT_29_NOPROMOGIFTS"  CHAR(1);
"SV_QG_CONTACT_30_BTSR_REP_ID"  CHAR(12);
"SV_QG_CONTACT_31_BTA_REP_ID"  CHAR(12);
"SV_QG_CONTACT_32_EMAIL_STATUS"  VARCHAR2(5);
"SV_QG_CONTACT_33_ATT_FLAG"  VARCHAR2(5);
"SV_QG_CONTACT_34_MAX_STARTDATE"  DATE;
"SV_QG_CONTACT_35_OSR_FLAG"  CHAR(1);
"SV_QG_CONTACT_36_SECTOR"  VARCHAR2(120);
"SV_QG_CONTA_37_OB_NATIO"  VARCHAR2(10);
"SV_QG_CONTACT_38_SUBSECTOR"  VARCHAR2(120);
"SV_QG_CONTACT_39_OB_TERR_NUM"  VARCHAR2(10);
"SV_QG_CONTACT_40_OSR_TERR_NUM"  VARCHAR2(10);
"SV_QG_CONTA_41_ENT_NATI"  VARCHAR2(10);
"SV_QG_CONTA_42_ENT_INSI"  VARCHAR2(10);
"SV_QG_CONTA_43_ENT_FEDE"  VARCHAR2(10);
"SV_QG_CONTACT_44_BTSR_TERR_NUM"  VARCHAR2(10);
"SV_QG_CONTACT_45_BTA_TERR_NUM"  VARCHAR2(10);
"SV_GET_USER_NAME_1_VALUE"  VARCHAR2(32767);
"SV_GET_USER_NAME_1_1_VALUE"  VARCHAR2(32767);
"SV_GET_USER_NAME_2_1_VALUE"  VARCHAR2(32767);
"SV_GET_USER_NAME_3_1_VALUE"  VARCHAR2(32767);
"SV_GET_USER_NAME_4_1_VALUE"  VARCHAR2(32767);
"SV_GET_ORA_TRX_NUM_1_VALUE"  VARCHAR2(32767);
"SV_GET_USER_NAME_5_1_VALUE"  VARCHAR2(32767);
"SV_GET_USER_NAME_6_1_VALUE"  VARCHAR2(32767);
"SV_CUST_DIM_0_CUST_ID"  VARCHAR2(50);
"SV_CUST_DIM_38_OB_NATIO"  VARCHAR2(10);
"SV_CUST_DIM_39_OB_NATIONAL_RE"  CHAR(12);
"SV_CUST_DIM_40_OB_NATIO"  VARCHAR2(64);
"SV_CUST_DIM_41_OB_TERR_NUM"  VARCHAR2(10);
"SV_CUST_DIM_42_OB_REP_ID"  CHAR(12);
"SV_CUST_DIM_43_OB_REP_NAME"  VARCHAR2(64);
"SV_CUST_DIM_44_OSR_TERR_NUM"  VARCHAR2(10);
"SV_CUST_DIM_45_OSR_ID"  CHAR(12);
"SV_CUST_DIM_46_OSR_REP_NAME"  VARCHAR2(64);
"SV_CUST_DIM_47_ENT_NATI"  VARCHAR2(10);
"SV_CUST_DIM_48_ENT_NATI"  CHAR(12);
"SV_CUST_DIM_49_ENT_NATI"  VARCHAR2(64);
"SV_CUST_DIM_50_ENT_INSI"  VARCHAR2(10);
"SV_CUST_DIM_51_ENT_INSIDE_REP_"  CHAR(12);
"SV_CUST_DIM_52_ENT_INSI"  VARCHAR2(64);
"SV_CUST_DIM_53_ENT_FEDE"  VARCHAR2(10);
"SV_CUST_DIM_54_ENT_FEDERAL_RE"  CHAR(12);
"SV_CUST_DIM_55_ENT_FEDE"  VARCHAR2(64);
"SV_CUST_DIM_56_BTSR_TERR_NUM"  VARCHAR2(10);
"SV_CUST_DIM_57_BTSR_REP_ID"  CHAR(12);
"SV_CUST_DIM_58_BTSR_REP_NAME"  VARCHAR2(64);
"SV_CUST_DIM_59_BTA_TERR_NUM"  VARCHAR2(10);
"SV_CUST_DIM_60_BTA_REP_ID"  CHAR(12);
"SV_CUST_DIM_61_BTA_REP_NAME"  VARCHAR2(64);

-- Bulk: intermediate collection variables
"QG_CONTACT_0_CONTACTID" "T_QG_CONTACT_0_CONTACTID";
"ROWKEY_QG_CONTACT" "T_ROWKEY_QG_CONTACT";
"QG_CONTACT_1_CREATEUSER" "T_QG_CONTACT_1_CREATEUSER";
"QG_CONTACT_2_CREATEDATE" "T_QG_CONTACT_2_CREATEDATE";
"QG_CONTACT_3_MODIFYUSER" "T_QG_CONTACT_3_MODIFYUSER";
"QG_CONTACT_4_MODIFYDATE" "T_QG_CONTACT_4_MODIFYDATE";
"QG_CONTACT_5_TITLE_CODE" "T_QG_CONTACT_5_TITLE_CODE";
"QG_CONTACT_6_ID_NUMBER" "T_QG_CONTACT_6_ID_NUMBER";
"QG_CONTACT_7_LEGACY_NO" "T_QG_CONTACT_7_LEGACY_NO";
"QG_CONTACT_8_DELEGATE" "T_QG_CONTACT_8_DELEGATE";
"QG_CONTACT_9_DECISION_MAKER" "T_QG_CONTACT_9_DECISION_MAKER";
"QG_CONTACT_10_INFLUENCER" "T_QG_CONTACT_10_INFLUENCER";
"QG_CONTACT_11_BOOKING_CONTACT" "T_QG_CONTACT_11_BOOKING_CONTA";
"QG_CONTA_12_EMAIL_NO" "T_QG_CONTA_12_EMAIL_NO";
"QG_CONTA_13_EMAIL_NO" "T_QG_CONTA_13_EMAIL_NO";
"QG_CONTACT_14_CAMPAIGNID" "T_QG_CONTACT_14_CAMPAIGNID";
"QG_CONTACT_15_DIRECTNUMBER" "T_QG_CONTACT_15_DIRECTNUMBER";
"QG_CONTACT_16_GENDER" "T_QG_CONTACT_16_GENDER";
"QG_CONTACT_17_EXTENSION" "T_QG_CONTACT_17_EXTENSION";
"QG_CONTACT_18_LEADSOURCEID" "T_QG_CONTACT_18_LEADSOURCEID";
"QG_CONTACT_19_QG_TERRITORYID" "T_QG_CONTACT_19_QG_TERRITORYID";
"QG_CONTACT_20_ESMID" "T_QG_CONTACT_20_ESMID";
"QG_CONTACT_21_UNVERIFIEDTEXT" "T_QG_CONTACT_21_UNVERIFIEDTEXT";
"QG_CONTACT_22_VERIFIED" "T_QG_CONTACT_22_VERIFIED";
"QG_CONTA_23_OB_NATIO" "T_QG_CONTA_23_OB_NATIO";
"QG_CONTACT_24_OB_REP_ID" "T_QG_CONTACT_24_OB_REP_ID";
"QG_CONTACT_25_OSR_ID" "T_QG_CONTACT_25_OSR_ID";
"QG_CONTA_26_ENT_NATI" "T_QG_CONTA_26_ENT_NATI";
"QG_CONTA_27_ENT_INSI" "T_QG_CONTA_27_ENT_INSI";
"QG_CONTA_28_ENT_FEDE" "T_QG_CONTA_28_ENT_FEDE";
"QG_CONTACT_29_NOPROMOGIFTS" "T_QG_CONTACT_29_NOPROMOGIFTS";
"QG_CONTACT_30_BTSR_REP_ID" "T_QG_CONTACT_30_BTSR_REP_ID";
"QG_CONTACT_31_BTA_REP_ID" "T_QG_CONTACT_31_BTA_REP_ID";
"QG_CONTACT_32_EMAIL_STATUS" "T_QG_CONTACT_32_EMAIL_STATUS";
"QG_CONTACT_33_ATT_FLAG" "T_QG_CONTACT_33_ATT_FLAG";
"QG_CONTACT_34_MAX_STARTDATE" "T_QG_CONTACT_34_MAX_STARTDATE";
"QG_CONTACT_35_OSR_FLAG" "T_QG_CONTACT_35_OSR_FLAG";
"QG_CONTACT_36_SECTOR" "T_QG_CONTACT_36_SECTOR";
"QG_CONTA_37_OB_NATIO" "T_QG_CONTA_37_OB_NATIO";
"QG_CONTACT_38_SUBSECTOR" "T_QG_CONTACT_38_SUBSECTOR";
"QG_CONTACT_39_OB_TERR_NUM" "T_QG_CONTACT_39_OB_TERR_NUM";
"QG_CONTACT_40_OSR_TERR_NUM" "T_QG_CONTACT_40_OSR_TERR_NUM";
"QG_CONTA_41_ENT_NATI" "T_QG_CONTA_41_ENT_NATI";
"QG_CONTA_42_ENT_INSI" "T_QG_CONTA_42_ENT_INSI";
"QG_CONTA_43_ENT_FEDE" "T_QG_CONTA_43_ENT_FEDE";
"QG_CONTACT_44_BTSR_TERR_NUM" "T_QG_CONTACT_44_BTSR_TERR_NUM";
"QG_CONTACT_45_BTA_TERR_NUM" "T_QG_CONTACT_45_BTA_TERR_NUM";
"GET_USER_NAME_1_VALUE" "T_GET_USER_NAME_1_VALUE";
"GET_USER_NAME_1_1_VALUE" "T_GET_USER_NAME_1_1_VALUE";
"GET_USER_NAME_2_1_VALUE" "T_GET_USER_NAME_2_1_VALUE";
"GET_USER_NAME_3_1_VALUE" "T_GET_USER_NAME_3_1_VALUE";
"GET_USER_NAME_4_1_VALUE" "T_GET_USER_NAME_4_1_VALUE";
"GET_ORA_TRX_NUM_1_VALUE" "T_GET_ORA_TRX_NUM_1_VALUE";
"GET_USER_NAME_5_1_VALUE" "T_GET_USER_NAME_5_1_VALUE";
"GET_USER_NAME_6_1_VALUE" "T_GET_USER_NAME_6_1_VALUE";
"CUST_DIM_0_CUST_ID" "T_CUST_DIM_0_CUST_ID";
"CUST_DIM_38_OB_NATIO" "T_CUST_DIM_38_OB_NATIO";
"CUST_DIM_39_OB_NATIONAL_REP_ID" "T_CUST_DIM_39_OB_NATIONAL_REP_";
"CUST_DIM_40_OB_NATIO" "T_CUST_DIM_40_OB_NATIO";
"CUST_DIM_41_OB_TERR_NUM" "T_CUST_DIM_41_OB_TERR_NUM";
"CUST_DIM_42_OB_REP_ID" "T_CUST_DIM_42_OB_REP_ID";
"CUST_DIM_43_OB_REP_NAME" "T_CUST_DIM_43_OB_REP_NAME";
"CUST_DIM_44_OSR_TERR_NUM" "T_CUST_DIM_44_OSR_TERR_NUM";
"CUST_DIM_45_OSR_ID" "T_CUST_DIM_45_OSR_ID";
"CUST_DIM_46_OSR_REP_NAME" "T_CUST_DIM_46_OSR_REP_NAME";
"CUST_DIM_47_ENT_NATI" "T_CUST_DIM_47_ENT_NATI";
"CUST_DIM_48_ENT_NATI" "T_CUST_DIM_48_ENT_NATI";
"CUST_DIM_49_ENT_NATI" "T_CUST_DIM_49_ENT_NATI";
"CUST_DIM_50_ENT_INSI" "T_CUST_DIM_50_ENT_INSI";
"CUST_DIM_51_ENT_INSIDE_REP_ID" "T_CUST_DIM_51_ENT_INSIDE_REP_";
"CUST_DIM_52_ENT_INSI" "T_CUST_DIM_52_ENT_INSI";
"CUST_DIM_53_ENT_FEDE" "T_CUST_DIM_53_ENT_FEDE";
"CUST_DIM_54_ENT_FEDERAL_REP_ID" "T_CUST_DIM_54_ENT_FEDERAL_REP_";
"CUST_DIM_55_ENT_FEDE" "T_CUST_DIM_55_ENT_FEDE";
"CUST_DIM_56_BTSR_TERR_NUM" "T_CUST_DIM_56_BTSR_TERR_NUM";
"CUST_DIM_57_BTSR_REP_ID" "T_CUST_DIM_57_BTSR_REP_ID";
"CUST_DIM_58_BTSR_REP_NAME" "T_CUST_DIM_58_BTSR_REP_NAME";
"CUST_DIM_59_BTA_TERR_NUM" "T_CUST_DIM_59_BTA_TERR_NUM";
"CUST_DIM_60_BTA_REP_ID" "T_CUST_DIM_60_BTA_REP_ID";
"CUST_DIM_61_BTA_REP_NAME" "T_CUST_DIM_61_BTA_REP_NAME";

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
PROCEDURE "QG_CONTACT_ES"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_0_CONTACTID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_0_CONTACTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_1_CREATEUSER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_1_CREATEUSER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_2_CREATEDATE',0,80),
    p_value=>SUBSTRB("QG_CONTACT_2_CREATEDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_3_MODIFYUSER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_3_MODIFYUSER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_4_MODIFYDATE',0,80),
    p_value=>SUBSTRB("QG_CONTACT_4_MODIFYDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_5_TITLE_CODE',0,80),
    p_value=>SUBSTRB("QG_CONTACT_5_TITLE_CODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_6_ID_NUMBER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_6_ID_NUMBER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_7_LEGACY_NO',0,80),
    p_value=>SUBSTRB("QG_CONTACT_7_LEGACY_NO"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_8_DELEGATE',0,80),
    p_value=>SUBSTRB("QG_CONTACT_8_DELEGATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_9_DECISION_MAKER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_9_DECISION_MAKER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_10_INFLUENCER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_10_INFLUENCER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_11_BOOKING_CONTACT',0,80),
    p_value=>SUBSTRB("QG_CONTACT_11_BOOKING_CONTACT"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_12_EMAIL_NO',0,80),
    p_value=>SUBSTRB("QG_CONTA_12_EMAIL_NO"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_13_EMAIL_NO',0,80),
    p_value=>SUBSTRB("QG_CONTA_13_EMAIL_NO"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>15,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_14_CAMPAIGNID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_14_CAMPAIGNID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>16,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_15_DIRECTNUMBER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_15_DIRECTNUMBER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>17,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_16_GENDER',0,80),
    p_value=>SUBSTRB("QG_CONTACT_16_GENDER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>18,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_17_EXTENSION',0,80),
    p_value=>SUBSTRB("QG_CONTACT_17_EXTENSION"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>19,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_18_LEADSOURCEID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_18_LEADSOURCEID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>20,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_19_QG_TERRITORYID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_19_QG_TERRITORYID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>21,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_20_ESMID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_20_ESMID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>22,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_21_UNVERIFIEDTEXT',0,80),
    p_value=>SUBSTRB("QG_CONTACT_21_UNVERIFIEDTEXT"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>23,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_22_VERIFIED',0,80),
    p_value=>SUBSTRB("QG_CONTACT_22_VERIFIED"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>24,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_23_OB_NATIO',0,80),
    p_value=>SUBSTRB("QG_CONTA_23_OB_NATIO"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>25,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_24_OB_REP_ID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_24_OB_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>26,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_25_OSR_ID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_25_OSR_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>27,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_26_ENT_NATI',0,80),
    p_value=>SUBSTRB("QG_CONTA_26_ENT_NATI"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>28,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_27_ENT_INSI',0,80),
    p_value=>SUBSTRB("QG_CONTA_27_ENT_INSI"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>29,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_28_ENT_FEDE',0,80),
    p_value=>SUBSTRB("QG_CONTA_28_ENT_FEDE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>30,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_29_NOPROMOGIFTS',0,80),
    p_value=>SUBSTRB("QG_CONTACT_29_NOPROMOGIFTS"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>31,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_30_BTSR_REP_ID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_30_BTSR_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>32,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_31_BTA_REP_ID',0,80),
    p_value=>SUBSTRB("QG_CONTACT_31_BTA_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>33,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_32_EMAIL_STATUS',0,80),
    p_value=>SUBSTRB("QG_CONTACT_32_EMAIL_STATUS"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>34,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_33_ATT_FLAG',0,80),
    p_value=>SUBSTRB("QG_CONTACT_33_ATT_FLAG"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>35,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_34_MAX_STARTDATE',0,80),
    p_value=>SUBSTRB("QG_CONTACT_34_MAX_STARTDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>36,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_35_OSR_FLAG',0,80),
    p_value=>SUBSTRB("QG_CONTACT_35_OSR_FLAG"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>37,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_36_SECTOR',0,80),
    p_value=>SUBSTRB("QG_CONTACT_36_SECTOR"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>38,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_37_OB_NATIO',0,80),
    p_value=>SUBSTRB("QG_CONTA_37_OB_NATIO"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>39,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_38_SUBSECTOR',0,80),
    p_value=>SUBSTRB("QG_CONTACT_38_SUBSECTOR"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>40,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_39_OB_TERR_NUM',0,80),
    p_value=>SUBSTRB("QG_CONTACT_39_OB_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>41,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_40_OSR_TERR_NUM',0,80),
    p_value=>SUBSTRB("QG_CONTACT_40_OSR_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>42,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_41_ENT_NATI',0,80),
    p_value=>SUBSTRB("QG_CONTA_41_ENT_NATI"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>43,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_42_ENT_INSI',0,80),
    p_value=>SUBSTRB("QG_CONTA_42_ENT_INSI"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>44,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTA_43_ENT_FEDE',0,80),
    p_value=>SUBSTRB("QG_CONTA_43_ENT_FEDE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>45,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_44_BTSR_TERR_NUM',0,80),
    p_value=>SUBSTRB("QG_CONTACT_44_BTSR_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>46,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('QG_CONTACT_45_BTA_TERR_NUM',0,80),
    p_value=>SUBSTRB("QG_CONTACT_45_BTA_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "QG_CONTACT_ES";

---------------------------------------------------------------------------
-- Procedure "QG_CONTACT_ER" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "QG_CONTACT_ER"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 200: ' || p_statement,
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
    "QG_CONTACT_ES"(p_error_index);
  END IF;
END "QG_CONTACT_ER";



---------------------------------------------------------------------------
-- Procedure "QG_CONTACT_SU" opens and initializes data source
-- for map "QG_CONTACT_p"
---------------------------------------------------------------------------
PROCEDURE "QG_CONTACT_SU" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "QG_CONTACT_c"%ISOPEN) THEN
    OPEN "QG_CONTACT_c";
  END IF;
  get_read_success := TRUE;
END "QG_CONTACT_SU";

---------------------------------------------------------------------------
-- Procedure "QG_CONTACT_RD" fetches a bulk of rows from
--   the data source for map "QG_CONTACT_p"
---------------------------------------------------------------------------
PROCEDURE "QG_CONTACT_RD" IS
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
    "QG_CONTACT_0_CONTACTID".DELETE;
    "QG_CONTACT_1_CREATEUSER".DELETE;
    "QG_CONTACT_2_CREATEDATE".DELETE;
    "QG_CONTACT_3_MODIFYUSER".DELETE;
    "QG_CONTACT_4_MODIFYDATE".DELETE;
    "QG_CONTACT_5_TITLE_CODE".DELETE;
    "QG_CONTACT_6_ID_NUMBER".DELETE;
    "QG_CONTACT_7_LEGACY_NO".DELETE;
    "QG_CONTACT_8_DELEGATE".DELETE;
    "QG_CONTACT_9_DECISION_MAKER".DELETE;
    "QG_CONTACT_10_INFLUENCER".DELETE;
    "QG_CONTACT_11_BOOKING_CONTACT".DELETE;
    "QG_CONTA_12_EMAIL_NO".DELETE;
    "QG_CONTA_13_EMAIL_NO".DELETE;
    "QG_CONTACT_14_CAMPAIGNID".DELETE;
    "QG_CONTACT_15_DIRECTNUMBER".DELETE;
    "QG_CONTACT_16_GENDER".DELETE;
    "QG_CONTACT_17_EXTENSION".DELETE;
    "QG_CONTACT_18_LEADSOURCEID".DELETE;
    "QG_CONTACT_19_QG_TERRITORYID".DELETE;
    "QG_CONTACT_20_ESMID".DELETE;
    "QG_CONTACT_21_UNVERIFIEDTEXT".DELETE;
    "QG_CONTACT_22_VERIFIED".DELETE;
    "QG_CONTA_23_OB_NATIO".DELETE;
    "QG_CONTACT_24_OB_REP_ID".DELETE;
    "QG_CONTACT_25_OSR_ID".DELETE;
    "QG_CONTA_26_ENT_NATI".DELETE;
    "QG_CONTA_27_ENT_INSI".DELETE;
    "QG_CONTA_28_ENT_FEDE".DELETE;
    "QG_CONTACT_29_NOPROMOGIFTS".DELETE;
    "QG_CONTACT_30_BTSR_REP_ID".DELETE;
    "QG_CONTACT_31_BTA_REP_ID".DELETE;
    "QG_CONTACT_32_EMAIL_STATUS".DELETE;
    "QG_CONTACT_33_ATT_FLAG".DELETE;
    "QG_CONTACT_34_MAX_STARTDATE".DELETE;
    "QG_CONTACT_35_OSR_FLAG".DELETE;
    "QG_CONTACT_36_SECTOR".DELETE;
    "QG_CONTA_37_OB_NATIO".DELETE;
    "QG_CONTACT_38_SUBSECTOR".DELETE;
    "QG_CONTACT_39_OB_TERR_NUM".DELETE;
    "QG_CONTACT_40_OSR_TERR_NUM".DELETE;
    "QG_CONTA_41_ENT_NATI".DELETE;
    "QG_CONTA_42_ENT_INSI".DELETE;
    "QG_CONTA_43_ENT_FEDE".DELETE;
    "QG_CONTACT_44_BTSR_TERR_NUM".DELETE;
    "QG_CONTACT_45_BTA_TERR_NUM".DELETE;

    FETCH
      "QG_CONTACT_c"
    BULK COLLECT INTO
      "QG_CONTACT_0_CONTACTID",
      "QG_CONTACT_1_CREATEUSER",
      "QG_CONTACT_2_CREATEDATE",
      "QG_CONTACT_3_MODIFYUSER",
      "QG_CONTACT_4_MODIFYDATE",
      "QG_CONTACT_5_TITLE_CODE",
      "QG_CONTACT_6_ID_NUMBER",
      "QG_CONTACT_7_LEGACY_NO",
      "QG_CONTACT_8_DELEGATE",
      "QG_CONTACT_9_DECISION_MAKER",
      "QG_CONTACT_10_INFLUENCER",
      "QG_CONTACT_11_BOOKING_CONTACT",
      "QG_CONTA_12_EMAIL_NO",
      "QG_CONTA_13_EMAIL_NO",
      "QG_CONTACT_14_CAMPAIGNID",
      "QG_CONTACT_15_DIRECTNUMBER",
      "QG_CONTACT_16_GENDER",
      "QG_CONTACT_17_EXTENSION",
      "QG_CONTACT_18_LEADSOURCEID",
      "QG_CONTACT_19_QG_TERRITORYID",
      "QG_CONTACT_20_ESMID",
      "QG_CONTACT_21_UNVERIFIEDTEXT",
      "QG_CONTACT_22_VERIFIED",
      "QG_CONTA_23_OB_NATIO",
      "QG_CONTACT_24_OB_REP_ID",
      "QG_CONTACT_25_OSR_ID",
      "QG_CONTA_26_ENT_NATI",
      "QG_CONTA_27_ENT_INSI",
      "QG_CONTA_28_ENT_FEDE",
      "QG_CONTACT_29_NOPROMOGIFTS",
      "QG_CONTACT_30_BTSR_REP_ID",
      "QG_CONTACT_31_BTA_REP_ID",
      "QG_CONTACT_32_EMAIL_STATUS",
      "QG_CONTACT_33_ATT_FLAG",
      "QG_CONTACT_34_MAX_STARTDATE",
      "QG_CONTACT_35_OSR_FLAG",
      "QG_CONTACT_36_SECTOR",
      "QG_CONTA_37_OB_NATIO",
      "QG_CONTACT_38_SUBSECTOR",
      "QG_CONTACT_39_OB_TERR_NUM",
      "QG_CONTACT_40_OSR_TERR_NUM",
      "QG_CONTA_41_ENT_NATI",
      "QG_CONTA_42_ENT_INSI",
      "QG_CONTA_43_ENT_FEDE",
      "QG_CONTACT_44_BTSR_TERR_NUM",
      "QG_CONTACT_45_BTA_TERR_NUM"
    LIMIT get_bulk_size;

    IF "QG_CONTACT_c"%NOTFOUND AND "QG_CONTACT_0_CONTACTID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "QG_CONTACT_0_CONTACTID".COUNT;
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
    get_map_selected := get_map_selected + "QG_CONTACT_0_CONTACTID".COUNT;
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
          p_stm=>'TRACE 201: SELECT',
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
END "QG_CONTACT_RD";

---------------------------------------------------------------------------
-- Procedure "QG_CONTACT_DML" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "QG_CONTACT_DML"(si NUMBER, firstround BOOLEAN) IS
  "CUST_DIM_upd0" NUMBER := "CUST_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "CUST_DIM_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "CUST_DIM_nul")) THEN
    -- Update DML for "CUST_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"CUST_DIM"';
    get_audit_detail_id := "CUST_DIM_id";
  
    IF get_use_hc AND NOT firstround THEN
      "CUST_DIM_si" := "CUST_DIM_ir"(si);
      IF "CUST_DIM_si" = 0 THEN
        "CUST_DIM_i" := 0;
      ELSE
        "CUST_DIM_i" := "CUST_DIM_si" + 1;
      END IF;
    ELSE
      "CUST_DIM_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "CUST_DIM_i" <= get_bulk_size 
   AND "QG_CONTACT_c"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "CUST_DIM_si" >= "CUST_DIM_i";
      END IF;
  
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "CUST_DIM_si".."CUST_DIM_i" - 1
          UPDATE
          /*+ APPEND PARALLEL("CUST_DIM") */
            "CUST_DIM"
          SET
  
  					"CUST_DIM"."OB_NATIONAL_TERR_NUM" = "CUST_DIM_38_OB_NATIO"
  (i),
  					"CUST_DIM"."OB_NATIONAL_REP_ID" = "CUST_DIM_39_OB_NATIONAL_REP_ID"
  (i),
  					"CUST_DIM"."OB_NATIONAL_REP_NAME" = "CUST_DIM_40_OB_NATIO"
  (i),
  					"CUST_DIM"."OB_TERR_NUM" = "CUST_DIM_41_OB_TERR_NUM"
  (i),
  					"CUST_DIM"."OB_REP_ID" = "CUST_DIM_42_OB_REP_ID"
  (i),
  					"CUST_DIM"."OB_REP_NAME" = "CUST_DIM_43_OB_REP_NAME"
  (i),
  					"CUST_DIM"."OSR_TERR_NUM" = "CUST_DIM_44_OSR_TERR_NUM"
  (i),
  					"CUST_DIM"."OSR_ID" = "CUST_DIM_45_OSR_ID"
  (i),
  					"CUST_DIM"."OSR_REP_NAME" = "CUST_DIM_46_OSR_REP_NAME"
  (i),
  					"CUST_DIM"."ENT_NATIONAL_TERR_NUM" = "CUST_DIM_47_ENT_NATI"
  (i),
  					"CUST_DIM"."ENT_NATIONAL_REP_ID" = "CUST_DIM_48_ENT_NATI"
  (i),
  					"CUST_DIM"."ENT_NATIONAL_REP_NAME" = "CUST_DIM_49_ENT_NATI"
  (i),
  					"CUST_DIM"."ENT_INSIDE_TERR_NUM" = "CUST_DIM_50_ENT_INSI"
  (i),
  					"CUST_DIM"."ENT_INSIDE_REP_ID" = "CUST_DIM_51_ENT_INSIDE_REP_ID"
  (i),
  					"CUST_DIM"."ENT_INSIDE_REP_NAME" = "CUST_DIM_52_ENT_INSI"
  (i),
  					"CUST_DIM"."ENT_FEDERAL_TERR_NUM" = "CUST_DIM_53_ENT_FEDE"
  (i),
  					"CUST_DIM"."ENT_FEDERAL_REP_ID" = "CUST_DIM_54_ENT_FEDERAL_REP_ID"
  (i),
  					"CUST_DIM"."ENT_FEDERAL_REP_NAME" = "CUST_DIM_55_ENT_FEDE"
  (i),
  					"CUST_DIM"."BTSR_TERR_NUM" = "CUST_DIM_56_BTSR_TERR_NUM"
  (i),
  					"CUST_DIM"."BTSR_REP_ID" = "CUST_DIM_57_BTSR_REP_ID"
  (i),
  					"CUST_DIM"."BTSR_REP_NAME" = "CUST_DIM_58_BTSR_REP_NAME"
  (i),
  					"CUST_DIM"."BTA_TERR_NUM" = "CUST_DIM_59_BTA_TERR_NUM"
  (i),
  					"CUST_DIM"."BTA_REP_ID" = "CUST_DIM_60_BTA_REP_ID"
  (i),
  					"CUST_DIM"."BTA_REP_NAME" = "CUST_DIM_61_BTA_REP_NAME"
  (i)
  
          WHERE
  
  
  					"CUST_DIM"."CUST_ID" = "CUST_DIM_0_CUST_ID"
  (i)
  
          RETURNING ROWID BULK COLLECT INTO get_rowid;
          
        feedback_bulk_limit := "CUST_DIM_i" - 1;
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "CUST_DIM_si"..feedback_bulk_limit LOOP
          IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              get_rowkey_bulk(rowkey_bulk_index) := "CUST_DIM_srk"(rowkey_index);
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
  
        "CUST_DIM_upd" := "CUST_DIM_upd" + get_rowid.COUNT;
        "CUST_DIM_si" := "CUST_DIM_i";
  
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          IF get_use_hc THEN
            get_row_status := FALSE;
            ROLLBACK;
            IF firstround THEN
              EXIT;
            END IF;
          END IF;
          IF NOT get_use_hc THEN
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "CUST_DIM_si".."CUST_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "CUST_DIM_si"..feedback_bulk_limit LOOP
              IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "CUST_DIM_srk"(rowkey_index);
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
            "CUST_DIM_upd" := "CUST_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "CUST_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
          END IF;
          LOOP
            BEGIN
              IF get_use_hc AND NOT get_row_status THEN
                last_successful_index := si;
                RAISE;
              END IF;
  
  
              UPDATE
              /*+ APPEND PARALLEL("CUST_DIM") */
                "CUST_DIM"
              SET
  
  							"CUST_DIM"."OB_NATIONAL_TERR_NUM" = "CUST_DIM_38_OB_NATIO"
  (last_successful_index),
  							"CUST_DIM"."OB_NATIONAL_REP_ID" = "CUST_DIM_39_OB_NATIONAL_REP_ID"
  (last_successful_index),
  							"CUST_DIM"."OB_NATIONAL_REP_NAME" = "CUST_DIM_40_OB_NATIO"
  (last_successful_index),
  							"CUST_DIM"."OB_TERR_NUM" = "CUST_DIM_41_OB_TERR_NUM"
  (last_successful_index),
  							"CUST_DIM"."OB_REP_ID" = "CUST_DIM_42_OB_REP_ID"
  (last_successful_index),
  							"CUST_DIM"."OB_REP_NAME" = "CUST_DIM_43_OB_REP_NAME"
  (last_successful_index),
  							"CUST_DIM"."OSR_TERR_NUM" = "CUST_DIM_44_OSR_TERR_NUM"
  (last_successful_index),
  							"CUST_DIM"."OSR_ID" = "CUST_DIM_45_OSR_ID"
  (last_successful_index),
  							"CUST_DIM"."OSR_REP_NAME" = "CUST_DIM_46_OSR_REP_NAME"
  (last_successful_index),
  							"CUST_DIM"."ENT_NATIONAL_TERR_NUM" = "CUST_DIM_47_ENT_NATI"
  (last_successful_index),
  							"CUST_DIM"."ENT_NATIONAL_REP_ID" = "CUST_DIM_48_ENT_NATI"
  (last_successful_index),
  							"CUST_DIM"."ENT_NATIONAL_REP_NAME" = "CUST_DIM_49_ENT_NATI"
  (last_successful_index),
  							"CUST_DIM"."ENT_INSIDE_TERR_NUM" = "CUST_DIM_50_ENT_INSI"
  (last_successful_index),
  							"CUST_DIM"."ENT_INSIDE_REP_ID" = "CUST_DIM_51_ENT_INSIDE_REP_ID"
  (last_successful_index),
  							"CUST_DIM"."ENT_INSIDE_REP_NAME" = "CUST_DIM_52_ENT_INSI"
  (last_successful_index),
  							"CUST_DIM"."ENT_FEDERAL_TERR_NUM" = "CUST_DIM_53_ENT_FEDE"
  (last_successful_index),
  							"CUST_DIM"."ENT_FEDERAL_REP_ID" = "CUST_DIM_54_ENT_FEDERAL_REP_ID"
  (last_successful_index),
  							"CUST_DIM"."ENT_FEDERAL_REP_NAME" = "CUST_DIM_55_ENT_FEDE"
  (last_successful_index),
  							"CUST_DIM"."BTSR_TERR_NUM" = "CUST_DIM_56_BTSR_TERR_NUM"
  (last_successful_index),
  							"CUST_DIM"."BTSR_REP_ID" = "CUST_DIM_57_BTSR_REP_ID"
  (last_successful_index),
  							"CUST_DIM"."BTSR_REP_NAME" = "CUST_DIM_58_BTSR_REP_NAME"
  (last_successful_index),
  							"CUST_DIM"."BTA_TERR_NUM" = "CUST_DIM_59_BTA_TERR_NUM"
  (last_successful_index),
  							"CUST_DIM"."BTA_REP_ID" = "CUST_DIM_60_BTA_REP_ID"
  (last_successful_index),
  							"CUST_DIM"."BTA_REP_NAME" = "CUST_DIM_61_BTA_REP_NAME"
  (last_successful_index)
  
              WHERE
  
  
  							"CUST_DIM"."CUST_ID" = "CUST_DIM_0_CUST_ID"
  (last_successful_index)
  
                ;
              
              last_successful_index := last_successful_index + 1;
            EXCEPTION
              WHEN OTHERS THEN
                  last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
                IF get_use_hc THEN
                  get_row_status := FALSE;
                  ROLLBACK;
                END IF;
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  error_rowkey := "CUST_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_NATIONAL_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_38_OB_NATIO"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_NATIONAL_REP_ID"',0,80),SUBSTRB("CUST_DIM_39_OB_NATIONAL_REP_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_NATIONAL_REP_NAME"',0,80),SUBSTRB("CUST_DIM_40_OB_NATIO"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_41_OB_TERR_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_REP_ID"',0,80),SUBSTRB("CUST_DIM_42_OB_REP_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_REP_NAME"',0,80),SUBSTRB("CUST_DIM_43_OB_REP_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OSR_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_44_OSR_TERR_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OSR_ID"',0,80),SUBSTRB("CUST_DIM_45_OSR_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OSR_REP_NAME"',0,80),SUBSTRB("CUST_DIM_46_OSR_REP_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_NATIONAL_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_47_ENT_NATI"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_NATIONAL_REP_ID"',0,80),SUBSTRB("CUST_DIM_48_ENT_NATI"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_NATIONAL_REP_NAME"',0,80),SUBSTRB("CUST_DIM_49_ENT_NATI"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_INSIDE_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_50_ENT_INSI"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_INSIDE_REP_ID"',0,80),SUBSTRB("CUST_DIM_51_ENT_INSIDE_REP_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_INSIDE_REP_NAME"',0,80),SUBSTRB("CUST_DIM_52_ENT_INSI"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_FEDERAL_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_53_ENT_FEDE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_FEDERAL_REP_ID"',0,80),SUBSTRB("CUST_DIM_54_ENT_FEDERAL_REP_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_FEDERAL_REP_NAME"',0,80),SUBSTRB("CUST_DIM_55_ENT_FEDE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTSR_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_56_BTSR_TERR_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTSR_REP_ID"',0,80),SUBSTRB("CUST_DIM_57_BTSR_REP_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTSR_REP_NAME"',0,80),SUBSTRB("CUST_DIM_58_BTSR_REP_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTA_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_59_BTA_TERR_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTA_REP_ID"',0,80),SUBSTRB("CUST_DIM_60_BTA_REP_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTA_REP_NAME"',0,80),SUBSTRB("CUST_DIM_61_BTA_REP_NAME"(last_successful_index),0,2000));
                  
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
                "CUST_DIM_err" := "CUST_DIM_err" + 1;
                
                IF get_errors + "CUST_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "CUST_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "CUST_DIM_si" >= "CUST_DIM_i" OR get_abort THEN
        "CUST_DIM_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "CUST_DIM_i" := 1; 
  END IF;
  
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "CUST_DIM_upd" := "CUST_DIM_upd0";
  END IF;

END "QG_CONTACT_DML";

---------------------------------------------------------------------------
-- "QG_CONTACT_p" main
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

  IF NOT "CUST_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "QG_CONTACT_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "CUST_DIM_St" THEN
          "CUST_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"CUST_DIM"',
              p_target_uoid=>'A7D1882009AC6CAFE040007F01002A48',
              p_stm=>'TRACE 203',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "CUST_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7D188200AB96CAFE040007F01002A48', -- Operator CUST_DIM
              p_parent_object_name=>'CUST_DIM',
              p_parent_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'CUST_DIM',
              p_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7D1882009426CAFE040007F01002A48', -- Operator QG_CONTACT
              p_parent_object_name=>'QG_CONTACT',
              p_parent_object_uoid=>'A41FFB190EF25678E040007F01006C7D', -- Table QG_CONTACT
              p_parent_object_type=>'Table',
              p_object_name=>'QG_CONTACT',
              p_object_uoid=>'A41FFB190EF25678E040007F01006C7D', -- Table QG_CONTACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7D1882009AC6CAFE040007F01002A48', -- Operator CUST_DIM
              p_parent_object_name=>'CUST_DIM',
              p_parent_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'CUST_DIM',
              p_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
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
    "QG_CONTACT_si" := 0;
    "CUST_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "QG_CONTACT_SU";

      LOOP
        IF "QG_CONTACT_si" = 0 THEN
          "QG_CONTACT_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "QG_CONTACT_0_CONTACTID".COUNT - 1;
          ELSE
            bulk_count := "QG_CONTACT_0_CONTACTID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "CUST_DIM_ir".DELETE;
"CUST_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "QG_CONTACT_i" := "QG_CONTACT_si";
        BEGIN
          
          LOOP
            EXIT WHEN "CUST_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "QG_CONTACT_i" := "QG_CONTACT_i" + 1;
            "QG_CONTACT_si" := "QG_CONTACT_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "CUST_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("QG_CONTACT_c"%NOTFOUND AND
               "QG_CONTACT_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "QG_CONTACT_i" > bulk_count THEN
            
              "QG_CONTACT_si" := 0;
              EXIT;
            END IF;


            

            IF get_buffer_done(get_buffer_done_index) OR
            	( "QG_CONTACT_2_CREATEDATE"("QG_CONTACT_i") >= "PREMAPPING_1_CREATE_DATE_OUT"  
  or  "QG_CONTACT_4_MODIFYDATE"("QG_CONTACT_i") >= "PREMAPPING_2_MODIFY_DATE_OUT"  )/* FLTR */ THEN
            
            
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTA_23_OB_NATIO"
              ("QG_CONTACT_i"))));
              
              ',0,2000);
              
              
              "GET_USER_NAME_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTA_23_OB_NATIO"
              ("QG_CONTACT_i"))));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_6_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"("QG_CONTACT_45_BTA_TERR_NUM"
              ("QG_CONTACT_i"));
              
              ',0,2000);
              
              
              "GET_USER_NAME_6_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"("QG_CONTACT_45_BTA_TERR_NUM"
              ("QG_CONTACT_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_1_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTACT_24_OB_REP_ID"
              ("QG_CONTACT_i"))));
              
              ',0,2000);
              
              
              "GET_USER_NAME_1_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTACT_24_OB_REP_ID"
              ("QG_CONTACT_i"))));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_3_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTA_26_ENT_NATI"
              ("QG_CONTACT_i"))));
              
              ',0,2000);
              
              
              "GET_USER_NAME_3_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTA_26_ENT_NATI"
              ("QG_CONTACT_i"))));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_4_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTA_27_ENT_INSI"
              ("QG_CONTACT_i"))));
              
              ',0,2000);
              
              
              "GET_USER_NAME_4_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTA_27_ENT_INSI"
              ("QG_CONTACT_i"))));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_2_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTACT_25_OSR_ID"
              ("QG_CONTACT_i"))));
              
              ',0,2000);
              
              
              "GET_USER_NAME_2_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"((RTRIM("QG_CONTACT_25_OSR_ID"
              ("QG_CONTACT_i"))));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_ORA_TRX_NUM_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_ORA_TRX_NUM"((RTRIM("QG_CONTA_28_ENT_FEDE"
              ("QG_CONTACT_i"))));
              
              ',0,2000);
              
              
              "GET_ORA_TRX_NUM_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_ORA_TRX_NUM"((RTRIM("QG_CONTA_28_ENT_FEDE"
              ("QG_CONTACT_i"))));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
              
              "GET_USER_NAME_5_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"("QG_CONTACT_44_BTSR_TERR_NUM"
              ("QG_CONTACT_i"));
              
              ',0,2000);
              
              
              "GET_USER_NAME_5_1_VALUE"
              ("QG_CONTACT_i") := 
              "GET_USER_NAME"("QG_CONTACT_44_BTSR_TERR_NUM"
              ("QG_CONTACT_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              
get_target_name := '"CUST_DIM"';
              get_audit_detail_id := "CUST_DIM_id";
              IF NOT "CUST_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
                BEGIN
                  get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
              		error_stmt := SUBSTRB('"CUST_DIM_0_CUST_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTACT_0_CONTACTID"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_0_CUST_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTACT_0_CONTACTID"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_0_CUST_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTACT_0_CONTACTID"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_0_CUST_ID" :=
              
              RTRIM("QG_CONTACT_0_CONTACTID"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_38_OB_NATIO"("CUST_DIM_i") := 
              
              "QG_CONTA_37_OB_NATIO"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_38_OB_NATIO"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTA_37_OB_NATIO"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_38_OB_NATIO"("CUST_DIM_i") :=
              
              "QG_CONTA_37_OB_NATIO"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_38_OB_NATIO" :=
              
              "QG_CONTA_37_OB_NATIO"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_39_OB_NATIONAL_REP_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTA_23_OB_NATIO"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_39_OB_NATIONAL_REP_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTA_23_OB_NATIO"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_39_OB_NATIONAL_REP_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTA_23_OB_NATIO"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_39_OB_NATIONAL_RE" :=
              
              RTRIM("QG_CONTA_23_OB_NATIO"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_40_OB_NATIO"("CUST_DIM_i") := 
              
              "GET_USER_NAME_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_40_OB_NATIO"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_40_OB_NATIO"("CUST_DIM_i") :=
              
              "GET_USER_NAME_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_40_OB_NATIO" :=
              
              "GET_USER_NAME_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_41_OB_TERR_NUM"("CUST_DIM_i") := 
              
              "QG_CONTACT_39_OB_TERR_NUM"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_41_OB_TERR_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTACT_39_OB_TERR_NUM"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_41_OB_TERR_NUM"("CUST_DIM_i") :=
              
              "QG_CONTACT_39_OB_TERR_NUM"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_41_OB_TERR_NUM" :=
              
              "QG_CONTACT_39_OB_TERR_NUM"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_42_OB_REP_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTACT_24_OB_REP_ID"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_42_OB_REP_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTACT_24_OB_REP_ID"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_42_OB_REP_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTACT_24_OB_REP_ID"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_42_OB_REP_ID" :=
              
              RTRIM("QG_CONTACT_24_OB_REP_ID"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_43_OB_REP_NAME"("CUST_DIM_i") := 
              
              "GET_USER_NAME_1_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_43_OB_REP_NAME"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_1_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_43_OB_REP_NAME"("CUST_DIM_i") :=
              
              "GET_USER_NAME_1_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_43_OB_REP_NAME" :=
              
              "GET_USER_NAME_1_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_44_OSR_TERR_NUM"("CUST_DIM_i") := 
              
              "QG_CONTACT_40_OSR_TERR_NUM"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_44_OSR_TERR_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTACT_40_OSR_TERR_NUM"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_44_OSR_TERR_NUM"("CUST_DIM_i") :=
              
              "QG_CONTACT_40_OSR_TERR_NUM"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_44_OSR_TERR_NUM" :=
              
              "QG_CONTACT_40_OSR_TERR_NUM"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_45_OSR_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTACT_25_OSR_ID"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_45_OSR_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTACT_25_OSR_ID"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_45_OSR_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTACT_25_OSR_ID"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_45_OSR_ID" :=
              
              RTRIM("QG_CONTACT_25_OSR_ID"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_46_OSR_REP_NAME"("CUST_DIM_i") := 
              
              "GET_USER_NAME_2_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_46_OSR_REP_NAME"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_2_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_46_OSR_REP_NAME"("CUST_DIM_i") :=
              
              "GET_USER_NAME_2_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_46_OSR_REP_NAME" :=
              
              "GET_USER_NAME_2_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_47_ENT_NATI"("CUST_DIM_i") := 
              
              "QG_CONTA_41_ENT_NATI"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_47_ENT_NATI"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTA_41_ENT_NATI"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_47_ENT_NATI"("CUST_DIM_i") :=
              
              "QG_CONTA_41_ENT_NATI"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_47_ENT_NATI" :=
              
              "QG_CONTA_41_ENT_NATI"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_48_ENT_NATI"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTA_26_ENT_NATI"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_48_ENT_NATI"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTA_26_ENT_NATI"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_48_ENT_NATI"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTA_26_ENT_NATI"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_48_ENT_NATI" :=
              
              RTRIM("QG_CONTA_26_ENT_NATI"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_49_ENT_NATI"("CUST_DIM_i") := 
              
              "GET_USER_NAME_3_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_49_ENT_NATI"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_3_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_49_ENT_NATI"("CUST_DIM_i") :=
              
              "GET_USER_NAME_3_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_49_ENT_NATI" :=
              
              "GET_USER_NAME_3_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_50_ENT_INSI"("CUST_DIM_i") := 
              
              "QG_CONTA_42_ENT_INSI"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_50_ENT_INSI"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTA_42_ENT_INSI"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_50_ENT_INSI"("CUST_DIM_i") :=
              
              "QG_CONTA_42_ENT_INSI"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_50_ENT_INSI" :=
              
              "QG_CONTA_42_ENT_INSI"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_51_ENT_INSIDE_REP_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTA_27_ENT_INSI"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_51_ENT_INSIDE_REP_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTA_27_ENT_INSI"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_51_ENT_INSIDE_REP_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTA_27_ENT_INSI"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_51_ENT_INSIDE_REP_" :=
              
              RTRIM("QG_CONTA_27_ENT_INSI"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_52_ENT_INSI"("CUST_DIM_i") := 
              
              "GET_USER_NAME_4_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_52_ENT_INSI"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_4_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_52_ENT_INSI"("CUST_DIM_i") :=
              
              "GET_USER_NAME_4_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_52_ENT_INSI" :=
              
              "GET_USER_NAME_4_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_53_ENT_FEDE"("CUST_DIM_i") := 
              
              "QG_CONTA_43_ENT_FEDE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_53_ENT_FEDE"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTA_43_ENT_FEDE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_53_ENT_FEDE"("CUST_DIM_i") :=
              
              "QG_CONTA_43_ENT_FEDE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_53_ENT_FEDE" :=
              
              "QG_CONTA_43_ENT_FEDE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_54_ENT_FEDERAL_REP_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTA_28_ENT_FEDE"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_54_ENT_FEDERAL_REP_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTA_28_ENT_FEDE"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_54_ENT_FEDERAL_REP_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTA_28_ENT_FEDE"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_54_ENT_FEDERAL_RE" :=
              
              RTRIM("QG_CONTA_28_ENT_FEDE"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_55_ENT_FEDE"("CUST_DIM_i") := 
              
              "GET_ORA_TRX_NUM_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_55_ENT_FEDE"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ORA_TRX_NUM_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_55_ENT_FEDE"("CUST_DIM_i") :=
              
              "GET_ORA_TRX_NUM_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_55_ENT_FEDE" :=
              
              "GET_ORA_TRX_NUM_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_56_BTSR_TERR_NUM"("CUST_DIM_i") := 
              
              "QG_CONTACT_44_BTSR_TERR_NUM"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_56_BTSR_TERR_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTACT_44_BTSR_TERR_NUM"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_56_BTSR_TERR_NUM"("CUST_DIM_i") :=
              
              "QG_CONTACT_44_BTSR_TERR_NUM"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_56_BTSR_TERR_NUM" :=
              
              "QG_CONTACT_44_BTSR_TERR_NUM"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_57_BTSR_REP_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTACT_30_BTSR_REP_ID"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_57_BTSR_REP_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTACT_30_BTSR_REP_ID"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_57_BTSR_REP_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTACT_30_BTSR_REP_ID"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_57_BTSR_REP_ID" :=
              
              RTRIM("QG_CONTACT_30_BTSR_REP_ID"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_58_BTSR_REP_NAME"("CUST_DIM_i") := 
              
              "GET_USER_NAME_5_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_58_BTSR_REP_NAME"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_5_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_58_BTSR_REP_NAME"("CUST_DIM_i") :=
              
              "GET_USER_NAME_5_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_58_BTSR_REP_NAME" :=
              
              "GET_USER_NAME_5_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_59_BTA_TERR_NUM"("CUST_DIM_i") := 
              
              "QG_CONTACT_45_BTA_TERR_NUM"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_59_BTA_TERR_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("QG_CONTACT_45_BTA_TERR_NUM"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_59_BTA_TERR_NUM"("CUST_DIM_i") :=
              
              "QG_CONTACT_45_BTA_TERR_NUM"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_59_BTA_TERR_NUM" :=
              
              "QG_CONTACT_45_BTA_TERR_NUM"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_60_BTA_REP_ID"("CUST_DIM_i") := 
              
              RTRIM("QG_CONTACT_31_BTA_REP_ID"("QG_CONTACT_i"));',0,2000);
              error_column := SUBSTRB('"CUST_DIM_60_BTA_REP_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("QG_CONTACT_31_BTA_REP_ID"("QG_CONTACT_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_60_BTA_REP_ID"("CUST_DIM_i") :=
              
              RTRIM("QG_CONTACT_31_BTA_REP_ID"("QG_CONTACT_i"));
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_60_BTA_REP_ID" :=
              
              RTRIM("QG_CONTACT_31_BTA_REP_ID"("QG_CONTACT_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"CUST_DIM_61_BTA_REP_NAME"("CUST_DIM_i") := 
              
              "GET_USER_NAME_6_1_VALUE"("QG_CONTACT_i");',0,2000);
              error_column := SUBSTRB('"CUST_DIM_61_BTA_REP_NAME"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_USER_NAME_6_1_VALUE"("QG_CONTACT_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "CUST_DIM_61_BTA_REP_NAME"("CUST_DIM_i") :=
              
              "GET_USER_NAME_6_1_VALUE"("QG_CONTACT_i");
              
              ELSIF get_row_status THEN
                "SV_CUST_DIM_61_BTA_REP_NAME" :=
              
              "GET_USER_NAME_6_1_VALUE"("QG_CONTACT_i");
              
              ELSE
                NULL;
              END IF;
              
              
              
                  IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                    IF NOT get_use_hc THEN
                      "CUST_DIM_srk"("CUST_DIM_i") := get_rowkey + "QG_CONTACT_i" - 1;
                    ELSIF get_row_status THEN
                      "SV_CUST_DIM_srk" := get_rowkey + "QG_CONTACT_i" - 1;
                    ELSE
                      NULL;
                    END IF;
                    END IF;
                    IF get_use_hc THEN
                    "CUST_DIM_new" := TRUE;
                  ELSE
                    "CUST_DIM_i" := "CUST_DIM_i" + 1;
                  END IF;
                EXCEPTION
                  WHEN OTHERS THEN
                      last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
               
                    "QG_CONTACT_ER"('TRACE 204: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "QG_CONTACT_i");
                    
                    "CUST_DIM_err" := "CUST_DIM_err" + 1;
                    
                    IF get_errors + "CUST_DIM_err" > get_max_errors THEN
                      get_abort:= TRUE;
                    END IF;
                    get_row_status := FALSE; 
                END;
              END IF;
              
              
              
            END IF;
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("CUST_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "CUST_DIM_new" 
            AND (NOT "CUST_DIM_nul") THEN
              "CUST_DIM_ir"(dml_bsize) := "CUST_DIM_i";
            	"CUST_DIM_0_CUST_ID"("CUST_DIM_i") := "SV_CUST_DIM_0_CUST_ID";
            	"CUST_DIM_38_OB_NATIO"("CUST_DIM_i") := "SV_CUST_DIM_38_OB_NATIO";
            	"CUST_DIM_39_OB_NATIONAL_REP_ID"("CUST_DIM_i") := "SV_CUST_DIM_39_OB_NATIONAL_RE";
            	"CUST_DIM_40_OB_NATIO"("CUST_DIM_i") := "SV_CUST_DIM_40_OB_NATIO";
            	"CUST_DIM_41_OB_TERR_NUM"("CUST_DIM_i") := "SV_CUST_DIM_41_OB_TERR_NUM";
            	"CUST_DIM_42_OB_REP_ID"("CUST_DIM_i") := "SV_CUST_DIM_42_OB_REP_ID";
            	"CUST_DIM_43_OB_REP_NAME"("CUST_DIM_i") := "SV_CUST_DIM_43_OB_REP_NAME";
            	"CUST_DIM_44_OSR_TERR_NUM"("CUST_DIM_i") := "SV_CUST_DIM_44_OSR_TERR_NUM";
            	"CUST_DIM_45_OSR_ID"("CUST_DIM_i") := "SV_CUST_DIM_45_OSR_ID";
            	"CUST_DIM_46_OSR_REP_NAME"("CUST_DIM_i") := "SV_CUST_DIM_46_OSR_REP_NAME";
            	"CUST_DIM_47_ENT_NATI"("CUST_DIM_i") := "SV_CUST_DIM_47_ENT_NATI";
            	"CUST_DIM_48_ENT_NATI"("CUST_DIM_i") := "SV_CUST_DIM_48_ENT_NATI";
            	"CUST_DIM_49_ENT_NATI"("CUST_DIM_i") := "SV_CUST_DIM_49_ENT_NATI";
            	"CUST_DIM_50_ENT_INSI"("CUST_DIM_i") := "SV_CUST_DIM_50_ENT_INSI";
            	"CUST_DIM_51_ENT_INSIDE_REP_ID"("CUST_DIM_i") := "SV_CUST_DIM_51_ENT_INSIDE_REP_";
            	"CUST_DIM_52_ENT_INSI"("CUST_DIM_i") := "SV_CUST_DIM_52_ENT_INSI";
            	"CUST_DIM_53_ENT_FEDE"("CUST_DIM_i") := "SV_CUST_DIM_53_ENT_FEDE";
            	"CUST_DIM_54_ENT_FEDERAL_REP_ID"("CUST_DIM_i") := "SV_CUST_DIM_54_ENT_FEDERAL_RE";
            	"CUST_DIM_55_ENT_FEDE"("CUST_DIM_i") := "SV_CUST_DIM_55_ENT_FEDE";
            	"CUST_DIM_56_BTSR_TERR_NUM"("CUST_DIM_i") := "SV_CUST_DIM_56_BTSR_TERR_NUM";
            	"CUST_DIM_57_BTSR_REP_ID"("CUST_DIM_i") := "SV_CUST_DIM_57_BTSR_REP_ID";
            	"CUST_DIM_58_BTSR_REP_NAME"("CUST_DIM_i") := "SV_CUST_DIM_58_BTSR_REP_NAME";
            	"CUST_DIM_59_BTA_TERR_NUM"("CUST_DIM_i") := "SV_CUST_DIM_59_BTA_TERR_NUM";
            	"CUST_DIM_60_BTA_REP_ID"("CUST_DIM_i") := "SV_CUST_DIM_60_BTA_REP_ID";
            	"CUST_DIM_61_BTA_REP_NAME"("CUST_DIM_i") := "SV_CUST_DIM_61_BTA_REP_NAME";
              "CUST_DIM_srk"("CUST_DIM_i") := "SV_CUST_DIM_srk";
              "CUST_DIM_i" := "CUST_DIM_i" + 1;
            ELSE
              "CUST_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "QG_CONTACT_DML"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "QG_CONTACT_DML"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "QG_CONTACT_ER"('TRACE 202: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "QG_CONTACT_i");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "QG_CONTACT_c"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "QG_CONTACT_i" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "QG_CONTACT_i" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "QG_CONTACT_c";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "CUST_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"CUST_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"CUST_DIM_ins",
        p_upd=>"CUST_DIM_upd",
        p_del=>"CUST_DIM_del",
        p_err=>"CUST_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "CUST_DIM_ins";
    get_updated  := get_updated  + "CUST_DIM_upd";
    get_deleted  := get_deleted  + "CUST_DIM_del";
    get_errors   := get_errors   + "CUST_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "QG_CONTACT_p";



-- Procedure "FLTR_t" is the entry point for map "FLTR_t"

PROCEDURE "FLTR_t"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"FLTR_t"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."QG_CONTACT"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A7D1882009426CAFE040007F01002A48';
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

"CUST_DIM_id" NUMBER(22) := 0;
"CUST_DIM_ins" NUMBER(22) := 0;
"CUST_DIM_upd" NUMBER(22) := 0;
"CUST_DIM_del" NUMBER(22) := 0;
"CUST_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"CUST_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"CUST_DIM_ir"  index_redirect_array;
"SV_CUST_DIM_srk" NUMBER;
"CUST_DIM_new"  BOOLEAN;
"CUST_DIM_nul"  BOOLEAN := FALSE;

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


"CUST_DIM_si" NUMBER(22) := 0;

"CUST_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_2_CONTACTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_39_OB_NATIONAL_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_25_OB_NATIONAL_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_41_OB_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_26_OB_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_1_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_42_OSR_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_27_OSR_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_2_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_43_ENT_NATIONAL_TERR_N" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_28_ENT_NATIONAL_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_3_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_44_ENT_INSIDE_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_29_ENT_INSIDE_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_4_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_45_ENT_FEDERAL_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_30_ENT_FEDERAL_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ORA_TRX_NUM_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_46_BTSR_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_32_BTSR_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_5_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_47_BTA_TERR_NUM" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_33_BTA_REP_ID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GET_USER_NAME_6_1_VALUE$1" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_0_CUST_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_38_OB_NATIO$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_39_OB_NATIONAL_RE" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_40_OB_NATIO$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_41_OB_TERR_NUM$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_42_OB_REP_ID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_43_OB_REP_NAME$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_44_OSR_TERR_NUM$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_45_OSR_ID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_46_OSR_REP_NAME$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_47_ENT_NATI$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_48_ENT_NATI$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_49_ENT_NATI$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_50_ENT_INSI$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_51_ENT_INSIDE_RE" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_52_ENT_INSI$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_53_ENT_FEDE$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_54_ENT_FEDERAL_RE" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_55_ENT_FEDE$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_56_BTSR_TERR_NUM$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_57_BTSR_REP_ID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_58_BTSR_REP_NAME$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_59_BTA_TERR_NUM$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_60_BTA_REP_ID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_CUST_DIM_61_BTA_REP_NAME$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_2_CONTACTID"  CHAR(12);
"SV_ROWKEY_FLTR"  VARCHAR2(18);
"SV_FLTR_39_OB_NATIONAL_TERR_N"  VARCHAR2(10);
"SV_FLTR_25_OB_NATIONAL_REP_ID"  CHAR(12);
"SV_GET_USER_NAME_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_41_OB_TERR_NUM"  VARCHAR2(10);
"SV_FLTR_26_OB_REP_ID"  CHAR(12);
"SV_GET_USER_NAME_1_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_42_OSR_TERR_NUM"  VARCHAR2(10);
"SV_FLTR_27_OSR_ID"  CHAR(12);
"SV_GET_USER_NAME_2_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_43_ENT_NATIONAL_TERR_N"  VARCHAR2(10);
"SV_FLTR_28_ENT_NATIONAL_REP_ID"  CHAR(12);
"SV_GET_USER_NAME_3_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_44_ENT_INSIDE_TERR_NUM"  VARCHAR2(10);
"SV_FLTR_29_ENT_INSIDE_REP_ID"  CHAR(12);
"SV_GET_USER_NAME_4_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_45_ENT_FEDERAL_TERR_N"  VARCHAR2(10);
"SV_FLTR_30_ENT_FEDERAL_REP_ID"  CHAR(12);
"SV_GET_ORA_TRX_NUM_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_46_BTSR_TERR_NUM"  VARCHAR2(10);
"SV_FLTR_32_BTSR_REP_ID"  CHAR(12);
"SV_GET_USER_NAME_5_1_VALUE$1"  VARCHAR2(32767);
"SV_FLTR_47_BTA_TERR_NUM"  VARCHAR2(10);
"SV_FLTR_33_BTA_REP_ID"  CHAR(12);
"SV_GET_USER_NAME_6_1_VALUE$1"  VARCHAR2(32767);
"SV_CUST_DIM_0_CUST_ID$1"  VARCHAR2(50);
"SV_CUST_DIM_38_OB_NATIO$1"  VARCHAR2(10);
"SV_CUST_DIM_39_OB_NATIONAL_"  CHAR(12);
"SV_CUST_DIM_40_OB_NATIO$1"  VARCHAR2(64);
"SV_CUST_DIM_41_OB_TERR_NUM$1"  VARCHAR2(10);
"SV_CUST_DIM_42_OB_REP_ID$1"  CHAR(12);
"SV_CUST_DIM_43_OB_REP_NAME$1"  VARCHAR2(64);
"SV_CUST_DIM_44_OSR_TERR_NUM$1"  VARCHAR2(10);
"SV_CUST_DIM_45_OSR_ID$1"  CHAR(12);
"SV_CUST_DIM_46_OSR_REP_NAME$1"  VARCHAR2(64);
"SV_CUST_DIM_47_ENT_NATI$1"  VARCHAR2(10);
"SV_CUST_DIM_48_ENT_NATI$1"  CHAR(12);
"SV_CUST_DIM_49_ENT_NATI$1"  VARCHAR2(64);
"SV_CUST_DIM_50_ENT_INSI$1"  VARCHAR2(10);
"SV_CUST_DIM_51_ENT_INSIDE_RE"  CHAR(12);
"SV_CUST_DIM_52_ENT_INSI$1"  VARCHAR2(64);
"SV_CUST_DIM_53_ENT_FEDE$1"  VARCHAR2(10);
"SV_CUST_DIM_54_ENT_FEDERAL_"  CHAR(12);
"SV_CUST_DIM_55_ENT_FEDE$1"  VARCHAR2(64);
"SV_CUST_DIM_56_BTSR_TERR_NUM$1"  VARCHAR2(10);
"SV_CUST_DIM_57_BTSR_REP_ID$1"  CHAR(12);
"SV_CUST_DIM_58_BTSR_REP_NAME$1"  VARCHAR2(64);
"SV_CUST_DIM_59_BTA_TERR_NUM$1"  VARCHAR2(10);
"SV_CUST_DIM_60_BTA_REP_ID$1"  CHAR(12);
"SV_CUST_DIM_61_BTA_REP_NAME$1"  VARCHAR2(64);

-- Bulk: intermediate collection variables
"FLTR_2_CONTACTID" "T_FLTR_2_CONTACTID";
"ROWKEY_FLTR" "T_ROWKEY_FLTR";
"FLTR_39_OB_NATIONAL_TERR_NUM" "T_FLTR_39_OB_NATIONAL_TERR_NUM";
"FLTR_25_OB_NATIONAL_REP_ID" "T_FLTR_25_OB_NATIONAL_REP_ID";
"GET_USER_NAME_1_VALUE$1" "T_GET_USER_NAME_1_VALUE$1";
"FLTR_41_OB_TERR_NUM" "T_FLTR_41_OB_TERR_NUM";
"FLTR_26_OB_REP_ID" "T_FLTR_26_OB_REP_ID";
"GET_USER_NAME_1_1_VALUE$1" "T_GET_USER_NAME_1_1_VALUE$1";
"FLTR_42_OSR_TERR_NUM" "T_FLTR_42_OSR_TERR_NUM";
"FLTR_27_OSR_ID" "T_FLTR_27_OSR_ID";
"GET_USER_NAME_2_1_VALUE$1" "T_GET_USER_NAME_2_1_VALUE$1";
"FLTR_43_ENT_NATIONAL_TERR_NUM" "T_FLTR_43_ENT_NATIONAL_TERR_N";
"FLTR_28_ENT_NATIONAL_REP_ID" "T_FLTR_28_ENT_NATIONAL_REP_ID";
"GET_USER_NAME_3_1_VALUE$1" "T_GET_USER_NAME_3_1_VALUE$1";
"FLTR_44_ENT_INSIDE_TERR_NUM" "T_FLTR_44_ENT_INSIDE_TERR_NUM";
"FLTR_29_ENT_INSIDE_REP_ID" "T_FLTR_29_ENT_INSIDE_REP_ID";
"GET_USER_NAME_4_1_VALUE$1" "T_GET_USER_NAME_4_1_VALUE$1";
"FLTR_45_ENT_FEDERAL_TERR_NUM" "T_FLTR_45_ENT_FEDERAL_TERR_NUM";
"FLTR_30_ENT_FEDERAL_REP_ID" "T_FLTR_30_ENT_FEDERAL_REP_ID";
"GET_ORA_TRX_NUM_1_VALUE$1" "T_GET_ORA_TRX_NUM_1_VALUE$1";
"FLTR_46_BTSR_TERR_NUM" "T_FLTR_46_BTSR_TERR_NUM";
"FLTR_32_BTSR_REP_ID" "T_FLTR_32_BTSR_REP_ID";
"GET_USER_NAME_5_1_VALUE$1" "T_GET_USER_NAME_5_1_VALUE$1";
"FLTR_47_BTA_TERR_NUM" "T_FLTR_47_BTA_TERR_NUM";
"FLTR_33_BTA_REP_ID" "T_FLTR_33_BTA_REP_ID";
"GET_USER_NAME_6_1_VALUE$1" "T_GET_USER_NAME_6_1_VALUE$1";
"CUST_DIM_0_CUST_ID$1" "T_CUST_DIM_0_CUST_ID$1";
"CUST_DIM_38_OB_NATIO$1" "T_CUST_DIM_38_OB_NATIO$1";
"CUST_DIM_39_OB_NATIONAL_REP_" "T_CUST_DIM_39_OB_NATIONAL_RE";
"CUST_DIM_40_OB_NATIO$1" "T_CUST_DIM_40_OB_NATIO$1";
"CUST_DIM_41_OB_TERR_NUM$1" "T_CUST_DIM_41_OB_TERR_NUM$1";
"CUST_DIM_42_OB_REP_ID$1" "T_CUST_DIM_42_OB_REP_ID$1";
"CUST_DIM_43_OB_REP_NAME$1" "T_CUST_DIM_43_OB_REP_NAME$1";
"CUST_DIM_44_OSR_TERR_NUM$1" "T_CUST_DIM_44_OSR_TERR_NUM$1";
"CUST_DIM_45_OSR_ID$1" "T_CUST_DIM_45_OSR_ID$1";
"CUST_DIM_46_OSR_REP_NAME$1" "T_CUST_DIM_46_OSR_REP_NAME$1";
"CUST_DIM_47_ENT_NATI$1" "T_CUST_DIM_47_ENT_NATI$1";
"CUST_DIM_48_ENT_NATI$1" "T_CUST_DIM_48_ENT_NATI$1";
"CUST_DIM_49_ENT_NATI$1" "T_CUST_DIM_49_ENT_NATI$1";
"CUST_DIM_50_ENT_INSI$1" "T_CUST_DIM_50_ENT_INSI$1";
"CUST_DIM_51_ENT_INSIDE_REP_" "T_CUST_DIM_51_ENT_INSIDE_RE";
"CUST_DIM_52_ENT_INSI$1" "T_CUST_DIM_52_ENT_INSI$1";
"CUST_DIM_53_ENT_FEDE$1" "T_CUST_DIM_53_ENT_FEDE$1";
"CUST_DIM_54_ENT_FEDERAL_REP_" "T_CUST_DIM_54_ENT_FEDERAL_RE";
"CUST_DIM_55_ENT_FEDE$1" "T_CUST_DIM_55_ENT_FEDE$1";
"CUST_DIM_56_BTSR_TERR_NUM$1" "T_CUST_DIM_56_BTSR_TERR_NUM$1";
"CUST_DIM_57_BTSR_REP_ID$1" "T_CUST_DIM_57_BTSR_REP_ID$1";
"CUST_DIM_58_BTSR_REP_NAME$1" "T_CUST_DIM_58_BTSR_REP_NAME$1";
"CUST_DIM_59_BTA_TERR_NUM$1" "T_CUST_DIM_59_BTA_TERR_NUM$1";
"CUST_DIM_60_BTA_REP_ID$1" "T_CUST_DIM_60_BTA_REP_ID$1";
"CUST_DIM_61_BTA_REP_NAME$1" "T_CUST_DIM_61_BTA_REP_NAME$1";

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
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_2_CONTACTID',0,80),
    p_value=>SUBSTRB("FLTR_2_CONTACTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_39_OB_NATIONAL_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_39_OB_NATIONAL_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_25_OB_NATIONAL_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_25_OB_NATIONAL_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_41_OB_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_41_OB_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_26_OB_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_26_OB_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_1_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_1_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_42_OSR_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_42_OSR_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_27_OSR_ID',0,80),
    p_value=>SUBSTRB("FLTR_27_OSR_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_2_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_2_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_43_ENT_NATIONAL_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_43_ENT_NATIONAL_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_28_ENT_NATIONAL_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_28_ENT_NATIONAL_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_3_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_3_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_44_ENT_INSIDE_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_44_ENT_INSIDE_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>15,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_29_ENT_INSIDE_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_29_ENT_INSIDE_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>16,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_4_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_4_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>17,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_45_ENT_FEDERAL_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_45_ENT_FEDERAL_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>18,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_30_ENT_FEDERAL_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_30_ENT_FEDERAL_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>19,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_ORA_TRX_NUM_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_ORA_TRX_NUM_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>20,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_46_BTSR_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_46_BTSR_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>21,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_32_BTSR_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_32_BTSR_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>22,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_5_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_5_1_VALUE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>23,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_47_BTA_TERR_NUM',0,80),
    p_value=>SUBSTRB("FLTR_47_BTA_TERR_NUM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>24,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('FLTR_33_BTA_REP_ID',0,80),
    p_value=>SUBSTRB("FLTR_33_BTA_REP_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>25,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."QG_CONTACT"',0,80),
    p_column=>SUBSTR('GET_USER_NAME_6_1_VALUE',0,80),
    p_value=>SUBSTRB("GET_USER_NAME_6_1_VALUE$1"(error_index),0,2000),
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
      p_stm=>'TRACE 205: ' || p_statement,
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
-- for map "FLTR_t"
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
--   the data source for map "FLTR_t"
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
    "FLTR_2_CONTACTID".DELETE;
    "FLTR_39_OB_NATIONAL_TERR_NUM".DELETE;
    "FLTR_25_OB_NATIONAL_REP_ID".DELETE;
    "GET_USER_NAME_1_VALUE$1".DELETE;
    "FLTR_41_OB_TERR_NUM".DELETE;
    "FLTR_26_OB_REP_ID".DELETE;
    "GET_USER_NAME_1_1_VALUE$1".DELETE;
    "FLTR_42_OSR_TERR_NUM".DELETE;
    "FLTR_27_OSR_ID".DELETE;
    "GET_USER_NAME_2_1_VALUE$1".DELETE;
    "FLTR_43_ENT_NATIONAL_TERR_NUM".DELETE;
    "FLTR_28_ENT_NATIONAL_REP_ID".DELETE;
    "GET_USER_NAME_3_1_VALUE$1".DELETE;
    "FLTR_44_ENT_INSIDE_TERR_NUM".DELETE;
    "FLTR_29_ENT_INSIDE_REP_ID".DELETE;
    "GET_USER_NAME_4_1_VALUE$1".DELETE;
    "FLTR_45_ENT_FEDERAL_TERR_NUM".DELETE;
    "FLTR_30_ENT_FEDERAL_REP_ID".DELETE;
    "GET_ORA_TRX_NUM_1_VALUE$1".DELETE;
    "FLTR_46_BTSR_TERR_NUM".DELETE;
    "FLTR_32_BTSR_REP_ID".DELETE;
    "GET_USER_NAME_5_1_VALUE$1".DELETE;
    "FLTR_47_BTA_TERR_NUM".DELETE;
    "FLTR_33_BTA_REP_ID".DELETE;
    "GET_USER_NAME_6_1_VALUE$1".DELETE;

    FETCH
      "FLTR_c"
    BULK COLLECT INTO
      "FLTR_2_CONTACTID",
      "FLTR_39_OB_NATIONAL_TERR_NUM",
      "FLTR_25_OB_NATIONAL_REP_ID",
      "GET_USER_NAME_1_VALUE$1",
      "FLTR_41_OB_TERR_NUM",
      "FLTR_26_OB_REP_ID",
      "GET_USER_NAME_1_1_VALUE$1",
      "FLTR_42_OSR_TERR_NUM",
      "FLTR_27_OSR_ID",
      "GET_USER_NAME_2_1_VALUE$1",
      "FLTR_43_ENT_NATIONAL_TERR_NUM",
      "FLTR_28_ENT_NATIONAL_REP_ID",
      "GET_USER_NAME_3_1_VALUE$1",
      "FLTR_44_ENT_INSIDE_TERR_NUM",
      "FLTR_29_ENT_INSIDE_REP_ID",
      "GET_USER_NAME_4_1_VALUE$1",
      "FLTR_45_ENT_FEDERAL_TERR_NUM",
      "FLTR_30_ENT_FEDERAL_REP_ID",
      "GET_ORA_TRX_NUM_1_VALUE$1",
      "FLTR_46_BTSR_TERR_NUM",
      "FLTR_32_BTSR_REP_ID",
      "GET_USER_NAME_5_1_VALUE$1",
      "FLTR_47_BTA_TERR_NUM",
      "FLTR_33_BTA_REP_ID",
      "GET_USER_NAME_6_1_VALUE$1"
    LIMIT get_bulk_size;

    IF "FLTR_c"%NOTFOUND AND "FLTR_2_CONTACTID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_2_CONTACTID".COUNT;
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
    get_map_selected := get_map_selected + "FLTR_2_CONTACTID".COUNT;
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
          p_stm=>'TRACE 206: SELECT',
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
  "CUST_DIM_upd0" NUMBER := "CUST_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "CUST_DIM_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "CUST_DIM_nul")) THEN
    -- Update DML for "CUST_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"CUST_DIM"';
    get_audit_detail_id := "CUST_DIM_id";
  
    IF get_use_hc AND NOT firstround THEN
      "CUST_DIM_si" := "CUST_DIM_ir"(si);
      IF "CUST_DIM_si" = 0 THEN
        "CUST_DIM_i" := 0;
      ELSE
        "CUST_DIM_i" := "CUST_DIM_si" + 1;
      END IF;
    ELSE
      "CUST_DIM_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "CUST_DIM_i" <= get_bulk_size 
   AND "FLTR_c"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "CUST_DIM_si" >= "CUST_DIM_i";
      END IF;
  
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "CUST_DIM_si".."CUST_DIM_i" - 1
          UPDATE
          /*+ APPEND PARALLEL("CUST_DIM") */
            "CUST_DIM"
          SET
  
  					"CUST_DIM"."OB_NATIONAL_TERR_NUM" = "CUST_DIM_38_OB_NATIO$1"
  (i),
  					"CUST_DIM"."OB_NATIONAL_REP_ID" = "CUST_DIM_39_OB_NATIONAL_REP_"
  (i),
  					"CUST_DIM"."OB_NATIONAL_REP_NAME" = "CUST_DIM_40_OB_NATIO$1"
  (i),
  					"CUST_DIM"."OB_TERR_NUM" = "CUST_DIM_41_OB_TERR_NUM$1"
  (i),
  					"CUST_DIM"."OB_REP_ID" = "CUST_DIM_42_OB_REP_ID$1"
  (i),
  					"CUST_DIM"."OB_REP_NAME" = "CUST_DIM_43_OB_REP_NAME$1"
  (i),
  					"CUST_DIM"."OSR_TERR_NUM" = "CUST_DIM_44_OSR_TERR_NUM$1"
  (i),
  					"CUST_DIM"."OSR_ID" = "CUST_DIM_45_OSR_ID$1"
  (i),
  					"CUST_DIM"."OSR_REP_NAME" = "CUST_DIM_46_OSR_REP_NAME$1"
  (i),
  					"CUST_DIM"."ENT_NATIONAL_TERR_NUM" = "CUST_DIM_47_ENT_NATI$1"
  (i),
  					"CUST_DIM"."ENT_NATIONAL_REP_ID" = "CUST_DIM_48_ENT_NATI$1"
  (i),
  					"CUST_DIM"."ENT_NATIONAL_REP_NAME" = "CUST_DIM_49_ENT_NATI$1"
  (i),
  					"CUST_DIM"."ENT_INSIDE_TERR_NUM" = "CUST_DIM_50_ENT_INSI$1"
  (i),
  					"CUST_DIM"."ENT_INSIDE_REP_ID" = "CUST_DIM_51_ENT_INSIDE_REP_"
  (i),
  					"CUST_DIM"."ENT_INSIDE_REP_NAME" = "CUST_DIM_52_ENT_INSI$1"
  (i),
  					"CUST_DIM"."ENT_FEDERAL_TERR_NUM" = "CUST_DIM_53_ENT_FEDE$1"
  (i),
  					"CUST_DIM"."ENT_FEDERAL_REP_ID" = "CUST_DIM_54_ENT_FEDERAL_REP_"
  (i),
  					"CUST_DIM"."ENT_FEDERAL_REP_NAME" = "CUST_DIM_55_ENT_FEDE$1"
  (i),
  					"CUST_DIM"."BTSR_TERR_NUM" = "CUST_DIM_56_BTSR_TERR_NUM$1"
  (i),
  					"CUST_DIM"."BTSR_REP_ID" = "CUST_DIM_57_BTSR_REP_ID$1"
  (i),
  					"CUST_DIM"."BTSR_REP_NAME" = "CUST_DIM_58_BTSR_REP_NAME$1"
  (i),
  					"CUST_DIM"."BTA_TERR_NUM" = "CUST_DIM_59_BTA_TERR_NUM$1"
  (i),
  					"CUST_DIM"."BTA_REP_ID" = "CUST_DIM_60_BTA_REP_ID$1"
  (i),
  					"CUST_DIM"."BTA_REP_NAME" = "CUST_DIM_61_BTA_REP_NAME$1"
  (i)
  
          WHERE
  
  
  					"CUST_DIM"."CUST_ID" = "CUST_DIM_0_CUST_ID$1"
  (i)
  
          RETURNING ROWID BULK COLLECT INTO get_rowid;
          
        feedback_bulk_limit := "CUST_DIM_i" - 1;
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "CUST_DIM_si"..feedback_bulk_limit LOOP
          IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              get_rowkey_bulk(rowkey_bulk_index) := "CUST_DIM_srk"(rowkey_index);
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
  
        "CUST_DIM_upd" := "CUST_DIM_upd" + get_rowid.COUNT;
        "CUST_DIM_si" := "CUST_DIM_i";
  
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          IF get_use_hc THEN
            get_row_status := FALSE;
            ROLLBACK;
            IF firstround THEN
              EXIT;
            END IF;
          END IF;
          IF NOT get_use_hc THEN
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "CUST_DIM_si".."CUST_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "CUST_DIM_si"..feedback_bulk_limit LOOP
              IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "CUST_DIM_srk"(rowkey_index);
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
            "CUST_DIM_upd" := "CUST_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "CUST_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
          END IF;
          LOOP
            BEGIN
              IF get_use_hc AND NOT get_row_status THEN
                last_successful_index := si;
                RAISE;
              END IF;
  
  
              UPDATE
              /*+ APPEND PARALLEL("CUST_DIM") */
                "CUST_DIM"
              SET
  
  							"CUST_DIM"."OB_NATIONAL_TERR_NUM" = "CUST_DIM_38_OB_NATIO$1"
  (last_successful_index),
  							"CUST_DIM"."OB_NATIONAL_REP_ID" = "CUST_DIM_39_OB_NATIONAL_REP_"
  (last_successful_index),
  							"CUST_DIM"."OB_NATIONAL_REP_NAME" = "CUST_DIM_40_OB_NATIO$1"
  (last_successful_index),
  							"CUST_DIM"."OB_TERR_NUM" = "CUST_DIM_41_OB_TERR_NUM$1"
  (last_successful_index),
  							"CUST_DIM"."OB_REP_ID" = "CUST_DIM_42_OB_REP_ID$1"
  (last_successful_index),
  							"CUST_DIM"."OB_REP_NAME" = "CUST_DIM_43_OB_REP_NAME$1"
  (last_successful_index),
  							"CUST_DIM"."OSR_TERR_NUM" = "CUST_DIM_44_OSR_TERR_NUM$1"
  (last_successful_index),
  							"CUST_DIM"."OSR_ID" = "CUST_DIM_45_OSR_ID$1"
  (last_successful_index),
  							"CUST_DIM"."OSR_REP_NAME" = "CUST_DIM_46_OSR_REP_NAME$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_NATIONAL_TERR_NUM" = "CUST_DIM_47_ENT_NATI$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_NATIONAL_REP_ID" = "CUST_DIM_48_ENT_NATI$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_NATIONAL_REP_NAME" = "CUST_DIM_49_ENT_NATI$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_INSIDE_TERR_NUM" = "CUST_DIM_50_ENT_INSI$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_INSIDE_REP_ID" = "CUST_DIM_51_ENT_INSIDE_REP_"
  (last_successful_index),
  							"CUST_DIM"."ENT_INSIDE_REP_NAME" = "CUST_DIM_52_ENT_INSI$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_FEDERAL_TERR_NUM" = "CUST_DIM_53_ENT_FEDE$1"
  (last_successful_index),
  							"CUST_DIM"."ENT_FEDERAL_REP_ID" = "CUST_DIM_54_ENT_FEDERAL_REP_"
  (last_successful_index),
  							"CUST_DIM"."ENT_FEDERAL_REP_NAME" = "CUST_DIM_55_ENT_FEDE$1"
  (last_successful_index),
  							"CUST_DIM"."BTSR_TERR_NUM" = "CUST_DIM_56_BTSR_TERR_NUM$1"
  (last_successful_index),
  							"CUST_DIM"."BTSR_REP_ID" = "CUST_DIM_57_BTSR_REP_ID$1"
  (last_successful_index),
  							"CUST_DIM"."BTSR_REP_NAME" = "CUST_DIM_58_BTSR_REP_NAME$1"
  (last_successful_index),
  							"CUST_DIM"."BTA_TERR_NUM" = "CUST_DIM_59_BTA_TERR_NUM$1"
  (last_successful_index),
  							"CUST_DIM"."BTA_REP_ID" = "CUST_DIM_60_BTA_REP_ID$1"
  (last_successful_index),
  							"CUST_DIM"."BTA_REP_NAME" = "CUST_DIM_61_BTA_REP_NAME$1"
  (last_successful_index)
  
              WHERE
  
  
  							"CUST_DIM"."CUST_ID" = "CUST_DIM_0_CUST_ID$1"
  (last_successful_index)
  
                ;
              
              last_successful_index := last_successful_index + 1;
            EXCEPTION
              WHEN OTHERS THEN
                  last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
                IF get_use_hc THEN
                  get_row_status := FALSE;
                  ROLLBACK;
                END IF;
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  error_rowkey := "CUST_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_NATIONAL_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_38_OB_NATIO$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_NATIONAL_REP_ID"',0,80),SUBSTRB("CUST_DIM_39_OB_NATIONAL_REP_"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_NATIONAL_REP_NAME"',0,80),SUBSTRB("CUST_DIM_40_OB_NATIO$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_41_OB_TERR_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_REP_ID"',0,80),SUBSTRB("CUST_DIM_42_OB_REP_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OB_REP_NAME"',0,80),SUBSTRB("CUST_DIM_43_OB_REP_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OSR_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_44_OSR_TERR_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OSR_ID"',0,80),SUBSTRB("CUST_DIM_45_OSR_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."OSR_REP_NAME"',0,80),SUBSTRB("CUST_DIM_46_OSR_REP_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_NATIONAL_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_47_ENT_NATI$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_NATIONAL_REP_ID"',0,80),SUBSTRB("CUST_DIM_48_ENT_NATI$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_NATIONAL_REP_NAME"',0,80),SUBSTRB("CUST_DIM_49_ENT_NATI$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_INSIDE_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_50_ENT_INSI$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_INSIDE_REP_ID"',0,80),SUBSTRB("CUST_DIM_51_ENT_INSIDE_REP_"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_INSIDE_REP_NAME"',0,80),SUBSTRB("CUST_DIM_52_ENT_INSI$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_FEDERAL_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_53_ENT_FEDE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_FEDERAL_REP_ID"',0,80),SUBSTRB("CUST_DIM_54_ENT_FEDERAL_REP_"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."ENT_FEDERAL_REP_NAME"',0,80),SUBSTRB("CUST_DIM_55_ENT_FEDE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTSR_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_56_BTSR_TERR_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTSR_REP_ID"',0,80),SUBSTRB("CUST_DIM_57_BTSR_REP_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTSR_REP_NAME"',0,80),SUBSTRB("CUST_DIM_58_BTSR_REP_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTA_TERR_NUM"',0,80),SUBSTRB("CUST_DIM_59_BTA_TERR_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTA_REP_ID"',0,80),SUBSTRB("CUST_DIM_60_BTA_REP_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"CUST_DIM"."BTA_REP_NAME"',0,80),SUBSTRB("CUST_DIM_61_BTA_REP_NAME$1"(last_successful_index),0,2000));
                  
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
                "CUST_DIM_err" := "CUST_DIM_err" + 1;
                
                IF get_errors + "CUST_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "CUST_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "CUST_DIM_si" >= "CUST_DIM_i" OR get_abort THEN
        "CUST_DIM_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "CUST_DIM_i" := 1; 
  END IF;
  
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "CUST_DIM_upd" := "CUST_DIM_upd0";
  END IF;

END "FLTR_DML";

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

  IF NOT "CUST_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "CUST_DIM_St" THEN
          "CUST_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"CUST_DIM"',
              p_target_uoid=>'A7D1882009AC6CAFE040007F01002A48',
              p_stm=>'TRACE 208',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "CUST_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7D188200AB96CAFE040007F01002A48', -- Operator CUST_DIM
              p_parent_object_name=>'CUST_DIM',
              p_parent_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'CUST_DIM',
              p_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7D1882009426CAFE040007F01002A48', -- Operator QG_CONTACT
              p_parent_object_name=>'QG_CONTACT',
              p_parent_object_uoid=>'A41FFB190EF25678E040007F01006C7D', -- Table QG_CONTACT
              p_parent_object_type=>'Table',
              p_object_name=>'QG_CONTACT',
              p_object_uoid=>'A41FFB190EF25678E040007F01006C7D', -- Table QG_CONTACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7D1882009AC6CAFE040007F01002A48', -- Operator CUST_DIM
              p_parent_object_name=>'CUST_DIM',
              p_parent_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'CUST_DIM',
              p_object_uoid=>'A41FA16DAEC9655CE040007F01006B9E', -- Table CUST_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
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
    "CUST_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU";

      LOOP
        IF "FLTR_si" = 0 THEN
          "FLTR_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_2_CONTACTID".COUNT - 1;
          ELSE
            bulk_count := "FLTR_2_CONTACTID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "CUST_DIM_ir".DELETE;
"CUST_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i" := "FLTR_si";
        BEGIN
          
          LOOP
            EXIT WHEN "CUST_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i" := "FLTR_i" + 1;
            "FLTR_si" := "FLTR_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "CUST_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("FLTR_c"%NOTFOUND AND
               "FLTR_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "FLTR_i" > bulk_count THEN
            
              "FLTR_si" := 0;
              EXIT;
            END IF;


            
get_target_name := '"CUST_DIM"';
            get_audit_detail_id := "CUST_DIM_id";
            IF NOT "CUST_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"CUST_DIM_0_CUST_ID$1"("CUST_DIM_i") := 
            
            RTRIM("FLTR_2_CONTACTID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_0_CUST_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_2_CONTACTID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_0_CUST_ID$1"("CUST_DIM_i") :=
            
            RTRIM("FLTR_2_CONTACTID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_0_CUST_ID$1" :=
            
            RTRIM("FLTR_2_CONTACTID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_38_OB_NATIO$1"("CUST_DIM_i") := 
            
            "FLTR_39_OB_NATIONAL_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_38_OB_NATIO$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_39_OB_NATIONAL_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_38_OB_NATIO$1"("CUST_DIM_i") :=
            
            "FLTR_39_OB_NATIONAL_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_38_OB_NATIO$1" :=
            
            "FLTR_39_OB_NATIONAL_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_39_OB_NATIONAL_REP_"("CUST_DIM_i") := 
            
            RTRIM("FLTR_25_OB_NATIONAL_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_39_OB_NATIONAL_REP_"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_25_OB_NATIONAL_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_39_OB_NATIONAL_REP_"("CUST_DIM_i") :=
            
            RTRIM("FLTR_25_OB_NATIONAL_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_39_OB_NATIONAL_" :=
            
            RTRIM("FLTR_25_OB_NATIONAL_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_40_OB_NATIO$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_40_OB_NATIO$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_40_OB_NATIO$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_40_OB_NATIO$1" :=
            
            "GET_USER_NAME_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_41_OB_TERR_NUM$1"("CUST_DIM_i") := 
            
            "FLTR_41_OB_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_41_OB_TERR_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_41_OB_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_41_OB_TERR_NUM$1"("CUST_DIM_i") :=
            
            "FLTR_41_OB_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_41_OB_TERR_NUM$1" :=
            
            "FLTR_41_OB_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_42_OB_REP_ID$1"("CUST_DIM_i") := 
            
            RTRIM("FLTR_26_OB_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_42_OB_REP_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_26_OB_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_42_OB_REP_ID$1"("CUST_DIM_i") :=
            
            RTRIM("FLTR_26_OB_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_42_OB_REP_ID$1" :=
            
            RTRIM("FLTR_26_OB_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_43_OB_REP_NAME$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_1_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_43_OB_REP_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_1_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_43_OB_REP_NAME$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_1_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_43_OB_REP_NAME$1" :=
            
            "GET_USER_NAME_1_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_44_OSR_TERR_NUM$1"("CUST_DIM_i") := 
            
            "FLTR_42_OSR_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_44_OSR_TERR_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_42_OSR_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_44_OSR_TERR_NUM$1"("CUST_DIM_i") :=
            
            "FLTR_42_OSR_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_44_OSR_TERR_NUM$1" :=
            
            "FLTR_42_OSR_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_45_OSR_ID$1"("CUST_DIM_i") := 
            
            RTRIM("FLTR_27_OSR_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_45_OSR_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_27_OSR_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_45_OSR_ID$1"("CUST_DIM_i") :=
            
            RTRIM("FLTR_27_OSR_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_45_OSR_ID$1" :=
            
            RTRIM("FLTR_27_OSR_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_46_OSR_REP_NAME$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_2_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_46_OSR_REP_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_2_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_46_OSR_REP_NAME$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_2_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_46_OSR_REP_NAME$1" :=
            
            "GET_USER_NAME_2_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_47_ENT_NATI$1"("CUST_DIM_i") := 
            
            "FLTR_43_ENT_NATIONAL_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_47_ENT_NATI$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_43_ENT_NATIONAL_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_47_ENT_NATI$1"("CUST_DIM_i") :=
            
            "FLTR_43_ENT_NATIONAL_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_47_ENT_NATI$1" :=
            
            "FLTR_43_ENT_NATIONAL_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_48_ENT_NATI$1"("CUST_DIM_i") := 
            
            RTRIM("FLTR_28_ENT_NATIONAL_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_48_ENT_NATI$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_28_ENT_NATIONAL_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_48_ENT_NATI$1"("CUST_DIM_i") :=
            
            RTRIM("FLTR_28_ENT_NATIONAL_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_48_ENT_NATI$1" :=
            
            RTRIM("FLTR_28_ENT_NATIONAL_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_49_ENT_NATI$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_3_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_49_ENT_NATI$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_3_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_49_ENT_NATI$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_3_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_49_ENT_NATI$1" :=
            
            "GET_USER_NAME_3_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_50_ENT_INSI$1"("CUST_DIM_i") := 
            
            "FLTR_44_ENT_INSIDE_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_50_ENT_INSI$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_44_ENT_INSIDE_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_50_ENT_INSI$1"("CUST_DIM_i") :=
            
            "FLTR_44_ENT_INSIDE_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_50_ENT_INSI$1" :=
            
            "FLTR_44_ENT_INSIDE_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_51_ENT_INSIDE_REP_"("CUST_DIM_i") := 
            
            RTRIM("FLTR_29_ENT_INSIDE_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_51_ENT_INSIDE_REP_"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_29_ENT_INSIDE_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_51_ENT_INSIDE_REP_"("CUST_DIM_i") :=
            
            RTRIM("FLTR_29_ENT_INSIDE_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_51_ENT_INSIDE_RE" :=
            
            RTRIM("FLTR_29_ENT_INSIDE_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_52_ENT_INSI$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_4_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_52_ENT_INSI$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_4_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_52_ENT_INSI$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_4_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_52_ENT_INSI$1" :=
            
            "GET_USER_NAME_4_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_53_ENT_FEDE$1"("CUST_DIM_i") := 
            
            "FLTR_45_ENT_FEDERAL_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_53_ENT_FEDE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_45_ENT_FEDERAL_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_53_ENT_FEDE$1"("CUST_DIM_i") :=
            
            "FLTR_45_ENT_FEDERAL_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_53_ENT_FEDE$1" :=
            
            "FLTR_45_ENT_FEDERAL_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_54_ENT_FEDERAL_REP_"("CUST_DIM_i") := 
            
            RTRIM("FLTR_30_ENT_FEDERAL_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_54_ENT_FEDERAL_REP_"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_30_ENT_FEDERAL_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_54_ENT_FEDERAL_REP_"("CUST_DIM_i") :=
            
            RTRIM("FLTR_30_ENT_FEDERAL_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_54_ENT_FEDERAL_" :=
            
            RTRIM("FLTR_30_ENT_FEDERAL_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_55_ENT_FEDE$1"("CUST_DIM_i") := 
            
            "GET_ORA_TRX_NUM_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_55_ENT_FEDE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ORA_TRX_NUM_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_55_ENT_FEDE$1"("CUST_DIM_i") :=
            
            "GET_ORA_TRX_NUM_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_55_ENT_FEDE$1" :=
            
            "GET_ORA_TRX_NUM_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_56_BTSR_TERR_NUM$1"("CUST_DIM_i") := 
            
            "FLTR_46_BTSR_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_56_BTSR_TERR_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_46_BTSR_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_56_BTSR_TERR_NUM$1"("CUST_DIM_i") :=
            
            "FLTR_46_BTSR_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_56_BTSR_TERR_NUM$1" :=
            
            "FLTR_46_BTSR_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_57_BTSR_REP_ID$1"("CUST_DIM_i") := 
            
            RTRIM("FLTR_32_BTSR_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_57_BTSR_REP_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_32_BTSR_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_57_BTSR_REP_ID$1"("CUST_DIM_i") :=
            
            RTRIM("FLTR_32_BTSR_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_57_BTSR_REP_ID$1" :=
            
            RTRIM("FLTR_32_BTSR_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_58_BTSR_REP_NAME$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_5_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_58_BTSR_REP_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_5_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_58_BTSR_REP_NAME$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_5_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_58_BTSR_REP_NAME$1" :=
            
            "GET_USER_NAME_5_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_59_BTA_TERR_NUM$1"("CUST_DIM_i") := 
            
            "FLTR_47_BTA_TERR_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_59_BTA_TERR_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_47_BTA_TERR_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_59_BTA_TERR_NUM$1"("CUST_DIM_i") :=
            
            "FLTR_47_BTA_TERR_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_59_BTA_TERR_NUM$1" :=
            
            "FLTR_47_BTA_TERR_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_60_BTA_REP_ID$1"("CUST_DIM_i") := 
            
            RTRIM("FLTR_33_BTA_REP_ID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"CUST_DIM_60_BTA_REP_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_33_BTA_REP_ID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_60_BTA_REP_ID$1"("CUST_DIM_i") :=
            
            RTRIM("FLTR_33_BTA_REP_ID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_60_BTA_REP_ID$1" :=
            
            RTRIM("FLTR_33_BTA_REP_ID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"CUST_DIM_61_BTA_REP_NAME$1"("CUST_DIM_i") := 
            
            "GET_USER_NAME_6_1_VALUE$1"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"CUST_DIM_61_BTA_REP_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_USER_NAME_6_1_VALUE$1"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "CUST_DIM_61_BTA_REP_NAME$1"("CUST_DIM_i") :=
            
            "GET_USER_NAME_6_1_VALUE$1"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_CUST_DIM_61_BTA_REP_NAME$1" :=
            
            "GET_USER_NAME_6_1_VALUE$1"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "CUST_DIM_srk"("CUST_DIM_i") := get_rowkey + "FLTR_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_CUST_DIM_srk" := get_rowkey + "FLTR_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "CUST_DIM_new" := TRUE;
                ELSE
                  "CUST_DIM_i" := "CUST_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER"('TRACE 209: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i");
                  
                  "CUST_DIM_err" := "CUST_DIM_err" + 1;
                  
                  IF get_errors + "CUST_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("CUST_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "CUST_DIM_new" 
            AND (NOT "CUST_DIM_nul") THEN
              "CUST_DIM_ir"(dml_bsize) := "CUST_DIM_i";
            	"CUST_DIM_0_CUST_ID$1"("CUST_DIM_i") := "SV_CUST_DIM_0_CUST_ID$1";
            	"CUST_DIM_38_OB_NATIO$1"("CUST_DIM_i") := "SV_CUST_DIM_38_OB_NATIO$1";
            	"CUST_DIM_39_OB_NATIONAL_REP_"("CUST_DIM_i") := "SV_CUST_DIM_39_OB_NATIONAL_";
            	"CUST_DIM_40_OB_NATIO$1"("CUST_DIM_i") := "SV_CUST_DIM_40_OB_NATIO$1";
            	"CUST_DIM_41_OB_TERR_NUM$1"("CUST_DIM_i") := "SV_CUST_DIM_41_OB_TERR_NUM$1";
            	"CUST_DIM_42_OB_REP_ID$1"("CUST_DIM_i") := "SV_CUST_DIM_42_OB_REP_ID$1";
            	"CUST_DIM_43_OB_REP_NAME$1"("CUST_DIM_i") := "SV_CUST_DIM_43_OB_REP_NAME$1";
            	"CUST_DIM_44_OSR_TERR_NUM$1"("CUST_DIM_i") := "SV_CUST_DIM_44_OSR_TERR_NUM$1";
            	"CUST_DIM_45_OSR_ID$1"("CUST_DIM_i") := "SV_CUST_DIM_45_OSR_ID$1";
            	"CUST_DIM_46_OSR_REP_NAME$1"("CUST_DIM_i") := "SV_CUST_DIM_46_OSR_REP_NAME$1";
            	"CUST_DIM_47_ENT_NATI$1"("CUST_DIM_i") := "SV_CUST_DIM_47_ENT_NATI$1";
            	"CUST_DIM_48_ENT_NATI$1"("CUST_DIM_i") := "SV_CUST_DIM_48_ENT_NATI$1";
            	"CUST_DIM_49_ENT_NATI$1"("CUST_DIM_i") := "SV_CUST_DIM_49_ENT_NATI$1";
            	"CUST_DIM_50_ENT_INSI$1"("CUST_DIM_i") := "SV_CUST_DIM_50_ENT_INSI$1";
            	"CUST_DIM_51_ENT_INSIDE_REP_"("CUST_DIM_i") := "SV_CUST_DIM_51_ENT_INSIDE_RE";
            	"CUST_DIM_52_ENT_INSI$1"("CUST_DIM_i") := "SV_CUST_DIM_52_ENT_INSI$1";
            	"CUST_DIM_53_ENT_FEDE$1"("CUST_DIM_i") := "SV_CUST_DIM_53_ENT_FEDE$1";
            	"CUST_DIM_54_ENT_FEDERAL_REP_"("CUST_DIM_i") := "SV_CUST_DIM_54_ENT_FEDERAL_";
            	"CUST_DIM_55_ENT_FEDE$1"("CUST_DIM_i") := "SV_CUST_DIM_55_ENT_FEDE$1";
            	"CUST_DIM_56_BTSR_TERR_NUM$1"("CUST_DIM_i") := "SV_CUST_DIM_56_BTSR_TERR_NUM$1";
            	"CUST_DIM_57_BTSR_REP_ID$1"("CUST_DIM_i") := "SV_CUST_DIM_57_BTSR_REP_ID$1";
            	"CUST_DIM_58_BTSR_REP_NAME$1"("CUST_DIM_i") := "SV_CUST_DIM_58_BTSR_REP_NAME$1";
            	"CUST_DIM_59_BTA_TERR_NUM$1"("CUST_DIM_i") := "SV_CUST_DIM_59_BTA_TERR_NUM$1";
            	"CUST_DIM_60_BTA_REP_ID$1"("CUST_DIM_i") := "SV_CUST_DIM_60_BTA_REP_ID$1";
            	"CUST_DIM_61_BTA_REP_NAME$1"("CUST_DIM_i") := "SV_CUST_DIM_61_BTA_REP_NAME$1";
              "CUST_DIM_srk"("CUST_DIM_i") := "SV_CUST_DIM_srk";
              "CUST_DIM_i" := "CUST_DIM_i" + 1;
            ELSE
              "CUST_DIM_ir"(dml_bsize) := 0;
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
            "FLTR_ER"('TRACE 207: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i");
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
    IF NOT "CUST_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"CUST_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"CUST_DIM_ins",
        p_upd=>"CUST_DIM_upd",
        p_del=>"CUST_DIM_del",
        p_err=>"CUST_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "CUST_DIM_ins";
    get_updated  := get_updated  + "CUST_DIM_upd";
    get_deleted  := get_deleted  + "CUST_DIM_del";
    get_errors   := get_errors   + "CUST_DIM_err";

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
      p_source=>'"SLXDW"."QG_CONTACT"',
      p_source_uoid=>'A7D1882009426CAFE040007F01002A48',
      p_target=>'"CUST_DIM"',
      p_target_uoid=>'A7D1882009AC6CAFE040007F01002A48',      p_info=>NULL,
      
            p_type=>'PLSQLMap',
      
      p_date=>get_cycle_date
    );
  END IF;



BEGIN
  -- Expression statement
      error_stmt := SUBSTRB('
  
      
      GET_MAX_DATE("OWB_CUST_DIM_TERR_UPD"."GET_CONST_0_TABLE_NAME","OWB_CUST_DIM_TERR_UPD"."PREMAPPING_1_CREATE_DATE_OUT","OWB_CUST_DIM_TERR_UPD"."PREMAPPING_2_MODIFY_DATE_OUT");
  
  ',0,2000);
  
      
      GET_MAX_DATE("OWB_CUST_DIM_TERR_UPD"."GET_CONST_0_TABLE_NAME","OWB_CUST_DIM_TERR_UPD"."PREMAPPING_1_CREATE_DATE_OUT","OWB_CUST_DIM_TERR_UPD"."PREMAPPING_2_MODIFY_DATE_OUT");
  
    -- End expression statement
  
  
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
  "CUST_DIM_St" := FALSE;
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
      "CUST_DIM_St" := "CUST_DIM_Bat";
      get_batch_status := get_batch_status AND "CUST_DIM_St";
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
		"QG_CONTACT_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "CUST_DIM_St" := "CUST_DIM_Bat";
        get_batch_status := get_batch_status AND "CUST_DIM_St";
      END IF;
    END IF;
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"CUST_DIM_St" := FALSE;

      END IF;
    END IF;

"QG_CONTACT_p";

  END IF;
  IF get_operating_mode = MODE_ROW_TARGET THEN
"FLTR_t";

  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW_TARGET THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "CUST_DIM_St" := "CUST_DIM_Bat";
        get_batch_status := get_batch_status AND "CUST_DIM_St";
      END IF;
    END IF;
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"CUST_DIM_St" := FALSE;

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
  AND    uo.object_name = 'OWB_CUST_DIM_TERR_UPD'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_CUST_DIM_TERR_UPD', x_schema, x_audit_id, x_object_id);

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
  IF "QG_CONTACT_c"%ISOPEN THEN
    CLOSE "QG_CONTACT_c";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;BEGIN
  IF "FLTR_c"%ISOPEN THEN
    CLOSE "FLTR_c";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;

END Close_Cursors;



END "OWB_CUST_DIM_TERR_UPD";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_CUST_DIM_TERR_UPD TO DWHREAD;

