DROP VIEW GKDW.GK_COURSE_FILL_STD_V;

/* Formatted on 29/01/2021 11:39:56 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_FILL_STD_V
(
   EVENT_CHANNEL,
   EVENT_MODALITY,
   COURSE_CODE,
   START_DAY,
   END_DAY,
   MIN_ENROLL_CNT,
   MAX_ENROLL_CNT,
   AVG_FILL_RATE
)
AS
     SELECT   event_channel,
              event_modality,
              course_code,
              start_day,
              end_day,
              MIN (enroll_cnt) min_enroll_cnt,
              MAX (enroll_cnt) max_enroll_cnt,
              ROUND (SUM (enroll_cnt) / SUM (event_cnt), 2) avg_fill_rate
       FROM   (  SELECT   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id,
                          70 start_day,
                          365 end_day,
                          SUM(CASE
                                 WHEN ed.start_date - f.enroll_date + 1 >= 70
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             enroll_cnt,
                          COUNT (DISTINCT ed.event_id) event_cnt
                   FROM      order_fact f
                          INNER JOIN
                             event_dim ed
                          ON f.event_id = ed.event_id
                  WHERE       enroll_status IN ('Confirmed', 'Attended')
                          AND ed.event_channel = 'INDIVIDUAL/PUBLIC'
                          AND ed.event_modality = 'C-LEARNING'
                          AND ed.status = 'Verified'
                          AND ed.ops_country = 'USA'
                          AND ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
               GROUP BY   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id
               UNION ALL
                 SELECT   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id,
                          56 start_day,
                          69 end_day,
                          SUM(CASE
                                 WHEN ed.start_date - f.enroll_date + 1 >= 56
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             enroll_cnt,
                          COUNT (DISTINCT ed.event_id) event_cnt
                   FROM      order_fact f
                          INNER JOIN
                             event_dim ed
                          ON f.event_id = ed.event_id
                  WHERE       enroll_status IN ('Confirmed', 'Attended')
                          AND ed.event_channel = 'INDIVIDUAL/PUBLIC'
                          AND ed.event_modality = 'C-LEARNING'
                          AND ed.status = 'Verified'
                          AND ed.ops_country = 'USA'
                          AND ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
               GROUP BY   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id
               UNION ALL
                 SELECT   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id,
                          42 start_day,
                          55 end_day,
                          SUM(CASE
                                 WHEN ed.start_date - f.enroll_date + 1 >= 42
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             enroll_cnt,
                          COUNT (DISTINCT ed.event_id) event_cnt
                   FROM      order_fact f
                          INNER JOIN
                             event_dim ed
                          ON f.event_id = ed.event_id
                  WHERE       enroll_status IN ('Confirmed', 'Attended')
                          AND ed.event_channel = 'INDIVIDUAL/PUBLIC'
                          AND ed.event_modality = 'C-LEARNING'
                          AND ed.status = 'Verified'
                          AND ed.ops_country = 'USA'
                          AND ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
               GROUP BY   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id
               UNION ALL
                 SELECT   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id,
                          21 start_day,
                          41 end_day,
                          SUM(CASE
                                 WHEN ed.start_date - f.enroll_date + 1 >= 21
                                 THEN
                                    1
                                 ELSE
                                    0
                              END)
                             enroll_cnt,
                          COUNT (DISTINCT ed.event_id) event_cnt
                   FROM      order_fact f
                          INNER JOIN
                             event_dim ed
                          ON f.event_id = ed.event_id
                  WHERE       enroll_status IN ('Confirmed', 'Attended')
                          AND ed.event_channel = 'INDIVIDUAL/PUBLIC'
                          AND ed.event_modality = 'C-LEARNING'
                          AND ed.status = 'Verified'
                          AND ed.ops_country = 'USA'
                          AND ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
               GROUP BY   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id
               UNION ALL
                 SELECT   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id,
                          0 start_day,
                          20 end_day,
                          COUNT (enroll_id) enroll_cnt,
                          COUNT (DISTINCT ed.event_id) event_cnt
                   FROM      order_fact f
                          INNER JOIN
                             event_dim ed
                          ON f.event_id = ed.event_id
                  WHERE       enroll_status IN ('Confirmed', 'Attended')
                          AND ed.event_channel = 'INDIVIDUAL/PUBLIC'
                          AND ed.event_modality = 'C-LEARNING'
                          AND ed.status = 'Verified'
                          AND ed.ops_country = 'USA'
                          AND ed.start_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
               GROUP BY   ed.event_channel,
                          ed.event_modality,
                          ed.course_code,
                          ed.event_id)
   GROUP BY   event_channel,
              event_modality,
              course_code,
              start_day,
              end_day
   ORDER BY   1,
              2,
              3,
              4 DESC;


