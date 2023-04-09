DROP VIEW GKDW.GK_SCHED_PLAN_V;

/* Formatted on 29/01/2021 11:26:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SCHED_PLAN_V
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
   EVENT_ID,
   OPS_COUNTRY,
   METRO,
   METRO_TIER,
   TZABBREVIATION,
   CONNECTED_C,
   CONNECTED_V,
   SALES_REQUEST,
   EV_SCHED,
   EV_RUN,
   EV_CANC,
   EV_STUD,
   FREQ_WEEKS
)
AS
   SELECT   1 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            ed.event_id,
            ed.ops_country,
            ed.facility_region_metro metro,
            CASE
               WHEN ed.facility_region_metro IN
                          ('OTT',
                           'TOR',
                           'VAN',
                           'MTL',
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
            ez.tzabbreviation,
            NVL (ed.connected_c, 'N') connected_c,
            CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
               connected_v,
            CASE WHEN ed.plan_type = 'Sales Request' THEN 'Y' ELSE 'N' END
               sales_request,
            1 ev_sched,
            CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END ev_run,
            CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END ev_canc,
            NVL (oa.enroll_cnt, 0) ev_stud,
            cf.freq_weeks
     FROM                     event_dim ed
                           INNER JOIN
                              course_dim cd
                           ON ed.course_id = cd.course_id
                              AND ed.ops_country = cd.country
                        INNER JOIN
                           time_dim td
                        ON ed.start_date = td.dim_date
                     INNER JOIN
                        gk_sched_course_freq_v cf
                     ON     ed.course_id = cf.course_id
                        AND ed.ops_country = cf.ops_country
                        AND cf.year_offset = 0
                  LEFT OUTER JOIN
                     gk_oe_attended_cnt_v oa
                  ON ed.event_id = oa.event_id
               LEFT OUTER JOIN
                  slxdw.evxevent ee
               ON ed.event_id = ee.evxeventid
            LEFT OUTER JOIN
               slxdw.evxtimezone ez
            ON ee.evxtimezoneid = ez.evxtimezoneid
    WHERE   ed.start_date > TRUNC (SYSDATE)
            AND ed.start_date <= TRUNC (SYSDATE) + 365
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '10'
            AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                     ('Course Delays - Equipment, Devel',
                      'Course Discontinued',
                      'Course Version Update',
                      'Event in Error',
                      'Event Postponed due to Acts of N',
                      'OS XL - Rescheduled due to Holid',
                      'Pre-Cancel (market/schedule righ')
   UNION
   SELECT   1 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            sp.event_id,
            sp.ops_country,
            'VCL' metro,
            0 metro_tier,
            'EST' tzabbreviation,
            'N' connected_c,
            sp.connected_v,
            sp.sales_request,
            sp.ev_sched,
            sp.ev_run,
            sp.ev_canc,
            sp.ev_stud,
            cf.freq_weeks
     FROM            gk_vcl_sched_plan_v sp
                  INNER JOIN
                     course_dim cd
                  ON sp.course_id = cd.course_id
                     AND cd.country = sp.ops_country
               INNER JOIN
                  time_dim td
               ON sp.start_date = td.dim_date
            INNER JOIN
               gk_sched_course_freq_v cf
            ON     sp.course_id = cf.course_id
               AND sp.ops_country = cf.ops_country
               AND cf.year_offset = 0
    WHERE   sp.start_date > TRUNC (SYSDATE)
            AND sp.start_date <= TRUNC (SYSDATE) + 365
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '20'
   UNION
   SELECT   0 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            ed.event_id,
            ed.ops_country,
            ed.facility_region_metro metro,
            CASE
               WHEN ed.facility_region_metro IN
                          ('OTT',
                           'TOR',
                           'VAN',
                           'MTL',
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
            ez.tzabbreviation,
            NVL (ed.connected_c, 'N') connected_c,
            CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
               connected_v,
            CASE WHEN ed.plan_type = 'Sales Request' THEN 'Y' ELSE 'N' END
               sales_request,
            1 ev_sched,
            CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END ev_run,
            CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END ev_canc,
            NVL (oa.enroll_cnt, 0) ev_stud,
            cf.freq_weeks
     FROM                     event_dim ed
                           INNER JOIN
                              course_dim cd
                           ON ed.course_id = cd.course_id
                              AND ed.ops_country = cd.country
                        INNER JOIN
                           time_dim td
                        ON ed.start_date = td.dim_date
                     INNER JOIN
                        gk_sched_course_freq_v cf
                     ON     ed.course_id = cf.course_id
                        AND ed.ops_country = cf.ops_country
                        AND cf.year_offset = 0
                  LEFT OUTER JOIN
                     gk_oe_attended_cnt_v oa
                  ON ed.event_id = oa.event_id
               LEFT OUTER JOIN
                  slxdw.evxevent ee
               ON ed.event_id = ee.evxeventid
            LEFT OUTER JOIN
               slxdw.evxtimezone ez
            ON ee.evxtimezoneid = ez.evxtimezoneid
    WHERE   ed.start_date > TRUNC (SYSDATE) - 365
            AND ed.start_date <= TRUNC (SYSDATE)
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '10'
            AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                     ('Course Delays - Equipment, Devel',
                      'Course Discontinued',
                      'Course Version Update',
                      'Event in Error',
                      'Event Postponed due to Acts of N',
                      'OS XL - Rescheduled due to Holid',
                      'Pre-Cancel (market/schedule righ')
   UNION
   SELECT   0 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            sp.event_id,
            sp.ops_country,
            'VCL' metro,
            0 metro_tier,
            'EST' tzabbreviation,
            'N' connected_c,
            sp.connected_v,
            sp.sales_request,
            sp.ev_sched,
            sp.ev_run,
            sp.ev_canc,
            sp.ev_stud,
            cf.freq_weeks
     FROM            gk_vcl_sched_plan_v sp
                  INNER JOIN
                     course_dim cd
                  ON sp.course_id = cd.course_id
                     AND cd.country = sp.ops_country
               INNER JOIN
                  time_dim td
               ON sp.start_date = td.dim_date
            INNER JOIN
               gk_sched_course_freq_v cf
            ON     sp.course_id = cf.course_id
               AND sp.ops_country = cf.ops_country
               AND cf.year_offset = 0
    WHERE   sp.start_date > TRUNC (SYSDATE) - 365
            AND sp.start_date <= TRUNC (SYSDATE)
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '20'
   UNION
   SELECT   -1 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            ed.event_id,
            ed.ops_country,
            ed.facility_region_metro metro,
            CASE
               WHEN ed.facility_region_metro IN
                          ('OTT',
                           'TOR',
                           'VAN',
                           'MTL',
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
            ez.tzabbreviation,
            NVL (ed.connected_c, 'N') connected_c,
            CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
               connected_v,
            CASE WHEN ed.plan_type = 'Sales Request' THEN 'Y' ELSE 'N' END
               sales_request,
            1 ev_sched,
            CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END ev_run,
            CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END ev_canc,
            NVL (oa.enroll_cnt, 0) ev_stud,
            cf.freq_weeks
     FROM                     event_dim ed
                           INNER JOIN
                              course_dim cd
                           ON ed.course_id = cd.course_id
                              AND ed.ops_country = cd.country
                        INNER JOIN
                           time_dim td
                        ON ed.start_date = td.dim_date
                     INNER JOIN
                        gk_sched_course_freq_v cf
                     ON     ed.course_id = cf.course_id
                        AND ed.ops_country = cf.ops_country
                        AND cf.year_offset = 0
                  LEFT OUTER JOIN
                     gk_oe_attended_cnt_v oa
                  ON ed.event_id = oa.event_id
               LEFT OUTER JOIN
                  slxdw.evxevent ee
               ON ed.event_id = ee.evxeventid
            LEFT OUTER JOIN
               slxdw.evxtimezone ez
            ON ee.evxtimezoneid = ez.evxtimezoneid
    WHERE   ed.start_date > TRUNC (SYSDATE) - 730
            AND ed.start_date <= TRUNC (SYSDATE) - 365
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '10'
            AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                     ('Course Delays - Equipment, Devel',
                      'Course Discontinued',
                      'Course Version Update',
                      'Event in Error',
                      'Event Postponed due to Acts of N',
                      'OS XL - Rescheduled due to Holid',
                      'Pre-Cancel (market/schedule righ')
   UNION
   SELECT   -1 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            sp.event_id,
            sp.ops_country,
            'VCL' metro,
            0 metro_tier,
            'EST' tzabbreviation,
            'N' connected_c,
            sp.connected_v,
            sp.sales_request,
            sp.ev_sched,
            sp.ev_run,
            sp.ev_canc,
            sp.ev_stud,
            cf.freq_weeks
     FROM            gk_vcl_sched_plan_v sp
                  INNER JOIN
                     course_dim cd
                  ON sp.course_id = cd.course_id
                     AND cd.country = sp.ops_country
               INNER JOIN
                  time_dim td
               ON sp.start_date = td.dim_date
            INNER JOIN
               gk_sched_course_freq_v cf
            ON     sp.course_id = cf.course_id
               AND sp.ops_country = cf.ops_country
               AND cf.year_offset = 0
    WHERE   sp.start_date > TRUNC (SYSDATE) - 730
            AND sp.start_date <= TRUNC (SYSDATE) - 365
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '20'
   UNION
   SELECT   -2 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            ed.event_id,
            ed.ops_country,
            ed.facility_region_metro metro,
            CASE
               WHEN ed.facility_region_metro IN
                          ('OTT',
                           'TOR',
                           'VAN',
                           'MTL',
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
            ez.tzabbreviation,
            NVL (ed.connected_c, 'N') connected_c,
            CASE WHEN ed.connected_v_to_c IS NOT NULL THEN 'Y' ELSE 'N' END
               connected_v,
            CASE WHEN ed.plan_type = 'Sales Request' THEN 'Y' ELSE 'N' END
               sales_request,
            1 ev_sched,
            CASE WHEN ed.status != 'Cancelled' THEN 1 ELSE 0 END ev_run,
            CASE WHEN ed.status = 'Cancelled' THEN 1 ELSE 0 END ev_canc,
            NVL (oa.enroll_cnt, 0) ev_stud,
            cf.freq_weeks
     FROM                     event_dim ed
                           INNER JOIN
                              course_dim cd
                           ON ed.course_id = cd.course_id
                              AND ed.ops_country = cd.country
                        INNER JOIN
                           time_dim td
                        ON ed.start_date = td.dim_date
                     INNER JOIN
                        gk_sched_course_freq_v cf
                     ON     ed.course_id = cf.course_id
                        AND ed.ops_country = cf.ops_country
                        AND cf.year_offset = 0
                  LEFT OUTER JOIN
                     gk_oe_attended_cnt_v oa
                  ON ed.event_id = oa.event_id
               LEFT OUTER JOIN
                  slxdw.evxevent ee
               ON ed.event_id = ee.evxeventid
            LEFT OUTER JOIN
               slxdw.evxtimezone ez
            ON ee.evxtimezoneid = ez.evxtimezoneid
    WHERE   ed.start_date > TRUNC (SYSDATE) - 1095
            AND ed.start_date <= TRUNC (SYSDATE) - 730
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '10'
            AND NVL (REPLACE (ed.cancel_reason, CHR (13), ''), 'NONE') NOT IN
                     ('Course Delays - Equipment, Devel',
                      'Course Discontinued',
                      'Course Version Update',
                      'Event in Error',
                      'Event Postponed due to Acts of N',
                      'OS XL - Rescheduled due to Holid',
                      'Pre-Cancel (market/schedule righ')
   UNION
   SELECT   -2 year_offset,
            td.dim_year,
            td.dim_year || '-' || td.dim_quarter dim_qtr,
            td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') dim_month,
            cd.course_id,
            cd.course_code,
            cd.short_name || '(' || cd.course_code || ')' short_name,
            cd.course_pl,
            cd.course_mod,
            cd.course_type,
            sp.event_id,
            sp.ops_country,
            'VCL' metro,
            0 metro_tier,
            'EST' tzabbreviation,
            'N' connected_c,
            sp.connected_v,
            sp.sales_request,
            sp.ev_sched,
            sp.ev_run,
            sp.ev_canc,
            sp.ev_stud,
            cf.freq_weeks
     FROM            gk_vcl_sched_plan_v sp
                  INNER JOIN
                     course_dim cd
                  ON sp.course_id = cd.course_id
                     AND cd.country = sp.ops_country
               INNER JOIN
                  time_dim td
               ON sp.start_date = td.dim_date
            INNER JOIN
               gk_sched_course_freq_v cf
            ON     sp.course_id = cf.course_id
               AND sp.ops_country = cf.ops_country
               AND cf.year_offset = 0
    WHERE   sp.start_date > TRUNC (SYSDATE) - 1095
            AND sp.start_date <= TRUNC (SYSDATE) - 730
            AND SUBSTR (cd.course_code, 1, 4) NOT IN
                     ('9983', '9984', '9989', '9992', '9995')
            AND cd.ch_num = '10'
            AND cd.md_num = '20'
   ORDER BY   dim_month, course_code, event_id;


