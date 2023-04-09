DROP VIEW GKDW.GK_FACILITY_TZ_V;

/* Formatted on 29/01/2021 11:36:16 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_FACILITY_TZ_V
(
   EVXFACILITYID,
   EVXTIMEZONEID,
   TZABBREVIATION,
   OFFSETFROMUTC
)
AS
   SELECT   evxfacilityid,
            f.evxtimezoneid,
            tz.tzabbreviation,
            tz.offsetfromutc
     FROM   evxfacility@slx f, evxtimezone@slx tz
    WHERE   f.evxtimezoneid = tz.evxtimezoneid;


