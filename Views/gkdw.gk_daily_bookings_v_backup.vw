DROP VIEW GKDW.GK_DAILY_BOOKINGS_V_BACKUP;

/* Formatted on 29/01/2021 11:38:18 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_DAILY_BOOKINGS_V_BACKUP
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
   ORDER_STATUS,
   CH_VALUE,
   CH_DESC,
   MD_VALUE,
   MD_DESC,
   PL_VALUE,
   PL_DESC,
   REVDATE,
   SOLD_BY,
   POSTAL_CODE,
   TERRITORY_ID,
   SALESREP,
   REGION,
   ATTENDEE_NAME,
   ATTENDEE_ACCOUNT,
   ACCT_PROFILE,
   DIM_MONTH,
   DIM_YEAR,
   KEYCODE,
   DIM_MONTH_NUM,
   REV_DIM_MONTH,
   REV_DIM_YEAR,
   REV_DIM_MONTH_NUM,
   OPPORTUNITYID,
   OPPORTUNITY_NAME,
   OPP_CREATE_USER,
   CREATEDATE,
   CHANNEL_MANAGER,
   PARTNER_NAME
)
AS
   SELECT   eh.evxevenrollid enrollid,
            et.actualamount enroll_amt,
            eh.enrollstatusdesc status_desc,
            et.billingdate bookdate,
            eh.enrollstatus enroll_status,
            ev.evxeventid event_id,
            ev.facilitycountry country,
            ev.coursecode course_code,
            ev.eventname event_name,
            ev.eventtype event_type,
            ot.orderstatus order_status,
            cd.ch_num ch_value,
            cd.course_ch ch_desc,
            cd.md_num md_value,
            cd.course_mod md_desc,
            cd.pl_num pl_value,
            cd.course_pl pl_desc,
            CASE
               WHEN ev.startdate < et.billingdate THEN et.billingdate
               ELSE ev.startdate
            END
               revdate,
            et.soldbyuser sold_by,
            a.postalcode postal_code,
            gt.territory_id,
            gt.salesrep,
            gt.region,
            c.firstname || ' ' || c.lastname attendee_name,
            c.ACCOUNT attendee_account,
            qa.profiletype acct_profile,
            td.dim_month,
            td.dim_year,
            ls.abbrevdesc keycode,
            td.dim_month_num,
            td2.dim_month rev_dim_month,
            td2.dim_year rev_dim_year,
            td2.dim_month_num rev_dim_month_num,
            ev.opportunityid,
            NULL opportunity_name,
            NULL opp_create_user,
            et.createdate,
            cp.channel_manager,
            cp.partner_name
     FROM                                             slxdw.evxenrollhx eh
                                                   INNER JOIN
                                                      slxdw.evxev_txfee et
                                                   ON eh.evxevenrollid =
                                                         et.evxevenrollid
                                                INNER JOIN
                                                   slxdw.evxevent ev
                                                ON eh.evxeventid =
                                                      ev.evxeventid
                                             INNER JOIN
                                                oracletx_history@slx ot
                                             ON et.evxbillingid =
                                                   ot.evxbillingid
                                                AND NVL (transactiontype,
                                                         'Invoice') !=
                                                      'Recapture'
                                          INNER JOIN
                                             slxdw.contact c
                                          ON c.contactid =
                                                et.attendeecontactid
                                       INNER JOIN
                                          slxdw.address a
                                       ON a.addressid = c.addressid
                                    INNER JOIN
                                       time_dim td
                                    ON td.dim_date = et.billingdate
                                 INNER JOIN
                                    time_dim td2
                                 ON td2.dim_date =
                                       CASE
                                          WHEN ev.startdate < et.billingdate
                                          THEN
                                             et.billingdate
                                          ELSE
                                             ev.startdate
                                       END
                              LEFT OUTER JOIN
                                 qg_evticket@slx qe
                              ON qe.evxevticketid = et.evxevticketid
                           LEFT OUTER JOIN
                              leadsource@slx ls
                           ON ls.leadsourceid = qe.leadsourceid
                        LEFT OUTER JOIN
                           gk_territory gt
                        ON a.postalcode BETWEEN gt.zip_start AND gt.zip_end
                           AND gt.state = a.state
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
                  qg_accprofiletype@slx qa
               ON qa.accountid = c.accountid
            LEFT OUTER JOIN
               gk_channel_partner cp
            ON ls.abbrevdesc = cp.partner_key_code
    WHERE   (cd.ch_num = '10'
             OR (cd.ch_num IS NULL AND ev.eventtype = 'Open Enrollment'))
   UNION
   SELECT   eh.evxevenrollid,
            et.actualamount,
            eh.enrollstatusdesc,
            et.createdate,
            eh.enrollstatus,
            ev.evxeventid,
            ev.facilitycountry,
            ev.coursecode,
            ev.eventname,
            ev.eventtype,
            ot.orderstatus,
            cd.ch_num,
            cd.course_ch,
            cd.md_num,
            cd.course_mod,
            cd.pl_num,
            cd.course_pl,
            CASE
               WHEN ev.startdate < et.createdate THEN TRUNC (et.createdate)
               ELSE ev.startdate
            END
               revdate,
            ui.username,
            NULL,
            NULL,
            NULL,
            NULL,
            c.firstname || ' ' || c.lastname,
            c.ACCOUNT attendee_account,
            qa.profiletype acct_profile,
            td.dim_month,
            td.dim_year,
            ls.abbrevdesc keycode,
            td.dim_month_num,
            td2.dim_month,
            td2.dim_year,
            td2.dim_month_num,
            ev.opportunityid,
            op.description,
            ui2.username,
            et.createdate,
            cp.channel_manager,
            cp.partner_name
     FROM                                                slxdw.evxenrollhx eh
                                                      INNER JOIN
                                                         slxdw.evxev_txfee et
                                                      ON eh.evxevenrollid =
                                                            et.evxevenrollid
                                                   INNER JOIN
                                                      slxdw.evxevent ev
                                                   ON eh.evxeventid =
                                                         ev.evxeventid
                                                INNER JOIN
                                                   slxdw.contact c
                                                ON c.contactid =
                                                      et.attendeecontactid
                                             INNER JOIN
                                                time_dim td
                                             ON td.dim_date =
                                                   TRUNC (et.createdate)
                                          INNER JOIN
                                             time_dim td2
                                          ON td2.dim_date =
                                                CASE
                                                   WHEN ev.startdate <
                                                           et.createdate
                                                   THEN
                                                      TRUNC (et.createdate)
                                                   ELSE
                                                      ev.startdate
                                                END
                                       LEFT OUTER JOIN
                                          slxdw.opportunity op
                                       ON ev.opportunityid = op.opportunityid
                                    LEFT OUTER JOIN
                                       slxdw.userinfo ui
                                    ON op.accountmanagerid = ui.userid
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui2
                                 ON op.createuser = ui2.userid
                              LEFT OUTER JOIN
                                 oracletx_history@slx ot
                              ON et.evxbillingid = ot.evxbillingid
                                 AND NVL (transactiontype, 'Invoice') !=
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
                        qg_accprofiletype@slx qa
                     ON qa.accountid = c.accountid
                  LEFT OUTER JOIN
                     qg_evticket@slx qe
                  ON qe.evxevticketid = et.evxevticketid
               LEFT OUTER JOIN
                  leadsource@slx ls
               ON ls.leadsourceid = qe.leadsourceid
            LEFT OUTER JOIN
               gk_channel_partner cp
            ON ls.abbrevdesc = cp.partner_key_code
    WHERE   (cd.ch_num = '20'
             OR (cd.ch_num IS NULL AND ev.eventtype = 'Onsite'))
            AND (et.actualamount < 0 OR et.actualamount > 1)
            AND NOT EXISTS (SELECT   1
                              FROM   gk_sem_onsite
                             WHERE   evxevenrollid = eh.evxevenrollid)
   UNION
   SELECT   es.evxsoid,
            totalnotax,
            NULL,
            es.shippeddate,
            --es.createdate,esd.detailtype,
            es.sostatus,
            esd.productid,
            es.shiptocountry,
            ep.prod_num,
            ep.prod_name,
            es.sotype,
            oh.orderstatus,
            ep.ch_num,
            ep.prod_channel,
            ep.md_num,
            ep.prod_modality,
            ep.pl_num,
            ep.prod_line,
            es.shippeddate revdate,
            es.soldbyuser,
            es.shiptopostal postal_code,
            gt.territory_id,
            gt.salesrep,
            gt.region,
            esd.shiptocontact attendee_name,
            esd.shiptoaccount attendee_account,
            NULL,
            td.dim_month,
            td.dim_year,
            ls.abbrevdesc keycode,
            td.dim_month_num,
            td2.dim_month,
            td2.dim_year,
            td2.dim_month_num,
            NULL,
            NULL,
            NULL,
            es.createdate,
            cp.channel_manager,
            cp.partner_name
     FROM                              evxso es
                                    INNER JOIN
                                       evxsodetail esd
                                    ON es.evxsoid = esd.evxsoid
                                 INNER JOIN
                                    time_dim td
                                 ON td.dim_date = TRUNC (es.createdate)
                              LEFT OUTER JOIN
                                 time_dim td2
                              ON td2.dim_date = TRUNC (es.shippeddate)
                           LEFT OUTER JOIN
                              qg_evticket@slx qe
                           ON qe.evxevticketid = esd.evxevticketid
                        LEFT OUTER JOIN
                           leadsource@slx ls
                        ON ls.leadsourceid = qe.leadsourceid
                     LEFT OUTER JOIN
                        gk_territory gt
                     ON esd.shiptopostal BETWEEN gt.zip_start AND gt.zip_end
                        AND gt.state = esd.shiptostate
                  LEFT OUTER JOIN
                     product_dim ep
                  ON esd.productid = ep.product_id
               LEFT OUTER JOIN
                  oracletx_history@slx oh
               ON es.evxsoid = oh.evxevenrollid
            LEFT OUTER JOIN
               gk_channel_partner cp
            ON ls.abbrevdesc = cp.partner_key_code
    WHERE   sotype = 'Standard' AND es.sostatus = 'Shipped';


