DROP MATERIALIZED VIEW GKDW.GK_ENROLL_CANCELLATION_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ENROLL_CANCELLATION_MV 
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
/* Formatted on 29/01/2021 12:25:15 (QP5 v5.115.810.9015) */
SELECT   td.dim_year,
         td.dim_period_name,
         td.dim_year || '-' || LPAD (td.dim_week, 2, '0') dim_week,
         f1.enroll_id,
         f1.book_date,
         f1.enroll_status_date cancel_date,
         f1.book_amt,
         cd.cust_name,
         cd.acct_name,
         c1.course_code,
         c1.short_name,
         f1.event_id,
         e1.start_date,
         e1.facility_region_metro metro,
         f1.transfer_enroll_id,
         c2.course_code transfer_course_code,
         c2.short_name transfer_short_name,
         e2.event_id transfer_event_id,
         e2.start_date transfer_start_date,
         e2.facility_region_metro transfer_metro,
         f2.enroll_status transfer_enroll_status,
         f2.enroll_status_date transfer_enroll_status_date,
         e1.cancel_reason,
         f1.enroll_status_desc,
         e1.event_type orig_event_type,
         e2.event_type transfer_event_type
  FROM                        order_fact f1
                           INNER JOIN
                              time_dim td
                           ON f1.enroll_status_date = td.dim_date
                        INNER JOIN
                           event_dim e1
                        ON f1.event_id = e1.event_id
                     INNER JOIN
                        course_dim c1
                     ON e1.course_id = c1.course_id
                        AND e1.ops_country = c1.country
                  INNER JOIN
                     cust_dim cd
                  ON f1.cust_id = cd.cust_id
               LEFT OUTER JOIN
                  order_fact f2
               ON f1.transfer_enroll_id = f2.enroll_id AND f2.book_amt > 0
            LEFT OUTER JOIN
               event_dim e2
            ON f2.event_id = e2.event_id
         LEFT OUTER JOIN
            course_dim c2
         ON e2.course_id = c2.course_id AND e2.ops_country = c2.country
 WHERE       c1.ch_num = '10'
         AND c1.md_num IN ('10', '20')
         AND e1.status = 'Cancelled'
         --and f1.enroll_status_desc = 'EVENT CANCELLATION'
         --and e1.cancel_reason in ('Low Enrollment','Low Enrollment - No Future Date')
         AND f1.book_amt < 0
         AND f1.book_date IS NOT NULL
--and e1.ops_country = 'USA';;

COMMENT ON MATERIALIZED VIEW GKDW.GK_ENROLL_CANCELLATION_MV IS 'snapshot table for snapshot GKDW.GK_ENROLL_CANCELLATION_MV';

GRANT SELECT ON GKDW.GK_ENROLL_CANCELLATION_MV TO DWHREAD;

