


Create Or Alter View Hold.Gk_Rms_Color_Coding_V
(
   Event_Id,
   Rev_Amt,
   Total_Cost,
   Enroll_Cnt,
   Margin,
   Goal_Rev,
   Adjusted_Goal_Rev,
   Needed_Rev_Amt,
   Jeopardy_Flag
)
As
     Select   N.Event_Id,
              Rev_Amt,
              Total_Cost,
              Enroll_Cnt,
              Margin,
              Total_Cost / (1 - .48) Goal_Rev,
              Total_Cost / (1 - .48)
              * (1
                 + (Case
                       When Enroll_Cnt = 0 Then 0
                       Else Isnull(Cw_Cost, 0) / Enroll_Cnt
                    End
                    + Case
                         When Enroll_Cnt = 0 Then 0
                         Else Isnull(Voucher_Cost, 0) / Enroll_Cnt
                      End
                    + Case
                         When Enroll_Cnt = 0 Then 0
                         Else Isnull(Cdw_Cost, 0) / Enroll_Cnt
                      End)
                   / Cf.Amount)
                 Adjusted_Goal_Rev,
              Total_Cost / (1 - .48)
              * (1
                 + (Case
                       When Enroll_Cnt = 0 Then 0
                       Else Isnull(Cw_Cost, 0) / Enroll_Cnt
                    End
                    + Case
                         When Enroll_Cnt = 0 Then 0
                         Else Isnull(Voucher_Cost, 0) / Enroll_Cnt
                      End
                    + Case
                         When Enroll_Cnt = 0 Then 0
                         Else Isnull(Cdw_Cost, 0) / Enroll_Cnt
                      End)
                   / Cf.Amount)
              - Rev_Amt
                 Needed_Rev_Amt,
              Case
                 When N.Course_Code Not In
                            (Select   Cd.Course_Code
                               From      Gkdw.Course_Dim Cd
                                      Inner Join
                                         Gkdw.Event_Dim Ed
                                      On Cd.Course_Id = Ed.Course_Id
                                         And Cd.Country = Ed.Ops_Country
                              Where   Ed.Start_Date Between Cast(Getutcdate() As Date)
                                                            - 365
                                                        And  Cast(Getutcdate() As Date)
                                      And Ed.Status != 'Cancelled')
                 Then
                    'N/A'
                 When N.Start_Date Between Cast(Getutcdate() As Date)
                                       And  Cast(Getutcdate() As Date) + 9
                 Then
                    'N/A'
                 When N.Cancelled_Date Is Not Null
                 Then
                    'N/A'
                 When Margin > .65
                 Then
                    'N/A'
                 When N.Md_Num = '20'
                 Then
                    'Sij'
                 When N.Nested_With Is Not Null And N.Enroll_Cnt < 2
                 Then
                    'Sij'
                 When Margin Between .5 And .65
                 Then
                    'Running'
                 When N.Start_Week Between    Td.Dim_Year
                                           + '-'
                                           + Lpad (Td.Dim_Week, 2, '0')
                                       And     Td.Dim_Year
                                            + '-'
                                            + Lpad (Td.Dim_Week + 4, 2, '0')
                      And Total_Cost / (1 - .48)
                         * (1
                            + (Case
                                  When Enroll_Cnt = 0 Then 0
                                  Else Isnull(Cw_Cost, 0) / Enroll_Cnt
                               End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Voucher_Cost, 0) / Enroll_Cnt
                                 End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Cdw_Cost, 0) / Enroll_Cnt
                                 End)
                              / Cf.Amount)
                         - Rev_Amt < 4000
                 Then
                    'Sij'
                 When N.Start_Week Between    Td.Dim_Year
                                           + '-'
                                           + Lpad (Td.Dim_Week + 5, 2, '0')
                                       And     Td.Dim_Year
                                            + '-'
                                            + Lpad (Td.Dim_Week + 6, 2, '0')
                      And Total_Cost / (1 - .48)
                         * (1
                            + (Case
                                  When Enroll_Cnt = 0 Then 0
                                  Else Isnull(Cw_Cost, 0) / Enroll_Cnt
                               End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Voucher_Cost, 0) / Enroll_Cnt
                                 End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Cdw_Cost, 0) / Enroll_Cnt
                                 End)
                              / Cf.Amount)
                         - Rev_Amt < 10000
                 Then
                    'Sij'
                 When N.Facility_Region_Metro In
                            ('Atl',
                             'Chi',
                             'Dal',
                             'Mrs',
                             'Nyc',
                             'Rtp',
                             'Snj',
                             'Was',
                             'Tor',
                             'Ott')
                      And N.Start_Week Between    Td.Dim_Year
                                               + '-'
                                               + Lpad (Td.Dim_Week, 2, '0')
                                           And  Td.Dim_Year + '-'
                                                + Lpad (Td.Dim_Week + 4,
                                                         2,
                                                         '0')
                      And Total_Cost / (1 - .48)
                         * (1
                            + (Case
                                  When Enroll_Cnt = 0 Then 0
                                  Else Isnull(Cw_Cost, 0) / Enroll_Cnt
                               End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Voucher_Cost, 0) / Enroll_Cnt
                                 End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Cdw_Cost, 0) / Enroll_Cnt
                                 End)
                              / Cf.Amount)
                         - Rev_Amt < 8000
                 Then
                    'Sij'
                 When N.Facility_Region_Metro In
                            ('Atl',
                             'Chi',
                             'Dal',
                             'Mrs',
                             'Nyc',
                             'Rtp',
                             'Snj',
                             'Was',
                             'Tor',
                             'Ott')
                      And N.Start_Week Between Td.Dim_Year + '-'
                                               + Lpad (Td.Dim_Week + 5,
                                                        2,
                                                        '0')
                                           And  Td.Dim_Year + '-'
                                                + Lpad (Td.Dim_Week + 6,
                                                         2,
                                                         '0')
                      And Total_Cost / (1 - .48)
                         * (1
                            + (Case
                                  When Enroll_Cnt = 0 Then 0
                                  Else Isnull(Cw_Cost, 0) / Enroll_Cnt
                               End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Voucher_Cost, 0) / Enroll_Cnt
                                 End
                               + Case
                                    When Enroll_Cnt = 0 Then 0
                                    Else Isnull(Cdw_Cost, 0) / Enroll_Cnt
                                 End)
                              / Cf.Amount)
                         - Rev_Amt < 13000
                 Then
                    'Sij'
                 Else
                    'N/A'
              End
                 Jeopardy_Flag
       From            Gkdw.Gk_Go_Nogo N
                    Inner Join
                       Gkdw.Event_Dim Ed
                    On N.Event_Id = Ed.Event_Id And Ed.Status = 'Open'
                 Inner Join
                    Base.Evxcoursefee Cf
                 On     N.Course_Id = Cf.Evxcourseid
                    And Case
                          When N.Ops_Country = 'Can' Then 'Cad'
                          Else 'Usd'
                       End = Cf.Currency
                    And Cf.Feetype = 'Primary'
              Inner Join
                 Gkdw.Time_Dim Td
              On Td.Dim_Date = Cast(Getutcdate() As Date)
      Where   Isnull(Cf.Amount, 0) > 0 And N.Ch_Num = '10' And Enroll_Cnt > 0
              And N.Start_Week Between    Td.Dim_Year
                                       + '-'
                                       + Lpad (Td.Dim_Week, 2, '0')
                                   And  Case
                                           When Td.Dim_Week + 8 > 52
                                           Then
                                              Td.Dim_Year + 1 + '-'
                                              + Lpad (Td.Dim_Week + 8 - 52,
                                                       2,
                                                       '0')
                                           Else
                                                 Td.Dim_Year
                                              + '-'
                                              + Lpad (Td.Dim_Week + 8, 2, '0')
                                        End
              And N.Start_Date >= Cast(Getutcdate() As Date)
   ;



