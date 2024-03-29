


Create Or Alter View Hold.Gk_Daily_Bookings_35_V
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
   Connected_V_To_C
)
As
   Select   Eh.Evxevenrollid Enrollid,
            Et.Actualamount Enroll_Amt,
            Eh.Enrollstatusdesc Status_Desc,
            Trunc (Et.Billingdate) Bookdate,
            Eh.Enrollstatus Enroll_Status,
            Ev.Evxeventid Event_Id,
            Ev.Facilitycountry Country,
            Ev.Coursecode Course_Code,
            Ev.Eventname Event_Name,
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
            Ed.Connected_V_To_C
     From                                                            Base.Evxenrollhx Eh
                                                                  Inner Join
                                                                     Base.Evxev_Txfee Et
                                                                  On Eh.Evxevenrollid =
                                                                        Et.Evxevenrollid
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



