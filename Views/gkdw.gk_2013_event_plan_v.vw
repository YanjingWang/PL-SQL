DROP VIEW GKDW.GK_2013_EVENT_PLAN_V;

/* Formatted on 29/01/2021 11:21:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_2013_EVENT_PLAN_V
(
   COURSE_CODE,
   SHORT_NAME,
   METRO,
   OPS_COUNTRY,
   DIM_QUARTER,
   EVENT_CNT_0,
   ENROLL_CNT_0,
   EVENT_CNT_1,
   ENROLL_CNT_1,
   EVENT_CNT_2,
   ENROLL_CNT_2,
   PROJ_FILL_RATE
)
AS
     SELECT   q.course_code,
              q.short_name,
              q.metro,
              q.ops_country,
              q.dim_quarter,
              SUM (event_cnt_0) event_cnt_0,
              SUM (enroll_cnt_0) enroll_cnt_0,
              SUM (event_cnt_1) event_cnt_1,
              SUM (enroll_cnt_1) enroll_cnt_1,
              SUM (event_cnt_2) event_cnt_2,
              SUM (enroll_cnt_2) enroll_cnt_2,
              ROUND(CASE
                       WHEN SUM (enroll_cnt_2) = 0 AND SUM (enroll_cnt_1) = 0
                       THEN
                          (CASE
                              WHEN SUM (event_cnt_0) = 0
                              THEN
                                 0
                              ELSE
                                 ROUND (SUM (enroll_cnt_0) / SUM (event_cnt_0))
                           END)
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
                       WHEN SUM (enroll_cnt_1) = 0
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
                                WHEN SUM (event_cnt_2) = 0
                                THEN
                                   0
                                ELSE
                                   ROUND (
                                      SUM (enroll_cnt_2) / SUM (event_cnt_2)
                                   )
                             END
                             * .2)
                       WHEN SUM (enroll_cnt_0) = 0
                       THEN
                          (CASE
                              WHEN SUM (event_cnt_1) = 0
                              THEN
                                 0
                              ELSE
                                 ROUND (SUM (enroll_cnt_1) / SUM (event_cnt_1))
                           END
                           * .6)
                          + (CASE
                                WHEN SUM (event_cnt_2) = 0
                                THEN
                                   0
                                ELSE
                                   ROUND (
                                      SUM (enroll_cnt_2) / SUM (event_cnt_2)
                                   )
                             END
                             * .4)
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
       FROM   (  SELECT   cd.course_code,
                          cd.short_name,
                          ed.facility_region_metro metro,
                          ed.ops_country,
                          td.dim_quarter dim_quarter,
                          COUNT (DISTINCT ed.event_id) event_cnt_0,
                          COUNT (DISTINCT f.enroll_id) enroll_cnt_0,
                          0 event_cnt_1,
                          0 enroll_cnt_1,
                          0 event_cnt_2,
                          0 enroll_cnt_2
                   FROM               event_dim ed
                                   INNER JOIN
                                      course_dim cd
                                   ON     ed.course_id = cd.course_id
                                      AND ed.ops_country = cd.country
                                      AND cd.ch_num = '10'
                                      AND cd.md_num = '10'
                                INNER JOIN
                                   order_fact f
                                ON ed.event_id = f.event_id
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             time_dim td2
                          ON ROUND (SYSDATE) = td2.dim_date
                  WHERE   td.dim_year || '-' || LPAD (td.dim_quarter - 1, 2, '0') BETWEEN td2.dim_year
                                                                                          - 1
                                                                                          || '-'
                                                                                          || LPAD (
                                                                                                td2.dim_quarter,
                                                                                                2,
                                                                                                '0'
                                                                                             )
                                                                                      AND  td2.dim_year
                                                                                           || '-'
                                                                                           || LPAD (
                                                                                                 td2.dim_quarter
                                                                                                 - 1,
                                                                                                 2,
                                                                                                 '0'
                                                                                              )
                          AND f.book_amt > 0
                          AND f.orig_enroll_id IS NULL
                          AND NVL (f.enroll_status_desc, 'NONE') NOT IN
                                   ('ORDER ENTRY ERROR', 'ACCOUNTING FIX')
                          --   and ed.status in ('Open','Verified')
                          --   and f.enroll_status in ('Confirmed','Attended')
                          AND ed.plan_type NOT IN ('Sales Request')
               GROUP BY   cd.course_code,
                          cd.short_name,
                          ed.facility_region_metro,
                          ed.ops_country,
                          td.dim_quarter
               UNION ALL
                 SELECT   cd.course_code,
                          cd.short_name,
                          ed.facility_region_metro,
                          ed.ops_country,
                          td.dim_quarter,
                          0 event_cnt_0,
                          0 enroll_cnt_0,
                          COUNT (DISTINCT ed.event_id) event_cnt_1,
                          COUNT (DISTINCT f.enroll_id) enroll_cnt_1,
                          0 event_cnt_2,
                          0 enroll_cnt_2
                   FROM               event_dim ed
                                   INNER JOIN
                                      course_dim cd
                                   ON     ed.course_id = cd.course_id
                                      AND ed.ops_country = cd.country
                                      AND cd.ch_num = '10'
                                      AND cd.md_num = '10'
                                INNER JOIN
                                   order_fact f
                                ON ed.event_id = f.event_id
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             time_dim td2
                          ON ROUND (SYSDATE) = td2.dim_date
                  WHERE   td.dim_year || '-' || LPAD (td.dim_quarter - 1, 2, '0') BETWEEN td2.dim_year
                                                                                          - 2
                                                                                          || '-'
                                                                                          || LPAD (
                                                                                                td2.dim_quarter,
                                                                                                2,
                                                                                                '0'
                                                                                             )
                                                                                      AND  td2.dim_year
                                                                                           - 1
                                                                                           || '-'
                                                                                           || LPAD (
                                                                                                 td2.dim_quarter
                                                                                                 - 1,
                                                                                                 2,
                                                                                                 '0'
                                                                                              )
                          AND f.book_amt > 0
                          AND f.orig_enroll_id IS NULL
                          AND NVL (f.enroll_status_desc, 'NONE') NOT IN
                                   ('ORDER ENTRY ERROR', 'ACCOUNTING FIX')
                          --   and ed.status in ('Open','Verified')
                          --   and f.enroll_status in ('Confirmed','Attended')
                          AND ed.plan_type NOT IN ('Sales Request')
               GROUP BY   cd.course_code,
                          cd.short_name,
                          ed.facility_region_metro,
                          ed.ops_country,
                          td.dim_quarter
               UNION ALL
                 SELECT   cd.course_code,
                          cd.short_name,
                          ed.facility_region_metro,
                          ed.ops_country,
                          td.dim_quarter,
                          0 event_cnt_0,
                          0 enroll_cnt_0,
                          0 event_cnt_1,
                          0 enroll_cnt_1,
                          COUNT (DISTINCT ed.event_id) event_cnt_2,
                          COUNT (DISTINCT f.enroll_id) enroll_cnt_2
                   FROM               event_dim ed
                                   INNER JOIN
                                      course_dim cd
                                   ON     ed.course_id = cd.course_id
                                      AND ed.ops_country = cd.country
                                      AND cd.ch_num = '10'
                                      AND cd.md_num = '10'
                                INNER JOIN
                                   order_fact f
                                ON ed.event_id = f.event_id
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             time_dim td2
                          ON ROUND (SYSDATE) = td2.dim_date
                  WHERE   td.dim_year || '-' || LPAD (td.dim_quarter - 1, 2, '0') BETWEEN td2.dim_year
                                                                                          - 3
                                                                                          || '-'
                                                                                          || LPAD (
                                                                                                td2.dim_quarter,
                                                                                                2,
                                                                                                '0'
                                                                                             )
                                                                                      AND  td2.dim_year
                                                                                           - 2
                                                                                           || '-'
                                                                                           || LPAD (
                                                                                                 td2.dim_quarter
                                                                                                 - 1,
                                                                                                 2,
                                                                                                 '0'
                                                                                              )
                          AND f.book_amt > 0
                          AND f.orig_enroll_id IS NULL
                          AND NVL (f.enroll_status_desc, 'NONE') NOT IN
                                   ('ORDER ENTRY ERROR', 'ACCOUNTING FIX')
                          --   and ed.status in ('Open','Verified')
                          --   and f.enroll_status in ('Confirmed','Attended')
                          AND ed.plan_type NOT IN ('Sales Request')
               GROUP BY   cd.course_code,
                          cd.short_name,
                          ed.facility_region_metro,
                          ed.ops_country,
                          td.dim_quarter) q
   GROUP BY   q.course_code,
              q.short_name,
              q.metro,
              q.ops_country,
              q.dim_quarter;


