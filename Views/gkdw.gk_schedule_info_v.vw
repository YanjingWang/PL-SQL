DROP VIEW GKDW.GK_SCHEDULE_INFO_V;

/* Formatted on 29/01/2021 11:27:09 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHEDULE_INFO_V
(
   SCHEDULE_ID,
   COURSE_PL,
   COURSE_TYPE,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_NAME,
   DIM_YEAR,
   DIM_MONTH_NUM,
   DIM_WEEK,
   EVENT_ID,
   START_DATE,
   END_DATE,
   MEETING_DAYS,
   ADJ_MEETING_DAYS,
   ACCT_NAME,
   LOCATION_NAME,
   FACILITY_REGION_METRO,
   EVENT_COUNTRY,
   INSTRUCTOR_ID,
   FIRSTNAME,
   LASTNAME,
   ACCOUNT,
   CITY,
   STATE,
   INSTRUCTOR_COUNTRY,
   CONNECTED_V_TO_C,
   ZIPCODE,
   START_TIME,
   END_TIME
)
AS
     SELECT   s."id" schedule_id,
              T1.COURSE_PL,
              T1.COURSE_TYPE,
              T1.COURSE_CODE,
              T1.SHORT_NAME,
              T1.COURSE_NAME,
              T2.DIM_YEAR,
              T2.DIM_MONTH_NUM,
              T2.DIM_WEEK,
              T3.EVENT_ID,
              T3.START_DATE,
              T3.END_DATE,
              T3.MEETING_DAYS,
              T3.ADJ_MEETING_DAYS,
              T4.ACCT_NAME,
              T3.LOCATION_NAME,
              T3.FACILITY_REGION_METRO,
              T3.COUNTRY Event_country,
              i."id" instructor_id,
              T5.FIRSTNAME,
              T5.LASTNAME,
              T5.ACCOUNT,
              T3.CITY,
              T3.STATE,
              T6.COUNTRY instructor_country,
              T3.CONNECTED_V_TO_C,
              T3.ZIPCODE,
              T3.START_TIME,
              T3.END_TIME
       FROM   GKDW.COURSE_DIM T1,
              GKDW.TIME_DIM T2,
                                GKDW.EVENT_DIM T3
                             LEFT OUTER JOIN
                                GKDW.OPPORTUNITY_DIM T7
                             ON T3.OPPORTUNITY_ID = T7.OPPORTUNITY_ID
                          LEFT OUTER JOIN
                             GKDW.ACCOUNT_DIM T4
                          ON T7.ACCOUNT_ID = T4.ACCT_ID
                       LEFT OUTER JOIN
                          GKDW.INSTRUCTOR_EVENT_V T5
                       ON T3.EVENT_ID = T5.EVXEVENTID
                    LEFT OUTER JOIN
                       GKDW.INSTRUCTOR_DIM T6
                    ON T5.CONTACTID = T6.CUST_ID
                 INNER JOIN
                    "schedule"@rms_prod s
                 ON s."slx_id" = t3.event_id
              LEFT OUTER JOIN
                 "instructor_func"@RMS_PROD I
              ON i."slx_contact_id" = t5.contactid
      WHERE       T3.COURSE_ID = T1.COURSE_ID
              AND T3.OPS_COUNTRY = T1.COUNTRY
              AND T3.START_DATE = T2.DIM_DATE
              AND 1 = 1
              AND T3.END_DATE >= TRUNC (SYSDATE)
              --         BETWEEN TO_DATE ('2017-04-20 00:00:00',
              --                                              'YYYY-MM-DD HH24:MI:SS')
              --                                 AND TO_DATE ('2017-04-20 00:00:00',
              --                                              'YYYY-MM-DD HH24:MI:SS')
              AND T3.STATUS <> 'Cancelled'
              AND T3.EVENT_TYPE <> 'Reseller'
   ORDER BY   EVENT_ID ASC, START_DATE ASC;


