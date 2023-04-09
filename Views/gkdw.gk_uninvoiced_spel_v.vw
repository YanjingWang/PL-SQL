DROP VIEW GKDW.GK_UNINVOICED_SPEL_V;

/* Formatted on 29/01/2021 11:24:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_UNINVOICED_SPEL_V
(
   SALES_ORDER_ID,
   CUST_NAME,
   ACCT_NAME,
   EMAIL,
   BILL_TO_ADDRESS1,
   BILL_TO_CITY,
   BILL_TO_STATE,
   BILL_TO_ZIPCODE,
   PROD_NUM,
   ORDER_DATE,
   PAYMENT_METHOD,
   CURR_CODE,
   BOOK_AMT,
   TAXTOTAL,
   TOTAL
)
AS
     SELECT   sf.sales_order_id,
              cd.cust_name,
              cd.acct_name,
              cd.email,
              sf.bill_to_address1,
              bill_to_city,
              bill_to_state,
              bill_to_zipcode,
              sf.prod_num,
              TRUNC (sf.creation_date) order_date,
              sf.payment_method,
              sf.curr_code,
              sf.book_amt,
              es.taxtotal,
              es.total
       FROM         sales_order_fact sf
                 INNER JOIN
                    cust_dim cd
                 ON sf.ordered_by_cust_id = cd.cust_id
              INNER JOIN
                 slxdw.evxso es
              ON sf.sales_order_id = es.evxsoid
      WHERE   record_type = 'SalesOrder' AND so_status IS NULL
   ORDER BY   sf.creation_date DESC;


