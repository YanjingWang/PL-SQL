


Create Or Alter View Hold.Gk_Stats_V
(
   Period_Name,
   Le_Num,
   Fe_Num,
   Acct_Num,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Act_Num,
   Cc_Num,
   Fut_Num,
   Debit,
   Credit,
   Event_Id
)
As
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92050' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (Ed.Event_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And (Ed.Cancel_Reason Not In
                         ('Event In Error', 'Session In Error')
                   Or Ed.Cancel_Reason Is Null)
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Training Events Held
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92060' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (Ed.Event_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status In ('Verified', 'Open')
              And Exists
                    (Select   1
                       From   Gkdw.Order_Fact F
                      Where   F.Event_Id = Ed.Event_Id
                              And F.Enroll_Status In ('Confirmed', 'Attended'))
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Students
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Md_Num In ('20', '32', '42', '44')
                      And F.Cust_Country In ('Ca', 'Canada')
                 Then
                    '220'
                 When Ed.Ops_Country = 'Usa'
                 Then
                    '210'
                 When Ed.Ops_Country = 'Canada'
                 Then
                    '220'
                 Else
                    Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92122' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (F.Enroll_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where   ( (Cd.Ch_Num In ('10') And F.Book_Amt > 0)
               Or (Cd.Ch_Num In ('20') And F.Book_Amt = 0))
              And Md_Num Not In ('32', '50')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Td.Acct_Period_Name,
              Case
                 When Md_Num In ('20', '32', '42', '44')
                      And F.Cust_Country In ('Ca', 'Canada')
                 Then
                    '220'
                 When Ed.Ops_Country = 'Usa'
                 Then
                    '210'
                 When Ed.Ops_Country = 'Canada'
                 Then
                    '220'
                 Else
                    Cd.Le_Num
              End,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- Included Spel And Digital 06/05/2018
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Md_Num = '44' And F.Cust_Country In ('Ca', 'Canada')
                 Then
                    '220'
                 When Ed.Ops_Country = 'Usa'
                 Then
                    '210'
                 When Ed.Ops_Country = 'Canada'
                 Then
                    '220'
                 Else
                    Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92122' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (F.Enroll_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id
              Inner Join
                 Gkdw.Time_Dim Td
              On Trunc (F.Book_Date) = Td.Dim_Date
      Where   Md_Num In ('44', '33')
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Td.Acct_Period_Name,
              Case
                 When Md_Num = '44' And F.Cust_Country In ('Ca', 'Canada')
                 Then
                    '220'
                 When Ed.Ops_Country = 'Usa'
                 Then
                    '210'
                 When Ed.Ops_Country = 'Canada'
                 Then
                    '220'
                 Else
                    Cd.Le_Num
              End,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Guests
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92123' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (F.Enroll_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Cd.Ch_Num In ('10')
              And F.Book_Amt = 0
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Isnull(F.Attendee_Type, 'None') != 'Unlimited'
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Students - Unlimited
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92127' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (F.Enroll_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Order_Fact F
              On Ed.Event_Id = F.Event_Id
      Where       Cd.Ch_Num In ('10')
              And F.Book_Amt = 0
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Isnull(F.Attendee_Type, 'None') = 'Unlimited'
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Session Days Held
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92210' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Gk_Event_Meeting_Days_V Md
                    On Ed.Event_Id = Md.Event_Id
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status In ('Verified', 'Open')
              And Exists
                    (Select   1
                       From   Gkdw.Order_Fact F
                      Where   F.Event_Id = Ed.Event_Id
                              And F.Enroll_Status In ('Confirmed', 'Attended'))
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Sessions Taught At Training Centers
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '145' Fe_Num,
              '92230' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Isnull(D.Cc_Num, '210') Cc_Num,
              '000' Fut_Num,
              Count (Ed.Event_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Facility_Cc_Dim D
              On Ed.Facility_Code = D.Facility_Code
      Where   Cd.Md_Num In ('10')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And Ed.Internalfacility = 'T'
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id,
              D.Cc_Num
   Union
     -- # Sessions Taught At External Facilities
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '145' Fe_Num,
              '92232' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '210' Cc_Num,
              '000' Fut_Num,
              Count (Ed.Event_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From         Gkdw.Event_Dim Ed
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where   Cd.Md_Num In ('10')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And Isnull(Ed.Internalfacility, 'F') = 'F'
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Days Taught At Training Centers
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '145' Fe_Num,
              '92235' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Isnull(D.Cc_Num, '210') Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Facility_Cc_Dim D
              On Ed.Facility_Code = D.Facility_Code
      Where   Cd.Md_Num In ('10')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And Ed.Internalfacility = 'T'
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id,
              D.Cc_Num
   Union
     -- # Days Taught At External Facilities
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '145' Fe_Num,
              '92238' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '210' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Gk_Event_Meeting_Days_V Md
                    On Ed.Event_Id = Md.Event_Id
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
              Inner Join
                 Gkdw.Time_Dim Td
              On Ed.Start_Date = Td.Dim_Date
      Where   Cd.Md_Num In ('10')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And Isnull(Ed.Internalfacility, 'F') = 'F'
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Days Taught By Internal Inst
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92226' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ins', 'Si'))
                   Or (Feecode In ('Ins', 'Si')))
              And (Upper (Isnull(Account, 'No Account')) Like 'Global Know%'
                   Or Upper (Isnull(Account, 'No Account')) Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Days Taught By External Inst
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92229' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ins', 'Si'))
                   Or (Feecode In ('Ins', 'Si')))
              And (Upper (Isnull(Account, 'No Account')) Not Like 'Global Know%'
                   And Upper (Isnull(Account, 'No Account')) Not Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Internal Inst Co-Teach Days
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92245' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ins', 'Si'))
                   Or (Feecode In ('Ins', 'Si')))
              And (Upper (Isnull(Account, 'No Account')) Like 'Global Know%'
                   Or Upper (Isnull(Account, 'No Account')) Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # External Inst Co-Teach Days
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92246' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum ( (Ed.End_Date - Ed.Start_Date + 1) * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ct', 'Ss'))
                   Or (Feecode In ('Ct', 'Ss')))
              And (Upper (Isnull(Account, 'No Account')) Not Like 'Global Know%'
                   And Upper (Isnull(Account, 'No Account')) Not Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Internal Inst Audit Days
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92242' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Fa', 'Aud', 'Taud'))
                   Or (Feecode In ('Fa', 'Aud', 'Taud')))
              And (Upper (Isnull(Account, 'No Account')) Like 'Global Know%'
                   Or Upper (Isnull(Account, 'No Account')) Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # External Inst Audit Days
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92243' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days * Md.Adj_Day_Val) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Gk_Event_Meeting_Days_V Md
                       On Ed.Event_Id = Md.Event_Id
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Fa', 'Aud', 'Taud'))
                   Or (Feecode In ('Fa', 'Aud', 'Taud')))
              And (Upper (Isnull(Account, 'No Account')) Not Like 'Global Know%'
                   And Upper (Isnull(Account, 'No Account')) Not Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Internal Inst Teaching Sessions
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92220' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (Ed.Event_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ins', 'Si'))
                   Or (Feecode In ('Ins', 'Si')))
              And (Upper (Isnull(Account, 'No Account')) Like 'Global Know%'
                   Or Upper (Isnull(Account, 'No Account')) Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # External Inst Teaching Sessions
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92222' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (Ed.Event_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where   Cd.Md_Num In ('10', '20')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ins', 'Si'))
                   Or (Feecode In ('Ins', 'Si')))
              And (Upper (Isnull(Account, 'No Account')) Not Like 'Global Know%'
                   And Upper (Isnull(Account, 'No Account')) Not Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- Qty Spel Products Shipped
     Select   Td.Acct_Period_Name Period_Name,
              Case When Es.Shiptocountry = 'Usa'
                 Then
                    '210'
                 When Upper (Substring(Es.Shiptocountry, 1,  3)) = 'Canada'
                 Then
                    '220'
                 Else
                    '210'
              End
                 Le_Num,
              '000' Fe_Num,
              '92070' Acct_Num,
              Isnull(Pd.Ch_Num, '00'),
              Isnull(Pd.Md_Num, '00'),
              Isnull(Pd.Pl_Num, '00'),
              Isnull(Pd.Act_Num, '000000'),
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Esd.Actualquantityordered) Debit,
              Null Credit,
              Pd.Prod_Num
       From            Base.Evxso Es
                    Inner Join
                       Gkdw.Evxsodetail Esd
                    On Es.Evxsoid = Esd.Evxsoid
                 Inner Join
                    Gkdw.Product_Dim Pd
                 On Esd.Productid = Pd.Product_Id
              Inner Join
                 Gkdw.Time_Dim Td
              On Trunc (Es.Shippeddate) = Td.Dim_Date
      Where       Es.Sostatus = 'Shipped'
              And Es.Recordtype = 'Salesorder'
              And Pd.Prod_Num Like '2%'
   Group By   Td.Acct_Period_Name,
              Es.Shiptocountry,
              Pd.Le_Num,
              Pd.Ch_Num,
              Pd.Md_Num,
              Pd.Pl_Num,
              Pd.Act_Num,
              Pd.Prod_Num
   Union
     -- Qty Spel Products Shipped
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Md_Num In ('20', '32', '42', '44')
                      And F.Cust_Country = 'Canada'
                 Then
                    '220'
                 When Ed.Ops_Country = 'Usa'
                 Then
                    '210'
                 When Ed.Ops_Country = 'Canada'
                 Then
                    '220'
                 Else
                    Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92070' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Count (F.Enroll_Id) Debit,
              Null Credit,
              Ed.Event_Id --Cd.Course_Code  Sr 01/07/2019 To Fix John's Issue With Blank Start Date
       From            Gkdw.Course_Dim Cd
                    Inner Join
                       Gkdw.Event_Dim Ed
                    On Cd.Course_Id = Ed.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id
              Inner Join
                 Gkdw.Time_Dim Td
              On Trunc (F.Book_Date) = Td.Dim_Date
      Where       Md_Num In ('32', '50')
              And F.Enroll_Status In ('Attended', 'Confirmed')
              And F.Book_Amt > 0
   Group By   Td.Acct_Period_Name,
              F.Cust_Country,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id                                     --Cd.Course_Code
   Union
     -- # Days Internal Instructor Prep
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92224' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where       Cd.Md_Num In ('10', '20')
              And Cd.Act_Num Between '006036' And '006199'
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ct', 'Fa', 'Aud', 'Taud'))
                   Or (Feecode In ('Ct', 'Fa', 'Aud', 'Taud')))
              And (Upper (Isnull(Account, 'No Account')) Like 'Global Know%'
                   Or Upper (Isnull(Account, 'No Account')) Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Days External Instructor Moc Prep
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '000' Fe_Num,
              '92227' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              '000' Cc_Num,
              '000' Fut_Num,
              Sum (Ed.Meeting_Days) Debit,
              Null Credit,
              Ed.Event_Id
       From            Gkdw.Event_Dim Ed
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Inner Join
                 Gkdw.Instructor_Event_V Ie
              On Ed.Event_Id = Ie.Evxeventid
      Where       Cd.Md_Num In ('10', '20')
              And Cd.Act_Num Between '006036' And '006199'
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And ( (Substr (Feecode, 1, Instr (Feecode, '-') - 2) In
                           ('Ct', 'Fa', 'Aud', 'Taud'))
                   Or (Feecode In ('Ct', 'Fa', 'Aud', 'Taud')))
              And (Upper (Isnull(Account, 'No Account')) Not Like 'Global Know%'
                   And Upper (Isnull(Account, 'No Account')) Not Like 'Nexient%')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id
   Union
     -- # Attendees In Fixed Locations
     Select   Td.Acct_Period_Name Period_Name,
              Case
                 When Ed.Ops_Country = 'Usa' Then '210'
                 When Ed.Ops_Country = 'Canada' Then '220'
                 Else Cd.Le_Num
              End
                 Le_Num,
              '145' Fe_Num,
              '92126' Acct_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Isnull(D.Cc_Num, '210') Cc_Num,
              '000' Fut_Num,
              Count (F.Enroll_Id) Debit,
              Null Credit,
              Ed.Event_Id
       From               Gkdw.Event_Dim Ed
                       Inner Join
                          Gkdw.Course_Dim Cd
                       On Ed.Course_Id = Cd.Course_Id
                          And Ed.Ops_Country = Cd.Country
                    Inner Join
                       Gkdw.Time_Dim Td
                    On Ed.Start_Date = Td.Dim_Date
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id
              Left Outer Join
                 Gkdw.Gk_Facility_Cc_Dim D
              On Ed.Facility_Code = D.Facility_Code
      Where   Cd.Md_Num In ('10')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses N
                               Where   N.Nested_Course_Code = Cd.Course_Code)
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Connected_Class_V C
                      Where   C.Event_Id = Ed.Event_Id
                              And Connected_V_To_C Is Not Null)
              And Not Exists (Select   1
                                From   Gkdw.Gk_Stats_Exclude_V E
                               Where   Cd.Course_Code = E.Course_Code)
              And Ed.Status Not In ('Cancelled')
              And Ed.Internalfacility = 'T'
              And (F.Book_Amt > 0
                   Or Isnull(F.Attendee_Type, 'None') = 'Unlimited')
              And F.Enroll_Status In ('Attended', 'Confirmed')
   Group By   Td.Acct_Period_Name,
              Ed.Ops_Country,
              Cd.Le_Num,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Pl_Num,
              Cd.Act_Num,
              Ed.Event_Id,
              D.Cc_Num;



