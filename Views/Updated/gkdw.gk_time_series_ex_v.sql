


Create Or Alter View Hold.Gk_Time_Series_Ex_V
(
   Course_Code,
   Short_Name,
   Course_Type,
   Dim_Year,
   Time_Val,
   Sched_Cnt,
   Run_Cnt
)
As
     Select   Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Type,
              Td.Dim_Year,
              Dim_Year - 2007 Time_Val,
              Count (Ed.Event_Id) Sched_Cnt,
              Sum (Case When Ed.Status != 'Cancelled' Then 1 Else 0 End)
                 Run_Cnt
       From         Gkdw.Course_Dim Cd
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On Cd.Course_Id = Ed.Course_Id And Cd.Country = Ed.Ops_Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where       Cd.Course_Pl = 'Cisco'
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
              And Ed.Ops_Country = 'Usa'
              And Cd.Course_Code = '5031C'
              And Exists
                    (Select   1
                       From         Gkdw.Course_Dim Cd1
                                 Inner Join
                                    Gkdw.Event_Dim Ed1
                                 On Cd1.Course_Id = Ed1.Course_Id
                                    And Cd1.Country = Ed1.Ops_Country
                              Inner Join
                                 Gkdw.Time_Dim Td1
                              On Ed1.Start_Date = Td1.Dim_Date
                      Where       Cd1.Course_Id = Cd.Course_Id
                              And Cd1.Country = Cd.Country
                              And Td1.Dim_Year = Format(Getutcdate(), 'Yyyy'))
   Group By   Cd.Course_Code,
              Cd.Short_Name,
              Cd.Course_Type,
              Td.Dim_Year;



