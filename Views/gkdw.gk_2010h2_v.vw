DROP VIEW GKDW.GK_2010H2_V;

/* Formatted on 29/01/2021 11:22:02 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_2010H2_V
(
   EVENT_ID,
   FILLRATE,
   SESSREV,
   REVSTUD
)
AS
     SELECT   ed.event_id,
              SUM(CASE
                     WHEN enroll_status IN ('Attended', 'Confirmed') THEN 1
                     ELSE 0
                  END)
              / COUNT (DISTINCT ed.event_id)
                 fillrate,
              SUM (book_amt) sessrev,
              CASE
                 WHEN SUM(CASE
                             WHEN f.enroll_status != 'Cancelled' THEN 1
                             ELSE 0
                          END) = 0
                 THEN
                    0
                 ELSE
                    SUM (book_amt)
                    / SUM(CASE
                             WHEN f.enroll_status != 'Cancelled' THEN 1
                             ELSE 0
                          END)
              END
                 revstud
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       td.dim_year = 2010
              AND cd.md_num = '10'
              AND cd.ch_num = '10'
              AND td.dim_month_num BETWEEN 1 AND 7
              AND ed.status = 'Verified'
   GROUP BY   ed.event_id;


