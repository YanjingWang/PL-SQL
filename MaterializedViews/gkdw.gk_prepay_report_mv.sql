DROP MATERIALIZED VIEW GKDW.GK_PREPAY_REPORT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PREPAY_REPORT_MV 
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
/* Formatted on 29/01/2021 12:23:17 (QP5 v5.115.810.9015) */
SELECT   sf.record_type,
         sf.sales_order_id,
         sf.prod_num,
         sf.creation_date,
         sf.book_amt,
         sf.curr_code,
         sf.payment_method,
         ad.acct_id,
         ad.acct_name,
         cd.cust_name,
         sf.bill_to_address1,
         sf.bill_to_city,
         sf.bill_to_state,
         sf.bill_to_zipcode,
         sf.bill_to_country,
         sf.ppcard_id,
         gt.territory_id zip_terr,
         gt.salesrep zip_salesrep,
         gt.region zip_region,
         sf.salesperson,
         pd.value_purchased_base,
         pd.value_balance_base,
         pd.event_pass_total,
         pd.event_pass_available,
         pd.card_status,
         pd.card_type,
         pd.expire_card,
         pd.expires_date,
         sl.sales_segment,
         sl.sales_rep sl_salesrep,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.sales_segment = 'Channel'
            THEN
               ui2.division
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'SP 1'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN SUBSTR (UPPER (cd.country), 1, 2) = 'CA'
            THEN
               gt.territory_id
            WHEN sl.ob_terr IS NOT NULL
            THEN
               TO_CHAR (sl.ob_terr)
            ELSE
               NVL (NVL (ui.division, gt.territory_id), ui3.division)
         END
            sales_terr_id,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               ui2.username
            WHEN sl.sales_segment = 'Channel'
            THEN
               ui2.username
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'Carl Beardsworth'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN SUBSTR (UPPER (cd.country), 1, 2) = 'CA'
            THEN
               gt.salesrep
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.username, ui2.username)
            ELSE
               NVL (NVL (ui.username, gt.salesrep), ui3.username)
         END
            sales_rep,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               um2.username
            WHEN sl.sales_segment = 'Channel'
            THEN
               um2.username
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'Adam VanDamia'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN SUBSTR (UPPER (cd.country), 1, 2) = 'CA'
            THEN
               gt.region_mgr
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (um.username, um2.username)
            ELSE
               NVL (NVL (um.username, gt.region_mgr), um3.username)
         END
            sales_manager,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN sl.sales_segment = 'Channel'
            THEN
               'Channel'
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'Strategic Partner'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (cd.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN SUBSTR (UPPER (cd.country), 1, 2) = 'CA'
            THEN
               'Canada'
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.region, ui2.region)
            ELSE
               NVL (NVL (ui.region, gt.region), ui3.region)
         END
            sales_region,
         td1.dim_year pos_year,
         td1.dim_year || '-' || LPAD (td1.dim_quarter, 2, '0') pos_qtr,
         td1.dim_year || '-' || LPAD (td1.dim_month_num, 2, '0') pos_month,
         td1.dim_period_name pos_period,
         td1.dim_year || '-' || LPAD (td1.dim_week, 2, '0') pos_week,
         nv.gk_vertical,
         td1.fiscal_year fscl_pos_year,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_quarter, 2, '0')
            fscl_pos_qtr,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_month_num, 2, '0')
            fscl_pos_month,
         td1.fiscal_period_name fscl_pos_period,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_week, 2, '0')
            fscl_pos_week
  FROM                                                         sales_order_fact sf
                                                            INNER JOIN
                                                               ppcard_dim pd
                                                            ON sf.ppcard_id =
                                                                  pd.ppcard_id
                                                         INNER JOIN
                                                            product_dim p
                                                         ON sf.product_id =
                                                               p.product_id
                                                      INNER JOIN
                                                         account_dim ad
                                                      ON pd.issued_to_acct_id =
                                                            ad.acct_id
                                                   INNER JOIN
                                                      cust_dim cd
                                                   ON pd.issued_to_cust_id =
                                                         cd.cust_id
                                                INNER JOIN
                                                   slxdw.qg_account qa
                                                ON cd.acct_id = qa.accountid
                                             LEFT OUTER JOIN
                                                gk_naics_verticals nv
                                             ON qa.group_naics_code =
                                                   nv.naics_code
                                          INNER JOIN
                                             time_dim td1
                                          ON TRUNC (sf.creation_date) =
                                                td1.dim_date
                                       LEFT OUTER JOIN
                                          gk_account_segment_lookup_mv sl
                                       ON pd.issued_to_acct_id = sl.accountid
                                    LEFT OUTER JOIN
                                       gk_territory gt
                                    ON cd.zipcode BETWEEN gt.zip_start
                                                      AND  gt.zip_end
                                       AND gt.territory_type = 'OB'
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui
                                 ON ui.userid = NVL (sl.ob_rep_id, gt.userid)
                              LEFT OUTER JOIN
                                 slxdw.usersecurity us
                              ON ui.userid = us.userid
                           LEFT OUTER JOIN
                              slxdw.userinfo um
                           ON us.managerid = um.userid
                        LEFT OUTER JOIN
                           slxdw.userinfo ui2
                        ON sl.sales_userid = ui2.userid
                           AND ui2.region != 'Retired'
                     LEFT OUTER JOIN
                        slxdw.usersecurity us2
                     ON ui2.userid = us2.userid
                  LEFT OUTER JOIN
                     slxdw.userinfo um2
                  ON us2.managerid = um2.userid
               LEFT OUTER JOIN
                  slxdw.userinfo ui3
               ON pd.create_user = ui3.userid AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui2.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE       sf.record_type IN ('Prepay Order', 'Event Card')
         AND td1.fiscal_year >= 2015
         AND sf.cancel_date IS NULL;

COMMENT ON MATERIALIZED VIEW GKDW.GK_PREPAY_REPORT_MV IS 'snapshot table for snapshot GKDW.GK_PREPAY_REPORT_MV';

GRANT SELECT ON GKDW.GK_PREPAY_REPORT_MV TO DWHREAD;

