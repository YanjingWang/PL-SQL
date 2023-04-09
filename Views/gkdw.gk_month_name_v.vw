DROP VIEW GKDW.GK_MONTH_NAME_V;

/* Formatted on 29/01/2021 11:33:01 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MONTH_NAME_V
(
   DIM_PERIOD_NAME,
   DIM_MONTH,
   DIM_YEAR
)
AS
   SELECT   DISTINCT dim_period_name, dim_month, dim_year FROM time_dim;


