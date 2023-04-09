DROP VIEW GKDW.GK_FACILITY_USAGE_V;

/* Formatted on 29/01/2021 11:36:12 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_FACILITY_USAGE_V
(
   FACILITY_REGION_METRO,
   FACILITY_CODE,
   TOTAL_DAYS,
   FACILITY_FEE,
   FACILITY_DAILY_FEE
)
AS
     SELECT   facility_region_metro,
              facility_code,
              SUM (total_days) total_days,
              SUM (facility_fee) facility_fee,
              SUM (facility_fee) / SUM (total_days) facility_daily_fee
       FROM   (  SELECT   ed.event_id,
                          ed.start_date,
                          ed.end_date,
                          ed.facility_region_metro,
                          ed.facility_code,
                          ed.end_date - ed.start_date + 1 total_days,
                          SUM (pl.unit_price * pl.quantity) facility_fee,
                          SUM (pl.unit_price * pl.quantity)
                          / (ed.end_date - ed.start_date + 1)
                             facility_daily_fee
                   FROM            po_lines_all@r12prd pl
                                INNER JOIN
                                   po_distributions_all@r12prd pd
                                ON pl.po_line_id = pd.po_line_id
                             INNER JOIN
                                gl_code_combinations@r12prd gcc
                             ON pd.code_combination_id = gcc.code_combination_id
                          INNER JOIN
                             event_dim ed
                          ON pd.attribute2 = ed.event_id
                  WHERE       pl.creation_date >= TRUNC (SYSDATE) - 365
                          AND gcc.segment3 = '64105'
                          AND ed.internalfacility = 'F'
               GROUP BY   ed.event_id,
                          ed.start_date,
                          ed.end_date,
                          ed.facility_region_metro,
                          ed.facility_code)
   GROUP BY   facility_region_metro, facility_code;


