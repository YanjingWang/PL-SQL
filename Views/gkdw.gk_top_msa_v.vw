DROP VIEW GKDW.GK_TOP_MSA_V;

/* Formatted on 29/01/2021 11:24:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TOP_MSA_V
(
   REPORTING_MSA,
   REV_AMT
)
AS
     SELECT   NVL (z.consolidated_msa, z.msa_desc) reporting_msa,
              SUM (book_amt) rev_amt
       FROM                  order_fact f
                          INNER JOIN
                             event_dim ed
                          ON f.event_id = ed.event_id
                       INNER JOIN
                          course_dim c
                       ON ed.course_id = c.course_id
                          AND ed.ops_country = c.country
                    INNER JOIN
                       time_dim td
                    ON ed.start_date = td.dim_date
                 INNER JOIN
                    cust_dim cd
                 ON f.cust_id = cd.cust_id
              INNER JOIN
                 gk_msa_zips z
              ON SUBSTR (cd.zipcode, 1, 5) = z.zip_code
      WHERE       td.dim_year BETWEEN 2007 AND 2009
              AND f.enroll_status != 'Cancelled'
              AND ed.status != 'Cancelled'
              AND c.ch_num IN ('10', '20')
              AND c.md_num = '10'
              AND z.msa_desc NOT LIKE '%NONMETRO%'
   GROUP BY   NVL (z.consolidated_msa, z.msa_desc)
     HAVING   SUM (book_amt) >= 1000000
   ORDER BY   2 DESC;


