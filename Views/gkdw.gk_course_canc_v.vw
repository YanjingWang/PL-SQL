DROP VIEW GKDW.GK_COURSE_CANC_V;

/* Formatted on 29/01/2021 11:40:10 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_CANC_V
(
   COURSE_ID,
   COURSE_CODE,
   OPS_COUNTRY,
   FACILITY_REGION_METRO,
   EVENT_CNT,
   CANC_EVENT_CNT,
   CANC_PCT
)
AS
     SELECT   cd.course_id,
              cd.course_code,
              ed.ops_country,
              ed.facility_region_metro,
              COUNT (ed.event_id) event_cnt,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END)
                 canc_event_cnt,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END)
              / COUNT (ed.event_id)
                 canc_pct
       FROM      event_dim ed
              INNER JOIN
                 course_dim cd
              ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
      WHERE       cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND ed.start_date >= TRUNC (SYSDATE) - 730
   --and cd.course_code = '2780C'
   --and ed.facility_region_metro = 'KSC'
   GROUP BY   cd.course_id,
              cd.course_code,
              ed.ops_country,
              ed.facility_region_metro
   ORDER BY   ed.ops_country, ed.facility_region_metro;


