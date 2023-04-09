DROP VIEW GKDW.GK_SCHED_FREQ_PLAN_V;

/* Formatted on 29/01/2021 11:26:46 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_FREQ_PLAN_V
(
   OPS_COUNTRY,
   COURSE_CODE,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   EVENT_CNT,
   TOTAL_COST,
   TOTAL_REVENUE,
   ENROLL_CNT,
   AVG_COST,
   AVG_FILL_RATE,
   AVG_FARE,
   MIN_FILL,
   RUN_PCT,
   TYPE_RUN_PCT
)
AS
     SELECT   g.ops_country,
              g.course_code,
              course_ch,
              course_mod,
              course_pl,
              course_type,
              COUNT (event_id) event_cnt,
              SUM (total_cost) total_cost,
              SUM (revenue) total_revenue,
              SUM (enroll_cnt) enroll_cnt,
              ROUND (SUM (total_cost) / COUNT (event_id)) avg_cost,
              ROUND (SUM (enroll_cnt) / COUNT (event_id)) avg_fill_rate,
              ROUND (SUM (revenue) / SUM (enroll_cnt)) avg_fare,
              CASE
                 WHEN ROUND( ( (SUM (total_cost) / COUNT (event_id)) * 2)
                            / (SUM(revenue) / SUM(enroll_cnt))) < 6
                 THEN
                    6
                 ELSE
                    ROUND( ( (SUM (total_cost) / COUNT (event_id)) * 2)
                          / (SUM (revenue) / SUM (enroll_cnt)))
              END
                 min_fill,
              ROUND (cc.run_pct, 2) run_pct,
              ROUND (q.type_run_pct, 2) type_run_pct
       FROM         gk_go_nogo_all_v g
                 LEFT OUTER JOIN
                    gk_course_run_rate_v cc
                 ON g.ops_country = cc.ops_country
                    AND g.course_code = cc.course_code
              LEFT OUTER JOIN
                 (  SELECT   course_pl,
                             course_type,
                             SUM (sched_cnt) type_sched,
                             SUM (run_cnt) type_run,
                             SUM (run_cnt) / SUM (sched_cnt) type_run_pct
                      FROM   gk_course_run_rate_v
                  GROUP BY   course_pl, course_type) q
              ON g.course_pl = q.course_pl AND g.course_type = q.course_type
      WHERE   g.start_date BETWEEN TRUNC (SYSDATE) - 365 AND TRUNC (SYSDATE)
              AND SUBSTR (g.course_code, 5, 1) IN ('C')
              AND g.enroll_cnt > 0
              AND g.course_code IN
                       (SELECT   ed.course_code
                          FROM   event_dim ed
                         WHERE   g.course_code = ed.course_code
                                 AND g.ops_country = ed.country
                                 AND TO_CHAR (ed.start_date, 'YYYY') =
                                       TO_CHAR (SYSDATE, 'YYYY')
                                 AND ed.status != 'Cancelled')
   GROUP BY   g.ops_country,
              g.course_code,
              course_ch,
              course_mod,
              course_pl,
              course_type,
              cc.run_pct,
              q.type_run_pct
     HAVING   ROUND (SUM (revenue) / SUM (enroll_cnt)) > 0
   ORDER BY   g.ops_country, course_pl, g.course_code;


