DROP VIEW GKDW.GK_CC_DETAILED_V_TEST;

/* Formatted on 29/01/2021 11:41:37 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CC_DETAILED_V_TEST
(
   QG_CCLOGGINGID,
   ORDERID,
   SLX_CONTACT_ID,
   SLX_CONTACT_NAME,
   TRANSACTIONDATE,
   TRANSACTIONID,
   EVXBILLINGID,
   ORDERNUMBER,
   ORACLE_TRX_NUM,
   ORACLE_CUST_NAME,
   ORACLE_CUST_ID,
   CUSTOMER_TRX_ID,
   TRX_NUMBER,
   ORA_TRX_DATE,
   ORDER_TYPE,
   TRANSACTIONAMOUNT,
   CCTRUNCNUM,
   AUTHCODE
)
AS
   SELECT   qg_ccloggingid,
            c.evxevenrollid,
            --   c.createdate,
            c.attendeecontactid SLX_CONTACT_ID,
            c.attendeecontact SLX_CONTACT_NAME,
            c.transactiondate,
            c.transactionid,
            cc.billing_id evxbillingid,
            evoorderid ordernumber,
            GET_ORA_TRX_NUM (f.txfee_id) oracle_trx_num,
            cc.oracle_cust_name,
            cc.oracle_cust_id,
            cc.customer_trx_id,
            cc.trx_number,
            cc.ora_trx_date,
            cc.order_type,
            cc.amount transactionamount,
            cc.cctruncnum,
            c.authcode
     FROM            (SELECT   qg_ccloggingid,
                               c.createdate transactiondate,
                               transactionid,
                               oh.evxbillingid,
                               oh.createdate,
                               oh.evxevenrollid,
                               c.evoorderid,
                               c.authcode,
                               oh.CC_AUTHORIZATIONNUMBER,
                               oh.attendeecontactid,
                               oh.attendeecontact                       --,c.*
                        FROM      slxdw.qg_cclogging c
                               INNER JOIN
                                  slxdw.oracletx_history oh
                               ON c.authcode = oh.CC_AUTHORIZATIONNUMBER
                                  AND oh.cc_number = c.creditcardnumber
                       WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                OR TRUNC (oh.createdate) >=
                                     TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                         )
                               AND (TRUNC (C.createdate) BETWEEN TRUNC(OH.createdate)
                                                                 - 60
                                                             AND  TRUNC (
                                                                     SYSDATE
                                                                  )
                                    AND TRUNC (oh.createdate) BETWEEN TRUNC(c.createdate)
                                                                      - 60
                                                                  AND  TRUNC(SYSDATE))
                      UNION
                      SELECT   qg_ccloggingid,
                               c.createdate transactiondate,
                               transactionid,
                               oh.evxbillingid,
                               oh.createdate,
                               oh.evxevenrollid,
                               c.evoorderid,
                               c.authcode,
                               oh.CC_AUTHORIZATIONNUMBER,
                               oh.attendeecontactid,
                               oh.attendeecontact                       --,c.*
                        FROM      slxdw.qg_cclogging c
                               INNER JOIN
                                  slxdw.oracletx_history oh
                               ON TO_CHAR (c.evoorderid) =
                                     oh.CC_AUTHORIZATIONNUMBER
                                  AND oh.cc_number = c.creditcardnumber
                       WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                OR TRUNC (oh.createdate) >=
                                     TRUNC (SYSDATE) - 60 -- TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                         )
                               AND TRUNC (oh.createdate) BETWEEN TRUNC(c.createdate)
                                                                 - 60
                                                             AND  TRUNC (
                                                                     SYSDATE
                                                                  )
                      UNION
                      SELECT   qg_ccloggingid,
                               c.createdate transactiondate,
                               transactionid,
                               oh.evxbillingid,
                               oh.createdate,
                               oh.evxevenrollid,
                               c.evoorderid,
                               c.authcode,
                               oh.CC_AUTHORIZATIONNUMBER,
                               oh.attendeecontactid,
                               oh.attendeecontact
                        FROM      slxdw.qg_cclogging c
                               INNER JOIN
                                  slxdw.oracletx_history oh
                               ON c.orderid = oh.evxevenrollid
                       WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 -- TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                OR TRUNC (oh.createdate) >=
                                     TRUNC (SYSDATE) - 60 --  TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                         )
                      UNION
                      SELECT   qg_ccloggingid,
                               c.createdate transactiondate,
                               transactionid,
                               oh.evxbillingid,
                               oh.createdate,
                               oh.evxevenrollid,
                               c.evoorderid,
                               c.authcode,
                               oh.CC_AUTHORIZATIONNUMBER,
                               attendeecontactid,
                               attendeecontact                          --,c.*
                        FROM      slxdw.qg_cclogging c
                               INNER JOIN
                                  (SELECT   evxbillingid,
                                            ponumber,
                                            createdate,
                                            evxevenrollid,
                                            attendeecontactid,
                                            attendeecontact,
                                            CC_AUTHORIZATIONNUMBER
                                     FROM   slxdw.oracletx_history h
                                    WHERE   UPPER (ponumber) LIKE '%CC%'
                                            AND NVL (UPPER(ponumber), 0) <>
                                                  '0'
                                            AND TRUNC (createdate) >=
                                                  TRUNC (SYSDATE) - 60 --  TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                            AND NOT EXISTS
                                                  (SELECT   1
                                                     FROM   slxdw.oracletx_history h1
                                                    WHERE   h.oracletxid =
                                                               h1.oracletxid
                                                            AND LENGTH(REGEXP_REPLACE (
                                                                          SUBSTR (
                                                                             REPLACE (
                                                                                ponumber,
                                                                                ' '
                                                                             ),
                                                                             -10
                                                                          ),
                                                                          '[a-zA-Z]',
                                                                          ''
                                                                       )) >=
                                                                  10) -- SR 10/26/2018
                                                                     ) oh
                               ON oh.ponumber LIKE
                                     '%' || TO_CHAR (c.evoorderid) || '%'
                       WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --  TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                OR TRUNC (oh.createdate) >=
                                     TRUNC (SYSDATE) - 60 --  TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                         )
                               AND TRUNC (c.createdate) BETWEEN TRUNC(oh.createdate)
                                                                - 60
                                                            AND  TRUNC (
                                                                    SYSDATE
                                                                 )) c
                  INNER JOIN
                     slxdw.evxev_txfee etf
                  ON etf.evxevenrollid = c.evxevenrollid
                     AND etf.evxbillingid = c.evxbillingid
               INNER JOIN
                  order_fact f
               ON etf.evxevenrollid = f.enroll_id
                  AND etf.evxev_txfeeid = f.txfee_id
            LEFT OUTER JOIN
               gk_cc_trx_details_v@r12prd cc
            ON c.evxevenrollid = cc.SLX_ENROLL_ID
               AND c.evxbillingid = cc.billing_id
    WHERE   TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy')
   UNION
   SELECT   qg_ccloggingid,
            oh.evxevenrollid,
            --     f.creation_date createdate,
            oh.attendeecontactid,
            oh.attendeecontact,
            c.transactiondate,
            c.transactionid,
            cc.billing_id evxbillingid,
            evoorderid ordernumber,
            GET_ORA_TRX_NUM (f.txfee_id) oracle_trx_num,
            cc.oracle_cust_name,
            cc.oracle_cust_id,
            cc.customer_trx_id,
            cc.trx_number,
            cc.ora_trx_date,
            cc.order_type,
            cc.amount transactionamount,
            cc.cctruncnum,
            c.authcode
     FROM                  slxdw.oracletx_history oh
                        INNER JOIN
                           slxdw.evxev_txfee etf
                        ON oh.evxevenrollid = etf.evxevenrollid
                           AND oh.evxbillingid = etf.evxbillingid
                     INNER JOIN
                        order_fact f
                     ON f.txfee_id = etf.evxev_txfeeid
                  INNER JOIN
                     slxdw.evxbillpayment bp
                  ON oh.evxbillingid = bp.evxbillingid
               LEFT OUTER JOIN
                  gk_cc_trx_details_v@r12prd cc
               ON oh.evxevenrollid = cc.SLX_ENROLL_ID
                  AND oh.evxbillingid = cc.billing_id
            LEFT OUTER JOIN
               (SELECT   qg_ccloggingid,
                         c.createdate transactiondate,
                         transactionid,
                         oh.evxbillingid,
                         oh.createdate,
                         oh.evxevenrollid,
                         c.evoorderid,
                         c.authcode,
                         oh.CC_AUTHORIZATIONNUMBER                      --,c.*
                  FROM      slxdw.qg_cclogging c
                         INNER JOIN
                            slxdw.oracletx_history oh
                         ON c.authcode = oh.CC_AUTHORIZATIONNUMBER
                            AND oh.cc_number = c.creditcardnumber
                 WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                          OR TRUNC (oh.createdate) >= TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                                          )
                         AND (TRUNC (C.createdate) BETWEEN TRUNC (
                                                              OH.createdate
                                                           )
                                                           - 60
                                                       AND  TRUNC (SYSDATE)
                              AND TRUNC (oh.createdate) BETWEEN TRUNC(c.createdate)
                                                                - 60
                                                            AND  TRUNC (
                                                                    SYSDATE
                                                                 ))
                UNION
                SELECT   qg_ccloggingid,
                         c.createdate transactiondate,
                         transactionid,
                         oh.evxbillingid,
                         oh.createdate,
                         oh.evxevenrollid,
                         c.evoorderid,
                         c.authcode,
                         oh.CC_AUTHORIZATIONNUMBER                      --,c.*
                  FROM      slxdw.qg_cclogging c
                         INNER JOIN
                            slxdw.oracletx_history oh
                         ON TO_CHAR (c.evoorderid) =
                               oh.CC_AUTHORIZATIONNUMBER
                            AND oh.cc_number = c.creditcardnumber
                 WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --  TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                          OR TRUNC (oh.createdate) >= TRUNC (SYSDATE) - 60 -- TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                                          )
                         AND TRUNC (oh.createdate) BETWEEN TRUNC (
                                                              c.createdate
                                                           )
                                                           - 60
                                                       AND  TRUNC (SYSDATE)
                UNION
                SELECT   qg_ccloggingid,
                         c.createdate transactiondate,
                         transactionid,
                         oh.evxbillingid,
                         oh.createdate,
                         oh.evxevenrollid,
                         c.evoorderid,
                         c.authcode,
                         oh.CC_AUTHORIZATIONNUMBER                      --,c.*
                  FROM      slxdw.qg_cclogging c
                         INNER JOIN
                            slxdw.oracletx_history oh
                         ON c.orderid = oh.evxevenrollid
                 WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 -- TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                          OR TRUNC (oh.createdate) >= TRUNC (SYSDATE) - 60 -- TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                                          )
                UNION
                SELECT   qg_ccloggingid,
                         c.createdate transactiondate,
                         transactionid,
                         oh.evxbillingid,
                         oh.createdate,
                         oh.evxevenrollid,
                         c.evoorderid,
                         c.authcode,
                         oh.CC_AUTHORIZATIONNUMBER
                  FROM      slxdw.qg_cclogging c
                         INNER JOIN
                            (SELECT   evxbillingid,
                                      ponumber,
                                      createdate,
                                      evxevenrollid,
                                      CC_AUTHORIZATIONNUMBER
                               FROM   slxdw.oracletx_history h
                              WHERE   UPPER (ponumber) LIKE '%CC%'
                                      AND NVL (UPPER(ponumber), 0) <> '0'
                                      AND TRUNC (createdate) >=
                                            TRUNC (SYSDATE) - 60 --  TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                      AND NOT EXISTS
                                            (SELECT   1
                                               FROM   slxdw.oracletx_history h1
                                              WHERE   h.oracletxid =
                                                         h1.oracletxid
                                                      AND LENGTH(REGEXP_REPLACE (
                                                                    SUBSTR (
                                                                       REPLACE (
                                                                          ponumber,
                                                                          ' '
                                                                       ),
                                                                       -10
                                                                    ),
                                                                    '[a-zA-Z]',
                                                                    ''
                                                                 )) >= 10) -- SR 10/26/2018
                                                                          )
                            oh
                         ON oh.ponumber LIKE
                               '%' || TO_CHAR (c.evoorderid) || '%'
                 WHERE   (TRUNC (c.createdate) >= TRUNC (SYSDATE) - 60 --    TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                          OR TRUNC (oh.createdate) >= TRUNC (SYSDATE) - 60 --     TO_DATE ('04/01/2018', 'mm/dd/yyyy')
                                                                          )
                         AND TRUNC (c.createdate) BETWEEN TRUNC (
                                                             oh.createdate
                                                          )
                                                          - 60
                                                      AND  TRUNC (SYSDATE)) c
            ON c.evxevenrollid = f.enroll_id
    WHERE   bp.method = 'Credit Card'
            AND TRUNC (oh.createdate) >= TRUNC (SYSDATE) - 60 --TO_DATE ('04/01/2018', 'mm/dd/yyyy');


