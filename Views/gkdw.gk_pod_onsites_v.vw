DROP VIEW GKDW.GK_POD_ONSITES_V;

/* Formatted on 29/01/2021 11:30:20 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_POD_ONSITES_V
(
   ENROLL_ID,
   BOOK_DATE,
   CUST_NAME,
   ACCT_NAME,
   CITY,
   STATE,
   ZIPCODE,
   ENROLL_STATUS,
   COURSE_CODE,
   COURSE_NAME,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   BOOK_AMT,
   REV_DATE,
   START_DATE,
   PAYMENT_METHOD,
   NATIONAL_TERR_ID,
   OB_COMM_TYPE,
   CARD_SHORT_CODE,
   DIM_MONTH,
   DIM_YEAR,
   SALESPERSON,
   KEYCODE,
   TERRITORY_ID,
   FACILITY_REGION_METRO,
   EVENT_TYPE,
   ENROLL_TYPE,
   FEE_TYPE
)
AS
   SELECT   f.enroll_id,
            f.book_date,
            c.cust_name,
            ad.acct_name,
            ad.city,
            ad.state,
            CASE
               WHEN ad.country = 'USA' THEN SUBSTR (ad.zipcode, 1, 5)
               ELSE ad.zipcode
            END
               zipcode,
            f.enroll_status,
            cd.course_code,
            cd.course_name,
            cd.course_ch,
            cd.course_mod,
            cd.course_pl,
            f.book_amt,
            f.rev_date,
            ed.start_date,
            f.payment_method,
            national_terr_id,
            ob_comm_type,
            pd.card_short_code,
            td.dim_month,
            td.dim_year,
            f.salesperson,
            f.keycode,
            t.territory_id,
            ed.facility_region_metro,
            ed.event_type,
            f.enroll_type,
            f.fee_type
     FROM                           order_fact f
                                 INNER JOIN
                                    event_dim ed
                                 ON f.event_id = ed.event_id
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.ops_country = cd.country
                           INNER JOIN
                              time_dim td
                           ON f.book_date = td.dim_date
                        INNER JOIN
                           cust_dim c
                        ON f.cust_id = c.cust_id
                     INNER JOIN
                        account_dim ad
                     ON c.acct_id = ad.acct_id
                  LEFT OUTER JOIN
                     gk_channel_partner cp
                  ON f.keycode = cp.partner_key_code
               LEFT OUTER JOIN
                  gk_territory t
               ON c.zipcode BETWEEN t.zip_start AND t.zip_end
                  AND t.territory_type = 'OB'
            LEFT OUTER JOIN
               ppcard_dim pd
            ON f.ppcard_id = pd.ppcard_id
    WHERE       f.enroll_status != 'Cancelled'
            AND cd.ch_num = '20'             --   and cd.md_num in ('10','41')
            AND f.book_amt <> 0;


