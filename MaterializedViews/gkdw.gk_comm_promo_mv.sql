DROP MATERIALIZED VIEW GKDW.GK_COMM_PROMO_MV;
CREATE MATERIALIZED VIEW GKDW.GK_COMM_PROMO_MV 
TABLESPACE GDWSML
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
REFRESH FORCE
START WITH TO_DATE('25-Dec-2016 04:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT trunc(SYSDATE)+28/24     
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:25:54 (QP5 v5.115.810.9015) */
SELECT   a.enroll_id,
         a.keycode,
         p.item_name,
         p.mfg_price promo_amt,
         500 comm_promo_amt
  FROM      gk_ipad_mini_audit_v a
         INNER JOIN
            gk_ipad_promo_keycode p
         ON a.keycode = p.keycode
            AND UPPER (TRIM (a.promo_item)) = UPPER (p.item_name)
UNION
SELECT   f.enroll_id,
         f.source,
         'Student Hotel' item_name,
         h.hotel_total,
         h.hotel_total
  FROM         gk_inst_hotel_v@gkprod h
            INNER JOIN
               cust_dim cd
            ON h.instructor_id = cd.cust_id
         INNER JOIN
            order_fact f
         ON h.evxeventid = f.event_id AND cd.cust_id = f.cust_id
 WHERE   h.hotel_pay = 'DIRECT' AND h.direct_hotel IS NOT NULL;

COMMENT ON MATERIALIZED VIEW GKDW.GK_COMM_PROMO_MV IS 'snapshot table for snapshot GKDW.GK_COMM_PROMO_MV';

GRANT SELECT ON GKDW.GK_COMM_PROMO_MV TO DWHREAD;

