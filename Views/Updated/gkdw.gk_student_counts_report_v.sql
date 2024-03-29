


Create Or Alter View Hold.Gk_Student_Counts_Report_V
(
   Le_Num,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Technology,
   Course_Code,
   Course_Name,
   Event_Id,
   Enroll_Id,
   Enroll_Status,
   Rev_Year,
   Rev_Month,
   Customer_Account_Name,
   Location_Name,
   Facility_Region_Metro
)
As
   Select   Distinct C.Le_Num,
                     C.Ch_Num,
                     C.Md_Num,
                     C.Pl_Num,
                     C.Subtech_Type1 As Technology,
                     C.Course_Code,
                     C.Course_Name,
                     E.Event_Id,
                     O.Enroll_Id,
                     O.Enroll_Status,
                     Year(O.Rev_Date) As Rev_Year,
                     Month(O.Rev_Date) As Rev_Month,
                     O.Acct_Name As Customer_Account_Name,
                     E.Location_Name,
                     E.Facility_Region_Metro
     From         Gkdw.Order_Fact O
               Inner Join
                  Gkdw.Event_Dim E
               On O.Event_Id = E.Event_Id
            Inner Join
               Gkdw.Course_Dim C
            On E.Course_Id = C.Course_Id And E.Ops_Country = C.Country
    Where   O.Rev_Date Between '16-Jan-01' And '18-May-25';



