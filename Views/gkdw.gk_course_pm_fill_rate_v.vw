DROP VIEW GKDW.GK_COURSE_PM_FILL_RATE_V;

/* Formatted on 29/01/2021 11:39:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_PM_FILL_RATE_V
(
   OPS_COUNTRY,
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   EVENT_CNT,
   AVG_COST,
   MAX_COST,
   AVG_FILL,
   MAX_FILL
)
AS
     SELECT   ed.ops_country,
              cd.course_id,
              cd.course_code,
              cd.short_name,
              COUNT (ed.event_id) event_cnt,
              ROUND (AVG (total_cost) * 2) avg_cost,
              ROUND (MAX (total_cost) * 2) max_cost,
              CASE
                 WHEN AVG (ab.avg_book_amt) = 0 THEN 0
                 ELSE ROUND ( (AVG (total_cost) * 1.8) / AVG (ab.avg_book_amt))
              END
                 avg_fill,
              CASE
                 WHEN AVG (ab.avg_book_amt) = 0 THEN 0
                 ELSE ROUND ( (MAX (total_cost) * 1.8) / AVG (ab.avg_book_amt))
              END
                 max_fill
       FROM                  gk_go_nogo_all_v g
                          INNER JOIN
                             event_dim ed
                          ON g.event_id = ed.event_id
                       INNER JOIN
                          course_dim cd
                       ON ed.course_id = cd.course_id
                          AND ed.ops_country = cd.country
                    INNER JOIN
                       time_dim td
                    ON ed.start_date = td.dim_date
                 INNER JOIN
                    time_dim td1
                 ON td1.dim_date = TRUNC (SYSDATE)
              INNER JOIN
                 gk_course_avg_book_v ab
              ON     ed.course_id = ab.course_id
                 AND ed.ops_country = ab.ops_country
                 AND ed.facility_region_metro = ab.metro
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
              AND ed.status = 'Verified'
   GROUP BY   ed.ops_country,
              cd.course_id,
              cd.course_code,
              cd.short_name;


