DROP VIEW GKDW.GK_SCHED_COURSE_FREQ_V;

/* Formatted on 29/01/2021 11:26:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_COURSE_FREQ_V
(
   YEAR_OFFSET,
   OPS_COUNTRY,
   COURSE_ID,
   COURSE_CODE,
   EVENT_SCHED_CNT,
   WEEKS_SCHED,
   FREQ_WEEKS
)
AS
     SELECT   1 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE)
              AND ed.start_date <= TRUNC (SYSDATE) + 365
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
              AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event in Error',
                        'Event Postponed due to Acts of N',
                        'OS XL - Rescheduled due to Holid',
                        'Pre-Cancel (market/schedule righ')
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   1 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      gk_vcl_sched_plan_v ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE)
              AND ed.start_date <= TRUNC (SYSDATE) + 365
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '20'
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   0 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE) - 365
              AND ed.start_date <= TRUNC (SYSDATE)
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
              AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event in Error',
                        'Event Postponed due to Acts of N',
                        'OS XL - Rescheduled due to Holid',
                        'Pre-Cancel (market/schedule righ')
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   0 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      gk_vcl_sched_plan_v ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE) - 365
              AND ed.start_date <= TRUNC (SYSDATE)
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '20'
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   -1 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE) - 730
              AND ed.start_date <= TRUNC (SYSDATE) - 365
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
              AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event in Error',
                        'Event Postponed due to Acts of N',
                        'OS XL - Rescheduled due to Holid',
                        'Pre-Cancel (market/schedule righ')
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   -1 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      gk_vcl_sched_plan_v ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE) - 730
              AND ed.start_date <= TRUNC (SYSDATE) - 365
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '20'
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   -2 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE) - 1095
              AND ed.start_date <= TRUNC (SYSDATE) - 730
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
              AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                       ('Course Delays - Equipment, Devel',
                        'Course Discontinued',
                        'Course Version Update',
                        'Event in Error',
                        'Event Postponed due to Acts of N',
                        'OS XL - Rescheduled due to Holid',
                        'Pre-Cancel (market/schedule righ')
   GROUP BY   ops_country, ed.course_id, ed.course_code
   UNION
     SELECT   -2 year_offset,
              ops_country,
              ed.course_id,
              ed.course_code,
              COUNT (DISTINCT event_id) event_sched_cnt,
              CEIL (MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1)
              * 4
                 weeks_sched,
              ROUND (
                 (CEIL (
                     MONTHS_BETWEEN (MAX (start_date), MIN (start_date)) + 1
                  )
                  * 4)
                 / (COUNT (DISTINCT event_id)),
                 2
              )
                 freq_weeks
       FROM      gk_vcl_sched_plan_v ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date > TRUNC (SYSDATE) - 1095
              AND ed.start_date <= TRUNC (SYSDATE) - 730
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num = '20'
   GROUP BY   ops_country, ed.course_id, ed.course_code;


