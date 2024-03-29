


Create Or Alter View Hold.Gk_Oe_Po_Orders_V
(
   Enroll_Id,
   Po_Number,
   Book_Date,
   Curr_Code,
   Payment_Method,
   Keycode,
   Enroll_Status,
   Start_Date,
   Course_Name,
   Cust_Name,
   Acct_Name,
   Dim_Month,
   Dim_Year,
   Course_Mod,
   Course_Pl,
   National_Terr_Id,
   Ob_Comm_Type,
   Partner_Name,
   Territory_Id,
   Region,
   Salesrep,
   Rev_Territory,
   Salesperson
)
As
   Select   F.Enroll_Id,
            F.Po_Number,
            F.Book_Date,
            F.Curr_Code,
            F.Payment_Method,
            F.Keycode,
            F.Enroll_Status,
            Ed.Start_Date,
            Cd.Course_Name,
            C.Cust_Name,
            C.Acct_Name,
            Td.Dim_Month,
            Td.Dim_Year,
            Cd.Course_Mod,
            Cd.Course_Pl,
            Ad.National_Terr_Id,
            Cp.Ob_Comm_Type,
            Cp.Partner_Name,
            T.Territory_Id,
            T.Region,
            T.Salesrep,
            Case
               When Cp.Ob_Comm_Type In ('63', '9', '80', 'None')
               Then
                  Cp.Ob_Comm_Type
               When Ad.National_Terr_Id In
                          ('32', '52', '73', '79', 'C5', 'C9')
               Then
                  Ad.National_Terr_Id
               When Mta_Territory_Id Is Not Null
               Then
                  Mta_Territory_Id
               Else
                  T.Territory_Id
            End
               Rev_Territory,
            F.Salesperson
     From                        Gkdw.Order_Fact F
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
    Where   F.Enroll_Status != 'Cancelled'
            And (F.Payment_Method In ('Osr Purchase Order', 'Purchase Order')
                 Or F.Po_Number Is Not Null)
            And Substring(F.Po_Number, 1,  3) Not In ('Moc', 'Pso')
            And Substring(F.Po_Number, 1,  2) Not In ('So')
            And Cd.Ch_Num = '10'
            And F.Book_Amt > 0;



