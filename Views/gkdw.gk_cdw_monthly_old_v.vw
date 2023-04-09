DROP VIEW GKDW.GK_CDW_MONTHLY_OLD_V;

/* Formatted on 29/01/2021 11:41:22 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CDW_MONTHLY_OLD_V
(
   CDW_GROUP,
   PERIOD_NAME,
   EVENT_ID,
   COURSE_CODE,
   CH_NUM,
   MD_NUM,
   SHORT_NAME,
   START_DATE,
   FACILITY_CODE,
   OPPORTUNITY_ID,
   ATTENDED_CNT,
   CLSP_SITE_ID,
   REPORTING_PERIOD_MONTHYEAR,
   TWO_TIER_SALES,
   CLP_ID_SO_NUMBER,
   CISCO_DW_ID,
   COUNTRY_ISO_ABBR,
   NUMBER_OF_STUDENTS,
   GROSS_REVENUE,
   GK_COURSE_CODE,
   EVENT_DUR,
   CDW_DUR,
   CDW_EFF_DUR,
   RATE_TYPE,
   CISCO_OVERALL_SOURCE,
   CDW_RATE,
   ROY_AMT
)
AS
     SELECT   'STANDARD-PUBLIC' cdw_group,
              td.dim_period_name period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (book_amt) gross_revenue,
              ed.course_code gk_course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.rate_type,
              cc.cisco_overall_source,
              cc.ilt_rate cdw_rate,
              CASE
                 WHEN cc.rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.ilt_rate * cc.eff_dur * COUNT (f.enroll_id)
                 WHEN cc.rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.ilt_rate * COUNT (f.enroll_id)
              END
                 roy_amt
       FROM                  event_dim ed
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          time_dim td
                       ON ed.start_date = td.dim_date
                    INNER JOIN
                       order_fact f
                    ON ed.event_id = f.event_id
                 INNER JOIN
                    cust_dim c
                 ON f.cust_id = c.cust_id
              INNER JOIN
                 gk_cdw_interface cc
              ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
      WHERE   f.enroll_status IN ('Confirmed', 'Attended')
              AND ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND cc.gk_exception IS NULL
              AND (f.book_amt > 0 OR f.attendee_type = 'Unlimited')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.lp_dur,
              cc.eff_dur,
              cc.rate_type,
              cc.ilt_rate,
              cc.cisco_overall_source
   UNION
     SELECT   'STANDARD-ONSITE',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.rate_type,
              cc.cisco_overall_source,
              cc.ilt_rate,
              CASE
                 WHEN cc.rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.ilt_rate * cc.eff_dur * COUNT (f.enroll_id)
                 WHEN cc.rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.ilt_rate * COUNT (f.enroll_id)
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 INNER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id
              INNER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND f.enroll_status = 'Attended'
              AND cc.gk_exception IS NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   and ed.end_date-ed.start_date+1 = cc.lp_dur
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.ilt_rate,
              cc.rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
   UNION
     SELECT   'STANDARD-ONSITE',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              ed.onsite_attended number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.rate_type,
              cc.cisco_overall_source,
              cc.ilt_rate,
              CASE
                 WHEN cc.rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.ilt_rate * cc.eff_dur * ed.onsite_attended
                 WHEN cc.rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.ilt_rate * ed.onsite_attended
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 LEFT OUTER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id AND f.enroll_status = 'Attended'
              LEFT OUTER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND cc.gk_exception IS NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
              --   and ed.end_date-ed.start_date+1 = cc.lp_dur
              AND ed.onsite_attended > 0
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.onsite_attended,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.ilt_rate,
              cc.rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
     HAVING   COUNT (f.enroll_id) = 0
   UNION
     SELECT   'SPEL-CD',
              j.period_name,
              pd.product_id,
              pd.prod_num,
              gcc.segment4,
              gcc.segment5,
              pd.prod_name,
              NULL,
              'SPEL',
              NULL,
              NULL,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END
                 country_iso_abbr,
              NULL number_of_students,
              SUM (NVL (accounted_cr, 0) - NVL (accounted_dr, 0)) gross_revenue,
              pd.prod_num,
              NULL event_dur,
              c.lp_dur cdw_dur,
              c.eff_dur cdw_eff_dur,
              c.rate_type,
              c.cisco_overall_source,
              c.spel_rate,
                SUM (NVL (accounted_cr, 0) - NVL (accounted_dr, 0))
              * c.cisco_overall_source
              * spel_rate
                 roy_rate
       FROM               gl_je_lines@r12prd j
                       INNER JOIN
                          gl_code_combinations@r12prd gcc
                       ON j.code_combination_id = gcc.code_combination_id
                    INNER JOIN
                       gk_cdw_interface c
                    ON gcc.segment7 =
                          CASE
                             WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
                             THEN
                                LPAD (SUBSTR (c.gk_course_num, 1, 4), 6, '00')
                             ELSE
                                c.gk_course_num
                          END
                       AND c.spel_rate IS NOT NULL
                 INNER JOIN
                    product_dim pd
                 ON gk_course_num || 'S' = pd.prod_num
                    AND pd.status = 'Available'
              INNER JOIN
                 gk_month_name_v td
              ON j.period_name = td.dim_period_name
      WHERE       gcc.segment3 = '41105'
              AND gcc.segment5 = '31'
              AND gcc.segment6 = '04'
              AND c.modality = 'E-Learning'
              AND c.dw_status != 'Inactive'
              AND SUBSTR (pd.prod_num, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   GROUP BY   j.period_name,
              pd.product_id,
              pd.prod_num,
              gcc.segment4,
              gcc.segment5,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END,
              pd.prod_num,
              pd.prod_name,
              c.eff_dur,
              c.lp_dur,
              c.rate_type,
              c.spel_rate,
              c.cisco_overall_source
   UNION
     SELECT   'SPEL-WEB',
              j.period_name,
              cd.course_id,
              cd.course_code,
              gcc.segment4,
              gcc.segment5,
              cd.short_name,
              NULL,
              'SPEL',
              NULL,
              NULL,
              '579' clsp_site_id,
              TRIM (td.dim_month) || ' ' || td.dim_year
                 reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END
                 country_iso_abbr,
              NULL number_of_students,
              SUM (NVL (accounted_cr, 0) - NVL (accounted_dr, 0)) gross_revenue,
              cd.course_code,
              NULL event_dur,
              c.lp_dur cdw_dur,
              c.eff_dur cdw_eff_dur,
              c.rate_type,
              c.cisco_overall_source,
              c.spel_rate,
                SUM (NVL (accounted_cr, 0) - NVL (accounted_dr, 0))
              * c.cisco_overall_source
              * spel_rate
                 roy_rate
       FROM               gl_je_lines@r12prd j
                       INNER JOIN
                          gl_code_combinations@r12prd gcc
                       ON j.code_combination_id = gcc.code_combination_id
                    INNER JOIN
                       gk_cdw_interface c
                    ON gcc.segment7 =
                          CASE
                             WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
                             THEN
                                LPAD (SUBSTR (c.gk_course_num, 1, 4), 6, '00')
                             ELSE
                                c.gk_course_num
                          END
                       AND c.spel_rate IS NOT NULL
                 INNER JOIN
                    course_dim cd
                 ON c.gk_course_num || 'W' = cd.course_code
                    AND CASE
                          WHEN gcc.segment1 = '220' THEN 'CANADA'
                          ELSE 'USA'
                       END = cd.country           --and cd.inactive_flag = 'F'
              INNER JOIN
                 gk_month_name_v td
              ON j.period_name = td.dim_period_name
      WHERE       gcc.segment3 = '41105'
              AND gcc.segment5 = '32'
              AND gcc.segment6 = '04'
              AND c.modality = 'E-Learning'
              AND c.dw_status != 'Inactive'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   GROUP BY   j.period_name,
              cd.course_id,
              cd.course_code,
              gcc.segment4,
              gcc.segment5,
              TRIM (td.dim_month) || ' ' || td.dim_year,
              auth_code,
              CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END,
              cd.course_code,
              cd.short_name,
              c.eff_dur,
              c.lp_dur,
              c.rate_type,
              c.spel_rate,
              c.cisco_overall_source
   UNION
     SELECT   'EX-ONSITE-NO_STUDENTS',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              NVL (ed.onsite_attended, 0) number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.rate_type,
              cc.cisco_overall_source,
              cc.ilt_rate,
              CASE
                 WHEN cc.rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.ilt_rate * cc.eff_dur * NVL (ed.onsite_attended, 0)
                 WHEN cc.rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.ilt_rate * NVL (ed.onsite_attended, 0)
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 LEFT OUTER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id AND f.enroll_status = 'Attended'
              LEFT OUTER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND cc.gk_exception IS NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
              --   and ed.end_date-ed.start_date+1 = cc.lp_dur
              AND NVL (ed.onsite_attended, 0) = 0
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.onsite_attended,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.ilt_rate,
              cc.rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
     HAVING   COUNT (f.enroll_id) = 0
   UNION
     SELECT   'EX-PUBLIC-OPTICAL' cdw_group,
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (book_amt) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.except_rate_type,
              cc.cisco_overall_source,
              cc.except_accrual_rate cdw_rate,
              CASE
                 WHEN cc.except_rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.except_accrual_rate * cc.eff_dur * COUNT (f.enroll_id)
                 WHEN cc.except_rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.except_accrual_rate * COUNT (f.enroll_id)
              END
                 roy_amt
       FROM                  event_dim ed
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          time_dim td
                       ON ed.start_date = td.dim_date
                    INNER JOIN
                       order_fact f
                    ON ed.event_id = f.event_id
                 INNER JOIN
                    cust_dim c
                 ON f.cust_id = c.cust_id
              INNER JOIN
                 gk_cdw_interface cc
              ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
      WHERE   f.enroll_status IN ('Confirmed', 'Attended')
              AND ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND cc.gk_exception IS NOT NULL
              AND (f.book_amt > 0 OR f.attendee_type = 'Unlimited')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND cd.course_type = 'Optical Networking'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.lp_dur,
              cc.eff_dur,
              cc.except_rate_type,
              cc.except_accrual_rate,
              cc.cisco_overall_source
   UNION
     SELECT   'EX-ONSITE-OPTICAL',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.except_rate_type,
              cc.cisco_overall_source,
              cc.except_accrual_rate,
              CASE
                 WHEN cc.except_rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.except_accrual_rate * cc.eff_dur * COUNT (f.enroll_id)
                 WHEN cc.except_rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.except_accrual_rate * COUNT (f.enroll_id)
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 INNER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id
              INNER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND f.enroll_status = 'Attended'
              AND cc.gk_exception IS NOT NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND cd.course_type = 'Optical Networking'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   and ed.end_date-ed.start_date+1 = cc.lp_dur
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.except_accrual_rate,
              cc.except_rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
   UNION
     SELECT   'EX-ONSITE-OPTICAL',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              ed.onsite_attended number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.except_rate_type,
              cc.cisco_overall_source,
              cc.except_accrual_rate,
              CASE
                 WHEN cc.except_rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.except_accrual_rate * cc.eff_dur * ed.onsite_attended
                 WHEN cc.except_rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.except_accrual_rate * ed.onsite_attended
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 LEFT OUTER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id AND f.enroll_status = 'Attended'
              LEFT OUTER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND cc.gk_exception IS NOT NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              --   and ed.end_date-ed.start_date+1 = cc.lp_dur
              AND cd.course_type = 'Optical Networking'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   and ed.onsite_attended > 0
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.onsite_attended,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.except_accrual_rate,
              cc.except_rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
     HAVING   COUNT (f.enroll_id) = 0
   UNION
     SELECT   'EX-PUBLIC-SALES_CHANNEL' cdw_group,
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (book_amt) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.except_rate_type,
              cc.cisco_overall_source,
              cc.except_accrual_rate cdw_rate,
              CASE
                 WHEN cc.except_rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.except_accrual_rate * cc.eff_dur * COUNT (f.enroll_id)
                 WHEN cc.except_rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.except_accrual_rate * COUNT (f.enroll_id)
              END
                 roy_amt
       FROM                  event_dim ed
                          INNER JOIN
                             course_dim cd
                          ON ed.course_id = cd.course_id
                             AND ed.ops_country = cd.country
                       INNER JOIN
                          time_dim td
                       ON ed.start_date = td.dim_date
                    INNER JOIN
                       order_fact f
                    ON ed.event_id = f.event_id
                 INNER JOIN
                    cust_dim c
                 ON f.cust_id = c.cust_id
              INNER JOIN
                 gk_cdw_interface cc
              ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
      WHERE   f.enroll_status IN ('Confirmed', 'Attended')
              AND ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND cc.gk_exception IS NOT NULL
              AND (f.book_amt > 0 OR f.attendee_type = 'Unlimited')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND cd.course_type != 'Optical Networking'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.lp_dur,
              cc.eff_dur,
              cc.except_rate_type,
              cc.except_accrual_rate,
              cc.cisco_overall_source
   UNION
     SELECT   'EX-ONSITE-SALES_CHANNEL',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.except_rate_type,
              cc.cisco_overall_source,
              cc.except_accrual_rate,
              CASE
                 WHEN cc.except_rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.except_accrual_rate * cc.eff_dur * COUNT (f.enroll_id)
                 WHEN cc.except_rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.except_accrual_rate * COUNT (f.enroll_id)
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 INNER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id
              INNER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND f.enroll_status = 'Attended'
              AND cc.gk_exception IS NOT NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              AND cd.course_type != 'Optical Networking'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   and ed.end_date-ed.start_date+1 = cc.lp_dur
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.except_accrual_rate,
              cc.except_rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
   UNION
     SELECT   'EX-ONSITE-SALES_CHANNEL',
              td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              cd.short_name,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              COUNT (f.enroll_id) attended_cnt,
              '579' clsp_site_id,
              td.dim_month || ' ' || td.dim_year reporting_period_monthyear,
              'No' two_tier_sales,
              NULL clp_id_so_number,
              auth_code cisco_dw_id,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END
                 country_iso_abbr,
              ed.onsite_attended number_of_students,
              SUM (NVL (ob.book_amt, 0)) gross_revenue,
              ed.course_code course_code,
              ed.end_date - ed.start_date + 1 event_dur,
              cc.lp_dur cdw_dur,
              cc.eff_dur cdw_eff_dur,
              cc.except_rate_type,
              cc.cisco_overall_source,
              cc.except_accrual_rate,
              CASE
                 WHEN cc.except_rate_type = 'Fixed Daily Rate'
                 THEN
                    cc.except_accrual_rate * cc.eff_dur * ed.onsite_attended
                 WHEN cc.except_rate_type = 'Fixed Unit Rate'
                 THEN
                    cc.except_accrual_rate * ed.onsite_attended
              END
                 roy_amt
       FROM                     event_dim ed
                             INNER JOIN
                                course_dim cd
                             ON ed.course_id = cd.course_id
                                AND ed.ops_country = cd.country
                          INNER JOIN
                             time_dim td
                          ON ed.start_date = td.dim_date
                       INNER JOIN
                          gk_cdw_onsite_v ob
                       ON ed.event_id = ob.event_id
                    INNER JOIN
                       gk_cdw_interface cc
                    ON SUBSTR (ed.course_code, 1, 4) = cc.gk_course_num
                 LEFT OUTER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id AND f.enroll_status = 'Attended'
              LEFT OUTER JOIN
                 cust_dim c
              ON f.cust_id = c.cust_id
      WHERE   ed.event_id NOT IN (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND ed.status IN ('Open', 'Verified')
              AND cc.gk_exception IS NOT NULL
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cc.modality = 'ILT'
              AND cc.dw_status != 'Inactive'
              --   and ed.end_date-ed.start_date+1 = cc.lp_dur
              AND cd.course_type != 'Optical Networking'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   and ed.onsite_attended > 0
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.onsite_attended,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              auth_code,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    SUBSTR (UPPER (c.country), 1, 3)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    SUBSTR (ed.ops_country, 1, 3)
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.end_date - ed.start_date + 1,
              cc.except_accrual_rate,
              cc.except_rate_type,
              cc.lp_dur,
              cc.eff_dur,
              cc.cisco_overall_source
     HAVING   COUNT (f.enroll_id) = 0
   ORDER BY   1,
              4,
              5,
              6;


