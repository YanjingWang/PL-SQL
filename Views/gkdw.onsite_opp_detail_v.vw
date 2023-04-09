DROP VIEW GKDW.ONSITE_OPP_DETAIL_V;

/* Formatted on 29/01/2021 11:23:20 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.ONSITE_OPP_DETAIL_V
(
   ENROLLID,
   ENROLL_AMT,
   LIST_PRICE,
   STATUS_DESC,
   BOOKDATE,
   ENROLL_STATUS,
   EVENT_ID,
   COUNTRY,
   COURSE_CODE,
   EVENT_NAME,
   EVENT_TYPE,
   EVENTSTATUS,
   CANCELREASON,
   CANCELDATE,
   ORDER_STATUS,
   CH_VALUE,
   CH_DESC,
   MD_VALUE,
   MD_DESC,
   PL_VALUE,
   PL_DESC,
   REVDATE,
   SALESREP,
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
   OP_CREATE_USER,
   CREATEDATE,
   CHANNEL_MANAGER,
   PARTNER_NAME,
   ENDDATE,
   CITY,
   STATE,
   POSTALCODE,
   ONSITE_APP
)
AS
   SELECT   eh.evxevenrollid enrollid,
            et.actualamount enroll_amt,
            cd.list_price,
            eh.enrollstatusdesc status_desc,
            et.createdate bookdate,
            eh.enrollstatus enroll_status,
            ev.evxeventid event_id,
            ev.facilitycountry country,
            ev.coursecode course_code,
            ev.eventname event_name,
            ev.eventtype event_type,
            ev.eventstatus,
            ev.cancelreason,
            ev.canceldate,
            ot.orderstatus order_status,
            cd.ch_num ch_value,
            cd.course_ch ch_desc,
            cd.md_num md_value,
            cd.course_mod md_desc,
            cd.pl_num pl_value,
            cd.course_pl pl_desc,
            ev.startdate revdate,
            ui.username salesrep,
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
            op.description opportunity_name,
            ui2.username op_create_user,
            et.createdate,
            cp.channel_manager,
            cp.partner_name,
            ev.enddate,
            ad.city,
            ad.state,
            ad.postalcode,
            'Old' onsite_app
     FROM                                                      slxdw.evxenrollhx eh
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
                                                      slxdw.ACCOUNT ac
                                                   ON c.accountid =
                                                         ac.accountid
                                                INNER JOIN
                                                   slxdw.address ad
                                                ON ac.addressid =
                                                      ad.addressid
                                             INNER JOIN
                                                time_dim td
                                             ON td.dim_date =
                                                   TRUNC (et.createdate)
                                          INNER JOIN
                                             time_dim td2
                                          ON td2.dim_date = ev.startdate
                                       INNER JOIN
                                          slxdw.opportunity op
                                       ON ev.opportunityid = op.opportunityid
                                    LEFT OUTER JOIN
                                       slxdw.userinfo ui
                                    ON op.accountmanagerid = ui.userid
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui2
                                 ON op.createuser = ui2.userid
                              LEFT OUTER JOIN
                                 slxdw.oracletx_history ot
                              ON et.evxbillingid = ot.evxbillingid
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
                        slxdw.qg_accprofiletype qa
                     ON qa.accountid = c.accountid
                  LEFT OUTER JOIN
                     slxdw.qg_evticket qe
                  ON qe.evxevticketid = et.evxevticketid
               LEFT OUTER JOIN
                  slxdw.leadsource ls
               ON ls.leadsourceid = qe.leadsourceid
            LEFT OUTER JOIN
               gk_channel_partner cp
            ON ls.abbrevdesc = cp.partner_key_code
    WHERE   (cd.ch_num = '20'
             OR (cd.ch_num IS NULL AND ev.eventtype = 'Onsite'))
            AND (et.actualamount < 0 OR et.actualamount > 1)
            AND et.feetype = 'Ons - Base'
   UNION
   SELECT   eh.evxevenrollid enrollid,
            et.actualamount enroll_amt,
            cd.list_price,
            eh.enrollstatusdesc status_desc,
            et.createdate bookdate,
            eh.enrollstatus enroll_status,
            ev.evxeventid event_id,
            ev.facilitycountry country,
            ev.coursecode course_code,
            ev.eventname event_name,
            ev.eventtype event_type,
            ev.eventstatus,
            ev.cancelreason,
            ev.canceldate,
            ot.orderstatus order_status,
            cd.ch_num ch_value,
            cd.course_ch ch_desc,
            cd.md_num md_value,
            cd.course_mod md_desc,
            cd.pl_num pl_value,
            cd.course_pl pl_desc,
            ev.startdate revdate,
            r.user_fname || ' ' || r.user_lname salesrep,
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
            so.description opportunity_name,
            ui2.username op_create_user,
            et.createdate,
            cp.channel_manager,
            cp.partner_name,
            ev.enddate,
            ad.city,
            ad.state,
            ad.postalcode,
            'New' onsite_app
     FROM                                                      slxdw.evxenrollhx eh
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
                                                      slxdw.ACCOUNT ac
                                                   ON c.accountid =
                                                         ac.accountid
                                                INNER JOIN
                                                   slxdw.address ad
                                                ON ac.addressid =
                                                      ad.addressid
                                             INNER JOIN
                                                time_dim td
                                             ON td.dim_date =
                                                   TRUNC (et.createdate)
                                          INNER JOIN
                                             time_dim td2
                                          ON td2.dim_date = ev.startdate
                                       INNER JOIN
                                          slxdw.gk_sales_opportunity so
                                       ON ev.opportunityid =
                                             so.gk_sales_opportunityid
                                    LEFT OUTER JOIN
                                       slxdw.gk_onsitereq_users r
                                    ON onsitereq_rep = r.gk_onsitereq_usersid
                                 LEFT OUTER JOIN
                                    slxdw.userinfo ui2
                                 ON so.createuser = ui2.userid
                              LEFT OUTER JOIN
                                 slxdw.oracletx_history ot
                              ON et.evxbillingid = ot.evxbillingid
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
                        slxdw.qg_accprofiletype qa
                     ON qa.accountid = c.accountid
                  LEFT OUTER JOIN
                     slxdw.qg_evticket qe
                  ON qe.evxevticketid = et.evxevticketid
               LEFT OUTER JOIN
                  slxdw.leadsource ls
               ON ls.leadsourceid = qe.leadsourceid
            LEFT OUTER JOIN
               gk_channel_partner cp
            ON ls.abbrevdesc = cp.partner_key_code
    WHERE   (cd.ch_num = '20'
             OR (cd.ch_num IS NULL AND ev.eventtype = 'Onsite'))
            AND (et.actualamount < 0 OR et.actualamount > 1)
            AND et.feetype = 'Ons - Base';


