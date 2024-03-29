


Create Or Alter View Hold.Gk_Course_Canc_Rate_V
(
   Ops_Country,
   Course_Code,
   Sched_Cnt,
   Canc_Cnt,
   Canc_Pct
)
As
     Select   Ed.Ops_Country,
              Cd.Course_Code,
              Count (Ed.Event_Id) Sched_Cnt,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End)
                 Canc_Cnt,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End)
              / Count (Ed.Event_Id)
                 Canc_Pct
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Start_Date Between Cast(Getutcdate() As Date) - 365 And Cast(Getutcdate() As Date)
   Group By   Ed.Ops_Country, Cd.Course_Code;



