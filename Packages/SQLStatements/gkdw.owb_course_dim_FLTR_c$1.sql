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
