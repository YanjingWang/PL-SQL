DROP VIEW GKDW.GK_NXT_COMMISSION_ORDERS_V;

/* Formatted on 29/01/2021 11:32:13 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_NXT_COMMISSION_ORDERS_V
(
   REV_PERIOD_NAME,
   OPERATING_UNIT,
   INV_TYPE,
   TRX_TYPE,
   INV_NUM,
   ORDER_NUM,
   REV_DATE,
   CUSTOMER_NAME,
   PRODUCT_NUM,
   PERSON_ID,
   EVENT_ID,
   ORACLE_ITEM_ID,
   CITY,
   PROVINCE,
   ZIPCODE,
   COMPANY_CITY,
   COMPANY_PROVINCE,
   COMPANY_ZIP,
   BOOK_AMT,
   ACT_NUM,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   ACCT_NUM,
   CUSTOMER_TRX_ID,
   ORG_ID,
   CREATED_BY,
   CUSTOMER_NUMBER,
   NAT_ACCT_FLAG,
   KEYCODE,
   PO_NUMBER,
   SALES_REP,
   FEE_TYPE,
   SOURCE,
   BOOK_DATE
)
AS
   SELECT   td.dim_period_name rev_period_name,
            hou.NAME operating_unit,
            rctt.NAME inv_type,
            rctt.TYPE trx_type,
            f.oracle_trx_num inv_num,
            f.enroll_id order_num,
            f.rev_date,
            cd.acct_name customer_name,
            c.oracle_item_num product_num,
            f.cust_id person_id,
            f.event_id,
            c.oracle_item_id,
            cd.city,
            cd.province,
            cd.zipcode,
            --rctl.line_number line_number,
            ad.city company_city,
            ad.province company_province,
            ad.zipcode company_zip,
            f.book_amt,
            -- null amt_Applied, null gl_date, null closed_date,
            c.act_num,
            c.ch_num,
            c.md_num,
            c.pl_num,
            gcc.segment3 acct_num,
            --null account, null acct_amount,
            rct.customer_trx_id customer_trx_id,
            rct.org_id org_id,
            rct.created_by created_by,
            cd.acct_id customer_number,
            ad.national_terr_id nat_acct_flag,
            f.keycode,
            f.po_number,
            rct.attribute13 sales_rep,                         --f.SALESPERSON
            f.fee_type,
            f.SOURCE,
            f.book_date
     FROM                                    order_fact f
                                          JOIN
                                             time_dim td
                                          ON f.rev_date = td.dim_date
                                       JOIN
                                          cust_dim cd
                                       ON f.cust_id = cd.cust_id
                                    JOIN
                                       account_dim ad
                                    ON cd.acct_id = ad.acct_id
                                 JOIN
                                    event_dim ed
                                 ON f.event_id = ed.event_id
                              JOIN
                                 course_dim c
                              ON ed.course_id = c.course_id
                                 AND ed.ops_country = c.country
                           LEFT JOIN
                              gk_territory gt
                           ON cd.zipcode BETWEEN gt.zip_start AND gt.zip_end
                              AND gt.territory_type = 'OB'
                        LEFT JOIN
                           ra_customer_trx_all@r12prd rct
                        ON f.oracle_trx_num = rct.trx_number
                     LEFT JOIN
                        hr_operating_units@r12prd hou
                     ON rct.org_id = hou.organization_id
                  LEFT JOIN
                     ra_cust_trx_types_all@r12prd rctt
                  ON rct.cust_trx_type_id = rctt.cust_trx_type_id
                     AND rct.org_id = rctt.org_id
               LEFT JOIN
                  mtl_system_items_b@r12prd msi
               ON c.oracle_item_id = msi.inventory_item_id
            JOIN
               gl_code_combinations@r12prd gcc
            ON msi.sales_account = gcc.code_combination_id
    WHERE       attendee_type = 'Nexient'
            AND rev_date >= '01-JAN-2010'
            --  and rctl.line_Type = 'LINE'
            -- and f.ENROLL_ID = 'Q6UJ9A3UNUQA'
            AND msi.organization_id = 88
            -- decode(upper(country_in), 'CANADA', 103, 101)
            AND msi.invoiceable_item_flag = 'Y'
            AND msi.invoice_enabled_flag = 'Y'
   UNION
   SELECT   td.dim_period_name rev_period_name,
            noo.operating_unit,
            noo.inv_type,
            noo.trx_type,
            noo.inv_num,
            noo.order_num,
            noo.rev_start_date,
            noo.customer_name customer_name,
            noo.product,
            noo.person_id,
            noo.event_id,
            noo.inventory_item_id oracle_item_id,
            NULL city,
            NULL province,
            NULL zipcode,
            noo.company_city,
            noo.company_province,
            noo.company_zip,
            noo.rev_amount,
            noo.act,
            noo.ch,
            noo.MOD,
            noo.pl,
            noo.acct,
            noo.customer_trx_id,
            noo.org_id,
            noo.created_by,
            noo.customer_number,
            NULL nat_acct_flag,
            NULL keycode,
            noo.purchase_order po_number,
            sales_rep,
            NULL fee_type,
            NULL SOURCE,
            noo.order_date
     FROM      gk_nxt_ora_orders_v@r12prd noo
            JOIN
               time_dim td
            ON noo.rev_start_date = td.dim_date;


