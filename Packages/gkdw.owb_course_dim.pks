DROP PACKAGE GKDW.OWB_COURSE_DIM;

CREATE OR REPLACE PACKAGE GKDW."OWB_COURSE_DIM"  AS
-- Map runtime identification id
OWB$MAP_OBJECT_ID             VARCHAR2(32) := '';

-- Auditing mode constants
AUDIT_NONE                    CONSTANT BINARY_INTEGER := 0;
AUDIT_STATISTICS              CONSTANT BINARY_INTEGER := 1;
AUDIT_ERROR_DETAILS           CONSTANT BINARY_INTEGER := 2;
AUDIT_COMPLETE                CONSTANT BINARY_INTEGER := 3;

-- Operating mode constants
MODE_SET                      CONSTANT BINARY_INTEGER := 0;
MODE_ROW                      CONSTANT BINARY_INTEGER := 1;
MODE_ROW_TARGET               CONSTANT BINARY_INTEGER := 2;
MODE_SET_FAILOVER_ROW         CONSTANT BINARY_INTEGER := 3;
MODE_SET_FAILOVER_ROW_TARGET  CONSTANT BINARY_INTEGER := 4;

-- Variables for auditing
get_runtime_audit_id          NUMBER(22) := 0;
get_audit_detail_id           NUMBER(22) := 0;
get_audit_detail_type_id      NUMBER(22) := 0;
get_audit_level               BINARY_INTEGER := AUDIT_ERROR_DETAILS;
get_cycle_date                CONSTANT DATE := SYSDATE;
get_lob_uoid                  CONSTANT VARCHAR2(40) := 'A41FFB199D6C5678E040007F01006C7D';
get_model_name                CONSTANT VARCHAR2(40) := '"OWB_COURSE_DIM"';
get_purge_group               VARCHAR2(40) := 'WB';
rowkey_counter                NUMBER(22) := 1;

-- Processing variables
get_selected                  NUMBER(22) := 0;
get_inserted                  NUMBER(22) := 0;
get_updated                   NUMBER(22) := 0;
get_deleted                   NUMBER(22) := 0;
get_merged                    NUMBER(22) := 0;
get_errors                    NUMBER(22) := 0;
get_logical_errors            NUMBER(22) := 0;
get_abort                     BOOLEAN    := FALSE;
get_abort_procedure           BOOLEAN    := FALSE; -- Causes the current procedure to be aborted, but not the entire map
get_trigger_success           BOOLEAN    := TRUE;
get_read_success              BOOLEAN    := TRUE;
get_status                    NUMBER(22) := 0;
get_column_seq                NUMBER(22) := 0;

get_processed                 NUMBER(22) := 0;
get_error_ratio               NUMBER(22) := 0;

get_audit_id                  NUMBER(22) := 0;

get_max_errors                NUMBER(22) := 50;
get_commit_frequency          NUMBER(22) := 1000;
get_operating_mode            BINARY_INTEGER := MODE_SET_FAILOVER_ROW;
get_table_function            BOOLEAN := false;
get_global_names              VARCHAR2(10) := 'FALSE';
check_record_cnt              NUMBER(22) := 0;
sql_stmt                      VARCHAR2(32767);
error_stmt                    VARCHAR2(2000);

-- Variable related to TF opertor
owb_temp_variable1       NUMBER(22);

-- Variables related to AW Load
"AWLOADLOAD_clob" clob;
"AWLOADLOAD_str" Varchar2(1000);

---- Begin Variables related to trickle feed maps
-- Variables related to LCR processing
lcr                           SYS.LCR$_ROW_RECORD := null;
lcr_original                  SYS.LCR$_ROW_RECORD := null;
lcr_old_values                SYS.LCR$_ROW_LIST   := null;
lcr_new_values                SYS.LCR$_ROW_LIST   := null;
lcr_new_old_values            SYS.LCR$_ROW_LIST   := null;

-- Variables related to message_event processing
message_event                 SYS.ANYDATA         := null;

-- Variables related to trickle feed auditing and error handling
last_txn_id                   VARCHAR2(22)        := '';
is_session_initialized        BOOLEAN             := false;
last_error_number             NUMBER;
last_error_message            VARCHAR2(2000);
---- End Variables related to trickle feed maps

-- Special variables for controlling map execution
get_use_hc                    BOOLEAN    := FALSE;
get_no_commit                 BOOLEAN    := FALSE;
get_enable_parallel_dml       BOOLEAN    := FALSE;

TYPE a_table_to_analyze_type IS RECORD (
                                  ownname          VARCHAR2(30),
                                  tabname          VARCHAR2(30),
                                  estimate_percent NUMBER,
                                  granularity      VARCHAR2(10),
                                  cascade          BOOLEAN,
                                  degree           NUMBER);
TYPE tables_to_analyze_type IS TABLE OF a_table_to_analyze_type INDEX BY BINARY_INTEGER;
tables_to_analyze  tables_to_analyze_type;
get_rows_processed            BOOLEAN    := FALSE;

-- Buffer usage variables
TYPE t_get_buffer_done     IS TABLE OF BOOLEAN INDEX BY BINARY_INTEGER;
get_buffer_done            t_get_buffer_done;
get_buffer_done_index      BINARY_INTEGER := 1;

-- Bulk processing variables
get_bulk_size                 NATURAL := 1000;
get_bulk_loop_count           NATURAL := NULL;

-- DML Exceptions
checked_table_not_empty       EXCEPTION;
PRAGMA EXCEPTION_INIT(checked_table_not_empty, -111);
invalid_dml                   EXCEPTION;
PRAGMA EXCEPTION_INIT(invalid_dml, -112);

-- Status variable for Batch cursors
"COURSE_DIM_St" Boolean;


-- Variables: user-defined variables via mapping Variable components,
--            and package global storage for user-defined mapping input parameters
"CONST_0_TABLE_NAME" VARCHAR2(30) := 'COURSE_DIM';
"CONST_1_SOURCE" VARCHAR2(20) := 'SLXDW';
"CONST_2_ORGANIZATION_ID" NUMBER := 88;
"CONST_3_INVOICEABLE_ITEM_FLAG" VARCHAR2(1) := 'Y';
"CONST_4_CH_FLEX_VALUE_SET_ID" NUMBER := 1007697;
"CONST_5_MD_FLEX_VALUE_SET_ID" NUMBER := 1007698;
"CONST_6_PL_FLEX_VALUE_SET_ID" NUMBER := 1007699;
"PREMAPPING_1_CREATE_DATE_OUT" DATE;
"PREMAPPING_2_MODIFY_DATE_OUT" DATE;

-- Access functions for user-defined variables via mapping Variable components,
--            and package global storage for user-defined mapping input parameters
FUNCTION "GET_CONST_0_TABLE_NAME" RETURN VARCHAR2;
FUNCTION "GET_CONST_1_SOURCE" RETURN VARCHAR2;
FUNCTION "GET_CONST_2_ORGANIZATION_ID" RETURN NUMBER;
FUNCTION "GET_CONST_3_INVOICEABLE_ITEM_" RETURN VARCHAR2;
FUNCTION "GET_CONST_4_CH_FLEX_VALUE_SET_" RETURN NUMBER;
FUNCTION "GET_CONST_5_MD_FLEX_VALUE_SET_" RETURN NUMBER;
FUNCTION "GET_CONST_6_PL_FLEX_VALUE_SET_" RETURN NUMBER;
FUNCTION "get_PREMAPPING_1_CREATE_DATE_O" RETURN DATE;
FUNCTION "get_PREMAPPING_2_MODIFY_DATE_O" RETURN DATE;

-- Package global declarations





-- Function Main -- Entry point in package "OWB_COURSE_DIM"
--------------------------------------------------
-- Function Main: Should only be called by OWB. --
--------------------------------------------------

FUNCTION Main(p_env IN WB_RT_MAPAUDIT.WB_RT_NAME_VALUES)  RETURN NUMBER;  

-- Close cursors procedure:
PROCEDURE Close_Cursors;

-------------------------------------------------
-- Procedure Main:                             --
-- 1. An entry point for this map.             --
-- 2. Can be called by OWB user from SQL*Plus  -- 
--    or from user applications.               --
-- 3. This procedure can run even when the     --
--    runtime service is not running.          -- 
-------------------------------------------------
PROCEDURE Main(p_status OUT VARCHAR2,
               p_max_no_of_errors IN VARCHAR2 DEFAULT NULL,
               p_commit_frequency IN VARCHAR2 DEFAULT NULL,
               p_operating_mode   IN VARCHAR2 DEFAULT NULL,
               p_bulk_size        IN VARCHAR2 DEFAULT NULL,
               p_audit_level      IN VARCHAR2 DEFAULT NULL,
               p_purge_group      IN VARCHAR2 DEFAULT NULL);



END "OWB_COURSE_DIM";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_COURSE_DIM TO DWHREAD;

