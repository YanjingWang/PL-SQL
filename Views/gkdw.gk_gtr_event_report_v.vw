DROP VIEW GKDW.GK_GTR_EVENT_REPORT_V;

/* Formatted on 29/01/2021 11:35:13 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GTR_EVENT_REPORT_V
(
   OPS_COUNTRY,
   START_WEEK,
   START_DATE,
   EVENT_ID,
   METRO,
   FACILITY_CODE,
   COURSE_CODE,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   GTR_REVENUE,
   GTR_ENROLL_CNT,
   GTR_CREATE_DATE,
   GTR_LEVEL,
   REVENUE,
   REV_GROWTH,
   ENROLL_CNT,
   ENROLL_GROWTH
)
AS
     SELECT   ge.ops_country,
              ge.start_week,
              ge.start_date,
              ge.event_id,
              ge.metro,
              ge.facility_code,
              ge.course_code,
              ge.course_ch,
              ge.course_mod,
              ge.course_pl,
              ge.course_type,
              ge.revenue gtr_revenue,
              ge.enroll_cnt gtr_enroll_cnt,
              gtr_create_date,
              gtr_level,
              SUM (f.book_amt) revenue,
              CASE
                 WHEN ge.revenue = 0 THEN 0
                 ELSE ( (SUM (f.book_amt) / ge.revenue) - 1)
              END
                 rev_growth,
              COUNT (f.enroll_id) enroll_cnt,
              CASE
                 WHEN ge.enroll_cnt = 0 THEN 0
                 ELSE ( (COUNT (f.enroll_id) / ge.enroll_cnt) - 1)
              END
                 enroll_growth
       FROM      gk_gtr_events ge
              INNER JOIN
                 order_fact f
              ON ge.event_id = f.event_id AND f.enroll_status != 'Cancelled'
   -- where ge.start_date <= trunc(sysdate)
   GROUP BY   ge.ops_country,
              ge.start_week,
              ge.start_date,
              ge.event_id,
              ge.metro,
              ge.facility_code,
              ge.course_code,
              ge.course_ch,
              ge.course_mod,
              ge.course_pl,
              ge.course_type,
              ge.revenue,
              ge.enroll_cnt,
              gtr_create_date,
              gtr_level
   ORDER BY   start_week;


