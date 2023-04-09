DROP VIEW GKDW.GK_DAILY_BOOKINGS_35_V;

/* Formatted on 29/01/2021 11:38:28 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_DAILY_BOOKINGS_35_V
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
   CONNECTED_V_TO_C
)
AS
   SELECT   eh.evxevenrollid enrollid,
            et.actualamount enroll_amt,
            eh.enrollstatusdesc status_desc,
            TRUNC (et.billingdate) bookdate,
            eh.enrollstatus enroll_status,
            ev.evxeventid event_id,
            ev.facilitycountry country,
            ev.coursecode course_code,
            ev.eventname event_name,
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
            ed.CONNECTED_V_TO_C
     FROM                                                            slxdw.evxenrollhx eh
                                                                  INNER JOIN
                                                                     slxdw.evxev_txfee et
                                                                  ON eh.evxevenrollid =
                                                                        et.evxevenrollid
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


