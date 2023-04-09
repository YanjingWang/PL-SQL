DROP PACKAGE BODY GKDW.OWB_COURSE_DIM;

CREATE OR REPLACE PACKAGE BODY GKDW."OWB_COURSE_DIM" AS

-- Define cursors here so that they have global scope within the package (for debugger)

---------------------------------------------------------------------------
--
-- "FLTR_c" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c" IS
  SELECT
  "EVXCOURSE"."EVXCOURSEID" "EVXCOURSEID",
  "EVXCOURSE"."COURSENAME" "COURSENAME",
  "EVXCOURSEFEE"."CURRENCY" "CURRENCY",
  "EVXCOURSE"."COURSECODE" "COURSECODE",
  "EVXCOURSEFEE"."AMOUNT" "AMOUNT",
  "EVXCOURSE"."CREATEDATE" "CREATEDATE",
  "EVXCOURSE"."MODIFYDATE" "MODIFYDATE",
  "EVXCOURSE"."ISINACTIVE" "ISINACTIVE",
  "EVXCOURSE"."COURSENUMBER" "COURSENUMBER",
  "EVXCOURSE"."COURSEGROUP" "COURSEGROUP",
  "QG_COURSE"."VENDORCODE" "VENDORCODE",
  "EVXCOURSE"."SHORTNAME" "SHORTNAME",
  "QG_COURSE"."DURATION" "DURATION",
  "QG_COURSE"."UOM" "UOM",
  "EVXCOURSE"."COURSETYPE" "COURSETYPE",
  "QG_COURSE"."CAPACITY" "CAPACITY",
  "RMS_COURSE"."COURSE_DESC" "COURSE_DESC",
  "RMS_COURSE"."ITBT" "ITBT",
  "RMS_COURSE"."ROOT_CODE" "ROOT_CODE",
  "RMS_COURSE"."LINE_OF_BUSINESS" "LINE_OF_BUSINESS",
  "RMS_COURSE"."MCMASTERS_ELIGIBLE" "MCMASTERS_ELIGIBLE",
  "RMS_COURSE"."MFG_COURSE_CODE" "MFG_COURSE_CODE"
FROM
    "SLXDW"."EVXCOURSE"  "EVXCOURSE"   
 JOIN   "SLXDW"."EVXCOURSEFEE"  "EVXCOURSEFEE" ON ( ( "EVXCOURSE"."EVXCOURSEID" = "EVXCOURSEFEE"."EVXCOURSEID" ) )
 LEFT OUTER JOIN   "SLXDW"."QG_COURSE"  "QG_COURSE" ON ( ( ( "QG_COURSE"."EVXCOURSEID" = "EVXCOURSE"."EVXCOURSEID" ) ) )
 LEFT OUTER JOIN   "RMSDW"."RMS_COURSE"  "RMS_COURSE" ON ( ( "RMS_COURSE"."SLX_COURSE_ID" = "EVXCOURSE"."EVXCOURSEID" ) )
  WHERE 
  ( ( "EVXCOURSE"."CREATEDATE" >= "OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT" or "EVXCOURSE"."MODIFYDATE" >= "OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" ) or ( "EVXCOURSEFEE"."CREATEDATE" >= "OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT" or "EVXCOURSEFEE"."MODIFYDATE" >= "OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" ) ) AND
  ( upper ( trim ( "EVXCOURSEFEE"."FEETYPE" ) ) in ( 'PRIMARY' , 'ONS - BASE' ) ) AND
  ( "EVXCOURSEFEE"."FEEALLOWUSE" = 'T' Or "EVXCOURSE"."ISINACTIVE" = 'T' ) AND
  ( "EVXCOURSEFEE"."FEEAVAILABLE" = 'T' or "EVXCOURSE"."ISINACTIVE" = 'T' ); 

---------------------------------------------------------------------------
--
-- "FLTR_c$1" Cursor declaration 
--
---------------------------------------------------------------------------
CURSOR "FLTR_c$1" IS
  SELECT
  "EVXCOURSE"."EVXCOURSEID" "EVXCOURSEID$1",
  UPPER(TRIM( "EVXCOURSE"."COURSENAME" ))/* EXPR.OUTGRP1.COURSE_NAME */ "COURSE_NAME",
  "EVXCOURSE"."COURSECODE" "COURSECODE$1",
  case  "EVXCOURSEFEE"."CURRENCY" 
when 'USD'
then 'USA'
when 'CAD'
then 'CANADA'
else 'USA'
end/* EXPR.OUTGRP1.COUNTRY */ "COUNTRY",
  "EVXCOURSEFEE"."AMOUNT" "AMOUNT$1",
  "EVXCOURSE"."CREATEDATE" "CREATEDATE$1",
  "EVXCOURSE"."MODIFYDATE" "MODIFYDATE$1",
  "EVXCOURSE"."ISINACTIVE" "ISINACTIVE$1",
  "EVXCOURSE"."COURSENUMBER" "COURSENUMBER$1",
  "EVXCOURSE"."COURSEGROUP" "COURSEGROUP$1",
  "QG_COURSE"."VENDORCODE" "VENDORCODE",
  "EVXCOURSE"."SHORTNAME" "SHORTNAME$1",
  case
  when upper(trim( "QG_COURSE"."UOM" )) like 'DAY%'
      then  "QG_COURSE"."DURATION" 
  when upper(trim( "QG_COURSE"."UOM" )) like 'HOUR%'
      then  ("QG_COURSE"."DURATION"/8)
  when upper(trim( "QG_COURSE"."UOM" )) like 'WEEK%'
      then  ("QG_COURSE"."DURATION"  * 5)
  else nvl("QG_COURSE"."DURATION" , 0)
  end/* EXPR_1.OUTGRP1.DURATION_IN_DAYS */ "DURATION_IN_DAYS",
  "EVXCOURSE"."COURSETYPE" "COURSETYPE$1",
  "QG_COURSE"."CAPACITY" "CAPACITY",
  "RMS_COURSE"."COURSE_DESC" "COURSE_DESC",
  "RMS_COURSE"."ITBT" "ITBT",
  "RMS_COURSE"."ROOT_CODE" "ROOT_CODE",
  "RMS_COURSE"."LINE_OF_BUSINESS" "LINE_OF_BUSINESS",
  "RMS_COURSE"."MCMASTERS_ELIGIBLE" "MCMASTERS_ELIGIBLE",
  "RMS_COURSE"."MFG_COURSE_CODE" "MFG_COURSE_CODE"
FROM
    "SLXDW"."EVXCOURSE"  "EVXCOURSE"   
 JOIN   "SLXDW"."EVXCOURSEFEE"  "EVXCOURSEFEE" ON ( ( "EVXCOURSE"."EVXCOURSEID" = "EVXCOURSEFEE"."EVXCOURSEID" ) )
 LEFT OUTER JOIN   "SLXDW"."QG_COURSE"  "QG_COURSE" ON ( ( ( "QG_COURSE"."EVXCOURSEID" = "EVXCOURSE"."EVXCOURSEID" ) ) )
 LEFT OUTER JOIN   "RMSDW"."RMS_COURSE"  "RMS_COURSE" ON ( ( "RMS_COURSE"."SLX_COURSE_ID" = "EVXCOURSE"."EVXCOURSEID" ) )
  WHERE 
  ( ( "EVXCOURSE"."CREATEDATE" >= "OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT" or "EVXCOURSE"."MODIFYDATE" >= "OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" ) or ( "EVXCOURSEFEE"."CREATEDATE" >= "OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT" or "EVXCOURSEFEE"."MODIFYDATE" >= "OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" ) ) AND
  ( upper ( trim ( "EVXCOURSEFEE"."FEETYPE" ) ) in ( 'PRIMARY' , 'ONS - BASE' ) ) AND
  ( "EVXCOURSEFEE"."FEEALLOWUSE" = 'T' Or "EVXCOURSE"."ISINACTIVE" = 'T' ) AND
  ( "EVXCOURSEFEE"."FEEAVAILABLE" = 'T' or "EVXCOURSE"."ISINACTIVE" = 'T' ); 


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
FUNCTION "GET_CONST_2_ORGANIZATION_ID" RETURN NUMBER IS
BEGIN
  RETURN "CONST_2_ORGANIZATION_ID";
END "GET_CONST_2_ORGANIZATION_ID";
FUNCTION "GET_CONST_3_INVOICEABLE_ITEM_" RETURN VARCHAR2 IS
BEGIN
  RETURN "CONST_3_INVOICEABLE_ITEM_FLAG";
END "GET_CONST_3_INVOICEABLE_ITEM_";
FUNCTION "GET_CONST_4_CH_FLEX_VALUE_SET_" RETURN NUMBER IS
BEGIN
  RETURN "CONST_4_CH_FLEX_VALUE_SET_ID";
END "GET_CONST_4_CH_FLEX_VALUE_SET_";
FUNCTION "GET_CONST_5_MD_FLEX_VALUE_SET_" RETURN NUMBER IS
BEGIN
  RETURN "CONST_5_MD_FLEX_VALUE_SET_ID";
END "GET_CONST_5_MD_FLEX_VALUE_SET_";
FUNCTION "GET_CONST_6_PL_FLEX_VALUE_SET_" RETURN NUMBER IS
BEGIN
  RETURN "CONST_6_PL_FLEX_VALUE_SET_ID";
END "GET_CONST_6_PL_FLEX_VALUE_SET_";
FUNCTION "get_PREMAPPING_1_CREATE_DATE_O" RETURN DATE IS
BEGIN
  RETURN "PREMAPPING_1_CREATE_DATE_OUT";
END "get_PREMAPPING_1_CREATE_DATE_O";
FUNCTION "get_PREMAPPING_2_MODIFY_DATE_O" RETURN DATE IS
BEGIN
  RETURN "PREMAPPING_2_MODIFY_DATE_OUT";
END "get_PREMAPPING_2_MODIFY_DATE_O";





-- Procedure "FLTR_p" is the entry point for map "FLTR_p"

PROCEDURE "FLTR_p"
 IS
-- Constants for this map
get_map_name               CONSTANT VARCHAR2(40) := '"FLTR_p"';
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB199F715678E040007F01006C7D,A41FFB199F6A5678E040007F01006C7D,A41FFB199F4B5678E040007F01006C7D,A41FFB199F4A5678E040007F01006C7D';
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

"COURSE_DIM_id" NUMBER(22) := 0;
"COURSE_DIM_ins" NUMBER(22) := 0;
"COURSE_DIM_upd" NUMBER(22) := 0;
"COURSE_DIM_del" NUMBER(22) := 0;
"COURSE_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"COURSE_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"COURSE_DIM_ir"  index_redirect_array;
"SV_COURSE_DIM_srk" NUMBER;
"COURSE_DIM_new"  BOOLEAN;
"COURSE_DIM_nul"  BOOLEAN := FALSE;

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


"COURSE_DIM_si" NUMBER(22) := 0;

"COURSE_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_2_EVXCOURSEID" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_3_COURSENAME" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_24_CURRENCY" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_2_COURSE_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_3_COUNTRY" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_13_COURSECODE" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ORAC_2_INVENTOR" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DUMMY_TABLE_CURSOR" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_CH_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_MD_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_PL_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_23_AMOUNT" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_2_ITEM_NUM" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_3_LE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_4_FE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_5_CH_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_6_MD_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_7_PL_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_8_ACT_NUM_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_16_CREATEDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_18_MODIFYDATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_7_ISINACTIVE" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_8_COURSENUMBER" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_11_COURSEGROUP" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_QG_COURSE_12_VENDORCODE" IS TABLE OF VARCHAR2(16) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_4_SHORTNAME" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_QG_COURSE_7_DURATION" IS TABLE OF FLOAT(49) INDEX BY BINARY_INTEGER;
TYPE "T_QG_COURSE_8_UOM" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_2_DURATION_IN_DAYS" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_10_COURSETYPE" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_QG_COURSE_11_CAPACITY" IS TABLE OF NUMBER(10) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_35_COURSE_DESC" IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_36_ITBT" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_37_ROOT_CODE" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_38_LINE_OF_BUSINE" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COUR_46_MCMASTER" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_47_MFG_COURSE_CO" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_0_COURSE_ID" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_1_COURSE_NAME" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_2_COURSE_CH" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_3_COURSE_MOD" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_4_COURSE_PL" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_5_LIST_PRICE" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_6_ORACLE_ITEM_ID" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_7_ORACLE_ITEM_NUM" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_8_CREATION_DATE" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_9_LAST_UPDATE_DA" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_14_GKDW_SOURCE" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_16_COURSE_CODE" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_17_COUNTRY" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_18_INACTIVE_FLAG" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_19_COURSE_NUM" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_20_LE_NUM" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_21_FE_NUM" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_22_CH_NUM" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_23_MD_NUM" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_24_PL_NUM" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_25_ACT_NUM" IS TABLE OF VARCHAR2(6) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_26_COURSE_GROUP" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_27_VENDOR_CODE" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_28_SHORT_NAME" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_29_DURATION_DAYS" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_30_COURSE_TYPE" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_31_CAPACITY" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_32_COURSE_DESC" IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_33_ITBT" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_34_ROOT_CODE" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_35_LINE_OF_BUSINE" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_D_36_MCMASTER" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_37_MFG_COURSE_CO" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_2_EVXCOURSEID"  CHAR(12);
"SV_ROWKEY_FLTR"  VARCHAR2(18);
"SV_FLTR_3_COURSENAME"  VARCHAR2(128);
"SV_FLTR_24_CURRENCY"  VARCHAR2(32);
"SV_EXPR_2_COURSE_NAME"  VARCHAR2(250);
"SV_EXPR_3_COUNTRY"  VARCHAR2(60);
"SV_FLTR_13_COURSECODE"  VARCHAR2(32);
"SV_GET_ORAC_2_INVENTOR"  NUMBER;
"SV_ROWKEY_DUMMY_TABLE_CURSOR"  VARCHAR2(18);
"SV_GET_FLEX_3_CH_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_MD_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_PL_FLEX_"  VARCHAR2(32767);
"SV_FLTR_23_AMOUNT"  NUMBER;
"SV_GET_ITEM_2_ITEM_NUM"  VARCHAR2(32767);
"SV_GET_ITEM_3_LE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_4_FE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_5_CH_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_6_MD_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_7_PL_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_8_ACT_NUM_"  VARCHAR2(32767);
"SV_FLTR_16_CREATEDATE"  DATE;
"SV_FLTR_18_MODIFYDATE"  DATE;
"SV_FLTR_7_ISINACTIVE"  CHAR(1);
"SV_FLTR_8_COURSENUMBER"  VARCHAR2(32);
"SV_FLTR_11_COURSEGROUP"  VARCHAR2(64);
"SV_QG_COURSE_12_VENDORCODE"  VARCHAR2(16);
"SV_FLTR_4_SHORTNAME"  VARCHAR2(32);
"SV_QG_COURSE_7_DURATION"  FLOAT(49);
"SV_QG_COURSE_8_UOM"  VARCHAR2(32);
"SV_EXPR_1_2_DURATION_IN_DAYS"  NUMBER;
"SV_FLTR_10_COURSETYPE"  VARCHAR2(64);
"SV_QG_COURSE_11_CAPACITY"  NUMBER(10);
"SV_RMS_COURSE_35_COURSE_DESC"  VARCHAR2(255);
"SV_RMS_COURSE_36_ITBT"  CHAR(1);
"SV_RMS_COURSE_37_ROOT_CODE"  VARCHAR2(128);
"SV_RMS_COURSE_38_LINE_OF_BUSI"  VARCHAR2(128);
"SV_RMS_COUR_46_MCMASTER"  CHAR(1);
"SV_RMS_COURSE_47_MFG_COURSE_CO"  VARCHAR2(128);
"SV_COURSE_DIM_0_COURSE_ID"  VARCHAR2(50);
"SV_COURSE_DIM_1_COURSE_NAME"  VARCHAR2(250);
"SV_COURSE_DIM_2_COURSE_CH"  VARCHAR2(50);
"SV_COURSE_DIM_3_COURSE_MOD"  VARCHAR2(50);
"SV_COURSE_DIM_4_COURSE_PL"  VARCHAR2(50);
"SV_COURSE_DIM_5_LIST_PRICE"  NUMBER;
"SV_COURSE_DIM_6_ORACLE_ITEM_ID"  NUMBER;
"SV_COURSE_DIM_7_ORACLE_ITEM_N"  VARCHAR2(50);
"SV_COURSE_DIM_8_CREATION_DATE"  DATE;
"SV_COURSE_DIM_9_LAST_UPDATE_DA"  DATE;
"SV_COURSE_DIM_14_GKDW_SOURCE"  VARCHAR2(20);
"SV_COURSE_DIM_16_COURSE_CODE"  VARCHAR2(50);
"SV_COURSE_DIM_17_COUNTRY"  VARCHAR2(60);
"SV_COURSE_DIM_18_INACTIVE_FLAG"  VARCHAR2(10);
"SV_COURSE_DIM_19_COURSE_NUM"  VARCHAR2(20);
"SV_COURSE_DIM_20_LE_NUM"  VARCHAR2(3);
"SV_COURSE_DIM_21_FE_NUM"  VARCHAR2(3);
"SV_COURSE_DIM_22_CH_NUM"  VARCHAR2(2);
"SV_COURSE_DIM_23_MD_NUM"  VARCHAR2(2);
"SV_COURSE_DIM_24_PL_NUM"  VARCHAR2(2);
"SV_COURSE_DIM_25_ACT_NUM"  VARCHAR2(6);
"SV_COURSE_DIM_26_COURSE_GROUP"  VARCHAR2(100);
"SV_COURSE_DIM_27_VENDOR_CODE"  VARCHAR2(20);
"SV_COURSE_DIM_28_SHORT_NAME"  VARCHAR2(50);
"SV_COURSE_DIM_29_DURATION_DAYS"  NUMBER;
"SV_COURSE_DIM_30_COURSE_TYPE"  VARCHAR2(64);
"SV_COURSE_DIM_31_CAPACITY"  NUMBER;
"SV_COURSE_DIM_32_COURSE_DESC"  VARCHAR2(255);
"SV_COURSE_DIM_33_ITBT"  CHAR(1);
"SV_COURSE_DIM_34_ROOT_CODE"  VARCHAR2(128);
"SV_COURSE_DIM_35_LINE_OF_BUSI"  VARCHAR2(128);
"SV_COURSE_D_36_MCMASTER"  CHAR(1);
"SV_COURSE_DIM_37_MFG_COURSE_CO"  VARCHAR2(128);

-- Bulk: intermediate collection variables
"FLTR_2_EVXCOURSEID" "T_FLTR_2_EVXCOURSEID";
"ROWKEY_FLTR" "T_ROWKEY_FLTR";
"FLTR_3_COURSENAME" "T_FLTR_3_COURSENAME";
"FLTR_24_CURRENCY" "T_FLTR_24_CURRENCY";
"EXPR_2_COURSE_NAME" "T_EXPR_2_COURSE_NAME";
"EXPR_3_COUNTRY" "T_EXPR_3_COUNTRY";
"FLTR_13_COURSECODE" "T_FLTR_13_COURSECODE";
"GET_ORAC_2_INVENTOR" "T_GET_ORAC_2_INVENTOR";
"ROWKEY_DUMMY_TABLE_CURSOR" "T_ROWKEY_DUMMY_TABLE_CURSOR";
"GET_FLEX_3_CH_FLEX_" "T_GET_FLEX_3_CH_FLEX_";
"GET_FLEX_3_MD_FLEX_" "T_GET_FLEX_3_MD_FLEX_";
"GET_FLEX_3_PL_FLEX_" "T_GET_FLEX_3_PL_FLEX_";
"FLTR_23_AMOUNT" "T_FLTR_23_AMOUNT";
"GET_ITEM_2_ITEM_NUM" "T_GET_ITEM_2_ITEM_NUM";
"GET_ITEM_3_LE_NUM_O" "T_GET_ITEM_3_LE_NUM_O";
"GET_ITEM_4_FE_NUM_O" "T_GET_ITEM_4_FE_NUM_O";
"GET_ITEM_5_CH_NUM_O" "T_GET_ITEM_5_CH_NUM_O";
"GET_ITEM_6_MD_NUM_O" "T_GET_ITEM_6_MD_NUM_O";
"GET_ITEM_7_PL_NUM_O" "T_GET_ITEM_7_PL_NUM_O";
"GET_ITEM_8_ACT_NUM_" "T_GET_ITEM_8_ACT_NUM_";
"FLTR_16_CREATEDATE" "T_FLTR_16_CREATEDATE";
"FLTR_18_MODIFYDATE" "T_FLTR_18_MODIFYDATE";
"FLTR_7_ISINACTIVE" "T_FLTR_7_ISINACTIVE";
"FLTR_8_COURSENUMBER" "T_FLTR_8_COURSENUMBER";
"FLTR_11_COURSEGROUP" "T_FLTR_11_COURSEGROUP";
"QG_COURSE_12_VENDORCODE" "T_QG_COURSE_12_VENDORCODE";
"FLTR_4_SHORTNAME" "T_FLTR_4_SHORTNAME";
"QG_COURSE_7_DURATION" "T_QG_COURSE_7_DURATION";
"QG_COURSE_8_UOM" "T_QG_COURSE_8_UOM";
"EXPR_1_2_DURATION_IN_DAYS" "T_EXPR_1_2_DURATION_IN_DAYS";
"FLTR_10_COURSETYPE" "T_FLTR_10_COURSETYPE";
"QG_COURSE_11_CAPACITY" "T_QG_COURSE_11_CAPACITY";
"RMS_COURSE_35_COURSE_DESC" "T_RMS_COURSE_35_COURSE_DESC";
"RMS_COURSE_36_ITBT" "T_RMS_COURSE_36_ITBT";
"RMS_COURSE_37_ROOT_CODE" "T_RMS_COURSE_37_ROOT_CODE";
"RMS_COURSE_38_LINE_OF_BUSINESS" "T_RMS_COURSE_38_LINE_OF_BUSINE";
"RMS_COUR_46_MCMASTER" "T_RMS_COUR_46_MCMASTER";
"RMS_COURSE_47_MFG_COURSE_CODE" "T_RMS_COURSE_47_MFG_COURSE_CO";
"COURSE_DIM_0_COURSE_ID" "T_COURSE_DIM_0_COURSE_ID";
"COURSE_DIM_1_COURSE_NAME" "T_COURSE_DIM_1_COURSE_NAME";
"COURSE_DIM_2_COURSE_CH" "T_COURSE_DIM_2_COURSE_CH";
"COURSE_DIM_3_COURSE_MOD" "T_COURSE_DIM_3_COURSE_MOD";
"COURSE_DIM_4_COURSE_PL" "T_COURSE_DIM_4_COURSE_PL";
"COURSE_DIM_5_LIST_PRICE" "T_COURSE_DIM_5_LIST_PRICE";
"COURSE_DIM_6_ORACLE_ITEM_ID" "T_COURSE_DIM_6_ORACLE_ITEM_ID";
"COURSE_DIM_7_ORACLE_ITEM_NUM" "T_COURSE_DIM_7_ORACLE_ITEM_NUM";
"COURSE_DIM_8_CREATION_DATE" "T_COURSE_DIM_8_CREATION_DATE";
"COURSE_DIM_9_LAST_UPDATE_DATE" "T_COURSE_DIM_9_LAST_UPDATE_DA";
"COURSE_DIM_14_GKDW_SOURCE" "T_COURSE_DIM_14_GKDW_SOURCE";
"COURSE_DIM_16_COURSE_CODE" "T_COURSE_DIM_16_COURSE_CODE";
"COURSE_DIM_17_COUNTRY" "T_COURSE_DIM_17_COUNTRY";
"COURSE_DIM_18_INACTIVE_FLAG" "T_COURSE_DIM_18_INACTIVE_FLAG";
"COURSE_DIM_19_COURSE_NUM" "T_COURSE_DIM_19_COURSE_NUM";
"COURSE_DIM_20_LE_NUM" "T_COURSE_DIM_20_LE_NUM";
"COURSE_DIM_21_FE_NUM" "T_COURSE_DIM_21_FE_NUM";
"COURSE_DIM_22_CH_NUM" "T_COURSE_DIM_22_CH_NUM";
"COURSE_DIM_23_MD_NUM" "T_COURSE_DIM_23_MD_NUM";
"COURSE_DIM_24_PL_NUM" "T_COURSE_DIM_24_PL_NUM";
"COURSE_DIM_25_ACT_NUM" "T_COURSE_DIM_25_ACT_NUM";
"COURSE_DIM_26_COURSE_GROUP" "T_COURSE_DIM_26_COURSE_GROUP";
"COURSE_DIM_27_VENDOR_CODE" "T_COURSE_DIM_27_VENDOR_CODE";
"COURSE_DIM_28_SHORT_NAME" "T_COURSE_DIM_28_SHORT_NAME";
"COURSE_DIM_29_DURATION_DAYS" "T_COURSE_DIM_29_DURATION_DAYS";
"COURSE_DIM_30_COURSE_TYPE" "T_COURSE_DIM_30_COURSE_TYPE";
"COURSE_DIM_31_CAPACITY" "T_COURSE_DIM_31_CAPACITY";
"COURSE_DIM_32_COURSE_DESC" "T_COURSE_DIM_32_COURSE_DESC";
"COURSE_DIM_33_ITBT" "T_COURSE_DIM_33_ITBT";
"COURSE_DIM_34_ROOT_CODE" "T_COURSE_DIM_34_ROOT_CODE";
"COURSE_DIM_35_LINE_OF_BUSINESS" "T_COURSE_DIM_35_LINE_OF_BUSINE";
"COURSE_D_36_MCMASTER" "T_COURSE_D_36_MCMASTER";
"COURSE_DIM_37_MFG_COURSE_CODE" "T_COURSE_DIM_37_MFG_COURSE_CO";

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
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_2_EVXCOURSEID',0,80),
    p_value=>SUBSTRB("FLTR_2_EVXCOURSEID"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_3_COURSENAME',0,80),
    p_value=>SUBSTRB("FLTR_3_COURSENAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_24_CURRENCY',0,80),
    p_value=>SUBSTRB("FLTR_24_CURRENCY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_13_COURSECODE',0,80),
    p_value=>SUBSTRB("FLTR_13_COURSECODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_23_AMOUNT',0,80),
    p_value=>SUBSTRB("FLTR_23_AMOUNT"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_16_CREATEDATE',0,80),
    p_value=>SUBSTRB("FLTR_16_CREATEDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_18_MODIFYDATE',0,80),
    p_value=>SUBSTRB("FLTR_18_MODIFYDATE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_7_ISINACTIVE',0,80),
    p_value=>SUBSTRB("FLTR_7_ISINACTIVE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_8_COURSENUMBER',0,80),
    p_value=>SUBSTRB("FLTR_8_COURSENUMBER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_11_COURSEGROUP',0,80),
    p_value=>SUBSTRB("FLTR_11_COURSEGROUP"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('QG_COURSE_12_VENDORCODE',0,80),
    p_value=>SUBSTRB("QG_COURSE_12_VENDORCODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_4_SHORTNAME',0,80),
    p_value=>SUBSTRB("FLTR_4_SHORTNAME"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('QG_COURSE_7_DURATION',0,80),
    p_value=>SUBSTRB("QG_COURSE_7_DURATION"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('QG_COURSE_8_UOM',0,80),
    p_value=>SUBSTRB("QG_COURSE_8_UOM"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>15,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_10_COURSETYPE',0,80),
    p_value=>SUBSTRB("FLTR_10_COURSETYPE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>16,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('QG_COURSE_11_CAPACITY',0,80),
    p_value=>SUBSTRB("QG_COURSE_11_CAPACITY"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>17,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_35_COURSE_DESC',0,80),
    p_value=>SUBSTRB("RMS_COURSE_35_COURSE_DESC"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>18,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_36_ITBT',0,80),
    p_value=>SUBSTRB("RMS_COURSE_36_ITBT"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>19,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_37_ROOT_CODE',0,80),
    p_value=>SUBSTRB("RMS_COURSE_37_ROOT_CODE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>20,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_38_LINE_OF_BUSINESS',0,80),
    p_value=>SUBSTRB("RMS_COURSE_38_LINE_OF_BUSINESS"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>21,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COUR_46_MCMASTER',0,80),
    p_value=>SUBSTRB("RMS_COUR_46_MCMASTER"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>22,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_47_MFG_COURSE_CODE',0,80),
    p_value=>SUBSTRB("RMS_COURSE_47_MFG_COURSE_CODE"(error_index),0,2000),
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
      p_stm=>'TRACE 88: ' || p_statement,
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
    "FLTR_2_EVXCOURSEID".DELETE;
    "FLTR_3_COURSENAME".DELETE;
    "FLTR_24_CURRENCY".DELETE;
    "FLTR_13_COURSECODE".DELETE;
    "FLTR_23_AMOUNT".DELETE;
    "FLTR_16_CREATEDATE".DELETE;
    "FLTR_18_MODIFYDATE".DELETE;
    "FLTR_7_ISINACTIVE".DELETE;
    "FLTR_8_COURSENUMBER".DELETE;
    "FLTR_11_COURSEGROUP".DELETE;
    "QG_COURSE_12_VENDORCODE".DELETE;
    "FLTR_4_SHORTNAME".DELETE;
    "QG_COURSE_7_DURATION".DELETE;
    "QG_COURSE_8_UOM".DELETE;
    "FLTR_10_COURSETYPE".DELETE;
    "QG_COURSE_11_CAPACITY".DELETE;
    "RMS_COURSE_35_COURSE_DESC".DELETE;
    "RMS_COURSE_36_ITBT".DELETE;
    "RMS_COURSE_37_ROOT_CODE".DELETE;
    "RMS_COURSE_38_LINE_OF_BUSINESS".DELETE;
    "RMS_COUR_46_MCMASTER".DELETE;
    "RMS_COURSE_47_MFG_COURSE_CODE".DELETE;

    FETCH
      "FLTR_c"
    BULK COLLECT INTO
      "FLTR_2_EVXCOURSEID",
      "FLTR_3_COURSENAME",
      "FLTR_24_CURRENCY",
      "FLTR_13_COURSECODE",
      "FLTR_23_AMOUNT",
      "FLTR_16_CREATEDATE",
      "FLTR_18_MODIFYDATE",
      "FLTR_7_ISINACTIVE",
      "FLTR_8_COURSENUMBER",
      "FLTR_11_COURSEGROUP",
      "QG_COURSE_12_VENDORCODE",
      "FLTR_4_SHORTNAME",
      "QG_COURSE_7_DURATION",
      "QG_COURSE_8_UOM",
      "FLTR_10_COURSETYPE",
      "QG_COURSE_11_CAPACITY",
      "RMS_COURSE_35_COURSE_DESC",
      "RMS_COURSE_36_ITBT",
      "RMS_COURSE_37_ROOT_CODE",
      "RMS_COURSE_38_LINE_OF_BUSINESS",
      "RMS_COUR_46_MCMASTER",
      "RMS_COURSE_47_MFG_COURSE_CODE"
    LIMIT get_bulk_size;

    IF "FLTR_c"%NOTFOUND AND "FLTR_2_EVXCOURSEID".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_2_EVXCOURSEID".COUNT;
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
    get_map_selected := get_map_selected + "FLTR_2_EVXCOURSEID".COUNT;
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
          p_stm=>'TRACE 89: SELECT',
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
  "COURSE_DIM_ins0" NUMBER := "COURSE_DIM_ins";
  "COURSE_DIM_upd0" NUMBER := "COURSE_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "COURSE_DIM_St" THEN
  -- Update/Insert DML for "COURSE_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"COURSE_DIM"';
    get_audit_detail_id := "COURSE_DIM_id";
    "COURSE_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "COURSE_DIM_i" > get_bulk_size 
   OR "FLTR_c"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "COURSE_DIM_si".."COURSE_DIM_i" - 1 
            UPDATE
              "COURSE_DIM"
            SET
  
  						"COURSE_DIM"."COURSE_NAME" = "COURSE_DIM_1_COURSE_NAME"
  (i),						"COURSE_DIM"."COURSE_CH" = "COURSE_DIM_2_COURSE_CH"
  (i),						"COURSE_DIM"."COURSE_MOD" = "COURSE_DIM_3_COURSE_MOD"
  (i),						"COURSE_DIM"."COURSE_PL" = "COURSE_DIM_4_COURSE_PL"
  (i),						"COURSE_DIM"."LIST_PRICE" = "COURSE_DIM_5_LIST_PRICE"
  (i),						"COURSE_DIM"."ORACLE_ITEM_ID" = "COURSE_DIM_6_ORACLE_ITEM_ID"
  (i),						"COURSE_DIM"."ORACLE_ITEM_NUM" = "COURSE_DIM_7_ORACLE_ITEM_NUM"
  (i),						"COURSE_DIM"."CREATION_DATE" = "COURSE_DIM_8_CREATION_DATE"
  (i),						"COURSE_DIM"."LAST_UPDATE_DATE" = "COURSE_DIM_9_LAST_UPDATE_DATE"
  (i),						"COURSE_DIM"."GKDW_SOURCE" = "COURSE_DIM_14_GKDW_SOURCE"
  (i),						"COURSE_DIM"."COURSE_CODE" = "COURSE_DIM_16_COURSE_CODE"
  (i),						"COURSE_DIM"."INACTIVE_FLAG" = "COURSE_DIM_18_INACTIVE_FLAG"
  (i),						"COURSE_DIM"."COURSE_NUM" = "COURSE_DIM_19_COURSE_NUM"
  (i),						"COURSE_DIM"."LE_NUM" = "COURSE_DIM_20_LE_NUM"
  (i),						"COURSE_DIM"."FE_NUM" = "COURSE_DIM_21_FE_NUM"
  (i),						"COURSE_DIM"."CH_NUM" = "COURSE_DIM_22_CH_NUM"
  (i),						"COURSE_DIM"."MD_NUM" = "COURSE_DIM_23_MD_NUM"
  (i),						"COURSE_DIM"."PL_NUM" = "COURSE_DIM_24_PL_NUM"
  (i),						"COURSE_DIM"."ACT_NUM" = "COURSE_DIM_25_ACT_NUM"
  (i),						"COURSE_DIM"."COURSE_GROUP" = "COURSE_DIM_26_COURSE_GROUP"
  (i),						"COURSE_DIM"."VENDOR_CODE" = "COURSE_DIM_27_VENDOR_CODE"
  (i),						"COURSE_DIM"."SHORT_NAME" = "COURSE_DIM_28_SHORT_NAME"
  (i),						"COURSE_DIM"."DURATION_DAYS" = "COURSE_DIM_29_DURATION_DAYS"
  (i),						"COURSE_DIM"."COURSE_TYPE" = "COURSE_DIM_30_COURSE_TYPE"
  (i),						"COURSE_DIM"."CAPACITY" = "COURSE_DIM_31_CAPACITY"
  (i),						"COURSE_DIM"."COURSE_DESC" = "COURSE_DIM_32_COURSE_DESC"
  (i),						"COURSE_DIM"."ITBT" = "COURSE_DIM_33_ITBT"
  (i),						"COURSE_DIM"."ROOT_CODE" = "COURSE_DIM_34_ROOT_CODE"
  (i),						"COURSE_DIM"."LINE_OF_BUSINESS" = "COURSE_DIM_35_LINE_OF_BUSINESS"
  (i),						"COURSE_DIM"."MCMASTERS_ELIGIBLE" = "COURSE_D_36_MCMASTER"
  (i),						"COURSE_DIM"."MFG_COURSE_CODE" = "COURSE_DIM_37_MFG_COURSE_CODE"
  (i)
    
            WHERE
  
  						"COURSE_DIM"."COURSE_ID" = "COURSE_DIM_0_COURSE_ID"
  (i) AND						"COURSE_DIM"."COUNTRY" = "COURSE_DIM_17_COUNTRY"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "COURSE_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "COURSE_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "COURSE_DIM_srk"(rowkey_index);
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
  
          "COURSE_DIM_upd" := "COURSE_DIM_upd" + get_rowid.COUNT;
          "COURSE_DIM_si" := "COURSE_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "COURSE_DIM_si".."COURSE_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "COURSE_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "COURSE_DIM_srk"(rowkey_index);
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
            "COURSE_DIM_upd" := "COURSE_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "COURSE_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                  "COURSE_DIM"
                SET
  
  								"COURSE_DIM"."COURSE_NAME" = "COURSE_DIM_1_COURSE_NAME"
  (last_successful_index),								"COURSE_DIM"."COURSE_CH" = "COURSE_DIM_2_COURSE_CH"
  (last_successful_index),								"COURSE_DIM"."COURSE_MOD" = "COURSE_DIM_3_COURSE_MOD"
  (last_successful_index),								"COURSE_DIM"."COURSE_PL" = "COURSE_DIM_4_COURSE_PL"
  (last_successful_index),								"COURSE_DIM"."LIST_PRICE" = "COURSE_DIM_5_LIST_PRICE"
  (last_successful_index),								"COURSE_DIM"."ORACLE_ITEM_ID" = "COURSE_DIM_6_ORACLE_ITEM_ID"
  (last_successful_index),								"COURSE_DIM"."ORACLE_ITEM_NUM" = "COURSE_DIM_7_ORACLE_ITEM_NUM"
  (last_successful_index),								"COURSE_DIM"."CREATION_DATE" = "COURSE_DIM_8_CREATION_DATE"
  (last_successful_index),								"COURSE_DIM"."LAST_UPDATE_DATE" = "COURSE_DIM_9_LAST_UPDATE_DATE"
  (last_successful_index),								"COURSE_DIM"."GKDW_SOURCE" = "COURSE_DIM_14_GKDW_SOURCE"
  (last_successful_index),								"COURSE_DIM"."COURSE_CODE" = "COURSE_DIM_16_COURSE_CODE"
  (last_successful_index),								"COURSE_DIM"."INACTIVE_FLAG" = "COURSE_DIM_18_INACTIVE_FLAG"
  (last_successful_index),								"COURSE_DIM"."COURSE_NUM" = "COURSE_DIM_19_COURSE_NUM"
  (last_successful_index),								"COURSE_DIM"."LE_NUM" = "COURSE_DIM_20_LE_NUM"
  (last_successful_index),								"COURSE_DIM"."FE_NUM" = "COURSE_DIM_21_FE_NUM"
  (last_successful_index),								"COURSE_DIM"."CH_NUM" = "COURSE_DIM_22_CH_NUM"
  (last_successful_index),								"COURSE_DIM"."MD_NUM" = "COURSE_DIM_23_MD_NUM"
  (last_successful_index),								"COURSE_DIM"."PL_NUM" = "COURSE_DIM_24_PL_NUM"
  (last_successful_index),								"COURSE_DIM"."ACT_NUM" = "COURSE_DIM_25_ACT_NUM"
  (last_successful_index),								"COURSE_DIM"."COURSE_GROUP" = "COURSE_DIM_26_COURSE_GROUP"
  (last_successful_index),								"COURSE_DIM"."VENDOR_CODE" = "COURSE_DIM_27_VENDOR_CODE"
  (last_successful_index),								"COURSE_DIM"."SHORT_NAME" = "COURSE_DIM_28_SHORT_NAME"
  (last_successful_index),								"COURSE_DIM"."DURATION_DAYS" = "COURSE_DIM_29_DURATION_DAYS"
  (last_successful_index),								"COURSE_DIM"."COURSE_TYPE" = "COURSE_DIM_30_COURSE_TYPE"
  (last_successful_index),								"COURSE_DIM"."CAPACITY" = "COURSE_DIM_31_CAPACITY"
  (last_successful_index),								"COURSE_DIM"."COURSE_DESC" = "COURSE_DIM_32_COURSE_DESC"
  (last_successful_index),								"COURSE_DIM"."ITBT" = "COURSE_DIM_33_ITBT"
  (last_successful_index),								"COURSE_DIM"."ROOT_CODE" = "COURSE_DIM_34_ROOT_CODE"
  (last_successful_index),								"COURSE_DIM"."LINE_OF_BUSINESS" = "COURSE_DIM_35_LINE_OF_BUSINESS"
  (last_successful_index),								"COURSE_DIM"."MCMASTERS_ELIGIBLE" = "COURSE_D_36_MCMASTER"
  (last_successful_index),								"COURSE_DIM"."MFG_COURSE_CODE" = "COURSE_DIM_37_MFG_COURSE_CODE"
  (last_successful_index)
  
                WHERE
  
  								"COURSE_DIM"."COURSE_ID" = "COURSE_DIM_0_COURSE_ID"
  (last_successful_index) AND 								"COURSE_DIM"."COUNTRY" = "COURSE_DIM_17_COUNTRY"
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
                  error_rowkey := "COURSE_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NAME"',0,80),SUBSTRB("COURSE_DIM_1_COURSE_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CH"',0,80),SUBSTRB("COURSE_DIM_2_COURSE_CH"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_MOD"',0,80),SUBSTRB("COURSE_DIM_3_COURSE_MOD"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_PL"',0,80),SUBSTRB("COURSE_DIM_4_COURSE_PL"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LIST_PRICE"',0,80),SUBSTRB("COURSE_DIM_5_LIST_PRICE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_ID"',0,80),SUBSTRB("COURSE_DIM_6_ORACLE_ITEM_ID"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("COURSE_DIM_7_ORACLE_ITEM_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CREATION_DATE"',0,80),SUBSTRB("COURSE_DIM_8_CREATION_DATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("COURSE_DIM_9_LAST_UPDATE_DATE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("COURSE_DIM_14_GKDW_SOURCE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_16_COURSE_CODE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."INACTIVE_FLAG"',0,80),SUBSTRB("COURSE_DIM_18_INACTIVE_FLAG"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NUM"',0,80),SUBSTRB("COURSE_DIM_19_COURSE_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LE_NUM"',0,80),SUBSTRB("COURSE_DIM_20_LE_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."FE_NUM"',0,80),SUBSTRB("COURSE_DIM_21_FE_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CH_NUM"',0,80),SUBSTRB("COURSE_DIM_22_CH_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MD_NUM"',0,80),SUBSTRB("COURSE_DIM_23_MD_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."PL_NUM"',0,80),SUBSTRB("COURSE_DIM_24_PL_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ACT_NUM"',0,80),SUBSTRB("COURSE_DIM_25_ACT_NUM"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_GROUP"',0,80),SUBSTRB("COURSE_DIM_26_COURSE_GROUP"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."VENDOR_CODE"',0,80),SUBSTRB("COURSE_DIM_27_VENDOR_CODE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."SHORT_NAME"',0,80),SUBSTRB("COURSE_DIM_28_SHORT_NAME"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."DURATION_DAYS"',0,80),SUBSTRB("COURSE_DIM_29_DURATION_DAYS"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_TYPE"',0,80),SUBSTRB("COURSE_DIM_30_COURSE_TYPE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CAPACITY"',0,80),SUBSTRB("COURSE_DIM_31_CAPACITY"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_DESC"',0,80),SUBSTRB("COURSE_DIM_32_COURSE_DESC"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ITBT"',0,80),SUBSTRB("COURSE_DIM_33_ITBT"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ROOT_CODE"',0,80),SUBSTRB("COURSE_DIM_34_ROOT_CODE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LINE_OF_BUSINESS"',0,80),SUBSTRB("COURSE_DIM_35_LINE_OF_BUSINESS"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MCMASTERS_ELIGIBLE"',0,80),SUBSTRB("COURSE_D_36_MCMASTER"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MFG_COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_37_MFG_COURSE_CODE"(last_successful_index),0,2000));
                  
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
                "COURSE_DIM_err" := "COURSE_DIM_err" + 1;
                
                IF get_errors + "COURSE_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "COURSE_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "COURSE_DIM_si" >= "COURSE_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "COURSE_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"COURSE_DIM_0_COURSE_ID"(insert_bulk_index) := "COURSE_DIM_0_COURSE_ID"(update_bulk(j));
  		"COURSE_DIM_1_COURSE_NAME"(insert_bulk_index) := "COURSE_DIM_1_COURSE_NAME"(update_bulk(j));
  		"COURSE_DIM_2_COURSE_CH"(insert_bulk_index) := "COURSE_DIM_2_COURSE_CH"(update_bulk(j));
  		"COURSE_DIM_3_COURSE_MOD"(insert_bulk_index) := "COURSE_DIM_3_COURSE_MOD"(update_bulk(j));
  		"COURSE_DIM_4_COURSE_PL"(insert_bulk_index) := "COURSE_DIM_4_COURSE_PL"(update_bulk(j));
  		"COURSE_DIM_5_LIST_PRICE"(insert_bulk_index) := "COURSE_DIM_5_LIST_PRICE"(update_bulk(j));
  		"COURSE_DIM_6_ORACLE_ITEM_ID"(insert_bulk_index) := "COURSE_DIM_6_ORACLE_ITEM_ID"(update_bulk(j));
  		"COURSE_DIM_7_ORACLE_ITEM_NUM"(insert_bulk_index) := "COURSE_DIM_7_ORACLE_ITEM_NUM"(update_bulk(j));
  		"COURSE_DIM_8_CREATION_DATE"(insert_bulk_index) := "COURSE_DIM_8_CREATION_DATE"(update_bulk(j));
  		"COURSE_DIM_9_LAST_UPDATE_DATE"(insert_bulk_index) := "COURSE_DIM_9_LAST_UPDATE_DATE"(update_bulk(j));
  		"COURSE_DIM_14_GKDW_SOURCE"(insert_bulk_index) := "COURSE_DIM_14_GKDW_SOURCE"(update_bulk(j));
  		"COURSE_DIM_16_COURSE_CODE"(insert_bulk_index) := "COURSE_DIM_16_COURSE_CODE"(update_bulk(j));
  		"COURSE_DIM_17_COUNTRY"(insert_bulk_index) := "COURSE_DIM_17_COUNTRY"(update_bulk(j));
  		"COURSE_DIM_18_INACTIVE_FLAG"(insert_bulk_index) := "COURSE_DIM_18_INACTIVE_FLAG"(update_bulk(j));
  		"COURSE_DIM_19_COURSE_NUM"(insert_bulk_index) := "COURSE_DIM_19_COURSE_NUM"(update_bulk(j));
  		"COURSE_DIM_20_LE_NUM"(insert_bulk_index) := "COURSE_DIM_20_LE_NUM"(update_bulk(j));
  		"COURSE_DIM_21_FE_NUM"(insert_bulk_index) := "COURSE_DIM_21_FE_NUM"(update_bulk(j));
  		"COURSE_DIM_22_CH_NUM"(insert_bulk_index) := "COURSE_DIM_22_CH_NUM"(update_bulk(j));
  		"COURSE_DIM_23_MD_NUM"(insert_bulk_index) := "COURSE_DIM_23_MD_NUM"(update_bulk(j));
  		"COURSE_DIM_24_PL_NUM"(insert_bulk_index) := "COURSE_DIM_24_PL_NUM"(update_bulk(j));
  		"COURSE_DIM_25_ACT_NUM"(insert_bulk_index) := "COURSE_DIM_25_ACT_NUM"(update_bulk(j));
  		"COURSE_DIM_26_COURSE_GROUP"(insert_bulk_index) := "COURSE_DIM_26_COURSE_GROUP"(update_bulk(j));
  		"COURSE_DIM_27_VENDOR_CODE"(insert_bulk_index) := "COURSE_DIM_27_VENDOR_CODE"(update_bulk(j));
  		"COURSE_DIM_28_SHORT_NAME"(insert_bulk_index) := "COURSE_DIM_28_SHORT_NAME"(update_bulk(j));
  		"COURSE_DIM_29_DURATION_DAYS"(insert_bulk_index) := "COURSE_DIM_29_DURATION_DAYS"(update_bulk(j));
  		"COURSE_DIM_30_COURSE_TYPE"(insert_bulk_index) := "COURSE_DIM_30_COURSE_TYPE"(update_bulk(j));
  		"COURSE_DIM_31_CAPACITY"(insert_bulk_index) := "COURSE_DIM_31_CAPACITY"(update_bulk(j));
  		"COURSE_DIM_32_COURSE_DESC"(insert_bulk_index) := "COURSE_DIM_32_COURSE_DESC"(update_bulk(j));
  		"COURSE_DIM_33_ITBT"(insert_bulk_index) := "COURSE_DIM_33_ITBT"(update_bulk(j));
  		"COURSE_DIM_34_ROOT_CODE"(insert_bulk_index) := "COURSE_DIM_34_ROOT_CODE"(update_bulk(j));
  		"COURSE_DIM_35_LINE_OF_BUSINESS"(insert_bulk_index) := "COURSE_DIM_35_LINE_OF_BUSINESS"(update_bulk(j));
  		"COURSE_D_36_MCMASTER"(insert_bulk_index) := "COURSE_D_36_MCMASTER"(update_bulk(j));
  		"COURSE_DIM_37_MFG_COURSE_CODE"(insert_bulk_index) := "COURSE_DIM_37_MFG_COURSE_CODE"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "COURSE_DIM_srk"(insert_bulk_index) := "COURSE_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "COURSE_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "COURSE_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "COURSE_DIM_si"..insert_bulk_index
          INSERT INTO
            "COURSE_DIM"
            ("COURSE_DIM"."COURSE_ID",
            "COURSE_DIM"."COURSE_NAME",
            "COURSE_DIM"."COURSE_CH",
            "COURSE_DIM"."COURSE_MOD",
            "COURSE_DIM"."COURSE_PL",
            "COURSE_DIM"."LIST_PRICE",
            "COURSE_DIM"."ORACLE_ITEM_ID",
            "COURSE_DIM"."ORACLE_ITEM_NUM",
            "COURSE_DIM"."CREATION_DATE",
            "COURSE_DIM"."LAST_UPDATE_DATE",
            "COURSE_DIM"."GKDW_SOURCE",
            "COURSE_DIM"."COURSE_CODE",
            "COURSE_DIM"."COUNTRY",
            "COURSE_DIM"."INACTIVE_FLAG",
            "COURSE_DIM"."COURSE_NUM",
            "COURSE_DIM"."LE_NUM",
            "COURSE_DIM"."FE_NUM",
            "COURSE_DIM"."CH_NUM",
            "COURSE_DIM"."MD_NUM",
            "COURSE_DIM"."PL_NUM",
            "COURSE_DIM"."ACT_NUM",
            "COURSE_DIM"."COURSE_GROUP",
            "COURSE_DIM"."VENDOR_CODE",
            "COURSE_DIM"."SHORT_NAME",
            "COURSE_DIM"."DURATION_DAYS",
            "COURSE_DIM"."COURSE_TYPE",
            "COURSE_DIM"."CAPACITY",
            "COURSE_DIM"."COURSE_DESC",
            "COURSE_DIM"."ITBT",
            "COURSE_DIM"."ROOT_CODE",
            "COURSE_DIM"."LINE_OF_BUSINESS",
            "COURSE_DIM"."MCMASTERS_ELIGIBLE",
            "COURSE_DIM"."MFG_COURSE_CODE")
          VALUES
            ("COURSE_DIM_0_COURSE_ID"(i),
            "COURSE_DIM_1_COURSE_NAME"(i),
            "COURSE_DIM_2_COURSE_CH"(i),
            "COURSE_DIM_3_COURSE_MOD"(i),
            "COURSE_DIM_4_COURSE_PL"(i),
            "COURSE_DIM_5_LIST_PRICE"(i),
            "COURSE_DIM_6_ORACLE_ITEM_ID"(i),
            "COURSE_DIM_7_ORACLE_ITEM_NUM"(i),
            "COURSE_DIM_8_CREATION_DATE"(i),
            "COURSE_DIM_9_LAST_UPDATE_DATE"(i),
            "COURSE_DIM_14_GKDW_SOURCE"(i),
            "COURSE_DIM_16_COURSE_CODE"(i),
            "COURSE_DIM_17_COUNTRY"(i),
            "COURSE_DIM_18_INACTIVE_FLAG"(i),
            "COURSE_DIM_19_COURSE_NUM"(i),
            "COURSE_DIM_20_LE_NUM"(i),
            "COURSE_DIM_21_FE_NUM"(i),
            "COURSE_DIM_22_CH_NUM"(i),
            "COURSE_DIM_23_MD_NUM"(i),
            "COURSE_DIM_24_PL_NUM"(i),
            "COURSE_DIM_25_ACT_NUM"(i),
            "COURSE_DIM_26_COURSE_GROUP"(i),
            "COURSE_DIM_27_VENDOR_CODE"(i),
            "COURSE_DIM_28_SHORT_NAME"(i),
            "COURSE_DIM_29_DURATION_DAYS"(i),
            "COURSE_DIM_30_COURSE_TYPE"(i),
            "COURSE_DIM_31_CAPACITY"(i),
            "COURSE_DIM_32_COURSE_DESC"(i),
            "COURSE_DIM_33_ITBT"(i),
            "COURSE_DIM_34_ROOT_CODE"(i),
            "COURSE_DIM_35_LINE_OF_BUSINESS"(i),
            "COURSE_D_36_MCMASTER"(i),
            "COURSE_DIM_37_MFG_COURSE_CODE"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "COURSE_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "COURSE_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "COURSE_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 90: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_ID"',0,80),SUBSTRB("COURSE_DIM_0_COURSE_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NAME"',0,80),SUBSTRB("COURSE_DIM_1_COURSE_NAME"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CH"',0,80),SUBSTRB("COURSE_DIM_2_COURSE_CH"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_MOD"',0,80),SUBSTRB("COURSE_DIM_3_COURSE_MOD"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_PL"',0,80),SUBSTRB("COURSE_DIM_4_COURSE_PL"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LIST_PRICE"',0,80),SUBSTRB("COURSE_DIM_5_LIST_PRICE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_ID"',0,80),SUBSTRB("COURSE_DIM_6_ORACLE_ITEM_ID"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("COURSE_DIM_7_ORACLE_ITEM_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CREATION_DATE"',0,80),SUBSTRB("COURSE_DIM_8_CREATION_DATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("COURSE_DIM_9_LAST_UPDATE_DATE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("COURSE_DIM_14_GKDW_SOURCE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_16_COURSE_CODE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COUNTRY"',0,80),SUBSTRB("COURSE_DIM_17_COUNTRY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."INACTIVE_FLAG"',0,80),SUBSTRB("COURSE_DIM_18_INACTIVE_FLAG"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NUM"',0,80),SUBSTRB("COURSE_DIM_19_COURSE_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LE_NUM"',0,80),SUBSTRB("COURSE_DIM_20_LE_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."FE_NUM"',0,80),SUBSTRB("COURSE_DIM_21_FE_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CH_NUM"',0,80),SUBSTRB("COURSE_DIM_22_CH_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MD_NUM"',0,80),SUBSTRB("COURSE_DIM_23_MD_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."PL_NUM"',0,80),SUBSTRB("COURSE_DIM_24_PL_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ACT_NUM"',0,80),SUBSTRB("COURSE_DIM_25_ACT_NUM"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_GROUP"',0,80),SUBSTRB("COURSE_DIM_26_COURSE_GROUP"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."VENDOR_CODE"',0,80),SUBSTRB("COURSE_DIM_27_VENDOR_CODE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."SHORT_NAME"',0,80),SUBSTRB("COURSE_DIM_28_SHORT_NAME"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."DURATION_DAYS"',0,80),SUBSTRB("COURSE_DIM_29_DURATION_DAYS"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_TYPE"',0,80),SUBSTRB("COURSE_DIM_30_COURSE_TYPE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CAPACITY"',0,80),SUBSTRB("COURSE_DIM_31_CAPACITY"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_DESC"',0,80),SUBSTRB("COURSE_DIM_32_COURSE_DESC"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ITBT"',0,80),SUBSTRB("COURSE_DIM_33_ITBT"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ROOT_CODE"',0,80),SUBSTRB("COURSE_DIM_34_ROOT_CODE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LINE_OF_BUSINESS"',0,80),SUBSTRB("COURSE_DIM_35_LINE_OF_BUSINESS"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MCMASTERS_ELIGIBLE"',0,80),SUBSTRB("COURSE_D_36_MCMASTER"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MFG_COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_37_MFG_COURSE_CODE"(error_index),0,2000));
            
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
          "COURSE_DIM_err" := "COURSE_DIM_err" + 1;
          
          IF get_errors + "COURSE_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "COURSE_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "COURSE_DIM_srk"(rowkey_index);
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
  
      "COURSE_DIM_ins" := "COURSE_DIM_ins" + get_rowid.COUNT;
      "COURSE_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "COURSE_DIM_ins" := "COURSE_DIM_ins0"; 
    "COURSE_DIM_upd" := "COURSE_DIM_upd0";
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

  IF NOT "COURSE_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "COURSE_DIM_St" THEN
          "COURSE_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"COURSE_DIM"',
              p_target_uoid=>'A41FFB199F6F5678E040007F01006C7D',
              p_stm=>'TRACE 92',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "COURSE_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F4A5678E040007F01006C7D', -- Operator RMS_COURSE
              p_parent_object_name=>'RMS_COURSE',
              p_parent_object_uoid=>'A41FFB18FC635678E040007F01006C7D', -- Table RMS_COURSE
              p_parent_object_type=>'Table',
              p_object_name=>'RMS_COURSE',
              p_object_uoid=>'A41FFB18FC635678E040007F01006C7D', -- Table RMS_COURSE
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FC3D5678E040007F01006C7D' -- Location RMSDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F6A5678E040007F01006C7D', -- Operator EVXCOURSEFEE
              p_parent_object_name=>'EVXCOURSEFEE',
              p_parent_object_uoid=>'A41FFB1909875678E040007F01006C7D', -- Table EVXCOURSEFEE
              p_parent_object_type=>'Table',
              p_object_name=>'EVXCOURSEFEE',
              p_object_uoid=>'A41FFB1909875678E040007F01006C7D', -- Table EVXCOURSEFEE
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F6F5678E040007F01006C7D', -- Operator COURSE_DIM
              p_parent_object_name=>'COURSE_DIM',
              p_parent_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'COURSE_DIM',
              p_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F4B5678E040007F01006C7D', -- Operator QG_COURSE
              p_parent_object_name=>'QG_COURSE',
              p_parent_object_uoid=>'A41FFB190D2A5678E040007F01006C7D', -- Table QG_COURSE
              p_parent_object_type=>'Table',
              p_object_name=>'QG_COURSE',
              p_object_uoid=>'A41FFB190D2A5678E040007F01006C7D', -- Table QG_COURSE
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A0A75678E040007F01006C7D', -- Operator COURSE_DIM
              p_parent_object_name=>'COURSE_DIM',
              p_parent_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'COURSE_DIM',
              p_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F715678E040007F01006C7D', -- Operator EVXCOURSE
              p_parent_object_name=>'EVXCOURSE',
              p_parent_object_uoid=>'A41FFB1907FF5678E040007F01006C7D', -- Table EVXCOURSE
              p_parent_object_type=>'Table',
              p_object_name=>'EVXCOURSE',
              p_object_uoid=>'A41FFB1907FF5678E040007F01006C7D', -- Table EVXCOURSE
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
    "COURSE_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU";

      LOOP
        IF "FLTR_si" = 0 THEN
          "FLTR_RD";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_2_EVXCOURSEID".COUNT - 1;
          ELSE
            bulk_count := "FLTR_2_EVXCOURSEID".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "COURSE_DIM_ir".DELETE;
"COURSE_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i" := "FLTR_si";
        BEGIN
          
          LOOP
            EXIT WHEN "COURSE_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i" := "FLTR_i" + 1;
            "FLTR_si" := "FLTR_i";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "COURSE_DIM_new" := FALSE;
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
            
            
            "EXPR_2_COURSE_NAME"
            ("FLTR_i") := 
            UPPER(TRIM( "FLTR_3_COURSENAME"
            ("FLTR_i") ))/* EXPR.OUTGRP1.COURSE_NAME */;
            
            ',0,2000);
            
            
            "EXPR_2_COURSE_NAME"
            ("FLTR_i") := 
            UPPER(TRIM( "FLTR_3_COURSENAME"
            ("FLTR_i") ))/* EXPR.OUTGRP1.COURSE_NAME */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_3_COUNTRY"
            ("FLTR_i") := 
            case  "FLTR_24_CURRENCY"
            ("FLTR_i") 
when ''USD''
then ''USA''
when ''CAD''
then ''CANADA''
else ''USA''
end/* EXPR.OUTGRP1.COUNTRY */;
            
            ',0,2000);
            
            
            "EXPR_3_COUNTRY"
            ("FLTR_i") := 
            case  "FLTR_24_CURRENCY"
            ("FLTR_i") 
when 'USD'
then 'USA'
when 'CAD'
then 'CANADA'
else 'USA'
end/* EXPR.OUTGRP1.COUNTRY */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
            
            "EXPR_1_2_DURATION_IN_DAYS"
            ("FLTR_i") := 
            case
  when upper(trim( "QG_COURSE_8_UOM"
            ("FLTR_i") )) like ''DAY%''
      then  "QG_COURSE_7_DURATION"
            ("FLTR_i") 
  when upper(trim( "QG_COURSE_8_UOM"
            ("FLTR_i") )) like ''HOUR%''
      then  ("QG_COURSE_7_DURATION"
            ("FLTR_i")/8)
  when upper(trim( "QG_COURSE_8_UOM"
            ("FLTR_i") )) like ''WEEK%''
      then  ("QG_COURSE_7_DURATION"
            ("FLTR_i")  * 5)
  else nvl("QG_COURSE_7_DURATION"
            ("FLTR_i") , 0)
  end/* EXPR_1.OUTGRP1.DURATION_IN_DAYS */;
            
            ',0,2000);
            
            
            "EXPR_1_2_DURATION_IN_DAYS"
            ("FLTR_i") := 
            case
  when upper(trim( "QG_COURSE_8_UOM"
            ("FLTR_i") )) like 'DAY%'
      then  "QG_COURSE_7_DURATION"
            ("FLTR_i") 
  when upper(trim( "QG_COURSE_8_UOM"
            ("FLTR_i") )) like 'HOUR%'
      then  ("QG_COURSE_7_DURATION"
            ("FLTR_i")/8)
  when upper(trim( "QG_COURSE_8_UOM"
            ("FLTR_i") )) like 'WEEK%'
      then  ("QG_COURSE_7_DURATION"
            ("FLTR_i")  * 5)
  else nvl("QG_COURSE_7_DURATION"
            ("FLTR_i") , 0)
  end/* EXPR_1.OUTGRP1.DURATION_IN_DAYS */;
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_ORACLE_ITEM_ID"("FLTR_13_COURSECODE"
            ("FLTR_i"),"EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_ORAC_2_INVENTOR"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_ORACLE_ITEM_ID"("FLTR_13_COURSECODE"
            ("FLTR_i"),"EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_ORAC_2_INVENTOR"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_COURSE_DIM"."GET_CONST_5_MD_FLEX_VALUE_SET_","EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_FLEX_3_MD_FLEX_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_COURSE_DIM"."GET_CONST_5_MD_FLEX_VALUE_SET_","EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_FLEX_3_MD_FLEX_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_COURSE_DIM"."GET_CONST_6_PL_FLEX_VALUE_SET_","EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_FLEX_3_PL_FLEX_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_COURSE_DIM"."GET_CONST_6_PL_FLEX_VALUE_SET_","EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_FLEX_3_PL_FLEX_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_ITEM_2_ITEM_NUM"
            ("FLTR_i"),"GET_ITEM_3_LE_NUM_O"
            ("FLTR_i"),"GET_ITEM_4_FE_NUM_O"
            ("FLTR_i"),"GET_ITEM_5_CH_NUM_O"
            ("FLTR_i"),"GET_ITEM_6_MD_NUM_O"
            ("FLTR_i"),"GET_ITEM_7_PL_NUM_O"
            ("FLTR_i"),"GET_ITEM_8_ACT_NUM_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_ITEM_2_ITEM_NUM"
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
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_COURSE_DIM"."GET_CONST_4_CH_FLEX_VALUE_SET_","EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_FLEX_3_CH_FLEX_"
            ("FLTR_i"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i"),"OWB_COURSE_DIM"."GET_CONST_4_CH_FLEX_VALUE_SET_","EXPR_3_COUNTRY"
            ("FLTR_i"),"GET_FLEX_3_CH_FLEX_"
            ("FLTR_i"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            
get_target_name := '"COURSE_DIM"';
            get_audit_detail_id := "COURSE_DIM_id";
            IF NOT "COURSE_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"COURSE_DIM_0_COURSE_ID"("COURSE_DIM_i") := 
            
            RTRIM("FLTR_2_EVXCOURSEID"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_0_COURSE_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_2_EVXCOURSEID"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_0_COURSE_ID"("COURSE_DIM_i") :=
            
            RTRIM("FLTR_2_EVXCOURSEID"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_0_COURSE_ID" :=
            
            RTRIM("FLTR_2_EVXCOURSEID"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_1_COURSE_NAME"("COURSE_DIM_i") := 
            
            "EXPR_2_COURSE_NAME"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_1_COURSE_NAME"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_2_COURSE_NAME"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_1_COURSE_NAME"("COURSE_DIM_i") :=
            
            "EXPR_2_COURSE_NAME"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_1_COURSE_NAME" :=
            
            "EXPR_2_COURSE_NAME"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_2_COURSE_CH"("COURSE_DIM_i") := 
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_2_COURSE_CH"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_CH_FLEX_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_2_COURSE_CH"("COURSE_DIM_i") :=
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_2_COURSE_CH" :=
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_3_COURSE_MOD"("COURSE_DIM_i") := 
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_3_COURSE_MOD"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_MD_FLEX_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_3_COURSE_MOD"("COURSE_DIM_i") :=
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_3_COURSE_MOD" :=
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_4_COURSE_PL"("COURSE_DIM_i") := 
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_4_COURSE_PL"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_PL_FLEX_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_4_COURSE_PL"("COURSE_DIM_i") :=
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_4_COURSE_PL" :=
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_5_LIST_PRICE"("COURSE_DIM_i") := 
            
            "FLTR_23_AMOUNT"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_5_LIST_PRICE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_23_AMOUNT"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_5_LIST_PRICE"("COURSE_DIM_i") :=
            
            "FLTR_23_AMOUNT"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_5_LIST_PRICE" :=
            
            "FLTR_23_AMOUNT"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_6_ORACLE_ITEM_ID"("COURSE_DIM_i") := 
            
            "GET_ORAC_2_INVENTOR"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_6_ORACLE_ITEM_ID"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ORAC_2_INVENTOR"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_6_ORACLE_ITEM_ID"("COURSE_DIM_i") :=
            
            "GET_ORAC_2_INVENTOR"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_6_ORACLE_ITEM_ID" :=
            
            "GET_ORAC_2_INVENTOR"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_7_ORACLE_ITEM_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_7_ORACLE_ITEM_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_2_ITEM_NUM"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_7_ORACLE_ITEM_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_7_ORACLE_ITEM_N" :=
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_8_CREATION_DATE"("COURSE_DIM_i") := 
            
            "FLTR_16_CREATEDATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_8_CREATION_DATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_16_CREATEDATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_8_CREATION_DATE"("COURSE_DIM_i") :=
            
            "FLTR_16_CREATEDATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_8_CREATION_DATE" :=
            
            "FLTR_16_CREATEDATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_9_LAST_UPDATE_DATE"("COURSE_DIM_i") := 
            
            "FLTR_18_MODIFYDATE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_9_LAST_UPDATE_DATE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_18_MODIFYDATE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_9_LAST_UPDATE_DATE"("COURSE_DIM_i") :=
            
            "FLTR_18_MODIFYDATE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_9_LAST_UPDATE_DA" :=
            
            "FLTR_18_MODIFYDATE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_14_GKDW_SOURCE"("COURSE_DIM_i") := 
            
            "OWB_COURSE_DIM"."GET_CONST_1_SOURCE";',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_14_GKDW_SOURCE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_COURSE_DIM"."GET_CONST_1_SOURCE",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_14_GKDW_SOURCE"("COURSE_DIM_i") :=
            
            "OWB_COURSE_DIM"."GET_CONST_1_SOURCE";
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_14_GKDW_SOURCE" :=
            
            "OWB_COURSE_DIM"."GET_CONST_1_SOURCE";
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_16_COURSE_CODE"("COURSE_DIM_i") := 
            
            "FLTR_13_COURSECODE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_16_COURSE_CODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_13_COURSECODE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_16_COURSE_CODE"("COURSE_DIM_i") :=
            
            "FLTR_13_COURSECODE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_16_COURSE_CODE" :=
            
            "FLTR_13_COURSECODE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_17_COUNTRY"("COURSE_DIM_i") := 
            
            "EXPR_3_COUNTRY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_17_COUNTRY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_3_COUNTRY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_17_COUNTRY"("COURSE_DIM_i") :=
            
            "EXPR_3_COUNTRY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_17_COUNTRY" :=
            
            "EXPR_3_COUNTRY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_18_INACTIVE_FLAG"("COURSE_DIM_i") := 
            
            RTRIM("FLTR_7_ISINACTIVE"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_18_INACTIVE_FLAG"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_7_ISINACTIVE"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_18_INACTIVE_FLAG"("COURSE_DIM_i") :=
            
            RTRIM("FLTR_7_ISINACTIVE"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_18_INACTIVE_FLAG" :=
            
            RTRIM("FLTR_7_ISINACTIVE"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_19_COURSE_NUM"("COURSE_DIM_i") := 
            
            "FLTR_8_COURSENUMBER"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_19_COURSE_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_8_COURSENUMBER"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_19_COURSE_NUM"("COURSE_DIM_i") :=
            
            "FLTR_8_COURSENUMBER"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_19_COURSE_NUM" :=
            
            "FLTR_8_COURSENUMBER"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_20_LE_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_20_LE_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_3_LE_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_20_LE_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_20_LE_NUM" :=
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_21_FE_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_21_FE_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_4_FE_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_21_FE_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_21_FE_NUM" :=
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_22_CH_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_22_CH_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_5_CH_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_22_CH_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_22_CH_NUM" :=
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_23_MD_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_23_MD_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_6_MD_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_23_MD_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_23_MD_NUM" :=
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_24_PL_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_24_PL_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_7_PL_NUM_O"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_24_PL_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_24_PL_NUM" :=
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_25_ACT_NUM"("COURSE_DIM_i") := 
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_25_ACT_NUM"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_8_ACT_NUM_"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_25_ACT_NUM"("COURSE_DIM_i") :=
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_25_ACT_NUM" :=
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_26_COURSE_GROUP"("COURSE_DIM_i") := 
            
            "FLTR_11_COURSEGROUP"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_26_COURSE_GROUP"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_11_COURSEGROUP"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_26_COURSE_GROUP"("COURSE_DIM_i") :=
            
            "FLTR_11_COURSEGROUP"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_26_COURSE_GROUP" :=
            
            "FLTR_11_COURSEGROUP"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_27_VENDOR_CODE"("COURSE_DIM_i") := 
            
            "QG_COURSE_12_VENDORCODE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_27_VENDOR_CODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("QG_COURSE_12_VENDORCODE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_27_VENDOR_CODE"("COURSE_DIM_i") :=
            
            "QG_COURSE_12_VENDORCODE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_27_VENDOR_CODE" :=
            
            "QG_COURSE_12_VENDORCODE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_28_SHORT_NAME"("COURSE_DIM_i") := 
            
            "FLTR_4_SHORTNAME"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_28_SHORT_NAME"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_4_SHORTNAME"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_28_SHORT_NAME"("COURSE_DIM_i") :=
            
            "FLTR_4_SHORTNAME"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_28_SHORT_NAME" :=
            
            "FLTR_4_SHORTNAME"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_29_DURATION_DAYS"("COURSE_DIM_i") := 
            
            "EXPR_1_2_DURATION_IN_DAYS"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_29_DURATION_DAYS"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_2_DURATION_IN_DAYS"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_29_DURATION_DAYS"("COURSE_DIM_i") :=
            
            "EXPR_1_2_DURATION_IN_DAYS"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_29_DURATION_DAYS" :=
            
            "EXPR_1_2_DURATION_IN_DAYS"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_30_COURSE_TYPE"("COURSE_DIM_i") := 
            
            "FLTR_10_COURSETYPE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_30_COURSE_TYPE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_10_COURSETYPE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_30_COURSE_TYPE"("COURSE_DIM_i") :=
            
            "FLTR_10_COURSETYPE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_30_COURSE_TYPE" :=
            
            "FLTR_10_COURSETYPE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_31_CAPACITY"("COURSE_DIM_i") := 
            
            "QG_COURSE_11_CAPACITY"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_31_CAPACITY"',0,80);
            
            BEGIN
              error_value := SUBSTRB("QG_COURSE_11_CAPACITY"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_31_CAPACITY"("COURSE_DIM_i") :=
            
            "QG_COURSE_11_CAPACITY"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_31_CAPACITY" :=
            
            "QG_COURSE_11_CAPACITY"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_32_COURSE_DESC"("COURSE_DIM_i") := 
            
            "RMS_COURSE_35_COURSE_DESC"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_32_COURSE_DESC"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_35_COURSE_DESC"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_32_COURSE_DESC"("COURSE_DIM_i") :=
            
            "RMS_COURSE_35_COURSE_DESC"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_32_COURSE_DESC" :=
            
            "RMS_COURSE_35_COURSE_DESC"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_33_ITBT"("COURSE_DIM_i") := 
            
            RTRIM("RMS_COURSE_36_ITBT"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_33_ITBT"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("RMS_COURSE_36_ITBT"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_33_ITBT"("COURSE_DIM_i") :=
            
            RTRIM("RMS_COURSE_36_ITBT"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_33_ITBT" :=
            
            RTRIM("RMS_COURSE_36_ITBT"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_34_ROOT_CODE"("COURSE_DIM_i") := 
            
            "RMS_COURSE_37_ROOT_CODE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_34_ROOT_CODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_37_ROOT_CODE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_34_ROOT_CODE"("COURSE_DIM_i") :=
            
            "RMS_COURSE_37_ROOT_CODE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_34_ROOT_CODE" :=
            
            "RMS_COURSE_37_ROOT_CODE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_35_LINE_OF_BUSINESS"("COURSE_DIM_i") := 
            
            "RMS_COURSE_38_LINE_OF_BUSINESS"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_35_LINE_OF_BUSINESS"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_38_LINE_OF_BUSINESS"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_35_LINE_OF_BUSINESS"("COURSE_DIM_i") :=
            
            "RMS_COURSE_38_LINE_OF_BUSINESS"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_35_LINE_OF_BUSI" :=
            
            "RMS_COURSE_38_LINE_OF_BUSINESS"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_D_36_MCMASTER"("COURSE_DIM_i") := 
            
            RTRIM("RMS_COUR_46_MCMASTER"("FLTR_i"));',0,2000);
            error_column := SUBSTRB('"COURSE_D_36_MCMASTER"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("RMS_COUR_46_MCMASTER"("FLTR_i")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_D_36_MCMASTER"("COURSE_DIM_i") :=
            
            RTRIM("RMS_COUR_46_MCMASTER"("FLTR_i"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_D_36_MCMASTER" :=
            
            RTRIM("RMS_COUR_46_MCMASTER"("FLTR_i"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_37_MFG_COURSE_CODE"("COURSE_DIM_i") := 
            
            "RMS_COURSE_47_MFG_COURSE_CODE"("FLTR_i");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_37_MFG_COURSE_CODE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_47_MFG_COURSE_CODE"("FLTR_i"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_37_MFG_COURSE_CODE"("COURSE_DIM_i") :=
            
            "RMS_COURSE_47_MFG_COURSE_CODE"("FLTR_i");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_37_MFG_COURSE_CO" :=
            
            "RMS_COURSE_47_MFG_COURSE_CODE"("FLTR_i");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "COURSE_DIM_srk"("COURSE_DIM_i") := get_rowkey + "FLTR_i" - 1;
                  ELSIF get_row_status THEN
                    "SV_COURSE_DIM_srk" := get_rowkey + "FLTR_i" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "COURSE_DIM_new" := TRUE;
                ELSE
                  "COURSE_DIM_i" := "COURSE_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER"('TRACE 93: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i");
                  
                  "COURSE_DIM_err" := "COURSE_DIM_err" + 1;
                  
                  IF get_errors + "COURSE_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("COURSE_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "COURSE_DIM_new" 
            AND (NOT "COURSE_DIM_nul") THEN
              "COURSE_DIM_ir"(dml_bsize) := "COURSE_DIM_i";
            	"COURSE_DIM_0_COURSE_ID"("COURSE_DIM_i") := "SV_COURSE_DIM_0_COURSE_ID";
            	"COURSE_DIM_1_COURSE_NAME"("COURSE_DIM_i") := "SV_COURSE_DIM_1_COURSE_NAME";
            	"COURSE_DIM_2_COURSE_CH"("COURSE_DIM_i") := "SV_COURSE_DIM_2_COURSE_CH";
            	"COURSE_DIM_3_COURSE_MOD"("COURSE_DIM_i") := "SV_COURSE_DIM_3_COURSE_MOD";
            	"COURSE_DIM_4_COURSE_PL"("COURSE_DIM_i") := "SV_COURSE_DIM_4_COURSE_PL";
            	"COURSE_DIM_5_LIST_PRICE"("COURSE_DIM_i") := "SV_COURSE_DIM_5_LIST_PRICE";
            	"COURSE_DIM_6_ORACLE_ITEM_ID"("COURSE_DIM_i") := "SV_COURSE_DIM_6_ORACLE_ITEM_ID";
            	"COURSE_DIM_7_ORACLE_ITEM_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_7_ORACLE_ITEM_N";
            	"COURSE_DIM_8_CREATION_DATE"("COURSE_DIM_i") := "SV_COURSE_DIM_8_CREATION_DATE";
            	"COURSE_DIM_9_LAST_UPDATE_DATE"("COURSE_DIM_i") := "SV_COURSE_DIM_9_LAST_UPDATE_DA";
            	"COURSE_DIM_14_GKDW_SOURCE"("COURSE_DIM_i") := "SV_COURSE_DIM_14_GKDW_SOURCE";
            	"COURSE_DIM_16_COURSE_CODE"("COURSE_DIM_i") := "SV_COURSE_DIM_16_COURSE_CODE";
            	"COURSE_DIM_17_COUNTRY"("COURSE_DIM_i") := "SV_COURSE_DIM_17_COUNTRY";
            	"COURSE_DIM_18_INACTIVE_FLAG"("COURSE_DIM_i") := "SV_COURSE_DIM_18_INACTIVE_FLAG";
            	"COURSE_DIM_19_COURSE_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_19_COURSE_NUM";
            	"COURSE_DIM_20_LE_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_20_LE_NUM";
            	"COURSE_DIM_21_FE_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_21_FE_NUM";
            	"COURSE_DIM_22_CH_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_22_CH_NUM";
            	"COURSE_DIM_23_MD_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_23_MD_NUM";
            	"COURSE_DIM_24_PL_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_24_PL_NUM";
            	"COURSE_DIM_25_ACT_NUM"("COURSE_DIM_i") := "SV_COURSE_DIM_25_ACT_NUM";
            	"COURSE_DIM_26_COURSE_GROUP"("COURSE_DIM_i") := "SV_COURSE_DIM_26_COURSE_GROUP";
            	"COURSE_DIM_27_VENDOR_CODE"("COURSE_DIM_i") := "SV_COURSE_DIM_27_VENDOR_CODE";
            	"COURSE_DIM_28_SHORT_NAME"("COURSE_DIM_i") := "SV_COURSE_DIM_28_SHORT_NAME";
            	"COURSE_DIM_29_DURATION_DAYS"("COURSE_DIM_i") := "SV_COURSE_DIM_29_DURATION_DAYS";
            	"COURSE_DIM_30_COURSE_TYPE"("COURSE_DIM_i") := "SV_COURSE_DIM_30_COURSE_TYPE";
            	"COURSE_DIM_31_CAPACITY"("COURSE_DIM_i") := "SV_COURSE_DIM_31_CAPACITY";
            	"COURSE_DIM_32_COURSE_DESC"("COURSE_DIM_i") := "SV_COURSE_DIM_32_COURSE_DESC";
            	"COURSE_DIM_33_ITBT"("COURSE_DIM_i") := "SV_COURSE_DIM_33_ITBT";
            	"COURSE_DIM_34_ROOT_CODE"("COURSE_DIM_i") := "SV_COURSE_DIM_34_ROOT_CODE";
            	"COURSE_DIM_35_LINE_OF_BUSINESS"("COURSE_DIM_i") := "SV_COURSE_DIM_35_LINE_OF_BUSI";
            	"COURSE_D_36_MCMASTER"("COURSE_DIM_i") := "SV_COURSE_D_36_MCMASTER";
            	"COURSE_DIM_37_MFG_COURSE_CODE"("COURSE_DIM_i") := "SV_COURSE_DIM_37_MFG_COURSE_CO";
              "COURSE_DIM_srk"("COURSE_DIM_i") := "SV_COURSE_DIM_srk";
              "COURSE_DIM_i" := "COURSE_DIM_i" + 1;
            ELSE
              "COURSE_DIM_ir"(dml_bsize) := 0;
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
            "FLTR_ER"('TRACE 91: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i");
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
    IF NOT "COURSE_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"COURSE_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"COURSE_DIM_ins",
        p_upd=>"COURSE_DIM_upd",
        p_del=>"COURSE_DIM_del",
        p_err=>"COURSE_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "COURSE_DIM_ins";
    get_updated  := get_updated  + "COURSE_DIM_upd";
    get_deleted  := get_deleted  + "COURSE_DIM_del";
    get_errors   := get_errors   + "COURSE_DIM_err";

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
get_source_name            CONSTANT VARCHAR2(2000) := '"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"';
get_source_uoid            CONSTANT VARCHAR2(2000) := 'A41FFB199F715678E040007F01006C7D,A41FFB199F6A5678E040007F01006C7D,A41FFB199F4B5678E040007F01006C7D,A41FFB199F4A5678E040007F01006C7D';
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

"COURSE_DIM_id" NUMBER(22) := 0;
"COURSE_DIM_ins" NUMBER(22) := 0;
"COURSE_DIM_upd" NUMBER(22) := 0;
"COURSE_DIM_del" NUMBER(22) := 0;
"COURSE_DIM_err" NUMBER(22) := 0;
-- Variables for auditing in bulk processing
one_rowkey            NUMBER(22) := 0;
get_rowkey            NUMBER(22) := 0;
get_rowkey_bulk       WB_RT_MAPAUDIT.NUMBERLIST;
one_rowid             ROWID;
get_rowid             WB_RT_MAPAUDIT.ROWIDLIST;
rowkey_bulk_index     NUMBER(22) := 0;
x_it_err_count        NUMBER(22) := 0;
get_rowkey_error      NUMBER(22) := 0;

"COURSE_DIM_srk" WB_RT_MAPAUDIT.NUMBERLIST;

-- Helper variables for implementing the correlated commit mechanism
TYPE index_redirect_array IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;

"COURSE_DIM_ir"  index_redirect_array;
"SV_COURSE_DIM_srk" NUMBER;
"COURSE_DIM_new"  BOOLEAN;
"COURSE_DIM_nul"  BOOLEAN := FALSE;

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


"COURSE_DIM_si" NUMBER(22) := 0;

"COURSE_DIM_i" NUMBER(22) := 0;




-- Bulk: types for collection variables
TYPE "T_FLTR_2_EVXCOURSEID$1" IS TABLE OF CHAR(12) INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_FLTR$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_2_COURSE_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_13_COURSECODE$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_3_COUNTRY$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ORAC_2_INVENTOR" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_ROWKEY_DUMMY_TABLE_CURSOR$1" IS TABLE OF VARCHAR2(18) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_CH_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_MD_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_FLEX_3_PL_FLEX_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_23_AMOUNT$1" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_2_ITEM_NUM" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_3_LE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_4_FE_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_5_CH_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_6_MD_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_7_PL_NUM_O" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_GET_ITEM_8_ACT_NUM_" IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_16_CREATEDATE$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_18_MODIFYDATE$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_7_ISINACTIVE$1" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_8_COURSENUMBER$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_11_COURSEGROUP$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_QG_COURSE_12_VENDORCODE$1" IS TABLE OF VARCHAR2(16) INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_4_SHORTNAME$1" IS TABLE OF VARCHAR2(32) INDEX BY BINARY_INTEGER;
TYPE "T_EXPR_1_2_DURATION_IN_DAYS$1" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_FLTR_10_COURSETYPE$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_QG_COURSE_11_CAPACITY$1" IS TABLE OF NUMBER(10) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_35_COURSE_DESC$1" IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_36_ITBT$1" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_37_ROOT_CODE$1" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_38_LINE_OF_BUSI" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COUR_46_MCMASTER$1" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_RMS_COURSE_47_MFG_COURSE_" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_0_COURSE_ID$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_1_COURSE_NAME$1" IS TABLE OF VARCHAR2(250) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_2_COURSE_CH$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_3_COURSE_MOD$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_4_COURSE_PL$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_5_LIST_PRICE$1" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_6_ORACLE_ITEM_" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_7_ORACLE_ITEM_N" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_8_CREATION_DATE$1" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_9_LAST_UPDATE_" IS TABLE OF DATE INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_14_GKDW_SOURCE$1" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_16_COURSE_CODE$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_17_COUNTRY$1" IS TABLE OF VARCHAR2(60) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_18_INACTIVE_FL" IS TABLE OF VARCHAR2(10) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_19_COURSE_NUM$1" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_20_LE_NUM$1" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_21_FE_NUM$1" IS TABLE OF VARCHAR2(3) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_22_CH_NUM$1" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_23_MD_NUM$1" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_24_PL_NUM$1" IS TABLE OF VARCHAR2(2) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_25_ACT_NUM$1" IS TABLE OF VARCHAR2(6) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_26_COURSE_GROUP$1" IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_27_VENDOR_CODE$1" IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_28_SHORT_NAME$1" IS TABLE OF VARCHAR2(50) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_29_DURATION_DA" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_30_COURSE_TYPE$1" IS TABLE OF VARCHAR2(64) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_31_CAPACITY$1" IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_32_COURSE_DESC$1" IS TABLE OF VARCHAR2(255) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_33_ITBT$1" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_34_ROOT_CODE$1" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_35_LINE_OF_BUSI" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_D_36_MCMASTER$1" IS TABLE OF CHAR(1) INDEX BY BINARY_INTEGER;
TYPE "T_COURSE_DIM_37_MFG_COURSE_" IS TABLE OF VARCHAR2(128) INDEX BY BINARY_INTEGER;

-- Bulk: intermediate scalar variables
"SV_FLTR_2_EVXCOURSEID$1"  CHAR(12);
"SV_ROWKEY_FLTR$1"  VARCHAR2(18);
"SV_EXPR_2_COURSE_NAME$1"  VARCHAR2(250);
"SV_FLTR_13_COURSECODE$1"  VARCHAR2(32);
"SV_EXPR_3_COUNTRY$1"  VARCHAR2(60);
"SV_GET_ORAC_2_INVENTOR"  NUMBER;
"SV_ROWKEY_DUMMY_TABLE_CURSOR$1"  VARCHAR2(18);
"SV_GET_FLEX_3_CH_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_MD_FLEX_"  VARCHAR2(32767);
"SV_GET_FLEX_3_PL_FLEX_"  VARCHAR2(32767);
"SV_FLTR_23_AMOUNT$1"  NUMBER;
"SV_GET_ITEM_2_ITEM_NUM"  VARCHAR2(32767);
"SV_GET_ITEM_3_LE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_4_FE_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_5_CH_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_6_MD_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_7_PL_NUM_O"  VARCHAR2(32767);
"SV_GET_ITEM_8_ACT_NUM_"  VARCHAR2(32767);
"SV_FLTR_16_CREATEDATE$1"  DATE;
"SV_FLTR_18_MODIFYDATE$1"  DATE;
"SV_FLTR_7_ISINACTIVE$1"  CHAR(1);
"SV_FLTR_8_COURSENUMBER$1"  VARCHAR2(32);
"SV_FLTR_11_COURSEGROUP$1"  VARCHAR2(64);
"SV_QG_COURSE_12_VENDORCODE$1"  VARCHAR2(16);
"SV_FLTR_4_SHORTNAME$1"  VARCHAR2(32);
"SV_EXPR_1_2_DURATION_IN_DAYS$1"  NUMBER;
"SV_FLTR_10_COURSETYPE$1"  VARCHAR2(64);
"SV_QG_COURSE_11_CAPACITY$1"  NUMBER(10);
"SV_RMS_COURSE_35_COURSE_DESC$1"  VARCHAR2(255);
"SV_RMS_COURSE_36_ITBT$1"  CHAR(1);
"SV_RMS_COURSE_37_ROOT_CODE$1"  VARCHAR2(128);
"SV_RMS_COURSE_38_LINE_OF_BU"  VARCHAR2(128);
"SV_RMS_COUR_46_MCMASTER$1"  CHAR(1);
"SV_RMS_COURSE_47_MFG_COURSE_"  VARCHAR2(128);
"SV_COURSE_DIM_0_COURSE_ID$1"  VARCHAR2(50);
"SV_COURSE_DIM_1_COURSE_NAME$1"  VARCHAR2(250);
"SV_COURSE_DIM_2_COURSE_CH$1"  VARCHAR2(50);
"SV_COURSE_DIM_3_COURSE_MOD$1"  VARCHAR2(50);
"SV_COURSE_DIM_4_COURSE_PL$1"  VARCHAR2(50);
"SV_COURSE_DIM_5_LIST_PRICE$1"  NUMBER;
"SV_COURSE_DIM_6_ORACLE_ITEM_"  NUMBER;
"SV_COURSE_DIM_7_ORACLE_ITEM"  VARCHAR2(50);
"SV_COURSE_DIM_8_CREATION_DA"  DATE;
"SV_COURSE_DIM_9_LAST_UPDATE_"  DATE;
"SV_COURSE_DIM_14_GKDW_SOURCE$1"  VARCHAR2(20);
"SV_COURSE_DIM_16_COURSE_CODE$1"  VARCHAR2(50);
"SV_COURSE_DIM_17_COUNTRY$1"  VARCHAR2(60);
"SV_COURSE_DIM_18_INACTIVE_FL"  VARCHAR2(10);
"SV_COURSE_DIM_19_COURSE_NUM$1"  VARCHAR2(20);
"SV_COURSE_DIM_20_LE_NUM$1"  VARCHAR2(3);
"SV_COURSE_DIM_21_FE_NUM$1"  VARCHAR2(3);
"SV_COURSE_DIM_22_CH_NUM$1"  VARCHAR2(2);
"SV_COURSE_DIM_23_MD_NUM$1"  VARCHAR2(2);
"SV_COURSE_DIM_24_PL_NUM$1"  VARCHAR2(2);
"SV_COURSE_DIM_25_ACT_NUM$1"  VARCHAR2(6);
"SV_COURSE_DIM_26_COURSE_GRO"  VARCHAR2(100);
"SV_COURSE_DIM_27_VENDOR_CODE$1"  VARCHAR2(20);
"SV_COURSE_DIM_28_SHORT_NAME$1"  VARCHAR2(50);
"SV_COURSE_DIM_29_DURATION_DA"  NUMBER;
"SV_COURSE_DIM_30_COURSE_TYPE$1"  VARCHAR2(64);
"SV_COURSE_DIM_31_CAPACITY$1"  NUMBER;
"SV_COURSE_DIM_32_COURSE_DESC$1"  VARCHAR2(255);
"SV_COURSE_DIM_33_ITBT$1"  CHAR(1);
"SV_COURSE_DIM_34_ROOT_CODE$1"  VARCHAR2(128);
"SV_COURSE_DIM_35_LINE_OF_BU"  VARCHAR2(128);
"SV_COURSE_D_36_MCMASTER$1"  CHAR(1);
"SV_COURSE_DIM_37_MFG_COURSE_"  VARCHAR2(128);

-- Bulk: intermediate collection variables
"FLTR_2_EVXCOURSEID$1" "T_FLTR_2_EVXCOURSEID$1";
"ROWKEY_FLTR$1" "T_ROWKEY_FLTR$1";
"EXPR_2_COURSE_NAME$1" "T_EXPR_2_COURSE_NAME$1";
"FLTR_13_COURSECODE$1" "T_FLTR_13_COURSECODE$1";
"EXPR_3_COUNTRY$1" "T_EXPR_3_COUNTRY$1";
"GET_ORAC_2_INVENTOR" "T_GET_ORAC_2_INVENTOR";
"ROWKEY_DUMMY_TABLE_CURSOR$1" "T_ROWKEY_DUMMY_TABLE_CURSOR$1";
"GET_FLEX_3_CH_FLEX_" "T_GET_FLEX_3_CH_FLEX_";
"GET_FLEX_3_MD_FLEX_" "T_GET_FLEX_3_MD_FLEX_";
"GET_FLEX_3_PL_FLEX_" "T_GET_FLEX_3_PL_FLEX_";
"FLTR_23_AMOUNT$1" "T_FLTR_23_AMOUNT$1";
"GET_ITEM_2_ITEM_NUM" "T_GET_ITEM_2_ITEM_NUM";
"GET_ITEM_3_LE_NUM_O" "T_GET_ITEM_3_LE_NUM_O";
"GET_ITEM_4_FE_NUM_O" "T_GET_ITEM_4_FE_NUM_O";
"GET_ITEM_5_CH_NUM_O" "T_GET_ITEM_5_CH_NUM_O";
"GET_ITEM_6_MD_NUM_O" "T_GET_ITEM_6_MD_NUM_O";
"GET_ITEM_7_PL_NUM_O" "T_GET_ITEM_7_PL_NUM_O";
"GET_ITEM_8_ACT_NUM_" "T_GET_ITEM_8_ACT_NUM_";
"FLTR_16_CREATEDATE$1" "T_FLTR_16_CREATEDATE$1";
"FLTR_18_MODIFYDATE$1" "T_FLTR_18_MODIFYDATE$1";
"FLTR_7_ISINACTIVE$1" "T_FLTR_7_ISINACTIVE$1";
"FLTR_8_COURSENUMBER$1" "T_FLTR_8_COURSENUMBER$1";
"FLTR_11_COURSEGROUP$1" "T_FLTR_11_COURSEGROUP$1";
"QG_COURSE_12_VENDORCODE$1" "T_QG_COURSE_12_VENDORCODE$1";
"FLTR_4_SHORTNAME$1" "T_FLTR_4_SHORTNAME$1";
"EXPR_1_2_DURATION_IN_DAYS$1" "T_EXPR_1_2_DURATION_IN_DAYS$1";
"FLTR_10_COURSETYPE$1" "T_FLTR_10_COURSETYPE$1";
"QG_COURSE_11_CAPACITY$1" "T_QG_COURSE_11_CAPACITY$1";
"RMS_COURSE_35_COURSE_DESC$1" "T_RMS_COURSE_35_COURSE_DESC$1";
"RMS_COURSE_36_ITBT$1" "T_RMS_COURSE_36_ITBT$1";
"RMS_COURSE_37_ROOT_CODE$1" "T_RMS_COURSE_37_ROOT_CODE$1";
"RMS_COURSE_38_LINE_OF_BUSINE" "T_RMS_COURSE_38_LINE_OF_BUSI";
"RMS_COUR_46_MCMASTER$1" "T_RMS_COUR_46_MCMASTER$1";
"RMS_COURSE_47_MFG_COURSE_CO" "T_RMS_COURSE_47_MFG_COURSE_";
"COURSE_DIM_0_COURSE_ID$1" "T_COURSE_DIM_0_COURSE_ID$1";
"COURSE_DIM_1_COURSE_NAME$1" "T_COURSE_DIM_1_COURSE_NAME$1";
"COURSE_DIM_2_COURSE_CH$1" "T_COURSE_DIM_2_COURSE_CH$1";
"COURSE_DIM_3_COURSE_MOD$1" "T_COURSE_DIM_3_COURSE_MOD$1";
"COURSE_DIM_4_COURSE_PL$1" "T_COURSE_DIM_4_COURSE_PL$1";
"COURSE_DIM_5_LIST_PRICE$1" "T_COURSE_DIM_5_LIST_PRICE$1";
"COURSE_DIM_6_ORACLE_ITEM_ID$1" "T_COURSE_DIM_6_ORACLE_ITEM_";
"COURSE_DIM_7_ORACLE_ITEM_NUM$1" "T_COURSE_DIM_7_ORACLE_ITEM_N";
"COURSE_DIM_8_CREATION_DATE$1" "T_COURSE_DIM_8_CREATION_DATE$1";
"COURSE_DIM_9_LAST_UPDATE_DA" "T_COURSE_DIM_9_LAST_UPDATE_";
"COURSE_DIM_14_GKDW_SOURCE$1" "T_COURSE_DIM_14_GKDW_SOURCE$1";
"COURSE_DIM_16_COURSE_CODE$1" "T_COURSE_DIM_16_COURSE_CODE$1";
"COURSE_DIM_17_COUNTRY$1" "T_COURSE_DIM_17_COUNTRY$1";
"COURSE_DIM_18_INACTIVE_FLAG$1" "T_COURSE_DIM_18_INACTIVE_FL";
"COURSE_DIM_19_COURSE_NUM$1" "T_COURSE_DIM_19_COURSE_NUM$1";
"COURSE_DIM_20_LE_NUM$1" "T_COURSE_DIM_20_LE_NUM$1";
"COURSE_DIM_21_FE_NUM$1" "T_COURSE_DIM_21_FE_NUM$1";
"COURSE_DIM_22_CH_NUM$1" "T_COURSE_DIM_22_CH_NUM$1";
"COURSE_DIM_23_MD_NUM$1" "T_COURSE_DIM_23_MD_NUM$1";
"COURSE_DIM_24_PL_NUM$1" "T_COURSE_DIM_24_PL_NUM$1";
"COURSE_DIM_25_ACT_NUM$1" "T_COURSE_DIM_25_ACT_NUM$1";
"COURSE_DIM_26_COURSE_GROUP$1" "T_COURSE_DIM_26_COURSE_GROUP$1";
"COURSE_DIM_27_VENDOR_CODE$1" "T_COURSE_DIM_27_VENDOR_CODE$1";
"COURSE_DIM_28_SHORT_NAME$1" "T_COURSE_DIM_28_SHORT_NAME$1";
"COURSE_DIM_29_DURATION_DAYS$1" "T_COURSE_DIM_29_DURATION_DA";
"COURSE_DIM_30_COURSE_TYPE$1" "T_COURSE_DIM_30_COURSE_TYPE$1";
"COURSE_DIM_31_CAPACITY$1" "T_COURSE_DIM_31_CAPACITY$1";
"COURSE_DIM_32_COURSE_DESC$1" "T_COURSE_DIM_32_COURSE_DESC$1";
"COURSE_DIM_33_ITBT$1" "T_COURSE_DIM_33_ITBT$1";
"COURSE_DIM_34_ROOT_CODE$1" "T_COURSE_DIM_34_ROOT_CODE$1";
"COURSE_DIM_35_LINE_OF_BUSINE" "T_COURSE_DIM_35_LINE_OF_BUSI";
"COURSE_D_36_MCMASTER$1" "T_COURSE_D_36_MCMASTER$1";
"COURSE_DIM_37_MFG_COURSE_CO" "T_COURSE_DIM_37_MFG_COURSE_";

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
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_2_EVXCOURSEID',0,80),
    p_value=>SUBSTRB("FLTR_2_EVXCOURSEID$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>2,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('EXPR_2_COURSE_NAME',0,80),
    p_value=>SUBSTRB("EXPR_2_COURSE_NAME$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>3,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_13_COURSECODE',0,80),
    p_value=>SUBSTRB("FLTR_13_COURSECODE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>4,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('EXPR_3_COUNTRY',0,80),
    p_value=>SUBSTRB("EXPR_3_COUNTRY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>5,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_23_AMOUNT',0,80),
    p_value=>SUBSTRB("FLTR_23_AMOUNT$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>6,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_16_CREATEDATE',0,80),
    p_value=>SUBSTRB("FLTR_16_CREATEDATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>7,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_18_MODIFYDATE',0,80),
    p_value=>SUBSTRB("FLTR_18_MODIFYDATE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>8,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_7_ISINACTIVE',0,80),
    p_value=>SUBSTRB("FLTR_7_ISINACTIVE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>9,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_8_COURSENUMBER',0,80),
    p_value=>SUBSTRB("FLTR_8_COURSENUMBER$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>10,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_11_COURSEGROUP',0,80),
    p_value=>SUBSTRB("FLTR_11_COURSEGROUP$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>11,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('QG_COURSE_12_VENDORCODE',0,80),
    p_value=>SUBSTRB("QG_COURSE_12_VENDORCODE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>12,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_4_SHORTNAME',0,80),
    p_value=>SUBSTRB("FLTR_4_SHORTNAME$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>13,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('EXPR_1_2_DURATION_IN_DAYS',0,80),
    p_value=>SUBSTRB("EXPR_1_2_DURATION_IN_DAYS$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>14,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('FLTR_10_COURSETYPE',0,80),
    p_value=>SUBSTRB("FLTR_10_COURSETYPE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>15,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('QG_COURSE_11_CAPACITY',0,80),
    p_value=>SUBSTRB("QG_COURSE_11_CAPACITY$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>16,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_35_COURSE_DESC',0,80),
    p_value=>SUBSTRB("RMS_COURSE_35_COURSE_DESC$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>17,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_36_ITBT',0,80),
    p_value=>SUBSTRB("RMS_COURSE_36_ITBT$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>18,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_37_ROOT_CODE',0,80),
    p_value=>SUBSTRB("RMS_COURSE_37_ROOT_CODE$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>19,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_38_LINE_OF_BUSINESS',0,80),
    p_value=>SUBSTRB("RMS_COURSE_38_LINE_OF_BUSINE"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>20,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COUR_46_MCMASTER',0,80),
    p_value=>SUBSTRB("RMS_COUR_46_MCMASTER$1"(error_index),0,2000),
    p_step=>get_step_number,
    p_role=>'S'
    );
  WB_RT_MAPAUDIT.error_source(
    p_rta=>get_runtime_audit_id,
    p_rowkey=>get_rowkey + error_index - 1,
    p_seq=>21,
    p_instance=>1,
    p_table=>SUBSTR('"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',0,80),
    p_column=>SUBSTR('RMS_COURSE_47_MFG_COURSE_CODE',0,80),
    p_value=>SUBSTRB("RMS_COURSE_47_MFG_COURSE_CO"(error_index),0,2000),
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
      p_stm=>'TRACE 94: ' || p_statement,
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
    "FLTR_2_EVXCOURSEID$1".DELETE;
    "EXPR_2_COURSE_NAME$1".DELETE;
    "FLTR_13_COURSECODE$1".DELETE;
    "EXPR_3_COUNTRY$1".DELETE;
    "FLTR_23_AMOUNT$1".DELETE;
    "FLTR_16_CREATEDATE$1".DELETE;
    "FLTR_18_MODIFYDATE$1".DELETE;
    "FLTR_7_ISINACTIVE$1".DELETE;
    "FLTR_8_COURSENUMBER$1".DELETE;
    "FLTR_11_COURSEGROUP$1".DELETE;
    "QG_COURSE_12_VENDORCODE$1".DELETE;
    "FLTR_4_SHORTNAME$1".DELETE;
    "EXPR_1_2_DURATION_IN_DAYS$1".DELETE;
    "FLTR_10_COURSETYPE$1".DELETE;
    "QG_COURSE_11_CAPACITY$1".DELETE;
    "RMS_COURSE_35_COURSE_DESC$1".DELETE;
    "RMS_COURSE_36_ITBT$1".DELETE;
    "RMS_COURSE_37_ROOT_CODE$1".DELETE;
    "RMS_COURSE_38_LINE_OF_BUSINE".DELETE;
    "RMS_COUR_46_MCMASTER$1".DELETE;
    "RMS_COURSE_47_MFG_COURSE_CO".DELETE;

    FETCH
      "FLTR_c$1"
    BULK COLLECT INTO
      "FLTR_2_EVXCOURSEID$1",
      "EXPR_2_COURSE_NAME$1",
      "FLTR_13_COURSECODE$1",
      "EXPR_3_COUNTRY$1",
      "FLTR_23_AMOUNT$1",
      "FLTR_16_CREATEDATE$1",
      "FLTR_18_MODIFYDATE$1",
      "FLTR_7_ISINACTIVE$1",
      "FLTR_8_COURSENUMBER$1",
      "FLTR_11_COURSEGROUP$1",
      "QG_COURSE_12_VENDORCODE$1",
      "FLTR_4_SHORTNAME$1",
      "EXPR_1_2_DURATION_IN_DAYS$1",
      "FLTR_10_COURSETYPE$1",
      "QG_COURSE_11_CAPACITY$1",
      "RMS_COURSE_35_COURSE_DESC$1",
      "RMS_COURSE_36_ITBT$1",
      "RMS_COURSE_37_ROOT_CODE$1",
      "RMS_COURSE_38_LINE_OF_BUSINE",
      "RMS_COUR_46_MCMASTER$1",
      "RMS_COURSE_47_MFG_COURSE_CO"
    LIMIT get_bulk_size;

    IF "FLTR_c$1"%NOTFOUND AND "FLTR_2_EVXCOURSEID$1".COUNT = 0 THEN
      RETURN;
    END IF;
    -- register feedback for successful reads
    IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
      get_rowkey := rowkey_counter;
      rowkey_counter := rowkey_counter + "FLTR_2_EVXCOURSEID$1".COUNT;
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
    get_map_selected := get_map_selected + "FLTR_2_EVXCOURSEID$1".COUNT;
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
          p_stm=>'TRACE 95: SELECT',
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
  "COURSE_DIM_ins0" NUMBER := "COURSE_DIM_ins";
  "COURSE_DIM_upd0" NUMBER := "COURSE_DIM_upd";
  BEGIN
  IF get_use_hc THEN
    IF firstround AND NOT get_row_status THEN
      RETURN;
    END IF;
    get_row_status := TRUE;
  END IF;
  IF NOT "COURSE_DIM_St" THEN
  -- Update/Insert DML for "COURSE_DIM"
    normal_action := 'UPDATE';
    error_action  := 'UPDATE';
    get_target_name := '"COURSE_DIM"';
    get_audit_detail_id := "COURSE_DIM_id";
    "COURSE_DIM_si" := 1;
    update_bulk.DELETE;
    update_bulk_index := 1;
    IF "COURSE_DIM_i" > get_bulk_size 
   OR "FLTR_c$1"%NOTFOUND OR get_abort THEN
      LOOP
        get_rowid.DELETE;
  
        BEGIN
          FORALL i IN "COURSE_DIM_si".."COURSE_DIM_i" - 1 
            UPDATE
              "COURSE_DIM"
            SET
  
  						"COURSE_DIM"."COURSE_NAME" = "COURSE_DIM_1_COURSE_NAME$1"
  (i),						"COURSE_DIM"."COURSE_CH" = "COURSE_DIM_2_COURSE_CH$1"
  (i),						"COURSE_DIM"."COURSE_MOD" = "COURSE_DIM_3_COURSE_MOD$1"
  (i),						"COURSE_DIM"."COURSE_PL" = "COURSE_DIM_4_COURSE_PL$1"
  (i),						"COURSE_DIM"."LIST_PRICE" = "COURSE_DIM_5_LIST_PRICE$1"
  (i),						"COURSE_DIM"."ORACLE_ITEM_ID" = "COURSE_DIM_6_ORACLE_ITEM_ID$1"
  (i),						"COURSE_DIM"."ORACLE_ITEM_NUM" = "COURSE_DIM_7_ORACLE_ITEM_NUM$1"
  (i),						"COURSE_DIM"."CREATION_DATE" = "COURSE_DIM_8_CREATION_DATE$1"
  (i),						"COURSE_DIM"."LAST_UPDATE_DATE" = "COURSE_DIM_9_LAST_UPDATE_DA"
  (i),						"COURSE_DIM"."GKDW_SOURCE" = "COURSE_DIM_14_GKDW_SOURCE$1"
  (i),						"COURSE_DIM"."COURSE_CODE" = "COURSE_DIM_16_COURSE_CODE$1"
  (i),						"COURSE_DIM"."INACTIVE_FLAG" = "COURSE_DIM_18_INACTIVE_FLAG$1"
  (i),						"COURSE_DIM"."COURSE_NUM" = "COURSE_DIM_19_COURSE_NUM$1"
  (i),						"COURSE_DIM"."LE_NUM" = "COURSE_DIM_20_LE_NUM$1"
  (i),						"COURSE_DIM"."FE_NUM" = "COURSE_DIM_21_FE_NUM$1"
  (i),						"COURSE_DIM"."CH_NUM" = "COURSE_DIM_22_CH_NUM$1"
  (i),						"COURSE_DIM"."MD_NUM" = "COURSE_DIM_23_MD_NUM$1"
  (i),						"COURSE_DIM"."PL_NUM" = "COURSE_DIM_24_PL_NUM$1"
  (i),						"COURSE_DIM"."ACT_NUM" = "COURSE_DIM_25_ACT_NUM$1"
  (i),						"COURSE_DIM"."COURSE_GROUP" = "COURSE_DIM_26_COURSE_GROUP$1"
  (i),						"COURSE_DIM"."VENDOR_CODE" = "COURSE_DIM_27_VENDOR_CODE$1"
  (i),						"COURSE_DIM"."SHORT_NAME" = "COURSE_DIM_28_SHORT_NAME$1"
  (i),						"COURSE_DIM"."DURATION_DAYS" = "COURSE_DIM_29_DURATION_DAYS$1"
  (i),						"COURSE_DIM"."COURSE_TYPE" = "COURSE_DIM_30_COURSE_TYPE$1"
  (i),						"COURSE_DIM"."CAPACITY" = "COURSE_DIM_31_CAPACITY$1"
  (i),						"COURSE_DIM"."COURSE_DESC" = "COURSE_DIM_32_COURSE_DESC$1"
  (i),						"COURSE_DIM"."ITBT" = "COURSE_DIM_33_ITBT$1"
  (i),						"COURSE_DIM"."ROOT_CODE" = "COURSE_DIM_34_ROOT_CODE$1"
  (i),						"COURSE_DIM"."LINE_OF_BUSINESS" = "COURSE_DIM_35_LINE_OF_BUSINE"
  (i),						"COURSE_DIM"."MCMASTERS_ELIGIBLE" = "COURSE_D_36_MCMASTER$1"
  (i),						"COURSE_DIM"."MFG_COURSE_CODE" = "COURSE_DIM_37_MFG_COURSE_CO"
  (i)
    
            WHERE
  
  						"COURSE_DIM"."COURSE_ID" = "COURSE_DIM_0_COURSE_ID$1"
  (i) AND						"COURSE_DIM"."COUNTRY" = "COURSE_DIM_17_COUNTRY$1"
  (i)
    
  RETURNING ROWID BULK COLLECT INTO get_rowid;
  
          feedback_bulk_limit := "COURSE_DIM_i" - 1;
          get_rowkey_bulk.DELETE;
          rowkey_bulk_index := 1;
          FOR rowkey_index IN "COURSE_DIM_si"..feedback_bulk_limit LOOP
            IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
              update_bulk(update_bulk_index) := rowkey_index;
              update_bulk_index := update_bulk_index + 1;
            ELSE
              IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                get_rowkey_bulk(rowkey_bulk_index) := "COURSE_DIM_srk"(rowkey_index);
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
  
          "COURSE_DIM_upd" := "COURSE_DIM_upd" + get_rowid.COUNT;
          "COURSE_DIM_si" := "COURSE_DIM_i";
  
        EXCEPTION
          WHEN OTHERS THEN
              last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
            IF SQL%NOTFOUND THEN
              last_successful_index := 0;
            ELSE
              FOR rowkey_index IN REVERSE "COURSE_DIM_si".."COURSE_DIM_i"- 1 LOOP
                IF NOT (SQL%BULK_ROWCOUNT(rowkey_index) = 0) THEN
                  last_successful_index := rowkey_index;
                  EXIT;
                END IF;
              END LOOP;
            END IF;
            feedback_bulk_limit := last_successful_index;
            get_rowkey_bulk.DELETE;
            rowkey_bulk_index := 1;
            FOR rowkey_index IN "COURSE_DIM_si"..feedback_bulk_limit LOOP
              IF SQL%BULK_ROWCOUNT(rowkey_index) = 0 THEN
                update_bulk(update_bulk_index) := rowkey_index;
                update_bulk_index := update_bulk_index + 1;
              ELSE
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  get_rowkey_bulk(rowkey_bulk_index) := "COURSE_DIM_srk"(rowkey_index);
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
            "COURSE_DIM_upd" := "COURSE_DIM_upd" + get_rowid.COUNT;
            IF last_successful_index = 0 THEN
              last_successful_index := "COURSE_DIM_si";
            ELSE
              last_successful_index := last_successful_index +1;
            END IF;
            LOOP
              BEGIN
                UPDATE
                  "COURSE_DIM"
                SET
  
  								"COURSE_DIM"."COURSE_NAME" = "COURSE_DIM_1_COURSE_NAME$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_CH" = "COURSE_DIM_2_COURSE_CH$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_MOD" = "COURSE_DIM_3_COURSE_MOD$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_PL" = "COURSE_DIM_4_COURSE_PL$1"
  (last_successful_index),								"COURSE_DIM"."LIST_PRICE" = "COURSE_DIM_5_LIST_PRICE$1"
  (last_successful_index),								"COURSE_DIM"."ORACLE_ITEM_ID" = "COURSE_DIM_6_ORACLE_ITEM_ID$1"
  (last_successful_index),								"COURSE_DIM"."ORACLE_ITEM_NUM" = "COURSE_DIM_7_ORACLE_ITEM_NUM$1"
  (last_successful_index),								"COURSE_DIM"."CREATION_DATE" = "COURSE_DIM_8_CREATION_DATE$1"
  (last_successful_index),								"COURSE_DIM"."LAST_UPDATE_DATE" = "COURSE_DIM_9_LAST_UPDATE_DA"
  (last_successful_index),								"COURSE_DIM"."GKDW_SOURCE" = "COURSE_DIM_14_GKDW_SOURCE$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_CODE" = "COURSE_DIM_16_COURSE_CODE$1"
  (last_successful_index),								"COURSE_DIM"."INACTIVE_FLAG" = "COURSE_DIM_18_INACTIVE_FLAG$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_NUM" = "COURSE_DIM_19_COURSE_NUM$1"
  (last_successful_index),								"COURSE_DIM"."LE_NUM" = "COURSE_DIM_20_LE_NUM$1"
  (last_successful_index),								"COURSE_DIM"."FE_NUM" = "COURSE_DIM_21_FE_NUM$1"
  (last_successful_index),								"COURSE_DIM"."CH_NUM" = "COURSE_DIM_22_CH_NUM$1"
  (last_successful_index),								"COURSE_DIM"."MD_NUM" = "COURSE_DIM_23_MD_NUM$1"
  (last_successful_index),								"COURSE_DIM"."PL_NUM" = "COURSE_DIM_24_PL_NUM$1"
  (last_successful_index),								"COURSE_DIM"."ACT_NUM" = "COURSE_DIM_25_ACT_NUM$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_GROUP" = "COURSE_DIM_26_COURSE_GROUP$1"
  (last_successful_index),								"COURSE_DIM"."VENDOR_CODE" = "COURSE_DIM_27_VENDOR_CODE$1"
  (last_successful_index),								"COURSE_DIM"."SHORT_NAME" = "COURSE_DIM_28_SHORT_NAME$1"
  (last_successful_index),								"COURSE_DIM"."DURATION_DAYS" = "COURSE_DIM_29_DURATION_DAYS$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_TYPE" = "COURSE_DIM_30_COURSE_TYPE$1"
  (last_successful_index),								"COURSE_DIM"."CAPACITY" = "COURSE_DIM_31_CAPACITY$1"
  (last_successful_index),								"COURSE_DIM"."COURSE_DESC" = "COURSE_DIM_32_COURSE_DESC$1"
  (last_successful_index),								"COURSE_DIM"."ITBT" = "COURSE_DIM_33_ITBT$1"
  (last_successful_index),								"COURSE_DIM"."ROOT_CODE" = "COURSE_DIM_34_ROOT_CODE$1"
  (last_successful_index),								"COURSE_DIM"."LINE_OF_BUSINESS" = "COURSE_DIM_35_LINE_OF_BUSINE"
  (last_successful_index),								"COURSE_DIM"."MCMASTERS_ELIGIBLE" = "COURSE_D_36_MCMASTER$1"
  (last_successful_index),								"COURSE_DIM"."MFG_COURSE_CODE" = "COURSE_DIM_37_MFG_COURSE_CO"
  (last_successful_index)
  
                WHERE
  
  								"COURSE_DIM"."COURSE_ID" = "COURSE_DIM_0_COURSE_ID$1"
  (last_successful_index) AND 								"COURSE_DIM"."COUNTRY" = "COURSE_DIM_17_COUNTRY$1"
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
                  error_rowkey := "COURSE_DIM_srk"(last_successful_index);
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
                  

                  
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NAME"',0,80),SUBSTRB("COURSE_DIM_1_COURSE_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CH"',0,80),SUBSTRB("COURSE_DIM_2_COURSE_CH$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_MOD"',0,80),SUBSTRB("COURSE_DIM_3_COURSE_MOD$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_PL"',0,80),SUBSTRB("COURSE_DIM_4_COURSE_PL$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LIST_PRICE"',0,80),SUBSTRB("COURSE_DIM_5_LIST_PRICE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_ID"',0,80),SUBSTRB("COURSE_DIM_6_ORACLE_ITEM_ID$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("COURSE_DIM_7_ORACLE_ITEM_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CREATION_DATE"',0,80),SUBSTRB("COURSE_DIM_8_CREATION_DATE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("COURSE_DIM_9_LAST_UPDATE_DA"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("COURSE_DIM_14_GKDW_SOURCE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_16_COURSE_CODE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."INACTIVE_FLAG"',0,80),SUBSTRB("COURSE_DIM_18_INACTIVE_FLAG$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NUM"',0,80),SUBSTRB("COURSE_DIM_19_COURSE_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LE_NUM"',0,80),SUBSTRB("COURSE_DIM_20_LE_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."FE_NUM"',0,80),SUBSTRB("COURSE_DIM_21_FE_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CH_NUM"',0,80),SUBSTRB("COURSE_DIM_22_CH_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MD_NUM"',0,80),SUBSTRB("COURSE_DIM_23_MD_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."PL_NUM"',0,80),SUBSTRB("COURSE_DIM_24_PL_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ACT_NUM"',0,80),SUBSTRB("COURSE_DIM_25_ACT_NUM$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_GROUP"',0,80),SUBSTRB("COURSE_DIM_26_COURSE_GROUP$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."VENDOR_CODE"',0,80),SUBSTRB("COURSE_DIM_27_VENDOR_CODE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."SHORT_NAME"',0,80),SUBSTRB("COURSE_DIM_28_SHORT_NAME$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."DURATION_DAYS"',0,80),SUBSTRB("COURSE_DIM_29_DURATION_DAYS$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_TYPE"',0,80),SUBSTRB("COURSE_DIM_30_COURSE_TYPE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CAPACITY"',0,80),SUBSTRB("COURSE_DIM_31_CAPACITY$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_DESC"',0,80),SUBSTRB("COURSE_DIM_32_COURSE_DESC$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ITBT"',0,80),SUBSTRB("COURSE_DIM_33_ITBT$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ROOT_CODE"',0,80),SUBSTRB("COURSE_DIM_34_ROOT_CODE$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LINE_OF_BUSINESS"',0,80),SUBSTRB("COURSE_DIM_35_LINE_OF_BUSINE"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MCMASTERS_ELIGIBLE"',0,80),SUBSTRB("COURSE_D_36_MCMASTER$1"(last_successful_index),0,2000));
                  Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MFG_COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_37_MFG_COURSE_CO"(last_successful_index),0,2000));
                  
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
                "COURSE_DIM_err" := "COURSE_DIM_err" + 1;
                
                IF get_errors + "COURSE_DIM_err" > get_max_errors THEN
                  get_abort:= TRUE;
                END IF;
                "COURSE_DIM_si" := last_successful_index + 1;
                EXIT;
            END;
          END LOOP;
      END;
      IF "COURSE_DIM_si" >= "COURSE_DIM_i" OR get_abort THEN
        EXIT;
      END IF;
    END LOOP;
  
    "COURSE_DIM_i" := 1;
  
    --process leftover inserts
    insert_bulk_index := 0;
    FOR j IN 1..update_bulk.COUNT LOOP
      insert_bulk_index := insert_bulk_index + 1;
  		"COURSE_DIM_0_COURSE_ID$1"(insert_bulk_index) := "COURSE_DIM_0_COURSE_ID$1"(update_bulk(j));
  		"COURSE_DIM_1_COURSE_NAME$1"(insert_bulk_index) := "COURSE_DIM_1_COURSE_NAME$1"(update_bulk(j));
  		"COURSE_DIM_2_COURSE_CH$1"(insert_bulk_index) := "COURSE_DIM_2_COURSE_CH$1"(update_bulk(j));
  		"COURSE_DIM_3_COURSE_MOD$1"(insert_bulk_index) := "COURSE_DIM_3_COURSE_MOD$1"(update_bulk(j));
  		"COURSE_DIM_4_COURSE_PL$1"(insert_bulk_index) := "COURSE_DIM_4_COURSE_PL$1"(update_bulk(j));
  		"COURSE_DIM_5_LIST_PRICE$1"(insert_bulk_index) := "COURSE_DIM_5_LIST_PRICE$1"(update_bulk(j));
  		"COURSE_DIM_6_ORACLE_ITEM_ID$1"(insert_bulk_index) := "COURSE_DIM_6_ORACLE_ITEM_ID$1"(update_bulk(j));
  		"COURSE_DIM_7_ORACLE_ITEM_NUM$1"(insert_bulk_index) := "COURSE_DIM_7_ORACLE_ITEM_NUM$1"(update_bulk(j));
  		"COURSE_DIM_8_CREATION_DATE$1"(insert_bulk_index) := "COURSE_DIM_8_CREATION_DATE$1"(update_bulk(j));
  		"COURSE_DIM_9_LAST_UPDATE_DA"(insert_bulk_index) := "COURSE_DIM_9_LAST_UPDATE_DA"(update_bulk(j));
  		"COURSE_DIM_14_GKDW_SOURCE$1"(insert_bulk_index) := "COURSE_DIM_14_GKDW_SOURCE$1"(update_bulk(j));
  		"COURSE_DIM_16_COURSE_CODE$1"(insert_bulk_index) := "COURSE_DIM_16_COURSE_CODE$1"(update_bulk(j));
  		"COURSE_DIM_17_COUNTRY$1"(insert_bulk_index) := "COURSE_DIM_17_COUNTRY$1"(update_bulk(j));
  		"COURSE_DIM_18_INACTIVE_FLAG$1"(insert_bulk_index) := "COURSE_DIM_18_INACTIVE_FLAG$1"(update_bulk(j));
  		"COURSE_DIM_19_COURSE_NUM$1"(insert_bulk_index) := "COURSE_DIM_19_COURSE_NUM$1"(update_bulk(j));
  		"COURSE_DIM_20_LE_NUM$1"(insert_bulk_index) := "COURSE_DIM_20_LE_NUM$1"(update_bulk(j));
  		"COURSE_DIM_21_FE_NUM$1"(insert_bulk_index) := "COURSE_DIM_21_FE_NUM$1"(update_bulk(j));
  		"COURSE_DIM_22_CH_NUM$1"(insert_bulk_index) := "COURSE_DIM_22_CH_NUM$1"(update_bulk(j));
  		"COURSE_DIM_23_MD_NUM$1"(insert_bulk_index) := "COURSE_DIM_23_MD_NUM$1"(update_bulk(j));
  		"COURSE_DIM_24_PL_NUM$1"(insert_bulk_index) := "COURSE_DIM_24_PL_NUM$1"(update_bulk(j));
  		"COURSE_DIM_25_ACT_NUM$1"(insert_bulk_index) := "COURSE_DIM_25_ACT_NUM$1"(update_bulk(j));
  		"COURSE_DIM_26_COURSE_GROUP$1"(insert_bulk_index) := "COURSE_DIM_26_COURSE_GROUP$1"(update_bulk(j));
  		"COURSE_DIM_27_VENDOR_CODE$1"(insert_bulk_index) := "COURSE_DIM_27_VENDOR_CODE$1"(update_bulk(j));
  		"COURSE_DIM_28_SHORT_NAME$1"(insert_bulk_index) := "COURSE_DIM_28_SHORT_NAME$1"(update_bulk(j));
  		"COURSE_DIM_29_DURATION_DAYS$1"(insert_bulk_index) := "COURSE_DIM_29_DURATION_DAYS$1"(update_bulk(j));
  		"COURSE_DIM_30_COURSE_TYPE$1"(insert_bulk_index) := "COURSE_DIM_30_COURSE_TYPE$1"(update_bulk(j));
  		"COURSE_DIM_31_CAPACITY$1"(insert_bulk_index) := "COURSE_DIM_31_CAPACITY$1"(update_bulk(j));
  		"COURSE_DIM_32_COURSE_DESC$1"(insert_bulk_index) := "COURSE_DIM_32_COURSE_DESC$1"(update_bulk(j));
  		"COURSE_DIM_33_ITBT$1"(insert_bulk_index) := "COURSE_DIM_33_ITBT$1"(update_bulk(j));
  		"COURSE_DIM_34_ROOT_CODE$1"(insert_bulk_index) := "COURSE_DIM_34_ROOT_CODE$1"(update_bulk(j));
  		"COURSE_DIM_35_LINE_OF_BUSINE"(insert_bulk_index) := "COURSE_DIM_35_LINE_OF_BUSINE"(update_bulk(j));
  		"COURSE_D_36_MCMASTER$1"(insert_bulk_index) := "COURSE_D_36_MCMASTER$1"(update_bulk(j));
  		"COURSE_DIM_37_MFG_COURSE_CO"(insert_bulk_index) := "COURSE_DIM_37_MFG_COURSE_CO"(update_bulk(j));
      IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
        "COURSE_DIM_srk"(insert_bulk_index) := "COURSE_DIM_srk"(update_bulk(j));
      END IF;
    END LOOP;
  
    "COURSE_DIM_si" := 1;
    normal_action := 'INSERT';
    error_action  := 'INSERT';
    LOOP
      EXIT WHEN get_abort OR "COURSE_DIM_si" > insert_bulk_index;
      get_rowid.DELETE;
  
      BEGIN
        FORALL i IN "COURSE_DIM_si"..insert_bulk_index
          INSERT INTO
            "COURSE_DIM"
            ("COURSE_DIM"."COURSE_ID",
            "COURSE_DIM"."COURSE_NAME",
            "COURSE_DIM"."COURSE_CH",
            "COURSE_DIM"."COURSE_MOD",
            "COURSE_DIM"."COURSE_PL",
            "COURSE_DIM"."LIST_PRICE",
            "COURSE_DIM"."ORACLE_ITEM_ID",
            "COURSE_DIM"."ORACLE_ITEM_NUM",
            "COURSE_DIM"."CREATION_DATE",
            "COURSE_DIM"."LAST_UPDATE_DATE",
            "COURSE_DIM"."GKDW_SOURCE",
            "COURSE_DIM"."COURSE_CODE",
            "COURSE_DIM"."COUNTRY",
            "COURSE_DIM"."INACTIVE_FLAG",
            "COURSE_DIM"."COURSE_NUM",
            "COURSE_DIM"."LE_NUM",
            "COURSE_DIM"."FE_NUM",
            "COURSE_DIM"."CH_NUM",
            "COURSE_DIM"."MD_NUM",
            "COURSE_DIM"."PL_NUM",
            "COURSE_DIM"."ACT_NUM",
            "COURSE_DIM"."COURSE_GROUP",
            "COURSE_DIM"."VENDOR_CODE",
            "COURSE_DIM"."SHORT_NAME",
            "COURSE_DIM"."DURATION_DAYS",
            "COURSE_DIM"."COURSE_TYPE",
            "COURSE_DIM"."CAPACITY",
            "COURSE_DIM"."COURSE_DESC",
            "COURSE_DIM"."ITBT",
            "COURSE_DIM"."ROOT_CODE",
            "COURSE_DIM"."LINE_OF_BUSINESS",
            "COURSE_DIM"."MCMASTERS_ELIGIBLE",
            "COURSE_DIM"."MFG_COURSE_CODE")
          VALUES
            ("COURSE_DIM_0_COURSE_ID$1"(i),
            "COURSE_DIM_1_COURSE_NAME$1"(i),
            "COURSE_DIM_2_COURSE_CH$1"(i),
            "COURSE_DIM_3_COURSE_MOD$1"(i),
            "COURSE_DIM_4_COURSE_PL$1"(i),
            "COURSE_DIM_5_LIST_PRICE$1"(i),
            "COURSE_DIM_6_ORACLE_ITEM_ID$1"(i),
            "COURSE_DIM_7_ORACLE_ITEM_NUM$1"(i),
            "COURSE_DIM_8_CREATION_DATE$1"(i),
            "COURSE_DIM_9_LAST_UPDATE_DA"(i),
            "COURSE_DIM_14_GKDW_SOURCE$1"(i),
            "COURSE_DIM_16_COURSE_CODE$1"(i),
            "COURSE_DIM_17_COUNTRY$1"(i),
            "COURSE_DIM_18_INACTIVE_FLAG$1"(i),
            "COURSE_DIM_19_COURSE_NUM$1"(i),
            "COURSE_DIM_20_LE_NUM$1"(i),
            "COURSE_DIM_21_FE_NUM$1"(i),
            "COURSE_DIM_22_CH_NUM$1"(i),
            "COURSE_DIM_23_MD_NUM$1"(i),
            "COURSE_DIM_24_PL_NUM$1"(i),
            "COURSE_DIM_25_ACT_NUM$1"(i),
            "COURSE_DIM_26_COURSE_GROUP$1"(i),
            "COURSE_DIM_27_VENDOR_CODE$1"(i),
            "COURSE_DIM_28_SHORT_NAME$1"(i),
            "COURSE_DIM_29_DURATION_DAYS$1"(i),
            "COURSE_DIM_30_COURSE_TYPE$1"(i),
            "COURSE_DIM_31_CAPACITY$1"(i),
            "COURSE_DIM_32_COURSE_DESC$1"(i),
            "COURSE_DIM_33_ITBT$1"(i),
            "COURSE_DIM_34_ROOT_CODE$1"(i),
            "COURSE_DIM_35_LINE_OF_BUSINE"(i),
            "COURSE_D_36_MCMASTER$1"(i),
            "COURSE_DIM_37_MFG_COURSE_CO"(i))
          RETURNING ROWID BULK COLLECT INTO get_rowid;
        error_index := "COURSE_DIM_si" + get_rowid.COUNT;
      EXCEPTION
        WHEN OTHERS THEN
            last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
          error_index := "COURSE_DIM_si" + get_rowid.COUNT;
          IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
            error_rowkey := "COURSE_DIM_srk"(error_index);
            WB_RT_MAPAUDIT.error(
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_rtd=>get_audit_detail_id,
              p_rowkey=>error_rowkey,
              p_table=>get_target_name,
              p_column=>'*',
              p_dstval=>NULL,
              p_stm=>'TRACE 96: ' || error_action,
              p_sqlerr=>SQLCODE,
              p_sqlerrm=>SQLERRM,
              p_rowid=>NULL
            );
            get_column_seq := 0;
            

            
            
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_ID"',0,80),SUBSTRB("COURSE_DIM_0_COURSE_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NAME"',0,80),SUBSTRB("COURSE_DIM_1_COURSE_NAME$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CH"',0,80),SUBSTRB("COURSE_DIM_2_COURSE_CH$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_MOD"',0,80),SUBSTRB("COURSE_DIM_3_COURSE_MOD$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_PL"',0,80),SUBSTRB("COURSE_DIM_4_COURSE_PL$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LIST_PRICE"',0,80),SUBSTRB("COURSE_DIM_5_LIST_PRICE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_ID"',0,80),SUBSTRB("COURSE_DIM_6_ORACLE_ITEM_ID$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ORACLE_ITEM_NUM"',0,80),SUBSTRB("COURSE_DIM_7_ORACLE_ITEM_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CREATION_DATE"',0,80),SUBSTRB("COURSE_DIM_8_CREATION_DATE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LAST_UPDATE_DATE"',0,80),SUBSTRB("COURSE_DIM_9_LAST_UPDATE_DA"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."GKDW_SOURCE"',0,80),SUBSTRB("COURSE_DIM_14_GKDW_SOURCE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_16_COURSE_CODE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COUNTRY"',0,80),SUBSTRB("COURSE_DIM_17_COUNTRY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."INACTIVE_FLAG"',0,80),SUBSTRB("COURSE_DIM_18_INACTIVE_FLAG$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_NUM"',0,80),SUBSTRB("COURSE_DIM_19_COURSE_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LE_NUM"',0,80),SUBSTRB("COURSE_DIM_20_LE_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."FE_NUM"',0,80),SUBSTRB("COURSE_DIM_21_FE_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CH_NUM"',0,80),SUBSTRB("COURSE_DIM_22_CH_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MD_NUM"',0,80),SUBSTRB("COURSE_DIM_23_MD_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."PL_NUM"',0,80),SUBSTRB("COURSE_DIM_24_PL_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ACT_NUM"',0,80),SUBSTRB("COURSE_DIM_25_ACT_NUM$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_GROUP"',0,80),SUBSTRB("COURSE_DIM_26_COURSE_GROUP$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."VENDOR_CODE"',0,80),SUBSTRB("COURSE_DIM_27_VENDOR_CODE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."SHORT_NAME"',0,80),SUBSTRB("COURSE_DIM_28_SHORT_NAME$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."DURATION_DAYS"',0,80),SUBSTRB("COURSE_DIM_29_DURATION_DAYS$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_TYPE"',0,80),SUBSTRB("COURSE_DIM_30_COURSE_TYPE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."CAPACITY"',0,80),SUBSTRB("COURSE_DIM_31_CAPACITY$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."COURSE_DESC"',0,80),SUBSTRB("COURSE_DIM_32_COURSE_DESC$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ITBT"',0,80),SUBSTRB("COURSE_DIM_33_ITBT$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."ROOT_CODE"',0,80),SUBSTRB("COURSE_DIM_34_ROOT_CODE$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."LINE_OF_BUSINESS"',0,80),SUBSTRB("COURSE_DIM_35_LINE_OF_BUSINE"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MCMASTERS_ELIGIBLE"',0,80),SUBSTRB("COURSE_D_36_MCMASTER$1"(error_index),0,2000));
            Main_ES(get_step_number,error_rowkey,get_target_name,SUBSTRB('"COURSE_DIM"."MFG_COURSE_CODE"',0,80),SUBSTRB("COURSE_DIM_37_MFG_COURSE_CO"(error_index),0,2000));
            
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
          "COURSE_DIM_err" := "COURSE_DIM_err" + 1;
          
          IF get_errors + "COURSE_DIM_err" > get_max_errors THEN
            get_abort:= TRUE;
          END IF;
      END;
  
      -- feedback for a bulk of rows
      IF get_audit_level = AUDIT_COMPLETE THEN
        get_rowkey_bulk.DELETE;
        rowkey_bulk_index := 1;
        FOR rowkey_index IN "COURSE_DIM_si"..error_index - 1 LOOP
          get_rowkey_bulk(rowkey_bulk_index) := "COURSE_DIM_srk"(rowkey_index);
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
  
      "COURSE_DIM_ins" := "COURSE_DIM_ins" + get_rowid.COUNT;
      "COURSE_DIM_si" := error_index + 1;
    END LOOP;
    END IF;
  END IF;
  

  IF get_use_hc AND NOT firstround THEN
    COMMIT; -- commit no.27
  END IF;
  IF get_use_hc AND NOT get_row_status THEN
    "COURSE_DIM_ins" := "COURSE_DIM_ins0"; 
    "COURSE_DIM_upd" := "COURSE_DIM_upd0";
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

  IF NOT "COURSE_DIM_St" THEN
    -- For normal cursor query loop operation, skip map procedure initialization if 
    -- cursor is already open - procedure initialization should only be done the 
    -- first time the procedure is called (since mapping debugger
    -- executes the procedure multiple times and leaves the cursor open). 
    -- For table function (parallel row mode) operation, the cursor will already be
    -- open when the procedure is called, so execute the initialization.
    IF get_table_function OR (NOT "FLTR_c$1"%ISOPEN) THEN
      IF NOT (get_audit_level = AUDIT_NONE) THEN
        IF NOT "COURSE_DIM_St" THEN
          "COURSE_DIM_id" :=
            WB_RT_MAPAUDIT.auditd_begin(  -- Template AuditDetailBegin
              p_rta=>get_runtime_audit_id,
              p_step=>get_step_number,
              p_name=>get_map_name,
              p_source=>get_source_name,
              p_source_uoid=>get_source_uoid,
              p_target=>'"COURSE_DIM"',
              p_target_uoid=>'A41FFB199F6F5678E040007F01006C7D',
              p_stm=>'TRACE 98',
            	p_info=>NULL,
              p_exec_mode=>l_exec_mode
            );
            get_audit_detail_id := "COURSE_DIM_id";
              
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F4A5678E040007F01006C7D', -- Operator RMS_COURSE
              p_parent_object_name=>'RMS_COURSE',
              p_parent_object_uoid=>'A41FFB18FC635678E040007F01006C7D', -- Table RMS_COURSE
              p_parent_object_type=>'Table',
              p_object_name=>'RMS_COURSE',
              p_object_uoid=>'A41FFB18FC635678E040007F01006C7D', -- Table RMS_COURSE
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FC3D5678E040007F01006C7D' -- Location RMSDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F6A5678E040007F01006C7D', -- Operator EVXCOURSEFEE
              p_parent_object_name=>'EVXCOURSEFEE',
              p_parent_object_uoid=>'A41FFB1909875678E040007F01006C7D', -- Table EVXCOURSEFEE
              p_parent_object_type=>'Table',
              p_object_name=>'EVXCOURSEFEE',
              p_object_uoid=>'A41FFB1909875678E040007F01006C7D', -- Table EVXCOURSEFEE
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F6F5678E040007F01006C7D', -- Operator COURSE_DIM
              p_parent_object_name=>'COURSE_DIM',
              p_parent_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'COURSE_DIM',
              p_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- Location GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F4B5678E040007F01006C7D', -- Operator QG_COURSE
              p_parent_object_name=>'QG_COURSE',
              p_parent_object_uoid=>'A41FFB190D2A5678E040007F01006C7D', -- Table QG_COURSE
              p_parent_object_type=>'Table',
              p_object_name=>'QG_COURSE',
              p_object_uoid=>'A41FFB190D2A5678E040007F01006C7D', -- Table QG_COURSE
              p_object_type=>'Table',
              p_location_uoid=>'A41FFB18FCD75678E040007F01006C7D' -- Location SLXDW_SOURCE_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB19A0A75678E040007F01006C7D', -- Operator COURSE_DIM
              p_parent_object_name=>'COURSE_DIM',
              p_parent_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_parent_object_type=>'Table',
              p_object_name=>'COURSE_DIM',
              p_object_uoid=>'A41FA16DAE70655CE040007F01006B9E', -- Table COURSE_DIM
              p_object_type=>'Table',
              p_location_uoid=>'A41FA16DADDC655CE040007F01006B9E' -- GKDW_TARGET_LOCATION
            );  
get_audit_detail_type_id := WB_RT_MAPAUDIT.register_audit_detail_type(
              p_rtd=>get_audit_detail_id,
              p_parent_operator_uoid=>'A41FFB199F715678E040007F01006C7D', -- Operator EVXCOURSE
              p_parent_object_name=>'EVXCOURSE',
              p_parent_object_uoid=>'A41FFB1907FF5678E040007F01006C7D', -- Table EVXCOURSE
              p_parent_object_type=>'Table',
              p_object_name=>'EVXCOURSE',
              p_object_uoid=>'A41FFB1907FF5678E040007F01006C7D', -- Table EVXCOURSE
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
    "COURSE_DIM_i" := 1;
    get_rows_processed := FALSE;

    IF NOT get_abort AND NOT get_abort_procedure THEN
      "FLTR_SU$1";

      LOOP
        IF "FLTR_si$1" = 0 THEN
          "FLTR_RD$1";   -- Fetch data from source
          IF NOT get_read_success THEN
            bulk_count := "FLTR_2_EVXCOURSEID$1".COUNT - 1;
          ELSE
            bulk_count := "FLTR_2_EVXCOURSEID$1".COUNT;
          END IF;
 
          IF get_use_hc THEN
            dml_bsize := 0;
            "COURSE_DIM_ir".DELETE;
"COURSE_DIM_i" := 1;
          END IF;
        END IF;

        -- Processing:
        "FLTR_i$1" := "FLTR_si$1";
        BEGIN
          
          LOOP
            EXIT WHEN "COURSE_DIM_i" > get_bulk_size OR get_abort OR get_abort_procedure;

            "FLTR_i$1" := "FLTR_i$1" + 1;
            "FLTR_si$1" := "FLTR_i$1";
            IF get_use_hc THEN
              get_row_status := TRUE;
                "COURSE_DIM_new" := FALSE;
            END IF;

            get_buffer_done(get_buffer_done_index) := 
              ("FLTR_c$1"%NOTFOUND AND
               "FLTR_i$1" > bulk_count);

            IF (NOT get_buffer_done(get_buffer_done_index)) AND
              "FLTR_i$1" > bulk_count THEN
            
              "FLTR_si$1" := 0;
              EXIT;
            END IF;


            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_ORACLE_ITEM_ID"("FLTR_13_COURSECODE$1"
            ("FLTR_i$1"),"EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"));
            
            ',0,2000);
            
                
                "GET_ORACLE_ITEM_ID"("FLTR_13_COURSECODE$1"
            ("FLTR_i$1"),"EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"OWB_COURSE_DIM"."GET_CONST_4_CH_FLEX_VALUE_SET_","EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_FLEX_3_CH_FLEX_"
            ("FLTR_i$1"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"OWB_COURSE_DIM"."GET_CONST_4_CH_FLEX_VALUE_SET_","EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_FLEX_3_CH_FLEX_"
            ("FLTR_i$1"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"OWB_COURSE_DIM"."GET_CONST_5_MD_FLEX_VALUE_SET_","EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_FLEX_3_MD_FLEX_"
            ("FLTR_i$1"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"OWB_COURSE_DIM"."GET_CONST_5_MD_FLEX_VALUE_SET_","EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_FLEX_3_MD_FLEX_"
            ("FLTR_i$1"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"OWB_COURSE_DIM"."GET_CONST_6_PL_FLEX_VALUE_SET_","EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_FLEX_3_PL_FLEX_"
            ("FLTR_i$1"));
            
            ',0,2000);
            
                
                "GET_FLEX_VALUE"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"OWB_COURSE_DIM"."GET_CONST_6_PL_FLEX_VALUE_SET_","EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_FLEX_3_PL_FLEX_"
            ("FLTR_i$1"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            IF NOT get_use_hc OR get_row_status THEN
  -- Expression statement
              IF NOT get_buffer_done(get_buffer_done_index) THEN
                error_stmt := SUBSTRB('
            
                
                "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_ITEM_2_ITEM_NUM"
            ("FLTR_i$1"),"GET_ITEM_3_LE_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_4_FE_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_5_CH_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_6_MD_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_7_PL_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_8_ACT_NUM_"
            ("FLTR_i$1"));
            
            ',0,2000);
            
                
                "GET_ITEM_SEGMENT_NUM"("GET_ORAC_2_INVENTOR"
            ("FLTR_i$1"),"EXPR_3_COUNTRY$1"
            ("FLTR_i$1"),"GET_ITEM_2_ITEM_NUM"
            ("FLTR_i$1"),"GET_ITEM_3_LE_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_4_FE_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_5_CH_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_6_MD_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_7_PL_NUM_O"
            ("FLTR_i$1"),"GET_ITEM_8_ACT_NUM_"
            ("FLTR_i$1"));
            
              END IF; -- get_buffer_done
              -- End expression statement
            END IF;
            
            
get_target_name := '"COURSE_DIM"';
            get_audit_detail_id := "COURSE_DIM_id";
            IF NOT "COURSE_DIM_St" AND NOT get_buffer_done(get_buffer_done_index) THEN
              BEGIN
                get_rows_processed := true; -- Set to indicate that some row data was processed (for debugger)
            		error_stmt := SUBSTRB('"COURSE_DIM_0_COURSE_ID$1"("COURSE_DIM_i") := 
            
            RTRIM("FLTR_2_EVXCOURSEID$1"("FLTR_i$1"));',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_0_COURSE_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_2_EVXCOURSEID$1"("FLTR_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_0_COURSE_ID$1"("COURSE_DIM_i") :=
            
            RTRIM("FLTR_2_EVXCOURSEID$1"("FLTR_i$1"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_0_COURSE_ID$1" :=
            
            RTRIM("FLTR_2_EVXCOURSEID$1"("FLTR_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_1_COURSE_NAME$1"("COURSE_DIM_i") := 
            
            "EXPR_2_COURSE_NAME$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_1_COURSE_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_2_COURSE_NAME$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_1_COURSE_NAME$1"("COURSE_DIM_i") :=
            
            "EXPR_2_COURSE_NAME$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_1_COURSE_NAME$1" :=
            
            "EXPR_2_COURSE_NAME$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_2_COURSE_CH$1"("COURSE_DIM_i") := 
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_2_COURSE_CH$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_CH_FLEX_"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_2_COURSE_CH$1"("COURSE_DIM_i") :=
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_2_COURSE_CH$1" :=
            
            "GET_FLEX_3_CH_FLEX_"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_3_COURSE_MOD$1"("COURSE_DIM_i") := 
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_3_COURSE_MOD$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_MD_FLEX_"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_3_COURSE_MOD$1"("COURSE_DIM_i") :=
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_3_COURSE_MOD$1" :=
            
            "GET_FLEX_3_MD_FLEX_"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_4_COURSE_PL$1"("COURSE_DIM_i") := 
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_4_COURSE_PL$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_FLEX_3_PL_FLEX_"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_4_COURSE_PL$1"("COURSE_DIM_i") :=
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_4_COURSE_PL$1" :=
            
            "GET_FLEX_3_PL_FLEX_"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_5_LIST_PRICE$1"("COURSE_DIM_i") := 
            
            "FLTR_23_AMOUNT$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_5_LIST_PRICE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_23_AMOUNT$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_5_LIST_PRICE$1"("COURSE_DIM_i") :=
            
            "FLTR_23_AMOUNT$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_5_LIST_PRICE$1" :=
            
            "FLTR_23_AMOUNT$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_6_ORACLE_ITEM_ID$1"("COURSE_DIM_i") := 
            
            "GET_ORAC_2_INVENTOR"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_6_ORACLE_ITEM_ID$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ORAC_2_INVENTOR"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_6_ORACLE_ITEM_ID$1"("COURSE_DIM_i") :=
            
            "GET_ORAC_2_INVENTOR"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_6_ORACLE_ITEM_" :=
            
            "GET_ORAC_2_INVENTOR"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_7_ORACLE_ITEM_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_7_ORACLE_ITEM_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_2_ITEM_NUM"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_7_ORACLE_ITEM_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_7_ORACLE_ITEM" :=
            
            "GET_ITEM_2_ITEM_NUM"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_8_CREATION_DATE$1"("COURSE_DIM_i") := 
            
            "FLTR_16_CREATEDATE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_8_CREATION_DATE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_16_CREATEDATE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_8_CREATION_DATE$1"("COURSE_DIM_i") :=
            
            "FLTR_16_CREATEDATE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_8_CREATION_DA" :=
            
            "FLTR_16_CREATEDATE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_9_LAST_UPDATE_DA"("COURSE_DIM_i") := 
            
            "FLTR_18_MODIFYDATE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_9_LAST_UPDATE_DA"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_18_MODIFYDATE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_9_LAST_UPDATE_DA"("COURSE_DIM_i") :=
            
            "FLTR_18_MODIFYDATE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_9_LAST_UPDATE_" :=
            
            "FLTR_18_MODIFYDATE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_14_GKDW_SOURCE$1"("COURSE_DIM_i") := 
            
            "OWB_COURSE_DIM"."GET_CONST_1_SOURCE";',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_14_GKDW_SOURCE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("OWB_COURSE_DIM"."GET_CONST_1_SOURCE",0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_14_GKDW_SOURCE$1"("COURSE_DIM_i") :=
            
            "OWB_COURSE_DIM"."GET_CONST_1_SOURCE";
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_14_GKDW_SOURCE$1" :=
            
            "OWB_COURSE_DIM"."GET_CONST_1_SOURCE";
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_16_COURSE_CODE$1"("COURSE_DIM_i") := 
            
            "FLTR_13_COURSECODE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_16_COURSE_CODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_13_COURSECODE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_16_COURSE_CODE$1"("COURSE_DIM_i") :=
            
            "FLTR_13_COURSECODE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_16_COURSE_CODE$1" :=
            
            "FLTR_13_COURSECODE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_17_COUNTRY$1"("COURSE_DIM_i") := 
            
            "EXPR_3_COUNTRY$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_17_COUNTRY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_3_COUNTRY$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_17_COUNTRY$1"("COURSE_DIM_i") :=
            
            "EXPR_3_COUNTRY$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_17_COUNTRY$1" :=
            
            "EXPR_3_COUNTRY$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_18_INACTIVE_FLAG$1"("COURSE_DIM_i") := 
            
            RTRIM("FLTR_7_ISINACTIVE$1"("FLTR_i$1"));',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_18_INACTIVE_FLAG$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("FLTR_7_ISINACTIVE$1"("FLTR_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_18_INACTIVE_FLAG$1"("COURSE_DIM_i") :=
            
            RTRIM("FLTR_7_ISINACTIVE$1"("FLTR_i$1"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_18_INACTIVE_FL" :=
            
            RTRIM("FLTR_7_ISINACTIVE$1"("FLTR_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_19_COURSE_NUM$1"("COURSE_DIM_i") := 
            
            "FLTR_8_COURSENUMBER$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_19_COURSE_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_8_COURSENUMBER$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_19_COURSE_NUM$1"("COURSE_DIM_i") :=
            
            "FLTR_8_COURSENUMBER$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_19_COURSE_NUM$1" :=
            
            "FLTR_8_COURSENUMBER$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_20_LE_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_20_LE_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_3_LE_NUM_O"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_20_LE_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_20_LE_NUM$1" :=
            
            "GET_ITEM_3_LE_NUM_O"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_21_FE_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_21_FE_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_4_FE_NUM_O"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_21_FE_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_21_FE_NUM$1" :=
            
            "GET_ITEM_4_FE_NUM_O"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_22_CH_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_22_CH_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_5_CH_NUM_O"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_22_CH_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_22_CH_NUM$1" :=
            
            "GET_ITEM_5_CH_NUM_O"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_23_MD_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_23_MD_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_6_MD_NUM_O"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_23_MD_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_23_MD_NUM$1" :=
            
            "GET_ITEM_6_MD_NUM_O"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_24_PL_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_24_PL_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_7_PL_NUM_O"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_24_PL_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_24_PL_NUM$1" :=
            
            "GET_ITEM_7_PL_NUM_O"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_25_ACT_NUM$1"("COURSE_DIM_i") := 
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_25_ACT_NUM$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("GET_ITEM_8_ACT_NUM_"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_25_ACT_NUM$1"("COURSE_DIM_i") :=
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_25_ACT_NUM$1" :=
            
            "GET_ITEM_8_ACT_NUM_"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_26_COURSE_GROUP$1"("COURSE_DIM_i") := 
            
            "FLTR_11_COURSEGROUP$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_26_COURSE_GROUP$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_11_COURSEGROUP$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_26_COURSE_GROUP$1"("COURSE_DIM_i") :=
            
            "FLTR_11_COURSEGROUP$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_26_COURSE_GRO" :=
            
            "FLTR_11_COURSEGROUP$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_27_VENDOR_CODE$1"("COURSE_DIM_i") := 
            
            "QG_COURSE_12_VENDORCODE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_27_VENDOR_CODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("QG_COURSE_12_VENDORCODE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_27_VENDOR_CODE$1"("COURSE_DIM_i") :=
            
            "QG_COURSE_12_VENDORCODE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_27_VENDOR_CODE$1" :=
            
            "QG_COURSE_12_VENDORCODE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_28_SHORT_NAME$1"("COURSE_DIM_i") := 
            
            "FLTR_4_SHORTNAME$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_28_SHORT_NAME$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_4_SHORTNAME$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_28_SHORT_NAME$1"("COURSE_DIM_i") :=
            
            "FLTR_4_SHORTNAME$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_28_SHORT_NAME$1" :=
            
            "FLTR_4_SHORTNAME$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_29_DURATION_DAYS$1"("COURSE_DIM_i") := 
            
            "EXPR_1_2_DURATION_IN_DAYS$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_29_DURATION_DAYS$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("EXPR_1_2_DURATION_IN_DAYS$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_29_DURATION_DAYS$1"("COURSE_DIM_i") :=
            
            "EXPR_1_2_DURATION_IN_DAYS$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_29_DURATION_DA" :=
            
            "EXPR_1_2_DURATION_IN_DAYS$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_30_COURSE_TYPE$1"("COURSE_DIM_i") := 
            
            "FLTR_10_COURSETYPE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_30_COURSE_TYPE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("FLTR_10_COURSETYPE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_30_COURSE_TYPE$1"("COURSE_DIM_i") :=
            
            "FLTR_10_COURSETYPE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_30_COURSE_TYPE$1" :=
            
            "FLTR_10_COURSETYPE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_31_CAPACITY$1"("COURSE_DIM_i") := 
            
            "QG_COURSE_11_CAPACITY$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_31_CAPACITY$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("QG_COURSE_11_CAPACITY$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_31_CAPACITY$1"("COURSE_DIM_i") :=
            
            "QG_COURSE_11_CAPACITY$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_31_CAPACITY$1" :=
            
            "QG_COURSE_11_CAPACITY$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_32_COURSE_DESC$1"("COURSE_DIM_i") := 
            
            "RMS_COURSE_35_COURSE_DESC$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_32_COURSE_DESC$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_35_COURSE_DESC$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_32_COURSE_DESC$1"("COURSE_DIM_i") :=
            
            "RMS_COURSE_35_COURSE_DESC$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_32_COURSE_DESC$1" :=
            
            "RMS_COURSE_35_COURSE_DESC$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_33_ITBT$1"("COURSE_DIM_i") := 
            
            RTRIM("RMS_COURSE_36_ITBT$1"("FLTR_i$1"));',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_33_ITBT$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("RMS_COURSE_36_ITBT$1"("FLTR_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_33_ITBT$1"("COURSE_DIM_i") :=
            
            RTRIM("RMS_COURSE_36_ITBT$1"("FLTR_i$1"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_33_ITBT$1" :=
            
            RTRIM("RMS_COURSE_36_ITBT$1"("FLTR_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_34_ROOT_CODE$1"("COURSE_DIM_i") := 
            
            "RMS_COURSE_37_ROOT_CODE$1"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_34_ROOT_CODE$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_37_ROOT_CODE$1"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_34_ROOT_CODE$1"("COURSE_DIM_i") :=
            
            "RMS_COURSE_37_ROOT_CODE$1"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_34_ROOT_CODE$1" :=
            
            "RMS_COURSE_37_ROOT_CODE$1"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_35_LINE_OF_BUSINE"("COURSE_DIM_i") := 
            
            "RMS_COURSE_38_LINE_OF_BUSINE"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_35_LINE_OF_BUSINE"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_38_LINE_OF_BUSINE"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_35_LINE_OF_BUSINE"("COURSE_DIM_i") :=
            
            "RMS_COURSE_38_LINE_OF_BUSINE"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_35_LINE_OF_BU" :=
            
            "RMS_COURSE_38_LINE_OF_BUSINE"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_D_36_MCMASTER$1"("COURSE_DIM_i") := 
            
            RTRIM("RMS_COUR_46_MCMASTER$1"("FLTR_i$1"));',0,2000);
            error_column := SUBSTRB('"COURSE_D_36_MCMASTER$1"',0,80);
            
            BEGIN
              error_value := SUBSTRB(RTRIM("RMS_COUR_46_MCMASTER$1"("FLTR_i$1")),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_D_36_MCMASTER$1"("COURSE_DIM_i") :=
            
            RTRIM("RMS_COUR_46_MCMASTER$1"("FLTR_i$1"));
            
            ELSIF get_row_status THEN
              "SV_COURSE_D_36_MCMASTER$1" :=
            
            RTRIM("RMS_COUR_46_MCMASTER$1"("FLTR_i$1"));
            
            ELSE
              NULL;
            END IF;
            
            		error_stmt := SUBSTRB('"COURSE_DIM_37_MFG_COURSE_CO"("COURSE_DIM_i") := 
            
            "RMS_COURSE_47_MFG_COURSE_CO"("FLTR_i$1");',0,2000);
            error_column := SUBSTRB('"COURSE_DIM_37_MFG_COURSE_CO"',0,80);
            
            BEGIN
              error_value := SUBSTRB("RMS_COURSE_47_MFG_COURSE_CO"("FLTR_i$1"),0,2000);
            EXCEPTION 
              WHEN OTHERS THEN
                error_value := '*';
            END;
            
            IF NOT get_use_hc THEN
              "COURSE_DIM_37_MFG_COURSE_CO"("COURSE_DIM_i") :=
            
            "RMS_COURSE_47_MFG_COURSE_CO"("FLTR_i$1");
            
            ELSIF get_row_status THEN
              "SV_COURSE_DIM_37_MFG_COURSE_" :=
            
            "RMS_COURSE_47_MFG_COURSE_CO"("FLTR_i$1");
            
            ELSE
              NULL;
            END IF;
            
            
            
                IF get_audit_level = AUDIT_ERROR_DETAILS OR get_audit_level = AUDIT_COMPLETE THEN
                  IF NOT get_use_hc THEN
                    "COURSE_DIM_srk"("COURSE_DIM_i") := get_rowkey + "FLTR_i$1" - 1;
                  ELSIF get_row_status THEN
                    "SV_COURSE_DIM_srk" := get_rowkey + "FLTR_i$1" - 1;
                  ELSE
                    NULL;
                  END IF;
                  END IF;
                  IF get_use_hc THEN
                  "COURSE_DIM_new" := TRUE;
                ELSE
                  "COURSE_DIM_i" := "COURSE_DIM_i" + 1;
                END IF;
              EXCEPTION
                WHEN OTHERS THEN
                    last_error_number  := SQLCODE;
  last_error_message := SQLERRM;
             
                  "FLTR_ER$1"('TRACE 99: ' || error_stmt, error_column, error_value, SQLCODE, SQLERRM, get_audit_detail_id, "FLTR_i$1");
                  
                  "COURSE_DIM_err" := "COURSE_DIM_err" + 1;
                  
                  IF get_errors + "COURSE_DIM_err" > get_max_errors THEN
                    get_abort:= TRUE;
                  END IF;
                  get_row_status := FALSE; 
              END;
            END IF;
            
            
            
            
             EXIT WHEN get_buffer_done(get_buffer_done_index);

            IF get_use_hc AND get_row_status AND ("COURSE_DIM_new") THEN
              dml_bsize := dml_bsize + 1;
            	IF "COURSE_DIM_new" 
            AND (NOT "COURSE_DIM_nul") THEN
              "COURSE_DIM_ir"(dml_bsize) := "COURSE_DIM_i";
            	"COURSE_DIM_0_COURSE_ID$1"("COURSE_DIM_i") := "SV_COURSE_DIM_0_COURSE_ID$1";
            	"COURSE_DIM_1_COURSE_NAME$1"("COURSE_DIM_i") := "SV_COURSE_DIM_1_COURSE_NAME$1";
            	"COURSE_DIM_2_COURSE_CH$1"("COURSE_DIM_i") := "SV_COURSE_DIM_2_COURSE_CH$1";
            	"COURSE_DIM_3_COURSE_MOD$1"("COURSE_DIM_i") := "SV_COURSE_DIM_3_COURSE_MOD$1";
            	"COURSE_DIM_4_COURSE_PL$1"("COURSE_DIM_i") := "SV_COURSE_DIM_4_COURSE_PL$1";
            	"COURSE_DIM_5_LIST_PRICE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_5_LIST_PRICE$1";
            	"COURSE_DIM_6_ORACLE_ITEM_ID$1"("COURSE_DIM_i") := "SV_COURSE_DIM_6_ORACLE_ITEM_";
            	"COURSE_DIM_7_ORACLE_ITEM_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_7_ORACLE_ITEM";
            	"COURSE_DIM_8_CREATION_DATE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_8_CREATION_DA";
            	"COURSE_DIM_9_LAST_UPDATE_DA"("COURSE_DIM_i") := "SV_COURSE_DIM_9_LAST_UPDATE_";
            	"COURSE_DIM_14_GKDW_SOURCE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_14_GKDW_SOURCE$1";
            	"COURSE_DIM_16_COURSE_CODE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_16_COURSE_CODE$1";
            	"COURSE_DIM_17_COUNTRY$1"("COURSE_DIM_i") := "SV_COURSE_DIM_17_COUNTRY$1";
            	"COURSE_DIM_18_INACTIVE_FLAG$1"("COURSE_DIM_i") := "SV_COURSE_DIM_18_INACTIVE_FL";
            	"COURSE_DIM_19_COURSE_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_19_COURSE_NUM$1";
            	"COURSE_DIM_20_LE_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_20_LE_NUM$1";
            	"COURSE_DIM_21_FE_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_21_FE_NUM$1";
            	"COURSE_DIM_22_CH_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_22_CH_NUM$1";
            	"COURSE_DIM_23_MD_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_23_MD_NUM$1";
            	"COURSE_DIM_24_PL_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_24_PL_NUM$1";
            	"COURSE_DIM_25_ACT_NUM$1"("COURSE_DIM_i") := "SV_COURSE_DIM_25_ACT_NUM$1";
            	"COURSE_DIM_26_COURSE_GROUP$1"("COURSE_DIM_i") := "SV_COURSE_DIM_26_COURSE_GRO";
            	"COURSE_DIM_27_VENDOR_CODE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_27_VENDOR_CODE$1";
            	"COURSE_DIM_28_SHORT_NAME$1"("COURSE_DIM_i") := "SV_COURSE_DIM_28_SHORT_NAME$1";
            	"COURSE_DIM_29_DURATION_DAYS$1"("COURSE_DIM_i") := "SV_COURSE_DIM_29_DURATION_DA";
            	"COURSE_DIM_30_COURSE_TYPE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_30_COURSE_TYPE$1";
            	"COURSE_DIM_31_CAPACITY$1"("COURSE_DIM_i") := "SV_COURSE_DIM_31_CAPACITY$1";
            	"COURSE_DIM_32_COURSE_DESC$1"("COURSE_DIM_i") := "SV_COURSE_DIM_32_COURSE_DESC$1";
            	"COURSE_DIM_33_ITBT$1"("COURSE_DIM_i") := "SV_COURSE_DIM_33_ITBT$1";
            	"COURSE_DIM_34_ROOT_CODE$1"("COURSE_DIM_i") := "SV_COURSE_DIM_34_ROOT_CODE$1";
            	"COURSE_DIM_35_LINE_OF_BUSINE"("COURSE_DIM_i") := "SV_COURSE_DIM_35_LINE_OF_BU";
            	"COURSE_D_36_MCMASTER$1"("COURSE_DIM_i") := "SV_COURSE_D_36_MCMASTER$1";
            	"COURSE_DIM_37_MFG_COURSE_CO"("COURSE_DIM_i") := "SV_COURSE_DIM_37_MFG_COURSE_";
              "COURSE_DIM_srk"("COURSE_DIM_i") := "SV_COURSE_DIM_srk";
              "COURSE_DIM_i" := "COURSE_DIM_i" + 1;
            ELSE
              "COURSE_DIM_ir"(dml_bsize) := 0;
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
            "FLTR_ER$1"('TRACE 97: ' || error_stmt, '*', NULL, SQLCODE, SQLERRM, NULL, "FLTR_i$1");
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
    IF NOT "COURSE_DIM_St"
    AND NOT (get_audit_level = AUDIT_NONE) THEN
      WB_RT_MAPAUDIT.auditd_end(
        p_rtd=>"COURSE_DIM_id",
        p_sel=>get_map_selected,  -- AuditDetailEnd1
        p_ins=>"COURSE_DIM_ins",
        p_upd=>"COURSE_DIM_upd",
        p_del=>"COURSE_DIM_del",
        p_err=>"COURSE_DIM_err",
        p_dis=>NULL
      );
    END IF;
  	get_inserted := get_inserted + "COURSE_DIM_ins";
    get_updated  := get_updated  + "COURSE_DIM_upd";
    get_deleted  := get_deleted  + "COURSE_DIM_del";
    get_errors   := get_errors   + "COURSE_DIM_err";

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
      p_source=>'"SLXDW"."EVXCOURSE","SLXDW"."EVXCOURSEFEE","SLXDW"."QG_COURSE","RMSDW"."RMS_COURSE"',
      p_source_uoid=>'A41FFB199F715678E040007F01006C7D,A41FFB199F6A5678E040007F01006C7D,A41FFB199F4B5678E040007F01006C7D,A41FFB199F4A5678E040007F01006C7D',
      p_target=>'"COURSE_DIM"',
      p_target_uoid=>'A41FFB199F6F5678E040007F01006C7D',      p_info=>NULL,
      
            p_type=>'PLSQLMap',
      
      p_date=>get_cycle_date
    );
  END IF;



BEGIN
  -- Expression statement
      error_stmt := SUBSTRB('
  
      
      GET_MAX_DATE("OWB_COURSE_DIM"."GET_CONST_0_TABLE_NAME","OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT","OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT");
  
  ',0,2000);
  
      
      GET_MAX_DATE("OWB_COURSE_DIM"."GET_CONST_0_TABLE_NAME","OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT","OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT");
  
    -- End expression statement
    --"OWB_COURSE_DIM"."PREMAPPING_1_CREATE_DATE_OUT" := '01-JAN-2000';
    --"OWB_COURSE_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" := '01-JAN-2000';
  
  
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
  "COURSE_DIM_St" := FALSE;
  IF get_trigger_success THEN

  --  Processing for different operating modes
  IF get_operating_mode = MODE_SET THEN
    RAISE_APPLICATION_ERROR(-20101, 'Set based mode not supported');
  END IF;
  IF get_operating_mode = MODE_ROW THEN
		"FLTR_p";
  END IF;
  IF get_operating_mode = MODE_SET_FAILOVER_ROW THEN
    IF get_use_hc THEN
      IF NOT get_batch_status AND get_use_hc THEN
        get_inserted := 0;
        get_updated  := 0;
        get_deleted  := 0;
        get_merged   := 0;
        get_logical_errors := 0;
"COURSE_DIM_St" := FALSE;

      END IF;
    END IF;

"FLTR_p";

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
"COURSE_DIM_St" := FALSE;

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
  AND    uo.object_name = 'OWB_COURSE_DIM'
  AND    uo.object_id = ao.object_id;

  wb_rt_mapaudit_util.premap('OWB_COURSE_DIM', x_schema, x_audit_id, x_object_id);

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



END "OWB_COURSE_DIM";
/


GRANT EXECUTE, DEBUG ON GKDW.OWB_COURSE_DIM TO DWHREAD;

