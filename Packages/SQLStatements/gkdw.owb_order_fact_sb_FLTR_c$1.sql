SELECT
  "LOOKUP_INPUT_SUBQUERY$1"."EVXEVENROLLID$1" "EVXEVENROLLID$1",
  "LOOKUP_INPUT_SUBQUERY$1"."EVXEVENTID$1" "EVXEVENTID$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ATTENDEECONTACTID$1" "ATTENDEECONTACTID$1",
  TRUNC("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_HX$1")/* EXPR.OUTGRP1.ENROLL_DATE */ "ENROLL_DATE",
  "LOOKUP_INPUT_SUBQUERY$1"."EVXEVTICKETID$1" "EVXEVTICKETID$1",
  case
when 
("EVENT_DIM"."EVENT_CHANNEL"  = 'INDIVIDUAL/PUBLIC' or
("EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE" = 'Open Enrollment'))
then 
        TRUNC("LOOKUP_INPUT_SUBQUERY$1"."BILLINGDATE$1")
when 
( "EVENT_DIM"."EVENT_CHANNEL"  = 'ENTERPRISE/PRIVATE' or 
( "EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE"  = 'Onsite'))
then
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1")
else
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1" )
end/* EXPR.OUTGRP1.BOOK_DATE */ "BOOK_DATE",
  case  when (case
when 
("EVENT_DIM"."EVENT_CHANNEL"  = 'INDIVIDUAL/PUBLIC' or
("EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE" = 'Open Enrollment'))
then 
        TRUNC("LOOKUP_INPUT_SUBQUERY$1"."BILLINGDATE$1")
when 
( "EVENT_DIM"."EVENT_CHANNEL"  = 'ENTERPRISE/PRIVATE' or 
( "EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE"  = 'Onsite'))
then
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1")
else
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1" )
end/* EXPR.OUTGRP1.BOOK_DATE */) is null then null when  "EVENT_DIM"."START_DATE" <  (case
when 
("EVENT_DIM"."EVENT_CHANNEL"  = 'INDIVIDUAL/PUBLIC' or
("EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE" = 'Open Enrollment'))
then 
        TRUNC("LOOKUP_INPUT_SUBQUERY$1"."BILLINGDATE$1")
when 
( "EVENT_DIM"."EVENT_CHANNEL"  = 'ENTERPRISE/PRIVATE' or 
( "EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE"  = 'Onsite'))
then
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1")
else
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1" )
end/* EXPR.OUTGRP1.BOOK_DATE */)  then  (case
when 
("EVENT_DIM"."EVENT_CHANNEL"  = 'INDIVIDUAL/PUBLIC' or
("EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE" = 'Open Enrollment'))
then 
        TRUNC("LOOKUP_INPUT_SUBQUERY$1"."BILLINGDATE$1")
when 
( "EVENT_DIM"."EVENT_CHANNEL"  = 'ENTERPRISE/PRIVATE' or 
( "EVENT_DIM"."EVENT_CHANNEL" is null 
and  "EVENT_DIM"."EVENT_TYPE"  = 'Onsite'))
then
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1")
else
        trunc("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1" )
end/* EXPR.OUTGRP1.BOOK_DATE */)  else  "EVENT_DIM"."START_DATE"  end/* EXPR_1.OUTGRP1.REV_DATE */ "REV_DATE",
  "LOOKUP_INPUT_SUBQUERY$1"."ENROLLSOURCE$1" "ENROLLSOURCE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ENROLLQTY$1" "ENROLLQTY$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ACTUALAMOUNT$1" "ACTUALAMOUNT$1",
  "LOOKUP_INPUT_SUBQUERY$1"."CURRENCYTYPE$1" "CURRENCYTYPE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."SOLDBYUSER$1" "SOLDBYUSER$1",
  "LOOKUP_INPUT_SUBQUERY$1"."OPPORTUNITYID$1" "OPPORTUNITYID$1",
  "GET_ORA_TRX_NUM"("LOOKUP_INPUT_SUBQUERY$1"."EVXEV_TXFEEID$2") "EVXEV_TXFEEID$1",
  case upper(trim("CUST_DIM"."COUNTRY" )) when 'USA'  then  SUBSTR( "CUST_DIM"."ZIPCODE",1, 5)  else  "CUST_DIM"."ZIPCODE"  end/* EXPR_2.OUTGRP1.ZIP_CODE */ "ZIP_CODE",
  "EVENT_DIM"."COUNTRY" "COUNTRY",
  "MARKET_DIM"."TERRITORY" "TERRITORY",
  "MARKET_DIM"."REGION" "REGION",
  "MARKET_DIM"."SALES_REP" "SALES_REP",
  "MARKET_DIM"."REGION_MGR" "REGION_MGR",
  "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1"/* EXPR.OUTGRP1.CREATE_DATE */ "CREATE_DATE",
  "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_TXFEE$1" "MODIFYDATE_TXFEE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ENROLLSTATUS$1" "ENROLLSTATUS$1",
  "LOOKUP_INPUT_SUBQUERY$1"."EVXEV_TXFEEID$2" "EVXEV_TXFEEID$2",
  "LOOKUP_INPUT_SUBQUERY$1"."BILLINGDATE$1" "BILLINGDATE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ENROLLSTATUSDESC$1" "ENROLLSTATUSDESC$1",
  "LOOKUP_INPUT_SUBQUERY$1"."FEETYPE$1" "FEETYPE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ENROLLSTATUSDATE$1" "ENROLLSTATUSDATE$1",
  "PPCARD_DIM"."SALES_ORDER_ID" "SALES_ORDER_ID",
  "LOOKUP_INPUT_SUBQUERY$1"."SOURCE$1" "SOURCE$1",
  "EVXBILLING"."BALANCEDUE" "BALANCEDUE",
  case when 
(   "EVXBILLPAYMENT"."METHOD"  = 'Prepay Card'
        OR  "PPCARD_DIM"."SALES_ORDER_ID"  IS NOT NULL
        OR  "EVXBILLPAYMENT"."EVXPPCARDID"  IS NOT NULL
       ) 
 AND  (TRUNC("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_HX$1")/* EXPR.OUTGRP1.ENROLL_DATE */)  >= '01-MAY-2007'
 then
  "GET_LIST_PRICE"( "LOOKUP_INPUT_SUBQUERY$1"."EVXEVENTID$1",  
                        "LOOKUP_INPUT_SUBQUERY$1"."FEETYPE$1",
                        (TRUNC("LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_HX$1")/* EXPR.OUTGRP1.ENROLL_DATE */) )
else
  "LOOKUP_INPUT_SUBQUERY$1"."ACTUALRATE$1" 
 end/* EXPR_3.OUTGRP1.LIST_PRICE_OUT */ "LIST_PRICE_OUT",
  "LOOKUP_INPUT_SUBQUERY$1"."PONUMBER$1" "PONUMBER$1",
  "EVXBILLPAYMENT"."EVXPPCARDID" "EVXPPCARDID",
  "EVXBILLPAYMENT"."METHOD" "METHOD",
  "LOOKUP_INPUT_SUBQUERY$1"."CHANNEL$1" "CHANNEL$1",
  "LOOKUP_INPUT_SUBQUERY$1"."CREATEUSER_TXFEE$1" "CREATEUSER_TXFEE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."MODIFYUSER_TXFEE$1" "MODIFYUSER_TXFEE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."REVIEWTYPE$1" "REVIEWTYPE$1",
  "LOOKUP_INPUT_SUBQUERY$1"."ATTENDEETYPE$1" "ATTENDEETYPE$1",
  "EVXBILLPAYMENT"."CHECKNUMBER" "CHECKNUMBER",
  "LOOKUP_INPUT_SUBQUERY$1"."COMMENTS$1" "COMMENTS$1",
  "CUST_DIM"."OB_NATIONAL_TERR_NUM" "OB_NATIONAL_TERR_NUM",
  "CUST_DIM"."OB_NATIONAL_REP_ID" "OB_NATIONAL_REP_ID",
  "CUST_DIM"."OB_NATIONAL_REP_NAME" "OB_NATIONAL_REP_NAME",
  "CUST_DIM"."OB_TERR_NUM" "OB_TERR_NUM",
  "CUST_DIM"."OB_REP_ID" "OB_REP_ID",
  "CUST_DIM"."OB_REP_NAME" "OB_REP_NAME",
  "CUST_DIM"."OSR_TERR_NUM" "OSR_TERR_NUM",
  "CUST_DIM"."OSR_ID" "OSR_ID",
  "CUST_DIM"."OSR_REP_NAME" "OSR_REP_NAME",
  "CUST_DIM"."ENT_NATIONAL_TERR_NUM" "ENT_NATIONAL_TERR_NUM",
  "CUST_DIM"."ENT_NATIONAL_REP_ID" "ENT_NATIONAL_REP_ID",
  "CUST_DIM"."ENT_NATIONAL_REP_NAME" "ENT_NATIONAL_REP_NAME",
  "CUST_DIM"."ENT_INSIDE_TERR_NUM" "ENT_INSIDE_TERR_NUM",
  "CUST_DIM"."ENT_INSIDE_REP_ID" "ENT_INSIDE_REP_ID",
  "CUST_DIM"."ENT_INSIDE_REP_NAME" "ENT_INSIDE_REP_NAME",
  "CUST_DIM"."ENT_FEDERAL_TERR_NUM" "ENT_FEDERAL_TERR_NUM",
  "CUST_DIM"."ENT_FEDERAL_REP_ID" "ENT_FEDERAL_REP_ID",
  "CUST_DIM"."ENT_FEDERAL_REP_NAME" "ENT_FEDERAL_REP_NAME",
  "CUST_DIM"."BTSR_TERR_NUM" "BTSR_TERR_NUM",
  "CUST_DIM"."BTSR_REP_ID" "BTSR_REP_ID",
  "CUST_DIM"."BTSR_REP_NAME" "BTSR_REP_NAME",
  "CUST_DIM"."BTA_TERR_NUM" "BTA_TERR_NUM",
  "CUST_DIM"."BTA_REP_ID" "BTA_REP_ID",
  "CUST_DIM"."BTA_REP_NAME" "BTA_REP_NAME"
FROM
   ( SELECT
  "OWB_ORDER_FACT_SB"."PREMAPPING_1_CREATE_DATE_OUT" "CREATE_DATE_OUT$1",
  "OWB_ORDER_FACT_SB"."PREMAPPING_2_MODIFY_DATE_OUT" "MODIFY_DATE_OUT$1",
  "EVXEV_TXFEE"."EVXEV_TXFEEID" "EVXEV_TXFEEID$2",
  "EVXEV_TXFEE"."CREATEDATE" "CREATEDATE_TXFEE$1",
  "EVXEV_TXFEE"."MODIFYDATE" "MODIFYDATE_TXFEE$1",
  "EVXEV_TXFEE"."ACTUALAMOUNT" "ACTUALAMOUNT$1",
  "EVXEV_TXFEE"."ACTUALQUANTITY" "ACTUALQUANTITY$1",
  "EVXEV_TXFEE"."EVXEVENTID" "EVXEVENTID$1",
  "EVXEV_TXFEE"."ATTENDEECONTACTID" "ATTENDEECONTACTID$1",
  "EVXENROLLHX"."CREATEDATE" "CREATEDATE_HX$1",
  "EVXENROLLHX"."ENROLLQTY" "ENROLLQTY$1",
  "EVXENROLLHX"."ENROLLSTATUS" "ENROLLSTATUS$1",
  "EVXENROLLHX"."EVXEVENROLLID" "EVXEVENROLLID$1",
  "EVXEV_TXFEE"."EVXEVTICKETID" "EVXEVTICKETID$1",
  "EVXENROLLHX"."ENROLLSTATUSDESC" "ENROLLSTATUSDESC$1",
  "EVXENROLLHX"."ENROLLSOURCE" "ENROLLSOURCE$1",
  "EVXEV_TXFEE"."BILLINGDATE" "BILLINGDATE$1",
  "EVXEV_TXFEE"."CURRENCYTYPE" "CURRENCYTYPE$1",
  "EVXEV_TXFEE"."EVXBILLINGID" "EVXBILLINGID$1",
  "EVXEVTICKET"."SOLDBYUSER" "SOLDBYUSER$1",
  "EVXEV_TXFEE"."FEETYPE" "FEETYPE$1",
  "EVXENROLLHX"."ENROLLSTATUSDATE" "ENROLLSTATUSDATE$1",
  "EVXENROLLHX"."MODIFYDATE" "MODIFYDATE_HX$1",
  "EVXEV_TXFEE"."ACTUALRATE" "ACTUALRATE$1",
  "QG_EVENROLL"."SOURCE" "SOURCE$1",
  "QG_EVENROLL"."CREATEDATE" "CREATEDATE_QG$1",
  "QG_EVENROLL"."MODIFYDATE" "MODIFYDATE_QG$1",
  "QG_EVENROLL"."CHANNEL" "CHANNEL$1",
  "EVXEV_TXFEE"."CREATEUSER" "CREATEUSER_TXFEE$1",
  "EVXEV_TXFEE"."MODIFYUSER" "MODIFYUSER_TXFEE$1",
  "EVXEVTICKET"."OPPORTUNITYID" "OPPORTUNITYID$1",
  "EVXEVTICKET"."PONUMBER" "PONUMBER$1",
  "EVXEVTICKET"."REVIEWTYPE" "REVIEWTYPE$1",
  "EVXEVTICKET"."CREATEDATE" "CREATEDATE_TKT$1",
  "EVXEVTICKET"."MODIFYDATE" "MODIFYDATE_TKT$1",
  "EVXEVTICKET"."ATTENDEETYPE" "ATTENDEETYPE$1",
  "EVXEVTICKET"."COMMENTS" "COMMENTS$1"
FROM
    "SLXDW"."EVXENROLLHX"  "EVXENROLLHX"   
 JOIN   "SLXDW"."EVXEV_TXFEE"  "EVXEV_TXFEE" ON ( ( "EVXENROLLHX"."EVXEVENROLLID" = "EVXEV_TXFEE"."EVXEVENROLLID" ) )
 LEFT OUTER JOIN  ( SELECT
  "QG_EVENROLL"."EVXEVENROLLID" "EVXEVENROLLID",
  "QG_EVENROLL"."CREATEDATE" "CREATEDATE",
  "QG_EVENROLL"."MODIFYDATE" "MODIFYDATE",
  "QG_EVENROLL"."SOURCE" "SOURCE",
  "QG_EVENROLL"."CHANNEL" "CHANNEL"
FROM
  "SLXDW"."QG_EVENROLL" "QG_EVENROLL" ) "QG_EVENROLL" ON ( ( "EVXENROLLHX"."EVXEVENROLLID" = "QG_EVENROLL"."EVXEVENROLLID" ) )
 JOIN   "SLXDW"."EVXEVTICKET"  "EVXEVTICKET" ON ( ( "EVXEV_TXFEE"."EVXEVTICKETID" = "EVXEVTICKET"."EVXEVTICKETID" ) ) ) "LOOKUP_INPUT_SUBQUERY$1"   
 LEFT OUTER JOIN   "EVENT_DIM"  "EVENT_DIM" ON ( ( "EVENT_DIM"."EVENT_ID" = "LOOKUP_INPUT_SUBQUERY$1"."EVXEVENTID$1" ) )
 LEFT OUTER JOIN   "CUST_DIM"  "CUST_DIM" ON ( ( "CUST_DIM"."CUST_ID" = "LOOKUP_INPUT_SUBQUERY$1"."ATTENDEECONTACTID$1" ) )
 LEFT OUTER JOIN   "MARKET_DIM"  "MARKET_DIM" ON ( ( "MARKET_DIM"."ZIPCODE" = (case upper(trim("CUST_DIM"."COUNTRY" )) when 'USA'  then  SUBSTR( "CUST_DIM"."ZIPCODE",1, 5)  else  "CUST_DIM"."ZIPCODE"  end/* EXPR_2.OUTGRP1.ZIP_CODE */) ) )
 LEFT OUTER JOIN   "SLXDW"."EVXBILLPAYMENT"  "EVXBILLPAYMENT" ON ( ( "EVXBILLPAYMENT"."EVXBILLINGID" = "LOOKUP_INPUT_SUBQUERY$1"."EVXBILLINGID$1" ) )
 LEFT OUTER JOIN   "PPCARD_DIM"  "PPCARD_DIM" ON ( ( "PPCARD_DIM"."PPCARD_ID" = "EVXBILLPAYMENT"."EVXPPCARDID" ) )
 LEFT OUTER JOIN   "SLXDW"."EVXBILLING"  "EVXBILLING" ON ( ( ( "EVXBILLING"."EVXBILLINGID" = "LOOKUP_INPUT_SUBQUERY$1"."EVXBILLINGID$1" ) ) )
  WHERE 
   "LOOKUP_INPUT_SUBQUERY$1"."EVXEVENROLLID$1"  in ('QGKID0B8YHZ1',
'Q6UJ90B7M55F',
'Q6UJ90B8AWLL',
'Q6UJ90B8CEEX',
'Q6UJ90B8CZ0H',
'Q6UJ90B8EN54',
'Q6UJ90B8JK9T',
'Q6UJ90B8LR71',
'Q6UJ90B8V5EC',
'Q6UJ90B8XX8B',
'Q6UJ90B8NP53',
'Q6UJ90B8NP6V',
'Q6UJ90B8NHCR',
'Q6UJ90B8N0FP',
'Q6UJ90B8NO0U',
'Q6UJ90B8QXBE',
'Q6UJ90B8QXM2',
'Q6UJ90B8QXNX',
'Q6UJ90B8UK7G',
'Q6UJ90B8U27W',
'Q6UJ90B8TOHA',
'Q6UJ90B8VO94',
'Q6UJ90B8W1S3',
'Q6UJ90B8W94K',
'Q6UJ90B8VXHF',
'Q6UJ90B8WVTL',
'QGKID0B8YCG1',
'Q6UJ90B8WKVQ',
'Q6UJ90B8WNAB',
'QGKID0B8YS9E',
'Q6UJ90B8X01P',
'Q6UJ90B8WOB4',
'Q6UJ90B8YJ58',
'Q6UJ90B8XOCS',
'Q6UJ90B8ZKX5',
'Q6UJ90B8XOHS',
'QGKID0B8W4XG',
'Q6UJ90B8XOIC',
'Q6UJ90B8XLIB',
'Q6UJ90B8XIRM',
'Q6UJ90B8XITC',
'Q6UJ90B8Y43W',
'Q6UJ90B8YDZ5',
'Q6UJ90B8YAYN',
'Q6UJ90B8YS8H',
'Q6UJ90B8ZDNM',
'Q6UJ90B8Y8QP',
'QGKID0B8Z376',
'Q6UJ90B8YTWO',
'Q6UJ90B8ZY6Z',
'Q6UJ90B901B8',
'Q6UJ90B901BO',
'Q6UJ90B903ZR',
'Q6UJ90B9073E',
'Q6UJ90B8ZVZN',
'Q6UJ90B907BC',
'Q6UJ90B907BC',
'Q6UJ90B8ZH4D',
'Q6UJ90B8ZTBV',
'Q6UJ90B908F5',
'Q6UJ90B9038W',
'Q6UJ90B903CH',
'Q6UJ90B906T7',
'QGKID0B8NYKW',
'QGKID0B8XUJ8',
'QGKID0B8YEOJ',
'QGKID0B8W6PV',
'QGKID0B8Z9E9',
'QGKID0B8ZXZE',
'QGKID0B8ZZXW',
'QGKID0B8XJPW',
'QGKID0B8VQ4N',
'QGKID0B9024O',
'QGKID0B8WPGT',
'QGKID0B8YBIB',
'QGKID0B908ZY',
'QGKID0B90924',
'QGKID0B90911')
 and ( ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TXFEE$1" >= "LOOKUP_INPUT_SUBQUERY$1"."CREATE_DATE_OUT$1" or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_TXFEE$1" >= "LOOKUP_INPUT_SUBQUERY$1"."MODIFY_DATE_OUT$1" ) OR ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_HX$1" >= "LOOKUP_INPUT_SUBQUERY$1"."CREATE_DATE_OUT$1" or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_HX$1" >= "LOOKUP_INPUT_SUBQUERY$1"."MODIFY_DATE_OUT$1" ) OR ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_QG$1" >= "LOOKUP_INPUT_SUBQUERY$1"."CREATE_DATE_OUT$1" or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_QG$1" >= "LOOKUP_INPUT_SUBQUERY$1"."MODIFY_DATE_OUT$1" ) OR ( "LOOKUP_INPUT_SUBQUERY$1"."CREATEDATE_TKT$1" >= "LOOKUP_INPUT_SUBQUERY$1"."CREATE_DATE_OUT$1" or "LOOKUP_INPUT_SUBQUERY$1"."MODIFYDATE_TKT$1" >= "LOOKUP_INPUT_SUBQUERY$1"."MODIFY_DATE_OUT$1" ) )
  AND NOT EXISTS (SELECT 1 FROM "GK_MASTER_ACCOUNT_EXCLUDE" "GK_MASTER_ACCOUNT_EXCLUDE" WHERE (("GK_MASTER_ACCOUNT_EXCLUDE"."ACCT_ID" = "CUST_DIM"."ACCT_ID" )));
