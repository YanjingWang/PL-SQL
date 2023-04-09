DROP VIEW GKDW.GK_GSA_AUDIT_DETAIL_V;

/* Formatted on 29/01/2021 11:35:29 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GSA_AUDIT_DETAIL_V
(
   DIM_YEAR,
   DIM_MONTH_NUM,
   ENROLL_ID,
   KEYCODE,
   ENROLL_STATUS,
   FEE_TYPE,
   SOURCE,
   PAYMENT_METHOD,
   ENROLL_TYPE,
   EVENT_ID,
   START_DATE,
   END_DATE,
   LOCATION_NAME,
   FACILITY_REGION_METRO,
   FAC_ADDRESS1,
   FAC_CITY,
   FAC_STATE,
   FAC_ZIPCODE,
   FAC_COUNTRY,
   COURSE_CODE,
   COURSE_NAME,
   SHORT_NAME,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   LIST_PRICE,
   GROUP_ACCT_NAME,
   ACCT_ID,
   ACCT_NAME,
   CUST_NAME,
   ADDRESS1,
   CITY,
   STATE,
   ZIPCODE,
   COUNTRY,
   EMAIL,
   WORKPHONE,
   PARTNER_NAME,
   PARTNER_TYPE,
   PPCARD_ID,
   CARD_TITLE,
   CARD_TYPE,
   ISSUED_DATE
)
AS
   SELECT   DISTINCT td.dim_year,
                     td.dim_month_num,
                     f.enroll_id,
                     f.keycode,
                     f.enroll_status,
                     f.fee_type,
                     f.source,
                     f.payment_method,
                     f.enroll_type,
                     ed.event_id,
                     ed.start_date,
                     ed.end_date,
                     ed.location_name,
                     ed.facility_region_metro,
                     ed.address1 fac_address1,
                     ed.city fac_city,
                     ed.state fac_state,
                     ed.zipcode fac_zipcode,
                     ed.country fac_country,
                     cd.course_code,
                     cd.course_name,
                     cd.short_name,
                     cd.course_ch,
                     cd.course_mod,
                     cd.course_pl,
                     cd.list_price,
                     NVL (r.group_acct_name, c.acct_name) group_acct_name,
                     c.acct_id,
                     c.acct_name,
                     c.cust_name,
                     c.address1,
                     c.city,
                     c.state,
                     c.zipcode,
                     c.country,
                     c.email,
                     c.workphone,
                     p.partner_name,
                     p.partner_type,
                     f.ppcard_id,
                     pd.card_title,
                     pd.card_type,
                     pd.issued_date
     FROM                        order_fact f
                              INNER JOIN
                                 event_dim ed
                              ON f.event_id = ed.event_id
                           INNER JOIN
                              course_dim cd
                           ON ed.course_id = cd.course_id
                              AND ed.ops_country = cd.country
                        INNER JOIN
                           cust_dim c
                        ON c.cust_id = f.cust_id
                     INNER JOIN
                        time_dim td
                     ON TRUNC (f.creation_date) = td.dim_date
                  LEFT OUTER JOIN
                     gk_account_groups_naics r
                  ON c.acct_id = r.acct_id
               LEFT OUTER JOIN
                  gk_channel_partner p
               ON f.keycode = p.partner_key_code
            LEFT OUTER JOIN
               ppcard_dim pd
            ON f.ppcard_id = pd.ppcard_id
    WHERE   f.creation_date >= '01-JAN-2010'
            AND f.ROWID = (SELECT   MAX (f2.ROWID)
                             FROM   order_fact f2
                            WHERE   f.enroll_id = f2.enroll_id)
   --and f.creation_date = (select max(f2.creation_date) from order_fact f2 where f.enroll_id = f2.enroll_id)
   --and f.fee_type not in ('Ons - Additional','Ons - Individual','Ons-Additional')
   --and f.book_amt > 0
   --and f.enroll_status in ('Confirmed','Attended')
   UNION
   SELECT   DISTINCT td.dim_year,
                     td.dim_month_num,
                     sf.sales_order_id,
                     sf.keycode,
                     sf.so_status,
                     NULL fee_type,
                     sf.source,
                     sf.payment_method,
                     NULL enroll_type,
                     pd.card_number,
                     pd.issued_date,
                     pd.expires_date,
                     pd.card_type,
                     'SPEL',
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     NULL,
                     prd.prod_num,
                     prd.prod_name,
                     prd.prod_name,
                     prd.prod_channel,
                     prd.prod_modality,
                     prd.prod_line,
                     prd.list_price,
                     NVL (r.group_acct_name, c.acct_name) group_acct_name,
                     c.acct_id,
                     c.acct_name,
                     c.cust_name,
                     c.address1,
                     c.city,
                     c.state,
                     c.zipcode,
                     c.country,
                     c.email,
                     c.workphone,
                     p.partner_name,
                     p.partner_type,
                     NULL,
                     NULL,
                     NULL,
                     NULL
     FROM                     sales_order_fact sf
                           LEFT OUTER JOIN
                              ppcard_dim pd
                           ON sf.ppcard_id = pd.ppcard_id
                        INNER JOIN
                           product_dim prd
                        ON sf.product_id = prd.product_id
                     INNER JOIN
                        cust_dim c
                     ON c.cust_id = sf.cust_id
                  INNER JOIN
                     time_dim td
                  ON TRUNC (sf.creation_date) = td.dim_date
               LEFT OUTER JOIN
                  gk_account_groups_naics r
               ON c.acct_id = r.acct_id
            LEFT OUTER JOIN
               gk_channel_partner p
            ON sf.keycode = p.partner_key_code
    WHERE   sf.creation_date >= '01-JAN-2010'
            AND sf.ROWID = (SELECT   MAX (sf2.ROWID)
                              FROM   sales_order_fact sf2
                             WHERE   sf2.sales_order_id = sf.sales_order_id)
--and sf.creation_date = (select max(sf2.creation_date) from sales_order_fact sf2 where sf2.sales_order_id = sf.sales_order_id)
--and sf.book_amt > 0
--and sf.cancel_date is null;


