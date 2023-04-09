DROP VIEW GKDW.GK_LOW_MARGIN_EVENT_V;

/* Formatted on 29/01/2021 11:33:25 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_LOW_MARGIN_EVENT_V
(
   OPS_COUNTRY,
   START_WEEK,
   START_DATE,
   EVENT_ID,
   METRO,
   METRO_LEVEL,
   FACILITY_CODE,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   INST_TYPE,
   REVENUE,
   TOTAL_COST,
   ENROLL_CNT,
   MARGIN,
   INST_COST,
   INST_TRAVEL_COST,
   CW_COST,
   FREIGHT_COST,
   VOUCHER_COST,
   CISCO_DW_COST,
   FACILITY_COST,
   HOTEL_PROMO_COST,
   PROCTOR_EXAM_COST
)
AS
     SELECT   ops_country,
              start_week,
              start_date,
              event_id,
              facility_region_metro metro,
              metro_level,
              facility_code,
              course_code,
              short_name,
              course_ch,
              course_mod,
              course_pl,
              inst_type,
              SUM (rev_amt) revenue,
              SUM(  inst_cost
                  + travel_cost
                  + cw_cost
                  + freight_cost
                  + voucher_cost
                  + cdw_cost
                  + facility_cost
                  + hotel_promo_cost
                  + proctor_exam_cost)
                 total_cost,
              SUM (enroll_cnt) enroll_cnt,
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
                           + proctor_exam_cost))
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
              SUM (proctor_exam_cost) proctor_exam_cost
       FROM   (SELECT   l1.ops_country,
                        l1.start_week,
                        l1.start_date,
                        l1.event_id,
                        l1.facility_region_metro,
                        NVL (l1.metro_level, 0) metro_level,
                        l1.facility_code,
                        l1.course_code,
                        l1.short_name,
                        l1.course_ch,
                        l1.course_mod,
                        l1.course_pl,
                        l1.inst_type,
                        NVL (l1.rev_amt, 0) rev_amt,
                        l1.enroll_cnt,
                        NVL (inst_cost, 0) inst_cost,
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
                        ROUND (NVL (facility_cost, 0), 2) facility_cost,
                        NVL (hotel_promo_cost, 0) hotel_promo_cost,
                        NVL (proctor_exam_cost, 0) proctor_exam_cost
                 FROM   gk_go_nogo l1
                WHERE       l1.ch_num = '10'
                        AND l1.md_num IN ('10', '20') --and l1.ops_country = 'USA'
                        AND l1.cancelled_date IS NULL
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
                          l1.short_name,
                          l1.course_ch,
                          l1.course_mod,
                          l1.course_pl,
                          l1.inst_type,
                          SUM (NVL (l2.rev_amt, 0)) rev_amt,
                          SUM (l2.enroll_cnt),
                          0,
                          0,
                          SUM(  NVL (l2.cw_cost, 0)
                              + NVL (l2.cw_shipping_cost, 0)
                              + NVL (l1.misc_cw_cost, 0))
                             cw_cost,
                          0,
                          SUM (NVL (l2.voucher_cost, 0)) voucher_cost,
                          SUM (NVL (l2.cdw_cost, 0)) cdw_cost,
                          0,
                          SUM (NVL (l2.hotel_promo_cost, 0)) hotel_promo_cost,
                          SUM (NVL (l2.proctor_exam_cost, 0)) proctor_exam_cost
                   FROM      gk_go_nogo l1
                          INNER JOIN
                             gk_go_nogo l2
                          ON l1.event_id = l2.nested_with
                  WHERE       l1.ch_num = '10'
                          AND l1.md_num = '10'
                          AND l1.ops_country = 'USA'
                          AND l1.cancelled_date IS NULL
               GROUP BY   l1.ops_country,
                          l1.start_week,
                          l1.start_date,
                          l1.event_id,
                          l1.facility_region_metro,
                          NVL (l1.metro_level, 0),
                          l1.facility_code,
                          l1.course_code,
                          l1.short_name,
                          l1.course_ch,
                          l1.course_mod,
                          l1.course_pl,
                          l1.inst_type)
   GROUP BY   ops_country,
              start_week,
              start_date,
              event_id,
              facility_region_metro,
              metro_level,
              facility_code,
              course_code,
              short_name,
              course_pl,
              course_ch,
              course_mod,
              inst_type
     HAVING   CASE
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
                           + proctor_exam_cost))
                    / SUM (rev_amt)
              END < .6;


