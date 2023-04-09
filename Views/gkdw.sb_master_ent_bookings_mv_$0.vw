DROP VIEW GKDW.SB_MASTER_ENT_BOOKINGS_MV_$0;

/* Formatted on 29/01/2021 11:22:47 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.SB_MASTER_ENT_BOOKINGS_MV_$0
(
   ENROLL_ID,
   EVENT_ID,
   CUST_ID,
   CH_NUM,
   COURSE_CH,
   MD_NUM,
   COURSE_MOD,
   PL_NUM,
   COURSE_PL,
   START_DATE,
   END_DATE,
   COURSE_CODE,
   COURSE_NAME,
   SHORT_NAME,
   OPS_COUNTRY,
   ENROLL_DATE,
   SALE_DATE,
   REV_DATE,
   BOOK_AMT,
   LIST_PRICE,
   CURR_CODE,
   SOLD_BY,
   SALESPERSON,
   ENROLL_TYPE,
   COUNTRY,
   ENROLL_STATUS,
   FEE_TYPE,
   PAYMENT_METHOD,
   PPCARD_ID,
   PO_NUMBER,
   ACCT_ID,
   ACCOUNT,
   ACCT_CITY,
   ACCT_STATE,
   ACCT_ZIPCODE,
   ACCT_COUNTRY,
   CUST_FIRST_NAME,
   CUST_LAST_NAME,
   CUST_NAME,
   EMAIL,
   ADDRESS1,
   ADDRESS2,
   CUST_CITY,
   CUST_WORKPHONE,
   CUST_STATE,
   CUST_ZIPCODE,
   CUST_COUNTRY,
   POS_YEAR,
   POS_QTR,
   POS_MONTH,
   POS_MONTH_NAME,
   POS_PERIOD,
   POS_WEEK,
   POD_YEAR,
   POD_QTR,
   POD_MONTH,
   POD_MONTH_NAME,
   POD_PERIOD,
   POD_WEEK,
   GK_VERTICAL,
   FARM_FLAG,
   FSCL_POS_YEAR,
   FSCL_POS_QTR,
   FSCL_POS_MONTH,
   FSCL_POS_MONTH_NAME,
   FSCL_POS_PERIOD,
   FSCL_POS_WEEK,
   FSCL_POD_YEAR,
   FSCL_POD_QTR,
   FSCL_POD_MONTH,
   FSCL_POD_MONTH_NAME,
   FSCL_POD_PERIOD,
   FSCL_POD_WEEK,
   PROMO_ADJ,
   COMM_AMT,
   BOOKINGS_COUNTRY
)
AS
   SELECT   et.evxevenrollid enroll_id,
            et.evxeventid event_id,
            et.contactid cust_id,
            cd.ch_num,
            cd.course_ch,
            cd.md_num,
            cd.course_mod,
            cd.pl_num,
            cd.course_pl,
            ed.start_date,
            ed.end_date,
            cd.course_code,
            cd.course_name,
            cd.short_name,
            ed.ops_country,
            TRUNC (et."SYSDATE" - 1) enroll_date,
            TRUNC (et."SYSDATE" - 1) sale_date,
            CASE
               WHEN et."SYSDATE" > ed.start_date
               THEN
                  TRUNC (et."SYSDATE" - 1)
               ELSE
                  ed.start_date
            END
               rev_date,
            et.actual_extended_amount book_amt,
            cd.list_price,
            et.currencytype curr_code,
            et.sold_by,
            et.salesrep salesperson,
            et.onsite_type enroll_type,
            et.eventcountry country,
            et.enrollstatus enroll_status,
            'Ons-Base' fee_type,
            CASE
               WHEN et.ponumber IS NOT NULL THEN 'Purchase Order'
               WHEN et.evxppcardid IS NOT NULL THEN 'Prepay Card'
               ELSE NULL
            END
               payment_method,
            et.evxppcardid ppcard_id,
            et.ponumber po_number,
            et.accountid acct_id,
            et.account,
            UPPER (ad1.city) acct_city,
            UPPER (ad1.state) acct_state,
            UPPER (ad1.postalcode) acct_zipcode,
            UPPER (ad1.country) acct_country,
            c.firstname cust_first_name,
            c.lastname cust_last_name,
            c.firstname || ' ' || c.lastname cust_name,
            c.email,
            UPPER (ad2.address1) address1,
            UPPER (ad2.address2) address2,
            UPPER (ad2.city) cust_city,
            UPPER (c.workphone) cust_workphone,
            UPPER (ad2.state) cust_state,
            UPPER (ad2.postalcode) cust_zipcode,
            UPPER (ad2.country) cust_country,
            --       sl.segment,
            --       sl.field_rep sl_sales_rep,
            --       sl.ob_terr sl_ob_terr,
            --       sl.field_terr sl_field_terr,
            --       gt.salesrep zip_sales_rep,
            --       gt.territory_id zip_terr,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             'Field Only'
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             ui3.division
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             ui2.division
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'SP 1'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'SP 2'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'SP 2'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             gt.territory_id
            --          WHEN sl.ob_terr IS NOT NULL           --AND SL.ACCOUNTID IS NOT NULL
            --          THEN
            --             sl.ob_terr
            --          ELSE
            --             NVL (ui.division, gt.territory_id)
            --       END
            --          sales_terr_id,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             ui2.username
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             ui3.username
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             ui2.username
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'Carl Beardsworth'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Anna Tancredi'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Anna Tancredi'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             gt.salesrep
            --          WHEN sl.ob_terr IS NOT NULL           --AND SL.ACCOUNTID IS NOT NULL
            --          THEN
            --             NVL (ui.username, ui2.username)
            --          ELSE
            --             NVL (ui.username, gt.salesrep)
            --       END
            --          sales_rep,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             um2.username
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             um3.username
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             um2.username
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'Adam VanDamia'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Adam VanDamia'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Adam VanDamia'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             gt.region_mgr
            --          WHEN sl.ob_terr IS NOT NULL
            --          THEN
            --             NVL (um.username, um2.username)
            --          ELSE
            --             NVL (um.username, gt.region_mgr)
            --       END
            --          sales_manager,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             'Field Only'
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             'Channel'
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             'Channel'
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'Strategic Alliance'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Strategic Alliance'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Strategic Alliance'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             'Canada'
            --          WHEN sl.ob_terr IS NOT NULL
            --          THEN
            --             NVL (ui.region, ui2.region)
            --          ELSE
            --             NVL (ui.region, gt.region)
            --       END
            --          sales_region,
            td1.dim_year pos_year,
            td1.dim_year || '-' || LPAD (td1.dim_quarter, 2, '0') pos_qtr,
            td1.dim_year || '-' || LPAD (td1.dim_month_num, 2, '0') pos_month,
            td1.dim_month pos_month_name,
            td1.dim_period_name pos_period,
            td1.dim_year || '-' || LPAD (td1.dim_week, 2, '0') pos_week,
            td2.dim_year pod_year,
            td2.dim_year || '-' || LPAD (td2.dim_quarter, 2, '0') pod_qtr,
            td2.dim_year || '-' || LPAD (td2.dim_month_num, 2, '0') pod_month,
            td2.dim_month pod_month_name,
            td2.dim_period_name pod_period,
            td2.dim_year || '-' || LPAD (td2.dim_week, 2, '0') pod_week,
            nv.gk_vertical,
            CASE WHEN cd.pl_num = '50' THEN 'Y' ELSE 'N' END farm_flag,
            td1.fiscal_year fscl_pos_year,
            td1.fiscal_year || '-' || LPAD (td1.fiscal_quarter, 2, '0')
               fscl_pos_qtr,
            td1.fiscal_year || '-' || LPAD (td1.fiscal_month_num, 2, '0')
               fscl_pos_month,
            td1.fiscal_month fscl_pos_month_name,
            td1.fiscal_period_name fscl_pos_period,
            td1.fiscal_year || '-' || LPAD (td1.fiscal_week, 2, '0')
               fscl_pos_week,
            td2.fiscal_year fscl_pod_year,
            td2.fiscal_year || '-' || LPAD (td2.fiscal_quarter, 2, '0')
               fscl_pod_qtr,
            td2.fiscal_year || '-' || LPAD (td2.fiscal_month_num, 2, '0')
               fscl_pod_month,
            td2.fiscal_month fscl_pod_month_name,
            td2.fiscal_period_name fscl_pod_period,
            td2.fiscal_year || '-' || LPAD (td2.fiscal_week, 2, '0')
               fscl_pod_week,
            0 promo_adj,
            et.actual_extended_amount comm_amt,
            CASE
               WHEN cd.md_num IN
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    AND UPPER (ad2.country) = 'CANADA'
               THEN
                  'CANADA'
               WHEN cd.md_num IN
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    AND ad2.country IS NULL
                    AND UPPER (ad1.country) = 'CANADA'
               THEN
                  'CANADA'
               WHEN cd.md_num IN
                          ('20', '31', '32', '33', '34', '42', '43', '44')
               THEN
                  'USA'
               ELSE
                  UPPER (ed.country)
            END
               bookings_country
     FROM                                 ent_trans_bookings_mv et
                                       INNER JOIN
                                          event_dim ed
                                       ON et.evxeventid = ed.event_id
                                    INNER JOIN
                                       course_dim cd
                                    ON ed.course_id = cd.course_id
                                       AND CASE
                                             WHEN ed.ops_country = 'CANADA'
                                             THEN
                                                'CANADA'
                                             ELSE
                                                'USA'
                                          END = cd.country
                                 INNER JOIN
                                    slxdw.account ac
                                 ON et.accountid = ac.accountid
                              INNER JOIN
                                 slxdw.qg_account qa
                              ON ac.accountid = qa.accountid
                           LEFT OUTER JOIN
                              gk_naics_verticals nv
                           ON qa.group_naics_code = nv.naics_code
                        INNER JOIN
                           slxdw.address ad1
                        ON ac.addressid = ad1.addressid
                     INNER JOIN
                        slxdw.contact c
                     ON et.contactid = c.contactid
                  INNER JOIN
                     slxdw.address ad2
                  ON c.addressid = ad2.addressid
               --       LEFT OUTER JOIN GK_ACCOUNT_SEGMENTS_MV sl
               --          ON ac.accountid = sl.accountid
               --       LEFT OUTER JOIN gk_territory gt
               --          ON     ad2.postalcode BETWEEN gt.zip_start AND gt.zip_end
               --             AND gt.territory_type = 'OB'
               INNER JOIN
                  time_dim td1
               ON TRUNC (et."SYSDATE") = td1.dim_date
            INNER JOIN
               time_dim td2
            ON CASE
                  WHEN cd.md_num IN ('31', '32', '33', '34', '43', '44')
                  THEN
                     TRUNC (et."SYSDATE")
                  ELSE
                     ed.start_date
               END = td2.dim_date
    --       LEFT OUTER JOIN slxdw.userinfo ui
    --          ON ui.userid = NVL (sl.ob_rep_id, gt.userid)
    --       LEFT OUTER JOIN slxdw.usersecurity us ON ui.userid = us.userid
    --       LEFT OUTER JOIN slxdw.userinfo um ON us.managerid = um.userid
    --       LEFT OUTER JOIN slxdw.userinfo ui2
    --          ON sl.field_rep_id = ui2.userid AND ui2.region != 'Retired'
    --       LEFT OUTER JOIN slxdw.usersecurity us2 ON ui2.userid = us2.userid
    --       LEFT OUTER JOIN slxdw.userinfo um2 ON us2.managerid = um2.userid
    --       LEFT OUTER JOIN slxdw.userinfo ui3
    --          ON et.salesrep = ui3.username AND ui3.region != 'Retired'
    --       LEFT OUTER JOIN slxdw.usersecurity us3 ON ui2.userid = us3.userid
    --       LEFT OUTER JOIN slxdw.userinfo um3 ON us3.managerid = um3.userid
    WHERE   td1.dim_year >= 2016
            -- AND et.actual_extended_amount <> 0
            -- and et.evxeventid='QGKID0B936Z6'
            AND cd.course_code NOT IN
                     ('1500D', '4931D', '283919I', '5983D', '1978I') -- SR 11/6/2018 ticket# 1937
            AND NOT EXISTS (SELECT   1
                              FROM   gk_master_account_exclude ma
                             WHERE   ma.acct_id = ac.accountid)
   UNION
   SELECT   f.enroll_id,
            f.event_id,
            f.cust_id,
            cd.ch_num,
            cd.course_ch,
            cd.md_num,
            cd.course_mod,
            cd.pl_num,
            cd.course_pl,
            ed.start_date,
            ed.end_date,
            cd.course_code,
            cd.course_name,
            cd.short_name,
            ed.ops_country,
            f.enroll_date,
            TRUNC (et."SYSDATE" - 1) sale_date,
            f.rev_date,
            f.book_amt,
            f.list_price,
            f.curr_code,
            NULL,
            f.salesperson,
            f.enroll_type,
            f.country,
            f.enroll_status,
            f.fee_type,
            f.payment_method,
            f.ppcard_id,
            f.po_number,
            f.acct_id,
            f.acct_name,
            UPPER (ad1.city) acct_city,
            UPPER (ad1.state) acct_state,
            UPPER (ad1.postalcode) acct_zipcode,
            UPPER (ad1.country) acct_country,
            --  Change begins: TKT # 32405 by SBARAL
            f.cust_first_name cust_first_name,
            f.cust_last_name cust_last_name,
            f.cust_first_name || ' ' || f.cust_last_name cust_name,
            f.cust_email email,
            UPPER (f.cust_address1) address1,
            UPPER (f.cust_address2) address2,
            UPPER (f.cust_city) cust_city,
            UPPER (c.workphone) cust_workphone,
            UPPER (f.cust_state) cust_state,
            UPPER (f.cust_zipcode) cust_zipcode,
            UPPER (f.cust_country) cust_country,
            -- c.firstname cust_first_name,
            --  c.lastname cust_last_name,
            -- c.firstname || ' ' || c.lastname cust_name,
            -- c.email,
            -- UPPER (ad2.address1) address1,
            --  UPPER (ad2.address2) address2,
            --  UPPER (ad2.city) cust_city,
            --  UPPER (c.workphone) cust_workphone,
            --  UPPER (ad2.state) cust_state,
            --  UPPER (ad2.postalcode) cust_zipcode,
            --  UPPER (ad2.country) cust_country,

            --  Change ends: TKT # 32405 by SBARAL
            --       sl.segment,
            --       sl.field_rep sl_sales_rep,
            --       sl.ob_terr sl_ob_terr,
            --       sl.field_terr sl_field_terr,
            --       gt.salesrep zip_sales_rep,
            --       gt.territory_id zip_terr,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             'Field Only'
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             ui3.division
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             ui2.division
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'SP 1'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'SP 2'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'SP 2'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             gt.territory_id
            --          WHEN sl.ob_terr IS NOT NULL           --AND SL.ACCOUNTID IS NOT NULL
            --          THEN
            --             sl.ob_terr
            --          ELSE
            --             NVL (ui.division, gt.territory_id)
            --       END
            --          sales_terr_id,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             ui2.username
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             ui3.username
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             ui2.username
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'Carl Beardsworth'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Anna Tancredi'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Anna Tancredi'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             gt.salesrep
            --          WHEN sl.ob_terr IS NOT NULL           --AND SL.ACCOUNTID IS NOT NULL
            --          THEN
            --             NVL (ui.username, ui2.username)
            --          ELSE
            --             NVL (ui.username, gt.salesrep)
            --       END
            --          sales_rep,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             um2.username
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             um3.username
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             um2.username
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'Adam VanDamia'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Adam VanDamia'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Adam VanDamia'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             gt.region_mgr
            --          WHEN sl.ob_terr IS NOT NULL
            --          THEN
            --             NVL (um.username, um2.username)
            --          ELSE
            --             NVL (um.username, gt.region_mgr)
            --       END
            --          sales_manager,
            --       CASE
            --          WHEN ui2.division = 'Field Only'
            --          THEN
            --             'Field Only'
            --          WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            --          THEN
            --             'Channel'
            --          WHEN sl.segment = 'Channel'
            --          THEN
            --             'Channel'
            --          WHEN sl.segment = 'Strategic Alliance'
            --          THEN
            --             'Strategic Alliance'
            --          WHEN     sl.segment IS NULL
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Strategic Alliance'
            --          WHEN     sl.segment = 'Inside'
            --               AND sl.field_rep = 'TBD'
            --               AND SUBSTR (UPPER (ad2.country), 1, 2) NOT IN ('US', 'CA')
            --          THEN
            --             'Strategic Alliance'
            --          WHEN SUBSTR (UPPER (ad2.country), 1, 2) = 'CA'
            --          THEN
            --             'Canada'
            --          WHEN sl.ob_terr IS NOT NULL
            --          THEN
            --             NVL (ui.region, ui2.region)
            --          ELSE
            --             NVL (ui.region, gt.region)
            --       END
            --          sales_region,
            td1.dim_year pos_year,
            td1.dim_year || '-' || LPAD (td1.dim_quarter, 2, '0') pos_qtr,
            td1.dim_year || '-' || LPAD (td1.dim_month_num, 2, '0') pos_month,
            td1.dim_month pos_month_name,
            td1.dim_period_name pos_period,
            td1.dim_year || '-' || LPAD (td1.dim_week, 2, '0') pos_week,
            td2.dim_year pod_year,
            td2.dim_year || '-' || LPAD (td2.dim_quarter, 2, '0') pod_qtr,
            td2.dim_year || '-' || LPAD (td2.dim_month_num, 2, '0') pod_month,
            td2.dim_month pod_month_name,
            td2.dim_period_name pod_period,
            td2.dim_year || '-' || LPAD (td2.dim_week, 2, '0') pod_week,
            nv.gk_vertical,
            CASE WHEN cd.pl_num = '50' THEN 'Y' ELSE 'N' END farm_flag,
            td1.fiscal_year fscl_pos_year,
            td1.fiscal_year || '-' || LPAD (td1.fiscal_quarter, 2, '0')
               fscl_pos_qtr,
            td1.fiscal_year || '-' || LPAD (td1.fiscal_month_num, 2, '0')
               fscl_pos_month,
            td1.fiscal_month fscl_pos_month_name,
            td1.fiscal_period_name fscl_pos_period,
            td1.fiscal_year || '-' || LPAD (td1.fiscal_week, 2, '0')
               fscl_pos_week,
            td2.fiscal_year fscl_pod_year,
            td2.fiscal_year || '-' || LPAD (td2.fiscal_quarter, 2, '0')
               fscl_pod_qtr,
            td2.fiscal_year || '-' || LPAD (td2.fiscal_month_num, 2, '0')
               fscl_pod_month,
            td2.fiscal_month fscl_pod_month_name,
            td2.fiscal_period_name fscl_pod_period,
            td2.fiscal_year || '-' || LPAD (td2.fiscal_week, 2, '0')
               fscl_pod_week,
            0 promo_adj,
            et.actual_extended_amount comm_amt,
            CASE
               WHEN cd.md_num IN
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    AND UPPER (ad2.country) = 'CANADA'
               THEN
                  'CANADA'
               WHEN cd.md_num IN
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    AND ad2.country IS NULL
                    AND UPPER (ad1.country) = 'CANADA'
               THEN
                  'CANADA'
               WHEN cd.md_num IN
                          ('20', '31', '32', '33', '34', '42', '43', '44')
               THEN
                  'USA'
               ELSE
                  UPPER (ed.country)
            END
               bookings_country
     FROM                                    ent_trans_bookings_mv et
                                          INNER JOIN
                                             order_fact f
                                          ON et.evxeventid = f.event_id
                                             AND TRUNC (et.startdate) =
                                                   TRUNC (f.book_date)
                                       INNER JOIN
                                          event_dim ed
                                       ON et.evxeventid = ed.event_id
                                    INNER JOIN
                                       course_dim cd
                                    ON ed.course_id = cd.course_id
                                       AND CASE
                                             WHEN ed.ops_country = 'CANADA'
                                             THEN
                                                'CANADA'
                                             ELSE
                                                'USA'
                                          END = cd.country
                                 INNER JOIN
                                    slxdw.account ac
                                 ON et.accountid = ac.accountid
                              INNER JOIN
                                 slxdw.qg_account qa
                              ON ac.accountid = qa.accountid
                           LEFT OUTER JOIN
                              gk_naics_verticals nv
                           ON qa.group_naics_code = nv.naics_code
                        INNER JOIN
                           slxdw.address ad1
                        ON ac.addressid = ad1.addressid
                     INNER JOIN
                        slxdw.contact c
                     ON et.contactid = c.contactid
                  INNER JOIN
                     slxdw.address ad2
                  ON c.addressid = ad2.addressid
               --       LEFT OUTER JOIN GK_ACCOUNT_SEGMENTS_MV sl
               --          ON ac.accountid = sl.accountid
               --       LEFT OUTER JOIN gk_territory gt
               --          ON     ad2.postalcode BETWEEN gt.zip_start AND gt.zip_end
               --             AND gt.territory_type = 'OB'
               INNER JOIN
                  time_dim td1
               ON TRUNC (et."SYSDATE") = td1.dim_date
            INNER JOIN
               time_dim td2
            ON CASE
                  WHEN cd.md_num IN ('31', '32', '33', '34', '43', '44')
                  THEN
                     TRUNC (et."SYSDATE")
                  ELSE
                     ed.start_date
               END = td2.dim_date
    --       LEFT OUTER JOIN slxdw.userinfo ui
    --          ON ui.userid = NVL (sl.ob_rep_id, gt.userid)
    --       LEFT OUTER JOIN slxdw.usersecurity us ON ui.userid = us.userid
    --       LEFT OUTER JOIN slxdw.userinfo um ON us.managerid = um.userid
    --       LEFT OUTER JOIN slxdw.userinfo ui2
    --          ON sl.field_rep_id = ui2.userid AND ui2.region != 'Retired'
    --       LEFT OUTER JOIN slxdw.usersecurity us2 ON ui2.userid = us2.userid
    --       LEFT OUTER JOIN slxdw.userinfo um2 ON us2.managerid = um2.userid
    --       LEFT OUTER JOIN slxdw.userinfo ui3
    --          ON et.salesrep = ui3.username AND ui3.region != 'Retired'
    --       LEFT OUTER JOIN slxdw.usersecurity us3 ON ui2.userid = us3.userid
    --       LEFT OUTER JOIN slxdw.userinfo um3 ON us3.managerid = um3.userid
    WHERE   td1.dim_year >= 2016
            -- AND et.actual_extended_amount <> 0
            --and f.event_id='QGKID0B936Z6'
            AND cd.course_code NOT IN
                     ('1500D', '4931D', '283919I', '5983D', '1978I') -- SR 11/6/2018 ticket# 1937
            AND NOT EXISTS (SELECT   1
                              FROM   gk_master_account_exclude ma
                             WHERE   ma.acct_id = ac.accountid)
            AND NOT EXISTS
                  (SELECT   1
                     FROM   ent_trans_bookings_mv mv
                    WHERE   mv.evxeventid = f.event_id
                            AND mv.evxevenrollid = f.enroll_id);


