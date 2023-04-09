DROP VIEW GKDW.GK_COURSE_AVG_BOOK_V;

/* Formatted on 29/01/2021 11:40:18 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_AVG_BOOK_V
(
   OPS_COUNTRY,
   METRO,
   COURSE_ID,
   AVG_BOOK_AMT
)
AS
     SELECT   ed.ops_country,
              ed.facility_region_metro metro,
              cd.course_id,
              AVG (book_amt) avg_book_amt
       FROM               event_dim ed
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
                 order_fact f
              ON     ed.event_id = f.event_id
                 AND f.enroll_status = 'Attended'
                 AND book_amt > 0
      WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') BETWEEN dim_year
                                                                            - 3
                                                                            || '-'
                                                                            || LPAD (
                                                                                  dim_month_num,
                                                                                  2,
                                                                                  '0'
                                                                               )
                                                                        AND  dim_year
                                                                             || '-'
                                                                             || LPAD (
                                                                                   dim_month_num
                                                                                   - 1,
                                                                                   2,
                                                                                   '0'
                                                                                )
              AND ch_num = '10'
              AND md_num = '10'
              AND ed.status = 'Verified'
   GROUP BY   ed.ops_country, ed.facility_region_metro, cd.course_id;


