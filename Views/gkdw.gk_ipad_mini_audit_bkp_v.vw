DROP VIEW GKDW.GK_IPAD_MINI_AUDIT_BKP_V;

/* Formatted on 29/01/2021 11:33:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_IPAD_MINI_AUDIT_BKP_V
(
   ENROLL_ID,
   ENROLL_STATUS,
   EVENT_ID,
   ELIGIBLE_FLAG,
   CUST_ID,
   CUST_NAME,
   ACCT_NAME,
   EMAIL,
   ENROLL_DATE,
   BOOK_DATE,
   KEYCODE,
   BOOK_AMT,
   LIST_PRICE,
   PO_NUMBER,
   PAYMENT_METHOD,
   SALESPERSON,
   SALES_REP,
   START_DATE,
   COURSE_CODE,
   SHORT_NAME,
   OPS_COUNTRY,
   PAID_DATE,
   CONFIRM_EMAIL,
   QUALIFY_EMAIL,
   SHIPPING_INFO_RECEIVED,
   GK_PO_NUM,
   PO_LINE_NUM,
   TRACKING_NUM,
   SHIPPED_DATE,
   ZIPCODE,
   STATE,
   OB_TERR_NUM,
   PROMO_ACCEPT,
   PROMO_ITEM,
   REQUEST_FULFILL_DATE,
   SOURCE_CODE,
   REG_CODE,
   EXPIRATION_DATE
)
AS
     SELECT   f.enroll_id,
              f.enroll_status,
              f.event_id,
              CASE WHEN pl.evxeventid IS NOT NULL THEN 'Y' ELSE 'N' END
                 eligible_flag,
              f.cust_id,
              c.first_name || ' ' || c.last_name cust_name,
              c.acct_name,
              c.email,
              f.enroll_date,
              f.book_date,
              f.keycode,
              f.book_amt,
              f.list_price,
              f.po_number,
              f.payment_method,
              f.salesperson,
              f.sales_rep,
              ed.start_date,
              ed.course_code,
              cd.short_name,
              ed.ops_country,
              pp."date_paid" paid_date,
              e1."datesent" confirm_email,
              MAX (e2."datesent") qualify_email,
              MAX (ps."date_received") shipping_info_received,
              pf.po_num gk_po_num,
              pf.po_line_num,
              pf.tracking_num,
              pf.shipped_date,
              c.zipcode,
              UPPER (gt.state) state,
              gt.territory_id ob_terr_num,
              CASE
                 WHEN ps."shipping_accept" = 'True' THEN 'Y'
                 WHEN ps."shipping_decline" IS NOT NULL THEN 'N'
                 ELSE NULL
              END
                 promo_accept,
              ps."item" promo_item,
              pf.request_date fulfill_request_date,
              f.source source_code,
              f.reg_code reg_code,
              prs.status_date expiration_date
       FROM                                    order_fact f
                                            INNER JOIN
                                               event_dim ed
                                            ON f.event_id = ed.event_id
                                         INNER JOIN
                                            course_dim cd
                                         ON ed.course_id = cd.course_id
                                            AND ed.ops_country = cd.country
                                      INNER JOIN
                                         cust_dim c
                                      ON f.cust_id = c.cust_id
                                   LEFT OUTER JOIN
                                      gk_territory gt
                                   ON c.zipcode BETWEEN gt.zip_start
                                                    AND  gt.zip_end
                                      AND gt.territory_type = 'OB'
                                LEFT OUTER JOIN
                                   gk_event_promo_lu pl
                                ON ed.event_id = pl.evxeventid
                                   AND pl.promocode = f.keycode
                             LEFT OUTER JOIN
                                promo_orders_paid@mkt_catalog pp
                             ON f.enroll_id = TRIM (pp."evxenrollid")
                          LEFT OUTER JOIN
                             promo_emails_sent@mkt_catalog e1
                          ON f.enroll_id = TRIM (e1."evxenrollid")
                             AND e1."email_type" = 'CONFIRM'
                       LEFT OUTER JOIN
                          promo_emails_sent@mkt_catalog e2
                       ON f.enroll_id = TRIM (e2."evxenrollid")
                          AND e2."email_type" = 'QUALIFY'
                    LEFT OUTER JOIN
                       promo_shipping@mkt_catalog ps
                    ON f.enroll_id = TRIM (ps."evxenrollid")
                       AND ps."currententry" = 1
                 LEFT JOIN
                    gk_promo_fulfilled_orders pf
                 ON f.enroll_id = pf.enroll_id
              LEFT JOIN
                 gk_promo_status@slx prs
              ON f.enroll_id = prs.evxevenrollid
                 AND prs.step_status = 'Expired'
      --AND prs.step_num = 6
      WHERE   EXISTS (SELECT   1
                        FROM   gk_ipad_promo_keycode k
                       WHERE   f.keycode = k.keycode)
              AND enroll_status != 'Cancelled'
   GROUP BY   f.enroll_id,
              f.enroll_status,
              f.event_id,
              CASE WHEN pl.evxeventid IS NOT NULL THEN 'Y' ELSE 'N' END,
              f.cust_id,
              c.first_name || ' ' || c.last_name,
              c.acct_name,
              c.email,
              f.enroll_date,
              f.book_date,
              f.keycode,
              f.book_amt,
              f.list_price,
              f.po_number,
              f.payment_method,
              f.salesperson,
              f.sales_rep,
              ed.start_date,
              ed.course_code,
              cd.short_name,
              ed.ops_country,
              pp."date_paid",
              e1."datesent",
              pf.po_num,
              pf.po_line_num,
              pf.tracking_num,
              pf.shipped_date,
              c.zipcode,
              UPPER (gt.state),
              gt.territory_id,
              ps."shipping_accept",
              ps."shipping_decline",
              ps."item",
              pf.request_date,
              f.source,
              f.reg_code,
              prs.status_date
   ORDER BY   start_date;


