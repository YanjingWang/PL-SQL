DROP MATERIALIZED VIEW GKDW.GK_CHANNEL_FACILITY_EMAIL_MV;
CREATE MATERIALIZED VIEW GKDW.GK_CHANNEL_FACILITY_EMAIL_MV 
TABLESPACE GDWSML
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          104K
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
/* Formatted on 29/01/2021 12:26:04 (QP5 v5.115.810.9015) */
SELECT   eh.evxevenrollid,
         eh.createdate,
         ee.evxeventid,
         ee.coursecode,
         ee.startdate,
         ee.starttime,
         ee.enddate,
         ee.endtime,
         ee.eventname,
         c.contactid,
         c.firstname,
         c.lastname,
         c.email,
         ee.evxfacilityid,
         cp.channel_email,                                 --cp.channel_email,
         eh.enrollstatus,
         cp.channel_keycode,
         ee.eventtype,
         ee.facilityname,
         ee.facilityaddress1,
         ee.facilityaddress2,
         ee.facilitycity,
         ee.facilitystate,
         ee.facilitypostal,
         cp.channel_phone,
         cp.channel_cc1_email,
         cp.channel_cc2_email
  FROM   evxevenroll@slx ev,
         evxenrollhx@slx eh,
         evxevent@slx ee,
         evxevticket@slx et,
         contact@slx c,
         gk_channel_partner_conf cp,
         evxev_txfee@slx tf
 WHERE       ev.evxevenrollid = eh.evxevenrollid
         AND eh.evxeventid = ee.evxeventid
         AND eh.evxevticketid = et.evxevticketid
         AND et.attendeecontactid = c.contactid
         AND et.leadsourcedesc = cp.channel_keycode
         AND eh.enrollstatusdate >= cp.active_date
         AND et.evxevticketid = tf.evxevticketid
         AND eh.enrollstatus = 'Confirmed'
         AND tf.feetype NOT IN ('Ons - Base', 'Ons - Additional')
UNION
SELECT   eh.evxevenrollid,
         eh.createdate,
         ee.evxeventid,
         ee.coursecode,
         ee.startdate,
         ee.starttime,
         ee.enddate,
         ee.endtime,
         ee.eventname,
         c.contactid,
         c.firstname,
         c.lastname,
         c.email,
         ee.evxfacilityid,
         'HPED-GKResell@hp.com' channel_email,
         eh.enrollstatus,
         'C09901018' channel_keycode,
         ee.eventtype,
         ee.facilityname,
         ee.facilityaddress1,
         ee.facilityaddress2,
         ee.facilitycity,
         ee.facilitystate,
         ee.facilitypostal,
         '1 800 HP CLASS (472 5277)' channel_phone,
         'HPED-GKResell@hp.com' channel_cc1_email,
         'erin.scalia@globalknowledge.com' channel_cc2_email
  FROM   evxevenroll@slx ev,
         evxenrollhx@slx eh,
         evxevent@slx ee,
         evxevticket@slx et,
         evxev_txfee@slx tf,
         contact@slx c,
         gk_hp_onsite_lookup hl
 WHERE       ev.evxevenrollid = eh.evxevenrollid
         AND eh.evxeventid = ee.evxeventid
         AND eh.evxevticketid = et.evxevticketid
         AND et.evxevticketid = tf.evxevticketid
         AND et.attendeecontactid = c.contactid
         AND ee.evxeventid = hl.evxeventid
         AND eh.enrollstatus = 'Confirmed'
         AND tf.feetype NOT IN ('Ons - Base', 'Ons - Additional');

COMMENT ON MATERIALIZED VIEW GKDW.GK_CHANNEL_FACILITY_EMAIL_MV IS 'snapshot table for snapshot GKDW.GK_CHANNEL_FACILITY_EMAIL_MV';

GRANT SELECT ON GKDW.GK_CHANNEL_FACILITY_EMAIL_MV TO DWHREAD;

