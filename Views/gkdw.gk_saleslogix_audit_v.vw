DROP VIEW GKDW.GK_SALESLOGIX_AUDIT_V;

/* Formatted on 29/01/2021 11:27:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_SALESLOGIX_AUDIT_V
(
   ENROLL_DATE,
   ENROLL_SO_ID,
   RECORD_TYPE,
   STATUS,
   STATUS_DESC,
   TX_DATE,
   SOLDBYUSER,
   AMOUNT,
   BILL_DATE,
   CONTACT,
   ACCOUNT,
   EVXBILLINGID,
   ORACLETXID,
   ORACLETX_CREATE,
   ORDERTYPE,
   TRANSACTIONTYPE,
   EVXPPCARDID,
   ACTUALAMOUNTLESSTAX,
   TRX_NUMBER,
   NAME,
   TYPE,
   RA_SOURCE,
   FEETYPE,
   METHOD,
   EVXEVTICKETID,
   SOURCE,
   SHIPTOCOUNTRY
)
AS
   SELECT   eh.createdate enroll_date,
            eh.evxevenrollid enroll_so_id,
            'ENROLLMENT' record_type,
            eh.enrollstatus status,
            eh.enrollstatusdesc status_desc,
            et.createdate tx_date,
            et.soldbyuser,
            et.actualamount amount,
            et.billingdate bill_date,
            billtocontact contact,
            et.billtoaccount ACCOUNT,
            et.evxbillingid,
            oh.oracletxid,
            oh.createdate oracletx_create,
            oh.ordertype,
            oh.transactiontype,
            oh.evxppcardid,
            oh.actualamountlesstax,
            rct.trx_number,
            rctt.NAME,
            rctt.TYPE,
            interface_header_context ra_source,
            et.feetype,
            eb.method,
            et.evxevticketid,
            oh.SOURCE,
            ee.eventcountry shiptocountry
     FROM                     evxenrollhx eh
                           INNER JOIN
                              qg_event ee
                           ON eh.evxeventid = ee.evxeventid
                        INNER JOIN
                           evxev_txfee et
                        ON eh.evxevenrollid = et.evxevenrollid
                     INNER JOIN
                        evxbillpayment eb
                     ON et.evxbillingid = eb.evxbillingid
                  INNER JOIN
                     oracletx_history oh
                  ON et.evxevenrollid = oh.evxevenrollid
                     AND et.evxbillingid = oh.evxbillingid
               INNER JOIN
                  ra_customer_trx_all@r12prd rct
               ON     oh.evxevenrollid = rct.interface_header_attribute1
                  AND eb.evxbillingid = rct.interface_header_attribute3
                  AND interface_header_context = 'GK ORDER INTERFACE'
            INNER JOIN
               ra_cust_trx_types_all@r12prd rctt
            ON rct.cust_trx_type_id = rctt.cust_trx_type_id
               AND rct.org_id = rctt.org_id
    WHERE   eh.createdate >= TO_DATE ('10/3/2005', 'mm/dd/yyyy')
   UNION
   SELECT   eh.createdate enroll_date,
            eh.evxevenrollid enroll_so_id,
            'ENROLLMENT' record_type,
            eh.enrollstatus status,
            eh.enrollstatusdesc status_desc,
            et.createdate tx_date,
            et.soldbyuser,
            et.actualamount amount,
            et.billingdate bill_date,
            billtocontact contact,
            et.billtoaccount ACCOUNT,
            et.evxbillingid,
            oh.oracletxid,
            oh.createdate oracletx_create,
            oh.ordertype,
            oh.transactiontype,
            oh.evxppcardid,
            oh.actualamountlesstax,
            rct.trx_number,
            rctt.NAME,
            rctt.TYPE,
            NVL (interface_header_context, 'MANUAL'),
            et.feetype,
            eb.method,
            et.evxevticketid,
            oh.SOURCE,
            ee.eventcountry shiptocountry
     FROM                     evxenrollhx eh
                           INNER JOIN
                              qg_event ee
                           ON eh.evxeventid = ee.evxeventid
                        INNER JOIN
                           evxev_txfee et
                        ON eh.evxevenrollid = et.evxevenrollid
                     INNER JOIN
                        evxbillpayment eb
                     ON et.evxbillingid = eb.evxbillingid
                  INNER JOIN
                     oracletx_history oh
                  ON et.evxevenrollid = oh.evxevenrollid
                     AND et.evxbillingid = oh.evxbillingid
               INNER JOIN
                  ra_customer_trx_all@r12prd rct
               ON     oh.evxevenrollid = rct.interface_header_attribute1
                  AND eb.evxbillingid <> rct.interface_header_attribute3
                  AND interface_header_context IS NULL
            INNER JOIN
               ra_cust_trx_types_all@r12prd rctt
            ON rct.cust_trx_type_id = rctt.cust_trx_type_id
               AND rct.org_id = rctt.org_id
    WHERE   eh.createdate >= TO_DATE ('10/3/2005', 'mm/dd/yyyy')
   UNION
   SELECT   eh.createdate enroll_date,
            eh.evxevenrollid enroll_so_id,
            'ENROLLMENT' record_type,
            eh.enrollstatus status,
            eh.enrollstatusdesc status_desc,
            et.createdate tx_date,
            et.soldbyuser,
            et.actualamount amount,
            et.billingdate bill_date,
            billtocontact contact,
            et.billtoaccount ACCOUNT,
            et.evxbillingid,
            oh.oracletxid,
            oh.createdate oracletx_create,
            oh.ordertype,
            oh.transactiontype,
            oh.evxppcardid,
            oh.actualamountlesstax,
            NULL,
            NULL,
            NULL,
            NULL,
            et.feetype,
            eb.method,
            et.evxevticketid,
            oh.SOURCE,
            ee.eventcountry shiptocountry
     FROM               evxenrollhx eh
                     INNER JOIN
                        qg_event ee
                     ON eh.evxeventid = ee.evxeventid
                  INNER JOIN
                     evxev_txfee et
                  ON eh.evxevenrollid = et.evxevenrollid
               INNER JOIN
                  evxbillpayment eb
               ON et.evxbillingid = eb.evxbillingid
            LEFT OUTER JOIN
               oracletx_history oh
            ON et.evxevenrollid = oh.evxevenrollid
               AND et.evxbillingid = oh.evxbillingid
    WHERE   eh.createdate >= TO_DATE ('10/3/2005', 'mm/dd/yyyy')
            AND NOT EXISTS
                  (SELECT   1
                     FROM   ra_customer_trx_all@r12prd
                    WHERE   interface_header_attribute1 = eh.evxevenrollid)
   UNION
   SELECT   es.createdate,
            es.evxsoid,
            'SALESORDER',
            es.sostatus,
            NULL,
            es.shippeddate,
            es.soldbyuser,
            es.totalnotax,
            eb.createdate,
            eb.receivedfromcontact,
            eb.receivedfromaccount,
            evxbillpaymentid,
            oh.oracletxid,
            oh.createdate,
            oh.ordertype,
            oh.transactiontype,
            oh.evxppcardid,
            oh.actualamountlesstax,
            rct.trx_number,
            rctt.NAME,
            rctt.TYPE,
            interface_header_context,
            NULL,
            eb.method,
            eb.evxevticketid,
            oh.SOURCE,
            es.shiptocountry
     FROM               evxso es
                     LEFT OUTER JOIN
                        evxbillpayment eb
                     ON es.evxsoid = eb.evxsoid
                  LEFT OUTER JOIN
                     oracletx_history oh
                  ON eb.evxsoid = oh.evxeventid
               LEFT OUTER JOIN
                  ra_customer_trx_all@r12prd rct
               ON eb.evxsoid = rct.interface_header_attribute1
            LEFT OUTER JOIN
               ra_cust_trx_types_all@r12prd rctt
            ON rct.cust_trx_type_id = rctt.cust_trx_type_id
               AND rct.org_id = rctt.org_id
    WHERE   recordtype = 'SalesOrder'
            AND es.createdate >= TO_DATE ('10/3/2005', 'mm/dd/yyyy')
   UNION
   SELECT   es.createdate,
            es.evxsoid,
            'PREPAYORDER',
            es.sostatus,
            NULL,
            es.createdate,
            es.soldbyuser,
            es.totalnotax,
            eb.createdate,
            eb.receivedfromcontact,
            eb.receivedfromaccount,
            evxbillpaymentid,
            oh.oracletxid,
            oh.createdate,
            oh.ordertype,
            oh.transactiontype,
            oh.evxevenrollid,
            oh.actualamountlesstax,
            rct.trx_number,
            rctt.NAME,
            rctt.TYPE,
            interface_header_context,
            NULL,
            eb.method,
            eb.evxevticketid,
            oh.SOURCE,
            es.shiptocountry
     FROM               evxso es
                     LEFT OUTER JOIN
                        evxbillpayment eb
                     ON es.evxsoid = eb.evxsoid
                  LEFT OUTER JOIN
                     oracletx_history oh
                  ON eb.evxsoid = oh.evxeventid
               LEFT OUTER JOIN
                  ra_customer_trx_all@r12prd rct
               ON oh.evxevenrollid = rct.interface_header_attribute1
            LEFT OUTER JOIN
               ra_cust_trx_types_all@r12prd rctt
            ON rct.cust_trx_type_id = rctt.cust_trx_type_id
               AND rct.org_id = rctt.org_id
    WHERE   sotype = 'Prepay Card'
            AND es.createdate >= TO_DATE ('10/3/2005', 'mm/dd/yyyy');


