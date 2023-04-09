DROP VIEW GKDW.GK_PROMO_AUDIT_ALL_V;

/* Formatted on 29/01/2021 11:28:48 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_AUDIT_ALL_V
(
   ENROLL_ID,
   ENROLL_STATUS,
   EVENT_ID,
   CUST_ID,
   CUST_NAME,
   ACCT_NAME,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   ZIPCODE,
   PHONE_NUMBER,
   EMAIL,
   ENROLL_DATE,
   BOOK_DATE,
   KEYCODE,
   BOOK_AMT,
   LIST_PRICE,
   PO_NUMBER,
   PAYMENT_METHOD,
   SALESPERSON,
   SALES_REP,
   OB_TERR_NUM,
   START_DATE,
   COURSE_CODE,
   SHORT_NAME,
   OPS_COUNTRY,
   PAID_DATE,
   GK_PO_NUM,
   PO_LINE_NUM,
   TRACKING_NUM,
   SHIPPED_DATE,
   PROMO_ACCEPT,
   PROMO_ITEM,
   FULFILL_REQUEST_DATE,
   EXPIRATION_DATE
)
AS
   SELECT   p.enroll_id,
            p.enroll_status,
            p.event_id,
            p.cust_id,
            TO_CHAR (cust_name) cust_name,
            TO_CHAR (acct_name) acct_name,
            TO_CHAR (address1) address1,
            TO_CHAR (address2) address2,
            TO_CHAR (city) city,
            TO_CHAR (state) state,
            TO_CHAR (zipcode) zipcode,
            TO_CHAR (phone_number) phone_number,
            TO_CHAR (email) email,
            enroll_date,
            book_date,
            keycode,
            book_amt,
            list_price,
            po_number,
            payment_method,
            salesperson,
            p.sales_rep,
            p.ob_terr_num,
            start_date,
            course_code,
            short_name,
            ops_country,
            TO_DATE (paid_date, 'yyyy-mm-dd') paid_date,
            gk_po_num,
            po_line_num,
            tracking_num,
            shipped_date,
            promo_accept,
            TO_CHAR (promo_item) promo_item,
            fulfill_request_date,
            expiration_date
     FROM   gk_promo_orders_mv p
   UNION
   SELECT   evxevenrollid,
            enroll_status,
            event_id,
            cust_id,
            cust_name,
            account_name,
            address1,
            address2,
            city,
            a.state,
            postalcode,
            workphone,
            email,
            enroll_date,
            book_date,
            keycode,
            book_amt,
            list_price,
            po_number,
            payment_method,
            salesperson,
            sales_rep,
            gt.territory_id,
            start_date,
            course_code,
            short_name,
            ops_country,
            paid_status_date,
            po_num,
            po_line_num,
            tracking_num,
            shipped_date,
            CASE WHEN tile_response = 'Accepted' THEN 'Y' END promo_accept,
            itemname,
            NVL (
               CASE
                  WHEN fulfilled_status IN ('Item Shipped', 'Item Delivered')
                  THEN
                     fulfilled_status_date
               END,
               pf.request_date
            )
               fulfill_request_date,
            expiration_date
     FROM         gk_promo_audit_v a
               LEFT OUTER JOIN
                  gk_territory gt
               ON a.postalcode BETWEEN gt.zip_start AND gt.zip_end
                  AND gt.territory_type = 'OB'
            LEFT JOIN
               gk_promo_fulfilled_orders pf
            ON a.evxevenrollid = pf.enroll_id;


DROP SYNONYM GKDW.GK_IPAD_MINI_AUDIT_V;

CREATE SYNONYM GKDW.GK_IPAD_MINI_AUDIT_V FOR GKDW.GK_PROMO_AUDIT_ALL_V;


