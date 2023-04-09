DROP VIEW GKDW.GK_STUDENT_COUNTS_REPORT_V;

/* Formatted on 29/01/2021 11:25:49 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_STUDENT_COUNTS_REPORT_V
(
   LE_NUM,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   TECHNOLOGY,
   COURSE_CODE,
   COURSE_NAME,
   EVENT_ID,
   ENROLL_ID,
   ENROLL_STATUS,
   REV_YEAR,
   REV_MONTH,
   CUSTOMER_ACCOUNT_NAME,
   LOCATION_NAME,
   FACILITY_REGION_METRO
)
AS
   SELECT   DISTINCT C.LE_NUM,
                     C.CH_NUM,
                     C.MD_NUM,
                     C.PL_NUM,
                     C.SUBTECH_TYPE1 AS TECHNOLOGY,
                     C.COURSE_CODE,
                     C.COURSE_NAME,
                     E.EVENT_ID,
                     O.ENROLL_ID,
                     O.ENROLL_STATUS,
                     EXTRACT (YEAR FROM O.REV_DATE) AS REV_YEAR,
                     EXTRACT (MONTH FROM O.REV_DATE) AS REV_MONTH,
                     O.ACCT_NAME AS CUSTOMER_ACCOUNT_NAME,
                     E.LOCATION_NAME,
                     E.FACILITY_REGION_METRO
     FROM         ORDER_FACT O
               INNER JOIN
                  EVENT_DIM E
               ON O.EVENT_ID = E.EVENT_ID
            INNER JOIN
               COURSE_DIM C
            ON E.COURSE_ID = C.COURSE_ID AND E.OPS_COUNTRY = C.COUNTRY
    WHERE   O.REV_DATE BETWEEN '16-JAN-01' AND '18-MAY-25';


