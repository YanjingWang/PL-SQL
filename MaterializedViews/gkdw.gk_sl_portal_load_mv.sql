DROP MATERIALIZED VIEW GKDW.GK_SL_PORTAL_LOAD_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SL_PORTAL_LOAD_MV 
TABLESPACE GDWSML
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
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:22:13 (QP5 v5.115.810.9015) */
SELECT   ed.event_id event_schedule_id,
         cd.course_code gk_course_code,
         ed.event_id,
         cd.course_name,
         SUBSTR (cd.course_code, 1, 4) sl_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         s.state_id,
         s.country_id,
         su.event_url || ed.event_id course_url,
         'English' class_language,
         CASE WHEN cd.md_num IN ('20', '42') THEN 'ILO' ELSE 'CR' END
            delivery_method,
         CASE
            WHEN cd.ch_num = '10' THEN 'Public'
            WHEN cd.ch_num = '20' THEN 'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914122805276504' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag
  FROM                     event_dim ed
                        INNER JOIN
                           course_dim cd
                        ON ed.course_id = cd.course_id
                           AND ed.ops_country = cd.country
                     INNER JOIN
                        slxdw.evxevent ee
                     ON ed.event_id = ee.evxeventid
                  INNER JOIN
                     slxdw.evxtimezone tz
                  ON ee.evxtimezoneid = tz.evxtimezoneid
               INNER JOIN
                  states@part_portals s
               ON s.iso_code =
                     SUBSTR (ed.ops_country, 1, 2) || '-' || ed.state
            LEFT OUTER JOIN
               gk_softlayer_url su
            ON cd.course_code = su.course_code
               AND ed.ops_country = su.ops_country
         LEFT OUTER JOIN
            gk_gtr_events gtr
         ON ed.event_id = gtr.event_id
 WHERE       ed.status = 'Open'
         AND cd.ch_num IN ('10', '20')
         AND SUBSTR (cd.course_code, 1, 4) IN (              --'0741', '0748',
                                               '1459', '5947', '5950')
UNION
SELECT   ed.event_id event_schedule_id,
         cd.course_code,
         ed.event_id,
         cd.course_name,
         SUBSTR (cd.course_code, 1, 4) sl_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         s.state_id,
         s.country_id,
         su.event_url || ed.event_id course_url,
         'English' class_language,
         CASE WHEN cd.md_num IN ('20', '42') THEN 'ILO' ELSE 'CR' END
            delivery_method,
         CASE
            WHEN cd.ch_num = '10' THEN 'Public'
            WHEN cd.ch_num = '20' THEN 'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914122805276504' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag
  FROM                     event_dim ed
                        INNER JOIN
                           course_dim cd
                        ON ed.course_id = cd.course_id
                           AND ed.ops_country = cd.country
                     INNER JOIN
                        slxdw.evxevent ee
                     ON ed.event_id = ee.evxeventid
                  INNER JOIN
                     slxdw.evxtimezone tz
                  ON ee.evxtimezoneid = tz.evxtimezoneid
               INNER JOIN
                  states@part_portals s
               ON UPPER (s.name) = UPPER (ed.province)
            LEFT OUTER JOIN
               gk_softlayer_url su
            ON cd.course_code = su.course_code
               AND ed.ops_country = su.ops_country
         LEFT OUTER JOIN
            gk_gtr_events gtr
         ON ed.event_id = gtr.event_id
 WHERE   ed.status = 'Open' AND cd.ch_num IN ('10', '20')
         AND SUBSTR (cd.course_code, 1, 4) IN
                  (                                                  --'0741',
                                                                     --'0748',
            '1459', '3417', '5947', '5950');

COMMENT ON MATERIALIZED VIEW GKDW.GK_SL_PORTAL_LOAD_MV IS 'snapshot table for snapshot GKDW.GK_SL_PORTAL_LOAD_MV';

GRANT SELECT ON GKDW.GK_SL_PORTAL_LOAD_MV TO DWHREAD;

