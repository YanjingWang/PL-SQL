DROP VIEW GKDW.GK_GO_NOGO_ALL_V;

/* Formatted on 29/01/2021 11:35:52 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GO_NOGO_ALL_V
(
   OPS_COUNTRY,
   START_WEEK,
   START_DATE,
   EVENT_ID,
   RESELLER_EVENT_ID,
   METRO,
   METRO_LEVEL,
   FACILITY_CODE,
   COURSE_CODE,
   CONNECTED_EVENT,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   COURSE_TYPE,
   INST_TYPE,
   INST_NAME,
   TP_COURSE,
   TP_STATUS,
   REVENUE,
   TOTAL_COST,
   ENROLL_CNT,
   GK_ENROLL_CNT,
   NEX_ENROLL_CNT,
   RATE_PLAN,
   MAX_DAILY_RATE,
   MARGIN,
   INST_COST,
   INST_TRAVEL_COST,
   CW_COST,
   FREIGHT_COST,
   VOUCHER_COST,
   CISCO_DW_COST,
   FACILITY_COST,
   HOTEL_PROMO_COST,
   PROCTOR_EXAM_COST,
   UNLIMITED_ENROLLMENTS,
   LOCK_PROMO_CNT,
   RUN_STATUS,
   RUN_STATUS_3,
   RUN_STATUS_6,
   RUN_STATUS_8,
   RUN_STATUS_10,
   AMT_DUE_REMAIN,
   REV_6_WEEKS_OUT,
   LAB_RENTAL,
   SALES_COMM,
   GTR_FLAG
)
AS
     SELECT   q.ops_country,
              q.start_week,
              q.start_date,
              q.event_id,
              ed.reseller_event_id,
              q.facility_region_metro metro,
              metro_level,
              q.facility_code,
              q.course_code,
              q.connected_event,
              q.course_ch,
              q.course_mod,
              q.course_pl,
              cd.course_type,
              q.inst_type,
              q.inst_name,
              c.course_code tp_course,
              c.status tp_status,
              SUM (rev_amt) revenue,
              SUM(  inst_cost
                  + travel_cost
                  + cw_cost
                  + freight_cost
                  + voucher_cost
                  + cdw_cost
                  + facility_cost
                  + hotel_promo_cost
                  + proctor_exam_cost
                  + lab_rental
                  + sales_comm)
                 total_cost,
              SUM (NVL (q.enroll_cnt, 0)) enroll_cnt,
              SUM (NVL (gk_enroll_cnt, 0)) gk_enroll_cnt,
              SUM (NVL (nex_enroll_cnt, 0)) nex_enroll_cnt,
              q.rate_plan,
              q.max_daily_rate,
              CASE
                 WHEN SUM (rev_amt) = 0
                 THEN
                    0
                 ELSE
                    (SUM (rev_amt)
                     - SUM(  inst_cost
                           + travel_cost
                           + cw_cost
                           + freight_cost
                           + voucher_cost
                           + cdw_cost
                           + facility_cost
                           + hotel_promo_cost
                           + proctor_exam_cost
                           + lab_rental
                           + sales_comm))
                    / SUM (rev_amt)
              END
                 margin,
              SUM (inst_cost) inst_cost,
              SUM (travel_cost) inst_travel_cost,
              SUM (cw_cost) cw_cost,
              SUM (freight_cost) freight_cost,
              SUM (voucher_cost) voucher_cost,
              SUM (cdw_cost) cisco_dw_cost,
              SUM (facility_cost) facility_cost,
              SUM (hotel_promo_cost) hotel_promo_cost,
              SUM (proctor_exam_cost) proctor_exam_cost,
              SUM (unlimited_cnt) unlimited_enrollments,
              SUM (lock_promo_cnt) lock_promo_cnt,
              run_status,
              run_status_3,
              run_status_6,
              run_status_8,
              run_status_10,
              SUM (amt_due_remain) amt_due_remain,
              SUM (rev_6_weeks_out) rev_6_weeks_out,
              SUM (lab_rental) lab_rental,
              SUM (sales_comm) sales_comm,
              CASE WHEN ge.event_id IS NOT NULL THEN 'Y' ELSE 'N' END gtr_flag
       FROM               (SELECT   l1.ops_country,
                                    l1.start_week,
                                    l1.start_date,
                                    l1.event_id,
                                    l1.facility_region_metro,
                                    NVL (l1.metro_level, 0) metro_level,
                                    l1.facility_code,
                                    l1.course_code,
                                    l1.course_ch,
                                    l1.course_mod,
                                    l1.course_pl,
                                    l1.inst_type,
                                    l1.inst_name,
                                    NVL (l1.rev_amt, 0) rev_amt,
                                    l1.enroll_cnt,
                                    l1.gk_enroll_cnt,
                                    l1.nex_enroll_cnt,
                                    l1.rate_plan,
                                    l1.max_daily_rate,
                                    CASE
                                       WHEN l1.course_mod = 'V-LEARNING'
                                            AND l1.ops_country = 'CANADA'
                                       THEN
                                          0
                                       ELSE
                                          NVL (inst_cost, 0)
                                    END
                                       inst_cost,
                                      NVL (hotel_cost, 0)
                                    + NVL (airfare_cost, 0)
                                    + NVL (rental_cost, 0)
                                       travel_cost,
                                      NVL (l1.cw_cost, 0)
                                    + NVL (l1.cw_shipping_cost, 0)
                                    + NVL (l1.misc_cw_cost, 0)
                                       cw_cost,
                                    NVL (freight_cost, 0) freight_cost,
                                    NVL (l1.voucher_cost, 0) voucher_cost,
                                    NVL (l1.cdw_cost, 0) cdw_cost,
                                    ROUND (NVL (facility_cost, 0), 2)
                                       facility_cost,
                                    NVL (hotel_promo_cost, 0) hotel_promo_cost,
                                    NVL (proctor_exam_cost, 0)
                                       proctor_exam_cost,
                                    unlimited_cnt,
                                    lock_promo_cnt,
                                    l1.run_status,
                                    l1.run_status_3,
                                    l1.run_status_6,
                                    l1.run_status_8,
                                    l1.run_status_10,
                                    NVL (l1.amt_due_remain, 0) amt_due_remain,
                                    NVL (l1.rev_6_weeks_out, 0) rev_6_weeks_out,
                                    l1.connected_event,
                                    NVL (l1.lab_rental, 0) lab_rental,
                                    NVL (l1.sales_comm, 0) sales_comm
                             FROM   gk_go_nogo l1
                            WHERE       l1.ch_num = '10'
                                    AND l1.md_num IN ('10', '20')
                                    AND l1.cancelled_date IS NULL
                                    AND l1.connected_to IS NULL
                                    AND nested_with IS NULL
                           UNION ALL
                             SELECT   l1.ops_country,
                                      l1.start_week,
                                      l1.start_date,
                                      l1.event_id,
                                      l1.facility_region_metro,
                                      NVL (l1.metro_level, 0),
                                      l1.facility_code,
                                      l1.course_code,
                                      l1.course_ch,
                                      l1.course_mod,
                                      l1.course_pl,
                                      l1.inst_type,
                                      l1.inst_name,
                                      SUM (NVL (l2.rev_amt, 0)) rev_amt,
                                      SUM (l2.enroll_cnt),
                                      SUM (l2.gk_enroll_cnt),
                                      SUM (l2.nex_enroll_cnt),
                                      l1.rate_plan,
                                      l1.max_daily_rate,
                                      0,
                                      0,
                                      SUM(  NVL (l2.cw_cost, 0)
                                          + NVL (l2.cw_shipping_cost, 0)
                                          + NVL (l2.misc_cw_cost, 0))
                                         cw_cost,
                                      0,
                                      SUM (NVL (l2.voucher_cost, 0)) voucher_cost,
                                      SUM (NVL (l2.cdw_cost, 0)) cdw_cost,
                                      0,
                                      SUM (NVL (l2.hotel_promo_cost, 0))
                                         hotel_promo_cost,
                                      SUM (NVL (l2.proctor_exam_cost, 0))
                                         proctor_exam_cost,
                                      SUM (l2.unlimited_cnt),
                                      SUM (l2.lock_promo_cnt),
                                      l1.run_status,
                                      l1.run_status_3,
                                      l1.run_status_6,
                                      l1.run_status_8,
                                      l1.run_status_10,
                                      SUM (NVL (l2.amt_due_remain, 0))
                                         amt_due_remain,
                                      SUM (NVL (l2.rev_6_weeks_out, 0))
                                         rev_6_weeks_out,
                                      NULL,
                                      SUM (NVL (l2.lab_rental, 0)),
                                      SUM (NVL (l2.sales_comm, 0))
                               FROM      gk_go_nogo l1
                                      INNER JOIN
                                         gk_go_nogo l2
                                      ON l1.event_id = l2.nested_with
                              WHERE       l1.ch_num = '10'
                                      AND l1.md_num = '10'
                                      AND l1.cancelled_date IS NULL
                           GROUP BY   l1.ops_country,
                                      l1.start_week,
                                      l1.start_date,
                                      l1.event_id,
                                      l1.facility_region_metro,
                                      NVL (l1.metro_level, 0),
                                      l1.facility_code,
                                      l1.course_code,
                                      l1.course_ch,
                                      l1.course_mod,
                                      l1.course_pl,
                                      l1.inst_type,
                                      l1.inst_name,
                                      l1.rate_plan,
                                      l1.max_daily_rate,
                                      l1.run_status,
                                      l1.run_status_3,
                                      l1.run_status_6,
                                      l1.run_status_8,
                                      l1.run_status_10
                           UNION ALL
                             SELECT   l1.ops_country,
                                      l1.start_week,
                                      l1.start_date,
                                      l1.event_id,
                                      l1.facility_region_metro,
                                      NVL (l1.metro_level, 0),
                                      l1.facility_code,
                                      l1.course_code,
                                      l1.course_ch,
                                      l1.course_mod,
                                      l1.course_pl,
                                      l1.inst_type,
                                      l1.inst_name,
                                      SUM (NVL (l2.rev_amt, 0)) rev_amt,
                                      SUM (l2.enroll_cnt),
                                      SUM (l2.gk_enroll_cnt),
                                      SUM (l2.nex_enroll_cnt),
                                      l1.rate_plan,
                                      l1.max_daily_rate,
                                      0,
                                      0,
                                      SUM(  NVL (l2.cw_cost, 0)
                                          + NVL (l2.cw_shipping_cost, 0)
                                          + NVL (l2.misc_cw_cost, 0))
                                         cw_cost,
                                      0,
                                      SUM (NVL (l2.voucher_cost, 0)) voucher_cost,
                                      SUM (NVL (l2.cdw_cost, 0)) cdw_cost,
                                      0,
                                      SUM (NVL (l2.hotel_promo_cost, 0))
                                         hotel_promo_cost,
                                      SUM (NVL (l2.proctor_exam_cost, 0))
                                         proctor_exam_cost,
                                      SUM (l2.unlimited_cnt),
                                      SUM (l2.lock_promo_cnt),
                                      l1.run_status,
                                      l1.run_status_3,
                                      l1.run_status_6,
                                      l1.run_status_8,
                                      l1.run_status_10,
                                      SUM (NVL (l2.amt_due_remain, 0))
                                         amt_due_remain,
                                      SUM (NVL (l2.rev_6_weeks_out, 0))
                                         rev_6_weeks_out,
                                      l1.connected_event,
                                      SUM (NVL (l2.lab_rental, 0)),
                                      SUM (NVL (l2.sales_comm, 0))
                               FROM      gk_go_nogo l1
                                      INNER JOIN
                                         gk_go_nogo l2
                                      ON l1.event_id = l2.connected_to
                              WHERE       l1.ch_num = '10'
                                      AND l1.md_num = '10'
                                      AND l1.cancelled_date IS NULL
                           GROUP BY   l1.ops_country,
                                      l1.start_week,
                                      l1.start_date,
                                      l1.event_id,
                                      l1.facility_region_metro,
                                      NVL (l1.metro_level, 0),
                                      l1.facility_code,
                                      l1.course_code,
                                      l1.course_ch,
                                      l1.course_mod,
                                      l1.course_pl,
                                      l1.inst_type,
                                      l1.inst_name,
                                      l1.rate_plan,
                                      l1.max_daily_rate,
                                      l1.run_status,
                                      l1.run_status_3,
                                      l1.run_status_6,
                                      l1.run_status_8,
                                      l1.run_status_10,
                                      l1.connected_event) q
                       INNER JOIN
                          event_dim ed
                       ON q.event_id = ed.event_id
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 LEFT OUTER JOIN
                    gk_gtr_events ge
                 ON q.event_id = ge.event_id
              LEFT OUTER JOIN
                 slxdw.tp_classes c
              ON ed.reseller_event_id = c.eventid --where q.start_date >= '01-JAN-2012'
                 AND SUBSTR (q.course_code, 5, 1) NOT IN ('N', 'V')
   GROUP BY   q.ops_country,
              q.start_week,
              q.start_date,
              q.event_id,
              ed.reseller_event_id,
              q.facility_region_metro,
              metro_level,
              q.facility_code,
              q.course_code,
              q.connected_event,
              q.course_pl,
              q.course_ch,
              q.course_mod,
              cd.course_type,
              q.inst_type,
              q.inst_name,
              q.rate_plan,
              q.max_daily_rate,
              c.course_code,
              c.status,
              run_status,
              run_status_3,
              run_status_6,
              run_status_8,
              run_status_10,
              CASE WHEN ge.event_id IS NOT NULL THEN 'Y' ELSE 'N' END
   ORDER BY   start_week, start_date;


