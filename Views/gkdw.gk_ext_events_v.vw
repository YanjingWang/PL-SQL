DROP VIEW GKDW.GK_EXT_EVENTS_V;

/* Formatted on 29/01/2021 11:36:41 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EXT_EVENTS_V
(
   EVENT_ID,
   SESSIONS,
   START_DATE,
   END_DATE,
   SESSION_DAYS,
   EXT_EVENT
)
AS
     SELECT   event_id,
              COUNT ( * ) sessions,
              MIN (session_date) start_date,
              MAX (session_date) end_date,
              MAX (session_date) - MIN (session_date) + 1 session_days,
              CASE
                 WHEN MAX (session_date) - MIN (session_date) + 1 > COUNT ( * )
                 THEN
                    'Y'
                 ELSE
                    'N'
              END
                 ext_event
       FROM   gk_event_days_mv
   GROUP BY   event_id
     HAVING   MAX (session_date) - MIN (session_date) + 1 > COUNT ( * );


