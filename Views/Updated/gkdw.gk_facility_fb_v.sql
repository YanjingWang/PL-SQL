


Create Or Alter View Hold.Gk_Facility_Fb_V
(
   Ops_Country,
   Facility_Region_Metro,
   Facility_Code,
   Fac_Type,
   Fac_Fb_Per_Stud
)
As
     Select   Ops_Country,
              Facility_Region_Metro,
              Facility_Code,
              Fac_Type,
              Sum (Facility_Fee) / (Sum (Total_Days) * Sum (Enroll_Cnt))
                 Fac_Fb_Per_Stud
       From   (  Select   Ed.Ops_Country,
                          Ed.Event_Id,
                          Ed.Start_Date,
                          Ed.End_Date,
                          Ed.Facility_Region_Metro,
                          Ed.Facility_Code,
                          Case
                             When Ed.Internalfacility = 'T' Then 'Internal'
                             Else 'External'
                          End
                             Fac_Type,
                          Ed.End_Date - Ed.Start_Date + 1 Total_Days,
                          F.Enroll_Cnt,
                          Sum (Pl.Unit_Price * Pl.Quantity) Facility_Fee,
                          Sum (Pl.Unit_Price * Pl.Quantity)
                          / (Ed.End_Date - Ed.Start_Date + 1)
                             Fac_Fb_Per_Stud
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
                             Gkdw.Gk_Oe_Attended_Cnt_V F
                          On Ed.Event_Id = F.Event_Id
                  Where   Pl.Creation_Date Between Cast(Getutcdate() As Date) - 365
                                               And  Cast(Getutcdate() As Date)
                          And Gcc.Segment3 = '64305'
               Group By   Ed.Ops_Country,
                          Ed.Event_Id,
                          Ed.Start_Date,
                          Ed.End_Date,
                          Ed.Facility_Region_Metro,
                          Ed.Facility_Code,
                          Case
                             When Ed.Internalfacility = 'T' Then 'Internal'
                             Else 'External'
                          End,
                          Ed.End_Date - Ed.Start_Date + 1,
                          F.Enroll_Cnt) a1
   Group By   Ops_Country,
              Facility_Region_Metro,
              Facility_Code,
              Fac_Type;



