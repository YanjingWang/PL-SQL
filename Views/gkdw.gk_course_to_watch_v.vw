DROP VIEW GKDW.GK_COURSE_TO_WATCH_V;

/* Formatted on 29/01/2021 11:39:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_COURSE_TO_WATCH_V
(
   START_WEEK,
   START_DATE,
   EVENT_ID,
   METRO,
   FACILITY_CODE,
   COURSE_CODE,
   SHORT_NAME,
   COURSE_CH,
   COURSE_MOD,
   COURSE_PL,
   ENROLL_CNT,
   REVENUE,
   TOTAL_COST,
   MARGIN,
   MARGIN_PCT,
   ENROLL_ID,
   BOOK_AMT,
   BOOK_DATE,
   CUST_NAME,
   EMAIL,
   ACCT_NAME,
   SALES_REP,
   TERRITORY,
   REGION,
   REGION_REP
)
AS
     SELECT   w.start_week,
              w.start_date,
              w.event_id,
              w.metro,
              w.facility_code,
              w.course_code,
              w.short_name,
              w.course_ch,
              w.course_mod,
              w.course_pl,
              w.enroll_cnt,
              w.revenue,
              w.total_cost,
              w.revenue - w.total_cost margin,
              w.margin margin_pct,
              f.enroll_id,
              f.book_amt,
              f.book_date,
              cd.cust_name,
              cd.email,
              cd.acct_name,
              f.sales_rep,
              f.territory,
              f.region,
              f.region_rep
       FROM         gk_low_margin_event_v w
                 LEFT OUTER JOIN
                    order_fact f
                 ON w.event_id = f.event_id AND f.enroll_status != 'Cancelled'
              LEFT OUTER JOIN
                 cust_dim cd
              ON f.cust_id = cd.cust_id
   ORDER BY   start_week, margin_pct DESC;


