DROP MATERIALIZED VIEW GKDW.GK_PROMO_AUDIT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PROMO_AUDIT_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
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
/* Formatted on 29/01/2021 12:23:09 (QP5 v5.115.810.9015) */
SELECT   pa.evxevenrollid,
         f.enroll_status,
         ed.event_id,
         f.cust_id,
         c.cust_name,
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
            expiration_date
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

COMMENT ON MATERIALIZED VIEW GKDW.GK_PROMO_AUDIT_MV IS 'snapshot table for snapshot GKDW.GK_PROMO_AUDIT_MV';

GRANT SELECT ON GKDW.GK_PROMO_AUDIT_MV TO DWHREAD;

