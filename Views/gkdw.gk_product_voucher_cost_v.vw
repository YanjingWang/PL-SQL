DROP VIEW GKDW.GK_PRODUCT_VOUCHER_COST_V;

/* Formatted on 29/01/2021 11:28:53 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_VOUCHER_COST_V
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
   VOUCHER_AMT
)
AS
     SELECT   'Test Voucher' cost_type,
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
              SUM (NVL (pv.unit_price, 0)) voucher_amt
       FROM                        gk_voucher@gkprod v
                                INNER JOIN
                                   gk_po_voucher_v@gkprod pv
                                ON v.po_num = pv.po_num
                                   AND UPPER (v.voucher_type) =
                                         UPPER (pv.voucher_type)
                             INNER JOIN
                                event_dim ed
                             ON v.evxeventid = ed.event_id
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
                                   TRUNC (v.issued_date)
                                ELSE
                                   ed.start_date
                             END
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
      WHERE   ed.start_date >= TO_DATE ('1/1/2004', 'mm/dd/yyyy')
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


