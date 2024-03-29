


Create Or Alter View Hold.Gk_Pod_Onsites_V
(
   Enroll_Id,
   Book_Date,
   Cust_Name,
   Acct_Name,
   City,
   State,
   Zipcode,
   Enroll_Status,
   Course_Code,
   Course_Name,
   Course_Ch,
   Course_Mod,
   Course_Pl,
   Book_Amt,
   Rev_Date,
   Start_Date,
   Payment_Method,
   National_Terr_Id,
   Ob_Comm_Type,
   Card_Short_Code,
   Dim_Month,
   Dim_Year,
   Salesperson,
   Keycode,
   Territory_Id,
   Facility_Region_Metro,
   Event_Type,
   Enroll_Type,
   Fee_Type
)
As
   Select   F.Enroll_Id,
            F.Book_Date,
            C.Cust_Name,
            Ad.Acct_Name,
            Ad.City,
            Ad.State,
            Case
               When Ad.Country = 'Usa' Then Substring(Ad.Zipcode, 1,  5)
               Else Ad.Zipcode
            End
               Zipcode,
            F.Enroll_Status,
            Cd.Course_Code,
            Cd.Course_Name,
            Cd.Course_Ch,
            Cd.Course_Mod,
            Cd.Course_Pl,
            F.Book_Amt,
            F.Rev_Date,
            Ed.Start_Date,
            F.Payment_Method,
            National_Terr_Id,
            Ob_Comm_Type,
            Pd.Card_Short_Code,
            Td.Dim_Month,
            Td.Dim_Year,
            F.Salesperson,
            F.Keycode,
            T.Territory_Id,
            Ed.Facility_Region_Metro,
            Ed.Event_Type,
            F.Enroll_Type,
            F.Fee_Type
     From                           Gkdw.Order_Fact F
                                 Inner Join
                                    Gkdw.Event_Dim Ed
                                 On F.Event_Id = Ed.Event_Id
                              Inner Join
                                 Gkdw.Course_Dim Cd
                              On Ed.Course_Id = Cd.Course_Id
                                 And Ed.Ops_Country = Cd.Country
                           Inner Join
                              Gkdw.Time_Dim Td
                           On F.Book_Date = Td.Dim_Date
                        Inner Join
                           Gkdw.Cust_Dim C
                        On F.Cust_Id = C.Cust_Id
                     Inner Join
                        Gkdw.Account_Dim Ad
                     On C.Acct_Id = Ad.Acct_Id
                  Left Outer Join
                     Gkdw.Gk_Channel_Partner Cp
                  On F.Keycode = Cp.Partner_Key_Code
               Left Outer Join
                  Gkdw.Gk_Territory T
               On C.Zipcode Between T.Zip_Start And T.Zip_End
                  And T.Territory_Type = 'Ob'
            Left Outer Join
               Gkdw.Ppcard_Dim Pd
            On F.Ppcard_Id = Pd.Ppcard_Id
    Where       F.Enroll_Status != 'Cancelled'
            And Cd.Ch_Num = '20'             --   And Cd.Md_Num In ('10','41')
            And F.Book_Amt <> 0;



