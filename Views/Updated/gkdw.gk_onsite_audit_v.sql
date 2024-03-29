


Create Or Alter View Hold.Gk_Onsite_Audit_V
(
   Event_Id,
   Course_Code,
   Course_Name,
   Creation_Date,
   Start_Date,
   End_Date,
   Status,
   Prod_Line,
   Ops_Country,
   Opp_Desc,
   Enroll_Id,
   Enroll_Date,
   Opportunity_Id,
   Fdc_Company,
   Fdc_Base_Price,
   Fdc_Add_Stud,
   Fdc_Other,
   Enroll_Cnt,
   Book_Amt
)
As
     Select   Ed.Event_Id,
              Cd.Course_Code,
              Cd.Course_Name,
              Ed.Creation_Date,
              Ed.Start_Date,
              Ed.End_Date,
              Ed.Status,
              Course_Pl Prod_Line,
              Ed.Ops_Country,
              Od.Description Opp_Desc,
              F.Enroll_Id,
              F.Enroll_Date,
              F.Opportunity_Id,
              Fd.Sold_To_Company Fdc_Company,
              Fd.Base_Price Fdc_Base_Price,
              Fd.Add_Student Fdc_Add_Stud,
              Fd.Other_Fee Fdc_Other,
              Count (F.Enroll_Id) Enroll_Cnt,
              Sum (F.Book_Amt) Book_Amt
       From                     Gkdw.Event_Dim Ed
                             Inner Join
                                Gkdw.Course_Dim Cd
                             On Ed.Course_Id = Cd.Course_Id
                                And Ed.Country = Cd.Country
                          Left Outer Join
                             Gkdw.Order_Fact F
                          On Ed.Event_Id = F.Event_Id And F.Book_Amt != 0
                       Left Outer Join
                          Ons.Idr@R12prd I
                       On F.Opportunity_Id = I.Slx_Opp_Id
                    Left Outer Join
                       Ons.Customer_Onsite@R12prd C
                    On I.Idr_Num = C.Idr_Num And Status_Code = 'A'
                 Left Outer Join
                    Ons.Fdc@R12prd Fd
                 On C.Onsite_Id = Fd.Onsite_Id
              Left Outer Join
                 Gkdw.Opportunity_Dim Od
              On Ed.Opportunity_Id = Od.Opportunity_Id
      Where   Substring(Cd.Course_Code, 5,  1) In ('N', 'V', 'H')
              And Ed.Status In ('Open', 'Verified')
   --And Ed.Creation_Date >= To_Date('7/17/2006','Mm/Dd/Yyyy')
   Group By   Ed.Event_Id,
              Ed.Course_Id,
              Ed.Creation_Date,
              Ed.Start_Date,
              Ed.End_Date,
              Ed.Status,
              Cd.Course_Code,
              Cd.Course_Name,
              Course_Pl,
              Ed.Ops_Country,
              Od.Description,
              F.Enroll_Id,
              F.Enroll_Date,
              F.Opportunity_Id,
              Fd.Submit_Date,
              Fd.Sold_To_Company,
              Fd.Base_Price,
              Fd.Add_Student,
              Fd.Other_Fee
   --Having Count(F.Enroll_Id) = 0
   ;



