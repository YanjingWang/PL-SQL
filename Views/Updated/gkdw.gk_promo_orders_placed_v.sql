


Create Or Alter View Hold.Gk_Promo_Orders_Placed_V
(
   Book_Date,
   Enroll_Id,
   Keycode,
   Email
)
As
   Select   Format(Book_Date, 'Mm/Dd/Yyyy') Book_Date,
            Enroll_Id,
            Keycode,
            Cd.Email
     From      Gkdw.Order_Fact F
            Inner Join
               Gkdw.Cust_Dim Cd
            On F.Cust_Id = Cd.Cust_Id
    Where       Keycode = 'Ipadmini2013'
            And Enroll_Status = 'Confirmed'
            And Book_Date Is Not Null
            And Not Exists (Select   1
                              From   Promo_Orders_Placed@Mkt_Catalog P
                             Where   F.Enroll_Id = Trim (P.[Evxenrollid]));



