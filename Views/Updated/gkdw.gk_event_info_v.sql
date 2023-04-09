


Create Or Alter View Hold.Gk_Event_Info_V
(
   Evxeventid,
   Evxcourseid,
   Coursecode,
   Eventname,
   Eventstatus,
   Eventtype,
   Startdate,
   Starttime,
   Enddate,
   Endtime,
   Evxfacilityid,
   Facilityaccountid,
   Facilitycontactid,
   Facilityregionmetro,
   Cap,
   Ops_Country
)
As
   Select   [Evxeventid],
            [Evxcourseid],
            [Coursecode],
            [Eventname],
            [Eventstatus],
            [Eventtype],
            [Startdate],
            [Starttime],
            [Enddate],
            [Endtime],
            [Evxfacilityid],
            [Facilityaccountid],
            [Facilitycontactid],
            [Facilityregionmetro],
            [Cap],
            [Ops_Country]
     From   Base.Gk_Event_Info_V;



