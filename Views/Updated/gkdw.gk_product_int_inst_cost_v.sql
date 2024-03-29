


Create Or Alter View Hold.Gk_Product_Int_Inst_Cost_V
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
   Int_Inst_Amt
)
As
     Select   'Internal Instructor Cost' Cost_Type,
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
              Cd.Course_Code + '(' + Isnull(Trim (Cd.Short_Name), ' ') + ')'
                 Course_Code,
              Td.Dim_Year Rev_Year,
              Td.Dim_Year + '-Qtr ' + Td.Dim_Quarter Rev_Quarter,
              Td.Dim_Year + '-' + Td.Dim_Month Rev_Month,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0') Rev_Mon_Num,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Rev_Week_Num,
              Cd.Course_Type,
              Fr.Region Facility_Region,
              Cd.Vendor_Code,
              Sum (Ir.Int_Inst_Rate * (Ed.End_Date - Ed.Start_Date + 1))
                 Int_Inst_Amt
       From                  Gkdw.Event_Dim Ed
                          Inner Join
                             Gkdw.Instructor_Event_V Ie
                          On Ed.Event_Id = Ie.Evxeventid
                             And (Upper (Account) Like 'Global Know%'
                                  Or Upper (Account) Like 'Nexient%')
                       Inner Join
                          Gkdw.Time_Dim Td
                       On Ed.Start_Date = Td.Dim_Date
                    Inner Join
                       Gkdw.Course_Dim Cd
                    On Ed.Course_Id = Cd.Course_Id
                       And Ed.Ops_Country = Cd.Country
                 Inner Join
                    Gkdw.Gk_Int_Inst_Rate_Pl Ir
                 On Cd.Pl_Num = Ir.Pl_Num
              Left Outer Join
                 Gkdw.Gk_Facility_Region_Mv Fr
              On Ed.Location_Id = Fr.Evxfacilityid
                 And Ed.Facility_Region_Metro = Fr.Facilityregionmetro
      Where       Ed.Start_Date >= To_Date ('1/1/2004', 'Mm/Dd/Yyyy')
              And Ed.Status != 'Cancelled'
              And Ie.Feecode In ('Si', 'Ins')
              And Not Exists (Select   1
                                From   Gkdw.Gk_Nested_Courses C
                               Where   C.Nested_Course_Id = Cd.Course_Id)
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
              Td.Dim_Year,
              Td.Dim_Year + '-Qtr ' + Td.Dim_Quarter,
              Td.Dim_Year + '-' + Td.Dim_Month,
              Td.Dim_Year + '-' + Lpad (Td.Dim_Month_Num, 2, '0'),
              Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0'),
              Cd.Course_Type,
              Fr.Region,
              Cd.Vendor_Code;



