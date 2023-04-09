DROP VIEW GKDW.GK_TOTAL_PIPELINE_DATES_V;

/* Formatted on 29/01/2021 11:24:50 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_TOTAL_PIPELINE_DATES_V
(
   DIM_DATE,
   DIM_DAY,
   DIM_WEEK,
   DIM_MONTH_NUM,
   WEEK_NUM
)
AS
     SELECT   dim_date,
              dim_day,
              dim_week,
              dim_month_num,
              CASE
                 WHEN dim_month_num <= 3
                 THEN
                    dim_week - (dim_month_num - 1) * 4
                 WHEN dim_month_num <= 6
                 THEN
                    (dim_week - 1) - (dim_month_num - 1) * 4
                 WHEN dim_month_num <= 9
                 THEN
                    (dim_week - 2) - (dim_month_num - 1) * 4
                 WHEN dim_month_num <= 12
                 THEN
                    (dim_week - 3) - (dim_month_num - 1) * 4
              END
                 week_num
       FROM   time_dim
      WHERE       dim_year >= 2011
              AND dim_day = 'Tuesday'
              AND CASE
                    WHEN dim_month_num <= 3
                    THEN
                       dim_week - (dim_month_num - 1) * 4
                    WHEN dim_month_num <= 6
                    THEN
                       (dim_week - 1) - (dim_month_num - 1) * 4
                    WHEN dim_month_num <= 9
                    THEN
                       (dim_week - 2) - (dim_month_num - 1) * 4
                    WHEN dim_month_num <= 12
                    THEN
                       (dim_week - 3) - (dim_month_num - 1) * 4
                 END = 2
   ORDER BY   dim_week;


