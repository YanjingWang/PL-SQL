


Create Or Alter View Hold.Tps_4_Ent_Pack_Burn_V
(
   Evxppcardid,
   Soldbyuser,
   Transdate,
   Cardshortcode,
   Cardstatus,
   Billtocountry,
   Cardtype,
   Issuedtocontact,
   Issuedtoaccount,
   Transtype,
   Pp_Trans_Amt,
   Enroll_Id,
   Enroll_Stat,
   Course_Code,
   Evxeventid,
   Enroll_Date,
   Rev_Date,
   Prod_Name,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Create_User,
   Billing_Zip,
   Student_Zip,
   Delivery_Zip,
   Province,
   Sales_Rep
)
As
     Select   Ep.Evxppcardid,
              Eo.Soldbyuser,
              Trunc (Et.Transdate) Transdate,
              Cardshortcode,
              Cardstatus,
              Eo.Billtocountry,
              Cardtype,
              Issuedtocontact,
              Issuedtoaccount,
              Et.Transtype,
              Isnull(
                 Case Et.Transtype
                    When 'Redeemed' Then Et.Valueprepaybase + Qb.Taxamount
                    Else Et.Valueprepaybase - Qb.Taxamount
                 End,
                 Es.Totalnotax
              )
                 Pp_Trans_Amt,
              Isnull(Qb.Evxevenrollid, Es.Evxsoid) Enroll_Id,
              Isnull(Eh.Enrollstatus, Sostatus) Enroll_Stat,
              Cd.Course_Code,
              Ee.Evxeventid,
              Eb.Createdate Enroll_Date,
              Isnull(Ee.Startdate, Es.Createdate) Rev_Date,
              Isnull(Ee.Coursename, Esd.Productname) Prod_Name,
              Isnull(Cd.Ch_Num, Pd.Ch_Num) Ch_Num,
              Isnull(Cd.Md_Num, Pd.Md_Num) Md_Num,
              Isnull(Cd.Pl_Num, Pd.Pl_Num) Pl_Num,
              Isnull(U1.Username, U2.Username) Create_User,
              Isnull(C1.Zipcode, Es.Billtopostal) Billing_Zip,
              Isnull(C2.Zipcode, Es.Orderedbypostal) Student_Zip,
              Isnull(Ee.Facilitypostal, Es.Shiptopostal) Delivery_Zip,
              C1.Province,
              Case
                 When Pp.Osr_Rep_Name Is Not Null Then Pp.Osr_Rep_Name
                 When Pp.Cam_Rep_Name Is Not Null Then Pp.Cam_Rep_Name
                 When Pp.Ob_Rep_Name Is Not Null Then Pp.Ob_Rep_Name
                 When Pp.Icam_Rep_Name Is Not Null Then Pp.Icam_Rep_Name
                 When Pp.Iam_Rep_Name Is Not Null Then Pp.Iam_Rep_Name
                 When Pp.Tam_Rep_Name Is Not Null Then Pp.Tam_Rep_Name
                 When Pp.Nam_Rep_Name Is Not Null Then Pp.Nam_Rep_Name
                 When Pp.Fsd_Rep_Name Is Not Null Then Pp.Fsd_Rep_Name
              End
                 Sales_Rep
       From                                                         Base.Evxppcard Ep
                                                                 Inner Join
                                                                    Gkdw.Ppcard_Dim Pp
                                                                 On Ep.Evxppcardid =
                                                                       Pp.Ppcard_Id
                                                              Inner Join
                                                                 Base.Evxso Eo
                                                              On Ep.Evxsoid =
                                                                    Eo.Evxsoid
                                                           Inner Join
                                                              Gkdw.Tps_3_New_Pack_V T3
                                                           On Ep.Evxppcardid =
                                                                 T3.Evxppcardid
                                                        Left Outer Join
                                                           Base.Evxppcard_Tx Et
                                                        On Ep.Evxppcardid =
                                                              Et.Evxppcardid
                                                           And Et.Transdesc !=
                                                                 'Purchase'
                                                     Left Outer Join
                                                        Base.Evxbillpayment Eb
                                                     On Et.Evxbillpaymentid =
                                                           Eb.Evxbillpaymentid
                                                  Left Outer Join
                                                     Base.Qg_Billingpayment Qb
                                                  On Eb.Evxbillpaymentid =
                                                        Qb.Evxbillpaymentid
                                               Left Outer Join
                                                  Base.Evxenrollhx Eh
                                               On Qb.Evxevenrollid =
                                                     Eh.Evxevenrollid
                                            Left Outer Join
                                               Base.Evxevticket Etk
                                            On Eh.Evxevticketid =
                                                  Etk.Evxevticketid
                                         Left Outer Join
                                            Gkdw.Cust_Dim C1
                                         On Etk.Billtocontactid = C1.Cust_Id
                                      Left Outer Join
                                         Gkdw.Cust_Dim C2
                                      On Etk.Attendeecontactid = C2.Cust_Id
                                   Left Outer Join
                                      Base.Evxevent Ee
                                   On Eh.Evxeventid = Ee.Evxeventid
                                Left Outer Join
                                   Base.Evxso Es
                                On Eb.Evxsoid = Es.Evxsoid
                             Left Outer Join
                                Base.Evxsodetail Esd
                             On Es.Evxsoid = Esd.Evxsoid
                          Left Outer Join
                             Base.Qg_Event Qe
                          On Ee.Evxeventid = Qe.Evxeventid
                       Left Outer Join
                          Gkdw.Course_Dim Cd
                       On Ee.Evxcourseid = Cd.Course_Id
                          And Upper (Trim (Qe.Eventcountry)) = Cd.Country
                    Left Outer Join
                       Gkdw.Product_Dim Pd
                    On Esd.Productid = Pd.Product_Id
                 Left Join
                    Base.Userinfo U1
                 On Etk.Createuser = U1.Userid
              Left Join
                 Base.Userinfo U2
              On Es.Createuser = U2.Userid
      Where       Ep.Cardstatus != 'Void'
              --And Qb.Evxevenrollid = 'Q6uj9066gvlz'
              And Trunc (Et.Transdate) >= '01-Jan-2016'
              And Isnull(Cd.Ch_Num, Pd.Ch_Num) = '20'
              And Case
                    When Pp.Osr_Rep_Name Is Not Null Then Pp.Osr_Rep_Name
                    When Pp.Cam_Rep_Name Is Not Null Then Pp.Cam_Rep_Name
                    When Pp.Ob_Rep_Name Is Not Null Then Pp.Ob_Rep_Name
                    When Pp.Icam_Rep_Name Is Not Null Then Pp.Icam_Rep_Name
                    When Pp.Iam_Rep_Name Is Not Null Then Pp.Iam_Rep_Name
                    When Pp.Tam_Rep_Name Is Not Null Then Pp.Tam_Rep_Name
                    When Pp.Nam_Rep_Name Is Not Null Then Pp.Nam_Rep_Name
                    When Pp.Fsd_Rep_Name Is Not Null Then Pp.Fsd_Rep_Name
                 End = T3.Sales_Rep
   ;



