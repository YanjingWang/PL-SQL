DROP PACKAGE BODY GKDW.OWB_ORDER_FACT_ORATX_UPD;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_ORDER_FACT_ORATX_UPD" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "FLTR_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c" IS
  SELECT
  "ORDER_FACT"."TXFEE_ID" "TXFEE_ID",
  "ORACLETX_HISTORY"."ORDERSTATUS" "ORDERSTATUS"
FROM
    "ORDER_FACT"  "ORDER_FACT"   
 LEFT OUTER JOIN   "SLXDW"."EVXEV_TXFEE"  "EVXEV_TXFEE" ON ( ( "EVXEV_TXFEE"."EVXEV_TXFEEID" = "ORDER_FACT"."TXFEE_ID" ) )
 LEFT OUTER JOIN   "SLXDW"."ORACLETX_HISTORY"  "ORACLETX_HISTORY" ON ( ( ( nvl(ORACLETX_HISTORY."TRANSACTIONTYPE", ' ') <> "OWB_ORDER_FACT_ORATX_UPD"."GET_CONST_0_TRANSACTIONTYPE" ) ) AND ( ( "ORACLETX_HISTORY"."EVXBILLINGID" = "EVXEV_TXFEE"."EVXBILLINGID" ) ) )
  WHERE 
  ( "ORDER_FACT"."GKDW_SOURCE" = 'SLXDW' ) AND
  ( "ORDER_FACT"."BILL_STATUS" is null ); 

---------------------------------------------------------------------------
--
-- "FLTR_c$1" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c$1" IS
  SELECT
  "ORDER_FACT"."TXFEE_ID" "TXFEE_ID$1",
  "ORACLETX_HISTORY"."ORDERSTATUS" "ORDERSTATUS"
FROM
    "ORDER_FACT"  "ORDER_FACT"   
 LEFT OUTER JOIN   "SLXDW"."EVXEV_TXFEE"  "EVXEV_TXFEE" ON ( ( "EVXEV_TXFEE"."EVXEV_TXFEEID" = "ORDER_FACT"."TXFEE_ID" ) )
 LEFT OUTER JOIN   "SLXDW"."ORACLETX_HISTORY"  "ORACLETX_HISTORY" ON ( ( ( nvl(ORACLETX_HISTORY."TRANSACTIONTYPE", ' ') <> "OWB_ORDER_FACT_ORATX_UPD"."GET_CONST_0_TRANSACTIONTYPE" ) ) AND ( ( "ORACLETX_HISTORY"."EVXBILLINGID" = "EVXEV_TXFEE"."EVXBILLINGID" ) ) )
  WHERE 
  ( "ORDER_FACT"."GKDW_SOURCE" = 'SLXDW' ) AND
  ( "ORDER_FACT"."BILL_STATUS" is null ); 


a_table_to_analyze a_table_to_analyze_type;


PROCEDURE EXEC_AUTONOMOUS_SQL(CMD IN VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  EXECUTE IMMEDIATE (CMD);
  COMMIT;
END;

-- Access functions for user-defined variables via mapping Variable components,
--            and package global storage for user-defined mapping input parameters
FUNCTION "GET_CONST_0_TRANSACTIONTYPE" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_0_TRANSACTIONTYPE";
END "GET_CONST_0_TRANSACTIONTYPE";



---------------------------------------------------------------------------
-- Function "ORDER_FACT_Bat"
--   performs batch extraction
--   Returns TRUE on success
--   Returns FALSE on failure
---------------------------------------------------------------------------
FUNCTION "ORDER_FACT_Bat"
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
      p_name=>'"ORDER_FACT_Bat"',
      p_source=>'*',
      p_source_uoid=>'*',
      p_target=>'"ORDER_FACT"',
      p_target_uoid=>'A41FFB19C3825678E040007F01006C7D',
      p_stm=>NULL,p_info=>NULL,
      
      p_exec_mode=>MODE_SET
    );
    get_audit_detail_id := batch_auditd_id;
  	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19C3825678E040007F01006C7D', -- Operator ORDER_FACT
    p_parent_object_name=>'ORDER_FACT',
    p_parent_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
    p_parent_object_type=>'Table',
    p_object_name=>'ORDER_FACT',
    p_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19C1A65678E040007F01006C7D', -- Operator ORDER_FACT_SOURCE
    p_parent_object_name=>'ORDER_FACT',
    p_parent_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
    p_parent_object_type=>'Table',
    p_object_name=>'ORDER_FACT',
    p_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- GKDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19C33A5678E040007F01006C7D', -- Operator ORDER_FACT_SOURCE
    p_parent_object_name=>'ORDER_FACT',
    p_parent_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
    p_parent_object_type=>'Table',
    p_object_name=>'ORDER_FACT',
    p_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A74AEE7BE007650EE040007F010059D8', -- Operator ORDER_FACT
    p_parent_object_name=>'ORDER_FACT',
    p_parent_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
    p_parent_object_type=>'Table',
    p_object_name=>'ORDER_FACT',
    p_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
    p_object_type=>'Table',
    p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19C3845678E040007F01006C7D', -- Operator ORACLETX_HISTORY
    p_parent_object_name=>'ORACLETX_HISTORY',
    p_parent_object_uoid=>'A41FFB190ABE5678E040007F01006C7D', -- Table ORACLETX_HISTORY
    p_parent_object_type=>'Table',
    p_object_name=>'ORACLETX_HISTORY',
    p_object_uoid=>'A41FFB190ABE5678E040007F01006C7D', -- Table ORACLETX_HISTORY
    p_object_type=>'Table',
    p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
  );
    	get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
    p_rtd=>get_audit_detail_id,
    p_parent_operator_uoid=>'A41FFB19C33B5678E040007F01006C7D', -- Operator EVXEV_TXFEE
    p_parent_object_name=>'EVXEV_TXFEE',
    p_parent_object_uoid=>'A41FFB190D9F5678E040007F01006C7D', -- Table EVXEV_TXFEE
    p_parent_object_type=>'Table',
    p_object_name=>'EVXEV_TXFEE',
    p_object_uoid=>'A41FFB190D9F5678E040007F01006C7D', -- Table EVXEV_TXFEE
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
  
    IF NOT "ORDER_FACT_St" THEN
    
      batch_action := 'BATCH MERGE';
batch_selected := SQL%ROWCOUNT;
MERGE
/*+ APPEND PARALLEL("ORDER_FACT") */
INTO
  "ORDER_FACT"
USING
  (SELECT
  "ORDER_FACT"."TXFEE_ID" "TXFEE_ID$2",
  "ORACLETX_HISTORY"."ORDERSTATUS" "ORDERSTATUS"
FROM
    "ORDER_FACT"  "ORDER_FACT"   
 LEFT OUTER JOIN   "SLXDW"."EVXEV_TXFEE"  "EVXEV_TXFEE" ON ( ( "EVXEV_TXFEE"."EVXEV_TXFEEID" = "ORDER_FACT"."TXFEE_ID" ) )
 LEFT OUTER JOIN   "SLXDW"."ORACLETX_HISTORY"  "ORACLETX_HISTORY" ON ( ( ( "ORACLETX_HISTORY"."TRANSACTIONTYPE" = "OWB_ORDER_FACT_ORATX_UPD"."GET_CONST_0_TRANSACTIONTYPE" ) ) AND ( ( "ORACLETX_HISTORY"."EVXBILLINGID" = "EVXEV_TXFEE"."EVXBILLINGID" ) ) )
  WHERE 
  ( "ORDER_FACT"."GKDW_SOURCE" = 'SLXDW' ) AND
  ( "ORDER_FACT"."BILL_STATUS" is null )
  )
    MERGE_SUBQUERY
ON (
  "ORDER_FACT"."TXFEE_ID" = "MERGE_SUBQUERY"."TXFEE_ID$2"
   )
  
  WHEN MATCHED THEN
    UPDATE
    SET
                  "BILL_STATUS" = "MERGE_SUBQUERY"."ORDERSTATUS"
       
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
        p_table=>'"ORDER_FACT"',
        p_column=>'*',
        p_dstval=>NULL,
        p_stm=>'TRACE 55: ' || batch_action,
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
END "ORDER_FACT_Bat";



-- Procedure "FLTR_p" is the entry point for map "FLTR_p"

PROCEDURE "FLTR_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"FLTR_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB19C33A5678E040007F01006C7D,A41FFB19C33B5678E040007F01006C7D,A41FFB19C3845678E040007F01006C7D';
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

"ORDER_FACT_id" NUMBER(22) := 0;
"ORDER_FACT_ins" NUMBER(22) := 0;
"ORDER_FACT_upd" NUMBER(22) := 0;
"ORDER_FACT_del" NUMBER(22) := 0;
"ORDER_FACT_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"ORDER_FACT_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"ORDER_FACT_ir"  index_redirect_array;
"SV_ORDER_FACT_srk" NUMBER;
"ORDER_FACT_new"  BOOLEAN;
"ORDER_FACT_nul"  BOOLEAN := FALSE;

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


"ORDER_FACT_si" NUMBER(22) := 0;

"ORDER_FACT_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_36_TXFEE_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_ORACLETX_39_ORDERSTA" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_ORDER_FACT_36_TXFEE_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ORDER_FACT_38_BILL_STATUS" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_36_TXFEE_ID"  VARCHAR2(50);
"SV_ROWKEY_FLTR"  VARCHAR2(18);
"SV_ORACLETX_39_ORDERSTA"  VARCHAR2(10);
"SV_ORDER_FACT_36_TXFEE_ID"  VARCHAR2(50);
"SV_ORDER_FACT_38_BILL_STATUS"  VARCHAR2(20);

-- Bulk: intermediate collection variables
"FLTR_36_TXFEE_ID" "T_FLTR_36_TXFEE_ID";
"ROWKEY_FLTR" "T_ROWKEY_FLTR";
"ORACLETX_39_ORDERSTA" "T_ORACLETX_39_ORDERSTA";
"ORDER_FACT_36_TXFEE_ID" "T_ORDER_FACT_36_TXFEE_ID";
"ORDER_FACT_38_BILL_STATUS" "T_ORDER_FACT_38_BILL_STATUS";

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
    p_table=>SUBSTR('"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"',0,80),
    p_column=>SUBSTR('FLTR_36_TXFEE_ID',0,80),
    p_value=>SUBSTRB("FLTR_36_TXFEE_ID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"',0,80),
    p_column=>SUBSTR('ORACLETX_39_ORDERSTA',0,80),
    p_value=>SUBSTRB("ORACLETX_39_ORDERSTA"(error_index),0,2000),
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
      p_stm=>'TRACE 56: ' || p_statement,
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
    "FLTR_36_TXFEE_ID".DELETE;
    "ORACLETX_39_ORDERSTA".DELETE;

    FETCH
      "FLTR_c"
    BULK COLLECT INTO
      "FLTR_36_TXFEE_ID",
      "ORACLETX_39_ORDERSTA"
    LIMIT get_bulk_size;

    IF "FLTR_c"%NOTFOUND AND "FLTR_36_TXFEE_ID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_36_TXFEE_ID".COUNT;
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
    get_map_selected := get_map_selected + "FLTR_36_TXFEE_ID".COUNT;
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
          p_stm=>'TRACE 57: SELECT',
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
  "ORDER_FACT_upd0" NUMBER := "ORDER_FACT_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "ORDER_FACT_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "ORDER_FACT_nul")) THEN
    -- Update DML for "ORDER_FACT"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"ORDER_FACT"';
    get_audit_detail_id := "ORDER_FACT_id";
  
    IF get_use_hc AND NOT firstround THEN
      "ORDER_FACT_si" := "ORDER_FACT_ir"(si);
      IF "ORDER_FACT_si" = 0 THEN
        "ORDER_FACT_i" := 0;
      ELSE
        "ORDER_FACT_i" := "ORDER_FACT_si" + 1;
      END IF;
    ELSE
      "ORDER_FACT_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "ORDER_FACT_i" <= get_bulk_size 
   AND "FLTR_c"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "ORDER_FACT_si" >= "ORDER_FACT_i";
      END IF;
  
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "ORDER_FACT_si".."ORDER_FACT_i" - 1
          UPDATE
          /*+ APPEND PARALLEL("ORDER_FACT") */
            "ORDER_FACT"
          SET
  
  					"ORDER_FACT"."BILL_STATUS" = "ORDER_FACT_38_BILL_STATUS"
  (i)
  
          WHERE
  
  
  					"ORDER_FACT"."TXFEE_ID" = "ORDER_FACT_36_TXFEE_ID"
  (i)
  
          RETURNING ROWID BULK COLLECT INTO get_rowid;
          
        feedback_bulk_limit := "ORDER_FACT_i" - 1;
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "ORDER_FACT_si"..feedback_bulk_limit LOOP
          IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              get_rowkey_bulk(rowkey_bulk_index) := "ORDER_FACT_srk"(rowkey_index);
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
  
        "ORDER_FACT_upd" := "ORDER_FACT_upd" + get_rowid.COUNT;
        "ORDER_FACT_si" := "ORDER_FACT_i";
  
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
              FOR rowkey_index IN REVERSE "ORDER_FACT_si".."ORDER_FACT_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "ORDER_FACT_si"..feedback_bulk_limit LOOP
              IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "ORDER_FACT_srk"(rowkey_index);
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
            "ORDER_FACT_upd" := "ORDER_FACT_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "ORDER_FACT_si";
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
              /*+ APPEND PARALLEL("ORDER_FACT") */
                "ORDER_FACT"
              SET
  
  							"ORDER_FACT"."BILL_STATUS" = "ORDER_FACT_38_BILL_STATUS"
  (last_successful_index)
  
              WHERE
  
  
  							"ORDER_FACT"."TXFEE_ID" = "ORDER_FACT_36_TXFEE_ID"
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
                  error_rowkey := "ORDER_FACT_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ORDER_FACT"."BILL_STATUS"',0,80),SUBSTRB("ORDER_FACT_38_BILL_STATUS"(last_successful_index),0,2000));
                  
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
                "ORDER_FACT_err" := "ORDER_FACT_err" + 1;
                
                IF get_errors + "ORDER_FACT_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "ORDER_FACT_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "ORDER_FACT_si" >= "ORDER_FACT_i" OR get_abort THEN
        "ORDER_FACT_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "ORDER_FACT_i" := 1; 
  END IF;
  
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "ORDER_FACT_upd" := "ORDER_FACT_upd0";
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

  IF NOT "ORDER_FACT_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "ORDER_FACT_St" THEN
          "ORDER_FACT_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"ORDER_FACT"',
              p_target_uoid=>'A41FFB19C3825678E040007F01006C7D',
              p_stm=>'TRACE 59',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "ORDER_FACT_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C3825678E040007F01006C7D', -- Operator ORDER_FACT
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C1A65678E040007F01006C7D', -- Operator ORDER_FACT_SOURCE
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C33A5678E040007F01006C7D', -- Operator ORDER_FACT_SOURCE
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A74AEE7BE007650EE040007F010059D8', -- Operator ORDER_FACT
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C3845678E040007F01006C7D', -- Operator ORACLETX_HISTORY
              p_parent_object_name=>'ORACLETX_HISTORY',
              p_parent_object_uoid=>'A41FFB190ABE5678E040007F01006C7D', -- Table ORACLETX_HISTORY
              p_parent_object_type=>'Table',
              p_object_name=>'ORACLETX_HISTORY',
              p_object_uoid=>'A41FFB190ABE5678E040007F01006C7D', -- Table ORACLETX_HISTORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C33B5678E040007F01006C7D', -- Operator EVXEV_TXFEE
              p_parent_object_name=>'EVXEV_TXFEE',
              p_parent_object_uoid=>'A41FFB190D9F5678E040007F01006C7D', -- Table EVXEV_TXFEE
              p_parent_object_type=>'Table',
              p_object_name=>'EVXEV_TXFEE',
              p_object_uoid=>'A41FFB190D9F5678E040007F01006C7D', -- Table EVXEV_TXFEE
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
    "FLTR_si" := 0;
    "ORDER_FACT_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU";

      LOOP
        IF "FLTR_si" = 0 THEN
          "FLTR_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_36_TXFEE_ID".COUNT - 1;
          ELSE
            bulk_count := "FLTR_36_TXFEE_ID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "ORDER_FACT_ir".DELETE;
"ORDER_FACT_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i" := "FLTR_si";
        BEGIN
          
          LOOP
            EXIT WHEN "ORDER_FACT_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i" := "FLTR_i" + 1;
            "FLTR_si" := "FLTR_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "ORDER_FACT_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("FLTR_c"%NOTFOUND AND
               "FLTR_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "FLTR_i" > bulk_count THEN
            
              "FLTR_si" := 0;
              EXIT;
            END IF;


            
get_target_name := '"ORDER_FACT"';
            get_audit_detail_id := "ORDER_FACT_id";
            IF NOT "ORDER_FACT_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"ORDER_FACT_36_TXFEE_ID"("ORDER_FACT_i") := 
            
            "FLTR_36_TXFEE_ID"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ORDER_FACT_36_TXFEE_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_36_TXFEE_ID"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ORDER_FACT_36_TXFEE_ID"("ORDER_FACT_i") :=
            
            "FLTR_36_TXFEE_ID"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ORDER_FACT_36_TXFEE_ID" :=
            
            "FLTR_36_TXFEE_ID"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ORDER_FACT_38_BILL_STATUS"("ORDER_FACT_i") := 
            
            "ORACLETX_39_ORDERSTA"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"ORDER_FACT_38_BILL_STATUS"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ORACLETX_39_ORDERSTA"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ORDER_FACT_38_BILL_STATUS"("ORDER_FACT_i") :=
            
            "ORACLETX_39_ORDERSTA"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_ORDER_FACT_38_BILL_STATUS" :=
            
            "ORACLETX_39_ORDERSTA"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "ORDER_FACT_srk"("ORDER_FACT_i") := get_rowkey + "FLTR_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_ORDER_FACT_srk" := get_rowkey + "FLTR_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "ORDER_FACT_new" := TRUE;
                ELSE
                  "ORDER_FACT_i" := "ORDER_FACT_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER"('TRACE 60: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i");
                  
                  "ORDER_FACT_err" := "ORDER_FACT_err" + 1;
                  
                  IF get_errors + "ORDER_FACT_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("ORDER_FACT_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "ORDER_FACT_new" 
            AND (NOT "ORDER_FACT_nul") THEN
              "ORDER_FACT_ir"(dml_bsize) := "ORDER_FACT_i";
            	"ORDER_FACT_36_TXFEE_ID"("ORDER_FACT_i") := "SV_ORDER_FACT_36_TXFEE_ID";
            	"ORDER_FACT_38_BILL_STATUS"("ORDER_FACT_i") := "SV_ORDER_FACT_38_BILL_STATUS";
              "ORDER_FACT_srk"("ORDER_FACT_i") := "SV_ORDER_FACT_srk";
              "ORDER_FACT_i" := "ORDER_FACT_i" + 1;
            ELSE
              "ORDER_FACT_ir"(dml_bsize) := 0;
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
            "FLTR_ER"('TRACE 58: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i");
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
    IF NOT "ORDER_FACT_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"ORDER_FACT_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"ORDER_FACT_ins",
        p_upd=>"ORDER_FACT_upd",
        p_del=>"ORDER_FACT_del",
        p_err=>"ORDER_FACT_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "ORDER_FACT_ins";
    get_updated  := get_updated  + "ORDER_FACT_upd";
    get_deleted  := get_deleted  + "ORDER_FACT_del";
    get_errors   := get_errors   + "ORDER_FACT_err";

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
get_source_name            CONSTANT VARCHAR2(2000) := '"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB19C33A5678E040007F01006C7D,A41FFB19C33B5678E040007F01006C7D,A41FFB19C3845678E040007F01006C7D';
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

"ORDER_FACT_id" NUMBER(22) := 0;
"ORDER_FACT_ins" NUMBER(22) := 0;
"ORDER_FACT_upd" NUMBER(22) := 0;
"ORDER_FACT_del" NUMBER(22) := 0;
"ORDER_FACT_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"ORDER_FACT_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"ORDER_FACT_ir"  index_redirect_array;
"SV_ORDER_FACT_srk" NUMBER;
"ORDER_FACT_new"  BOOLEAN;
"ORDER_FACT_nul"  BOOLEAN := FALSE;

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


"ORDER_FACT_si" NUMBER(22) := 0;

"ORDER_FACT_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_36_TXFEE_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_ORACLETX_39_ORDERSTA$1" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_ORDER_FACT_36_TXFEE_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_ORDER_FACT_38_BILL_STATUS$1" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_36_TXFEE_ID$1"  VARCHAR2(50);
"SV_ROWKEY_FLTR$1"  VARCHAR2(18);
"SV_ORACLETX_39_ORDERSTA$1"  VARCHAR2(10);
"SV_ORDER_FACT_36_TXFEE_ID$1"  VARCHAR2(50);
"SV_ORDER_FACT_38_BILL_STATUS$1"  VARCHAR2(20);

-- Bulk: intermediate collection variables
"FLTR_36_TXFEE_ID$1" "T_FLTR_36_TXFEE_ID$1";
"ROWKEY_FLTR$1" "T_ROWKEY_FLTR$1";
"ORACLETX_39_ORDERSTA$1" "T_ORACLETX_39_ORDERSTA$1";
"ORDER_FACT_36_TXFEE_ID$1" "T_ORDER_FACT_36_TXFEE_ID$1";
"ORDER_FACT_38_BILL_STATUS$1" "T_ORDER_FACT_38_BILL_STATUS$1";

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
    p_table=>SUBSTR('"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"',0,80),
    p_column=>SUBSTR('FLTR_36_TXFEE_ID',0,80),
    p_value=>SUBSTRB("FLTR_36_TXFEE_ID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"',0,80),
    p_column=>SUBSTR('ORACLETX_39_ORDERSTA',0,80),
    p_value=>SUBSTRB("ORACLETX_39_ORDERSTA$1"(error_index),0,2000),
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
      p_stm=>'TRACE 61: ' || p_statement,
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
    "FLTR_36_TXFEE_ID$1".DELETE;
    "ORACLETX_39_ORDERSTA$1".DELETE;

    FETCH
      "FLTR_c$1"
    BULK COLLECT INTO
      "FLTR_36_TXFEE_ID$1",
      "ORACLETX_39_ORDERSTA$1"
    LIMIT get_bulk_size;

    IF "FLTR_c$1"%NOTFOUND AND "FLTR_36_TXFEE_ID$1".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_36_TXFEE_ID$1".COUNT;
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
    get_map_selected := get_map_selected + "FLTR_36_TXFEE_ID$1".COUNT;
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
          p_stm=>'TRACE 62: SELECT',
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
  "ORDER_FACT_upd0" NUMBER := "ORDER_FACT_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "ORDER_FACT_St" AND (NOT get_use_hc OR get_row_status) 
  AND (NOT (get_use_hc AND "ORDER_FACT_nul")) THEN
    -- Update DML for "ORDER_FACT"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"ORDER_FACT"';
    get_audit_detail_id := "ORDER_FACT_id";
  
    IF get_use_hc AND NOT firstround THEN
      "ORDER_FACT_si" := "ORDER_FACT_ir"(si);
      IF "ORDER_FACT_si" = 0 THEN
        "ORDER_FACT_i" := 0;
      ELSE
        "ORDER_FACT_i" := "ORDER_FACT_si" + 1;
      END IF;
    ELSE
      "ORDER_FACT_si" := 1;
    END IF;
    LOOP
      IF NOT get_use_hc THEN
      EXIT WHEN "ORDER_FACT_i" <= get_bulk_size 
   AND "FLTR_c$1"%FOUND AND NOT get_abort;
      ELSE
        EXIT WHEN "ORDER_FACT_si" >= "ORDER_FACT_i";
      END IF;
  
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "ORDER_FACT_si".."ORDER_FACT_i" - 1
          UPDATE
          /*+ APPEND PARALLEL("ORDER_FACT") */
            "ORDER_FACT"
          SET
  
  					"ORDER_FACT"."BILL_STATUS" = "ORDER_FACT_38_BILL_STATUS$1"
  (i)
  
          WHERE
  
  
  					"ORDER_FACT"."TXFEE_ID" = "ORDER_FACT_36_TXFEE_ID$1"
  (i)
  
          RETURNING ROWID BULK COLLECT INTO get_rowid;
          
        feedback_bulk_limit := "ORDER_FACT_i" - 1;
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "ORDER_FACT_si"..feedback_bulk_limit LOOP
          IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
            IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
              get_rowkey_bulk(rowkey_bulk_index) := "ORDER_FACT_srk"(rowkey_index);
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
  
        "ORDER_FACT_upd" := "ORDER_FACT_upd" + get_rowid.COUNT;
        "ORDER_FACT_si" := "ORDER_FACT_i";
  
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
              FOR rowkey_index IN REVERSE "ORDER_FACT_si".."ORDER_FACT_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "ORDER_FACT_si"..feedback_bulk_limit LOOP
              IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "ORDER_FACT_srk"(rowkey_index);
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
            "ORDER_FACT_upd" := "ORDER_FACT_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "ORDER_FACT_si";
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
              /*+ APPEND PARALLEL("ORDER_FACT") */
                "ORDER_FACT"
              SET
  
  							"ORDER_FACT"."BILL_STATUS" = "ORDER_FACT_38_BILL_STATUS$1"
  (last_successful_index)
  
              WHERE
  
  
  							"ORDER_FACT"."TXFEE_ID" = "ORDER_FACT_36_TXFEE_ID$1"
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
                  error_rowkey := "ORDER_FACT_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"ORDER_FACT"."BILL_STATUS"',0,80),SUBSTRB("ORDER_FACT_38_BILL_STATUS$1"(last_successful_index),0,2000));
                  
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
                "ORDER_FACT_err" := "ORDER_FACT_err" + 1;
                
                IF get_errors + "ORDER_FACT_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "ORDER_FACT_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "ORDER_FACT_si" >= "ORDER_FACT_i" OR get_abort THEN
        "ORDER_FACT_i" := 1;
        EXIT;
      END IF;
    END LOOP;
  END IF;
  IF get_use_hc THEN
    "ORDER_FACT_i" := 1; 
  END IF;
  
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "ORDER_FACT_upd" := "ORDER_FACT_upd0";
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

  IF NOT "ORDER_FACT_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c$1"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "ORDER_FACT_St" THEN
          "ORDER_FACT_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"ORDER_FACT"',
              p_target_uoid=>'A41FFB19C3825678E040007F01006C7D',
              p_stm=>'TRACE 64',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "ORDER_FACT_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C3825678E040007F01006C7D', -- Operator ORDER_FACT
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C1A65678E040007F01006C7D', -- Operator ORDER_FACT_SOURCE
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C33A5678E040007F01006C7D', -- Operator ORDER_FACT_SOURCE
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FFB1913AC5678E040007F01006C7D', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FD395678E040007F01006C7D' -- Location GKDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A74AEE7BE007650EE040007F010059D8', -- Operator ORDER_FACT
              p_parent_object_name=>'ORDER_FACT',
              p_parent_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_parent_object_type=>'Table',
              p_object_name=>'ORDER_FACT',
              p_object_uoid=>'A41FA16DB082655CE040007F01006B9E', -- Table ORDER_FACT
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C3845678E040007F01006C7D', -- Operator ORACLETX_HISTORY
              p_parent_object_name=>'ORACLETX_HISTORY',
              p_parent_object_uoid=>'A41FFB190ABE5678E040007F01006C7D', -- Table ORACLETX_HISTORY
              p_parent_object_type=>'Table',
              p_object_name=>'ORACLETX_HISTORY',
              p_object_uoid=>'A41FFB190ABE5678E040007F01006C7D', -- Table ORACLETX_HISTORY
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19C33B5678E040007F01006C7D', -- Operator EVXEV_TXFEE
              p_parent_object_name=>'EVXEV_TXFEE',
              p_parent_object_uoid=>'A41FFB190D9F5678E040007F01006C7D', -- Table EVXEV_TXFEE
              p_parent_object_type=>'Table',
              p_object_name=>'EVXEV_TXFEE',
              p_object_uoid=>'A41FFB190D9F5678E040007F01006C7D', -- Table EVXEV_TXFEE
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
    "FLTR_si$1" := 0;
    "ORDER_FACT_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU$1";

      LOOP
        IF "FLTR_si$1" = 0 THEN
          "FLTR_RD$1";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_36_TXFEE_ID$1".COUNT - 1;
          ELSE
            bulk_count := "FLTR_36_TXFEE_ID$1".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "ORDER_FACT_ir".DELETE;
"ORDER_FACT_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i$1" := "FLTR_si$1";
        BEGIN
          
          LOOP
            EXIT WHEN "ORDER_FACT_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i$1" := "FLTR_i$1" + 1;
            "FLTR_si$1" := "FLTR_i$1";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "ORDER_FACT_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("FLTR_c$1"%NOTFOUND AND
               "FLTR_i$1" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "FLTR_i$1" > bulk_count THEN
            
              "FLTR_si$1" := 0;
              EXIT;
            END IF;


            
get_target_name := '"ORDER_FACT"';
            get_audit_detail_id := "ORDER_FACT_id";
            IF NOT "ORDER_FACT_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"ORDER_FACT_36_TXFEE_ID$1"("ORDER_FACT_i") := 
            
            "FLTR_36_TXFEE_ID$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ORDER_FACT_36_TXFEE_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_36_TXFEE_ID$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ORDER_FACT_36_TXFEE_ID$1"("ORDER_FACT_i") :=
            
            "FLTR_36_TXFEE_ID$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ORDER_FACT_36_TXFEE_ID$1" :=
            
            "FLTR_36_TXFEE_ID$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"ORDER_FACT_38_BILL_STATUS$1"("ORDER_FACT_i") := 
            
            "ORACLETX_39_ORDERSTA$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"ORDER_FACT_38_BILL_STATUS$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("ORACLETX_39_ORDERSTA$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "ORDER_FACT_38_BILL_STATUS$1"("ORDER_FACT_i") :=
            
            "ORACLETX_39_ORDERSTA$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_ORDER_FACT_38_BILL_STATUS$1" :=
            
            "ORACLETX_39_ORDERSTA$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "ORDER_FACT_srk"("ORDER_FACT_i") := get_rowkey + "FLTR_i$1" - 1;
                  ELSIF get_row_status THEN
                    "SV_ORDER_FACT_srk" := get_rowkey + "FLTR_i$1" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "ORDER_FACT_new" := TRUE;
                ELSE
                  "ORDER_FACT_i" := "ORDER_FACT_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER$1"('TRACE 65: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i$1");
                  
                  "ORDER_FACT_err" := "ORDER_FACT_err" + 1;
                  
                  IF get_errors + "ORDER_FACT_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("ORDER_FACT_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "ORDER_FACT_new" 
            AND (NOT "ORDER_FACT_nul") THEN
              "ORDER_FACT_ir"(dml_bsize) := "ORDER_FACT_i";
            	"ORDER_FACT_36_TXFEE_ID$1"("ORDER_FACT_i") := "SV_ORDER_FACT_36_TXFEE_ID$1";
            	"ORDER_FACT_38_BILL_STATUS$1"("ORDER_FACT_i") := "SV_ORDER_FACT_38_BILL_STATUS$1";
              "ORDER_FACT_srk"("ORDER_FACT_i") := "SV_ORDER_FACT_srk";
              "ORDER_FACT_i" := "ORDER_FACT_i" + 1;
            ELSE
              "ORDER_FACT_ir"(dml_bsize) := 0;
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
            "FLTR_ER$1"('TRACE 63: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i$1");
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
    IF NOT "ORDER_FACT_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"ORDER_FACT_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"ORDER_FACT_ins",
        p_upd=>"ORDER_FACT_upd",
        p_del=>"ORDER_FACT_del",
        p_err=>"ORDER_FACT_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "ORDER_FACT_ins";
    get_updated  := get_updated  + "ORDER_FACT_upd";
    get_deleted  := get_deleted  + "ORDER_FACT_del";
    get_errors   := get_errors   + "ORDER_FACT_err";

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
      p_source=>'"ORDER_FACT","SLXDW"."EVXEV_TXFEE","SLXDW"."ORACLETX_HISTORY"',
      p_source_uoid=>'A41FFB19C33A5678E040007F01006C7D,A41FFB19C33B5678E040007F01006C7D,A41FFB19C3845678E040007F01006C7D',
      p_target=>'"ORDER_FACT"',
      p_target_uoid=>'A41FFB19C3825678E040007F01006C7D',      p_info=>NULL,
      
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
  "ORDER_FACT_St" := FALSE;

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
      "ORDER_FACT_St" := "ORDER_FACT_Bat";
      get_batch_status := get_batch_status AND "ORDER_FACT_St";
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
        "ORDER_FACT_St" := "ORDER_FACT_Bat";
        get_batch_status := get_batch_status AND "ORDER_FACT_St";
      END IF;
    END IF;
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"ORDER_FACT_St" := FALSE;

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
        "ORDER_FACT_St" := "ORDER_FACT_Bat";
        get_batch_status := get_batch_status AND "ORDER_FACT_St";
      END IF;
    END IF;
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"ORDER_FACT_St" := FALSE;

    END IF;
"FLTR_t";

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
  AND    uo.object_name = 'OWB_ORDER_FACT_ORATX_UPD'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_ORDER_FACT_ORATX_UPD', x_schema, x_audit_id, x_object_id);

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



END "OWB_ORDER_FACT_ORATX_UPD";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_ORDER_FACT_ORATX_UPD TO DWHREAD;

