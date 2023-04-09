DROP VIEW GKDW.TPS_2_OE_CH_MP_V;

/* Formatted on 29/01/2021 11:22:39 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.TPS_2_OE_CH_MP_V
(
   ENROLL_ID,
   KEYCODE,
   BOOK_DATE,
   START_DATE,
   ENROLL_DATE,
   EVENT_ID,
   BOOK_AMT,
   CURR_CODE,
   ORACLE_TRX_NUM,
   ACCT_NAME,
   ENROLL_STATUS,
   PARTNER_NAME,
   CHANNEL_MANAGER,
   COURSE_MOD,
   TERRITORY_TYPE,
   PL_NUM,
   COURSE_CODE,
   COURSE_NAME,
   PPCARD_ID,
   ZIPCODE,
   PROVINCE,
   OPS_COUNTRY
)
AS
     SELECT   f.enroll_id,
              f.keycode,
              f.book_date,
              ed.start_date,
              f.enroll_date,
              f.event_id,
              f.book_amt,
              f.curr_code,
              f.oracle_trx_num,
              a.acct_name,
              f.enroll_status,
              cp.partner_name,
              cp.channel_manager,
              cd.course_mod,
              gt.territory_type,
              cd.pl_num,
              cd.course_code,
              cd.course_name,
              f.ppcard_id,
              c.zipcode,
              c.province,
              ed.ops_country
       FROM                     order_fact f
                             INNER JOIN
                                event_dim ed
                             ON f.event_id = ed.event_id
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          cust_dim c
                       ON f.cust_id = c.cust_id
                    INNER JOIN
                       account_dim a
                    ON c.acct_id = a.acct_id
                 LEFT OUTER JOIN
                    gk_territory gt
                 ON c.zipcode BETWEEN gt.zip_start AND gt.zip_end
                    AND (gt.territory_type = 'OB' OR gt.territory_type IS NULL)
              INNER JOIN
                 gk_channel_partner cp
              ON f.keycode = cp.partner_key_code
      WHERE   cd.ch_num = '10'
              AND (   SUBSTR (f.keycode, 1, 2) IN ('C0', 'C1', 'MP')
                   OR f.keycode = 'BMJP09'
                   OR f.keycode = 'C099025')
              AND book_date >= '01-JAN-2014'
   ORDER BY   f.enroll_id;


