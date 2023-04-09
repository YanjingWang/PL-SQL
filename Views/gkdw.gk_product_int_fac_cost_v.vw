DROP VIEW GKDW.GK_PRODUCT_INT_FAC_COST_V;

/* Formatted on 29/01/2021 11:29:14 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PRODUCT_INT_FAC_COST_V
(
   PERIOD_YEAR,
   CC_NUM,
   TC_AMT,
   EVENT_DAYS,
   TC_AMT_PER_EVENT_DAY
)
AS
     SELECT   fc.period_year,
              fc.cc_num,
              fc.tc_amt,
              SUM (end_date - start_date + 1) event_days,
              fc.tc_amt / SUM (end_date - start_date + 1) tc_amt_per_event_day
       FROM            gk_int_fac_cost_v@r12prd fc
                    INNER JOIN
                       time_dim td
                    ON fc.period_year = td.dim_year
                 INNER JOIN
                    event_dim ed
                 ON td.dim_date = ed.start_date
              INNER JOIN
                 gk_facility_cc_dim gc
              ON fc.cc_num = gc.cc_num AND ed.facility_code = gc.facility_code,
              gk_last_closed_period_v lc
      WHERE   td.dim_year || '-' || LPAD (td.dim_month_num, 2, 0) BETWEEN '2004-01'
                                                                      AND  lc.last_period
              AND ed.status != 'Cancelled'
              AND ed.internalfacility = 'T'
   GROUP BY   fc.period_year, fc.cc_num, fc.tc_amt;


