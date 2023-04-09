DROP MATERIALIZED VIEW GKDW.GK_MTM_DATA_MV;
CREATE MATERIALIZED VIEW GKDW.GK_MTM_DATA_MV 
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
NOLOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:24:17 (QP5 v5.115.810.9015) */
  SELECT   td.dim_year,
           td.dim_week,
           cd.course_pl,
           cd.course_mod,
           cd.course_ch,
           cd.course_id,
           cd.course_code,
           ed.event_id,
           ed.start_date,
           ed.end_date,
           ed.status,
           ed.location_id,
           ed.facility_code,
           CASE
              WHEN SUBSTR (cd.course_code, 1, 4) IN ('2622', '2623', '2624')
              THEN
                 '9719'
              WHEN SUBSTR (cd.course_code, 1, 4) IN
                         ('8870', '8871', '8872', '8873', '8874')
              THEN
                 '14815'
              WHEN cd.course_code = '5274N'
              THEN
                 '18859'
              WHEN TRIM (cce.ka_survey_id) IS NOT NULL
              THEN
                 TRIM (cce.ka_survey_id)
              ELSE
                 ml.ka_survey_id
           END
              ka_survey_id,
           CASE
              WHEN SUBSTR (cd.course_code, 1, 4) IN ('2622', '2623', '2624')
              THEN
                 'ADP'
              WHEN SUBSTR (cd.course_code, 1, 4) IN
                         ('8870', '8871', '8872', '8873', '8874')
              THEN
                 'HDI'
              WHEN cd.course_code = '5274N'
              THEN
                 'Master NA - ILT Cisco Private'
              WHEN TRIM (cce.ka_survey_id) IS NOT NULL
              THEN
                 TRIM (cce.survey_name)
              ELSE
                 ml.survey_id
           END
              survey_id,
           ie.contactid contactid1,
           ie.firstname firstname1,
           REPLACE (ie.lastname, '1', '') lastname1,
           c.email,
           c.acct_name,
           cd.short_name,
           REPLACE (
              REPLACE (REPLACE (REPLACE (cd.course_name, '"'), CHR (174), ''),
                       CHR (194),
                       ''),
              CHR (191),
              ''
           )
              course_name,
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND UPPER (ed.location_name) LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
              THEN
                 'Client Site'
              ELSE
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
           END
              loc_desc,
           CASE
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND COUNT (f.enroll_id) > 0
              THEN
                 COUNT (f.enroll_id)
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND NVL (ed.onsite_attended, 0) > 0
              THEN
                 ed.onsite_attended - 1
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND NVL (ed.onsite_attended, 0) = 0
              THEN
                 ed.capacity
              WHEN ed.status = 'Verified'
              THEN
                 SUM (CASE WHEN f.enroll_status = 'Attended' THEN 1 ELSE 0 END)
              ELSE
                 COUNT (DISTINCT f.enroll_id)
           END
              enroll_cnt,
           ed.ops_country,
           SUBSTR (cd.course_code, 1, LENGTH (cd.course_code) - 1)
              xml_course_id,
           SUBSTR (UPPER (c.country), 1, 2) || '_' || ri.rms_instructor_id
              xml_instructor_id,
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country = 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 30043
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country != 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 5265
              ELSE
                 rf.rms_facility_id
           END
              xml_loc_id,
           REPLACE (
              REPLACE (
                 REPLACE (
                    NVL (UPPER (rc.mtm_course_title),
                         REPLACE (cd.course_name, '"')),
                    CHR (174),
                    ''
                 ),
                 CHR (194),
                 ''
              ),
              CHR (191),
              ''
           )
              mtm_course_title,
           ed.end_date - 1 survey_date
    FROM                                    event_dim ed
                                         INNER JOIN
                                            time_dim td
                                         ON ed.start_date = td.dim_date
                                      INNER JOIN
                                         course_dim cd
                                      ON ed.course_id = cd.course_id
                                         AND ed.ops_country = cd.country
                                   INNER JOIN
                                      gk_mtm_instructor_v ie
                                   ON ed.event_id = ie.evxeventid
                                LEFT OUTER JOIN
                                   order_fact f
                                ON     ed.event_id = f.event_id
                                   AND f.enroll_status != 'Cancelled'
                                   AND f.fee_type != 'Ons - Base' -- change to outer join 5/6/10 jd
                             INNER JOIN
                                cust_dim c
                             ON ie.contactid = c.cust_id
                          INNER JOIN
                             rmsdw.rms_instructor ri
                          ON ie.contactid = ri.slx_contact_id
                       INNER JOIN
                          gk_mtm_location_v lv
                       ON ed.location_id = lv.evxfacilityid
                    INNER JOIN
                       rmsdw.rms_facility rf
                    ON lv.evxfacilityid = rf.slx_facility_id
                 INNER JOIN
                    gk_mtm_lookup ml
                 ON     cd.course_pl = ml.pl_desc
                    AND cd.course_mod = ml.md_desc
                    AND CASE
                          WHEN cd.course_mod = 'V-LEARNING'
                          THEN
                             'VIRTUAL'
                          WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                          THEN
                             'ONSITE'
                          ELSE
                             lv.facility_desc
                       END = ml.loc_type
              LEFT JOIN
                 mtm_course_custom_evals cce
              ON ed.course_code = cce.course_code
           INNER JOIN
              rmsdw.rms_course rc
           ON cd.course_id = rc.slx_course_id
   WHERE       ed.status != 'Cancelled'
           AND cd.course_mod IN ('C-LEARNING', 'V-LEARNING')
           AND ed.mtm_exclude = 'N'
           AND ed.course_code NOT IN (SELECT   ce.course_code
                                        FROM   mtm_course_exclude ce)
GROUP BY   td.dim_year,
           td.dim_week,
           cd.course_pl,
           cd.course_mod,
           cd.course_ch,
           cd.course_id,
           cd.course_code,
           ed.event_id,
           ed.start_date,
           ed.end_date,
           ed.status,
           ed.location_id,
           ed.facility_code,
           ed.capacity,
           ml.ka_survey_id,
           ml.survey_id,
           cce.ka_survey_id,
           cce.survey_name,
           ie.contactid,
           ie.firstname,
           REPLACE (ie.lastname, '1', ''),
           c.email,
           c.acct_name,
           cd.short_name,
           REPLACE (
              REPLACE (
                 REPLACE (REPLACE (cd.course_name, '"'), CHR (174), ''),
                 CHR (194),
                 ''
              ),
              CHR (191),
              ''
           ),
           REPLACE (
              REPLACE (
                 REPLACE (
                    NVL (UPPER (rc.mtm_course_title),
                         REPLACE (cd.course_name, '"')),
                    CHR (174),
                    ''
                 ),
                 CHR (194),
                 ''
              ),
              CHR (191),
              ''
           ),
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND UPPER (ed.location_name) LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
              THEN
                 'Client Site'
              ELSE
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
           END,
           ed.ops_country,
           SUBSTR (cd.course_code, 1, LENGTH (cd.course_code) - 1),
           ed.onsite_attended,
           SUBSTR (UPPER (c.country), 1, 2) || '_' || ri.rms_instructor_id,
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country = 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 30043
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country != 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 5265
              ELSE
                 rf.rms_facility_id
           END,
           rc.mtm_course_title
UNION
  SELECT   td.dim_year,
           td.dim_week,
           cd.course_pl,
           cd.course_mod,
           cd.course_ch,
           cd.course_id,
           cd.course_code,
           ed.event_id,
           ed.start_date,
           ed.end_date,
           ed.status,
           ed.location_id,
           ed.facility_code,
           CASE
              WHEN SUBSTR (cd.course_code, 1, 4) IN ('2622', '2623', '2624')
              THEN
                 '9719'
              WHEN SUBSTR (cd.course_code, 1, 4) IN
                         ('8870', '8871', '8872', '8873', '8874')
              THEN
                 '14815'
              WHEN cd.course_code = '5274N'
              THEN
                 '18859'
              WHEN TRIM (cce.ka_survey_id) IS NOT NULL
              THEN
                 TRIM (cce.ka_survey_id)
              ELSE
                 ml.ka_survey_id
           END
              ka_survey_id,
           CASE
              WHEN SUBSTR (cd.course_code, 1, 4) IN ('2622', '2623', '2624')
              THEN
                 'ADP'
              WHEN SUBSTR (cd.course_code, 1, 4) IN
                         ('8870', '8871', '8872', '8873', '8874')
              THEN
                 'HDI'
              WHEN cd.course_code = '5274N'
              THEN
                 'Master NA - ILT Cisco Private'
              WHEN TRIM (cce.ka_survey_id) IS NOT NULL
              THEN
                 TRIM (cce.survey_name)
              ELSE
                 ml.survey_id
           END
              survey_id,
           NULL contactid1,
           NULL firstname1,
           NULL lastname1,
           NULL email,
           NULL acct_name,
           cd.short_name,
           REPLACE (
              REPLACE (REPLACE (REPLACE (cd.course_name, '"'), CHR (174), ''),
                       CHR (194),
                       ''),
              CHR (191),
              ''
           )
              course_name,
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND UPPER (ed.location_name) LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
              THEN
                 'Client Site'
              ELSE
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
           END
              loc_desc,
           CASE
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND COUNT (f.enroll_id) > 0
              THEN
                 COUNT (f.enroll_id)
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND NVL (ed.onsite_attended, 0) > 0
              THEN
                 ed.onsite_attended - 1
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND NVL (ed.onsite_attended, 0) = 0
              THEN
                 ed.capacity
              WHEN ed.status = 'Verified'
              THEN
                 SUM (CASE WHEN f.enroll_status = 'Attended' THEN 1 ELSE 0 END)
              ELSE
                 COUNT (DISTINCT f.enroll_id)
           END
              enroll_cnt,
           ed.ops_country,
           SUBSTR (cd.course_code, 1, LENGTH (cd.course_code) - 1)
              xml_course_id,
           NULL xml_instructor_id,
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country = 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 30043
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country != 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 5265
              ELSE
                 rf.rms_facility_id
           END
              xml_loc_id,
           REPLACE (
              REPLACE (
                 REPLACE (
                    NVL (UPPER (rc.mtm_course_title),
                         REPLACE (cd.course_name, '"')),
                    CHR (174),
                    ''
                 ),
                 CHR (194),
                 ''
              ),
              CHR (191),
              ''
           )
              mtm_course_title,
           f.book_date + 7 survey_date
    FROM                           event_dim ed
                                INNER JOIN
                                   course_dim cd
                                ON ed.course_id = cd.course_id
                                   AND ed.ops_country = cd.country
                             INNER JOIN
                                order_fact f
                             ON     ed.event_id = f.event_id
                                AND f.enroll_status != 'Cancelled'
                                AND f.fee_type != 'Ons - Base'
                          INNER JOIN
                             time_dim td
                          ON f.book_date = td.dim_date
                       INNER JOIN
                          gk_mtm_location_v lv
                       ON ed.location_id = lv.evxfacilityid
                    INNER JOIN
                       rmsdw.rms_facility rf
                    ON lv.evxfacilityid = rf.slx_facility_id
                 INNER JOIN
                    gk_mtm_lookup ml
                 ON     cd.course_pl = ml.pl_desc
                    AND cd.course_mod = ml.md_desc
                    AND CASE
                          WHEN cd.course_mod = 'V-LEARNING'
                          THEN
                             'VIRTUAL'
                          WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                          THEN
                             'ONSITE'
                          ELSE
                             lv.facility_desc
                       END = ml.loc_type
              LEFT JOIN
                 mtm_course_custom_evals cce
              ON ed.course_code = cce.course_code
           INNER JOIN
              rmsdw.rms_course rc
           ON cd.course_id = rc.slx_course_id
   WHERE       ed.status != 'Cancelled'
           AND cd.md_num = '33'
           AND ed.mtm_exclude = 'N'
           AND ed.course_code NOT IN (SELECT   ce.course_code
                                        FROM   mtm_course_exclude ce)
GROUP BY   td.dim_year,
           td.dim_week,
           cd.course_pl,
           cd.course_mod,
           cd.course_ch,
           cd.course_id,
           cd.course_code,
           ed.event_id,
           ed.start_date,
           ed.end_date,
           ed.status,
           ed.location_id,
           ed.facility_code,
           ed.capacity,
           ml.ka_survey_id,
           ml.survey_id,
           cce.ka_survey_id,
           cce.survey_name,
           cd.short_name,
           f.book_date,
           REPLACE (
              REPLACE (
                 REPLACE (REPLACE (cd.course_name, '"'), CHR (174), ''),
                 CHR (194),
                 ''
              ),
              CHR (191),
              ''
           ),
           REPLACE (
              REPLACE (
                 REPLACE (
                    NVL (UPPER (rc.mtm_course_title),
                         REPLACE (cd.course_name, '"')),
                    CHR (174),
                    ''
                 ),
                 CHR (194),
                 ''
              ),
              CHR (191),
              ''
           ),
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND UPPER (ed.location_name) LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
              WHEN cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
              THEN
                 'Client Site'
              ELSE
                 ed.location_name || '-' || ed.city || ', '
                 || CASE
                       WHEN UPPER (ed.country) = 'CANADA'
                       THEN
                          INITCAP (ed.province)
                       ELSE
                          ed.state
                    END
           END,
           ed.ops_country,
           SUBSTR (cd.course_code, 1, LENGTH (cd.course_code) - 1),
           ed.onsite_attended,
           CASE
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country = 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 30043
              WHEN     cd.course_ch = 'ENTERPRISE/PRIVATE'
                   AND cd.course_mod = 'C-LEARNING'
                   AND ed.ops_country != 'CANADA'
                   AND UPPER (ed.location_name) NOT LIKE 'GLOBAL KNOWLEDGE%'
              THEN
                 5265
              ELSE
                 rf.rms_facility_id
           END,
           rc.mtm_course_title;

COMMENT ON MATERIALIZED VIEW GKDW.GK_MTM_DATA_MV IS 'snapshot table for snapshot GKDW.GK_MTM_DATA_MV';

GRANT SELECT ON GKDW.GK_MTM_DATA_MV TO DWHREAD;

