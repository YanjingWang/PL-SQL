DROP MATERIALIZED VIEW GKDW.GK_SL_PORTAL_RSS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_SL_PORTAL_RSS_MV 
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
/* Formatted on 29/01/2021 12:22:08 (QP5 v5.115.810.9015) */
SELECT   ev.line_id,
         ev.event_id,
         ev.course_code,
         ev.course_name,
         ev.course_url,
         ev.start_date,
         ev.end_date,
         ev.city,
         c.iso_code iso_country,
         c.name country,
         ev.state,
         ev.delivery_method,
         ev.event_type class_type,
         ev.time_zone timezone,
         start_time,
         end_time,
         ev.status,
         class_language,
         ev.duration_days,
         ev.gtr gtr_flag
  FROM         event_schedule@part_portals ev
            INNER JOIN
               countries@part_portals c
            ON ev.country = c.country_id
         INNER JOIN
            partners@part_portals p
         ON ev.partner_id = p.partner_id AND p.active = 'T'
 WHERE       ev.country NOT IN ('US', 'CA')
         AND ev.line_id = 'BLI2014120914122805276504'
         AND p.partner_id NOT IN ('PAR2014060910063208301257')
         AND ev.event_type = 'Public'
         AND ev.start_time LIKE '%:%'
         AND ev.end_time LIKE '%:%'
         AND NOT EXISTS
               (SELECT   1
                  FROM   event_sponsor@part_portals sp
                 WHERE       ev.event_schedule_id = sp.event_schedule_id
                         AND ev.line_id = sp.line_id
                         AND sp.active = 'T')
UNION
SELECT   ev.line_id,
         ev.event_id,
         ev.course_code,
         ev.course_name,
         ev.course_url,
         ev.start_date,
         ev.end_date,
         ev.city,
         c.iso_code iso_country,
         c.name country,
         ev.state,
         ev.delivery_method,
         ev.event_type class_type,
         ev.time_zone timezone,
         start_time,
         end_time,
         ev.status,
         class_language,
         ev.duration_days,
         'T' gtr_flag
  FROM            event_schedule@part_portals ev
               INNER JOIN
                  event_sponsor@part_portals sp
               ON     ev.event_schedule_id = sp.event_schedule_id
                  AND ev.line_id = sp.line_id
                  AND sp.active = 'T'
            INNER JOIN
               countries@part_portals c
            ON ev.country = c.country_id
         INNER JOIN
            partners@part_portals p
         ON ev.partner_id = p.partner_id AND p.active = 'T'
 WHERE       ev.country NOT IN ('US', 'CA')
         AND ev.line_id = 'BLI2014120914122805276504'
         AND p.partner_id NOT IN ('PAR2014060910063208301257')
         AND event_type = 'Public'
         AND start_time LIKE '%:%'
         AND end_time LIKE '%:%';

COMMENT ON MATERIALIZED VIEW GKDW.GK_SL_PORTAL_RSS_MV IS 'snapshot table for snapshot GKDW.GK_SL_PORTAL_RSS_MV';

GRANT SELECT ON GKDW.GK_SL_PORTAL_RSS_MV TO DWHREAD;

