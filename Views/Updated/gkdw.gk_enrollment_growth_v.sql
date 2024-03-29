


Create Or Alter View Hold.Gk_Enrollment_Growth_V
(
   Ops_Country,
   Course_Pl,
   Course_Type,
   Course_Code,
   Enroll_Year_Minus_3,
   Enroll_Year_Minus_2,
   Enroll_Year_Minus_1,
   Enroll_Year,
   One_Year_Growth,
   Two_Year_Growth,
   Three_Year_Growth
)
As
     Select   Ed.Ops_Country,
              Cd.Course_Pl,
              Cd.Course_Type,
              Cd.Course_Code,
              Sum(Case
                     When Ed.Start_Date Between Cast(Getutcdate() As Date) - 1460
                                            And  Cast(Getutcdate() As Date) - 1096
                     Then
                        1
                     Else
                        0
                  End)
                 Enroll_Year_Minus_3,
              Sum(Case
                     When Ed.Start_Date Between Cast(Getutcdate() As Date) - 1095
                                            And  Cast(Getutcdate() As Date) - 731
                     Then
                        1
                     Else
                        0
                  End)
                 Enroll_Year_Minus_2,
              Sum(Case
                     When Ed.Start_Date Between Cast(Getutcdate() As Date) - 730
                                            And  Cast(Getutcdate() As Date) - 366
                     Then
                        1
                     Else
                        0
                  End)
                 Enroll_Year_Minus_1,
              Sum(Case
                     When Ed.Start_Date Between Cast(Getutcdate() As Date) - 365
                                            And  Cast(Getutcdate() As Date)
                     Then
                        1
                     Else
                        0
                  End)
                 Enroll_Year,
              Case
                 When Sum(Case
                             When Ed.Start_Date Between Cast(Getutcdate() As Date) - 730
                                                    And  Cast(Getutcdate() As Date) - 366
                             Then
                                1
                             Else
                                0
                          End) = 0
                 Then
                    0
                 Else
                    (Sum(Case
                            When Ed.Start_Date Between Cast(Getutcdate() As Date) - 365
                                                   And  Cast(Getutcdate() As Date)
                            Then
                               1
                            Else
                               0
                         End)
                     / Sum(Case
                              When Ed.Start_Date Between Cast(Getutcdate() As Date) - 730
                                                     And  Cast(Getutcdate() As Date) - 366
                              Then
                                 1
                              Else
                                 0
                           End)
                     - 1)
              End
                 One_Year_Growth,
              Case
                 When Sum(Case
                             When Ed.Start_Date Between Cast(Getutcdate() As Date) - 1095
                                                    And  Cast(Getutcdate() As Date) - 731
                             Then
                                1
                             Else
                                0
                          End) = 0
                 Then
                    0
                 Else
                    (Sum(Case
                            When Ed.Start_Date Between Cast(Getutcdate() As Date) - 365
                                                   And  Cast(Getutcdate() As Date)
                            Then
                               1
                            Else
                               0
                         End)
                     / Sum(Case
                              When Ed.Start_Date Between Cast(Getutcdate() As Date) - 1095
                                                     And  Cast(Getutcdate() As Date) - 731
                              Then
                                 1
                              Else
                                 0
                           End)
                     - 1)
              End
                 Two_Year_Growth,
              Case
                 When Sum(Case
                             When Ed.Start_Date Between Cast(Getutcdate() As Date) - 1460
                                                    And  Cast(Getutcdate() As Date) - 1096
                             Then
                                1
                             Else
                                0
                          End) = 0
                 Then
                    0
                 Else
                    (Sum(Case
                            When Ed.Start_Date Between Cast(Getutcdate() As Date) - 365
                                                   And  Cast(Getutcdate() As Date)
                            Then
                               1
                            Else
                               0
                         End)
                     / Sum(Case
                              When Ed.Start_Date Between Cast(Getutcdate() As Date) - 1460
                                                     And  Cast(Getutcdate() As Date)
                                                          - 1096
                              Then
                                 1
                              Else
                                 0
                           End)
                     - 1)
              End
                 Three_Year_Growth
       From         Gkdw.Order_Fact F
                 Inner Join
                    Gkdw.Event_Dim Ed
                 On F.Event_Id = Ed.Event_Id
              Inner Join
                 Gkdw.Course_Dim Cd
              On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
      Where   Ed.Start_Date Between Cast(Getutcdate() As Date) - 1460 And Cast(Getutcdate() As Date)
              And Cd.Ch_Num = '10'
              And Cd.Md_Num = '10'
              And F.Enroll_Status In ('Confirmed', 'Attended')
              And F.Book_Amt > 0
   Group By   Ed.Ops_Country,
              Cd.Course_Pl,
              Cd.Course_Type,
              Cd.Course_Code;



