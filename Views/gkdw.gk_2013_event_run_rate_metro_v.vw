DROP VIEW GKDW.GK_2013_EVENT_RUN_RATE_METRO_V;

/* Formatted on 29/01/2021 11:21:54 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_2013_EVENT_RUN_RATE_METRO_V
(
   COURSE_CODE,
   METRO,
   DIM_QUARTER,
   EVENT_CNT,
   CANC_CNT,
   RUN_RATE
)
AS
     SELECT   cd.course_code,
              ed.facility_region_metro metro,
              td.dim_quarter dim_quarter,
              COUNT (DISTINCT ed.event_id) event_cnt,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END)
                 canc_cnt,
              (COUNT (DISTINCT ed.event_id)
               - SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END))
              / COUNT (DISTINCT ed.event_id)
                 run_rate
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_code = cd.course_code
                    AND cd.country = ed.ops_country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE       td.dim_year >= TO_NUMBER (TO_CHAR (SYSDATE, 'yyyy')) - 2
              AND cd.ch_num = '10'
              AND cd.md_num = '10'
   GROUP BY   cd.course_code, ed.facility_region_metro, td.dim_quarter;


