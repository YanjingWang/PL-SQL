


Create Or Alter View Hold.Gk_Facility_Av_V
(
   Facility_Region_Metro,
   Facility_Code,
   Total_Days,
   Facility_Fee,
   Facility_Daily_Fee
)
As
     Select   Facility_Region_Metro,
              Facility_Code,
              Sum (Total_Days) Total_Days,
              Sum (Facility_Fee) Facility_Fee,
              Sum (Facility_Fee) / Sum (Total_Days) Facility_Daily_Fee
       From   (  Select   Ed.Event_Id,
                          Ed.Start_Date,
                          Ed.End_Date,
                          Ed.Facility_Region_Metro,
                          Ed.Facility_Code,
                          Ed.End_Date - Ed.Start_Date + 1 Total_Days,
                          Sum (Pl.Unit_Price * Pl.Quantity) Facility_Fee,
                          Sum (Pl.Unit_Price * Pl.Quantity)
                          / (Ed.End_Date - Ed.Start_Date + 1)
                             Facility_Daily_Fee
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
                             Gkdw.Course_Dim Cd
                          On Ed.Course_Id = Cd.Course_Id
                             And Ed.Ops_Country = Cd.Country
                  Where       Pl.Creation_Date >= Cast(Getutcdate() As Date) - 365
                          And Gcc.Segment3 = '64205'
                          And Ed.Internalfacility = 'F'
                          And Cd.Ch_Num = '10'
                          And Cd.Md_Num = '10'
                          And Pl.Item_Description Like 'Av%'
               Group By   Ed.Event_Id,
                          Ed.Start_Date,
                          Ed.End_Date,
                          Ed.Facility_Region_Metro,
                          Ed.Facility_Code,
                          Ed.End_Date - Ed.Start_Date + 1) a1
   Group By   Facility_Region_Metro, Facility_Code;



