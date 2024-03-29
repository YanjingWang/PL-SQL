


Create Or Alter View Hold.Gk_Proctor_Cost_V
(
   Course_Code,
   Event_Id,
   Total_Proctor,
   Student_Cnt
)
As
     Select   Course_Code,
              Event_Id,
              Sum (Total_Proctor_Fee) Total_Proctor,
              Sum (Student_Cnt) Student_Cnt
       From   (  Select   Ed.Course_Code,
                          Ed.Event_Id,
                          Sum (Pl.Unit_Price * Pl.Quantity) Total_Proctor_Fee,
                          0 Student_Cnt
                   From            Po_Lines_All@R12prd Pl
                                Inner Join
                                   Po_Distributions_All@R12prd Pd
                                On Pl.Po_Line_Id = Pd.Po_Line_Id
                             Inner Join
                                Gl_Code_Combinations@R12prd Gcc
                             On Pd.Code_Combination_Id = Gcc.Code_Combination_Id
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On Pd.Attribute2 = Ed.Event_Id
                  Where   Pl.Creation_Date >= Cast(Getutcdate() As Date) - 365
                          And Gcc.Segment3 = '62305'
               Group By   Ed.Course_Code, Ed.Event_Id
               Union All
                 Select   Ed.Course_Code,
                          Ed.Event_Id,
                          0,
                          Count (Distinct F.Enroll_Id)
                   From               Po_Lines_All@R12prd Pl
                                   Inner Join
                                      Po_Distributions_All@R12prd Pd
                                   On Pl.Po_Line_Id = Pd.Po_Line_Id
                                Inner Join
                                   Gl_Code_Combinations@R12prd Gcc
                                On Pd.Code_Combination_Id =
                                      Gcc.Code_Combination_Id
                             Inner Join
                                Gkdw.Event_Dim Ed
                             On Pd.Attribute2 = Ed.Event_Id
                          Inner Join
                             Gkdw.Order_Fact F
                          On Ed.Event_Id = F.Event_Id
                             And F.Enroll_Status = 'Attended'
                  Where   Pl.Creation_Date >= Cast(Getutcdate() As Date) - 365
                          And Gcc.Segment3 = '62305'
               Group By   Ed.Course_Code, Ed.Event_Id) a1
   Group By   Course_Code, Event_Id
     Having   Sum (Student_Cnt) > 0;



