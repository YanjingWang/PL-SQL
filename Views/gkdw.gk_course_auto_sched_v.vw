DROP VIEW GKDW.GK_COURSE_AUTO_SCHED_V;

/* Formatted on 29/01/2021 11:40:24 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_AUTO_SCHED_V
(
   PLAN_YEAR,
   COUNTRY,
   COURSE_ID,
   COURSE,
   SHORT_NAME,
   COURSE_PL,
   COURSE_CH,
   COURSE_MOD,
   COURSE_TYPE,
   DURATION_DAYS,
   METRO,
   AVG_BOOK_AMT,
   AVG_COST,
   MAX_COST,
   AVG_FILL,
   MAX_FILL,
   SCHED_CNT_3,
   EV_CNT_3,
   EN_CNT_3,
   FILL_3,
   SCHED_CNT_2,
   EV_CNT_2,
   EN_CNT_2,
   FILL_2,
   SCHED_CNT_1,
   EV_CNT_1,
   EN_CNT_1,
   FILL_1,
   FUTURE_SCHED_EVENT,
   EV_CNT_PLAN,
   WK_DIST_PLAN
)
AS
     SELECT   plan_year,
              q.country,
              q.course_id,
              q.course_code course,
              q.short_name,
              course_pl,
              course_ch,
              course_mod,
              course_type,
              duration_days,
              q.facility_region_metro metro,
              avg_book_amt,
              avg_cost,
              max_cost,
              avg_fill,
              max_fill,
              SUM (sched_cnt_3) sched_cnt_3,
              SUM (event_cnt_3) ev_cnt_3,
              SUM (enroll_cnt_3) en_cnt_3,
              CASE
                 WHEN SUM (event_cnt_3) = 0 THEN 0
                 ELSE ROUND (SUM (enroll_cnt_3) / SUM (event_cnt_3), 1)
              END
                 fill_3,
              SUM (sched_cnt_2) sched_cnt_2,
              SUM (event_cnt_2) ev_cnt_2,
              SUM (enroll_cnt_2) en_cnt_2,
              CASE
                 WHEN SUM (event_cnt_2) = 0 THEN 0
                 ELSE ROUND (SUM (enroll_cnt_2) / SUM (event_cnt_2), 1)
              END
                 fill_2,
              SUM (sched_cnt_1) sched_cnt_1,
              SUM (event_cnt_1) ev_cnt_1,
              SUM (enroll_cnt_1) en_cnt_1,
              CASE
                 WHEN SUM (event_cnt_1) = 0 THEN 0
                 ELSE ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1)
              END
                 fill_1,
              SUM (NVL (future_sched_event, 0)) future_sched_event,
              CASE
                 WHEN SUM (event_cnt_1) = 0
                 THEN
                    0
                 WHEN avg_fill = 0
                 THEN
                    0
                 WHEN max_fill = 0
                 THEN
                    0
                 WHEN ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1) <
                         avg_fill
                 THEN
                    ROUND(SUM (event_cnt_1)
                          * (SUM (enroll_cnt_1) / SUM (event_cnt_1) / avg_fill))
                 WHEN ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1) BETWEEN avg_fill
                                                                            AND  max_fill
                 THEN
                    SUM (event_cnt_1)
                 WHEN ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1) >
                         max_fill
                 THEN
                    ROUND(SUM (event_cnt_1)
                          * (SUM (enroll_cnt_1) / SUM (event_cnt_1) / max_fill))
              END
                 ev_cnt_plan,
              CASE
                 WHEN SUM (event_cnt_1) = 0
                 THEN
                    0
                 WHEN avg_fill = 0
                 THEN
                    0
                 WHEN max_fill = 0
                 THEN
                    0
                 WHEN ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1) <
                         avg_fill
                 THEN
                    ROUND(  48
                          / SUM (event_cnt_1)
                          * (SUM (enroll_cnt_1) / SUM (event_cnt_1) / avg_fill))
                 WHEN ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1) BETWEEN avg_fill
                                                                            AND  max_fill
                 THEN
                    ROUND (48 / SUM (event_cnt_1))
                 WHEN ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1), 1) >
                         max_fill
                 THEN
                    ROUND(  48
                          / SUM (event_cnt_1)
                          * (SUM (enroll_cnt_1) / SUM (event_cnt_1) / max_fill))
              END
                 wk_dist_plan
       FROM      (  SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             COUNT (DISTINCT ed.event_id) event_cnt_3,
                             COUNT (enroll_id) enroll_cnt_3,
                             0 event_cnt_2,
                             0 enroll_cnt_2,
                             0 event_cnt_1,
                             0 enroll_cnt_1,
                             0 sched_cnt_3,
                             0 sched_cnt_2,
                             0 sched_cnt_1,
                             0 future_sched_event
                      FROM               course_dim cd
                                      INNER JOIN
                                         event_dim ed
                                      ON cd.course_id = ed.course_id
                                         AND cd.country = ed.ops_country
                                   INNER JOIN
                                      order_fact f
                                   ON     ed.event_id = f.event_id
                                      AND f.enroll_status = 'Attended'
                                      AND f.book_amt > 0
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                time_dim td1
                             ON td1.dim_date = TRUNC (SYSDATE)
                     WHERE      td.dim_year
                             || '-'
                             || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
                                                                        - 3
                                                                        || '-'
                                                                        || LPAD (
                                                                              td1.dim_month_num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    AND  td1.dim_year
                                                                         - 2
                                                                         || '-'
                                                                         || LPAD (
                                                                               td1.dim_month_num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             AND ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND ed.status IN ('Verified')
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days
                  UNION
                    SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             0 event_cnt_3,
                             0 enroll_cnt_3,
                             COUNT (DISTINCT ed.event_id) event_cnt_2,
                             COUNT (enroll_id) enroll_cnt_2,
                             0 event_cnt_1,
                             0 enroll_cnt_1,
                             0 sched_cnt_3,
                             0 sched_cnt_2,
                             0 sched_cnt_1,
                             0 future_sched_event
                      FROM               course_dim cd
                                      INNER JOIN
                                         event_dim ed
                                      ON cd.course_id = ed.course_id
                                         AND cd.country = ed.ops_country
                                   INNER JOIN
                                      order_fact f
                                   ON     ed.event_id = f.event_id
                                      AND f.enroll_status = 'Attended'
                                      AND f.book_amt > 0
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                time_dim td1
                             ON td1.dim_date = TRUNC (SYSDATE)
                     WHERE      td.dim_year
                             || '-'
                             || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
                                                                        - 2
                                                                        || '-'
                                                                        || LPAD (
                                                                              td1.dim_month_num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    AND  td1.dim_year
                                                                         - 1
                                                                         || '-'
                                                                         || LPAD (
                                                                               td1.dim_month_num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             AND ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND ed.status IN ('Verified')
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days
                  UNION
                    SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             0 event_cnt_3,
                             0 enroll_cnt_3,
                             0 event_cnt_2,
                             0 enroll_cnt_2,
                             COUNT (DISTINCT ed.event_id) event_cnt_1,
                             COUNT (enroll_id) enroll_cnt_1,
                             0 sched_cnt_3,
                             0 sched_cnt_2,
                             0 sched_cnt_1,
                             0 future_sched_event
                      FROM               course_dim cd
                                      INNER JOIN
                                         event_dim ed
                                      ON cd.course_id = ed.course_id
                                         AND cd.country = ed.ops_country
                                   INNER JOIN
                                      order_fact f
                                   ON     ed.event_id = f.event_id
                                      AND f.enroll_status = 'Attended'
                                      AND f.book_amt > 0
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                time_dim td1
                             ON td1.dim_date = TRUNC (SYSDATE)
                     WHERE      td.dim_year
                             || '-'
                             || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
                                                                        - 1
                                                                        || '-'
                                                                        || LPAD (
                                                                              td1.dim_month_num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    AND  td1.dim_year
                                                                         || '-'
                                                                         || LPAD (
                                                                               td1.dim_month_num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             AND ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND ed.status IN ('Verified')
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days
                  UNION
                    SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             0 event_cnt_3,
                             0 enroll_cnt_3,
                             0 event_cnt_2,
                             0 enroll_cnt_2,
                             0 event_cnt_1,
                             0 enroll_cnt_1,
                             COUNT (DISTINCT ed.event_id) sched_cnt_3,
                             0 sched_cnt_2,
                             0 sched_cnt_1,
                             0 future_sched_event
                      FROM            course_dim cd
                                   INNER JOIN
                                      event_dim ed
                                   ON cd.course_id = ed.course_id
                                      AND cd.country = ed.ops_country
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                time_dim td1
                             ON td1.dim_date = TRUNC (SYSDATE)
                     WHERE      td.dim_year
                             || '-'
                             || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
                                                                        - 3
                                                                        || '-'
                                                                        || LPAD (
                                                                              td1.dim_month_num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    AND  td1.dim_year
                                                                         - 2
                                                                         || '-'
                                                                         || LPAD (
                                                                               td1.dim_month_num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             AND ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND (ed.status IN ('Open', 'Verified')
                                  OR (ed.status = 'Cancelled'
                                      AND ed.cancel_reason = 'Low Enrollment'))
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days
                  UNION
                    SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             0 event_cnt_3,
                             0 enroll_cnt_3,
                             0 event_cnt_2,
                             0 enroll_cnt_2,
                             0 event_cnt_1,
                             0 enroll_cnt_1,
                             0 sched_cnt_3,
                             COUNT (DISTINCT ed.event_id) sched_cnt_2,
                             0 sched_cnt_1,
                             0 future_sched_event
                      FROM            course_dim cd
                                   INNER JOIN
                                      event_dim ed
                                   ON cd.course_id = ed.course_id
                                      AND cd.country = ed.ops_country
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                time_dim td1
                             ON td1.dim_date = TRUNC (SYSDATE)
                     WHERE      td.dim_year
                             || '-'
                             || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
                                                                        - 2
                                                                        || '-'
                                                                        || LPAD (
                                                                              td1.dim_month_num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    AND  td1.dim_year
                                                                         - 1
                                                                         || '-'
                                                                         || LPAD (
                                                                               td1.dim_month_num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             AND ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND (ed.status IN ('Open', 'Verified')
                                  OR (ed.status = 'Cancelled'
                                      AND ed.cancel_reason = 'Low Enrollment'))
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days
                  UNION
                    SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             0 event_cnt_3,
                             0 enroll_cnt_3,
                             0 event_cnt_2,
                             0 enroll_cnt_2,
                             0 event_cnt_1,
                             0 enroll_cnt_1,
                             0 sched_cnt_3,
                             0 sched_cnt_2,
                             COUNT (DISTINCT ed.event_id) sched_cnt_1,
                             0 future_sched_event
                      FROM            course_dim cd
                                   INNER JOIN
                                      event_dim ed
                                   ON cd.course_id = ed.course_id
                                      AND cd.country = ed.ops_country
                                INNER JOIN
                                   time_dim td
                                ON ed.start_date = td.dim_date
                             INNER JOIN
                                time_dim td1
                             ON td1.dim_date = TRUNC (SYSDATE)
                     WHERE      td.dim_year
                             || '-'
                             || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
                                                                        - 1
                                                                        || '-'
                                                                        || LPAD (
                                                                              td1.dim_month_num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    AND  td1.dim_year
                                                                         || '-'
                                                                         || LPAD (
                                                                               td1.dim_month_num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             AND ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND (ed.status IN ('Open', 'Verified')
                                  OR (ed.status = 'Cancelled'
                                      AND ed.cancel_reason = 'Low Enrollment'))
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days
                  UNION
                    SELECT   td1.dim_year + 1 plan_year,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days,
                             0 event_cnt_3,
                             0 enroll_cnt_3,
                             0 event_cnt_2,
                             0 enroll_cnt_2,
                             0 event_cnt_1,
                             0 enroll_cnt_1,
                             0 sched_cnt_3,
                             0 sched_cnt_2,
                             0 sched_cnt_1,
                             COUNT (DISTINCT ed.event_id) future_sched_event
                      FROM               course_dim cd
                                      INNER JOIN
                                         event_dim ed
                                      ON cd.course_id = ed.course_id
                                         AND cd.country = ed.ops_country
                                   INNER JOIN
                                      time_dim td
                                   ON ed.start_date = td.dim_date
                                INNER JOIN
                                   time_dim td1
                                ON td1.dim_date = TRUNC (SYSDATE)
                                   AND td.dim_year = td1.dim_year
                             LEFT OUTER JOIN
                                order_fact f
                             ON     ed.event_id = f.event_id
                                AND f.enroll_status != 'Cancelled'
                                AND f.book_amt > 0
                     WHERE       ch_num = '10'
                             AND md_num IN ('10', '20')
                             AND ed.status IN ('Open', 'Verified')
                  GROUP BY   td1.dim_year + 1,
                             cd.country,
                             cd.course_id,
                             cd.course_code,
                             cd.short_name,
                             ed.facility_region_metro,
                             course_pl,
                             course_ch,
                             course_mod,
                             cd.course_type,
                             cd.duration_days) q
              LEFT OUTER JOIN
                 gk_course_fill_rate_v fr
              ON q.course_id = fr.course_id
                 AND q.facility_region_metro = fr.metro
   GROUP BY   plan_year,
              q.country,
              q.course_id,
              q.course_code,
              q.short_name,
              course_pl,
              course_ch,
              course_mod,
              course_type,
              duration_days,
              q.facility_region_metro,
              avg_book_amt,
              avg_cost,
              max_cost,
              avg_fill,
              max_fill
     HAVING   SUM (future_sched_event) > 0
   --having sum(event_cnt_1) > 0
   --   and case when avg_fill = 0 then 0
   --            when max_fill = 0 then 0
   --            when round(sum(enroll_cnt_1)/sum(event_cnt_1),1) < avg_fill
   --            then round(sum(event_cnt_1)*(sum(enroll_cnt_1)/sum(event_cnt_1)/avg_fill))
   --            when round(sum(enroll_cnt_1)/sum(event_cnt_1),1) between avg_fill and max_fill
   --            then sum(event_cnt_1)
   --            when round(sum(enroll_cnt_1)/sum(event_cnt_1),1) > max_fill
   --            then round(sum(event_cnt_1)*(sum(enroll_cnt_1)/sum(event_cnt_1)/max_fill))
   --       end > 0
   ORDER BY   q.country,
              metro,
              course,
              wk_dist_plan;


