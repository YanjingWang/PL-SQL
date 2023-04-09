DROP MATERIALIZED VIEW GKDW.GK_COURSE_FILLRATE_MV;
CREATE MATERIALIZED VIEW GKDW.GK_COURSE_FILLRATE_MV 
TABLESPACE GDWSML
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
/* Formatted on 29/01/2021 12:25:35 (QP5 v5.115.810.9015) */
  SELECT   event_channel,
           event_modality,
           course_code,
           course_id,
           SUM (event_cnt) event_cnt,
           MIN (run_week_6) min_run_6,
           MIN (run_week_5) min_run_5,
           MIN (run_week_4) min_run_4,
           MIN (run_week_3) min_run_3,
           MIN (run_week_2) min_run_2,
           MIN (run_week_1) min_run_1,
           MIN (run_week_0) min_run_0,
           ROUND (SUM (run_week_0) / SUM (event_cnt)) avg_fill_rate
    FROM   (  SELECT   ed.event_channel,
                       ed.event_modality,
                       ed.course_code,
                       ed.course_id,
                       ed.event_id,
                       COUNT (DISTINCT ed.event_id) event_cnt,
                       SUM(CASE
                              WHEN ed.start_date - f.enroll_date + 1 >= 42 THEN 1
                              ELSE 0
                           END)
                          run_week_6,
                       SUM(CASE
                              WHEN ed.start_date - f.enroll_date + 1 >= 35 THEN 1
                              ELSE 0
                           END)
                          run_week_5,
                       SUM(CASE
                              WHEN ed.start_date - f.enroll_date + 1 >= 28 THEN 1
                              ELSE 0
                           END)
                          run_week_4,
                       SUM(CASE
                              WHEN ed.start_date - f.enroll_date + 1 >= 21 THEN 1
                              ELSE 0
                           END)
                          run_week_3,
                       SUM(CASE
                              WHEN ed.start_date - f.enroll_date + 1 >= 14 THEN 1
                              ELSE 0
                           END)
                          run_week_2,
                       SUM(CASE
                              WHEN ed.start_date - f.enroll_date + 1 >= 7 THEN 1
                              ELSE 0
                           END)
                          run_week_1,
                       COUNT (enroll_id) run_week_0
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
            --and ed.course_code = '0224C'
            GROUP BY   ed.event_channel,
                       ed.event_modality,
                       ed.course_code,
                       ed.course_id,
                       ed.event_id)
GROUP BY   event_channel,
           event_modality,
           course_code,
           course_id;

COMMENT ON MATERIALIZED VIEW GKDW.GK_COURSE_FILLRATE_MV IS 'snapshot table for snapshot GKDW.GK_COURSE_FILLRATE_MV';

GRANT SELECT ON GKDW.GK_COURSE_FILLRATE_MV TO DWHREAD;

