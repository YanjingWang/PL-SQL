DROP VIEW GKDW.GK_GO_NOGO_V;

/* Formatted on 29/01/2021 11:35:39 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_GO_NOGO_V
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
   GUEST_STUDENT_CNT,
   ALLACCESS_CNT,
   GUEST_CNT,
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
   MISC_CW_COST,
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
   FOOD_AND_BEV,
   CREDIT_CARD_FEE,
   CD_FEE,
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
              CASE
                 WHEN ed.connected_c = 'Y' THEN 'C'
                 WHEN ed.connected_v_to_c IS NOT NULL THEN 'V'
                 ELSE NULL
              END
                 connected_event,
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
                  + misc_cw_cost
                  + lab_rental
                  + sales_comm
                  + food_and_bev
                  + credit_card_fee
                  + cd_fee)
                 total_cost,
              SUM (NVL (q.enroll_cnt, 0)) enroll_cnt,
              SUM (NVL (gk_enroll_cnt, 0)) gk_enroll_cnt,
              SUM (NVL (nex_enroll_cnt, 0)) nex_enroll_cnt,
              --            SUM (CASE WHEN f.enroll_id IS NOT NULL THEN 1 ELSE 0 END)
              --               guest_student_cnt,
              q.guest_cnt - q.allaccess_cnt quest_student_cnt,
              q.ALLACCESS_CNT,
              --            SUM (CASE WHEN f2.enroll_id IS NOT NULL THEN 1 ELSE 0 END)
              --               allaccess_cnt,
              --            COUNT (f.enroll_id) guest_student_cnt,
              --            COUNT (f2.enroll_id) allaccess_cnt,
              SUM (NVL (guest_cnt, 0)) guest_cnt,
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
                           + misc_cw_cost
                           + lab_rental
                           + sales_comm
                           + food_and_bev
                           + credit_card_fee
                           + cd_fee))
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
              SUM (misc_cw_cost) misc_cw_cost,
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
              SUM (food_and_bev) food_and_bev,
              SUM (credit_card_fee) credit_card_fee,
              SUM (cd_fee) cd_fee,
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
                                    l1.guest_cnt,
                                    l1.allaccess_cnt,
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
                                       cw_cost,
                                    NVL (freight_cost, 0) freight_cost,
                                    NVL (l1.voucher_cost, 0) voucher_cost,
                                    NVL (l1.cdw_cost, 0) cdw_cost,
                                    ROUND (NVL (facility_cost, 0), 2)
                                       facility_cost,
                                    NVL (hotel_promo_cost, 0) hotel_promo_cost,
                                    NVL (misc_cw_cost, 0) misc_cw_cost,
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
                                    NVL (l1.sales_comm, 0) sales_comm,
                                    NVL (l1.food_and_bev, 0) food_and_bev,
                                    NVL (l1.credit_card_fee, 0) credit_card_fee,
                                    NVL (l1.cd_fee, 0) cd_fee
                             FROM   gk_go_nogo l1
                            WHERE       l1.ch_num = '10'
                                    AND l1.md_num IN ('10')
                                    AND l1.cancelled_date IS NULL
                                    --          and l1.connected_to is null
                                    AND nested_with IS NULL
                           UNION ALL
                           SELECT   l1.ops_country,
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
                                    l1.guest_cnt,
                                    l1.allaccess_cnt,
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
                                       cw_cost,
                                    NVL (freight_cost, 0) freight_cost,
                                    NVL (l1.voucher_cost, 0) voucher_cost,
                                    NVL (l1.cdw_cost, 0) cdw_cost,
                                    ROUND (NVL (facility_cost, 0), 2)
                                       facility_cost,
                                    NVL (hotel_promo_cost, 0) hotel_promo_cost,
                                    NVL (misc_cw_cost, 0) misc_cw_cost,
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
                                    NVL (l1.sales_comm, 0) sales_comm,
                                    NVL (l1.food_and_bev, 0) food_and_bev,
                                    NVL (l1.credit_card_fee, 0) credit_card_fee,
                                    NVL (l1.cd_fee, 0) cd_fee
                             FROM   gk_go_nogo l1
                            WHERE       l1.ch_num = '10'
                                    AND l1.md_num IN ('20')
                                    AND l1.cancelled_date IS NULL
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
                                      SUM (l2.guest_cnt),
                                      SUM (l2.allaccess_cnt),
                                      l1.rate_plan,
                                      l1.max_daily_rate,
                                      0,
                                      0,
                                      SUM(NVL (l2.cw_cost, 0)
                                          + NVL (l2.cw_shipping_cost, 0))
                                         cw_cost,
                                      0,
                                      SUM (NVL (l2.voucher_cost, 0)) voucher_cost,
                                      SUM (NVL (l2.cdw_cost, 0)) cdw_cost,
                                      0,
                                      SUM (NVL (l2.hotel_promo_cost, 0))
                                         hotel_promo_cost,
                                      SUM (NVL (l2.misc_cw_cost, 0)) misc_cw_cost,
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
                                      SUM (NVL (l2.sales_comm, 0)),
                                      SUM (NVL (l2.food_and_bev, 0)),
                                      SUM (NVL (l2.credit_card_fee, 0)),
                                      SUM (NVL (l2.cd_fee, 0))
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
                                      l1.run_status_10     --        union all
                                                      --        select l1.ops_country,l1.start_week,l1.start_date,l1.event_id,l1.facility_region_metro,nvl(l1.metro_level,0),l1.facility_code,
                                                      --              l1.course_code,l1.course_ch,l1.course_mod,l1.course_pl,l1.inst_type,l1.inst_name,sum(nvl(l2.rev_amt,0)) rev_amt,sum(l2.enroll_cnt),
                                                      --              sum(l2.gk_enroll_cnt),sum(l2.nex_enroll_cnt),l1.rate_plan,l1.max_daily_rate,0,0,
                                                      --              sum(nvl(l2.cw_cost,0)+nvl(l2.cw_shipping_cost,0)+nvl(l2.misc_cw_cost,0)) cw_cost,
                                                      --              0,sum(nvl(l2.voucher_cost,0)) voucher_cost,sum(nvl(l2.cdw_cost,0)) cdw_cost,0,sum(nvl(l2.hotel_promo_cost,0)) hotel_promo_cost,
                                                      --              sum(nvl(l2.proctor_exam_cost,0)) proctor_exam_cost,sum(l2.unlimited_cnt),sum(l2.lock_promo_cnt),l1.run_status,l1.run_status_3,
                                                      --              l1.run_status_6,l1.run_status_8,l1.run_status_10,sum(nvl(l2.amt_due_remain,0)) amt_due_remain,sum(nvl(l2.rev_6_weeks_out,0)) rev_6_weeks_out,
                                                      --              l1.connected_event,sum(nvl(l2.lab_rental,0)),sum(nvl(l2.sales_comm,0))
                                                      --         from gk_go_nogo l1
                                                      --              inner join gk_go_nogo l2 on l1.event_id = l2.connected_to
                                                      --        where l1.ch_num = '10'
                                                      --          and l1.md_num = '10'
                                                      --          and l1.cancelled_date is null
                                                      --        group by l1.ops_country,l1.start_week,l1.start_date,l1.event_id,l1.facility_region_metro,nvl(l1.metro_level,0),l1.facility_code,
                                                      --                 l1.course_code,l1.course_ch,l1.course_mod,l1.course_pl,l1.inst_type,l1.inst_name,l1.rate_plan,l1.max_daily_rate,
                                                      --                 l1.run_status,l1.run_status_3,l1.run_status_6,l1.run_status_8,l1.run_status_10,l1.connected_event
                          ) q
                       INNER JOIN
                          event_dim ed
                       ON q.event_id = ed.event_id
                    INNER JOIN
                       course_dim cd
                    ON ed.course_id = cd.course_id
                       AND ed.ops_country = cd.country
                 --            LEFT OUTER JOIN order_fact f
                 --               ON     ed.event_id = f.event_id
                 --                  AND f.enroll_status <> 'Cancelled'
                 --                  AND f.book_amt = 0
                 --                  AND NVL (f.keycode, '0') <> 'ALLACCESS'
                 --            LEFT OUTER JOIN order_fact f2
                 --               ON     ed.event_id = f2.event_id
                 --                  AND f2.enroll_status <> 'Cancelled'
                 --                  AND f2.book_amt = 0
                 --                  AND f2.keycode = 'ALLACCESS'
                 LEFT OUTER JOIN
                    gk_gtr_events ge
                 ON q.event_id = ge.event_id
              LEFT OUTER JOIN
                 slxdw.tp_classes c
              ON ed.reseller_event_id = c.eventid
      WHERE   q.start_date >= '01-JAN-2015' --      where q.start_date >= to_date('01/01/'||to_char(sysdate,'yyyy'),'mm/dd/yyyy')
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
              CASE
                 WHEN ed.connected_c = 'Y' THEN 'C'
                 WHEN ed.connected_v_to_c IS NOT NULL THEN 'V'
                 ELSE NULL
              END,
              q.course_pl,
              q.course_ch,
              q.course_mod,
              cd.course_type,
              q.inst_type,
              q.inst_name,
              q.guest_cnt - q.allaccess_cnt,
              q.ALLACCESS_CNT,
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


