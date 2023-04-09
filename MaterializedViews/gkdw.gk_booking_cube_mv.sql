DROP MATERIALIZED VIEW GKDW.GK_BOOKING_CUBE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_BOOKING_CUBE_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:19:42 (QP5 v5.115.810.9015) */
SELECT   f.enroll_id,
         f.event_id,
         f.cust_id,
         f.keycode,
         f.fee_type,
         f.enroll_status,
         f.book_date,
         f.rev_date,
         f.book_amt,
         ed.ops_country,
         ed.country,
         c.COUNTRY cust_country,
         event_type,
         facility_region_metro,
         ed.ZIPCODE event_zip,
         CASE
            WHEN f.enroll_status IN ('T', 'Cancelled', 'Did Not Attend')
                 AND f.book_amt < 0
            THEN
               (-1 * (TRUNC (ed.END_DATE) - TRUNC (ed.start_date)))
            ELSE
               TRUNC (ed.END_DATE) - TRUNC (ed.start_date)
         END
            Eventlength,
         CASE
            WHEN f.enroll_status IN ('T', 'Cancelled', 'Did Not Attend')
                 AND f.book_amt < 0
            THEN
               (-1 * cd.list_price)
            ELSE
               cd.list_price
         END
            list_price,
         cd.ch_num,
         cd.course_ch,
         cd.md_num,
         cd.course_mod,
         cd.pl_num,
         cd.course_pl,
         cd.course_name,
         cd.course_code,
         a.ACCT_ID,
         a.acct_name,
         c.CUST_name,
         tdr.dim_year rev_year,
         tdr.dim_year || '-Qtr ' || tdr.dim_quarter rev_quarter,
         tdr.dim_year || '-' || tdr.dim_month rev_month,
         tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0')
            rev_month_num,
         tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0') rev_week,
         tdb.dim_year book_year,
         tdb.dim_year || '-Qtr ' || tdb.dim_quarter book_quarter,
         tdb.dim_year || '-' || tdb.dim_month book_month,
         tdb.dim_year || '-' || LPAD (tdb.dim_month_num, 2, '0')
            book_month_num,
         tdb.dim_year || '-' || LPAD (tdb.dim_week, 2, '0') book_week,
         CASE
            WHEN SUBSTR (keycode, 1, 1) BETWEEN '0' AND '9' THEN '1-10'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'A' AND 'F' THEN 'A-F'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'G' AND 'M' THEN 'G-M'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'N' AND 'S' THEN 'N-S'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'T' AND 'Z' THEN 'T-Z'
            ELSE 'NA'
         END
            keycode_category,
         SUBSTR (keycode, 1, 2) keycode_subcat,
         DECODE (UPPER (ed.country), 'CANADA', ed.province, ed.state) state,
         DECODE (UPPER (c.country), 'CANADA', c.province, c.state) cust_state,
         c.ZIPCODE cust_zip,
         f.sales_rep,
         TRUNC (rev_date) - TRUNC (book_date) Age,
         CASE
            WHEN     cd.CH_NUM = '20'
                 AND f.ENROLL_STATUS = 'Attended'
                 AND f.FEE_TYPE = 'Ons - Individual'
            THEN
               1
            ELSE
               0
         END
            ent_count,
         CASE WHEN cd.CH_NUM <> '20' AND f.book_amt > 0 THEN 1 ELSE 0 END
            public_enroll_count,
         CASE WHEN cd.CH_NUM <> '20' AND f.BOOK_AMT < 0 THEN 1 ELSE 0 END
            public_cancel_count,
         CASE WHEN cd.CH_NUM <> '20' AND f.BOOK_AMT = 0 THEN 1 ELSE 0 END
            public_guest_count
  FROM                     order_fact f
                        LEFT OUTER JOIN
                           event_dim ed
                        ON f.event_id = ed.event_id
                     INNER JOIN
                        time_dim tdr
                     ON TRUNC (f.rev_date) = tdr.dim_date
                  INNER JOIN
                     time_dim tdb
                  ON TRUNC (f.book_date) = tdb.dim_date
               LEFT OUTER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.OPS_COUNTRY = cd.COUNTRY
            LEFT OUTER JOIN
               cust_dim c
            ON f.cust_id = c.cust_id
         LEFT OUTER JOIN
            account_dim a
         ON c.ACCT_ID = a.acct_id
 WHERE   f.rev_date >= TO_DATE ('1/1/2003', 'mm/dd/yyyy')
         AND ( ( (cd.ch_num = '10'
                  OR (cd.ch_num IS NULL AND ed.event_type = 'Open Enrollment'))
                AND f.bill_status IS NOT NULL)
              OR ( (cd.CH_NUM = '20'
                    OR (cd.ch_num IS NULL AND ed.event_type = 'Onsite'))
                  AND NOT EXISTS (SELECT   1
                                    FROM   gk_sem_onsite
                                   WHERE   evxevenrollid = f.enroll_id))
              OR (ch_num = '00'))
UNION ALL
SELECT   s.sales_order_id,
         s.prod_num,
         s.cust_id,
         s.keycode,
         'Product',
         s.so_status,
         TRUNC (s.book_date),
         TRUNC (s.rev_date),
         s.book_amt,
         'USA',
         s.country,
         c.COUNTRY cust_country,
         s.record_type,
         'SPEL',
         '27518' event_zip,
         0,
         pd.list_price,
         pd.ch_num,
         pd.prod_channel,
         pd.md_num,
         pd.prod_modality,
         pd.pl_num,
         pd.prod_line,
         pd.prod_name,
         pd.prod_num,
         a.ACCT_ID,
         a.acct_name,
         c.CUST_NAME,
         tdr.dim_year rev_year,
         tdr.dim_year || '-Qtr ' || tdr.dim_quarter rev_quarter,
         tdr.dim_year || '-' || tdr.dim_month rev_month,
         tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0')
            rev_month_num,
         tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0') rev_week,
         tdb.dim_year book_year,
         tdb.dim_year || '-Qtr ' || tdb.dim_quarter book_quarter,
         tdb.dim_year || '-' || tdb.dim_month book_month,
         tdb.dim_year || '-' || LPAD (tdb.dim_month_num, 2, '0')
            book_month_num,
         tdb.dim_year || '-' || LPAD (tdb.dim_week, 2, '0') book_week,
         CASE
            WHEN SUBSTR (keycode, 1, 1) BETWEEN '0' AND '9' THEN '1-10'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'A' AND 'F' THEN 'A-F'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'G' AND 'M' THEN 'G-M'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'N' AND 'S' THEN 'N-S'
            WHEN SUBSTR (keycode, 1, 1) BETWEEN 'T' AND 'Z' THEN 'T-Z'
            ELSE 'NA'
         END
            keycode_category,
         SUBSTR (keycode, 1, 2) keycode_subcat,
         'SPEL' state,
         DECODE (UPPER (c.country), 'CANADA', c.province, c.state) cust_state,
         c.ZIPCODE cust_zip,
         s.sales_rep,
         TRUNC (rev_date) - TRUNC (book_date) Age,
         0 ent_count,
         quantity public_enroll_count,
         CASE WHEN s.SO_STATUS = 'Cancelled' THEN quantity ELSE 0 END
            public_cancel_count,
         0 public_guest_count
  FROM                  sales_order_fact s
                     INNER JOIN
                        time_dim tdb
                     ON TRUNC (s.book_date) = tdb.dim_date
                  INNER JOIN
                     product_dim pd
                  ON s.product_id = pd.product_id
               LEFT OUTER JOIN
                  time_dim tdr
               ON TRUNC (s.rev_date) = tdr.dim_date
            LEFT OUTER JOIN
               cust_dim c
            ON s.cust_id = c.cust_id
         LEFT OUTER JOIN
            account_dim a
         ON c.ACCT_ID = a.acct_id
 WHERE   s.record_type = 'SalesOrder'
         AND (s.rev_date IS NULL
              OR s.rev_date >= TO_DATE ('1/1/2003', 'mm/dd/yyyy'))
         AND s.SO_STATUS = 'Shipped';

COMMENT ON MATERIALIZED VIEW GKDW.GK_BOOKING_CUBE_MV IS 'snapshot table for snapshot GKDW.GK_BOOKING_CUBE_MV';

GRANT SELECT ON GKDW.GK_BOOKING_CUBE_MV TO DWHREAD;

