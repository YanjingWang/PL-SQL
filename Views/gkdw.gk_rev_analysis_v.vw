DROP VIEW GKDW.GK_REV_ANALYSIS_V;

/* Formatted on 29/01/2021 11:27:48 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_REV_ANALYSIS_V
(
   DIM_YEAR,
   DIM_PERIOD_NAME,
   EVENT_MODALITY,
   METRO_AREA,
   TOT_CONF_ATT,
   BOOK_AMT,
   TOT_FEE_STUD,
   FULL_CNT,
   FULL_AMT,
   FULL_FEE_STUD,
   DISC_CNT,
   DISC_AMT,
   DISC_FEE_STUD,
   PREPAY_CNT,
   PREPAY_AMT,
   PREPAY_FEE_STUD,
   GK_CANC_CNT,
   GK_CANC_AMT,
   STUD_CANC_CNT,
   STUD_CANC_AMT
)
AS
     SELECT   t.dim_year,
              t.dim_period_name,
              e.event_modality,
              e.facility_region_metro metro_area,
              SUM (CASE WHEN f.enroll_status != 'Cancelled' THEN 1 ELSE 0 END)
                 tot_conf_att,
              SUM(CASE
                     WHEN f.enroll_status != 'Cancelled' THEN book_amt
                     ELSE 0
                  END)
                 book_amt,
              CASE
                 WHEN SUM(CASE
                             WHEN f.enroll_status != 'Cancelled' THEN 1
                             ELSE 0
                          END) = 0
                 THEN
                    0
                 ELSE
                    SUM(CASE
                           WHEN f.enroll_status != 'Cancelled' THEN book_amt
                           ELSE 0
                        END)
                    / SUM(CASE
                             WHEN f.enroll_status != 'Cancelled' THEN 1
                             ELSE 0
                          END)
              END
                 tot_fee_stud,
              SUM(CASE
                     WHEN book_amt >= NVL (list_price, book_amt)
                          AND (pp_sales_order_id IS NULL
                               OR pd.card_type = 'ValueCard')
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        1
                     ELSE
                        0
                  END)
                 full_cnt,
              SUM(CASE
                     WHEN book_amt >= NVL (list_price, book_amt)
                          AND (pp_sales_order_id IS NULL
                               OR pd.card_type = 'ValueCard')
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        book_amt
                     ELSE
                        0
                  END)
                 full_amt,
              CASE
                 WHEN SUM(CASE
                             WHEN book_amt >= NVL (list_price, book_amt)
                                  AND (pp_sales_order_id IS NULL
                                       OR pd.card_type = 'ValueCard')
                                  AND f.enroll_status != 'Cancelled'
                             THEN
                                1
                             ELSE
                                0
                          END) = 0
                 THEN
                    0
                 ELSE
                    SUM(CASE
                           WHEN book_amt >= NVL (list_price, book_amt)
                                AND (pp_sales_order_id IS NULL
                                     OR pd.card_type = 'ValueCard')
                                AND f.enroll_status != 'Cancelled'
                           THEN
                              book_amt
                           ELSE
                              0
                        END)
                    / SUM(CASE
                             WHEN book_amt >= NVL (list_price, book_amt)
                                  AND (pp_sales_order_id IS NULL
                                       OR pd.card_type = 'ValueCard')
                                  AND f.enroll_status != 'Cancelled'
                             THEN
                                1
                             ELSE
                                0
                          END)
              END
                 full_fee_stud,
              SUM(CASE
                     WHEN book_amt < list_price
                          AND (pp_sales_order_id IS NULL
                               OR pd.card_type = 'ValueCard')
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        1
                     ELSE
                        0
                  END)
                 disc_cnt,
              SUM(CASE
                     WHEN book_amt < list_price
                          AND (pp_sales_order_id IS NULL
                               OR pd.card_type = 'ValueCard')
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        list_price - book_amt
                     ELSE
                        0
                  END)
                 disc_amt,
              SUM(CASE
                     WHEN book_amt < list_price
                          AND (pp_sales_order_id IS NULL
                               OR pd.card_type = 'ValueCard')
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        list_price - book_amt
                     ELSE
                        0
                  END)
              / (CASE
                    WHEN SUM(CASE
                                WHEN book_amt < list_price
                                     AND (pp_sales_order_id IS NULL
                                          OR pd.card_type = 'ValueCard')
                                     AND f.enroll_status != 'Cancelled'
                                THEN
                                   1
                                ELSE
                                   0
                             END) = 0
                    THEN
                       1
                    ELSE
                       SUM(CASE
                              WHEN book_amt < list_price
                                   AND (pp_sales_order_id IS NULL
                                        OR pd.card_type = 'ValueCard')
                                   AND f.enroll_status != 'Cancelled'
                              THEN
                                 1
                              ELSE
                                 0
                           END)
                 END)
                 disc_fee_stud,
              SUM(CASE
                     WHEN     pp_sales_order_id IS NOT NULL
                          AND pd.card_type = 'EventCard'
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        1
                     ELSE
                        0
                  END)
                 prepay_cnt,
              SUM(CASE
                     WHEN     pp_sales_order_id IS NOT NULL
                          AND pd.card_type = 'EventCard'
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        book_amt
                     ELSE
                        0
                  END)
                 prepay_amt,
              SUM(CASE
                     WHEN     pp_sales_order_id IS NOT NULL
                          AND pd.card_type = 'EventCard'
                          AND f.enroll_status != 'Cancelled'
                     THEN
                        book_amt
                     ELSE
                        0
                  END)
              / CASE
                   WHEN SUM(CASE
                               WHEN     pp_sales_order_id IS NOT NULL
                                    AND pd.card_type = 'EventCard'
                                    AND f.enroll_status != 'Cancelled'
                               THEN
                                  1
                               ELSE
                                  0
                            END) = 0
                   THEN
                      1
                   ELSE
                      SUM(CASE
                             WHEN     pp_sales_order_id IS NOT NULL
                                  AND pd.card_type = 'EventCard'
                                  AND f.enroll_status != 'Cancelled'
                             THEN
                                1
                             ELSE
                                0
                          END)
                END
                 prepay_fee_stud,
              SUM(CASE
                     WHEN     enroll_status = 'Cancelled'
                          AND bill_status = 'Cancelled'
                          AND book_amt < 0
                          AND enroll_status_desc = 'EVENT CANCELLATION'
                     THEN
                        1
                     ELSE
                        0
                  END)
                 gk_canc_cnt,
              SUM(CASE
                     WHEN     enroll_status = 'Cancelled'
                          AND bill_status = 'Cancelled'
                          AND book_amt < 0
                          AND enroll_status_desc = 'EVENT CANCELLATION'
                     THEN
                        book_amt
                     ELSE
                        0
                  END)
                 gk_canc_amt,
              SUM(CASE
                     WHEN     enroll_status = 'Cancelled'
                          AND bill_status = 'Cancelled'
                          AND book_amt < 0
                          AND enroll_status_desc NOT IN
                                   ('EVENT CANCELLATION', 'ORDER ENTRY ERROR')
                     THEN
                        1
                     ELSE
                        0
                  END)
                 stud_canc_cnt,
              SUM(CASE
                     WHEN     enroll_status = 'Cancelled'
                          AND bill_status = 'Cancelled'
                          AND book_amt < 0
                          AND enroll_status_desc NOT IN
                                   ('EVENT CANCELLATION', 'ORDER ENTRY ERROR')
                     THEN
                        book_amt
                     ELSE
                        0
                  END)
                 stud_canc_amt
       FROM            order_fact f
                    INNER JOIN
                       time_dim t
                    ON f.rev_date = t.dim_date
                 INNER JOIN
                    event_dim e
                 ON f.event_id = e.event_id
              LEFT OUTER JOIN
                 ppcard_dim pd
              ON f.pp_sales_order_id = pd.sales_order_id
      WHERE       e.event_channel = 'INDIVIDUAL/PUBLIC'
              --and e.event_modality in ('C-LEARNING')
              AND country = 'USA'
              AND rev_date >= TO_DATE ('1/1/2006', 'mm/dd/yyyy')
   GROUP BY   t.dim_year,
              t.dim_period_name,
              t.dim_month_num,
              e.event_modality,
              e.facility_region_metro
   ORDER BY   e.event_modality,
              e.facility_region_metro,
              t.dim_year,
              t.dim_month_num;


