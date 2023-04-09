DROP PACKAGE BODY GKDW.OWB_PRODUCT_DIM;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_PRODUCT_DIM" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "JOIN_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "JOIN_c" IS
  SELECT
  "PRODUCT"."PRODUCTID" "PRODUCTID",
  "PRODUCT"."PRODUCT_NAME" "PRODUCT_NAME",
  "PRODUCT"."DESCRIPTION" "DESCRIPTION",
  "PRODUCT"."ACTUALID" "ACTUALID",
  "PRODUCT"."FAMILY" "FAMILY",
  "PRODUCTPROGRAM"."PP_PRICE" "PP_PRICE",
  "PRODUCT"."CREATEDATE" "CREATEDATE",
  "PRODUCT"."CREATEUSER" "CREATEUSER",
  "PRODUCT"."MODIFYDATE" "MODIFYDATE",
  "PRODUCT"."MODIFYUSER" "MODIFYUSER",
  "PRODUCT"."PRODUCTGROUP" "PRODUCTGROUP",
  "PRODUCT"."STATUS" "STATUS",
  "PRODUCT"."GLACCOUNTNUMBER" "GLACCOUNTNUMBER",
  "PRODUCTPROGRAM"."PP_CREATEDATE" "PP_CREATEDATE",
  "PRODUCTPROGRAM"."PP_MODIFYDATE" "PP_MODIFYDATE"
FROM
    "SLXDW"."PRODUCT"  "PRODUCT"   
 LEFT OUTER JOIN  ( SELECT
  "PRODUCTPROGRAM"."PRODUCTPROGRAMID" "PRODUCTPROGRAMID",
  "PRODUCTPROGRAM"."PRODUCTID" "PP_PRODUCTID",
  "PRODUCTPROGRAM"."CREATEUSER" "PP_CREATEUSER",
  "PRODUCTPROGRAM"."CREATEDATE" "PP_CREATEDATE",
  "PRODUCTPROGRAM"."MODIFYUSER" "PP_MODIFYUSER",
  "PRODUCTPROGRAM"."MODIFYDATE" "PP_MODIFYDATE",
  "PRODUCTPROGRAM"."PROGRAM" "PP_PROGRAM",
  "PRODUCTPROGRAM"."PRICE" "PP_PRICE",
  "PRODUCTPROGRAM"."DEFAULTPROGRAM" "PP_DEFAULTPROGRAM",
  "PRODUCTPROGRAM"."EVX_CURRENCYTYPE" "PP_EVX_CURRENCYTYPE"
FROM
  "SLXDW"."PRODUCTPROGRAM" "PRODUCTPROGRAM" ) "PRODUCTPROGRAM" ON ( ( "PRODUCT"."PRODUCTID" = "PRODUCTPROGRAM"."PP_PRODUCTID" ) )
  WHERE 
  ( "PRODUCTPROGRAM"."PP_DEFAULTPROGRAM" = 'T' And "PRODUCTPROGRAM"."PP_EVX_CURRENCYTYPE" = 'USD' ); 

---------------------------------------------------------------------------
--
-- "FLTR_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c" IS
  SELECT
  "LOOKUP_INPUT_SUBQUERY"."ACTUALID" "ACTUALID",
  "LOOKUP_INPUT_SUBQUERY"."PRODUCT_NAME" "PRODUCT_NAME",
  "LOOKUP_INPUT_SUBQUERY"."FAMILY" "FAMILY",
  "LOOKUP_INPUT_SUBQUERY"."PRICE" "PRICE",
  "LOOKUP_INPUT_SUBQUERY"."CREATEDATE" "CREATEDATE",
  "LOOKUP_INPUT_SUBQUERY"."MODIFYDATE" "MODIFYDATE",
  "LOOKUP_INPUT_SUBQUERY"."PRODUCTID" "PRODUCTID",
  "LOOKUP_INPUT_SUBQUERY"."STATUS" "STATUS"
FROM
  (SELECT
  "PRODUCT"."PRODUCTID" "PRODUCTID",
  "PRODUCT"."PRODUCT_NAME" "PRODUCT_NAME",
  "PRODUCT"."DESCRIPTION" "DESCRIPTION",
  "PRODUCT"."ACTUALID" "ACTUALID",
  "PRODUCT"."FAMILY" "FAMILY",
  "PRODUCTPROGRAM"."PP_PRICE" "PRICE",
  "PRODUCT"."CREATEDATE" "CREATEDATE",
  "PRODUCT"."CREATEUSER" "CREATEUSER",
  "PRODUCT"."MODIFYDATE" "MODIFYDATE",
  "PRODUCT"."MODIFYUSER" "MODIFYUSER",
  "PRODUCT"."PRODUCTGROUP" "PRODUCTGROUP",
  "PRODUCT"."STATUS" "STATUS",
  "PRODUCT"."GLACCOUNTNUMBER" "GLACCOUNTNUMBER",
  "OWB_PRODUCT_DIM"."PREMAPPING_1_CREATE_DATE_OUT" "CREATE_DATE_OUT",
  "OWB_PRODUCT_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" "MODIFY_DATE_OUT",
  "PRODUCTPROGRAM"."PP_CREATEDATE" "PP_CREATEDATE",
  "PRODUCTPROGRAM"."PP_MODIFYDATE" "PP_MODIFYDATE"
FROM
    "SLXDW"."PRODUCT"  "PRODUCT"   
 LEFT OUTER JOIN  ( SELECT
  "PRODUCTPROGRAM"."PRODUCTPROGRAMID" "PRODUCTPROGRAMID",
  "PRODUCTPROGRAM"."PRODUCTID" "PP_PRODUCTID",
  "PRODUCTPROGRAM"."CREATEUSER" "PP_CREATEUSER",
  "PRODUCTPROGRAM"."CREATEDATE" "PP_CREATEDATE",
  "PRODUCTPROGRAM"."MODIFYUSER" "PP_MODIFYUSER",
  "PRODUCTPROGRAM"."MODIFYDATE" "PP_MODIFYDATE",
  "PRODUCTPROGRAM"."PROGRAM" "PP_PROGRAM",
  "PRODUCTPROGRAM"."PRICE" "PP_PRICE",
  "PRODUCTPROGRAM"."DEFAULTPROGRAM" "PP_DEFAULTPROGRAM",
  "PRODUCTPROGRAM"."EVX_CURRENCYTYPE" "PP_EVX_CURRENCYTYPE"
FROM
  "SLXDW"."PRODUCTPROGRAM" "PRODUCTPROGRAM" ) "PRODUCTPROGRAM" ON ( ( "PRODUCT"."PRODUCTID" = "PRODUCTPROGRAM"."PP_PRODUCTID" ) )
  WHERE 
  ( "PRODUCTPROGRAM"."PP_DEFAULTPROGRAM" = 'T' And "PRODUCTPROGRAM"."PP_EVX_CURRENCYTYPE" = 'USD' )) "LOOKUP_INPUT_SUBQUERY"
  WHERE 
  ( ( "LOOKUP_INPUT_SUBQUERY"."CREATEDATE" >= "LOOKUP_INPUT_SUBQUERY"."CREATE_DATE_OUT" or "LOOKUP_INPUT_SUBQUERY"."MODIFYDATE" >= "LOOKUP_INPUT_SUBQUERY"."MODIFY_DATE_OUT" ) Or ( "LOOKUP_INPUT_SUBQUERY"."PP_CREATEDATE" >= "LOOKUP_INPUT_SUBQUERY"."CREATE_DATE_OUT" Or "LOOKUP_INPUT_SUBQUERY"."PP_MODIFYDATE" >= "LOOKUP_INPUT_SUBQUERY"."MODIFY_DATE_OUT" ) ); 


a_table_to_analyze a_table_to_analyze_type;


PROCEDURE EXEC_AUTONOMOUS_SQL(CMD IN VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  EXECUTE IMMEDIATE (CMD);
  COMMIT;
END;

-- Access functions for user-defined variables via mapping Variable components,
--            and package global storage for user-defined mapping input parameters
FUNCTION "GET_CONST_0_CH_FLEX_VALUE_SET_" RETURN NUMBER IS
BEGIN
  RETURN "CONST_0_CH_FLEX_VALUE_SET_ID";
END "GET_CONST_0_CH_FLEX_VALUE_SET_";
FUNCTION "GET_CONST_1_MD_FLEX_VALUE_SET_" RETURN NUMBER IS
BEGIN
  RETURN "CONST_1_MD_FLEX_VALUE_SET_ID";
END "GET_CONST_1_MD_FLEX_VALUE_SET_";
FUNCTION "GET_CONST_2_TABLE_NAME" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_2_TABLE_NAME";
END "GET_CONST_2_TABLE_NAME";
FUNCTION "GET_CONST_3_ORGANIZATION_ID" RETURN NUMBER IS
BEGIN
  RETURN "CONST_3_ORGANIZATION_ID";
END "GET_CONST_3_ORGANIZATION_ID";
FUNCTION "GET_CONST_4_INVOICEABLE_ITEM_" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_4_INVOICEABLE_ITEM_FLAG";
END "GET_CONST_4_INVOICEABLE_ITEM_";
FUNCTION "GET_CONST_5_PL_FLEX_VALUE_SET_" RETURN NUMBER IS
BEGIN
  RETURN "CONST_5_PL_FLEX_VALUE_SET_ID";
END "GET_CONST_5_PL_FLEX_VALUE_SET_";
FUNCTION "GET_CONST_6_COUNTRY" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_6_COUNTRY";
END "GET_CONST_6_COUNTRY";
FUNCTION "GET_CONST_7_GKDW_SOURCE" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_7_GKDW_SOURCE";
END "GET_CONST_7_GKDW_SOURCE";
FUNCTION "get_PREMAPPING_1_CREATE_DATE_O" RETURN DATE IS
BEGIN
  RETURN "PREMAPPING_1_CREATE_DATE_OUT";
END "get_PREMAPPING_1_CREATE_DATE_O";
FUNCTION "get_PREMAPPING_2_MODIFY_DATE_O" RETURN DATE IS
BEGIN
  RETURN "PREMAPPING_2_MODIFY_DATE_OUT";
END "get_PREMAPPING_2_MODIFY_DATE_O";





-- Procedure "JOIN_p" is the entry point for map "JOIN_p"

PROCEDURE "JOIN_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"JOIN_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB19A95E5678E040007F01006C7D';
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

"PRODUCT_DIM_id" NUMBER(22) := 0;
"PRODUCT_DIM_ins" NUMBER(22) := 0;
"PRODUCT_DIM_upd" NUMBER(22) := 0;
"PRODUCT_DIM_del" NUMBER(22) := 0;
"PRODUCT_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"PRODUCT_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"PRODUCT_DIM_ir"  index_redirect_array;
"SV_PRODUCT_DIM_srk" NUMBER;
"PRODUCT_DIM_new"  BOOLEAN;
"PRODUCT_DIM_nul"  BOOLEAN := FALSE;

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

"JOIN_si" NUMBER(22) := 0;

"JOIN_i" NUMBER(22) := 0;


"PRODUCT_DIM_si" NUMBER(22) := 0;

"PRODUCT_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_JOIN_23_PRODUCTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_JOIN" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_24_PRODUCT_NAME" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_25_DESCRIPTION" IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_26_ACTUALID" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_27_FAMILY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_43_PP_PRICE" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_29_CREATEDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_30_CREATEUSER" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_31_MODIFYDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_32_MODIFYUSER" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_33_PRODUCTGROUP" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_34_STATUS" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_35_GLACCOUNTNUMBER" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_39_PP_CREATEDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_JOIN_41_PP_MODIFYDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_GET_ORAC_2_INVENTOR" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_CH_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_MD_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_PL_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_2_ITEM_NUM" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_3_LE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_4_FE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_5_CH_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_6_MD_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_7_PL_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_8_ACT_NUM_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_0_ITEM_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_1_PROD_NUM" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_2_PROD_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_3_PROD_CHANNEL" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_4_PROD_MODALITY" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_5_PROD_LINE" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_6_PROD_FAMILY" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_7_LIST_PRICE" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_8_ORACLE_ITEM_N" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_9_CREATION_DATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT__10_LAST_UPD" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_15_GKDW_SOURCE" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_17_PRODUCT_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_18_LE_NUM" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_19_FE_NUM" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_20_CH_NUM" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_21_MD_NUM" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_22_PL_NUM" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_23_ACT_NUM" IS TABLE OF VARCHAR2(6) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_24_STATUS" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_JOIN_23_PRODUCTID"  CHAR(12);
"SV_ROWKEY_JOIN"  VARCHAR2(18);
"SV_JOIN_24_PRODUCT_NAME"  VARCHAR2(64);
"SV_JOIN_25_DESCRIPTION"  VARCHAR2(255);
"SV_JOIN_26_ACTUALID"  VARCHAR2(64);
"SV_JOIN_27_FAMILY"  VARCHAR2(32);
"SV_JOIN_43_PP_PRICE"  NUMBER;
"SV_JOIN_29_CREATEDATE"  DATE;
"SV_JOIN_30_CREATEUSER"  CHAR(12);
"SV_JOIN_31_MODIFYDATE"  DATE;
"SV_JOIN_32_MODIFYUSER"  CHAR(12);
"SV_JOIN_33_PRODUCTGROUP"  VARCHAR2(64);
"SV_JOIN_34_STATUS"  VARCHAR2(64);
"SV_JOIN_35_GLACCOUNTNUMBER"  VARCHAR2(10);
"SV_JOIN_39_PP_CREATEDATE"  DATE;
"SV_JOIN_41_PP_MODIFYDATE"  DATE;
"SV_GET_ORAC_2_INVENTOR"  NUMBER;
"SV_GET_FLEX_3_CH_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_MD_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_PL_FLEX_"  VARCHAR2(32767);
"SV_GET_ITEM_2_ITEM_NUM"  VARCHAR2(32767);
"SV_GET_ITEM_3_LE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_4_FE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_5_CH_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_6_MD_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_7_PL_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_8_ACT_NUM_"  VARCHAR2(32767);
"SV_PRODUCT_DIM_0_ITEM_ID"  VARCHAR2(50);
"SV_PRODUCT_DIM_1_PROD_NUM"  VARCHAR2(100);
"SV_PRODUCT_DIM_2_PROD_NAME"  VARCHAR2(250);
"SV_PRODUCT_DIM_3_PROD_CHANNEL"  VARCHAR2(250);
"SV_PRODUCT_DIM_4_PROD_MODALITY"  VARCHAR2(250);
"SV_PRODUCT_DIM_5_PROD_LINE"  VARCHAR2(250);
"SV_PRODUCT_DIM_6_PROD_FAMILY"  VARCHAR2(250);
"SV_PRODUCT_DIM_7_LIST_PRICE"  NUMBER;
"SV_PRODUCT_DIM_8_ORACLE_ITEM_N"  VARCHAR2(50);
"SV_PRODUCT_DIM_9_CREATION_DATE"  DATE;
"SV_PRODUCT__10_LAST_UPD"  DATE;
"SV_PRODUCT_DIM_15_GKDW_SOURCE"  VARCHAR2(20);
"SV_PRODUCT_DIM_17_PRODUCT_ID"  VARCHAR2(50);
"SV_PRODUCT_DIM_18_LE_NUM"  VARCHAR2(3);
"SV_PRODUCT_DIM_19_FE_NUM"  VARCHAR2(3);
"SV_PRODUCT_DIM_20_CH_NUM"  VARCHAR2(2);
"SV_PRODUCT_DIM_21_MD_NUM"  VARCHAR2(2);
"SV_PRODUCT_DIM_22_PL_NUM"  VARCHAR2(2);
"SV_PRODUCT_DIM_23_ACT_NUM"  VARCHAR2(6);
"SV_PRODUCT_DIM_24_STATUS"  VARCHAR2(64);

-- Bulk: intermediate collection variables
"JOIN_23_PRODUCTID" "T_JOIN_23_PRODUCTID";
"ROWKEY_JOIN" "T_ROWKEY_JOIN";
"JOIN_24_PRODUCT_NAME" "T_JOIN_24_PRODUCT_NAME";
"JOIN_25_DESCRIPTION" "T_JOIN_25_DESCRIPTION";
"JOIN_26_ACTUALID" "T_JOIN_26_ACTUALID";
"JOIN_27_FAMILY" "T_JOIN_27_FAMILY";
"JOIN_43_PP_PRICE" "T_JOIN_43_PP_PRICE";
"JOIN_29_CREATEDATE" "T_JOIN_29_CREATEDATE";
"JOIN_30_CREATEUSER" "T_JOIN_30_CREATEUSER";
"JOIN_31_MODIFYDATE" "T_JOIN_31_MODIFYDATE";
"JOIN_32_MODIFYUSER" "T_JOIN_32_MODIFYUSER";
"JOIN_33_PRODUCTGROUP" "T_JOIN_33_PRODUCTGROUP";
"JOIN_34_STATUS" "T_JOIN_34_STATUS";
"JOIN_35_GLACCOUNTNUMBER" "T_JOIN_35_GLACCOUNTNUMBER";
"JOIN_39_PP_CREATEDATE" "T_JOIN_39_PP_CREATEDATE";
"JOIN_41_PP_MODIFYDATE" "T_JOIN_41_PP_MODIFYDATE";
"GET_ORAC_2_INVENTOR" "T_GET_ORAC_2_INVENTOR";
"GET_FLEX_3_CH_FLEX_" "T_GET_FLEX_3_CH_FLEX_";
"GET_FLEX_3_MD_FLEX_" "T_GET_FLEX_3_MD_FLEX_";
"GET_FLEX_3_PL_FLEX_" "T_GET_FLEX_3_PL_FLEX_";
"GET_ITEM_2_ITEM_NUM" "T_GET_ITEM_2_ITEM_NUM";
"GET_ITEM_3_LE_NUM_O" "T_GET_ITEM_3_LE_NUM_O";
"GET_ITEM_4_FE_NUM_O" "T_GET_ITEM_4_FE_NUM_O";
"GET_ITEM_5_CH_NUM_O" "T_GET_ITEM_5_CH_NUM_O";
"GET_ITEM_6_MD_NUM_O" "T_GET_ITEM_6_MD_NUM_O";
"GET_ITEM_7_PL_NUM_O" "T_GET_ITEM_7_PL_NUM_O";
"GET_ITEM_8_ACT_NUM_" "T_GET_ITEM_8_ACT_NUM_";
"PRODUCT_DIM_0_ITEM_ID" "T_PRODUCT_DIM_0_ITEM_ID";
"PRODUCT_DIM_1_PROD_NUM" "T_PRODUCT_DIM_1_PROD_NUM";
"PRODUCT_DIM_2_PROD_NAME" "T_PRODUCT_DIM_2_PROD_NAME";
"PRODUCT_DIM_3_PROD_CHANNEL" "T_PRODUCT_DIM_3_PROD_CHANNEL";
"PRODUCT_DIM_4_PROD_MODALITY" "T_PRODUCT_DIM_4_PROD_MODALITY";
"PRODUCT_DIM_5_PROD_LINE" "T_PRODUCT_DIM_5_PROD_LINE";
"PRODUCT_DIM_6_PROD_FAMILY" "T_PRODUCT_DIM_6_PROD_FAMILY";
"PRODUCT_DIM_7_LIST_PRICE" "T_PRODUCT_DIM_7_LIST_PRICE";
"PRODUCT_DIM_8_ORACLE_ITEM_NUM" "T_PRODUCT_DIM_8_ORACLE_ITEM_N";
"PRODUCT_DIM_9_CREATION_DATE" "T_PRODUCT_DIM_9_CREATION_DATE";
"PRODUCT__10_LAST_UPD" "T_PRODUCT__10_LAST_UPD";
"PRODUCT_DIM_15_GKDW_SOURCE" "T_PRODUCT_DIM_15_GKDW_SOURCE";
"PRODUCT_DIM_17_PRODUCT_ID" "T_PRODUCT_DIM_17_PRODUCT_ID";
"PRODUCT_DIM_18_LE_NUM" "T_PRODUCT_DIM_18_LE_NUM";
"PRODUCT_DIM_19_FE_NUM" "T_PRODUCT_DIM_19_FE_NUM";
"PRODUCT_DIM_20_CH_NUM" "T_PRODUCT_DIM_20_CH_NUM";
"PRODUCT_DIM_21_MD_NUM" "T_PRODUCT_DIM_21_MD_NUM";
"PRODUCT_DIM_22_PL_NUM" "T_PRODUCT_DIM_22_PL_NUM";
"PRODUCT_DIM_23_ACT_NUM" "T_PRODUCT_DIM_23_ACT_NUM";
"PRODUCT_DIM_24_STATUS" "T_PRODUCT_DIM_24_STATUS";

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
PROCEDURE "JOIN_ES"(error_index IN NUMBER) IS
BEGIN

  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>1,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_23_PRODUCTID',0,80),
    p_value=>SUBSTRB("JOIN_23_PRODUCTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_24_PRODUCT_NAME',0,80),
    p_value=>SUBSTRB("JOIN_24_PRODUCT_NAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_25_DESCRIPTION',0,80),
    p_value=>SUBSTRB("JOIN_25_DESCRIPTION"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_26_ACTUALID',0,80),
    p_value=>SUBSTRB("JOIN_26_ACTUALID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_27_FAMILY',0,80),
    p_value=>SUBSTRB("JOIN_27_FAMILY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_43_PP_PRICE',0,80),
    p_value=>SUBSTRB("JOIN_43_PP_PRICE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_29_CREATEDATE',0,80),
    p_value=>SUBSTRB("JOIN_29_CREATEDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_30_CREATEUSER',0,80),
    p_value=>SUBSTRB("JOIN_30_CREATEUSER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_31_MODIFYDATE',0,80),
    p_value=>SUBSTRB("JOIN_31_MODIFYDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_32_MODIFYUSER',0,80),
    p_value=>SUBSTRB("JOIN_32_MODIFYUSER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_33_PRODUCTGROUP',0,80),
    p_value=>SUBSTRB("JOIN_33_PRODUCTGROUP"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_34_STATUS',0,80),
    p_value=>SUBSTRB("JOIN_34_STATUS"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_35_GLACCOUNTNUMBER',0,80),
    p_value=>SUBSTRB("JOIN_35_GLACCOUNTNUMBER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_39_PP_CREATEDATE',0,80),
    p_value=>SUBSTRB("JOIN_39_PP_CREATEDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>15,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('JOIN_41_PP_MODIFYDATE',0,80),
    p_value=>SUBSTRB("JOIN_41_PP_MODIFYDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  RETURN;
    
  END "JOIN_ES";

---------------------------------------------------------------------------
-- Procedure "JOIN_ER" registers error for one erroneous row
---------------------------------------------------------------------------
PROCEDURE "JOIN_ER"(p_statement IN VARCHAR2, p_column IN VARCHAR2, p_col_value IN VARCHAR2, p_sqlcode IN NUMBER, p_sqlerrm IN VARCHAR2, p_auditd_id IN NUMBER, p_error_index IN NUMBER) IS
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
      p_stm=>'TRACE 148: ' || p_statement,
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
    "JOIN_ES"(p_error_index);
  END IF;
END "JOIN_ER";



---------------------------------------------------------------------------
-- Procedure "JOIN_SU" opens and initializes data source
-- for map "JOIN_p"
---------------------------------------------------------------------------
PROCEDURE "JOIN_SU" IS
BEGIN
  IF get_abort THEN
    RETURN;
  END IF;
  IF (NOT "JOIN_c"%ISOPEN) THEN
    OPEN "JOIN_c";
  END IF;
  get_read_success := TRUE;
END "JOIN_SU";

---------------------------------------------------------------------------
-- Procedure "JOIN_RD" fetches a bulk of rows from
--   the data source for map "JOIN_p"
---------------------------------------------------------------------------
PROCEDURE "JOIN_RD" IS
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
    "JOIN_23_PRODUCTID".DELETE;
    "JOIN_24_PRODUCT_NAME".DELETE;
    "JOIN_25_DESCRIPTION".DELETE;
    "JOIN_26_ACTUALID".DELETE;
    "JOIN_27_FAMILY".DELETE;
    "JOIN_43_PP_PRICE".DELETE;
    "JOIN_29_CREATEDATE".DELETE;
    "JOIN_30_CREATEUSER".DELETE;
    "JOIN_31_MODIFYDATE".DELETE;
    "JOIN_32_MODIFYUSER".DELETE;
    "JOIN_33_PRODUCTGROUP".DELETE;
    "JOIN_34_STATUS".DELETE;
    "JOIN_35_GLACCOUNTNUMBER".DELETE;
    "JOIN_39_PP_CREATEDATE".DELETE;
    "JOIN_41_PP_MODIFYDATE".DELETE;

    FETCH
      "JOIN_c"
    BULK COLLECT INTO
      "JOIN_23_PRODUCTID",
      "JOIN_24_PRODUCT_NAME",
      "JOIN_25_DESCRIPTION",
      "JOIN_26_ACTUALID",
      "JOIN_27_FAMILY",
      "JOIN_43_PP_PRICE",
      "JOIN_29_CREATEDATE",
      "JOIN_30_CREATEUSER",
      "JOIN_31_MODIFYDATE",
      "JOIN_32_MODIFYUSER",
      "JOIN_33_PRODUCTGROUP",
      "JOIN_34_STATUS",
      "JOIN_35_GLACCOUNTNUMBER",
      "JOIN_39_PP_CREATEDATE",
      "JOIN_41_PP_MODIFYDATE"
    LIMIT get_bulk_size;

    IF "JOIN_c"%NOTFOUND AND "JOIN_23_PRODUCTID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "JOIN_23_PRODUCTID".COUNT;
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
    get_map_selected := get_map_selected + "JOIN_23_PRODUCTID".COUNT;
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
          p_stm=>'TRACE 149: SELECT',
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
END "JOIN_RD";

---------------------------------------------------------------------------
-- Procedure "JOIN_DML" does DML for a bulk of rows starting from index si.
---------------------------------------------------------------------------
PROCEDURE "JOIN_DML"(si NUMBER, firstround BOOLEAN) IS
  "PRODUCT_DIM_ins0" NUMBER := "PRODUCT_DIM_ins";
  "PRODUCT_DIM_upd0" NUMBER := "PRODUCT_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "PRODUCT_DIM_St" THEN
  -- Update/Insert DML for "PRODUCT_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"PRODUCT_DIM"';
    get_audit_detail_id := "PRODUCT_DIM_id";
    "PRODUCT_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "PRODUCT_DIM_i" > get_bulk_size 
   OR "JOIN_c"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "PRODUCT_DIM_si".."PRODUCT_DIM_i" - 1 
            UPDATE
              "PRODUCT_DIM"
            SET
  
  						"PRODUCT_DIM"."ITEM_ID" = "PRODUCT_DIM_0_ITEM_ID"
  (i),						"PRODUCT_DIM"."PROD_NUM" = "PRODUCT_DIM_1_PROD_NUM"
  (i),						"PRODUCT_DIM"."PROD_NAME" = "PRODUCT_DIM_2_PROD_NAME"
  (i),						"PRODUCT_DIM"."PROD_CHANNEL" = "PRODUCT_DIM_3_PROD_CHANNEL"
  (i),						"PRODUCT_DIM"."PROD_MODALITY" = "PRODUCT_DIM_4_PROD_MODALITY"
  (i),						"PRODUCT_DIM"."PROD_LINE" = "PRODUCT_DIM_5_PROD_LINE"
  (i),						"PRODUCT_DIM"."PROD_FAMILY" = "PRODUCT_DIM_6_PROD_FAMILY"
  (i),						"PRODUCT_DIM"."LIST_PRICE" = "PRODUCT_DIM_7_LIST_PRICE"
  (i),						"PRODUCT_DIM"."ORACLE_ITEM_NUM" = "PRODUCT_DIM_8_ORACLE_ITEM_NUM"
  (i),						"PRODUCT_DIM"."CREATION_DATE" = "PRODUCT_DIM_9_CREATION_DATE"
  (i),						"PRODUCT_DIM"."LAST_UPDATE_DATE" = "PRODUCT__10_LAST_UPD"
  (i),						"PRODUCT_DIM"."GKDW_SOURCE" = "PRODUCT_DIM_15_GKDW_SOURCE"
  (i),						"PRODUCT_DIM"."LE_NUM" = "PRODUCT_DIM_18_LE_NUM"
  (i),						"PRODUCT_DIM"."FE_NUM" = "PRODUCT_DIM_19_FE_NUM"
  (i),						"PRODUCT_DIM"."CH_NUM" = "PRODUCT_DIM_20_CH_NUM"
  (i),						"PRODUCT_DIM"."MD_NUM" = "PRODUCT_DIM_21_MD_NUM"
  (i),						"PRODUCT_DIM"."PL_NUM" = "PRODUCT_DIM_22_PL_NUM"
  (i),						"PRODUCT_DIM"."ACT_NUM" = "PRODUCT_DIM_23_ACT_NUM"
  (i),						"PRODUCT_DIM"."STATUS" = "PRODUCT_DIM_24_STATUS"
  (i)
    
            WHERE
  
  						"PRODUCT_DIM"."PRODUCT_ID" = "PRODUCT_DIM_17_PRODUCT_ID"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "PRODUCT_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "PRODUCT_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "PRODUCT_DIM_srk"(rowkey_index);
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
  
          "PRODUCT_DIM_upd" := "PRODUCT_DIM_upd" + get_rowid.COUNT;
          "PRODUCT_DIM_si" := "PRODUCT_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "PRODUCT_DIM_si".."PRODUCT_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "PRODUCT_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "PRODUCT_DIM_srk"(rowkey_index);
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
            "PRODUCT_DIM_upd" := "PRODUCT_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "PRODUCT_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                  "PRODUCT_DIM"
                SET
  
  								"PRODUCT_DIM"."ITEM_ID" = "PRODUCT_DIM_0_ITEM_ID"
  (last_successful_index),								"PRODUCT_DIM"."PROD_NUM" = "PRODUCT_DIM_1_PROD_NUM"
  (last_successful_index),								"PRODUCT_DIM"."PROD_NAME" = "PRODUCT_DIM_2_PROD_NAME"
  (last_successful_index),								"PRODUCT_DIM"."PROD_CHANNEL" = "PRODUCT_DIM_3_PROD_CHANNEL"
  (last_successful_index),								"PRODUCT_DIM"."PROD_MODALITY" = "PRODUCT_DIM_4_PROD_MODALITY"
  (last_successful_index),								"PRODUCT_DIM"."PROD_LINE" = "PRODUCT_DIM_5_PROD_LINE"
  (last_successful_index),								"PRODUCT_DIM"."PROD_FAMILY" = "PRODUCT_DIM_6_PROD_FAMILY"
  (last_successful_index),								"PRODUCT_DIM"."LIST_PRICE" = "PRODUCT_DIM_7_LIST_PRICE"
  (last_successful_index),								"PRODUCT_DIM"."ORACLE_ITEM_NUM" = "PRODUCT_DIM_8_ORACLE_ITEM_NUM"
  (last_successful_index),								"PRODUCT_DIM"."CREATION_DATE" = "PRODUCT_DIM_9_CREATION_DATE"
  (last_successful_index),								"PRODUCT_DIM"."LAST_UPDATE_DATE" = "PRODUCT__10_LAST_UPD"
  (last_successful_index),								"PRODUCT_DIM"."GKDW_SOURCE" = "PRODUCT_DIM_15_GKDW_SOURCE"
  (last_successful_index),								"PRODUCT_DIM"."LE_NUM" = "PRODUCT_DIM_18_LE_NUM"
  (last_successful_index),								"PRODUCT_DIM"."FE_NUM" = "PRODUCT_DIM_19_FE_NUM"
  (last_successful_index),								"PRODUCT_DIM"."CH_NUM" = "PRODUCT_DIM_20_CH_NUM"
  (last_successful_index),								"PRODUCT_DIM"."MD_NUM" = "PRODUCT_DIM_21_MD_NUM"
  (last_successful_index),								"PRODUCT_DIM"."PL_NUM" = "PRODUCT_DIM_22_PL_NUM"
  (last_successful_index),								"PRODUCT_DIM"."ACT_NUM" = "PRODUCT_DIM_23_ACT_NUM"
  (last_successful_index),								"PRODUCT_DIM"."STATUS" = "PRODUCT_DIM_24_STATUS"
  (last_successful_index)
  
                WHERE
  
  								"PRODUCT_DIM"."PRODUCT_ID" = "PRODUCT_DIM_17_PRODUCT_ID"
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
                  error_rowkey := "PRODUCT_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ITEM_ID"',0,80),SUBSTRB("PRODUCT_DIM_0_ITEM_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_1_PROD_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NAME"',0,80),SUBSTRB("PRODUCT_DIM_2_PROD_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_CHANNEL"',0,80),SUBSTRB("PRODUCT_DIM_3_PROD_CHANNEL"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_MODALITY"',0,80),SUBSTRB("PRODUCT_DIM_4_PROD_MODALITY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_LINE"',0,80),SUBSTRB("PRODUCT_DIM_5_PROD_LINE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_FAMILY"',0,80),SUBSTRB("PRODUCT_DIM_6_PROD_FAMILY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LIST_PRICE"',0,80),SUBSTRB("PRODUCT_DIM_7_LIST_PRICE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("PRODUCT_DIM_8_ORACLE_ITEM_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CREATION_DATE"',0,80),SUBSTRB("PRODUCT_DIM_9_CREATION_DATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("PRODUCT__10_LAST_UPD"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("PRODUCT_DIM_15_GKDW_SOURCE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_18_LE_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."FE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_19_FE_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CH_NUM"',0,80),SUBSTRB("PRODUCT_DIM_20_CH_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."MD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_21_MD_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PL_NUM"',0,80),SUBSTRB("PRODUCT_DIM_22_PL_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ACT_NUM"',0,80),SUBSTRB("PRODUCT_DIM_23_ACT_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."STATUS"',0,80),SUBSTRB("PRODUCT_DIM_24_STATUS"(last_successful_index),0,2000));
                  
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
                "PRODUCT_DIM_err" := "PRODUCT_DIM_err" + 1;
                
                IF get_errors + "PRODUCT_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "PRODUCT_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "PRODUCT_DIM_si" >= "PRODUCT_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "PRODUCT_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"PRODUCT_DIM_0_ITEM_ID"(insert_bulk_index) := "PRODUCT_DIM_0_ITEM_ID"(update_bulk(j));
  		"PRODUCT_DIM_1_PROD_NUM"(insert_bulk_index) := "PRODUCT_DIM_1_PROD_NUM"(update_bulk(j));
  		"PRODUCT_DIM_2_PROD_NAME"(insert_bulk_index) := "PRODUCT_DIM_2_PROD_NAME"(update_bulk(j));
  		"PRODUCT_DIM_3_PROD_CHANNEL"(insert_bulk_index) := "PRODUCT_DIM_3_PROD_CHANNEL"(update_bulk(j));
  		"PRODUCT_DIM_4_PROD_MODALITY"(insert_bulk_index) := "PRODUCT_DIM_4_PROD_MODALITY"(update_bulk(j));
  		"PRODUCT_DIM_5_PROD_LINE"(insert_bulk_index) := "PRODUCT_DIM_5_PROD_LINE"(update_bulk(j));
  		"PRODUCT_DIM_6_PROD_FAMILY"(insert_bulk_index) := "PRODUCT_DIM_6_PROD_FAMILY"(update_bulk(j));
  		"PRODUCT_DIM_7_LIST_PRICE"(insert_bulk_index) := "PRODUCT_DIM_7_LIST_PRICE"(update_bulk(j));
  		"PRODUCT_DIM_8_ORACLE_ITEM_NUM"(insert_bulk_index) := "PRODUCT_DIM_8_ORACLE_ITEM_NUM"(update_bulk(j));
  		"PRODUCT_DIM_9_CREATION_DATE"(insert_bulk_index) := "PRODUCT_DIM_9_CREATION_DATE"(update_bulk(j));
  		"PRODUCT__10_LAST_UPD"(insert_bulk_index) := "PRODUCT__10_LAST_UPD"(update_bulk(j));
  		"PRODUCT_DIM_15_GKDW_SOURCE"(insert_bulk_index) := "PRODUCT_DIM_15_GKDW_SOURCE"(update_bulk(j));
  		"PRODUCT_DIM_17_PRODUCT_ID"(insert_bulk_index) := "PRODUCT_DIM_17_PRODUCT_ID"(update_bulk(j));
  		"PRODUCT_DIM_18_LE_NUM"(insert_bulk_index) := "PRODUCT_DIM_18_LE_NUM"(update_bulk(j));
  		"PRODUCT_DIM_19_FE_NUM"(insert_bulk_index) := "PRODUCT_DIM_19_FE_NUM"(update_bulk(j));
  		"PRODUCT_DIM_20_CH_NUM"(insert_bulk_index) := "PRODUCT_DIM_20_CH_NUM"(update_bulk(j));
  		"PRODUCT_DIM_21_MD_NUM"(insert_bulk_index) := "PRODUCT_DIM_21_MD_NUM"(update_bulk(j));
  		"PRODUCT_DIM_22_PL_NUM"(insert_bulk_index) := "PRODUCT_DIM_22_PL_NUM"(update_bulk(j));
  		"PRODUCT_DIM_23_ACT_NUM"(insert_bulk_index) := "PRODUCT_DIM_23_ACT_NUM"(update_bulk(j));
  		"PRODUCT_DIM_24_STATUS"(insert_bulk_index) := "PRODUCT_DIM_24_STATUS"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "PRODUCT_DIM_srk"(insert_bulk_index) := "PRODUCT_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "PRODUCT_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "PRODUCT_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "PRODUCT_DIM_si"..insert_bulk_index
          INSERT INTO
            "PRODUCT_DIM"
            ("PRODUCT_DIM"."ITEM_ID",
            "PRODUCT_DIM"."PROD_NUM",
            "PRODUCT_DIM"."PROD_NAME",
            "PRODUCT_DIM"."PROD_CHANNEL",
            "PRODUCT_DIM"."PROD_MODALITY",
            "PRODUCT_DIM"."PROD_LINE",
            "PRODUCT_DIM"."PROD_FAMILY",
            "PRODUCT_DIM"."LIST_PRICE",
            "PRODUCT_DIM"."ORACLE_ITEM_NUM",
            "PRODUCT_DIM"."CREATION_DATE",
            "PRODUCT_DIM"."LAST_UPDATE_DATE",
            "PRODUCT_DIM"."GKDW_SOURCE",
            "PRODUCT_DIM"."PRODUCT_ID",
            "PRODUCT_DIM"."LE_NUM",
            "PRODUCT_DIM"."FE_NUM",
            "PRODUCT_DIM"."CH_NUM",
            "PRODUCT_DIM"."MD_NUM",
            "PRODUCT_DIM"."PL_NUM",
            "PRODUCT_DIM"."ACT_NUM",
            "PRODUCT_DIM"."STATUS")
          VALUES
            ("PRODUCT_DIM_0_ITEM_ID"(i),
            "PRODUCT_DIM_1_PROD_NUM"(i),
            "PRODUCT_DIM_2_PROD_NAME"(i),
            "PRODUCT_DIM_3_PROD_CHANNEL"(i),
            "PRODUCT_DIM_4_PROD_MODALITY"(i),
            "PRODUCT_DIM_5_PROD_LINE"(i),
            "PRODUCT_DIM_6_PROD_FAMILY"(i),
            "PRODUCT_DIM_7_LIST_PRICE"(i),
            "PRODUCT_DIM_8_ORACLE_ITEM_NUM"(i),
            "PRODUCT_DIM_9_CREATION_DATE"(i),
            "PRODUCT__10_LAST_UPD"(i),
            "PRODUCT_DIM_15_GKDW_SOURCE"(i),
            "PRODUCT_DIM_17_PRODUCT_ID"(i),
            "PRODUCT_DIM_18_LE_NUM"(i),
            "PRODUCT_DIM_19_FE_NUM"(i),
            "PRODUCT_DIM_20_CH_NUM"(i),
            "PRODUCT_DIM_21_MD_NUM"(i),
            "PRODUCT_DIM_22_PL_NUM"(i),
            "PRODUCT_DIM_23_ACT_NUM"(i),
            "PRODUCT_DIM_24_STATUS"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "PRODUCT_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "PRODUCT_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "PRODUCT_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 150: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ITEM_ID"',0,80),SUBSTRB("PRODUCT_DIM_0_ITEM_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_1_PROD_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NAME"',0,80),SUBSTRB("PRODUCT_DIM_2_PROD_NAME"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_CHANNEL"',0,80),SUBSTRB("PRODUCT_DIM_3_PROD_CHANNEL"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_MODALITY"',0,80),SUBSTRB("PRODUCT_DIM_4_PROD_MODALITY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_LINE"',0,80),SUBSTRB("PRODUCT_DIM_5_PROD_LINE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_FAMILY"',0,80),SUBSTRB("PRODUCT_DIM_6_PROD_FAMILY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LIST_PRICE"',0,80),SUBSTRB("PRODUCT_DIM_7_LIST_PRICE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("PRODUCT_DIM_8_ORACLE_ITEM_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CREATION_DATE"',0,80),SUBSTRB("PRODUCT_DIM_9_CREATION_DATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("PRODUCT__10_LAST_UPD"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("PRODUCT_DIM_15_GKDW_SOURCE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PRODUCT_ID"',0,80),SUBSTRB("PRODUCT_DIM_17_PRODUCT_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_18_LE_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."FE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_19_FE_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CH_NUM"',0,80),SUBSTRB("PRODUCT_DIM_20_CH_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."MD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_21_MD_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PL_NUM"',0,80),SUBSTRB("PRODUCT_DIM_22_PL_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ACT_NUM"',0,80),SUBSTRB("PRODUCT_DIM_23_ACT_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."STATUS"',0,80),SUBSTRB("PRODUCT_DIM_24_STATUS"(error_index),0,2000));
            
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
          "PRODUCT_DIM_err" := "PRODUCT_DIM_err" + 1;
          
          IF get_errors + "PRODUCT_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "PRODUCT_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "PRODUCT_DIM_srk"(rowkey_index);
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
  
      "PRODUCT_DIM_ins" := "PRODUCT_DIM_ins" + get_rowid.COUNT;
      "PRODUCT_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "PRODUCT_DIM_ins" := "PRODUCT_DIM_ins0"; 
    "PRODUCT_DIM_upd" := "PRODUCT_DIM_upd0";
  END IF;

END "JOIN_DML";

---------------------------------------------------------------------------
-- "JOIN_p" main
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

  IF NOT "PRODUCT_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "JOIN_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "PRODUCT_DIM_St" THEN
          "PRODUCT_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"PRODUCT_DIM"',
              p_target_uoid=>'A41FFB19A9605678E040007F01006C7D',
              p_stm=>'TRACE 152',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "PRODUCT_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A9B55678E040007F01006C7D', -- Operator PRODUCTPROGRAM
              p_parent_object_name=>'PRODUCTPROGRAM',
              p_parent_object_uoid=>'A41FFB19102C5678E040007F01006C7D', -- Table PRODUCTPROGRAM
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCTPROGRAM',
              p_object_uoid=>'A41FFB19102C5678E040007F01006C7D', -- Table PRODUCTPROGRAM
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19AA6B5678E040007F01006C7D', -- Operator PRODUCT_DIM
              p_parent_object_name=>'PRODUCT_DIM',
              p_parent_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCT_DIM',
              p_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A9605678E040007F01006C7D', -- Operator PRODUCT_DIM
              p_parent_object_name=>'PRODUCT_DIM',
              p_parent_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCT_DIM',
              p_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A95E5678E040007F01006C7D', -- Operator PRODUCT
              p_parent_object_name=>'PRODUCT',
              p_parent_object_uoid=>'A41FFB1910F95678E040007F01006C7D', -- Table PRODUCT
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCT',
              p_object_uoid=>'A41FFB1910F95678E040007F01006C7D', -- Table PRODUCT
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
    "JOIN_si" := 0;
    "PRODUCT_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "JOIN_SU";

      LOOP
        IF "JOIN_si" = 0 THEN
          "JOIN_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "JOIN_23_PRODUCTID".COUNT - 1;
          ELSE
            bulk_count := "JOIN_23_PRODUCTID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "PRODUCT_DIM_ir".DELETE;
"PRODUCT_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "JOIN_i" := "JOIN_si";
        BEGIN
          
          LOOP
            EXIT WHEN "PRODUCT_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "JOIN_i" := "JOIN_i" + 1;
            "JOIN_si" := "JOIN_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "PRODUCT_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("JOIN_c"%NOTFOUND AND
               "JOIN_i" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "JOIN_i" > bulk_count THEN
            
              "JOIN_si" := 0;
              EXIT;
            END IF;


            

            IF get_buffer_done(get_buffer_done_index) OR
            	("JOIN_29_CREATEDATE"("JOIN_i")  >=  "PREMAPPING_1_CREATE_DATE_OUT" 
or  "JOIN_31_MODIFYDATE"("JOIN_i")  >=  "PREMAPPING_2_MODIFY_DATE_OUT"
) Or 
( "JOIN_39_PP_CREATEDATE"("JOIN_i")  >=  "PREMAPPING_1_CREATE_DATE_OUT" 
  Or  "JOIN_41_PP_MODIFYDATE"("JOIN_i")  >=  "PREMAPPING_2_MODIFY_DATE_OUT" 
 )/* FLTR */ THEN
            
            
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
                  
                  "GET_ORACLE_ITEM_ID"("JOIN_26_ACTUALID"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ORAC_2_INVENTOR"
              ("JOIN_i"));
              
              ',0,2000);
              
                  
                  "GET_ORACLE_ITEM_ID"("JOIN_26_ACTUALID"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ORAC_2_INVENTOR"
              ("JOIN_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
                  
                  "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_1_MD_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_MD_FLEX_"
              ("JOIN_i"));
              
              ',0,2000);
              
                  
                  "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_1_MD_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_MD_FLEX_"
              ("JOIN_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
                  
                  "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_0_CH_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_CH_FLEX_"
              ("JOIN_i"));
              
              ',0,2000);
              
                  
                  "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_0_CH_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_CH_FLEX_"
              ("JOIN_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
                  
                  "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_5_PL_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_PL_FLEX_"
              ("JOIN_i"));
              
              ',0,2000);
              
                  
                  "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_5_PL_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_PL_FLEX_"
              ("JOIN_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
                IF NOT get_buffer_done(get_buffer_done_index) THEN
                  error_stmt := SUBSTRB('
              
                  
                  "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ITEM_2_ITEM_NUM"
              ("JOIN_i"),"GET_ITEM_3_LE_NUM_O"
              ("JOIN_i"),"GET_ITEM_4_FE_NUM_O"
              ("JOIN_i"),"GET_ITEM_5_CH_NUM_O"
              ("JOIN_i"),"GET_ITEM_6_MD_NUM_O"
              ("JOIN_i"),"GET_ITEM_7_PL_NUM_O"
              ("JOIN_i"),"GET_ITEM_8_ACT_NUM_"
              ("JOIN_i"));
              
              ',0,2000);
              
                  
                  "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
              ("JOIN_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ITEM_2_ITEM_NUM"
              ("JOIN_i"),"GET_ITEM_3_LE_NUM_O"
              ("JOIN_i"),"GET_ITEM_4_FE_NUM_O"
              ("JOIN_i"),"GET_ITEM_5_CH_NUM_O"
              ("JOIN_i"),"GET_ITEM_6_MD_NUM_O"
              ("JOIN_i"),"GET_ITEM_7_PL_NUM_O"
              ("JOIN_i"),"GET_ITEM_8_ACT_NUM_"
              ("JOIN_i"));
              
                END IF; -- get_buffer_done
                -- End expression statement
              END IF;
              
              
get_target_name := '"PRODUCT_DIM"';
              get_audit_detail_id := "PRODUCT_DIM_id";
              IF NOT "PRODUCT_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
                BEGIN
                  get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
              		error_stmt := SUBSTRB('"PRODUCT_DIM_0_ITEM_ID"("PRODUCT_DIM_i") := 
              
              "GET_ORAC_2_INVENTOR"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_0_ITEM_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ORAC_2_INVENTOR"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_0_ITEM_ID"("PRODUCT_DIM_i") :=
              
              "GET_ORAC_2_INVENTOR"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_0_ITEM_ID" :=
              
              "GET_ORAC_2_INVENTOR"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_1_PROD_NUM"("PRODUCT_DIM_i") := 
              
              "JOIN_26_ACTUALID"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_1_PROD_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_26_ACTUALID"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_1_PROD_NUM"("PRODUCT_DIM_i") :=
              
              "JOIN_26_ACTUALID"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_1_PROD_NUM" :=
              
              "JOIN_26_ACTUALID"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_2_PROD_NAME"("PRODUCT_DIM_i") := 
              
              "JOIN_24_PRODUCT_NAME"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_2_PROD_NAME"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_24_PRODUCT_NAME"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_2_PROD_NAME"("PRODUCT_DIM_i") :=
              
              "JOIN_24_PRODUCT_NAME"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_2_PROD_NAME" :=
              
              "JOIN_24_PRODUCT_NAME"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_3_PROD_CHANNEL"("PRODUCT_DIM_i") := 
              
              "GET_FLEX_3_CH_FLEX_"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_3_PROD_CHANNEL"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_FLEX_3_CH_FLEX_"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_3_PROD_CHANNEL"("PRODUCT_DIM_i") :=
              
              "GET_FLEX_3_CH_FLEX_"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_3_PROD_CHANNEL" :=
              
              "GET_FLEX_3_CH_FLEX_"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_4_PROD_MODALITY"("PRODUCT_DIM_i") := 
              
              "GET_FLEX_3_MD_FLEX_"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_4_PROD_MODALITY"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_FLEX_3_MD_FLEX_"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_4_PROD_MODALITY"("PRODUCT_DIM_i") :=
              
              "GET_FLEX_3_MD_FLEX_"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_4_PROD_MODALITY" :=
              
              "GET_FLEX_3_MD_FLEX_"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_5_PROD_LINE"("PRODUCT_DIM_i") := 
              
              "GET_FLEX_3_PL_FLEX_"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_5_PROD_LINE"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_FLEX_3_PL_FLEX_"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_5_PROD_LINE"("PRODUCT_DIM_i") :=
              
              "GET_FLEX_3_PL_FLEX_"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_5_PROD_LINE" :=
              
              "GET_FLEX_3_PL_FLEX_"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_6_PROD_FAMILY"("PRODUCT_DIM_i") := 
              
              "JOIN_27_FAMILY"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_6_PROD_FAMILY"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_27_FAMILY"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_6_PROD_FAMILY"("PRODUCT_DIM_i") :=
              
              "JOIN_27_FAMILY"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_6_PROD_FAMILY" :=
              
              "JOIN_27_FAMILY"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_7_LIST_PRICE"("PRODUCT_DIM_i") := 
              
              "JOIN_43_PP_PRICE"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_7_LIST_PRICE"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_43_PP_PRICE"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_7_LIST_PRICE"("PRODUCT_DIM_i") :=
              
              "JOIN_43_PP_PRICE"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_7_LIST_PRICE" :=
              
              "JOIN_43_PP_PRICE"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_8_ORACLE_ITEM_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_2_ITEM_NUM"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_8_ORACLE_ITEM_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_2_ITEM_NUM"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_8_ORACLE_ITEM_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_2_ITEM_NUM"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_8_ORACLE_ITEM_N" :=
              
              "GET_ITEM_2_ITEM_NUM"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_9_CREATION_DATE"("PRODUCT_DIM_i") := 
              
              "JOIN_29_CREATEDATE"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_9_CREATION_DATE"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_29_CREATEDATE"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_9_CREATION_DATE"("PRODUCT_DIM_i") :=
              
              "JOIN_29_CREATEDATE"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_9_CREATION_DATE" :=
              
              "JOIN_29_CREATEDATE"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT__10_LAST_UPD"("PRODUCT_DIM_i") := 
              
              "JOIN_31_MODIFYDATE"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT__10_LAST_UPD"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_31_MODIFYDATE"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT__10_LAST_UPD"("PRODUCT_DIM_i") :=
              
              "JOIN_31_MODIFYDATE"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT__10_LAST_UPD" :=
              
              "JOIN_31_MODIFYDATE"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_15_GKDW_SOURCE"("PRODUCT_DIM_i") := 
              
              "OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE";',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_15_GKDW_SOURCE"',0,80);
              
              BEGIN
                error_value := SUBSTRB("OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE",0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_15_GKDW_SOURCE"("PRODUCT_DIM_i") :=
              
              "OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE";
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_15_GKDW_SOURCE" :=
              
              "OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE";
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_17_PRODUCT_ID"("PRODUCT_DIM_i") := 
              
              RTRIM("JOIN_23_PRODUCTID"("JOIN_i"));',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_17_PRODUCT_ID"',0,80);
              
              BEGIN
                error_value := SUBSTRB(RTRIM("JOIN_23_PRODUCTID"("JOIN_i")),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_17_PRODUCT_ID"("PRODUCT_DIM_i") :=
              
              RTRIM("JOIN_23_PRODUCTID"("JOIN_i"));
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_17_PRODUCT_ID" :=
              
              RTRIM("JOIN_23_PRODUCTID"("JOIN_i"));
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_18_LE_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_3_LE_NUM_O"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_18_LE_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_3_LE_NUM_O"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_18_LE_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_3_LE_NUM_O"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_18_LE_NUM" :=
              
              "GET_ITEM_3_LE_NUM_O"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_19_FE_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_4_FE_NUM_O"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_19_FE_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_4_FE_NUM_O"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_19_FE_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_4_FE_NUM_O"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_19_FE_NUM" :=
              
              "GET_ITEM_4_FE_NUM_O"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_20_CH_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_5_CH_NUM_O"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_20_CH_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_5_CH_NUM_O"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_20_CH_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_5_CH_NUM_O"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_20_CH_NUM" :=
              
              "GET_ITEM_5_CH_NUM_O"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_21_MD_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_6_MD_NUM_O"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_21_MD_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_6_MD_NUM_O"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_21_MD_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_6_MD_NUM_O"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_21_MD_NUM" :=
              
              "GET_ITEM_6_MD_NUM_O"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_22_PL_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_7_PL_NUM_O"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_22_PL_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_7_PL_NUM_O"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_22_PL_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_7_PL_NUM_O"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_22_PL_NUM" :=
              
              "GET_ITEM_7_PL_NUM_O"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_23_ACT_NUM"("PRODUCT_DIM_i") := 
              
              "GET_ITEM_8_ACT_NUM_"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_23_ACT_NUM"',0,80);
              
              BEGIN
                error_value := SUBSTRB("GET_ITEM_8_ACT_NUM_"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_23_ACT_NUM"("PRODUCT_DIM_i") :=
              
              "GET_ITEM_8_ACT_NUM_"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_23_ACT_NUM" :=
              
              "GET_ITEM_8_ACT_NUM_"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              		error_stmt := SUBSTRB('"PRODUCT_DIM_24_STATUS"("PRODUCT_DIM_i") := 
              
              "JOIN_34_STATUS"("JOIN_i");',0,2000);
              error_column := SUBSTRB('"PRODUCT_DIM_24_STATUS"',0,80);
              
              BEGIN
                error_value := SUBSTRB("JOIN_34_STATUS"("JOIN_i"),0,2000);
              EXCEPTION 
                WHEN OTHERS THEN
                  error_value := '*';
              END;
              
              IF NOT get_use_hc THEN
                "PRODUCT_DIM_24_STATUS"("PRODUCT_DIM_i") :=
              
              "JOIN_34_STATUS"("JOIN_i");
              
              ELSIF get_row_status THEN
                "SV_PRODUCT_DIM_24_STATUS" :=
              
              "JOIN_34_STATUS"("JOIN_i");
              
              ELSE
                NULL;
              END IF;
              
              
              
                  IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                    IF NOT get_use_hc THEN
                      "PRODUCT_DIM_srk"("PRODUCT_DIM_i") := get_rowkey + "JOIN_i" - 1;
                    ELSIF get_row_status THEN
                      "SV_PRODUCT_DIM_srk" := get_rowkey + "JOIN_i" - 1;
                    ELSE
                      NULL;
                    END IF;
                    END IF;
                    IF get_use_hc THEN
                    "PRODUCT_DIM_new" := TRUE;
                  ELSE
                    "PRODUCT_DIM_i" := "PRODUCT_DIM_i" + 1;
                  END IF;
                EXCEPTION
                  WHEN OTHERS THEN
                      last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
               
                    "JOIN_ER"('TRACE 153: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "JOIN_i");
                    
                    "PRODUCT_DIM_err" := "PRODUCT_DIM_err" + 1;
                    
                    IF get_errors + "PRODUCT_DIM_err" > get_max_errors THEN
                      get_abort:= TRUE;
                    END IF;
                    get_row_status := FALSE; 
                END;
              END IF;
              
              
              
            END IF;
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("PRODUCT_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "PRODUCT_DIM_new" 
            AND (NOT "PRODUCT_DIM_nul") THEN
              "PRODUCT_DIM_ir"(dml_bsize) := "PRODUCT_DIM_i";
            	"PRODUCT_DIM_0_ITEM_ID"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_0_ITEM_ID";
            	"PRODUCT_DIM_1_PROD_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_1_PROD_NUM";
            	"PRODUCT_DIM_2_PROD_NAME"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_2_PROD_NAME";
            	"PRODUCT_DIM_3_PROD_CHANNEL"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_3_PROD_CHANNEL";
            	"PRODUCT_DIM_4_PROD_MODALITY"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_4_PROD_MODALITY";
            	"PRODUCT_DIM_5_PROD_LINE"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_5_PROD_LINE";
            	"PRODUCT_DIM_6_PROD_FAMILY"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_6_PROD_FAMILY";
            	"PRODUCT_DIM_7_LIST_PRICE"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_7_LIST_PRICE";
            	"PRODUCT_DIM_8_ORACLE_ITEM_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_8_ORACLE_ITEM_N";
            	"PRODUCT_DIM_9_CREATION_DATE"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_9_CREATION_DATE";
            	"PRODUCT__10_LAST_UPD"("PRODUCT_DIM_i") := "SV_PRODUCT__10_LAST_UPD";
            	"PRODUCT_DIM_15_GKDW_SOURCE"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_15_GKDW_SOURCE";
            	"PRODUCT_DIM_17_PRODUCT_ID"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_17_PRODUCT_ID";
            	"PRODUCT_DIM_18_LE_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_18_LE_NUM";
            	"PRODUCT_DIM_19_FE_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_19_FE_NUM";
            	"PRODUCT_DIM_20_CH_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_20_CH_NUM";
            	"PRODUCT_DIM_21_MD_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_21_MD_NUM";
            	"PRODUCT_DIM_22_PL_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_22_PL_NUM";
            	"PRODUCT_DIM_23_ACT_NUM"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_23_ACT_NUM";
            	"PRODUCT_DIM_24_STATUS"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_24_STATUS";
              "PRODUCT_DIM_srk"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_srk";
              "PRODUCT_DIM_i" := "PRODUCT_DIM_i" + 1;
            ELSE
              "PRODUCT_DIM_ir"(dml_bsize) := 0;
            END IF;
            END IF;
            
          END LOOP;

          "JOIN_DML"(1, TRUE);
          IF get_use_hc THEN
            IF NOT get_row_status THEN
              FOR start_index IN 1..dml_bsize LOOP
                "JOIN_DML"(start_index, FALSE);
              END LOOP;
            ELSE
              COMMIT;
            END IF;
          END IF;
          
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            "JOIN_ER"('TRACE 151: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "JOIN_i");
            get_errors := get_errors + 1;
            IF get_errors > get_max_errors THEN  
  get_abort := TRUE;
END IF;
            
        END;
        


        cursor_exhausted := "JOIN_c"%NOTFOUND;
        exit_loop_normal := get_abort OR get_abort_procedure OR (cursor_exhausted AND "JOIN_i" > bulk_count);
        exit_loop_early := get_rows_processed AND get_bulk_loop_count IS NOT NULL AND "JOIN_i" >= get_bulk_loop_count;
        get_close_cursor := get_abort OR get_abort_procedure OR cursor_exhausted;
        EXIT WHEN exit_loop_normal OR exit_loop_early;

      END LOOP;
    END IF;
    IF NOT get_no_commit THEN
      COMMIT; -- commit no.11
    END IF;
    BEGIN
      IF get_close_cursor THEN
        CLOSE "JOIN_c";
      END IF;
    EXCEPTION WHEN OTHERS THEN
      NULL;
      END;
    -- Do post processing only after procedure has been called for the last time and the cursor is closing
    IF get_close_cursor THEN
      
      NULL;
    END IF; -- If get_close_cursor
  END IF;
    IF NOT "PRODUCT_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"PRODUCT_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"PRODUCT_DIM_ins",
        p_upd=>"PRODUCT_DIM_upd",
        p_del=>"PRODUCT_DIM_del",
        p_err=>"PRODUCT_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "PRODUCT_DIM_ins";
    get_updated  := get_updated  + "PRODUCT_DIM_upd";
    get_deleted  := get_deleted  + "PRODUCT_DIM_del";
    get_errors   := get_errors   + "PRODUCT_DIM_err";

  get_selected := get_selected + get_map_selected;
  IF NOT get_no_commit THEN
  COMMIT;  -- commit no.21
END IF;

END "JOIN_p";



-- Procedure "FLTR_t" is the entry point for map "FLTR_t"

PROCEDURE "FLTR_t"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"FLTR_t"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"';
get_source_uoid            CONSTANT VARCHAR2(2000) := '';
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

"PRODUCT_DIM_id" NUMBER(22) := 0;
"PRODUCT_DIM_ins" NUMBER(22) := 0;
"PRODUCT_DIM_upd" NUMBER(22) := 0;
"PRODUCT_DIM_del" NUMBER(22) := 0;
"PRODUCT_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"PRODUCT_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"PRODUCT_DIM_ir"  index_redirect_array;
"SV_PRODUCT_DIM_srk" NUMBER;
"PRODUCT_DIM_new"  BOOLEAN;
"PRODUCT_DIM_nul"  BOOLEAN := FALSE;

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


"PRODUCT_DIM_si" NUMBER(22) := 0;

"PRODUCT_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_3_ACTUALID" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DUMMY_TABLE_CURSOR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ORAC_2_INVENTOR" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_1_PRODUCT_NAME" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_CH_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_MD_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_PL_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_4_FAMILY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_5_PRICE" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_2_ITEM_NUM" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_3_LE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_4_FE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_5_CH_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_6_MD_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_7_PL_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_8_ACT_NUM_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_6_CREATEDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_8_MODIFYDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_0_PRODUCTID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_11_STATUS" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_0_ITEM_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_1_PROD_NUM$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_2_PROD_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_3_PROD_CHANNEL$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_4_PROD_MODALI" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_5_PROD_LINE$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_6_PROD_FAMILY$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_7_LIST_PRICE$1" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_8_ORACLE_ITEM" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_9_CREATION_DA" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT__10_LAST_UPD$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_15_GKDW_SOURCE$1" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_17_PRODUCT_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_18_LE_NUM$1" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_19_FE_NUM$1" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_20_CH_NUM$1" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_21_MD_NUM$1" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_22_PL_NUM$1" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_23_ACT_NUM$1" IS TABLE OF VARCHAR2(6) INDEX BY BINARY_INTEGER;
TYPE "T_PRODUCT_DIM_24_STATUS$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_3_ACTUALID"  VARCHAR2(64);
"SV_ROWKEY_FLTR"  VARCHAR2(18);
"SV_ROWKEY_DUMMY_TABLE_CURSOR"  VARCHAR2(18);
"SV_GET_ORAC_2_INVENTOR"  NUMBER;
"SV_FLTR_1_PRODUCT_NAME"  VARCHAR2(64);
"SV_GET_FLEX_3_CH_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_MD_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_PL_FLEX_"  VARCHAR2(32767);
"SV_FLTR_4_FAMILY"  VARCHAR2(32);
"SV_FLTR_5_PRICE"  NUMBER;
"SV_GET_ITEM_2_ITEM_NUM"  VARCHAR2(32767);
"SV_GET_ITEM_3_LE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_4_FE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_5_CH_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_6_MD_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_7_PL_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_8_ACT_NUM_"  VARCHAR2(32767);
"SV_FLTR_6_CREATEDATE"  DATE;
"SV_FLTR_8_MODIFYDATE"  DATE;
"SV_FLTR_0_PRODUCTID"  CHAR(12);
"SV_FLTR_11_STATUS"  VARCHAR2(64);
"SV_PRODUCT_DIM_0_ITEM_ID$1"  VARCHAR2(50);
"SV_PRODUCT_DIM_1_PROD_NUM$1"  VARCHAR2(100);
"SV_PRODUCT_DIM_2_PROD_NAME$1"  VARCHAR2(250);
"SV_PRODUCT_DIM_3_PROD_CHANN"  VARCHAR2(250);
"SV_PRODUCT_DIM_4_PROD_MODALI"  VARCHAR2(250);
"SV_PRODUCT_DIM_5_PROD_LINE$1"  VARCHAR2(250);
"SV_PRODUCT_DIM_6_PROD_FAMILY$1"  VARCHAR2(250);
"SV_PRODUCT_DIM_7_LIST_PRICE$1"  NUMBER;
"SV_PRODUCT_DIM_8_ORACLE_ITEM"  VARCHAR2(50);
"SV_PRODUCT_DIM_9_CREATION_DA"  DATE;
"SV_PRODUCT__10_LAST_UPD$1"  DATE;
"SV_PRODUCT_DIM_15_GKDW_SOUR"  VARCHAR2(20);
"SV_PRODUCT_DIM_17_PRODUCT_ID$1"  VARCHAR2(50);
"SV_PRODUCT_DIM_18_LE_NUM$1"  VARCHAR2(3);
"SV_PRODUCT_DIM_19_FE_NUM$1"  VARCHAR2(3);
"SV_PRODUCT_DIM_20_CH_NUM$1"  VARCHAR2(2);
"SV_PRODUCT_DIM_21_MD_NUM$1"  VARCHAR2(2);
"SV_PRODUCT_DIM_22_PL_NUM$1"  VARCHAR2(2);
"SV_PRODUCT_DIM_23_ACT_NUM$1"  VARCHAR2(6);
"SV_PRODUCT_DIM_24_STATUS$1"  VARCHAR2(64);

-- Bulk: intermediate collection variables
"FLTR_3_ACTUALID" "T_FLTR_3_ACTUALID";
"ROWKEY_FLTR" "T_ROWKEY_FLTR";
"ROWKEY_DUMMY_TABLE_CURSOR" "T_ROWKEY_DUMMY_TABLE_CURSOR";
"GET_ORAC_2_INVENTOR" "T_GET_ORAC_2_INVENTOR";
"FLTR_1_PRODUCT_NAME" "T_FLTR_1_PRODUCT_NAME";
"GET_FLEX_3_CH_FLEX_" "T_GET_FLEX_3_CH_FLEX_";
"GET_FLEX_3_MD_FLEX_" "T_GET_FLEX_3_MD_FLEX_";
"GET_FLEX_3_PL_FLEX_" "T_GET_FLEX_3_PL_FLEX_";
"FLTR_4_FAMILY" "T_FLTR_4_FAMILY";
"FLTR_5_PRICE" "T_FLTR_5_PRICE";
"GET_ITEM_2_ITEM_NUM" "T_GET_ITEM_2_ITEM_NUM";
"GET_ITEM_3_LE_NUM_O" "T_GET_ITEM_3_LE_NUM_O";
"GET_ITEM_4_FE_NUM_O" "T_GET_ITEM_4_FE_NUM_O";
"GET_ITEM_5_CH_NUM_O" "T_GET_ITEM_5_CH_NUM_O";
"GET_ITEM_6_MD_NUM_O" "T_GET_ITEM_6_MD_NUM_O";
"GET_ITEM_7_PL_NUM_O" "T_GET_ITEM_7_PL_NUM_O";
"GET_ITEM_8_ACT_NUM_" "T_GET_ITEM_8_ACT_NUM_";
"FLTR_6_CREATEDATE" "T_FLTR_6_CREATEDATE";
"FLTR_8_MODIFYDATE" "T_FLTR_8_MODIFYDATE";
"FLTR_0_PRODUCTID" "T_FLTR_0_PRODUCTID";
"FLTR_11_STATUS" "T_FLTR_11_STATUS";
"PRODUCT_DIM_0_ITEM_ID$1" "T_PRODUCT_DIM_0_ITEM_ID$1";
"PRODUCT_DIM_1_PROD_NUM$1" "T_PRODUCT_DIM_1_PROD_NUM$1";
"PRODUCT_DIM_2_PROD_NAME$1" "T_PRODUCT_DIM_2_PROD_NAME$1";
"PRODUCT_DIM_3_PROD_CHANNEL$1" "T_PRODUCT_DIM_3_PROD_CHANNEL$1";
"PRODUCT_DIM_4_PROD_MODALITY$1" "T_PRODUCT_DIM_4_PROD_MODALI";
"PRODUCT_DIM_5_PROD_LINE$1" "T_PRODUCT_DIM_5_PROD_LINE$1";
"PRODUCT_DIM_6_PROD_FAMILY$1" "T_PRODUCT_DIM_6_PROD_FAMILY$1";
"PRODUCT_DIM_7_LIST_PRICE$1" "T_PRODUCT_DIM_7_LIST_PRICE$1";
"PRODUCT_DIM_8_ORACLE_ITEM_N" "T_PRODUCT_DIM_8_ORACLE_ITEM";
"PRODUCT_DIM_9_CREATION_DATE$1" "T_PRODUCT_DIM_9_CREATION_DA";
"PRODUCT__10_LAST_UPD$1" "T_PRODUCT__10_LAST_UPD$1";
"PRODUCT_DIM_15_GKDW_SOURCE$1" "T_PRODUCT_DIM_15_GKDW_SOURCE$1";
"PRODUCT_DIM_17_PRODUCT_ID$1" "T_PRODUCT_DIM_17_PRODUCT_ID$1";
"PRODUCT_DIM_18_LE_NUM$1" "T_PRODUCT_DIM_18_LE_NUM$1";
"PRODUCT_DIM_19_FE_NUM$1" "T_PRODUCT_DIM_19_FE_NUM$1";
"PRODUCT_DIM_20_CH_NUM$1" "T_PRODUCT_DIM_20_CH_NUM$1";
"PRODUCT_DIM_21_MD_NUM$1" "T_PRODUCT_DIM_21_MD_NUM$1";
"PRODUCT_DIM_22_PL_NUM$1" "T_PRODUCT_DIM_22_PL_NUM$1";
"PRODUCT_DIM_23_ACT_NUM$1" "T_PRODUCT_DIM_23_ACT_NUM$1";
"PRODUCT_DIM_24_STATUS$1" "T_PRODUCT_DIM_24_STATUS$1";

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
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_3_ACTUALID',0,80),
    p_value=>SUBSTRB("FLTR_3_ACTUALID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_1_PRODUCT_NAME',0,80),
    p_value=>SUBSTRB("FLTR_1_PRODUCT_NAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_4_FAMILY',0,80),
    p_value=>SUBSTRB("FLTR_4_FAMILY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_5_PRICE',0,80),
    p_value=>SUBSTRB("FLTR_5_PRICE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_6_CREATEDATE',0,80),
    p_value=>SUBSTRB("FLTR_6_CREATEDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_8_MODIFYDATE',0,80),
    p_value=>SUBSTRB("FLTR_8_MODIFYDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_0_PRODUCTID',0,80),
    p_value=>SUBSTRB("FLTR_0_PRODUCTID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',0,80),
    p_column=>SUBSTR('FLTR_11_STATUS',0,80),
    p_value=>SUBSTRB("FLTR_11_STATUS"(error_index),0,2000),
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
      p_stm=>'TRACE 154: ' || p_statement,
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
    "FLTR_3_ACTUALID".DELETE;
    "FLTR_1_PRODUCT_NAME".DELETE;
    "FLTR_4_FAMILY".DELETE;
    "FLTR_5_PRICE".DELETE;
    "FLTR_6_CREATEDATE".DELETE;
    "FLTR_8_MODIFYDATE".DELETE;
    "FLTR_0_PRODUCTID".DELETE;
    "FLTR_11_STATUS".DELETE;

    FETCH
      "FLTR_c"
    BULK COLLECT INTO
      "FLTR_3_ACTUALID",
      "FLTR_1_PRODUCT_NAME",
      "FLTR_4_FAMILY",
      "FLTR_5_PRICE",
      "FLTR_6_CREATEDATE",
      "FLTR_8_MODIFYDATE",
      "FLTR_0_PRODUCTID",
      "FLTR_11_STATUS"
    LIMIT get_bulk_size;

    IF "FLTR_c"%NOTFOUND AND "FLTR_3_ACTUALID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_3_ACTUALID".COUNT;
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
    get_map_selected := get_map_selected + "FLTR_3_ACTUALID".COUNT;
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
          p_stm=>'TRACE 155: SELECT',
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
  "PRODUCT_DIM_ins0" NUMBER := "PRODUCT_DIM_ins";
  "PRODUCT_DIM_upd0" NUMBER := "PRODUCT_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "PRODUCT_DIM_St" THEN
  -- Update/Insert DML for "PRODUCT_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"PRODUCT_DIM"';
    get_audit_detail_id := "PRODUCT_DIM_id";
    "PRODUCT_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "PRODUCT_DIM_i" > get_bulk_size 
   OR "FLTR_c"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "PRODUCT_DIM_si".."PRODUCT_DIM_i" - 1 
            UPDATE
              "PRODUCT_DIM"
            SET
  
  						"PRODUCT_DIM"."ITEM_ID" = "PRODUCT_DIM_0_ITEM_ID$1"
  (i),						"PRODUCT_DIM"."PROD_NUM" = "PRODUCT_DIM_1_PROD_NUM$1"
  (i),						"PRODUCT_DIM"."PROD_NAME" = "PRODUCT_DIM_2_PROD_NAME$1"
  (i),						"PRODUCT_DIM"."PROD_CHANNEL" = "PRODUCT_DIM_3_PROD_CHANNEL$1"
  (i),						"PRODUCT_DIM"."PROD_MODALITY" = "PRODUCT_DIM_4_PROD_MODALITY$1"
  (i),						"PRODUCT_DIM"."PROD_LINE" = "PRODUCT_DIM_5_PROD_LINE$1"
  (i),						"PRODUCT_DIM"."PROD_FAMILY" = "PRODUCT_DIM_6_PROD_FAMILY$1"
  (i),						"PRODUCT_DIM"."LIST_PRICE" = "PRODUCT_DIM_7_LIST_PRICE$1"
  (i),						"PRODUCT_DIM"."ORACLE_ITEM_NUM" = "PRODUCT_DIM_8_ORACLE_ITEM_N"
  (i),						"PRODUCT_DIM"."CREATION_DATE" = "PRODUCT_DIM_9_CREATION_DATE$1"
  (i),						"PRODUCT_DIM"."LAST_UPDATE_DATE" = "PRODUCT__10_LAST_UPD$1"
  (i),						"PRODUCT_DIM"."GKDW_SOURCE" = "PRODUCT_DIM_15_GKDW_SOURCE$1"
  (i),						"PRODUCT_DIM"."LE_NUM" = "PRODUCT_DIM_18_LE_NUM$1"
  (i),						"PRODUCT_DIM"."FE_NUM" = "PRODUCT_DIM_19_FE_NUM$1"
  (i),						"PRODUCT_DIM"."CH_NUM" = "PRODUCT_DIM_20_CH_NUM$1"
  (i),						"PRODUCT_DIM"."MD_NUM" = "PRODUCT_DIM_21_MD_NUM$1"
  (i),						"PRODUCT_DIM"."PL_NUM" = "PRODUCT_DIM_22_PL_NUM$1"
  (i),						"PRODUCT_DIM"."ACT_NUM" = "PRODUCT_DIM_23_ACT_NUM$1"
  (i),						"PRODUCT_DIM"."STATUS" = "PRODUCT_DIM_24_STATUS$1"
  (i)
    
            WHERE
  
  						"PRODUCT_DIM"."PRODUCT_ID" = "PRODUCT_DIM_17_PRODUCT_ID$1"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "PRODUCT_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "PRODUCT_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "PRODUCT_DIM_srk"(rowkey_index);
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
  
          "PRODUCT_DIM_upd" := "PRODUCT_DIM_upd" + get_rowid.COUNT;
          "PRODUCT_DIM_si" := "PRODUCT_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "PRODUCT_DIM_si".."PRODUCT_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "PRODUCT_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "PRODUCT_DIM_srk"(rowkey_index);
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
            "PRODUCT_DIM_upd" := "PRODUCT_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "PRODUCT_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                  "PRODUCT_DIM"
                SET
  
  								"PRODUCT_DIM"."ITEM_ID" = "PRODUCT_DIM_0_ITEM_ID$1"
  (last_successful_index),								"PRODUCT_DIM"."PROD_NUM" = "PRODUCT_DIM_1_PROD_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."PROD_NAME" = "PRODUCT_DIM_2_PROD_NAME$1"
  (last_successful_index),								"PRODUCT_DIM"."PROD_CHANNEL" = "PRODUCT_DIM_3_PROD_CHANNEL$1"
  (last_successful_index),								"PRODUCT_DIM"."PROD_MODALITY" = "PRODUCT_DIM_4_PROD_MODALITY$1"
  (last_successful_index),								"PRODUCT_DIM"."PROD_LINE" = "PRODUCT_DIM_5_PROD_LINE$1"
  (last_successful_index),								"PRODUCT_DIM"."PROD_FAMILY" = "PRODUCT_DIM_6_PROD_FAMILY$1"
  (last_successful_index),								"PRODUCT_DIM"."LIST_PRICE" = "PRODUCT_DIM_7_LIST_PRICE$1"
  (last_successful_index),								"PRODUCT_DIM"."ORACLE_ITEM_NUM" = "PRODUCT_DIM_8_ORACLE_ITEM_N"
  (last_successful_index),								"PRODUCT_DIM"."CREATION_DATE" = "PRODUCT_DIM_9_CREATION_DATE$1"
  (last_successful_index),								"PRODUCT_DIM"."LAST_UPDATE_DATE" = "PRODUCT__10_LAST_UPD$1"
  (last_successful_index),								"PRODUCT_DIM"."GKDW_SOURCE" = "PRODUCT_DIM_15_GKDW_SOURCE$1"
  (last_successful_index),								"PRODUCT_DIM"."LE_NUM" = "PRODUCT_DIM_18_LE_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."FE_NUM" = "PRODUCT_DIM_19_FE_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."CH_NUM" = "PRODUCT_DIM_20_CH_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."MD_NUM" = "PRODUCT_DIM_21_MD_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."PL_NUM" = "PRODUCT_DIM_22_PL_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."ACT_NUM" = "PRODUCT_DIM_23_ACT_NUM$1"
  (last_successful_index),								"PRODUCT_DIM"."STATUS" = "PRODUCT_DIM_24_STATUS$1"
  (last_successful_index)
  
                WHERE
  
  								"PRODUCT_DIM"."PRODUCT_ID" = "PRODUCT_DIM_17_PRODUCT_ID$1"
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
                  error_rowkey := "PRODUCT_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ITEM_ID"',0,80),SUBSTRB("PRODUCT_DIM_0_ITEM_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_1_PROD_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NAME"',0,80),SUBSTRB("PRODUCT_DIM_2_PROD_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_CHANNEL"',0,80),SUBSTRB("PRODUCT_DIM_3_PROD_CHANNEL$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_MODALITY"',0,80),SUBSTRB("PRODUCT_DIM_4_PROD_MODALITY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_LINE"',0,80),SUBSTRB("PRODUCT_DIM_5_PROD_LINE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_FAMILY"',0,80),SUBSTRB("PRODUCT_DIM_6_PROD_FAMILY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LIST_PRICE"',0,80),SUBSTRB("PRODUCT_DIM_7_LIST_PRICE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("PRODUCT_DIM_8_ORACLE_ITEM_N"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CREATION_DATE"',0,80),SUBSTRB("PRODUCT_DIM_9_CREATION_DATE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("PRODUCT__10_LAST_UPD$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("PRODUCT_DIM_15_GKDW_SOURCE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_18_LE_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."FE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_19_FE_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CH_NUM"',0,80),SUBSTRB("PRODUCT_DIM_20_CH_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."MD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_21_MD_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PL_NUM"',0,80),SUBSTRB("PRODUCT_DIM_22_PL_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ACT_NUM"',0,80),SUBSTRB("PRODUCT_DIM_23_ACT_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."STATUS"',0,80),SUBSTRB("PRODUCT_DIM_24_STATUS$1"(last_successful_index),0,2000));
                  
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
                "PRODUCT_DIM_err" := "PRODUCT_DIM_err" + 1;
                
                IF get_errors + "PRODUCT_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "PRODUCT_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "PRODUCT_DIM_si" >= "PRODUCT_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "PRODUCT_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"PRODUCT_DIM_0_ITEM_ID$1"(insert_bulk_index) := "PRODUCT_DIM_0_ITEM_ID$1"(update_bulk(j));
  		"PRODUCT_DIM_1_PROD_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_1_PROD_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_2_PROD_NAME$1"(insert_bulk_index) := "PRODUCT_DIM_2_PROD_NAME$1"(update_bulk(j));
  		"PRODUCT_DIM_3_PROD_CHANNEL$1"(insert_bulk_index) := "PRODUCT_DIM_3_PROD_CHANNEL$1"(update_bulk(j));
  		"PRODUCT_DIM_4_PROD_MODALITY$1"(insert_bulk_index) := "PRODUCT_DIM_4_PROD_MODALITY$1"(update_bulk(j));
  		"PRODUCT_DIM_5_PROD_LINE$1"(insert_bulk_index) := "PRODUCT_DIM_5_PROD_LINE$1"(update_bulk(j));
  		"PRODUCT_DIM_6_PROD_FAMILY$1"(insert_bulk_index) := "PRODUCT_DIM_6_PROD_FAMILY$1"(update_bulk(j));
  		"PRODUCT_DIM_7_LIST_PRICE$1"(insert_bulk_index) := "PRODUCT_DIM_7_LIST_PRICE$1"(update_bulk(j));
  		"PRODUCT_DIM_8_ORACLE_ITEM_N"(insert_bulk_index) := "PRODUCT_DIM_8_ORACLE_ITEM_N"(update_bulk(j));
  		"PRODUCT_DIM_9_CREATION_DATE$1"(insert_bulk_index) := "PRODUCT_DIM_9_CREATION_DATE$1"(update_bulk(j));
  		"PRODUCT__10_LAST_UPD$1"(insert_bulk_index) := "PRODUCT__10_LAST_UPD$1"(update_bulk(j));
  		"PRODUCT_DIM_15_GKDW_SOURCE$1"(insert_bulk_index) := "PRODUCT_DIM_15_GKDW_SOURCE$1"(update_bulk(j));
  		"PRODUCT_DIM_17_PRODUCT_ID$1"(insert_bulk_index) := "PRODUCT_DIM_17_PRODUCT_ID$1"(update_bulk(j));
  		"PRODUCT_DIM_18_LE_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_18_LE_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_19_FE_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_19_FE_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_20_CH_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_20_CH_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_21_MD_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_21_MD_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_22_PL_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_22_PL_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_23_ACT_NUM$1"(insert_bulk_index) := "PRODUCT_DIM_23_ACT_NUM$1"(update_bulk(j));
  		"PRODUCT_DIM_24_STATUS$1"(insert_bulk_index) := "PRODUCT_DIM_24_STATUS$1"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "PRODUCT_DIM_srk"(insert_bulk_index) := "PRODUCT_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "PRODUCT_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "PRODUCT_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "PRODUCT_DIM_si"..insert_bulk_index
          INSERT INTO
            "PRODUCT_DIM"
            ("PRODUCT_DIM"."ITEM_ID",
            "PRODUCT_DIM"."PROD_NUM",
            "PRODUCT_DIM"."PROD_NAME",
            "PRODUCT_DIM"."PROD_CHANNEL",
            "PRODUCT_DIM"."PROD_MODALITY",
            "PRODUCT_DIM"."PROD_LINE",
            "PRODUCT_DIM"."PROD_FAMILY",
            "PRODUCT_DIM"."LIST_PRICE",
            "PRODUCT_DIM"."ORACLE_ITEM_NUM",
            "PRODUCT_DIM"."CREATION_DATE",
            "PRODUCT_DIM"."LAST_UPDATE_DATE",
            "PRODUCT_DIM"."GKDW_SOURCE",
            "PRODUCT_DIM"."PRODUCT_ID",
            "PRODUCT_DIM"."LE_NUM",
            "PRODUCT_DIM"."FE_NUM",
            "PRODUCT_DIM"."CH_NUM",
            "PRODUCT_DIM"."MD_NUM",
            "PRODUCT_DIM"."PL_NUM",
            "PRODUCT_DIM"."ACT_NUM",
            "PRODUCT_DIM"."STATUS")
          VALUES
            ("PRODUCT_DIM_0_ITEM_ID$1"(i),
            "PRODUCT_DIM_1_PROD_NUM$1"(i),
            "PRODUCT_DIM_2_PROD_NAME$1"(i),
            "PRODUCT_DIM_3_PROD_CHANNEL$1"(i),
            "PRODUCT_DIM_4_PROD_MODALITY$1"(i),
            "PRODUCT_DIM_5_PROD_LINE$1"(i),
            "PRODUCT_DIM_6_PROD_FAMILY$1"(i),
            "PRODUCT_DIM_7_LIST_PRICE$1"(i),
            "PRODUCT_DIM_8_ORACLE_ITEM_N"(i),
            "PRODUCT_DIM_9_CREATION_DATE$1"(i),
            "PRODUCT__10_LAST_UPD$1"(i),
            "PRODUCT_DIM_15_GKDW_SOURCE$1"(i),
            "PRODUCT_DIM_17_PRODUCT_ID$1"(i),
            "PRODUCT_DIM_18_LE_NUM$1"(i),
            "PRODUCT_DIM_19_FE_NUM$1"(i),
            "PRODUCT_DIM_20_CH_NUM$1"(i),
            "PRODUCT_DIM_21_MD_NUM$1"(i),
            "PRODUCT_DIM_22_PL_NUM$1"(i),
            "PRODUCT_DIM_23_ACT_NUM$1"(i),
            "PRODUCT_DIM_24_STATUS$1"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "PRODUCT_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "PRODUCT_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "PRODUCT_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 156: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ITEM_ID"',0,80),SUBSTRB("PRODUCT_DIM_0_ITEM_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_1_PROD_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_NAME"',0,80),SUBSTRB("PRODUCT_DIM_2_PROD_NAME$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_CHANNEL"',0,80),SUBSTRB("PRODUCT_DIM_3_PROD_CHANNEL$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_MODALITY"',0,80),SUBSTRB("PRODUCT_DIM_4_PROD_MODALITY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_LINE"',0,80),SUBSTRB("PRODUCT_DIM_5_PROD_LINE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PROD_FAMILY"',0,80),SUBSTRB("PRODUCT_DIM_6_PROD_FAMILY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LIST_PRICE"',0,80),SUBSTRB("PRODUCT_DIM_7_LIST_PRICE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("PRODUCT_DIM_8_ORACLE_ITEM_N"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CREATION_DATE"',0,80),SUBSTRB("PRODUCT_DIM_9_CREATION_DATE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("PRODUCT__10_LAST_UPD$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("PRODUCT_DIM_15_GKDW_SOURCE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PRODUCT_ID"',0,80),SUBSTRB("PRODUCT_DIM_17_PRODUCT_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."LE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_18_LE_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."FE_NUM"',0,80),SUBSTRB("PRODUCT_DIM_19_FE_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."CH_NUM"',0,80),SUBSTRB("PRODUCT_DIM_20_CH_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."MD_NUM"',0,80),SUBSTRB("PRODUCT_DIM_21_MD_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."PL_NUM"',0,80),SUBSTRB("PRODUCT_DIM_22_PL_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."ACT_NUM"',0,80),SUBSTRB("PRODUCT_DIM_23_ACT_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"PRODUCT_DIM"."STATUS"',0,80),SUBSTRB("PRODUCT_DIM_24_STATUS$1"(error_index),0,2000));
            
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
          "PRODUCT_DIM_err" := "PRODUCT_DIM_err" + 1;
          
          IF get_errors + "PRODUCT_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "PRODUCT_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "PRODUCT_DIM_srk"(rowkey_index);
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
  
      "PRODUCT_DIM_ins" := "PRODUCT_DIM_ins" + get_rowid.COUNT;
      "PRODUCT_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "PRODUCT_DIM_ins" := "PRODUCT_DIM_ins0"; 
    "PRODUCT_DIM_upd" := "PRODUCT_DIM_upd0";
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

  IF NOT "PRODUCT_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "PRODUCT_DIM_St" THEN
          "PRODUCT_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"PRODUCT_DIM"',
              p_target_uoid=>'A41FFB19A9605678E040007F01006C7D',
              p_stm=>'TRACE 158',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "PRODUCT_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A9B55678E040007F01006C7D', -- Operator PRODUCTPROGRAM
              p_parent_object_name=>'PRODUCTPROGRAM',
              p_parent_object_uoid=>'A41FFB19102C5678E040007F01006C7D', -- Table PRODUCTPROGRAM
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCTPROGRAM',
              p_object_uoid=>'A41FFB19102C5678E040007F01006C7D', -- Table PRODUCTPROGRAM
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19AA6B5678E040007F01006C7D', -- Operator PRODUCT_DIM
              p_parent_object_name=>'PRODUCT_DIM',
              p_parent_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCT_DIM',
              p_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A9605678E040007F01006C7D', -- Operator PRODUCT_DIM
              p_parent_object_name=>'PRODUCT_DIM',
              p_parent_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCT_DIM',
              p_object_uoid=>'A41FA16DB1D8655CE040007F01006B9E', -- Table PRODUCT_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A95E5678E040007F01006C7D', -- Operator PRODUCT
              p_parent_object_name=>'PRODUCT',
              p_parent_object_uoid=>'A41FFB1910F95678E040007F01006C7D', -- Table PRODUCT
              p_parent_object_type=>'Table',
              p_object_name=>'PRODUCT',
              p_object_uoid=>'A41FFB1910F95678E040007F01006C7D', -- Table PRODUCT
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
    "PRODUCT_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU";

      LOOP
        IF "FLTR_si" = 0 THEN
          "FLTR_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_3_ACTUALID".COUNT - 1;
          ELSE
            bulk_count := "FLTR_3_ACTUALID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "PRODUCT_DIM_ir".DELETE;
"PRODUCT_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i" := "FLTR_si";
        BEGIN
          
          LOOP
            EXIT WHEN "PRODUCT_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i" := "FLTR_i" + 1;
            "FLTR_si" := "FLTR_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "PRODUCT_DIM_new" := FALSE;
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
            
                
                "GET_ORACLE_ITEM_ID"("FLTR_3_ACTUALID"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ORAC_2_INVENTOR"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_ORACLE_ITEM_ID"("FLTR_3_ACTUALID"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ORAC_2_INVENTOR"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_1_MD_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_MD_FLEX_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_1_MD_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_MD_FLEX_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_0_CH_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_CH_FLEX_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_0_CH_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_CH_FLEX_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_5_PL_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_PL_FLEX_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_5_PL_FLEX_VALUE_SET_","OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_FLEX_3_PL_FLEX_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ITEM_2_ITEM_NUM"
            ("FLTR_i"),"GET_ITEM_3_LE_NUM_O"
            ("FLTR_i"),"GET_ITEM_4_FE_NUM_O"
            ("FLTR_i"),"GET_ITEM_5_CH_NUM_O"
            ("FLTR_i"),"GET_ITEM_6_MD_NUM_O"
            ("FLTR_i"),"GET_ITEM_7_PL_NUM_O"
            ("FLTR_i"),"GET_ITEM_8_ACT_NUM_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_PRODUCT_DIM"."GET_CONST_6_COUNTRY","GET_ITEM_2_ITEM_NUM"
            ("FLTR_i"),"GET_ITEM_3_LE_NUM_O"
            ("FLTR_i"),"GET_ITEM_4_FE_NUM_O"
            ("FLTR_i"),"GET_ITEM_5_CH_NUM_O"
            ("FLTR_i"),"GET_ITEM_6_MD_NUM_O"
            ("FLTR_i"),"GET_ITEM_7_PL_NUM_O"
            ("FLTR_i"),"GET_ITEM_8_ACT_NUM_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            
get_target_name := '"PRODUCT_DIM"';
            get_audit_detail_id := "PRODUCT_DIM_id";
            IF NOT "PRODUCT_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"PRODUCT_DIM_0_ITEM_ID$1"("PRODUCT_DIM_i") := 
            
            "GET_ORAC_2_INVENTOR"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_0_ITEM_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ORAC_2_INVENTOR"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_0_ITEM_ID$1"("PRODUCT_DIM_i") :=
            
            "GET_ORAC_2_INVENTOR"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_0_ITEM_ID$1" :=
            
            "GET_ORAC_2_INVENTOR"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_1_PROD_NUM$1"("PRODUCT_DIM_i") := 
            
            "FLTR_3_ACTUALID"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_1_PROD_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_3_ACTUALID"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_1_PROD_NUM$1"("PRODUCT_DIM_i") :=
            
            "FLTR_3_ACTUALID"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_1_PROD_NUM$1" :=
            
            "FLTR_3_ACTUALID"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_2_PROD_NAME$1"("PRODUCT_DIM_i") := 
            
            "FLTR_1_PRODUCT_NAME"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_2_PROD_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_1_PRODUCT_NAME"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_2_PROD_NAME$1"("PRODUCT_DIM_i") :=
            
            "FLTR_1_PRODUCT_NAME"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_2_PROD_NAME$1" :=
            
            "FLTR_1_PRODUCT_NAME"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_3_PROD_CHANNEL$1"("PRODUCT_DIM_i") := 
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_3_PROD_CHANNEL$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_CH_FLEX_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_3_PROD_CHANNEL$1"("PRODUCT_DIM_i") :=
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_3_PROD_CHANN" :=
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_4_PROD_MODALITY$1"("PRODUCT_DIM_i") := 
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_4_PROD_MODALITY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_MD_FLEX_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_4_PROD_MODALITY$1"("PRODUCT_DIM_i") :=
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_4_PROD_MODALI" :=
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_5_PROD_LINE$1"("PRODUCT_DIM_i") := 
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_5_PROD_LINE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_PL_FLEX_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_5_PROD_LINE$1"("PRODUCT_DIM_i") :=
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_5_PROD_LINE$1" :=
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_6_PROD_FAMILY$1"("PRODUCT_DIM_i") := 
            
            "FLTR_4_FAMILY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_6_PROD_FAMILY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_4_FAMILY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_6_PROD_FAMILY$1"("PRODUCT_DIM_i") :=
            
            "FLTR_4_FAMILY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_6_PROD_FAMILY$1" :=
            
            "FLTR_4_FAMILY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_7_LIST_PRICE$1"("PRODUCT_DIM_i") := 
            
            "FLTR_5_PRICE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_7_LIST_PRICE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_5_PRICE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_7_LIST_PRICE$1"("PRODUCT_DIM_i") :=
            
            "FLTR_5_PRICE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_7_LIST_PRICE$1" :=
            
            "FLTR_5_PRICE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_8_ORACLE_ITEM_N"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_8_ORACLE_ITEM_N"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_2_ITEM_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_8_ORACLE_ITEM_N"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_8_ORACLE_ITEM" :=
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_9_CREATION_DATE$1"("PRODUCT_DIM_i") := 
            
            "FLTR_6_CREATEDATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_9_CREATION_DATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_6_CREATEDATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_9_CREATION_DATE$1"("PRODUCT_DIM_i") :=
            
            "FLTR_6_CREATEDATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_9_CREATION_DA" :=
            
            "FLTR_6_CREATEDATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT__10_LAST_UPD$1"("PRODUCT_DIM_i") := 
            
            "FLTR_8_MODIFYDATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT__10_LAST_UPD$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_8_MODIFYDATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT__10_LAST_UPD$1"("PRODUCT_DIM_i") :=
            
            "FLTR_8_MODIFYDATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT__10_LAST_UPD$1" :=
            
            "FLTR_8_MODIFYDATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_15_GKDW_SOURCE$1"("PRODUCT_DIM_i") := 
            
            "OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE";',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_15_GKDW_SOURCE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_15_GKDW_SOURCE$1"("PRODUCT_DIM_i") :=
            
            "OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE";
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_15_GKDW_SOUR" :=
            
            "OWB_PRODUCT_DIM"."GET_CONST_7_GKDW_SOURCE";
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_17_PRODUCT_ID$1"("PRODUCT_DIM_i") := 
            
            RTRIM("FLTR_0_PRODUCTID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_17_PRODUCT_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_0_PRODUCTID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_17_PRODUCT_ID$1"("PRODUCT_DIM_i") :=
            
            RTRIM("FLTR_0_PRODUCTID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_17_PRODUCT_ID$1" :=
            
            RTRIM("FLTR_0_PRODUCTID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_18_LE_NUM$1"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_18_LE_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_3_LE_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_18_LE_NUM$1"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_18_LE_NUM$1" :=
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_19_FE_NUM$1"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_19_FE_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_4_FE_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_19_FE_NUM$1"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_19_FE_NUM$1" :=
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_20_CH_NUM$1"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_20_CH_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_5_CH_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_20_CH_NUM$1"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_20_CH_NUM$1" :=
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_21_MD_NUM$1"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_21_MD_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_6_MD_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_21_MD_NUM$1"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_21_MD_NUM$1" :=
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_22_PL_NUM$1"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_22_PL_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_7_PL_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_22_PL_NUM$1"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_22_PL_NUM$1" :=
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_23_ACT_NUM$1"("PRODUCT_DIM_i") := 
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_23_ACT_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_8_ACT_NUM_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_23_ACT_NUM$1"("PRODUCT_DIM_i") :=
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_23_ACT_NUM$1" :=
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"PRODUCT_DIM_24_STATUS$1"("PRODUCT_DIM_i") := 
            
            "FLTR_11_STATUS"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"PRODUCT_DIM_24_STATUS$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_11_STATUS"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "PRODUCT_DIM_24_STATUS$1"("PRODUCT_DIM_i") :=
            
            "FLTR_11_STATUS"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_PRODUCT_DIM_24_STATUS$1" :=
            
            "FLTR_11_STATUS"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "PRODUCT_DIM_srk"("PRODUCT_DIM_i") := get_rowkey + "FLTR_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_PRODUCT_DIM_srk" := get_rowkey + "FLTR_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "PRODUCT_DIM_new" := TRUE;
                ELSE
                  "PRODUCT_DIM_i" := "PRODUCT_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER"('TRACE 159: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i");
                  
                  "PRODUCT_DIM_err" := "PRODUCT_DIM_err" + 1;
                  
                  IF get_errors + "PRODUCT_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("PRODUCT_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "PRODUCT_DIM_new" 
            AND (NOT "PRODUCT_DIM_nul") THEN
              "PRODUCT_DIM_ir"(dml_bsize) := "PRODUCT_DIM_i";
            	"PRODUCT_DIM_0_ITEM_ID$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_0_ITEM_ID$1";
            	"PRODUCT_DIM_1_PROD_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_1_PROD_NUM$1";
            	"PRODUCT_DIM_2_PROD_NAME$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_2_PROD_NAME$1";
            	"PRODUCT_DIM_3_PROD_CHANNEL$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_3_PROD_CHANN";
            	"PRODUCT_DIM_4_PROD_MODALITY$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_4_PROD_MODALI";
            	"PRODUCT_DIM_5_PROD_LINE$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_5_PROD_LINE$1";
            	"PRODUCT_DIM_6_PROD_FAMILY$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_6_PROD_FAMILY$1";
            	"PRODUCT_DIM_7_LIST_PRICE$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_7_LIST_PRICE$1";
            	"PRODUCT_DIM_8_ORACLE_ITEM_N"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_8_ORACLE_ITEM";
            	"PRODUCT_DIM_9_CREATION_DATE$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_9_CREATION_DA";
            	"PRODUCT__10_LAST_UPD$1"("PRODUCT_DIM_i") := "SV_PRODUCT__10_LAST_UPD$1";
            	"PRODUCT_DIM_15_GKDW_SOURCE$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_15_GKDW_SOUR";
            	"PRODUCT_DIM_17_PRODUCT_ID$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_17_PRODUCT_ID$1";
            	"PRODUCT_DIM_18_LE_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_18_LE_NUM$1";
            	"PRODUCT_DIM_19_FE_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_19_FE_NUM$1";
            	"PRODUCT_DIM_20_CH_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_20_CH_NUM$1";
            	"PRODUCT_DIM_21_MD_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_21_MD_NUM$1";
            	"PRODUCT_DIM_22_PL_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_22_PL_NUM$1";
            	"PRODUCT_DIM_23_ACT_NUM$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_23_ACT_NUM$1";
            	"PRODUCT_DIM_24_STATUS$1"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_24_STATUS$1";
              "PRODUCT_DIM_srk"("PRODUCT_DIM_i") := "SV_PRODUCT_DIM_srk";
              "PRODUCT_DIM_i" := "PRODUCT_DIM_i" + 1;
            ELSE
              "PRODUCT_DIM_ir"(dml_bsize) := 0;
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
            "FLTR_ER"('TRACE 157: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i");
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
    IF NOT "PRODUCT_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"PRODUCT_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"PRODUCT_DIM_ins",
        p_upd=>"PRODUCT_DIM_upd",
        p_del=>"PRODUCT_DIM_del",
        p_err=>"PRODUCT_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "PRODUCT_DIM_ins";
    get_updated  := get_updated  + "PRODUCT_DIM_upd";
    get_deleted  := get_deleted  + "PRODUCT_DIM_del";
    get_errors   := get_errors   + "PRODUCT_DIM_err";

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
      p_source=>'"SLXDW"."PRODUCT","SLXDW"."PRODUCTPROGRAM"',
      p_source_uoid=>'*',
      p_target=>'"PRODUCT_DIM"',
      p_target_uoid=>'A41FFB19A9605678E040007F01006C7D',      p_info=>NULL,
      
            p_type=>'PLSQLMap',
      
      p_date=>get_cycle_date
    );
  END IF;



BEGIN
  -- Expression statement
      error_stmt := SUBSTRB('
  
      
      GET_MAX_DATE("OWB_PRODUCT_DIM"."GET_CONST_2_TABLE_NAME","OWB_PRODUCT_DIM"."PREMAPPING_1_CREATE_DATE_OUT","OWB_PRODUCT_DIM"."PREMAPPING_2_MODIFY_DATE_OUT");
  
  ',0,2000);
  
      
      GET_MAX_DATE("OWB_PRODUCT_DIM"."GET_CONST_2_TABLE_NAME","OWB_PRODUCT_DIM"."PREMAPPING_1_CREATE_DATE_OUT","OWB_PRODUCT_DIM"."PREMAPPING_2_MODIFY_DATE_OUT");
  
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
  "PRODUCT_DIM_St" := FALSE;
  IF get_trigger_success THEN

  --  Processing for different operating modes
  IF get_operating_mode = MODE_SET THEN
    RAISE_APPLICATION_ERROR(-20101, 'Set based mode not supported');
  END IF;
  IF get_operating_mode = MODE_ROW THEN
		"JOIN_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"PRODUCT_DIM_St" := FALSE;

      END IF;
    END IF;

"JOIN_p";

  END IF;
  IF get_operating_mode = MODE_ROW_TARGET THEN
"FLTR_t";

  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW_TARGET THEN
    IF NOT get_batch_status AND get_use_hc THEN
      get_inserted := 0;
      get_updated  := 0;
      get_deleted  := 0;
      get_merged   := 0;
      get_logical_errors := 0;
"PRODUCT_DIM_St" := FALSE;

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
  AND    uo.object_name = 'OWB_PRODUCT_DIM'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_PRODUCT_DIM', x_schema, x_audit_id, x_object_id);

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
  IF "JOIN_c"%ISOPEN THEN
    CLOSE "JOIN_c";
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



END "OWB_PRODUCT_DIM";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_PRODUCT_DIM TO DWHREAD;

