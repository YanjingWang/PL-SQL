


Create Or Alter View Hold.Gk_Cc_Detailed_V
(
   Qg_Ccloggingid,
   Orderid,
   Slx_Contact_Id,
   Slx_Contact_Name,
   Transactiondate,
   Transactionid,
   Evxbillingid,
   Ordernumber,
   Oracle_Trx_Num,
   Oracle_Cust_Name,
   Oracle_Cust_Id,
   Oracle_Cust_Account_Number,
   Customer_Trx_Id,
   Trx_Number,
   Ora_Trx_Date,
   Order_Type,
   Transactionamount,
   Cctruncnum,
   Authcode
)
As
   Select   Qg_Ccloggingid,
            C.Evxevenrollid,
            --   C.Createdate,
            C.Attendeecontactid Slx_Contact_Id,
            C.Attendeecontact Slx_Contact_Name,
            C.Transactiondate,
            C.Transactionid,
            Cc.Billing_Id Evxbillingid,
            Evoorderid Ordernumber,
            Get_Ora_Trx_Num (F.Txfee_Id) Oracle_Trx_Num,
            Cc.Oracle_Cust_Name,
            Cc.Oracle_Cust_Id,
            Cc.Oracle_Cust_Account_Number,
            Cc.Customer_Trx_Id,
            Cc.Trx_Number,
            Cc.Ora_Trx_Date,
            Cc.Order_Type,
            Cc.Amount Transactionamount,
            Cc.Cctruncnum,
            C.Authcode
     From            (Select   Qg_Ccloggingid,
                               C.Createdate Transactiondate,
                               Transactionid,
                               Oh.Evxbillingid,
                               Oh.Createdate,
                               Oh.Evxevenrollid,
                               C.Evoorderid,
                               C.Authcode,
                               Oh.Cc_Authorizationnumber,
                               Oh.Attendeecontactid,
                               Oh.Attendeecontact                       --,C.*
                        From      Base.Qg_Cclogging C
                               Inner Join
                                  Base.Oracletx_History Oh
                               On C.Authcode = Oh.Cc_Authorizationnumber
                                  And Oh.Cc_Number = C.Creditcardnumber
                       Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                Or Trunc (Oh.Createdate) >=
                                     Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                         )
                               And (Trunc (C.Createdate) Between Trunc(Oh.Createdate)
                                                                 - 30
                                                             And  Trunc (
                                                                     Getutcdate()
                                                                  )
                                    And Trunc (Oh.Createdate) Between Trunc(C.Createdate)
                                                                      - 30
                                                                  And  Cast(Getutcdate() As Date))
                      Union
                      Select   Qg_Ccloggingid,
                               C.Createdate Transactiondate,
                               Transactionid,
                               Oh.Evxbillingid,
                               Oh.Createdate,
                               Oh.Evxevenrollid,
                               C.Evoorderid,
                               C.Authcode,
                               Oh.Cc_Authorizationnumber,
                               Oh.Attendeecontactid,
                               Oh.Attendeecontact                       --,C.*
                        From      Base.Qg_Cclogging C
                               Inner Join
                                  Base.Oracletx_History Oh
                               On Format(C.Evoorderid) =
                                     Oh.Cc_Authorizationnumber
                                  And Oh.Cc_Number = C.Creditcardnumber
                       Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                Or Trunc (Oh.Createdate) >=
                                     Cast(Getutcdate() As Date) - 45 -- To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                         )
                               And Trunc (Oh.Createdate) Between Trunc(C.Createdate)
                                                                 - 30
                                                             And  Trunc (
                                                                     Getutcdate()
                                                                  )
                      Union
                      Select   Qg_Ccloggingid,
                               C.Createdate Transactiondate,
                               Transactionid,
                               Oh.Evxbillingid,
                               Oh.Createdate,
                               Oh.Evxevenrollid,
                               C.Evoorderid,
                               C.Authcode,
                               Oh.Cc_Authorizationnumber,
                               Oh.Attendeecontactid,
                               Oh.Attendeecontact
                        From      Base.Qg_Cclogging C
                               Inner Join
                                  Base.Oracletx_History Oh
                               On C.Orderid = Oh.Evxevenrollid
                       Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 -- To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                Or Trunc (Oh.Createdate) >=
                                     Cast(Getutcdate() As Date) - 45 --  To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                         )
                      Union
                      Select   Qg_Ccloggingid,
                               C.Createdate Transactiondate,
                               Transactionid,
                               Oh.Evxbillingid,
                               Oh.Createdate,
                               Oh.Evxevenrollid,
                               C.Evoorderid,
                               C.Authcode,
                               Oh.Cc_Authorizationnumber,
                               Attendeecontactid,
                               Attendeecontact                          --,C.*
                        From      Base.Qg_Cclogging C
                               Inner Join
                                  (Select   Evxbillingid,
                                            Ponumber,
                                            Createdate,
                                            Evxevenrollid,
                                            Attendeecontactid,
                                            Attendeecontact,
                                            Cc_Authorizationnumber
                                     From   Base.Oracletx_History H
                                    Where   Upper (Ponumber) Like '%Cc%'
                                            And Isnull(Upper(Ponumber), 0) <>
                                                  '0'
                                            And Cast(Createdate As Date) >=
                                                  Cast(Getutcdate() As Date) - 45 --  To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                            And Not Exists
                                                  (Select   1
                                                     From   Base.Oracletx_History H1
                                                    Where   H.Oracletxid =
                                                               H1.Oracletxid
                                                            And Length(Regexp_Replace (
                                                                          Substr (
                                                                             Replace (
                                                                                Ponumber,
                                                                                ' '
                                                                             ),
                                                                             -10
                                                                          ),
                                                                          '[A-Za-Z]',
                                                                          ''
                                                                       )) >=
                                                                  10) -- Sr 10/26/2018
                                                                     ) Oh
                               On Oh.Ponumber Like
                                     '%' + Format(C.Evoorderid) + '%'
                       Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --  To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                Or Trunc (Oh.Createdate) >=
                                     Cast(Getutcdate() As Date) - 45 --  To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                         )
                               And Trunc (C.Createdate) Between Trunc(Oh.Createdate)
                                                                - 30
                                                            And  Trunc (
                                                                    Getutcdate()
                                                                 )) C
                  Inner Join
                     Base.Evxev_Txfee Etf
                  On Etf.Evxevenrollid = C.Evxevenrollid
                     And Etf.Evxbillingid = C.Evxbillingid
               Inner Join
                  Gkdw.Order_Fact F
               On Etf.Evxevenrollid = F.Enroll_Id
                  And Etf.Evxev_Txfeeid = F.Txfee_Id
            Left Outer Join
               Gk_Cc_Trx_Details_V@R12prd Cc
            On C.Evxevenrollid = Cc.Slx_Enroll_Id
               And C.Evxbillingid = Cc.Billing_Id
    Where   Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
   Union
   Select   Qg_Ccloggingid,
            Oh.Evxevenrollid,
            --     F.Creation_Date Createdate,
            Oh.Attendeecontactid,
            Oh.Attendeecontact,
            C.Transactiondate,
            C.Transactionid,
            Cc.Billing_Id Evxbillingid,
            Evoorderid Ordernumber,
            Get_Ora_Trx_Num (F.Txfee_Id) Oracle_Trx_Num,
            Cc.Oracle_Cust_Name,
            Cc.Oracle_Cust_Id,
            Cc.Oracle_Cust_Account_Number,
            Cc.Customer_Trx_Id,
            Cc.Trx_Number,
            Cc.Ora_Trx_Date,
            Cc.Order_Type,
            Cc.Amount Transactionamount,
            Cc.Cctruncnum,
            C.Authcode
     From                  Base.Oracletx_History Oh
                        Inner Join
                           Base.Evxev_Txfee Etf
                        On Oh.Evxevenrollid = Etf.Evxevenrollid
                           And Oh.Evxbillingid = Etf.Evxbillingid
                     Inner Join
                        Gkdw.Order_Fact F
                     On F.Txfee_Id = Etf.Evxev_Txfeeid
                  Inner Join
                     Base.Evxbillpayment Bp
                  On Oh.Evxbillingid = Bp.Evxbillingid
               Left Outer Join
                  Gk_Cc_Trx_Details_V@R12prd Cc
               On Oh.Evxevenrollid = Cc.Slx_Enroll_Id
                  And Oh.Evxbillingid = Cc.Billing_Id
            Left Outer Join
               (Select   Qg_Ccloggingid,
                         C.Createdate Transactiondate,
                         Transactionid,
                         Oh.Evxbillingid,
                         Oh.Createdate,
                         Oh.Evxevenrollid,
                         C.Evoorderid,
                         C.Authcode,
                         Oh.Cc_Authorizationnumber                      --,C.*
                  From      Base.Qg_Cclogging C
                         Inner Join
                            Base.Oracletx_History Oh
                         On C.Authcode = Oh.Cc_Authorizationnumber
                            And Oh.Cc_Number = C.Creditcardnumber
                 Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                          Or Trunc (Oh.Createdate) >= Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                                          )
                         And (Trunc (C.Createdate) Between Trunc (
                                                              Oh.Createdate
                                                           )
                                                           - 30
                                                       And  Cast(Getutcdate() As Date)
                              And Trunc (Oh.Createdate) Between Trunc(C.Createdate)
                                                                - 30
                                                            And  Trunc (
                                                                    Getutcdate()
                                                                 ))
                Union
                Select   Qg_Ccloggingid,
                         C.Createdate Transactiondate,
                         Transactionid,
                         Oh.Evxbillingid,
                         Oh.Createdate,
                         Oh.Evxevenrollid,
                         C.Evoorderid,
                         C.Authcode,
                         Oh.Cc_Authorizationnumber                      --,C.*
                  From      Base.Qg_Cclogging C
                         Inner Join
                            Base.Oracletx_History Oh
                         On Format(C.Evoorderid) =
                               Oh.Cc_Authorizationnumber
                            And Oh.Cc_Number = C.Creditcardnumber
                 Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --  To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                          Or Trunc (Oh.Createdate) >= Cast(Getutcdate() As Date) - 45 -- To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                                          )
                         And Trunc (Oh.Createdate) Between Trunc (
                                                              C.Createdate
                                                           )
                                                           - 30
                                                       And  Cast(Getutcdate() As Date)
                Union
                Select   Qg_Ccloggingid,
                         C.Createdate Transactiondate,
                         Transactionid,
                         Oh.Evxbillingid,
                         Oh.Createdate,
                         Oh.Evxevenrollid,
                         C.Evoorderid,
                         C.Authcode,
                         Oh.Cc_Authorizationnumber                      --,C.*
                  From      Base.Qg_Cclogging C
                         Inner Join
                            Base.Oracletx_History Oh
                         On C.Orderid = Oh.Evxevenrollid
                 Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 -- To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                          Or Trunc (Oh.Createdate) >= Cast(Getutcdate() As Date) - 45 -- To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                                          )
                Union
                Select   Qg_Ccloggingid,
                         C.Createdate Transactiondate,
                         Transactionid,
                         Oh.Evxbillingid,
                         Oh.Createdate,
                         Oh.Evxevenrollid,
                         C.Evoorderid,
                         C.Authcode,
                         Oh.Cc_Authorizationnumber
                  From      Base.Qg_Cclogging C
                         Inner Join
                            (Select   Evxbillingid,
                                      Ponumber,
                                      Createdate,
                                      Evxevenrollid,
                                      Cc_Authorizationnumber
                               From   Base.Oracletx_History H
                              Where   Upper (Ponumber) Like '%Cc%'
                                      And Isnull(Upper(Ponumber), 0) <> '0'
                                      And Cast(Createdate As Date) >=
                                            Cast(Getutcdate() As Date) - 45 --  To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                      And Not Exists
                                            (Select   1
                                               From   Base.Oracletx_History H1
                                              Where   H.Oracletxid =
                                                         H1.Oracletxid
                                                      And Length(Regexp_Replace (
                                                                    Substr (
                                                                       Replace (
                                                                          Ponumber,
                                                                          ' '
                                                                       ),
                                                                       -10
                                                                    ),
                                                                    '[A-Za-Z]',
                                                                    ''
                                                                 )) >= 10) -- Sr 10/26/2018
                                                                          )
                            Oh
                         On Oh.Ponumber Like
                               '%' + Format(C.Evoorderid) + '%'
                 Where   (Trunc (C.Createdate) >= Cast(Getutcdate() As Date) - 45 --    To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                          Or Trunc (Oh.Createdate) >= Cast(Getutcdate() As Date) - 45 --     To_Date ('04/01/2018', 'Mm/Dd/Yyyy')
                                                                          )
                         And Trunc (C.Createdate) Between Trunc (
                                                             Oh.Createdate
                                                          )
                                                          - 45
                                                      And  Cast(Getutcdate() As Date)) C
            On C.Evxevenrollid = F.Enroll_Id
    Where   Bp.Method = 'Credit Card'
            And Trunc (Oh.Createdate) >= Cast(Getutcdate() As Date) - 45 --To_Date ('04/01/2018', 'Mm/Dd/Yyyy');



