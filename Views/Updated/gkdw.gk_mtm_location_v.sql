


Create Or Alter View Hold.Gk_Mtm_Location_V
(
   Facility_Desc,
   Evxfacilityid,
   Facilityname,
   Facilitycode
)
As
   Select   'Gk' Facility_Desc,
            Evxfacilityid,
            Facilityname,
            Facilitycode
     From   Base.Evxfacility
    Where   Upper (Facilityname) Like 'Global Knowledge%'
   Union
   Select   'Micro',
            Evxfacilityid,
            Facilityname,
            Facilitycode
     From   Base.Evxfacility
    Where   Upper (Facilityname) Like 'Microtek%'
   Union
   Select   'Other',
            Evxfacilityid,
            Facilityname,
            Facilitycode
     From   Base.Evxfacility
    Where   Upper (Facilityname) Not Like 'Global Knowledge%'
            And Upper (Facilityname) Not Like 'Microtek%';



