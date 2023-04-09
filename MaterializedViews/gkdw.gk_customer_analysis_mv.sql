DROP MATERIALIZED VIEW GKDW.GK_CUSTOMER_ANALYSIS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CUSTOMER_ANALYSIS_MV 
TABLESPACE GDWLRG
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
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
/* Formatted on 29/01/2021 12:25:21 (QP5 v5.115.810.9015) */
  SELECT   td.dim_year,
           td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') dim_qtr,
           td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
           ed.ops_country,
           UPPER (NVL (qa.account_group, ad.acct_name)) group_acct_name,
           nc.naics_code,
           nc.naics_desc,
           nl.naics_description rollup_naics_desc,
           ad.acct_name || ' (' || ad.acct_id || ')' acct_name,
           ad.acct_id,
           ad.city,
           ad.state,
           ad.zipcode,
           ad.province,
           ad.country,
           ad.national_terr_id,
           gt.territory_id territory,
           gt.region,
           gt.salesrep sales_rep,
           gt.region_mgr,
           c.course_ch,
           c.course_mod,
           c.course_pl,
           c.course_type,
           SUM (NVL (f.book_amt, 0)) total_revenue
    FROM                                 cust_dim cd
                                      INNER JOIN
                                         account_dim ad
                                      ON cd.acct_id = ad.acct_id
                                   INNER JOIN
                                      order_fact f
                                   ON cd.cust_id = f.cust_id
                                INNER JOIN
                                   event_dim ed
                                ON f.event_id = ed.event_id
                             INNER JOIN
                                course_dim c
                             ON ed.course_id = c.course_id
                                AND ed.ops_country = c.country
                          INNER JOIN
                             time_dim td
                          ON f.rev_date = td.dim_date
                       INNER JOIN
                          slxdw.qg_account qa
                       ON ad.acct_id = qa.accountid
                    LEFT OUTER JOIN
                       gk_account_groups_naics n
                    ON ad.acct_id = n.acct_id
                 LEFT OUTER JOIN
                    gk_naics_lookup nl
                 ON SUBSTR (NVL (qa.group_naics_code, n.naics_code), 1, 2) =
                       nl.naics_code
              LEFT OUTER JOIN
                 gk_naics_code nc
              ON NVL (qa.group_naics_code, n.naics_code) = nc.naics_code
           LEFT OUTER JOIN
              gk_territory gt
           ON ad.zipcode BETWEEN gt.zip_start AND gt.zip_end
              AND gt.territory_type = 'OB'
   WHERE   td.dim_year >= 2010 AND c.ch_num IN ('10', '20')
GROUP BY   td.dim_year,
           td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0'),
           td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
           ed.ops_country,
           UPPER (NVL (qa.account_group, ad.acct_name)),
           nc.naics_code,
           nc.naics_desc,
           ad.acct_name,
           ad.acct_id,
           ad.city,
           ad.state,
           ad.zipcode,
           ad.province,
           ad.country,
           ad.national_terr_id,
           gt.territory_id,
           gt.region,
           gt.salesrep,
           gt.region_mgr,
           nl.naics_description,
           c.course_ch,
           c.course_mod,
           c.course_pl,
           c.course_type
  HAVING   SUM (NVL (f.book_amt, 0)) > 0;

COMMENT ON MATERIALIZED VIEW GKDW.GK_CUSTOMER_ANALYSIS_MV IS 'snapshot table for snapshot GKDW.GK_CUSTOMER_ANALYSIS_MV';

GRANT SELECT ON GKDW.GK_CUSTOMER_ANALYSIS_MV TO DWHREAD;

