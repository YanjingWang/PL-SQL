DROP VIEW GKDW.GK_RMS_COLOR_CODING_V;

/* Formatted on 29/01/2021 11:27:32 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_RMS_COLOR_CODING_V
(
   EVENT_ID,
   REV_AMT,
   TOTAL_COST,
   ENROLL_CNT,
   MARGIN,
   GOAL_REV,
   ADJUSTED_GOAL_REV,
   NEEDED_REV_AMT,
   JEOPARDY_FLAG
)
AS
     SELECT   n.event_id,
              rev_amt,
              total_cost,
              enroll_cnt,
              margin,
              total_cost / (1 - .48) goal_rev,
              total_cost / (1 - .48)
              * (1
                 + (CASE
                       WHEN enroll_cnt = 0 THEN 0
                       ELSE NVL (cw_cost, 0) / enroll_cnt
                    END
                    + CASE
                         WHEN enroll_cnt = 0 THEN 0
                         ELSE NVL (voucher_cost, 0) / enroll_cnt
                      END
                    + CASE
                         WHEN enroll_cnt = 0 THEN 0
                         ELSE NVL (cdw_cost, 0) / enroll_cnt
                      END)
                   / cf.amount)
                 adjusted_goal_rev,
              total_cost / (1 - .48)
              * (1
                 + (CASE
                       WHEN enroll_cnt = 0 THEN 0
                       ELSE NVL (cw_cost, 0) / enroll_cnt
                    END
                    + CASE
                         WHEN enroll_cnt = 0 THEN 0
                         ELSE NVL (voucher_cost, 0) / enroll_cnt
                      END
                    + CASE
                         WHEN enroll_cnt = 0 THEN 0
                         ELSE NVL (cdw_cost, 0) / enroll_cnt
                      END)
                   / cf.amount)
              - rev_amt
                 needed_rev_amt,
              CASE
                 WHEN n.course_code NOT IN
                            (SELECT   cd.course_code
                               FROM      course_dim cd
                                      INNER JOIN
                                         event_dim ed
                                      ON cd.course_id = ed.course_id
                                         AND cd.country = ed.ops_country
                              WHERE   ed.start_date BETWEEN TRUNC (SYSDATE)
                                                            - 365
                                                        AND  TRUNC (SYSDATE)
                                      AND ed.status != 'Cancelled')
                 THEN
                    'N/A'
                 WHEN n.start_date BETWEEN TRUNC (SYSDATE)
                                       AND  TRUNC (SYSDATE) + 9
                 THEN
                    'N/A'
                 WHEN n.cancelled_date IS NOT NULL
                 THEN
                    'N/A'
                 WHEN margin > .65
                 THEN
                    'N/A'
                 WHEN n.md_num = '20'
                 THEN
                    'SIJ'
                 WHEN n.nested_with IS NOT NULL AND n.enroll_cnt < 2
                 THEN
                    'SIJ'
                 WHEN margin BETWEEN .5 AND .65
                 THEN
                    'Running'
                 WHEN n.start_week BETWEEN    td.dim_year
                                           || '-'
                                           || LPAD (td.dim_week, 2, '0')
                                       AND     td.dim_year
                                            || '-'
                                            || LPAD (td.dim_week + 4, 2, '0')
                      AND total_cost / (1 - .48)
                         * (1
                            + (CASE
                                  WHEN enroll_cnt = 0 THEN 0
                                  ELSE NVL (cw_cost, 0) / enroll_cnt
                               END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (voucher_cost, 0) / enroll_cnt
                                 END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (cdw_cost, 0) / enroll_cnt
                                 END)
                              / cf.amount)
                         - rev_amt < 4000
                 THEN
                    'SIJ'
                 WHEN n.start_week BETWEEN    td.dim_year
                                           || '-'
                                           || LPAD (td.dim_week + 5, 2, '0')
                                       AND     td.dim_year
                                            || '-'
                                            || LPAD (td.dim_week + 6, 2, '0')
                      AND total_cost / (1 - .48)
                         * (1
                            + (CASE
                                  WHEN enroll_cnt = 0 THEN 0
                                  ELSE NVL (cw_cost, 0) / enroll_cnt
                               END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (voucher_cost, 0) / enroll_cnt
                                 END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (cdw_cost, 0) / enroll_cnt
                                 END)
                              / cf.amount)
                         - rev_amt < 10000
                 THEN
                    'SIJ'
                 WHEN n.facility_region_metro IN
                            ('ATL',
                             'CHI',
                             'DAL',
                             'MRS',
                             'NYC',
                             'RTP',
                             'SNJ',
                             'WAS',
                             'TOR',
                             'OTT')
                      AND n.start_week BETWEEN    td.dim_year
                                               || '-'
                                               || LPAD (td.dim_week, 2, '0')
                                           AND  td.dim_year || '-'
                                                || LPAD (td.dim_week + 4,
                                                         2,
                                                         '0')
                      AND total_cost / (1 - .48)
                         * (1
                            + (CASE
                                  WHEN enroll_cnt = 0 THEN 0
                                  ELSE NVL (cw_cost, 0) / enroll_cnt
                               END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (voucher_cost, 0) / enroll_cnt
                                 END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (cdw_cost, 0) / enroll_cnt
                                 END)
                              / cf.amount)
                         - rev_amt < 8000
                 THEN
                    'SIJ'
                 WHEN n.facility_region_metro IN
                            ('ATL',
                             'CHI',
                             'DAL',
                             'MRS',
                             'NYC',
                             'RTP',
                             'SNJ',
                             'WAS',
                             'TOR',
                             'OTT')
                      AND n.start_week BETWEEN td.dim_year || '-'
                                               || LPAD (td.dim_week + 5,
                                                        2,
                                                        '0')
                                           AND  td.dim_year || '-'
                                                || LPAD (td.dim_week + 6,
                                                         2,
                                                         '0')
                      AND total_cost / (1 - .48)
                         * (1
                            + (CASE
                                  WHEN enroll_cnt = 0 THEN 0
                                  ELSE NVL (cw_cost, 0) / enroll_cnt
                               END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (voucher_cost, 0) / enroll_cnt
                                 END
                               + CASE
                                    WHEN enroll_cnt = 0 THEN 0
                                    ELSE NVL (cdw_cost, 0) / enroll_cnt
                                 END)
                              / cf.amount)
                         - rev_amt < 13000
                 THEN
                    'SIJ'
                 ELSE
                    'N/A'
              END
                 jeopardy_flag
       FROM            gk_go_nogo n
                    INNER JOIN
                       event_dim ed
                    ON n.event_id = ed.event_id AND ed.status = 'Open'
                 INNER JOIN
                    slxdw.evxcoursefee cf
                 ON     n.course_id = cf.evxcourseid
                    AND CASE
                          WHEN n.ops_country = 'CAN' THEN 'CAD'
                          ELSE 'USD'
                       END = cf.currency
                    AND cf.feetype = 'Primary'
              INNER JOIN
                 time_dim td
              ON td.dim_date = TRUNC (SYSDATE)
      WHERE   NVL (cf.amount, 0) > 0 AND n.ch_num = '10' AND enroll_cnt > 0
              AND n.start_week BETWEEN    td.dim_year
                                       || '-'
                                       || LPAD (td.dim_week, 2, '0')
                                   AND  CASE
                                           WHEN td.dim_week + 8 > 52
                                           THEN
                                              td.dim_year + 1 || '-'
                                              || LPAD (td.dim_week + 8 - 52,
                                                       2,
                                                       '0')
                                           ELSE
                                                 td.dim_year
                                              || '-'
                                              || LPAD (td.dim_week + 8, 2, '0')
                                        END
              AND n.start_date >= TRUNC (SYSDATE)
   ORDER BY   n.start_date;


