


Create Or Alter View Hold.Gk_Non_Buyers_V
(
   Acct_Name,
   Acct_City,
   Acct_State,
   Acct_Zip,
   Acct_Country,
   Industry,
   Acct_Create_Date,
   Acct_Modify_Date,
   Cust_Name,
   Cust_Address1,
   Cust_Address2,
   Cust_City,
   Cust_State,
   Cust_Zip,
   Cust_Country,
   Workphone,
   Email,
   Title,
   Department,
   Cust_Create_Date,
   Cust_Modify_Date,
   Territory_Id,
   Territory_Type,
   Region
)
As
     Select   Ad.Acct_Name,
              Ad.City Acct_City,
              Ad.State Acct_State,
              Ad.Zipcode Acct_Zip,
              Ad.Country Acct_Country,
              Ad.Sic_Code Industry,
              Ad.Creation_Date Acct_Create_Date,
              Ad.Last_Update_Date Acct_Modify_Date,
              Cd.Cust_Name,
              Cd.Address1 Cust_Address1,
              Cd.Address2 Cust_Address2,
              Cd.City Cust_City,
              Cd.State Cust_State,
              Cd.Zipcode Cust_Zip,
              Cd.Country Cust_Country,
              Cd.Workphone,
              Cd.Email,
              Cd.Title,
              Cd.Department,
              Cd.Creation_Date Cust_Create_Date,
              Cd.Last_Update_Date Cust_Modify_Date,
              Gt.Territory_Id,
              Gt.Territory_Type,
              Gt.Region
       From         Gkdw.Cust_Dim Cd
                 Inner Join
                    Gkdw.Account_Dim Ad
                 On Cd.Acct_Id = Ad.Acct_Id
              Inner Join
                 Gkdw.Gk_Territory Gt
              On Cd.Zipcode Between Gt.Zip_Start And Gt.Zip_End
      Where   Not Exists (Select   *
                            From   Gkdw.Gk_Booking_Cube_Mv Mv
                           Where   Mv.Cust_Id = Cd.Cust_Id)
              And Not Exists (Select   *
                                From   Gkdw.Sales_Order_Fact So
                               Where   So.Cust_Id = Cd.Cust_Id)
   ;



