DROP MATERIALIZED VIEW GKDW.GK_PRODUCT_KBI_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PRODUCT_KBI_MV 
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
/* Formatted on 29/01/2021 12:23:14 (QP5 v5.115.810.9015) */
  SELECT   ed.event_id,
           ed.status,
              cd.course_code
           || '-'
           || facility_region_metro
           || '-'
           || TO_CHAR (ed.start_date, 'yymmdd')
           || '('
           || ed.event_id
           || ')'
              event_desc,
           --TRUNC (ed.start_date) rev_date,
           CASE
              WHEN cd.md_num IN ('32', '33', '44') THEN TRUNC (f.book_date)
              ELSE TRUNC (ed.start_date)
           END
              rev_date,
           SUM (DECODE (ed.status, 'Cancelled', 0, f.book_amt)) rev_amt,
           CASE
              WHEN cd.md_num IN ('20', '32', '33', '44')
                   AND UPPER (c.country) = 'CANADA'
              THEN
                 'CANADA'
              WHEN cd.md_num IN ('20', '32', '33', '44')
              THEN
                 'USA'
              ELSE
                 ed.ops_country
           END
              ops_country,
           event_type,
           facility_region_metro,
           ED.LOCATION_NAME,
           CASE WHEN ED.CONNECTED_C = 'Y' THEN 'Y' ELSE 'N' END connected_C,
           CASE WHEN ED.CONNECTED_V_TO_C IS NOT NULL THEN 'Y' ELSE 'N' END
              connected_V,
           CASE
              WHEN nc.nested_course_id IS NOT NULL THEN 0
              ELSE TRUNC (ed.end_date) - TRUNC (ed.start_date) + 1
           END
              eventlength,
           NVL (cd.list_price, 0) list_price,
           cd.ch_num,
           cd.course_ch,
           cd.md_num,
           CASE
              WHEN cd.course_code LIKE '%Z' THEN 'EXTENDED V-LEARNING'
              ELSE cd.course_mod
           END
              course_mod,
           cd.pl_num,
           cd.course_pl,
           cd.course_name,
           CASE
              WHEN nc.nested_course_id IS NOT NULL
              THEN
                    cd1.course_code
                 || '('
                 || NVL (TRIM (cd1.short_name), ' ')
                 || ')'
              ELSE
                    cd.course_code
                 || '('
                 || NVL (TRIM (cd.short_name), ' ')
                 || ')'
           END
              course_code,
           tdr.dim_year rev_year,
           tdr.dim_year || '-Qtr ' || tdr.dim_quarter rev_quarter,
           tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0') rev_mon_num,
           tdr.dim_year || '-' || tdr.dim_month rev_month,
           tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0') rev_week_num,
           tde.dim_year start_year,
           tde.dim_year || '-Qtr ' || tde.dim_quarter start_quarter,
           tde.dim_year || '-' || LPAD (tde.dim_month_num, 2, '0')
              start_mon_num,
           tde.dim_year || '-' || tde.dim_month start_month,
           tde.dim_year || '-' || LPAD (tde.dim_week, 2, '0') start_week_num,
           NVL (oa.enroll_cnt, 0) ent_cnt,
           SUM(CASE
                  WHEN     cd.ch_num <> '20'
                       AND f.enroll_status IN ('Attended', 'Confirmed')
                       AND f.book_amt <> 0
                  THEN
                     1
                  ELSE
                     0
               END)
              public_enroll_count,
           SUM(CASE
                  WHEN     cd.ch_num <> '20'
                       AND f.enroll_status IN ('Attended', 'Confirmed')
                       AND f.book_amt = 0
                  THEN
                     1
                  ELSE
                     0
               END)
              public_guest_count,
           CASE
              WHEN nc.nested_course_id IS NOT NULL
              THEN
                 0
              ELSE
                 COUNT (
                    DISTINCT CASE
                                WHEN ed.status != 'Cancelled' THEN ed.event_id
                                ELSE NULL
                             END
                 )
           END
              event_held_cnt,
           CASE
              WHEN nc.nested_course_id IS NOT NULL THEN 0
              ELSE COUNT (DISTINCT ed.event_id)
           END
              event_sched_cnt,
           cd.course_type,
           fr.region facility_region,
           CASE WHEN x.course_code IS NOT NULL THEN 'XBox' ELSE NULL END
              promo_type,
           cd.vendor_code,
           cd.ibm_tech_grp,
           CD.SUBTECH_TYPE1 tech_sub_type1,
           CD.SUBTECH_TYPE2 tech_sub_type2,
           pl.vendor_name PDM_VENDOR,
           CD.ROOT_CODE root_code,
           cd.product_manager product_manager,
           CD.LINE_OF_BUSINESS line_of_business
    FROM                                    order_fact f
                                         INNER JOIN
                                            event_dim ed
                                         ON f.event_id = ed.event_id
                                      INNER JOIN
                                         course_dim cd
                                      ON ed.course_id = cd.course_id
                                         AND ed.ops_country = cd.country
                                   INNER JOIN
                                      cust_dim c
                                   ON f.cust_id = c.cust_id
                                INNER JOIN
                                   time_dim tdr
                                ON tdr.dim_date =
                                      CASE
                                         WHEN cd.md_num IN ('32', '33', '44')
                                         THEN
                                            TRUNC (f.book_date)
                                         ELSE
                                            ed.start_date
                                      END --must use start date for kbi accuracy
                             LEFT JOIN
                                time_dim tde
                             ON tde.dim_date = ed.start_date -- Added to provide start_Date as a dim
                          LEFT OUTER JOIN
                             gk_onsite_attended_cnt_v oa
                          ON ed.event_id = oa.event_id
                       LEFT OUTER JOIN
                          gk_facility_region_mv fr
                       ON ed.location_id = fr.evxfacilityid
                          AND ed.facility_region_metro = fr.facilityregionmetro
                    LEFT OUTER JOIN
                       gk_nested_courses nc
                    ON cd.course_id = nc.nested_course_id
                 LEFT OUTER JOIN
                    course_dim cd1
                 ON nc.master_course_id = cd1.course_id
                    AND ed.ops_country = cd1.country
              LEFT OUTER JOIN
                 xbox_promo x
              ON ed.course_code = x.course_code
           LEFT OUTER JOIN
              "gk_product_list"@rms_prod pl
           ON CD.COURSE_ID = pl."SLX_COURSE_ID"
   WHERE   TDr.DIM_YEAR >= TO_CHAR (SYSDATE, 'YYYY') - 3 /** Rolling 3 year filter added by Sumitra - 10/20/2015 *************/
                                                         --ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
           AND cd.ch_num IN ('10', '20', '40')
           AND cd.short_name NOT IN
                    ('0 CLASSROOM TRAINING FEE', 'RHCT SUCCESS PACK')
           AND cd.course_code NOT IN ('097')
GROUP BY   ed.event_id,
           ed.status,
              cd.course_code
           || '-'
           || facility_region_metro
           || '-'
           || TO_CHAR (ed.start_date, 'yymmdd')
           || '('
           || ed.event_id
           || ')',
           --TRUNC (ed.start_date),
           CASE
              WHEN cd.md_num IN ('32', '33', '44') THEN TRUNC (f.book_date)
              ELSE TRUNC (ed.start_date)
           END,
           UPPER (c.country),
           ed.ops_country,
           event_type,
           facility_region_metro,
           ED.LOCATION_NAME,
           CASE WHEN ED.CONNECTED_C = 'Y' THEN 'Y' ELSE 'N' END, -- Connected c flag
           CASE WHEN ED.CONNECTED_V_TO_C IS NOT NULL THEN 'Y' ELSE 'N' END, -- Connected V flag
           TRUNC (ed.end_date) - TRUNC (ed.start_date) + 1,
           NVL (cd.list_price, 0),
           cd.ch_num,
           cd.course_ch,
           cd.md_num,
           CASE
              WHEN cd.course_code LIKE '%Z' THEN 'EXTENDED V-LEARNING'
              ELSE cd.course_mod
           END,
           cd.pl_num,
           cd.course_pl,
           cd.course_type,
           cd.course_name,
           cd.course_code || '(' || NVL (TRIM (cd.short_name), ' ') || ')',
           cd1.course_code || '(' || NVL (TRIM (cd1.short_name), ' ') || ')',
           nc.nested_course_id,
           NVL (oa.enroll_cnt, 0),
           tdr.dim_year,
           tdr.dim_year || '-Qtr ' || tdr.dim_quarter,
           tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0'),
           tdr.dim_year || '-' || tdr.dim_month,
           tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0'),
           tde.dim_year,
           tde.dim_year || '-Qtr ' || tde.dim_quarter,
           tde.dim_year || '-' || LPAD (tde.dim_month_num, 2, '0'),
           tde.dim_year || '-' || tde.dim_month,
           tde.dim_year || '-' || LPAD (tde.dim_week, 2, '0'),
           cd.course_type,
           fr.region,
           x.course_code,
           cd.vendor_code,
           cd.ibm_tech_grp,
           CD.SUBTECH_TYPE1,
           CD.SUBTECH_TYPE2,
           pl.vendor_name,
           cd.root_code,
           cd.product_manager,
           cd.line_of_business
UNION ALL
  SELECT   pd.product_id,
           'Open',
           pd.prod_num,
           NVL (TRUNC (s.rev_date), TRUNC (s.book_date) + 7),
           SUM (s.book_amt),
           'USA',
           s.record_type,
           'SPEL',
           'SPEL',
           'N',
           'N',
           0,
           NVL (pd.list_price, 0),
           pd.ch_num,
           pd.prod_channel,
           pd.md_num,
           pd.prod_modality,
           pd.pl_num,
           pd.prod_line,
           pd.prod_name,
           pd.prod_num,
           tdr.dim_year,
           tdr.dim_year || '-Qtr ' || tdr.dim_quarter,
           tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0') rev_mon_num,
           tdr.dim_year || '-' || tdr.dim_month,
           tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0'),
           tde.dim_year,
           tde.dim_year || '-Qtr ' || tde.dim_quarter,
           tde.dim_year || '-' || LPAD (tde.dim_month_num, 2, '0'),
           tde.dim_year || '-' || tde.dim_month,
           tde.dim_year || '-' || LPAD (tde.dim_week, 2, '0'),
           0 ent_count,
           SUM (s.quantity) public_enroll_count,
           0 public_guest_count,
           0,
           0,
           pd.prod_family,
           'SPEL',
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL PDM_VENDOR,
           NULL root_Code,
           NULL product_manager,
           NULL line_of_business
    FROM                     sales_order_fact s
                          INNER JOIN
                             product_dim pd
                          ON s.product_id = pd.product_id
                       INNER JOIN
                          time_dim tdr
                       ON TRUNC (s.ship_date) = tdr.dim_date
                    INNER JOIN
                       time_dim tde
                    ON TRUNC (s.ship_date) = tde.dim_date
                 INNER JOIN
                    cust_dim c
                 ON s.cust_id = c.cust_id
              INNER JOIN
                 account_dim a
              ON c.acct_id = a.acct_id
           INNER JOIN
              slxdw.evxso es
           ON s.sales_order_id = es.evxsoid
   WHERE       s.record_type = 'SalesOrder'
           AND TDr.DIM_YEAR >= TO_CHAR (SYSDATE, 'YYYY') - 3 /** Rolling 3 year filter added by Sumitra - 10/20/2015 *************/
           --AND s.ship_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
           AND s.cancel_date IS NULL
           AND s.book_amt <> 0
           AND pd.prod_name NOT IN
                    ('0 CLASSROOM TRAINING FEE', 'RHCT SUCCESS PACK')
           AND pd.prod_num NOT IN ('097')
GROUP BY   pd.product_id,
           pd.prod_num,
           NVL (TRUNC (s.rev_date), TRUNC (s.book_date) + 7),
           'USA',
           s.record_type,
           'SPEL',
           'SPEL',
           0,
           'N',
           'N',
           NVL (pd.list_price, 0),
           pd.ch_num,
           pd.prod_channel,
           pd.md_num,
           pd.prod_modality,
           pd.pl_num,
           pd.prod_line,
           pd.prod_family,
           pd.prod_name,
           pd.prod_num,
           tdr.dim_year,
           tdr.dim_year || '-Qtr ' || tdr.dim_quarter,
           tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0'),
           tdr.dim_year || '-' || tdr.dim_month,
           tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0'),
           tde.dim_year,
           tde.dim_year || '-Qtr ' || tde.dim_quarter,
           tde.dim_year || '-' || LPAD (tde.dim_month_num, 2, '0'),
           tde.dim_year || '-' || tde.dim_month,
           tde.dim_year || '-' || LPAD (tde.dim_week, 2, '0');

COMMENT ON MATERIALIZED VIEW GKDW.GK_PRODUCT_KBI_MV IS 'snapshot table for snapshot GKDW.GK_PRODUCT_KBI_MV';

GRANT SELECT ON GKDW.GK_PRODUCT_KBI_MV TO DWHREAD;

