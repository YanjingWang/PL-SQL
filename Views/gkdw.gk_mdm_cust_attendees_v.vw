DROP VIEW GKDW.GK_MDM_CUST_ATTENDEES_V;

/* Formatted on 29/01/2021 11:33:17 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MDM_CUST_ATTENDEES_V
(
   ENROLL_ID,
   CUST_ID,
   BOOK_DATE,
   COURSE_CODE,
   EVENT_DESC,
   EVENT_ID,
   START_DATE,
   END_DATE,
   BOOK_AMT,
   PAYMENT_INFO,
   FACILITY_CODE,
   FACILITY_REGION_METRO,
   ENROLL_STATUS,
   CUST_NAME,
   ACCT_NAME,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   ZIPCODE,
   EMAIL,
   TITLE,
   WORKPHONE,
   EVENT_TYPE,
   EVENT_STATUS,
   DELIVERYMETHOD,
   DURATION
)
AS
   SELECT   o.enroll_id,
            o.cust_id,
            o.book_date,
            ed.course_code,
            ed.event_name,
            ed.event_id,
            ed.start_date,
            ed.end_date,
            o.book_amt,
            o.payment_method payment_info,
            ed.facility_code,
            ed.facility_region_metro,
            o.enroll_status,
            cd.cust_name,
            cd.acct_name,
            cd.address1,
            cd.address2,
            cd.city,
            cd.state,
            cd.zipcode,
            cd.email,
            cd.title,
            cd.workphone,
            ed.event_type,
            ed.status event_status,
            ee.deliverymethod,
            CASE
               WHEN UPPER (uom) LIKE 'DAY%' THEN (DURATION * 8)
               ELSE NULL
            END
               DURATION
     FROM               order_fact o
                     JOIN
                        event_dim ed
                     ON o.event_id = ed.event_id
                  JOIN
                     cust_dim cd
                  ON o.cust_id = cd.cust_id
               JOIN
                  slxdw.evxevent ee
               ON ed.event_id = ee.evxeventid
            LEFT OUTER JOIN
               slxdw.qg_course qc
            ON ed.course_id = qc.evxcourseid
    WHERE   o.enroll_status NOT IN ('Cancelled', 'T')
   --and ed.status <> 'Cancelled'
   --   and o.GKDW_SOURCE = 'SLXDW'
   UNION ALL
   SELECT   so.sales_order_id,
            so.cust_id,
            so.book_date,
            pd.prod_num,
            pd.prod_name,
            pd.product_id,
            DECODE (so.record_type_code, 1, so.ship_date, so.book_date)
               start_date,
            NULL,
            so.book_amt,
            so.payment_method,
            NULL,
            NULL,
            so_status,
            cd.cust_name,
            cd.acct_name,
            cd.address1,
            cd.address2,
            cd.city,
            cd.state,
            cd.zipcode,
            cd.email,
            cd.title,
            cd.workphone,
            so.record_type,
            NULL event_status,
            so.record_type deliverymethod,
            NULL DURATION
     FROM         sales_order_fact so
               JOIN
                  product_dim pd
               ON so.product_id = pd.product_id
            JOIN
               cust_dim cd
            ON so.cust_id = cd.cust_id
    WHERE   NVL (so.so_status, ' ') <> 'Cancelled'
   --   and so.GKDW_SOURCE = 'SLXDW'
   ORDER BY   acct_name,
              start_date,
              cust_id,
              event_type;


