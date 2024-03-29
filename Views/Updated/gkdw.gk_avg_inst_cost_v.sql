


Create Or Alter View Hold.Gk_Avg_Inst_Cost_V
(
   Metro_Level,
   Facility_Region_Metro,
   Avg_Hotel_Day,
   Avg_Airfare_Event,
   Avg_Rental_Day
)
As
     Select   Substring(Travel_Level, 1,  1) Metro_Level,
              Facilityregionmetro Facility_Region_Metro,
              Round (Sum (Hotel_Cost) / Sum (Event_Length)) Avg_Hotel_Day,
              Round (Sum (Airfare_Cost) / Count (Evxeventid)) Avg_Airfare_Event,
              Round (Sum (Rental_Cost) / Sum (Event_Length)) Avg_Rental_Day
       From   Gk_Inst_Localization_V@Gkprod
      Where   Dim_Year = 2008
   Group By   Substring(Travel_Level, 1,  1), Facilityregionmetro;



