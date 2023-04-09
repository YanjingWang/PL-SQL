DROP VIEW GKDW.GK_PROMO_AUDIT_V;

/* Formatted on 29/01/2021 11:28:42 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PROMO_AUDIT_V
(
   EVXEVENROLLID,
   ENROLL_STATUS,
   EVENT_ID,
   CUST_ID,
   CUST_NAME,
   FIRST_NAME,
   LAST_NAME,
   ACCOUNT_NAME,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   POSTALCODE,
   WORKPHONE,
   EMAIL,
   ENROLL_DATE,
   KEYCODE,
   BOOK_DATE,
   BOOK_AMT,
   LIST_PRICE,
   PO_NUMBER,
   PAYMENT_METHOD,
   SALESPERSON,
   SALES_REP,
   START_DATE,
   COURSE_CODE,
   SHORT_NAME,
   OPS_COUNTRY,
   PAID_STATUS,
   PAID_STATUS_DATE,
   PO_NUM,
   PO_LINE_NUM,
   TRACKING_NUM,
   SHIPPED_DATE,
   ITEMNAME,
   TILE_RESPONSE,
   TILE_RESPONSE_DATE,
   FULFILLED_STATUS,
   FULFILLED_STATUS_DATE,
   PROMO_STATUS,
   PROMO_STATUS_DATE,
   EXPIRATION_DATE,
   CUST_DIM_EMAIL,
   PROMONAME
)
AS
   SELECT   pa.evxevenrollid,
            f.enroll_status,
            ed.event_id,
            f.cust_id,
            c.cust_name,
            c.first_name,
            c.last_name,
            pa.account_name,
            pa.address1,
            pa.address2,
            pa.city,
            pa.state,
            pa.postalcode,
            pa.workphone,
            pa.email,
            f.enroll_date,
            f.keycode,
            f.book_date,
            f.book_amt,
            f.list_price,
            f.po_number,
            f.payment_method,
            f.salesperson,
            f.sales_rep,
            ed.start_date,
            ed.course_code,
            cd.short_name,
            ed.ops_country,
            pa.paid_status,
            pa.paid_status_date,
            pf.po_num,
            pf.po_line_num,
            pf.tracking_num,
            pf.shipped_date,
            pa.itemname,
            pa.tile_response,
            pa.tile_response_date,
            pa.fulfilled_status,
            pa.fulfilled_status_date,
            pa.promo_status,
            pa.promo_status_date,
            CASE
               WHEN pa.promo_status = 'Expired' THEN pa.promo_status_date
               ELSE NULL
            END
               expiration_date,
            c.email cust_dim_email,
            pa.promoname
     FROM                  gk_promo_audit_v@gkhub pa
                        INNER JOIN
                           order_fact f
                        ON pa.evxevenrollid = f.enroll_id
                     INNER JOIN
                        cust_dim c
                     ON f.cust_id = c.cust_id
                  INNER JOIN
                     event_dim ed
                  ON f.event_id = ed.event_id
               INNER JOIN
                  course_dim cd
               ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
            LEFT OUTER JOIN
               gk_promo_fulfilled_orders pf
            ON pa.evxevenrollid = pf.enroll_id
    WHERE   f.enroll_status != 'Cancelled';


