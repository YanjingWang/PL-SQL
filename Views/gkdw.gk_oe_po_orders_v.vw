DROP VIEW GKDW.GK_OE_PO_ORDERS_V;

/* Formatted on 29/01/2021 11:31:44 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OE_PO_ORDERS_V
(
   ENROLL_ID,
   PO_NUMBER,
   BOOK_DATE,
   CURR_CODE,
   PAYMENT_METHOD,
   KEYCODE,
   ENROLL_STATUS,
   START_DATE,
   COURSE_NAME,
   CUST_NAME,
   ACCT_NAME,
   DIM_MONTH,
   DIM_YEAR,
   COURSE_MOD,
   COURSE_PL,
   NATIONAL_TERR_ID,
   OB_COMM_TYPE,
   PARTNER_NAME,
   TERRITORY_ID,
   REGION,
   SALESREP,
   REV_TERRITORY,
   SALESPERSON
)
AS
   SELECT   f.enroll_id,
            f.po_number,
            f.book_date,
            f.curr_code,
            f.payment_method,
            f.keycode,
            f.enroll_status,
            ed.start_date,
            cd.course_name,
            c.cust_name,
            c.acct_name,
            td.dim_month,
            td.dim_year,
            cd.course_mod,
            cd.course_pl,
            ad.national_terr_id,
            cp.ob_comm_type,
            cp.partner_name,
            t.territory_id,
            t.region,
            t.salesrep,
            CASE
               WHEN cp.ob_comm_type IN ('63', '9', '80', 'none')
               THEN
                  cp.ob_comm_type
               WHEN ad.national_terr_id IN
                          ('32', '52', '73', '79', 'C5', 'C9')
               THEN
                  ad.national_terr_id
               WHEN mta_territory_id IS NOT NULL
               THEN
                  mta_territory_id
               ELSE
                  t.territory_id
            END
               rev_territory,
            f.salesperson
     FROM                        order_fact f
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
    WHERE   f.enroll_status != 'Cancelled'
            AND (f.payment_method IN ('OSR Purchase Order', 'Purchase Order')
                 OR f.po_number IS NOT NULL)
            AND SUBSTR (f.po_number, 1, 3) NOT IN ('MOC', 'PSO')
            AND SUBSTR (f.po_number, 1, 2) NOT IN ('SO')
            AND cd.ch_num = '10'
            AND f.book_amt > 0;


