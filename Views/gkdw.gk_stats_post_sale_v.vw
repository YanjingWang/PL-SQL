DROP VIEW GKDW.GK_STATS_POST_SALE_V;

/* Formatted on 29/01/2021 11:26:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_STATS_POST_SALE_V
(
   PERIOD_NAME,
   LE_NUM,
   FE_NUM,
   ACCT_NUM,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   ACT_NUM,
   CC_NUM,
   FUT_NUM,
   DEBIT,
   CREDIT,
   EVENT_ID
)
AS
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92050' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (ed.event_id) debit,
              NULL credit,
              ed.event_id
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND (ed.cancel_reason NOT IN
                         ('Event in Error', 'Session in Error')
                   OR ed.cancel_reason IS NULL)
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92060' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (ed.event_id) debit,
              NULL credit,
              ed.event_id
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status IN ('Verified', 'Open')
              AND EXISTS
                    (SELECT   1
                       FROM   order_fact f
                      WHERE   f.event_id = ed.event_id
                              AND f.enroll_status IN ('Confirmed', 'Attended'))
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92122' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (f.enroll_id) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
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
      WHERE   ( (cd.ch_num IN ('10') AND f.book_amt > 0)
               OR (cd.ch_num IN ('20') AND f.book_amt = 0))
              AND md_num NOT IN ('32', '50')
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND f.enroll_status IN ('Attended', 'Confirmed')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92123' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (f.enroll_id) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
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
      WHERE       cd.ch_num IN ('10')
              AND f.book_amt = 0
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND NVL (f.attendee_type, 'None') != 'Unlimited'
              AND f.enroll_status IN ('Attended', 'Confirmed')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92127' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (f.enroll_id) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
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
      WHERE       cd.ch_num IN ('10')
              AND f.book_amt = 0
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND NVL (f.attendee_type, 'None') = 'Unlimited'
              AND f.enroll_status IN ('Attended', 'Confirmed')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92210' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status IN ('Verified', 'Open')
              AND EXISTS
                    (SELECT   1
                       FROM   order_fact f
                      WHERE   f.event_id = ed.event_id
                              AND f.enroll_status IN ('Confirmed', 'Attended'))
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '145' fe_num,
              '92230' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              NVL (d.cc_num, '210') cc_num,
              '000' fut_num,
              COUNT (ed.event_id) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              LEFT OUTER JOIN
                 gk_facility_cc_dim d
              ON ed.facility_code = d.facility_code
      WHERE   cd.md_num IN ('10')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ed.internalfacility = 'T'
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id,
              d.cc_num
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '145' fe_num,
              '92232' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '210' cc_num,
              '000' fut_num,
              COUNT (ed.event_id) debit,
              NULL credit,
              ed.event_id
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE   cd.md_num IN ('10')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND NVL (ed.internalfacility, 'F') = 'F'
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '145' fe_num,
              '92235' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              NVL (d.cc_num, '210') cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              LEFT OUTER JOIN
                 gk_facility_cc_dim d
              ON ed.facility_code = d.facility_code
      WHERE   cd.md_num IN ('10')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ed.internalfacility = 'T'
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id,
              d.cc_num
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '145' fe_num,
              '92238' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '210' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM         event_dim ed
                 INNER JOIN
                    course_dim cd
                 ON ed.course_id = cd.course_id AND ed.ops_country = cd.country
              INNER JOIN
                 time_dim td
              ON ed.start_date = td.dim_date
      WHERE   cd.md_num IN ('10')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND NVL (ed.internalfacility, 'F') = 'F'
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92226' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('INS', 'SI'))
                   OR (feecode IN ('INS', 'SI')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'GLOBAL KNOW%'
                   OR UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92229' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('INS', 'SI'))
                   OR (feecode IN ('INS', 'SI')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'GLOBAL KNOW%'
                   AND UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92245' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('CT', 'SS'))
                   OR (feecode IN ('CT', 'SS')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'GLOBAL KNOW%'
                   OR UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92246' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('CT', 'SS'))
                   OR (feecode IN ('CT', 'SS')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'GLOBAL KNOW%'
                   AND UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92242' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('FA', 'AUD', 'TAUD'))
                   OR (feecode IN ('FA', 'AUD', 'TAUD')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'GLOBAL KNOW%'
                   OR UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92243' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('FA', 'AUD', 'TAUD'))
                   OR (feecode IN ('FA', 'AUD', 'TAUD')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'GLOBAL KNOW%'
                   AND UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92220' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (ed.event_id) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('INS', 'SI'))
                   OR (feecode IN ('INS', 'SI')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'GLOBAL KNOW%'
                   OR UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92222' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (ed.event_id) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('INS', 'SI'))
                   OR (feecode IN ('INS', 'SI')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'GLOBAL KNOW%'
                   AND UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name,
              CASE
                 WHEN UPPER (es.shiptocountry) = 'USA'
                 THEN
                    '210'
                 WHEN UPPER (SUBSTR (es.shiptocountry, 1, 3)) = 'CANADA'
                 THEN
                    '220'
                 ELSE
                    '210'
              END
                 le_num,
              '000' fe_num,
              '92070' acct_num,
              NVL (pd.ch_num, '00'),
              NVL (pd.md_num, '00'),
              NVL (pd.pl_num, '00'),
              NVL (pd.act_num, '000000'),
              '000' cc_num,
              '000' fut_num,
              SUM (esd.actualquantityordered) debit,
              NULL credit,
              pd.prod_num
       FROM            slxdw.evxso es
                    INNER JOIN
                       evxsodetail esd
                    ON es.evxsoid = esd.evxsoid
                 INNER JOIN
                    product_dim pd
                 ON esd.productid = pd.product_id
              INNER JOIN
                 time_dim td
              ON TRUNC (es.shippeddate) = td.dim_date
      WHERE       es.sostatus = 'Shipped'
              AND es.recordtype = 'SalesOrder'
              AND pd.prod_num LIKE '2%'
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              es.shiptocountry,
              pd.le_num,
              pd.ch_num,
              pd.md_num,
              pd.pl_num,
              pd.act_num,
              pd.prod_num
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92070' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              COUNT (f.enroll_id) debit,
              NULL credit,
              cd.course_code
       FROM            course_dim cd
                    INNER JOIN
                       event_dim ed
                    ON cd.course_id = ed.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    order_fact f
                 ON ed.event_id = f.event_id
              INNER JOIN
                 time_dim td
              ON TRUNC (f.book_date) = td.dim_date
      WHERE       md_num IN ('32', '50')
              AND f.enroll_status IN ('Attended', 'Confirmed')
              AND f.book_amt > 0
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              cd.course_code
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92224' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.act_num BETWEEN '006036' AND '006199'
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('CT', 'FA', 'AUD', 'TAUD'))
                   OR (feecode IN ('CT', 'FA', 'AUD', 'TAUD')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'GLOBAL KNOW%'
                   OR UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '000' fe_num,
              '92227' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              '000' cc_num,
              '000' fut_num,
              SUM (ed.end_date - ed.start_date + 1) debit,
              NULL credit,
              ed.event_id
       FROM            event_dim ed
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              INNER JOIN
                 instructor_event_v ie
              ON ed.event_id = ie.evxeventid
      WHERE   cd.md_num IN ('10', '20')
              AND cd.act_num BETWEEN '006036' AND '006199'
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ( (SUBSTR (feecode, 1, INSTR (feecode, '-') - 2) IN
                           ('CT', 'FA', 'AUD', 'TAUD'))
                   OR (feecode IN ('CT', 'FA', 'AUD', 'TAUD')))
              AND (UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'GLOBAL KNOW%'
                   AND UPPER (NVL (ACCOUNT, 'NO ACCOUNT')) NOT LIKE 'NEXIENT%')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id
   /**************************************************/
   /****** ATTENDEES IN FIXED TRAINING CENTERS *******/
   /**************************************************/
   UNION
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN ed.ops_country = 'USA' THEN '210'
                 WHEN ed.ops_country = 'CANADA' THEN '220'
                 ELSE cd.le_num
              END
                 le_num,
              '145' fe_num,
              '92126' acct_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              NVL (d.cc_num, '210') cc_num,
              '000' fut_num,
              COUNT (f.enroll_id) debit,
              NULL credit,
              ed.event_id
       FROM               event_dim ed
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
              LEFT OUTER JOIN
                 gk_facility_cc_dim d
              ON ed.facility_code = d.facility_code
      WHERE   cd.md_num IN ('10')
              AND cd.course_code NOT IN
                       (  SELECT   nested_course_code FROM gk_nested_courses)
              AND cd.course_code NOT IN ('3163N', '3164N', '3188N', '3189N')
              AND ed.status NOT IN ('Cancelled')
              AND ed.internalfacility = 'T'
              AND (f.book_amt > 0
                   OR NVL (f.attendee_type, 'None') = 'Unlimited')
              AND f.enroll_status IN ('Attended', 'Confirmed')
              AND td.dim_date BETWEEN '01-OCT-2011' AND '21-OCT-2011'
   GROUP BY   td.dim_period_name,
              ed.ops_country,
              cd.le_num,
              cd.ch_num,
              cd.md_num,
              cd.pl_num,
              cd.act_num,
              ed.event_id,
              d.cc_num;


