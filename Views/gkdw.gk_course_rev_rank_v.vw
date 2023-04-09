DROP VIEW GKDW.GK_COURSE_REV_RANK_V;

/* Formatted on 29/01/2021 11:39:11 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_REV_RANK_V
(
   COURSE_CODE,
   REV_AMT,
   REV_RANK
)
AS
     SELECT   cd.course_code,
              SUM (book_amt) rev_amt,
              RANK () OVER (ORDER BY SUM (book_amt) DESC) rev_rank
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE       ed.start_date >= TRUNC (SYSDATE) - 365
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20', '41', '42')
   GROUP BY   cd.course_code
   ORDER BY   rev_rank;


