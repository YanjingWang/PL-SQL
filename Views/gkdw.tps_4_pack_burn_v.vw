DROP VIEW GKDW.TPS_4_PACK_BURN_V;

/* Formatted on 29/01/2021 11:22:22 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.TPS_4_PACK_BURN_V
(
   EVXPPCARDID,
   SOLDBYUSER,
   TRANSDATE,
   CARDSHORTCODE,
   CARDSTATUS,
   BILLTOCOUNTRY,
   CARDTYPE,
   EVENTPASSCOUNTAVAILABLE,
   EVENTPASSCOUNTREDEEMED,
   EVENTPASSCOUNTTOTAL,
   ISSUEDTOCONTACT,
   ISSUEDTOACCOUNT,
   VALUEPURCHASEDBASE,
   VALUEREDEEMEDBASE,
   VALUEBALANCEBASE,
   TRANSTYPE,
   VALUEPREPAYBASE,
   TAX_AMT,
   BOOK_AMT,
   ENROLL_ID,
   ENROLL_STAT,
   ENROLL_DATE,
   REV_DATE,
   PROD_NAME,
   CH_NUM,
   MD_NUM,
   PL_NUM,
   CREATE_USER,
   BILLING_ZIP,
   STUDENT_ZIP,
   DELIVERY_ZIP,
   PROVINCE,
   SALES_REP,
   EVXEVENTID,
   COURSE_CODE
)
AS
     SELECT   ep.evxppcardid,
              eo.soldbyuser,
              TRUNC (et.transdate) transdate,
              cardshortcode,
              cardstatus,
              eo.billtocountry,
              cardtype,
              eventpasscountavailable,
              eventpasscountredeemed,
              eventpasscounttotal,
              issuedtocontact,
              issuedtoaccount,
              valuepurchasedbase,
              valueredeemedbase,
              valuebalancebase,
              et.transtype,
              et.valueprepaybase,
              NVL (
                 CASE et.transtype
                    WHEN 'Redeemed' THEN (qb.taxamount) * -1
                    ELSE qb.taxamount
                 END,
                 es.taxtotal
              )
                 tax_amt,
              NVL (
                 CASE et.transtype
                    WHEN 'Redeemed' THEN et.valueprepaybase + qb.taxamount
                    ELSE et.valueprepaybase - qb.taxamount
                 END,
                 es.totalnotax
              )
                 book_amt,
              NVL (qb.evxevenrollid, es.evxsoid) enroll_id,
              NVL (eh.enrollstatus, sostatus) enroll_stat,
              eb.createdate enroll_date,
              NVL (ee.startdate, es.createdate) rev_date,
              NVL (ee.coursename, esd.productname) prod_name,
              NVL (cd.ch_num, pd.ch_num) ch_num,
              NVL (cd.md_num, pd.md_num) md_num,
              NVL (cd.pl_num, pd.pl_num) pl_num,
              NVL (u1.username, u2.username) create_user,
              NVL (c1.zipcode, es.billtopostal) billing_zip,
              NVL (c2.zipcode, es.orderedbypostal) student_zip,
              NVL (ee.facilitypostal, es.shiptopostal) delivery_zip,
              c2.province,
              CASE
                 WHEN pp.osr_rep_name IS NOT NULL THEN pp.osr_rep_name
                 WHEN pp.cam_rep_name IS NOT NULL THEN pp.cam_rep_name
                 WHEN pp.ob_rep_name IS NOT NULL THEN pp.ob_rep_name
                 WHEN pp.icam_rep_name IS NOT NULL THEN pp.icam_rep_name
                 WHEN pp.iam_rep_name IS NOT NULL THEN pp.iam_rep_name
                 WHEN pp.tam_rep_name IS NOT NULL THEN pp.tam_rep_name
                 WHEN pp.nam_rep_name IS NOT NULL THEN pp.nam_rep_name
                 WHEN pp.fsd_rep_name IS NOT NULL THEN pp.fsd_rep_name
              END
                 sales_rep,
              ee.evxeventid,
              NVL (cd.course_code, pd.prod_num) course_code
       FROM                                                      slxdw.evxppcard ep
                                                              INNER JOIN
                                                                 gkdw.ppcard_dim pp
                                                              ON ep.evxppcardid =
                                                                    pp.ppcard_id
                                                           INNER JOIN
                                                              slxdw.evxso eo
                                                           ON ep.evxsoid =
                                                                 eo.evxsoid
                                                        INNER JOIN
                                                           slxdw.evxppcard_tx et
                                                        ON ep.evxppcardid =
                                                              et.evxppcardid
                                                           AND et.transdesc !=
                                                                 'Purchase'
                                                     LEFT OUTER JOIN
                                                        slxdw.evxbillpayment eb
                                                     ON et.evxbillpaymentid =
                                                           eb.evxbillpaymentid
                                                  LEFT OUTER JOIN
                                                     slxdw.qg_billingpayment qb
                                                  ON eb.evxbillpaymentid =
                                                        qb.evxbillpaymentid
                                               LEFT OUTER JOIN
                                                  slxdw.evxenrollhx eh
                                               ON qb.evxevenrollid =
                                                     eh.evxevenrollid
                                            LEFT OUTER JOIN
                                               slxdw.evxevticket etk
                                            ON eh.evxevticketid =
                                                  etk.evxevticketid
                                         LEFT OUTER JOIN
                                            gkdw.cust_dim c1
                                         ON etk.billtocontactid = c1.cust_id
                                      LEFT OUTER JOIN
                                         gkdw.cust_dim c2
                                      ON etk.attendeecontactid = c2.cust_id
                                   LEFT OUTER JOIN
                                      slxdw.evxevent ee
                                   ON eh.evxeventid = ee.evxeventid
                                LEFT OUTER JOIN
                                   slxdw.evxso es
                                ON eb.evxsoid = es.evxsoid
                             LEFT OUTER JOIN
                                slxdw.evxsodetail esd
                             ON es.evxsoid = esd.evxsoid
                          LEFT OUTER JOIN
                             slxdw.qg_event qe
                          ON ee.evxeventid = qe.evxeventid
                       LEFT OUTER JOIN
                          gkdw.course_dim cd
                       ON ee.evxcourseid = cd.course_id
                          AND UPPER (TRIM (qe.eventcountry)) = cd.country
                    LEFT OUTER JOIN
                       gkdw.product_dim pd
                    ON esd.productid = pd.product_id
                 LEFT JOIN
                    slxdw.userinfo u1
                 ON etk.createuser = u1.userid
              LEFT JOIN
                 slxdw.userinfo u2
              ON es.createuser = u2.userid
      WHERE   ep.cardstatus != 'Void'
   ORDER BY   1, enroll_id;


