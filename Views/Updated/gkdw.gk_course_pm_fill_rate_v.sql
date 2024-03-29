


Create Or Alter View Hold.Gk_Course_Pm_Fill_Rate_V
(
   Ops_Country,
   Course_Id,
   Course_Code,
   Short_Name,
   Event_Cnt,
   Avg_Cost,
   Max_Cost,
   Avg_Fill,
   Max_Fill
)
As
     Select   Ed.Ops_Country,
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name,
              Count (Ed.Event_Id) Event_Cnt,
              Round (Avg (Total_Cost) * 2) Avg_Cost,
              Round (Max (Total_Cost) * 2) Max_Cost,
              Case
                 When Avg (Ab.Avg_Book_Amt) = 0 Then 0
                 Else Round ( (Avg (Total_Cost) * 1.8) / Avg (Ab.Avg_Book_Amt))
              End
                 Avg_Fill,
              Case
                 When Avg (Ab.Avg_Book_Amt) = 0 Then 0
                 Else Round ( (Max (Total_Cost) * 1.8) / Avg (Ab.Avg_Book_Amt))
              End
                 Max_Fill
       From                  Gkdw.Gk_Go_Nogo_All_V G
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On G.Event_Id = Ed.Event_Id
                       Inner Join
                          Gkdw.Course_Dim Cd
                       On Ed.Course_Id = Cd.Course_Id
                          And Ed.Ops_Country = Cd.Country
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed.Start_Date = Td.Dim_Date
                 Inner Join
                    Gkdw.Time_Dim Td1
                 On Td1.Dim_Date = Cast(Getutcdate() As Date)
              Inner Join
                 Gkdw.Gk_Course_Avg_Book_V Ab
              On     Ed.Course_Id = Ab.Course_Id
                 And Ed.Ops_Country = Ab.Ops_Country
                 And Ed.Facility_Region_Metro = Ab.Metro
      Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
                                                                            - 1
                                                                            + '-'
                                                                            + Lpad (
                                                                                  Td1.Dim_Month_Num,
                                                                                  2,
                                                                                  '0'
                                                                               )
                                                                        And  Td1.Dim_Year
                                                                             + '-'
                                                                             + Lpad (
                                                                                   Td1.Dim_Month_Num
                                                                                   - 1,
                                                                                   2,
                                                                                   '0'
                                                                                )
              And Ch_Num = '10'
              And Md_Num = '10'
              And Ed.Status = 'Verified'
   Group By   Ed.Ops_Country,
              Cd.Course_Id,
              Cd.Course_Code,
              Cd.Short_Name;



