DROP MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_LOAD_MV;
CREATE MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_LOAD_MV 
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
/* Formatted on 29/01/2021 12:24:47 (QP5 v5.115.810.9015) */
SELECT   ed.event_id event_schedule_id,
         cd.course_code,
         ed.event_id,
         cd.course_name,
         tx.coursecode ibm_course_code,
         tx.coursecode ibm_ww_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         s.state_id,
         s.country_id,
         'http://www.globalknowledge.com/training/olm/ibmgo.aspx?coursecode='
         || tx.coursecode
         || CHR (38)
         || 'country='
         || SUBSTR (ed.ops_country, 1, 2)
            course_url,
         'English' class_language,
         CASE
            WHEN cd.md_num IN ('20', '42')
            THEN
               'ILO'
            WHEN cd.md_num IN ('32', '44') AND tx.modality LIKE '%SPVC%'
            THEN
               'SPVC'
            WHEN cd.md_num IN ('32', '44') AND tx.modality LIKE '%WBT%'
            THEN
               'WBT'
            ELSE
               'CR'
         END
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
         odr.gk_onsitereq_deliveryid odr_slx_id
  FROM                           event_dim ed
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.ops_country = cd.country
                           INNER JOIN
                              ibm_tier_xml tx
                           ON NVL (cd.mfg_course_code, cd.short_name) =
                                 tx.coursecode
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
                  slxdw.gk_onsitereq_courses orc
               ON orc.evxeventid = ed.event_id
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_fdc fdc
            ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.gk_onsitereq_delivery odr
         ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
 WHERE   ed.status = 'Open' AND cd.ch_num IN ('10', '20')
UNION
SELECT   ed.event_id event_schedule_id,
         cd.course_code,
         ed.event_id,
         cd.course_name,
         tx.coursecode ibm_course_code,
         tx.coursecode ibm_ww_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         s.state_id,
         s.country_id,
         'http://www.globalknowledge.com/training/olm/ibmgo.aspx?coursecode='
         || tx.coursecode
         || CHR (38)
         || 'country='
         || SUBSTR (ed.ops_country, 1, 2)
            course_url,
         'English' class_language,
         CASE
            WHEN cd.md_num IN ('20', '42')
            THEN
               'ILO'
            WHEN cd.md_num IN ('32', '44') AND tx.modality LIKE '%SPVC%'
            THEN
               'SPVC'
            WHEN cd.md_num IN ('32', '44') AND tx.modality LIKE '%WBT%'
            THEN
               'WBT'
            ELSE
               'CR'
         END
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
         odr.gk_onsitereq_deliveryid odr_slx_id
  FROM                           event_dim ed
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.ops_country = cd.country
                           INNER JOIN
                              ibm_tier_xml tx
                           ON NVL (cd.mfg_course_code, cd.short_name) =
                                 tx.coursecode
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
                  slxdw.gk_onsitereq_courses orc
               ON orc.evxeventid = ed.event_id
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_fdc fdc
            ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.gk_onsitereq_delivery odr
         ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
 WHERE   ed.status = 'Open' AND cd.ch_num IN ('10', '20');

COMMENT ON MATERIALIZED VIEW GKDW.GK_IBM_PORTAL_LOAD_MV IS 'snapshot table for snapshot GKDW.GK_IBM_PORTAL_LOAD_MV';

GRANT SELECT ON GKDW.GK_IBM_PORTAL_LOAD_MV TO DWHREAD;
