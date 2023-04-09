DROP MATERIALIZED VIEW GKDW.GK_OPEN_ENROLLMENT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_OPEN_ENROLLMENT_MV 
TABLESPACE GDWSML
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
/* Formatted on 29/01/2021 12:24:02 (QP5 v5.115.810.9015) */
SELECT   td2.dim_year book_year,
         td2.dim_year || '-Qtr ' || LPAD (td2.dim_quarter, 2, '0')
            book_quarter,
         td2.dim_year || '-Prd ' || LPAD (td2.dim_month_num, 2, '0')
            book_month_num,
         td2.dim_period_name book_period,
         f.book_date book_date,
         td2.sales_day_num book_day,
         td3.dim_year rev_year,
         td3.dim_year || '-Qtr ' || LPAD (td3.dim_quarter, 2, '0')
            rev_quarter,
         td3.dim_year || '-Prd ' || LPAD (td3.dim_month_num, 2, '0')
            rev_month_num,
         td3.dim_period_name rev_period,
         ed.start_date rev_date,
         td3.sales_day_num rev_day,
         f.enroll_id,
         f.enroll_status,
         f.event_id,
         f.cust_id,
         f.keycode,
         CASE
            WHEN f.attendee_type = 'Unlimited' AND f.book_amt = 0
            THEN
               NVL (ab.book_amt, 0)
            ELSE
               f.book_amt
         END
            book_amt,
         f.curr_code,
         CASE
            WHEN gop.po_num IS NOT NULL
            THEN
               gop.po_type
            WHEN gw.evxevenrollid IS NOT NULL
            THEN
               'Web Registration'
            WHEN f.registration_type IS NOT NULL
            THEN
               'Web Registration'
            WHEN cp.partner_key_code IS NOT NULL
            THEN
               'Channel Partner'
            WHEN p.osrprepay = 'T'
            THEN
               'OSR Prepay'
            WHEN NVL (ui1.department, ui2.department) = 'Enterprise'
                 AND NVL (ui1.region, ui2.region) IS NOT NULL
            THEN
                  NVL (ui1.department, ui2.department)
               || '-'
               || NVL (ui1.region, ui2.region)
            ELSE
               NVL (ui1.department, ui2.department)
         END
            department,
         f.fee_type,
         f.list_price,
         f.list_price
         - CASE
              WHEN f.attendee_type = 'Unlimited' AND f.book_amt = 0
              THEN
                 NVL (ab.book_amt, 0)
              ELSE
                 f.book_amt
           END
            disc_amt,
         ed.facility_region_metro,
         c.course_ch event_channel,
         c.course_mod event_modality,
         ed.event_prod_line,
         ed.course_code,
         ed.facility_code,
         SUBSTR (ed.ops_country, 1, 3) ops_country,
         fr.region facility_region,
         CASE
            WHEN f.ppcard_id IS NOT NULL THEN 'PREPAID REDEMPTION'
            ELSE 'INDIVIDUAL PURCHASE'
         END
            sale_type,
         UPPER (f.payment_method) payment_type,
         TRIM (UPPER (ad.acct_name)) acct_name,
         c.short_name,
         c.course_type,
         CASE
            WHEN c.pl_num = '09' AND NVL (c.itbt, 'F') = 'F'
            THEN
               'Business Training'
            WHEN territory_id BETWEEN '80' AND '89'
            THEN
               'MTA'
            WHEN ad.national_terr_id IN ('32', '73', '52', 'C5', 'C9')
            THEN
               'National Acct'
            ELSE
               m.region
         END
            sales_region,
         CASE
            WHEN c.pl_num = '09' AND NVL (c.itbt, 'F') = 'F'
            THEN
               bt.territory_id
               || CASE
                     WHEN bt.salesrep IS NOT NULL
                     THEN
                        ' (' || bt.salesrep || ')'
                  END
            WHEN territory_id BETWEEN '80' AND '89'
            THEN
               mt.territory_id
               || CASE
                     WHEN mt.salesrep IS NOT NULL
                     THEN
                        ' (' || mt.salesrep || ')'
                  END
            WHEN ad.national_terr_id = '32'
            THEN
               ad.national_terr_id || ' (Smith Primm)'
            WHEN ad.national_terr_id = '52'
            THEN
               ad.national_terr_id || ' (Carl Beardsworth)'
            WHEN ad.national_terr_id = '73'
            THEN
               ad.national_terr_id || ' (Kechia Mackey)'
            WHEN ad.national_terr_id = 'C5'
            THEN
               ad.national_terr_id || ' (Richard Bellet)'
            WHEN ad.national_terr_id = 'C9'
            THEN
               ad.national_terr_id || ' (Trina Brown)'
            ELSE
               m.territory
               || CASE
                     WHEN m.sales_rep IS NOT NULL
                     THEN
                        ' (' || m.sales_rep || ')'
                  END
         END
            sales_territory,
         CASE
            WHEN c.pl_num = '09' AND NVL (c.itbt, 'F') = 'F'
            THEN
               bt.territory_id
            WHEN territory_id BETWEEN '80' AND '89'
            THEN
               mt.territory_id
            WHEN ad.national_terr_id IN ('32', '73', '52', 'C5', 'C9')
            THEN
               ad.national_terr_id
            ELSE
               m.territory
         END
            territory_id,
         CASE
            WHEN c.pl_num = '09' AND NVL (c.itbt, 'F') = 'F'
            THEN
               'Abby Prescott'
            WHEN territory_id BETWEEN '80' AND '89'
            THEN
               mt.region_mgr
            WHEN ad.national_terr_id IN ('32', '73', '52')
            THEN
               'Heather Piper'
            WHEN ad.national_terr_id IN ('C5', 'C9')
            THEN
               'Roxanne Curd'
            ELSE
               m.region_mgr
         END
            region_mgr,
         CASE
            WHEN c.pl_num = '09' AND NVL (c.itbt, 'F') = 'F' THEN bt.salesrep
            WHEN territory_id BETWEEN '80' AND '89' THEN mt.salesrep
            WHEN ad.national_terr_id = '32' THEN 'Smith Primm'
            WHEN ad.national_terr_id = '52' THEN 'Carl Beardsworth'
            WHEN ad.national_terr_id = '73' THEN 'Kechia Mackey'
            WHEN ad.national_terr_id = 'C5' THEN 'Richard Bellet'
            WHEN ad.national_terr_id = 'C9' THEN 'Trina Brown'
            ELSE m.sales_rep
         END
            sales_rep,
         m.zipcode,
         cp.partner_name channel_partner,
         NVL (ui1.username, ui2.username) pos_person,
            ed.course_code
         || '-'
         || ed.facility_region_metro
         || '-'
         || TO_CHAR (ed.start_date, 'yyyymmdd')
         || ' ('
         || ed.event_id
         || ')'
            event_desc,
         cd.first_name || ' ' || cd.last_name || ' (' || f.enroll_id || ')'
            enrollee,
         CASE
            WHEN c.pl_num = '09' AND c.itbt = 'T' THEN 'ITBT'
            WHEN c.pl_num = '09' AND NVL (c.itbt, 'F') = 'F' THEN 'Non-ITBT'
            ELSE NULL
         END
            itbt_flag,
         CASE WHEN cp.partner_key_code IS NOT NULL THEN 'Y' ELSE 'N' END
            ch_flag,
         CASE
            WHEN ad.national_terr_id IN ('32', '73', '52', 'C5', 'C9')
            THEN
               'Y'
            ELSE
               'N'
         END
            nat_flag,
         CASE
            WHEN cd.mta_territory_id BETWEEN '80' AND '89' THEN 'Y'
            ELSE 'N'
         END
            mta_flag,
         CASE WHEN f.orig_enroll_id IS NOT NULL THEN 'Y' ELSE 'N' END
            reenroll_flag,
         CASE
            WHEN f.orig_enroll_id IS NULL
                 AND UPPER (f.payment_method) NOT IN
                          ('PREPAY CARD', '100% Credit')
                 AND UPPER (ui2.department) != 'Revenue Retention'
                 AND f.book_amt > 0
            THEN
               'Y'
            ELSE
               'N'
         END
            new_money_flag,
         f.source,
         ad.acct_id,
         CASE WHEN f.enroll_status != 'Cancelled' THEN 1 ELSE -1 END
            enroll_cnt,
         CASE
            WHEN f.book_amt > 0 THEN 'Invoice'
            WHEN f.book_amt < 0 THEN 'Credit'
         END
            order_type
  FROM                                                         order_fact f
                                                            INNER JOIN
                                                               event_dim ed
                                                            ON f.event_id =
                                                                  ed.event_id
                                                         INNER JOIN
                                                            course_dim c
                                                         ON ed.course_id =
                                                               c.course_id
                                                            AND ed.ops_country =
                                                                  c.country
                                                      INNER JOIN
                                                         cust_dim cd
                                                      ON f.cust_id =
                                                            cd.cust_id
                                                   INNER JOIN
                                                      account_dim ad
                                                   ON cd.acct_id = ad.acct_id
                                                INNER JOIN
                                                   time_dim td2
                                                ON f.book_date = td2.dim_date
                                             INNER JOIN
                                                time_dim td3
                                             ON ed.start_date = td3.dim_date
                                          LEFT OUTER JOIN
                                             gk_unlimited_avg_book_v ab
                                          ON f.cust_id = ab.cust_id
                                       LEFT OUTER JOIN
                                          slxdw.evxev_txfee t
                                       ON f.txfee_id = t.evxev_txfeeid
                                    LEFT OUTER JOIN
                                       slxdw.userinfo ui1
                                    ON f.salesperson = ui1.username
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui2
                                 ON f.create_user = ui2.userid
                              LEFT OUTER JOIN
                                 ppcard_dim p
                              ON f.ppcard_id = p.ppcard_id
                           LEFT OUTER JOIN
                              gk_facility_region_mv fr
                           ON ed.location_id = fr.evxfacilityid
                              AND ed.facility_region_metro =
                                    fr.facilityregionmetro
                        LEFT OUTER JOIN
                           market_dim m
                        ON CASE
                              WHEN cd.country = 'USA'
                              THEN
                                 SUBSTR (f.zip_code, 1, 5)
                              ELSE
                                 f.zip_code
                           END = m.zipcode
                     LEFT OUTER JOIN
                        gk_channel_partner cp
                     ON f.reg_code = cp.partner_key_code
                  LEFT OUTER JOIN
                     slxdw.gk_webenrollment gw
                  ON f.enroll_id = gw.evxevenrollid
               LEFT OUTER JOIN
                  gk_osr_po gop
               ON UPPER (TRIM (f.po_number)) = UPPER (gop.po_num)
            LEFT OUTER JOIN
               gk_territory bt
            ON bt.territory_type = 'BTA'
               AND f.zip_code BETWEEN bt.zip_start AND bt.zip_end
         LEFT OUTER JOIN
            gk_territory mt
         ON cd.mta_territory_id = mt.territory_id
 WHERE   td2.dim_year >= 2006 AND c.course_ch = 'INDIVIDUAL/PUBLIC'
         AND c.short_name NOT IN
                  ('0 CLASSROOM TRAINING FEE', 'RHCT SUCCESS PACK')
         AND c.course_code NOT IN ('097', '0CLASSFEE')
         AND (f.book_amt <> 0
              OR (f.attendee_type = 'Unlimited' AND f.book_amt = 0));

COMMENT ON MATERIALIZED VIEW GKDW.GK_OPEN_ENROLLMENT_MV IS 'snapshot table for snapshot GKDW.GK_OPEN_ENROLLMENT_MV';

GRANT SELECT ON GKDW.GK_OPEN_ENROLLMENT_MV TO DWHREAD;

