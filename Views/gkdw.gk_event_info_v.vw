DROP VIEW GKDW.GK_EVENT_INFO_V;

/* Formatted on 29/01/2021 11:37:01 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_EVENT_INFO_V
(
   EVXEVENTID,
   EVXCOURSEID,
   COURSECODE,
   EVENTNAME,
   EVENTSTATUS,
   EVENTTYPE,
   STARTDATE,
   STARTTIME,
   ENDDATE,
   ENDTIME,
   EVXFACILITYID,
   FACILITYACCOUNTID,
   FACILITYCONTACTID,
   FACILITYREGIONMETRO,
   CAP,
   OPS_COUNTRY
)
AS
   SELECT   "EVXEVENTID",
            "EVXCOURSEID",
            "COURSECODE",
            "EVENTNAME",
            "EVENTSTATUS",
            "EVENTTYPE",
            "STARTDATE",
            "STARTTIME",
            "ENDDATE",
            "ENDTIME",
            "EVXFACILITYID",
            "FACILITYACCOUNTID",
            "FACILITYCONTACTID",
            "FACILITYREGIONMETRO",
            "CAP",
            "OPS_COUNTRY"
     FROM   gk_event_info_v@slx;


