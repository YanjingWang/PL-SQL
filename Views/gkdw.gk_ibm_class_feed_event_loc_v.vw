DROP VIEW GKDW.GK_IBM_CLASS_FEED_EVENT_LOC_V;

/* Formatted on 29/01/2021 11:35:09 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IBM_CLASS_FEED_EVENT_LOC_V
(
   "ProviderMonthlyClassFeed",
   "6",
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
   PAYMENT_METHOD
)
AS
   SELECT   DISTINCT
            'ProviderMonthlyClassFeed' "ProviderMonthlyClassFeed",
            '6' "6",
            CASE SUBSTR (o.COURSE_CODE, -1, 1)
               WHEN 'W' THEN TO_CHAR (O.rev_DATE, 'yyyy')
               ELSE TO_CHAR (O.event_start_date, 'yyyy')
            END
               Year4Digit,
            CASE SUBSTR (o.COURSE_CODE, -1, 1)
               WHEN 'W' THEN TO_CHAR (o.rev_date, 'mm')
               ELSE TO_CHAR (O.event_start_date, 'mm')
            END
               Month2Digit,
            o.country "CountryISO2Enrollment", --,  O.CUST_COUNTRY                                             ,
            O.COURSE_CODE "CourseCodeProvider",
            'N' "DerivativeWork",
            O.COURSE_MOD,
            SUBSTR (o.COURSE_CODE, -1, 1) Course_code_mod,
            CASE SUBSTR (o.COURSE_CODE, -1, 1)
               WHEN 'C' THEN 'CR'
               WHEN 'N' THEN 'CR'
               WHEN 'L' THEN 'ILO'
               WHEN 'V' THEN 'ILO'
               WHEN 'W' THEN 'DL'
               ELSE 'NA'
            END
               "Modality",
            (CD.DURATION_DAYS * 8) "DurationHours",
            qc.duration_hours,
            CD.MFG_COURSE_CODE "CourseCodeIBMPri",
            CD.SHORT_NAME,                         -- IBMC.IBM_WW_COURSE_CODE,
            NULL "CourseCodeIBMSec",
            CASE
               WHEN (O.PAYMENT_METHOD NOT IN
                           ('Talent at IBM',
                            'talent at IBM',
                            'IBM Partner Rewards',
                            'IBM Storage Systems',
                            'IBM System i Voucher')
                     OR O.PAYMENT_METHOD IS NULL)
               THEN
                  1
               ELSE
                  0
            END
               "StudentsCustomer",
            CASE
               WHEN UPPER (O.PAYMENT_METHOD) = 'TALENT AT IBM' THEN 1
               ELSE 0
            END
               "StudentsIBM",
            CASE
               WHEN O.PAYMENT_METHOD IN
                          ('IBM Partner Rewards',
                           'IBM Storage Systems',
                           'IBM System i Voucher')
               THEN
                  1
               ELSE
                  0
            END
               "StudentsIBMPartner",
            'A' "FunctionFlag",
            O.ENROLL_ID,
            O.PAYMENT_METHOD
     FROM            gk_all_orders_mv o
                  JOIN
                     event_dim ed
                  ON O.EVENT_ID = ED.EVENT_ID
               JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            JOIN
               qg_course qc
            ON CD.COURSE_ID = qc.evxcourseid
    WHERE       O.ENROLL_STATUS NOT IN ('Cancelled', 'Did Not Attend')
            AND o.course_pl = 'IBM'
            AND O.FEE_TYPE <> 'Ons - Base';


