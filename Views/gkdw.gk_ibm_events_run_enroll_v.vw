DROP VIEW GKDW.GK_IBM_EVENTS_RUN_ENROLL_V;

/* Formatted on 29/01/2021 11:34:47 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IBM_EVENTS_RUN_ENROLL_V
(
   IBM_WW_COURSE_CODE,
   GK_COURSE_CODE,
   COURSE_TYPE,
   COURSE_MOD,
   COURSE_CH,
   REGION,
   COUNTRY,
   EVENT_STATUS,
   EVENT_WEEK,
   EVENT_MONTH_NUM,
   EVENT_MONTH,
   EVENT_YEAR,
   DIM_PERIOD_NAME,
   EVENT_ID,
   ENROLL_ID
)
AS
   SELECT   CD.SHORT_NAME IBM_WW_Course_Code,
            SUBSTR (CD.COURSE_CODE, 1, 4) GK_Course_code,
            CD.COURSE_TYPE,
            CD.COURSE_MOD,
            CD.COURSE_CH,
            CASE
               WHEN CD.COUNTRY IN ('USA', 'CANADA') THEN 'US/CA'
               ELSE cd.country
            END
               region,
            CD.COUNTRY,
            ED.STATUS Event_status,
            TD.DIM_WEEK event_Week,
            TD.DIM_MONTH_NUM event_month_num,
            TD.DIM_MONTH event_month,
            TD.DIM_YEAR event_year,
            TD.DIM_PERIOD_NAME,
            ED.EVENT_ID,
            O.ENROLL_ID
     --    COUNT (distinct ED.EVENT_ID) Sessions_Run
     -- count(distinct O.ENROLL_ID) Student_cnt
     FROM            event_dim ed
                  JOIN
                     course_dim cd
                  ON ED.COUNTRY = CD.COUNTRY AND ED.COURSE_ID = CD.COURSE_ID
               LEFT JOIN
                  gk_all_orders_mv o
               ON ED.EVENT_ID = O.EVENT_ID
                  AND (O.ENROLL_STATUS NOT IN ('Cancelled', 'Did Not Attend')
                       AND O.FEE_TYPE <> 'Ons - Base')
            JOIN
               time_dim td
            ON TD.DIM_DATE = ED.START_DATE
    WHERE       CD.COURSE_PL = 'IBM'
            AND ED.STATUS NOT IN ('Cancelled')
            AND SUBSTR (CD.COURSE_CODE, 1, 4) NOT LIKE '3639%'
   /*GROUP BY TD.DIM_YEAR,
         TD.DIM_PERIOD_NAME,
         TD.DIM_MONTH_NUM,
         TD.DIM_MONTH,
         TD.DIM_WEEK,
         CD.SHORT_NAME,
         SUBSTR (CD.COURSE_CODE, 1, 4),
         CD.COURSE_TYPE,
         CD.COURSE_MOD,
         CD.COURSE_CH,
         CD.COUNTRY,
         ED.STATUS,
         ED.EVENT_ID
--            O.ENROLL_ID*/
   UNION
   /***************EMEA Events *************************/
   SELECT   IBM_WW_COURSE_CODE,
            GK_COURSE_CODE,
            COURSE_BRAND,
            MODALITY,
            NULL,
            'EMEA',
            COUNTRY,
            NULL,
            TD.DIM_WEEK,
            TD.DIM_MONTH_NUM event_month_mm,
            TD.DIM_MONTH event_month_mon,
            TD.DIM_YEAR event_year,
            TD.DIM_PERIOD_NAME,
            NULL,
            NULL
     FROM      GKDW.GK_IBM_EVENTS_RUN_EMEA_LOAD er
            JOIN
               time_dim td
            ON TRUNC (ER.EVENT_START_DATE) = TD.DIM_DATE
   ORDER BY   1,
              2,
              3,
              4,
              5,
              6,
              7;


