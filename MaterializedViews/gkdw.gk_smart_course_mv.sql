DROP MATERIALIZED VIEW GKDW.GK_SMART_COURSE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SMART_COURSE_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:22:04 (QP5 v5.115.810.9015) */
SELECT   course_code,
         q.course_id,
         q.course_pl,
         q.course_type,
         q.next_course,
         q.short_name,
         q.course_name,
         course_rank
  FROM   (  SELECT   cd.course_code,
                     cd1.course_id,
                     cd1.course_pl,
                     cd1.course_type,
                     cd1.course_code next_course,
                     cd1.short_name,
                     cd1.course_name,
                     COUNT ( * ) course_cnt,
                     RANK ()
                        OVER (PARTITION BY cd.course_code
                              ORDER BY COUNT ( * ) DESC)
                        course_rank
              FROM                        course_dim cd
                                       INNER JOIN
                                          event_dim ed
                                       ON cd.course_id = ed.course_id
                                          AND cd.country = ed.ops_country
                                    INNER JOIN
                                       order_fact f
                                    ON ed.event_id = f.event_id
                                       AND f.enroll_status IN
                                                ('Confirmed', 'Attended')
                                 INNER JOIN
                                    time_dim td
                                 ON td.dim_date = f.book_date
                              INNER JOIN
                                 order_fact f1
                              ON f.cust_id = f1.cust_id
                                 AND f1.enroll_status IN
                                          ('Confirmed', 'Attended')
                           INNER JOIN
                              event_dim ed1
                           ON f1.event_id = ed1.event_id
                        INNER JOIN
                           course_dim cd1
                        ON     ed1.course_id = cd1.course_id
                           AND ed1.ops_country = cd1.country
                           AND cd.course_id != cd1.course_id
                           AND cd1.course_ch = 'INDIVIDUAL/PUBLIC'
                           AND cd1.course_pl != 'ALLOCATION POOL/OVERHEAD'
                     INNER JOIN
                        time_dim td1
                     ON td1.dim_date = f1.book_date
             WHERE   td1.dim_year >= td.dim_year - 2
                     AND EXISTS
                           (SELECT   1
                              FROM   event_dim ed2
                             WHERE       cd1.course_id = ed2.course_id
                                     AND ed2.status = 'Open'
                                     AND ed2.start_date >= TRUNC (SYSDATE))
          GROUP BY   cd.course_code,
                     cd1.course_id,
                     cd1.course_pl,
                     cd1.course_type,
                     cd1.course_code,
                     cd1.short_name,
                     cd1.course_name) q
 WHERE   course_rank <= 10;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SMART_COURSE_MV IS 'snapshot table for snapshot GKDW.GK_SMART_COURSE_MV';

GRANT SELECT ON GKDW.GK_SMART_COURSE_MV TO DWHREAD;

