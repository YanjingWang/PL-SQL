DROP VIEW GKDW.GK_GO_NOGO_CB_RPT;

/* Formatted on 29/01/2021 11:35:48 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GO_NOGO_CB_RPT
(
   START_WEEK,
   START_DATE,
   EVENT_ID,
   LOCATION_NAME,
   COURSE_CODE,
   SHORT_NAME,
   STATUS
)
AS
   SELECT   START_WEEK,
            START_DATE,
            EVENT_ID,
            LOCATION_NAME,
            COURSE_CODE,
            SHORT_NAME,
            Status
     FROM   (SELECT   START_WEEK,
                      START_DATE,
                      EVENT_ID,
                      --   STUDENTS,
                      LOCATION_NAME,
                      COURSE_CODE,
                      SHORT_NAME,
                      -- CONNECTED_EVENT,
                      -- REVENUE,
                      -- TOTAL_COST,
                      CASE
                         WHEN (GTR_FLAG = 'Y' OR Est_students_Needed <= 0)
                         THEN
                            'Good'
                         ELSE
                               'Need '
                            || Est_students_Needed
                            || ' more paying students'
                      END
                         Status
               FROM   (SELECT   START_WEEK,
                                START_DATE,
                                EVENT_ID,
                                STUDENTS,
                                LOCATION_NAME,
                                COURSE_CODE,
                                SHORT_NAME,
                                CONNECTED_EVENT,
                                REVENUE,
                                TOTAL_COST,
                                margin,
                                Duration,
                                GTR_FLAG,
                                Margin_needed,
                                Avg_RevperStudent,
                                Avg_MarginperStudent,
                                CASE
                                   WHEN Margin_needed = 0
                                   THEN
                                      0
                                   WHEN Avg_MarginperStudent = 0
                                   THEN
                                      0
                                   ELSE
                                      ROUND (
                                         Margin_needed / Avg_MarginperStudent
                                      )
                                END
                                   Est_students_Needed
                         FROM   (SELECT   DISTINCT
                                          T1.START_WEEK,
                                          T1.START_DATE,
                                          T1.EVENT_ID,
                                          T1.ENROLL_CNT AS STUDENTS,
                                          T3.LOCATION_NAME,
                                          T1.COURSE_CODE,
                                          T2.SHORT_NAME,
                                          T1.CONNECTED_EVENT,
                                          T1.REVENUE,
                                          T1.TOTAL_COST,
                                          T1.MARGIN * T1.REVENUE margin,
                                          T3.END_DATE - T3.START_DATE + 1
                                             AS Duration,
                                          T1.GTR_FLAG,
                                          (T3.END_DATE - T3.START_DATE + 1)
                                          * 1000
                                          - (T1.MARGIN * T1.REVENUE)
                                             Margin_needed,
                                          CASE
                                             WHEN t1.revenue = 0 THEN 0
                                             ELSE T1.REVENUE / T1.ENROLL_CNT
                                          END
                                             Avg_RevperStudent,
                                          (CASE
                                              WHEN t1.revenue = 0 THEN 0
                                              ELSE T1.REVENUE / T1.ENROLL_CNT
                                           END)
                                          * 0.8
                                             Avg_MarginperStudent
                                   FROM   GK_GO_NOGO_V T1,
                                          EVENT_DIM T3,
                                          COURSE_DIM T2,
                                          ORDER_FACT F
                                  WHERE       T1.EVENT_ID = T3.EVENT_ID
                                          AND T3.COURSE_ID = T2.COURSE_ID
                                          AND T3.OPS_COUNTRY = T2.COUNTRY
                                          AND F.EVENT_ID(+) = T3.EVENT_ID --   AND (T1.START_WEEK IN ('2019-18')) --AND T1.Course_mod in (:p_course_mod)
                                          --AND t1.course_pl in (:p_course_pl)
                                      --AND t1.ops_country in (:p_ops_country)
                                )))
    WHERE   status <> 'Good';


