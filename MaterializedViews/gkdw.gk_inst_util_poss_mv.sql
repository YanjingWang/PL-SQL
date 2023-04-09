DROP MATERIALIZED VIEW GKDW.GK_INST_UTIL_POSS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_INST_UTIL_POSS_MV 
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
/* Formatted on 29/01/2021 12:24:29 (QP5 v5.115.810.9015) */
  SELECT   dim_year,
           dim_period_name,
           qtr,
           period_num,
           startweek,
           ins_name,
           account,
           ins_city,
           ins_state,
           ins_postal,
           ins_country,
           acct_type,
           SUM (possible_teach_days) possible_teach_days,
           SUM (possible_level_1_days) possible_level_1_days,
           SUM (possible_level_2_days) possible_level_2_days,
           SUM (possible_level_3_days) possible_level_3_days
    FROM   (  SELECT   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                          period_num,
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                       UPPER (c.first_name || ' ' || c.last_name) ins_name,
                       UPPER (c.acct_name) account,
                       UPPER (c.city) ins_city,
                       UPPER (c.state) ins_state,
                       UPPER (c.zipcode) ins_postal,
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
                       MAX (ed.end_date - ed.start_date + 1) possible_teach_days,
                       0 possible_level_1_days,
                       0 possible_level_2_days,
                       0 possible_level_3_days
                FROM                  event_dim ed
                                   INNER JOIN
                                      time_dim td
                                   ON ed.start_date = td.dim_date
                                INNER JOIN
                                   course_dim cd
                                ON ed.course_id = cd.course_id
                                   AND ed.ops_country = cd.country
                             INNER JOIN
                                rmsdw.rms_instructor_cert ric
                             ON SUBSTR (cd.course_code, 1, 4) = ric.coursecode
                                AND cd.course_mod = ric.modality_group
                          INNER JOIN
                             rmsdw.rms_instructor ri
                          ON ric.rms_instructor_id = ri.rms_instructor_id
                       INNER JOIN
                          cust_dim c
                       ON ri.slx_contact_id = c.cust_id
               WHERE       td.dim_year >= 2007
                       AND ed.status != 'Cancelled'
                       AND cd.md_num IN ('10', '20')
            GROUP BY   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0'),
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0'),
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
                       UPPER (c.first_name || ' ' || c.last_name),
                       UPPER (c.acct_name),
                       UPPER (c.city),
                       UPPER (c.state),
                       UPPER (c.zipcode),
                       UPPER (c.country),
                       CASE
                          WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                                OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                          THEN
                             'INTERNAL'
                          ELSE
                             'EXTERNAL'
                       END
            UNION
              SELECT   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                          period_num,
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                       UPPER (c.first_name || ' ' || c.last_name) ins_name,
                       UPPER (c.acct_name) account,
                       UPPER (c.city) ins_city,
                       UPPER (c.state) ins_state,
                       UPPER (c.zipcode) ins_postal,
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
                       0,
                       MAX (ed.end_date - ed.start_date + 1),
                       0,
                       0
                FROM                     event_dim ed
                                      INNER JOIN
                                         time_dim td
                                      ON ed.start_date = td.dim_date
                                   INNER JOIN
                                      course_dim cd
                                   ON ed.course_id = cd.course_id
                                      AND ed.ops_country = cd.country
                                INNER JOIN
                                   rmsdw.rms_instructor_cert ric
                                ON SUBSTR (cd.course_code, 1, 4) = ric.coursecode
                                   AND cd.course_mod = ric.modality_group
                             INNER JOIN
                                rmsdw.rms_instructor ri
                             ON ric.rms_instructor_id = ri.rms_instructor_id
                          INNER JOIN
                             cust_dim c
                          ON ri.slx_contact_id = c.cust_id
                       INNER JOIN
                          rmsdw.rms_instructor_metro rim
                       ON ric.rms_instructor_id = rim.rms_instructor_id
                          AND rim.metro_code = ed.facility_region_metro
               WHERE       td.dim_year >= 2007
                       AND ed.status != 'Cancelled'
                       AND cd.md_num IN ('10', '20')
                       AND rim.metro_level = 1
            GROUP BY   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0'),
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0'),
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
                       UPPER (c.first_name || ' ' || c.last_name),
                       UPPER (c.acct_name),
                       UPPER (c.city),
                       UPPER (c.state),
                       UPPER (c.zipcode),
                       UPPER (c.country),
                       CASE
                          WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                                OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                          THEN
                             'INTERNAL'
                          ELSE
                             'EXTERNAL'
                       END
            UNION
              SELECT   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                          period_num,
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                       UPPER (c.first_name || ' ' || c.last_name) ins_name,
                       UPPER (c.acct_name) account,
                       UPPER (c.city) ins_city,
                       UPPER (c.state) ins_state,
                       UPPER (c.zipcode) ins_postal,
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
                       0,
                       0,
                       MAX (ed.end_date - ed.start_date + 1),
                       0
                FROM                     event_dim ed
                                      INNER JOIN
                                         time_dim td
                                      ON ed.start_date = td.dim_date
                                   INNER JOIN
                                      course_dim cd
                                   ON ed.course_id = cd.course_id
                                      AND ed.ops_country = cd.country
                                INNER JOIN
                                   rmsdw.rms_instructor_cert ric
                                ON SUBSTR (cd.course_code, 1, 4) = ric.coursecode
                                   AND cd.course_mod = ric.modality_group
                             INNER JOIN
                                rmsdw.rms_instructor ri
                             ON ric.rms_instructor_id = ri.rms_instructor_id
                          INNER JOIN
                             cust_dim c
                          ON ri.slx_contact_id = c.cust_id
                       INNER JOIN
                          rmsdw.rms_instructor_metro rim
                       ON ric.rms_instructor_id = rim.rms_instructor_id
                          AND rim.metro_code = ed.facility_region_metro
               WHERE       td.dim_year >= 2007
                       AND ed.status != 'Cancelled'
                       AND cd.md_num IN ('10', '20')
                       AND rim.metro_level = 2
            GROUP BY   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0'),
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0'),
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
                       UPPER (c.first_name || ' ' || c.last_name),
                       UPPER (c.acct_name),
                       UPPER (c.city),
                       UPPER (c.state),
                       UPPER (c.zipcode),
                       UPPER (c.country),
                       CASE
                          WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                                OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                          THEN
                             'INTERNAL'
                          ELSE
                             'EXTERNAL'
                       END
            UNION
              SELECT   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0') qtr,
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0')
                          period_num,
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0') startweek,
                       UPPER (c.first_name || ' ' || c.last_name) ins_name,
                       UPPER (c.acct_name) account,
                       UPPER (c.city) ins_city,
                       UPPER (c.state) ins_state,
                       UPPER (c.zipcode) ins_postal,
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
                       0,
                       0,
                       0,
                       MAX (ed.end_date - ed.start_date + 1)
                FROM                     event_dim ed
                                      INNER JOIN
                                         time_dim td
                                      ON ed.start_date = td.dim_date
                                   INNER JOIN
                                      course_dim cd
                                   ON ed.course_id = cd.course_id
                                      AND ed.ops_country = cd.country
                                INNER JOIN
                                   rmsdw.rms_instructor_cert ric
                                ON SUBSTR (cd.course_code, 1, 4) = ric.coursecode
                                   AND cd.course_mod = ric.modality_group
                             INNER JOIN
                                rmsdw.rms_instructor ri
                             ON ric.rms_instructor_id = ri.rms_instructor_id
                          INNER JOIN
                             cust_dim c
                          ON ri.slx_contact_id = c.cust_id
                       INNER JOIN
                          rmsdw.rms_instructor_metro rim
                       ON ric.rms_instructor_id = rim.rms_instructor_id
                          AND rim.metro_code = ed.facility_region_metro
               WHERE       td.dim_year >= 2007
                       AND ed.status != 'Cancelled'
                       AND cd.md_num IN ('10', '20')
                       AND rim.metro_level = 3
            GROUP BY   td.dim_year,
                       td.dim_period_name,
                       td.dim_year || '-' || LPAD (td.dim_quarter, 2, '0'),
                       td.dim_year || '-' || LPAD (dim_month_num, 2, '0'),
                       td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
                       UPPER (c.first_name || ' ' || c.last_name),
                       UPPER (c.acct_name),
                       UPPER (c.city),
                       UPPER (c.state),
                       UPPER (c.zipcode),
                       UPPER (c.country),
                       CASE
                          WHEN (UPPER (c.acct_name) LIKE 'GLOBAL KNOWLEDGE%'
                                OR UPPER (c.acct_name) LIKE 'NEXIENT%')
                          THEN
                             'INTERNAL'
                          ELSE
                             'EXTERNAL'
                       END)
GROUP BY   dim_year,
           dim_period_name,
           qtr,
           period_num,
           startweek,
           ins_name,
           account,
           ins_city,
           ins_state,
           ins_postal,
           ins_country,
           acct_type;

COMMENT ON MATERIALIZED VIEW GKDW.GK_INST_UTIL_POSS_MV IS 'snapshot table for snapshot GKDW.GK_INST_UTIL_POSS_MV';

GRANT SELECT ON GKDW.GK_INST_UTIL_POSS_MV TO DWHREAD;

