


Create Or Alter View Hold.Gk_Cisco_Dw_V
(
   Period_Name,
   Country,
   Course_Code,
   Event_Id,
   Ev_Len,
   Ch_Num,
   Course_Ch,
   Md_Num,
   Course_Mod,
   Cnt,
   Rev_Amt,
   Royalty_Day,
   Source1_Pct,
   Source2_Pct,
   Source3_Pct,
   Source4_Pct,
   Source5_Pct,
   Self_Print_Disc_Amt,
   Roy_Amt
)
As
     Select   Td.Dim_Period_Name Period_Name,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Upper (C.Country)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Upper (Cd.Country)
              End
                 Country,
              Cd.Course_Code,
              Ed.Event_Id,
              Ed.End_Date - Ed.Start_Date + 1 Ev_Len,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Course_Mod,
              Sum (Case When Book_Amt > 0 Then 1 Else 0 End) Cnt,
              Sum (Book_Amt) Rev_Amt,
              Gc.Royalty_Day,
              Gc.Source1_Pct,
              Gc.Source2_Pct,
              Gc.Source3_Pct,
              Gc.Source4_Pct,
              Gc.Source5_Pct,
              Case When Gc.Self_Print_Disc = 'Y' Then 15 Else 0 End Self_Print_Disc_Amt,
                Gc.Royalty_Day
              * (Ed.End_Date - Ed.Start_Date + 1)
              * Sum (Case When Book_Amt > 0 Then 1 Else 0 End)
              - (Case When Gc.Self_Print_Disc = 'Y' Then 15 Else 0 End
                 * Sum (Case When Book_Amt > 0 Then 1 Else 0 End))
                 Roy_Amt
       From                  Gkdw.Course_Dim Cd
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On Cd.Course_Id = Ed.Course_Id
                             And Cd.Country = Ed.Country
                       Inner Join
                          Gkdw.Order_Fact O
                       On Ed.Event_Id = O.Event_Id
                    Inner Join
                       Gkdw.Cust_Dim C
                    On O.Cust_Id = C.Cust_Id
                 Inner Join
                    Gkdw.Time_Dim Td
                 On O.Rev_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Cdw_Courses Gc
              On Substring(Cd.Course_Code, 1,  4) = Gc.Gk_Course_Code
      Where       Enroll_Status In ('Confirmed', 'Attended')
              And Cd.Pl_Num = '04'
              And Cd.Ch_Num = '10'
              And Cd.Md_Num Not In ('31', '32', '43', '44')
   --   And Td.Dim_Period_Name = 'Mar-06'
   Group By   Td.Dim_Period_Name,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Upper (C.Country)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Upper (Cd.Country)
              End,
              Cd.Course_Code,
              Ed.Event_Id,
              Ed.End_Date - Ed.Start_Date + 1,
              Cd.Ch_Num,
              Course_Ch,
              Cd.Md_Num,
              Course_Mod,
              Gc.Royalty_Day,
              Gc.Source1_Desc,
              Gc.Source1_Pct,
              Gc.Source2_Desc,
              Gc.Source2_Pct,
              Gc.Source3_Desc,
              Gc.Source3_Pct,
              Gc.Source4_Desc,
              Gc.Source4_Pct,
              Gc.Source5_Desc,
              Gc.Source5_Pct,
              Gc.Self_Print_Disc
   Union
     Select   Td.Dim_Period_Name,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Upper (C.Country)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Upper (Cd.Country)
              End,
              Cd.Course_Code,
              Ed.Event_Id,
              Ed.End_Date - Ed.Start_Date + 1 Ev_Len,
              Cd.Ch_Num,
              Cd.Course_Ch,
              Cd.Md_Num,
              Course_Mod,
              Ed.Capacity Cnt,
              Sum (Book_Amt) Rev_Amt,
              Gc.Royalty_Day,
              Gc.Source1_Pct,
              Gc.Source2_Pct,
              Gc.Source3_Pct,
              Gc.Source4_Pct,
              Gc.Source5_Pct,
              Case When Gc.Self_Print_Disc = 'Y' Then 15 Else 0 End Self_Print_Disc_Amt,
                Gc.Royalty_Day
              * (Ed.End_Date - Ed.Start_Date + 1)
              * Sum (Case When Book_Amt = 0 Then 1 Else 0 End)
              - (Case When Gc.Self_Print_Disc = 'Y' Then 15 Else 0 End
                 * Sum (Case When Book_Amt = 0 Then 1 Else 0 End))
                 Roy_Amt
       From                  Gkdw.Course_Dim Cd
                          Inner Join
                             Gkdw.Event_Dim Ed
                          On Cd.Course_Id = Ed.Course_Id
                             And Cd.Country = Ed.Country
                       Inner Join
                          Gkdw.Order_Fact O
                       On Ed.Event_Id = O.Event_Id
                    Inner Join
                       Gkdw.Cust_Dim C
                    On O.Cust_Id = C.Cust_Id
                 Inner Join
                    Gkdw.Time_Dim Td
                 On Ed.Start_Date = Td.Dim_Date
              Left Outer Join
                 Gkdw.Gk_Cdw_Courses Gc
              On Substring(Cd.Course_Code, 1,  4) = Gc.Gk_Course_Code
      Where       Ed.Status In ('Open', 'Verified')
              And Cd.Pl_Num = '04'
              And Cd.Ch_Num = '20'
   --   And Td.Dim_Period_Name = 'Mar-06'
   Group By   Td.Dim_Period_Name,
              Case
                 When Cd.Md_Num = '20' And Upper (C.Country) = 'Canada'
                 Then
                    Upper (C.Country)
                 When Cd.Md_Num = '20'
                 Then
                    'Usa'
                 Else
                    Upper (Cd.Country)
              End,
              Cd.Course_Code,
              Ed.Event_Id,
              Ed.End_Date - Ed.Start_Date + 1,
              Cd.Ch_Num,
              Course_Ch,
              Cd.Md_Num,
              Course_Mod,
              Ed.Capacity,
              Gc.Royalty_Day,
              Gc.Source1_Pct,
              Gc.Source2_Pct,
              Gc.Source3_Pct,
              Gc.Source4_Pct,
              Gc.Source5_Pct,
              Gc.Self_Print_Disc
   Union
     Select   Td.Dim_Period_Name,
              Upper (Sf.Ship_To_Country),
              Sf.Prod_Num,
              Sf.Product_Id,
              1,
              Pd.Ch_Num,
              Pd.Prod_Channel,
              Pd.Md_Num,
              Pd.Prod_Channel,
              Sum (Quantity),
              Sum (Book_Amt),
              Null,
              Null,
              Null,
              Null,
              Null,
              Null,
              Null,
              Null
       From         Gkdw.Sales_Order_Fact Sf
                 Inner Join
                    Gkdw.Product_Dim Pd
                 On Sf.Product_Id = Pd.Product_Id
              Inner Join
                 Gkdw.Time_Dim Td
              On Sf.Rev_Date = Td.Dim_Date
      Where       Record_Type = 'Salesorder'
              And So_Status = 'Shipped'
              And Pd.Pl_Num = '04'
   --And Dim_Period_Name = 'Mar-06'
   Group By   Td.Dim_Period_Name,
              Upper (Sf.Ship_To_Country),
              Sf.Prod_Num,
              Sf.Product_Id,
              1,
              Pd.Ch_Num,
              Pd.Prod_Channel,
              Pd.Md_Num,
              Pd.Prod_Channel
   Union
     Select   Gp.Period_Name,
              Decode (Rct.Org_Id,
                      '86',
                      'Canada',
                      '87',
                      'Canada',
                      '84',
                      'Usa',
                      '85',
                      'Usa'),
              Msi.Attribute1 Course_Code,
              Msi.Attribute1 Event_Id,
              1,
              Gcc.Segment4,
              Cd.Ch_Desc,
              Gcc.Segment5,
              Md.Md_Desc,
              Count (Distinct Rct.Trx_Number) Cnt,
              Sum (Rctd.Amount) Amt,
              Null,
              Null,
              Null,
              Null,
              Null,
              Null,
              Null,
              Null
       From   Gl_Code_Combinations@R12prd Gcc,
              Ra_Customer_Trx_Lines_All@R12prd Rctl,
              Ra_Cust_Trx_Line_Gl_Dist_All@R12prd Rctd,
              Ra_Cust_Trx_Types_All@R12prd Rctt,
              Gl_Periods@R12prd Gp,
              Ra_Customer_Trx_All@R12prd Rct,
              Mtl_System_Items@R12prd Msi,
              Ch_Dim Cd,
              Md_Dim Md
      Where       Rctl.Customer_Trx_Id = Rct.Customer_Trx_Id
              And Rctl.Customer_Trx_Line_Id = Rctd.Customer_Trx_Line_Id
              And Rct.Cust_Trx_Type_Id = Rctt.Cust_Trx_Type_Id
              And Rct.Org_Id = Rctt.Org_Id
              And Rctd.Code_Combination_Id = Gcc.Code_Combination_Id
              And Rctd.Gl_Date Between Gp.Start_Date And Gp.End_Date
              And Rctl.Inventory_Item_Id = Msi.Inventory_Item_Id
              And Msi.Organization_Id = 88
              And Gcc.Segment4 = Cd.Ch_Value
              And Gcc.Segment5 = Md.Md_Value
              And Rctt.Type In ('Inv', 'Cm')
              And Rctd.Account_Class = 'Rev'
              And Gcc.Segment4 = '10'
              And Gcc.Segment5 In ('31', '32', '43', '44')
              And Gcc.Segment6 = '04'
   --   And Gp.Period_Name = 'Mar-06'
   Group By   Gp.Period_Name,
              Msi.Attribute1,
              Rct.Attribute5,
              Decode (Rct.Org_Id,
                      '86',
                      'Canada',
                      '87',
                      'Canada',
                      '84',
                      'Usa',
                      '85',
                      'Usa'),
              Gcc.Segment4,
              Cd.Ch_Desc,
              Gcc.Segment5,
              Md.Md_Desc;



