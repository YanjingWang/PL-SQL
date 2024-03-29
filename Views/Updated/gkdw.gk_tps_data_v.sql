


Create Or Alter View Hold.Gk_Tps_Data_V
(
   Tab_Type,
   Sales_Rep,
   Sales_Rep_Email,
   Manager_Name,
   Manager_Email,
   Dim_Year,
   Dim_Month_Num,
   Book_Mo,
   Book_Date,
   Book_Amt,
   Customer_Parent,
   Sales_Team,
   Evxevenrollid,
   Eventid,
   Coursecode,
   Eventname,
   Startdate,
   Course_Lob,
   Prepay_Card,
   Pack_Issued,
   Student_Postalcode,
   First_Digit,
   Province,
   Pack_Type,
   Eventcountry
)
As
     Select   [Tab_Type],
              [Sales_Rep],
              [Sales_Rep_Email],
              [Manager_Name],
              [Manager_Email],
              [Dim_Year],
              [Dim_Month_Num],
              [Book_Mo],
              [Book_Date],
              [Book_Amt],
              [Customer_Parent],
              [Sales_Team],
              [Evxevenrollid],
              [Eventid],
              [Coursecode],
              [Eventname],
              [Startdate],
              [Course_Lob],
              [Prepay_Card],
              [Pack_Issued],
              [Student_Postalcode],
              [First_Digit],
              [Province],
              [Pack_Type],
              [Eventcountry]
       From   (Select   'Dedicated Bookings' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Trunc (Et.Createdate) Book_Date,
                        Actual_Extended_Amount Book_Amt,
                        Et.Account Customer_Parent,
                        Ui.Division Sales_Team,
                        Et.Evxevenrollid,
                        Et.Evxeventid Eventid,
                        Et.Coursecode,
                        Et.Eventname,
                        Et.Startdate,
                        Null Course_Lob,
                        Et.Evxppcardid Prepay_Card,
                        Null Pack_Issued,
                        Et.Student_Postalcode,
                        Null First_Digit,
                        Case When A.Country = 'Canada' Then A.State
                           Else Null
                        End
                           Province,
                        Null Pack_Type,
                        Upper (Et.Eventcountry) Eventcountry
                 From                     Gkdw.Ent_Trans_Bookings_Mv Et
                                       Inner Join
                                          Base.Userinfo Ui
                                       On Replace (Upper (Et.Sold_By), ' ', '') =
                                             Replace (Upper (Ui.Username),
                                                      ' ',
                                                      '')
                                    Inner Join
                                       Base.Usersecurity Us
                                    On Ui.Userid = Us.Userid
                                       And Us.Enabled = 'T'
                                 Left Outer Join
                                    Base.Userinfo Um
                                 On Us.Managerid = Um.Userid
                              Inner Join
                                 Gkdw.Time_Dim Td
                              On Trunc (Et.Createdate) = Td.Dim_Date
                           Inner Join
                              Base.Contact C
                           On Et.Contactid = C.Contactid
                        Inner Join
                           Base.Address A
                        On C.Contactid = A.Entityid And A.Isprimary = 'T'
                Where   Td.Dim_Year >= 2015
               Union
               Select   'Misc Items' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        To_Date (
                              Lpad (Book_Mon, 2, '0')
                           + '/'
                           + Lpad (Book_Day, 2, '0')
                           + '/20'
                           + Lpad (Book_Year, 2, '0'),
                           'Mm/Dd/Yyyy'
                        )
                           Book_Date,
                        To_Number (Amount) Book_Amount,
                        Eb.Customer_Name,
                        Ui.Division Sales_Team,
                        Null Evxevenrollid,
                        Null Eventid,
                        Null Coursecode,
                        Eb.Project_Name,
                        Null Startdate,
                        Null Course_Lob,
                        Null Prepay_Card,
                        Null Pack_Issued,
                        Null Student_Postalcode,
                        Null First_Digit,
                        Null Province,
                        Null Pack_Type,
                        'Usa' Eventcountry
                 From               Gkdw.Gk_Misc_Ent_Bookings Eb
                                 Inner Join
                                    Gkdw.Time_Dim Td
                                 On To_Date (
                                          Lpad (Book_Mon, 2, '0')
                                       + '/'
                                       + Lpad (Book_Day, 2, '0')
                                       + '/20'
                                       + Lpad (Book_Year, 2, '0'),
                                       'Mm/Dd/Yyyy'
                                    ) = Td.Dim_Date
                              Inner Join
                                 Base.Userinfo Ui
                              On Replace (Upper (Eb.Sales_Rep), ' ', '') =
                                    Replace (Upper (Ui.Username), ' ', '')
                           Inner Join
                              Base.Usersecurity Us
                           On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                        Left Outer Join
                           Base.Userinfo Um
                        On Us.Managerid = Um.Userid
                Where       Misc_Type = 'Onsite'
                        And Eb.Book_Mon Between '1' And '12'
                        And Td.Dim_Year >= 2015
               Union
               Select   'Els Items' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        To_Date (
                              Lpad (Book_Mon, 2, '0')
                           + '/'
                           + Lpad (Book_Day, 2, '0')
                           + '/20'
                           + Lpad (Book_Year, 2, '0'),
                           'Mm/Dd/Yyyy'
                        )
                           Book_Date,
                        To_Number (Amount) Book_Amount,
                        Eb.Customer_Name,
                        Ui.Division Sales_Team,
                        Null Evxevenrollid,
                        Null Eventid,
                        Null Coursecode,
                        Eb.Project_Name,
                        Null Startdate,
                        Null Course_Lob,
                        Null Prepay_Card,
                        Null Pack_Issued,
                        Null Student_Postalcode,
                        Null First_Digit,
                        Null Province,
                        Null Pack_Type,
                        'Usa' Eventcountry
                 From               Gkdw.Gk_Misc_Ent_Bookings Eb
                                 Inner Join
                                    Gkdw.Time_Dim Td
                                 On To_Date (
                                          Lpad (Book_Mon, 2, '0')
                                       + '/'
                                       + Lpad (Book_Day, 2, '0')
                                       + '/20'
                                       + Lpad (Book_Year, 2, '0'),
                                       'Mm/Dd/Yyyy'
                                    ) = Td.Dim_Date
                              Inner Join
                                 Base.Userinfo Ui
                              On Replace (Upper (Eb.Sales_Rep), ' ', '') =
                                    Replace (Upper (Ui.Username), ' ', '')
                           Inner Join
                              Base.Usersecurity Us
                           On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                        Left Outer Join
                           Base.Userinfo Um
                        On Us.Managerid = Um.Userid
                Where       Misc_Type = 'Els'
                        And Eb.Book_Mon Between '1' And '12'
                        And Td.Dim_Year >= 2015
               Union
               Select   'Oe Bookings' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Tps2.Book_Date,
                        Tps2.Book_Amt,
                        Tps2.Acct_Name Customer_Parent,
                        Ui.Division Sales_Team,
                        Tps2.Enroll_Id,
                        Tps2.Event_Id,
                        Tps2.Course_Code,
                        Tps2.Course_Name,
                        Trunc (Tps2.Start_Date),
                        Null Course_Lob,
                        Tps2.Ppcard_Id,
                        Null Pack_Issued,
                        Tps2.Zipcode,
                        Null First_Digit,
                        Tps2.Province,
                        Null Pack_Type,
                        Upper (Tps2.Ops_Country) Eventcountry
                 From               Gkdw.Tps_2_Oe_Ch_Mp_V Tps2
                                 Inner Join
                                    Base.Userinfo Ui
                                 On Replace (Upper (Tps2.Channel_Manager),
                                             ' ',
                                             '') =
                                       Replace (Upper (Ui.Username), ' ', '')
                              Inner Join
                                 Base.Usersecurity Us
                              On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                           Left Outer Join
                              Base.Userinfo Um
                           On Us.Managerid = Um.Userid
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Tps2.Book_Date = Td.Dim_Date
                Where   Td.Dim_Year >= 2015
               Union
               Select   'Oe Bookings' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Tps2.Book_Date,
                        Tps2.Book_Amt * .5,
                        Tps2.Acct_Name Customer_Parent,
                        Ui.Division Sales_Team,
                        Tps2.Enroll_Id,
                        Tps2.Event_Id,
                        Tps2.Course_Code,
                        Tps2.Course_Name,
                        Trunc (Tps2.Start_Date),
                        Null Course_Lob,
                        Tps2.Ppcard_Id,
                        Null Pack_Issued,
                        Tps2.Zipcode,
                        Null First_Digit,
                        Tps2.Province,
                        Null Pack_Type,
                        Upper (Tps2.Ops_Country) Eventcountry
                 From               Gkdw.Tps_2_Oe_Ch_Mp_V Tps2
                                 Inner Join
                                    Base.Userinfo Ui
                                 On Replace (
                                       Upper(Substr (
                                                Tps2.Channel_Manager,
                                                1,
                                                Instr (Tps2.Channel_Manager,
                                                       '/')
                                                - 1
                                             )),
                                       ' ',
                                       ''
                                    ) = Replace (Upper (Ui.Username), ' ', '')
                              Inner Join
                                 Base.Usersecurity Us
                              On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                           Left Outer Join
                              Base.Userinfo Um
                           On Us.Managerid = Um.Userid
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Tps2.Book_Date = Td.Dim_Date
                Where   Td.Dim_Year >= 2015 And Channel_Manager Like '%/%'
               Union
               Select   'Oe Bookings' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Tps2.Book_Date,
                        Tps2.Book_Amt * .5,
                        Tps2.Acct_Name Customer_Parent,
                        Ui.Division Sales_Team,
                        Tps2.Enroll_Id,
                        Tps2.Event_Id,
                        Tps2.Course_Code,
                        Tps2.Course_Name,
                        Trunc (Tps2.Start_Date),
                        Null Course_Lob,
                        Tps2.Ppcard_Id,
                        Null Pack_Issued,
                        Tps2.Zipcode,
                        Null First_Digit,
                        Tps2.Province,
                        Null Pack_Type,
                        Upper (Tps2.Ops_Country) Eventcountry
                 From               Gkdw.Tps_2_Oe_Ch_Mp_V Tps2
                                 Inner Join
                                    Base.Userinfo Ui
                                 On Replace (
                                       Upper(Substr (
                                                Tps2.Channel_Manager,
                                                Instr (Tps2.Channel_Manager,
                                                       '/')
                                                + 1
                                             )),
                                       ' ',
                                       ''
                                    ) = Replace (Upper (Ui.Username), ' ', '')
                              Inner Join
                                 Base.Usersecurity Us
                              On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                           Left Outer Join
                              Base.Userinfo Um
                           On Us.Managerid = Um.Userid
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Tps2.Book_Date = Td.Dim_Date
                Where   Td.Dim_Year >= 2015 And Channel_Manager Like '%/%'
               Union
               Select   'Pack Sales' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Trunc (Tps3.Issueddate) Book_Date,
                        Valuepurchasedbase,
                        Tps3.Issuedtoaccount,
                        Ui.Division,
                        Null Enroll_Id,
                        Null Event_Id,
                        Null Course_Code,
                        Null Course_Name,
                        Null Start_Date,
                        Null Course_Lob,
                        Tps3.Evxppcardid,
                        Tps3.Issueddate,
                        Tps3.Ordered_By_Zipcode,
                        Null First_Digit,
                        Tps3.Ordered_By_Province,
                        Tps3.Cardtype,
                        Upper (Tps3.Billtocountry)
                 From               Gkdw.Tps_3_New_Pack_V Tps3
                                 Inner Join
                                    Base.Userinfo Ui
                                 On Replace (Upper (Tps3.Sales_Rep), ' ', '') =
                                       Replace (Upper (Ui.Username), ' ', '')
                              Inner Join
                                 Base.Usersecurity Us
                              On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                           Left Outer Join
                              Base.Userinfo Um
                           On Us.Managerid = Um.Userid
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Trunc (Tps3.Issueddate) = Td.Dim_Date
                Where   Td.Dim_Year >= 2015
               Union
               Select   'Oe Pack Burn' Tab_Type,
                        Ui.Username Sales_Rep,
                        Case
                           When Ui.Email Is Null And Ui.Firstname Is Null
                           Then
                              Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Ui.Email Is Null
                           Then
                                 Replace (Ui.Firstname, ' ', '')
                              + '.'
                              + Replace (Ui.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Ui.Email
                        End
                           Sales_Rep_Email,
                        Um.Username Manager_Name,
                        Case
                           When Um.Email Is Null And Um.Firstname Is Null
                           Then
                              Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           When Um.Email Is Null
                           Then
                                 Replace (Um.Firstname, ' ', '')
                              + '.'
                              + Replace (Um.Lastname, ' ', '')
                              + '@Globalknowledge.Com'
                           Else
                              Um.Email
                        End
                           Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Trunc (T4.Transdate) Book_Date,
                        T4.Book_Amt,
                        T4.Issuedtoaccount,
                        Ui.Division,
                        T4.Enroll_Id,
                        T4.Evxeventid,
                        T4.Course_Code,
                        T4.Prod_Name,
                        T4.Rev_Date,
                        Null Course_Lob,
                        T4.Evxppcardid,
                        Null Pack_Issued,
                        T4.Student_Zip,
                        Null First_Digit,
                        T4.Province,
                        Null Pack_Type,
                        Upper (T4.Billtocountry)
                 From               Gkdw.Tps_4_Pack_Burn_V T4
                                 Inner Join
                                    Base.Userinfo Ui
                                 On Replace (Upper (T4.Sales_Rep), ' ', '') =
                                       Replace (Upper (Ui.Username), ' ', '')
                              Inner Join
                                 Base.Usersecurity Us
                              On Ui.Userid = Us.Userid And Us.Enabled = 'T'
                           Left Outer Join
                              Base.Userinfo Um
                           On Us.Managerid = Um.Userid
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Trunc (T4.Transdate) = Td.Dim_Date
                Where   Td.Dim_Year >= 2015
                        And (Exists
                                (Select   1
                                   From   Gkdw.Tps_2_Oe_Ch_Mp_V T2
                                  Where   T4.Enroll_Id = T2.Enroll_Id
                                          And T4.Sales_Rep = T2.Channel_Manager)
                             Or Exists
                                  (Select   1
                                     From   Gkdw.Ent_Trans_Bookings_Mv Et
                                    Where   T4.Enroll_Id = Et.Evxevenrollid
                                            And T4.Sales_Rep = Et.Sold_By))
               Union
               Select   'Po/Clc' Tab_Type,
                        T3.Username,
                        T3.Sales_Rep_Email,
                        T3.Manager_Name,
                        T3.Manager_Email,
                        Td.Dim_Year,
                        Td.Dim_Month_Num,
                        Substring(Td.Dim_Month, 1,  3) Book_Mo,
                        Trunc (T3.Createdate) Book_Date,
                        T3.Amount,
                        T3.Account,
                        T3.Division,
                        Null Enroll_Id,
                        Null Event_Id,
                        Null Course_Code,
                        T3.Ordertype + '-' + T3.Ponumber,
                        Null,
                        Null,
                        Null,
                        Null,
                        Null,
                        Null,
                        Null,
                        Null,
                        T3.Country
                 From      Gkdw.Tps_3_Po_Clc_V T3
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Trunc (T3.Createdate) = Td.Dim_Date
                Where   Td.Dim_Year >= 2015) a1
      Where   Dim_Year = 2015
   --And Dim_Month_Num = 12
   ;



