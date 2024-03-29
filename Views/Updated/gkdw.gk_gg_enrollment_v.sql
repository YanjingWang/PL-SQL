


Create Or Alter View Hold.Gk_Gg_Enrollment_V
(
   Enroll_Id,
   Event_Id,
   Start_Date,
   Cust_Id,
   First_Name,
   Last_Name,
   Email,
   Course_Code,
   Unit_Price,
   Ops_Country,
   Ch_Num,
   Md_Num,
   Pl_Num,
   Act_Num,
   Feetype,
   Country
)
As
   Select   Eh.Evxevenrollid Enroll_Id,
            Ed.Event_Id,
            Ed.Start_Date,
            C.Contactid Cust_Id,
            C.Firstname First_Name,
            C.Lastname Last_Name,
            C.Email,
            Cd.Course_Code,
            Pc.Unit_Price,
            Ed.Ops_Country,
            Cd.Ch_Num,
            Cd.Md_Num,
            Cd.Pl_Num,
            Cd.Act_Num,
            Ef.Feetype,
            Upper (Ad.Country) Country
     From                        Gkdw.Course_Dim Cd
                              Inner Join
                                 Gkdw.Event_Dim Ed
                              On Cd.Course_Id = Ed.Course_Id
                                 And Cd.Country = Ed.Ops_Country
                           Inner Join
                              Base.Evxenrollhx Eh
                           On Ed.Event_Id = Eh.Evxeventid
                        Inner Join
                           Base.Evxevticket Et
                        On Eh.Evxevticketid = Et.Evxevticketid
                     Inner Join
                        Base.Evxev_Txfee Ef
                     On Et.Evxevticketid = Ef.Evxevticketid
                  Inner Join
                     Base.Contact C
                  On Et.Attendeecontactid = C.Contactid
               Inner Join
                  Base.Address Ad
               On C.Addressid = Ad.Addressid
            Inner Join
               Gkdw.Gk_Sec_Plus_Course Pc
            On Substring(Cd.Course_Code, 1,  4) = Pc.Course_Code
               And Ed.Start_Date >= Pc.Avail_Date
    Where       Cd.Ch_Num In ('10')
            And Cd.Md_Num In ('10', '20')
            And Cast(Getutcdate() As Date) Between Ed.Start_Date - 14 And Ed.End_Date
            And Ed.Status != 'Cancelled'
            And Eh.Enrollstatus != 'Cancelled'
            And Ef.Feetype Not In
                     ('Ons-Additional',
                      'Ons - Additional',
                      'Ons - Base',
                      'Sub')
            And Substring(Cd.Course_Code, 1,  4) Not In ('5330', '5335', '5340')
            And Not Exists (Select   1
                              From   Gkdw.Gk_Sec_Plus_User_Info Ui
                             Where   Eh.Evxevenrollid = Ui.Enroll_Id)
   Union
   Select   Eh.Evxevenrollid Enroll_Id,
            Ed.Event_Id,
            Ed.Start_Date,
            C.Contactid Cust_Id,
            C.Firstname First_Name,
            C.Lastname Last_Name,
            C.Email,
            Cd.Course_Code,
            Pc.Unit_Price,
            Ed.Ops_Country,
            Cd.Ch_Num,
            Cd.Md_Num,
            Cd.Pl_Num,
            Cd.Act_Num,
            Ef.Feetype,
            Upper (Ad.Country) Country
     From                        Gkdw.Course_Dim Cd
                              Inner Join
                                 Gkdw.Event_Dim Ed
                              On Cd.Course_Id = Ed.Course_Id
                                 And Cd.Country = Ed.Ops_Country
                           Inner Join
                              Base.Evxenrollhx Eh
                           On Ed.Event_Id = Eh.Evxeventid
                        Inner Join
                           Base.Evxevticket Et
                        On Eh.Evxevticketid = Et.Evxevticketid
                     Inner Join
                        Base.Evxev_Txfee Ef
                     On Et.Evxevticketid = Ef.Evxevticketid
                  Inner Join
                     Base.Contact C
                  On Et.Attendeecontactid = C.Contactid
               Inner Join
                  Base.Address Ad
               On C.Addressid = Ad.Addressid
            Inner Join
               Gkdw.Gk_Sec_Plus_Course Pc
            On Substring(Cd.Course_Code, 1,  4) = Pc.Course_Code
               And Ed.Start_Date >= Pc.Avail_Date
    Where       Cd.Ch_Num In ('20')
            And Cd.Md_Num In ('10', '20')
            And Cd.Course_Code Not In ('3367N', '9730N')
            And Cast(Getutcdate() As Date) Between Ed.Start_Date - 14 And Ed.End_Date
            And Ed.Status != 'Cancelled'
            And Eh.Enrollstatus != 'Cancelled'
            And Ef.Feetype Not In
                     ('Ons-Additional',
                      'Ons - Additional',
                      'Ons - Base',
                      'Sub')
            And Substring(Cd.Course_Code, 1,  4) Not In ('5330', '5335', '5340')
            And Not Exists (Select   1
                              From   Gkdw.Gk_Sec_Plus_User_Info Ui
                             Where   Eh.Evxevenrollid = Ui.Enroll_Id);



