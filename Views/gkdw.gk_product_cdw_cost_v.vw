DROP VIEW GKDW.GK_PRODUCT_CDW_COST_V;

/* Formatted on 29/01/2021 11:29:54 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_CDW_COST_V
(
   COST_TYPE,
   EVENT_ID,
   EVENT_DESC,
   REV_DATE,
   OPS_COUNTRY,
   FACILITY_REGION_METRO,
   CH_NUM,
   COURSE_CH,
   MD_NUM,
   COURSE_MOD,
   PL_NUM,
   COURSE_PL,
   COURSE_NAME,
   COURSE_CODE,
   REV_YEAR,
   REV_QUARTER,
   REV_MONTH,
   REV_MON_NUM,
   REV_WEEK_NUM,
   COURSE_TYPE,
   FACILITY_REGION,
   VENDOR_CODE,
   CDW_AMT
)
AS
     SELECT   'Cisco DW' cost_type,
              ed.event_id,
                 cd.course_code
              || '-'
              || facility_region_metro
              || '-'
              || TO_CHAR (ed.start_date, 'yymmdd')
              || '('
              || ed.event_id
              || ')'
                 event_desc,
              ed.start_date rev_date,
              ed.ops_country,
              ed.facility_region_metro,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              cd.course_mod,
              cd.pl_num,
              cd.course_pl,
              cd.course_name,
              CASE
                 WHEN nc.nested_course_id IS NOT NULL
                 THEN
                       cd1.course_code
                    || '('
                    || NVL (TRIM (cd1.short_name), ' ')
                    || ')'
                 ELSE
                       cd.course_code
                    || '('
                    || NVL (TRIM (cd.short_name), ' ')
                    || ')'
              END
                 course_code,
              td.dim_year rev_year,
              td.dim_year || '-Qtr ' || td.dim_quarter rev_quarter,
              td.dim_year || '-' || td.dim_month rev_month,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') rev_mon_num,
              td.dim_year || '-' || LPAD (td.dim_week, 2, '0') rev_week_num,
              cd.course_type,
              fr.region facility_region,
              cd.vendor_code,
              SUM (cm.roy_amt) cdw_amt
       FROM                     gk_cdw_monthly_v cm
                             INNER JOIN
                                event_dim ed
                             ON cm.event_id = ed.event_id
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          course_dim cd
                       ON ed.course_id = cd.course_id
                          AND ed.ops_country = cd.country
                    LEFT OUTER JOIN
                       gk_facility_region_mv fr
                    ON ed.location_id = fr.evxfacilityid
                       AND ed.facility_region_metro = fr.facilityregionmetro
                 LEFT OUTER JOIN
                    gk_nested_courses nc
                 ON cd.course_id = nc.nested_course_id
              LEFT OUTER JOIN
                 course_dim cd1
              ON nc.master_course_id = cd1.course_id
                 AND ed.ops_country = cd1.country
      WHERE   ed.start_date >= TO_DATE ('8/23/2008', 'mm/dd/yyyy')
   -- where ed.start_date between to_date('8/23/2008', 'mm/dd/yyyy') and trunc(sysdate)
   GROUP BY   ed.event_id,
                 cd.course_code
              || '-'
              || facility_region_metro
              || '-'
              || TO_CHAR (ed.start_date, 'yymmdd')
              || '('
              || ed.event_id
              || ')',
              ed.start_date,
              ed.ops_country,
              facility_region_metro,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              cd.course_mod,
              cd.pl_num,
              cd.course_pl,
              cd.course_name,
              cd.course_code || '(' || NVL (TRIM (cd.short_name), ' ') || ')',
              nc.nested_course_id,
                 cd1.course_code
              || '('
              || NVL (TRIM (cd1.short_name), ' ')
              || ')',
              td.dim_year,
              td.dim_year || '-Qtr ' || td.dim_quarter,
              td.dim_year || '-' || td.dim_month,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
              cd.course_type,
              fr.region,
              cd.vendor_code
   UNION ALL
     SELECT   'Cisco DW' cost_type,
              ed.event_id,
                 cd.course_code
              || '-'
              || facility_region_metro
              || '-'
              || TO_CHAR (ed.start_date, 'yymmdd')
              || '('
              || ed.event_id
              || ')'
                 event_desc,
              ed.start_date rev_date,
              ed.ops_country,
              ed.facility_region_metro,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              cd.course_mod,
              cd.pl_num,
              cd.course_pl,
              cd.course_name,
              CASE
                 WHEN nc.nested_course_id IS NOT NULL
                 THEN
                       cd1.course_code
                    || '('
                    || NVL (TRIM (cd1.short_name), ' ')
                    || ')'
                 ELSE
                       cd.course_code
                    || '('
                    || NVL (TRIM (cd.short_name), ' ')
                    || ')'
              END
                 course_code,
              td.dim_year rev_year,
              td.dim_year || '-Qtr ' || td.dim_quarter rev_quarter,
              td.dim_year || '-' || td.dim_month rev_month,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') rev_mon_num,
              td.dim_year || '-' || LPAD (td.dim_week, 2, '0') rev_week_num,
              cd.course_type,
              fr.region facility_region,
              cd.vendor_code,
              SUM(CASE
                     WHEN (ed.end_date - ed.start_date + 1) * royalty_day >
                             max_royalty
                     THEN
                        max_royalty
                     ELSE
                        ( (ed.end_date - ed.start_date + 1) * royalty_day)
                        - (DECODE (cc.self_print_disc, 'Y', 15, 0))
                  END)
                 cdw_amt
       FROM                           course_dim cd
                                   INNER JOIN
                                      event_dim ed
                                   ON cd.course_id = ed.course_id
                                      AND cd.country = ed.ops_country
                                INNER JOIN
                                   order_fact f
                                ON ed.event_id = f.event_id
                             INNER JOIN
                                cust_dim c
                             ON f.cust_id = c.cust_id
                          INNER JOIN
                             time_dim td
                          ON td.dim_date = f.rev_date
                       INNER JOIN
                          gk_cdw_courses cc
                       ON SUBSTR (cd.course_code, 1, 4) = cc.gk_course_code
                          AND cdw_level != 'SPEL'
                    LEFT OUTER JOIN
                       gk_facility_region_mv fr
                    ON ed.location_id = fr.evxfacilityid
                       AND ed.facility_region_metro = fr.facilityregionmetro
                 LEFT OUTER JOIN
                    gk_nested_courses nc
                 ON cd.course_id = nc.nested_course_id
              LEFT OUTER JOIN
                 course_dim cd1
              ON nc.master_course_id = cd1.course_id
                 AND ed.ops_country = cd1.country
      WHERE       enroll_status IN ('Confirmed', 'Attended')
              AND cd.pl_num = '04'
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND f.book_amt > 0
              AND ed.start_date BETWEEN TO_DATE ('1/1/2004', 'mm/dd/yyyy')
                                    AND  TO_DATE ('8/23/2008', 'mm/dd/yyyy')
   GROUP BY   ed.event_id,
                 cd.course_code
              || '-'
              || facility_region_metro
              || '-'
              || TO_CHAR (ed.start_date, 'yymmdd')
              || '('
              || ed.event_id
              || ')',
              ed.start_date,
              ed.ops_country,
              facility_region_metro,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              cd.course_mod,
              cd.pl_num,
              cd.course_pl,
              cd.course_name,
              cd.course_code || '(' || NVL (TRIM (cd.short_name), ' ') || ')',
              nc.nested_course_id,
                 cd1.course_code
              || '('
              || NVL (TRIM (cd1.short_name), ' ')
              || ')',
              td.dim_year,
              td.dim_year || '-Qtr ' || td.dim_quarter,
              td.dim_year || '-' || td.dim_month,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
              cd.course_type,
              fr.region,
              cd.vendor_code;


