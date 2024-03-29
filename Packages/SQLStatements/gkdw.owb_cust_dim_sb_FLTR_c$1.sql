SELECT
  "LOOKUP_INPUT_SUBQUERY$1"."CONTACTID$1" "CONTACTID$1",
  UPPER(TRIM("LOOKUP_INPUT_SUBQUERY$1"."FIRSTNAME$1"))  || ' ' ||    UPPER(TRIM("LOOKUP_INPUT_SUBQUERY$1"."MIDDLENAME$1"))  ||  ' '  ||    UPPER(TRIM("LOOKUP_INPUT_SUBQUERY$1"."LASTNAME$1"))/* EXPR.OUTGRP1.NAME */ "NAME",
  NVL("ACCOUNT_DIM"."ACCT_NAME", NULL) "ACCT_NAME",
  "LOOKUP_INPUT_SUBQUERY$1"."ACCOUNTID$1" "ACCOUNTID$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ADDRESS1$1" "ADDRESS1$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ADDRESS2$1" "ADDRESS2$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ADDRESS3$1" "ADDRESS3$1",
  "LOOKUP_INPUT_SUBQUERY$1"."CITY$1" "CITY$1",
  case upper(trim("LOOKUP_INPUT_SUBQUERY$1"."COUNTRY$1" ))
when 'CANADA' 
then null 
when 'CAN' 
then null 
else  uppeR(trim("LOOKUP_INPUT_SUBQUERY$1"."STATE$1"))
end/* EXPR_1.OUTGRP1.STATE */ "STATE",
  "LOOKUP_INPUT_SUBQUERY$1"."POSTALCODE$1" "POSTALCODE$1",
  case upper(trim("LOOKUP_INPUT_SUBQUERY$1"."COUNTRY$1" ))
when 'CANADA'
then  upper(trim("LOOKUP_INPUT_SUBQUERY$1"."STATE$1"))
when 'CAN'
then  upper(trim("LOOKUP_INPUT_SUBQUERY$1"."STATE$1"))
else null
end/* EXPR_1.OUTGRP1.PROVINCE */ "PROVINCE",
  upper(trim( "LOOKUP_INPUT_SUBQUERY$1"."COUNTRY$1" ))/* EXPR_1.OUTGRP1.COUNTRY */ "COUNTRY",
  UPPER(TRIM( "LOOKUP_INPUT_SUBQUERY$1"."COUNTY$1" ))/* EXPR.OUTGRP1.COUNTY */ "COUNTY",
  "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE$1" "CREATEDATE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE$1" "MODIFYDATE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."TITLE$1" "TITLE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."WORKPHONE$1" "WORKPHONE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."EMAIL$1" "EMAIL$1",
  UPPER(TRIM("LOOKUP_INPUT_SUBQUERY$1"."LASTNAME$1"))/* EXPR.OUTGRP1.LAST_NAME */ "LAST_NAME",
  UPPER(TRIM("LOOKUP_INPUT_SUBQUERY$1"."FIRSTNAME$1"))/* EXPR.OUTGRP1.FIRST_NAME */ "FIRST_NAME",
  "LOOKUP_INPUT_SUBQUERY$1"."DONOTEMAIL$1" "DONOTEMAIL$1",
  "LOOKUP_INPUT_SUBQUERY$1"."DONOTPHONE$1" "DONOTPHONE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."DONOTMAIL$1" "DONOTMAIL$1",
  NVL("QG_CONTACT"."ID_NUMBER", NULL) "ID_NUMBER",
  "LOOKUP_INPUT_SUBQUERY$1"."DEPARTMENT$1" "DEPARTMENT$1",
  NVL("QG_CONTACT"."EXTENSION", NULL) "EXTENSION",
  NVL("QG_CONTACT"."ATT_FLAG", NULL) "ATT_FLAG",
  NVL("QG_CONTACT"."MAX_STARTDATE", NULL) "MAX_STARTDATE",
  NVL("QG_CONTACT"."TITLE_CODE", NULL) "TITLE_CODE"
FROM
   ( SELECT
  "CONTACT"."CONTACTID" "CONTACTID$1",
  "CONTACT"."CONTACTTYPE" "CONTACTTYPE$1",
  "CONTACT"."ACCOUNTID" "ACCOUNTID$1",
  "CONTACT"."ACCOUNT" "ACCOUNT$1",
  "CONTACT"."DEPARTMENT" "DEPARTMENT$1",
  "CONTACT"."ISPRIMARY" "ISPRIMARY$1",
  "CONTACT"."LASTNAME" "LASTNAME$1",
  "CONTACT"."FIRSTNAME" "FIRSTNAME$1",
  "CONTACT"."MIDDLENAME" "MIDDLENAME$1",
  "CONTACT"."WORKPHONE" "WORKPHONE$1",
  "CONTACT"."HOMEPHONE" "HOMEPHONE$1",
  "CONTACT"."FAX" "FAX$1",
  "CONTACT"."MOBILE" "MOBILE$1",
  "CONTACT"."EMAIL" "EMAIL$1",
  "CONTACT"."DESCRIPTION" "DESCRIPTION$1",
  "CONTACT"."TITLE" "TITLE$1",
  "CONTACT"."SECCODEID" "SECCODEID$1",
  "CONTACT"."ACCOUNTMANAGERID" "ACCOUNTMANAGERID$1",
  "CONTACT"."STATUS" "STATUS$1",
  "CONTACT"."CREATEDATE" "CREATEDATE$1",
  "CONTACT"."CREATEUSER" "CREATEUSER$1",
  "CONTACT"."MODIFYDATE" "MODIFYDATE$1",
  "CONTACT"."MODIFYUSER" "MODIFYUSER$1",
  "CONTACT"."TITLE_CODE" "TITLE_CODE$1",
  "CONTACT"."LEGACYID" "LEGACYID$1",
  "CONTACT"."DELEGATE" "DELEGATE$1",
  "CONTACT"."DECISION_MAKER" "DECISION_MAKER$1",
  "CONTACT"."INFLUENCER" "INFLUENCER$1",
  "CONTACT"."BOOKING_CONTACT" "BOOKING_CONTACT$1",
  "CONTACT"."EMAIL_NOT_AVAILABLE" "EMAIL_NOT_AVAILABLE$1",
  "CONTACT"."EMAIL_NOT_AVAILABLE_REASON" "EMAIL_NOT_AVAILABLE_REASON$1",
  "CONTACT"."CAMPAIGNID" "CAMPAIGNID$1",
  "CONTACT"."DIRECTNUMBER" "DIRECTNUMBER$1",
  "CONTACT"."QG_TERRITORYID" "QG_TERRITORYID$1",
  "OWB_CUST_DIM_SB"."PREMAPPING_1_CREATE_DATE_OUT" "CREATE_DATE_OUT$1",
  "OWB_CUST_DIM_SB"."PREMAPPING_2_MODIFY_DATE_OUT" "MODIFY_DATE_OUT$1",
  "CONTACT"."ADDRESSID" "ADDRESSID$1",
  "CONTACT"."DONOTEMAIL" "DONOTEMAIL$1",
  "CONTACT"."DONOTMAIL" "DONOTMAIL$1",
  "CONTACT"."DONOTPHONE" "DONOTPHONE$1",
  "ACCOUNT"."CREATEDATE" "CREATEDATE_ACCOUNT$1",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE_ACCOUNT$1",
  "ADDRESS"."CREATEDATE" "CREATEDATE_ADDRESS$1",
  "ADDRESS"."MODIFYDATE" "MODIFYDATE_ADDRESS$1",
  "ADDRESS"."ADDRESS1" "ADDRESS1$1",
  "ADDRESS"."ADDRESS2" "ADDRESS2$1",
  "ADDRESS"."CITY" "CITY$1",
  "ADDRESS"."STATE" "STATE$1",
  "ADDRESS"."POSTALCODE" "POSTALCODE$1",
  "ADDRESS"."COUNTY" "COUNTY$1",
  "ADDRESS"."COUNTRY" "COUNTRY$1",
  "ADDRESS"."ADDRESS3" "ADDRESS3$1"
FROM
    "SLXDW"."CONTACT"  "CONTACT"   
 LEFT OUTER JOIN  ( SELECT
  "ADDRESS"."ADDRESSID" "ADDRESSID",
  "ADDRESS"."CREATEDATE" "CREATEDATE",
  "ADDRESS"."MODIFYDATE" "MODIFYDATE",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."CITY" "CITY",
  "ADDRESS"."STATE" "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  "ADDRESS"."COUNTY" "COUNTY",
  "ADDRESS"."COUNTRY" "COUNTRY",
  "ADDRESS"."ADDRESS3" "ADDRESS3"
FROM
  "SLXDW"."ADDRESS" "ADDRESS" ) "ADDRESS" ON ( ( "CONTACT"."ADDRESSID" = "ADDRESS"."ADDRESSID" ) )
 LEFT OUTER JOIN  ( SELECT
  "ACCOUNT"."ACCOUNTID" "ACCOUNTID",
  "ACCOUNT"."ACCOUNT" "ACCOUNT",
  "ACCOUNT"."CREATEDATE" "CREATEDATE",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE"
FROM
  "SLXDW"."ACCOUNT" "ACCOUNT" ) "ACCOUNT" ON ( ( "CONTACT"."ACCOUNTID" = "ACCOUNT"."ACCOUNTID" ) ) ) "LOOKUP_INPUT_SUBQUERY$1"   
 LEFT OUTER JOIN   "ACCOUNT_DIM"  "ACCOUNT_DIM" ON ( ( "ACCOUNT_DIM"."ACCT_ID" = "LOOKUP_INPUT_SUBQUERY$1"."ACCOUNTID$1" ) )
 LEFT OUTER JOIN   "SLXDW"."QG_CONTACT"  "QG_CONTACT" ON ( ( "QG_CONTACT"."CONTACTID" = "LOOKUP_INPUT_SUBQUERY$1"."CONTACTID$1" ) )
  WHERE 
  ( ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE$1" >= '7-Jul-2020' or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE$1" >= '7-Jul-2020') 
  OR ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_ACCOUNT$1" >= '7-Jul-2020' or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_ACCOUNT$1" >= '7-Jul-2020' )
  OR ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_ADDRESS$1" >= '7-Jul-2020' or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_ADDRESS$1" >= '7-Jul-2020') );
