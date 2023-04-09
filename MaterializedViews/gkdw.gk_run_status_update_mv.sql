DROP MATERIALIZED VIEW GKDW.GK_RUN_STATUS_UPDATE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_RUN_STATUS_UPDATE_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:22:42 (QP5 v5.115.810.9015) */
SELECT   f.event_id,
         ed.course_code,
         f.enroll_id,
         f.enroll_status,
         ed.start_date,
         f.book_date enroll_date,
         NULL cancel_date,
         TRUNC (ed.start_date - book_date) enroll_days,
         0 cancel_days
  FROM      order_fact f
         INNER JOIN
            event_dim ed
         ON f.event_id = ed.event_id
 WHERE   enroll_status != 'Cancelled' AND ed.start_date <= TRUNC (SYSDATE)
UNION
SELECT   f.event_id,
         ed.course_code,
         f.enroll_id,
         f.enroll_status,
         ed.start_date,
         f.enroll_date,
         f.book_date cancel_date,
         TRUNC (ed.start_date - enroll_date) enroll_days,
         CASE
            WHEN f.bill_status = 'Cancelled'
            THEN
               TRUNC (ed.start_date - book_date)
            ELSE
               0
         END
            cancel_days
  FROM      order_fact f
         INNER JOIN
            event_dim ed
         ON f.event_id = ed.event_id
 WHERE   f.bill_status = 'Cancelled' AND ed.start_date <= TRUNC (SYSDATE);

COMMENT ON MATERIALIZED VIEW GKDW.GK_RUN_STATUS_UPDATE_MV IS 'snapshot table for snapshot GKDW.GK_RUN_STATUS_UPDATE_MV';

GRANT SELECT ON GKDW.GK_RUN_STATUS_UPDATE_MV TO DWHREAD;

