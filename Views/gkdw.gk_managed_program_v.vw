DROP VIEW GKDW.GK_MANAGED_PROGRAM_V;

/* Formatted on 29/01/2021 11:33:21 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MANAGED_PROGRAM_V
(
   MANAGED_PROGRAM_ID,
   EVENT_ID,
   COURSE_CODE,
   SHORT_NAME,
   EVENT_DESC,
   START_DATE,
   END_DATE,
   LOCATION_NAME,
   CITY,
   STATE,
   COUNTRY,
   PO_NUM,
   CREATION_DATE,
   PO_HEADER_ID,
   PO_LINE_ID,
   LINE_NUM,
   PO_DISTRIBUTION_ID,
   CODE_COMBINATION_ID,
   SEGMENT1,
   LE_DESC,
   SEGMENT2,
   FE_DESC,
   SEGMENT3,
   ACCT_DESC,
   SEGMENT4,
   CH_DESC,
   SEGMENT5,
   MD_DESC,
   SEGMENT6,
   PL_DESC,
   SEGMENT7,
   ACT_DESC,
   SEGMENT8,
   CC_DESC,
   PO_AMT,
   INVOICE_ID,
   INVOICE_NUM,
   INVOICE_CURRENCY_CODE,
   INVOICE_AMOUNT,
   INVOICE_DESCRIPTION,
   INVOICE_DISTRIBUTION_ID,
   DESCRIPTION,
   UNIT_PRICE,
   QUANTITY_INVOICED,
   AMOUNT
)
AS
     SELECT   ed.managed_program_id,
              ed.event_id,
              cd.course_code,
              cd.short_name,
              ed.event_desc,
              ed.start_date,
              ed.end_date,
              ed.location_name,
              ed.city,
              ed.state,
              ed.country,
              ph.segment1 po_num,
              ph.creation_date,
              ph.po_header_id,
              pl.po_line_id,
              pl.line_num,
              pd.po_distribution_id,
              pd.code_combination_id,
              gcc.segment1,
              l.le_desc,
              gcc.segment2,
              f.fe_desc,
              gcc.segment3,
              a.acct_desc,
              gcc.segment4,
              c.ch_desc,
              gcc.segment5,
              m.md_desc,
              gcc.segment6,
              p.pl_desc,
              gcc.segment7,
              ac.act_desc,
              gcc.segment8,
              cc.cc_desc,
              SUM (pd.quantity_ordered * pl.unit_price) po_amt,
              ai.invoice_id,
              ai.invoice_num,
              ai.invoice_currency_code,
              ai.invoice_amount,
              ai.description invoice_description,
              aid.invoice_distribution_id,
              aid.description,
              aid.unit_price,
              aid.quantity_invoiced,
              aid.amount
       FROM                                                event_dim ed
                                                        INNER JOIN
                                                           course_dim cd
                                                        ON ed.course_id =
                                                              cd.course_id
                                                           AND ed.ops_country =
                                                                 cd.country
                                                     LEFT OUTER JOIN
                                                        po_distributions_all@r12prd pd
                                                     ON ed.event_id =
                                                           pd.attribute2
                                                  LEFT OUTER JOIN
                                                     po_lines_all@r12prd pl
                                                  ON pd.po_line_id =
                                                        pl.po_line_id
                                               LEFT OUTER JOIN
                                                  po_headers_all@r12prd ph
                                               ON pl.po_header_id =
                                                     ph.po_header_id
                                            LEFT OUTER JOIN
                                               gl_code_combinations@r12prd gcc
                                            ON pd.code_combination_id =
                                                  gcc.code_combination_id
                                         LEFT OUTER JOIN
                                            ap_invoice_distributions_all@r12prd aid
                                         ON pd.po_distribution_id =
                                               aid.po_distribution_id
                                            AND NVL (aid.reversal_flag, 'N') =
                                                  'N'
                                      LEFT OUTER JOIN
                                         ap_invoices_all@r12prd ai
                                      ON aid.invoice_id = ai.invoice_id
                                   LEFT OUTER JOIN
                                      le_dim l
                                   ON gcc.segment1 = l.le_value
                                LEFT OUTER JOIN
                                   fe_dim f
                                ON gcc.segment2 = f.fe_value
                             LEFT OUTER JOIN
                                acct_dim a
                             ON gcc.segment3 = a.acct_value
                          LEFT OUTER JOIN
                             ch_dim c
                          ON gcc.segment4 = c.ch_value
                       LEFT OUTER JOIN
                          md_dim m
                       ON gcc.segment5 = m.md_value
                    LEFT OUTER JOIN
                       pl_dim p
                    ON gcc.segment6 = p.pl_value
                 LEFT OUTER JOIN
                    act_dim ac
                 ON gcc.segment7 = ac.act_value
              LEFT OUTER JOIN
                 cc_dim cc
              ON gcc.segment8 = cc.cc_value
      WHERE   ed.managed_program_id IS NOT NULL
   GROUP BY   ed.managed_program_id,
              ed.event_id,
              cd.course_code,
              cd.short_name,
              ed.event_desc,
              ed.start_date,
              ed.end_date,
              ed.location_name,
              ed.city,
              ed.state,
              ed.country,
              ph.segment1,
              ph.creation_date,
              ph.po_header_id,
              pl.po_line_id,
              pl.line_num,
              pd.po_distribution_id,
              pd.code_combination_id,
              gcc.segment1,
              l.le_desc,
              gcc.segment2,
              f.fe_desc,
              gcc.segment3,
              a.acct_desc,
              gcc.segment4,
              c.ch_desc,
              gcc.segment5,
              m.md_desc,
              gcc.segment6,
              p.pl_desc,
              gcc.segment7,
              ac.act_desc,
              gcc.segment8,
              cc.cc_desc,
              ai.invoice_id,
              ai.invoice_num,
              ai.invoice_currency_code,
              ai.invoice_amount,
              ai.description,
              aid.invoice_distribution_id,
              aid.description,
              aid.unit_price,
              aid.quantity_invoiced,
              aid.amount
   ORDER BY   ed.managed_program_id, ph.po_header_id, pl.line_num;


