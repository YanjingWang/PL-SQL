DROP VIEW GKDW.GK_CDW_MONTHLY_V;

/* Formatted on 29/01/2021 11:41:16 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CDW_MONTHLY_V
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
              dw_auth_code cisco_dw_id,
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
              ed.meeting_days event_dur,
              cc.cisco_dur_days cdw_dur,
              cc.cisco_dur_days cdw_eff_dur,
              cc.payment_unit rate_type,
              1 cisco_overall_source,
              CASE
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT' THEN 0
                 ELSE cc.fee_rate
              END
                 cdw_rate,
              CASE
                 WHEN UPPER (cc.payment_unit) IN
                            ('PER STUDENT PER DAY', 'FIXED')
                 THEN
                    cc.fee_rate * cc.cisco_dur_days * COUNT (f.enroll_id)
                 WHEN UPPER (cc.payment_unit) = 'PER STUDENT'
                 THEN
                    cc.fee_rate * COUNT (f.enroll_id)
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT'
                 THEN
                    0
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
                          order_fact f
                       ON ed.event_id = f.event_id
                    INNER JOIN
                       cust_dim c
                    ON f.cust_id = c.cust_id
                 INNER JOIN
                    gk_cisco_dw_mv cc
                 ON     cd.course_id = cc.course_id
                    AND UPPER (cc.fee_status) = 'ACTIVE'
                    AND td.dim_date BETWEEN cc.from_date AND cc.TO_DATE
              INNER JOIN
                 gk_cdw_curr_auth_mv cc2
              ON cc.course_id = cc2.course_id AND cc.TO_DATE = cc2.TO_DATE
      WHERE   f.enroll_status IN ('Confirmed', 'Attended')
              AND ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND (f.book_amt > 0 OR f.attendee_type = 'Unlimited')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cd.course_code NOT LIKE '%L'
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
              dw_auth_code,
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
              ed.meeting_days,
              cc.cisco_dur_days,
              cc.payment_unit,
              cc.fee_rate
   UNION --- This block handles course codes that end in L, which are virtual courses that take place in both the US and Canada and must be summed so country code is made the same.
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
              dw_auth_code cisco_dw_id,
              CASE
                 WHEN SUBSTR (c.country, 1, 3) = 'CAN' THEN 'CAN'
                 ELSE 'USA'
              END
                 country_iso_abbr,
              COUNT (f.enroll_id) number_of_students,
              SUM (book_amt) gross_revenue,
              ed.course_code gk_course_code,
              ed.meeting_days event_dur,
              cc.cisco_dur_days cdw_dur,
              cc.cisco_dur_days cdw_eff_dur,
              cc.payment_unit rate_type,
              1 cisco_overall_source,
              CASE
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT' THEN 0
                 ELSE cc.fee_rate
              END
                 cdw_rate,
              CASE
                 WHEN UPPER (cc.payment_unit) IN
                            ('PER STUDENT PER DAY', 'FIXED')
                 THEN
                    cc.fee_rate * cc.cisco_dur_days * COUNT (f.enroll_id)
                 WHEN UPPER (cc.payment_unit) = 'PER STUDENT'
                 THEN
                    cc.fee_rate * COUNT (f.enroll_id)
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT'
                 THEN
                    0
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
                          order_fact f
                       ON ed.event_id = f.event_id
                    INNER JOIN
                       cust_dim c
                    ON f.cust_id = c.cust_id
                 INNER JOIN
                    gk_cisco_dw_mv cc
                 ON     cd.course_id = cc.course_id
                    AND UPPER (cc.fee_status) = 'ACTIVE'
                    AND td.dim_date BETWEEN cc.from_date AND cc.TO_DATE
              INNER JOIN
                 gk_cdw_curr_auth_mv cc2
              ON cc.course_id = cc2.course_id AND cc.TO_DATE = cc2.TO_DATE
      WHERE   f.enroll_status IN ('Confirmed', 'Attended')
              AND ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND (f.book_amt > 0 OR f.attendee_type = 'Unlimited')
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
              AND cd.course_code LIKE '%L'
   GROUP BY   td.dim_period_name,
              ed.event_id,
              ed.course_code,
              cd.ch_num,
              cd.md_num,
              ed.start_date,
              ed.facility_code,
              ed.opportunity_id,
              td.dim_month || ' ' || td.dim_year,
              dw_auth_code,
              CASE
                 WHEN SUBSTR (c.country, 1, 3) = 'CAN' THEN 'CAN'
                 ELSE 'USA'
              END,
              ed.course_code,
              cd.short_name,
              ed.course_code,
              ed.meeting_days,
              cc.cisco_dur_days,
              cc.payment_unit,
              cc.fee_rate
   UNION
     SELECT   'STANDARD-ONSITE' cdw_group,
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
              dw_auth_code cisco_dw_id,
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
              NVL (
                 CASE
                    WHEN COUNT (f.enroll_id) = 0 THEN ed.onsite_attended
                    ELSE COUNT (f.enroll_id)
                 END,
                 0
              )
                 number_of_students,
              SUM (ob.book_amt) gross_revenue,
              ed.course_code gk_course_code,
              ed.meeting_days event_dur,
              cc.cisco_dur_days cdw_dur,
              cc.cisco_dur_days cdw_eff_dur,
              cc.payment_unit rate_type,
              1 cisco_overall_source,
              CASE
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT' THEN 0
                 ELSE cc.fee_rate
              END
                 cdw_rate,
              CASE
                 WHEN UPPER (cc.payment_unit) = 'PER STUDENT PER DAY'
                 THEN
                    cc.fee_rate * cc.cisco_dur_days
                    * CASE
                         WHEN COUNT(f.enroll_id) = 0 THEN ed.onsite_attended
                         ELSE COUNT (f.enroll_id)
                      END
                 WHEN UPPER (cc.payment_unit) = 'PER STUDENT'
                 THEN
                    cc.fee_rate
                    * CASE
                         WHEN COUNT (f.enroll_id) = 0 THEN ed.onsite_attended
                         ELSE COUNT (f.enroll_id)
                      END
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT'
                 THEN
                    0
              END
                 roy_amt
       FROM                        event_dim ed
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
                       LEFT OUTER JOIN
                          order_fact f
                       ON     ed.event_id = f.event_id
                          AND f.enroll_status IN ('Confirmed', 'Attended')
                          AND f.fee_type != 'Ons - Base'
                    LEFT OUTER JOIN
                       cust_dim c
                    ON f.cust_id = c.cust_id
                 INNER JOIN
                    gk_cisco_dw_mv cc
                 ON     cd.course_id = cc.course_id
                    AND UPPER (cc.fee_status) = 'ACTIVE'
                    AND td.dim_date BETWEEN cc.from_date AND cc.TO_DATE
              INNER JOIN
                 gk_cdw_curr_auth_mv cc2
              ON cc.course_id = cc2.course_id AND cc.TO_DATE = cc2.TO_DATE
      WHERE   ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND cd.ch_num = '20'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
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
              dw_auth_code,
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
              ed.meeting_days,
              cc.cisco_dur_days,
              cc.payment_unit,
              cc.fee_rate,
              ed.onsite_attended
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
              dw_auth_code cisco_dw_id,
              CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END
                 country_iso_abbr,
              NULL number_of_students,
              SUM (NVL (accounted_cr, 0) - NVL (accounted_dr, 0)) gross_revenue,
              cd.course_code,
              NULL event_dur,
              c.cisco_dur_days cdw_dur,
              c.cisco_dur_days cdw_eff_dur,
              c.fee_type,
              1 cisco_overall_source,
              (c.fee_rate / 100) fee_rate,
              SUM (NVL (accounted_cr, 0) - NVL (accounted_dr, 0))
              * (fee_rate / 100)
                 roy_rate
       FROM               gl_je_lines@r12prd j
                       INNER JOIN
                          gl_code_combinations@r12prd gcc
                       ON j.code_combination_id = gcc.code_combination_id
                    INNER JOIN
                       gk_cisco_dw_mv c
                    ON gcc.segment7 =
                          CASE
                             WHEN SUBSTR (gcc.segment7, 1, 1) = '0'
                             THEN
                                LPAD (SUBSTR (c.prod_code, 1, 4), 6, '00')
                             ELSE
                                c.prod_code
                          END
                 INNER JOIN
                    course_dim cd
                 ON c.course_id = cd.course_id
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
              AND c.content_type = 'E-Learning'
              AND c.fee_status != 'Inactive'
              AND SUBSTR (cd.course_code, 1, 4) NOT IN
                       ('5313', '5314', '5316', '5317', '5318', '5319')
              AND j.effective_date BETWEEN c.from_date AND c.TO_DATE
   GROUP BY   j.period_name,
              cd.course_id,
              cd.course_code,
              gcc.segment4,
              gcc.segment5,
              TRIM (td.dim_month) || ' ' || td.dim_year,
              dw_auth_code,
              CASE WHEN gcc.segment1 = '220' THEN 'CAN' ELSE 'USA' END,
              cd.course_code,
              cd.short_name,
              c.cisco_dur_days,
              c.fee_type,
              c.fee_rate
   UNION
     SELECT   'EX-ONSITE-NO_STUDENTS' cdw_group,
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
              dw_auth_code cisco_dw_id,
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
              NVL (
                 CASE
                    WHEN COUNT (f.enroll_id) = 0 THEN ed.onsite_attended
                    ELSE COUNT (f.enroll_id)
                 END,
                 0
              )
                 number_of_students,
              SUM (ob.book_amt) gross_revenue,
              ed.course_code gk_course_code,
              ed.meeting_days event_dur,
              cc.cisco_dur_days cdw_dur,
              cc.cisco_dur_days cdw_eff_dur,
              cc.payment_unit rate_type,
              1 cisco_overall_source,
              CASE
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT' THEN 0
                 ELSE cc.fee_rate
              END
                 cdw_rate,
              CASE
                 WHEN UPPER (cc.payment_unit) = 'PER STUDENT PER DAY'
                 THEN
                    cc.fee_rate * cc.cisco_dur_days
                    * CASE
                         WHEN COUNT(f.enroll_id) = 0 THEN ed.onsite_attended
                         ELSE COUNT (f.enroll_id)
                      END
                 WHEN UPPER (cc.payment_unit) = 'PER STUDENT'
                 THEN
                    cc.fee_rate
                    * CASE
                         WHEN COUNT (f.enroll_id) = 0 THEN ed.onsite_attended
                         ELSE COUNT (f.enroll_id)
                      END
                 WHEN UPPER (cc.payment_unit) = 'NO PAYMENT'
                 THEN
                    0
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
                    LEFT OUTER JOIN
                       order_fact f
                    ON     ed.event_id = f.event_id
                       AND f.enroll_status IN ('Confirmed', 'Attended')
                       AND f.fee_type != 'Ons - Base'
                 LEFT OUTER JOIN
                    cust_dim c
                 ON f.cust_id = c.cust_id
              INNER JOIN
                 gk_cisco_dw_mv cc
              ON     cd.course_id = cc.course_id
                 AND UPPER (cc.fee_status) = 'ACTIVE'
                 AND td.dim_date BETWEEN cc.from_date AND cc.TO_DATE
      WHERE   ed.status IN ('Open', 'Verified')
              AND ed.event_id NOT IN
                       (  SELECT   event_id FROM gk_cdw_event_exclude)
              AND cd.ch_num = '10'
              AND cd.md_num IN ('10', '20')
              AND cd.pl_num = '04'
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
              dw_auth_code,
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
              ed.meeting_days,
              cc.cisco_dur_days,
              cc.payment_unit,
              cc.fee_rate,
              ed.onsite_attended
     HAVING   NVL (
                 CASE
                    WHEN COUNT (f.enroll_id) = 0 THEN ed.onsite_attended
                    ELSE COUNT (f.enroll_id)
                 END,
                 0
              ) = 0;


