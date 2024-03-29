


Create Or Alter View Hold.Gk_Cdw_Monthly_Old_V
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
              Auth_Code Cisco_Dw_Id,
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
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Ilt_Rate Cdw_Rate,
              Case
                 When Cc.Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Ilt_Rate * Cc.Eff_Dur * Count (F.Enroll_Id)
                 When Cc.Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Ilt_Rate * Count (F.Enroll_Id)
              End
                 Roy_Amt
       From                  Gkdw.Event_Dim Ed
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
                 Gkdw.Gk_Cdw_Interface Cc
              On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
      Where   F.Enroll_Status In ('Confirmed', 'Attended')
              And Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Cc.Gk_Exception Is Null
              And (F.Book_Amt > 0 Or F.Attendee_Type = 'Unlimited')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
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
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Rate_Type,
              Cc.Ilt_Rate,
              Cc.Cisco_Overall_Source
   Union
     Select   'Standard-Onsite',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Ilt_Rate,
              Case
                 When Cc.Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Ilt_Rate * Cc.Eff_Dur * Count (F.Enroll_Id)
                 When Cc.Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Ilt_Rate * Count (F.Enroll_Id)
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id
              Inner Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And F.Enroll_Status = 'Attended'
              And Cc.Gk_Exception Is Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Ilt_Rate,
              Cc.Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
   Union
     Select   'Standard-Onsite',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Ed.Onsite_Attended Number_Of_Students,
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Ilt_Rate,
              Case
                 When Cc.Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Ilt_Rate * Cc.Eff_Dur * Ed.Onsite_Attended
                 When Cc.Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Ilt_Rate * Ed.Onsite_Attended
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id And F.Enroll_Status = 'Attended'
              Left Outer Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And Cc.Gk_Exception Is Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
              --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
              And Ed.Onsite_Attended > 0
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Onsite_Attended,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Ilt_Rate,
              Cc.Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
     Having   Count (F.Enroll_Id) = 0
   Union
     Select   'Spel-Cd',
              J.Period_Name,
              Pd.Product_Id,
              Pd.Prod_Num,
              Gcc.Segment4,
              Gcc.Segment5,
              Pd.Prod_Name,
              Null,
              'Spel',
              Null,
              Null,
              '579' Clsp_Site_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year Reporting_Period_Monthyear,
              'No' Two_Tier_Sales,
              Null Clp_Id_So_Number,
              Auth_Code Cisco_Dw_Id,
              Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End
                 Country_Iso_Abbr,
              Null Number_Of_Students,
              Sum (Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0)) Gross_Revenue,
              Pd.Prod_Num,
              Null Event_Dur,
              C.Lp_Dur Cdw_Dur,
              C.Eff_Dur Cdw_Eff_Dur,
              C.Rate_Type,
              C.Cisco_Overall_Source,
              C.Spel_Rate,
                Sum (Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0))
              * C.Cisco_Overall_Source
              * Spel_Rate
                 Roy_Rate
       From               Gl_Je_Lines@R12prd J
                       Inner Join
                          Gl_Code_Combinations@R12prd Gcc
                       On J.Code_Combination_Id = Gcc.Code_Combination_Id
                    Inner Join
                       Gkdw.Gk_Cdw_Interface C
                    On Gcc.Segment7 =
                          Case
                             When Substring(Gcc.Segment7, 1,  1) = '0'
                             Then
                                Lpad (Substring(C.Gk_Course_Num, 1,  4), 6, '00')
                             Else
                                C.Gk_Course_Num
                          End
                       And C.Spel_Rate Is Not Null
                 Inner Join
                    Gkdw.Product_Dim Pd
                 On Gk_Course_Num + 'S' = Pd.Prod_Num
                    And Pd.Status = 'Available'
              Inner Join
                 Gkdw.Gk_Month_Name_V Td
              On J.Period_Name = Td.Dim_Period_Name
      Where       Gcc.Segment3 = '41105'
              And Gcc.Segment5 = '31'
              And Gcc.Segment6 = '04'
              And C.Modality = 'E-Learning'
              And C.Dw_Status != 'Inactive'
              And Substring(Pd.Prod_Num, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   Group By   J.Period_Name,
              Pd.Product_Id,
              Pd.Prod_Num,
              Gcc.Segment4,
              Gcc.Segment5,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
              Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End,
              Pd.Prod_Num,
              Pd.Prod_Name,
              C.Eff_Dur,
              C.Lp_Dur,
              C.Rate_Type,
              C.Spel_Rate,
              C.Cisco_Overall_Source
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
              Auth_Code Cisco_Dw_Id,
              Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End
                 Country_Iso_Abbr,
              Null Number_Of_Students,
              Sum (Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0)) Gross_Revenue,
              Cd.Course_Code,
              Null Event_Dur,
              C.Lp_Dur Cdw_Dur,
              C.Eff_Dur Cdw_Eff_Dur,
              C.Rate_Type,
              C.Cisco_Overall_Source,
              C.Spel_Rate,
                Sum (Isnull(Accounted_Cr, 0) - Isnull(Accounted_Dr, 0))
              * C.Cisco_Overall_Source
              * Spel_Rate
                 Roy_Rate
       From               Gl_Je_Lines@R12prd J
                       Inner Join
                          Gl_Code_Combinations@R12prd Gcc
                       On J.Code_Combination_Id = Gcc.Code_Combination_Id
                    Inner Join
                       Gkdw.Gk_Cdw_Interface C
                    On Gcc.Segment7 =
                          Case
                             When Substring(Gcc.Segment7, 1,  1) = '0'
                             Then
                                Lpad (Substring(C.Gk_Course_Num, 1,  4), 6, '00')
                             Else
                                C.Gk_Course_Num
                          End
                       And C.Spel_Rate Is Not Null
                 Inner Join
                    Gkdw.Course_Dim Cd
                 On C.Gk_Course_Num + 'W' = Cd.Course_Code
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
              And C.Modality = 'E-Learning'
              And C.Dw_Status != 'Inactive'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   Group By   J.Period_Name,
              Cd.Course_Id,
              Cd.Course_Code,
              Gcc.Segment4,
              Gcc.Segment5,
              Trim (Td.Dim_Month) + ' ' + Td.Dim_Year,
              Auth_Code,
              Case When Gcc.Segment1 = '220' Then 'Can' Else 'Usa' End,
              Cd.Course_Code,
              Cd.Short_Name,
              C.Eff_Dur,
              C.Lp_Dur,
              C.Rate_Type,
              C.Spel_Rate,
              C.Cisco_Overall_Source
   Union
     Select   'Ex-Onsite-No_Students',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Isnull(Ed.Onsite_Attended, 0) Number_Of_Students,
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Ilt_Rate,
              Case
                 When Cc.Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Ilt_Rate * Cc.Eff_Dur * Isnull(Ed.Onsite_Attended, 0)
                 When Cc.Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Ilt_Rate * Isnull(Ed.Onsite_Attended, 0)
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id And F.Enroll_Status = 'Attended'
              Left Outer Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And Cc.Gk_Exception Is Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
              --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
              And Isnull(Ed.Onsite_Attended, 0) = 0
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Onsite_Attended,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Ilt_Rate,
              Cc.Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
     Having   Count (F.Enroll_Id) = 0
   Union
     Select   'Ex-Public-Optical' Cdw_Group,
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Except_Accrual_Rate Cdw_Rate,
              Case
                 When Cc.Except_Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Except_Accrual_Rate * Cc.Eff_Dur * Count (F.Enroll_Id)
                 When Cc.Except_Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Except_Accrual_Rate * Count (F.Enroll_Id)
              End
                 Roy_Amt
       From                  Gkdw.Event_Dim Ed
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
                 Gkdw.Gk_Cdw_Interface Cc
              On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
      Where   F.Enroll_Status In ('Confirmed', 'Attended')
              And Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Cc.Gk_Exception Is Not Null
              And (F.Book_Amt > 0 Or F.Attendee_Type = 'Unlimited')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Cd.Course_Type = 'Optical Networking'
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
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Except_Accrual_Rate,
              Cc.Cisco_Overall_Source
   Union
     Select   'Ex-Onsite-Optical',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Except_Accrual_Rate,
              Case
                 When Cc.Except_Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Except_Accrual_Rate * Cc.Eff_Dur * Count (F.Enroll_Id)
                 When Cc.Except_Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Except_Accrual_Rate * Count (F.Enroll_Id)
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id
              Inner Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And F.Enroll_Status = 'Attended'
              And Cc.Gk_Exception Is Not Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Cd.Course_Type = 'Optical Networking'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Except_Accrual_Rate,
              Cc.Except_Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
   Union
     Select   'Ex-Onsite-Optical',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Ed.Onsite_Attended Number_Of_Students,
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Except_Accrual_Rate,
              Case
                 When Cc.Except_Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Except_Accrual_Rate * Cc.Eff_Dur * Ed.Onsite_Attended
                 When Cc.Except_Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Except_Accrual_Rate * Ed.Onsite_Attended
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id And F.Enroll_Status = 'Attended'
              Left Outer Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And Cc.Gk_Exception Is Not Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
              And Cd.Course_Type = 'Optical Networking'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   And Ed.Onsite_Attended > 0
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Onsite_Attended,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Except_Accrual_Rate,
              Cc.Except_Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
     Having   Count (F.Enroll_Id) = 0
   Union
     Select   'Ex-Public-Sales_Channel' Cdw_Group,
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Except_Accrual_Rate Cdw_Rate,
              Case
                 When Cc.Except_Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Except_Accrual_Rate * Cc.Eff_Dur * Count (F.Enroll_Id)
                 When Cc.Except_Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Except_Accrual_Rate * Count (F.Enroll_Id)
              End
                 Roy_Amt
       From                  Gkdw.Event_Dim Ed
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
                 Gkdw.Gk_Cdw_Interface Cc
              On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
      Where   F.Enroll_Status In ('Confirmed', 'Attended')
              And Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Cc.Gk_Exception Is Not Null
              And (F.Book_Amt > 0 Or F.Attendee_Type = 'Unlimited')
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Cd.Course_Type != 'Optical Networking'
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
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Except_Accrual_Rate,
              Cc.Cisco_Overall_Source
   Union
     Select   'Ex-Onsite-Sales_Channel',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Except_Accrual_Rate,
              Case
                 When Cc.Except_Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Except_Accrual_Rate * Cc.Eff_Dur * Count (F.Enroll_Id)
                 When Cc.Except_Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Except_Accrual_Rate * Count (F.Enroll_Id)
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Inner Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id
              Inner Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And F.Enroll_Status = 'Attended'
              And Cc.Gk_Exception Is Not Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              And Cd.Course_Type != 'Optical Networking'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Except_Accrual_Rate,
              Cc.Except_Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
   Union
     Select   'Ex-Onsite-Sales_Channel',
              Td.Dim_Period_Name,
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
              Auth_Code Cisco_Dw_Id,
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
              Ed.Onsite_Attended Number_Of_Students,
              Sum (Isnull(Ob.Book_Amt, 0)) Gross_Revenue,
              Ed.Course_Code Course_Code,
              Ed.End_Date - Ed.Start_Date + 1 Event_Dur,
              Cc.Lp_Dur Cdw_Dur,
              Cc.Eff_Dur Cdw_Eff_Dur,
              Cc.Except_Rate_Type,
              Cc.Cisco_Overall_Source,
              Cc.Except_Accrual_Rate,
              Case
                 When Cc.Except_Rate_Type = 'Fixed Daily Rate'
                 Then
                    Cc.Except_Accrual_Rate * Cc.Eff_Dur * Ed.Onsite_Attended
                 When Cc.Except_Rate_Type = 'Fixed Unit Rate'
                 Then
                    Cc.Except_Accrual_Rate * Ed.Onsite_Attended
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
                    Inner Join
                       Gkdw.Gk_Cdw_Interface Cc
                    On Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num
                 Left Outer Join
                    Gkdw.Order_Fact F
                 On Ed.Event_Id = F.Event_Id And F.Enroll_Status = 'Attended'
              Left Outer Join
                 Gkdw.Cust_Dim C
              On F.Cust_Id = C.Cust_Id
      Where   Ed.Event_Id Not In (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Ed.Status In ('Open', 'Verified')
              And Cc.Gk_Exception Is Not Null
              And Cd.Ch_Num = '20'
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cc.Modality = 'Ilt'
              And Cc.Dw_Status != 'Inactive'
              --   And Ed.End_Date-Ed.Start_Date+1 = Cc.Lp_Dur
              And Cd.Course_Type != 'Optical Networking'
              And Substring(Cd.Course_Code, 1,  4) Not In
                       ('5313', '5314', '5316', '5317', '5318', '5319')
   --   And Ed.Onsite_Attended > 0
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Cd.Ch_Num,
              Cd.Md_Num,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Onsite_Attended,
              Ed.Opportunity_Id,
              Td.Dim_Month + ' ' + Td.Dim_Year,
              Auth_Code,
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
              Ed.End_Date - Ed.Start_Date + 1,
              Cc.Except_Accrual_Rate,
              Cc.Except_Rate_Type,
              Cc.Lp_Dur,
              Cc.Eff_Dur,
              Cc.Cisco_Overall_Source
     Having   Count (F.Enroll_Id) = 0
   ;



