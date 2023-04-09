DROP MATERIALIZED VIEW GKDW.GK_SALES_TERR_TOTAL_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SALES_TERR_TOTAL_MV 
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
/* Formatted on 29/01/2021 12:22:33 (QP5 v5.115.810.9015) */
  SELECT   rev_year,
           territory_id,
           acct_name,
           SUM (public_oe_rev) public_oe_rev,
           RANK ()
              OVER (PARTITION BY territory_id, rev_year
                    ORDER BY SUM (public_oe_rev) DESC)
              public_oe_rank,
           SUM (nonitbt_oe_rev) nonitbt_oe_rev,
           RANK ()
              OVER (PARTITION BY territory_id, rev_year
                    ORDER BY SUM (nonitbt_oe_rev) DESC)
              nonitbt_oe_rank,
           CASE
              WHEN SUM (public_oe_rev) > 16000 THEN 'Tier 1'
              WHEN SUM (public_oe_rev) BETWEEN 6000 AND 16000 THEN 'Tier 2'
              WHEN SUM (public_oe_rev) BETWEEN 3000 AND 5999 THEN 'Tier 3'
              WHEN SUM (public_oe_rev) BETWEEN 1000 AND 2999 THEN 'Tier 4'
              WHEN SUM (public_oe_rev) < 1000 THEN 'Tier 5'
           END
              sales_tier,
           RANK ()
              OVER (
                 PARTITION BY territory_id,
                              rev_year,
                              CASE
                                 WHEN SUM (public_oe_rev) > 16000
                                 THEN
                                    'Tier 1'
                                 WHEN SUM (public_oe_rev) BETWEEN 6000
                                                              AND  16000
                                 THEN
                                    'Tier 2'
                                 WHEN SUM (public_oe_rev) BETWEEN 3000 AND 5999
                                 THEN
                                    'Tier 3'
                                 WHEN SUM (public_oe_rev) BETWEEN 1000 AND 2999
                                 THEN
                                    'Tier 4'
                                 WHEN SUM (public_oe_rev) < 1000
                                 THEN
                                    'Tier 5'
                              END
                 ORDER BY SUM (public_oe_rev) DESC
              )
              tier_oe_rank
    FROM   (  SELECT   rev_year,
                       territory_id,
                       oe.acct_name,
                       SUM (book_amt) public_oe_rev,
                       0 nonitbt_oe_rev
                FROM   gk_open_enrollment_mv oe
               WHERE       rev_year >= 2007
                       --   and (itbt_flag = 'ITBT' or itbt_flag is null)
                       AND ch_flag = 'N'
                       AND nat_flag = 'N'
                       AND mta_flag = 'N'
                       AND event_prod_line != 'OTHER'
                       AND event_modality != 'RESELLER - C-LEARNING'
            GROUP BY   rev_year, oe.acct_name, territory_id
            UNION ALL
              SELECT   rev_year,
                       territory_id,
                       oe.acct_name,
                       0,
                       SUM (book_amt)
                FROM         gk_open_enrollment_mv oe
                          INNER JOIN
                             cust_dim cd
                          ON oe.cust_id = cd.cust_id
                       INNER JOIN
                          gk_territory t
                       ON cd.zipcode BETWEEN t.zip_start AND t.zip_end
               WHERE       rev_year >= 2007
                       AND itbt_flag = 'Non-ITBT'
                       AND ch_flag = 'N'
                       AND nat_flag = 'N'
                       AND mta_flag = 'N'
                       AND event_prod_line != 'OTHER'
                       AND event_modality != 'RESELLER - C-LEARNING'
            GROUP BY   rev_year, oe.acct_name, t.territory_id)
-- where acct_name like 'DRS%'
GROUP BY   rev_year, territory_id, acct_name
  HAVING   SUM (public_oe_rev) > 0;

COMMENT ON MATERIALIZED VIEW GKDW.GK_SALES_TERR_TOTAL_MV IS 'snapshot table for snapshot GKDW.GK_SALES_TERR_TOTAL_MV';

GRANT SELECT ON GKDW.GK_SALES_TERR_TOTAL_MV TO DWHREAD;

