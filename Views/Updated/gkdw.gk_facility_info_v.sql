


Create Or Alter View Hold.Gk_Facility_Info_V
(
   Evxfacilityid,
   Facilityname,
   Facilitycode,
   Facilitystatus,
   Virtualfacility,
   Addressid,
   Address1,
   Address2,
   City,
   State,
   Postalcode,
   County,
   Country,
   Accountid,
   Accounttype,
   Account,
   Contactid,
   Contact_Name,
   Workphone,
   Email
)
As
   Select   [Evxfacilityid],
            [Facilityname],
            [Facilitycode],
            [Facilitystatus],
            [Virtualfacility],
            [Addressid],
            [Address1],
            [Address2],
            [City],
            [State],
            [Postalcode],
            [County],
            [Country],
            [Accountid],
            [Accounttype],
            [Account],
            [Contactid],
            [Contact_Name],
            [Workphone],
            [Email]
     From   Base.Gk_Facility_Info_V;



