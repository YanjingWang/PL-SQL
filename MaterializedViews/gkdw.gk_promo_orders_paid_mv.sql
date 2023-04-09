DROP MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PAID_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PAID_MV 
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
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:22:58 (QP5 v5.115.810.9015) */
  SELECT   enroll_id, MAX (date_paid) date_paid
    FROM   (SELECT   f.enroll_id,
                     TO_CHAR (b.modifydate - 1, 'yyyy-mm-dd') date_paid
              FROM      order_fact f
                     INNER JOIN
                        slxdw.qg_billingpayment b
                     ON f.enroll_id = b.evxevenrollid
             WHERE       b.oraclestatus = 'Paid'
                     AND f.enroll_status != 'Cancelled'
                     AND EXISTS (SELECT   1
                                   FROM   pvxpromo@gkhub k
                                  WHERE   f.keycode = k.keycode)
            UNION
            SELECT   f.enroll_id, TO_CHAR (f.book_date, 'yyyy-mm-dd') date_paid
              FROM   order_fact f
             WHERE   payment_method IN
                           ('Voucher',
                            'Cisco Learning Credits',
                            'Credit Card',
                            'Citrix Training Pass')
                     AND EXISTS (SELECT   1
                                   FROM   pvxpromo@gkhub k
                                  WHERE   f.keycode = k.keycode)
            UNION
            SELECT   f.sales_order_id,
                     TO_CHAR (f.book_date, 'yyyy-mm-dd') date_paid
              FROM   sales_order_fact f
             WHERE   payment_method IN
                           ('Voucher',
                            'Cisco Learning Credits',
                            'Credit Card',
                            'Citrix Training Pass')
                     AND EXISTS (SELECT   1
                                   FROM   pvxpromo@gkhub k
                                  WHERE   f.keycode = k.keycode))
GROUP BY   enroll_id;

COMMENT ON MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PAID_MV IS 'snapshot table for snapshot GKDW.GK_PROMO_ORDERS_PAID_MV';

GRANT SELECT ON GKDW.GK_PROMO_ORDERS_PAID_MV TO DWHREAD;

