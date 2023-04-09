DROP MATERIALIZED VIEW GKDW.GK_ALL_ORDERS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ALL_ORDERS_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:19:27 (QP5 v5.115.810.9015) */
SELECT   f.enroll_id enroll_id,
         f.event_id event_id,
         f.cust_id cust_id,
         f.keycode keycode,
         f.fee_type fee_type,
         f.enroll_status enroll_status,
         f.book_date book_date,
         f.rev_date rev_date,
         f.book_amt book_amt,
         ed.ops_country ops_country,
         ed.country country,
         c.country cust_country,
         event_type event_type,
         facility_region_metro facility_region_metro,
         cd.ch_num ch_num,
         cd.course_ch course_ch,
         cd.md_num md_num,
         cd.course_mod course_mod,
         cd.pl_num pl_num,
         cd.course_pl course_pl,
         cd.course_name course_name,
         cd.course_code course_code,
         a.acct_id acct_id,
         a.acct_name acct_name,
         c.cust_name cust_name,
         DECODE (UPPER (ed.country), 'CANADA', ed.province, ed.state) state,
         c.city cust_city,
         DECODE (UPPER (c.country), 'CANADA', c.province, c.state) cust_state,
         f.salesperson salesperson,
         f.list_price list_price,
         f.source source,
         f.pp_sales_order_id pp_sales_order_id,
         cd.course_type course_type,
         cd.course_group course_group,
         c.zipcode zipcode,
         SUBSTR (c.zipcode, 1, 3) cust_scf,
         'Enrollment' order_type,
         ed.status event_status,
         ed.start_date event_start_date,
         ED.END_DATE event_end_Date,
         f.payment_method,
         f.ppcard_id,
         f.sf_opportunity_id
  FROM                     order_fact f
                        INNER JOIN
                           time_dim td
                        ON td.dim_date = TRUNC (SYSDATE)
                     INNER JOIN
                        time_dim td1
                     ON f.book_date = td1.dim_date
                  INNER JOIN
                     event_dim ed
                  ON f.event_id = ed.event_id
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            INNER JOIN
               cust_dim c
            ON UPPER (f.cust_id) = UPPER (c.cust_id)
         INNER JOIN
            account_dim a
         ON c.acct_id = a.acct_id
 WHERE   td1.dim_year >= td.dim_year - 4
UNION ALL
SELECT   s.sales_order_id,
         NULL,
         s.cust_id,
         s.keycode,
         'Product',
         s.so_status,
         TRUNC (s.book_date),
         TRUNC (s.rev_date),
         s.book_amt,
         'USA',
         s.country,
         c.country cust_country,
         s.record_type,
         s.metro_area,
         pd.ch_num,
         pd.prod_channel,
         pd.md_num,
         pd.prod_modality,
         pd.pl_num,
         pd.prod_line,
         pd.prod_name,
         pd.prod_num,
         a.acct_id,
         a.acct_name,
         c.cust_name,
         'SPEL' state,
         c.city cust_city,
         DECODE (UPPER (c.country), 'CANADA', c.province, c.state) cust_state,
         s.salesperson,
         esd.actualnetrate,
         s.source,
         s.pp_sales_order_id,
         NULL,
         pd.prod_family,
         c.zipcode,
         SUBSTR (c.zipcode, 1, 3),
         'Sales Order',
         NULL,
         TRUNC (s.book_date),
         TRUNC (s.book_date),
         s.payment_method,
         s.ppcard_id,
         ''
  FROM                     sales_order_fact s
                        INNER JOIN
                           time_dim td
                        ON td.dim_date = TRUNC (SYSDATE)
                     INNER JOIN
                        time_dim td1
                     ON TRUNC (s.book_date) = td1.dim_date
                  INNER JOIN
                     product_dim pd
                  ON s.product_id = pd.product_id
               INNER JOIN
                  cust_dim c
               ON UPPER (s.cust_id) = UPPER (c.cust_id)
            INNER JOIN
               account_dim a
            ON c.acct_id = a.acct_id
         INNER JOIN
            slxdw.evxsodetail esd
         ON s.sales_order_id = esd.evxsoid
 WHERE   s.record_type = 'SalesOrder' AND td1.dim_year >= td.dim_year - 4
UNION ALL
SELECT   s.sales_order_id,
         NULL,
         s.cust_id,
         s.keycode,
         'Product',
         s.so_status,
         TRUNC (s.book_date),
         TRUNC (s.rev_date),
         s.book_amt,
         'USA',
         s.country,
         c.country cust_country,
         s.record_type,
         s.metro_area,
         pd.ch_num,
         pd.prod_channel,
         pd.md_num,
         pd.prod_modality,
         pd.pl_num,
         pd.prod_line,
         pd.prod_name,
         pd.prod_num,
         a.acct_id,
         a.acct_name,
         c.cust_name,
         'Prepay' state,
         c.city cust_city,
         DECODE (UPPER (c.country), 'CANADA', c.province, c.state) cust_state,
         s.salesperson,
         esd.actualnetrate,
         s.source,
         s.pp_sales_order_id,
         NULL,
         pd.prod_family,
         c.zipcode,
         SUBSTR (c.zipcode, 1, 3),
         'Prepay',
         NULL,
         TRUNC (s.book_date),
         TRUNC (s.book_date),
         s.payment_method,
         s.ppcard_id,
         ''
  FROM                     sales_order_fact s
                        INNER JOIN
                           time_dim td
                        ON td.dim_date = TRUNC (SYSDATE)
                     INNER JOIN
                        time_dim td1
                     ON TRUNC (s.book_date) = td1.dim_date
                  INNER JOIN
                     product_dim pd
                  ON s.product_id = pd.product_id
               INNER JOIN
                  cust_dim c
               ON UPPER (s.cust_id) = UPPER (c.cust_id)
            INNER JOIN
               account_dim a
            ON c.acct_id = a.acct_id
         INNER JOIN
            slxdw.evxsodetail esd
         ON s.sales_order_id = esd.evxsoid
 WHERE   s.record_type = 'Prepay Order' AND td1.dim_year >= td.dim_year - 4;

COMMENT ON MATERIALIZED VIEW GKDW.GK_ALL_ORDERS_MV IS 'snapshot table for snapshot GKDW.GK_ALL_ORDERS_MV';

CREATE INDEX GKDW.GK_ALL_ORDERS_MV_IDX ON GKDW.GK_ALL_ORDERS_MV
(CUST_ID)
LOGGING
TABLESPACE GDWIDX
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
NOPARALLEL;

GRANT SELECT ON GKDW.GK_ALL_ORDERS_MV TO DWHREAD;

