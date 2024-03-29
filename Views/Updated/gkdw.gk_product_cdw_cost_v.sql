


Create Or Alter View Hold.Gk_Product_Cdw_Cost_V
(
   Cost_Type,
   Event_Id,
   Event_Desc,
   Rev_Date,
   Ops_Country,
   Facility_Region_Metro,
   Ch_Num,
   Course_Ch,
   Md_Num,
   Course_Mod,
   Pl_Num,
   Course_Pl,
   Course_Name,
   Course_Code,
   Rev_Year,
   Rev_Quarter,
   Rev_Month,
   Rev_Mon_Num,
   Rev_Week_Num,
   Course_Type,
   Facility_Region,
   Vendor_Code,
   Cdw_Amt
)
As
     Select   'Cisco Dw' Cost_Type,
              Ed.Event_Id,
                 Cd.Course_Code
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Ed.Start_Date, 'Yymmdd')
              + '('
              + Ed.Event_Id
              + ')'
                 Event_Desc,
              Ed.Start_Date Rev_Date,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Cd.Course_Mod,
              Cd.Pl_Num,
              Cd.Course_Pl,
              Cd.Course_Name,
              Case
                 When Nc.Nested_Course_Id Is Not Null
                 Then
                       Cd1.Course_Code
                    + '('
                    + Isnull(Trim (Cd1.Short_Name), ' ')
                    + ')'
                 Else
                       Cd.Course_Code
                    + '('
                    + Isnull(Trim (Cd.Short_Name), ' ')
                    + ')'
              End
                 Course_Code,
              Td.Dim_Year Rev_Year,
              Td.Dim_Year + '-Qtr ' + Td.Dim_Quarter Rev_Quarter,
              Td.Dim_Year + '-' + Td.Dim_Month Rev_Month,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Rev_Mon_Num,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Rev_Week_Num,
              Cd.Course_Type,
              Fr.Region Facility_Region,
              Cd.Vendor_Code,
              Sum (Cm.Roy_Amt) Cdw_Amt
       From                     Gkdw.Gk_Cdw_Monthly_V Cm
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Cm.Event_Id = Ed.Event_Id
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Ed.Start_Date = Td.Dim_Date
                       Inner Join
                          Gkdw.Course_Dim Cd
                       On Ed.Course_Id = Cd.Course_Id
                          And Ed.Ops_Country = Cd.Country
                    Left Outer Join
                       Gkdw.Gk_Facility_Region_Mv Fr
                    On Ed.Location_Id = Fr.Evxfacilityid
                       And Ed.Facility_Region_Metro = Fr.Facilityregionmetro
                 Left Outer Join
                    Gkdw.Gk_Nested_Courses Nc
                 On Cd.Course_Id = Nc.Nested_Course_Id
              Left Outer Join
                 Gkdw.Course_Dim Cd1
              On Nc.Master_Course_Id = Cd1.Course_Id
                 And Ed.Ops_Country = Cd1.Country
      Where   Ed.Start_Date >= To_Date ('8/23/2008', 'Mm/Dd/Yyyy')
   -- Where Ed.Start_Date Between To_Date('8/23/2008', 'Mm/Dd/Yyyy') And Cast(Getutcdate() As Date)
   Group By   Ed.Event_Id,
                 Cd.Course_Code
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Ed.Start_Date, 'Yymmdd')
              + '('
              + Ed.Event_Id
              + ')',
              Ed.Start_Date,
              Ed.Ops_Country,
              Facility_Region_Metro,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Cd.Course_Mod,
              Cd.Pl_Num,
              Cd.Course_Pl,
              Cd.Course_Name,
              Cd.Course_Code + '(' + Isnull(Trim (Cd.Short_Name), ' ') + ')',
              Nc.Nested_Course_Id,
                 Cd1.Course_Code
              + '('
              + Isnull(Trim (Cd1.Short_Name), ' ')
              + ')',
              Td.Dim_Year,
              Td.Dim_Year + '-Qtr ' + Td.Dim_Quarter,
              Td.Dim_Year + '-' + Td.Dim_Month,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0'),
              Cd.Course_Type,
              Fr.Region,
              Cd.Vendor_Code
   Union All
     Select   'Cisco Dw' Cost_Type,
              Ed.Event_Id,
                 Cd.Course_Code
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Ed.Start_Date, 'Yymmdd')
              + '('
              + Ed.Event_Id
              + ')'
                 Event_Desc,
              Ed.Start_Date Rev_Date,
              Ed.Ops_Country,
              Ed.Facility_Region_Metro,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Cd.Course_Mod,
              Cd.Pl_Num,
              Cd.Course_Pl,
              Cd.Course_Name,
              Case
                 When Nc.Nested_Course_Id Is Not Null
                 Then
                       Cd1.Course_Code
                    + '('
                    + Isnull(Trim (Cd1.Short_Name), ' ')
                    + ')'
                 Else
                       Cd.Course_Code
                    + '('
                    + Isnull(Trim (Cd.Short_Name), ' ')
                    + ')'
              End
                 Course_Code,
              Td.Dim_Year Rev_Year,
              Td.Dim_Year + '-Qtr ' + Td.Dim_Quarter Rev_Quarter,
              Td.Dim_Year + '-' + Td.Dim_Month Rev_Month,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Rev_Mon_Num,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Rev_Week_Num,
              Cd.Course_Type,
              Fr.Region Facility_Region,
              Cd.Vendor_Code,
              Sum(Case
                     When (Ed.End_Date - Ed.Start_Date + 1) * Royalty_Day >
                             Max_Royalty
                     Then
                        Max_Royalty
                     Else
                        ( (Ed.End_Date - Ed.Start_Date + 1) * Royalty_Day)
                        - (Case When Cc.Self_Print_Disc = 'Y' Then 15 Else 0 End)
                  End)
                 Cdw_Amt
       From                           Gkdw.Course_Dim Cd
                                   Inner Join
                                      Gkdw.Event_Dim Ed
                                   On Cd.Course_Id = Ed.Course_Id
                                      And Cd.Country = Ed.Ops_Country
                                Inner Join
                                   Gkdw.Order_Fact F
                                On Ed.Event_Id = F.Event_Id
                             Inner Join
                                Gkdw.Cust_Dim C
                             On F.Cust_Id = C.Cust_Id
                          Inner Join
                             Gkdw.Time_Dim Td
                          On Td.Dim_Date = F.Rev_Date
                       Inner Join
                          Gkdw.Gk_Cdw_Courses Cc
                       On Substring(Cd.Course_Code, 1,  4) = Cc.Gk_Course_Code
                          And Cdw_Level != 'Spel'
                    Left Outer Join
                       Gkdw.Gk_Facility_Region_Mv Fr
                    On Ed.Location_Id = Fr.Evxfacilityid
                       And Ed.Facility_Region_Metro = Fr.Facilityregionmetro
                 Left Outer Join
                    Gkdw.Gk_Nested_Courses Nc
                 On Cd.Course_Id = Nc.Nested_Course_Id
              Left Outer Join
                 Gkdw.Course_Dim Cd1
              On Nc.Master_Course_Id = Cd1.Course_Id
                 And Ed.Ops_Country = Cd1.Country
      Where       Enroll_Status In ('Confirmed', 'Attended')
              And Cd.Pl_Num = '04'
              And Cd.Ch_Num = '10'
              And Cd.Md_Num In ('10', '20')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And F.Book_Amt > 0
              And Ed.Start_Date Between To_Date ('1/1/2004', 'Mm/Dd/Yyyy')
                                    And  To_Date ('8/23/2008', 'Mm/Dd/Yyyy')
   Group By   Ed.Event_Id,
                 Cd.Course_Code
              + '-'
              + Facility_Region_Metro
              + '-'
              + Format(Ed.Start_Date, 'Yymmdd')
              + '('
              + Ed.Event_Id
              + ')',
              Ed.Start_Date,
              Ed.Ops_Country,
              Facility_Region_Metro,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Cd.Course_Mod,
              Cd.Pl_Num,
              Cd.Course_Pl,
              Cd.Course_Name,
              Cd.Course_Code + '(' + Isnull(Trim (Cd.Short_Name), ' ') + ')',
              Nc.Nested_Course_Id,
                 Cd1.Course_Code
              + '('
              + Isnull(Trim (Cd1.Short_Name), ' ')
              + ')',
              Td.Dim_Year,
              Td.Dim_Year + '-Qtr ' + Td.Dim_Quarter,
              Td.Dim_Year + '-' + Td.Dim_Month,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0'),
              Cd.Course_Type,
              Fr.Region,
              Cd.Vendor_Code;



