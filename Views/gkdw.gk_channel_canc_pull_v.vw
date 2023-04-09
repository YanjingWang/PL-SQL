DROP VIEW GKDW.GK_CHANNEL_CANC_PULL_V;

/* Formatted on 29/01/2021 11:40:59 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CHANNEL_CANC_PULL_V
(
   EVXEVENROLLID,
   CREATEDATE,
   EVXEVENTID,
   COURSECODE,
   STARTDATE,
   STARTTIME,
   ENDDATE,
   ENDTIME,
   EVENTNAME,
   CONTACTID,
   FIRSTNAME,
   LASTNAME,
   EMAIL,
   EVXFACILITYID,
   ENROLLSTATUS,
   CHANNEL_KEYCODE,
   EVENTTYPE,
   FACILITYNAME,
   FACILITYADDRESS1,
   FACILITYADDRESS2,
   FACILITYCITY,
   FACILITYSTATE,
   FACILITYPOSTAL,
   EVXEVTICKETID,
   HVXUSERID,
   ENROLLSTATUSDATE,
   ENROLLSTATUSDESC,
   CHANNEL_EMAIL,
   CHANNEL_PHONE,
   CHANNEL_CC1_EMAIL,
   CHANNEL_CC2_EMAIL
)
AS
   SELECT   ce.*,
            cp.channel_email,
            cp.channel_phone,
            cp.channel_cc1_email,
            cp.channel_cc2_email
     FROM      gk_channel_canc_email_mv ce
            INNER JOIN
               gk_channel_partner_conf cp
            ON ce.channel_keycode = cp.channel_keycode
    WHERE   NOT EXISTS (SELECT   1
                          FROM   gk_hp_onsite_lookup hl
                         WHERE   ce.evxeventid = hl.evxeventid)
            AND (enrollstatusdesc = 'EVENT CANCELLATION'
                 OR SUBSTR (enrollstatusdesc, 1, 12) = 'CANCELLATION')
   UNION
   SELECT   ce.*,
            cp.channel_email,
            cp.channel_phone,
            cp.channel_cc1_email,
            cp.channel_cc2_email
     FROM         gk_channel_canc_email_mv ce
               INNER JOIN
                  gk_hp_onsite_lookup hl
               ON ce.evxeventid = hl.evxeventid
            INNER JOIN
               gk_channel_partner_conf cp
            ON cp.channel_keycode = 'C09901018'
    WHERE   (enrollstatusdesc = 'EVENT CANCELLATION'
             OR SUBSTR (enrollstatusdesc, 1, 12) = 'CANCELLATION');


