


Create Or Alter View Hold.Gk_2013_Course_Run_Rate_V
(
   Ops_Country,
   Course_Code,
   Event_Cnt,
   Canc_Cnt,
   Run_Rate
)
As
     Select   Ed.Ops_Country,
              Cd.Course_Code,
              Count (Distinct Ed.Event_Id) Event_Cnt,
              Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End)
                 Canc_Cnt,
              (Count (Distinct Ed.Event_Id)
               - Sum (Case When Ed.Status = 'Cancelled' Then 1 Else 0 End))
              / Count (Distinct Ed.Event_Id)
                 Run_Rate
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Code = Cd.Course_Code And Cd.Country = Ed.Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where       Td.Dim_Year >= To_Number (Format(Getutcdate(), 'Yyyy')) - 2
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
   Group By   Ed.Ops_Country, Cd.Course_Code;



