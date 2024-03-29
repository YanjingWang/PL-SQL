


Create Or Alter View Hold.Gk_Product_Cw_Cost_V
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
   Cw_Amt
)
As
     Select   Cost_Type,
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
              Sum (Cw_Cost) + Sum (Misc_Cw_Cost) Cw_Amt
       From   (  Select   'Course Materials' Cost_Type,
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
                          Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
                             Rev_Mon_Num,
                          Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0')
                             Rev_Week_Num,
                          Cd.Course_Type,
                          Fr.Region Facility_Region,
                          Cd.Vendor_Code,
                          Sum (Isnull(Qty_Ordered, 0) * Isnull(B.Kit_Price, 0))
                             Cw_Cost,
                          0 Misc_Cw_Cost
                   From                        Cw_Fulfillment@Gkprod Cf
                                            Inner Join
                                               Cw_Bom@Gkprod B
                                            On Cf.Part_Number = B.Kit_Num
                                         Inner Join
                                            Gkdw.Event_Dim Ed
                                         On Cf.Event_Id = Ed.Event_Id
                                      Inner Join
                                         Gkdw.Course_Dim Cd
                                      On Ed.Course_Id = Cd.Course_Id
                                         And Ed.Ops_Country = Cd.Country
                                   Inner Join
                                      Gkdw.Time_Dim Td
                                   On Td.Dim_Date =
                                         Case
                                            When Cd.Md_Num In ('32', '44')
                                            Then
                                               Trunc (Cf.Request_Date)
                                            Else
                                               Ed.Start_Date
                                         End
                                Left Outer Join
                                   Gkdw.Gk_Facility_Region_Mv Fr
                                On Ed.Location_Id = Fr.Evxfacilityid
                                   And Ed.Facility_Region_Metro =
                                         Fr.Facilityregionmetro
                             Left Outer Join
                                Gkdw.Gk_Nested_Courses Nc
                             On Cd.Course_Id = Nc.Nested_Course_Id
                          Left Outer Join
                             Gkdw.Course_Dim Cd1
                          On Nc.Master_Course_Id = Cd1.Course_Id
                             And Ed.Ops_Country = Cd1.Country
                  Where   Ed.Start_Date >= To_Date ('1/1/2004', 'Mm/Dd/Yyyy')
               -- Where Ed.Start_Date Between To_Date('1/1/2004', 'Mm/Dd/Yyyy') And Cast(Getutcdate() As Date)
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
                             Cd.Course_Code
                          + '('
                          + Isnull(Trim (Cd.Short_Name), ' ')
                          + ')',
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
               Union
                 Select   'Course Materials' Cost_Type,
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
                          Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0')
                             Rev_Mon_Num,
                          Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0')
                             Rev_Week_Num,
                          Cd.Course_Type,
                          Fr.Region Facility_Region,
                          Cd.Vendor_Code,
                          0,
                          Case
                             When Mc.Type = 'Per Student'
                             Then
                                Isnull(Ce.Enroll_Cnt, 0) * Isnull(Mc.Cw_Cost, 0)
                             When Mc.Type = 'Per Event'
                             Then
                                Isnull(Mc.Cw_Cost, 0)
                             Else
                                0
                          End
                   From                        Gkdw.Event_Dim Ed
                                            Inner Join
                                               Gkdw.Time_Dim Td
                                            On Ed.Start_Date = Td.Dim_Date
                                         Inner Join
                                            Gkdw.Course_Dim Cd
                                         On Ed.Course_Id = Cd.Course_Id
                                            And Ed.Ops_Country = Cd.Country
                                      Inner Join
                                         Cw_Event_Enroll_V@Gkprod Ce
                                      On Ed.Event_Id = Ce.Evxeventid
                                   Inner Join
                                      Gkdw.Gk_Misc_Cw_Temp Mc
                                   On Substring(Cd.Course_Code, 1,  4) =
                                         Mc.Course_Code
                                Left Outer Join
                                   Gkdw.Gk_Facility_Region_Mv Fr
                                On Ed.Location_Id = Fr.Evxfacilityid
                                   And Ed.Facility_Region_Metro =
                                         Fr.Facilityregionmetro
                             Left Outer Join
                                Gkdw.Gk_Nested_Courses Nc
                             On Cd.Course_Id = Nc.Nested_Course_Id
                          Left Outer Join
                             Gkdw.Course_Dim Cd1
                          On Nc.Master_Course_Id = Cd1.Course_Id
                             And Ed.Ops_Country = Cd1.Country
                  Where   Ed.Start_Date >= To_Date ('1/1/2004', 'Mm/Dd/Yyyy')
                          And Ed.Status != 'Cancelled'
               -- Where Ed.Start_Date Between To_Date('1/1/2004', 'Mm/Dd/Yyyy') And Cast(Getutcdate() As Date)
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
                             Cd.Course_Code
                          + '('
                          + Isnull(Trim (Cd.Short_Name), ' ')
                          + ')',
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
                          Ce.Enroll_Cnt,
                          Mc.Type,
                          Mc.Cw_Cost,
                          Cd.Vendor_Code) a1
   Group By   Cost_Type,
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
              Vendor_Code;



