DROP VIEW GKDW.GK_SMART_V;

/* Formatted on 29/01/2021 11:26:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SMART_V
(
   CUST_ID,
   COURSE_ID,
   COURSE_PL,
   COURSE_TYPE,
   NEXT_COURSE,
   SHORT_NAME,
   COURSE_NAME,
   COURSE_RANK
)
AS
     SELECT   cust_id,
              q.course_id,
              q.course_pl,
              q.course_type,
              q.next_course,
              q.short_name,
              q.course_name,
              course_rank
       FROM   (  SELECT   f.cust_id,
                          cd3.course_id,
                          cd3.course_pl,
                          cd3.course_type,
                          cd3.course_code next_course,
                          cd3.short_name,
                          cd3.course_name,
                          COUNT ( * ) course_cnt,
                          RANK ()
                             OVER (PARTITION BY f.cust_id
                                   ORDER BY COUNT ( * ) DESC)
                             course_rank
                   FROM                                    order_fact f
                                                        INNER JOIN
                                                           time_dim td
                                                        ON td.dim_date =
                                                              f.book_date
                                                     INNER JOIN
                                                        event_dim ed
                                                     ON f.event_id = ed.event_id
                                                  INNER JOIN
                                                     course_dim cd
                                                  ON ed.course_id = cd.course_id
                                                     AND ed.ops_country =
                                                           cd.country
                                               --and cd.course_ch = 'INDIVIDUAL/PUBLIC'
                                               INNER JOIN
                                                  event_dim ed2
                                               ON cd.course_id = ed2.course_id
                                            INNER JOIN
                                               order_fact f2
                                            ON ed2.event_id = f2.event_id
                                               AND f2.enroll_status IN
                                                        ('Confirmed', 'Attended')
                                         INNER JOIN
                                            time_dim td2
                                         ON td2.dim_date = f2.book_date
                                      INNER JOIN
                                         cust_dim c2
                                      ON f2.cust_id = c2.cust_id
                                   INNER JOIN
                                      order_fact f3
                                   ON c2.cust_id = f3.cust_id
                                      AND f3.enroll_status IN
                                               ('Confirmed', 'Attended')
                                INNER JOIN
                                   time_dim td3
                                ON td3.dim_date = f2.book_date
                             INNER JOIN
                                event_dim ed3
                             ON f3.event_id = ed3.event_id
                          INNER JOIN
                             course_dim cd3
                          ON     ed3.course_id = cd3.course_id
                             AND ed3.ops_country = cd3.country
                             AND cd.course_code != cd3.course_code
                             AND cd3.course_ch = 'INDIVIDUAL/PUBLIC'
                             AND cd3.course_pl != 'ALLOCATION POOL/OVERHEAD'
                  WHERE       f.enroll_status IN ('Confirmed', 'Attended')
                          AND td2.dim_year >= td.dim_year - 2
                          AND td3.dim_year >= td.dim_year - 2
                          AND NOT EXISTS
                                (SELECT   1
                                   FROM         order_fact f4
                                             INNER JOIN
                                                event_dim ed4
                                             ON f4.event_id = ed4.event_id
                                          INNER JOIN
                                             course_dim cd4
                                          ON ed4.course_id = cd4.course_id
                                             AND ed4.ops_country = cd4.country
                                  WHERE   f4.cust_id = f.cust_id
                                          AND SUBSTR (cd3.course_code, 1, 4) =
                                                SUBSTR (cd4.course_code, 1, 4))
                          AND EXISTS
                                (SELECT   1
                                   FROM   event_dim ed5
                                  WHERE   cd3.course_id = ed5.course_id
                                          AND ed5.status = 'Open')
               GROUP BY   f.cust_id,
                          cd3.course_id,
                          cd3.course_pl,
                          cd3.course_type,
                          cd3.course_code,
                          cd3.short_name,
                          cd3.course_name) q
      WHERE   course_rank <= 10
   ORDER BY   course_rank ASC;


