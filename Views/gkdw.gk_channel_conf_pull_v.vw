DROP VIEW GKDW.GK_CHANNEL_CONF_PULL_V;

/* Formatted on 29/01/2021 11:40:55 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_CHANNEL_CONF_PULL_V
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
     FROM      gk_channel_conf_email_mv ce
            INNER JOIN
               gk_channel_partner_conf cp
            ON ce.channel_keycode = cp.channel_keycode
    WHERE   NOT EXISTS (SELECT   1
                          FROM   gk_hp_onsite_lookup hl
                         WHERE   ce.evxeventid = hl.evxeventid)
   UNION
   SELECT   ce.evxevenrollid,
            ce.createdate,
            ce.evxeventid,
            ce.coursecode,
            ce.startdate,
            ce.starttime,
            ce.enddate,
            ce.endtime,
            ce.eventname,
            ce.contactid,
            ce.firstname,
            ce.lastname,
            ce.email,
            ce.evxfacilityid,
            ce.enrollstatus,
            'C09901018' channel_keycode,
            ce.eventtype,
            ce.facilityname,
            ce.facilityaddress1,
            ce.facilityaddress2,
            ce.facilitycity,
            ce.facilitystate,
            ce.facilitypostal,
            ce.evxevticketid,
            ce.hvxuserid,
            ce.enrollstatusdate,
            ce.enrollstatusdesc,
            cp.channel_email,
            cp.channel_phone,
            cp.channel_cc1_email,
            cp.channel_cc2_email
     FROM         gk_channel_conf_email_mv ce
               INNER JOIN
                  gk_hp_onsite_lookup hl
               ON ce.evxeventid = hl.evxeventid
            INNER JOIN
               gk_channel_partner_conf cp
            ON cp.channel_keycode = 'C09901018';


