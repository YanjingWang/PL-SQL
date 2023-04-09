DROP VIEW GKDW.RMS_EVENT_POD_ASSIGNMENTS_V;

/* Formatted on 29/01/2021 11:23:04 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.RMS_EVENT_POD_ASSIGNMENTS_V
(
   EVENT_ID,
   COURSE_CODE,
   SHORTNAME,
   START_DATE,
   START_TIME,
   END_DATE,
   END_TIME,
   TIMEZONE,
   MEETING_DAYS,
   COUNTRY,
   FACILITY_REGION_METRO,
   LOCATION_NAME,
   FACILITY_CODE,
   STATUS,
   POD_DETAILS,
   CURRENROLLMENT,
   MAXENROLLMENT,
   FEECODE1,
   INSTRUCTOR1,
   FEECODE2,
   INSTRUCTOR2,
   FEECODE3,
   INSTRUCTOR3,
   EVENT_COMMENT
)
AS
   SELECT   e.event_id,
            e.course_code,
            shortname,
            start_date,
            start_time,
            end_date,
            end_time,
            'UTC ' || TO_CHAR (offset_from_utc) timezone,
            meeting_days,
            country,
            facility_region_metro,
            location_name,
            facility_code,
            status,
            pd.pod_name || ' : ' || pd.pod_count || 'pods' pod_details,
            currenrollment,
            maxenrollment,
            feecode1,
            firstname1 || ' ' || lastname1 instructor1,
            feecode2,
            firstname2 || ' ' || lastname2 instructor2,
            feecode3,
            firstname3 || ' ' || lastname3 instructor3,
            pd.event_comment
     FROM               event_dim e
                     INNER JOIN
                        slxdw.evxevent se
                     ON e.event_id = se.evxeventid
                  INNER JOIN
                     slxdw.evxcourse c
                  ON e.course_id = c.evxcourseid
               LEFT JOIN
                  gk_all_event_instr_mv i
               ON e.event_id = i.event_id
            INNER JOIN
               rms_pod_count_v pd
            ON e.event_id = pd.slx_event_id;


