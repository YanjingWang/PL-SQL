DROP PACKAGE BODY GKDW.OWB_GK_TERRITORY;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_GK_TERRITORY" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "GK_TERRITORY_SLX_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "GK_TERRITORY_SLX_c" IS
  SELECT
/*+ NO_MERGE */
  "GK_TERRITORY"."TERRITORY_ID" "TERRITORY_ID",
  "GK_TERRITORY"."SALESREP" "SALESREP",
  "GK_TERRITORY"."STATE" "STATE",
  "GK_TERRITORY"."ZIP_START" "ZIP_START",
  "GK_TERRITORY"."ZIP_END" "ZIP_END",
  "GK_TERRITORY"."REGION" "REGION",
  "GK_TERRITORY"."USERID" "USERID",
  "GK_TERRITORY"."REGION_MGR" "REGION_MGR",
  "GK_TERRITORY"."GK_TERRITORYID" "GK_TERRITORYID",
  "GK_TERRITORY"."TERRITORY_TYPE" "TERRITORY_TYPE"
FROM
  "sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION" "GK_TERRITORY"; 

---------------------------------------------------------------------------
--
-- "GK_TERRITORY_SLX_c$1" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "GK_TERRITORY_SLX_c$1" IS
  SELECT
/*+ NO_MERGE */
  "GK_TERRITORY"."TERRITORY_ID" "TERRITORY_ID",
  "GK_TERRITORY"."SALESREP" "SALESREP",
  TRIM( "GK_TERRITORY"."STATE" )/* EXPR.OUTGRP1.STATE_OUT */ "STATE_OUT",
  "GK_TERRITORY"."ZIP_START" "ZIP_START",
  "GK_TERRITORY"."ZIP_END" "ZIP_END",
  "GK_TERRITORY"."REGION" "REGION",
  "GK_TERRITORY"."USERID" "USERID",
  "GK_TERRITORY"."REGION_MGR" "REGION_MGR",
  "GK_TERRITORY"."GK_TERRITORYID" "GK_TERRITORYID",
  "GK_TERRITORY"."TERRITORY_TYPE" "TERRITORY_TYPE"
FROM
  "sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION" "GK_TERRITORY"; 


"GK_TERRITORY_tt_sqlcode"  NUMBER := NULL;
"GK_TERRITORY_tt_sqlerrm"  VARCHAR2(2000) := NULL;

a_table_to_analyze a_table_to_analyze_type;



---------------------------------------------------------------------------
-- Function "GK_TERRITORY_Bat"
--   performs batch extraction
--   Returns TRUE on success
--   Returns FALSE on failure
---------------------------------------------------------------------------
FUNCTION "GK_TERRITORY_Bat"
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
      p_name=>'"GK_TERRITORY_Bat"',
      p_source=>'*',
      p_source_uoid=>'*',
      p_target=>'"GK_TERRITORY"',
      p_target_uoid=>'A41FFB198FC65678E040007F01006C7D',
      p_stm=>NULL,p_info=>NULL,
      
      p_exec_mode=>MODE_SET
    );
    get_audit_detail_id := batch_auditd_id;
  	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198FC65678E040007F01006C7D', -- Operator GK_TERRITORY
    p_parent_object_name=>'GK_TERRITORY',
    p_parent_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
    p_parent_object_type=>'Table',
    p_object_name=>'GK_TERRITORY',
    p_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A59CB5D347CC0953E040007F01007FB6', -- Operator GK_TERRITORY
    p_parent_object_name=>'GK_TERRITORY',
    p_parent_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
    p_parent_object_type=>'Table',
    p_object_name=>'GK_TERRITORY',
    p_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB198FBE5678E040007F01006C7D', -- Operator GK_TERRITORY_SLX
    p_parent_object_name=>'GK_TERRITORY',
    p_parent_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
    p_parent_object_type=>'Table',
    p_object_name=>'GK_TERRITORY',
    p_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
    p_object_type=>'Table',
    p_location_uoid=>'A40B7C6CC08AA5E9E040007F01003A50' -- Location SLX_PROD_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A59CB5D347990953E040007F01007FB6', -- Operator GK_TERRITORY_SLX
    p_parent_object_name=>'GK_TERRITORY',
    p_parent_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
    p_parent_object_type=>'Table',
    p_object_name=>'GK_TERRITORY',
    p_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
    p_object_type=>'Table',
    p_location_uoid=>'A40B7C6CC08AA5E9E040007F01003A50' -- SLX_PROD_LOCATION
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
  
    IF NOT "GK_TERRITORY_St" THEN
      IF get_use_hc THEN
        IF "GK_TERRITORY_tt_sqlcode" IS NOT NULL THEN
          RAISE_APPLICATION_ERROR(-20016, "GK_TERRITORY_tt_sqlerrm");
        END IF;
      ELSE
        -- Truncate the target table
        EXECUTE IMMEDIATE 'TRUNCATE TABLE "GK_TERRITORY"';
      END IF;
    END IF;
    
  
    IF NOT get_use_hc AND NOT get_no_commit THEN
      COMMIT; -- commit no.4
    END IF;
  
    IF NOT "GK_TERRITORY_St" THEN
    
      batch_action := 'BATCH INSERT';
      batch_selected := SQL%ROWCOUNT;
      
      INSERT
      /*+ APPEND PARALLEL("GK_TERRITORY") */
      INTO
        "GK_TERRITORY"
        ("TERRITORY_ID",
        "SALESREP",
        "STATE",
        "ZIP_START",
        "ZIP_END",
        "REGION",
        "USERID",
        "REGION_MGR",
        "GK_TERRITORY_ID",
        "TERRITORY_TYPE")
        (SELECT
/*+ NO_MERGE */
  "GK_TERRITORY"."TERRITORY_ID" "TERRITORY_ID",
  "GK_TERRITORY"."SALESREP" "SALESREP",
  TRIM( "GK_TERRITORY"."STATE" )/* EXPR.OUTGRP1.STATE_OUT */ "STATE_OUT",
  "GK_TERRITORY"."ZIP_START" "ZIP_START",
  "GK_TERRITORY"."ZIP_END" "ZIP_END",
  "GK_TERRITORY"."REGION" "REGION",
  "GK_TERRITORY"."USERID" "USERID",
  "GK_TERRITORY"."REGION_MGR" "REGION_MGR",
  "GK_TERRITORY"."GK_TERRITORYID" "GK_TERRITORYID",
  "GK_TERRITORY"."TERRITORY_TYPE" "TERRITORY_TYPE"
FROM
  "sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION" "GK_TERRITORY"
        );
      batch_inserted := SQL%ROWCOUNT;
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
        p_table=>'"GK_TERRITORY"',
        p_column=>'*',
        p_dstval=>NULL,
        p_stm=>'TRACE 15: ' || batch_action,
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
END "GK_TERRITORY_Bat";



-- Procedure "GK_TERRITORY_SLX_p" is the entry point for map "GK_TERRITORY_SLX_p"

PROCEDURE "GK_TERRITORY_SLX_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"GK_TERRITORY_SLX_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB198FBE5678E040007F01006C7D';
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

"GK_TERRITORY_id" NUMBER(22) := 0;
"GK_TERRITORY_ins" NUMBER(22) := 0;
"GK_TERRITORY_upd" NUMBER(22) := 0;
"GK_TERRITORY_del" NUMBER(22) := 0;
"GK_TERRITORY_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"GK_TERRITORY_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"GK_TERRITORY_ir"  index_redirect_array;
"SV_GK_TERRITORY_srk" NUMBER;
"GK_TERRITORY_new"  BOOLEAN;
"GK_TERRITORY_nul"  BOOLEAN := FALSE;

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

"GK_TERRITORY_SLX_si" NUMBER(22) := 0;

"GK_TERRITORY_SLX_i" NUMBER(22) := 0;


"GK_TERRITORY_si" NUMBER(22) := 0;

"GK_TERRITORY_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_GK_TERRI_13_TERRITOR" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_GK_TERRITORY_SLX" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_10_SALESREP" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_11_STATE" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_STATE_OUT" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_19_ZIP_STA" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_18_ZIP_END" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_8_REGION" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_17_USERID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_9_REGION_M" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRI_2_GK_TERRI" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRI_14_TERRITOR" IS TABLE OF VARCHAR2(5) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_0_TERRITORY_ID" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_1_SALESREP" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_2_STATE" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_3_ZIP_START" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_4_ZIP_END" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_5_REGION" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_6_USERID" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_7_REGION_MGR" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRI_8_GK_TERRI" IS TABLE OF VARCHAR2(12) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_9_TERRITORY_TY" IS TABLE OF VARCHAR2(5) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_GK_TERRI_13_TERRITOR"  VARCHAR2(10);
"SV_ROWKEY_GK_TERRITORY_SLX"  VARCHAR2(18);
"SV_GK_TERRITORY_SLX_10_SALESR"  VARCHAR2(75);
"SV_GK_TERRITORY_SLX_11_STATE"  VARCHAR2(15);
"SV_EXPR_1_STATE_OUT"  VARCHAR2(15);
"SV_GK_TERRITORY_SLX_19_ZIP_STA"  VARCHAR2(10);
"SV_GK_TERRITORY_SLX_18_ZIP_END"  VARCHAR2(10);
"SV_GK_TERRITORY_SLX_8_REGION"  VARCHAR2(50);
"SV_GK_TERRITORY_SLX_17_USERID"  CHAR(12);
"SV_GK_TERRITORY_SLX_9_REGION_M"  VARCHAR2(75);
"SV_GK_TERRI_2_GK_TERRI"  CHAR(12);
"SV_GK_TERRI_14_TERRITOR"  VARCHAR2(5);
"SV_GK_TERRITORY_0_TERRITORY_ID"  VARCHAR2(10);
"SV_GK_TERRITORY_1_SALESREP"  VARCHAR2(75);
"SV_GK_TERRITORY_2_STATE"  VARCHAR2(15);
"SV_GK_TERRITORY_3_ZIP_START"  VARCHAR2(10);
"SV_GK_TERRITORY_4_ZIP_END"  VARCHAR2(10);
"SV_GK_TERRITORY_5_REGION"  VARCHAR2(50);
"SV_GK_TERRITORY_6_USERID"  VARCHAR2(15);
"SV_GK_TERRITORY_7_REGION_MGR"  VARCHAR2(75);
"SV_GK_TERRI_8_GK_TERRI"  VARCHAR2(12);
"SV_GK_TERRITORY_9_TERRITORY_TY"  VARCHAR2(5);

-- Bulk: intermediate collection variables
"GK_TERRI_13_TERRITOR" "T_GK_TERRI_13_TERRITOR";
"ROWKEY_GK_TERRITORY_SLX" "T_ROWKEY_GK_TERRITORY_SLX";
"GK_TERRITORY_SLX_10_SALESREP" "T_GK_TERRITORY_SLX_10_SALESREP";
"GK_TERRITORY_SLX_11_STATE" "T_GK_TERRITORY_SLX_11_STATE";
"EXPR_1_STATE_OUT" "T_EXPR_1_STATE_OUT";
"GK_TERRITORY_SLX_19_ZIP_START" "T_GK_TERRITORY_SLX_19_ZIP_STA";
"GK_TERRITORY_SLX_18_ZIP_END" "T_GK_TERRITORY_SLX_18_ZIP_END";
"GK_TERRITORY_SLX_8_REGION" "T_GK_TERRITORY_SLX_8_REGION";
"GK_TERRITORY_SLX_17_USERID" "T_GK_TERRITORY_SLX_17_USERID";
"GK_TERRITORY_SLX_9_REGION_MGR" "T_GK_TERRITORY_SLX_9_REGION_M";
"GK_TERRI_2_GK_TERRI" "T_GK_TERRI_2_GK_TERRI";
"GK_TERRI_14_TERRITOR" "T_GK_TERRI_14_TERRITOR";
"GK_TERRITORY_0_TERRITORY_ID" "T_GK_TERRITORY_0_TERRITORY_ID";
"GK_TERRITORY_1_SALESREP" "T_GK_TERRITORY_1_SALESREP";
"GK_TERRITORY_2_STATE" "T_GK_TERRITORY_2_STATE";
"GK_TERRITORY_3_ZIP_START" "T_GK_TERRITORY_3_ZIP_START";
"GK_TERRITORY_4_ZIP_END" "T_GK_TERRITORY_4_ZIP_END";
"GK_TERRITORY_5_REGION" "T_GK_TERRITORY_5_REGION";
"GK_TERRITORY_6_USERID" "T_GK_TERRITORY_6_USERID";
"GK_TERRITORY_7_REGION_MGR" "T_GK_TERRITORY_7_REGION_MGR";
"GK_TERRI_8_GK_TERRI" "T_GK_TERRI_8_GK_TERRI";
"GK_TERRITORY_9_TERRITORY_TYPE" "T_GK_TERRITORY_9_TERRITORY_TY";

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
PROCEDURE "GK_TERRITORY_SLX_ES"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRI_13_TERRITOR',0,80),
    p_value=>SUBSTRB("GK_TERRI_13_TERRITOR"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_10_SALESREP',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_10_SALESREP"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_11_STATE',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_11_STATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_19_ZIP_START',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_19_ZIP_START"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_18_ZIP_END',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_18_ZIP_END"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_8_REGION',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_8_REGION"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_17_USERID',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_17_USERID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_9_REGION_MGR',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_9_REGION_MGR"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRI_2_GK_TERRI',0,80),
    p_value=>SUBSTRB("GK_TERRI_2_GK_TERRI"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRI_14_TERRITOR',0,80),
    p_value=>SUBSTRB("GK_TERRI_14_TERRITOR"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "GK_TERRITORY_SLX_ES";

---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_ER" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_ER"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 16: ' || p_statement,
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
    "GK_TERRITORY_SLX_ES"(p_error_index);
  END IF;
END "GK_TERRITORY_SLX_ER";



---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_SU" opens and initializes data source
-- for map "GK_TERRITORY_SLX_p"
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_SU" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "GK_TERRITORY_SLX_c"%ISOPEN) THEN
    OPEN "GK_TERRITORY_SLX_c";
  END IF;
  get_read_success := TRUE;
END "GK_TERRITORY_SLX_SU";

---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_RD" fetches a bulk of rows from
--   the data source for map "GK_TERRITORY_SLX_p"
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_RD" IS
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
    "GK_TERRI_13_TERRITOR".DELETE;
    "GK_TERRITORY_SLX_10_SALESREP".DELETE;
    "GK_TERRITORY_SLX_11_STATE".DELETE;
    "GK_TERRITORY_SLX_19_ZIP_START".DELETE;
    "GK_TERRITORY_SLX_18_ZIP_END".DELETE;
    "GK_TERRITORY_SLX_8_REGION".DELETE;
    "GK_TERRITORY_SLX_17_USERID".DELETE;
    "GK_TERRITORY_SLX_9_REGION_MGR".DELETE;
    "GK_TERRI_2_GK_TERRI".DELETE;
    "GK_TERRI_14_TERRITOR".DELETE;

    FETCH
      "GK_TERRITORY_SLX_c"
    BULK COLLECT INTO
      "GK_TERRI_13_TERRITOR",
      "GK_TERRITORY_SLX_10_SALESREP",
      "GK_TERRITORY_SLX_11_STATE",
      "GK_TERRITORY_SLX_19_ZIP_START",
      "GK_TERRITORY_SLX_18_ZIP_END",
      "GK_TERRITORY_SLX_8_REGION",
      "GK_TERRITORY_SLX_17_USERID",
      "GK_TERRITORY_SLX_9_REGION_MGR",
      "GK_TERRI_2_GK_TERRI",
      "GK_TERRI_14_TERRITOR"
    LIMIT get_bulk_size;

    IF "GK_TERRITORY_SLX_c"%NOTFOUND AND "GK_TERRI_13_TERRITOR".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "GK_TERRI_13_TERRITOR".COUNT;
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
    get_map_selected := get_map_selected + "GK_TERRI_13_TERRITOR".COUNT;
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
          p_stm=>'TRACE 17: SELECT',
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
END "GK_TERRITORY_SLX_RD";

---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_DML" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_DML"(si NUMBER, firstround BOOLEAN) IS
  "GK_TERRITORY_ins0" NUMBER := "GK_TERRITORY_ins";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "GK_TERRITORY_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "GK_TERRITORY_nul")) THEN
    -- Insert DML for "GK_TERRITORY"
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    get_target_name := '"GK_TERRITORY"';
    get_audit_detail_id := "GK_TERRITORY_id";
    IF get_use_hc AND NOT firstround THEN
      "GK_TERRITORY_si" := "GK_TERRITORY_ir"(si);
      IF "GK_TERRITORY_si" = 0 THEN
        "GK_TERRITORY_i" := 0;
      ELSE
        "GK_TERRITORY_i" := "GK_TERRITORY_si" + 1;
      END IF;
    ELSE
      "GK_TERRITORY_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "GK_TERRITORY_i" <= get_bulk_size 
   AND "GK_TERRITORY_SLX_c"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "GK_TERRITORY_si" >= "GK_TERRITORY_i";
      END IF;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "GK_TERRITORY_si".."GK_TERRITORY_i" - 1
          INSERT 
          /*+ APPEND PARALLEL("GK_TERRITORY") */
          INTO
            "GK_TERRITORY"
            ("GK_TERRITORY"."TERRITORY_ID",
            "GK_TERRITORY"."SALESREP",
            "GK_TERRITORY"."STATE",
            "GK_TERRITORY"."ZIP_START",
            "GK_TERRITORY"."ZIP_END",
            "GK_TERRITORY"."REGION",
            "GK_TERRITORY"."USERID",
            "GK_TERRITORY"."REGION_MGR",
            "GK_TERRITORY"."GK_TERRITORY_ID",
            "GK_TERRITORY"."TERRITORY_TYPE"
            )
          VALUES
            ("GK_TERRITORY_0_TERRITORY_ID"(i),
            "GK_TERRITORY_1_SALESREP"(i),
            "GK_TERRITORY_2_STATE"(i),
            "GK_TERRITORY_3_ZIP_START"(i),
            "GK_TERRITORY_4_ZIP_END"(i),
            "GK_TERRITORY_5_REGION"(i),
            "GK_TERRITORY_6_USERID"(i),
            "GK_TERRITORY_7_REGION_MGR"(i),
            "GK_TERRI_8_GK_TERRI"(i),
            "GK_TERRITORY_9_TERRITORY_TYPE"(i)
            )
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "GK_TERRITORY_si" + get_rowid.COUNT;
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
          error_index := "GK_TERRITORY_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "GK_TERRITORY_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 18: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."TERRITORY_ID"',0,80),SUBSTRB("GK_TERRITORY_0_TERRITORY_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."SALESREP"',0,80),SUBSTRB("GK_TERRITORY_1_SALESREP"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."STATE"',0,80),SUBSTRB("GK_TERRITORY_2_STATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."ZIP_START"',0,80),SUBSTRB("GK_TERRITORY_3_ZIP_START"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."ZIP_END"',0,80),SUBSTRB("GK_TERRITORY_4_ZIP_END"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."REGION"',0,80),SUBSTRB("GK_TERRITORY_5_REGION"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."USERID"',0,80),SUBSTRB("GK_TERRITORY_6_USERID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."REGION_MGR"',0,80),SUBSTRB("GK_TERRITORY_7_REGION_MGR"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."GK_TERRITORY_ID"',0,80),SUBSTRB("GK_TERRI_8_GK_TERRI"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."TERRITORY_TYPE"',0,80),SUBSTRB("GK_TERRITORY_9_TERRITORY_TYPE"(error_index),0,2000));
            
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
          "GK_TERRITORY_err" := "GK_TERRITORY_err" + 1;
          
          IF get_errors + "GK_TERRITORY_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "GK_TERRITORY_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "GK_TERRITORY_srk"(rowkey_index);
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
  
      "GK_TERRITORY_ins" := "GK_TERRITORY_ins" + get_rowid.COUNT;
      "GK_TERRITORY_si" := error_index + 1;
  
      IF "GK_TERRITORY_si" >= "GK_TERRITORY_i" OR get_abort THEN
        "GK_TERRITORY_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "GK_TERRITORY_i" := 1; 
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "GK_TERRITORY_ins" := "GK_TERRITORY_ins0";
  END IF;

END "GK_TERRITORY_SLX_DML";

---------------------------------------------------------------------------
-- "GK_TERRITORY_SLX_p" main
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

  IF NOT "GK_TERRITORY_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "GK_TERRITORY_SLX_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "GK_TERRITORY_St" THEN
          "GK_TERRITORY_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"GK_TERRITORY"',
              p_target_uoid=>'A41FFB198FC65678E040007F01006C7D',
              p_stm=>'TRACE 20',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "GK_TERRITORY_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198FC65678E040007F01006C7D', -- Operator GK_TERRITORY
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A59CB5D347CC0953E040007F01007FB6', -- Operator GK_TERRITORY
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198FBE5678E040007F01006C7D', -- Operator GK_TERRITORY_SLX
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A40B7C6CC08AA5E9E040007F01003A50' -- Location SLX_PROD_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A59CB5D347990953E040007F01007FB6', -- Operator GK_TERRITORY_SLX
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A40B7C6CC08AA5E9E040007F01003A50' -- SLX_PROD_LOCATION
            );
        END IF;
        IF NOT get_no_commit THEN
          COMMIT; -- commit no.10
        END IF;
      END IF;

      IF NOT "GK_TERRITORY_St" THEN
  BEGIN
    -- Truncate the target table, if the cursor has not been opened yet.
    -- If the cursor is open, then this is not the first call of this procedure for 
    -- the run, so the target has already been truncated.
    IF NOT "GK_TERRITORY_SLX_c"%ISOPEN THEN
      IF get_use_hc THEN
        IF "GK_TERRITORY_tt_sqlcode" IS NOT NULL THEN
          RAISE_APPLICATION_ERROR(-20016, "GK_TERRITORY_tt_sqlerrm");
        END IF;
      ELSE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE "GK_TERRITORY"';
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
        last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              WB_RT_MAPAUDIT.error(
                p_rta=>get_runtime_audit_id,
                p_step=>1,
                p_rtd=>"GK_TERRITORY_id",
                p_rowkey=>0,
                p_table=>'"GK_TERRITORY"',
                p_column=>'*',
                p_dstval=>NULL,
                p_stm=>'TRACE 21: TRUNCATE',
                p_sqlerr=>SQLCODE,
                p_sqlerrm=>SQLERRM,
                p_rowid=>NULL
              );
            END IF;
      get_abort := TRUE;
  END;
END IF;
      

      -- Initialize buffer variables
      get_buffer_done.DELETE;
      get_buffer_done_index := 1;

    END IF; -- End if cursor not open

    -- Initialize internal loop index variables
    "GK_TERRITORY_SLX_si" := 0;
    "GK_TERRITORY_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "GK_TERRITORY_SLX_SU";

      LOOP
        IF "GK_TERRITORY_SLX_si" = 0 THEN
          "GK_TERRITORY_SLX_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "GK_TERRI_13_TERRITOR".COUNT - 1;
          ELSE
            bulk_count := "GK_TERRI_13_TERRITOR".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "GK_TERRITORY_ir".DELETE;
"GK_TERRITORY_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "GK_TERRITORY_SLX_i" := "GK_TERRITORY_SLX_si";
        BEGIN
          
          LOOP
            EXIT WHEN "GK_TERRITORY_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "GK_TERRITORY_SLX_i" := "GK_TERRITORY_SLX_i" + 1;
            "GK_TERRITORY_SLX_si" := "GK_TERRITORY_SLX_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "GK_TERRITORY_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("GK_TERRITORY_SLX_c"%NOTFOUND AND
               "GK_TERRITORY_SLX_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "GK_TERRITORY_SLX_i" > bulk_count THEN
            
              "GK_TERRITORY_SLX_si" := 0;
              EXIT;
            END IF;


            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_STATE_OUT"
            ("GK_TERRITORY_SLX_i") := 
            TRIM( "GK_TERRITORY_SLX_11_STATE"
            ("GK_TERRITORY_SLX_i") )/* EXPR.OUTGRP1.STATE_OUT */;
            
            ',0,2000);
            
            
            "EXPR_1_STATE_OUT"
            ("GK_TERRITORY_SLX_i") := 
            TRIM( "GK_TERRITORY_SLX_11_STATE"
            ("GK_TERRITORY_SLX_i") )/* EXPR.OUTGRP1.STATE_OUT */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            
get_target_name := '"GK_TERRITORY"';
            get_audit_detail_id := "GK_TERRITORY_id";
            IF NOT "GK_TERRITORY_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"GK_TERRITORY_0_TERRITORY_ID"("GK_TERRITORY_i") := 
            
            "GK_TERRI_13_TERRITOR"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_0_TERRITORY_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRI_13_TERRITOR"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_0_TERRITORY_ID"("GK_TERRITORY_i") :=
            
            "GK_TERRI_13_TERRITOR"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_0_TERRITORY_ID" :=
            
            "GK_TERRI_13_TERRITOR"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_1_SALESREP"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_10_SALESREP"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_1_SALESREP"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_10_SALESREP"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_1_SALESREP"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_10_SALESREP"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_1_SALESREP" :=
            
            "GK_TERRITORY_SLX_10_SALESREP"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_2_STATE"("GK_TERRITORY_i") := 
            
            "EXPR_1_STATE_OUT"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_2_STATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_STATE_OUT"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_2_STATE"("GK_TERRITORY_i") :=
            
            "EXPR_1_STATE_OUT"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_2_STATE" :=
            
            "EXPR_1_STATE_OUT"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_3_ZIP_START"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_19_ZIP_START"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_3_ZIP_START"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_19_ZIP_START"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_3_ZIP_START"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_19_ZIP_START"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_3_ZIP_START" :=
            
            "GK_TERRITORY_SLX_19_ZIP_START"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_4_ZIP_END"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_18_ZIP_END"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_4_ZIP_END"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_18_ZIP_END"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_4_ZIP_END"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_18_ZIP_END"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_4_ZIP_END" :=
            
            "GK_TERRITORY_SLX_18_ZIP_END"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_5_REGION"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_8_REGION"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_5_REGION"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_8_REGION"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_5_REGION"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_8_REGION"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_5_REGION" :=
            
            "GK_TERRITORY_SLX_8_REGION"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_6_USERID"("GK_TERRITORY_i") := 
            
            RTRIM("GK_TERRITORY_SLX_17_USERID"("GK_TERRITORY_SLX_i"));',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_6_USERID"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("GK_TERRITORY_SLX_17_USERID"("GK_TERRITORY_SLX_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_6_USERID"("GK_TERRITORY_i") :=
            
            RTRIM("GK_TERRITORY_SLX_17_USERID"("GK_TERRITORY_SLX_i"));
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_6_USERID" :=
            
            RTRIM("GK_TERRITORY_SLX_17_USERID"("GK_TERRITORY_SLX_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_7_REGION_MGR"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_9_REGION_MGR"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_7_REGION_MGR"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_9_REGION_MGR"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_7_REGION_MGR"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_9_REGION_MGR"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_7_REGION_MGR" :=
            
            "GK_TERRITORY_SLX_9_REGION_MGR"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRI_8_GK_TERRI"("GK_TERRITORY_i") := 
            
            RTRIM("GK_TERRI_2_GK_TERRI"("GK_TERRITORY_SLX_i"));',0,2000);
            error_column := SUBSTRB('"GK_TERRI_8_GK_TERRI"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("GK_TERRI_2_GK_TERRI"("GK_TERRITORY_SLX_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRI_8_GK_TERRI"("GK_TERRITORY_i") :=
            
            RTRIM("GK_TERRI_2_GK_TERRI"("GK_TERRITORY_SLX_i"));
            
            ELSIF get_row_status THEN
              "SV_GK_TERRI_8_GK_TERRI" :=
            
            RTRIM("GK_TERRI_2_GK_TERRI"("GK_TERRITORY_SLX_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_9_TERRITORY_TYPE"("GK_TERRITORY_i") := 
            
            "GK_TERRI_14_TERRITOR"("GK_TERRITORY_SLX_i");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_9_TERRITORY_TYPE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRI_14_TERRITOR"("GK_TERRITORY_SLX_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_9_TERRITORY_TYPE"("GK_TERRITORY_i") :=
            
            "GK_TERRI_14_TERRITOR"("GK_TERRITORY_SLX_i");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_9_TERRITORY_TY" :=
            
            "GK_TERRI_14_TERRITOR"("GK_TERRITORY_SLX_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "GK_TERRITORY_srk"("GK_TERRITORY_i") := get_rowkey + "GK_TERRITORY_SLX_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_GK_TERRITORY_srk" := get_rowkey + "GK_TERRITORY_SLX_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "GK_TERRITORY_new" := TRUE;
                ELSE
                  "GK_TERRITORY_i" := "GK_TERRITORY_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "GK_TERRITORY_SLX_ER"('TRACE 22: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "GK_TERRITORY_SLX_i");
                  
                  "GK_TERRITORY_err" := "GK_TERRITORY_err" + 1;
                  
                  IF get_errors + "GK_TERRITORY_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("GK_TERRITORY_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "GK_TERRITORY_new" 
            AND (NOT "GK_TERRITORY_nul") THEN
              "GK_TERRITORY_ir"(dml_bsize) := "GK_TERRITORY_i";
            	"GK_TERRITORY_0_TERRITORY_ID"("GK_TERRITORY_i") := "SV_GK_TERRITORY_0_TERRITORY_ID";
            	"GK_TERRITORY_1_SALESREP"("GK_TERRITORY_i") := "SV_GK_TERRITORY_1_SALESREP";
            	"GK_TERRITORY_2_STATE"("GK_TERRITORY_i") := "SV_GK_TERRITORY_2_STATE";
            	"GK_TERRITORY_3_ZIP_START"("GK_TERRITORY_i") := "SV_GK_TERRITORY_3_ZIP_START";
            	"GK_TERRITORY_4_ZIP_END"("GK_TERRITORY_i") := "SV_GK_TERRITORY_4_ZIP_END";
            	"GK_TERRITORY_5_REGION"("GK_TERRITORY_i") := "SV_GK_TERRITORY_5_REGION";
            	"GK_TERRITORY_6_USERID"("GK_TERRITORY_i") := "SV_GK_TERRITORY_6_USERID";
            	"GK_TERRITORY_7_REGION_MGR"("GK_TERRITORY_i") := "SV_GK_TERRITORY_7_REGION_MGR";
            	"GK_TERRI_8_GK_TERRI"("GK_TERRITORY_i") := "SV_GK_TERRI_8_GK_TERRI";
            	"GK_TERRITORY_9_TERRITORY_TYPE"("GK_TERRITORY_i") := "SV_GK_TERRITORY_9_TERRITORY_TY";
              "GK_TERRITORY_srk"("GK_TERRITORY_i") := "SV_GK_TERRITORY_srk";
              "GK_TERRITORY_i" := "GK_TERRITORY_i" + 1;
            ELSE
              "GK_TERRITORY_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "GK_TERRITORY_SLX_DML"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "GK_TERRITORY_SLX_DML"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "GK_TERRITORY_SLX_ER"('TRACE 19: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "GK_TERRITORY_SLX_i");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "GK_TERRITORY_SLX_c"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "GK_TERRITORY_SLX_i" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "GK_TERRITORY_SLX_i" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "GK_TERRITORY_SLX_c";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "GK_TERRITORY_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"GK_TERRITORY_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"GK_TERRITORY_ins",
        p_upd=>"GK_TERRITORY_upd",
        p_del=>"GK_TERRITORY_del",
        p_err=>"GK_TERRITORY_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "GK_TERRITORY_ins";
    get_updated  := get_updated  + "GK_TERRITORY_upd";
    get_deleted  := get_deleted  + "GK_TERRITORY_del";
    get_errors   := get_errors   + "GK_TERRITORY_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "GK_TERRITORY_SLX_p";



-- Procedure "GK_TERRITORY_SLX_t" is the entry point for map "GK_TERRITORY_SLX_t"

PROCEDURE "GK_TERRITORY_SLX_t"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"GK_TERRITORY_SLX_t"';
get_source_name            CONSTANT VARCHAR2(2000) := '"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB198FBE5678E040007F01006C7D';
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

"GK_TERRITORY_id" NUMBER(22) := 0;
"GK_TERRITORY_ins" NUMBER(22) := 0;
"GK_TERRITORY_upd" NUMBER(22) := 0;
"GK_TERRITORY_del" NUMBER(22) := 0;
"GK_TERRITORY_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"GK_TERRITORY_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"GK_TERRITORY_ir"  index_redirect_array;
"SV_GK_TERRITORY_srk" NUMBER;
"GK_TERRITORY_new"  BOOLEAN;
"GK_TERRITORY_nul"  BOOLEAN := FALSE;

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

"GK_TERRITORY_SLX_si$1" NUMBER(22) := 0;

"GK_TERRITORY_SLX_i$1" NUMBER(22) := 0;


"GK_TERRITORY_si" NUMBER(22) := 0;

"GK_TERRITORY_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_GK_TERRI_13_TERRITOR$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_GK_TERRITORY_SLX$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_10_SALESR" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_STATE_OUT$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_19_ZIP_S" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_18_ZIP_E" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_8_REGION$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_17_USERID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_SLX_9_REGION" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRI_2_GK_TERRI$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRI_14_TERRITOR$1" IS TABLE OF VARCHAR2(5) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_0_TERRITORY_" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_1_SALESREP$1" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_2_STATE$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_3_ZIP_START$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_4_ZIP_END$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_5_REGION$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_6_USERID$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_7_REGION_MGR$1" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRI_8_GK_TERRI$1" IS TABLE OF VARCHAR2(12) INDEX BY BINARY_INTEGER;
TYPE "T_GK_TERRITORY_9_TERRITORY_" IS TABLE OF VARCHAR2(5) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_GK_TERRI_13_TERRITOR$1"  VARCHAR2(10);
"SV_ROWKEY_GK_TERRITORY_SLX$1"  VARCHAR2(18);
"SV_GK_TERRITORY_SLX_10_SALE"  VARCHAR2(75);
"SV_EXPR_1_STATE_OUT$1"  VARCHAR2(15);
"SV_GK_TERRITORY_SLX_19_ZIP_S"  VARCHAR2(10);
"SV_GK_TERRITORY_SLX_18_ZIP_E"  VARCHAR2(10);
"SV_GK_TERRITORY_SLX_8_REGION$1"  VARCHAR2(50);
"SV_GK_TERRITORY_SLX_17_USER"  CHAR(12);
"SV_GK_TERRITORY_SLX_9_REGION"  VARCHAR2(75);
"SV_GK_TERRI_2_GK_TERRI$1"  CHAR(12);
"SV_GK_TERRI_14_TERRITOR$1"  VARCHAR2(5);
"SV_GK_TERRITORY_0_TERRITORY_"  VARCHAR2(10);
"SV_GK_TERRITORY_1_SALESREP$1"  VARCHAR2(75);
"SV_GK_TERRITORY_2_STATE$1"  VARCHAR2(15);
"SV_GK_TERRITORY_3_ZIP_START$1"  VARCHAR2(10);
"SV_GK_TERRITORY_4_ZIP_END$1"  VARCHAR2(10);
"SV_GK_TERRITORY_5_REGION$1"  VARCHAR2(50);
"SV_GK_TERRITORY_6_USERID$1"  VARCHAR2(15);
"SV_GK_TERRITORY_7_REGION_MGR$1"  VARCHAR2(75);
"SV_GK_TERRI_8_GK_TERRI$1"  VARCHAR2(12);
"SV_GK_TERRITORY_9_TERRITORY_"  VARCHAR2(5);

-- Bulk: intermediate collection variables
"GK_TERRI_13_TERRITOR$1" "T_GK_TERRI_13_TERRITOR$1";
"ROWKEY_GK_TERRITORY_SLX$1" "T_ROWKEY_GK_TERRITORY_SLX$1";
"GK_TERRITORY_SLX_10_SALESREP$1" "T_GK_TERRITORY_SLX_10_SALESR";
"EXPR_1_STATE_OUT$1" "T_EXPR_1_STATE_OUT$1";
"GK_TERRITORY_SLX_19_ZIP_STA" "T_GK_TERRITORY_SLX_19_ZIP_S";
"GK_TERRITORY_SLX_18_ZIP_END$1" "T_GK_TERRITORY_SLX_18_ZIP_E";
"GK_TERRITORY_SLX_8_REGION$1" "T_GK_TERRITORY_SLX_8_REGION$1";
"GK_TERRITORY_SLX_17_USERID$1" "T_GK_TERRITORY_SLX_17_USERID$1";
"GK_TERRITORY_SLX_9_REGION_M" "T_GK_TERRITORY_SLX_9_REGION";
"GK_TERRI_2_GK_TERRI$1" "T_GK_TERRI_2_GK_TERRI$1";
"GK_TERRI_14_TERRITOR$1" "T_GK_TERRI_14_TERRITOR$1";
"GK_TERRITORY_0_TERRITORY_ID$1" "T_GK_TERRITORY_0_TERRITORY_";
"GK_TERRITORY_1_SALESREP$1" "T_GK_TERRITORY_1_SALESREP$1";
"GK_TERRITORY_2_STATE$1" "T_GK_TERRITORY_2_STATE$1";
"GK_TERRITORY_3_ZIP_START$1" "T_GK_TERRITORY_3_ZIP_START$1";
"GK_TERRITORY_4_ZIP_END$1" "T_GK_TERRITORY_4_ZIP_END$1";
"GK_TERRITORY_5_REGION$1" "T_GK_TERRITORY_5_REGION$1";
"GK_TERRITORY_6_USERID$1" "T_GK_TERRITORY_6_USERID$1";
"GK_TERRITORY_7_REGION_MGR$1" "T_GK_TERRITORY_7_REGION_MGR$1";
"GK_TERRI_8_GK_TERRI$1" "T_GK_TERRI_8_GK_TERRI$1";
"GK_TERRITORY_9_TERRITORY_TY" "T_GK_TERRITORY_9_TERRITORY_";

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
PROCEDURE "GK_TERRITORY_SLX_ES$1"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRI_13_TERRITOR',0,80),
    p_value=>SUBSTRB("GK_TERRI_13_TERRITOR$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_10_SALESREP',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_10_SALESREP$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('EXPR_1_STATE_OUT',0,80),
    p_value=>SUBSTRB("EXPR_1_STATE_OUT$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_19_ZIP_START',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_19_ZIP_STA"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_18_ZIP_END',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_18_ZIP_END$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_8_REGION',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_8_REGION$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_17_USERID',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_17_USERID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRITORY_SLX_9_REGION_MGR',0,80),
    p_value=>SUBSTRB("GK_TERRITORY_SLX_9_REGION_M"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRI_2_GK_TERRI',0,80),
    p_value=>SUBSTRB("GK_TERRI_2_GK_TERRI$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',0,80),
    p_column=>SUBSTR('GK_TERRI_14_TERRITOR',0,80),
    p_value=>SUBSTRB("GK_TERRI_14_TERRITOR$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "GK_TERRITORY_SLX_ES$1";

---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_ER$1" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_ER$1"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 23: ' || p_statement,
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
    "GK_TERRITORY_SLX_ES$1"(p_error_index);
  END IF;
END "GK_TERRITORY_SLX_ER$1";



---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_SU$1" opens and initializes data source
-- for map "GK_TERRITORY_SLX_t"
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_SU$1" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "GK_TERRITORY_SLX_c$1"%ISOPEN) THEN
    OPEN "GK_TERRITORY_SLX_c$1";
  END IF;
  get_read_success := TRUE;
END "GK_TERRITORY_SLX_SU$1";

---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_RD$1" fetches a bulk of rows from
--   the data source for map "GK_TERRITORY_SLX_t"
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_RD$1" IS
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
    "GK_TERRI_13_TERRITOR$1".DELETE;
    "GK_TERRITORY_SLX_10_SALESREP$1".DELETE;
    "EXPR_1_STATE_OUT$1".DELETE;
    "GK_TERRITORY_SLX_19_ZIP_STA".DELETE;
    "GK_TERRITORY_SLX_18_ZIP_END$1".DELETE;
    "GK_TERRITORY_SLX_8_REGION$1".DELETE;
    "GK_TERRITORY_SLX_17_USERID$1".DELETE;
    "GK_TERRITORY_SLX_9_REGION_M".DELETE;
    "GK_TERRI_2_GK_TERRI$1".DELETE;
    "GK_TERRI_14_TERRITOR$1".DELETE;

    FETCH
      "GK_TERRITORY_SLX_c$1"
    BULK COLLECT INTO
      "GK_TERRI_13_TERRITOR$1",
      "GK_TERRITORY_SLX_10_SALESREP$1",
      "EXPR_1_STATE_OUT$1",
      "GK_TERRITORY_SLX_19_ZIP_STA",
      "GK_TERRITORY_SLX_18_ZIP_END$1",
      "GK_TERRITORY_SLX_8_REGION$1",
      "GK_TERRITORY_SLX_17_USERID$1",
      "GK_TERRITORY_SLX_9_REGION_M",
      "GK_TERRI_2_GK_TERRI$1",
      "GK_TERRI_14_TERRITOR$1"
    LIMIT get_bulk_size;

    IF "GK_TERRITORY_SLX_c$1"%NOTFOUND AND "GK_TERRI_13_TERRITOR$1".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "GK_TERRI_13_TERRITOR$1".COUNT;
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
    get_map_selected := get_map_selected + "GK_TERRI_13_TERRITOR$1".COUNT;
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
          p_stm=>'TRACE 24: SELECT',
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
END "GK_TERRITORY_SLX_RD$1";

---------------------------------------------------------------------------
-- Procedure "GK_TERRITORY_SLX_DML$1" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "GK_TERRITORY_SLX_DML$1"(si NUMBER, firstround BOOLEAN) IS
  "GK_TERRITORY_ins0" NUMBER := "GK_TERRITORY_ins";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "GK_TERRITORY_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "GK_TERRITORY_nul")) THEN
    -- Insert DML for "GK_TERRITORY"
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    get_target_name := '"GK_TERRITORY"';
    get_audit_detail_id := "GK_TERRITORY_id";
    IF get_use_hc AND NOT firstround THEN
      "GK_TERRITORY_si" := "GK_TERRITORY_ir"(si);
      IF "GK_TERRITORY_si" = 0 THEN
        "GK_TERRITORY_i" := 0;
      ELSE
        "GK_TERRITORY_i" := "GK_TERRITORY_si" + 1;
      END IF;
    ELSE
      "GK_TERRITORY_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "GK_TERRITORY_i" <= get_bulk_size 
   AND "GK_TERRITORY_SLX_c$1"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "GK_TERRITORY_si" >= "GK_TERRITORY_i";
      END IF;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "GK_TERRITORY_si".."GK_TERRITORY_i" - 1
          INSERT 
          /*+ APPEND PARALLEL("GK_TERRITORY") */
          INTO
            "GK_TERRITORY"
            ("GK_TERRITORY"."TERRITORY_ID",
            "GK_TERRITORY"."SALESREP",
            "GK_TERRITORY"."STATE",
            "GK_TERRITORY"."ZIP_START",
            "GK_TERRITORY"."ZIP_END",
            "GK_TERRITORY"."REGION",
            "GK_TERRITORY"."USERID",
            "GK_TERRITORY"."REGION_MGR",
            "GK_TERRITORY"."GK_TERRITORY_ID",
            "GK_TERRITORY"."TERRITORY_TYPE"
            )
          VALUES
            ("GK_TERRITORY_0_TERRITORY_ID$1"(i),
            "GK_TERRITORY_1_SALESREP$1"(i),
            "GK_TERRITORY_2_STATE$1"(i),
            "GK_TERRITORY_3_ZIP_START$1"(i),
            "GK_TERRITORY_4_ZIP_END$1"(i),
            "GK_TERRITORY_5_REGION$1"(i),
            "GK_TERRITORY_6_USERID$1"(i),
            "GK_TERRITORY_7_REGION_MGR$1"(i),
            "GK_TERRI_8_GK_TERRI$1"(i),
            "GK_TERRITORY_9_TERRITORY_TY"(i)
            )
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "GK_TERRITORY_si" + get_rowid.COUNT;
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
          error_index := "GK_TERRITORY_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "GK_TERRITORY_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 25: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."TERRITORY_ID"',0,80),SUBSTRB("GK_TERRITORY_0_TERRITORY_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."SALESREP"',0,80),SUBSTRB("GK_TERRITORY_1_SALESREP$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."STATE"',0,80),SUBSTRB("GK_TERRITORY_2_STATE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."ZIP_START"',0,80),SUBSTRB("GK_TERRITORY_3_ZIP_START$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."ZIP_END"',0,80),SUBSTRB("GK_TERRITORY_4_ZIP_END$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."REGION"',0,80),SUBSTRB("GK_TERRITORY_5_REGION$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."USERID"',0,80),SUBSTRB("GK_TERRITORY_6_USERID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."REGION_MGR"',0,80),SUBSTRB("GK_TERRITORY_7_REGION_MGR$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."GK_TERRITORY_ID"',0,80),SUBSTRB("GK_TERRI_8_GK_TERRI$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"GK_TERRITORY"."TERRITORY_TYPE"',0,80),SUBSTRB("GK_TERRITORY_9_TERRITORY_TY"(error_index),0,2000));
            
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
          "GK_TERRITORY_err" := "GK_TERRITORY_err" + 1;
          
          IF get_errors + "GK_TERRITORY_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "GK_TERRITORY_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "GK_TERRITORY_srk"(rowkey_index);
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
  
      "GK_TERRITORY_ins" := "GK_TERRITORY_ins" + get_rowid.COUNT;
      "GK_TERRITORY_si" := error_index + 1;
  
      IF "GK_TERRITORY_si" >= "GK_TERRITORY_i" OR get_abort THEN
        "GK_TERRITORY_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "GK_TERRITORY_i" := 1; 
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "GK_TERRITORY_ins" := "GK_TERRITORY_ins0";
  END IF;

END "GK_TERRITORY_SLX_DML$1";

---------------------------------------------------------------------------
-- "GK_TERRITORY_SLX_t" main
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

  IF NOT "GK_TERRITORY_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "GK_TERRITORY_SLX_c$1"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "GK_TERRITORY_St" THEN
          "GK_TERRITORY_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"GK_TERRITORY"',
              p_target_uoid=>'A41FFB198FC65678E040007F01006C7D',
              p_stm=>'TRACE 27',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "GK_TERRITORY_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198FC65678E040007F01006C7D', -- Operator GK_TERRITORY
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A59CB5D347CC0953E040007F01007FB6', -- Operator GK_TERRITORY
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FA16DAFED655CE040007F01006B9E', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB198FBE5678E040007F01006C7D', -- Operator GK_TERRITORY_SLX
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A40B7C6CC08AA5E9E040007F01003A50' -- Location SLX_PROD_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A59CB5D347990953E040007F01007FB6', -- Operator GK_TERRITORY_SLX
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FFB18FDA45678E040007F01006C7D', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A40B7C6CC08AA5E9E040007F01003A50' -- SLX_PROD_LOCATION
            );
        END IF;
        IF NOT get_no_commit THEN
          COMMIT; -- commit no.10
        END IF;
      END IF;

      IF NOT "GK_TERRITORY_St" THEN
  BEGIN
    -- Truncate the target table, if the cursor has not been opened yet.
    -- If the cursor is open, then this is not the first call of this procedure for 
    -- the run, so the target has already been truncated.
    IF NOT "GK_TERRITORY_SLX_c$1"%ISOPEN THEN
      IF get_use_hc THEN
        IF "GK_TERRITORY_tt_sqlcode" IS NOT NULL THEN
          RAISE_APPLICATION_ERROR(-20016, "GK_TERRITORY_tt_sqlerrm");
        END IF;
      ELSE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE "GK_TERRITORY"';
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
        last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              WB_RT_MAPAUDIT.error(
                p_rta=>get_runtime_audit_id,
                p_step=>1,
                p_rtd=>"GK_TERRITORY_id",
                p_rowkey=>0,
                p_table=>'"GK_TERRITORY"',
                p_column=>'*',
                p_dstval=>NULL,
                p_stm=>'TRACE 28: TRUNCATE',
                p_sqlerr=>SQLCODE,
                p_sqlerrm=>SQLERRM,
                p_rowid=>NULL
              );
            END IF;
      get_abort := TRUE;
  END;
END IF;
      

      -- Initialize buffer variables
      get_buffer_done.DELETE;
      get_buffer_done_index := 1;

    END IF; -- End if cursor not open

    -- Initialize internal loop index variables
    "GK_TERRITORY_SLX_si$1" := 0;
    "GK_TERRITORY_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "GK_TERRITORY_SLX_SU$1";

      LOOP
        IF "GK_TERRITORY_SLX_si$1" = 0 THEN
          "GK_TERRITORY_SLX_RD$1";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "GK_TERRI_13_TERRITOR$1".COUNT - 1;
          ELSE
            bulk_count := "GK_TERRI_13_TERRITOR$1".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "GK_TERRITORY_ir".DELETE;
"GK_TERRITORY_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "GK_TERRITORY_SLX_i$1" := "GK_TERRITORY_SLX_si$1";
        BEGIN
          
          LOOP
            EXIT WHEN "GK_TERRITORY_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "GK_TERRITORY_SLX_i$1" := "GK_TERRITORY_SLX_i$1" + 1;
            "GK_TERRITORY_SLX_si$1" := "GK_TERRITORY_SLX_i$1";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "GK_TERRITORY_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("GK_TERRITORY_SLX_c$1"%NOTFOUND AND
               "GK_TERRITORY_SLX_i$1" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "GK_TERRITORY_SLX_i$1" > bulk_count THEN
            
              "GK_TERRITORY_SLX_si$1" := 0;
              EXIT;
            END IF;


            
get_target_name := '"GK_TERRITORY"';
            get_audit_detail_id := "GK_TERRITORY_id";
            IF NOT "GK_TERRITORY_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"GK_TERRITORY_0_TERRITORY_ID$1"("GK_TERRITORY_i") := 
            
            "GK_TERRI_13_TERRITOR$1"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_0_TERRITORY_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRI_13_TERRITOR$1"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_0_TERRITORY_ID$1"("GK_TERRITORY_i") :=
            
            "GK_TERRI_13_TERRITOR$1"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_0_TERRITORY_" :=
            
            "GK_TERRI_13_TERRITOR$1"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_1_SALESREP$1"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_10_SALESREP$1"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_1_SALESREP$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_10_SALESREP$1"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_1_SALESREP$1"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_10_SALESREP$1"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_1_SALESREP$1" :=
            
            "GK_TERRITORY_SLX_10_SALESREP$1"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_2_STATE$1"("GK_TERRITORY_i") := 
            
            "EXPR_1_STATE_OUT$1"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_2_STATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_STATE_OUT$1"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_2_STATE$1"("GK_TERRITORY_i") :=
            
            "EXPR_1_STATE_OUT$1"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_2_STATE$1" :=
            
            "EXPR_1_STATE_OUT$1"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_3_ZIP_START$1"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_19_ZIP_STA"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_3_ZIP_START$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_19_ZIP_STA"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_3_ZIP_START$1"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_19_ZIP_STA"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_3_ZIP_START$1" :=
            
            "GK_TERRITORY_SLX_19_ZIP_STA"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_4_ZIP_END$1"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_18_ZIP_END$1"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_4_ZIP_END$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_18_ZIP_END$1"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_4_ZIP_END$1"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_18_ZIP_END$1"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_4_ZIP_END$1" :=
            
            "GK_TERRITORY_SLX_18_ZIP_END$1"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_5_REGION$1"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_8_REGION$1"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_5_REGION$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_8_REGION$1"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_5_REGION$1"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_8_REGION$1"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_5_REGION$1" :=
            
            "GK_TERRITORY_SLX_8_REGION$1"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_6_USERID$1"("GK_TERRITORY_i") := 
            
            RTRIM("GK_TERRITORY_SLX_17_USERID$1"("GK_TERRITORY_SLX_i$1"));',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_6_USERID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("GK_TERRITORY_SLX_17_USERID$1"("GK_TERRITORY_SLX_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_6_USERID$1"("GK_TERRITORY_i") :=
            
            RTRIM("GK_TERRITORY_SLX_17_USERID$1"("GK_TERRITORY_SLX_i$1"));
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_6_USERID$1" :=
            
            RTRIM("GK_TERRITORY_SLX_17_USERID$1"("GK_TERRITORY_SLX_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_7_REGION_MGR$1"("GK_TERRITORY_i") := 
            
            "GK_TERRITORY_SLX_9_REGION_M"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_7_REGION_MGR$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRITORY_SLX_9_REGION_M"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_7_REGION_MGR$1"("GK_TERRITORY_i") :=
            
            "GK_TERRITORY_SLX_9_REGION_M"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_7_REGION_MGR$1" :=
            
            "GK_TERRITORY_SLX_9_REGION_M"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRI_8_GK_TERRI$1"("GK_TERRITORY_i") := 
            
            RTRIM("GK_TERRI_2_GK_TERRI$1"("GK_TERRITORY_SLX_i$1"));',0,2000);
            error_column := SUBSTRB('"GK_TERRI_8_GK_TERRI$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("GK_TERRI_2_GK_TERRI$1"("GK_TERRITORY_SLX_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRI_8_GK_TERRI$1"("GK_TERRITORY_i") :=
            
            RTRIM("GK_TERRI_2_GK_TERRI$1"("GK_TERRITORY_SLX_i$1"));
            
            ELSIF get_row_status THEN
              "SV_GK_TERRI_8_GK_TERRI$1" :=
            
            RTRIM("GK_TERRI_2_GK_TERRI$1"("GK_TERRITORY_SLX_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"GK_TERRITORY_9_TERRITORY_TY"("GK_TERRITORY_i") := 
            
            "GK_TERRI_14_TERRITOR$1"("GK_TERRITORY_SLX_i$1");',0,2000);
            error_column := SUBSTRB('"GK_TERRITORY_9_TERRITORY_TY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GK_TERRI_14_TERRITOR$1"("GK_TERRITORY_SLX_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "GK_TERRITORY_9_TERRITORY_TY"("GK_TERRITORY_i") :=
            
            "GK_TERRI_14_TERRITOR$1"("GK_TERRITORY_SLX_i$1");
            
            ELSIF get_row_status THEN
              "SV_GK_TERRITORY_9_TERRITORY_" :=
            
            "GK_TERRI_14_TERRITOR$1"("GK_TERRITORY_SLX_i$1");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "GK_TERRITORY_srk"("GK_TERRITORY_i") := get_rowkey + "GK_TERRITORY_SLX_i$1" - 1;
                  ELSIF get_row_status THEN
                    "SV_GK_TERRITORY_srk" := get_rowkey + "GK_TERRITORY_SLX_i$1" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "GK_TERRITORY_new" := TRUE;
                ELSE
                  "GK_TERRITORY_i" := "GK_TERRITORY_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "GK_TERRITORY_SLX_ER$1"('TRACE 29: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "GK_TERRITORY_SLX_i$1");
                  
                  "GK_TERRITORY_err" := "GK_TERRITORY_err" + 1;
                  
                  IF get_errors + "GK_TERRITORY_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("GK_TERRITORY_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "GK_TERRITORY_new" 
            AND (NOT "GK_TERRITORY_nul") THEN
              "GK_TERRITORY_ir"(dml_bsize) := "GK_TERRITORY_i";
            	"GK_TERRITORY_0_TERRITORY_ID$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_0_TERRITORY_";
            	"GK_TERRITORY_1_SALESREP$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_1_SALESREP$1";
            	"GK_TERRITORY_2_STATE$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_2_STATE$1";
            	"GK_TERRITORY_3_ZIP_START$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_3_ZIP_START$1";
            	"GK_TERRITORY_4_ZIP_END$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_4_ZIP_END$1";
            	"GK_TERRITORY_5_REGION$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_5_REGION$1";
            	"GK_TERRITORY_6_USERID$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_6_USERID$1";
            	"GK_TERRITORY_7_REGION_MGR$1"("GK_TERRITORY_i") := "SV_GK_TERRITORY_7_REGION_MGR$1";
            	"GK_TERRI_8_GK_TERRI$1"("GK_TERRITORY_i") := "SV_GK_TERRI_8_GK_TERRI$1";
            	"GK_TERRITORY_9_TERRITORY_TY"("GK_TERRITORY_i") := "SV_GK_TERRITORY_9_TERRITORY_";
              "GK_TERRITORY_srk"("GK_TERRITORY_i") := "SV_GK_TERRITORY_srk";
              "GK_TERRITORY_i" := "GK_TERRITORY_i" + 1;
            ELSE
              "GK_TERRITORY_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "GK_TERRITORY_SLX_DML$1"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "GK_TERRITORY_SLX_DML$1"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "GK_TERRITORY_SLX_ER$1"('TRACE 26: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "GK_TERRITORY_SLX_i$1");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "GK_TERRITORY_SLX_c$1"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "GK_TERRITORY_SLX_i$1" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "GK_TERRITORY_SLX_i$1" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "GK_TERRITORY_SLX_c$1";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "GK_TERRITORY_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"GK_TERRITORY_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"GK_TERRITORY_ins",
        p_upd=>"GK_TERRITORY_upd",
        p_del=>"GK_TERRITORY_del",
        p_err=>"GK_TERRITORY_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "GK_TERRITORY_ins";
    get_updated  := get_updated  + "GK_TERRITORY_upd";
    get_deleted  := get_deleted  + "GK_TERRITORY_del";
    get_errors   := get_errors   + "GK_TERRITORY_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "GK_TERRITORY_SLX_t";







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
      p_source=>'"sysdba"."GK_TERRITORY"@"SLX@SLX_PROD_LOCATION"',
      p_source_uoid=>'A41FFB198FBE5678E040007F01006C7D',
      p_target=>'"GK_TERRITORY"',
      p_target_uoid=>'A41FFB198FC65678E040007F01006C7D',      p_info=>NULL,
      
            p_type=>'PLSQLMap',
      
      p_date=>get_cycle_date
    );
  END IF;



  IF NOT get_no_commit THEN
    COMMIT; -- commit no.1
  END IF;
END Initialize;

PROCEDURE Truncate_Targets IS
BEGIN
	BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE "GK_TERRITORY"';
EXCEPTION
  WHEN OTHERS THEN
      last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
    "GK_TERRITORY_tt_sqlcode" := SQLCODE;
    "GK_TERRITORY_tt_sqlerrm" := SQLERRM;
END;

END Truncate_Targets;

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
  "GK_TERRITORY_St" := FALSE;
  Truncate_Targets;

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
      "GK_TERRITORY_St" := "GK_TERRITORY_Bat";
      get_batch_status := get_batch_status AND "GK_TERRITORY_St";
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
		"GK_TERRITORY_SLX_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "GK_TERRITORY_St" := "GK_TERRITORY_Bat";
        get_batch_status := get_batch_status AND "GK_TERRITORY_St";
      END IF;
    END IF;
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"GK_TERRITORY_St" := FALSE;

      END IF;
    END IF;

"GK_TERRITORY_SLX_p";

  END IF;
  IF get_operating_mode = MODE_ROW_TARGET THEN
"GK_TERRITORY_SLX_t";

  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW_TARGET THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "GK_TERRITORY_St" := "GK_TERRITORY_Bat";
        get_batch_status := get_batch_status AND "GK_TERRITORY_St";
      END IF;
    END IF;
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"GK_TERRITORY_St" := FALSE;

    END IF;
"GK_TERRITORY_SLX_t";

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
  AND    uo.object_name = 'OWB_GK_TERRITORY'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_GK_TERRITORY', x_schema, x_audit_id, x_object_id);

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
  IF "GK_TERRITORY_SLX_c"%ISOPEN THEN
    CLOSE "GK_TERRITORY_SLX_c";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;BEGIN
  IF "GK_TERRITORY_SLX_c$1"%ISOPEN THEN
    CLOSE "GK_TERRITORY_SLX_c$1";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;

END Close_Cursors;



END "OWB_GK_TERRITORY";
/


