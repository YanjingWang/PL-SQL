


Create Or Alter View Hold.Gk_Gsa_Audit_Detail_V
(
   Dim_Year,
   Dim_Month_Num,
   Enroll_Id,
   Keycode,
   Enroll_Status,
   Fee_Type,
   Source,
   Payment_Method,
   Enroll_Type,
   Event_Id,
   Start_Date,
   End_Date,
   Location_Name,
   Facility_Region_Metro,
   Fac_Address1,
   Fac_City,
   Fac_State,
   Fac_Zipcode,
   Fac_Country,
   Course_Code,
   Course_Name,
   Short_Name,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   List_Price,
   Group_Acct_Name,
   Acct_Id,
   Acct_Name,
   Cust_Name,
   Address1,
   City,
   State,
   Zipcode,
   Country,
   Email,
   Workphone,
   Partner_Name,
   Partner_Type,
   Ppcard_Id,
   Card_Title,
   Card_Type,
   Issued_Date
)
As
   Select   Distinct Td.Dim_Year,
                     Td.Dim_Month_Num,
                     F.Enroll_Id,
                     F.Keycode,
                     F.Enroll_Status,
                     F.Fee_Type,
                     F.Source,
                     F.Payment_Method,
                     F.Enroll_Type,
                     Ed.Event_Id,
                     Ed.Start_Date,
                     Ed.End_Date,
                     Ed.Location_Name,
                     Ed.Facility_Region_Metro,
                     Ed.Address1 Fac_Address1,
                     Ed.City Fac_City,
                     Ed.State Fac_State,
                     Ed.Zipcode Fac_Zipcode,
                     Ed.Country Fac_Country,
                     Cd.Course_Code,
                     Cd.Course_Name,
                     Cd.Short_Name,
                     Cd.Course_Ch,
                     Cd.Course_Mod,
                     Cd.Course_Pl,
                     Cd.List_Price,
                     Isnull(R.Group_Acct_Name, C.Acct_Name) Group_Acct_Name,
                     C.Acct_Id,
                     C.Acct_Name,
                     C.Cust_Name,
                     C.Address1,
                     C.City,
                     C.State,
                     C.Zipcode,
                     C.Country,
                     C.Email,
                     C.Workphone,
                     P.Partner_Name,
                     P.Partner_Type,
                     F.Ppcard_Id,
                     Pd.Card_Title,
                     Pd.Card_Type,
                     Pd.Issued_Date
     From                        Gkdw.Order_Fact F
                              Inner Join
                                 Gkdw.Event_Dim Ed
                              On F.Event_Id = Ed.Event_Id
                           Inner Join
                              Gkdw.Course_Dim Cd
                           On Ed.Course_Id = Cd.Course_Id
                              And Ed.Ops_Country = Cd.Country
                        Inner Join
                           Gkdw.Cust_Dim C
                        On C.Cust_Id = F.Cust_Id
                     Inner Join
                        Gkdw.Time_Dim Td
                     On Trunc (F.Creation_Date) = Td.Dim_Date
                  Left Outer Join
                     Gkdw.Gk_Account_Groups_Naics R
                  On C.Acct_Id = R.Acct_Id
               Left Outer Join
                  Gkdw.Gk_Channel_Partner P
               On F.Keycode = P.Partner_Key_Code
            Left Outer Join
               Gkdw.Ppcard_Dim Pd
            On F.Ppcard_Id = Pd.Ppcard_Id
    Where   F.Creation_Date >= '01-Jan-2010'
            And F.Rowid = (Select   Max (F2.Rowid)
                             From   Gkdw.Order_Fact F2
                            Where   F.Enroll_Id = F2.Enroll_Id)
   --And F.Creation_Date = (Select Max(F2.Creation_Date) From Gkdw.Order_Fact F2 Where F.Enroll_Id = F2.Enroll_Id)
   --And F.Fee_Type Not In ('Ons - Additional','Ons - Individual','Ons-Additional')
   --And F.Book_Amt > 0
   --And F.Enroll_Status In ('Confirmed','Attended')
   Union
   Select   Distinct Td.Dim_Year,
                     Td.Dim_Month_Num,
                     Sf.Sales_Order_Id,
                     Sf.Keycode,
                     Sf.So_Status,
                     Null Fee_Type,
                     Sf.Source,
                     Sf.Payment_Method,
                     Null Enroll_Type,
                     Pd.Card_Number,
                     Pd.Issued_Date,
                     Pd.Expires_Date,
                     Pd.Card_Type,
                     'Spel',
                     Null,
                     Null,
                     Null,
                     Null,
                     Null,
                     Prd.Prod_Num,
                     Prd.Prod_Name,
                     Prd.Prod_Name,
                     Prd.Prod_Channel,
                     Prd.Prod_Modality,
                     Prd.Prod_Line,
                     Prd.List_Price,
                     Isnull(R.Group_Acct_Name, C.Acct_Name) Group_Acct_Name,
                     C.Acct_Id,
                     C.Acct_Name,
                     C.Cust_Name,
                     C.Address1,
                     C.City,
                     C.State,
                     C.Zipcode,
                     C.Country,
                     C.Email,
                     C.Workphone,
                     P.Partner_Name,
                     P.Partner_Type,
                     Null,
                     Null,
                     Null,
                     Null
     From                     Gkdw.Sales_Order_Fact Sf
                           Left Outer Join
                              Gkdw.Ppcard_Dim Pd
                           On Sf.Ppcard_Id = Pd.Ppcard_Id
                        Inner Join
                           Gkdw.Product_Dim Prd
                        On Sf.Product_Id = Prd.Product_Id
                     Inner Join
                        Gkdw.Cust_Dim C
                     On C.Cust_Id = Sf.Cust_Id
                  Inner Join
                     Gkdw.Time_Dim Td
                  On Trunc (Sf.Creation_Date) = Td.Dim_Date
               Left Outer Join
                  Gkdw.Gk_Account_Groups_Naics R
               On C.Acct_Id = R.Acct_Id
            Left Outer Join
               Gkdw.Gk_Channel_Partner P
            On Sf.Keycode = P.Partner_Key_Code
    Where   Sf.Creation_Date >= '01-Jan-2010'
            And Sf.Rowid = (Select   Max (Sf2.Rowid)
                              From   Gkdw.Sales_Order_Fact Sf2
                             Where   Sf2.Sales_Order_Id = Sf.Sales_Order_Id)
--And Sf.Creation_Date = (Select Max(Sf2.Creation_Date) From Gkdw.Sales_Order_Fact Sf2 Where Sf2.Sales_Order_Id = Sf.Sales_Order_Id)
--And Sf.Book_Amt > 0
--And Sf.Cancel_Date Is Null;



