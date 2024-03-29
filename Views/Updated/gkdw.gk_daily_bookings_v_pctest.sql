


Create Or Alter View Hold.Gk_Daily_Bookings_V_Pctest
(
   Enrollid,
   Enroll_Amt,
   Status_Desc,
   Bookdate,
   Enroll_Status,
   Event_Id,
   Country,
   Course_Code,
   Event_Name,
   Event_Type,
   Ch_Value,
   Ch_Desc,
   Md_Value,
   Md_Desc,
   Pl_Value,
   Pl_Desc,
   Revdate,
   Dim_Year,
   Dim_Month_Num,
   Rev_Dim_Year,
   Rev_Dim_Month_Num,
   Orderstatus,
   Ppcard_Id,
   Card_Type,
   Course_Desc,
   Itbt,
   Course_Type,
   Create_Date,
   Source,
   Attendeetype,
   Attendeeaccountid,
   Attendeeaccount,
   Ponumber,
   Payment_Method,
   Evxev_Txfeeid,
   Create_User,
   Billing_Zip,
   Student_Zip,
   Delivery_Zip,
   Soldbyuser,
   Student_Email,
   Ob_Rep_Name,
   Key_Code,
   Partner_Name,
   Connected_C,
   Connected_V_To_C,
   Card_Short_Code,
   List_Price
)
As
   Select   Eh.Evxevenrollid Enrollid,
            Et.Actualamount Enroll_Amt,
            Eh.Enrollstatusdesc Status_Desc,
            Trunc (Et.Billingdate) Bookdate,
            Eh.Enrollstatus Enroll_Status,
            Ev.Evxeventid Event_Id,
            Case
               When Cd.Md_Num In ('20', '42', '32', '44')
                    And Ot.Source = 'Ca_Ops'
               Then
                  'Canada'
               When Cd.Md_Num In ('20', '42', '32', '44')
               Then
                  'Usa'
               Else
                  Ev.Facilitycountry
            End
               Country,                            --  Added By Jd On 11/13/13
            Ev.Coursecode Course_Code,
            Ev.Eventname Event_Name,
            Ev.Eventtype Event_Type,
            Cd.Ch_Num Ch_Value,
            Cd.Course_Ch Ch_Desc,
            Cd.Md_Num Md_Value,
            Cd.Course_Mod Md_Desc,
            Cd.Pl_Num Pl_Value,
            Cd.Course_Pl Pl_Desc,
            Case
               When Cd.Md_Num In ('32', '44') Then Trunc (Et.Billingdate)
               When Ev.Startdate < Et.Billingdate Then Trunc (Et.Billingdate)
               Else Trunc (Ev.Startdate)
            End
               Revdate,
            Td.Dim_Year,
            Td.Dim_Month_Num,
            Td2.Dim_Year Rev_Dim_Year,
            Td2.Dim_Month_Num Rev_Dim_Month_Num,
            Ot.Orderstatus,
            Bp.Evxppcardid Ppcard_Id,
            Pp.Cardtype Card_Type,
            Cd.Course_Desc,
            Cd.Itbt,
            Cd.Course_Type,
            Et.Createdate Create_Date,
            Qe.Source,
            Tkt.Attendeetype,
            Et.Attendeeaccountid,
            Et.Attendeeaccount,
            Tkt.Ponumber,
            Bp.Method Payment_Method,
            Et.Evxev_Txfeeid,
            U.Username Create_User,
            C.Zipcode Billing_Zip,
            C1.Zipcode Student_Zip,
            Ev.Facilitypostal Delivery_Zip,
            Tkt.Soldbyuser,
            C1.Email Student_Email,
            U1.Username Ob_Rep_Name,
            Le.Abbrevdesc Key_Code,
            Gcp.Partner_Name,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Pp.Cardshortcode,
            F.List_Price
     From                                                               Base.Evxenrollhx Eh
                                                                     Inner Join
                                                                        Base.Evxev_Txfee Et
                                                                     On Eh.Evxevenrollid =
                                                                           Et.Evxevenrollid
                                                                  Left Join
                                                                     Gkdw.Order_Fact F
                                                                  On Eh.Evxevenrollid =
                                                                        F.Enroll_Id
                                                                     And F.Txfee_Id =
                                                                           Et.Evxev_Txfeeid
                                                               Inner Join
                                                                  Base.Evxevticket Tkt
                                                               On Et.Evxevticketid =
                                                                     Tkt.Evxevticketid
                                                            Inner Join
                                                               Base.Evxevent Ev
                                                            On Eh.Evxeventid =
                                                                  Ev.Evxeventid
                                                         Left Outer Join
                                                            Gkdw.Cust_Dim C
                                                         On C.Cust_Id =
                                                               Et.Billtocontactid
                                                      Inner Join
                                                         Gkdw.Cust_Dim C1
                                                      On C1.Cust_Id =
                                                            Et.Attendeecontactid
                                                   Inner Join
                                                      Base.Oracletx_History Ot
                                                   On Et.Evxbillingid =
                                                         Ot.Evxbillingid
                                                      And Isnull(
                                                            Transactiontype,
                                                            'Invoice'
                                                         ) != 'Recapture'
                                                Inner Join
                                                   Gkdw.Time_Dim Td
                                                On Td.Dim_Date =
                                                      Et.Billingdate
                                             --       Inner Join Gkdw.Time_Dim Td2 On Td2.Dim_Date = Case When Ev.Startdate < Et.Billingdate Then Et.Billingdate Else Ev.Startdate End
                                             Inner Join
                                                Base.Userinfo U
                                             On Et.Createuser = U.Userid
                                          Left Outer Join
                                             Gkdw.Event_Dim Ed
                                          On Ev.Evxeventid = Ed.Event_Id
                                       Left Outer Join
                                          Gkdw.Course_Dim Cd
                                       On Ed.Course_Id = Cd.Course_Id
                                          And Decode (Upper (Ed.Country),
                                                      'Canada', 'Canada',
                                                      'Usa') = Cd.Country
                                    Left Outer Join
                                       Base.Evxbillpayment Bp
                                    On Et.Evxbillingid = Bp.Evxbillingid
                                 Left Outer Join
                                    Base.Evxppcard Pp
                                 On Bp.Evxppcardid = Pp.Evxppcardid
                              Left Outer Join
                                 Base.Qg_Evenroll Qe
                              On Eh.Evxevenrollid = Qe.Evxevenrollid
                           Left Outer Join
                              Base.Qg_Contact Qc
                           On Et.Attendeecontactid = Qc.Contactid
                        Left Outer Join
                           Base.Userinfo U1
                        On Qc.Ob_Rep_Id = U1.Userid
                     Inner Join
                        Base.Qg_Evticket Qet
                     On Qet.Evxevticketid = Et.Evxevticketid
                  Left Outer Join
                     Base.Leadsource Le
                  On Le.Leadsourceid = Qet.Leadsourceid
               Left Outer Join
                  Gkdw.Gk_Channel_Partner Gcp
               On Gcp.Partner_Key_Code = Le.Abbrevdesc
            Inner Join
               Gkdw.Time_Dim Td2
            On Td2.Dim_Date =
                  Case
                     When Cd.Md_Num In ('32', '44')
                     Then
                        Trunc (Et.Billingdate)
                     When Ev.Startdate < Et.Billingdate
                     Then
                        Trunc (Et.Billingdate)
                     Else
                        Trunc (Ev.Startdate)
                  End
    Where   (Cd.Ch_Num = '10'
             Or (Cd.Ch_Num Is Null
                 And Ev.Eventtype In ('Open Enrollment', 'Reseller')))
   Union
   Select   Eh.Evxevenrollid,
            Et.Actualamount,
            Eh.Enrollstatusdesc,
            Trunc (Et.Createdate),
            Eh.Enrollstatus,
            Ev.Evxeventid,
            Ev.Facilitycountry,
            Ev.Coursecode,
            Ev.Eventname,
            Ev.Eventtype,
            Cd.Ch_Num,
            Cd.Course_Ch,
            Cd.Md_Num,
            Cd.Course_Mod,
            Cd.Pl_Num,
            Cd.Course_Pl,
            Case
               When Ev.Startdate < Et.Createdate Then Trunc (Et.Createdate)
               Else Trunc (Ev.Startdate)
            End
               Revdate,
            Td.Dim_Year,
            Td.Dim_Month_Num,
            Td2.Dim_Year,
            Td2.Dim_Month_Num,
            Ot.Orderstatus,
            Bp.Evxppcardid Ppcard_Id,
            Pp.Cardtype Card_Type,
            Cd.Course_Desc,
            Cd.Itbt,
            Cd.Course_Type,
            Et.Createdate Create_Date,
            Qe.Source,
            Tkt.Attendeetype,
            Et.Attendeeaccountid,
            Et.Attendeeaccount,
            Tkt.Ponumber,
            Bp.Method Payment_Method,
            Et.Evxev_Txfeeid,
            U.Username Create_User,
            C.Zipcode Billing_Zip,
            C1.Zipcode Student_Zip,
            Ev.Facilitypostal Delivery_Zip,
            Tkt.Soldbyuser,
            C1.Email,
            U1.Username,
            Le.Abbrevdesc,
            Gcp.Partner_Name,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Pp.Cardshortcode,
            F.List_Price
     From                                                               Base.Evxenrollhx Eh
                                                                     Inner Join
                                                                        Base.Evxev_Txfee Et
                                                                     On Eh.Evxevenrollid =
                                                                           Et.Evxevenrollid
                                                                  Left Join
                                                                     Gkdw.Order_Fact F
                                                                  On Eh.Evxevenrollid =
                                                                        F.Enroll_Id
                                                                     And F.Txfee_Id =
                                                                           Et.Evxev_Txfeeid
                                                               Inner Join
                                                                  Base.Evxevticket Tkt
                                                               On Et.Evxevticketid =
                                                                     Tkt.Evxevticketid
                                                            Inner Join
                                                               Base.Evxevent Ev
                                                            On Eh.Evxeventid =
                                                                  Ev.Evxeventid
                                                         Left Outer Join
                                                            Gkdw.Cust_Dim C
                                                         On C.Cust_Id =
                                                               Et.Billtocontactid
                                                      Inner Join
                                                         Gkdw.Cust_Dim C1
                                                      On C1.Cust_Id =
                                                            Et.Attendeecontactid
                                                   Inner Join
                                                      Gkdw.Time_Dim Td
                                                   On Td.Dim_Date =
                                                         Trunc (
                                                            Et.Createdate
                                                         )
                                                Inner Join
                                                   Gkdw.Time_Dim Td2
                                                On Td2.Dim_Date =
                                                      Case
                                                         When Ev.Startdate <
                                                                 Et.Createdate
                                                         Then
                                                            Trunc (
                                                               Et.Createdate
                                                            )
                                                         Else
                                                            Ev.Startdate
                                                      End
                                             Inner Join
                                                Base.Userinfo U
                                             On Et.Createuser = U.Userid
                                          Left Outer Join
                                             Base.Oracletx_History Ot
                                          On Et.Evxbillingid =
                                                Ot.Evxbillingid
                                             And Isnull(Transactiontype,
                                                      'Invoice') !=
                                                   'Recapture'
                                       Left Outer Join
                                          Gkdw.Event_Dim Ed
                                       On Ev.Evxeventid = Ed.Event_Id
                                    Left Outer Join
                                       Gkdw.Course_Dim Cd
                                    On Ed.Course_Id = Cd.Course_Id
                                       And Decode (Upper (Ed.Country),
                                                   'Canada', 'Canada',
                                                   'Usa') = Cd.Country
                                 Left Outer Join
                                    Base.Evxbillpayment Bp
                                 On Et.Evxbillingid = Bp.Evxbillingid
                              Left Outer Join
                                 Base.Evxppcard Pp
                              On Bp.Evxppcardid = Pp.Evxppcardid
                           Left Outer Join
                              Base.Qg_Evenroll Qe
                           On Eh.Evxevenrollid = Qe.Evxevenrollid
                        Left Outer Join
                           Base.Qg_Contact Qc
                        On Et.Attendeecontactid = Qc.Contactid
                     Left Outer Join
                        Base.Userinfo U1
                     On Qc.Ob_Rep_Id = U1.Userid
                  Inner Join
                     Base.Qg_Evticket Qet
                  On Qet.Evxevticketid = Et.Evxevticketid
               Left Outer Join
                  Base.Leadsource Le
               On Le.Leadsourceid = Qet.Leadsourceid
            Left Outer Join
               Gkdw.Gk_Channel_Partner Gcp
            On Gcp.Partner_Key_Code = Le.Abbrevdesc
    Where   (Cd.Ch_Num = '20'
             Or (Cd.Ch_Num Is Null And Ev.Eventtype = 'Onsite'))
            And (Et.Actualamount < 0 Or Et.Actualamount > 1)
            And Not Exists (Select   1
                              From   Gkdw.Gk_Sem_Onsite
                             Where   Evxevenrollid = Eh.Evxevenrollid)
   Union
   Select   Es.Evxsoid,
            Esd.Actualnetrate * Actualquantityordered,
            Null,
            Trunc (Es.Shippeddate), --Totalnotax,Es.Createdate,Esd.Detailtype,
            Es.Sostatus,
            Esd.Productid,
            Es.Shiptocountry,
            Ep.Prod_Num,
            Ep.Prod_Name,
            Null,
            Ep.Ch_Num,
            Ep.Prod_Channel,
            Ep.Md_Num,
            Ep.Prod_Modality,
            Ep.Pl_Num,
            Ep.Prod_Line,
            Trunc (Es.Shippeddate) Revdate,
            Td.Dim_Year,
            Td.Dim_Month_Num,
            Td2.Dim_Year,
            Td2.Dim_Month_Num,
            Null,
            Ep.Evxppcardid,
            Pp.Cardtype                                       --Oh.Orderstatus
                       ,
            Null Course_Desc,
            'F' Itbt,
            Null Course_Type,
            Es.Createdate Create_Date,
            Es.Source,
            Null Attendeetype,
            Es.Shiptoaccountid,
            Es.Shiptoaccount,
            Es.Purchaseorder,
            Bp.Method Payment_Method,
            Null Evxev_Txfeeid,
            U.Username,
            C.Zipcode Billing_Zip,
            C1.Zipcode Student_Zip,
            C1.Zipcode,
            Es.Soldbyuser,
            C1.Email,
            U1.Username,
            Ls.Abbrevdesc,
            Gcp.Partner_Name,
            Null,
            Null,
            Pp.Cardshortcode,
            F.Book_Amt
     From                                                   Gkdw.Evxso Es
                                                         Left Join
                                                            Gkdw.Sales_Order_Fact F
                                                         On Es.Evxsoid =
                                                               F.Sales_Order_Id
                                                      Inner Join
                                                         Gkdw.Evxsodetail Esd
                                                      On Es.Evxsoid =
                                                            Esd.Evxsoid
                                                   Inner Join
                                                      Gkdw.Cust_Dim C
                                                   On C.Cust_Id =
                                                         Es.Billtocontactid
                                                Inner Join
                                                   Gkdw.Cust_Dim C1
                                                On C1.Cust_Id =
                                                      Es.Shiptocontactid
                                             Inner Join
                                                Gkdw.Time_Dim Td
                                             On Td.Dim_Date =
                                                   Trunc (Es.Createdate)
                                          Inner Join
                                             Base.Userinfo U
                                          On Es.Createuser = U.Userid
                                       Left Outer Join
                                          Gkdw.Time_Dim Td2
                                       On Td2.Dim_Date =
                                             Trunc (Es.Shippeddate)
                                    Left Outer Join
                                       Gkdw.Product_Dim Ep
                                    On Esd.Productid = Ep.Product_Id
                                 Left Outer Join
                                    Base.Evxppeventpass Ep
                                 On Es.Evxsoid = Ep.Evxevenrollid
                              Left Outer Join
                                 Base.Evxppcard Pp
                              On Ep.Evxppcardid = Pp.Evxppcardid
                           Left Outer Join
                              Base.Evxbillpayment Bp
                           On Es.Evxsoid = Bp.Evxsoid
                        Left Outer Join
                           Base.Qg_Contact Qc
                        On Es.Shiptocontactid = Qc.Contactid
                     Left Outer Join
                        Base.Userinfo U1
                     On Qc.Ob_Rep_Id = U1.Userid
                  Left Outer Join
                     Base.Qg_Contactleadsource Cls
                  On Cls.Itemid = Es.Evxsoid
               Left Join
                  Base.Leadsource Ls
               On Cls.Leadsourceid = Ls.Leadsourceid
            Left Outer Join
               Gkdw.Gk_Channel_Partner Gcp
            On Gcp.Partner_Key_Code = Ls.Abbrevdesc
    Where       Es.Sotype = 'Standard'
            And Es.Sostatus = 'Shipped'
            And Ep.Prod_Num <> '0Classfee'
            And Bp.Method <> 'Cancellation'
   Union
   Select   Eh.Evxevenrollid Enrollid,
            Et.Actualamount Enroll_Amt,
            Eh.Enrollstatusdesc Status_Desc,
            Trunc (Et.Billingdate) Bookdate,
            Eh.Enrollstatus Enroll_Status,
            Ev.Evxeventid Event_Id,
            Ev.Facilitycountry Country,
            Ev.Coursecode Course_Code,
            Ev.Eventname Event_Name,
            Ev.Eventtype Event_Type,
            Cd.Ch_Num Ch_Value,
            Cd.Course_Ch Ch_Desc,
            Cd.Md_Num Md_Value,
            Cd.Course_Mod Md_Desc,
            Cd.Pl_Num Pl_Value,
            Cd.Course_Pl Pl_Desc,
            Case
               When Ev.Startdate < Et.Createdate Then Trunc (Et.Createdate)
               Else Trunc (Ev.Startdate)
            End
               Revdate,
            Td.Dim_Year,
            Td.Dim_Month_Num,
            Td2.Dim_Year Rev_Dim_Year,
            Td2.Dim_Month_Num Rev_Dim_Month_Num,
            Ot.Orderstatus,
            Bp.Evxppcardid Ppcard_Id,
            Pp.Cardtype Card_Type,
            Cd.Course_Desc,
            Cd.Itbt,
            Cd.Course_Type,
            Et.Createdate Create_Date,
            Qe.Source,
            Tkt.Attendeetype,
            Et.Attendeeaccountid,
            Et.Attendeeaccount,
            Tkt.Ponumber,
            Bp.Method Payment_Method,
            Et.Evxev_Txfeeid,
            U.Username Create_User,
            C.Zipcode Billing_Zip,
            C1.Zipcode Student_Zip,
            Ev.Facilitypostal Delivery_Zip,
            Tkt.Soldbyuser,
            C1.Email Student_Email,
            U1.Username Ob_Rep_Name,
            Le.Abbrevdesc Key_Code,
            Gcp.Partner_Name,
            Ed.Connected_C,
            Ed.Connected_V_To_C,
            Pp.Cardshortcode,
            F.List_Price
     From                                                               Base.Evxenrollhx Eh
                                                                     Inner Join
                                                                        Base.Evxev_Txfee Et
                                                                     On Eh.Evxevenrollid =
                                                                           Et.Evxevenrollid
                                                                  Left Join
                                                                     Gkdw.Order_Fact F
                                                                  On Eh.Evxevenrollid =
                                                                        F.Enroll_Id
                                                                     And F.Txfee_Id =
                                                                           Et.Evxev_Txfeeid
                                                               Inner Join
                                                                  Base.Evxevticket Tkt
                                                               On Et.Evxevticketid =
                                                                     Tkt.Evxevticketid
                                                            Inner Join
                                                               Base.Evxevent Ev
                                                            On Eh.Evxeventid =
                                                                  Ev.Evxeventid
                                                         Left Outer Join
                                                            Gkdw.Cust_Dim C
                                                         On C.Cust_Id =
                                                               Et.Billtocontactid
                                                      Inner Join
                                                         Gkdw.Cust_Dim C1
                                                      On C1.Cust_Id =
                                                            Et.Attendeecontactid
                                                   Inner Join
                                                      Base.Oracletx_History Ot
                                                   On Et.Evxbillingid =
                                                         Ot.Evxbillingid
                                                      And Isnull(
                                                            Transactiontype,
                                                            'Invoice'
                                                         ) != 'Recapture'
                                                Inner Join
                                                   Gkdw.Time_Dim Td
                                                On Td.Dim_Date =
                                                      Et.Billingdate
                                             Inner Join
                                                Base.Userinfo U
                                             On Et.Createuser = U.Userid
                                          Left Outer Join
                                             Gkdw.Event_Dim Ed
                                          On Ev.Evxeventid = Ed.Event_Id
                                       Left Outer Join
                                          Gkdw.Course_Dim Cd
                                       On Ed.Course_Id = Cd.Course_Id
                                          And Decode (Upper (Ed.Country),
                                                      'Canada', 'Canada',
                                                      'Usa') = Cd.Country
                                    Left Outer Join
                                       Base.Evxbillpayment Bp
                                    On Et.Evxbillingid = Bp.Evxbillingid
                                 Left Outer Join
                                    Base.Evxppcard Pp
                                 On Bp.Evxppcardid = Pp.Evxppcardid
                              Left Outer Join
                                 Base.Qg_Evenroll Qe
                              On Eh.Evxevenrollid = Qe.Evxevenrollid
                           Left Outer Join
                              Base.Qg_Contact Qc
                           On Et.Attendeecontactid = Qc.Contactid
                        Left Outer Join
                           Base.Userinfo U1
                        On Qc.Ob_Rep_Id = U1.Userid
                     Inner Join
                        Base.Qg_Evticket Qet
                     On Qet.Evxevticketid = Et.Evxevticketid
                  Left Outer Join
                     Base.Leadsource Le
                  On Le.Leadsourceid = Qet.Leadsourceid
               Left Outer Join
                  Gkdw.Gk_Channel_Partner Gcp
               On Gcp.Partner_Key_Code = Le.Abbrevdesc
            Inner Join
               Gkdw.Time_Dim Td2
            On Td2.Dim_Date =
                  Case
                     When Ev.Startdate < Et.Createdate
                     Then
                        Trunc (Et.Createdate)
                     Else
                        Ev.Startdate
                  End
    Where   Cd.Ch_Num = '35';



