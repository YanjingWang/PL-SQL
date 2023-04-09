DROP VIEW GKDW.TPS_4_ENT_PACK_BURN_V;

/* Formatted on 29/01/2021 11:22:26 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.TPS_4_ENT_PACK_BURN_V
(
   EVXPPCARDID,
   SOLDBYUSER,
   TRANSDATE,
   CARDSHORTCODE,
   CARDSTATUS,
   BILLTOCOUNTRY,
   CARDTYPE,
   ISSUEDTOCONTACT,
   ISSUEDTOACCOUNT,
   TRANSTYPE,
   PP_TRANS_AMT,
   ENROLL_ID,
   ENROLL_STAT,
   COURSE_CODE,
   EVXEVENTID,
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
   SALES_REP
)
AS
     SELECT   ep.evxppcardid,
              eo.soldbyuser,
              TRUNC (et.transdate) transdate,
              cardshortcode,
              cardstatus,
              eo.billtocountry,
              cardtype,
              issuedtocontact,
              issuedtoaccount,
              et.transtype,
              NVL (
                 CASE et.transtype
                    WHEN 'Redeemed' THEN et.valueprepaybase + qb.TAXAMOUNT
                    ELSE et.valueprepaybase - qb.TAXAMOUNT
                 END,
                 es.TOTALNOTAX
              )
                 pp_trans_amt,
              NVL (qb.evxevenrollid, es.evxsoid) enroll_id,
              NVL (eh.enrollstatus, sostatus) enroll_stat,
              cd.course_code,
              ee.evxeventid,
              eb.createdate enroll_date,
              NVL (ee.startdate, es.createdate) rev_date,
              NVL (ee.coursename, esd.productname) prod_name,
              NVL (cd.CH_NUM, pd.CH_NUM) ch_num,
              NVL (cd.MD_NUM, pd.MD_NUM) md_num,
              NVL (cd.PL_NUM, pd.PL_NUM) pl_num,
              NVL (u1.USERNAME, u2.USERNAME) create_user,
              NVL (c1.ZIPCODE, es.BILLTOPOSTAL) billing_zip,
              NVL (c2.ZIPCODE, es.ORDEREDBYPOSTAL) student_zip,
              NVL (ee.FACILITYPOSTAL, es.SHIPTOPOSTAL) delivery_zip,
              c1.PROVINCE,
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
                 sales_rep
       FROM                                                         slxdw.evxppcard ep
                                                                 INNER JOIN
                                                                    gkdw.ppcard_dim pp
                                                                 ON ep.EVXPPCARDID =
                                                                       pp.PPCARD_ID
                                                              INNER JOIN
                                                                 slxdw.evxso eo
                                                              ON ep.evxsoid =
                                                                    eo.evxsoid
                                                           INNER JOIN
                                                              tps_3_new_pack_v t3
                                                           ON ep.evxppcardid =
                                                                 t3.evxppcardid
                                                        LEFT OUTER JOIN
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
                                            ON eh.EVXEVTICKETID =
                                                  etk.evxevticketid
                                         LEFT OUTER JOIN
                                            gkdw.cust_dim c1
                                         ON etk.billtocontactid = c1.CUST_ID
                                      LEFT OUTER JOIN
                                         gkdw.cust_dim c2
                                      ON etk.attendeecontactid = c2.CUST_ID
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
                          ON ee.EVXEVENTID = qe.evxeventid
                       LEFT OUTER JOIN
                          gkdw.course_dim cd
                       ON ee.EVXCOURSEID = cd.COURSE_ID
                          AND UPPER (TRIM (qe.EVENTCOUNTRY)) = cd.COUNTRY
                    LEFT OUTER JOIN
                       gkdw.product_dim pd
                    ON esd.PRODUCTID = pd.PRODUCT_ID
                 LEFT JOIN
                    slxdw.userinfo u1
                 ON etk.CREATEUSER = u1.USERID
              LEFT JOIN
                 slxdw.userinfo u2
              ON es.CREATEUSER = u2.USERID
      WHERE       ep.cardstatus != 'Void'
              --and qb.evxevenrollid = 'Q6UJ9066GVLZ'
              AND TRUNC (et.transdate) >= '01-JAN-2016'
              AND NVL (cd.CH_NUM, pd.CH_NUM) = '20'
              AND CASE
                    WHEN pp.osr_rep_name IS NOT NULL THEN pp.osr_rep_name
                    WHEN pp.cam_rep_name IS NOT NULL THEN pp.cam_rep_name
                    WHEN pp.ob_rep_name IS NOT NULL THEN pp.ob_rep_name
                    WHEN pp.icam_rep_name IS NOT NULL THEN pp.icam_rep_name
                    WHEN pp.iam_rep_name IS NOT NULL THEN pp.iam_rep_name
                    WHEN pp.tam_rep_name IS NOT NULL THEN pp.tam_rep_name
                    WHEN pp.nam_rep_name IS NOT NULL THEN pp.nam_rep_name
                    WHEN pp.fsd_rep_name IS NOT NULL THEN pp.fsd_rep_name
                 END = t3.sales_rep
   ORDER BY   1, enroll_id;


