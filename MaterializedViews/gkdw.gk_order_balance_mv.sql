DROP MATERIALIZED VIEW GKDW.GK_ORDER_BALANCE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ORDER_BALANCE_MV 
TABLESPACE GDWMED
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
/* Formatted on 29/01/2021 12:23:41 (QP5 v5.115.810.9015) */
SELECT   f.enroll_id,
         t.actualamount,
         NVL (b.amountreceived, 0) amountreceived,
         t.actualamount - NVL (b.amountreceived, 0) order_balance
  FROM   order_fact f, evxev_txfee@slx t, evxbillpayment@slx b
 WHERE   f.txfee_id = t.evxev_txfeeid AND t.evxevticketid = b.evxevticketid;

COMMENT ON MATERIALIZED VIEW GKDW.GK_ORDER_BALANCE_MV IS 'snapshot table for snapshot GKDW.GK_ORDER_BALANCE_MV';

GRANT SELECT ON GKDW.GK_ORDER_BALANCE_MV TO DWHREAD;

