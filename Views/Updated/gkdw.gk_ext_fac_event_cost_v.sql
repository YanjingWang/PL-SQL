


Create Or Alter View Hold.Gk_Ext_Fac_Event_Cost_V
(
   Event_Id,
   Fac_Amt
)
As
     Select   Ed.Event_Id, Sum (Pl.Unit_Price * Pl.Quantity) Fac_Amt
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
      Where   Gcc.Segment3 In ('64105', '64205', '64305')
              And Ed.Internalfacility = 'F'
   Group By   Ed.Event_Id;



