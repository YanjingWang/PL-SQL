DROP MATERIALIZED VIEW GKDW.MASTER_ACTIVITY_MV;
CREATE MATERIALIZED VIEW GKDW.MASTER_ACTIVITY_MV 
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
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:20:32 (QP5 v5.115.810.9015) */
SELECT   ac.accountid,
         ac.account account_name,
         UPPER(CASE
                  WHEN TRIM (sl.customer_name) IS NOT NULL
                  THEN
                     TO_CHAR (sl.customer_name)
                  WHEN TRIM (qa.account_group) IS NOT NULL
                  THEN
                     qa.account_group
                  ELSE
                     TRIM (ac.account)
               END)
            account_group_name,
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
         sl.segment,
         sl.FIELD_REP sl_sales_rep,
         sl.ob_terr sl_ob_terr,
         sl.field_terr sl_field_terr,
         gt.salesrep zip_sales_rep,
         gt.territory_id zip_terr,
         a.userid,
         a.createdate,
         ui3.username,
         NULL completeduser,
         NVL (ui3.division, gt.territory_id) sales_terr_id,
         NVL (ui3.username, gt.salesrep) sales_rep,
         NVL (um3.username, gt.region_mgr) sales_manager,
         NVL (ui3.region, gt.region) sales_region,
         TRUNC (a.startdate) activity_date,
         td1.dim_year pos_year,
         td1.dim_year || '-' || LPAD (td1.dim_quarter, 2, '0') pos_qtr,
         td1.dim_year || '-' || LPAD (td1.dim_month_num, 2, '0') pos_month,
         td1.dim_month pos_month_name,
         td1.dim_period_name pos_period,
         td1.dim_year || '-' || LPAD (td1.dim_week, 2, '0') pos_week,
         td1.fiscal_year fscl_pos_year,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_quarter, 2, '0')
            fscl_pos_qtr,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_month_num, 2, '0')
            fscl_pos_month,
         td1.fiscal_month fscl_pos_month_name,
         td1.fiscal_period_name fscl_pos_period,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_week, 2, '0')
            fscl_pos_week,
         nv.gk_vertical,
         t.activity_desc,
         a.activityid,
         1 activity_cnt,
         0 conv_cnt,
         NULL result,
         'Open' activity_status
  FROM                                          slxdw.activity a
                                             INNER JOIN
                                                slxdw.activity_types t
                                             ON a.activitytype =
                                                   t.activity_code
                                          INNER JOIN
                                             slxdw.contact c
                                          ON a.contactid = c.contactid
                                       INNER JOIN
                                          slxdw.account ac
                                       ON c.accountid = ac.accountid
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
                              slxdw.address ad2
                           ON c.addressid = ad2.addressid
                        LEFT OUTER JOIN
                           GK_ACCOUNT_SEGMENTS_MV sl
                        ON ac.accountid = sl.accountid
                     LEFT OUTER JOIN
                        gk_territory gt
                     ON ad2.postalcode BETWEEN gt.zip_start AND gt.zip_end
                        AND gt.territory_type = 'OB'
                  INNER JOIN
                     time_dim td1
                  ON TRUNC (a.startdate) = td1.dim_date
               LEFT OUTER JOIN
                  slxdw.userinfo ui3
               ON a.userid = ui3.userid AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui3.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE   td1.fiscal_year >= 2015
UNION
SELECT   ac.accountid,
         ac.account account_name,
         UPPER(CASE
                  WHEN TRIM (sl.customer_name) IS NOT NULL
                  THEN
                     TO_CHAR (sl.customer_name)
                  WHEN TRIM (qa.account_group) IS NOT NULL
                  THEN
                     qa.account_group
                  ELSE
                     TRIM (ac.account)
               END)
            account_group_name,
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
         sl.segment,
         sl.FIELD_REP sl_sales_rep,
         sl.ob_terr sl_ob_terr,
         sl.field_terr sl_field_terr,
         gt.salesrep zip_sales_rep,
         gt.territory_id zip_terr,
         a.userid,
         a.createdate,
         ui3.username,
         a.completeduser,
         NVL (ui3.division, gt.territory_id) sales_terr_id,
         NVL (ui3.username, gt.salesrep) sales_rep,
         NVL (um3.username, gt.region_mgr) sales_manager,
         NVL (ui3.region, gt.region) sales_region,
         TRUNC (a.completeddate) activity_date,
         td1.dim_year pos_year,
         td1.dim_year || '-' || LPAD (td1.dim_quarter, 2, '0') pos_qtr,
         td1.dim_year || '-' || LPAD (td1.dim_month_num, 2, '0') pos_month,
         td1.dim_month pos_month_name,
         td1.dim_period_name pos_period,
         td1.dim_year || '-' || LPAD (td1.dim_week, 2, '0') pos_week,
         td1.fiscal_year fscl_pos_year,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_quarter, 2, '0')
            fscl_pos_qtr,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_month_num, 2, '0')
            fscl_pos_month,
         td1.fiscal_month fscl_pos_month_name,
         td1.fiscal_period_name fscl_pos_period,
         td1.fiscal_year || '-' || LPAD (td1.fiscal_week, 2, '0')
            fscl_pos_week,
         nv.gk_vertical,
         t.activity_desc,
         a.activityid,
         1 activity_cnt,
         CASE WHEN UPPER (a.result) LIKE 'SPOKE%TO%' THEN 1 ELSE 0 END
            conv_cnt,
         a.result,
         'Open' activity_status
  FROM                                          slxdw.history a
                                             INNER JOIN
                                                slxdw.activity_types t
                                             ON a.history_type =
                                                   t.activity_code
                                          INNER JOIN
                                             slxdw.contact c
                                          ON a.contactid = c.contactid
                                       INNER JOIN
                                          slxdw.account ac
                                       ON c.accountid = ac.accountid
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
                              slxdw.address ad2
                           ON c.addressid = ad2.addressid
                        LEFT OUTER JOIN
                           GK_ACCOUNT_SEGMENTS_MV sl
                        ON ac.accountid = sl.accountid
                     LEFT OUTER JOIN
                        gk_territory gt
                     ON ad2.postalcode BETWEEN gt.zip_start AND gt.zip_end
                        AND gt.territory_type = 'OB'
                  INNER JOIN
                     time_dim td1
                  ON TRUNC (a.completeddate) = td1.dim_date
               LEFT OUTER JOIN
                  slxdw.userinfo ui3
               ON a.userid = ui3.userid AND ui3.region != 'Retired'
            LEFT OUTER JOIN
               slxdw.usersecurity us3
            ON ui3.userid = us3.userid
         LEFT OUTER JOIN
            slxdw.userinfo um3
         ON us3.managerid = um3.userid
 WHERE   td1.fiscal_year >= 2015;

COMMENT ON MATERIALIZED VIEW GKDW.MASTER_ACTIVITY_MV IS 'snapshot table for snapshot GKDW.MASTER_ACTIVITY_MV';

GRANT SELECT ON GKDW.MASTER_ACTIVITY_MV TO DWHREAD;

