DROP VIEW GKDW.GK_SCHED_EVENT_PLAN_V;

/* Formatted on 29/01/2021 11:26:50 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_EVENT_PLAN_V
(
   OPS_COUNTRY,
   COURSE_CODE,
   SHORT_NAME,
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
   EVENT_RATIO,
   EVENT_CNT_PLAN,
   RUN_PCT_FACTOR,
   SCHED_CNT_PLAN
)
AS
     SELECT   p.ops_country,
              p.course_code,
              short_name,
              p.course_ch,
              p.course_mod,
              p.course_pl,
              p.course_type,
              event_cnt,
              total_cost,
              total_revenue,
              enroll_cnt,
              avg_cost,
              avg_fill_rate,
              avg_fare,
              min_fill,
              CASE
                 WHEN avg_fill_rate / min_fill > 1.20 THEN 1.20
                 ELSE ROUND (avg_fill_rate / min_fill, 2)
              END
                 event_ratio,
              ROUND(event_cnt
                    * CASE
                         WHEN avg_fill_rate / min_fill > 1.20 THEN 1.20
                         ELSE ROUND (avg_fill_rate / min_fill, 2)
                      END)
                 event_cnt_plan,
              ROUND ( (run_pct + NVL (type_run_pct, run_pct)) / 2, 2)
                 run_pct_factor,
              CEIL( (event_cnt
                     * CASE
                          WHEN avg_fill_rate / min_fill > 1.20 THEN 1.20
                          ELSE ROUND (avg_fill_rate / min_fill, 2)
                       END)
                   / ( (run_pct + NVL (type_run_pct, run_pct)) / 2))
                 sched_cnt_plan
       FROM      gk_sched_freq_plan_v p
              INNER JOIN
                 course_dim cd
              ON     p.course_code = cd.course_code
                 AND p.ops_country = cd.country
                 AND cd.gkdw_source = 'SLXDW'
      WHERE   ops_country = 'USA'
   ORDER BY   course_pl, course_type, course_code;


