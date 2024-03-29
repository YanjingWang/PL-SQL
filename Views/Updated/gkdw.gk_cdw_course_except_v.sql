


Create Or Alter View Hold.Gk_Cdw_Course_Except_V
(
   Cdw_Group,
   Period_Name,
   Event_Id,
   Course_Code,
   Start_Date,
   Facility_Code,
   Short_Name,
   Attended_Cnt,
   Onsite_Attended,
   Ops_Country,
   Ch_Num,
   Md_Num,
   Gross_Revenue
)
As
     Select   'Ex-Not_On_Master' Cdw_Group,
              Td.Dim_Period_Name Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Ed.Start_Date,
              Ed.Facility_Code,
              Cd.Short_Name,
              Count (F.Enroll_Id) Attended_Cnt,
              Isnull(Ed.Onsite_Attended, 0) Onsite_Attended,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Upper (C.Country)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Ed.Ops_Country
              End
                 Ops_Country,
              Cd.Ch_Num,
              Cd.Md_Num,
              Sum (Isnull(F.Book_Amt, 0)) + Isnull(Ob.Book_Amt, 0) Gross_Revenue
       From                  Gkdw.Event_Dim Ed
                          Inner Join
                             Gkdw.Course_Dim Cd
                          On Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                       Inner Join
                          Gkdw.Time_Dim Td
                       On Ed.Start_Date = Td.Dim_Date
                    Left Outer Join
                       Gkdw.Order_Fact F
                    On Ed.Event_Id = F.Event_Id
                       And F.Enroll_Status = 'Attended'
                 Left Outer Join
                    Gkdw.Cust_Dim C
                 On F.Cust_Id = C.Cust_Id
              Left Outer Join
                 Gkdw.Gk_Cdw_Onsite_V Ob
              On Ed.Event_Id = Ob.Event_Id
      Where   Ed.Status In ('Open', 'Verified')
              And Ed.Event_Id Not In
                       (  Select   Event_Id From Gkdw.Gk_Cdw_Event_Exclude)
              And Cd.Ch_Num In ('10', '20')
              And Cd.Md_Num In ('10', '20')
              And Cd.Pl_Num = '04'
              And Cd.Course_Code != '9989N'
              And Not Exists
                    (Select   1
                       From   Gkdw.Gk_Cdw_Interface Cc
                      Where   Substring(Ed.Course_Code, 1,  4) = Cc.Gk_Course_Num)
   Group By   Td.Dim_Period_Name,
              Ed.Event_Id,
              Ed.Course_Code,
              Ed.Start_Date,
              Ed.Facility_Code,
              Ed.Onsite_Attended,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Upper (C.Country)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Ed.Ops_Country
              End,
              Cd.Ch_Num,
              Cd.Md_Num,
              Cd.Short_Name,
              Isnull(Ob.Book_Amt, 0);



