DROP VIEW GKDW.GK_EVENT_FIRST_SCHED_V;

/* Formatted on 29/01/2021 11:37:08 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_FIRST_SCHED_V
(
   OPS_COUNTRY,
   COURSE_ID,
   COURSE_CODE,
   FIRST_SCHED_DATE
)
AS
     SELECT   ops_country,
              course_id,
              course_code,
              MIN (start_date) first_sched_date
       FROM   event_dim ed
      WHERE   gkdw_source = 'SLXDW'
   GROUP BY   ops_country, course_id, course_code;


