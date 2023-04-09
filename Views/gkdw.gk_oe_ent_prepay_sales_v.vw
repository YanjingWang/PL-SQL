DROP VIEW GKDW.GK_OE_ENT_PREPAY_SALES_V;

/* Formatted on 29/01/2021 11:31:49 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OE_ENT_PREPAY_SALES_V
(
   "Transaction ID",
   "Cust Account",
   "Cust Country",
   ZIPCODE,
   "Product Code",
   US_FARM,
   CA_FARM,
   KEYCODE,
   "Geography Name",
   "Sold to Account",
   "Selling Price",
   "Selling Price Currency",
   "Incentive Date",
   "Order Date",
   "Order Type",
   "Field Sales Rep Name",
   "Field Sales",
   "Inside Sales Rep Name",
   "Inside Sales",
   "CSD Rep Name",
   CSD,
   "Channel",
   "Product",
   "Delivery Format",
   "Event Type",
   "Payment Method",
   "Product Family",
   "Product Type",
   "Segment",
   "Student Name"
)
AS
   SELECT   DISTINCT
            f.enroll_id "Transaction ID",
            c.acct_id "Cust Account",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'CA' THEN 'CANADA'
               WHEN SUBSTR (c.country, 1, 2) = 'US' THEN 'USA'
               ELSE c.country
            END
               "Cust Country",
            c.zipcode,
            ed.course_code "Product Code",
            cd.us_farm,
            cd.ca_farm,
            rt.partner_key_code keycode,
            NULL "Geography Name",
            NVL (c.acct_name, f.acct_name) "Sold to Account",
            CASE
               WHEN f.keycode = 'C09901068P' THEN f.book_amt * 2
               ELSE f.book_amt
            END
               "Selling Price",
            f.curr_code "Selling Price Currency",
            TRUNC (f.book_date) "Incentive Date",
            TRUNC (f.book_date) "Order Date",
            'Sales' "Order Type",
            CASE
               WHEN SUBSTR (c.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 20, 40)
               THEN
                  rt.channel_manager
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE',
                              'MID MARKET/GEO',
                              'COMMERCIAL/GEO',
                              'COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL')
                    AND cd.ch_num = 20
               THEN
                  NVL (ui2.username, ui5.username)              --sl.FIELD_REP
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE',
                              'FEDERAL',
                              'LARGE ENTERPRISE',
                              'MID MARKET',
                              'COMMERCIAL')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui2.username, ui5.username)              --sl.FIELD_REP
               WHEN SUBSTR (c.country, 1, 2) IN ('US', 'CA')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND cd.ch_num IN (10, 40, 20)
                    AND rt.partner_key_code IS NULL
               THEN
                  COALESCE (ui2.username, ui5.username, ui4.username)
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NULL
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NVL (ui2.username, ui5.username)
               ELSE
                  NULL
            END
               "Field Sales Rep Name",
            CASE
               WHEN SUBSTR (c.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 20, 40)
               THEN
                  ui8.accountinguserid                    --rt.channel_manager
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE',
                              'MID MARKET/GEO',
                              'COMMERCIAL/GEO',
                              'COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL')
                    AND cd.ch_num = 20
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid)
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE',
                              'FEDERAL',
                              'LARGE ENTERPRISE',
                              'MID MARKET',
                              'COMMERCIAL')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid) -- sl.FIELD_REP_ID
               WHEN SUBSTR (c.country, 1, 2) IN ('US', 'CA')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND cd.ch_num IN (10, 40, 20)
                    AND rt.partner_key_code IS NULL
               THEN
                  COALESCE (ui2.accountinguserid,
                            ui5.accountinguserid,
                            ui4.accountinguserid)
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NULL
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 20, 40)
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid)
               ELSE
                  NULL
            END
               "Field Sales",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NULL
               WHEN     SUBSTR (c.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 20)
               THEN
                  ui9.username
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL',
                              'STRATEGIC ALLIANCE')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui.username, ui6.username) -- nvl(sl.ob_rep,ui5.username)
               WHEN     SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CHANNEL'
                    AND cd.ch_num IN (10, 40)
                    AND rt.partner_key_code IS NULL
               THEN
                  NVL (ui.username, ui6.username) -- nvl(sl.ob_rep,ui5.username)
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE', 'MID MARKET/GEO', 'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui4.username, ui.username) -- nvl(sl.ob_rep,ui5.username)
               WHEN     SUBSTR (c.country, 1, 2) = 'US'
                    AND NVL (qa.segment, sl.segment) IS NULL
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  CASE
                     WHEN GT.TERRITORY_ID LIKE 'NE%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'MA%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'MW%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'SC%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'SE%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'W%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NULL
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CANADA'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 40)
               THEN
                  NULL
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND qa.rep_3_id IS NOT NULL               -- Bell accounts
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        f.salesperson
                     WHEN cd.ch_num IN (10, 40)
                     THEN
                        CASE
                           WHEN UPPER (NVL (ui.username, ui6.username)) =
                                   'MARSHA SCOTT'
                           THEN
                              NVL (ui.username, ui6.username)
                           ELSE
                              'Audrey Perry'
                        END
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
                    AND qa.rep_3_id IS NULL
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        f.salesperson
                     WHEN cd.ch_num IN (10, 40) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        NVL (ui.username, ui6.username)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CANADA'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  COALESCE (ui.username, ui6.username, ui4.username)
               WHEN     SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CHANNEL'
                    AND cd.ch_num IN (10, 40)
                    AND rt.partner_key_code IS NULL
               THEN
                  NVL (ui.username, ui6.username)
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) =
                          'COMMERCIAL/GEO'
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui4.username, ui.username)
               WHEN     SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'INSIDE'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NVL (ui4.username, ui.username)
               -- sl.OB_REP
            WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                 AND NVL (qa.segment, sl.segment) IS NOT NULL
               THEN
                  NVL (ui.username, ui6.username)
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NULL
               THEN
                  'Anna  Tancredi'
               ELSE
                  NULL
            END
               "Inside Sales Rep Name",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NULL
               WHEN     SUBSTR (c.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 20)
               THEN
                  ui9.accountinguserid
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL',
                              'STRATEGIC ALLIANCE')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui.accountinguserid, ui6.accountinguserid) --sl.ob_rep_id
               WHEN     SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CHANNEL'
                    AND cd.ch_num IN (10, 40)
                    AND rt.partner_key_code IS NULL
               THEN
                  NVL (ui.accountinguserid, ui6.accountinguserid) -- nvl(sl.ob_rep,ui5.username)
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE', 'MID MARKET/GEO', 'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui4.accountinguserid, ui.accountinguserid)
               WHEN     SUBSTR (c.country, 1, 2) = 'US'
                    AND NVL (qa.segment, sl.segment) IS NULL
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  CASE
                     WHEN GT.TERRITORY_ID LIKE 'NE%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'MA%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'MW%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'SC%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'SE%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'W%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40)
               THEN
                  NULL
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CANADA'
                    AND RT.partner_KEY_CODE IS NOT NULL
                    AND cd.ch_num IN (10, 40)
               THEN
                  NULL
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND qa.rep_3_id IS NOT NULL     -- Bell CAD named accounts
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        ui7.accountinguserid
                     WHEN cd.ch_num IN (10, 40)
                     THEN
                        CASE
                           WHEN UPPER (NVL (ui.username, ui6.username)) =
                                   'MARSHA SCOTT'
                           THEN
                              NVL (ui.accountinguserid, ui6.accountinguserid)
                           ELSE
                              '002608'                          --Audrey Perry
                        END
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA' -- All other CAD Named accounts
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
                    AND qa.rep_3_id IS NULL
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        ui7.accountinguserid
                     WHEN cd.ch_num IN (10, 40) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        NVL (ui.accountinguserid, ui6.accountinguserid)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CANADA'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  COALESCE (ui.accountinguserid,
                            ui6.accountinguserid,
                            ui4.accountinguserid)
               WHEN     SUBSTR (c.country, 1, 2) = 'CA'
                    AND qa.rep_3_id IS NOT NULL
                    AND cd.ch_num IN (10, 40)
               THEN
                  ui7.accountinguserid
               WHEN     SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'CHANNEL'
                    AND cd.ch_num IN (10, 40)
                    AND RT.partner_KEY_CODE IS NULL
               THEN
                  NVL (ui.accountinguserid, ui6.accountinguserid) -- sl.OB_REP_ID
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) =
                          'COMMERCIAL/GEO'
                    AND cd.ch_num IN (10, 40)
               THEN
                  NVL (ui4.accountinguserid, ui.accountinguserid)
               WHEN     SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) = 'INSIDE'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NVL (ui4.accountinguserid, ui.accountinguserid) -- sl.OB_REP_ID
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NOT NULL
               THEN
                  NVL (ui.accountinguserid, ui6.accountinguserid)
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NULL
               THEN
                  '002219'                                 -- 'Anna  Tancredi'
               ELSE
                  NULL
            END
               "Inside Sales",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (NVL (qa.segment, sl.segment), '0')) NOT IN
                             ('0', 'INSIDE')
                    AND cd.ch_num = 20
                    AND course_pl IN
                             ('BUSINESS TRAINING',
                              'LEADERSHIP AND BUSINESS SOLUTIONS')
               THEN
                  ui3.username                                  -- qc.rep_4_id
               ELSE
                  NULL
            END
               "CSD Rep Name",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (NVL (qa.segment, sl.segment), '0')) NOT IN
                             ('0', 'INSIDE')
                    AND cd.ch_num = 20
                    AND course_pl IN
                             ('BUSINESS TRAINING',
                              'LEADERSHIP AND BUSINESS SOLUTIONS')
               THEN
                  ui3.accountinguserid                         --  qc.rep_4_id
               ELSE
                  NULL
            END
               "CSD",
            CASE
               WHEN cd.ch_num = '20' THEN 'Enterprise'
               WHEN cd.ch_num IN ('10', '40') THEN 'Open Enrollment'
               WHEN cd.ch_num IS NULL THEN NULL
            END
               "Channel",
            cd.Course_name "Product",
            CASE
               WHEN SUBSTR (ed.Course_code, -1, 1) IN
                          ('N', 'C', 'G', 'H', 'D', 'I')
               THEN
                  'Classroom'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('V', 'L', 'Y', 'U')
               THEN
                  'Virtual'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('Z')
               THEN
                  'Virtual Fit'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('S', 'W', 'E', 'P')
               THEN
                  'Digital'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('A')
               THEN
                  'Digital'
            END
               "Delivery Format",
            ed.event_type "Event Type",
            NVL (f.payment_method, ft.payment_method) "Payment Method",
            cd.course_pl "Product Family",
            'Class' "Product Type",
            COALESCE (qa.segment, sl.segment, gt.region) "Segment",
            f.cust_first_name || ' ' || f.cust_last_name "Student Name"
     FROM                                                            order_fact f
                                                                  INNER JOIN
                                                                     (SELECT   DISTINCT
                                                                               enroll_id,
                                                                               payment_method
                                                                        FROM   order_fact
                                                                       WHERE   bill_status <>
                                                                                  'Cancelled')
                                                                     ft
                                                                  ON f.enroll_id =
                                                                        ft.enroll_id
                                                               INNER JOIN
                                                                  cust_dim c
                                                               ON f.cust_id =
                                                                     c.cust_id
                                                            --(select contactid cust_id,accountid acct_id,account acct_name,upper(adr.country) country,adr.postalcode zipcode from slxdw.contact ct
                                                            --inner join slxdw.address adr on ct.addressid = adr.addressid) c ON f.cust_id = c.cust_id
                                                            INNER JOIN
                                                               event_dim ed
                                                            ON f.event_id =
                                                                  ed.event_id
                                                         INNER JOIN
                                                            course_dim cd
                                                         ON ed.course_id =
                                                               cd.course_id
                                                            AND ed.ops_country =
                                                                  cd.country
                                                      LEFT OUTER JOIN
                                                         evxev_txfee@slx tf
                                                      ON f.txfee_id =
                                                            tf.EVXEV_TXfeereverseid
                                                   LEFT OUTER JOIN
                                                      (SELECT   accountid,
                                                                ob_national_rep_id,
                                                                ob_rep_id,
                                                                ent_national_rep_id,
                                                                ent_inside_rep_id,
                                                                gk_segment
                                                                   segment,
                                                                rep_4_id,
                                                                rep_3_id
                                                         FROM   qg_account@slx)
                                                      qa
                                                   ON c.acct_id =
                                                         qa.accountid
                                                LEFT OUTER JOIN
                                                   GK_ACCOUNT_SEGMENTS_MV sl
                                                ON c.acct_id = sl.accountid
                                             LEFT OUTER JOIN
                                                gk_territory gt
                                             ON c.zipcode BETWEEN gt.zip_start
                                                              AND  gt.zip_end
                                                AND SUBSTR (c.country, 1, 2) IN
                                                         ('US', 'CA')
                                          LEFT OUTER JOIN
                                             userinfo@slx ui
                                          ON ui.userid = qa.ob_rep_id
                                       LEFT OUTER JOIN
                                          userinfo@slx ui6
                                       ON ui6.userid = sl.ob_rep_id
                                    LEFT OUTER JOIN
                                       userinfo@slx ui2
                                    ON ui2.userid = qa.ent_national_rep_id
                                 LEFT OUTER JOIN
                                    userinfo@slx ui5
                                 ON ui5.userid = sl.field_rep_id
                              LEFT OUTER JOIN
                                 userinfo@slx ui3
                              ON ui3.userid = qa.rep_4_id
                           LEFT OUTER JOIN
                              userinfo@slx ui4
                           ON ui4.userid = gt.userid
                        LEFT OUTER JOIN
                           userinfo@slx ui7
                        ON f.salesperson = ui7.username
                     LEFT OUTER JOIN
                        GK_CHANNEL_PARTNER rt
                     ON rt.partner_key_code = f.keycode      -- GK_REP_TAGGING
                  LEFT OUTER JOIN
                     userinfo@slx ui8
                  ON rt.channel_manager = ui8.username
               LEFT OUTER JOIN
                  gk_territory gtt
               ON REPLACE (gtt.territory_id, CHR (32), '') = rt.ob_comm_type
            LEFT OUTER JOIN
               userinfo@slx ui9
            ON ui9.userid = gtt.userid
    WHERE   TO_CHAR (f.book_date, 'mm/yyyy') =
               TO_CHAR (TRUNC (SYSDATE), 'mm/yyyy')
            AND f.book_Amt <> '0'
            AND ch_num IN (10, 20, 40)
            AND ( (f.bill_status = 'Cancelled'
                   AND evxev_txfeereverseid IS NOT NULL)
                 OR f.bill_status <> 'Cancelled')
   --  and f.enroll_id = 'QGKID0A0RJAS'
   UNION
   SELECT   DISTINCT
            et.evxevenrollid "Transaction ID",
            c2.acct_id "Cust Account",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
               THEN
                  'CANADA'
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'US'
               THEN
                  'USA'
               ELSE
                  COALESCE (c2.country, f1.cust_country, f1.acct_country)
            END
               cust_country,
            COALESCE (c2.zipcode, f1.cust_zipcode, f1.acct_zipcode) zipcode,
            et.coursecode "Product Code",
            cd.us_farm,
            cd.ca_farm,
            rt.partner_key_code keycode,
            NULL "Geography Name",
            NVL (c2.acct_name, et.account) "Sold to Account",
            CASE
               WHEN F1.KEYCODE = 'C09901068P'
               THEN
                  et.actual_extended_amount * 2
               ELSE
                  et.actual_extended_amount
            END
               "Selling Price",
            et.CURRENCYTYPE "Selling Price Currency",
            TRUNC (et.createdate) "Incentive Date",
            TRUNC (et.createdate) "Order Date",
            'Sales' "Order Type",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) IN
                          ('CA', 'US')
                    AND UPPER (COALESCE (q.segment, sl.segment, gt2.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 20, 40)
               THEN
                  rt.channel_manager
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'US'
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('INSIDE',
                              'MID MARKET/GEO',
                              'COMMERCIAL/GEO',
                              'COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL')
                    AND cd.ch_num = 20
               THEN
                  NVL (ui2.username, ui5.username)              --sl.FIELD_REP
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NVL (ui2.username, ui5.username)
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) IN
                          ('US', 'CA')
                    AND UPPER (COALESCE (q.segment, sl.segment, gt2.region)) =
                          'CHANNEL'
                    AND cd.ch_num IN (10, 40, 20)
                    AND rt.partner_key_code IS NULL
               THEN
                  COALESCE (ui2.username, ui5.username, ui4.username)
               ELSE
                  NULL
            END
               "Field Sales Rep Name",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) IN
                          ('CA', 'US')
                    AND UPPER (COALESCE (q.segment, sl.segment, gt2.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
                    AND cd.ch_num IN (10, 20, 40)
               THEN
                  ui8.accountinguserid                         -- rt.field_rep
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'US'
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('INSIDE',
                              'MID MARKET/GEO',
                              'COMMERCIAL/GEO',
                              'COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL')
                    AND cd.ch_num = 20
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid)
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
                    AND cd.ch_num IN (10, 20, 40)
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid) -- sl.FIELD_REP_ID
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) IN
                          ('US', 'CA')
                    AND UPPER (COALESCE (q.segment, sl.segment, gt2.region)) =
                          'CHANNEL'
                    AND cd.ch_num IN (10, 20, 40)
                    AND rt.partner_key_code IS NULL
               THEN
                  COALESCE (ui2.accountinguserid,
                            ui5.accountinguserid,
                            ui4.accountinguserid)           -- sl.FIELD_REP_ID
               ELSE
                  NULL
            END
               "Field Sales",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'US'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NULL
               WHEN     SUBSTR (
                           COALESCE (c2.country,
                                     f1.cust_country,
                                     f1.acct_country),
                           1,
                           2
                        ) = 'US'
                    AND NVL (q.segment, sl.segment) IS NULL
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  CASE
                     WHEN GT2.TERRITORY_ID LIKE 'NE%'
                     THEN
                        NVL (GT2.SALESREP, ui.username)
                     WHEN GT2.TERRITORY_ID LIKE 'MA%'
                     THEN
                        NVL (GT2.SALESREP, ui.username)
                     WHEN GT2.TERRITORY_ID LIKE 'MW%'
                     THEN
                        NVL (GT2.SALESREP, ui.username)
                     WHEN GT2.TERRITORY_ID LIKE 'SC%'
                     THEN
                        NVL (GT2.SALESREP, ui.username)
                     WHEN GT2.TERRITORY_ID LIKE 'SE%'
                     THEN
                        NVL (GT2.SALESREP, ui.username)
                     WHEN GT2.TERRITORY_ID LIKE 'W%'
                     THEN
                        NVL (GT2.SALESREP, ui.username)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND q.rep_3_id IS NOT NULL                -- Bell accounts
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f1.salesperson =
                                NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        f1.salesperson
                     WHEN cd.ch_num IN (10, 40)
                     THEN
                        CASE
                           WHEN UPPER (NVL (ui.username, ui6.username)) =
                                   'MARSHA SCOTT'
                           THEN
                              NVL (ui.username, ui6.username)
                           ELSE
                              'Audrey Perry'
                        END
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
                    AND q.rep_3_id IS NULL
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f1.salesperson =
                                NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        f1.salesperson
                     WHEN cd.ch_num IN (10, 40) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        NVL (ui.username, ui6.username)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (COALESCE (q.segment, sl.segment, gt2.region)) =
                          'CANADA'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  COALESCE (ui.username, ui6.username, ui4.username)
               WHEN     SUBSTR (
                           COALESCE (c2.country,
                                     f1.cust_country,
                                     f1.acct_country),
                           1,
                           2
                        ) = 'CA'
                    AND UPPER (NVL (q.segment, sl.segment)) = 'INSIDE'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NVL (ui4.username, ui.username)
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) NOT IN
                          ('US', 'CA')
                    AND NVL (q.segment, sl.segment) IS NOT NULL
               THEN
                  NVL (ui.username, ui6.username)
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) NOT IN
                          ('US', 'CA')
                    AND NVL (q.segment, sl.segment) IS NULL
               THEN
                  'Anna  Tancredi'
               ELSE
                  NULL
            END
               "Inside Sales Rep name",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'US'
                    AND ( (cd.us_farm = 'Y' AND cd.ca_farm = 'Y')
                         OR cd.course_pl = 'MICROSOFT APPS')
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NULL
               WHEN     SUBSTR (
                           COALESCE (c2.country,
                                     f1.cust_country,
                                     f1.acct_country),
                           1,
                           2
                        ) = 'US'
                    AND NVL (q.segment, sl.segment) IS NULL
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  CASE
                     WHEN GT2.TERRITORY_ID LIKE 'NE%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT2.TERRITORY_ID LIKE 'MA%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT2.TERRITORY_ID LIKE 'MW%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT2.TERRITORY_ID LIKE 'SC%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT2.TERRITORY_ID LIKE 'SE%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT2.TERRITORY_ID LIKE 'W%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND q.rep_3_id IS NOT NULL      -- Bell CAD named accounts
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f1.salesperson =
                                NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        ui7.accountinguserid
                     WHEN cd.ch_num IN (10, 40)
                     THEN
                        CASE
                           WHEN UPPER (NVL (ui.username, ui6.username)) =
                                   'MARSHA SCOTT'
                           THEN
                              NVL (ui.accountinguserid, ui6.accountinguserid)
                           ELSE
                              '002608'                          --Audrey Perry
                        END
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'                   -- All other CAD Named accounts
                    AND UPPER (NVL (q.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
                    AND q.rep_3_id IS NULL
               THEN
                  CASE
                     WHEN cd.ch_num = 20
                          AND f1.salesperson =
                                NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        ui7.accountinguserid
                     WHEN cd.ch_num IN (10, 40) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                     THEN
                        NVL (ui.accountinguserid, ui6.accountinguserid)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (COALESCE (q.segment, sl.segment, gt2.region)) =
                          'CANADA'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  COALESCE (ui.accountinguserid,
                            ui6.accountinguserid,
                            ui4.accountinguserid)
               WHEN     SUBSTR (
                           COALESCE (c2.country,
                                     f1.cust_country,
                                     f1.acct_country),
                           1,
                           2
                        ) = 'CA'
                    AND UPPER (NVL (q.segment, sl.segment)) = 'INSIDE'
                    AND cd.ch_num IN (10, 40, 20)
               THEN
                  NVL (ui4.accountinguserid, ui.accountinguserid) -- sl.OB_REP_ID
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) NOT IN
                          ('US', 'CA')
                    AND NVL (q.segment, sl.segment) IS NOT NULL
               THEN
                  NVL (ui.accountinguserid, ui6.accountinguserid)
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) NOT IN
                          ('US', 'CA')
                    AND NVL (q.segment, sl.segment) IS NULL
               THEN
                  '002219'                                 -- 'Anna  Tancredi'
               ELSE
                  NULL
            END
               "Inside Sales",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (NVL (NVL (q.segment, sl.segment), '0')) NOT IN
                             ('0', 'INSIDE')
                    AND cd.ch_num = 20
                    AND course_pl IN
                             ('BUSINESS TRAINING',
                              'LEADERSHIP AND BUSINESS SOLUTIONS')
               THEN
                  ui3.username                                  -- qc.rep_4_id
               ELSE
                  NULL
            END
               "CSD_rep_name",
            CASE
               WHEN SUBSTR (
                       COALESCE (c2.country,
                                 f1.cust_country,
                                 f1.acct_country),
                       1,
                       2
                    ) = 'CA'
                    AND UPPER (NVL (NVL (q.segment, sl.segment), '0')) NOT IN
                             ('0', 'INSIDE')
                    AND cd.ch_num = 20
                    AND course_pl IN
                             ('BUSINESS TRAINING',
                              'LEADERSHIP AND BUSINESS SOLUTIONS')
               THEN
                  ui3.accountinguserid                         --  qc.rep_4_id
               ELSE
                  NULL
            END
               "CSD",
            CASE
               WHEN cd.ch_num = '20' THEN 'Enterprise'
               ELSE 'Open Enrollment'
            END
               "Channel",
            cd.Course_name "Product",
            CASE
               WHEN SUBSTR (ed.Course_code, -1, 1) IN
                          ('N', 'C', 'G', 'H', 'D', 'I')
               THEN
                  'Classroom'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('V', 'L', 'Y', 'U')
               THEN
                  'Virtual'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('Z')
               THEN
                  'Virtual Fit'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('S', 'W', 'E', 'P')
               THEN
                  'Digital'
               WHEN SUBSTR (ed.Course_code, -1, 1) IN ('A')
               THEN
                  'Digital'
            END
               "Delivery Format",
            ed.event_type "Event Type",
            CASE
               WHEN et.ponumber IS NOT NULL THEN 'Purchase Order'
               WHEN et.evxppcardid IS NOT NULL THEN 'Prepay Card'
               ELSE ebp."METHOD"
            END
               "Payment Method",
            cd.course_pl "Product Family",
            'Class' "Product Type",
            COALESCE (q.segment, sl.segment, gt2.region) "Segment",
            NVL (f1.cust_first_name || ' ' || f1.cust_last_name,
                 et.Attendee_name)
               "Student Name"
     FROM                                                            ent_trans_bookings@slx et
                                                                  INNER JOIN
                                                                     cust_dim c2
                                                                  ON et.contactid =
                                                                        c2.cust_id
                                                               INNER JOIN
                                                                  event_dim ed
                                                               ON et.evxeventid =
                                                                     ed.event_id
                                                            INNER JOIN
                                                               ORDER_FACT F1
                                                            ON F1.ENROLL_ID =
                                                                  ET.EVXEVENROLLID
                                                         INNER JOIN
                                                            course_dim cd
                                                         ON ed.course_id =
                                                               cd.course_id
                                                            AND CASE
                                                                  WHEN ed.ops_country IN
                                                                             ('CA',
                                                                              'CANADA')
                                                                  THEN
                                                                     'CANADA'
                                                                  ELSE
                                                                     'USA'
                                                               END =
                                                                  cd.country
                                                      INNER JOIN
                                                         SLXDW.evxev_txfee etf
                                                      ON etf.evxevenrollid =
                                                            et.evxevenrollid
                                                   INNER JOIN
                                                      SLXDW.evxevticket etk
                                                   ON etf.evxevticketid =
                                                         etk.evxevticketid
                                                INNER JOIN
                                                   SLXDW.evxbillpayment ebp
                                                ON etf.EVXBILLINGID =
                                                      ebp.EVXBILLINGID --and nvl(etf.evxbillingid,'0') <> '0'
                                             LEFT OUTER JOIN
                                                (SELECT   accountid,
                                                          ob_national_rep_id,
                                                          ob_rep_id,
                                                          ent_national_rep_id,
                                                          ent_inside_rep_id,
                                                          gk_segment segment,
                                                          rep_3_id,
                                                          rep_4_id
                                                   FROM   qg_account@slx) q
                                             ON c2.acct_id = q.accountid
                                          LEFT OUTER JOIN
                                             GK_ACCOUNT_SEGMENTS_MV sl
                                          ON c2.acct_id = sl.accountid
                                       LEFT OUTER JOIN
                                          gk_territory gt2
                                       ON COALESCE (c2.zipcode,
                                                    f1.cust_zipcode,
                                                    f1.acct_zipcode) BETWEEN gt2.zip_start
                                                                         AND  gt2.zip_end
                                          AND SUBSTR (
                                                COALESCE (c2.country,
                                                          f1.cust_country,
                                                          f1.acct_country),
                                                1,
                                                2
                                             ) IN
                                                   ('US', 'CA')
                                    LEFT OUTER JOIN
                                       userinfo@slx ui
                                    ON ui.userid = q.ob_rep_id
                                 LEFT OUTER JOIN
                                    userinfo@slx ui6
                                 ON ui6.userid = sl.ob_rep_id
                              LEFT OUTER JOIN
                                 userinfo@slx ui2
                              ON ui2.userid = q.ent_national_rep_id
                           LEFT OUTER JOIN
                              userinfo@slx ui5
                           ON ui5.userid = sl.field_rep_id
                        LEFT OUTER JOIN
                           userinfo@slx ui3
                        ON ui3.userid = q.rep_4_id
                     LEFT OUTER JOIN
                        userinfo@slx ui4
                     ON ui4.userid = gt2.userid
                  LEFT OUTER JOIN
                     userinfo@slx ui7
                  ON f1.salesperson = ui7.username
               LEFT OUTER JOIN
                  GK_CHANNEL_PARTNER rt
               ON rt.partner_key_code = f1.keycode           -- GK_REP_TAGGING
            LEFT OUTER JOIN
               userinfo@slx ui8
            ON rt.channel_manager = ui8.username
    WHERE   TO_CHAR (et.createdate, 'mm/yyyy') =
               TO_CHAR (TRUNC (SYSDATE), 'mm/yyyy')
            AND cd.ch_num IN (10, 20)
   UNION
   SELECT   DISTINCT
            epp.evxppcardid "Transaction ID",
            c.acct_id "Cust Account",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'CA' THEN 'CANADA'
               WHEN SUBSTR (c.country, 1, 2) = 'US' THEN 'USA'
               ELSE c.country
            END
               "Cust Country",
            c.zipcode,
            sf.prod_num "Product Code",
            NULL us_farm,
            NULL cd_farm,
            rt.partner_key_code keycode,
            NULL "Geography Name",
            c.acct_name "Sold to Account",
            CASE
               WHEN sf.keycode = 'C09901068P' THEN sf.book_amt * 2
               ELSE sf.book_amt
            END
               "Selling Price",
            sf.curr_code "Selling Price Currency",
            NVL (sf.book_date, creation_date) "Incentive Date",
            NVL (sf.book_date, creation_date) "Order Date",
            'Sales' "Order Type",                                 --c.acct_id,
            CASE
               WHEN SUBSTR (C.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
               THEN
                  rt.channel_manager
               WHEN SUBSTR (C.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE',
                              'MID MARKET/GEO',
                              'COMMERCIAL/GEO',
                              'COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL')
               THEN
                  NVL (ui2.username, ui5.username)
               WHEN SUBSTR (C.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
               THEN
                  NVL (ui2.username, ui5.username)
               WHEN SUBSTR (C.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NULL
               THEN
                  COALESCE (ui2.username, ui5.username, ui4.username)
               ELSE
                  NULL
            END
               "Field Sales Rep Name",                      --GT.TERRITORY_ID,
            CASE
               WHEN SUBSTR (C.country, 1, 2) IN ('CA', 'US')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NOT NULL
               THEN
                  ui8.accountinguserid                    --rt.channel_manager
               WHEN SUBSTR (C.country, 1, 2) = 'US'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('INSIDE',
                              'MID MARKET/GEO',
                              'COMMERCIAL/GEO',
                              'COMMERCIAL',
                              'MID MARKET',
                              'LARGE ENTERPRISE',
                              'FEDERAL')
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid)
               WHEN SUBSTR (C.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT',
                              'LARGE ENTERPRISE',
                              'COMMERCIAL/GEO')
               THEN
                  NVL (ui2.accountinguserid, ui5.accountinguserid)
               WHEN SUBSTR (C.country, 1, 2) IN ('US', 'CA')
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CHANNEL'
                    AND rt.partner_key_code IS NULL
               THEN
                  COALESCE (ui2.accountinguserid,
                            ui5.accountinguserid,
                            ui4.username)
               ELSE
                  NULL
            END
               "Field Sales",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND NVL (qa.segment, sl.segment) IS NULL
               THEN
                  CASE
                     WHEN GT.TERRITORY_ID LIKE 'NE%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'MA%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'MW%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'SC%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'SE%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     WHEN GT.TERRITORY_ID LIKE 'W%'
                     THEN
                        NVL (GT.SALESREP, ui.username)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND qa.rep_3_id IS NOT NULL               -- Bell accounts
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
               THEN
                  CASE WHEN sf.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                                                                            THEN sf.salesperson ELSE NULL END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
                    AND qa.rep_3_id IS NULL
               THEN
                  CASE WHEN sf.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                                                                            THEN sf.salesperson ELSE NULL END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CANADA'
               THEN
                  COALESCE (ui.username, ui6.username, ui4.username)
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'INSIDE'
               THEN
                  NVL (ui4.username, ui.username)
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NOT NULL
               THEN
                  NVL (ui.username, ui6.username)
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NULL
               THEN
                  'Anna Tancredi'
               ELSE
                  NULL
            END
               "Inside Sales Rep Name",
            CASE
               WHEN SUBSTR (c.country, 1, 2) = 'US'
                    AND NVL (qa.segment, sl.segment) IS NULL
               THEN
                  CASE
                     WHEN GT.TERRITORY_ID LIKE 'NE%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'MA%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'MW%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'SC%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'SE%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     WHEN GT.TERRITORY_ID LIKE 'W%'
                     THEN
                        NVL (ui4.accountinguserid, ui.accountinguserid)
                     ELSE
                        NULL
                  END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND qa.rep_3_id IS NOT NULL               -- Bell accounts
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
               THEN
                  CASE WHEN sf.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                                                                            THEN ui7.accountinguserid ELSE NULL END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND UPPER (NVL (qa.segment, sl.segment)) IN
                             ('GOVERNMENT', 'LARGE ENTERPRISE')
                    AND qa.rep_3_id IS NULL
               THEN
                  CASE WHEN sf.salesperson = NVL (ui.username, ui6.username) /*and upper(nvl(ui.title,ui6.title)) = 'ACCOUNT MANAGER'*/
                                                                            THEN ui7.accountinguserid ELSE NULL END
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND sf.ppcard_id IS NOT NULL
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'CANADA'
               THEN
                  COALESCE (ui.accountinguserid,
                            ui6.accountinguserid,
                            ui4.accountinguserid)
               WHEN SUBSTR (c.country, 1, 2) = 'CA'
                    AND sf.ppcard_id IS NOT NULL
                    AND UPPER (COALESCE (qa.segment, sl.segment, gt.region)) =
                          'INSIDE'
               THEN
                  NVL (ui4.accountinguserid, ui.accountinguserid)
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NOT NULL
               THEN
                  NVL (ui.accountinguserid, ui6.accountinguserid)
               WHEN SUBSTR (c.country, 1, 2) NOT IN ('US', 'CA')
                    AND NVL (qa.segment, sl.segment) IS NULL
               THEN
                  '002219'                                  --'Anna  Tancredi'
               ELSE
                  NULL
            END
               "Inside Sales",
            NULL "CSD_rep_name",
            NULL "CSD",
            'Prepay' "Channel",
            NVL (epp.cardtitle, p.prod_name) "Product",
            'Prepay' "Delivery Format",
            'Prepay' "Event Type",
            sf.payment_method "Payment Method",
            'Prepay' "Product Family",
            'Prepay Card' "Product Type",
            COALESCE (qa.segment, sl.segment, gt.region) "Segment",
            'Prepay' "Student Name"
     FROM                                                sales_order_fact sf
                                                      LEFT JOIN
                                                         slxdw.evxppcard epp
                                                      ON sf.sales_order_id =
                                                            epp.evxsoid
                                                   LEFT JOIN
                                                      product_dim p
                                                   ON sf.product_id =
                                                         p.product_id
                                                LEFT JOIN
                                                   cust_dim c
                                                ON sf.cust_id = c.cust_id
                                             LEFT OUTER JOIN
                                                (SELECT   accountid,
                                                          ob_national_rep_id,
                                                          ob_rep_id,
                                                          ent_national_rep_id,
                                                          ent_inside_rep_id,
                                                          gk_segment segment,
                                                          rep_3_id,
                                                          rep_4_id
                                                   FROM   qg_account@slx) qa
                                             ON c.acct_id = qa.accountid
                                          LEFT OUTER JOIN
                                             GK_ACCOUNT_SEGMENTS_MV sl
                                          ON c.acct_id = sl.accountid
                                       LEFT OUTER JOIN
                                          gk_territory gt
                                       ON c.zipcode BETWEEN gt.zip_start
                                                        AND  gt.zip_end
                                          AND SUBSTR (c.country, 1, 2) IN
                                                   ('US', 'CA')
                                    LEFT OUTER JOIN
                                       userinfo@slx ui
                                    ON ui.userid = qa.ob_rep_id
                                 LEFT OUTER JOIN
                                    userinfo@slx ui6
                                 ON ui6.userid = sl.ob_rep_id
                              LEFT OUTER JOIN
                                 userinfo@slx ui2
                              ON ui2.userid = qa.ent_national_rep_id
                           LEFT OUTER JOIN
                              userinfo@slx ui5
                           ON ui5.userid = sl.field_rep_id
                        LEFT OUTER JOIN
                           userinfo@slx ui3
                        ON ui3.userid = qa.rep_4_id
                     LEFT OUTER JOIN
                        userinfo@slx ui4
                     ON ui4.userid = gt.userid
                  LEFT OUTER JOIN
                     userinfo@slx ui7
                  ON sf.salesperson = ui7.username
               LEFT OUTER JOIN
                  GK_CHANNEL_PARTNER rt
               ON rt.partner_key_code = sf.keycode           -- GK_REP_TAGGING
            LEFT OUTER JOIN
               userinfo@slx ui8
            ON rt.channel_manager = ui8.username
    WHERE   TO_CHAR (sf.book_date, 'mm/yyyy') =
               TO_CHAR (TRUNC (SYSDATE), 'mm/yyyy')
            AND sf.book_Amt <> '0'
            AND sf.ppcard_id IS NOT NULL;


GRANT SELECT ON GKDW.GK_OE_ENT_PREPAY_SALES_V TO COGNOS_RO;

