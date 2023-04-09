DROP VIEW GKDW.GK_SCHED_REV_PER_STUD_V;

/* Formatted on 29/01/2021 11:26:27 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_REV_PER_STUD_V
(
   COURSE_ID,
   OPS_COUNTRY,
   REV_AMT,
   EN_CNT,
   REV_PER_STUD
)
AS
     SELECT   ed.course_id,
              ed.ops_country,
              SUM (f.book_amt) rev_amt,
              COUNT (DISTINCT f.enroll_id) en_cnt,
              SUM (f.book_amt) / COUNT (DISTINCT f.enroll_id) rev_per_stud
       FROM         event_dim ed
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       td.dim_year = TO_CHAR (SYSDATE, 'YYYY')
              AND ed.start_date <= TRUNC (SYSDATE)
              AND ed.status != 'Cancelled'
              AND f.enroll_status != 'Cancelled'
   GROUP BY   ed.course_id, ed.ops_country;


