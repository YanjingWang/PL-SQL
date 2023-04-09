DROP VIEW GKDW.GK_CUSTOMER_REVENUE_CUBE_V;

/* Formatted on 29/01/2021 11:38:41 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CUSTOMER_REVENUE_CUBE_V
(
   DIM_YEAR,
   DIM_QTR,
   DIM_MONTH,
   OPS_COUNTRY,
   GROUP_ACCT_NAME,
   NAICS_DESC,
   ROLLUP_NAICS_DESC,
   ACCT_NAME,
   ACCT_ID,
   CITY,
   STATE,
   ZIPCODE,
   PROVINCE,
   COUNTRY,
   NATIONAL_TERR_ID,
   TERRITORY,
   REGION,
   SALES_REP,
   REGION_MGR,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   TOTAL_REVENUE
)
AS
     SELECT   td.dim_year,
              td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') dim_qtr,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
              ed.ops_country,
              UPPER (NVL (n.group_acct_name, ad.acct_name)) group_acct_name,
              NVL (n.group_naics_desc, n.naics_desc) naics_desc,
              nl.naics_description rollup_naics_desc,
              ad.acct_name || ' (' || ad.acct_id || ')' acct_name,
              ad.acct_id,
              ad.city,
              ad.state,
              ad.zipcode,
              ad.province,
              ad.country,
              ad.national_terr_id,
              md.territory,
              md.region,
              md.sales_rep,
              md.region_mgr,
              c.course_ch,
              c.course_mod,
              c.course_pl,
              c.course_type,
              SUM (NVL (f.book_amt, 0)) total_revenue
       FROM                           cust_dim cd
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
                       ON f.book_date = td.dim_date
                    LEFT OUTER JOIN
                       gk_account_groups_naics n
                    ON ad.acct_id = n.acct_id
                 LEFT OUTER JOIN
                    gk_naics_lookup nl
                 ON SUBSTR (NVL (n.group_naics_code, n.naics_code), 1, 2) =
                       nl.naics_code
              LEFT OUTER JOIN
                 market_dim md
              ON CASE
                    WHEN cd.country = 'USA' THEN SUBSTR (ad.zipcode, 1, 5)
                    ELSE ad.zipcode
                 END = md.zipcode
      WHERE   td.dim_year >= 2010 AND c.ch_num IN ('10', '20')
   GROUP BY   td.dim_year,
              td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0'),
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              ed.ops_country,
              UPPER (NVL (n.group_acct_name, ad.acct_name)),
              NVL (n.group_naics_desc, n.naics_desc),
              ad.acct_name,
              ad.acct_id,
              ad.city,
              ad.state,
              ad.zipcode,
              ad.province,
              ad.country,
              ad.national_terr_id,
              md.territory,
              md.region,
              md.sales_rep,
              md.region_mgr,
              nl.naics_description,
              c.course_ch,
              c.course_mod,
              c.course_pl,
              c.course_type
     HAVING   SUM (NVL (f.book_amt, 0)) > 0;


