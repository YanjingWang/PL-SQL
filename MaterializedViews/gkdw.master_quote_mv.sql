DROP MATERIALIZED VIEW GKDW.MASTER_QUOTE_MV;
CREATE MATERIALIZED VIEW GKDW.MASTER_QUOTE_MV 
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
/* Formatted on 29/01/2021 12:20:03 (QP5 v5.115.810.9015) */
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
         sl.segment,
         sl.field_rep sl_sales_rep,
         sl.ob_terr sl_ob_terr,
         sl.field_terr sl_field_terr,
         gt.salesrep zip_sales_rep,
         gt.territory_id zip_terr,
         d.CREATE_USER userid,
         ui3.username,
         -- NVL (ui3.division, gt.territory_id) sales_terr_id_org, -- SR
         CASE
            WHEN NVL (ui3.division, gt.territory_id) IS NOT NULL
                 AND UPPER (NVL (ui3.division, gt.territory_id)) != 'RETIRED'
            THEN
               NVL (ui3.division, gt.territory_id)
            WHEN UPPER (NVL (ui3.division, gt.territory_id)) = 'RETIRED'
            THEN
               un3.division
            ELSE
               NVL (ui3.division, gt.territory_id)
         END
            sales_terr_id,                                                --SR
         NVL (ui3.username, gt.salesrep) sales_rep,
         NVL (um3.username, gt.region_mgr) sales_manager,
         -- NVL (ui3.region, gt.region) sales_region_org, -- SR
         CASE
            WHEN NVL (ui3.region, gt.region) IS NOT NULL
                 AND UPPER (NVL (ui3.region, gt.region)) != 'RETIRED'
            THEN
               NVL (ui3.region, gt.region)
            WHEN UPPER (NVL (ui3.region, gt.region)) = 'RETIRED'
            THEN
               un3.region
            ELSE
               NVL (ui3.region, gt.region)
         END
            sales_region,                                                 --SR
         TRUNC (d.estimated_close) opportunity_date,
         d.closed,
         d.stage,
         d.close_probability,
         d.status,
         d.creation_date,
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
         1 opp_cnt,
         d.opportunity_id,
         NVL (sales_potential, 0) opp_potential,
         d.actual_amount
  FROM                                    opportunity_dim d
                                       INNER JOIN
                                          slxdw.account ac
                                       ON d.account_id = ac.accountid
                                    INNER JOIN
                                       slxdw.qg_account qa
                                    ON ac.accountid = qa.accountid
                                 LEFT OUTER JOIN
                                    gk_naics_verticals nv
                                 ON qa.group_naics_code = nv.naics_code
                              INNER JOIN
                                 slxdw.address ad1
                              ON ac.addressid = ad1.addressid
                           LEFT OUTER JOIN
                              GK_ACCOUNT_SEGMENTS_MV sl
                           ON ac.accountid = sl.accountid
                        LEFT OUTER JOIN
                           gk_territory gt
                        ON ad1.postalcode BETWEEN gt.zip_start AND gt.zip_end
                           AND gt.territory_type = 'OB'
                     INNER JOIN
                        time_dim td1
                     ON TRUNC (d.creation_date) = td1.dim_date
                  LEFT OUTER JOIN
                     slxdw.userinfo ui3
                  ON d.CREATE_USER = ui3.userid --AND ui3.region != 'Retired' -- SR
               LEFT OUTER JOIN
                  slxdw.usersecurity us3
               ON ui3.userid = us3.userid
            LEFT OUTER JOIN
               slxdw.userinfo um3
            ON us3.managerid = um3.userid
         LEFT OUTER JOIN
            slxdw.userinfo un3
         ON UPPER (TRIM (un3.username)) = UPPER (TRIM (ui3.username))    -- SR
            AND un3.region != 'Retired'
 WHERE   td1.fiscal_year >= 2015;

COMMENT ON MATERIALIZED VIEW GKDW.MASTER_QUOTE_MV IS 'snapshot table for snapshot GKDW.MASTER_QUOTE_MV';

GRANT SELECT ON GKDW.MASTER_QUOTE_MV TO DWHREAD;

