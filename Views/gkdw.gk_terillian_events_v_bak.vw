DROP VIEW GKDW.GK_TERILLIAN_EVENTS_V_BAK;

/* Formatted on 29/01/2021 11:25:27 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TERILLIAN_EVENTS_V_BAK
(
   COURSE_ID,
   COURSE_CODE,
   CLASS_ID,
   EVENT_NAME,
   STATUS,
   LOCATION_ID,
   COMPANY_ID,
   MAXSEATS,
   MINSEAT,
   CONNECTED_C,
   CONNECTED_V_TO_C,
   START_TIME,
   END_TIME,
   START_DATE,
   END_DATE,
   TZGENERICNAME,
   COUNTRY,
   "manufacturer_custom_code",
   TERILLIAN_COURSE_CODE
)
AS
   SELECT   DISTINCT
            ed.COURSE_ID,
            ed.COURSE_CODE,
            ed.EVENT_ID Class_id,
            ed.EVENT_NAME,
            ed.STATUS,
            ed.LOCATION_ID,
            NULL company_id,
            ed.CAPACITY maxseats,
            ee.MINENROLLMENT MINSEAT,
            ed.CONNECTED_C,
            ed.CONNECTED_V_TO_C,
            ed.START_TIME,
            ed.END_TIME,
            ed.start_date,
            ed.END_DATE,
            tz."TZGENERICNAME",
            ed.COUNTRY,
            s."manufacturer_custom_code",
            CASE (SUBSTR (course_code, 1, 4))
               WHEN '7016' THEN s."manufacturer_custom_code"
               ELSE ED.COURSE_CODE
            END
               Terillian_course_code
     FROM                  event_dim ed
                        JOIN
                           evxevent ee
                        ON ed.EVENT_ID = ee.EVXEVENTID
                     LEFT JOIN
                        "schedule"@rms_prod s
                     ON s."slx_id" = ed.EVENT_ID
                  LEFT JOIN
                     "location_func"@rms_prod lf
                  ON s."location_func" = lf."id"
               LEFT JOIN
                  "SLX_TIMEZONE"@rms_prod tz
               ON lf."timezone" = tz."OFF_SET"
            LEFT JOIN
               "lab_courses"@rms_prod lc
            ON lc."product" = s."product"
    WHERE   lc."lab" = 293 OR ed.event_id = 'Q6UJ9AS5XW2T'
   UNION                   /** Non MS Train the Trainer courses *************/
   SELECT   DISTINCT
            ed.COURSE_ID,
            ed.COURSE_CODE,
            ed.EVENT_ID Class_id,
            ed.EVENT_NAME,
            ed.STATUS,
            ed.LOCATION_ID,
            NULL company_id,
            ed.CAPACITY maxseats,
            ee.MINENROLLMENT MINSEAT,
            ed.CONNECTED_C,
            ed.CONNECTED_V_TO_C,
            ed.START_TIME,
            ed.END_TIME,
            ed.start_date,
            ed.END_DATE,
            tz."TZGENERICNAME",
            ed.COUNTRY,
            s."manufacturer_custom_code",
            CASE (SUBSTR (course_code, 1, 4))
               WHEN '7016' THEN s."manufacturer_custom_code"
               ELSE ED.COURSE_CODE
            END
               Terillian_course_code
     FROM               event_dim ed
                     JOIN
                        evxevent ee
                     ON ed.EVENT_ID = ee.EVXEVENTID
                  LEFT JOIN
                     "schedule"@rms_prod s
                  ON s."slx_id" = ed.EVENT_ID
               LEFT JOIN
                  "location_func"@rms_prod lf
               ON s."location_func" = lf."id"
            LEFT JOIN
               "SLX_TIMEZONE"@rms_prod tz
            ON lf."timezone" = tz."OFF_SET"
    WHERE   (SUBSTR (course_code, 1, 4) IN
                   ('3326', '3405', '3410', '3411', '9995'))
   UNION
   /*** VIRTUAL EVENTS WITH A MYGK COURSE PROFILE ***/
   SELECT   DISTINCT
            ed.course_id,
            ed.course_code,
            ed.event_id class_id,
            ed.event_name,
            ed.status,
            ed.location_id,
            NULL company_id,
            ed.capacity maxseats,
            ee.minenrollment minseat,
            ed.connected_c,
            ed.connected_v_to_c,
            ed.start_time,
            ed.end_time,
            ed.start_date,
            ed.end_date,
            tz."TZGENERICNAME" tzgenericname,
            ed.country,
            s."manufacturer_custom_code" manufacturer_custom_code,
            CASE
               WHEN SUBSTR (course_code, 1, 4) = '7016'
               THEN
                  s."manufacturer_custom_code"
               ELSE
                  ed.course_code
            END
               terillian_course_code
     FROM                     event_dim ed
                           INNER JOIN
                              gk_mygk_course_profile_v p
                           ON ed.course_code = p.course_code
                        INNER JOIN
                           evxevent ee
                        ON ed.event_id = ee.evxeventid
                     LEFT OUTER JOIN
                        "schedule"@rms_prod s
                     ON s."slx_id" = ed.event_id
                  LEFT OUTER JOIN
                     "location_func"@rms_prod lf
                  ON s."location_func" = lf."id"
               INNER JOIN
                  "SLX_TIMEZONE"@rms_prod tz
               ON lf."timezone" = tz."OFF_SET"
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE   cd.md_num IN ('20', '32') --AF - added modality 32 due to course code 2389Z'
   /*** CLASSROOM EVENTS WITH A MYGK COURSE PROFILE WITH A CONNECTED VIRTUAL ***/
   UNION
   SELECT   DISTINCT
            ed.course_id,
            ed.course_code,
            ed.event_id class_id,
            ed.event_name,
            ed.status,
            ed.location_id,
            NULL company_id,
            ed.capacity maxseats,
            ee.minenrollment minseat,
            ed.connected_c,
            ed.connected_v_to_c,
            ed.start_time,
            ed.end_time,
            ed.start_date,
            ed.end_date,
            tz."TZGENERICNAME" tzgenericname,
            ed.country,
            s."manufacturer_custom_code" manufacturer_custom_code,
            CASE
               WHEN SUBSTR (course_code, 1, 4) = '7016'
               THEN
                  s."manufacturer_custom_code"
               ELSE
                  ed.course_code
            END
               terillian_course_code
     FROM                        event_dim ed2
                              INNER JOIN
                                 event_dim ed
                              ON ed2.connected_v_to_c = ed.event_id
                           INNER JOIN
                              gk_mygk_course_profile_v p
                           ON ed.course_code = p.course_code
                        INNER JOIN
                           evxevent ee
                        ON ed.event_id = ee.evxeventid
                     LEFT OUTER JOIN
                        "schedule"@rms_prod s
                     ON s."slx_id" = ed.event_id
                  LEFT OUTER JOIN
                     "location_func"@rms_prod lf
                  ON s."location_func" = lf."id"
               INNER JOIN
                  "SLX_TIMEZONE"@rms_prod tz
               ON lf."timezone" = tz."OFF_SET"
            INNER JOIN
               course_dim cd
            ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
    WHERE   cd.md_num = '10';


