DROP MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_EXP_CO_MV;
CREATE MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_EXP_CO_MV 
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
/* Formatted on 29/01/2021 12:24:50 (QP5 v5.115.810.9015) */
SELECT   partners.partner_legal_name,
         countries.name AS country,
         countries_1.name AS partner_country,
         countries.iso_code AS iso_ctry,
         event_schedule.event_schedule_id,
         event_schedule.createdate,
         event_schedule.modifydate,
         event_schedule.course_code,
         event_schedule.event_id event_id,
         event_schedule.course_name,
         event_schedule.ibm_course_code,
         event_schedule.ibm_ww_course_code,
         event_schedule.start_date,
         event_schedule.end_date,
         event_schedule.start_time,
         event_schedule.end_time,
         event_schedule.time_zone,
         'Virtual Training' city,
         event_schedule.state,
         event_schedule.country country_id,
         event_schedule.course_url,
         event_schedule.class_language,
         event_schedule.delivery_method,
         event_schedule.event_type,
         event_schedule.partner_id,
         event_schedule.active,
         event_schedule.status,
         event_schedule.student_count,
         event_schedule.region_id,
         event_schedule.modifyby_id,
         event_schedule.gtr,
         event_schedule.line_id,
         event_schedule.duration_days,
         country_virtual_schedule.is_active
  FROM               country_virtual_schedule@part_portals
                  INNER JOIN
                     countries@part_portals
                  ON country_virtual_schedule.country_id =
                        countries.country_id
               INNER JOIN
                  partners@part_portals
               ON country_virtual_schedule.partner_id = partners.partner_id
            INNER JOIN
               countries@part_portals countries_1
            ON country_virtual_schedule.partner_country_id =
                  countries_1.country_id
         INNER JOIN
            event_schedule@part_portals
         ON country_virtual_schedule.partner_id = event_schedule.partner_id
            AND country_virtual_schedule.partner_country_id =
                  event_schedule.country
 WHERE       event_schedule.start_date > country_virtual_schedule.start_date
         AND event_schedule.end_date < country_virtual_schedule.end_date
         AND event_schedule.line_id = 'BLI2014120914123401279416' --for ibm event only
         AND country_virtual_schedule.line_id = 'BLI2014120914123401279416' --for ibm only
         AND event_schedule.delivery_method = 'ILO'
         AND event_schedule.event_type = 'Public';

COMMENT ON MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_EXP_CO_MV IS 'snapshot table for snapshot GKDW.GK_IBM_PORTAL_EXP_CO_MV';

GRANT SELECT ON GKDW.GK_IBM_PORTAL_EXP_CO_MV TO DWHREAD;

