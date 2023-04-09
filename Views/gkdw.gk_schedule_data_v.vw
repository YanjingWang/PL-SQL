DROP VIEW GKDW.GK_SCHEDULE_DATA_V;

/* Formatted on 29/01/2021 11:27:14 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHEDULE_DATA_V
(
   YEAR_OFFSET,
   DIM_YEAR,
   DIM_QTR,
   DIM_MONTH,
   COURSE_ID,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_PL,
   COURSE_MOD,
   COURSE_TYPE,
   OPS_COUNTRY,
   METRO,
   METRO_TIER,
   CONNECTED_C,
   CONNECTED_V,
   EV_SCHED,
   EV_RUN,
   EV_CANC,
   EV_STUD
)
AS
     SELECT   0 year_offset,
              td.dim_year,
              td.dim_year || '-' || td.dim_quarter dim_qtr,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
              cd.course_id,
              cd.course_code,
              cd.short_name,
              cd.course_pl,
              cd.course_mod,
              cd.course_type,
              ed.ops_country,
              ed.facility_region_metro metro,
              CASE
                 WHEN ed.facility_region_metro IN
                            ('MTL',
                             'TOR',
                             'VAN',
                             'NYC',
                             'WAS',
                             'MRS',
                             'DAL',
                             'CHI',
                             'SNJ',
                             'RTP',
                             'ATL')
                 THEN
                    1
                 WHEN ed.facility_region_metro IN ('BOS', 'CLB', 'HOU', 'LOS')
                 THEN
                    2
                 WHEN ed.facility_region_metro IN ('VCL')
                 THEN
                    0
                 ELSE
                    3
              END
                 metro_tier,
              NVL (ed.connected_c, 'N') connected_c,
              CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
                 connected_v,
              COUNT (DISTINCT ed.event_id) ev_sched,
              SUM (CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END) ev_run,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END) ev_canc,
              NVL (SUM (oa.enroll_cnt), 0) ev_stud
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              LEFT OUTER JOIN
                 gk_oe_attended_cnt_v oa
              ON ed.event_id = oa.event_id
      WHERE   ed.start_date > TRUNC (SYSDATE) - 365
              AND ed.start_date <= TRUNC (SYSDATE)
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
   GROUP BY   td.dim_year,
              td.dim_year || '-' || td.dim_quarter,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              cd.course_id,
              cd.course_code,
              cd.short_name,
              cd.course_pl,
              cd.course_mod,
              cd.course_type,
              ed.ops_country,
              ed.facility_region_metro,
              location_name,
              ed.connected_c,
              ed.connected_v_to_c
   UNION
     SELECT   -1 year_offset,
              td.dim_year,
              td.dim_year || '-' || td.dim_quarter dim_qtr,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
              cd.course_id,
              cd.course_code,
              cd.short_name,
              cd.course_pl,
              cd.course_mod,
              cd.course_type,
              ed.ops_country,
              ed.facility_region_metro metro,
              CASE
                 WHEN ed.facility_region_metro IN
                            ('MTL',
                             'TOR',
                             'VAN',
                             'NYC',
                             'WAS',
                             'MRS',
                             'DAL',
                             'CHI',
                             'SNJ',
                             'RTP',
                             'ATL')
                 THEN
                    1
                 WHEN ed.facility_region_metro IN ('BOS', 'CLB', 'HOU', 'LOS')
                 THEN
                    2
                 WHEN ed.facility_region_metro IN ('VCL')
                 THEN
                    0
                 ELSE
                    3
              END
                 metro_tier,
              NVL (ed.connected_c, 'N') connected_c,
              CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
                 connected_v,
              COUNT (DISTINCT ed.event_id) ev_sched,
              SUM (CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END) ev_run,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END) ev_canc,
              NVL (SUM (oa.enroll_cnt), 0) ev_stud
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              LEFT OUTER JOIN
                 gk_oe_attended_cnt_v oa
              ON ed.event_id = oa.event_id
      WHERE   ed.start_date > TRUNC (SYSDATE) - 730
              AND ed.start_date <= TRUNC (SYSDATE) - 365
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
   GROUP BY   td.dim_year,
              td.dim_year || '-' || td.dim_quarter,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              cd.course_id,
              cd.course_code,
              cd.short_name,
              cd.course_pl,
              cd.course_mod,
              cd.course_type,
              ed.ops_country,
              ed.facility_region_metro,
              location_name,
              ed.connected_c,
              ed.connected_v_to_c
   UNION
     SELECT   -2 year_offset,
              td.dim_year,
              td.dim_year || '-' || td.dim_quarter dim_qtr,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
              cd.course_id,
              cd.course_code,
              cd.short_name,
              cd.course_pl,
              cd.course_mod,
              cd.course_type,
              ed.ops_country,
              ed.facility_region_metro metro,
              CASE
                 WHEN ed.facility_region_metro IN
                            ('MTL',
                             'TOR',
                             'VAN',
                             'NYC',
                             'WAS',
                             'MRS',
                             'DAL',
                             'CHI',
                             'SNJ',
                             'RTP',
                             'ATL')
                 THEN
                    1
                 WHEN ed.facility_region_metro IN ('BOS', 'CLB', 'HOU', 'LOS')
                 THEN
                    2
                 WHEN ed.facility_region_metro IN ('VCL')
                 THEN
                    0
                 ELSE
                    3
              END
                 metro_tier,
              NVL (ed.connected_c, 'N') connected_c,
              CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
                 connected_v,
              COUNT (DISTINCT ed.event_id) ev_sched,
              SUM (CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END) ev_run,
              SUM (CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END) ev_canc,
              NVL (SUM (oa.enroll_cnt), 0) ev_stud
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              LEFT OUTER JOIN
                 gk_oe_attended_cnt_v oa
              ON ed.event_id = oa.event_id
      WHERE   ed.start_date > TRUNC (SYSDATE) - 1095
              AND ed.start_date <= TRUNC (SYSDATE) - 730
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('9983', '9984', '9989', '9992', '9995')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
   GROUP BY   td.dim_year,
              td.dim_year || '-' || td.dim_quarter,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              cd.course_id,
              cd.course_code,
              cd.short_name,
              cd.course_pl,
              cd.course_mod,
              cd.course_type,
              ed.ops_country,
              ed.facility_region_metro,
              location_name,
              ed.connected_c,
              ed.connected_v_to_c
   ORDER BY   year_offset, ops_country, metro;


