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
  ( "ACCOUNT"."CREATEDATE" >= "OWB_ACCOUNT_DIM_NEW"."PREMAPPING_1_CREATE_DATE_OUT" Or "ACCOUNT"."MODIFYDATE" >= "OWB_ACCOUNT_DIM_NEW"."PREMAPPING_2_MODIFY_DATE_OUT" );
