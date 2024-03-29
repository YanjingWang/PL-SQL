


Create Or Alter View Hold.Gk_Cdw_Monthly_V
(
   Cdw_Group,
   Period_Name,
   Event_Id,
   Course_Code,
   Ch_Num,
   Md_Num,
   Short_Name,
   Start_Date,
   Facility_Code,
   Opportunity_Id,
   Attended_Cnt,
   Clsp_Site_Id,
   Reporting_Period_Monthyear,
   Two_Tier_Sales,
   Clp_Id_So_Number,
   Cisco_Dw_Id,
   Country_Iso_Abbr,
   Number_Of_Students,
   Gross_Revenue,
   Gk_Course_Code,
   Event_Dur,
   Cdw_Dur,
   Cdw_Eff_Dur,
   Rate_Type,
   Cisco_Overall_Source,
   Cdw_Rate,
   Roy_Amt
)
As
     Select   'Standard-Public' Cdw_Group,
              Td.Dim_Period_Name Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Short_Name,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Count (F.Enroll_Id) Attended_Cnt,
              '579' Clsp_Site_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year Reporting_Period_Monthyear,
              'No' Two_Tier_Sales,
              Null Clp_Id_So_Number,
              Dw_Auth_Code Cisco_Dw_Id,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Substr (Upper (C.Country), 1, 3)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Substring(Ed.Ops_Country, 1,  3)
              End
                 Country_Iso_Abbr,
              Count (F.Enroll_Id) Number_Of_Students,
              Sum (Book_Amt) Gross_Revenue,
              Ed.Course_Code Gk_Course_Code,
              Ed.Meeting_Days Event_Dur,
              Cc.Cisco_Dur_Days Cdw_Dur,
              Cc.Cisco_Dur_Days Cdw_Eff_Dur,
              Cc.Payment_Unit Rate_Type,
              1 Cisco_Overall_Source,
              Case When Cc.Payment_Unit = 'No Payment' Then 0
                 Else Cc.Fee_Rate
              End
                 Cdw_Rate,
              Case When Cc.Payment_Unit In
                            ('Per Student Per Day', 'Fixed')
                 Then
                    Cc.Fee_Rate * Cc.Cisco_Dur_Days * Count (F.Enroll_Id)
                 When Upper (Cc.Payment_Unit) = 'Per Student'
                 Then
                    Cc.Fee_Rate * Count (F.Enroll_Id)
                 When Upper (Cc.Payment_Unit) = 'No Payment'
                 Then
                    0
              End
                 Roy_Amt
       From                     Gkdw.Event_Dim Ed
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
                    Inner Join
                       Gkdw.Cust_Dim C
                    On F.Cust_Id = C.Cust_Id
                 Inner Join
                    Gkdw.Gk_Cisco_Dw_Mv Cc
                 On     Cd.Course_Id = Cc.Course_Id
                    And Upper (Cc.Fee_Status) = 'Active'
                    And Td.Dim_Date Between Cc.From_Date And Cc.To_Date
              Inner Join
                 Gkdw.Gk_Cdw_Curr_Auth_Mv Cc2
              On Cc.Course_Id = Cc2.Course_Id And Cc.To_Date = Cc2.To_Date
      Where   F.Enroll_Status In ('Confirmed', 'Attended')
              And Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And (F.Book_Amt > 0 Or F.Attendee_Type = 'Unlimited')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cd.Course_Code Not Like '%L'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Dw_Auth_Code,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Substr (Upper (C.Country), 1, 3)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Substring(Ed.Ops_Country, 1,  3)
              End,
              Ed.Course_Code,
              Cd.Short_Name,
              Ed.Course_Code,
              Ed.Meeting_Days,
              Cc.Cisco_Dur_Days,
              Cc.Payment_Unit,
              Cc.Fee_Rate
   Union --- This Block Handles Course Codes That End In L, Which Are Virtual Courses That Take Place In Both The Us And Canada And Must Be Summed So Country Code Is Made The Same.
     Select   'Standard-Public' Cdw_Group,
              Td.Dim_Period_Name Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Short_Name,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Count (F.Enroll_Id) Attended_Cnt,
              '579' Clsp_Site_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year Reporting_Period_Monthyear,
              'No' Two_Tier_Sales,
              Null Clp_Id_So_Number,
              Dw_Auth_Code Cisco_Dw_Id,
              Case
                 When Substring(C.Country, 1,  3) = 'Can' Then 'Can'
                 Else 'Usa'
              End
                 Country_Iso_Abbr,
              Count (F.Enroll_Id) Number_Of_Students,
              Sum (Book_Amt) Gross_Revenue,
              Ed.Course_Code Gk_Course_Code,
              Ed.Meeting_Days Event_Dur,
              Cc.Cisco_Dur_Days Cdw_Dur,
              Cc.Cisco_Dur_Days Cdw_Eff_Dur,
              Cc.Payment_Unit Rate_Type,
              1 Cisco_Overall_Source,
              Case When Cc.Payment_Unit = 'No Payment' Then 0
                 Else Cc.Fee_Rate
              End
                 Cdw_Rate,
              Case When Cc.Payment_Unit In
                            ('Per Student Per Day', 'Fixed')
                 Then
                    Cc.Fee_Rate * Cc.Cisco_Dur_Days * Count (F.Enroll_Id)
                 When Upper (Cc.Payment_Unit) = 'Per Student'
                 Then
                    Cc.Fee_Rate * Count (F.Enroll_Id)
                 When Upper (Cc.Payment_Unit) = 'No Payment'
                 Then
                    0
              End
                 Roy_Amt
       From                     Gkdw.Event_Dim Ed
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
                    Inner Join
                       Gkdw.Cust_Dim C
                    On F.Cust_Id = C.Cust_Id
                 Inner Join
                    Gkdw.Gk_Cisco_Dw_Mv Cc
                 On     Cd.Course_Id = Cc.Course_Id
                    And Upper (Cc.Fee_Status) = 'Active'
                    And Td.Dim_Date Between Cc.From_Date And Cc.To_Date
              Inner Join
                 Gkdw.Gk_Cdw_Curr_Auth_Mv Cc2
              On Cc.Course_Id = Cc2.Course_Id And Cc.To_Date = Cc2.To_Date
      Where   F.Enroll_Status In ('Confirmed', 'Attended')
              And Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And (F.Book_Amt > 0 Or F.Attendee_Type = 'Unlimited')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cd.Course_Code Like '%L'
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Dw_Auth_Code,
              Case
                 When Substring(C.Country, 1,  3) = 'Can' Then 'Can'
                 Else 'Usa'
              End,
              Ed.Course_Code,
              Cd.Short_Name,
              Ed.Course_Code,
              Ed.Meeting_Days,
              Cc.Cisco_Dur_Days,
              Cc.Payment_Unit,
              Cc.Fee_Rate
   Union
     Select   'Standard-Onsite' Cdw_Group,
              Td.Dim_Period_Name Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Short_Name,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Count (F.Enroll_Id) Attended_Cnt,
              '579' Clsp_Site_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year Reporting_Period_Monthyear,
              'No' Two_Tier_Sales,
              Null Clp_Id_So_Number,
              Dw_Auth_Code Cisco_Dw_Id,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Substr (Upper (C.Country), 1, 3)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Substring(Ed.Ops_Country, 1,  3)
              End
                 Country_Iso_Abbr,
              Isnull(
                 Case
                    When Count (F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                    Else Count (F.Enroll_Id)
                 End,
                 0
              )
                 Number_Of_Students,
              Sum (Ob.Book_Amt) Gross_Revenue,
              Ed.Course_Code Gk_Course_Code,
              Ed.Meeting_Days Event_Dur,
              Cc.Cisco_Dur_Days Cdw_Dur,
              Cc.Cisco_Dur_Days Cdw_Eff_Dur,
              Cc.Payment_Unit Rate_Type,
              1 Cisco_Overall_Source,
              Case When Cc.Payment_Unit = 'No Payment' Then 0
                 Else Cc.Fee_Rate
              End
                 Cdw_Rate,
              Case When Cc.Payment_Unit = 'Per Student Per Day'
                 Then
                    Cc.Fee_Rate * Cc.Cisco_Dur_Days
                    * Case
                         When Count(F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                         Else Count (F.Enroll_Id)
                      End
                 When Upper (Cc.Payment_Unit) = 'Per Student'
                 Then
                    Cc.Fee_Rate
                    * Case
                         When Count (F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                         Else Count (F.Enroll_Id)
                      End
                 When Upper (Cc.Payment_Unit) = 'No Payment'
                 Then
                    0
              End
                 Roy_Amt
       From                        Gkdw.Event_Dim Ed
                                Inner Join
                                   Gkdw.Course_Dim Cd
                                On Ed.Course_Id = Cd.Course_Id
                                   And Ed.Ops_Country = Cd.Country
                             Inner Join
                                Gkdw.Time_Dim Td
                             On Ed.Start_Date = Td.Dim_Date
                          Inner Join
                             Gkdw.Gk_Cdw_Onsite_V Ob
                          On Ed.Event_Id = Ob.Event_Id
                       Left Outer Join
                          Gkdw.Order_Fact F
                       On     Ed.Event_Id = F.Event_Id
                          And F.Enroll_Status In ('Confirmed', 'Attended')
                          And F.Fee_Type != 'Ons - Base'
                    Left Outer Join
                       Gkdw.Cust_Dim C
                    On F.Cust_Id = C.Cust_Id
                 Inner Join
                    Gkdw.Gk_Cisco_Dw_Mv Cc
                 On     Cd.Course_Id = Cc.Course_Id
                    And Upper (Cc.Fee_Status) = 'Active'
                    And Td.Dim_Date Between Cc.From_Date And Cc.To_Date
              Inner Join
                 Gkdw.Gk_Cdw_Curr_Auth_Mv Cc2
              On Cc.Course_Id = Cc2.Course_Id And Cc.To_Date = Cc2.To_Date
      Where   Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Dw_Auth_Code,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Substr (Upper (C.Country), 1, 3)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Substring(Ed.Ops_Country, 1,  3)
              End,
              Ed.Course_Code,
              Cd.Short_Name,
              Ed.Course_Code,
              Ed.Meeting_Days,
              Cc.Cisco_Dur_Days,
              Cc.Payment_Unit,
              Cc.Fee_Rate,
              Ed.Onsite_Attended
   Union
     Select   'Spel-Web',
              J.Period_Name,
              Cd.Course_Id,
              Cd.Course_Code,
              Gcc.Segment4,
              Gcc.Segment5,
              Cd.Short_Name,
              Null,
              'Spel',
              Null,
              Null,
              '579' Clsp_Site_Id,
              Trim (Td.Dim_Month) + ' ' + Td.Dim_Year
                 Reporting_Period_Monthyear,
              'No' Two_Tier_Sales,
              Null Clp_Id_So_Number,
              Dw_Auth_Code Cisco_Dw_Id,
              Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End
                 Country_Iso_Abbr,
              Null Number_Of_Students,
              Sum (Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0)) Gross_Revenue,
              Cd.Course_Code,
              Null Event_Dur,
              C.Cisco_Dur_Days Cdw_Dur,
              C.Cisco_Dur_Days Cdw_Eff_Dur,
              C.Fee_Type,
              1 Cisco_Overall_Source,
              (C.Fee_Rate / 100) Fee_Rate,
              Sum (Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0))
              * (Fee_Rate / 100)
                 Roy_Rate
       From               Gl_Je_Lines@R12prd J
                       Inner Join
                          Gl_Code_Combinations@R12prd Gcc
                       On J.Code_Combination_Id = Gcc.Code_Combination_Id
                    Inner Join
                       Gkdw.Gk_Cisco_Dw_Mv C
                    On Gcc.Segment7 =
                          Case
                             When Substring(Gcc.Segment7, 1,  1) = '0'
                             Then
                                Lpad (Substring(C.Prod_Code, 1,  4), 6, '00')
                             Else
                                C.Prod_Code
                          End
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On C.Course_Id = Cd.Course_Id
                    And Case
                          When Gcc.Segment1 = '220' Then 'Canada'
                          Else 'Usa'
                       End = Cd.Country           --And Cd.Inactive_Flag = 'F'
              Inner Join
                 Gkdw.Gk_Month_Name_V Td
              On J.Period_Name = Td.Dim_Period_Name
      Where       Gcc.Segment3 = '41105'
              And Gcc.Segment5 = '32'
              And Gcc.Segment6 = '04'
              And C.Content_Type = 'E-Learning'
              And C.Fee_Status != 'Inactive'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
              And J.Effective_Date Between C.From_Date And C.To_Date
   Group By   J.Period_Name,
              Cd.Course_Id,
              Cd.Course_Code,
              Gcc.Segment4,
              Gcc.Segment5,
              Trim (Td.Dim_Month) + ' ' + Td.Dim_Year,
              Dw_Auth_Code,
              Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End,
              Cd.Course_Code,
              Cd.Short_Name,
              C.Cisco_Dur_Days,
              C.Fee_Type,
              C.Fee_Rate
   Union
     Select   'Ex-Onsite-No_Students' Cdw_Group,
              Td.Dim_Period_Name Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Short_Name,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Count (F.Enroll_Id) Attended_Cnt,
              '579' Clsp_Site_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year Reporting_Period_Monthyear,
              'No' Two_Tier_Sales,
              Null Clp_Id_So_Number,
              Dw_Auth_Code Cisco_Dw_Id,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Substr (Upper (C.Country), 1, 3)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Substring(Ed.Ops_Country, 1,  3)
              End
                 Country_Iso_Abbr,
              Isnull(
                 Case
                    When Count (F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                    Else Count (F.Enroll_Id)
                 End,
                 0
              )
                 Number_Of_Students,
              Sum (Ob.Book_Amt) Gross_Revenue,
              Ed.Course_Code Gk_Course_Code,
              Ed.Meeting_Days Event_Dur,
              Cc.Cisco_Dur_Days Cdw_Dur,
              Cc.Cisco_Dur_Days Cdw_Eff_Dur,
              Cc.Payment_Unit Rate_Type,
              1 Cisco_Overall_Source,
              Case When Cc.Payment_Unit = 'No Payment' Then 0
                 Else Cc.Fee_Rate
              End
                 Cdw_Rate,
              Case When Cc.Payment_Unit = 'Per Student Per Day'
                 Then
                    Cc.Fee_Rate * Cc.Cisco_Dur_Days
                    * Case
                         When Count(F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                         Else Count (F.Enroll_Id)
                      End
                 When Upper (Cc.Payment_Unit) = 'Per Student'
                 Then
                    Cc.Fee_Rate
                    * Case
                         When Count (F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                         Else Count (F.Enroll_Id)
                      End
                 When Upper (Cc.Payment_Unit) = 'No Payment'
                 Then
                    0
              End
                 Roy_Amt
       From                     Gkdw.Event_Dim Ed
                             Inner Join
                                Gkdw.Course_Dim Cd
                             On Ed.Course_Id = Cd.Course_Id
                                And Ed.Ops_Country = Cd.Country
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                       Inner Join
                          Gkdw.Gk_Cdw_Onsite_V Ob
                       On Ed.Event_Id = Ob.Event_Id
                    Left Outer Join
                       Gkdw.Order_Fact F
                    On     Ed.Event_Id = F.Event_Id
                       And F.Enroll_Status In ('Confirmed', 'Attended')
                       And F.Fee_Type != 'Ons - Base'
                 Left Outer Join
                    Gkdw.Cust_Dim C
                 On F.Cust_Id = C.Cust_Id
              Inner Join
                 Gkdw.Gk_Cisco_Dw_Mv Cc
              On     Cd.Course_Id = Cc.Course_Id
                 And Upper (Cc.Fee_Status) = 'Active'
                 And Td.Dim_Date Between Cc.From_Date And Cc.To_Date
      Where   Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Dw_Auth_Code,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Substr (Upper (C.Country), 1, 3)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Substring(Ed.Ops_Country, 1,  3)
              End,
              Ed.Course_Code,
              Cd.Short_Name,
              Ed.Course_Code,
              Ed.Meeting_Days,
              Cc.Cisco_Dur_Days,
              Cc.Payment_Unit,
              Cc.Fee_Rate,
              Ed.Onsite_Attended
     Having   Isnull(
                 Case
                    When Count (F.Enroll_Id) = 0 Then Ed.Onsite_Attended
                    Else Count (F.Enroll_Id)
                 End,
                 0
              ) = 0;



