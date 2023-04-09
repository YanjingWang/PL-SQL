DROP VIEW GKDW.GK_DAILY_BOOKINGS_V;

/* Formatted on 29/01/2021 11:38:23 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_DAILY_BOOKINGS_V
(
   ENROLLID,
   ENROLL_AMT,
   STATUS_DESC,
   BOOKDATE,
   ENROLL_STATUS,
   EVENT_ID,
   COUNTRY,
   COURSE_CODE,
   EVENT_NAME,
   EVENT_TYPE,
   CH_VALUE,
   CH_DESC,
   MD_VALUE,
   MD_DESC,
   PL_VALUE,
   PL_DESC,
   REVDATE,
   DIM_YEAR,
   DIM_MONTH_NUM,
   REV_DIM_YEAR,
   REV_DIM_MONTH_NUM,
   ORDERSTATUS,
   PPCARD_ID,
   CARD_TYPE,
   COURSE_DESC,
   ITBT,
   COURSE_TYPE,
   CREATE_DATE,
   SOURCE,
   ATTENDEETYPE,
   ATTENDEEACCOUNTID,
   ATTENDEEACCOUNT,
   PONUMBER,
   PAYMENT_METHOD,
   EVXEV_TXFEEID,
   CREATE_USER,
   BILLING_ZIP,
   STUDENT_ZIP,
   DELIVERY_ZIP,
   SOLDBYUSER,
   STUDENT_EMAIL,
   OB_REP_NAME,
   KEY_CODE,
   PARTNER_NAME,
   CONNECTED_C,
   CONNECTED_V_TO_C,
   CARD_SHORT_CODE,
   LIST_PRICE
)
AS
   SELECT   eh.evxevenrollid enrollid,
            et.actualamount enroll_amt,
            eh.enrollstatusdesc status_desc,
            TRUNC (et.billingdate) bookdate,
            eh.enrollstatus enroll_status,
            ev.evxeventid event_id,
            CASE
               WHEN cd.md_num IN ('20', '33', '42', '32', '44')
                    AND ot.source = 'CA_OPS'
               THEN
                  'Canada'
               WHEN cd.md_num IN ('20', '33', '42', '32', '44')
               THEN
                  'USA'
               ELSE
                  ev.facilitycountry
            END
               country,                            --  ADDED BY JD ON 11/13/13
            ev.coursecode course_code,
            ev.eventname event_name,
            ev.eventtype event_type,
            cd.ch_num ch_value,
            cd.course_ch ch_desc,
            cd.md_num md_value,
            cd.course_mod md_desc,
            cd.pl_num pl_value,
            cd.course_pl pl_desc,
            CASE
               WHEN cd.md_num IN ('32', '33', '44')
               THEN
                  TRUNC (et.billingdate)
               WHEN ev.startdate < et.billingdate
               THEN
                  TRUNC (et.billingdate)
               ELSE
                  TRUNC (ev.startdate)
            END
               revdate,
            td.dim_year,
            td.dim_month_num,
            td2.dim_year rev_dim_year,
            td2.dim_month_num rev_dim_month_num,
            ot.orderstatus,
            bp.evxppcardid ppcard_id,
            pp.cardtype card_type,
            cd.course_desc,
            cd.itbt,
            cd.COURSE_TYPE,
            et.createdate create_date,
            qe.SOURCE,
            tkt.attendeetype,
            et.attendeeaccountid,
            et.attendeeaccount,
            tkt.ponumber,
            bp.method payment_method,
            et.evxev_txfeeid,
            u.username create_user,
            c.zipcode billing_zip,
            c1.zipcode student_zip,
            ev.facilitypostal delivery_zip,
            tkt.soldbyuser,
            c1.email student_email,
            u1.username ob_rep_name,
            le.ABBREVDESC key_code,
            gcp.PARTNER_NAME,
            ed.CONNECTED_C,
            ed.CONNECTED_V_TO_C,
            pp.CardShortCode,
            f.list_price
     FROM                                                               slxdw.evxenrollhx eh
                                                                     INNER JOIN
                                                                        slxdw.evxev_txfee et
                                                                     ON eh.evxevenrollid =
                                                                           et.evxevenrollid
                                                                  LEFT JOIN
                                                                     order_fact f
                                                                  ON eh.evxevenrollid =
                                                                        f.enroll_id
                                                                     AND f.txfee_id =
                                                                           et.evxev_txfeeid
                                                               INNER JOIN
                                                                  slxdw.evxevticket tkt
                                                               ON et.evxevticketid =
                                                                     tkt.evxevticketid
                                                            INNER JOIN
                                                               slxdw.evxevent ev
                                                            ON eh.evxeventid =
                                                                  ev.evxeventid
                                                         LEFT OUTER JOIN
                                                            cust_dim c
                                                         ON c.cust_id =
                                                               et.billtocontactid
                                                      INNER JOIN
                                                         cust_dim c1
                                                      ON c1.cust_id =
                                                            et.attendeecontactid
                                                   INNER JOIN
                                                      oracletx_history@slx ot
                                                   ON et.evxbillingid =
                                                         ot.evxbillingid
                                                      AND NVL (
                                                            transactiontype,
                                                            'Invoice'
                                                         ) != 'Recapture'
                                                INNER JOIN
                                                   time_dim td
                                                ON td.dim_date =
                                                      TRUNC (et.billingdate)
                                             --       inner join time_dim td2 on td2.dim_date = case when ev.startdate < et.billingdate then et.billingdate else ev.startdate end
                                             INNER JOIN
                                                slxdw.userinfo u
                                             ON et.createuser = u.userid
                                          LEFT OUTER JOIN
                                             event_dim ed
                                          ON ev.evxeventid = ed.event_id
                                       LEFT OUTER JOIN
                                          course_dim cd
                                       ON ed.course_id = cd.course_id
                                          AND DECODE (UPPER (ed.country),
                                                      'CANADA', 'CANADA',
                                                      'USA') = cd.country
                                    LEFT OUTER JOIN
                                       slxdw.evxbillpayment bp
                                    ON et.evxbillingid = bp.evxbillingid
                                 LEFT OUTER JOIN
                                    slxdw.evxppcard pp
                                 ON bp.evxppcardid = pp.evxppcardid
                              LEFT OUTER JOIN
                                 slxdw.qg_evenroll qe
                              ON eh.evxevenrollid = qe.evxevenrollid
                           LEFT OUTER JOIN
                              slxdw.qg_contact qc
                           ON et.attendeecontactid = qc.contactid
                        LEFT OUTER JOIN
                           slxdw.userinfo u1
                        ON qc.ob_rep_id = u1.userid
                     INNER JOIN
                        slxdw.qg_evticket qet
                     ON qet.evxevticketid = et.evxevticketid
                  LEFT OUTER JOIN
                     slxdw.leadsource le
                  ON le.leadsourceid = qet.leadsourceid
               LEFT OUTER JOIN
                  gk_channel_partner gcp
               ON gcp.PARTNER_KEY_CODE = le.ABBREVDESC
            INNER JOIN
               time_dim td2
            ON td2.dim_date =
                  CASE
                     WHEN cd.md_num IN ('32', '33', '44')
                     THEN
                        TRUNC (et.billingdate)
                     WHEN ev.startdate < et.billingdate
                     THEN
                        TRUNC (et.billingdate)
                     ELSE
                        TRUNC (ev.startdate)
                  END
    WHERE   (cd.ch_num IN ('10', '40')
             OR (cd.ch_num IS NULL
                 AND ev.eventtype IN ('Open Enrollment', 'Reseller')))
   UNION
   SELECT   eh.evxevenrollid,
            et.actualamount,
            eh.enrollstatusdesc,
            TRUNC (et.createdate),
            eh.enrollstatus,
            ev.evxeventid,
            ev.facilitycountry,
            ev.coursecode,
            ev.eventname,
            ev.eventtype,
            cd.ch_num,
            cd.course_ch,
            cd.md_num,
            cd.course_mod,
            cd.pl_num,
            cd.course_pl,
            CASE
               WHEN ev.startdate < et.createdate THEN TRUNC (et.createdate)
               ELSE TRUNC (ev.startdate)
            END
               revdate,
            td.dim_year,
            td.dim_month_num,
            td2.dim_year,
            td2.dim_month_num,
            ot.orderstatus,
            bp.evxppcardid ppcard_id,
            pp.cardtype card_type,
            cd.course_desc,
            cd.itbt,
            cd.COURSE_TYPE,
            et.createdate create_date,
            qe.SOURCE,
            tkt.attendeetype,
            et.attendeeaccountid,
            et.attendeeaccount,
            tkt.ponumber,
            bp.method payment_method,
            et.evxev_txfeeid,
            u.username create_user,
            c.zipcode billing_zip,
            c1.zipcode student_zip,
            ev.facilitypostal delivery_zip,
            tkt.soldbyuser,
            c1.email,
            u1.username,
            le.ABBREVDESC,
            gcp.PARTNER_NAME,
            ed.CONNECTED_C,
            ed.CONNECTED_V_TO_C,
            pp.CardShortCode,
            f.list_price
     FROM                                                               slxdw.evxenrollhx eh
                                                                     INNER JOIN
                                                                        slxdw.evxev_txfee et
                                                                     ON eh.evxevenrollid =
                                                                           et.evxevenrollid
                                                                  LEFT JOIN
                                                                     order_fact f
                                                                  ON eh.evxevenrollid =
                                                                        f.enroll_id
                                                                     AND f.txfee_id =
                                                                           et.evxev_txfeeid
                                                               INNER JOIN
                                                                  slxdw.evxevticket tkt
                                                               ON et.evxevticketid =
                                                                     tkt.evxevticketid
                                                            INNER JOIN
                                                               slxdw.evxevent ev
                                                            ON eh.evxeventid =
                                                                  ev.evxeventid
                                                         LEFT OUTER JOIN
                                                            cust_dim c
                                                         ON c.cust_id =
                                                               et.billtocontactid
                                                      INNER JOIN
                                                         cust_dim c1
                                                      ON c1.cust_id =
                                                            et.attendeecontactid
                                                   INNER JOIN
                                                      time_dim td
                                                   ON td.dim_date =
                                                         TRUNC (
                                                            et.createdate
                                                         )
                                                INNER JOIN
                                                   time_dim td2
                                                ON td2.dim_date =
                                                      CASE
                                                         WHEN ev.startdate <
                                                                 et.createdate
                                                         THEN
                                                            TRUNC (
                                                               et.createdate
                                                            )
                                                         ELSE
                                                            ev.startdate
                                                      END
                                             INNER JOIN
                                                slxdw.userinfo u
                                             ON et.createuser = u.userid
                                          LEFT OUTER JOIN
                                             oracletx_history@slx ot
                                          ON et.evxbillingid =
                                                ot.evxbillingid
                                             AND NVL (transactiontype,
                                                      'Invoice') !=
                                                   'Recapture'
                                       LEFT OUTER JOIN
                                          event_dim ed
                                       ON ev.evxeventid = ed.event_id
                                    LEFT OUTER JOIN
                                       course_dim cd
                                    ON ed.course_id = cd.course_id
                                       AND DECODE (UPPER (ed.country),
                                                   'CANADA', 'CANADA',
                                                   'USA') = cd.country
                                 LEFT OUTER JOIN
                                    slxdw.evxbillpayment bp
                                 ON et.evxbillingid = bp.evxbillingid
                              LEFT OUTER JOIN
                                 slxdw.evxppcard pp
                              ON bp.evxppcardid = pp.evxppcardid
                           LEFT OUTER JOIN
                              slxdw.qg_evenroll qe
                           ON eh.evxevenrollid = qe.evxevenrollid
                        LEFT OUTER JOIN
                           slxdw.qg_contact qc
                        ON et.attendeecontactid = qc.contactid
                     LEFT OUTER JOIN
                        slxdw.userinfo u1
                     ON qc.ob_rep_id = u1.userid
                  INNER JOIN
                     slxdw.qg_evticket qet
                  ON qet.evxevticketid = et.evxevticketid
               LEFT OUTER JOIN
                  slxdw.leadsource le
               ON le.leadsourceid = qet.leadsourceid
            LEFT OUTER JOIN
               gk_channel_partner gcp
            ON gcp.PARTNER_KEY_CODE = le.ABBREVDESC
    WHERE   (cd.ch_num = '20'
             OR (cd.ch_num IS NULL AND ev.eventtype = 'Onsite'))
            AND (et.actualamount < 0 OR et.actualamount > 1)
            AND NOT EXISTS (SELECT   1
                              FROM   gk_sem_onsite
                             WHERE   evxevenrollid = eh.evxevenrollid)
   UNION
   SELECT   es.evxsoid,
            esd.actualnetrate * actualquantityordered,
            NULL,
            TRUNC (es.shippeddate), --totalnotax,es.createdate,esd.detailtype,
            es.sostatus,
            esd.productid,
            es.shiptocountry,
            ep.prod_num,
            ep.prod_name,
            NULL,
            ep.ch_num,
            ep.prod_channel,
            ep.md_num,
            ep.prod_modality,
            ep.pl_num,
            ep.prod_line,
            TRUNC (es.shippeddate) revdate,
            td.dim_year,
            td.dim_month_num,
            td2.dim_year,
            td2.dim_month_num,
            NULL,
            ep.evxppcardid,
            pp.cardtype                                       --oh.orderstatus
                       ,
            NULL course_desc,
            'F' itbt,
            NULL course_type,
            es.createdate create_date,
            es.SOURCE,
            NULL attendeetype,
            es.shiptoaccountid,
            es.shiptoaccount,
            es.purchaseorder,
            bp.method payment_method,
            NULL evxev_txfeeid,
            u.username,
            c.zipcode billing_zip,
            c1.zipcode student_zip,
            c1.zipcode,
            es.soldbyuser,
            c1.email,
            u1.username,
            ls.abbrevdesc,
            gcp.PARTNER_NAME,
            NULL,
            NULL,
            pp.CardShortCode,
            f.book_amt
     FROM                                                   evxso es
                                                         LEFT JOIN
                                                            sales_order_fact f
                                                         ON es.evxsoid =
                                                               f.sales_order_id
                                                      INNER JOIN
                                                         evxsodetail esd
                                                      ON es.evxsoid =
                                                            esd.evxsoid
                                                   INNER JOIN
                                                      cust_dim c
                                                   ON c.cust_id =
                                                         es.billtocontactid
                                                INNER JOIN
                                                   cust_dim c1
                                                ON c1.cust_id =
                                                      es.shiptocontactid
                                             INNER JOIN
                                                time_dim td
                                             ON td.dim_date =
                                                   TRUNC (es.createdate)
                                          INNER JOIN
                                             slxdw.userinfo u
                                          ON es.createuser = u.userid
                                       LEFT OUTER JOIN
                                          time_dim td2
                                       ON td2.dim_date =
                                             TRUNC (es.shippeddate)
                                    LEFT OUTER JOIN
                                       product_dim ep
                                    ON esd.productid = ep.product_id
                                 LEFT OUTER JOIN
                                    slxdw.evxppeventpass ep
                                 ON es.evxsoid = ep.evxevenrollid
                              LEFT OUTER JOIN
                                 slxdw.evxppcard pp
                              ON ep.evxppcardid = pp.evxppcardid
                           LEFT OUTER JOIN
                              slxdw.evxbillpayment bp
                           ON es.evxsoid = bp.evxsoid
                        LEFT OUTER JOIN
                           slxdw.qg_contact qc
                        ON es.shiptocontactid = qc.contactid
                     LEFT OUTER JOIN
                        slxdw.userinfo u1
                     ON qc.ob_rep_id = u1.userid
                  LEFT OUTER JOIN
                     slxdw.QG_CONTACTLEADSOURCE cls
                  ON cls.ITEMID = es.evxsoid
               LEFT JOIN
                  slxdw.LEADSOURCE LS
               ON cLS.LEADSOURCEID = LS.LEADSOURCEID
            LEFT OUTER JOIN
               gk_channel_partner gcp
            ON gcp.PARTNER_KEY_CODE = ls.ABBREVDESC
    WHERE       es.sotype = 'Standard'
            AND es.sostatus = 'Shipped'
            AND ep.prod_num <> '0CLASSFEE'
            AND bp.method <> 'Cancellation'
   UNION
   SELECT   eh.evxevenrollid enrollid,
            et.actualamount enroll_amt,
            eh.enrollstatusdesc status_desc,
            TRUNC (et.billingdate) bookdate,
            eh.enrollstatus enroll_status,
            ev.evxeventid event_id,
            ev.facilitycountry country,
            ev.coursecode course_code,
            ev.eventname event_name,
            ev.eventtype event_type,
            cd.ch_num ch_value,
            cd.course_ch ch_desc,
            cd.md_num md_value,
            cd.course_mod md_desc,
            cd.pl_num pl_value,
            cd.course_pl pl_desc,
            CASE
               WHEN ev.startdate < et.createdate THEN TRUNC (et.createdate)
               ELSE TRUNC (ev.startdate)
            END
               revdate,
            td.dim_year,
            td.dim_month_num,
            td2.dim_year rev_dim_year,
            td2.dim_month_num rev_dim_month_num,
            ot.orderstatus,
            bp.evxppcardid ppcard_id,
            pp.cardtype card_type,
            cd.course_desc,
            cd.itbt,
            cd.COURSE_TYPE,
            et.createdate create_date,
            qe.SOURCE,
            tkt.attendeetype,
            et.attendeeaccountid,
            et.attendeeaccount,
            tkt.ponumber,
            bp.method payment_method,
            et.evxev_txfeeid,
            u.username create_user,
            c.zipcode billing_zip,
            c1.zipcode student_zip,
            ev.facilitypostal delivery_zip,
            tkt.soldbyuser,
            c1.email student_email,
            u1.username ob_rep_name,
            le.ABBREVDESC key_code,
            gcp.PARTNER_NAME,
            ed.CONNECTED_C,
            ed.CONNECTED_V_TO_C,
            pp.CardShortCode,
            f.list_price
     FROM                                                               slxdw.evxenrollhx eh
                                                                     INNER JOIN
                                                                        slxdw.evxev_txfee et
                                                                     ON eh.evxevenrollid =
                                                                           et.evxevenrollid
                                                                  LEFT JOIN
                                                                     order_fact f
                                                                  ON eh.evxevenrollid =
                                                                        f.enroll_id
                                                                     AND f.txfee_id =
                                                                           et.evxev_txfeeid
                                                               INNER JOIN
                                                                  slxdw.evxevticket tkt
                                                               ON et.evxevticketid =
                                                                     tkt.evxevticketid
                                                            INNER JOIN
                                                               slxdw.evxevent ev
                                                            ON eh.evxeventid =
                                                                  ev.evxeventid
                                                         LEFT OUTER JOIN
                                                            gkdw.cust_dim c
                                                         ON c.cust_id =
                                                               et.billtocontactid
                                                      INNER JOIN
                                                         cust_dim c1
                                                      ON c1.cust_id =
                                                            et.attendeecontactid
                                                   INNER JOIN
                                                      oracletx_history@slx ot
                                                   ON et.evxbillingid =
                                                         ot.evxbillingid
                                                      AND NVL (
                                                            transactiontype,
                                                            'Invoice'
                                                         ) != 'Recapture'
                                                INNER JOIN
                                                   time_dim td
                                                ON td.dim_date =
                                                      et.billingdate
                                             INNER JOIN
                                                slxdw.userinfo u
                                             ON et.createuser = u.userid
                                          LEFT OUTER JOIN
                                             event_dim ed
                                          ON ev.evxeventid = ed.event_id
                                       LEFT OUTER JOIN
                                          course_dim cd
                                       ON ed.course_id = cd.course_id
                                          AND DECODE (UPPER (ed.country),
                                                      'CANADA', 'CANADA',
                                                      'USA') = cd.country
                                    LEFT OUTER JOIN
                                       slxdw.evxbillpayment bp
                                    ON et.evxbillingid = bp.evxbillingid
                                 LEFT OUTER JOIN
                                    slxdw.evxppcard pp
                                 ON bp.evxppcardid = pp.evxppcardid
                              LEFT OUTER JOIN
                                 slxdw.qg_evenroll qe
                              ON eh.evxevenrollid = qe.evxevenrollid
                           LEFT OUTER JOIN
                              slxdw.qg_contact qc
                           ON et.attendeecontactid = qc.contactid
                        LEFT OUTER JOIN
                           slxdw.userinfo u1
                        ON qc.ob_rep_id = u1.userid
                     INNER JOIN
                        slxdw.qg_evticket qet
                     ON qet.evxevticketid = et.evxevticketid
                  LEFT OUTER JOIN
                     slxdw.leadsource le
                  ON le.leadsourceid = qet.leadsourceid
               LEFT OUTER JOIN
                  gk_channel_partner gcp
               ON gcp.PARTNER_KEY_CODE = le.ABBREVDESC
            INNER JOIN
               time_dim td2
            ON td2.dim_date =
                  CASE
                     WHEN ev.startdate < et.createdate
                     THEN
                        TRUNC (et.createdate)
                     ELSE
                        ev.startdate
                  END
    WHERE   cd.CH_NUM = '35';


