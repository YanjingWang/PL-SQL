DROP VIEW GKDW.GK_FACILITY_FB_V;

/* Formatted on 29/01/2021 11:36:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_FACILITY_FB_V
(
   OPS_COUNTRY,
   FACILITY_REGION_METRO,
   FACILITY_CODE,
   FAC_TYPE,
   FAC_FB_PER_STUD
)
AS
     SELECT   ops_country,
              facility_region_metro,
              facility_code,
              fac_type,
              SUM (facility_fee) / (SUM (total_days) * SUM (enroll_cnt))
                 fac_fb_per_stud
       FROM   (  SELECT   ed.ops_country,
                          ed.event_id,
                          ed.start_date,
                          ed.end_date,
                          ed.facility_region_metro,
                          ed.facility_code,
                          CASE
                             WHEN ed.internalfacility = 'T' THEN 'INTERNAL'
                             ELSE 'EXTERNAL'
                          END
                             fac_type,
                          ed.end_date - ed.start_date + 1 total_days,
                          f.enroll_cnt,
                          SUM (pl.unit_price * pl.quantity) facility_fee,
                          SUM (pl.unit_price * pl.quantity)
                          / (ed.end_date - ed.start_date + 1)
                             fac_fb_per_stud
                   FROM               po_lines_all@r12prd pl
                                   INNER JOIN
                                      po_distributions_all@r12prd pd
                                   ON pl.po_line_id = pd.po_line_id
                                INNER JOIN
                                   gl_code_combinations@r12prd gcc
                                ON pd.code_combination_id =
                                      gcc.code_combination_id
                             INNER JOIN
                                event_dim ed
                             ON pd.attribute2 = ed.event_id
                          INNER JOIN
                             gk_oe_attended_cnt_v f
                          ON ed.event_id = f.event_id
                  WHERE   pl.creation_date BETWEEN TRUNC (SYSDATE) - 365
                                               AND  TRUNC (SYSDATE)
                          AND gcc.segment3 = '64305'
               GROUP BY   ed.ops_country,
                          ed.event_id,
                          ed.start_date,
                          ed.end_date,
                          ed.facility_region_metro,
                          ed.facility_code,
                          CASE
                             WHEN ed.internalfacility = 'T' THEN 'INTERNAL'
                             ELSE 'EXTERNAL'
                          END,
                          ed.end_date - ed.start_date + 1,
                          f.enroll_cnt)
   GROUP BY   ops_country,
              facility_region_metro,
              facility_code,
              fac_type;


