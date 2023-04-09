


Create Or Alter View Hold.Gk_Product_Inst_Cost_V
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
   Inst_Amt
)
As
     Select   'Instructor Cost' Cost_Type,
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
              Sum (Isnull(Pl.Item_Qty, 0) * Isnull(Pl.Item_Unit_Price, 0)) Inst_Amt
       From                              Inst_Po_Header@Gkprod Ph
                                      Inner Join
                                         Inst_Po_Line@Gkprod Pl
                                      On Ph.Po_Num = Pl.Po_Num
                                   Inner Join
                                      Gl_Code_Combinations@R12prd Gcc
                                   On Pl.Charge_Acct_Id =
                                         Gcc.Code_Combination_Id
                                Inner Join
                                   Gkdw.Acct_Dim Ad
                                On Gcc.Segment3 = Ad.Acct_Value
                                   And Ad.Acct_Value In ('62305', '62310')
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Ph.Evxeventid = Ed.Event_Id
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
      Where   Ed.Start_Date >= To_Date ('1/1/2004', 'Mm/Dd/Yyyy')
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



