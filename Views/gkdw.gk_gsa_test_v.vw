DROP VIEW GKDW.GK_GSA_TEST_V;

/* Formatted on 29/01/2021 11:35:21 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GSA_TEST_V
(
   ACCT_NAME,
   GROUP_ACCT_NAME,
   ACCT_ID,
   EMAIL,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   PPCARD_ID,
   ENROLL_ID,
   BOOK_AMT,
   BOOK_DATE,
   FEE_TYPE,
   PAYMENT_METHOD,
   EVENT_ID,
   START_DATE,
   FACILITY_REGION_METRO,
   CITY,
   STATE,
   OB_REP_NAME
)
AS
   SELECT   acct_name,
            group_acct_name,
            acct_id,
            email,
            course_code,
            short_name,
            course_ch,
            course_mod,
            course_pl,
            ppcard_id,
            enroll_id,
            book_amt,
            book_date,
            fee_type,
            payment_method,
            event_id,
            start_date,
            facility_region_metro,
            city,
            state,
            ob_rep_name
     FROM   (SELECT   cd1.acct_name,
                      NVL (n.group_acct_name, cd1.acct_name) group_acct_name,
                      cd1.acct_id,
                      cd1.email,
                      c.course_code,
                      c.short_name,
                      c.course_ch,
                      c.course_mod,
                      c.course_pl,
                      f.ppcard_id,
                      f.enroll_id,
                      f.book_amt,
                      f.book_date,
                      f.fee_type,
                      f.payment_method,
                      ed.event_id,
                      ed.start_date,
                      ed.facility_region_metro,
                      cd1.city,
                      cd1.state,
                      f.ob_rep_name
               FROM                  cust_dim cd1
                                  INNER JOIN
                                     order_fact f
                                  ON cd1.cust_id = f.cust_id
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
                      LEFT OUTER JOIN
                         gk_account_groups_naics n
                      ON cd1.acct_id = n.acct_id
              WHERE   td.dim_year >= 2009 --   and td.dim_month_num between 8 and 12
                      AND f.enroll_status IN ('Confirmed', 'Attended')
                      AND EXISTS
                            (SELECT   1
                               FROM   cust_dim cd2
                              WHERE   cd1.acct_id = cd2.acct_id
                                      AND (   UPPER (cd2.email) LIKE '%.GOV'
                                           OR UPPER (cd2.email) LIKE '%.MIL'
                                           OR UPPER (cd2.email) LIKE '%.US'))
             UNION
             SELECT   cd1.acct_name,
                      NVL (n.group_acct_name, cd1.acct_name) group_acct_name,
                      cd1.acct_id,
                      cd1.email,
                      pd.prod_num,
                      pd.prod_name,
                      pd.prod_channel,
                      pd.prod_modality,
                      pd.prod_line,
                      f.ppcard_id,
                      f.sales_order_id,
                      f.book_amt,
                      f.book_date,
                      NULL,
                      f.payment_method,
                      NULL,
                      NULL,
                      f.record_type,
                      cd1.city,
                      cd1.state,
                      f.sales_rep
               FROM               cust_dim cd1
                               INNER JOIN
                                  sales_order_fact f
                               ON cd1.cust_id = f.cust_id
                            INNER JOIN
                               product_dim pd
                            ON f.product_id = pd.product_id
                         INNER JOIN
                            time_dim td
                         ON TRUNC (f.creation_date) = td.dim_date
                      LEFT OUTER JOIN
                         gk_account_groups_naics n
                      ON cd1.acct_id = n.acct_id
              WHERE   td.dim_year >= 2009 --   and td.dim_month_num between 8 and 12
                                         AND f.so_status != 'Cancelled'
                      AND EXISTS
                            (SELECT   1
                               FROM   cust_dim cd2
                              WHERE   cd1.acct_id = cd2.acct_id
                                      AND (   UPPER (cd2.email) LIKE '%.GOV'
                                           OR UPPER (cd2.email) LIKE '%.MIL'
                                           OR UPPER (cd2.email) LIKE '%.US')));


