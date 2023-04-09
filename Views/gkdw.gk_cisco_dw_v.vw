DROP VIEW GKDW.GK_CISCO_DW_V;

/* Formatted on 29/01/2021 11:40:51 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CISCO_DW_V
(
   PERIOD_NAME,
   COUNTRY,
   COURSE_CODE,
   EVENT_ID,
   EV_LEN,
   CH_NUM,
   COURSE_CH,
   MD_NUM,
   COURSE_MOD,
   CNT,
   REV_AMT,
   ROYALTY_DAY,
   SOURCE1_PCT,
   SOURCE2_PCT,
   SOURCE3_PCT,
   SOURCE4_PCT,
   SOURCE5_PCT,
   SELF_PRINT_DISC_AMT,
   ROY_AMT
)
AS
     SELECT   td.dim_period_name period_name,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    UPPER (c.country)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    UPPER (cd.country)
              END
                 country,
              cd.course_code,
              ed.event_id,
              ed.end_date - ed.start_date + 1 ev_len,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              course_mod,
              SUM (CASE WHEN book_amt > 0 THEN 1 ELSE 0 END) cnt,
              SUM (book_amt) rev_amt,
              gc.royalty_day,
              gc.source1_pct,
              gc.source2_pct,
              gc.source3_pct,
              gc.source4_pct,
              gc.source5_pct,
              DECODE (gc.self_print_disc, 'Y', 15, 0) self_print_disc_amt,
                gc.royalty_day
              * (ed.end_date - ed.start_date + 1)
              * SUM (CASE WHEN book_amt > 0 THEN 1 ELSE 0 END)
              - (DECODE (gc.self_print_disc, 'Y', 15, 0)
                 * SUM (CASE WHEN book_amt > 0 THEN 1 ELSE 0 END))
                 roy_amt
       FROM                  course_dim cd
                          INNER JOIN
                             event_dim ed
                          ON cd.course_id = ed.course_id
                             AND cd.country = ed.country
                       INNER JOIN
                          order_fact o
                       ON ed.event_id = o.event_id
                    INNER JOIN
                       cust_dim c
                    ON o.cust_id = c.cust_id
                 INNER JOIN
                    time_dim td
                 ON o.rev_date = td.dim_date
              LEFT OUTER JOIN
                 gk_cdw_courses gc
              ON SUBSTR (cd.course_code, 1, 4) = gc.gk_course_code
      WHERE       enroll_status IN ('Confirmed', 'Attended')
              AND cd.pl_num = '04'
              AND cd.ch_num = '10'
              AND cd.md_num NOT IN ('31', '32', '43', '44')
   --   and td.dim_period_name = 'MAR-06'
   GROUP BY   td.dim_period_name,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    UPPER (c.country)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    UPPER (cd.country)
              END,
              cd.course_code,
              ed.event_id,
              ed.end_date - ed.start_date + 1,
              cd.ch_num,
              course_ch,
              cd.md_num,
              course_mod,
              gc.royalty_day,
              gc.source1_desc,
              gc.source1_pct,
              gc.source2_desc,
              gc.source2_pct,
              gc.source3_desc,
              gc.source3_pct,
              gc.source4_desc,
              gc.source4_pct,
              gc.source5_desc,
              gc.source5_pct,
              gc.self_print_disc
   UNION
     SELECT   td.dim_period_name,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    UPPER (c.country)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    UPPER (cd.country)
              END,
              cd.course_code,
              ed.event_id,
              ed.end_date - ed.start_date + 1 ev_len,
              cd.ch_num,
              cd.course_ch,
              cd.md_num,
              course_mod,
              ed.capacity cnt,
              SUM (book_amt) rev_amt,
              gc.royalty_day,
              gc.source1_pct,
              gc.source2_pct,
              gc.source3_pct,
              gc.source4_pct,
              gc.source5_pct,
              DECODE (gc.self_print_disc, 'Y', 15, 0) self_print_disc_amt,
                gc.royalty_day
              * (ed.end_date - ed.start_date + 1)
              * SUM (CASE WHEN book_amt = 0 THEN 1 ELSE 0 END)
              - (DECODE (gc.self_print_disc, 'Y', 15, 0)
                 * SUM (CASE WHEN book_amt = 0 THEN 1 ELSE 0 END))
                 roy_amt
       FROM                  course_dim cd
                          INNER JOIN
                             event_dim ed
                          ON cd.course_id = ed.course_id
                             AND cd.country = ed.country
                       INNER JOIN
                          order_fact o
                       ON ed.event_id = o.event_id
                    INNER JOIN
                       cust_dim c
                    ON o.cust_id = c.cust_id
                 INNER JOIN
                    time_dim td
                 ON ed.start_date = td.dim_date
              LEFT OUTER JOIN
                 gk_cdw_courses gc
              ON SUBSTR (cd.course_code, 1, 4) = gc.gk_course_code
      WHERE       ed.status IN ('Open', 'Verified')
              AND cd.pl_num = '04'
              AND cd.ch_num = '20'
   --   and td.dim_period_name = 'MAR-06'
   GROUP BY   td.dim_period_name,
              CASE
                 WHEN cd.md_num = '20' AND UPPER (c.country) = 'CANADA'
                 THEN
                    UPPER (c.country)
                 WHEN cd.md_num = '20'
                 THEN
                    'USA'
                 ELSE
                    UPPER (cd.country)
              END,
              cd.course_code,
              ed.event_id,
              ed.end_date - ed.start_date + 1,
              cd.ch_num,
              course_ch,
              cd.md_num,
              course_mod,
              ed.capacity,
              gc.royalty_day,
              gc.source1_pct,
              gc.source2_pct,
              gc.source3_pct,
              gc.source4_pct,
              gc.source5_pct,
              gc.self_print_disc
   UNION
     SELECT   td.dim_period_name,
              UPPER (sf.ship_to_country),
              sf.prod_num,
              sf.product_id,
              1,
              pd.ch_num,
              pd.prod_channel,
              pd.md_num,
              pd.prod_channel,
              SUM (quantity),
              SUM (book_amt),
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL
       FROM         sales_order_fact sf
                 INNER JOIN
                    product_dim pd
                 ON sf.product_id = pd.product_id
              INNER JOIN
                 time_dim td
              ON sf.rev_date = td.dim_date
      WHERE       record_type = 'SalesOrder'
              AND so_status = 'Shipped'
              AND pd.pl_num = '04'
   --and dim_period_name = 'MAR-06'
   GROUP BY   td.dim_period_name,
              UPPER (sf.ship_to_country),
              sf.prod_num,
              sf.product_id,
              1,
              pd.ch_num,
              pd.prod_channel,
              pd.md_num,
              pd.prod_channel
   UNION
     SELECT   gp.period_name,
              DECODE (rct.org_id,
                      '86',
                      'CANADA',
                      '87',
                      'CANADA',
                      '84',
                      'USA',
                      '85',
                      'USA'),
              msi.attribute1 course_code,
              msi.attribute1 event_id,
              1,
              gcc.segment4,
              cd.ch_desc,
              gcc.segment5,
              md.md_desc,
              COUNT (DISTINCT rct.trx_number) cnt,
              SUM (rctd.amount) amt,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL,
              NULL
       FROM   gl_code_combinations@r12prd gcc,
              ra_customer_trx_lines_all@r12prd rctl,
              ra_cust_trx_line_gl_dist_all@r12prd rctd,
              ra_cust_trx_types_all@r12prd rctt,
              gl_periods@r12prd gp,
              ra_customer_trx_all@r12prd rct,
              mtl_system_items@r12prd msi,
              ch_dim cd,
              md_dim md
      WHERE       rctl.customer_trx_id = rct.customer_trx_id
              AND rctl.customer_trx_line_id = rctd.customer_trx_line_id
              AND rct.cust_trx_type_id = rctt.cust_trx_type_id
              AND rct.org_id = rctt.org_id
              AND rctd.code_combination_id = gcc.code_combination_id
              AND rctd.gl_date BETWEEN gp.start_date AND gp.end_date
              AND rctl.inventory_item_id = msi.inventory_item_id
              AND msi.organization_id = 88
              AND gcc.segment4 = cd.ch_value
              AND gcc.segment5 = md.md_value
              AND rctt.TYPE IN ('INV', 'CM')
              AND rctd.account_class = 'REV'
              AND gcc.segment4 = '10'
              AND gcc.segment5 IN ('31', '32', '43', '44')
              AND gcc.segment6 = '04'
   --   AND GP.PERIOD_NAME = 'MAR-06'
   GROUP BY   gp.period_name,
              msi.attribute1,
              rct.attribute5,
              DECODE (rct.org_id,
                      '86',
                      'CANADA',
                      '87',
                      'CANADA',
                      '84',
                      'USA',
                      '85',
                      'USA'),
              gcc.segment4,
              cd.ch_desc,
              gcc.segment5,
              md.md_desc;


