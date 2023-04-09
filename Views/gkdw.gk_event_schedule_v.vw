DROP VIEW GKDW.GK_EVENT_SCHEDULE_V;

/* Formatted on 29/01/2021 11:36:45 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_SCHEDULE_V
(
   EVXEVENTID,
   STARTDATE,
   ENDDATE,
   COURSECODE,
   EVENTSTATUS,
   STATUS,
   SCHEDULE_ID
)
AS
   SELECT   ev.EVXEVENTID,
            ev.STARTDATE,
            ev.ENDDATE,
            ev.COURSECODE,
            ev.EVENTSTATUS,
            s."status" status,
            s."id" schedule_id
     FROM      EVXEVENT@slx ev
            INNER JOIN
               "schedule"@rms_prod s
            ON ev.EVXEVENTID = s."slx_id"
    WHERE   ev.EVENTSTATUS <> s."status" AND ev.STARTDATE > TRUNC (SYSDATE);


