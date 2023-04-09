DROP VIEW GKDW.GK_EXT_FAC_EVENT_COST_V;

/* Formatted on 29/01/2021 11:36:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EXT_FAC_EVENT_COST_V
(
   EVENT_ID,
   FAC_AMT
)
AS
     SELECT   ed.event_id, SUM (pl.unit_price * pl.quantity) fac_amt
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
      WHERE   gcc.segment3 IN ('64105', '64205', '64305')
              AND ed.internalfacility = 'F'
   GROUP BY   ed.event_id;


