DROP VIEW GKDW.GK_2013_EVENT_PLAN_PROJ;

/* Formatted on 29/01/2021 11:21:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_2013_EVENT_PLAN_PROJ
(
   DIM_YEAR,
   COUNTRY,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_PL,
   COURSE_TYPE,
   METRO,
   DIM_QTR,
   DIM_MONTH,
   EVENT_CNT,
   PROJ_EVENT_FILL,
   PROJ_COURSE_FILL,
   PROJ_COURSE_METRO_FILL,
   PROJ_FILL_RATE_2013
)
AS
     SELECT   p1.dim_year,
              p1.country,
              p1.course_code,
              p1.short_name,
              p1.course_pl,
              p1.course_type,
              p1.metro,
              p1.dim_qtr,
              p1.dim_month,
              COUNT (p1.course_code) event_cnt,
              p2.proj_fill_rate proj_event_fill,
              p6.proj_fill_rate proj_course_fill,
              p7.proj_fill_rate proj_course_metro_fill,
              CASE
                 WHEN (CASE
                          WHEN p2.proj_fill_rate IS NOT NULL THEN 1
                          ELSE 0
                       END
                       + CASE
                            WHEN p6.proj_fill_rate IS NOT NULL THEN 1
                            ELSE 0
                         END
                       + CASE
                            WHEN p7.proj_fill_rate IS NOT NULL THEN 1
                            ELSE 0
                         END) = 0
                 THEN
                    0
                 ELSE
                    ROUND( (  2 * NVL (p2.proj_fill_rate, 0)
                            + .25 * NVL (p6.proj_fill_rate, 0)
                            + .75 * NVL (p7.proj_fill_rate, 0))
                          / (CASE
                                WHEN p2.proj_fill_rate IS NOT NULL THEN 2
                                ELSE 0
                             END
                             + CASE
                                  WHEN p6.proj_fill_rate IS NOT NULL THEN .25
                                  ELSE 0
                               END
                             + CASE
                                  WHEN p7.proj_fill_rate IS NOT NULL THEN .75
                                  ELSE 0
                               END))
              END
                 proj_fill_rate_2013
       FROM            gk_2013_event_plan p1
                    LEFT OUTER JOIN
                       gk_2013_event_plan_v p2
                    ON     p1.course_code = p2.course_code
                       AND p1.metro = p2.metro
                       AND p1.dim_qtr = p2.dim_quarter
                 LEFT OUTER JOIN
                    gk_2013_event_course_v p6
                 ON p1.course_code = p6.course_code
              LEFT OUTER JOIN
                 gk_2013_event_course_metro_v p7
              ON p1.course_code = p7.course_code AND p1.metro = p7.metro
   -- where p1.course_pl = 'CISCO'
   GROUP BY   p1.dim_year,
              p1.country,
              p1.course_code,
              p1.short_name,
              p1.course_pl,
              p1.course_type,
              p1.metro,
              p1.dim_qtr,
              p1.dim_month,
              p2.proj_fill_rate,
              p6.proj_fill_rate,
              p7.proj_fill_rate
   ORDER BY   p1.course_code,
              p1.metro,
              p1.dim_qtr,
              p1.dim_month;


