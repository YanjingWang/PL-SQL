DROP MATERIALIZED VIEW GKDW.GK_FACILITY_PO_MV;
CREATE MATERIALIZED VIEW GKDW.GK_FACILITY_PO_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          256K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE
START WITH TO_DATE('29-Jan-2021 20:00:00','dd-mon-yyyy hh24:mi:ss')
NEXT TRUNC(SYSDATE+1)+20/24  
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:25:07 (QP5 v5.115.810.9015) */
SELECT   pd.attribute2 event_id,
         ph.segment1,
         pl.line_num,
         pl.item_description,
         pl.quantity,
         pl.unit_price,
         gcc.segment1 le,
         gcc.segment2 fe,
         gcc.segment3 acct,
         gcc.segment4 ch,
         gcc.segment5 md,
         gcc.segment6 pl,
         gcc.segment7 act,
         gcc.segment8 cc
  FROM            po_distributions_all@prd pd
               INNER JOIN
                  po_lines_all@prd pl
               ON pd.po_line_id = pl.po_line_id
            INNER JOIN
               po_headers_all@prd ph
            ON pl.po_header_id = ph.po_header_id
         INNER JOIN
            gl_code_combinations@prd gcc
         ON pd.code_combination_id = gcc.code_combination_id
 WHERE   gcc.segment2 = '145';

COMMENT ON MATERIALIZED VIEW GKDW.GK_FACILITY_PO_MV IS 'snapshot table for snapshot GKDW.GK_FACILITY_PO_MV';

GRANT SELECT ON GKDW.GK_FACILITY_PO_MV TO DWHREAD;

