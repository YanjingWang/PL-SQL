


Create Or Alter View Hold.Gk_Pod_V
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
   Order_Status,
   Ch_Value,
   Ch_Desc,
   Md_Value,
   Md_Desc,
   Pl_Value,
   Pl_Desc,
   Revdate,
   Sold_By,
   Postal_Code,
   Territory_Id,
   Salesrep,
   Region,
   Attendee_Name,
   Attendee_Account,
   Acct_Profile,
   Dim_Month,
   Dim_Year,
   Keycode,
   Dim_Month_Num,
   Rev_Dim_Month,
   Rev_Dim_Year,
   Rev_Dim_Month_Num,
   Email,
   Contactid
)
As
   Select   Eh.Evxevenrollid Enrollid,
            Et.Actualamount Enroll_Amt,
            Eh.Enrollstatusdesc Status_Desc,
            Et.Billingdate Bookdate,
            Eh.Enrollstatus Enroll_Status,
            Ev.Evxeventid Event_Id,
            Ev.Facilitycountry Country,
            Ev.Coursecode Course_Code,
            Ev.Eventname Event_Name,
            Ev.Eventtype Event_Type,
            Ot.Orderstatus Order_Status,
            Cd.Ch_Num Ch_Value,
            Cd.Course_Ch Ch_Desc,
            Cd.Md_Num Md_Value,
            Cd.Course_Mod Md_Desc,
            Cd.Pl_Num Pl_Value,
            Cd.Course_Pl Pl_Desc,
            Case
               When Ev.Startdate < Et.Billingdate Then Et.Billingdate
               Else Ev.Startdate
            End
               Revdate,
            Et.Soldbyuser Sold_By,
            A.Postalcode Postal_Code,
            Gt.Territory_Id,
            Gt.Salesrep,
            Gt.Region,
            C.Firstname + ' ' + C.Lastname Attendee_Name,
            C.Account Attendee_Account,
            Qa.Profiletype Acct_Profile,
            Td.Dim_Month,
            Td.Dim_Year,
            Ls.Abbrevdesc Keycode,
            Td.Dim_Month_Num,
            Td2.Dim_Month Rev_Dim_Month,
            Td2.Dim_Year Rev_Dim_Year,
            Td2.Dim_Month_Num Rev_Dim_Month_Num,
            C.Email,
            C.Contactid
     From                                          Base.Evxenrollhx Eh
                                                Inner Join
                                                   Base.Evxev_Txfee Et
                                                On Eh.Evxevenrollid =
                                                      Et.Evxevenrollid
                                             Inner Join
                                                Base.Evxevent Ev
                                             On Eh.Evxeventid = Ev.Evxeventid
                                          Inner Join
                                             Base.Contact C
                                          On C.Contactid =
                                                Et.Attendeecontactid
                                       Inner Join
                                          Base.Address A
                                       On A.Addressid = C.Addressid
                                    Left Outer Join
                                       Gkdw.Time_Dim Td
                                    On Td.Dim_Date = Et.Billingdate
                                 Inner Join
                                    Gkdw.Time_Dim Td2
                                 On Td2.Dim_Date = Ev.Startdate
                              Left Outer Join
                                 Base.Oracletx_History Ot
                              On Et.Evxbillingid = Ot.Evxbillingid
                           Left Outer Join
                              Base.Qg_Evticket Qe
                           On Qe.Evxevticketid = Et.Evxevticketid
                        Left Outer Join
                           Base.Leadsource Ls
                        On Ls.Leadsourceid = Qe.Leadsourceid
                     Left Outer Join
                        Gkdw.Gk_Territory Gt
                     On A.Postalcode Between Gt.Zip_Start And Gt.Zip_End
                        And Gt.State = A.State
                  Left Outer Join
                     Gkdw.Event_Dim Ed
                  On Ev.Evxeventid = Ed.Event_Id
               Left Outer Join
                  Gkdw.Course_Dim Cd
               On Ed.Course_Id = Cd.Course_Id
                  And Upper (Ed.Country) = Cd.Country
            Left Outer Join
               Base.Qg_Accprofiletype Qa
            On Qa.Accountid = C.Accountid
    Where   (Cd.Ch_Num = '10'
             Or (Cd.Ch_Num Is Null And Ev.Eventtype = 'Open Enrollment'))
   Union
   Select   Eh.Evxevenrollid,
            Et.Actualamount,
            Eh.Enrollstatusdesc,
            Et.Createdate,
            Eh.Enrollstatus,
            Ev.Evxeventid,
            Ev.Facilitycountry,
            Ev.Coursecode,
            Ev.Eventname,
            Ev.Eventtype,
            Ot.Orderstatus,
            Cd.Ch_Num,
            Cd.Course_Ch,
            Cd.Md_Num,
            Cd.Course_Mod,
            Cd.Pl_Num,
            Cd.Course_Pl,
            Case
               When Ev.Startdate < Et.Createdate Then Trunc (Et.Createdate)
               Else Ev.Startdate
            End
               Revdate,
            Et.Soldbyuser,
            Null,
            Null,
            Null,
            Null,
            Null,
            Null,
            Null,
            Td.Dim_Month,
            Td.Dim_Year,
            Null Keycode,
            Td.Dim_Month_Num,
            Td2.Dim_Month,
            Td2.Dim_Year,
            Td2.Dim_Month_Num,
            Null,
            Null
     From                        Base.Evxenrollhx Eh
                              Inner Join
                                 Base.Evxev_Txfee Et
                              On Eh.Evxevenrollid = Et.Evxevenrollid
                           Inner Join
                              Base.Evxevent Ev
                           On Eh.Evxeventid = Ev.Evxeventid
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Td.Dim_Date = Trunc (Et.Createdate)
                     Inner Join
                        Gkdw.Time_Dim Td2
                     On Td2.Dim_Date = Ev.Startdate
                  Left Outer Join
                     Base.Oracletx_History Ot
                  On Et.Evxbillingid = Ot.Evxbillingid
               Left Outer Join
                  Gkdw.Event_Dim Ed
               On Ev.Evxeventid = Ed.Event_Id
            Left Outer Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id
               And Upper (Ed.Country) = Cd.Country
    Where   (Cd.Ch_Num = '20'
             Or (Cd.Ch_Num Is Null And Ev.Eventtype = 'Onsite'))
            And (Actualamount < 0 Or Actualamount > 1)
   Union
   Select   Es.Evxsoid,
            Totalnotax,
            Null,
            Es.Createdate,
            Esd.Detailtype,
            Esd.Productid,
            Esd.Shiptocountry,
            Ep.Prod_Num,
            Ep.Prod_Name,
            Es.Sotype,
            Oh.Orderstatus,
            Ep.Ch_Num,
            Ep.Prod_Channel,
            Ep.Md_Num,
            Ep.Prod_Modality,
            Ep.Pl_Num,
            Ep.Prod_Line,
            Es.Shippeddate Revdate,
            Es.Soldbyuser,
            Esd.Shiptopostal Postal_Code,
            Gt.Territory_Id,
            Gt.Salesrep,
            Gt.Region,
            Esd.Shiptocontact Attendee_Name,
            Esd.Shiptoaccount Attendee_Account,
            Null,
            Td.Dim_Month,
            Td.Dim_Year,
            Ls.Abbrevdesc Keycode,
            Td.Dim_Month_Num,
            Td2.Dim_Month,
            Td2.Dim_Year,
            Td2.Dim_Month_Num,
            C.Email,
            C.Contactid
     From                              Gkdw.Evxso Es
                                    Inner Join
                                       Gkdw.Evxsodetail Esd
                                    On Es.Evxsoid = Esd.Evxsoid
                                 Inner Join
                                    Gkdw.Time_Dim Td
                                 On Td.Dim_Date = Trunc (Es.Createdate)
                              Inner Join
                                 Base.Contact C
                              On Es.Shiptocontactid = C.Contactid
                           Left Outer Join
                              Gkdw.Time_Dim Td2
                           On Td2.Dim_Date = Trunc (Es.Shippeddate)
                        Left Outer Join
                           Base.Qg_Evticket Qe
                        On Qe.Evxevticketid = Esd.Evxevticketid
                     Left Outer Join
                        Base.Leadsource Ls
                     On Ls.Leadsourceid = Qe.Leadsourceid
                  Left Outer Join
                     Gkdw.Gk_Territory Gt
                  On Esd.Shiptopostal Between Gt.Zip_Start And Gt.Zip_End
                     And Gt.State = Esd.Shiptostate
               Left Outer Join
                  Gkdw.Product_Dim Ep
               On Esd.Productid = Ep.Product_Id
            Left Outer Join
               Base.Oracletx_History Oh
            On Es.Evxsoid = Oh.Evxevenrollid
    Where   Sotype = 'Standard';



