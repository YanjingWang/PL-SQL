DROP MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PLACED_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PLACED_MV 
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
/* Formatted on 29/01/2021 12:22:51 (QP5 v5.115.810.9015) */
SELECT   TO_CHAR (book_date, 'yyyy-mm-dd') book_date,
         enroll_id,
         keycode,
         cd.email
  FROM      order_fact f
         INNER JOIN
            cust_dim cd
         ON f.cust_id = cd.cust_id
 WHERE       enroll_status IN ('Confirmed', 'Attended')
         AND book_date IS NOT NULL
         AND EXISTS (SELECT   1
                       FROM   gk_ipad_promo_keycode k
                      WHERE   f.keycode = k.keycode)
         AND NOT EXISTS (SELECT   1
                           FROM   promo_orders_placed@mkt_catalog p
                          WHERE   f.enroll_id = TRIM (p."evxenrollid"));

COMMENT ON MATERIALIZED VIEW GKDW.GK_PROMO_ORDERS_PLACED_MV IS 'snapshot table for snapshot GKDW.GK_PROMO_ORDERS_PLACED_MV';

GRANT SELECT ON GKDW.GK_PROMO_ORDERS_PLACED_MV TO DWHREAD;

