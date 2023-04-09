DROP VIEW GKDW.GK_CANCELLED_EVENTS_V;

/* Formatted on 29/01/2021 11:41:59 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CANCELLED_EVENTS_V
(
   EVENT_ID,
   COURSE_CODE,
   START_DATE,
   END_DATE,
   FACILITY_REGION_METRO,
   CITY,
   STATE,
   CANCEL_DATE,
   CANCEL_REASON,
   ENROLL_CT
)
AS
     SELECT   e.event_id,
              course_code,
              start_date,
              end_date,
              facility_region_metro,
              city,
              state,
              cancel_date,
              cancel_reason,
              o.enroll_ct
       FROM      event_dim e
              LEFT OUTER JOIN
                 (  SELECT   event_id, COUNT (DISTINCT enroll_id) enroll_ct
                      FROM   order_fact
                     WHERE   book_amt >= 0
                  GROUP BY   event_id) o
              ON e.event_id = o.event_id
      WHERE   status = 'Cancelled'
   ORDER BY   e.event_id;


