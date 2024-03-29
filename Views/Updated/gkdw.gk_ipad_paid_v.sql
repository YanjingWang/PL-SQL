


Create Or Alter View Hold.Gk_Ipad_Paid_V
(
   Enroll_Id,
   Modifydate,
   Country
)
As
   Select   F.Enroll_Id, B.Modifydate, 'Usa' Country
     From            Gkdw.Order_Fact F
                  Inner Join
                     Gkdw.Cust_Dim C
                  On F.Cust_Id = C.Cust_Id
               Inner Join
                  Base.Qg_Billingpayment B
               On F.Enroll_Id = B.Evxevenrollid
            Inner Join
               Promo2012_Orders_Placed@Mkt_Catalog P
            On F.Enroll_Id = Trim (P.[Evxenrollid])
    Where       Keycode = 'Ipad2012p'
            And B.Oraclestatus = 'Paid'
            And Not Exists (Select   1
                              From   Promo2012_Orders_Paid@Mkt_Catalog O
                             Where   F.Enroll_Id = Trim (O.[Evxenrollid]))
   Union
   Select   F.Enroll_Id, F.Book_Date, 'Usa'
     From   Gkdw.Order_Fact F
    Where       Keycode = 'Ipad2012p'
            And Payment_Method In ('Cisco Learning Credits', 'Credit Card')
            And Not Exists (Select   1
                              From   Promo2012_Orders_Paid@Mkt_Catalog O
                             Where   F.Enroll_Id = Trim (O.[Evxenrollid]))
   Union
   Select   F.Sales_Order_Id, F.Book_Date, 'Usa'
     From   Gkdw.Sales_Order_Fact F
    Where       Keycode = 'Ipad2012p'
            And Payment_Method In ('Cisco Learning Credits', 'Credit Card')
            And Book_Date Is Not Null
            And Not Exists
                  (Select   1
                     From   Promo2012_Orders_Paid@Mkt_Catalog O
                    Where   F.Sales_Order_Id = Trim (O.[Evxenrollid]));



