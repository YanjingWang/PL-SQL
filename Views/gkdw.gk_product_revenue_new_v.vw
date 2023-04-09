DROP VIEW GKDW.GK_PRODUCT_REVENUE_NEW_V;

/* Formatted on 29/01/2021 11:29:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_REVENUE_NEW_V
(
   EVENT_ID,
   STATUS,
   EVENT_DESC,
   REV_DATE,
   REV_AMT,
   OPS_COUNTRY,
   FACILITY_REGION_METRO,
   EVENTLENGTH,
   CH_NUM,
   COURSE_CH,
   MD_NUM,
   COURSE_MOD,
   PL_NUM,
   COURSE_PL,
   COURSE_NAME,
   DELIVERY_METHOD,
   DELIVERY_TYPE,
   SALES_CHANNEL,
   PRODUCT_LINE,
   BUSINESS_UNIT,
   VENDOR,
   PRODUCT_TYPE,
   COURSE_CODE,
   REV_YEAR,
   REV_QUARTER,
   REV_MON_NUM,
   REV_MONTH,
   REV_WEEK_NUM,
   ENT_CNT,
   PUBLIC_ENROLL_COUNT,
   PUBLIC_GUEST_COUNT,
   EVENT_HELD_CNT,
   EVENT_SCHED_CNT
)
AS
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
              TRUNC (ed.start_date) rev_date,
              SUM (DECODE (ed.status, 'Cancelled', 0, f.book_amt)) rev_amt,
              ed.ops_country,
              facility_region_metro,
              CASE
                 WHEN nc.nested_course_id IS NOT NULL THEN 0
                 ELSE TRUNC (ed.end_date) - TRUNC (ed.start_date) + 1
              END
                 eventlength,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              cd.course_mod,
              cd.pl_num,
              cd.course_pl,
              cd.course_name,
              ca.delivery_method,
              ca.delivery_type,
              ca.sales_channel,
              ca.product_line,
              ca.business_unit,
              ca.vendor,
              ca.product_type,
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
              tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0')
                 rev_mon_num,
              tdr.dim_year || '-' || tdr.dim_month rev_month,
              tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0') rev_week_num,
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
                                   WHEN ed.status != 'Cancelled'
                                   THEN
                                      ed.event_id
                                   ELSE
                                      NULL
                                END
                    )
              END
                 event_held_cnt,
              CASE
                 WHEN nc.nested_course_id IS NOT NULL THEN 0
                 ELSE COUNT (DISTINCT ed.event_id)
              END
                 event_sched_cnt
       FROM                        order_fact f
                                INNER JOIN
                                   event_dim ed
                                ON f.event_id = ed.event_id
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             gk_course_attributes_v ca
                          ON cd.course_id = ca.course_id
                       INNER JOIN
                          time_dim tdr
                       ON tdr.dim_date =
                             CASE
                                WHEN cd.md_num IN ('32', '44')
                                THEN
                                   TRUNC (f.book_date)
                                ELSE
                                   ed.start_date
                             END        --must use start date for KBI accuracy
                    LEFT OUTER JOIN
                       gk_onsite_attended_cnt_v oa
                    ON ed.event_id = oa.event_id
                 LEFT OUTER JOIN
                    gk_nested_courses nc
                 ON cd.course_id = nc.nested_course_id
              LEFT OUTER JOIN
                 course_dim cd1
              ON nc.master_course_id = cd1.course_id
                 AND ed.ops_country = cd1.country
      WHERE   ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
              AND cd.ch_num IN ('10', '20')
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
              TRUNC (ed.start_date),
              ed.ops_country,
              facility_region_metro,
              TRUNC (ed.end_date) - TRUNC (ed.start_date) + 1,
              NVL (cd.list_price, 0),
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              cd.course_mod,
              cd.pl_num,
              cd.course_pl,
              cd.course_type,
              ca.delivery_method,
              ca.delivery_type,
              ca.sales_channel,
              ca.product_line,
              ca.business_unit,
              ca.vendor,
              ca.product_type,
              cd.course_name,
              cd.course_code || '(' || NVL (TRIM (cd.short_name), ' ') || ')',
                 cd1.course_code
              || '('
              || NVL (TRIM (cd1.short_name), ' ')
              || ')',
              nc.nested_course_id,
              NVL (oa.enroll_cnt, 0),
              tdr.dim_year,
              tdr.dim_year || '-Qtr ' || tdr.dim_quarter,
              tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0'),
              tdr.dim_year || '-' || tdr.dim_month,
              tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0'),
              cd.course_type
   UNION ALL
     SELECT   pd.product_id,
              'Open',
              pd.prod_num,
              NVL (TRUNC (s.rev_date), TRUNC (s.book_date) + 7),
              SUM (s.book_amt),
              'USA',
              'SPEL',
              0,
              pd.ch_num,
              pd.prod_channel,
              pd.md_num,
              pd.prod_modality,
              pd.pl_num,
              pd.prod_line,
              pd.prod_name,
              ca.delivery_method,
              ca.delivery_type,
              ca.sales_channel,
              ca.product_line,
              ca.business_unit,
              ca.vendor,
              ca.product_type,
              pd.prod_num,
              tdr.dim_year,
              tdr.dim_year || '-Qtr ' || tdr.dim_quarter,
              tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0')
                 rev_mon_num,
              tdr.dim_year || '-' || tdr.dim_month,
              tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0'),
              0 ent_count,
              SUM (s.quantity) public_enroll_count,
              0 public_guest_count,
              0,
              0
       FROM                     sales_order_fact s
                             INNER JOIN
                                product_dim pd
                             ON s.product_id = pd.product_id
                          INNER JOIN
                             gk_course_attributes_v ca
                          ON pd.product_id = ca.course_id
                       INNER JOIN
                          time_dim tdr
                       ON TRUNC (s.ship_date) = tdr.dim_date
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
              AND s.ship_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
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
              0,
              pd.ch_num,
              pd.prod_channel,
              pd.md_num,
              pd.prod_modality,
              pd.pl_num,
              pd.prod_line,
              pd.prod_family,
              pd.prod_name,
              ca.delivery_method,
              ca.delivery_type,
              ca.sales_channel,
              ca.product_line,
              ca.business_unit,
              ca.vendor,
              ca.product_type,
              pd.prod_num,
              tdr.dim_year,
              tdr.dim_year || '-Qtr ' || tdr.dim_quarter,
              tdr.dim_year || '-' || LPAD (tdr.dim_month_num, 2, '0'),
              tdr.dim_year || '-' || tdr.dim_month,
              tdr.dim_year || '-' || LPAD (tdr.dim_week, 2, '0');


