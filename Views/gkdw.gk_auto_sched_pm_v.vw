DROP VIEW GKDW.GK_AUTO_SCHED_PM_V;

/* Formatted on 29/01/2021 11:42:51 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_AUTO_SCHED_PM_V
(
   PLAN_YEAR,
   COUNTRY,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   ROOT_CODE,
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   DURATION_DAYS,
   SCHED_ROLL_3,
   EV_ROLL_3,
   EN_ROLL_3,
   BOOK_ROLL_3,
   SCHED_ROLL_2,
   EV_ROLL_2,
   EN_ROLL_2,
   BOOK_ROLL_2,
   SCHED_ROLL_1,
   EV_ROLL_1,
   EN_ROLL_1,
   BOOK_ROLL_1
)
AS
     SELECT   q.plan_year,
              q.country,
              q.course_ch,
              q.course_mod,
              q.course_pl,
              q.course_type,
              q.root_code,
              q.course_id,
              q.course_code,
              q.short_name,
              q.duration_days,
              SUM (sched_roll_3) sched_roll_3,
              SUM (ev_roll_3) ev_roll_3,
              SUM (en_roll_3) en_roll_3,
              SUM (book_roll_3) book_roll_3,
              SUM (sched_roll_2) sched_roll_2,
              SUM (ev_roll_2) ev_roll_2,
              SUM (en_roll_2) en_roll_2,
              SUM (book_roll_2) book_roll_2,
              SUM (sched_roll_1) sched_roll_1,
              SUM (ev_roll_1) ev_roll_1,
              SUM (en_roll_1) en_roll_1,
              SUM (book_roll_1) book_roll_1
       FROM   (  SELECT   td1.dim_year + 1 plan_year,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          COUNT (DISTINCT ed.event_id) ev_roll_3,
                          COUNT (enroll_id) en_roll_3,
                          SUM (f.book_amt) book_roll_3,
                          0 ev_roll_2,
                          0 en_roll_2,
                          0 book_roll_2,
                          0 ev_roll_1,
                          0 en_roll_1,
                          0 book_roll_1,
                          0 sched_roll_3,
                          0 sched_roll_2,
                          0 sched_roll_1
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
                  WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
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
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
               GROUP BY   td1.dim_year + 1,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days
               UNION
                 SELECT   td1.dim_year + 1 plan_year,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          0 ev_roll_3,
                          0 en_roll_3,
                          0,
                          COUNT (DISTINCT ed.event_id) ev_roll_2,
                          COUNT (enroll_id) en_roll_2,
                          SUM (f.book_amt),
                          0 ev_roll_1,
                          0 en_roll_1,
                          0,
                          0,
                          0,
                          0
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
                  WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
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
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
               GROUP BY   td1.dim_year + 1,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days
               UNION
                 SELECT   td1.dim_year + 1 plan_year,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          0 ev_roll_3,
                          0 en_roll_3,
                          0,
                          0 ev_roll_2,
                          0 en_roll_2,
                          0,
                          COUNT (DISTINCT ed.event_id) ev_roll_1,
                          COUNT (enroll_id) en_roll_1,
                          SUM (f.book_amt),
                          0,
                          0,
                          0
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
                  WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
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
                          AND md_num = '10'
                          AND ed.status IN ('Verified')
               GROUP BY   td1.dim_year + 1,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days
               UNION
                 SELECT   td1.dim_year + 1 plan_year,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id) sched_roll_3,
                          0,
                          0
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
                  WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
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
                          AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
               GROUP BY   td1.dim_year + 1,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days
               UNION
                 SELECT   td1.dim_year + 1 plan_year,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id) sched_roll_2,
                          0
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
                  WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
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
                          AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
               GROUP BY   td1.dim_year + 1,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days
               UNION
                 SELECT   td1.dim_year + 1 plan_year,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          COUNT (DISTINCT ed.event_id) sched_roll_1
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
                  WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN td1.dim_year
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
                          AND md_num = '10'
                          AND (ed.status IN ('Open', 'Verified')
                               OR (ed.status = 'Cancelled'
                                   AND ed.cancel_reason = 'Low Enrollment'))
               GROUP BY   td1.dim_year + 1,
                          cd.country,
                          cd.course_ch,
                          cd.course_mod,
                          cd.course_pl,
                          cd.course_type,
                          cd.root_code,
                          cd.course_id,
                          cd.course_code,
                          cd.short_name,
                          cd.duration_days) q
      WHERE   SUBSTR (q.course_code, 5, 1) = 'C'
   GROUP BY   q.plan_year,
              q.country,
              q.course_ch,
              q.course_mod,
              q.course_pl,
              q.course_type,
              q.root_code,
              q.course_id,
              q.course_code,
              q.short_name,
              q.duration_days;


