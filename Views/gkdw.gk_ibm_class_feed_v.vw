DROP VIEW GKDW.GK_IBM_CLASS_FEED_V;

/* Formatted on 29/01/2021 11:35:05 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IBM_CLASS_FEED_V
(
   "ProviderMonthlyClassFeedv2",
   "6",
   VERSION,
   YEAR4DIGIT,
   MONTH2DIGIT,
   "CountryISO2Enrollment",
   "CourseCodeProvider",
   "DerivativeWork",
   COURSE_MOD,
   COURSE_CODE_MOD,
   "Modality",
   "DurationHours",
   DURATION_HOURS,
   "CourseCodeIBMPri",
   SHORT_NAME,
   "CourseCodeIBMSec",
   "StudentsCustomer",
   "StudentsIBM",
   "StudentsIBMPartner",
   "FunctionFlag",
   ENROLL_ID,
   PAYMENT_METHOD,
   EMAIL_ID
)
AS
   SELECT   DISTINCT
            'ProviderMonthlyClassFeedv2' "ProviderMonthlyClassFeedv2",
            '6' "6",
            1 Version,
            CASE SUBSTR (o.COURSE_CODE, -1, 1)
               WHEN 'W' THEN TO_CHAR (O.rev_DATE, 'yyyy')
               ELSE TO_CHAR (O.event_end_date, 'yyyy')
            END
               Year4Digit,
            CASE SUBSTR (o.COURSE_CODE, -1, 1)
               WHEN 'W' THEN TO_CHAR (o.rev_date, 'mm')
               ELSE TO_CHAR (O.event_end_date, 'mm')
            END
               Month2Digit,
            CASE
               WHEN TRIM (UPPER (o.cust_country)) IN
                          ('UNITED STATE',
                           'UNITED STATES',
                           'UNITES STATES',
                           'UNITED STATES OF AMERICA',
                           'UNITES STATES OF AMERICA',
                           'US',
                           'U.S.A.',
                           'U.S.A',
                           'USA',
                           'AMERICA')
               THEN
                  'US'
               WHEN    o.cust_country IS NULL
                    OR UPPER (O.CUST_COUNTRY) = 'VIRTUAL'
                    OR O.CUST_COUNTRY = '0'
                    OR O.CUST_COUNTRY = 'N/A'
               THEN
                  CASE
                     WHEN TRIM (UPPER (o.country)) IN
                                ('UNITED STATE',
                                 'UNITED STATES',
                                 'UNITES STATES',
                                 'UNITED STATES OF AMERICA',
                                 'UNITES STATES OF AMERICA',
                                 'US',
                                 'U.S.A.',
                                 'U.S.A',
                                 'USA',
                                 'AMERICA')
                     THEN
                        'US'
                     ELSE
                        o.country
                  END
               ELSE
                  o.cust_country
            END
               "CountryISO2Enrollment", --,  O.CUST_COUNTRY                                             ,
            O.COURSE_CODE "CourseCodeProvider",
            CASE
               WHEN CD.SHORT_NAME LIKE 'SL%' OR CD.COURSE_CODE LIKE '7196%'
               THEN
                  'Y'
               ELSE
                  'N'
            END
               "DerivativeWork",
            O.COURSE_MOD,
            SUBSTR (o.COURSE_CODE, -1, 1) Course_code_mod,
            CASE SUBSTR (o.COURSE_CODE, -1, 1)
               WHEN 'C' THEN 'CR'
               WHEN 'N' THEN 'CR'
               WHEN 'D' THEN 'CR'
               WHEN 'L' THEN 'ILO'
               WHEN 'V' THEN 'ILO'
               WHEN 'Z' THEN 'ILO'
               WHEN 'W' THEN 'DL'
               ELSE 'NA'
            END
               "Modality",
            (CD.DURATION_DAYS * 8) "DurationHours",
            qc.duration_hours,
            CD.MFG_COURSE_CODE "CourseCodeIBMPri",
            CASE
               WHEN CD.SHORT_NAME LIKE 'SL Design%' THEN 'U60748G'
               WHEN CD.SHORT_NAME LIKE 'SL Fund%' THEN 'U60741G'
               WHEN CD.SHORT_NAME LIKE 'SL - IaaS Roadshow%' THEN 'U61459G'
               ELSE CD.SHORT_NAME
            END,                                   -- IBMC.IBM_WW_COURSE_CODE,
            NULL "CourseCodeIBMSec",
            CASE
               WHEN (O.PAYMENT_METHOD NOT IN
                           ('Talent at IBM',
                            'talent at IBM',
                            'IBM Partner Rewards',
                            'IBM Storage Systems',
                            'IBM System i Voucher')
                     OR O.PAYMENT_METHOD IS NULL)
                    AND UPPER (NVL (C.EMAIL, 'x')) NOT LIKE '%IBM.COM'
               THEN
                  1
               ELSE
                  0
            END
               "StudentsCustomer",
            CASE
               WHEN UPPER (NVL (C.EMAIL, 'x')) LIKE '%IBM.COM' THEN 1
               ELSE 0
            END
               "StudentsIBM",
            CASE
               WHEN O.PAYMENT_METHOD IN
                          ('IBM Partner Rewards',
                           'IBM Storage Systems',
                           'IBM System i Voucher')
                    AND UPPER (NVL (C.EMAIL, 'x')) NOT LIKE '%IBM.COM'
               THEN
                  1
               ELSE
                  0
            END
               "StudentsIBMPartner",
            'A' "FunctionFlag",
            O.ENROLL_ID,
            O.PAYMENT_METHOD,
            C.EMAIL
     FROM               gk_all_orders_mv o
                     JOIN
                        event_dim ed
                     ON O.EVENT_ID = ED.EVENT_ID
                  JOIN
                     course_dim cd
                  ON ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
               JOIN
                  qg_course qc
               ON CD.COURSE_ID = qc.evxcourseid
            JOIN
               cust_dim c
            ON O.CUST_ID = C.CUST_ID
    WHERE       O.ENROLL_STATUS NOT IN ('Cancelled', 'Did Not Attend')
            AND o.course_pl = 'IBM'
            AND O.FEE_TYPE <> 'Ons - Base';


