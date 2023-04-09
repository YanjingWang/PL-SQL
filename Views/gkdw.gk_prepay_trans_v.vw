DROP VIEW GKDW.GK_PREPAY_TRANS_V;

/* Formatted on 29/01/2021 11:30:03 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_PREPAY_TRANS_V
(
   PREPAYCARD,
   SALESORDER,
   TRANSDATE,
   TRANSTYPE,
   ORDER_NUM,
   ORDER_TYPE,
   ACCOUNT,
   CONTACT,
   VALUESTATEMENTTOTAL
)
AS
   SELECT   et.evxppcardid prepaycard,
            ep.evxsoid salesorder,
            transdate,
            transtype,
            NVL (eb.evxsoid, qb.evxevenrollid) order_num,
            DECODE (eb.evxsoid, '', 'Enrollment', 'SalesOrder') order_type,
            NVL (eb.attendeeaccount, es.shiptoaccount) ACCOUNT,
            NVL (eb.attendeecontact, es.shiptocontact) contact,
            valuestatementtotal
     FROM               slxdw.evxppcard_tx et
                     INNER JOIN
                        slxdw.evxppcard ep
                     ON et.evxppcardid = ep.evxppcardid
                  INNER JOIN
                     slxdw.evxbillpayment eb
                  ON et.evxbillpaymentid = eb.evxbillpaymentid
               LEFT OUTER JOIN
                  slxdw.qg_billingpayment qb
               ON eb.evxbillpaymentid = qb.evxbillpaymentid
            LEFT OUTER JOIN
               slxdw.evxso es
            ON eb.evxsoid = es.evxsoid
    WHERE   transtype IN ('Redeemed', 'Redeem Reverse');


