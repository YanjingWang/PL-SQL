


Create Or Alter View Hold.Gk_Nxt_Commission_Orders_V
(
   Rev_Period_Name,
   Operating_Unit,
   Inv_Type,
   Trx_Type,
   Inv_Num,
   Order_Num,
   Rev_Date,
   Customer_Name,
   Product_Num,
   Person_Id,
   Event_Id,
   Oracle_Item_Id,
   City,
   Province,
   Zipcode,
   Company_City,
   Company_Province,
   Company_Zip,
   Book_Amt,
   Act_Num,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Acct_Num,
   Customer_Trx_Id,
   Org_Id,
   Created_By,
   Customer_Number,
   Nat_Acct_Flag,
   Keycode,
   Po_Number,
   Sales_Rep,
   Fee_Type,
   Source,
   Book_Date
)
As
   Select   Td.Dim_Period_Name Rev_Period_Name,
            Hou.Name Operating_Unit,
            Rctt.Name Inv_Type,
            Rctt.Type Trx_Type,
            F.Oracle_Trx_Num Inv_Num,
            F.Enroll_Id Order_Num,
            F.Rev_Date,
            Cd.Acct_Name Customer_Name,
            C.Oracle_Item_Num Product_Num,
            F.Cust_Id Person_Id,
            F.Event_Id,
            C.Oracle_Item_Id,
            Cd.City,
            Cd.Province,
            Cd.Zipcode,
            --Rctl.Line_Number Line_Number,
            Ad.City Company_City,
            Ad.Province Company_Province,
            Ad.Zipcode Company_Zip,
            F.Book_Amt,
            -- Null Amt_Applied, Null Gl_Date, Null Closed_Date,
            C.Act_Num,
            C.Ch_Num,
            C.Md_Num,
            C.Pl_Num,
            Gcc.Segment3 Acct_Num,
            --Null Account, Null Acct_Amount,
            Rct.Customer_Trx_Id Customer_Trx_Id,
            Rct.Org_Id Org_Id,
            Rct.Created_By Created_By,
            Cd.Acct_Id Customer_Number,
            Ad.National_Terr_Id Nat_Acct_Flag,
            F.Keycode,
            F.Po_Number,
            Rct.Attribute13 Sales_Rep,                         --F.Salesperson
            F.Fee_Type,
            F.Source,
            F.Book_Date
     From                                    Gkdw.Order_Fact F
                                          Join
                                             Gkdw.Time_Dim Td
                                          On F.Rev_Date = Td.Dim_Date
                                       Join
                                          Gkdw.Cust_Dim Cd
                                       On F.Cust_Id = Cd.Cust_Id
                                    Join
                                       Gkdw.Account_Dim Ad
                                    On Cd.Acct_Id = Ad.Acct_Id
                                 Join
                                    Gkdw.Event_Dim Ed
                                 On F.Event_Id = Ed.Event_Id
                              Join
                                 Gkdw.Course_Dim C
                              On Ed.Course_Id = C.Course_Id
                                 And Ed.Ops_Country = C.Country
                           Left Join
                              Gkdw.Gk_Territory Gt
                           On Cd.Zipcode Between Gt.Zip_Start And Gt.Zip_End
                              And Gt.Territory_Type = 'Ob'
                        Left Join
                           Ra_Customer_Trx_All@R12prd Rct
                        On F.Oracle_Trx_Num = Rct.Trx_Number
                     Left Join
                        Hr_Operating_Units@R12prd Hou
                     On Rct.Org_Id = Hou.Organization_Id
                  Left Join
                     Ra_Cust_Trx_Types_All@R12prd Rctt
                  On Rct.Cust_Trx_Type_Id = Rctt.Cust_Trx_Type_Id
                     And Rct.Org_Id = Rctt.Org_Id
               Left Join
                  Mtl_System_Items_B@R12prd Msi
               On C.Oracle_Item_Id = Msi.Inventory_Item_Id
            Join
               Gl_Code_Combinations@R12prd Gcc
            On Msi.Sales_Account = Gcc.Code_Combination_Id
    Where       Attendee_Type = 'Nexient'
            And Rev_Date >= '01-Jan-2010'
            --  And Rctl.Line_Type = 'Line'
            -- And F.Enroll_Id = 'Q6uj9a3unuqa'
            And Msi.Organization_Id = 88
            -- Decode(Upper(Country_In), 'Canada', 103, 101)
            And Msi.Invoiceable_Item_Flag = 'Y'
            And Msi.Invoice_Enabled_Flag = 'Y'
   Union
   Select   Td.Dim_Period_Name Rev_Period_Name,
            Noo.Operating_Unit,
            Noo.Inv_Type,
            Noo.Trx_Type,
            Noo.Inv_Num,
            Noo.Order_Num,
            Noo.Rev_Start_Date,
            Noo.Customer_Name Customer_Name,
            Noo.Product,
            Noo.Person_Id,
            Noo.Event_Id,
            Noo.Inventory_Item_Id Oracle_Item_Id,
            Null City,
            Null Province,
            Null Zipcode,
            Noo.Company_City,
            Noo.Company_Province,
            Noo.Company_Zip,
            Noo.Rev_Amount,
            Noo.Act,
            Noo.Ch,
            Noo.Mod,
            Noo.Pl,
            Noo.Acct,
            Noo.Customer_Trx_Id,
            Noo.Org_Id,
            Noo.Created_By,
            Noo.Customer_Number,
            Null Nat_Acct_Flag,
            Null Keycode,
            Noo.Purchase_Order Po_Number,
            Sales_Rep,
            Null Fee_Type,
            Null Source,
            Noo.Order_Date
     From      Gk_Nxt_Ora_Orders_V@R12prd Noo
            Join
               Gkdw.Time_Dim Td
            On Noo.Rev_Start_Date = Td.Dim_Date;



