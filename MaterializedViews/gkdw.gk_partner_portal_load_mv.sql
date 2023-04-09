DROP MATERIALIZED VIEW GKDW.GK_PARTNER_PORTAL_LOAD_MV;
CREATE MATERIALIZED VIEW GKDW.GK_PARTNER_PORTAL_LOAD_MV 
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
/* Formatted on 29/01/2021 12:23:35 (QP5 v5.115.810.9015) */
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
            'http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='
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
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) IN ('I', 'N')
            THEN
               'Private'
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) NOT IN ('I', 'N')
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) = 'L'
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) != 'L'
            THEN
               'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914123401279416' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag,
         lbs.odr_slx_id odr_slx_id,
         'IBM' partner_code,
         ed.last_update_date
  FROM                                 event_dim ed
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
                                 SUBSTR (ed.ops_country, 1, 2)
                              || '-'
                              || ed.state
                     LEFT OUTER JOIN
                        gk_gtr_events gtr
                     ON ed.event_id = gtr.event_id
                  LEFT OUTER JOIN
                     slxdw.gk_onsitereq_courses orc
                  ON orc.evxeventid = ed.event_id
               LEFT OUTER JOIN
                  slxdw.gk_onsitereq_fdc fdc
               ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_delivery odr
            ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.logistics_booking_sheet lbs
         ON lbs.odr_slx_id = odr.gk_onsitereq_deliveryid
            AND lbs.lbs_finished = 'Y'
 WHERE   cd.ch_num IN ('10', '20') AND cd.md_num IN ('10', '20')
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
            'http://db.globalknowledge.com/olm/ibmgo.aspx?coursecode='
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
         --       CASE
         --          WHEN cd.md_num = '10' THEN 'Public'
         --          WHEN cd.md_num = '20' THEN 'Private'
         --       END
         CASE
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) IN ('I', 'N')
            THEN
               'Private'
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) NOT IN ('I', 'N')
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) = 'L'
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) != 'L'
            THEN
               'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914123401279416' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag,
         lbs.odr_slx_id odr_slx_id,
         'IBM' partner_code,
         ed.last_update_date
  FROM                                 event_dim ed
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
                        gk_gtr_events gtr
                     ON ed.event_id = gtr.event_id
                  LEFT OUTER JOIN
                     slxdw.gk_onsitereq_courses orc
                  ON orc.evxeventid = ed.event_id
               LEFT OUTER JOIN
                  slxdw.gk_onsitereq_fdc fdc
               ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_delivery odr
            ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.logistics_booking_sheet lbs
         ON lbs.odr_slx_id = odr.gk_onsitereq_deliveryid
            AND lbs.lbs_finished = 'Y'
 WHERE   cd.ch_num IN ('10', '20') AND cd.md_num IN ('10', '20')
UNION
SELECT   ed.event_id event_schedule_id,
         cd.course_code gk_course_code,
         ed.event_id,
         cd.course_name,
         SUBSTR (cd.course_code, 1, 4) ibm_course_code,
         SUBSTR (cd.course_code, 1, 4) ibm_ww_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         s.state_id,
         s.country_id,
         CASE WHEN su.event_url IS NOT NULL THEN su.event_url END course_url,
         'English' class_language,
         CASE WHEN cd.md_num IN ('20', '42') THEN 'ILO' ELSE 'CR' END
            delivery_method,
         --       CASE
         --          WHEN cd.ch_num = '10' THEN 'Public'
         --          WHEN cd.ch_num = '20' THEN 'Private'
         --       END
         CASE
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) IN ('I', 'N')
            THEN
               'Private'
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) NOT IN ('I', 'N')
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) = 'L'
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) != 'L'
            THEN
               'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914122805276504' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag,
         lbs.odr_slx_id odr_slx_id,
         'SL' partner_code,
         ed.last_update_date
  FROM                                 event_dim ed
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
                                    SUBSTR (ed.ops_country, 1, 2)
                                 || '-'
                                 || ed.state
                        LEFT OUTER JOIN
                           gk_softlayer_url su
                        ON cd.course_code = su.course_code
                           AND ed.ops_country = su.ops_country
                     LEFT OUTER JOIN
                        gk_gtr_events gtr
                     ON ed.event_id = gtr.event_id
                  LEFT OUTER JOIN
                     slxdw.gk_onsitereq_courses orc
                  ON orc.evxeventid = ed.event_id
               LEFT OUTER JOIN
                  slxdw.gk_onsitereq_fdc fdc
               ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_delivery odr
            ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.logistics_booking_sheet lbs
         ON lbs.odr_slx_id = odr.gk_onsitereq_deliveryid
            AND lbs.lbs_finished = 'Y'
 WHERE   cd.ch_num IN ('10', '20') AND cd.md_num IN ('10', '20')
         AND SUBSTR (cd.course_code, 1, 4) IN
                  ('5950', '5947', '0741', '0748', '1459', '3417', '3573')
UNION
SELECT   ed.event_id event_schedule_id,
         cd.course_code,
         ed.event_id,
         cd.course_name,
         SUBSTR (cd.course_code, 1, 4) ibm_course_code,
         SUBSTR (cd.course_code, 1, 4) ibm_ww_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         s.state_id,
         s.country_id,
         CASE WHEN su.event_url IS NOT NULL THEN su.event_url END course_url,
         'English' class_language,
         CASE WHEN cd.md_num IN ('20', '42') THEN 'ILO' ELSE 'CR' END
            delivery_method,
         --       CASE
         --          WHEN cd.ch_num = '10' THEN 'Public'
         --          WHEN cd.ch_num = '20' THEN 'Private'
         --       END
         CASE
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) IN ('I', 'N')
            THEN
               'Private'
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) NOT IN ('I', 'N')
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) = 'L'
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) != 'L'
            THEN
               'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914122805276504' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag,
         lbs.odr_slx_id odr_slx_id,
         'SL' partner_code,
         ed.last_update_date
  FROM                                 event_dim ed
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
                  LEFT OUTER JOIN
                     slxdw.gk_onsitereq_courses orc
                  ON orc.evxeventid = ed.event_id
               LEFT OUTER JOIN
                  slxdw.gk_onsitereq_fdc fdc
               ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_delivery odr
            ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.logistics_booking_sheet lbs
         ON lbs.odr_slx_id = odr.gk_onsitereq_deliveryid
            AND lbs.lbs_finished = 'Y'
 WHERE   cd.ch_num IN ('10', '20') AND cd.md_num IN ('10', '20')
         AND SUBSTR (cd.course_code, 1, 4) IN
                  ('5950', '5947', '0741', '0748', '1459', '3417', '3573')
UNION
SELECT   ed.event_id event_schedule_id,
         cd.course_code,
         ed.event_id,
         cd.course_name,
         SUBSTR (cd.course_code, 1, 4) ibm_course_code,
         SUBSTR (cd.course_code, 1, 4) ibm_ww_course_code,
         ed.start_date,
         ed.end_date,
         ed.start_time,
         ed.end_time,
         'UTC' || LPAD (tz.offsetfromutc, 2, '0') || ':00' time_zone,
         ed.city,
         NULL state_id,
         s.country_id,
         CASE WHEN su.event_url IS NOT NULL THEN su.event_url END course_url,
         'English' class_language,
         CASE WHEN cd.md_num IN ('20', '42') THEN 'ILO' ELSE 'CR' END
            delivery_method,
         --       CASE
         --          WHEN cd.ch_num = '10' THEN 'Public'
         --          WHEN cd.ch_num = '20' THEN 'Private'
         --       END
         CASE
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) IN ('I', 'N')
            THEN
               'Private'
            WHEN cd.md_num = '10'
                 AND SUBSTR (cd.course_code, 5, 5) NOT IN ('I', 'N')
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) = 'L'
            THEN
               'Public'
            WHEN cd.md_num = '20' AND SUBSTR (cd.course_code, 5, 5) != 'L'
            THEN
               'Private'
         END
            event_type,
         'PAR2014060910063208301257' partner_id,
         'T' active,
         ed.status,
         0 student_cnt,
         'REG2014010813015501871482' region_id,
         'BLI2014120914122805276504' line_id,
         CASE WHEN gtr.gtr_level IS NOT NULL THEN '1' ELSE '0' END gtr_flag,
         lbs.odr_slx_id odr_slx_id,
         'SL' partner_code,
         ed.last_update_date
  FROM                                 event_dim ed
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
                              countries@part_portals s
                           ON UPPER (s.name) = UPPER (ed.country)
                        LEFT OUTER JOIN
                           gk_softlayer_url su
                        ON cd.course_code = su.course_code
                           AND ed.ops_country = su.ops_country
                     LEFT OUTER JOIN
                        gk_gtr_events gtr
                     ON ed.event_id = gtr.event_id
                  LEFT OUTER JOIN
                     slxdw.gk_onsitereq_courses orc
                  ON orc.evxeventid = ed.event_id
               LEFT OUTER JOIN
                  slxdw.gk_onsitereq_fdc fdc
               ON fdc.gk_onsitereq_fdcid = orc.gk_onsitereq_fdcid
            LEFT OUTER JOIN
               slxdw.gk_onsitereq_delivery odr
            ON odr.gk_onsitereq_fdcid = fdc.gk_onsitereq_fdcid
         LEFT OUTER JOIN
            slxdw.logistics_booking_sheet lbs
         ON lbs.odr_slx_id = odr.gk_onsitereq_deliveryid
            AND lbs.lbs_finished = 'Y'
 WHERE   cd.ch_num IN ('10', '20') AND cd.md_num IN ('10', '20')
         AND SUBSTR (cd.course_code, 1, 4) IN
                  ('5950', '5947', '0741', '0748', '1459', '3417', '3573')
         AND UPPER (s.name) NOT IN ('CANADA', 'UNITED STATES');

COMMENT ON MATERIALIZED VIEW GKDW.GK_PARTNER_PORTAL_LOAD_MV IS 'snapshot table for snapshot GKDW.GK_PARTNER_PORTAL_LOAD_MV';

GRANT SELECT ON GKDW.GK_PARTNER_PORTAL_LOAD_MV TO DWHREAD;

