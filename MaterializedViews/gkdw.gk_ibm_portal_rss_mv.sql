DROP MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_RSS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_RSS_MV 
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
/* Formatted on 29/01/2021 12:24:45 (QP5 v5.115.810.9015) */
SELECT   ev.event_id,
         ev.course_code,
         ev.course_name,
         tx.title,
         tx.coursecode ibm_ww_course_code,
         ev.course_url,
         ev.start_date,
         ev.end_date,
         ev.city,
         c.iso_code country,
         ev.state,
         ev.delivery_method,
         tx.duration_length,
         tx.duration_unit,
         ev.event_type class_type,
         ev.time_zone timezone,
         start_time,
         end_time,
         ev.status,
         class_language,
         ev.duration_days,
         ev.gtr,
         p.partner_legal_name
  FROM            event_schedule@part_portals ev
               INNER JOIN
                  countries@part_portals c
               ON ev.country = c.country_id
            INNER JOIN
               ibm_tier_xml tx
            ON ev.ibm_ww_course_code = tx.coursecode
         INNER JOIN
            partners@part_portals p
         ON ev.partner_id = p.partner_id AND p.active = 'T'
            AND region IN
                     ('REG2014010813015501871482',
                      'REG2014021413024808531641',
                      'REG2014010813010704607048',
                      'REG2014010813011708536038',
                      'REG2014010813011203807849')
            AND p.partner_id NOT IN
                     ('PAR2014060910063208301257',
                      'PAR2014051211052205932780')
 WHERE       ev.country NOT IN ('US', 'CA')
         AND ev.line_id = 'BLI2014120914123401279416'
         AND event_type = 'Public'
         AND start_time LIKE '%:%'
         AND end_time LIKE '%:%';

COMMENT ON MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_RSS_MV IS 'snapshot table for snapshot GKDW.GK_IBM_PORTAL_RSS_MV';

GRANT SELECT ON GKDW.GK_IBM_PORTAL_RSS_MV TO DWHREAD;

