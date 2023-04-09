DROP VIEW GKDW.GK_MTM_LOCATION_V;

/* Formatted on 29/01/2021 11:32:53 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_MTM_LOCATION_V
(
   FACILITY_DESC,
   EVXFACILITYID,
   FACILITYNAME,
   FACILITYCODE
)
AS
   SELECT   'GK' facility_desc,
            evxfacilityid,
            facilityname,
            facilitycode
     FROM   slxdw.evxfacility
    WHERE   UPPER (facilityname) LIKE 'GLOBAL KNOWLEDGE%'
   UNION
   SELECT   'MICRO',
            evxfacilityid,
            facilityname,
            facilitycode
     FROM   slxdw.evxfacility
    WHERE   UPPER (facilityname) LIKE 'MICROTEK%'
   UNION
   SELECT   'OTHER',
            evxfacilityid,
            facilityname,
            facilitycode
     FROM   slxdw.evxfacility
    WHERE   UPPER (facilityname) NOT LIKE 'GLOBAL KNOWLEDGE%'
            AND UPPER (facilityname) NOT LIKE 'MICROTEK%';


