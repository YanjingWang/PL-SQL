DROP MATERIALIZED VIEW GKDW.GK_TERILLIAN_EVENTS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_TERILLIAN_EVENTS_MV 
TABLESPACE GDWMED
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
PARALLEL ( DEGREE DEFAULT INSTANCES DEFAULT )
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:21:46 (QP5 v5.115.810.9015) */
SELECT   DISTINCT ed.COURSE_ID,
                  ed.COURSE_CODE,
                  ed.EVENT_ID Class_id,
                  ed.EVENT_NAME,
                  ed.STATUS,
                  ed.LOCATION_ID,
                  CAST (NULL AS VARCHAR2 (20)) company_id,
                  ed.CAPACITY maxseats,
                  ee.MINENROLLMENT MINSEAT,
                  ed.CONNECTED_C,
                  ed.CONNECTED_V_TO_C,
                  ed.START_TIME,
                  ed.END_TIME,
                  ed.start_date,
                  ed.END_DATE,
                  tz."TZGENERICNAME",
                  ed.country
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
            JOIN
               "SLX_TIMEZONE"@rms_prod tz
            ON lf."timezone" = tz."OFF_SET"
         LEFT JOIN
            "lab_courses"@rms_prod lc
         ON lc."product" = s."product"
 WHERE   lc."lab" = 293                      --OR ed.event_id = 'Q6UJ9AS5XW2T'
UNION
SELECT   DISTINCT ed.COURSE_ID,
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
                  ed.COUNTRY
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
         JOIN
            "SLX_TIMEZONE"@rms_prod tz
         ON lf."timezone" = tz."OFF_SET"
 WHERE   (SUBSTR (course_code, 1, 4) IN
                ('3405',
                 '3410',
                 '3411',
                 '4501',
                 '4502',
                 '4503',
                 '4504',
                 '4506',
                 '4507'));

COMMENT ON MATERIALIZED VIEW GKDW.GK_TERILLIAN_EVENTS_MV IS 'snapshot table for snapshot GKDW.GK_TERILLIAN_EVENTS_MV';

GRANT SELECT ON GKDW.GK_TERILLIAN_EVENTS_MV TO DWHREAD;

