SELECT
  "LOOKUP_INPUT_SUBQUERY"."CONTACTID" "CONTACTID",
  "LOOKUP_INPUT_SUBQUERY"."FIRSTNAME" "FIRSTNAME",
  "LOOKUP_INPUT_SUBQUERY"."LASTNAME" "LASTNAME",
  "LOOKUP_INPUT_SUBQUERY"."MIDDLENAME" "MIDDLENAME",
  "LOOKUP_INPUT_SUBQUERY"."COUNTY" "COUNTY",
  NVL("ACCOUNT_DIM"."ACCT_NAME", NULL) "ACCT_NAME",
  "LOOKUP_INPUT_SUBQUERY"."ACCOUNTID" "ACCOUNTID",
  "LOOKUP_INPUT_SUBQUERY"."ADDRESS1" "ADDRESS1",
  "LOOKUP_INPUT_SUBQUERY"."ADDRESS2" "ADDRESS2",
  "LOOKUP_INPUT_SUBQUERY"."ADDRESS3" "ADDRESS3",
  "LOOKUP_INPUT_SUBQUERY"."CITY" "CITY",
  "LOOKUP_INPUT_SUBQUERY"."STATE" "STATE",
  "LOOKUP_INPUT_SUBQUERY"."COUNTRY" "COUNTRY",
  "LOOKUP_INPUT_SUBQUERY"."POSTALCODE" "POSTALCODE",
  "LOOKUP_INPUT_SUBQUERY"."CREATEDATE" "CREATEDATE",
  "LOOKUP_INPUT_SUBQUERY"."MODIFYDATE" "MODIFYDATE",
  "LOOKUP_INPUT_SUBQUERY"."TITLE" "TITLE",
  "LOOKUP_INPUT_SUBQUERY"."WORKPHONE" "WORKPHONE",
  "LOOKUP_INPUT_SUBQUERY"."EMAIL" "EMAIL",
  "LOOKUP_INPUT_SUBQUERY"."DONOTEMAIL" "DONOTEMAIL",
  "LOOKUP_INPUT_SUBQUERY"."DONOTPHONE" "DONOTPHONE",
  "LOOKUP_INPUT_SUBQUERY"."DONOTMAIL" "DONOTMAIL",
  NVL("QG_CONTACT"."ID_NUMBER", NULL) "ID_NUMBER",
  "LOOKUP_INPUT_SUBQUERY"."DEPARTMENT" "DEPARTMENT",
  NVL("QG_CONTACT"."EXTENSION", NULL) "EXTENSION",
  NVL("QG_CONTACT"."ATT_FLAG", NULL) "ATT_FLAG",
  NVL("QG_CONTACT"."MAX_STARTDATE", NULL) "MAX_STARTDATE",
  NVL("QG_CONTACT"."TITLE_CODE", NULL) "TITLE_CODE"
FROM
   ( SELECT
  "CONTACT"."CONTACTID" "CONTACTID",
  "CONTACT"."CONTACTTYPE" "CONTACTTYPE",
  "CONTACT"."ACCOUNTID" "ACCOUNTID",
  "CONTACT"."ACCOUNT" "ACCOUNT",
  "CONTACT"."DEPARTMENT" "DEPARTMENT",
  "CONTACT"."ISPRIMARY" "ISPRIMARY",
  "CONTACT"."LASTNAME" "LASTNAME",
  "CONTACT"."FIRSTNAME" "FIRSTNAME",
  "CONTACT"."MIDDLENAME" "MIDDLENAME",
  "CONTACT"."WORKPHONE" "WORKPHONE",
  "CONTACT"."HOMEPHONE" "HOMEPHONE",
  "CONTACT"."FAX" "FAX",
  "CONTACT"."MOBILE" "MOBILE",
  "CONTACT"."EMAIL" "EMAIL",
  "CONTACT"."DESCRIPTION" "DESCRIPTION",
  "CONTACT"."TITLE" "TITLE",
  "CONTACT"."SECCODEID" "SECCODEID",
  "CONTACT"."ACCOUNTMANAGERID" "ACCOUNTMANAGERID",
  "CONTACT"."STATUS" "STATUS",
  "CONTACT"."CREATEDATE" "CREATEDATE",
  "CONTACT"."CREATEUSER" "CREATEUSER",
  "CONTACT"."MODIFYDATE" "MODIFYDATE",
  "CONTACT"."MODIFYUSER" "MODIFYUSER",
  "CONTACT"."TITLE_CODE" "TITLE_CODE",
  "CONTACT"."LEGACYID" "LEGACYID",
  "CONTACT"."DELEGATE" "DELEGATE",
  "CONTACT"."DECISION_MAKER" "DECISION_MAKER",
  "CONTACT"."INFLUENCER" "INFLUENCER",
  "CONTACT"."BOOKING_CONTACT" "BOOKING_CONTACT",
  "CONTACT"."EMAIL_NOT_AVAILABLE" "EMAIL_NOT_AVAILABLE",
  "CONTACT"."EMAIL_NOT_AVAILABLE_REASON" "EMAIL_NOT_AVAILABLE_REASON",
  "CONTACT"."CAMPAIGNID" "CAMPAIGNID",
  "CONTACT"."DIRECTNUMBER" "DIRECTNUMBER",
  "CONTACT"."QG_TERRITORYID" "QG_TERRITORYID",
  "OWB_CUST_DIM"."PREMAPPING_1_CREATE_DATE_OUT" "CREATE_DATE_OUT",
  "OWB_CUST_DIM"."PREMAPPING_2_MODIFY_DATE_OUT" "MODIFY_DATE_OUT",
  "CONTACT"."ADDRESSID" "ADDRESSID",
  "CONTACT"."DONOTEMAIL" "DONOTEMAIL",
  "CONTACT"."DONOTMAIL" "DONOTMAIL",
  "CONTACT"."DONOTPHONE" "DONOTPHONE",
  "ACCOUNT"."CREATEDATE" "CREATEDATE_ACCOUNT",
  "ACCOUNT"."MODIFYDATE" "MODIFYDATE_ACCOUNT",
  "ADDRESS"."CREATEDATE" "CREATEDATE_ADDRESS",
  "ADDRESS"."MODIFYDATE" "MODIFYDATE_ADDRESS",
  "ADDRESS"."ADDRESS1" "ADDRESS1",
  "ADDRESS"."ADDRESS2" "ADDRESS2",
  "ADDRESS"."CITY" "CITY",
  "ADDRESS"."STATE" "STATE",
  "ADDRESS"."POSTALCODE" "POSTALCODE",
  "ADDRESS"."COUNTY" "COUNTY",
  "ADDRESS"."COUNTRY" "COUNTRY",
  "ADDRESS"."ADDRESS3" "ADDRESS3"
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
  "SLXDW"."ACCOUNT" "ACCOUNT" ) "ACCOUNT" ON ( ( "CONTACT"."ACCOUNTID" = "ACCOUNT"."ACCOUNTID" ) ) ) "LOOKUP_INPUT_SUBQUERY"   
 LEFT OUTER JOIN   "ACCOUNT_DIM"  "ACCOUNT_DIM" ON ( ( "ACCOUNT_DIM"."ACCT_ID" = "LOOKUP_INPUT_SUBQUERY"."ACCOUNTID" ) )
 LEFT OUTER JOIN   "SLXDW"."QG_CONTACT"  "QG_CONTACT" ON ( ( "QG_CONTACT"."CONTACTID" = "LOOKUP_INPUT_SUBQUERY"."CONTACTID" ) )
  WHERE 
  ( ( "LOOKUP_INPUT_SUBQUERY"."CREATEDATE" >= "LOOKUP_INPUT_SUBQUERY"."CREATE_DATE_OUT" or "LOOKUP_INPUT_SUBQUERY"."MODIFYDATE" >= "LOOKUP_INPUT_SUBQUERY"."MODIFY_DATE_OUT" ) OR ( "LOOKUP_INPUT_SUBQUERY"."CREATEDATE_ACCOUNT" >= "LOOKUP_INPUT_SUBQUERY"."CREATE_DATE_OUT" or "LOOKUP_INPUT_SUBQUERY"."MODIFYDATE_ACCOUNT" >= "LOOKUP_INPUT_SUBQUERY"."MODIFY_DATE_OUT" ) OR ( "LOOKUP_INPUT_SUBQUERY"."CREATEDATE_ADDRESS" >= "LOOKUP_INPUT_SUBQUERY"."CREATE_DATE_OUT" or "LOOKUP_INPUT_SUBQUERY"."MODIFYDATE_ADDRESS" >= "LOOKUP_INPUT_SUBQUERY"."MODIFY_DATE_OUT" ) );
