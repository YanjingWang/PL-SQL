DROP MATERIALIZED VIEW GKDW.GK_ONSITE_BOOKINGS_MV;
CREATE MATERIALIZED VIEW GKDW.GK_ONSITE_BOOKINGS_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
LOGGING
NOCOMPRESS
NOPARALLEL
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
AS 
/* Formatted on 29/01/2021 12:24:05 (QP5 v5.115.810.9015) */
SELECT   eh.evxevenrollid enrollid,
         et.actualamount enroll_amt,
         et.actualnetrate net_amt,
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
         ui.username sold_by,
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
         ad.postalcode
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
                                                ON c.accountid = ac.accountid
                                             INNER JOIN
                                                slxdw.address ad
                                             ON ac.addressid = ad.addressid
                                          INNER JOIN
                                             time_dim td
                                          ON td.dim_date =
                                                TRUNC (et.createdate)
                                       INNER JOIN
                                          time_dim td2
                                       ON td2.dim_date = ev.startdate
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
 WHERE   (cd.ch_num = '20' OR (cd.ch_num IS NULL AND ev.eventtype = 'Onsite'))
         AND (et.actualamount < 0 OR et.actualamount > 1);

COMMENT ON MATERIALIZED VIEW GKDW.GK_ONSITE_BOOKINGS_MV IS 'snapshot table for snapshot GKDW.GK_ONSITE_BOOKINGS_MV';

GRANT SELECT ON GKDW.GK_ONSITE_BOOKINGS_MV TO DWHREAD;

