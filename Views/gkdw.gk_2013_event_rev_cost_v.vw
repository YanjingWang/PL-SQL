DROP VIEW GKDW.GK_2013_EVENT_REV_COST_V;

/* Formatted on 29/01/2021 11:21:19 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_2013_EVENT_REV_COST_V
(
   OPS_COUNTRY,
   COURSE_CODE,
   BOOK_AMT,
   ENROLL_CNT,
   AVG_FARE,
   EVENT_COST,
   EVENT_CNT,
   AVG_EVENT_COST,
   AVG_MARGIN
)
AS
     SELECT   ops_country,
              course_code,
              SUM (book_amt) book_amt,
              SUM (enroll_cnt) enroll_cnt,
              SUM (avg_fare) avg_fare,
              SUM (event_cost) event_cost,
              SUM (event_cnt) event_cnt,
              SUM (avg_event_cost) avg_event_cost,
              CASE
                 WHEN SUM (event_cnt) = 0
                 THEN
                    0
                 ELSE
                    ROUND (
                       (SUM (book_amt) - SUM (event_cost)) / SUM (event_cnt)
                    )
              END
                 avg_margin
       FROM   (  SELECT   ed.ops_country,
                          ed.course_code,
                          SUM (book_amt) book_amt,
                          COUNT (enroll_id) enroll_cnt,
                          ROUND (SUM (book_amt) / COUNT (enroll_id)) avg_fare,
                          0 event_cost,
                          0 event_cnt,
                          0 avg_event_cost
                   FROM         event_dim ed
                             INNER JOIN
                                time_dim td
                             ON ed.start_date = td.dim_date
                          INNER JOIN
                             order_fact f
                          ON ed.event_id = f.event_id
                  WHERE   td.dim_year >=
                             TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - 2
                          AND f.enroll_status IN ('Confirmed', 'Attended')
               GROUP BY   ed.ops_country, ed.course_code
               UNION ALL
                 SELECT   l.ops_country,
                          l.course_code,
                          0 book_amt,
                          0 enroll_cnt,
                          0 avg_fare,
                          SUM (total_cost) event_cost,
                          COUNT (l.event_id) event_cnt,
                          ROUND (SUM (total_cost) / COUNT (l.event_id))
                             avg_event_cost
                   FROM      gk_go_nogo l
                          INNER JOIN
                             time_dim td
                          ON l.start_date = td.dim_date
                  WHERE   td.dim_year >=
                             TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - 2
                          AND l.cancelled_date IS NULL
               GROUP BY   l.ops_country, l.course_code)
   GROUP BY   ops_country, course_code;


