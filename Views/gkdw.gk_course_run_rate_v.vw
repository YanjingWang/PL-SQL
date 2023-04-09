DROP VIEW GKDW.GK_COURSE_RUN_RATE_V;

/* Formatted on 29/01/2021 11:39:07 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_RUN_RATE_V
(
   OPS_COUNTRY,
   COURSE_CODE,
   COURSE_PL,
   COURSE_TYPE,
   SCHED_CNT,
   RUN_CNT,
   RUN_PCT
)
AS
     SELECT   ed.ops_country,
              cd.course_code,
              cd.course_pl,
              cd.course_type,
              COUNT (ed.event_id) sched_cnt,
              SUM (CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END)
                 run_cnt,
              SUM (CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END)
              / COUNT (ed.event_id)
                 run_pct
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   start_date BETWEEN TRUNC (SYSDATE) - 365 AND TRUNC (SYSDATE)
              AND (ed.status IN ('Verified', 'Open')
                   OR (ed.status = 'Cancelled'
                       AND ed.cancel_reason = 'Low Enrollment'))
   GROUP BY   ed.ops_country,
              cd.course_code,
              cd.course_pl,
              cd.course_type;


