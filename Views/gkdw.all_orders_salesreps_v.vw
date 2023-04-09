DROP VIEW GKDW.ALL_ORDERS_SALESREPS_V;

/* Formatted on 29/01/2021 11:21:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.ALL_ORDERS_SALESREPS_V
(
   ORDER_ID,
   EVENT_ID,
   PROD_NAME,
   PRODUCT_ID,
   ENROLL_DATE,
   ENROLL_STATUS,
   BOOK_AMT,
   BILL_DATE,
   BILL_STATUS,
   CURR_CODE,
   TAKER,
   CUST_ID,
   CUST_NAME,
   ZIPCODE,
   COUNTRY,
   STATE,
   WORKPHONE,
   EMAIL,
   TITLE,
   SALESREP,
   TERRITORY_ID
)
AS
   SELECT   sales_order_id order_id,
            NULL event_id,
            p.prod_name,
            p.product_id,
            TRUNC (so.creation_date) enroll_date,
            so.record_type enroll_status,
            book_amt,
            TRUNC (bill_date),
            bill_status,
            curr_code,
            salesperson taker,
            cust_id,
            c.cust_name,
            c.zipcode,
            so.country,
            DECODE (UPPER (c.country), 'CANADA', c.province, c.state) state,
            c.workphone,
            c.email,
            NVL (TRIM (c.title), 'N/A'),
            g.salesrep,
            g.territory_id
     FROM            sales_order_fact so
                  LEFT OUTER JOIN
                     product_dim p
                  ON so.product_id = p.product_id
               LEFT OUTER JOIN
                  cust_dim c
               ON so.cust_id = c.cust_id
            LEFT OUTER JOIN
               gk_territory g
            ON SUBSTR (c.zipcode, 1, 5) BETWEEN g.zip_start
                                            AND  SUBSTR (g.zip_end, 1, 5)
               AND DECODE (UPPER (c.country), 'CANADA', c.province, c.state) =
                     TRIM (UPPER (g.state))
   UNION ALL
   SELECT   enroll_id order_id,
            o.event_id,
            e.course_code,
            e.course_id,
            TRUNC (enroll_date),
            enroll_status,
            book_amt,
            TRUNC (bill_date),
            bill_status,
            curr_code,
            salesperson,
            c.cust_id,
            cust_name,
            c.zipcode,
            o.country,
            DECODE (UPPER (c.country), 'CANADA', c.province, c.state) state,
            c.workphone,
            c.email,
            NVL (TRIM (c.title), 'N/A'),
            g.salesrep,
            g.territory_id
     FROM            order_fact o
                  LEFT OUTER JOIN
                     event_dim e
                  ON o.event_id = e.event_id
               LEFT OUTER JOIN
                  cust_dim c
               ON o.cust_id = c.cust_id
            LEFT OUTER JOIN
               gk_territory g
            ON SUBSTR (c.zipcode, 1, 5) BETWEEN g.zip_start
                                            AND  SUBSTR (g.zip_end, 1, 5)
               AND DECODE (UPPER (c.country), 'CANADA', c.province, c.state) =
                     TRIM (UPPER (g.state));


