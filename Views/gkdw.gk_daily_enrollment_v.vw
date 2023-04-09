DROP VIEW GKDW.GK_DAILY_ENROLLMENT_V;

/* Formatted on 29/01/2021 11:38:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_DAILY_ENROLLMENT_V
(
   EVXEVENROLLID,
   EVXEVENTID,
   CONTACTID,
   CREATEDATE,
   QUANTITY,
   ENROLL_AMT,
   FEETYPE,
   CURRENCYTYPE,
   OPPORTUNITYID,
   ENROLLSTATUS,
   FIRSTNAME,
   LASTNAME,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   COUNTY,
   POSTALCODE,
   COUNTRY,
   WORKPHONE,
   EMAIL,
   ATTENDEETYPE,
   ACCOUNT
)
AS
   SELECT   "evxevenrollid" evxevenrollid,
            "evxeventid" evxeventid,
            "contactid" contactid,
            "createdate" createdate,
            "quantity" quantity,
            "enroll_amt" enroll_amt,
            "feetype" feetype,
            "currencytype" currencytype,
            "opportunityid" opportunityid,
            "enrollstatus" enrollstatus,
            "firstname" firstname,
            "lastname" lastname,
            "address1" address1,
            "address2" address2,
            "city" city,
            "state" state,
            "county" county,
            "postalcode" postalcode,
            "country" country,
            "workphone" workphone,
            "email" email,
            "attendeetype" attendeetype,
            "account" account
     FROM   gk_daily_enrollment_v@SLX;


