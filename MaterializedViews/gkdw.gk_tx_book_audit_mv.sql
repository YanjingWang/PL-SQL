DROP MATERIALIZED VIEW GKDW.GK_TX_BOOK_AUDIT_MV;
CREATE MATERIALIZED VIEW GKDW.GK_TX_BOOK_AUDIT_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
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
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:21:09 (QP5 v5.115.810.9015) */
  SELECT   bookdate,
           source,
           ordertype,
           event_channel,
           event_modality,
           event_prod_line,
           tr_type,
           SUM (tx_cnt) tx_cnt,
           SUM (tx_amt) tx_amt,
           SUM (bk_cnt) bk_cnt,
           SUM (bk_amt) bk_amt,
           method
    FROM   (  SELECT   TRUNC (bookdate) bookdate,
                       CASE
                          WHEN country = 'Canada' THEN 'CA_OPS'
                          ELSE 'US_OPS'
                       END
                          source,
                       CASE
                          WHEN orderstatus IN ('Attended', 'Confirmed')
                          THEN
                             'Invoice'
                          WHEN enroll_status = 'Shipped'
                          THEN
                             'Invoice'
                          WHEN orderstatus = 'Cancelled'
                          THEN
                             'Credit'
                          ELSE
                             enroll_status
                       END
                          ordertype,
                       ch_desc event_channel,
                       md_desc event_modality,
                       pl_desc event_prod_line,
                       'Standard' tr_type,
                       0 tx_cnt,
                       0 tx_amt,
                       COUNT (DISTINCT enrollid) bk_cnt,
                       SUM (ROUND (enroll_amt)) bk_amt,
                       CASE
                          WHEN bp.method = 'Prepay Card'
                               OR bp1.method = 'Prepay Card'
                          THEN
                             'PREPAY'
                          ELSE
                             'STANDARD'
                       END
                          method
                FROM               gk_daily_bookings_v b
                                LEFT OUTER JOIN
                                   evxev_txfee et
                                ON b.EVXEV_TXFEEID = et.EVXEV_TXFEEID
                             LEFT OUTER JOIN
                                evxbilling eb
                             ON et.evxbillingid = eb.evxbillingid
                          LEFT OUTER JOIN
                             evxbillpayment bp
                          ON eb.evxbillingid = bp.evxbillingid
                       LEFT OUTER JOIN
                          evxbillpayment bp1
                       ON b.enrollid = bp1.evxsoid
               WHERE   ch_value = '10'
            GROUP BY   TRUNC (bookdate),
                       CASE
                          WHEN country = 'Canada' THEN 'CA_OPS'
                          ELSE 'US_OPS'
                       END,
                       CASE
                          WHEN orderstatus IN ('Attended', 'Confirmed')
                          THEN
                             'Invoice'
                          WHEN enroll_status = 'Shipped'
                          THEN
                             'Invoice'
                          WHEN orderstatus = 'Cancelled'
                          THEN
                             'Credit'
                          ELSE
                             enroll_status
                       END,
                       ch_desc,
                       md_desc,
                       pl_desc,
                       CASE
                          WHEN bp.method = 'Prepay Card'
                               OR bp1.method = 'Prepay Card'
                          THEN
                             'PREPAY'
                          ELSE
                             'STANDARD'
                       END
            UNION ALL
              SELECT   TRUNC (createdate) bookdate,
                       source,
                       ordertype,
                       c.course_ch,
                       c.course_mod,
                       c.course_pl,
                       CASE
                          WHEN transactiontype = 'Recapture' THEN 'Breakage'
                          ELSE 'Standard'
                       END
                          tr_type,
                       COUNT (evxevenrollid) tx_cnt,
                       SUM (ROUND (actualamountlesstax)) tx_amt,
                       0 bk_cnt,
                       0 bk_amt,
                       CASE
                          WHEN evxppcardid IS NOT NULL THEN 'PREPAY'
                          ELSE 'STANDARD'
                       END
                          method
                FROM         oracletx_history h
                          INNER JOIN
                             event_dim e
                          ON h.evxeventid = e.event_id
                       INNER JOIN
                          course_dim c
                       ON e.course_id = c.course_id AND e.ops_country = c.country
               WHERE   c.ch_num = '10'
                       AND (transactiontype != 'Recapture'
                            OR transactiontype IS NULL)
            GROUP BY   TRUNC (createdate),
                       source,
                       ordertype,
                       c.course_ch,
                       c.course_mod,
                       c.course_pl,
                       CASE
                          WHEN transactiontype = 'Recapture' THEN 'Breakage'
                          ELSE 'Standard'
                       END,
                       CASE
                          WHEN evxppcardid IS NOT NULL THEN 'PREPAY'
                          ELSE 'STANDARD'
                       END
            UNION ALL
              SELECT   TRUNC (createdate) bookdate,
                       h.source,
                       ordertype,
                       p.prod_channel,
                       p.prod_modality,
                       p.prod_line,
                       CASE
                          WHEN transactiontype = 'Recapture' THEN 'Breakage'
                          ELSE 'Standard'
                       END
                          tr_type,
                       COUNT (evxevenrollid) tx_cnt,
                       CASE
                          WHEN ordertype = 'Credit' THEN 0
                          ELSE SUM (ROUND (actualamountlesstax))
                       END
                          tx_amt,
                       0 bk_cnt,
                       0 bk_amt,
                       CASE
                          WHEN evxppcardid IS NOT NULL THEN 'PREPAY'
                          ELSE 'STANDARD'
                       END
                          method
                FROM         oracletx_history h
                          INNER JOIN
                             sales_order_fact s
                          ON h.evxeventid = s.sales_order_id
                       INNER JOIN
                          product_dim p
                       ON s.product_id = p.product_id
               WHERE   p.prod_channel = 'INDIVIDUAL/PUBLIC'
                       AND (transactiontype != 'Recapture'
                            OR transactiontype IS NULL)
            GROUP BY   TRUNC (createdate),
                       h.source,
                       ordertype,
                       p.prod_channel,
                       p.prod_modality,
                       p.prod_line,
                       CASE
                          WHEN transactiontype = 'Recapture' THEN 'Breakage'
                          ELSE 'Standard'
                       END,
                       CASE
                          WHEN evxppcardid IS NOT NULL THEN 'PREPAY'
                          ELSE 'STANDARD'
                       END)
   WHERE   bookdate > TRUNC (SYSDATE) - 30
GROUP BY   bookdate,
           source,
           ordertype,
           event_channel,
           event_modality,
           event_prod_line,
           tr_type,
           method;

COMMENT ON MATERIALIZED VIEW GKDW.GK_TX_BOOK_AUDIT_MV IS 'snapshot table for snapshot GKDW.GK_TX_BOOK_AUDIT_MV';

GRANT SELECT ON GKDW.GK_TX_BOOK_AUDIT_MV TO DWHREAD;

