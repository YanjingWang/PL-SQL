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
