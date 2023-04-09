DROP VIEW GKDW.GK_FACILITY_INFO_V;

/* Formatted on 29/01/2021 11:36:20 (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW GKDW.GK_FACILITY_INFO_V
(
   EVXFACILITYID,
   FACILITYNAME,
   FACILITYCODE,
   FACILITYSTATUS,
   VIRTUALFACILITY,
   ADDRESSID,
   ADDRESS1,
   ADDRESS2,
   CITY,
   STATE,
   POSTALCODE,
   COUNTY,
   COUNTRY,
   ACCOUNTID,
   ACCOUNTTYPE,
   ACCOUNT,
   CONTACTID,
   CONTACT_NAME,
   WORKPHONE,
   EMAIL
)
AS
   SELECT   "EVXFACILITYID",
            "FACILITYNAME",
            "FACILITYCODE",
            "FACILITYSTATUS",
            "VIRTUALFACILITY",
            "ADDRESSID",
            "ADDRESS1",
            "ADDRESS2",
            "CITY",
            "STATE",
            "POSTALCODE",
            "COUNTY",
            "COUNTRY",
            "ACCOUNTID",
            "ACCOUNTTYPE",
            "ACCOUNT",
            "CONTACTID",
            "CONTACT_NAME",
            "WORKPHONE",
            "EMAIL"
     FROM   gk_facility_info_v@slx;


