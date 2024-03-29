


Create Or Alter View Hold.Gk_Promo_Orders_Paid_V
(
   Enroll_Id,
   Date_Paid
)
As
   Select   F.Enroll_Id, Format(B.Modifydate - 1, 'Mm/Dd/Yyyy') Date_Paid
     From            Gkdw.Order_Fact F
                  Inner Join
                     Gkdw.Cust_Dim C
                  On F.Cust_Id = C.Cust_Id
               Inner Join
                  Base.Qg_Billingpayment B
               On F.Enroll_Id = B.Evxevenrollid
            Inner Join
               Promo_Orders_Placed@Mkt_Catalog P
            On F.Enroll_Id = Trim (P.[Evxenrollid])
    Where       Keycode = 'Ipadmini2013'
            And B.Oraclestatus = 'Paid'
            And Not Exists (Select   1
                              From   Promo_Orders_Paid@Mkt_Catalog O
                             Where   F.Enroll_Id = Trim (O.[Evxenrollid]))
   Union
   Select   F.Enroll_Id, Format(F.Book_Date, 'Mm/Dd/Yyyy') Date_Paid
     From   Gkdw.Order_Fact F
    Where       Keycode = 'Ipadmini2013'
            And Payment_Method In ('Cisco Learning Credits', 'Credit Card')
            And Not Exists (Select   1
                              From   Promo_Orders_Paid@Mkt_Catalog O
                             Where   F.Enroll_Id = Trim (O.[Evxenrollid]))
   Union
   Select   F.Sales_Order_Id, Format(F.Book_Date, 'Mm/Dd/Yyyy') Date_Paid
     From   Gkdw.Sales_Order_Fact F
    Where       Keycode = 'Ipadmini2013'
            And Payment_Method In ('Cisco Learning Credits', 'Credit Card')
            And Book_Date Is Not Null
            And Not Exists
                  (Select   1
                     From   Promo_Orders_Paid@Mkt_Catalog O
                    Where   F.Sales_Order_Id = Trim (O.[Evxenrollid]));



