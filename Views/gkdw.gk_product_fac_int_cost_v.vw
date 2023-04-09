DROP VIEW GKDW.GK_PRODUCT_FAC_INT_COST_V;

/* Formatted on 29/01/2021 11:29:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_FAC_INT_COST_V
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
   INT_FAC_AMT
)
AS
     SELECT   'Internal Facility Cost' cost_type,
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
              SUM (tc_amt_per_event_day * (ed.end_date - ed.start_date + 1))
                 int_fac_amt
       FROM                  event_dim ed
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          course_dim cd
                       ON ed.course_id = cd.course_id
                          AND ed.ops_country = cd.country
                    INNER JOIN
                       gk_facility_cc_dim fc
                    ON ed.facility_code = fc.facility_code
                 INNER JOIN
                    gk_product_int_fac_cost_v ic
                 ON fc.cc_num = ic.cc_num
                    AND TO_CHAR (ed.start_date, 'yyyy') = ic.period_year
              LEFT OUTER JOIN
                 gk_facility_region_mv fr
              ON ed.location_id = fr.evxfacilityid
                 AND ed.facility_region_metro = fr.facilityregionmetro
      WHERE       ed.start_date >= TO_DATE ('1/1/2004', 'mm/dd/yyyy')
              AND ed.status != 'Cancelled'
              AND ed.internalfacility = 'T'
              AND NOT EXISTS (SELECT   1
                                FROM   gk_nested_courses nc
                               WHERE   cd.course_id = nc.nested_course_id)
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


