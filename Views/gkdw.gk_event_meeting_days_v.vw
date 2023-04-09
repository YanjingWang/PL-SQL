DROP VIEW GKDW.GK_EVENT_MEETING_DAYS_V;

/* Formatted on 29/01/2021 11:36:57 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_MEETING_DAYS_V
(
   EVENT_ID,
   ADJ_DAY_VAL
)
AS
   SELECT   event_id, CASE
                         WHEN total_hrs <= 2 THEN .25
                         WHEN total_hrs <= 4 THEN .5
                         WHEN total_hrs <= 6 THEN .75
                         ELSE 1
                      END
                         adj_day_val
     FROM   (SELECT   ed.event_id,
                      ed.end_date - ed.start_date + 1 meeting_days,
                      (CASE
                          WHEN ed.end_time LIKE '%PM'
                               AND SUBSTR (ed.end_time, 1, 2) < '12'
                          THEN
                             TO_NUMBER (SUBSTR (ed.end_time, 1, 2)) + 12
                          WHEN     ed.end_time LIKE '%AM'
                               AND ed.start_time LIKE '%PM'
                               AND SUBSTR (ed.end_time, 1, 2) < '12'
                          THEN
                             TO_NUMBER (SUBSTR (ed.end_time, 1, 2)) + 12
                          ELSE
                             TO_NUMBER (SUBSTR (ed.end_time, 1, 2))
                       END
                       + CASE
                            WHEN SUBSTR (ed.end_time, 4, 2) = '15' THEN .25
                            WHEN SUBSTR (ed.end_time, 4, 2) = '30' THEN .5
                            WHEN SUBSTR (ed.end_time, 4, 2) = '45' THEN .75
                            ELSE .0
                         END)
                      - (CASE
                            WHEN     ed.start_time LIKE '%PM'
                                 AND ed.end_time NOT LIKE '%AM'
                                 AND SUBSTR (ed.start_time, 1, 2) < '12'
                            THEN
                               TO_NUMBER (SUBSTR (ed.start_time, 1, 2)) + 12
                            WHEN ed.end_time LIKE '%AM'
                                 AND ed.start_time LIKE '%PM'
                            THEN
                               TO_NUMBER (SUBSTR (ed.start_time, 1, 2))
                            ELSE
                               TO_NUMBER (SUBSTR (ed.start_time, 1, 2))
                         END
                         + CASE
                              WHEN SUBSTR (ed.start_time, 4, 2) = '15'
                              THEN
                                 .25
                              WHEN SUBSTR (ed.start_time, 4, 2) = '30'
                              THEN
                                 .5
                              WHEN SUBSTR (ed.start_time, 4, 2) = '45'
                              THEN
                                 .75
                              ELSE
                                 .0
                           END)
                         total_hrs
               FROM   event_dim ed);


