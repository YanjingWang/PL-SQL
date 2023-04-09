DROP MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PAID_STAT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PAID_STAT_MV 
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
/* Formatted on 29/01/2021 12:22:55 (QP5 v5.115.810.9015) */
SELECT   f.enroll_id, TO_CHAR (b.modifydate - 1, 'yyyy-mm-dd') date_paid
  FROM         order_fact f
            INNER JOIN
               cust_dim c
            ON f.cust_id = c.cust_id
         INNER JOIN
            slxdw.qg_billingpayment b
         ON f.enroll_id = b.evxevenrollid
 WHERE       b.oraclestatus = 'Paid'
         AND keycode = 'IPADMINI2013'
         AND enroll_status != 'Cancelled'
         --   and exists (select 1 from promo_orders_placed@mkt_catalog p where f.enroll_id = trim (p."evxenrollid"))
         AND NOT EXISTS (SELECT   1
                           FROM   promo_orders_paid@mkt_catalog o
                          WHERE   f.enroll_id = TRIM (o."evxenrollid"));

COMMENT ON MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PAID_STAT_MV IS 'snapshot table for snapshot GKDW.GK_PROMO_ORDERS_PAID_STAT_MV';

GRANT SELECT ON GKDW.GK_PROMO_ORDERS_PAID_STAT_MV TO DWHREAD;

