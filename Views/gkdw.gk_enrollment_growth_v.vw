DROP VIEW GKDW.GK_ENROLLMENT_GROWTH_V;

/* Formatted on 29/01/2021 11:37:42 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ENROLLMENT_GROWTH_V
(
   OPS_COUNTRY,
   COURSE_PL,
   COURSE_TYPE,
   COURSE_CODE,
   ENROLL_YEAR_MINUS_3,
   ENROLL_YEAR_MINUS_2,
   ENROLL_YEAR_MINUS_1,
   ENROLL_YEAR,
   ONE_YEAR_GROWTH,
   TWO_YEAR_GROWTH,
   THREE_YEAR_GROWTH
)
AS
     SELECT   ed.ops_country,
              cd.course_pl,
              cd.course_type,
              cd.course_code,
              SUM(CASE
                     WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 1460
                                            AND  TRUNC (SYSDATE) - 1096
                     THEN
                        1
                     ELSE
                        0
                  END)
                 enroll_year_minus_3,
              SUM(CASE
                     WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 1095
                                            AND  TRUNC (SYSDATE) - 731
                     THEN
                        1
                     ELSE
                        0
                  END)
                 enroll_year_minus_2,
              SUM(CASE
                     WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 730
                                            AND  TRUNC (SYSDATE) - 366
                     THEN
                        1
                     ELSE
                        0
                  END)
                 enroll_year_minus_1,
              SUM(CASE
                     WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 365
                                            AND  TRUNC (SYSDATE)
                     THEN
                        1
                     ELSE
                        0
                  END)
                 enroll_year,
              CASE
                 WHEN SUM(CASE
                             WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 730
                                                    AND  TRUNC(SYSDATE) - 366
                             THEN
                                1
                             ELSE
                                0
                          END) = 0
                 THEN
                    0
                 ELSE
                    (SUM(CASE
                            WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 365
                                                   AND  TRUNC (SYSDATE)
                            THEN
                               1
                            ELSE
                               0
                         END)
                     / SUM(CASE
                              WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 730
                                                     AND  TRUNC (SYSDATE) - 366
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                     - 1)
              END
                 one_year_growth,
              CASE
                 WHEN SUM(CASE
                             WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 1095
                                                    AND  TRUNC(SYSDATE) - 731
                             THEN
                                1
                             ELSE
                                0
                          END) = 0
                 THEN
                    0
                 ELSE
                    (SUM(CASE
                            WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 365
                                                   AND  TRUNC (SYSDATE)
                            THEN
                               1
                            ELSE
                               0
                         END)
                     / SUM(CASE
                              WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 1095
                                                     AND  TRUNC (SYSDATE) - 731
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                     - 1)
              END
                 two_year_growth,
              CASE
                 WHEN SUM(CASE
                             WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 1460
                                                    AND  TRUNC(SYSDATE) - 1096
                             THEN
                                1
                             ELSE
                                0
                          END) = 0
                 THEN
                    0
                 ELSE
                    (SUM(CASE
                            WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 365
                                                   AND  TRUNC (SYSDATE)
                            THEN
                               1
                            ELSE
                               0
                         END)
                     / SUM(CASE
                              WHEN ed.start_date BETWEEN TRUNC (SYSDATE) - 1460
                                                     AND  TRUNC (SYSDATE)
                                                          - 1096
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                     - 1)
              END
                 three_year_growth
       FROM         order_fact f
                 INNER JOIN
                    event_dim ed
                 ON f.event_id = ed.event_id
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE   ed.start_date BETWEEN TRUNC (SYSDATE) - 1460 AND TRUNC (SYSDATE)
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
              AND f.enroll_status IN ('Confirmed', 'Attended')
              AND f.book_amt > 0
   GROUP BY   ed.ops_country,
              cd.course_pl,
              cd.course_type,
              cd.course_code;


