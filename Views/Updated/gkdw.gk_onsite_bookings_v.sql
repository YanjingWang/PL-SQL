


Create Or Alter View Hold.Gk_Onsite_Bookings_V
(
   Enrollid,
   Enroll_Amt,
   Status_Desc,
   Net_Amt,
   List_Price,
   Bookdate,
   Enroll_Status,
   Event_Id,
   Country,
   Course_Code,
   Event_Name,
   Event_Type,
   Event_Status,
   Cancel_Reason,
   Cancel_Date,
   Order_Status,
   Ch_Value,
   Ch_Desc,
   Md_Value,
   Md_Desc,
   Pl_Value,
   Pl_Desc,
   Revdate,
   Sold_By,
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
   Opportunityid,
   Opportunity_Name,
   Op_Create_User,
   Createdate,
   Channel_Manager,
   Partner_Name,
   Enddate,
   City,
   State,
   Zip
)
As
   Select   Eh.Evxevenrollid Enrollid,
            Et.Actualamount Enroll_Amt,
            Et.Actualnetrate Net_Amt,
            Cd.List_Price,
            Eh.Enrollstatusdesc Status_Desc,
            Et.Createdate Bookdate,
            Eh.Enrollstatus Enroll_Status,
            Ev.Evxeventid Event_Id,
            Ev.Facilitycountry Country,
            Ev.Coursecode Course_Code,
            Ev.Eventname Event_Name,
            Ev.Eventtype Event_Type,
            Ev.Eventstatus,
            Ev.Cancelreason,
            Ev.Canceldate,
            Ot.Orderstatus Order_Status,
            Cd.Ch_Num Ch_Value,
            Cd.Course_Ch Ch_Desc,
            Cd.Md_Num Md_Value,
            Cd.Course_Mod Md_Desc,
            Cd.Pl_Num Pl_Value,
            Cd.Course_Pl Pl_Desc,
            Ev.Startdate Revdate,
            Ui.Username Sold_By,
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
            Ev.Opportunityid,
            Op.Description Opportunity_Name,
            Ui2.Username Op_Create_User,
            Et.Createdate,
            Cp.Channel_Manager,
            Cp.Partner_Name,
            Ev.Enddate,
            Ad.City,
            Ad.State,
            Ad.Postalcode
     From                                                      Base.Evxenrollhx Eh
                                                            Inner Join
                                                               Base.Evxev_Txfee Et
                                                            On Eh.Evxevenrollid =
                                                                  Et.Evxevenrollid
                                                         Inner Join
                                                            Base.Evxevent Ev
                                                         On Eh.Evxeventid =
                                                               Ev.Evxeventid
                                                      Inner Join
                                                         Base.Contact C
                                                      On C.Contactid =
                                                            Et.Attendeecontactid
                                                   Inner Join
                                                      Base.Account Ac
                                                   On C.Accountid =
                                                         Ac.Accountid
                                                Inner Join
                                                   Base.Address Ad
                                                On Ac.Addressid =
                                                      Ad.Addressid
                                             Inner Join
                                                Gkdw.Time_Dim Td
                                             On Td.Dim_Date =
                                                   Trunc (Et.Createdate)
                                          Inner Join
                                             Gkdw.Time_Dim Td2
                                          On Td2.Dim_Date = Ev.Startdate
                                       Left Outer Join
                                          Base.Opportunity Op
                                       On Ev.Opportunityid = Op.Opportunityid
                                    Left Outer Join
                                       Base.Userinfo Ui
                                    On Op.Accountmanagerid = Ui.Userid
                                 Left Outer Join
                                    Base.Userinfo Ui2
                                 On Op.Createuser = Ui2.Userid
                              Left Outer Join
                                 Base.Oracletx_History Ot
                              On Et.Evxbillingid = Ot.Evxbillingid
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
                        Base.Qg_Accprofiletype Qa
                     On Qa.Accountid = C.Accountid
                  Left Outer Join
                     Base.Qg_Evticket Qe
                  On Qe.Evxevticketid = Et.Evxevticketid
               Left Outer Join
                  Base.Leadsource Ls
               On Ls.Leadsourceid = Qe.Leadsourceid
            Left Outer Join
               Gkdw.Gk_Channel_Partner Cp
            On Ls.Abbrevdesc = Cp.Partner_Key_Code
    Where   (Cd.Ch_Num = '20'
             Or (Cd.Ch_Num Is Null And Ev.Eventtype = 'Onsite'))
            And (Et.Actualamount < 0 Or Et.Actualamount > 1);



