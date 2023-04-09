DROP VIEW GKDW.GK_2013_EVENT_METRO_V;

/* Formatted on 29/01/2021 11:21:45 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_2013_EVENT_METRO_V
(
   METRO,
   DIM_QUARTER,
   FILL_RATE_0,
   FILL_RATE_1,
   FILL_RATE_2,
   PROJ_FILL_RATE
)
AS
     SELECT   e.metro,
              e.dim_quarter,
              CASE
                 WHEN SUM (event_cnt_0) = 0 THEN 0
                 ELSE ROUND (SUM (enroll_cnt_0) / SUM (event_cnt_0))
              END
                 fill_rate_0,
              CASE
                 WHEN SUM (event_cnt_1) = 0 THEN 0
                 ELSE ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1))
              END
                 fill_rate_1,
              CASE
                 WHEN SUM (event_cnt_2) = 0 THEN 0
                 ELSE ROUND (SUM (enroll_cnt_2) / SUM (event_cnt_2))
              END
                 fill_rate_2,
              ROUND(CASE
                       WHEN SUM (enroll_cnt_2) = 0 AND SUM (enroll_cnt_1) = 0
                       THEN
                          CASE
                             WHEN SUM (event_cnt_0) = 0
                             THEN
                                0
                             ELSE
                                ROUND (SUM (enroll_cnt_0) / SUM (event_cnt_0))
                          END
                       WHEN SUM (enroll_cnt_2) = 0
                       THEN
                          (CASE
                              WHEN SUM (event_cnt_0) = 0
                              THEN
                                 0
                              ELSE
                                 ROUND (SUM (enroll_cnt_0) / SUM (event_cnt_0))
                           END
                           * .8)
                          + (CASE
                                WHEN SUM (event_cnt_1) = 0
                                THEN
                                   0
                                ELSE
                                   ROUND (
                                      SUM (enroll_cnt_1) / SUM (event_cnt_1)
                                   )
                             END
                             * .2)
                       ELSE
                          (CASE
                              WHEN SUM (event_cnt_0) = 0
                              THEN
                                 0
                              ELSE
                                 ROUND (SUM (enroll_cnt_0) / SUM (event_cnt_0))
                           END
                           * .7)
                          + (CASE
                                WHEN SUM (event_cnt_1) = 0
                                THEN
                                   0
                                ELSE
                                   ROUND (
                                      SUM (enroll_cnt_1) / SUM (event_cnt_1)
                                   )
                             END
                             * .2)
                          + (CASE
                                WHEN SUM (event_cnt_2) = 0
                                THEN
                                   0
                                ELSE
                                   ROUND (
                                      SUM (enroll_cnt_2) / SUM (event_cnt_2)
                                   )
                             END
                             * .1)
                    END)
                 proj_fill_rate
       FROM      gk_2013_event_plan_v e
              INNER JOIN
                 course_dim c
              ON e.course_code = c.course_code AND c.country = e.ops_country
   GROUP BY   e.metro, e.dim_quarter
   ORDER BY   e.metro, e.dim_quarter;


