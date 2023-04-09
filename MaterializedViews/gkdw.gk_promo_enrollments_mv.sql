DROP MATERIALIZED VIEW GKDW.GK_PROMO_ENROLLMENTS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PROMO_ENROLLMENTS_MV 
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
/* Formatted on 29/01/2021 12:23:06 (QP5 v5.115.810.9015) */
  SELECT   l.event_id,
           f.keycode,
           f.enroll_id,
           1 enroll_cnt,
           MAX (pi.mfg_price) unit_price
    FROM            order_fact f
                 INNER JOIN
                    gk_go_nogo l
                 ON f.event_id = l.event_id
              INNER JOIN
                 pvxpromo@gkhub pp
              ON UPPER (f.keycode) = UPPER (pp.keycode)
           INNER JOIN
              pvxpromoitem@gkhub pi
           ON pp.pvxpromoid = pi.pvxpromoid
   WHERE   f.enroll_status IN ('Confirmed', 'Attended')
GROUP BY   l.event_id, f.keycode, f.enroll_id
UNION
  SELECT   l.event_id,
           f.keycode,
           f.enroll_id,
           1 enroll_cnt,
           c.cost_per_unit unit_price
    FROM         order_fact f
              INNER JOIN
                 gk_go_nogo l
              ON f.event_id = l.event_id
           INNER JOIN
              gk_promo_cost c
           ON UPPER (c.promo_code) = UPPER (f.keycode)
   WHERE   f.enroll_status IN ('Confirmed', 'Attended')
GROUP BY   l.event_id,
           f.keycode,
           f.enroll_id,
           c.cost_per_unit;

COMMENT ON MATERIALIZED VIEW GKDW.GK_PROMO_ENROLLMENTS_MV IS 'snapshot table for snapshot GKDW.GK_PROMO_ENROLLMENTS_MV';

GRANT SELECT ON GKDW.GK_PROMO_ENROLLMENTS_MV TO DWHREAD;

