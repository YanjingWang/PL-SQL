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
