


Create Or Alter View Hold.Gk_Course_Run_Rate_V
(
   Ops_Country,
   Course_Code,
   Course_Pl,
   Course_Type,
   Sched_Cnt,
   Run_Cnt,
   Run_Pct
)
As
     Select   Ed.Ops_Country,
              Cd.Course_Code,
              Cd.Course_Pl,
              Cd.Course_Type,
              Count (Ed.Event_Id) Sched_Cnt,
              Sum (Case When Ed.Status != 'Cancelled' Then 1 Else 0 End)
                 Run_Cnt,
              Sum (Case When Ed.Status != 'Cancelled' Then 1 Else 0 End)
              / Count (Ed.Event_Id)
                 Run_Pct
       From      Gkdw.Event_Dim Ed
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Start_Date Between Cast(Getutcdate() As Date) - 365 And Cast(Getutcdate() As Date)
              And (Ed.Status In ('Verified', 'Open')
                   Or (Ed.Status = 'Cancelled'
                       And Ed.Cancel_Reason = 'Low Enrollment'))
   Group By   Ed.Ops_Country,
              Cd.Course_Code,
              Cd.Course_Pl,
              Cd.Course_Type;



