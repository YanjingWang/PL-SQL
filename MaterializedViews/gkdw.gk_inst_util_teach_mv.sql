DROP MATERIALIZED VIEW GKDW.GK_INST_UTIL_TEACH_MV;
CREATE MATERIALIZED VIEW GKDW.GK_INST_UTIL_TEACH_MV 
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
/* Formatted on 29/01/2021 12:24:25 (QP5 v5.115.810.9015) */
  SELECT   dim_year,
           dim_period_name,
           qtr,
           period_num,
           evxeventid,
           eventname,
           eventstatus,
           startdate,
           facilityregionmetro,
           startweek,
           shortname,
           coursecode,
           ch_desc,
           md_desc,
           pl_desc,
           facilitycode,
           fac_city,
           fac_state,
           fac_postal,
           ins_name,
           ACCOUNT,
           ins_city,
           ins_state,
           ins_postal,
           coursetype,
           event_desc,
           ins_country,
           acct_type,
           ops_country,
           SUM (teach_days) teach_days,
           SUM (teach_days_1) teach_days_1,
           SUM (teach_days_2) teach_days_2,
           SUM (teach_days_3) teach_days_3
    FROM   (SELECT   td.dim_year,
                     td.dim_period_name,
                     td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                     td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                        period_num,
                     ed.event_id evxeventid,
                     ed.event_name eventname,
                     ed.status eventstatus,
                     ed.start_date startdate,
                     ed.facility_region_metro facilityregionmetro,
                     td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                     cd.short_name shortname,
                     ed.course_code coursecode,
                     cd.course_ch ch_desc,
                     cd.course_mod md_desc,
                     cd.course_pl pl_desc,
                     ed.facility_code facilitycode,
                     UPPER (ed.city) fac_city,
                     UPPER (ed.state) fac_state,
                     UPPER (ed.zipcode) fac_postal,
                     UPPER (c.first_name || ' ' || c.last_name) ins_name,
                     UPPER (c.acct_name) ACCOUNT,
                     UPPER (c.city) ins_city,
                     UPPER (c.state) ins_state,
                     UPPER (c.zipcode) ins_postal,
                     cd.course_type coursetype,
                        cd.course_code
                     || '-'
                     || ed.facility_region_metro
                     || '-'
                     || TO_CHAR (ed.start_date, 'yyyymmdd')
                        event_desc,
                     UPPER (c.country) ins_country,
                     CASE
                        WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                              OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                        THEN
                           'INTERNAL'
                        ELSE
                           'EXTERNAL'
                     END
                        acct_type,
                     SUBSTR (ops_country, 1, 3) ops_country,
                     ed.end_date - ed.start_date + 1 teach_days,
                     0 teach_days_1,
                     0 teach_days_2,
                     0 teach_days_3
              FROM               gk_inst_unavailable_mv iu
                              INNER JOIN
                                 event_dim ed
                              ON iu.event_id = ed.event_id
                           INNER JOIN
                              time_dim td
                           ON ed.start_date = td.dim_date
                        INNER JOIN
                           course_dim cd
                        ON ed.course_id = cd.course_id
                           AND ed.ops_country = cd.country
                     INNER JOIN
                        cust_dim c
                     ON iu.instructor_id = c.cust_id
             WHERE   inst_desc IN
                           ('[INS] - Instructor',
                            '[SI] - Supervising Instructor')
                     AND ed.status != 'Cancelled'
            UNION ALL
            SELECT   td.dim_year,
                     td.dim_period_name,
                     td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                     td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                        period_num,
                     ed.event_id evxeventid,
                     ed.event_name eventname,
                     ed.status eventstatus,
                     ed.start_date startdate,
                     ed.facility_region_metro facilityregionmetro,
                     td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                     cd.short_name shortname,
                     ed.course_code coursecode,
                     cd.course_ch ch_desc,
                     cd.course_mod md_desc,
                     cd.course_pl pl_desc,
                     ed.facility_code facilitycode,
                     UPPER (ed.city) fac_city,
                     UPPER (ed.state) fac_state,
                     UPPER (ed.zipcode) fac_postal,
                     UPPER (c.first_name || ' ' || c.last_name) ins_name,
                     UPPER (c.acct_name) ACCOUNT,
                     UPPER (c.city) ins_city,
                     UPPER (c.state) ins_state,
                     UPPER (c.zipcode) ins_postal,
                     cd.course_type coursetype,
                        cd.course_code
                     || '-'
                     || ed.facility_region_metro
                     || '-'
                     || TO_CHAR (ed.start_date, 'yyyymmdd')
                        event_desc,
                     UPPER (c.country) ins_country,
                     CASE
                        WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                              OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                        THEN
                           'INTERNAL'
                        ELSE
                           'EXTERNAL'
                     END
                        acct_type,
                     SUBSTR (ops_country, 1, 3) ops_country,
                     0 teach_days,
                     ed.end_date - ed.start_date + 1 teach_days_1,
                     0 teach_days_2,
                     0 teach_days_3
              FROM                     gk_inst_unavailable_mv iu
                                    INNER JOIN
                                       event_dim ed
                                    ON iu.event_id = ed.event_id
                                 INNER JOIN
                                    time_dim td
                                 ON ed.start_date = td.dim_date
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.ops_country = cd.country
                           INNER JOIN
                              cust_dim c
                           ON iu.instructor_id = c.cust_id
                        INNER JOIN
                           rmsdw.rms_instructor ri
                        ON iu.instructor_id = ri.slx_contact_id
                     INNER JOIN
                        rmsdw.rms_instructor_metro rim
                     ON ri.rms_instructor_id = rim.rms_instructor_id
                        AND rim.metro_code = ed.facility_region_metro
             WHERE   inst_desc IN
                           ('[INS] - Instructor',
                            '[SI] - Supervising Instructor')
                     AND ed.status != 'Cancelled'
                     AND rim.metro_level = 1
            UNION ALL
            SELECT   td.dim_year,
                     td.dim_period_name,
                     td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                     td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                        period_num,
                     ed.event_id evxeventid,
                     ed.event_name eventname,
                     ed.status eventstatus,
                     ed.start_date startdate,
                     ed.facility_region_metro facilityregionmetro,
                     td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                     cd.short_name shortname,
                     ed.course_code coursecode,
                     cd.course_ch ch_desc,
                     cd.course_mod md_desc,
                     cd.course_pl pl_desc,
                     ed.facility_code facilitycode,
                     UPPER (ed.city) fac_city,
                     UPPER (ed.state) fac_state,
                     UPPER (ed.zipcode) fac_postal,
                     UPPER (c.first_name || ' ' || c.last_name) ins_name,
                     UPPER (c.acct_name) ACCOUNT,
                     UPPER (c.city) ins_city,
                     UPPER (c.state) ins_state,
                     UPPER (c.zipcode) ins_postal,
                     cd.course_type coursetype,
                        cd.course_code
                     || '-'
                     || ed.facility_region_metro
                     || '-'
                     || TO_CHAR (ed.start_date, 'yyyymmdd')
                        event_desc,
                     UPPER (c.country) ins_country,
                     CASE
                        WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                              OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                        THEN
                           'INTERNAL'
                        ELSE
                           'EXTERNAL'
                     END
                        acct_type,
                     SUBSTR (ops_country, 1, 3) ops_country,
                     0 teach_days,
                     0 teach_days_1,
                     ed.end_date - ed.start_date + 1 teach_days_2,
                     0 teach_days_3
              FROM                     gk_inst_unavailable_mv iu
                                    INNER JOIN
                                       event_dim ed
                                    ON iu.event_id = ed.event_id
                                 INNER JOIN
                                    time_dim td
                                 ON ed.start_date = td.dim_date
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.ops_country = cd.country
                           INNER JOIN
                              cust_dim c
                           ON iu.instructor_id = c.cust_id
                        INNER JOIN
                           rmsdw.rms_instructor ri
                        ON iu.instructor_id = ri.slx_contact_id
                     INNER JOIN
                        rmsdw.rms_instructor_metro rim
                     ON ri.rms_instructor_id = rim.rms_instructor_id
                        AND rim.metro_code = ed.facility_region_metro
             WHERE   inst_desc IN
                           ('[INS] - Instructor',
                            '[SI] - Supervising Instructor')
                     AND ed.status != 'Cancelled'
                     AND rim.metro_level = 2
            UNION ALL
            SELECT   td.dim_year,
                     td.dim_period_name,
                     td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                     td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                        period_num,
                     ed.event_id evxeventid,
                     ed.event_name eventname,
                     ed.status eventstatus,
                     ed.start_date startdate,
                     ed.facility_region_metro facilityregionmetro,
                     td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                     cd.short_name shortname,
                     ed.course_code coursecode,
                     cd.course_ch ch_desc,
                     cd.course_mod md_desc,
                     cd.course_pl pl_desc,
                     ed.facility_code facilitycode,
                     UPPER (ed.city) fac_city,
                     UPPER (ed.state) fac_state,
                     UPPER (ed.zipcode) fac_postal,
                     UPPER (c.first_name || ' ' || c.last_name) ins_name,
                     UPPER (c.acct_name) ACCOUNT,
                     UPPER (c.city) ins_city,
                     UPPER (c.state) ins_state,
                     UPPER (c.zipcode) ins_postal,
                     cd.course_type coursetype,
                        cd.course_code
                     || '-'
                     || ed.facility_region_metro
                     || '-'
                     || TO_CHAR (ed.start_date, 'yyyymmdd')
                        event_desc,
                     UPPER (c.country) ins_country,
                     CASE
                        WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                              OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                        THEN
                           'INTERNAL'
                        ELSE
                           'EXTERNAL'
                     END
                        acct_type,
                     SUBSTR (ops_country, 1, 3) ops_country,
                     0 teach_days,
                     0 teach_days_1,
                     0 teach_days_2,
                     ed.end_date - ed.start_date + 1 teach_days_3
              FROM                     gk_inst_unavailable_mv iu
                                    INNER JOIN
                                       event_dim ed
                                    ON iu.event_id = ed.event_id
                                 INNER JOIN
                                    time_dim td
                                 ON ed.start_date = td.dim_date
                              INNER JOIN
                                 course_dim cd
                              ON ed.course_id = cd.course_id
                                 AND ed.ops_country = cd.country
                           INNER JOIN
                              cust_dim c
                           ON iu.instructor_id = c.cust_id
                        INNER JOIN
                           rmsdw.rms_instructor ri
                        ON iu.instructor_id = ri.slx_contact_id
                     INNER JOIN
                        rmsdw.rms_instructor_metro rim
                     ON ri.rms_instructor_id = rim.rms_instructor_id
                        AND rim.metro_code = ed.facility_region_metro
             WHERE   inst_desc IN
                           ('[INS] - Instructor',
                            '[SI] - Supervising Instructor')
                     AND ed.status != 'Cancelled'
                     AND rim.metro_level = 3)
GROUP BY   dim_year,
           dim_period_name,
           qtr,
           period_num,
           evxeventid,
           eventname,
           eventstatus,
           startdate,
           facilityregionmetro,
           startweek,
           shortname,
           coursecode,
           ch_desc,
           md_desc,
           pl_desc,
           facilitycode,
           fac_city,
           fac_state,
           fac_postal,
           ins_name,
           ACCOUNT,
           ins_city,
           ins_state,
           ins_postal,
           coursetype,
           event_desc,
           ins_country,
           acct_type,
           ops_country;

COMMENT ON MATERIALIZED VIEW GKDW.GK_INST_UTIL_TEACH_MV IS 'snapshot table for snapshot GKDW.GK_INST_UTIL_TEACH_MV';

GRANT SELECT ON GKDW.GK_INST_UTIL_TEACH_MV TO DWHREAD;

