DROP VIEW GKDW.GK_OSR_OPPORTUNITIES_V;

/* Formatted on 29/01/2021 11:31:01 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_OSR_OPPORTUNITIES_V
(
   OPPORTUNITY_ID,
   DESCRIPTION,
   CLOSED,
   STAGE,
   SALES_POTENTIAL,
   CLOSE_PROBABILITY,
   WEIGHTED_SALES,
   ESTIMATED_CLOSE,
   STATUS,
   DEPARTMENT,
   REGION,
   DIVISION,
   USERNAME,
   ACCT_NAME,
   STATE,
   TERRITORY_ID,
   NOTES,
   ACTUAL_CLOSE,
   ACTUAL_AMOUNT,
   EST_CLOSE_MONTH_NUM,
   EST_CLOSE_PERIOD_NAME,
   EST_CLOSE_YEAR,
   EST_CLOSE_WEEK,
   EST_CLOSE_QUARTER,
   EST_CLOSE_YYYYMM,
   ACT_CLOSE_YYYYMM,
   ACT_CLOSE_MONTH_NUM,
   ACT_CLOSE_PERIOD_NAME,
   ACT_CLOSE_YEAR,
   ACT_CLOSE_WEEK,
   ACT_CLOST_QUARTER
)
AS
   SELECT   od.opportunity_id,
            od.description,
            od.closed,
            od.stage,
            od.sales_potential,
            (od.close_probability / 100) close_probability,
            ( (od.close_probability / 100) * od.sales_potential)
               weighted_sales,
            od.estimated_close,
            od.status,
            u.department,
            u.region,
            u.division,
            u.username,
            ad.acct_name,
            ad.state,
            gt.territory_id,
            od.notes,
            actual_close,
            actual_amount,
            td.dim_month_num est_close_month_num,
            td.dim_period_name est_close_period_name,
            td.dim_year est_close_year,
            td.dim_week est_close_week,
            td.dim_quarter est_close_quarter,
            td.dim_year || '-' || td.dim_month_num est_close_yyyymm,
            td2.dim_year || '-' || td2.dim_month_num act_close_yyyymm,
            td2.dim_month_num act_close_month_num,
            td2.dim_period_name act_close_period_name,
            td2.dim_year act_close_year,
            td2.dim_week act_close_week,
            td2.dim_quarter act_clost_quarter
     FROM                  gkdw.opportunity_dim od
                        INNER JOIN
                           slxdw.userinfo u
                        ON od.account_manager_id = u.userid
                           AND department = 'OSR'
                     LEFT OUTER JOIN
                        gkdw.account_dim ad
                     ON od.account_id = ad.acct_id
                  LEFT OUTER JOIN
                     gkdw.gk_territory gt
                  ON ad.zipcode BETWEEN gt.zip_start AND gt.zip_end
                     AND gt.territory_type = 'OSR'
               LEFT OUTER JOIN
                  gkdw.time_dim td
               ON TO_CHAR (od.estimated_close, 'DD-MON-YYYY') = td.dim_date
            LEFT OUTER JOIN
               gkdw.time_dim td2
            ON TO_CHAR (od.actual_close, 'DD-MON-YYYY') = td2.dim_date;


