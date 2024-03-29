


Create Or Alter View Hold.Gk_All_Orders_V
(
   Enroll_Id,
   Event_Id,
   Cust_Id,
   Keycode,
   Fee_Type,
   Enroll_Status,
   Book_Date,
   Rev_Date,
   Book_Amt,
   Ops_Country,
   Country,
   Cust_Country,
   Event_Type,
   Facility_Region_Metro,
   Ch_Num,
   Course_Ch,
   Md_Num,
   Course_Mod,
   Pl_Num,
   Course_Pl,
   Course_Name,
   Course_Code,
   Acct_Id,
   Acct_Name,
   Cust_Name,
   State,
   Cust_State,
   Salesperson,
   List_Price,
   Source,
   Pp_Sales_Order_Id,
   Course_Type,
   Course_Group,
   Zipcode,
   Cust_Scf,
   Order_Type,
   Event_Status,
   Event_Start_Date,
   Payment_Method,
   Sf_Opportunity_Id
)
As
   Select   F.Enroll_Id,
            F.Event_Id,
            F.Cust_Id,
            F.Keycode,
            F.Fee_Type,
            F.Enroll_Status,
            F.Book_Date,
            F.Rev_Date,
            F.Book_Amt,
            Ed.Ops_Country,
            Ed.Country,
            C.Country Cust_Country,
            Event_Type,
            Facility_Region_Metro,
            Cd.Ch_Num,
            Cd.Course_Ch,
            Cd.Md_Num,
            Cd.Course_Mod,
            Cd.Pl_Num,
            Cd.Course_Pl,
            Cd.Course_Name,
            Cd.Course_Code,
            A.Acct_Id,
            A.Acct_Name,
            C.Cust_Name,
            Decode (Upper (Ed.Country), 'Canada', Ed.Province, Ed.State)
               State,
            Decode (Upper (C.Country), 'Canada', C.Province, C.State)
               Cust_State,
            F.Salesperson,
            F.List_Price,
            F.Source,
            F.Pp_Sales_Order_Id,
            Cd.Course_Type,
            Cd.Course_Group,
            C.Zipcode,
            Substring(C.Zipcode, 1,  3),
            'Enrollment',
            Ed.Status,
            Ed.Start_Date,
            F.Payment_Method,
            F.Sf_Opportunity_Id
     From               Gkdw.Order_Fact F
                     Left Outer Join
                        Gkdw.Event_Dim Ed
                     On F.Event_Id = Ed.Event_Id
                  Left Outer Join
                     Gkdw.Course_Dim Cd
                  On Ed.Course_Id = Cd.Course_Id
                     And Ed.Ops_Country = Cd.Country
               Left Outer Join
                  Gkdw.Cust_Dim C
               On F.Cust_Id = C.Cust_Id
            Left Outer Join
               Gkdw.Account_Dim A
            On C.Acct_Id = A.Acct_Id
   Union All
   Select   S.Sales_Order_Id,
            Null,
            S.Cust_Id,
            S.Keycode,
            'Product',
            S.So_Status,
            Trunc (S.Book_Date),
            Trunc (S.Rev_Date),
            S.Book_Amt,
            'Usa',
            S.Country,
            C.Country Cust_Country,
            S.Record_Type,
            S.Metro_Area,
            Pd.Ch_Num,
            Pd.Prod_Channel,
            Pd.Md_Num,
            Pd.Prod_Modality,
            Pd.Pl_Num,
            Pd.Prod_Line,
            Pd.Prod_Name,
            Pd.Prod_Num,
            A.Acct_Id,
            A.Acct_Name,
            C.Cust_Name,
            'Spel' State,
            Decode (Upper (C.Country), 'Canada', C.Province, C.State)
               Cust_State,
            S.Salesperson,
            Esd.Actualnetrate,
            S.Source,
            S.Pp_Sales_Order_Id,
            Null,
            Pd.Prod_Family,
            C.Zipcode,
            Substring(C.Zipcode, 1,  3),
            'Sales Order',
            Null,
            Trunc (S.Book_Date),
            S.Payment_Method,
            Null
     From               Gkdw.Sales_Order_Fact S
                     Left Outer Join
                        Gkdw.Product_Dim Pd
                     On S.Product_Id = Pd.Product_Id
                  Left Outer Join
                     Gkdw.Cust_Dim C
                  On S.Cust_Id = C.Cust_Id
               Left Outer Join
                  Gkdw.Account_Dim A
               On C.Acct_Id = A.Acct_Id
            Left Outer Join
               Base.Evxsodetail Esd
            On S.Sales_Order_Id = Esd.Evxsoid
    Where   S.Record_Type = 'Salesorder'
   Union All
   Select   S.Sales_Order_Id,
            Null,
            S.Cust_Id,
            S.Keycode,
            'Product',
            S.So_Status,
            Trunc (S.Book_Date),
            Trunc (S.Rev_Date),
            S.Book_Amt,
            'Usa',
            S.Country,
            C.Country Cust_Country,
            S.Record_Type,
            S.Metro_Area,
            Pd.Ch_Num,
            Pd.Prod_Channel,
            Pd.Md_Num,
            Pd.Prod_Modality,
            Pd.Pl_Num,
            Pd.Prod_Line,
            Pd.Prod_Name,
            Pd.Prod_Num,
            A.Acct_Id,
            A.Acct_Name,
            C.Cust_Name,
            'Prepay' State,
            Decode (Upper (C.Country), 'Canada', C.Province, C.State)
               Cust_State,
            S.Salesperson,
            Esd.Actualnetrate,
            S.Source,
            S.Pp_Sales_Order_Id,
            Null,
            Pd.Prod_Family,
            C.Zipcode,
            Substring(C.Zipcode, 1,  3),
            'Prepay',
            Null,
            Trunc (S.Book_Date),
            S.Payment_Method,
            Null
     From               Gkdw.Sales_Order_Fact S
                     Left Outer Join
                        Gkdw.Product_Dim Pd
                     On S.Product_Id = Pd.Product_Id
                  Left Outer Join
                     Gkdw.Cust_Dim C
                  On S.Cust_Id = C.Cust_Id
               Left Outer Join
                  Gkdw.Account_Dim A
               On C.Acct_Id = A.Acct_Id
            Left Outer Join
               Base.Evxsodetail Esd
            On S.Sales_Order_Id = Esd.Evxsoid
    Where   S.Record_Type = 'Prepay Order';



