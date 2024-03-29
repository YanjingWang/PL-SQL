


Create Or Alter View Hold.Gk_Auto_Sched_Pm_V
(
   Plan_Year,
   Country,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Course_Type,
   Root_Code,
   Course_Id,
   Course_Code,
   Short_Name,
   Duration_Days,
   Sched_Roll_3,
   Ev_Roll_3,
   En_Roll_3,
   Book_Roll_3,
   Sched_Roll_2,
   Ev_Roll_2,
   En_Roll_2,
   Book_Roll_2,
   Sched_Roll_1,
   Ev_Roll_1,
   En_Roll_1,
   Book_Roll_1
)
As
     Select   Q.Plan_Year,
              Q.Country,
              Q.Course_Ch,
              Q.Course_Mod,
              Q.Course_Pl,
              Q.Course_Type,
              Q.Root_Code,
              Q.Course_Id,
              Q.Course_Code,
              Q.Short_Name,
              Q.Duration_Days,
              Sum (Sched_Roll_3) Sched_Roll_3,
              Sum (Ev_Roll_3) Ev_Roll_3,
              Sum (En_Roll_3) En_Roll_3,
              Sum (Book_Roll_3) Book_Roll_3,
              Sum (Sched_Roll_2) Sched_Roll_2,
              Sum (Ev_Roll_2) Ev_Roll_2,
              Sum (En_Roll_2) En_Roll_2,
              Sum (Book_Roll_2) Book_Roll_2,
              Sum (Sched_Roll_1) Sched_Roll_1,
              Sum (Ev_Roll_1) Ev_Roll_1,
              Sum (En_Roll_1) En_Roll_1,
              Sum (Book_Roll_1) Book_Roll_1
       From   (  Select   Td1.Dim_Year + 1 Plan_Year,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          Count (Distinct Ed.Event_Id) Ev_Roll_3,
                          Count (Enroll_Id) En_Roll_3,
                          Sum (F.Book_Amt) Book_Roll_3,
                          0 Ev_Roll_2,
                          0 En_Roll_2,
                          0 Book_Roll_2,
                          0 Ev_Roll_1,
                          0 En_Roll_1,
                          0 Book_Roll_1,
                          0 Sched_Roll_3,
                          0 Sched_Roll_2,
                          0 Sched_Roll_1
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
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
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
                          And Md_Num = '10'
                          And Ed.Status In ('Verified')
               Group By   Td1.Dim_Year + 1,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days
               Union
                 Select   Td1.Dim_Year + 1 Plan_Year,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          0 Ev_Roll_3,
                          0 En_Roll_3,
                          0,
                          Count (Distinct Ed.Event_Id) Ev_Roll_2,
                          Count (Enroll_Id) En_Roll_2,
                          Sum (F.Book_Amt),
                          0 Ev_Roll_1,
                          0 En_Roll_1,
                          0,
                          0,
                          0,
                          0
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
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
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
                          And Md_Num = '10'
                          And Ed.Status In ('Verified')
               Group By   Td1.Dim_Year + 1,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days
               Union
                 Select   Td1.Dim_Year + 1 Plan_Year,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          0 Ev_Roll_3,
                          0 En_Roll_3,
                          0,
                          0 Ev_Roll_2,
                          0 En_Roll_2,
                          0,
                          Count (Distinct Ed.Event_Id) Ev_Roll_1,
                          Count (Enroll_Id) En_Roll_1,
                          Sum (F.Book_Amt),
                          0,
                          0,
                          0
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
                          And Ed.Status In ('Verified')
               Group By   Td1.Dim_Year + 1,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days
               Union
                 Select   Td1.Dim_Year + 1 Plan_Year,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id) Sched_Roll_3,
                          0,
                          0
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
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
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
                          And Md_Num = '10'
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
               Group By   Td1.Dim_Year + 1,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days
               Union
                 Select   Td1.Dim_Year + 1 Plan_Year,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id) Sched_Roll_2,
                          0
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
                  Where   Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Between Td1.Dim_Year
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
                          And Md_Num = '10'
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
               Group By   Td1.Dim_Year + 1,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days
               Union
                 Select   Td1.Dim_Year + 1 Plan_Year,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0,
                          Count (Distinct Ed.Event_Id) Sched_Roll_1
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
                          And (Ed.Status In ('Open', 'Verified')
                               Or (Ed.Status = 'Cancelled'
                                   And Ed.Cancel_Reason = 'Low Enrollment'))
               Group By   Td1.Dim_Year + 1,
                          Cd.Country,
                          Cd.Course_Ch,
                          Cd.Course_Mod,
                          Cd.Course_Pl,
                          Cd.Course_Type,
                          Cd.Root_Code,
                          Cd.Course_Id,
                          Cd.Course_Code,
                          Cd.Short_Name,
                          Cd.Duration_Days) Q
      Where   Substring(Q.Course_Code, 5,  1) = 'C'
   Group By   Q.Plan_Year,
              Q.Country,
              Q.Course_Ch,
              Q.Course_Mod,
              Q.Course_Pl,
              Q.Course_Type,
              Q.Root_Code,
              Q.Course_Id,
              Q.Course_Code,
              Q.Short_Name,
              Q.Duration_Days;



