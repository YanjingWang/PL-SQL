DROP VIEW GKDW.GK_FILLRATE_FORECAST;

/* Formatted on 29/01/2021 11:36:04 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_FILLRATE_FORECAST
(
   COURSE_ID,
   METRO_AREA,
   EVENT_CNT,
   AVG
)
AS
     SELECT   course_id,
              facility_region_metro metro_area,
              COUNT (DISTINCT ed.event_id) event_cnt,
              ROUND (COUNT (enroll_id) / COUNT (DISTINCT ed.event_id)) AVG
       FROM      event_dim ed
              INNER JOIN
                 order_fact f
              ON ed.event_id = f.event_id
      WHERE   (start_date BETWEEN TRUNC (SYSDATE) - 360
                              AND  TRUNC (SYSDATE) - 270
               OR start_date BETWEEN TRUNC (SYSDATE) - 720
                                 AND  TRUNC (SYSDATE) - 540)
              AND f.enroll_status IN ('Confirmed', 'Attended')
   GROUP BY   course_id, facility_region_metro;


