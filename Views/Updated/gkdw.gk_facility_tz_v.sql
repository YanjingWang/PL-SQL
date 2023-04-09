


Create Or Alter View Hold.Gk_Facility_Tz_V
(
   Evxfacilityid,
   Evxtimezoneid,
   Tzabbreviation,
   Offsetfromutc
)
As
   Select   Evxfacilityid,
            F.Evxtimezoneid,
            Tz.Tzabbreviation,
            Tz.Offsetfromutc
     From   Base.Evxfacility F, Base.Evxtimezone Tz
    Where   F.Evxtimezoneid = Tz.Evxtimezoneid;



