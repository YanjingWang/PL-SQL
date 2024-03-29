


Create Or Alter View Hold.Gk_Ipad_Mini_Audit_Bkp_V
(
   Enroll_Id,
   Enroll_Status,
   Event_Id,
   Eligible_Flag,
   Cust_Id,
   Cust_Name,
   Acct_Name,
   Email,
   Enroll_Date,
   Book_Date,
   Keycode,
   Book_Amt,
   List_Price,
   Po_Number,
   Payment_Method,
   Salesperson,
   Sales_Rep,
   Start_Date,
   Course_Code,
   Short_Name,
   Ops_Country,
   Paid_Date,
   Confirm_Email,
   Qualify_Email,
   Shipping_Info_Received,
   Gk_Po_Num,
   Po_Line_Num,
   Tracking_Num,
   Shipped_Date,
   Zipcode,
   State,
   Ob_Terr_Num,
   Promo_Accept,
   Promo_Item,
   Request_Fulfill_Date,
   Source_Code,
   Reg_Code,
   Expiration_Date
)
As
     Select   F.Enroll_Id,
              F.Enroll_Status,
              F.Event_Id,
              Case When Pl.Evxeventid Is Not Null Then 'Y' Else 'N' End
                 Eligible_Flag,
              F.Cust_Id,
              C.First_Name + ' ' + C.Last_Name Cust_Name,
              C.Acct_Name,
              C.Email,
              F.Enroll_Date,
              F.Book_Date,
              F.Keycode,
              F.Book_Amt,
              F.List_Price,
              F.Po_Number,
              F.Payment_Method,
              F.Salesperson,
              F.Sales_Rep,
              Ed.Start_Date,
              Ed.Course_Code,
              Cd.Short_Name,
              Ed.Ops_Country,
              Pp.[Date_Paid] Paid_Date,
              E1.[Datesent] Confirm_Email,
              Max (E2.[Datesent]) Qualify_Email,
              Max (Ps.[Date_Received]) Shipping_Info_Received,
              Pf.Po_Num Gk_Po_Num,
              Pf.Po_Line_Num,
              Pf.Tracking_Num,
              Pf.Shipped_Date,
              C.Zipcode,
              Upper (Gt.State) State,
              Gt.Territory_Id Ob_Terr_Num,
              Case
                 When Ps.[Shipping_Accept] = 'True' Then 'Y'
                 When Ps.[Shipping_Decline] Is Not Null Then 'N'
                 Else Null
              End
                 Promo_Accept,
              Ps.[Item] Promo_Item,
              Pf.Request_Date Fulfill_Request_Date,
              F.Source Source_Code,
              F.Reg_Code Reg_Code,
              Prs.Status_Date Expiration_Date
       From                                    Gkdw.Order_Fact F
                                            Inner Join
                                               Gkdw.Event_Dim Ed
                                            On F.Event_Id = Ed.Event_Id
                                         Inner Join
                                            Gkdw.Course_Dim Cd
                                         On Ed.Course_Id = Cd.Course_Id
                                            And Ed.Ops_Country = Cd.Country
                                      Inner Join
                                         Gkdw.Cust_Dim C
                                      On F.Cust_Id = C.Cust_Id
                                   Left Outer Join
                                      Gkdw.Gk_Territory Gt
                                   On C.Zipcode Between Gt.Zip_Start
                                                    And  Gt.Zip_End
                                      And Gt.Territory_Type = 'Ob'
                                Left Outer Join
                                   Gkdw.Gk_Event_Promo_Lu Pl
                                On Ed.Event_Id = Pl.Evxeventid
                                   And Pl.Promocode = F.Keycode
                             Left Outer Join
                                Promo_Orders_Paid@Mkt_Catalog Pp
                             On F.Enroll_Id = Trim (Pp.[Evxenrollid])
                          Left Outer Join
                             Promo_Emails_Sent@Mkt_Catalog E1
                          On F.Enroll_Id = Trim (E1.[Evxenrollid])
                             And E1.[Email_Type] = 'Confirm'
                       Left Outer Join
                          Promo_Emails_Sent@Mkt_Catalog E2
                       On F.Enroll_Id = Trim (E2.[Evxenrollid])
                          And E2.[Email_Type] = 'Qualify'
                    Left Outer Join
                       Promo_Shipping@Mkt_Catalog Ps
                    On F.Enroll_Id = Trim (Ps.[Evxenrollid])
                       And Ps.[Currententry] = 1
                 Left Join
                    Gkdw.Gk_Promo_Fulfilled_Orders Pf
                 On F.Enroll_Id = Pf.Enroll_Id
              Left Join
                 Base.Gk_Promo_Status Prs
              On F.Enroll_Id = Prs.Evxevenrollid
                 And Prs.Step_Status = 'Expired'
      --And Prs.Step_Num = 6
      Where   Exists (Select   1
                        From   Gkdw.Gk_Ipad_Promo_Keycode K
                       Where   F.Keycode = K.Keycode)
              And Enroll_Status != 'Cancelled'
   Group By   F.Enroll_Id,
              F.Enroll_Status,
              F.Event_Id,
              Case When Pl.Evxeventid Is Not Null Then 'Y' Else 'N' End,
              F.Cust_Id,
              C.First_Name + ' ' + C.Last_Name,
              C.Acct_Name,
              C.Email,
              F.Enroll_Date,
              F.Book_Date,
              F.Keycode,
              F.Book_Amt,
              F.List_Price,
              F.Po_Number,
              F.Payment_Method,
              F.Salesperson,
              F.Sales_Rep,
              Ed.Start_Date,
              Ed.Course_Code,
              Cd.Short_Name,
              Ed.Ops_Country,
              Pp.[Date_Paid],
              E1.[Datesent],
              Pf.Po_Num,
              Pf.Po_Line_Num,
              Pf.Tracking_Num,
              Pf.Shipped_Date,
              C.Zipcode,
              Upper (Gt.State),
              Gt.Territory_Id,
              Ps.[Shipping_Accept],
              Ps.[Shipping_Decline],
              Ps.[Item],
              Pf.Request_Date,
              F.Source,
              F.Reg_Code,
              Prs.Status_Date
   ;



