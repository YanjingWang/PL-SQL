DROP VIEW GKDW.GK_PAYMENT_DETAIL_V;

/* Formatted on 29/01/2021 11:30:46 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PAYMENT_DETAIL_V
(
   ENROLL_ID,
   EVENT_ID,
   FEE_TYPE,
   ENROLL_DATE,
   BOOK_DATE,
   START_DATE,
   ENROLL_STATUS,
   PMT_DATE,
   BOOK_AMT,
   PMT_AMT,
   BAL_DUE
)
AS
   SELECT   f.enroll_id,
            e.event_id,
            f.fee_type,
            f.enroll_date,
            f.book_date,
            e.start_date,
            f.enroll_status,
            p.createdate pmt_date,
            ROUND (book_amt, 2) book_amt,
            NVL (p.appliedamount, 0) pmt_amt,
            ROUND (f.book_amt, 2) - NVL (p.appliedamount, 0) bal_due
     FROM            order_fact f
                  INNER JOIN
                     event_dim e
                  ON f.event_id = e.event_id
               INNER JOIN
                  evxev_txfee@slx t
               ON f.txfee_id = t.evxev_txfeeid
            LEFT OUTER JOIN
               evxpmtapplied@slx p
            ON t.evxbillingid = p.evxbillingid
    WHERE   enroll_status != 'Cancelled'
            AND e.event_channel = 'INDIVIDUAL/PUBLIC';


