


Create Or Alter View Hold.Gk_Uninvoiced_Spel_V
(
   Sales_Order_Id,
   Cust_Name,
   Acct_Name,
   Email,
   Bill_To_Address1,
   Bill_To_City,
   Bill_To_State,
   Bill_To_Zipcode,
   Prod_Num,
   Order_Date,
   Payment_Method,
   Curr_Code,
   Book_Amt,
   Taxtotal,
   Total
)
As
     Select   Sf.Sales_Order_Id,
              Cd.Cust_Name,
              Cd.Acct_Name,
              Cd.Email,
              Sf.Bill_To_Address1,
              Bill_To_City,
              Bill_To_State,
              Bill_To_Zipcode,
              Sf.Prod_Num,
              Trunc (Sf.Creation_Date) Order_Date,
              Sf.Payment_Method,
              Sf.Curr_Code,
              Sf.Book_Amt,
              Es.Taxtotal,
              Es.Total
       From         Gkdw.Sales_Order_Fact Sf
                 Inner Join
                    Gkdw.Cust_Dim Cd
                 On Sf.Ordered_By_Cust_Id = Cd.Cust_Id
              Inner Join
                 Base.Evxso Es
              On Sf.Sales_Order_Id = Es.Evxsoid
      Where   Record_Type = 'Salesorder' And So_Status Is Null
   ;



