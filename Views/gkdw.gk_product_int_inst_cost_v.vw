DROP VIEW GKDW.GK_PRODUCT_INT_INST_COST_V;

/* Formatted on 29/01/2021 11:29:10 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_INT_INST_COST_V
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
   INT_INST_AMT
)
AS
     SELECT   'Internal Instructor Cost' cost_type,
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
              cd.course_code || '(' || NVL (TRIM (cd.short_name), ' ') || ')'
                 course_code,
              td.dim_year rev_year,
              td.dim_year || '-Qtr ' || td.dim_quarter rev_quarter,
              td.dim_year || '-' || td.dim_month rev_month,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0') rev_mon_num,
              td.dim_year || '-' || LPAD (td.dim_week, 2, '0') rev_week_num,
              cd.course_type,
              fr.region facility_region,
              cd.vendor_code,
              SUM (ir.int_inst_rate * (ed.end_date - ed.start_date + 1))
                 int_inst_amt
       FROM                  event_dim ed
                          INNER JOIN
                             instructor_event_v ie
                          ON ed.event_id = ie.evxeventid
                             AND (UPPER (ACCOUNT) LIKE 'GLOBAL KNOW%'
                                  OR UPPER (ACCOUNT) LIKE 'NEXIENT%')
                       INNER JOIN
                          time_dim td
                       ON ed.start_date = td.dim_date
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    gk_int_inst_rate_pl ir
                 ON cd.pl_num = ir.pl_num
              LEFT OUTER JOIN
                 gk_facility_region_mv fr
              ON ed.location_id = fr.evxfacilityid
                 AND ed.facility_region_metro = fr.facilityregionmetro
      WHERE       ed.start_date >= TO_DATE ('1/1/2004', 'mm/dd/yyyy')
              AND ed.status != 'Cancelled'
              AND ie.feecode IN ('SI', 'INS')
              AND NOT EXISTS (SELECT   1
                                FROM   gk_nested_courses c
                               WHERE   c.nested_course_id = cd.course_id)
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
              td.dim_year,
              td.dim_year || '-Qtr ' || td.dim_quarter,
              td.dim_year || '-' || td.dim_month,
              td.dim_year || '-' || LPAD (td.dim_month_num, 2, '0'),
              td.dim_year || '-' || LPAD (td.dim_week, 2, '0'),
              cd.course_type,
              fr.region,
              cd.vendor_code;


