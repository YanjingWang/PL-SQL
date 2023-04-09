DROP MATERIALIZED VIEW GKDW.MASTER_ENT_OE_BOOKING_MV;
CREATE MATERIALIZED VIEW GKDW.MASTER_ENT_OE_BOOKING_MV 
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
/* Formatted on 29/01/2021 12:20:17 (QP5 v5.115.810.9015) */
SELECT   DISTINCT 'Onsite' TYPE,
                  enroll_id,
                  me.event_id,
                  cust_id,
                  ch_num,
                  course_ch,
                  md_num,
                  course_mod,
                  pl_num,
                  course_pl,
                  start_date,
                  end_date,
                  course_code,
                  course_name,
                  short_name,
                  ops_country,
                  enroll_date,
                  sale_date,
                  sale_date book_date,
                  rev_date,
                  book_amt,
                  list_price,
                  curr_code,
                  NULL keycode,
                  NULL source,
                  salesperson,
                  sold_by,
                  enroll_type,
                  country,
                  enroll_status,
                  fee_type,
                  payment_method,
                  ppcard_id,
                  po_number,
                  acct_id,
                  me.account acct_name,
                  acct_city,
                  acct_state,
                  acct_zipcode,
                  acct_country,
                  cust_first_name,
                  cust_last_name,
                  cust_name,
                  email,
                  address1,
                  address2,
                  cust_city,
                  cust_workphone,
                  cust_state,
                  cust_zipcode,
                  cust_country,
                  NULL partner_key_code,
                  NULL partner_name,
                  NULL ob_comm_type,
                  --       SEGMENT,
                  --       SL_SALES_REP,
                  --       SL_OB_TERR,
                  --       SL_FIELD_TERR,
                  --       ZIP_SALES_REP,
                  --       ZIP_TERR,
                  --       SALES_TERR_ID,
                  --       SALES_REP,
                  --       SALES_MANAGER,
                  --       SALES_REGION,
                  pos_year,
                  pos_qtr,
                  pos_month,
                  pos_month_name,
                  pos_period,
                  pos_week,
                  pod_year,
                  pod_qtr,
                  pod_month,
                  pod_month_name,
                  pod_period,
                  pod_week,
                  gk_vertical,
                  farm_flag,
                  fscl_pos_year,
                  fscl_pos_qtr,
                  fscl_pos_month,
                  fscl_pos_month_name,
                  fscl_pos_period,
                  fscl_pos_week,
                  fscl_pod_year,
                  fscl_pod_qtr,
                  fscl_pod_month,
                  fscl_pod_month_name,
                  fscl_pod_period,
                  fscl_pod_week,
                  promo_adj,
                  comm_amt,
                  bookings_country,
                  fiscal_week,
                  fiscal_month_num,
                  fiscal_month,
                  fiscal_period_name,
                  fiscal_quarter,
                  fiscal_year,
                  accts.customer_name,
                  accts.segment,
                  accts.ob_terr,
                  accts.country segments_country,
                  tz.terr_id,
                  --salesrep,
                  ed.course_id,
                  ed.event_desc,
                  ed.facility_region_metro,
                  ed.zipcode event_zipcode,
                  cd.course_type
  FROM                  master_ent_bookings_mv me
                     LEFT OUTER JOIN
                        time_dim td
                     ON me.sale_date = td.dim_date
                  LEFT OUTER JOIN
                     gk_account_segments_mv accts
                  ON me.acct_id = accts.accountid
               LEFT OUTER JOIN
                  gk_territory_zip_mv tz
               ON tz.salesrep = me.salesperson
            LEFT OUTER JOIN
               event_dim ed
            ON ed.event_id = me.event_id
         LEFT OUTER JOIN
            course_dim cd
         ON cd.course_id = ed.course_id AND cd.country = ed.ops_country
UNION
SELECT   DISTINCT 'OE' TYPE,
                  enroll_id,
                  event_id,
                  cust_id,
                  ch_num,
                  course_ch,
                  md_num,
                  course_mod,
                  pl_num,
                  course_pl,
                  start_date,
                  end_date,
                  course_code,
                  course_name,
                  short_name,
                  ops_country,
                  enroll_date,
                  sale_date,
                  sale_date book_date,
                  rev_date,
                  book_amt,
                  mo.list_price,
                  curr_code,
                  keycode,
                  source,
                  salesperson,
                  salesperson sold_by,
                  enroll_type,
                  country,
                  enroll_status,
                  fee_type,
                  payment_method,
                  ppcard_id,
                  po_number,
                  acct_id,
                  mo.acct_name,
                  acct_city,
                  acct_state,
                  acct_zipcode,
                  acct_country,
                  cust_first_name,
                  cust_last_name,
                  cust_name,
                  email,
                  address1,
                  address2,
                  cust_city,
                  cust_workphone,
                  cust_state,
                  cust_zipcode,
                  cust_country,
                  partner_key_code,
                  partner_name,
                  ob_comm_type,
                  --       TO_CHAR (SEGMENT) SEGMENT,
                  --       TO_CHAR (SL_SALES_REP) SL_SALES_REP,
                  --       SL_OB_TERR,
                  --       SL_FIELD_TERR,
                  --       ZIP_SALES_REP,
                  --       ZIP_TERR,
                  --       SALES_TERR_ID,
                  --       SALES_REP,
                  --       SALES_MANAGER,
                  --       SALES_REGION,
                  pos_year,
                  pos_qtr,
                  pos_month,
                  pos_month_name,
                  pos_period,
                  pos_week,
                  pod_year,
                  pod_qtr,
                  pod_month,
                  pod_month_name,
                  pod_period,
                  pod_week,
                  gk_vertical,
                  farm_flag,
                  fscl_pos_year,
                  fscl_pos_qtr,
                  fscl_pos_month,
                  fscl_pos_month_name,
                  fscl_pos_period,
                  fscl_pos_week,
                  fscl_pod_year,
                  fscl_pod_qtr,
                  fscl_pod_month,
                  fscl_pod_month_name,
                  fscl_pod_period,
                  fscl_pod_week,
                  promo_adj,
                  comm_amt,
                  bookings_country,
                  fiscal_week,
                  fiscal_month_num,
                  fiscal_month,
                  fiscal_period_name,
                  fiscal_quarter,
                  fiscal_year,
                  accts.customer_name,
                  accts.segment,
                  accts.ob_terr,
                  accts.country segments_country,
                  tz.terr_id,
                  --salesrep,
                  ed.course_id,
                  ed.event_desc,
                  ed.facility_region_metro,
                  ed.zipcode event_zipcode,
                  cd.course_type
  FROM                  master_oe_bookings_mv mo
                     LEFT OUTER JOIN
                        time_dim td
                     ON mo.sale_date = td.dim_date
                  LEFT OUTER JOIN
                     gk_account_segments_mv accts
                  ON mo.acct_id = accts.accountid
               LEFT OUTER JOIN
                  gk_territory_zip_mv tz
               ON tz.salesrep = mo.salesperson
            LEFT OUTER JOIN
               event_dim ed
            ON ed.event_id = mo.event_id
         LEFT OUTER JOIN
            course_dim cd
         ON cd.course_id = ed.course_id AND cd.country = ed.ops_country;

COMMENT ON MATERIALIZED VIEW GKDW.MASTER_ENT_OE_BOOKING_MV IS 'snapshot table for snapshot GKDW.MASTER_ENT_OE_BOOKING_MV';

