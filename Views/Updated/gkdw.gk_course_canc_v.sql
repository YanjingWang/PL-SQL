


Create Or Alter View Hold.Gk_Course_Canc_V
(
   Course_Id,
   Course_Code,
   Ops_Country,
   Facility_Region_Metro,
   Event_Cnt,
   Canc_Event_Cnt,
   Canc_Pct
)
As
     Select   Cd.Course_Id,
              Cd.Course_Code,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro,
              Count (Ed.Event_Id) Event_Cnt,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End)
                 Canc_Event_Cnt,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End)
              / Count (Ed.Event_Id)
                 Canc_Pct
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where       Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Ed.Start_Date >= Cast(Getutcdate() As Date) - 730
   --And Cd.Course_Code = '2780C'
   --And Ed.Facility_Region_Metro = 'Ksc'
   Group By   Cd.Course_Id,
              Cd.Course_Code,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro
   ;



