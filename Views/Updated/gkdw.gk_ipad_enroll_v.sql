


Create Or Alter View Hold.Gk_Ipad_Enroll_V
(
   Enroll_Id,
   Email,
   Country
)
As
   Select   Enroll_Id, C.Email, 'Usa' Country
     From      Gkdw.Order_Fact F
            Inner Join
               Gkdw.Cust_Dim C
            On F.Cust_Id = C.Cust_Id
    Where       Keycode = 'Ipad2012p'
            And F.Enroll_Status != 'Cancelled'
            And Not Exists (Select   1
                              From   Promo2012_Orders_Placed@Mkt_Catalog P
                             Where   F.Enroll_Id = Trim (P.[Evxenrollid]))
            And Not Exists (Select   1
                              From   Gkdw.Gk_Ipad_Enroll E
                             Where   F.Enroll_Id = E.Enroll_Id)
   Union
   Select   Sales_Order_Id, C.Email, 'Usa' Country
     From      Gkdw.Sales_Order_Fact F
            Inner Join
               Gkdw.Cust_Dim C
            On F.Cust_Id = C.Cust_Id
    Where   Keycode = 'Ipad2012p' And F.So_Status != 'Cancelled'
            And Not Exists
                  (Select   1
                     From   Promo2012_Orders_Placed@Mkt_Catalog P
                    Where   F.Sales_Order_Id = Trim (P.[Evxenrollid]))
            And Not Exists (Select   1
                              From   Gkdw.Gk_Ipad_Enroll E
                             Where   F.Sales_Order_Id = E.Enroll_Id);



