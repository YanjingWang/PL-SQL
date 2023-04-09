DROP PACKAGE BODY GKDW.OWB_MARKET_DIM;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_MARKET_DIM" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "JOINER_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "JOINER_c" IS
  SELECT
  "MARKET_DIM"."ZIPCODE" "ZIPCODE",
  "MARKET_DIM"."COUNTRY" "COUNTRY",
  "GK_TERRITORY"."TERRITORY_ID" "TERRITORY_ID",
  "GK_TERRITORY"."REGION" "REGION_1",
  "GK_TERRITORY"."SALESREP" "SALESREP",
  "GK_TERRITORY"."REGION_MGR" "REGION_MGR_1",
  "MARKET_DIM"."STATE" "STATE",
  "MARKET_DIM"."CITY" "CITY",
  "GK_TERRITORY"."USERID" "USERID"
FROM
  "MARKET_DIM" "MARKET_DIM",
"GK_TERRITORY" "GK_TERRITORY"
  WHERE 
  ( "GK_TERRITORY"."TERRITORY_TYPE" = 'OB' ) AND
  ( "MARKET_DIM"."ZIPCODE" BETWEEN "GK_TERRITORY"."ZIP_START" AND "GK_TERRITORY"."ZIP_END" ); 

---------------------------------------------------------------------------
--
-- "JOINER_c$1" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "JOINER_c$1" IS
  SELECT
  "MARKET_DIM"."ZIPCODE" "ZIPCODE",
  "MARKET_DIM"."COUNTRY" "COUNTRY",
  "GK_TERRITORY"."TERRITORY_ID" "TERRITORY_ID",
  "GK_TERRITORY"."REGION" "REGION_1",
  "GK_TERRITORY"."SALESREP" "SALESREP",
  "GK_TERRITORY"."REGION_MGR" "REGION_MGR_1",
  "MARKET_DIM"."STATE" "STATE",
  "MARKET_DIM"."CITY" "CITY",
  "GK_TERRITORY"."USERID" "USERID"
FROM
  "MARKET_DIM" "MARKET_DIM",
"GK_TERRITORY" "GK_TERRITORY"
  WHERE 
  ( "GK_TERRITORY"."TERRITORY_TYPE" = 'OB' ) AND
  ( "MARKET_DIM"."ZIPCODE" BETWEEN "GK_TERRITORY"."ZIP_START" AND "GK_TERRITORY"."ZIP_END" ); 


a_table_to_analyze a_table_to_analyze_type;



---------------------------------------------------------------------------
-- Function "MARKET_DIM_Bat"
--   performs batch extraction
--   Returns TRUE on success
--   Returns FALSE on failure
---------------------------------------------------------------------------
FUNCTION "MARKET_DIM_Bat"
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
      p_name=>'"MARKET_DIM_Bat"',
      p_source=>'*',
      p_source_uoid=>'*',
      p_target=>'"MARKET_DIM"',
      p_target_uoid=>'A75448099F0B49DAE040007F010067E5',
      p_stm=>NULL,p_info=>NULL,
      
      p_exec_mode=>MODE_SET
    );
    get_audit_detail_id := batch_auditd_id;
  	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A75448099EF149DAE040007F010067E5', -- Operator MARKET_DIM_SOURCE
    p_parent_object_name=>'MARKET_DIM',
    p_parent_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'MARKET_DIM',
    p_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A75448099F0B49DAE040007F010067E5', -- Operator MARKET_DIM
    p_parent_object_name=>'MARKET_DIM',
    p_parent_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'MARKET_DIM',
    p_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A75448099E7249DAE040007F010067E5', -- Operator MARKET_DIM_SOURCE
    p_parent_object_name=>'MARKET_DIM',
    p_parent_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'MARKET_DIM',
    p_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- GKDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A75448099F7749DAE040007F010067E5', -- Operator MARKET_DIM
    p_parent_object_name=>'MARKET_DIM',
    p_parent_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
    p_parent_object_type=>'Table',
    p_object_name=>'MARKET_DIM',
    p_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A7544809A02749DAE040007F010067E5', -- Operator GK_TERRITORY
    p_parent_object_name=>'GK_TERRITORY',
    p_parent_object_uoid=>'A41FFB1913675678E040007F01006C7D', -- Table GK_TERRITORY
    p_parent_object_type=>'Table',
    p_object_name=>'GK_TERRITORY',
    p_object_uoid=>'A41FFB1913675678E040007F01006C7D', -- Table GK_TERRITORY
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
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
  
    IF NOT "MARKET_DIM_St" THEN
    
      batch_action := 'BATCH MERGE';
batch_selected := SQL%ROWCOUNT;
MERGE
INTO
  "MARKET_DIM"
USING
  (SELECT
  "MARKET_DIM"."ZIPCODE" "ZIPCODE",
  "MARKET_DIM"."COUNTRY" "COUNTRY",
  "GK_TERRITORY"."TERRITORY_ID" "TERRITORY_ID",
  "GK_TERRITORY"."REGION" "REGION_1",
  "GK_TERRITORY"."SALESREP" "SALESREP",
  "GK_TERRITORY"."REGION_MGR" "REGION_MGR_1",
  "MARKET_DIM"."STATE" "STATE",
  "MARKET_DIM"."CITY" "CITY",
  "GK_TERRITORY"."USERID" "USERID"
FROM
  "MARKET_DIM" "MARKET_DIM",
"GK_TERRITORY" "GK_TERRITORY"
  WHERE 
  ( "GK_TERRITORY"."TERRITORY_TYPE" = 'OB' ) AND
  ( "MARKET_DIM"."ZIPCODE" BETWEEN "GK_TERRITORY"."ZIP_START" AND "GK_TERRITORY"."ZIP_END" )
  )
    MERGE_SUBQUERY
ON (
  "MARKET_DIM"."ZIPCODE" = "MERGE_SUBQUERY"."ZIPCODE"
   )
  
  WHEN MATCHED THEN
    UPDATE
    SET
                  "COUNTRY" = "MERGE_SUBQUERY"."COUNTRY",
  "TERRITORY" = "MERGE_SUBQUERY"."TERRITORY_ID",
  "REGION" = "MERGE_SUBQUERY"."REGION_1",
  "SALES_REP" = "MERGE_SUBQUERY"."SALESREP",
  "REGION_MGR" = "MERGE_SUBQUERY"."REGION_MGR_1",
  "STATE" = "MERGE_SUBQUERY"."STATE",
  "CITY" = "MERGE_SUBQUERY"."CITY",
  "SALES_REP_ID" = "MERGE_SUBQUERY"."USERID"
       
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
        p_table=>'"MARKET_DIM"',
        p_column=>'*',
        p_dstval=>NULL,
        p_stm=>'TRACE 99: ' || batch_action,
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
END "MARKET_DIM_Bat";



-- Procedure "JOINER_p" is the entry point for map "JOINER_p"

PROCEDURE "JOINER_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"JOINER_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"MARKET_DIM","GK_TERRITORY"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A75448099EF149DAE040007F010067E5,A7544809A02749DAE040007F010067E5';
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

"MARKET_DIM_id" NUMBER(22) := 0;
"MARKET_DIM_ins" NUMBER(22) := 0;
"MARKET_DIM_upd" NUMBER(22) := 0;
"MARKET_DIM_del" NUMBER(22) := 0;
"MARKET_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"MARKET_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"MARKET_DIM_ir"  index_redirect_array;
"SV_MARKET_DIM_srk" NUMBER;
"MARKET_DIM_new"  BOOLEAN;
"MARKET_DIM_nul"  BOOLEAN := FALSE;

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

"JOINER_si" NUMBER(22) := 0;

"JOINER_i" NUMBER(22) := 0;


"MARKET_DIM_si" NUMBER(22) := 0;

"MARKET_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_JOINER_25_ZIPCODE" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_JOINER" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_26_COUNTRY" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_40_TERRITORY_ID" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_45_REGION_1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_41_SALESREP" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_47_REGION_MGR_1" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_37_STATE" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_38_CITY" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_46_USERID" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_0_ZIPCODE" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_1_COUNTRY" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_2_TERRITORY" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_3_REGION" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_4_SALES_REP" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_5_REGION_MGR" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_12_STATE" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_13_CITY" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_14_SALES_REP_ID" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_JOINER_25_ZIPCODE"  VARCHAR2(25);
"SV_ROWKEY_JOINER"  VARCHAR2(18);
"SV_JOINER_26_COUNTRY"  VARCHAR2(15);
"SV_JOINER_40_TERRITORY_ID"  VARCHAR2(10);
"SV_JOINER_45_REGION_1"  VARCHAR2(50);
"SV_JOINER_41_SALESREP"  VARCHAR2(75);
"SV_JOINER_47_REGION_MGR_1"  VARCHAR2(75);
"SV_JOINER_37_STATE"  VARCHAR2(25);
"SV_JOINER_38_CITY"  VARCHAR2(50);
"SV_JOINER_46_USERID"  VARCHAR2(15);
"SV_MARKET_DIM_0_ZIPCODE"  VARCHAR2(25);
"SV_MARKET_DIM_1_COUNTRY"  VARCHAR2(15);
"SV_MARKET_DIM_2_TERRITORY"  VARCHAR2(25);
"SV_MARKET_DIM_3_REGION"  VARCHAR2(50);
"SV_MARKET_DIM_4_SALES_REP"  VARCHAR2(100);
"SV_MARKET_DIM_5_REGION_MGR"  VARCHAR2(100);
"SV_MARKET_DIM_12_STATE"  VARCHAR2(25);
"SV_MARKET_DIM_13_CITY"  VARCHAR2(50);
"SV_MARKET_DIM_14_SALES_REP_ID"  VARCHAR2(15);

-- Bulk: intermediate collection variables
"JOINER_25_ZIPCODE" "T_JOINER_25_ZIPCODE";
"ROWKEY_JOINER" "T_ROWKEY_JOINER";
"JOINER_26_COUNTRY" "T_JOINER_26_COUNTRY";
"JOINER_40_TERRITORY_ID" "T_JOINER_40_TERRITORY_ID";
"JOINER_45_REGION_1" "T_JOINER_45_REGION_1";
"JOINER_41_SALESREP" "T_JOINER_41_SALESREP";
"JOINER_47_REGION_MGR_1" "T_JOINER_47_REGION_MGR_1";
"JOINER_37_STATE" "T_JOINER_37_STATE";
"JOINER_38_CITY" "T_JOINER_38_CITY";
"JOINER_46_USERID" "T_JOINER_46_USERID";
"MARKET_DIM_0_ZIPCODE" "T_MARKET_DIM_0_ZIPCODE";
"MARKET_DIM_1_COUNTRY" "T_MARKET_DIM_1_COUNTRY";
"MARKET_DIM_2_TERRITORY" "T_MARKET_DIM_2_TERRITORY";
"MARKET_DIM_3_REGION" "T_MARKET_DIM_3_REGION";
"MARKET_DIM_4_SALES_REP" "T_MARKET_DIM_4_SALES_REP";
"MARKET_DIM_5_REGION_MGR" "T_MARKET_DIM_5_REGION_MGR";
"MARKET_DIM_12_STATE" "T_MARKET_DIM_12_STATE";
"MARKET_DIM_13_CITY" "T_MARKET_DIM_13_CITY";
"MARKET_DIM_14_SALES_REP_ID" "T_MARKET_DIM_14_SALES_REP_ID";

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
PROCEDURE "JOINER_ES"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_25_ZIPCODE',0,80),
    p_value=>SUBSTRB("JOINER_25_ZIPCODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_26_COUNTRY',0,80),
    p_value=>SUBSTRB("JOINER_26_COUNTRY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_40_TERRITORY_ID',0,80),
    p_value=>SUBSTRB("JOINER_40_TERRITORY_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_45_REGION_1',0,80),
    p_value=>SUBSTRB("JOINER_45_REGION_1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_41_SALESREP',0,80),
    p_value=>SUBSTRB("JOINER_41_SALESREP"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_47_REGION_MGR_1',0,80),
    p_value=>SUBSTRB("JOINER_47_REGION_MGR_1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_37_STATE',0,80),
    p_value=>SUBSTRB("JOINER_37_STATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_38_CITY',0,80),
    p_value=>SUBSTRB("JOINER_38_CITY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_46_USERID',0,80),
    p_value=>SUBSTRB("JOINER_46_USERID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "JOINER_ES";

---------------------------------------------------------------------------
-- Procedure "JOINER_ER" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "JOINER_ER"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 100: ' || p_statement,
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
    "JOINER_ES"(p_error_index);
  END IF;
END "JOINER_ER";



---------------------------------------------------------------------------
-- Procedure "JOINER_SU" opens and initializes data source
-- for map "JOINER_p"
---------------------------------------------------------------------------
PROCEDURE "JOINER_SU" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "JOINER_c"%ISOPEN) THEN
    OPEN "JOINER_c";
  END IF;
  get_read_success := TRUE;
END "JOINER_SU";

---------------------------------------------------------------------------
-- Procedure "JOINER_RD" fetches a bulk of rows from
--   the data source for map "JOINER_p"
---------------------------------------------------------------------------
PROCEDURE "JOINER_RD" IS
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
    "JOINER_25_ZIPCODE".DELETE;
    "JOINER_26_COUNTRY".DELETE;
    "JOINER_40_TERRITORY_ID".DELETE;
    "JOINER_45_REGION_1".DELETE;
    "JOINER_41_SALESREP".DELETE;
    "JOINER_47_REGION_MGR_1".DELETE;
    "JOINER_37_STATE".DELETE;
    "JOINER_38_CITY".DELETE;
    "JOINER_46_USERID".DELETE;

    FETCH
      "JOINER_c"
    BULK COLLECT INTO
      "JOINER_25_ZIPCODE",
      "JOINER_26_COUNTRY",
      "JOINER_40_TERRITORY_ID",
      "JOINER_45_REGION_1",
      "JOINER_41_SALESREP",
      "JOINER_47_REGION_MGR_1",
      "JOINER_37_STATE",
      "JOINER_38_CITY",
      "JOINER_46_USERID"
    LIMIT get_bulk_size;

    IF "JOINER_c"%NOTFOUND AND "JOINER_25_ZIPCODE".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "JOINER_25_ZIPCODE".COUNT;
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
    get_map_selected := get_map_selected + "JOINER_25_ZIPCODE".COUNT;
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
          p_stm=>'TRACE 101: SELECT',
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
END "JOINER_RD";

---------------------------------------------------------------------------
-- Procedure "JOINER_DML" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "JOINER_DML"(si NUMBER, firstround BOOLEAN) IS
  "MARKET_DIM_upd0" NUMBER := "MARKET_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "MARKET_DIM_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "MARKET_DIM_nul")) THEN
    -- Update DML for "MARKET_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"MARKET_DIM"';
    get_audit_detail_id := "MARKET_DIM_id";
  
    IF get_use_hc AND NOT firstround THEN
      "MARKET_DIM_si" := "MARKET_DIM_ir"(si);
      IF "MARKET_DIM_si" = 0 THEN
        "MARKET_DIM_i" := 0;
      ELSE
        "MARKET_DIM_i" := "MARKET_DIM_si" + 1;
      END IF;
    ELSE
      "MARKET_DIM_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "MARKET_DIM_i" <= get_bulk_size 
   AND "JOINER_c"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "MARKET_DIM_si" >= "MARKET_DIM_i";
      END IF;
  
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "MARKET_DIM_si".."MARKET_DIM_i" - 1
          UPDATE
            "MARKET_DIM"
          SET
  
  					"MARKET_DIM"."COUNTRY" = "MARKET_DIM_1_COUNTRY"
  (i),
  					"MARKET_DIM"."TERRITORY" = "MARKET_DIM_2_TERRITORY"
  (i),
  					"MARKET_DIM"."REGION" = "MARKET_DIM_3_REGION"
  (i),
  					"MARKET_DIM"."SALES_REP" = "MARKET_DIM_4_SALES_REP"
  (i),
  					"MARKET_DIM"."REGION_MGR" = "MARKET_DIM_5_REGION_MGR"
  (i),
  					"MARKET_DIM"."STATE" = "MARKET_DIM_12_STATE"
  (i),
  					"MARKET_DIM"."CITY" = "MARKET_DIM_13_CITY"
  (i),
  					"MARKET_DIM"."SALES_REP_ID" = "MARKET_DIM_14_SALES_REP_ID"
  (i)
  
          WHERE
  
  
  					"MARKET_DIM"."ZIPCODE" = "MARKET_DIM_0_ZIPCODE"
  (i)
  
          RETURNING ROWID BULK COLLECT INTO get_rowid;
          
        feedback_bulk_limit := "MARKET_DIM_i" - 1;
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "MARKET_DIM_si"..feedback_bulk_limit LOOP
          IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              get_rowkey_bulk(rowkey_bulk_index) := "MARKET_DIM_srk"(rowkey_index);
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
  
        "MARKET_DIM_upd" := "MARKET_DIM_upd" + get_rowid.COUNT;
        "MARKET_DIM_si" := "MARKET_DIM_i";
  
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
              FOR rowkey_index IN REVERSE "MARKET_DIM_si".."MARKET_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "MARKET_DIM_si"..feedback_bulk_limit LOOP
              IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "MARKET_DIM_srk"(rowkey_index);
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
            "MARKET_DIM_upd" := "MARKET_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "MARKET_DIM_si";
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
                "MARKET_DIM"
              SET
  
  							"MARKET_DIM"."COUNTRY" = "MARKET_DIM_1_COUNTRY"
  (last_successful_index),
  							"MARKET_DIM"."TERRITORY" = "MARKET_DIM_2_TERRITORY"
  (last_successful_index),
  							"MARKET_DIM"."REGION" = "MARKET_DIM_3_REGION"
  (last_successful_index),
  							"MARKET_DIM"."SALES_REP" = "MARKET_DIM_4_SALES_REP"
  (last_successful_index),
  							"MARKET_DIM"."REGION_MGR" = "MARKET_DIM_5_REGION_MGR"
  (last_successful_index),
  							"MARKET_DIM"."STATE" = "MARKET_DIM_12_STATE"
  (last_successful_index),
  							"MARKET_DIM"."CITY" = "MARKET_DIM_13_CITY"
  (last_successful_index),
  							"MARKET_DIM"."SALES_REP_ID" = "MARKET_DIM_14_SALES_REP_ID"
  (last_successful_index)
  
              WHERE
  
  
  							"MARKET_DIM"."ZIPCODE" = "MARKET_DIM_0_ZIPCODE"
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
                  error_rowkey := "MARKET_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."COUNTRY"',0,80),SUBSTRB("MARKET_DIM_1_COUNTRY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."TERRITORY"',0,80),SUBSTRB("MARKET_DIM_2_TERRITORY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."REGION"',0,80),SUBSTRB("MARKET_DIM_3_REGION"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."SALES_REP"',0,80),SUBSTRB("MARKET_DIM_4_SALES_REP"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."REGION_MGR"',0,80),SUBSTRB("MARKET_DIM_5_REGION_MGR"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."STATE"',0,80),SUBSTRB("MARKET_DIM_12_STATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."CITY"',0,80),SUBSTRB("MARKET_DIM_13_CITY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."SALES_REP_ID"',0,80),SUBSTRB("MARKET_DIM_14_SALES_REP_ID"(last_successful_index),0,2000));
                  
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
                "MARKET_DIM_err" := "MARKET_DIM_err" + 1;
                
                IF get_errors + "MARKET_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "MARKET_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "MARKET_DIM_si" >= "MARKET_DIM_i" OR get_abort THEN
        "MARKET_DIM_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "MARKET_DIM_i" := 1; 
  END IF;
  
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "MARKET_DIM_upd" := "MARKET_DIM_upd0";
  END IF;

END "JOINER_DML";

---------------------------------------------------------------------------
-- "JOINER_p" main
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

  IF NOT "MARKET_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "JOINER_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "MARKET_DIM_St" THEN
          "MARKET_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"MARKET_DIM"',
              p_target_uoid=>'A75448099F0B49DAE040007F010067E5',
              p_stm=>'TRACE 103',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "MARKET_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099EF149DAE040007F010067E5', -- Operator MARKET_DIM_SOURCE
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099F0B49DAE040007F010067E5', -- Operator MARKET_DIM
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099E7249DAE040007F010067E5', -- Operator MARKET_DIM_SOURCE
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099F7749DAE040007F010067E5', -- Operator MARKET_DIM
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7544809A02749DAE040007F010067E5', -- Operator GK_TERRITORY
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FFB1913675678E040007F01006C7D', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FFB1913675678E040007F01006C7D', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
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
    "JOINER_si" := 0;
    "MARKET_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "JOINER_SU";

      LOOP
        IF "JOINER_si" = 0 THEN
          "JOINER_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "JOINER_25_ZIPCODE".COUNT - 1;
          ELSE
            bulk_count := "JOINER_25_ZIPCODE".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "MARKET_DIM_ir".DELETE;
"MARKET_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "JOINER_i" := "JOINER_si";
        BEGIN
          
          LOOP
            EXIT WHEN "MARKET_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "JOINER_i" := "JOINER_i" + 1;
            "JOINER_si" := "JOINER_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "MARKET_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("JOINER_c"%NOTFOUND AND
               "JOINER_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "JOINER_i" > bulk_count THEN
            
              "JOINER_si" := 0;
              EXIT;
            END IF;


            
get_target_name := '"MARKET_DIM"';
            get_audit_detail_id := "MARKET_DIM_id";
            IF NOT "MARKET_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"MARKET_DIM_0_ZIPCODE"("MARKET_DIM_i") := 
            
            "JOINER_25_ZIPCODE"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_0_ZIPCODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_25_ZIPCODE"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_0_ZIPCODE"("MARKET_DIM_i") :=
            
            "JOINER_25_ZIPCODE"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_0_ZIPCODE" :=
            
            "JOINER_25_ZIPCODE"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_1_COUNTRY"("MARKET_DIM_i") := 
            
            "JOINER_26_COUNTRY"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_1_COUNTRY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_26_COUNTRY"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_1_COUNTRY"("MARKET_DIM_i") :=
            
            "JOINER_26_COUNTRY"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_1_COUNTRY" :=
            
            "JOINER_26_COUNTRY"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_2_TERRITORY"("MARKET_DIM_i") := 
            
            "JOINER_40_TERRITORY_ID"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_2_TERRITORY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_40_TERRITORY_ID"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_2_TERRITORY"("MARKET_DIM_i") :=
            
            "JOINER_40_TERRITORY_ID"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_2_TERRITORY" :=
            
            "JOINER_40_TERRITORY_ID"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_3_REGION"("MARKET_DIM_i") := 
            
            "JOINER_45_REGION_1"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_3_REGION"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_45_REGION_1"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_3_REGION"("MARKET_DIM_i") :=
            
            "JOINER_45_REGION_1"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_3_REGION" :=
            
            "JOINER_45_REGION_1"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_4_SALES_REP"("MARKET_DIM_i") := 
            
            "JOINER_41_SALESREP"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_4_SALES_REP"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_41_SALESREP"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_4_SALES_REP"("MARKET_DIM_i") :=
            
            "JOINER_41_SALESREP"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_4_SALES_REP" :=
            
            "JOINER_41_SALESREP"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_5_REGION_MGR"("MARKET_DIM_i") := 
            
            "JOINER_47_REGION_MGR_1"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_5_REGION_MGR"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_47_REGION_MGR_1"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_5_REGION_MGR"("MARKET_DIM_i") :=
            
            "JOINER_47_REGION_MGR_1"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_5_REGION_MGR" :=
            
            "JOINER_47_REGION_MGR_1"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_12_STATE"("MARKET_DIM_i") := 
            
            "JOINER_37_STATE"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_12_STATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_37_STATE"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_12_STATE"("MARKET_DIM_i") :=
            
            "JOINER_37_STATE"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_12_STATE" :=
            
            "JOINER_37_STATE"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_13_CITY"("MARKET_DIM_i") := 
            
            "JOINER_38_CITY"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_13_CITY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_38_CITY"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_13_CITY"("MARKET_DIM_i") :=
            
            "JOINER_38_CITY"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_13_CITY" :=
            
            "JOINER_38_CITY"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_14_SALES_REP_ID"("MARKET_DIM_i") := 
            
            "JOINER_46_USERID"("JOINER_i");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_14_SALES_REP_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_46_USERID"("JOINER_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_14_SALES_REP_ID"("MARKET_DIM_i") :=
            
            "JOINER_46_USERID"("JOINER_i");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_14_SALES_REP_ID" :=
            
            "JOINER_46_USERID"("JOINER_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "MARKET_DIM_srk"("MARKET_DIM_i") := get_rowkey + "JOINER_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_MARKET_DIM_srk" := get_rowkey + "JOINER_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "MARKET_DIM_new" := TRUE;
                ELSE
                  "MARKET_DIM_i" := "MARKET_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "JOINER_ER"('TRACE 104: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "JOINER_i");
                  
                  "MARKET_DIM_err" := "MARKET_DIM_err" + 1;
                  
                  IF get_errors + "MARKET_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("MARKET_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "MARKET_DIM_new" 
            AND (NOT "MARKET_DIM_nul") THEN
              "MARKET_DIM_ir"(dml_bsize) := "MARKET_DIM_i";
            	"MARKET_DIM_0_ZIPCODE"("MARKET_DIM_i") := "SV_MARKET_DIM_0_ZIPCODE";
            	"MARKET_DIM_1_COUNTRY"("MARKET_DIM_i") := "SV_MARKET_DIM_1_COUNTRY";
            	"MARKET_DIM_2_TERRITORY"("MARKET_DIM_i") := "SV_MARKET_DIM_2_TERRITORY";
            	"MARKET_DIM_3_REGION"("MARKET_DIM_i") := "SV_MARKET_DIM_3_REGION";
            	"MARKET_DIM_4_SALES_REP"("MARKET_DIM_i") := "SV_MARKET_DIM_4_SALES_REP";
            	"MARKET_DIM_5_REGION_MGR"("MARKET_DIM_i") := "SV_MARKET_DIM_5_REGION_MGR";
            	"MARKET_DIM_12_STATE"("MARKET_DIM_i") := "SV_MARKET_DIM_12_STATE";
            	"MARKET_DIM_13_CITY"("MARKET_DIM_i") := "SV_MARKET_DIM_13_CITY";
            	"MARKET_DIM_14_SALES_REP_ID"("MARKET_DIM_i") := "SV_MARKET_DIM_14_SALES_REP_ID";
              "MARKET_DIM_srk"("MARKET_DIM_i") := "SV_MARKET_DIM_srk";
              "MARKET_DIM_i" := "MARKET_DIM_i" + 1;
            ELSE
              "MARKET_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "JOINER_DML"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "JOINER_DML"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "JOINER_ER"('TRACE 102: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "JOINER_i");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "JOINER_c"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "JOINER_i" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "JOINER_i" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "JOINER_c";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "MARKET_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"MARKET_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"MARKET_DIM_ins",
        p_upd=>"MARKET_DIM_upd",
        p_del=>"MARKET_DIM_del",
        p_err=>"MARKET_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "MARKET_DIM_ins";
    get_updated  := get_updated  + "MARKET_DIM_upd";
    get_deleted  := get_deleted  + "MARKET_DIM_del";
    get_errors   := get_errors   + "MARKET_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "JOINER_p";



-- Procedure "JOINER_t" is the entry point for map "JOINER_t"

PROCEDURE "JOINER_t"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"JOINER_t"';
get_source_name            CONSTANT VARCHAR2(2000) := '"MARKET_DIM","GK_TERRITORY"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A75448099EF149DAE040007F010067E5,A7544809A02749DAE040007F010067E5';
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

"MARKET_DIM_id" NUMBER(22) := 0;
"MARKET_DIM_ins" NUMBER(22) := 0;
"MARKET_DIM_upd" NUMBER(22) := 0;
"MARKET_DIM_del" NUMBER(22) := 0;
"MARKET_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"MARKET_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"MARKET_DIM_ir"  index_redirect_array;
"SV_MARKET_DIM_srk" NUMBER;
"MARKET_DIM_new"  BOOLEAN;
"MARKET_DIM_nul"  BOOLEAN := FALSE;

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

"JOINER_si$1" NUMBER(22) := 0;

"JOINER_i$1" NUMBER(22) := 0;


"MARKET_DIM_si" NUMBER(22) := 0;

"MARKET_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_JOINER_25_ZIPCODE$1" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_JOINER$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_26_COUNTRY$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_40_TERRITORY_ID$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_45_REGION_1$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_41_SALESREP$1" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_47_REGION_MGR_1$1" IS TABLE OF VARCHAR2(75) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_37_STATE$1" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_38_CITY$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_JOINER_46_USERID$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_0_ZIPCODE$1" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_1_COUNTRY$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_2_TERRITORY$1" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_3_REGION$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_4_SALES_REP$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_5_REGION_MGR$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_12_STATE$1" IS TABLE OF VARCHAR2(25) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_13_CITY$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_MARKET_DIM_14_SALES_REP_ID$1" IS TABLE OF VARCHAR2(15) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_JOINER_25_ZIPCODE$1"  VARCHAR2(25);
"SV_ROWKEY_JOINER$1"  VARCHAR2(18);
"SV_JOINER_26_COUNTRY$1"  VARCHAR2(15);
"SV_JOINER_40_TERRITORY_ID$1"  VARCHAR2(10);
"SV_JOINER_45_REGION_1$1"  VARCHAR2(50);
"SV_JOINER_41_SALESREP$1"  VARCHAR2(75);
"SV_JOINER_47_REGION_MGR_1$1"  VARCHAR2(75);
"SV_JOINER_37_STATE$1"  VARCHAR2(25);
"SV_JOINER_38_CITY$1"  VARCHAR2(50);
"SV_JOINER_46_USERID$1"  VARCHAR2(15);
"SV_MARKET_DIM_0_ZIPCODE$1"  VARCHAR2(25);
"SV_MARKET_DIM_1_COUNTRY$1"  VARCHAR2(15);
"SV_MARKET_DIM_2_TERRITORY$1"  VARCHAR2(25);
"SV_MARKET_DIM_3_REGION$1"  VARCHAR2(50);
"SV_MARKET_DIM_4_SALES_REP$1"  VARCHAR2(100);
"SV_MARKET_DIM_5_REGION_MGR$1"  VARCHAR2(100);
"SV_MARKET_DIM_12_STATE$1"  VARCHAR2(25);
"SV_MARKET_DIM_13_CITY$1"  VARCHAR2(50);
"SV_MARKET_DIM_14_SALES_REP_"  VARCHAR2(15);

-- Bulk: intermediate collection variables
"JOINER_25_ZIPCODE$1" "T_JOINER_25_ZIPCODE$1";
"ROWKEY_JOINER$1" "T_ROWKEY_JOINER$1";
"JOINER_26_COUNTRY$1" "T_JOINER_26_COUNTRY$1";
"JOINER_40_TERRITORY_ID$1" "T_JOINER_40_TERRITORY_ID$1";
"JOINER_45_REGION_1$1" "T_JOINER_45_REGION_1$1";
"JOINER_41_SALESREP$1" "T_JOINER_41_SALESREP$1";
"JOINER_47_REGION_MGR_1$1" "T_JOINER_47_REGION_MGR_1$1";
"JOINER_37_STATE$1" "T_JOINER_37_STATE$1";
"JOINER_38_CITY$1" "T_JOINER_38_CITY$1";
"JOINER_46_USERID$1" "T_JOINER_46_USERID$1";
"MARKET_DIM_0_ZIPCODE$1" "T_MARKET_DIM_0_ZIPCODE$1";
"MARKET_DIM_1_COUNTRY$1" "T_MARKET_DIM_1_COUNTRY$1";
"MARKET_DIM_2_TERRITORY$1" "T_MARKET_DIM_2_TERRITORY$1";
"MARKET_DIM_3_REGION$1" "T_MARKET_DIM_3_REGION$1";
"MARKET_DIM_4_SALES_REP$1" "T_MARKET_DIM_4_SALES_REP$1";
"MARKET_DIM_5_REGION_MGR$1" "T_MARKET_DIM_5_REGION_MGR$1";
"MARKET_DIM_12_STATE$1" "T_MARKET_DIM_12_STATE$1";
"MARKET_DIM_13_CITY$1" "T_MARKET_DIM_13_CITY$1";
"MARKET_DIM_14_SALES_REP_ID$1" "T_MARKET_DIM_14_SALES_REP_ID$1";

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
PROCEDURE "JOINER_ES$1"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_25_ZIPCODE',0,80),
    p_value=>SUBSTRB("JOINER_25_ZIPCODE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_26_COUNTRY',0,80),
    p_value=>SUBSTRB("JOINER_26_COUNTRY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_40_TERRITORY_ID',0,80),
    p_value=>SUBSTRB("JOINER_40_TERRITORY_ID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_45_REGION_1',0,80),
    p_value=>SUBSTRB("JOINER_45_REGION_1$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_41_SALESREP',0,80),
    p_value=>SUBSTRB("JOINER_41_SALESREP$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_47_REGION_MGR_1',0,80),
    p_value=>SUBSTRB("JOINER_47_REGION_MGR_1$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_37_STATE',0,80),
    p_value=>SUBSTRB("JOINER_37_STATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_38_CITY',0,80),
    p_value=>SUBSTRB("JOINER_38_CITY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"MARKET_DIM","GK_TERRITORY"',0,80),
    p_column=>SUBSTR('JOINER_46_USERID',0,80),
    p_value=>SUBSTRB("JOINER_46_USERID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "JOINER_ES$1";

---------------------------------------------------------------------------
-- Procedure "JOINER_ER$1" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "JOINER_ER$1"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 105: ' || p_statement,
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
    "JOINER_ES$1"(p_error_index);
  END IF;
END "JOINER_ER$1";



---------------------------------------------------------------------------
-- Procedure "JOINER_SU$1" opens and initializes data source
-- for map "JOINER_t"
---------------------------------------------------------------------------
PROCEDURE "JOINER_SU$1" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "JOINER_c$1"%ISOPEN) THEN
    OPEN "JOINER_c$1";
  END IF;
  get_read_success := TRUE;
END "JOINER_SU$1";

---------------------------------------------------------------------------
-- Procedure "JOINER_RD$1" fetches a bulk of rows from
--   the data source for map "JOINER_t"
---------------------------------------------------------------------------
PROCEDURE "JOINER_RD$1" IS
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
    "JOINER_25_ZIPCODE$1".DELETE;
    "JOINER_26_COUNTRY$1".DELETE;
    "JOINER_40_TERRITORY_ID$1".DELETE;
    "JOINER_45_REGION_1$1".DELETE;
    "JOINER_41_SALESREP$1".DELETE;
    "JOINER_47_REGION_MGR_1$1".DELETE;
    "JOINER_37_STATE$1".DELETE;
    "JOINER_38_CITY$1".DELETE;
    "JOINER_46_USERID$1".DELETE;

    FETCH
      "JOINER_c$1"
    BULK COLLECT INTO
      "JOINER_25_ZIPCODE$1",
      "JOINER_26_COUNTRY$1",
      "JOINER_40_TERRITORY_ID$1",
      "JOINER_45_REGION_1$1",
      "JOINER_41_SALESREP$1",
      "JOINER_47_REGION_MGR_1$1",
      "JOINER_37_STATE$1",
      "JOINER_38_CITY$1",
      "JOINER_46_USERID$1"
    LIMIT get_bulk_size;

    IF "JOINER_c$1"%NOTFOUND AND "JOINER_25_ZIPCODE$1".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "JOINER_25_ZIPCODE$1".COUNT;
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
    get_map_selected := get_map_selected + "JOINER_25_ZIPCODE$1".COUNT;
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
          p_stm=>'TRACE 106: SELECT',
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
END "JOINER_RD$1";

---------------------------------------------------------------------------
-- Procedure "JOINER_DML$1" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "JOINER_DML$1"(si NUMBER, firstround BOOLEAN) IS
  "MARKET_DIM_upd0" NUMBER := "MARKET_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "MARKET_DIM_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "MARKET_DIM_nul")) THEN
    -- Update DML for "MARKET_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"MARKET_DIM"';
    get_audit_detail_id := "MARKET_DIM_id";
  
    IF get_use_hc AND NOT firstround THEN
      "MARKET_DIM_si" := "MARKET_DIM_ir"(si);
      IF "MARKET_DIM_si" = 0 THEN
        "MARKET_DIM_i" := 0;
      ELSE
        "MARKET_DIM_i" := "MARKET_DIM_si" + 1;
      END IF;
    ELSE
      "MARKET_DIM_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "MARKET_DIM_i" <= get_bulk_size 
   AND "JOINER_c$1"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "MARKET_DIM_si" >= "MARKET_DIM_i";
      END IF;
  
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "MARKET_DIM_si".."MARKET_DIM_i" - 1
          UPDATE
            "MARKET_DIM"
          SET
  
  					"MARKET_DIM"."COUNTRY" = "MARKET_DIM_1_COUNTRY$1"
  (i),
  					"MARKET_DIM"."TERRITORY" = "MARKET_DIM_2_TERRITORY$1"
  (i),
  					"MARKET_DIM"."REGION" = "MARKET_DIM_3_REGION$1"
  (i),
  					"MARKET_DIM"."SALES_REP" = "MARKET_DIM_4_SALES_REP$1"
  (i),
  					"MARKET_DIM"."REGION_MGR" = "MARKET_DIM_5_REGION_MGR$1"
  (i),
  					"MARKET_DIM"."STATE" = "MARKET_DIM_12_STATE$1"
  (i),
  					"MARKET_DIM"."CITY" = "MARKET_DIM_13_CITY$1"
  (i),
  					"MARKET_DIM"."SALES_REP_ID" = "MARKET_DIM_14_SALES_REP_ID$1"
  (i)
  
          WHERE
  
  
  					"MARKET_DIM"."ZIPCODE" = "MARKET_DIM_0_ZIPCODE$1"
  (i)
  
          RETURNING ROWID BULK COLLECT INTO get_rowid;
          
        feedback_bulk_limit := "MARKET_DIM_i" - 1;
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "MARKET_DIM_si"..feedback_bulk_limit LOOP
          IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              get_rowkey_bulk(rowkey_bulk_index) := "MARKET_DIM_srk"(rowkey_index);
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
  
        "MARKET_DIM_upd" := "MARKET_DIM_upd" + get_rowid.COUNT;
        "MARKET_DIM_si" := "MARKET_DIM_i";
  
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
              FOR rowkey_index IN REVERSE "MARKET_DIM_si".."MARKET_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "MARKET_DIM_si"..feedback_bulk_limit LOOP
              IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "MARKET_DIM_srk"(rowkey_index);
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
            "MARKET_DIM_upd" := "MARKET_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "MARKET_DIM_si";
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
                "MARKET_DIM"
              SET
  
  							"MARKET_DIM"."COUNTRY" = "MARKET_DIM_1_COUNTRY$1"
  (last_successful_index),
  							"MARKET_DIM"."TERRITORY" = "MARKET_DIM_2_TERRITORY$1"
  (last_successful_index),
  							"MARKET_DIM"."REGION" = "MARKET_DIM_3_REGION$1"
  (last_successful_index),
  							"MARKET_DIM"."SALES_REP" = "MARKET_DIM_4_SALES_REP$1"
  (last_successful_index),
  							"MARKET_DIM"."REGION_MGR" = "MARKET_DIM_5_REGION_MGR$1"
  (last_successful_index),
  							"MARKET_DIM"."STATE" = "MARKET_DIM_12_STATE$1"
  (last_successful_index),
  							"MARKET_DIM"."CITY" = "MARKET_DIM_13_CITY$1"
  (last_successful_index),
  							"MARKET_DIM"."SALES_REP_ID" = "MARKET_DIM_14_SALES_REP_ID$1"
  (last_successful_index)
  
              WHERE
  
  
  							"MARKET_DIM"."ZIPCODE" = "MARKET_DIM_0_ZIPCODE$1"
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
                  error_rowkey := "MARKET_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."COUNTRY"',0,80),SUBSTRB("MARKET_DIM_1_COUNTRY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."TERRITORY"',0,80),SUBSTRB("MARKET_DIM_2_TERRITORY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."REGION"',0,80),SUBSTRB("MARKET_DIM_3_REGION$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."SALES_REP"',0,80),SUBSTRB("MARKET_DIM_4_SALES_REP$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."REGION_MGR"',0,80),SUBSTRB("MARKET_DIM_5_REGION_MGR$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."STATE"',0,80),SUBSTRB("MARKET_DIM_12_STATE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."CITY"',0,80),SUBSTRB("MARKET_DIM_13_CITY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"MARKET_DIM"."SALES_REP_ID"',0,80),SUBSTRB("MARKET_DIM_14_SALES_REP_ID$1"(last_successful_index),0,2000));
                  
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
                "MARKET_DIM_err" := "MARKET_DIM_err" + 1;
                
                IF get_errors + "MARKET_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "MARKET_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "MARKET_DIM_si" >= "MARKET_DIM_i" OR get_abort THEN
        "MARKET_DIM_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "MARKET_DIM_i" := 1; 
  END IF;
  
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "MARKET_DIM_upd" := "MARKET_DIM_upd0";
  END IF;

END "JOINER_DML$1";

---------------------------------------------------------------------------
-- "JOINER_t" main
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

  IF NOT "MARKET_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "JOINER_c$1"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "MARKET_DIM_St" THEN
          "MARKET_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"MARKET_DIM"',
              p_target_uoid=>'A75448099F0B49DAE040007F010067E5',
              p_stm=>'TRACE 108',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "MARKET_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099EF149DAE040007F010067E5', -- Operator MARKET_DIM_SOURCE
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099F0B49DAE040007F010067E5', -- Operator MARKET_DIM
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099E7249DAE040007F010067E5', -- Operator MARKET_DIM_SOURCE
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FFB1913845678E040007F01006C7D', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A75448099F7749DAE040007F010067E5', -- Operator MARKET_DIM
              p_parent_object_name=>'MARKET_DIM',
              p_parent_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'MARKET_DIM',
              p_object_uoid=>'A41FA16DB2BA655CE040007F01006B9E', -- Table MARKET_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A7544809A02749DAE040007F010067E5', -- Operator GK_TERRITORY
              p_parent_object_name=>'GK_TERRITORY',
              p_parent_object_uoid=>'A41FFB1913675678E040007F01006C7D', -- Table GK_TERRITORY
              p_parent_object_type=>'Table',
              p_object_name=>'GK_TERRITORY',
              p_object_uoid=>'A41FFB1913675678E040007F01006C7D', -- Table GK_TERRITORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
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
    "JOINER_si$1" := 0;
    "MARKET_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "JOINER_SU$1";

      LOOP
        IF "JOINER_si$1" = 0 THEN
          "JOINER_RD$1";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "JOINER_25_ZIPCODE$1".COUNT - 1;
          ELSE
            bulk_count := "JOINER_25_ZIPCODE$1".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "MARKET_DIM_ir".DELETE;
"MARKET_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "JOINER_i$1" := "JOINER_si$1";
        BEGIN
          
          LOOP
            EXIT WHEN "MARKET_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "JOINER_i$1" := "JOINER_i$1" + 1;
            "JOINER_si$1" := "JOINER_i$1";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "MARKET_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("JOINER_c$1"%NOTFOUND AND
               "JOINER_i$1" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "JOINER_i$1" > bulk_count THEN
            
              "JOINER_si$1" := 0;
              EXIT;
            END IF;


            
get_target_name := '"MARKET_DIM"';
            get_audit_detail_id := "MARKET_DIM_id";
            IF NOT "MARKET_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"MARKET_DIM_0_ZIPCODE$1"("MARKET_DIM_i") := 
            
            "JOINER_25_ZIPCODE$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_0_ZIPCODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_25_ZIPCODE$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_0_ZIPCODE$1"("MARKET_DIM_i") :=
            
            "JOINER_25_ZIPCODE$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_0_ZIPCODE$1" :=
            
            "JOINER_25_ZIPCODE$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_1_COUNTRY$1"("MARKET_DIM_i") := 
            
            "JOINER_26_COUNTRY$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_1_COUNTRY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_26_COUNTRY$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_1_COUNTRY$1"("MARKET_DIM_i") :=
            
            "JOINER_26_COUNTRY$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_1_COUNTRY$1" :=
            
            "JOINER_26_COUNTRY$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_2_TERRITORY$1"("MARKET_DIM_i") := 
            
            "JOINER_40_TERRITORY_ID$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_2_TERRITORY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_40_TERRITORY_ID$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_2_TERRITORY$1"("MARKET_DIM_i") :=
            
            "JOINER_40_TERRITORY_ID$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_2_TERRITORY$1" :=
            
            "JOINER_40_TERRITORY_ID$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_3_REGION$1"("MARKET_DIM_i") := 
            
            "JOINER_45_REGION_1$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_3_REGION$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_45_REGION_1$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_3_REGION$1"("MARKET_DIM_i") :=
            
            "JOINER_45_REGION_1$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_3_REGION$1" :=
            
            "JOINER_45_REGION_1$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_4_SALES_REP$1"("MARKET_DIM_i") := 
            
            "JOINER_41_SALESREP$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_4_SALES_REP$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_41_SALESREP$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_4_SALES_REP$1"("MARKET_DIM_i") :=
            
            "JOINER_41_SALESREP$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_4_SALES_REP$1" :=
            
            "JOINER_41_SALESREP$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_5_REGION_MGR$1"("MARKET_DIM_i") := 
            
            "JOINER_47_REGION_MGR_1$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_5_REGION_MGR$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_47_REGION_MGR_1$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_5_REGION_MGR$1"("MARKET_DIM_i") :=
            
            "JOINER_47_REGION_MGR_1$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_5_REGION_MGR$1" :=
            
            "JOINER_47_REGION_MGR_1$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_12_STATE$1"("MARKET_DIM_i") := 
            
            "JOINER_37_STATE$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_12_STATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_37_STATE$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_12_STATE$1"("MARKET_DIM_i") :=
            
            "JOINER_37_STATE$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_12_STATE$1" :=
            
            "JOINER_37_STATE$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_13_CITY$1"("MARKET_DIM_i") := 
            
            "JOINER_38_CITY$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_13_CITY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_38_CITY$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_13_CITY$1"("MARKET_DIM_i") :=
            
            "JOINER_38_CITY$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_13_CITY$1" :=
            
            "JOINER_38_CITY$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"MARKET_DIM_14_SALES_REP_ID$1"("MARKET_DIM_i") := 
            
            "JOINER_46_USERID$1"("JOINER_i$1");',0,2000);
            error_column := SUBSTRB('"MARKET_DIM_14_SALES_REP_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("JOINER_46_USERID$1"("JOINER_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "MARKET_DIM_14_SALES_REP_ID$1"("MARKET_DIM_i") :=
            
            "JOINER_46_USERID$1"("JOINER_i$1");
            
            ELSIF get_row_status THEN
              "SV_MARKET_DIM_14_SALES_REP_" :=
            
            "JOINER_46_USERID$1"("JOINER_i$1");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "MARKET_DIM_srk"("MARKET_DIM_i") := get_rowkey + "JOINER_i$1" - 1;
                  ELSIF get_row_status THEN
                    "SV_MARKET_DIM_srk" := get_rowkey + "JOINER_i$1" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "MARKET_DIM_new" := TRUE;
                ELSE
                  "MARKET_DIM_i" := "MARKET_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "JOINER_ER$1"('TRACE 109: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "JOINER_i$1");
                  
                  "MARKET_DIM_err" := "MARKET_DIM_err" + 1;
                  
                  IF get_errors + "MARKET_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("MARKET_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "MARKET_DIM_new" 
            AND (NOT "MARKET_DIM_nul") THEN
              "MARKET_DIM_ir"(dml_bsize) := "MARKET_DIM_i";
            	"MARKET_DIM_0_ZIPCODE$1"("MARKET_DIM_i") := "SV_MARKET_DIM_0_ZIPCODE$1";
            	"MARKET_DIM_1_COUNTRY$1"("MARKET_DIM_i") := "SV_MARKET_DIM_1_COUNTRY$1";
            	"MARKET_DIM_2_TERRITORY$1"("MARKET_DIM_i") := "SV_MARKET_DIM_2_TERRITORY$1";
            	"MARKET_DIM_3_REGION$1"("MARKET_DIM_i") := "SV_MARKET_DIM_3_REGION$1";
            	"MARKET_DIM_4_SALES_REP$1"("MARKET_DIM_i") := "SV_MARKET_DIM_4_SALES_REP$1";
            	"MARKET_DIM_5_REGION_MGR$1"("MARKET_DIM_i") := "SV_MARKET_DIM_5_REGION_MGR$1";
            	"MARKET_DIM_12_STATE$1"("MARKET_DIM_i") := "SV_MARKET_DIM_12_STATE$1";
            	"MARKET_DIM_13_CITY$1"("MARKET_DIM_i") := "SV_MARKET_DIM_13_CITY$1";
            	"MARKET_DIM_14_SALES_REP_ID$1"("MARKET_DIM_i") := "SV_MARKET_DIM_14_SALES_REP_";
              "MARKET_DIM_srk"("MARKET_DIM_i") := "SV_MARKET_DIM_srk";
              "MARKET_DIM_i" := "MARKET_DIM_i" + 1;
            ELSE
              "MARKET_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "JOINER_DML$1"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "JOINER_DML$1"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "JOINER_ER$1"('TRACE 107: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "JOINER_i$1");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "JOINER_c$1"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "JOINER_i$1" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "JOINER_i$1" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "JOINER_c$1";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "MARKET_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"MARKET_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"MARKET_DIM_ins",
        p_upd=>"MARKET_DIM_upd",
        p_del=>"MARKET_DIM_del",
        p_err=>"MARKET_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "MARKET_DIM_ins";
    get_updated  := get_updated  + "MARKET_DIM_upd";
    get_deleted  := get_deleted  + "MARKET_DIM_del";
    get_errors   := get_errors   + "MARKET_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "JOINER_t";







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
      p_source=>'"MARKET_DIM","GK_TERRITORY"',
      p_source_uoid=>'A75448099EF149DAE040007F010067E5,A7544809A02749DAE040007F010067E5',
      p_target=>'"MARKET_DIM"',
      p_target_uoid=>'A75448099F0B49DAE040007F010067E5',      p_info=>NULL,
      
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
  "MARKET_DIM_St" := FALSE;

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
      "MARKET_DIM_St" := "MARKET_DIM_Bat";
      get_batch_status := get_batch_status AND "MARKET_DIM_St";
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
		"JOINER_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "MARKET_DIM_St" := "MARKET_DIM_Bat";
        get_batch_status := get_batch_status AND "MARKET_DIM_St";
      END IF;
    END IF;
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"MARKET_DIM_St" := FALSE;

      END IF;
    END IF;

"JOINER_p";

  END IF;
  IF get_operating_mode = MODE_ROW_TARGET THEN
"JOINER_t";

  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW_TARGET THEN
		
    IF get_batch_status THEN
      IF NOT get_use_hc OR get_batch_status THEN
        "MARKET_DIM_St" := "MARKET_DIM_Bat";
        get_batch_status := get_batch_status AND "MARKET_DIM_St";
      END IF;
    END IF;
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"MARKET_DIM_St" := FALSE;

    END IF;
"JOINER_t";

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
  AND    uo.object_name = 'OWB_MARKET_DIM'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_MARKET_DIM', x_schema, x_audit_id, x_object_id);

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
  IF "JOINER_c"%ISOPEN THEN
    CLOSE "JOINER_c";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;BEGIN
  IF "JOINER_c$1"%ISOPEN THEN
    CLOSE "JOINER_c$1";
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    NULL;    
END;

END Close_Cursors;



END "OWB_MARKET_DIM";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_MARKET_DIM TO DWHREAD;

