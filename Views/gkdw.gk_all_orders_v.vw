DROP VIEW GKDW.GK_ALL_ORDERS_V;

/* Formatted on 29/01/2021 11:43:01 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_ALL_ORDERS_V
(
   ENROLL_ID,
   EVENT_ID,
   CUST_ID,
   KEYCODE,
   FEE_TYPE,
   ENROLL_STATUS,
   BOOK_DATE,
   REV_DATE,
   BOOK_AMT,
   OPS_COUNTRY,
   COUNTRY,
   CUST_COUNTRY,
   EVENT_TYPE,
   FACILITY_REGION_METRO,
   CH_NUM,
   COURSE_CH,
   MD_NUM,
   COURSE_MOD,
   PL_NUM,
   COURSE_PL,
   COURSE_NAME,
   COURSE_CODE,
   ACCT_ID,
   ACCT_NAME,
   CUST_NAME,
   STATE,
   CUST_STATE,
   SALESPERSON,
   LIST_PRICE,
   SOURCE,
   PP_SALES_ORDER_ID,
   COURSE_TYPE,
   COURSE_GROUP,
   ZIPCODE,
   CUST_SCF,
   ORDER_TYPE,
   EVENT_STATUS,
   EVENT_START_DATE,
   PAYMENT_METHOD,
   SF_OPPORTUNITY_ID
)
AS
   SELECT   f.enroll_id,
            f.event_id,
            f.cust_id,
            f.keycode,
            f.fee_type,
            f.enroll_status,
            f.book_date,
            f.rev_date,
            f.book_amt,
            ed.ops_country,
            ed.country,
            c.country cust_country,
            event_type,
            facility_region_metro,
            cd.ch_num,
            cd.course_ch,
            cd.md_num,
            cd.course_mod,
            cd.pl_num,
            cd.course_pl,
            cd.course_name,
            cd.course_code,
            a.acct_id,
            a.acct_name,
            c.cust_name,
            DECODE (UPPER (ed.country), 'CANADA', ed.province, ed.state)
               state,
            DECODE (UPPER (c.country), 'CANADA', c.province, c.state)
               cust_state,
            f.salesperson,
            f.list_price,
            f.SOURCE,
            f.pp_sales_order_id,
            cd.course_type,
            cd.course_group,
            c.zipcode,
            SUBSTR (c.zipcode, 1, 3),
            'Enrollment',
            ed.status,
            ed.start_date,
            f.payment_method,
            f.sf_opportunity_id
     FROM               order_fact f
                     LEFT OUTER JOIN
                        event_dim ed
                     ON f.event_id = ed.event_id
                  LEFT OUTER JOIN
                     course_dim cd
                  ON ed.course_id = cd.course_id
                     AND ed.ops_country = cd.country
               LEFT OUTER JOIN
                  cust_dim c
               ON f.cust_id = c.cust_id
            LEFT OUTER JOIN
               account_dim a
            ON c.acct_id = a.acct_id
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
            DECODE (UPPER (c.country), 'CANADA', c.province, c.state)
               cust_state,
            s.salesperson,
            esd.actualnetrate,
            s.SOURCE,
            s.pp_sales_order_id,
            NULL,
            pd.prod_family,
            c.zipcode,
            SUBSTR (c.zipcode, 1, 3),
            'Sales Order',
            NULL,
            TRUNC (s.book_date),
            s.payment_method,
            NULL
     FROM               sales_order_fact s
                     LEFT OUTER JOIN
                        product_dim pd
                     ON s.product_id = pd.product_id
                  LEFT OUTER JOIN
                     cust_dim c
                  ON s.cust_id = c.cust_id
               LEFT OUTER JOIN
                  account_dim a
               ON c.acct_id = a.acct_id
            LEFT OUTER JOIN
               slxdw.evxsodetail esd
            ON s.sales_order_id = esd.evxsoid
    WHERE   s.record_type = 'SalesOrder'
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
            DECODE (UPPER (c.country), 'CANADA', c.province, c.state)
               cust_state,
            s.salesperson,
            esd.actualnetrate,
            s.SOURCE,
            s.pp_sales_order_id,
            NULL,
            pd.prod_family,
            c.zipcode,
            SUBSTR (c.zipcode, 1, 3),
            'Prepay',
            NULL,
            TRUNC (s.book_date),
            s.payment_method,
            NULL
     FROM               sales_order_fact s
                     LEFT OUTER JOIN
                        product_dim pd
                     ON s.product_id = pd.product_id
                  LEFT OUTER JOIN
                     cust_dim c
                  ON s.cust_id = c.cust_id
               LEFT OUTER JOIN
                  account_dim a
               ON c.acct_id = a.acct_id
            LEFT OUTER JOIN
               slxdw.evxsodetail esd
            ON s.sales_order_id = esd.evxsoid
    WHERE   s.record_type = 'Prepay Order';


