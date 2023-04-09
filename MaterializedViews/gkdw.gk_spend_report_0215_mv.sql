DROP MATERIALIZED VIEW GKDW.GK_SPEND_REPORT_0215_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SPEND_REPORT_0215_MV 
TABLESPACE GDWLRG
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
/* Formatted on 29/01/2021 12:21:56 (QP5 v5.115.810.9015) */
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
         f.book_date sale_date,
         CASE
            WHEN cd.md_num IN ('10', '20')
                 AND ed.start_date >= TRUNC (SYSDATE)
            THEN
               ed.start_date
            ELSE
               f.book_date
         END
            rev_date,
         f.book_amt,
         f.list_price,
         f.curr_code,
         f.keycode,
         f.source,
         f.salesperson,
         f.enroll_type,
         f.country,
         f.enroll_status,
         f.fee_type,
         f.payment_method,
         c.acct_id,
         c.acct_name,
         f.acct_city,
         f.acct_state,
         f.acct_zipcode,
         f.acct_country,
         c.first_name cust_first_name,
         c.last_name cust_last_name,
         c.first_name || ' ' || c.last_name cust_name,
         c.email,
         c.address1,
         c.address2,
         c.city cust_city,
         c.state cust_state,
         c.zipcode cust_zipcode,
         c.country cust_country,
         cp.partner_key_code,
         cp.partner_name,
         cp.ob_comm_type,
         sl.sales_segment,
         sl.sales_rep sl_sales_rep,
         sl.ob_terr sl_ob_terr,
         gt.salesrep zip_sales_rep,
         gt.territory_id zip_terr,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN UPPER (NVL (ob_comm_type, 'NONE')) NOT IN
                       ('NONE', 'FEDERAL', 'NAMED ACCOUNT', 'STUDENT', 'APOC')
            THEN
               ob_comm_type
            WHEN     cd.ch_num = '10'
                 AND sl.sales_segment = 'Channel'
                 AND cp.partner_key_code IS NULL
            THEN
               'Error'
            WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            THEN
               ui3.division
            WHEN sl.sales_segment = 'Channel'
            THEN
               ui2.division
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'SP 1'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'SP 2'
            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA'
            THEN
               gt.territory_id
            WHEN sl.ob_terr IS NOT NULL
            THEN
               sl.ob_terr
            ELSE
               NVL (ui.division, gt.territory_id)
         END
            sales_terr_id,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               ui2.username
            WHEN ob_comm_type IN ('99', '32')
            THEN
               f.salesperson
            WHEN UPPER (NVL (ob_comm_type, 'NONE')) NOT IN
                       ('NONE', 'FEDERAL', 'NAMED ACCOUNT', 'STUDENT', 'APOC')
            THEN
               ui.username
            WHEN     cd.ch_num = '10'
                 AND sl.sales_segment = 'Channel'
                 AND cp.partner_key_code IS NULL
            THEN
               'Error'
            WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            THEN
               ui3.username
            WHEN sl.sales_segment = 'Channel'
            THEN
               ui2.username
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'Carl Beardsworth'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Kechia Mackey'
            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA'
            THEN
               gt.salesrep
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.username, ui2.username)
            ELSE
               NVL (ui.username, gt.salesrep)
         END
            sales_rep,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               um2.username
            WHEN ob_comm_type IN ('99', '32')
            THEN
               cp.channel_manager
            WHEN UPPER (NVL (ob_comm_type, 'NONE')) NOT IN
                       ('NONE', 'FEDERAL', 'NAMED ACCOUNT', 'STUDENT', 'APOC')
            THEN
               um.username
            WHEN     cd.ch_num = '10'
                 AND sl.sales_segment = 'Channel'
                 AND cp.partner_key_code IS NULL
            THEN
               'Error'
            WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            THEN
               um3.username
            WHEN sl.sales_segment = 'Channel'
            THEN
               um2.username
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'Adam VanDamia'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Adam VanDamia'
            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA'
            THEN
               gt.region_mgr
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (um.username, um2.username)
            ELSE
               NVL (um.username, gt.region_mgr)
         END
            sales_manager,
         CASE
            WHEN ui2.division = 'Field Only'
            THEN
               'Field Only'
            WHEN ob_comm_type IN ('99', '32')
            THEN
               'Channel'
            WHEN UPPER (NVL (ob_comm_type, 'NONE')) NOT IN
                       ('NONE', 'FEDERAL', 'NAMED ACCOUNT', 'STUDENT', 'APOC')
            THEN
               ui.region
            WHEN     cd.ch_num = '10'
                 AND sl.sales_segment = 'Channel'
                 AND cp.partner_key_code IS NULL
            THEN
               'Error'
            WHEN cd.ch_num = '20' AND ui3.region = 'Channel'
            THEN
               'Channel'
            WHEN sl.sales_segment = 'Channel'
            THEN
               'Channel'
            WHEN sl.sales_segment = 'Strategic Partner'
            THEN
               'Strategic Partner'
            WHEN sl.sales_segment IS NULL
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN     sl.sales_segment = 'Inside'
                 AND sl.sales_rep = 'TBD'
                 AND SUBSTR (UPPER (c.country), 1, 2) NOT IN ('US', 'CA')
            THEN
               'Strategic Partner'
            WHEN SUBSTR (UPPER (c.country), 1, 2) = 'CA'
            THEN
               'Canada'
            WHEN sl.ob_terr IS NOT NULL
            THEN
               NVL (ui.region, ui2.region)
            ELSE
               NVL (ui.region, gt.region)
         END
            sales_region,
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
         CASE WHEN cd.pl_num = '50' THEN 'Y' ELSE 'N' END farm_flag
  FROM                                                            order_fact f
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
                                                         INNER JOIN
                                                            cust_dim c
                                                         ON f.cust_id =
                                                               c.cust_id
                                                      INNER JOIN
                                                         slxdw.qg_account qa
                                                      ON c.acct_id =
                                                            qa.accountid
                                                   LEFT OUTER JOIN
                                                      gk_naics_verticals nv
                                                   ON qa.group_naics_code =
                                                         nv.naics_code
                                                LEFT OUTER JOIN
                                                   gk_channel_partner cp
                                                ON f.keycode =
                                                      cp.partner_key_code
                                             LEFT OUTER JOIN
                                                GK_ACCOUNT_SEGMENT_021516_MV sl
                                             ON c.acct_id = sl.accountid
                                          LEFT OUTER JOIN
                                             gk_territory gt
                                          ON c.zipcode BETWEEN gt.zip_start
                                                           AND  gt.zip_end
                                             AND gt.territory_type = 'OB'
                                       INNER JOIN
                                          time_dim td1
                                       ON f.book_date = td1.dim_date
                                    INNER JOIN
                                       time_dim td2
                                    ON CASE
                                          WHEN cd.md_num IN
                                                     ('31',
                                                      '32',
                                                      '33',
                                                      '34',
                                                      '43',
                                                      '44')
                                          THEN
                                             f.book_date
                                          ELSE
                                             ed.start_date
                                       END = td2.dim_date
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui
                                 ON CASE
                                       WHEN UPPER (
                                               NVL (ob_comm_type, 'NONE')
                                            ) NOT IN
                                                  ('NONE',
                                                   'FEDERAL',
                                                   'NAMED ACCOUNT',
                                                   'STUDENT',
                                                   'APOC')
                                       THEN
                                          ob_comm_type
                                       WHEN sl.ob_terr IS NOT NULL
                                       THEN
                                          sl.ob_terr
                                       ELSE
                                          gt.territory_id
                                    END = ui.division
                                    AND (ui.department = 'Outbound'
                                         OR ui.region = 'Channel')
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
               ON f.salesperson = ui3.username AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui2.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE   td1.dim_year >= 2014 AND f.book_amt <> 0;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SPEND_REPORT_0215_MV IS 'snapshot table for snapshot GKDW.GK_SPEND_REPORT_0215_MV';

GRANT SELECT ON GKDW.GK_SPEND_REPORT_0215_MV TO DWHREAD;

