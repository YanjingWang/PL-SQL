


Create Or Alter View Hold.Gk_Fillrate_Forecast
(
   Course_Id,
   Metro_Area,
   Event_Cnt,
   Avg
)
As
     Select   Course_Id,
              Facility_Region_Metro Metro_Area,
              Count (Distinct Ed.Event_Id) Event_Cnt,
              Round (Count (Enroll_Id) / Count (Distinct Ed.Event_Id)) Avg
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where   (Start_Date Between Cast(Getutcdate() As Date) - 360
                              And  Cast(Getutcdate() As Date) - 270
               Or Start_Date Between Cast(Getutcdate() As Date) - 720
                                 And  Cast(Getutcdate() As Date) - 540)
              And F.Enroll_Status In ('Confirmed', 'Attended')
   Group By   Course_Id, Facility_Region_Metro;



