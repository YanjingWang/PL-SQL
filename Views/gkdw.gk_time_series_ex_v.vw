DROP VIEW GKDW.GK_TIME_SERIES_EX_V;

/* Formatted on 29/01/2021 11:24:59 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TIME_SERIES_EX_V
(
   COURSE_CODE,
   SHORT_NAME,
   COURSE_TYPE,
   DIM_YEAR,
   TIME_VAL,
   SCHED_CNT,
   RUN_CNT
)
AS
     SELECT   cd.course_code,
              cd.short_name,
              cd.course_type,
              td.dim_year,
              dim_year - 2007 time_val,
              COUNT (ed.event_id) sched_cnt,
              SUM (CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END)
                 run_cnt
       FROM         course_dim cd
                 INNER JOIN
                    event_dim ed
                 ON cd.course_id = ed.course_id AND cd.country = ed.ops_country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE       cd.course_pl = 'CISCO'
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
              AND ed.ops_country = 'USA'
              AND cd.course_code = '5031C'
              AND EXISTS
                    (SELECT   1
                       FROM         course_dim cd1
                                 INNER JOIN
                                    event_dim ed1
                                 ON cd1.course_id = ed1.course_id
                                    AND cd1.country = ed1.ops_country
                              INNER JOIN
                                 time_dim td1
                              ON ed1.start_date = td1.dim_date
                      WHERE       cd1.course_id = cd.course_id
                              AND cd1.country = cd.country
                              AND td1.dim_year = TO_CHAR (SYSDATE, 'YYYY'))
   GROUP BY   cd.course_code,
              cd.short_name,
              cd.course_type,
              td.dim_year;


