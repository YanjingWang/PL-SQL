DROP PACKAGE BODY GKDW.OWB_INSTRUCTOR_DIM;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_INSTRUCTOR_DIM" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "DEDUP_IN2_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "DEDUP_IN2_c" IS
  SELECT
  "DEDUP_INPUT_SUBQUERY2"."CONTACTID" "CONTACTID",
  "CONTACT"."FIRSTNAME" "FIRSTNAME",
  "CONTACT"."LASTNAME" "LASTNAME",
  "CONTACT"."MIDDLENAME" "MIDDLENAME",
  "ACCOUNT"."ACCOUNT" "ACCOUNT",
  "CONTACT"."ACCOUNTID" "ACCOUNTID",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."ADDRESS3" "ADDRESS3",
  "ADDRESS"."CITY" "CITY",
  "ADDRESS"."STATE" "STATE",
  "ADDRESS"."COUNTRY" "COUNTRY",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  "ADDRESS"."COUNTY" "COUNTY"
FROM
   ( SELECT
DISTINCT
  "QG_EVENTINSTRUCTORS"."CONTACTID" "CONTACTID"
FROM
  "SLXDW"."QG_EVENTINSTRUCTORS" "QG_EVENTINSTRUCTORS" ) "DEDUP_INPUT_SUBQUERY2"   
 LEFT OUTER JOIN   "SLXDW"."CONTACT"  "CONTACT" ON ( ( "CONTACT"."CONTACTID" = "DEDUP_INPUT_SUBQUERY2"."CONTACTID" ) )
 LEFT OUTER JOIN   "SLXDW"."ACCOUNT"  "ACCOUNT" ON ( ( "ACCOUNT"."ACCOUNTID" = "CONTACT"."ACCOUNTID" ) )
 LEFT OUTER JOIN   "SLXDW"."ADDRESS"  "ADDRESS" ON ( ( "ADDRESS"."ADDRESSID" = "CONTACT"."ADDRESSID" ) ); 

---------------------------------------------------------------------------
--
-- "DEDUP_IN2_c$1" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "DEDUP_IN2_c$1" IS
  SELECT
  "DEDUP_INPUT_SUBQUERY2$1"."CONTACTID$1" "CONTACTID$1",
  UPPER(TRIM("CONTACT"."FIRSTNAME"))  || ' ' || 
  UPPER(TRIM("CONTACT"."MIDDLENAME"))  ||  ' '  || 
  UPPER(TRIM("CONTACT"."LASTNAME"))/* EXPR.OUTGRP1.NAME */ "NAME",
  UPPER(TRIM("ACCOUNT"."ACCOUNT"))/* EXPR.OUTGRP1.ACCT_NAME */ "ACCT_NAME",
  "CONTACT"."ACCOUNTID" "ACCOUNTID",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."ADDRESS3" "ADDRESS3",
  "ADDRESS"."CITY" "CITY",
  case upper(trim("ADDRESS"."COUNTRY" )) when 'CANADA' then null when 'CAN' then null else  "ADDRESS"."STATE"  end/* EXPR_1.OUTGRP1.STATE */ "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  case upper(trim("ADDRESS"."COUNTRY" ))
when 'CANADA'
then  "ADDRESS"."STATE"  
when 'CAN'
then  "ADDRESS"."STATE" 
else null
end/* EXPR_1.OUTGRP1.PROVINCE */ "PROVINCE",
  "ADDRESS"."COUNTRY" "COUNTRY",
  "ADDRESS"."COUNTY" "COUNTY"
FROM
   ( SELECT
DISTINCT
  "QG_EVENTINSTRUCTORS"."CONTACTID" "CONTACTID$1"
FROM
  "SLXDW"."QG_EVENTINSTRUCTORS" "QG_EVENTINSTRUCTORS" ) "DEDUP_INPUT_SUBQUERY2$1"   
 LEFT OUTER JOIN   "SLXDW"."CONTACT"  "CONTACT" ON ( ( "CONTACT"."CONTACTID" = "DEDUP_INPUT_SUBQUERY2$1"."CONTACTID$1" ) )
 LEFT OUTER JOIN   "SLXDW"."ACCOUNT"  "ACCOUNT" ON ( ( "ACCOUNT"."ACCOUNTID" = "CONTACT"."ACCOUNTID" ) )
 LEFT OUTER JOIN   "SLXDW"."ADDRESS"  "ADDRESS" ON ( ( "ADDRESS"."ADDRESSID" = "CONTACT"."ADDRESSID" ) ); 


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
FUNCTION "GET_CONST_1_SOURCE_NAME" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_1_SOURCE_NAME";
END "GET_CONST_1_SOURCE_NAME";



---------------------------------------------------------------------------
-- Function "INSTRUCTOR_DIM_Bat"
--   performs batch extraction
--   Returns TRUE on success
--   Returns FALSE on failure
---------------------------------------------------------------------------
FUNCTION "INSTRUCTOR_DIM_Bat"
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
      p_name=>'"INSTRUCTOR_DIM_Bat"',
      p_source=>'*',
      p_source_uoid=>'*',
      p_target=>'"INSTRUCTOR_DIM"',
      p_target_uoid=>'A41FFB19A74F5678E040007F01006C7D',
      p_stm=>NULL,p_info=>NULL,
      
      p_exec_mode=>MODE_SET
    );
    get_audit_detail_id := batch_auditd_id;
  	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19CD9A5678E040007F01006C7D', -- Operator INSTRUCTOR_DIM
    p_parent_object_name=>'INSTRUCTOR_DIM',
    p_parent_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'INSTRUCTOR_DIM',
    p_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19A73E5678E040007F01006C7D', -- Operator QG_EVENTINSTRUCTORS
    p_parent_object_name=>'QG_EVENTINSTRUCTORS',
    p_parent_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
    p_parent_object_type=>'Table',
    p_object_name=>'QG_EVENTINSTRUCTORS',
    p_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19A73F5678E040007F01006C7D', -- Operator ADDRESS
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
    p_parent_operator_uoid=>'A41FFB19A7505678E040007F01006C7D', -- Operator ACCOUNT
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
    p_parent_operator_uoid=>'A41FFB19CD535678E040007F01006C7D', -- Operator QG_EVENTINSTRUCTORS
    p_parent_object_name=>'QG_EVENTINSTRUCTORS',
    p_parent_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
    p_parent_object_type=>'Table',
    p_object_name=>'QG_EVENTINSTRUCTORS',
    p_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19A74F5678E040007F01006C7D', -- Operator INSTRUCTOR_DIM
    p_parent_object_name=>'INSTRUCTOR_DIM',
    p_parent_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'INSTRUCTOR_DIM',
    p_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19A73D5678E040007F01006C7D', -- Operator CONTACT
    p_parent_object_name=>'CONTACT',
    p_parent_object_uoid=>'A41FFB190F555678E040007F01006C7D', -- Table CONTACT
    p_parent_object_type=>'Table',
    p_object_name=>'CONTACT',
    p_object_uoid=>'A41FFB190F555678E040007F01006C7D', -- Table CONTACT
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
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
  
    IF NOT "INSTRUCTOR_DIM_St" THEN
    
      batch_action := 'BATCH MERGE';
batch_selected := SQL%ROWCOUNT;
MERGE
/*+ APPEND PARALLEL("INSTRUCTOR_DIM") */
INTO
  "INSTRUCTOR_DIM"
USING
  (SELECT
  "DEDUP_INPUT_SUBQUERY2$2"."CONTACTID$3" "CONTACTID$2",
  UPPER(TRIM("CONTACT"."FIRSTNAME"))  || ' ' || 
  UPPER(TRIM("CONTACT"."MIDDLENAME"))  ||  ' '  || 
  UPPER(TRIM("CONTACT"."LASTNAME"))/* EXPR.OUTGRP1.NAME */ "NAME",
  UPPER(TRIM("ACCOUNT"."ACCOUNT"))/* EXPR.OUTGRP1.ACCT_NAME */ "ACCT_NAME",
  "CONTACT"."ACCOUNTID" "ACCOUNTID",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."ADDRESS3" "ADDRESS3",
  "ADDRESS"."CITY" "CITY",
  case upper(trim("ADDRESS"."COUNTRY" )) when 'CANADA' then null when 'CAN' then null else  "ADDRESS"."STATE"  end/* EXPR_1.OUTGRP1.STATE */ "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  case upper(trim("ADDRESS"."COUNTRY" ))
when 'CANADA'
then  "ADDRESS"."STATE"  
when 'CAN'
then  "ADDRESS"."STATE" 
else null
end/* EXPR_1.OUTGRP1.PROVINCE */ "PROVINCE",
  "ADDRESS"."COUNTRY" "COUNTRY",
  "ADDRESS"."COUNTY" "COUNTY",
  "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME" "SOURCE_NAME"
FROM
   ( SELECT
DISTINCT
  "QG_EVENTINSTRUCTORS"."CONTACTID" "CONTACTID$3"
FROM
  "SLXDW"."QG_EVENTINSTRUCTORS" "QG_EVENTINSTRUCTORS" ) "DEDUP_INPUT_SUBQUERY2$2"   
 LEFT OUTER JOIN   "SLXDW"."CONTACT"  "CONTACT" ON ( ( "CONTACT"."CONTACTID" = "DEDUP_INPUT_SUBQUERY2$2"."CONTACTID$3" ) )
 LEFT OUTER JOIN   "SLXDW"."ACCOUNT"  "ACCOUNT" ON ( ( "ACCOUNT"."ACCOUNTID" = "CONTACT"."ACCOUNTID" ) )
 LEFT OUTER JOIN   "SLXDW"."ADDRESS"  "ADDRESS" ON ( ( "ADDRESS"."ADDRESSID" = "CONTACT"."ADDRESSID" ) )
  )
    MERGE_SUBQUERY
ON (
  "INSTRUCTOR_DIM"."CUST_ID" = "MERGE_SUBQUERY"."CONTACTID$2"
   )
  
  WHEN MATCHED THEN
    UPDATE
    SET
                  "CUST_NAME" = "MERGE_SUBQUERY"."NAME",
  "ACCT_NAME" = "MERGE_SUBQUERY"."ACCT_NAME",
  "ACCT_ID" = "MERGE_SUBQUERY"."ACCOUNTID",
  "ADDRESS1" = "MERGE_SUBQUERY"."ADDRESS1",
  "ADDRESS2" = "MERGE_SUBQUERY"."ADDRESS2",
  "ADDRESS3" = "MERGE_SUBQUERY"."ADDRESS3",
  "CITY" = "MERGE_SUBQUERY"."CITY",
  "STATE" = "MERGE_SUBQUERY"."STATE",
  "ZIPCODE" = "MERGE_SUBQUERY"."POSTALCODE",
  "PROVINCE" = "MERGE_SUBQUERY"."PROVINCE",
  "COUNTRY" = "MERGE_SUBQUERY"."COUNTRY",
  "COUNTY" = "MERGE_SUBQUERY"."COUNTY",
  "GKDW_SOURCE" = "MERGE_SUBQUERY"."SOURCE_NAME"
       
  WHEN NOT MATCHED THEN
    INSERT
      ("INSTRUCTOR_DIM"."CUST_ID",
      "INSTRUCTOR_DIM"."CUST_NAME",
      "INSTRUCTOR_DIM"."ACCT_NAME",
      "INSTRUCTOR_DIM"."ACCT_ID",
      "INSTRUCTOR_DIM"."ADDRESS1",
      "INSTRUCTOR_DIM"."ADDRESS2",
      "INSTRUCTOR_DIM"."ADDRESS3",
      "INSTRUCTOR_DIM"."CITY",
      "INSTRUCTOR_DIM"."STATE",
      "INSTRUCTOR_DIM"."ZIPCODE",
      "INSTRUCTOR_DIM"."PROVINCE",
      "INSTRUCTOR_DIM"."COUNTRY",
      "INSTRUCTOR_DIM"."COUNTY",
      "INSTRUCTOR_DIM"."GKDW_SOURCE")
    VALUES
      ("MERGE_SUBQUERY"."CONTACTID$2",
      "MERGE_SUBQUERY"."NAME",
      "MERGE_SUBQUERY"."ACCT_NAME",
      "MERGE_SUBQUERY"."ACCOUNTID",
      "MERGE_SUBQUERY"."ADDRESS1",
      "MERGE_SUBQUERY"."ADDRESS2",
      "MERGE_SUBQUERY"."ADDRESS3",
      "MERGE_SUBQUERY"."CITY",
      "MERGE_SUBQUERY"."STATE",
      "MERGE_SUBQUERY"."POSTALCODE",
      "MERGE_SUBQUERY"."PROVINCE",
      "MERGE_SUBQUERY"."COUNTRY",
      "MERGE_SUBQUERY"."COUNTY",
      "MERGE_SUBQUERY"."SOURCE_NAME")
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
        p_table=>'"INSTRUCTOR_DIM"',
        p_column=>'*',
        p_dstval=>NULL,
        p_stm=>'TRACE 433: ' || batch_action,
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
END "INSTRUCTOR_DIM_Bat";



-- Procedure "DEDUP_IN2_p" is the entry point for map "DEDUP_IN2_p"

PROCEDURE "DEDUP_IN2_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"DEDUP_IN2_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB19A73D5678E040007F01006C7D,A41FFB19A7505678E040007F01006C7D,A41FFB19A73F5678E040007F01006C7D';
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

"INSTRUCTOR_DIM_id" NUMBER(22) := 0;
"INSTRUCTOR_DIM_ins" NUMBER(22) := 0;
"INSTRUCTOR_DIM_upd" NUMBER(22) := 0;
"INSTRUCTOR_DIM_del" NUMBER(22) := 0;
"INSTRUCTOR_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"INSTRUCTOR_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"INSTRUCTOR_DIM_ir"  index_redirect_array;
"SV_INSTRUCTOR_DIM_srk" NUMBER;
"INSTRUCTOR_DIM_new"  BOOLEAN;
"INSTRUCTOR_DIM_nul"  BOOLEAN := FALSE;

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

"DEDUP_IN2_si" NUMBER(22) := 0;

"DEDUP_IN2_i" NUMBER(22) := 0;


"INSTRUCTOR_DIM_si" NUMBER(22) := 0;

"INSTRUCTOR_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_DEDUP_0_CONTACTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DEDUP_IN2" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_CONTACT_8_FIRSTNAME" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_CONTACT_7_LASTNAME" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_CONTACT_9_MIDDLENAME" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ACCOUNT_3_ACCOUNT" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_4_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_5_ACCT_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_CONTACT_3_ACCOUNTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_5_ADDRESS1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_6_ADDRESS2" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_18_ADDRESS3" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_7_CITY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_8_STATE" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_11_COUNTRY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_2_STATE" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_3_PROVINCE" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_9_POSTALCODE" IS TABLE OF VARCHAR2(24) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_10_COUNTY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_0_CUST_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_1_CUST_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_3_ACCT_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_5_ACCT_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_6_ADDRESS1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_7_ADDRESS2" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_8_ADDRESS3" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_9_CITY" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_10_STATE" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_11_ZIPCODE" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_12_PROVINCE" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_13_COUNTRY" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_14_COUNTY" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_21_GKDW_SOUR" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_DEDUP_0_CONTACTID"  CHAR(12);
"SV_ROWKEY_DEDUP_IN2"  VARCHAR2(18);
"SV_CONTACT_8_FIRSTNAME"  VARCHAR2(32);
"SV_CONTACT_7_LASTNAME"  VARCHAR2(32);
"SV_CONTACT_9_MIDDLENAME"  VARCHAR2(32);
"SV_ACCOUNT_3_ACCOUNT"  VARCHAR2(128);
"SV_EXPR_4_NAME"  VARCHAR2(250);
"SV_EXPR_5_ACCT_NAME"  VARCHAR2(250);
"SV_CONTACT_3_ACCOUNTID"  CHAR(12);
"SV_ADDRESS_5_ADDRESS1"  VARCHAR2(64);
"SV_ADDRESS_6_ADDRESS2"  VARCHAR2(64);
"SV_ADDRESS_18_ADDRESS3"  VARCHAR2(64);
"SV_ADDRESS_7_CITY"  VARCHAR2(32);
"SV_ADDRESS_8_STATE"  VARCHAR2(32);
"SV_ADDRESS_11_COUNTRY"  VARCHAR2(32);
"SV_EXPR_1_2_STATE"  VARCHAR2(60);
"SV_EXPR_1_3_PROVINCE"  VARCHAR2(100);
"SV_ADDRESS_9_POSTALCODE"  VARCHAR2(24);
"SV_ADDRESS_10_COUNTY"  VARCHAR2(32);
"SV_INSTRUCTOR_DIM_0_CUST_ID"  VARCHAR2(50);
"SV_INSTRUCTOR_DIM_1_CUST_NAME"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_3_ACCT_NAME"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_5_ACCT_ID"  VARCHAR2(50);
"SV_INSTRUCTOR_DIM_6_ADDRESS1"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_7_ADDRESS2"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_8_ADDRESS3"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_9_CITY"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_10_STATE"  VARCHAR2(60);
"SV_INSTRUCTOR_DIM_11_ZIPCODE"  VARCHAR2(60);
"SV_INSTRUCTOR_DIM_12_PROVINCE"  VARCHAR2(100);
"SV_INSTRUCTOR_DIM_13_COUNTRY"  VARCHAR2(60);
"SV_INSTRUCTOR_DIM_14_COUNTY"  VARCHAR2(100);
"SV_INSTRUCTOR_DIM_21_GKDW_SOUR"  VARCHAR2(20);

-- Bulk: intermediate collection variables
"DEDUP_0_CONTACTID" "T_DEDUP_0_CONTACTID";
"ROWKEY_DEDUP_IN2" "T_ROWKEY_DEDUP_IN2";
"CONTACT_8_FIRSTNAME" "T_CONTACT_8_FIRSTNAME";
"CONTACT_7_LASTNAME" "T_CONTACT_7_LASTNAME";
"CONTACT_9_MIDDLENAME" "T_CONTACT_9_MIDDLENAME";
"ACCOUNT_3_ACCOUNT" "T_ACCOUNT_3_ACCOUNT";
"EXPR_4_NAME" "T_EXPR_4_NAME";
"EXPR_5_ACCT_NAME" "T_EXPR_5_ACCT_NAME";
"CONTACT_3_ACCOUNTID" "T_CONTACT_3_ACCOUNTID";
"ADDRESS_5_ADDRESS1" "T_ADDRESS_5_ADDRESS1";
"ADDRESS_6_ADDRESS2" "T_ADDRESS_6_ADDRESS2";
"ADDRESS_18_ADDRESS3" "T_ADDRESS_18_ADDRESS3";
"ADDRESS_7_CITY" "T_ADDRESS_7_CITY";
"ADDRESS_8_STATE" "T_ADDRESS_8_STATE";
"ADDRESS_11_COUNTRY" "T_ADDRESS_11_COUNTRY";
"EXPR_1_2_STATE" "T_EXPR_1_2_STATE";
"EXPR_1_3_PROVINCE" "T_EXPR_1_3_PROVINCE";
"ADDRESS_9_POSTALCODE" "T_ADDRESS_9_POSTALCODE";
"ADDRESS_10_COUNTY" "T_ADDRESS_10_COUNTY";
"INSTRUCTOR_DIM_0_CUST_ID" "T_INSTRUCTOR_DIM_0_CUST_ID";
"INSTRUCTOR_DIM_1_CUST_NAME" "T_INSTRUCTOR_DIM_1_CUST_NAME";
"INSTRUCTOR_DIM_3_ACCT_NAME" "T_INSTRUCTOR_DIM_3_ACCT_NAME";
"INSTRUCTOR_DIM_5_ACCT_ID" "T_INSTRUCTOR_DIM_5_ACCT_ID";
"INSTRUCTOR_DIM_6_ADDRESS1" "T_INSTRUCTOR_DIM_6_ADDRESS1";
"INSTRUCTOR_DIM_7_ADDRESS2" "T_INSTRUCTOR_DIM_7_ADDRESS2";
"INSTRUCTOR_DIM_8_ADDRESS3" "T_INSTRUCTOR_DIM_8_ADDRESS3";
"INSTRUCTOR_DIM_9_CITY" "T_INSTRUCTOR_DIM_9_CITY";
"INSTRUCTOR_DIM_10_STATE" "T_INSTRUCTOR_DIM_10_STATE";
"INSTRUCTOR_DIM_11_ZIPCODE" "T_INSTRUCTOR_DIM_11_ZIPCODE";
"INSTRUCTOR_DIM_12_PROVINCE" "T_INSTRUCTOR_DIM_12_PROVINCE";
"INSTRUCTOR_DIM_13_COUNTRY" "T_INSTRUCTOR_DIM_13_COUNTRY";
"INSTRUCTOR_DIM_14_COUNTY" "T_INSTRUCTOR_DIM_14_COUNTY";
"INSTRUCTOR_DIM_21_GKDW_SOURCE" "T_INSTRUCTOR_DIM_21_GKDW_SOUR";

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
PROCEDURE "DEDUP_IN2_ES"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('DEDUP_0_CONTACTID',0,80),
    p_value=>SUBSTRB("DEDUP_0_CONTACTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('CONTACT_8_FIRSTNAME',0,80),
    p_value=>SUBSTRB("CONTACT_8_FIRSTNAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('CONTACT_7_LASTNAME',0,80),
    p_value=>SUBSTRB("CONTACT_7_LASTNAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('CONTACT_9_MIDDLENAME',0,80),
    p_value=>SUBSTRB("CONTACT_9_MIDDLENAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ACCOUNT_3_ACCOUNT',0,80),
    p_value=>SUBSTRB("ACCOUNT_3_ACCOUNT"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('CONTACT_3_ACCOUNTID',0,80),
    p_value=>SUBSTRB("CONTACT_3_ACCOUNTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_5_ADDRESS1',0,80),
    p_value=>SUBSTRB("ADDRESS_5_ADDRESS1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_6_ADDRESS2',0,80),
    p_value=>SUBSTRB("ADDRESS_6_ADDRESS2"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_18_ADDRESS3',0,80),
    p_value=>SUBSTRB("ADDRESS_18_ADDRESS3"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_7_CITY',0,80),
    p_value=>SUBSTRB("ADDRESS_7_CITY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_8_STATE',0,80),
    p_value=>SUBSTRB("ADDRESS_8_STATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_11_COUNTRY',0,80),
    p_value=>SUBSTRB("ADDRESS_11_COUNTRY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_9_POSTALCODE',0,80),
    p_value=>SUBSTRB("ADDRESS_9_POSTALCODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_10_COUNTY',0,80),
    p_value=>SUBSTRB("ADDRESS_10_COUNTY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "DEDUP_IN2_ES";

---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_ER" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_ER"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 434: ' || p_statement,
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
    "DEDUP_IN2_ES"(p_error_index);
  END IF;
END "DEDUP_IN2_ER";



---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_SU" opens and initializes data source
-- for map "DEDUP_IN2_p"
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_SU" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "DEDUP_IN2_c"%ISOPEN) THEN
    OPEN "DEDUP_IN2_c";
  END IF;
  get_read_success := TRUE;
END "DEDUP_IN2_SU";

---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_RD" fetches a bulk of rows from
--   the data source for map "DEDUP_IN2_p"
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_RD" IS
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
    "DEDUP_0_CONTACTID".DELETE;
    "CONTACT_8_FIRSTNAME".DELETE;
    "CONTACT_7_LASTNAME".DELETE;
    "CONTACT_9_MIDDLENAME".DELETE;
    "ACCOUNT_3_ACCOUNT".DELETE;
    "CONTACT_3_ACCOUNTID".DELETE;
    "ADDRESS_5_ADDRESS1".DELETE;
    "ADDRESS_6_ADDRESS2".DELETE;
    "ADDRESS_18_ADDRESS3".DELETE;
    "ADDRESS_7_CITY".DELETE;
    "ADDRESS_8_STATE".DELETE;
    "ADDRESS_11_COUNTRY".DELETE;
    "ADDRESS_9_POSTALCODE".DELETE;
    "ADDRESS_10_COUNTY".DELETE;

    FETCH
      "DEDUP_IN2_c"
    BULK COLLECT INTO
      "DEDUP_0_CONTACTID",
      "CONTACT_8_FIRSTNAME",
      "CONTACT_7_LASTNAME",
      "CONTACT_9_MIDDLENAME",
      "ACCOUNT_3_ACCOUNT",
      "CONTACT_3_ACCOUNTID",
      "ADDRESS_5_ADDRESS1",
      "ADDRESS_6_ADDRESS2",
      "ADDRESS_18_ADDRESS3",
      "ADDRESS_7_CITY",
      "ADDRESS_8_STATE",
      "ADDRESS_11_COUNTRY",
      "ADDRESS_9_POSTALCODE",
      "ADDRESS_10_COUNTY"
    LIMIT get_bulk_size;

    IF "DEDUP_IN2_c"%NOTFOUND AND "DEDUP_0_CONTACTID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "DEDUP_0_CONTACTID".COUNT;
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
    get_map_selected := get_map_selected + "DEDUP_0_CONTACTID".COUNT;
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
          p_stm=>'TRACE 435: SELECT',
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
END "DEDUP_IN2_RD";

---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_DML" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_DML"(si NUMBER, firstround BOOLEAN) IS
  "INSTRUCTOR_DIM_ins0" NUMBER := "INSTRUCTOR_DIM_ins";
  "INSTRUCTOR_DIM_upd0" NUMBER := "INSTRUCTOR_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "INSTRUCTOR_DIM_St" THEN
  -- Update/Insert DML for "INSTRUCTOR_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"INSTRUCTOR_DIM"';
    get_audit_detail_id := "INSTRUCTOR_DIM_id";
    "INSTRUCTOR_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "INSTRUCTOR_DIM_i" > get_bulk_size 
   OR "DEDUP_IN2_c"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "INSTRUCTOR_DIM_si".."INSTRUCTOR_DIM_i" - 1 
            UPDATE
            /*+ APPEND PARALLEL("INSTRUCTOR_DIM") */
              "INSTRUCTOR_DIM"
            SET
  
  						"INSTRUCTOR_DIM"."CUST_NAME" = "INSTRUCTOR_DIM_1_CUST_NAME"
  (i),						"INSTRUCTOR_DIM"."ACCT_NAME" = "INSTRUCTOR_DIM_3_ACCT_NAME"
  (i),						"INSTRUCTOR_DIM"."ACCT_ID" = "INSTRUCTOR_DIM_5_ACCT_ID"
  (i),						"INSTRUCTOR_DIM"."ADDRESS1" = "INSTRUCTOR_DIM_6_ADDRESS1"
  (i),						"INSTRUCTOR_DIM"."ADDRESS2" = "INSTRUCTOR_DIM_7_ADDRESS2"
  (i),						"INSTRUCTOR_DIM"."ADDRESS3" = "INSTRUCTOR_DIM_8_ADDRESS3"
  (i),						"INSTRUCTOR_DIM"."CITY" = "INSTRUCTOR_DIM_9_CITY"
  (i),						"INSTRUCTOR_DIM"."STATE" = "INSTRUCTOR_DIM_10_STATE"
  (i),						"INSTRUCTOR_DIM"."ZIPCODE" = "INSTRUCTOR_DIM_11_ZIPCODE"
  (i),						"INSTRUCTOR_DIM"."PROVINCE" = "INSTRUCTOR_DIM_12_PROVINCE"
  (i),						"INSTRUCTOR_DIM"."COUNTRY" = "INSTRUCTOR_DIM_13_COUNTRY"
  (i),						"INSTRUCTOR_DIM"."COUNTY" = "INSTRUCTOR_DIM_14_COUNTY"
  (i),						"INSTRUCTOR_DIM"."GKDW_SOURCE" = "INSTRUCTOR_DIM_21_GKDW_SOURCE"
  (i)
    
            WHERE
  
  						"INSTRUCTOR_DIM"."CUST_ID" = "INSTRUCTOR_DIM_0_CUST_ID"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "INSTRUCTOR_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "INSTRUCTOR_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "INSTRUCTOR_DIM_srk"(rowkey_index);
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
  
          "INSTRUCTOR_DIM_upd" := "INSTRUCTOR_DIM_upd" + get_rowid.COUNT;
          "INSTRUCTOR_DIM_si" := "INSTRUCTOR_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "INSTRUCTOR_DIM_si".."INSTRUCTOR_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "INSTRUCTOR_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "INSTRUCTOR_DIM_srk"(rowkey_index);
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
            "INSTRUCTOR_DIM_upd" := "INSTRUCTOR_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "INSTRUCTOR_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                /*+ APPEND PARALLEL("INSTRUCTOR_DIM") */
                  "INSTRUCTOR_DIM"
                SET
  
  								"INSTRUCTOR_DIM"."CUST_NAME" = "INSTRUCTOR_DIM_1_CUST_NAME"
  (last_successful_index),								"INSTRUCTOR_DIM"."ACCT_NAME" = "INSTRUCTOR_DIM_3_ACCT_NAME"
  (last_successful_index),								"INSTRUCTOR_DIM"."ACCT_ID" = "INSTRUCTOR_DIM_5_ACCT_ID"
  (last_successful_index),								"INSTRUCTOR_DIM"."ADDRESS1" = "INSTRUCTOR_DIM_6_ADDRESS1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ADDRESS2" = "INSTRUCTOR_DIM_7_ADDRESS2"
  (last_successful_index),								"INSTRUCTOR_DIM"."ADDRESS3" = "INSTRUCTOR_DIM_8_ADDRESS3"
  (last_successful_index),								"INSTRUCTOR_DIM"."CITY" = "INSTRUCTOR_DIM_9_CITY"
  (last_successful_index),								"INSTRUCTOR_DIM"."STATE" = "INSTRUCTOR_DIM_10_STATE"
  (last_successful_index),								"INSTRUCTOR_DIM"."ZIPCODE" = "INSTRUCTOR_DIM_11_ZIPCODE"
  (last_successful_index),								"INSTRUCTOR_DIM"."PROVINCE" = "INSTRUCTOR_DIM_12_PROVINCE"
  (last_successful_index),								"INSTRUCTOR_DIM"."COUNTRY" = "INSTRUCTOR_DIM_13_COUNTRY"
  (last_successful_index),								"INSTRUCTOR_DIM"."COUNTY" = "INSTRUCTOR_DIM_14_COUNTY"
  (last_successful_index),								"INSTRUCTOR_DIM"."GKDW_SOURCE" = "INSTRUCTOR_DIM_21_GKDW_SOURCE"
  (last_successful_index)
  
                WHERE
  
  								"INSTRUCTOR_DIM"."CUST_ID" = "INSTRUCTOR_DIM_0_CUST_ID"
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
                  error_rowkey := "INSTRUCTOR_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CUST_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_1_CUST_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_3_ACCT_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_ID"',0,80),SUBSTRB("INSTRUCTOR_DIM_5_ACCT_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS1"',0,80),SUBSTRB("INSTRUCTOR_DIM_6_ADDRESS1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS2"',0,80),SUBSTRB("INSTRUCTOR_DIM_7_ADDRESS2"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS3"',0,80),SUBSTRB("INSTRUCTOR_DIM_8_ADDRESS3"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CITY"',0,80),SUBSTRB("INSTRUCTOR_DIM_9_CITY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."STATE"',0,80),SUBSTRB("INSTRUCTOR_DIM_10_STATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ZIPCODE"',0,80),SUBSTRB("INSTRUCTOR_DIM_11_ZIPCODE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."PROVINCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_12_PROVINCE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTRY"',0,80),SUBSTRB("INSTRUCTOR_DIM_13_COUNTRY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTY"',0,80),SUBSTRB("INSTRUCTOR_DIM_14_COUNTY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_21_GKDW_SOURCE"(last_successful_index),0,2000));
                  
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
                "INSTRUCTOR_DIM_err" := "INSTRUCTOR_DIM_err" + 1;
                
                IF get_errors + "INSTRUCTOR_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "INSTRUCTOR_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "INSTRUCTOR_DIM_si" >= "INSTRUCTOR_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "INSTRUCTOR_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"INSTRUCTOR_DIM_0_CUST_ID"(insert_bulk_index) := "INSTRUCTOR_DIM_0_CUST_ID"(update_bulk(j));
  		"INSTRUCTOR_DIM_1_CUST_NAME"(insert_bulk_index) := "INSTRUCTOR_DIM_1_CUST_NAME"(update_bulk(j));
  		"INSTRUCTOR_DIM_3_ACCT_NAME"(insert_bulk_index) := "INSTRUCTOR_DIM_3_ACCT_NAME"(update_bulk(j));
  		"INSTRUCTOR_DIM_5_ACCT_ID"(insert_bulk_index) := "INSTRUCTOR_DIM_5_ACCT_ID"(update_bulk(j));
  		"INSTRUCTOR_DIM_6_ADDRESS1"(insert_bulk_index) := "INSTRUCTOR_DIM_6_ADDRESS1"(update_bulk(j));
  		"INSTRUCTOR_DIM_7_ADDRESS2"(insert_bulk_index) := "INSTRUCTOR_DIM_7_ADDRESS2"(update_bulk(j));
  		"INSTRUCTOR_DIM_8_ADDRESS3"(insert_bulk_index) := "INSTRUCTOR_DIM_8_ADDRESS3"(update_bulk(j));
  		"INSTRUCTOR_DIM_9_CITY"(insert_bulk_index) := "INSTRUCTOR_DIM_9_CITY"(update_bulk(j));
  		"INSTRUCTOR_DIM_10_STATE"(insert_bulk_index) := "INSTRUCTOR_DIM_10_STATE"(update_bulk(j));
  		"INSTRUCTOR_DIM_11_ZIPCODE"(insert_bulk_index) := "INSTRUCTOR_DIM_11_ZIPCODE"(update_bulk(j));
  		"INSTRUCTOR_DIM_12_PROVINCE"(insert_bulk_index) := "INSTRUCTOR_DIM_12_PROVINCE"(update_bulk(j));
  		"INSTRUCTOR_DIM_13_COUNTRY"(insert_bulk_index) := "INSTRUCTOR_DIM_13_COUNTRY"(update_bulk(j));
  		"INSTRUCTOR_DIM_14_COUNTY"(insert_bulk_index) := "INSTRUCTOR_DIM_14_COUNTY"(update_bulk(j));
  		"INSTRUCTOR_DIM_21_GKDW_SOURCE"(insert_bulk_index) := "INSTRUCTOR_DIM_21_GKDW_SOURCE"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "INSTRUCTOR_DIM_srk"(insert_bulk_index) := "INSTRUCTOR_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "INSTRUCTOR_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "INSTRUCTOR_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "INSTRUCTOR_DIM_si"..insert_bulk_index
          INSERT INTO
            "INSTRUCTOR_DIM"
            ("INSTRUCTOR_DIM"."CUST_ID",
            "INSTRUCTOR_DIM"."CUST_NAME",
            "INSTRUCTOR_DIM"."ACCT_NAME",
            "INSTRUCTOR_DIM"."ACCT_ID",
            "INSTRUCTOR_DIM"."ADDRESS1",
            "INSTRUCTOR_DIM"."ADDRESS2",
            "INSTRUCTOR_DIM"."ADDRESS3",
            "INSTRUCTOR_DIM"."CITY",
            "INSTRUCTOR_DIM"."STATE",
            "INSTRUCTOR_DIM"."ZIPCODE",
            "INSTRUCTOR_DIM"."PROVINCE",
            "INSTRUCTOR_DIM"."COUNTRY",
            "INSTRUCTOR_DIM"."COUNTY",
            "INSTRUCTOR_DIM"."GKDW_SOURCE")
          VALUES
            ("INSTRUCTOR_DIM_0_CUST_ID"(i),
            "INSTRUCTOR_DIM_1_CUST_NAME"(i),
            "INSTRUCTOR_DIM_3_ACCT_NAME"(i),
            "INSTRUCTOR_DIM_5_ACCT_ID"(i),
            "INSTRUCTOR_DIM_6_ADDRESS1"(i),
            "INSTRUCTOR_DIM_7_ADDRESS2"(i),
            "INSTRUCTOR_DIM_8_ADDRESS3"(i),
            "INSTRUCTOR_DIM_9_CITY"(i),
            "INSTRUCTOR_DIM_10_STATE"(i),
            "INSTRUCTOR_DIM_11_ZIPCODE"(i),
            "INSTRUCTOR_DIM_12_PROVINCE"(i),
            "INSTRUCTOR_DIM_13_COUNTRY"(i),
            "INSTRUCTOR_DIM_14_COUNTY"(i),
            "INSTRUCTOR_DIM_21_GKDW_SOURCE"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "INSTRUCTOR_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "INSTRUCTOR_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "INSTRUCTOR_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 436: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CUST_ID"',0,80),SUBSTRB("INSTRUCTOR_DIM_0_CUST_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CUST_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_1_CUST_NAME"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_3_ACCT_NAME"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_ID"',0,80),SUBSTRB("INSTRUCTOR_DIM_5_ACCT_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS1"',0,80),SUBSTRB("INSTRUCTOR_DIM_6_ADDRESS1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS2"',0,80),SUBSTRB("INSTRUCTOR_DIM_7_ADDRESS2"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS3"',0,80),SUBSTRB("INSTRUCTOR_DIM_8_ADDRESS3"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CITY"',0,80),SUBSTRB("INSTRUCTOR_DIM_9_CITY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."STATE"',0,80),SUBSTRB("INSTRUCTOR_DIM_10_STATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ZIPCODE"',0,80),SUBSTRB("INSTRUCTOR_DIM_11_ZIPCODE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."PROVINCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_12_PROVINCE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTRY"',0,80),SUBSTRB("INSTRUCTOR_DIM_13_COUNTRY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTY"',0,80),SUBSTRB("INSTRUCTOR_DIM_14_COUNTY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_21_GKDW_SOURCE"(error_index),0,2000));
            
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
          "INSTRUCTOR_DIM_err" := "INSTRUCTOR_DIM_err" + 1;
          
          IF get_errors + "INSTRUCTOR_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "INSTRUCTOR_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "INSTRUCTOR_DIM_srk"(rowkey_index);
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
  
      "INSTRUCTOR_DIM_ins" := "INSTRUCTOR_DIM_ins" + get_rowid.COUNT;
      "INSTRUCTOR_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "INSTRUCTOR_DIM_ins" := "INSTRUCTOR_DIM_ins0"; 
    "INSTRUCTOR_DIM_upd" := "INSTRUCTOR_DIM_upd0";
  END IF;

END "DEDUP_IN2_DML";

---------------------------------------------------------------------------
-- "DEDUP_IN2_p" main
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

  IF NOT "INSTRUCTOR_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "DEDUP_IN2_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "INSTRUCTOR_DIM_St" THEN
          "INSTRUCTOR_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"INSTRUCTOR_DIM"',
              p_target_uoid=>'A41FFB19A74F5678E040007F01006C7D',
              p_stm=>'TRACE 438',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "INSTRUCTOR_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19CD9A5678E040007F01006C7D', -- Operator INSTRUCTOR_DIM
              p_parent_object_name=>'INSTRUCTOR_DIM',
              p_parent_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'INSTRUCTOR_DIM',
              p_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A73E5678E040007F01006C7D', -- Operator QG_EVENTINSTRUCTORS
              p_parent_object_name=>'QG_EVENTINSTRUCTORS',
              p_parent_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_parent_object_type=>'Table',
              p_object_name=>'QG_EVENTINSTRUCTORS',
              p_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A73F5678E040007F01006C7D', -- Operator ADDRESS
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
              p_parent_operator_uoid=>'A41FFB19A7505678E040007F01006C7D', -- Operator ACCOUNT
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
              p_parent_operator_uoid=>'A41FFB19CD535678E040007F01006C7D', -- Operator QG_EVENTINSTRUCTORS
              p_parent_object_name=>'QG_EVENTINSTRUCTORS',
              p_parent_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_parent_object_type=>'Table',
              p_object_name=>'QG_EVENTINSTRUCTORS',
              p_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A74F5678E040007F01006C7D', -- Operator INSTRUCTOR_DIM
              p_parent_object_name=>'INSTRUCTOR_DIM',
              p_parent_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'INSTRUCTOR_DIM',
              p_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A73D5678E040007F01006C7D', -- Operator CONTACT
              p_parent_object_name=>'CONTACT',
              p_parent_object_uoid=>'A41FFB190F555678E040007F01006C7D', -- Table CONTACT
              p_parent_object_type=>'Table',
              p_object_name=>'CONTACT',
              p_object_uoid=>'A41FFB190F555678E040007F01006C7D', -- Table CONTACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
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
    "DEDUP_IN2_si" := 0;
    "INSTRUCTOR_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "DEDUP_IN2_SU";

      LOOP
        IF "DEDUP_IN2_si" = 0 THEN
          "DEDUP_IN2_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "DEDUP_0_CONTACTID".COUNT - 1;
          ELSE
            bulk_count := "DEDUP_0_CONTACTID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "INSTRUCTOR_DIM_ir".DELETE;
"INSTRUCTOR_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "DEDUP_IN2_i" := "DEDUP_IN2_si";
        BEGIN
          
          LOOP
            EXIT WHEN "INSTRUCTOR_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "DEDUP_IN2_i" := "DEDUP_IN2_i" + 1;
            "DEDUP_IN2_si" := "DEDUP_IN2_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "INSTRUCTOR_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("DEDUP_IN2_c"%NOTFOUND AND
               "DEDUP_IN2_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "DEDUP_IN2_i" > bulk_count THEN
            
              "DEDUP_IN2_si" := 0;
              EXIT;
            END IF;


            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_4_NAME"
            ("DEDUP_IN2_i") := 
            UPPER(TRIM("CONTACT_8_FIRSTNAME"
            ("DEDUP_IN2_i")))  || '' '' || 
  UPPER(TRIM("CONTACT_9_MIDDLENAME"
            ("DEDUP_IN2_i")))  ||  '' ''  || 
  UPPER(TRIM("CONTACT_7_LASTNAME"
            ("DEDUP_IN2_i")))/* EXPR.OUTGRP1.NAME */;
            
            ',0,2000);
            
            
            "EXPR_4_NAME"
            ("DEDUP_IN2_i") := 
            UPPER(TRIM("CONTACT_8_FIRSTNAME"
            ("DEDUP_IN2_i")))  || ' ' || 
  UPPER(TRIM("CONTACT_9_MIDDLENAME"
            ("DEDUP_IN2_i")))  ||  ' '  || 
  UPPER(TRIM("CONTACT_7_LASTNAME"
            ("DEDUP_IN2_i")))/* EXPR.OUTGRP1.NAME */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_5_ACCT_NAME"
            ("DEDUP_IN2_i") := 
            UPPER(TRIM("ACCOUNT_3_ACCOUNT"
            ("DEDUP_IN2_i")))/* EXPR.OUTGRP1.ACCT_NAME */;
            
            ',0,2000);
            
            
            "EXPR_5_ACCT_NAME"
            ("DEDUP_IN2_i") := 
            UPPER(TRIM("ACCOUNT_3_ACCOUNT"
            ("DEDUP_IN2_i")))/* EXPR.OUTGRP1.ACCT_NAME */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_2_STATE"
            ("DEDUP_IN2_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("DEDUP_IN2_i") )) when ''CANADA'' then null when ''CAN'' then null else  "ADDRESS_8_STATE"
            ("DEDUP_IN2_i")  end/* EXPR_1.OUTGRP1.STATE */;
            
            ',0,2000);
            
            
            "EXPR_1_2_STATE"
            ("DEDUP_IN2_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("DEDUP_IN2_i") )) when 'CANADA' then null when 'CAN' then null else  "ADDRESS_8_STATE"
            ("DEDUP_IN2_i")  end/* EXPR_1.OUTGRP1.STATE */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_3_PROVINCE"
            ("DEDUP_IN2_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("DEDUP_IN2_i") ))
when ''CANADA''
then  "ADDRESS_8_STATE"
            ("DEDUP_IN2_i")  
when ''CAN''
then  "ADDRESS_8_STATE"
            ("DEDUP_IN2_i") 
else null
end/* EXPR_1.OUTGRP1.PROVINCE */;
            
            ',0,2000);
            
            
            "EXPR_1_3_PROVINCE"
            ("DEDUP_IN2_i") := 
            case upper(trim("ADDRESS_11_COUNTRY"
            ("DEDUP_IN2_i") ))
when 'CANADA'
then  "ADDRESS_8_STATE"
            ("DEDUP_IN2_i")  
when 'CAN'
then  "ADDRESS_8_STATE"
            ("DEDUP_IN2_i") 
else null
end/* EXPR_1.OUTGRP1.PROVINCE */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            
get_target_name := '"INSTRUCTOR_DIM"';
            get_audit_detail_id := "INSTRUCTOR_DIM_id";
            IF NOT "INSTRUCTOR_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_0_CUST_ID"("INSTRUCTOR_DIM_i") := 
            
            RTRIM("DEDUP_0_CONTACTID"("DEDUP_IN2_i"));',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_0_CUST_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("DEDUP_0_CONTACTID"("DEDUP_IN2_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_0_CUST_ID"("INSTRUCTOR_DIM_i") :=
            
            RTRIM("DEDUP_0_CONTACTID"("DEDUP_IN2_i"));
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_0_CUST_ID" :=
            
            RTRIM("DEDUP_0_CONTACTID"("DEDUP_IN2_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_1_CUST_NAME"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_4_NAME"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_1_CUST_NAME"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_4_NAME"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_1_CUST_NAME"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_4_NAME"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_1_CUST_NAME" :=
            
            "EXPR_4_NAME"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_3_ACCT_NAME"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_5_ACCT_NAME"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_3_ACCT_NAME"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_5_ACCT_NAME"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_3_ACCT_NAME"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_5_ACCT_NAME"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_3_ACCT_NAME" :=
            
            "EXPR_5_ACCT_NAME"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_5_ACCT_ID"("INSTRUCTOR_DIM_i") := 
            
            RTRIM("CONTACT_3_ACCOUNTID"("DEDUP_IN2_i"));',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_5_ACCT_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("CONTACT_3_ACCOUNTID"("DEDUP_IN2_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_5_ACCT_ID"("INSTRUCTOR_DIM_i") :=
            
            RTRIM("CONTACT_3_ACCOUNTID"("DEDUP_IN2_i"));
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_5_ACCT_ID" :=
            
            RTRIM("CONTACT_3_ACCOUNTID"("DEDUP_IN2_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_6_ADDRESS1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_5_ADDRESS1"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_6_ADDRESS1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_5_ADDRESS1"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_6_ADDRESS1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_5_ADDRESS1"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_6_ADDRESS1" :=
            
            "ADDRESS_5_ADDRESS1"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_7_ADDRESS2"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_6_ADDRESS2"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_7_ADDRESS2"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_6_ADDRESS2"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_7_ADDRESS2"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_6_ADDRESS2"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_7_ADDRESS2" :=
            
            "ADDRESS_6_ADDRESS2"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_8_ADDRESS3"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_18_ADDRESS3"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_8_ADDRESS3"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_18_ADDRESS3"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_8_ADDRESS3"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_18_ADDRESS3"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_8_ADDRESS3" :=
            
            "ADDRESS_18_ADDRESS3"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_9_CITY"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_7_CITY"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_9_CITY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_7_CITY"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_9_CITY"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_7_CITY"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_9_CITY" :=
            
            "ADDRESS_7_CITY"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_10_STATE"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_1_2_STATE"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_10_STATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_2_STATE"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_10_STATE"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_1_2_STATE"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_10_STATE" :=
            
            "EXPR_1_2_STATE"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_11_ZIPCODE"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_9_POSTALCODE"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_11_ZIPCODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_9_POSTALCODE"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_11_ZIPCODE"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_9_POSTALCODE"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_11_ZIPCODE" :=
            
            "ADDRESS_9_POSTALCODE"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_12_PROVINCE"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_1_3_PROVINCE"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_12_PROVINCE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_3_PROVINCE"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_12_PROVINCE"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_1_3_PROVINCE"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_12_PROVINCE" :=
            
            "EXPR_1_3_PROVINCE"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_13_COUNTRY"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_11_COUNTRY"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_13_COUNTRY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_11_COUNTRY"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_13_COUNTRY"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_11_COUNTRY"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_13_COUNTRY" :=
            
            "ADDRESS_11_COUNTRY"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_14_COUNTY"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_10_COUNTY"("DEDUP_IN2_i");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_14_COUNTY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_10_COUNTY"("DEDUP_IN2_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_14_COUNTY"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_10_COUNTY"("DEDUP_IN2_i");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_14_COUNTY" :=
            
            "ADDRESS_10_COUNTY"("DEDUP_IN2_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_21_GKDW_SOURCE"("INSTRUCTOR_DIM_i") := 
            
            "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME";',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_21_GKDW_SOURCE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_21_GKDW_SOURCE"("INSTRUCTOR_DIM_i") :=
            
            "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME";
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_21_GKDW_SOUR" :=
            
            "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME";
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "INSTRUCTOR_DIM_srk"("INSTRUCTOR_DIM_i") := get_rowkey + "DEDUP_IN2_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_INSTRUCTOR_DIM_srk" := get_rowkey + "DEDUP_IN2_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "INSTRUCTOR_DIM_new" := TRUE;
                ELSE
                  "INSTRUCTOR_DIM_i" := "INSTRUCTOR_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "DEDUP_IN2_ER"('TRACE 439: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "DEDUP_IN2_i");
                  
                  "INSTRUCTOR_DIM_err" := "INSTRUCTOR_DIM_err" + 1;
                  
                  IF get_errors + "INSTRUCTOR_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("INSTRUCTOR_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "INSTRUCTOR_DIM_new" 
            AND (NOT "INSTRUCTOR_DIM_nul") THEN
              "INSTRUCTOR_DIM_ir"(dml_bsize) := "INSTRUCTOR_DIM_i";
            	"INSTRUCTOR_DIM_0_CUST_ID"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_0_CUST_ID";
            	"INSTRUCTOR_DIM_1_CUST_NAME"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_1_CUST_NAME";
            	"INSTRUCTOR_DIM_3_ACCT_NAME"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_3_ACCT_NAME";
            	"INSTRUCTOR_DIM_5_ACCT_ID"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_5_ACCT_ID";
            	"INSTRUCTOR_DIM_6_ADDRESS1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_6_ADDRESS1";
            	"INSTRUCTOR_DIM_7_ADDRESS2"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_7_ADDRESS2";
            	"INSTRUCTOR_DIM_8_ADDRESS3"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_8_ADDRESS3";
            	"INSTRUCTOR_DIM_9_CITY"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_9_CITY";
            	"INSTRUCTOR_DIM_10_STATE"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_10_STATE";
            	"INSTRUCTOR_DIM_11_ZIPCODE"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_11_ZIPCODE";
            	"INSTRUCTOR_DIM_12_PROVINCE"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_12_PROVINCE";
            	"INSTRUCTOR_DIM_13_COUNTRY"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_13_COUNTRY";
            	"INSTRUCTOR_DIM_14_COUNTY"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_14_COUNTY";
            	"INSTRUCTOR_DIM_21_GKDW_SOURCE"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_21_GKDW_SOUR";
              "INSTRUCTOR_DIM_srk"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_srk";
              "INSTRUCTOR_DIM_i" := "INSTRUCTOR_DIM_i" + 1;
            ELSE
              "INSTRUCTOR_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "DEDUP_IN2_DML"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "DEDUP_IN2_DML"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "DEDUP_IN2_ER"('TRACE 437: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "DEDUP_IN2_i");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "DEDUP_IN2_c"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "DEDUP_IN2_i" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "DEDUP_IN2_i" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "DEDUP_IN2_c";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "INSTRUCTOR_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"INSTRUCTOR_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"INSTRUCTOR_DIM_ins",
        p_upd=>"INSTRUCTOR_DIM_upd",
        p_del=>"INSTRUCTOR_DIM_del",
        p_err=>"INSTRUCTOR_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "INSTRUCTOR_DIM_ins";
    get_updated  := get_updated  + "INSTRUCTOR_DIM_upd";
    get_deleted  := get_deleted  + "INSTRUCTOR_DIM_del";
    get_errors   := get_errors   + "INSTRUCTOR_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "DEDUP_IN2_p";



-- Procedure "DEDUP_IN2_t" is the entry point for map "DEDUP_IN2_t"

PROCEDURE "DEDUP_IN2_t"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"DEDUP_IN2_t"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB19A73D5678E040007F01006C7D,A41FFB19A7505678E040007F01006C7D,A41FFB19A73F5678E040007F01006C7D';
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

"INSTRUCTOR_DIM_id" NUMBER(22) := 0;
"INSTRUCTOR_DIM_ins" NUMBER(22) := 0;
"INSTRUCTOR_DIM_upd" NUMBER(22) := 0;
"INSTRUCTOR_DIM_del" NUMBER(22) := 0;
"INSTRUCTOR_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"INSTRUCTOR_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"INSTRUCTOR_DIM_ir"  index_redirect_array;
"SV_INSTRUCTOR_DIM_srk" NUMBER;
"INSTRUCTOR_DIM_new"  BOOLEAN;
"INSTRUCTOR_DIM_nul"  BOOLEAN := FALSE;

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

"DEDUP_IN2_si$1" NUMBER(22) := 0;

"DEDUP_IN2_i$1" NUMBER(22) := 0;


"INSTRUCTOR_DIM_si" NUMBER(22) := 0;

"INSTRUCTOR_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_DEDUP_0_CONTACTID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DEDUP_IN2$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_4_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_5_ACCT_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_CONTACT_3_ACCOUNTID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_5_ADDRESS1$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_6_ADDRESS2$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_18_ADDRESS3$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_7_CITY$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_2_STATE$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_9_POSTALCODE$1" IS TABLE OF VARCHAR2(24) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_3_PROVINCE$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_11_COUNTRY$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ADDRESS_10_COUNTY$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DUMMY_TABLE_CURSOR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_0_CUST_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_1_CUST_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_3_ACCT_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_5_ACCT_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_6_ADDRESS1$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_7_ADDRESS2$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_8_ADDRESS3$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_9_CITY$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_10_STATE$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_11_ZIPCODE$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_12_PROVINCE$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_13_COUNTRY$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_14_COUNTY$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_INSTRUCTOR_DIM_21_GKDW_SO" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_DEDUP_0_CONTACTID$1"  CHAR(12);
"SV_ROWKEY_DEDUP_IN2$1"  VARCHAR2(18);
"SV_EXPR_4_NAME$1"  VARCHAR2(250);
"SV_EXPR_5_ACCT_NAME$1"  VARCHAR2(250);
"SV_CONTACT_3_ACCOUNTID$1"  CHAR(12);
"SV_ADDRESS_5_ADDRESS1$1"  VARCHAR2(64);
"SV_ADDRESS_6_ADDRESS2$1"  VARCHAR2(64);
"SV_ADDRESS_18_ADDRESS3$1"  VARCHAR2(64);
"SV_ADDRESS_7_CITY$1"  VARCHAR2(32);
"SV_EXPR_1_2_STATE$1"  VARCHAR2(60);
"SV_ADDRESS_9_POSTALCODE$1"  VARCHAR2(24);
"SV_EXPR_1_3_PROVINCE$1"  VARCHAR2(100);
"SV_ADDRESS_11_COUNTRY$1"  VARCHAR2(32);
"SV_ADDRESS_10_COUNTY$1"  VARCHAR2(32);
"SV_ROWKEY_DUMMY_TABLE_CURSOR"  VARCHAR2(18);
"SV_INSTRUCTOR_DIM_0_CUST_ID$1"  VARCHAR2(50);
"SV_INSTRUCTOR_DIM_1_CUST_NA"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_3_ACCT_NA"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_5_ACCT_ID$1"  VARCHAR2(50);
"SV_INSTRUCTOR_DIM_6_ADDRESS1$1"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_7_ADDRESS2$1"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_8_ADDRESS3$1"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_9_CITY$1"  VARCHAR2(250);
"SV_INSTRUCTOR_DIM_10_STATE$1"  VARCHAR2(60);
"SV_INSTRUCTOR_DIM_11_ZIPCODE$1"  VARCHAR2(60);
"SV_INSTRUCTOR_DIM_12_PROVIN"  VARCHAR2(100);
"SV_INSTRUCTOR_DIM_13_COUNTRY$1"  VARCHAR2(60);
"SV_INSTRUCTOR_DIM_14_COUNTY$1"  VARCHAR2(100);
"SV_INSTRUCTOR_DIM_21_GKDW_SO"  VARCHAR2(20);

-- Bulk: intermediate collection variables
"DEDUP_0_CONTACTID$1" "T_DEDUP_0_CONTACTID$1";
"ROWKEY_DEDUP_IN2$1" "T_ROWKEY_DEDUP_IN2$1";
"EXPR_4_NAME$1" "T_EXPR_4_NAME$1";
"EXPR_5_ACCT_NAME$1" "T_EXPR_5_ACCT_NAME$1";
"CONTACT_3_ACCOUNTID$1" "T_CONTACT_3_ACCOUNTID$1";
"ADDRESS_5_ADDRESS1$1" "T_ADDRESS_5_ADDRESS1$1";
"ADDRESS_6_ADDRESS2$1" "T_ADDRESS_6_ADDRESS2$1";
"ADDRESS_18_ADDRESS3$1" "T_ADDRESS_18_ADDRESS3$1";
"ADDRESS_7_CITY$1" "T_ADDRESS_7_CITY$1";
"EXPR_1_2_STATE$1" "T_EXPR_1_2_STATE$1";
"ADDRESS_9_POSTALCODE$1" "T_ADDRESS_9_POSTALCODE$1";
"EXPR_1_3_PROVINCE$1" "T_EXPR_1_3_PROVINCE$1";
"ADDRESS_11_COUNTRY$1" "T_ADDRESS_11_COUNTRY$1";
"ADDRESS_10_COUNTY$1" "T_ADDRESS_10_COUNTY$1";
"ROWKEY_DUMMY_TABLE_CURSOR" "T_ROWKEY_DUMMY_TABLE_CURSOR";
"INSTRUCTOR_DIM_0_CUST_ID$1" "T_INSTRUCTOR_DIM_0_CUST_ID$1";
"INSTRUCTOR_DIM_1_CUST_NAME$1" "T_INSTRUCTOR_DIM_1_CUST_NAME$1";
"INSTRUCTOR_DIM_3_ACCT_NAME$1" "T_INSTRUCTOR_DIM_3_ACCT_NAME$1";
"INSTRUCTOR_DIM_5_ACCT_ID$1" "T_INSTRUCTOR_DIM_5_ACCT_ID$1";
"INSTRUCTOR_DIM_6_ADDRESS1$1" "T_INSTRUCTOR_DIM_6_ADDRESS1$1";
"INSTRUCTOR_DIM_7_ADDRESS2$1" "T_INSTRUCTOR_DIM_7_ADDRESS2$1";
"INSTRUCTOR_DIM_8_ADDRESS3$1" "T_INSTRUCTOR_DIM_8_ADDRESS3$1";
"INSTRUCTOR_DIM_9_CITY$1" "T_INSTRUCTOR_DIM_9_CITY$1";
"INSTRUCTOR_DIM_10_STATE$1" "T_INSTRUCTOR_DIM_10_STATE$1";
"INSTRUCTOR_DIM_11_ZIPCODE$1" "T_INSTRUCTOR_DIM_11_ZIPCODE$1";
"INSTRUCTOR_DIM_12_PROVINCE$1" "T_INSTRUCTOR_DIM_12_PROVINCE$1";
"INSTRUCTOR_DIM_13_COUNTRY$1" "T_INSTRUCTOR_DIM_13_COUNTRY$1";
"INSTRUCTOR_DIM_14_COUNTY$1" "T_INSTRUCTOR_DIM_14_COUNTY$1";
"INSTRUCTOR_DIM_21_GKDW_SOUR" "T_INSTRUCTOR_DIM_21_GKDW_SO";

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
PROCEDURE "DEDUP_IN2_ES$1"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('DEDUP_0_CONTACTID',0,80),
    p_value=>SUBSTRB("DEDUP_0_CONTACTID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('EXPR_4_NAME',0,80),
    p_value=>SUBSTRB("EXPR_4_NAME$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('EXPR_5_ACCT_NAME',0,80),
    p_value=>SUBSTRB("EXPR_5_ACCT_NAME$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('CONTACT_3_ACCOUNTID',0,80),
    p_value=>SUBSTRB("CONTACT_3_ACCOUNTID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_5_ADDRESS1',0,80),
    p_value=>SUBSTRB("ADDRESS_5_ADDRESS1$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_6_ADDRESS2',0,80),
    p_value=>SUBSTRB("ADDRESS_6_ADDRESS2$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_18_ADDRESS3',0,80),
    p_value=>SUBSTRB("ADDRESS_18_ADDRESS3$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_7_CITY',0,80),
    p_value=>SUBSTRB("ADDRESS_7_CITY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('EXPR_1_2_STATE',0,80),
    p_value=>SUBSTRB("EXPR_1_2_STATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_9_POSTALCODE',0,80),
    p_value=>SUBSTRB("ADDRESS_9_POSTALCODE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('EXPR_1_3_PROVINCE',0,80),
    p_value=>SUBSTRB("EXPR_1_3_PROVINCE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_11_COUNTRY',0,80),
    p_value=>SUBSTRB("ADDRESS_11_COUNTRY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',0,80),
    p_column=>SUBSTR('ADDRESS_10_COUNTY',0,80),
    p_value=>SUBSTRB("ADDRESS_10_COUNTY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "DEDUP_IN2_ES$1";

---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_ER$1" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_ER$1"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 440: ' || p_statement,
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
    "DEDUP_IN2_ES$1"(p_error_index);
  END IF;
END "DEDUP_IN2_ER$1";



---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_SU$1" opens and initializes data source
-- for map "DEDUP_IN2_t"
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_SU$1" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "DEDUP_IN2_c$1"%ISOPEN) THEN
    OPEN "DEDUP_IN2_c$1";
  END IF;
  get_read_success := TRUE;
END "DEDUP_IN2_SU$1";

---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_RD$1" fetches a bulk of rows from
--   the data source for map "DEDUP_IN2_t"
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_RD$1" IS
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
    "DEDUP_0_CONTACTID$1".DELETE;
    "EXPR_4_NAME$1".DELETE;
    "EXPR_5_ACCT_NAME$1".DELETE;
    "CONTACT_3_ACCOUNTID$1".DELETE;
    "ADDRESS_5_ADDRESS1$1".DELETE;
    "ADDRESS_6_ADDRESS2$1".DELETE;
    "ADDRESS_18_ADDRESS3$1".DELETE;
    "ADDRESS_7_CITY$1".DELETE;
    "EXPR_1_2_STATE$1".DELETE;
    "ADDRESS_9_POSTALCODE$1".DELETE;
    "EXPR_1_3_PROVINCE$1".DELETE;
    "ADDRESS_11_COUNTRY$1".DELETE;
    "ADDRESS_10_COUNTY$1".DELETE;

    FETCH
      "DEDUP_IN2_c$1"
    BULK COLLECT INTO
      "DEDUP_0_CONTACTID$1",
      "EXPR_4_NAME$1",
      "EXPR_5_ACCT_NAME$1",
      "CONTACT_3_ACCOUNTID$1",
      "ADDRESS_5_ADDRESS1$1",
      "ADDRESS_6_ADDRESS2$1",
      "ADDRESS_18_ADDRESS3$1",
      "ADDRESS_7_CITY$1",
      "EXPR_1_2_STATE$1",
      "ADDRESS_9_POSTALCODE$1",
      "EXPR_1_3_PROVINCE$1",
      "ADDRESS_11_COUNTRY$1",
      "ADDRESS_10_COUNTY$1"
    LIMIT get_bulk_size;

    IF "DEDUP_IN2_c$1"%NOTFOUND AND "DEDUP_0_CONTACTID$1".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "DEDUP_0_CONTACTID$1".COUNT;
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
    get_map_selected := get_map_selected + "DEDUP_0_CONTACTID$1".COUNT;
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
          p_stm=>'TRACE 441: SELECT',
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
END "DEDUP_IN2_RD$1";

---------------------------------------------------------------------------
-- Procedure "DEDUP_IN2_DML$1" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "DEDUP_IN2_DML$1"(si NUMBER, firstround BOOLEAN) IS
  "INSTRUCTOR_DIM_ins0" NUMBER := "INSTRUCTOR_DIM_ins";
  "INSTRUCTOR_DIM_upd0" NUMBER := "INSTRUCTOR_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "INSTRUCTOR_DIM_St" THEN
  -- Update/Insert DML for "INSTRUCTOR_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"INSTRUCTOR_DIM"';
    get_audit_detail_id := "INSTRUCTOR_DIM_id";
    "INSTRUCTOR_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "INSTRUCTOR_DIM_i" > get_bulk_size 
   OR "DEDUP_IN2_c$1"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "INSTRUCTOR_DIM_si".."INSTRUCTOR_DIM_i" - 1 
            UPDATE
            /*+ APPEND PARALLEL("INSTRUCTOR_DIM") */
              "INSTRUCTOR_DIM"
            SET
  
  						"INSTRUCTOR_DIM"."CUST_NAME" = "INSTRUCTOR_DIM_1_CUST_NAME$1"
  (i),						"INSTRUCTOR_DIM"."ACCT_NAME" = "INSTRUCTOR_DIM_3_ACCT_NAME$1"
  (i),						"INSTRUCTOR_DIM"."ACCT_ID" = "INSTRUCTOR_DIM_5_ACCT_ID$1"
  (i),						"INSTRUCTOR_DIM"."ADDRESS1" = "INSTRUCTOR_DIM_6_ADDRESS1$1"
  (i),						"INSTRUCTOR_DIM"."ADDRESS2" = "INSTRUCTOR_DIM_7_ADDRESS2$1"
  (i),						"INSTRUCTOR_DIM"."ADDRESS3" = "INSTRUCTOR_DIM_8_ADDRESS3$1"
  (i),						"INSTRUCTOR_DIM"."CITY" = "INSTRUCTOR_DIM_9_CITY$1"
  (i),						"INSTRUCTOR_DIM"."STATE" = "INSTRUCTOR_DIM_10_STATE$1"
  (i),						"INSTRUCTOR_DIM"."ZIPCODE" = "INSTRUCTOR_DIM_11_ZIPCODE$1"
  (i),						"INSTRUCTOR_DIM"."PROVINCE" = "INSTRUCTOR_DIM_12_PROVINCE$1"
  (i),						"INSTRUCTOR_DIM"."COUNTRY" = "INSTRUCTOR_DIM_13_COUNTRY$1"
  (i),						"INSTRUCTOR_DIM"."COUNTY" = "INSTRUCTOR_DIM_14_COUNTY$1"
  (i),						"INSTRUCTOR_DIM"."GKDW_SOURCE" = "INSTRUCTOR_DIM_21_GKDW_SOUR"
  (i)
    
            WHERE
  
  						"INSTRUCTOR_DIM"."CUST_ID" = "INSTRUCTOR_DIM_0_CUST_ID$1"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "INSTRUCTOR_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "INSTRUCTOR_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "INSTRUCTOR_DIM_srk"(rowkey_index);
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
  
          "INSTRUCTOR_DIM_upd" := "INSTRUCTOR_DIM_upd" + get_rowid.COUNT;
          "INSTRUCTOR_DIM_si" := "INSTRUCTOR_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "INSTRUCTOR_DIM_si".."INSTRUCTOR_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "INSTRUCTOR_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "INSTRUCTOR_DIM_srk"(rowkey_index);
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
            "INSTRUCTOR_DIM_upd" := "INSTRUCTOR_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "INSTRUCTOR_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                /*+ APPEND PARALLEL("INSTRUCTOR_DIM") */
                  "INSTRUCTOR_DIM"
                SET
  
  								"INSTRUCTOR_DIM"."CUST_NAME" = "INSTRUCTOR_DIM_1_CUST_NAME$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ACCT_NAME" = "INSTRUCTOR_DIM_3_ACCT_NAME$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ACCT_ID" = "INSTRUCTOR_DIM_5_ACCT_ID$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ADDRESS1" = "INSTRUCTOR_DIM_6_ADDRESS1$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ADDRESS2" = "INSTRUCTOR_DIM_7_ADDRESS2$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ADDRESS3" = "INSTRUCTOR_DIM_8_ADDRESS3$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."CITY" = "INSTRUCTOR_DIM_9_CITY$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."STATE" = "INSTRUCTOR_DIM_10_STATE$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."ZIPCODE" = "INSTRUCTOR_DIM_11_ZIPCODE$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."PROVINCE" = "INSTRUCTOR_DIM_12_PROVINCE$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."COUNTRY" = "INSTRUCTOR_DIM_13_COUNTRY$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."COUNTY" = "INSTRUCTOR_DIM_14_COUNTY$1"
  (last_successful_index),								"INSTRUCTOR_DIM"."GKDW_SOURCE" = "INSTRUCTOR_DIM_21_GKDW_SOUR"
  (last_successful_index)
  
                WHERE
  
  								"INSTRUCTOR_DIM"."CUST_ID" = "INSTRUCTOR_DIM_0_CUST_ID$1"
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
                  error_rowkey := "INSTRUCTOR_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CUST_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_1_CUST_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_3_ACCT_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_ID"',0,80),SUBSTRB("INSTRUCTOR_DIM_5_ACCT_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS1"',0,80),SUBSTRB("INSTRUCTOR_DIM_6_ADDRESS1$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS2"',0,80),SUBSTRB("INSTRUCTOR_DIM_7_ADDRESS2$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS3"',0,80),SUBSTRB("INSTRUCTOR_DIM_8_ADDRESS3$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CITY"',0,80),SUBSTRB("INSTRUCTOR_DIM_9_CITY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."STATE"',0,80),SUBSTRB("INSTRUCTOR_DIM_10_STATE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ZIPCODE"',0,80),SUBSTRB("INSTRUCTOR_DIM_11_ZIPCODE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."PROVINCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_12_PROVINCE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTRY"',0,80),SUBSTRB("INSTRUCTOR_DIM_13_COUNTRY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTY"',0,80),SUBSTRB("INSTRUCTOR_DIM_14_COUNTY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_21_GKDW_SOUR"(last_successful_index),0,2000));
                  
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
                "INSTRUCTOR_DIM_err" := "INSTRUCTOR_DIM_err" + 1;
                
                IF get_errors + "INSTRUCTOR_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "INSTRUCTOR_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "INSTRUCTOR_DIM_si" >= "INSTRUCTOR_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "INSTRUCTOR_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"INSTRUCTOR_DIM_0_CUST_ID$1"(insert_bulk_index) := "INSTRUCTOR_DIM_0_CUST_ID$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_1_CUST_NAME$1"(insert_bulk_index) := "INSTRUCTOR_DIM_1_CUST_NAME$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_3_ACCT_NAME$1"(insert_bulk_index) := "INSTRUCTOR_DIM_3_ACCT_NAME$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_5_ACCT_ID$1"(insert_bulk_index) := "INSTRUCTOR_DIM_5_ACCT_ID$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_6_ADDRESS1$1"(insert_bulk_index) := "INSTRUCTOR_DIM_6_ADDRESS1$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_7_ADDRESS2$1"(insert_bulk_index) := "INSTRUCTOR_DIM_7_ADDRESS2$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_8_ADDRESS3$1"(insert_bulk_index) := "INSTRUCTOR_DIM_8_ADDRESS3$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_9_CITY$1"(insert_bulk_index) := "INSTRUCTOR_DIM_9_CITY$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_10_STATE$1"(insert_bulk_index) := "INSTRUCTOR_DIM_10_STATE$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_11_ZIPCODE$1"(insert_bulk_index) := "INSTRUCTOR_DIM_11_ZIPCODE$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_12_PROVINCE$1"(insert_bulk_index) := "INSTRUCTOR_DIM_12_PROVINCE$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_13_COUNTRY$1"(insert_bulk_index) := "INSTRUCTOR_DIM_13_COUNTRY$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_14_COUNTY$1"(insert_bulk_index) := "INSTRUCTOR_DIM_14_COUNTY$1"(update_bulk(j));
  		"INSTRUCTOR_DIM_21_GKDW_SOUR"(insert_bulk_index) := "INSTRUCTOR_DIM_21_GKDW_SOUR"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "INSTRUCTOR_DIM_srk"(insert_bulk_index) := "INSTRUCTOR_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "INSTRUCTOR_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "INSTRUCTOR_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "INSTRUCTOR_DIM_si"..insert_bulk_index
          INSERT INTO
            "INSTRUCTOR_DIM"
            ("INSTRUCTOR_DIM"."CUST_ID",
            "INSTRUCTOR_DIM"."CUST_NAME",
            "INSTRUCTOR_DIM"."ACCT_NAME",
            "INSTRUCTOR_DIM"."ACCT_ID",
            "INSTRUCTOR_DIM"."ADDRESS1",
            "INSTRUCTOR_DIM"."ADDRESS2",
            "INSTRUCTOR_DIM"."ADDRESS3",
            "INSTRUCTOR_DIM"."CITY",
            "INSTRUCTOR_DIM"."STATE",
            "INSTRUCTOR_DIM"."ZIPCODE",
            "INSTRUCTOR_DIM"."PROVINCE",
            "INSTRUCTOR_DIM"."COUNTRY",
            "INSTRUCTOR_DIM"."COUNTY",
            "INSTRUCTOR_DIM"."GKDW_SOURCE")
          VALUES
            ("INSTRUCTOR_DIM_0_CUST_ID$1"(i),
            "INSTRUCTOR_DIM_1_CUST_NAME$1"(i),
            "INSTRUCTOR_DIM_3_ACCT_NAME$1"(i),
            "INSTRUCTOR_DIM_5_ACCT_ID$1"(i),
            "INSTRUCTOR_DIM_6_ADDRESS1$1"(i),
            "INSTRUCTOR_DIM_7_ADDRESS2$1"(i),
            "INSTRUCTOR_DIM_8_ADDRESS3$1"(i),
            "INSTRUCTOR_DIM_9_CITY$1"(i),
            "INSTRUCTOR_DIM_10_STATE$1"(i),
            "INSTRUCTOR_DIM_11_ZIPCODE$1"(i),
            "INSTRUCTOR_DIM_12_PROVINCE$1"(i),
            "INSTRUCTOR_DIM_13_COUNTRY$1"(i),
            "INSTRUCTOR_DIM_14_COUNTY$1"(i),
            "INSTRUCTOR_DIM_21_GKDW_SOUR"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "INSTRUCTOR_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "INSTRUCTOR_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "INSTRUCTOR_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 442: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CUST_ID"',0,80),SUBSTRB("INSTRUCTOR_DIM_0_CUST_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CUST_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_1_CUST_NAME$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_NAME"',0,80),SUBSTRB("INSTRUCTOR_DIM_3_ACCT_NAME$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ACCT_ID"',0,80),SUBSTRB("INSTRUCTOR_DIM_5_ACCT_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS1"',0,80),SUBSTRB("INSTRUCTOR_DIM_6_ADDRESS1$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS2"',0,80),SUBSTRB("INSTRUCTOR_DIM_7_ADDRESS2$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ADDRESS3"',0,80),SUBSTRB("INSTRUCTOR_DIM_8_ADDRESS3$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."CITY"',0,80),SUBSTRB("INSTRUCTOR_DIM_9_CITY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."STATE"',0,80),SUBSTRB("INSTRUCTOR_DIM_10_STATE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."ZIPCODE"',0,80),SUBSTRB("INSTRUCTOR_DIM_11_ZIPCODE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."PROVINCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_12_PROVINCE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTRY"',0,80),SUBSTRB("INSTRUCTOR_DIM_13_COUNTRY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."COUNTY"',0,80),SUBSTRB("INSTRUCTOR_DIM_14_COUNTY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"INSTRUCTOR_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("INSTRUCTOR_DIM_21_GKDW_SOUR"(error_index),0,2000));
            
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
          "INSTRUCTOR_DIM_err" := "INSTRUCTOR_DIM_err" + 1;
          
          IF get_errors + "INSTRUCTOR_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "INSTRUCTOR_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "INSTRUCTOR_DIM_srk"(rowkey_index);
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
  
      "INSTRUCTOR_DIM_ins" := "INSTRUCTOR_DIM_ins" + get_rowid.COUNT;
      "INSTRUCTOR_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "INSTRUCTOR_DIM_ins" := "INSTRUCTOR_DIM_ins0"; 
    "INSTRUCTOR_DIM_upd" := "INSTRUCTOR_DIM_upd0";
  END IF;

END "DEDUP_IN2_DML$1";

---------------------------------------------------------------------------
-- "DEDUP_IN2_t" main
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

  IF NOT "INSTRUCTOR_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "DEDUP_IN2_c$1"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "INSTRUCTOR_DIM_St" THEN
          "INSTRUCTOR_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"INSTRUCTOR_DIM"',
              p_target_uoid=>'A41FFB19A74F5678E040007F01006C7D',
              p_stm=>'TRACE 444',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "INSTRUCTOR_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19CD9A5678E040007F01006C7D', -- Operator INSTRUCTOR_DIM
              p_parent_object_name=>'INSTRUCTOR_DIM',
              p_parent_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'INSTRUCTOR_DIM',
              p_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A73E5678E040007F01006C7D', -- Operator QG_EVENTINSTRUCTORS
              p_parent_object_name=>'QG_EVENTINSTRUCTORS',
              p_parent_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_parent_object_type=>'Table',
              p_object_name=>'QG_EVENTINSTRUCTORS',
              p_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A73F5678E040007F01006C7D', -- Operator ADDRESS
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
              p_parent_operator_uoid=>'A41FFB19A7505678E040007F01006C7D', -- Operator ACCOUNT
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
              p_parent_operator_uoid=>'A41FFB19CD535678E040007F01006C7D', -- Operator QG_EVENTINSTRUCTORS
              p_parent_object_name=>'QG_EVENTINSTRUCTORS',
              p_parent_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_parent_object_type=>'Table',
              p_object_name=>'QG_EVENTINSTRUCTORS',
              p_object_uoid=>'A41FFB190CB25678E040007F01006C7D', -- Table QG_EVENTINSTRUCTORS
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A74F5678E040007F01006C7D', -- Operator INSTRUCTOR_DIM
              p_parent_object_name=>'INSTRUCTOR_DIM',
              p_parent_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'INSTRUCTOR_DIM',
              p_object_uoid=>'A41FA16DB00A655CE040007F01006B9E', -- Table INSTRUCTOR_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A73D5678E040007F01006C7D', -- Operator CONTACT
              p_parent_object_name=>'CONTACT',
              p_parent_object_uoid=>'A41FFB190F555678E040007F01006C7D', -- Table CONTACT
              p_parent_object_type=>'Table',
              p_object_name=>'CONTACT',
              p_object_uoid=>'A41FFB190F555678E040007F01006C7D', -- Table CONTACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
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
    "DEDUP_IN2_si$1" := 0;
    "INSTRUCTOR_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "DEDUP_IN2_SU$1";

      LOOP
        IF "DEDUP_IN2_si$1" = 0 THEN
          "DEDUP_IN2_RD$1";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "DEDUP_0_CONTACTID$1".COUNT - 1;
          ELSE
            bulk_count := "DEDUP_0_CONTACTID$1".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "INSTRUCTOR_DIM_ir".DELETE;
"INSTRUCTOR_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "DEDUP_IN2_i$1" := "DEDUP_IN2_si$1";
        BEGIN
          
          LOOP
            EXIT WHEN "INSTRUCTOR_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "DEDUP_IN2_i$1" := "DEDUP_IN2_i$1" + 1;
            "DEDUP_IN2_si$1" := "DEDUP_IN2_i$1";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "INSTRUCTOR_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("DEDUP_IN2_c$1"%NOTFOUND AND
               "DEDUP_IN2_i$1" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "DEDUP_IN2_i$1" > bulk_count THEN
            
              "DEDUP_IN2_si$1" := 0;
              EXIT;
            END IF;


            
get_target_name := '"INSTRUCTOR_DIM"';
            get_audit_detail_id := "INSTRUCTOR_DIM_id";
            IF NOT "INSTRUCTOR_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_0_CUST_ID$1"("INSTRUCTOR_DIM_i") := 
            
            RTRIM("DEDUP_0_CONTACTID$1"("DEDUP_IN2_i$1"));',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_0_CUST_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("DEDUP_0_CONTACTID$1"("DEDUP_IN2_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_0_CUST_ID$1"("INSTRUCTOR_DIM_i") :=
            
            RTRIM("DEDUP_0_CONTACTID$1"("DEDUP_IN2_i$1"));
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_0_CUST_ID$1" :=
            
            RTRIM("DEDUP_0_CONTACTID$1"("DEDUP_IN2_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_1_CUST_NAME$1"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_4_NAME$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_1_CUST_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_4_NAME$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_1_CUST_NAME$1"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_4_NAME$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_1_CUST_NA" :=
            
            "EXPR_4_NAME$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_3_ACCT_NAME$1"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_5_ACCT_NAME$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_3_ACCT_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_5_ACCT_NAME$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_3_ACCT_NAME$1"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_5_ACCT_NAME$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_3_ACCT_NA" :=
            
            "EXPR_5_ACCT_NAME$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_5_ACCT_ID$1"("INSTRUCTOR_DIM_i") := 
            
            RTRIM("CONTACT_3_ACCOUNTID$1"("DEDUP_IN2_i$1"));',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_5_ACCT_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("CONTACT_3_ACCOUNTID$1"("DEDUP_IN2_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_5_ACCT_ID$1"("INSTRUCTOR_DIM_i") :=
            
            RTRIM("CONTACT_3_ACCOUNTID$1"("DEDUP_IN2_i$1"));
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_5_ACCT_ID$1" :=
            
            RTRIM("CONTACT_3_ACCOUNTID$1"("DEDUP_IN2_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_6_ADDRESS1$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_5_ADDRESS1$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_6_ADDRESS1$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_5_ADDRESS1$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_6_ADDRESS1$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_5_ADDRESS1$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_6_ADDRESS1$1" :=
            
            "ADDRESS_5_ADDRESS1$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_7_ADDRESS2$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_6_ADDRESS2$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_7_ADDRESS2$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_6_ADDRESS2$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_7_ADDRESS2$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_6_ADDRESS2$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_7_ADDRESS2$1" :=
            
            "ADDRESS_6_ADDRESS2$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_8_ADDRESS3$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_18_ADDRESS3$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_8_ADDRESS3$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_18_ADDRESS3$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_8_ADDRESS3$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_18_ADDRESS3$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_8_ADDRESS3$1" :=
            
            "ADDRESS_18_ADDRESS3$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_9_CITY$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_7_CITY$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_9_CITY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_7_CITY$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_9_CITY$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_7_CITY$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_9_CITY$1" :=
            
            "ADDRESS_7_CITY$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_10_STATE$1"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_1_2_STATE$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_10_STATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_2_STATE$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_10_STATE$1"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_1_2_STATE$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_10_STATE$1" :=
            
            "EXPR_1_2_STATE$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_11_ZIPCODE$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_9_POSTALCODE$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_11_ZIPCODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_9_POSTALCODE$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_11_ZIPCODE$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_9_POSTALCODE$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_11_ZIPCODE$1" :=
            
            "ADDRESS_9_POSTALCODE$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_12_PROVINCE$1"("INSTRUCTOR_DIM_i") := 
            
            "EXPR_1_3_PROVINCE$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_12_PROVINCE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_3_PROVINCE$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_12_PROVINCE$1"("INSTRUCTOR_DIM_i") :=
            
            "EXPR_1_3_PROVINCE$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_12_PROVIN" :=
            
            "EXPR_1_3_PROVINCE$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_13_COUNTRY$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_11_COUNTRY$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_13_COUNTRY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_11_COUNTRY$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_13_COUNTRY$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_11_COUNTRY$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_13_COUNTRY$1" :=
            
            "ADDRESS_11_COUNTRY$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_14_COUNTY$1"("INSTRUCTOR_DIM_i") := 
            
            "ADDRESS_10_COUNTY$1"("DEDUP_IN2_i$1");',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_14_COUNTY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ADDRESS_10_COUNTY$1"("DEDUP_IN2_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_14_COUNTY$1"("INSTRUCTOR_DIM_i") :=
            
            "ADDRESS_10_COUNTY$1"("DEDUP_IN2_i$1");
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_14_COUNTY$1" :=
            
            "ADDRESS_10_COUNTY$1"("DEDUP_IN2_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"INSTRUCTOR_DIM_21_GKDW_SOUR"("INSTRUCTOR_DIM_i") := 
            
            "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME";',0,2000);
            error_column := SUBSTRB('"INSTRUCTOR_DIM_21_GKDW_SOUR"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "INSTRUCTOR_DIM_21_GKDW_SOUR"("INSTRUCTOR_DIM_i") :=
            
            "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME";
            
            ELSIF get_row_status THEN
              "SV_INSTRUCTOR_DIM_21_GKDW_SO" :=
            
            "OWB_INSTRUCTOR_DIM"."GET_CONST_1_SOURCE_NAME";
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "INSTRUCTOR_DIM_srk"("INSTRUCTOR_DIM_i") := get_rowkey + "DEDUP_IN2_i$1" - 1;
                  ELSIF get_row_status THEN
                    "SV_INSTRUCTOR_DIM_srk" := get_rowkey + "DEDUP_IN2_i$1" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "INSTRUCTOR_DIM_new" := TRUE;
                ELSE
                  "INSTRUCTOR_DIM_i" := "INSTRUCTOR_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "DEDUP_IN2_ER$1"('TRACE 445: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "DEDUP_IN2_i$1");
                  
                  "INSTRUCTOR_DIM_err" := "INSTRUCTOR_DIM_err" + 1;
                  
                  IF get_errors + "INSTRUCTOR_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("INSTRUCTOR_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "INSTRUCTOR_DIM_new" 
            AND (NOT "INSTRUCTOR_DIM_nul") THEN
              "INSTRUCTOR_DIM_ir"(dml_bsize) := "INSTRUCTOR_DIM_i";
            	"INSTRUCTOR_DIM_0_CUST_ID$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_0_CUST_ID$1";
            	"INSTRUCTOR_DIM_1_CUST_NAME$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_1_CUST_NA";
            	"INSTRUCTOR_DIM_3_ACCT_NAME$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_3_ACCT_NA";
            	"INSTRUCTOR_DIM_5_ACCT_ID$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_5_ACCT_ID$1";
            	"INSTRUCTOR_DIM_6_ADDRESS1$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_6_ADDRESS1$1";
            	"INSTRUCTOR_DIM_7_ADDRESS2$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_7_ADDRESS2$1";
            	"INSTRUCTOR_DIM_8_ADDRESS3$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_8_ADDRESS3$1";
            	"INSTRUCTOR_DIM_9_CITY$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_9_CITY$1";
            	"INSTRUCTOR_DIM_10_STATE$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_10_STATE$1";
            	"INSTRUCTOR_DIM_11_ZIPCODE$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_11_ZIPCODE$1";
            	"INSTRUCTOR_DIM_12_PROVINCE$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_12_PROVIN";
            	"INSTRUCTOR_DIM_13_COUNTRY$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_13_COUNTRY$1";
            	"INSTRUCTOR_DIM_14_COUNTY$1"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_14_COUNTY$1";
            	"INSTRUCTOR_DIM_21_GKDW_SOUR"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_21_GKDW_SO";
              "INSTRUCTOR_DIM_srk"("INSTRUCTOR_DIM_i") := "SV_INSTRUCTOR_DIM_srk";
              "INSTRUCTOR_DIM_i" := "INSTRUCTOR_DIM_i" + 1;
            ELSE
              "INSTRUCTOR_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "DEDUP_IN2_DML$1"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "DEDUP_IN2_DML$1"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "DEDUP_IN2_ER$1"('TRACE 443: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "DEDUP_IN2_i$1");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "DEDUP_IN2_c$1"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "DEDUP_IN2_i$1" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "DEDUP_IN2_i$1" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "DEDUP_IN2_c$1";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "INSTRUCTOR_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"INSTRUCTOR_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"INSTRUCTOR_DIM_ins",
        p_upd=>"INSTRUCTOR_DIM_upd",
        p_del=>"INSTRUCTOR_DIM_del",
        p_err=>"INSTRUCTOR_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "INSTRUCTOR_DIM_ins";
    get_updated  := get_updated  + "INSTRUCTOR_DIM_upd";
    get_deleted  := get_deleted  + "INSTRUCTOR_DIM_del";
    get_errors   := get_errors   + "INSTRUCTOR_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "DEDUP_IN2_t";







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
      p_source=>'"SLXDW"."CONTACT","SLXDW"."ACCOUNT","SLXDW"."ADDRESS","SLXDW"."QG_EVENTINSTRUCTORS"',
      p_source_uoid=>'A41FFB19A73D5678E040007F01006C7D,A41FFB19A7505678E040007F01006C7D,A41FFB19A73F5678E040007F01006C7D',
      p_target=>'"INSTRUCTOR_DIM"',
      p_target_uoid=>'A41FFB19A74F5678E040007F01006C7D',      p_info=>NULL,
      
            p_type=>'PLSQLMap',
      
      p_date=>get_cycle_date
    );
  END IF;



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
  "INSTRUCTOR_DIM_St" := FALSE;

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
      "INSTRUCTOR_DIM_St" := "INSTRUCTOR_DIM_Bat";
      get_batch_status := get_batch_status AND "INSTRUCTOR_DIM_St";
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
		"DEDUP_IN2_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "INSTRUCTOR_DIM_St" := "INSTRUCTOR_DIM_Bat";
        get_batch_status := get_batch_status AND "INSTRUCTOR_DIM_St";
      END IF;
    END IF;
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"INSTRUCTOR_DIM_St" := FALSE;

      END IF;
    END IF;

"DEDUP_IN2_p";

  END IF;
  IF get_operating_mode = MODE_ROW_TARGET THEN
"DEDUP_IN2_t";

  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW_TARGET THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "INSTRUCTOR_DIM_St" := "INSTRUCTOR_DIM_Bat";
        get_batch_status := get_batch_status AND "INSTRUCTOR_DIM_St";
      END IF;
    END IF;
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"INSTRUCTOR_DIM_St" := FALSE;

    END IF;
"DEDUP_IN2_t";

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
  AND    uo.object_name = 'OWB_INSTRUCTOR_DIM'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_INSTRUCTOR_DIM', x_schema, x_audit_id, x_object_id);

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
  IF "DEDUP_IN2_c"%ISOPEN THEN
    CLOSE "DEDUP_IN2_c";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;BEGIN
  IF "DEDUP_IN2_c$1"%ISOPEN THEN
    CLOSE "DEDUP_IN2_c$1";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;

END Close_Cursors;



END "OWB_INSTRUCTOR_DIM";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_INSTRUCTOR_DIM TO DWHREAD;

