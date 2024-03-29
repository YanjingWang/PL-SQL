


Create Or Alter View Hold.Gk_Course_Auto_Sched_V
(
   Plan_Year,
   Country,
   Course_Id,
   Course,
   Short_Name,
   Course_Pl,
   Course_Ch,
   Course_Mod,
   Course_Type,
   Duration_Days,
   Metro,
   Avg_Book_Amt,
   Avg_Cost,
   Max_Cost,
   Avg_Fill,
   Max_Fill,
   Sched_Cnt_3,
   Ev_Cnt_3,
   En_Cnt_3,
   Fill_3,
   Sched_Cnt_2,
   Ev_Cnt_2,
   En_Cnt_2,
   Fill_2,
   Sched_Cnt_1,
   Ev_Cnt_1,
   En_Cnt_1,
   Fill_1,
   Future_Sched_Event,
   Ev_Cnt_Plan,
   Wk_Dist_Plan
)
As
     Select   Plan_Year,
              Q.Country,
              Q.Course_Id,
              Q.Course_Code Course,
              Q.Short_Name,
              Course_Pl,
              Course_Ch,
              Course_Mod,
              Course_Type,
              Duration_Days,
              Q.Facility_Region_Metro Metro,
              Avg_Book_Amt,
              Avg_Cost,
              Max_Cost,
              Avg_Fill,
              Max_Fill,
              Sum (Sched_Cnt_3) Sched_Cnt_3,
              Sum (Event_Cnt_3) Ev_Cnt_3,
              Sum (Enroll_Cnt_3) En_Cnt_3,
              Case
                 When Sum (Event_Cnt_3) = 0 Then 0
                 Else Round (Sum (Enroll_Cnt_3) / Sum (Event_Cnt_3), 1)
              End
                 Fill_3,
              Sum (Sched_Cnt_2) Sched_Cnt_2,
              Sum (Event_Cnt_2) Ev_Cnt_2,
              Sum (Enroll_Cnt_2) En_Cnt_2,
              Case
                 When Sum (Event_Cnt_2) = 0 Then 0
                 Else Round (Sum (Enroll_Cnt_2) / Sum (Event_Cnt_2), 1)
              End
                 Fill_2,
              Sum (Sched_Cnt_1) Sched_Cnt_1,
              Sum (Event_Cnt_1) Ev_Cnt_1,
              Sum (Enroll_Cnt_1) En_Cnt_1,
              Case
                 When Sum (Event_Cnt_1) = 0 Then 0
                 Else Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1)
              End
                 Fill_1,
              Sum (Isnull(Future_Sched_Event, 0)) Future_Sched_Event,
              Case
                 When Sum (Event_Cnt_1) = 0
                 Then
                    0
                 When Avg_Fill = 0
                 Then
                    0
                 When Max_Fill = 0
                 Then
                    0
                 When Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1) <
                         Avg_Fill
                 Then
                    Round(Sum (Event_Cnt_1)
                          * (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1) / Avg_Fill))
                 When Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1) Between Avg_Fill
                                                                            And  Max_Fill
                 Then
                    Sum (Event_Cnt_1)
                 When Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1) >
                         Max_Fill
                 Then
                    Round(Sum (Event_Cnt_1)
                          * (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1) / Max_Fill))
              End
                 Ev_Cnt_Plan,
              Case
                 When Sum (Event_Cnt_1) = 0
                 Then
                    0
                 When Avg_Fill = 0
                 Then
                    0
                 When Max_Fill = 0
                 Then
                    0
                 When Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1) <
                         Avg_Fill
                 Then
                    Round(  48
                          / Sum (Event_Cnt_1)
                          * (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1) / Avg_Fill))
                 When Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1) Between Avg_Fill
                                                                            And  Max_Fill
                 Then
                    Round (48 / Sum (Event_Cnt_1))
                 When Round (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1), 1) >
                         Max_Fill
                 Then
                    Round(  48
                          / Sum (Event_Cnt_1)
                          * (Sum (Enroll_Cnt_1) / Sum (Event_Cnt_1) / Max_Fill))
              End
                 Wk_Dist_Plan
       From      (  Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             Count (Distinct Ed.Event_Id) Event_Cnt_3,
                             Count (Enroll_Id) Enroll_Cnt_3,
                             0 Event_Cnt_2,
                             0 Enroll_Cnt_2,
                             0 Event_Cnt_1,
                             0 Enroll_Cnt_1,
                             0 Sched_Cnt_3,
                             0 Sched_Cnt_2,
                             0 Sched_Cnt_1,
                             0 Future_Sched_Event
                      From               Gkdw.Course_Dim Cd
                                      Inner Join
                                         Gkdw.Event_Dim Ed
                                      On Cd.Course_Id = Ed.Course_Id
                                         And Cd.Country = Ed.Ops_Country
                                   Inner Join
                                      Gkdw.Order_Fact F
                                   On     Ed.Event_Id = F.Event_Id
                                      And F.Enroll_Status = 'Attended'
                                      And F.Book_Amt > 0
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Time_Dim Td1
                             On Td1.Dim_Date = Cast(Getutcdate() As Date)
                     Where      Td.Dim_Year
                             + '-'
                             + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
                                                                        - 3
                                                                        + '-'
                                                                        + Lpad (
                                                                              Td1.Dim_Month_Num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    And  Td1.Dim_Year
                                                                         - 2
                                                                         + '-'
                                                                         + Lpad (
                                                                               Td1.Dim_Month_Num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             And Ch_Num = '10'
                             And Md_Num In ('10', '20')
                             And Ed.Status In ('Verified')
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days
                  Union
                    Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             0 Event_Cnt_3,
                             0 Enroll_Cnt_3,
                             Count (Distinct Ed.Event_Id) Event_Cnt_2,
                             Count (Enroll_Id) Enroll_Cnt_2,
                             0 Event_Cnt_1,
                             0 Enroll_Cnt_1,
                             0 Sched_Cnt_3,
                             0 Sched_Cnt_2,
                             0 Sched_Cnt_1,
                             0 Future_Sched_Event
                      From               Gkdw.Course_Dim Cd
                                      Inner Join
                                         Gkdw.Event_Dim Ed
                                      On Cd.Course_Id = Ed.Course_Id
                                         And Cd.Country = Ed.Ops_Country
                                   Inner Join
                                      Gkdw.Order_Fact F
                                   On     Ed.Event_Id = F.Event_Id
                                      And F.Enroll_Status = 'Attended'
                                      And F.Book_Amt > 0
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Time_Dim Td1
                             On Td1.Dim_Date = Cast(Getutcdate() As Date)
                     Where      Td.Dim_Year
                             + '-'
                             + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
                                                                        - 2
                                                                        + '-'
                                                                        + Lpad (
                                                                              Td1.Dim_Month_Num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    And  Td1.Dim_Year
                                                                         - 1
                                                                         + '-'
                                                                         + Lpad (
                                                                               Td1.Dim_Month_Num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             And Ch_Num = '10'
                             And Md_Num In ('10', '20')
                             And Ed.Status In ('Verified')
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days
                  Union
                    Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             0 Event_Cnt_3,
                             0 Enroll_Cnt_3,
                             0 Event_Cnt_2,
                             0 Enroll_Cnt_2,
                             Count (Distinct Ed.Event_Id) Event_Cnt_1,
                             Count (Enroll_Id) Enroll_Cnt_1,
                             0 Sched_Cnt_3,
                             0 Sched_Cnt_2,
                             0 Sched_Cnt_1,
                             0 Future_Sched_Event
                      From               Gkdw.Course_Dim Cd
                                      Inner Join
                                         Gkdw.Event_Dim Ed
                                      On Cd.Course_Id = Ed.Course_Id
                                         And Cd.Country = Ed.Ops_Country
                                   Inner Join
                                      Gkdw.Order_Fact F
                                   On     Ed.Event_Id = F.Event_Id
                                      And F.Enroll_Status = 'Attended'
                                      And F.Book_Amt > 0
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Time_Dim Td1
                             On Td1.Dim_Date = Cast(Getutcdate() As Date)
                     Where      Td.Dim_Year
                             + '-'
                             + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
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
                             And Md_Num In ('10', '20')
                             And Ed.Status In ('Verified')
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days
                  Union
                    Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             0 Event_Cnt_3,
                             0 Enroll_Cnt_3,
                             0 Event_Cnt_2,
                             0 Enroll_Cnt_2,
                             0 Event_Cnt_1,
                             0 Enroll_Cnt_1,
                             Count (Distinct Ed.Event_Id) Sched_Cnt_3,
                             0 Sched_Cnt_2,
                             0 Sched_Cnt_1,
                             0 Future_Sched_Event
                      From            Gkdw.Course_Dim Cd
                                   Inner Join
                                      Gkdw.Event_Dim Ed
                                   On Cd.Course_Id = Ed.Course_Id
                                      And Cd.Country = Ed.Ops_Country
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Time_Dim Td1
                             On Td1.Dim_Date = Cast(Getutcdate() As Date)
                     Where      Td.Dim_Year
                             + '-'
                             + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
                                                                        - 3
                                                                        + '-'
                                                                        + Lpad (
                                                                              Td1.Dim_Month_Num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    And  Td1.Dim_Year
                                                                         - 2
                                                                         + '-'
                                                                         + Lpad (
                                                                               Td1.Dim_Month_Num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             And Ch_Num = '10'
                             And Md_Num In ('10', '20')
                             And (Ed.Status In ('Open', 'Verified')
                                  Or (Ed.Status = 'Cancelled'
                                      And Ed.Cancel_Reason = 'Low Enrollment'))
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days
                  Union
                    Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             0 Event_Cnt_3,
                             0 Enroll_Cnt_3,
                             0 Event_Cnt_2,
                             0 Enroll_Cnt_2,
                             0 Event_Cnt_1,
                             0 Enroll_Cnt_1,
                             0 Sched_Cnt_3,
                             Count (Distinct Ed.Event_Id) Sched_Cnt_2,
                             0 Sched_Cnt_1,
                             0 Future_Sched_Event
                      From            Gkdw.Course_Dim Cd
                                   Inner Join
                                      Gkdw.Event_Dim Ed
                                   On Cd.Course_Id = Ed.Course_Id
                                      And Cd.Country = Ed.Ops_Country
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Time_Dim Td1
                             On Td1.Dim_Date = Cast(Getutcdate() As Date)
                     Where      Td.Dim_Year
                             + '-'
                             + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
                                                                        - 2
                                                                        + '-'
                                                                        + Lpad (
                                                                              Td1.Dim_Month_Num,
                                                                              2,
                                                                              '0'
                                                                           )
                                                                    And  Td1.Dim_Year
                                                                         - 1
                                                                         + '-'
                                                                         + Lpad (
                                                                               Td1.Dim_Month_Num
                                                                               - 1,
                                                                               2,
                                                                               '0'
                                                                            )
                             And Ch_Num = '10'
                             And Md_Num In ('10', '20')
                             And (Ed.Status In ('Open', 'Verified')
                                  Or (Ed.Status = 'Cancelled'
                                      And Ed.Cancel_Reason = 'Low Enrollment'))
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days
                  Union
                    Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             0 Event_Cnt_3,
                             0 Enroll_Cnt_3,
                             0 Event_Cnt_2,
                             0 Enroll_Cnt_2,
                             0 Event_Cnt_1,
                             0 Enroll_Cnt_1,
                             0 Sched_Cnt_3,
                             0 Sched_Cnt_2,
                             Count (Distinct Ed.Event_Id) Sched_Cnt_1,
                             0 Future_Sched_Event
                      From            Gkdw.Course_Dim Cd
                                   Inner Join
                                      Gkdw.Event_Dim Ed
                                   On Cd.Course_Id = Ed.Course_Id
                                      And Cd.Country = Ed.Ops_Country
                                Inner Join
                                   Gkdw.Time_Dim Td
                                On Ed.Start_Date = Td.Dim_Date
                             Inner Join
                                Gkdw.Time_Dim Td1
                             On Td1.Dim_Date = Cast(Getutcdate() As Date)
                     Where      Td.Dim_Year
                             + '-'
                             + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
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
                             And Md_Num In ('10', '20')
                             And (Ed.Status In ('Open', 'Verified')
                                  Or (Ed.Status = 'Cancelled'
                                      And Ed.Cancel_Reason = 'Low Enrollment'))
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days
                  Union
                    Select   Td1.Dim_Year + 1 Plan_Year,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days,
                             0 Event_Cnt_3,
                             0 Enroll_Cnt_3,
                             0 Event_Cnt_2,
                             0 Enroll_Cnt_2,
                             0 Event_Cnt_1,
                             0 Enroll_Cnt_1,
                             0 Sched_Cnt_3,
                             0 Sched_Cnt_2,
                             0 Sched_Cnt_1,
                             Count (Distinct Ed.Event_Id) Future_Sched_Event
                      From               Gkdw.Course_Dim Cd
                                      Inner Join
                                         Gkdw.Event_Dim Ed
                                      On Cd.Course_Id = Ed.Course_Id
                                         And Cd.Country = Ed.Ops_Country
                                   Inner Join
                                      Gkdw.Time_Dim Td
                                   On Ed.Start_Date = Td.Dim_Date
                                Inner Join
                                   Gkdw.Time_Dim Td1
                                On Td1.Dim_Date = Cast(Getutcdate() As Date)
                                   And Td.Dim_Year = Td1.Dim_Year
                             Left Outer Join
                                Gkdw.Order_Fact F
                             On     Ed.Event_Id = F.Event_Id
                                And F.Enroll_Status != 'Cancelled'
                                And F.Book_Amt > 0
                     Where       Ch_Num = '10'
                             And Md_Num In ('10', '20')
                             And Ed.Status In ('Open', 'Verified')
                  Group By   Td1.Dim_Year + 1,
                             Cd.Country,
                             Cd.Course_Id,
                             Cd.Course_Code,
                             Cd.Short_Name,
                             Ed.Facility_Region_Metro,
                             Course_Pl,
                             Course_Ch,
                             Course_Mod,
                             Cd.Course_Type,
                             Cd.Duration_Days) Q
              Left Outer Join
                 Gkdw.Gk_Course_Fill_Rate_V Fr
              On Q.Course_Id = Fr.Course_Id
                 And Q.Facility_Region_Metro = Fr.Metro
   Group By   Plan_Year,
              Q.Country,
              Q.Course_Id,
              Q.Course_Code,
              Q.Short_Name,
              Course_Pl,
              Course_Ch,
              Course_Mod,
              Course_Type,
              Duration_Days,
              Q.Facility_Region_Metro,
              Avg_Book_Amt,
              Avg_Cost,
              Max_Cost,
              Avg_Fill,
              Max_Fill
     Having   Sum (Future_Sched_Event) > 0
   --Having Sum(Event_Cnt_1) > 0
   --   And Case When Avg_Fill = 0 Then 0
   --            When Max_Fill = 0 Then 0
   --            When Round(Sum(Enroll_Cnt_1)/Sum(Event_Cnt_1),1) < Avg_Fill
   --            Then Round(Sum(Event_Cnt_1)*(Sum(Enroll_Cnt_1)/Sum(Event_Cnt_1)/Avg_Fill))
   --            When Round(Sum(Enroll_Cnt_1)/Sum(Event_Cnt_1),1) Between Avg_Fill And Max_Fill
   --            Then Sum(Event_Cnt_1)
   --            When Round(Sum(Enroll_Cnt_1)/Sum(Event_Cnt_1),1) > Max_Fill
   --            Then Round(Sum(Event_Cnt_1)*(Sum(Enroll_Cnt_1)/Sum(Event_Cnt_1)/Max_Fill))
   --       End > 0
   ;



