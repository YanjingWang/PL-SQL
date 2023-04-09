DROP VIEW GKDW.GK_PARTNER_ORDERS_V;

/* Formatted on 29/01/2021 11:30:51 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PARTNER_ORDERS_V
(
   DIM_WEEK,
   PO_CREATE_METH,
   PO_ACTIVE,
   VENDOR_CODE,
   ORACLE_VENDOR_ID,
   ORACLE_VENDOR_SITE,
   EVENT_ID,
   EVENT_NAME,
   START_DATE,
   FACILITY_CODE,
   RESELLER_EVENT_ID,
   LOCATION_NAME,
   OPS_COUNTRY,
   ORG_ID,
   INV_ORG_ID,
   CURR_CODE,
   LE,
   MD_NUM,
   ROYALTY_FEE,
   COURSE_CODE,
   ACT,
   VPO_DESC,
   ENROLL_ID,
   ENROLL_STATUS,
   BOOK_DATE,
   CUST_NAME,
   ACCT_NAME,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   ZIPCODE
)
AS
   SELECT   td.dim_year || '-' || LPAD (td.dim_week, 2, '0') dim_week,
            pr.po_create_meth,
            pr.po_active,
            pv.vendor_code,
            pv.oracle_vendor_id,
            pv.oracle_vendor_site,
            ed.event_id,
            ed.event_name,
            ed.start_date,
            ed.facility_code,
            ed.reseller_event_id,
            ed.location_name,
            ed.ops_country,
            pv.org_id org_id,
            pv.inv_org_id inv_org_id,
            pv.payment_currency_code curr_code,
            pv.le,
            cd.md_num,
            CASE
               WHEN ed.ops_country = 'CANADA' THEN rl.ca_fee
               ELSE rl.us_fee
            END
               royalty_fee,
            cd.course_code,
            '00' || SUBSTR (course_code, 1, 4) act,
               course_group
            || '-'
            || cd.course_code
            || '-'
            || TO_CHAR (ed.start_date, 'mmddyy')
            || '-'
            || c.cust_name
            || '-'
            || CASE
                  WHEN ed.ops_country = 'CANADA' THEN rl.ca_fee
                  ELSE rl.us_fee
               END
            || '-EV:'
            || ed.event_id
            || '-EN:'
            || f.enroll_id
               vpo_desc,
            f.enroll_id enroll_id,
            f.enroll_status,
            TRUNC (f.book_date) book_date,
            c.cust_name,
            c.acct_name,
            c.address1,
            c.address2,
            c.city,
            c.state,
            c.zipcode
     FROM                        event_dim ed
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.country = cd.country
                           INNER JOIN
                              order_fact f
                           ON ed.event_id = f.event_id
                        INNER JOIN
                           time_dim td
                        ON CASE
                              WHEN cd.md_num IN ('10', '20', '41', '42')
                              THEN
                                 ed.start_date
                              ELSE
                                 f.book_date
                           END = td.dim_date
                     INNER JOIN
                        cust_dim c
                     ON f.cust_id = c.cust_id
                  INNER JOIN
                     gk_royalty_lookup rl
                  ON cd.course_code = rl.course_code
                     AND f.book_date BETWEEN rl.active_date
                                         AND  rl.inactive_date
               INNER JOIN
                  gk_partner_vendor pv
               ON TRIM (rl.vendor_code) = TRIM (pv.vendor_code)
                  AND ed.ops_country = pv.ops_country
            INNER JOIN
               gk_partner_royalty pr
            ON TRIM (pv.vendor_code) = TRIM (pr.vendor_code)
    WHERE       f.enroll_status != 'Cancelled' -- requested change by erica loring 6/5/09
            AND f.book_amt > 0
            AND CASE
                  WHEN ed.ops_country = 'CANADA' THEN rl.ca_fee
                  ELSE rl.us_fee
               END > 0
            AND cd.md_num NOT IN ('20', '42')
            AND NVL (f.keycode, 'NONE') NOT IN
                     ('ITIL2432',
                      'ITIL2437',
                      'WPROD',
                      'WSPEC',
                      'WCERTAP5',
                      'WCERTP4')
            AND NVL (UPPER (payment_method), 'NONE') != 'MICROSOFT SATV'
   UNION
   SELECT   td.dim_year || '-' || LPAD (td.dim_week, 2, '0') dim_week,
            pr.po_create_meth,
            pr.po_active,
            pv.vendor_code,
            pv.oracle_vendor_id,
            pv.oracle_vendor_site,
            ed.event_id,
            ed.event_name,
            ed.start_date,
            ed.facility_code,
            ed.reseller_event_id,
            ed.location_name,
            CASE
               WHEN c.country IN ('CA', 'CANADA') THEN 'CANADA'
               ELSE 'USA'
            END,
            pv.org_id org_id,
            pv.inv_org_id inv_org_id,
            pv.payment_currency_code curr_code,
            pv.le,
            cd.md_num,
            CASE
               WHEN UPPER (c.country) IN ('CA', 'CANADA') THEN rl.ca_fee
               ELSE rl.us_fee
            END
               royalty_fee,
            cd.course_code,
            '00' || SUBSTR (course_code, 1, 4) act,
               course_group
            || '-'
            || cd.course_code
            || '-'
            || TO_CHAR (ed.start_date, 'mmddyy')
            || '-'
            || c.cust_name
            || '-'
            || CASE
                  WHEN ed.ops_country = 'CANADA' THEN rl.ca_fee
                  ELSE rl.us_fee
               END
            || '-EV:'
            || ed.event_id
            || '-EN:'
            || f.enroll_id
               vpo_desc,
            f.enroll_id enroll_id,
            f.enroll_status,
            TRUNC (f.book_date) book_date,
            c.cust_name,
            c.acct_name,
            c.address1,
            c.address2,
            c.city,
            c.state,
            c.zipcode
     FROM                        event_dim ed
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.country = cd.country
                           INNER JOIN
                              order_fact f
                           ON ed.event_id = f.event_id
                        INNER JOIN
                           time_dim td
                        ON CASE
                              WHEN cd.md_num IN ('10', '20', '41', '42')
                              THEN
                                 ed.start_date
                              ELSE
                                 f.book_date
                           END = td.dim_date
                     INNER JOIN
                        cust_dim c
                     ON f.cust_id = c.cust_id
                  INNER JOIN
                     gk_royalty_lookup rl
                  ON cd.course_code = rl.course_code
                     AND f.book_date BETWEEN rl.active_date
                                         AND  rl.inactive_date
               INNER JOIN
                  gk_partner_vendor pv
               ON TRIM (rl.vendor_code) = TRIM (pv.vendor_code)
                  AND CASE
                        --WHEN cd.vendor_code = 'FMC' THEN ed.ops_country -- requested change by lindsey kanwasher 7/5/16
                     WHEN c.country IN ('CA', 'CANADA') THEN 'CANADA' --c.country
                        ELSE 'USA'
                     END = pv.ops_country
            INNER JOIN
               gk_partner_royalty pr
            ON TRIM (pv.vendor_code) = TRIM (pr.vendor_code)
    WHERE       f.enroll_status != 'Cancelled' -- requested change by erica loring 6/5/09
            AND f.book_amt > 0
            AND CASE
                  WHEN ed.ops_country = 'CANADA' THEN rl.ca_fee
                  ELSE rl.us_fee
               END > 0
            AND cd.md_num IN ('20', '42')
            AND NVL (f.keycode, 'NONE') NOT IN
                     ('ITIL2432',
                      'ITIL2437',
                      'WPROD',
                      'WSPEC',
                      'WCERTAP5',
                      'WCERTP4')
            AND NVL (UPPER (payment_method), 'NONE') != 'MICROSOFT SATV';


