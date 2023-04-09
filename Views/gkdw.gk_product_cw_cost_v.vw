DROP VIEW GKDW.GK_PRODUCT_CW_COST_V;

/* Formatted on 29/01/2021 11:29:50 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_CW_COST_V
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
   CW_AMT
)
AS
     SELECT   cost_type,
              event_id,
              event_desc,
              rev_date,
              ops_country,
              facility_region_metro,
              ch_num,
              course_ch,
              md_num,
              course_mod,
              pl_num,
              course_pl,
              course_name,
              course_code,
              rev_year,
              rev_quarter,
              rev_month,
              rev_mon_num,
              rev_week_num,
              course_type,
              facility_region,
              vendor_code,
              SUM (cw_cost) + SUM (misc_cw_cost) cw_amt
       FROM   (  SELECT   'Course Materials' cost_type,
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
                          td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
                             rev_mon_num,
                          td.dim_year || '-' || LPAD (td.dim_week, 2, '0')
                             rev_week_num,
                          cd.course_type,
                          fr.region facility_region,
                          cd.vendor_code,
                          SUM (NVL (qty_ordered, 0) * NVL (b.kit_price, 0))
                             cw_cost,
                          0 misc_cw_cost
                   FROM                        cw_fulfillment@gkprod cf
                                            INNER JOIN
                                               cw_bom@gkprod b
                                            ON cf.part_number = b.kit_num
                                         INNER JOIN
                                            event_dim ed
                                         ON cf.event_id = ed.event_id
                                      INNER JOIN
                                         course_dim cd
                                      ON ed.course_id = cd.course_id
                                         AND ed.ops_country = cd.country
                                   INNER JOIN
                                      time_dim td
                                   ON td.dim_date =
                                         CASE
                                            WHEN cd.md_num IN ('32', '44')
                                            THEN
                                               TRUNC (cf.request_date)
                                            ELSE
                                               ed.start_date
                                         END
                                LEFT OUTER JOIN
                                   gk_facility_region_mv fr
                                ON ed.location_id = fr.evxfacilityid
                                   AND ed.facility_region_metro =
                                         fr.facilityregionmetro
                             LEFT OUTER JOIN
                                gk_nested_courses nc
                             ON cd.course_id = nc.nested_course_id
                          LEFT OUTER JOIN
                             course_dim cd1
                          ON nc.master_course_id = cd1.course_id
                             AND ed.ops_country = cd1.country
                  WHERE   ed.start_date >= TO_DATE ('1/1/2004', 'mm/dd/yyyy')
               -- where ed.start_date between to_date('1/1/2004', 'mm/dd/yyyy') and trunc(sysdate)
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
                             cd.course_code
                          || '('
                          || NVL (TRIM (cd.short_name), ' ')
                          || ')',
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
               UNION
                 SELECT   'Course Materials' cost_type,
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
                          td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0')
                             rev_mon_num,
                          td.dim_year || '-' || LPAD (td.dim_week, 2, '0')
                             rev_week_num,
                          cd.course_type,
                          fr.region facility_region,
                          cd.vendor_code,
                          0,
                          CASE
                             WHEN mc.TYPE = 'Per Student'
                             THEN
                                NVL (ce.enroll_cnt, 0) * NVL (mc.cw_cost, 0)
                             WHEN mc.TYPE = 'Per Event'
                             THEN
                                NVL (mc.cw_cost, 0)
                             ELSE
                                0
                          END
                   FROM                        event_dim ed
                                            INNER JOIN
                                               time_dim td
                                            ON ed.start_date = td.dim_date
                                         INNER JOIN
                                            course_dim cd
                                         ON ed.course_id = cd.course_id
                                            AND ed.ops_country = cd.country
                                      INNER JOIN
                                         cw_event_enroll_v@gkprod ce
                                      ON ed.event_id = ce.evxeventid
                                   INNER JOIN
                                      gk_misc_cw_temp mc
                                   ON SUBSTR (cd.course_code, 1, 4) =
                                         mc.course_code
                                LEFT OUTER JOIN
                                   gk_facility_region_mv fr
                                ON ed.location_id = fr.evxfacilityid
                                   AND ed.facility_region_metro =
                                         fr.facilityregionmetro
                             LEFT OUTER JOIN
                                gk_nested_courses nc
                             ON cd.course_id = nc.nested_course_id
                          LEFT OUTER JOIN
                             course_dim cd1
                          ON nc.master_course_id = cd1.course_id
                             AND ed.ops_country = cd1.country
                  WHERE   ed.start_date >= TO_DATE ('1/1/2004', 'mm/dd/yyyy')
                          AND ed.status != 'Cancelled'
               -- where ed.start_date between to_date('1/1/2004', 'mm/dd/yyyy') and trunc(sysdate)
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
                             cd.course_code
                          || '('
                          || NVL (TRIM (cd.short_name), ' ')
                          || ')',
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
                          ce.enroll_cnt,
                          mc.TYPE,
                          mc.cw_cost,
                          cd.vendor_code)
   GROUP BY   cost_type,
              event_id,
              event_desc,
              rev_date,
              ops_country,
              facility_region_metro,
              ch_num,
              course_ch,
              md_num,
              course_mod,
              pl_num,
              course_pl,
              course_name,
              course_code,
              rev_year,
              rev_quarter,
              rev_month,
              rev_mon_num,
              rev_week_num,
              course_type,
              facility_region,
              vendor_code;


