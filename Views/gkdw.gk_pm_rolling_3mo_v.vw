DROP VIEW GKDW.GK_PM_ROLLING_3MO_V;

/* Formatted on 29/01/2021 11:30:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PM_ROLLING_3MO_V
(
   COUNTRY,
   COURSE_ID,
   COURSE_CODE,
   REV_AMT,
   ENROLL_CNT,
   EVENT_CNT,
   REV_STUD
)
AS
     SELECT   cd.country,
              cd.course_id,
              cd.course_code,
              SUM (f.book_amt) rev_amt,
              COUNT (f.enroll_id) enroll_cnt,
              COUNT (DISTINCT ed.event_id) event_cnt,
              SUM (f.book_amt) / COUNT (f.enroll_id) rev_stud
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       ed.status != 'Cancelled'
              AND f.enroll_status != 'Cancelled'
              AND ed.start_date >= TRUNC (SYSDATE) - 90
   GROUP BY   cd.country, cd.course_id, cd.course_code;


