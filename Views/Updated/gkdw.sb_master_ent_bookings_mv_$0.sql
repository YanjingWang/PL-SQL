


Create Or Alter View Hold.Sb_Master_Ent_Bookings_Mv_$0
(
   Enroll_Id,
   Event_Id,
   Cust_Id,
   Ch_Num,
   Course_Ch,
   Md_Num,
   Course_Mod,
   Pl_Num,
   Course_Pl,
   Start_Date,
   End_Date,
   Course_Code,
   Course_Name,
   Short_Name,
   Ops_Country,
   Enroll_Date,
   Sale_Date,
   Rev_Date,
   Book_Amt,
   List_Price,
   Curr_Code,
   Sold_By,
   Salesperson,
   Enroll_Type,
   Country,
   Enroll_Status,
   Fee_Type,
   Payment_Method,
   Ppcard_Id,
   Po_Number,
   Acct_Id,
   Account,
   Acct_City,
   Acct_State,
   Acct_Zipcode,
   Acct_Country,
   Cust_First_Name,
   Cust_Last_Name,
   Cust_Name,
   Email,
   Address1,
   Address2,
   Cust_City,
   Cust_Workphone,
   Cust_State,
   Cust_Zipcode,
   Cust_Country,
   Pos_Year,
   Pos_Qtr,
   Pos_Month,
   Pos_Month_Name,
   Pos_Period,
   Pos_Week,
   Pod_Year,
   Pod_Qtr,
   Pod_Month,
   Pod_Month_Name,
   Pod_Period,
   Pod_Week,
   Gk_Vertical,
   Farm_Flag,
   Fscl_Pos_Year,
   Fscl_Pos_Qtr,
   Fscl_Pos_Month,
   Fscl_Pos_Month_Name,
   Fscl_Pos_Period,
   Fscl_Pos_Week,
   Fscl_Pod_Year,
   Fscl_Pod_Qtr,
   Fscl_Pod_Month,
   Fscl_Pod_Month_Name,
   Fscl_Pod_Period,
   Fscl_Pod_Week,
   Promo_Adj,
   Comm_Amt,
   Bookings_Country
)
As
   Select   Et.Evxevenrollid Enroll_Id,
            Et.Evxeventid Event_Id,
            Et.Contactid Cust_Id,
            Cd.Ch_Num,
            Cd.Course_Ch,
            Cd.Md_Num,
            Cd.Course_Mod,
            Cd.Pl_Num,
            Cd.Course_Pl,
            Ed.Start_Date,
            Ed.End_Date,
            Cd.Course_Code,
            Cd.Course_Name,
            Cd.Short_Name,
            Ed.Ops_Country,
            Trunc (Et.[Getutcdate()] - 1) Enroll_Date,
            Trunc (Et.[Getutcdate()] - 1) Sale_Date,
            Case
               When Et.[Getutcdate()] > Ed.Start_Date
               Then
                  Trunc (Et.[Getutcdate()] - 1)
               Else
                  Ed.Start_Date
            End
               Rev_Date,
            Et.Actual_Extended_Amount Book_Amt,
            Cd.List_Price,
            Et.Currencytype Curr_Code,
            Et.Sold_By,
            Et.Salesrep Salesperson,
            Et.Onsite_Type Enroll_Type,
            Et.Eventcountry Country,
            Et.Enrollstatus Enroll_Status,
            'Ons-Base' Fee_Type,
            Case
               When Et.Ponumber Is Not Null Then 'Purchase Order'
               When Et.Evxppcardid Is Not Null Then 'Prepay Card'
               Else Null
            End
               Payment_Method,
            Et.Evxppcardid Ppcard_Id,
            Et.Ponumber Po_Number,
            Et.Accountid Acct_Id,
            Et.Account,
            Upper (Ad1.City) Acct_City,
            Upper (Ad1.State) Acct_State,
            Upper (Ad1.Postalcode) Acct_Zipcode,
            Upper (Ad1.Country) Acct_Country,
            C.Firstname Cust_First_Name,
            C.Lastname Cust_Last_Name,
            C.Firstname + ' ' + C.Lastname Cust_Name,
            C.Email,
            Upper (Ad2.Address1) Address1,
            Upper (Ad2.Address2) Address2,
            Upper (Ad2.City) Cust_City,
            Upper (C.Workphone) Cust_Workphone,
            Upper (Ad2.State) Cust_State,
            Upper (Ad2.Postalcode) Cust_Zipcode,
            Upper (Ad2.Country) Cust_Country,
            --       Sl.Segment,
            --       Sl.Field_Rep Sl_Sales_Rep,
            --       Sl.Ob_Terr Sl_Ob_Terr,
            --       Sl.Field_Terr Sl_Field_Terr,
            --       Gt.Salesrep Zip_Sales_Rep,
            --       Gt.Territory_Id Zip_Terr,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             'Field Only'
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             Ui3.Division
            --          When Sl.Segment = 'Channel'
            --          Then
            --             Ui2.Division
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Sp 1'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Sp 2'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Sp 2'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             Gt.Territory_Id
            --          When Sl.Ob_Terr Is Not Null           --And Sl.Accountid Is Not Null
            --          Then
            --             Sl.Ob_Terr
            --          Else
            --             Isnull(Ui.Division, Gt.Territory_Id)
            --       End
            --          Sales_Terr_Id,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             Ui2.Username
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             Ui3.Username
            --          When Sl.Segment = 'Channel'
            --          Then
            --             Ui2.Username
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Carl Beardsworth'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Anna Tancredi'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Anna Tancredi'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             Gt.Salesrep
            --          When Sl.Ob_Terr Is Not Null           --And Sl.Accountid Is Not Null
            --          Then
            --             Isnull(Ui.Username, Ui2.Username)
            --          Else
            --             Isnull(Ui.Username, Gt.Salesrep)
            --       End
            --          Sales_Rep,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             Um2.Username
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             Um3.Username
            --          When Sl.Segment = 'Channel'
            --          Then
            --             Um2.Username
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Adam Vandamia'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Adam Vandamia'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Adam Vandamia'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             Gt.Region_Mgr
            --          When Sl.Ob_Terr Is Not Null
            --          Then
            --             Isnull(Um.Username, Um2.Username)
            --          Else
            --             Isnull(Um.Username, Gt.Region_Mgr)
            --       End
            --          Sales_Manager,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             'Field Only'
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             'Channel'
            --          When Sl.Segment = 'Channel'
            --          Then
            --             'Channel'
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Strategic Alliance'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Strategic Alliance'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Strategic Alliance'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             'Canada'
            --          When Sl.Ob_Terr Is Not Null
            --          Then
            --             Isnull(Ui.Region, Ui2.Region)
            --          Else
            --             Isnull(Ui.Region, Gt.Region)
            --       End
            --          Sales_Region,
            Td1.Dim_Year Pos_Year,
            Td1.Dim_Year + '-' + Lpad (Td1.Dim_Quarter, 2, '0') Pos_Qtr,
            Td1.Dim_Year + '-' + Lpad (Td1.Dim_Month_Num, 2, '0') Pos_Month,
            Td1.Dim_Month Pos_Month_Name,
            Td1.Dim_Period_Name Pos_Period,
            Td1.Dim_Year + '-' + Lpad (Td1.Dim_Week, 2, '0') Pos_Week,
            Td2.Dim_Year Pod_Year,
            Td2.Dim_Year + '-' + Lpad (Td2.Dim_Quarter, 2, '0') Pod_Qtr,
            Td2.Dim_Year + '-' + Lpad (Td2.Dim_Month_Num, 2, '0') Pod_Month,
            Td2.Dim_Month Pod_Month_Name,
            Td2.Dim_Period_Name Pod_Period,
            Td2.Dim_Year + '-' + Lpad (Td2.Dim_Week, 2, '0') Pod_Week,
            Nv.Gk_Vertical,
            Case When Cd.Pl_Num = '50' Then 'Y' Else 'N' End Farm_Flag,
            Td1.Fiscal_Year Fscl_Pos_Year,
            Td1.Fiscal_Year + '-' + Lpad (Td1.Fiscal_Quarter, 2, '0')
               Fscl_Pos_Qtr,
            Td1.Fiscal_Year + '-' + Lpad (Td1.Fiscal_Month_Num, 2, '0')
               Fscl_Pos_Month,
            Td1.Fiscal_Month Fscl_Pos_Month_Name,
            Td1.Fiscal_Period_Name Fscl_Pos_Period,
            Td1.Fiscal_Year + '-' + Lpad (Td1.Fiscal_Week, 2, '0')
               Fscl_Pos_Week,
            Td2.Fiscal_Year Fscl_Pod_Year,
            Td2.Fiscal_Year + '-' + Lpad (Td2.Fiscal_Quarter, 2, '0')
               Fscl_Pod_Qtr,
            Td2.Fiscal_Year + '-' + Lpad (Td2.Fiscal_Month_Num, 2, '0')
               Fscl_Pod_Month,
            Td2.Fiscal_Month Fscl_Pod_Month_Name,
            Td2.Fiscal_Period_Name Fscl_Pod_Period,
            Td2.Fiscal_Year + '-' + Lpad (Td2.Fiscal_Week, 2, '0')
               Fscl_Pod_Week,
            0 Promo_Adj,
            Et.Actual_Extended_Amount Comm_Amt,
            Case
               When Cd.Md_Num In
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    And Upper (Ad2.Country) = 'Canada'
               Then
                  'Canada'
               When Cd.Md_Num In
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    And Ad2.Country Is Null
                    And Upper (Ad1.Country) = 'Canada'
               Then
                  'Canada'
               When Cd.Md_Num In
                          ('20', '31', '32', '33', '34', '42', '43', '44')
               Then
                  'Usa'
               Else
                  Upper (Ed.Country)
            End
               Bookings_Country
     From                                 Gkdw.Ent_Trans_Bookings_Mv Et
                                       Inner Join
                                          Gkdw.Event_Dim Ed
                                       On Et.Evxeventid = Ed.Event_Id
                                    Inner Join
                                       Gkdw.Course_Dim Cd
                                    On Ed.Course_Id = Cd.Course_Id
                                       And Case
                                             When Ed.Ops_Country = 'Canada'
                                             Then
                                                'Canada'
                                             Else
                                                'Usa'
                                          End = Cd.Country
                                 Inner Join
                                    Base.Account Ac
                                 On Et.Accountid = Ac.Accountid
                              Inner Join
                                 Base.Qg_Account Qa
                              On Ac.Accountid = Qa.Accountid
                           Left Outer Join
                              Gkdw.Gk_Naics_Verticals Nv
                           On Qa.Group_Naics_Code = Nv.Naics_Code
                        Inner Join
                           Base.Address Ad1
                        On Ac.Addressid = Ad1.Addressid
                     Inner Join
                        Base.Contact C
                     On Et.Contactid = C.Contactid
                  Inner Join
                     Base.Address Ad2
                  On C.Addressid = Ad2.Addressid
               --       Left Outer Join Gkdw.Gk_Account_Segments_Mv Sl
               --          On Ac.Accountid = Sl.Accountid
               --       Left Outer Join Gkdw.Gk_Territory Gt
               --          On     Ad2.Postalcode Between Gt.Zip_Start And Gt.Zip_End
               --             And Gt.Territory_Type = 'Ob'
               Inner Join
                  Gkdw.Time_Dim Td1
               On Trunc (Et.[Getutcdate()]) = Td1.Dim_Date
            Inner Join
               Gkdw.Time_Dim Td2
            On Case
                  When Cd.Md_Num In ('31', '32', '33', '34', '43', '44')
                  Then
                     Trunc (Et.[Getutcdate()])
                  Else
                     Ed.Start_Date
               End = Td2.Dim_Date
    --       Left Outer Join Base.Userinfo Ui
    --          On Ui.Userid = Isnull(Sl.Ob_Rep_Id, Gt.Userid)
    --       Left Outer Join Base.Usersecurity Us On Ui.Userid = Us.Userid
    --       Left Outer Join Base.Userinfo Um On Us.Managerid = Um.Userid
    --       Left Outer Join Base.Userinfo Ui2
    --          On Sl.Field_Rep_Id = Ui2.Userid And Ui2.Region != 'Retired'
    --       Left Outer Join Base.Usersecurity Us2 On Ui2.Userid = Us2.Userid
    --       Left Outer Join Base.Userinfo Um2 On Us2.Managerid = Um2.Userid
    --       Left Outer Join Base.Userinfo Ui3
    --          On Et.Salesrep = Ui3.Username And Ui3.Region != 'Retired'
    --       Left Outer Join Base.Usersecurity Us3 On Ui2.Userid = Us3.Userid
    --       Left Outer Join Base.Userinfo Um3 On Us3.Managerid = Um3.Userid
    Where   Td1.Dim_Year >= 2016
            -- And Et.Actual_Extended_Amount <> 0
            -- And Et.Evxeventid='Qgkid0b936z6'
            And Cd.Course_Code Not In
                     ('1500D', '4931D', '283919I', '5983D', '1978I') -- Sr 11/6/2018 Ticket# 1937
            And Not Exists (Select   1
                              From   Gkdw.Gk_Master_Account_Exclude Ma
                             Where   Ma.Acct_Id = Ac.Accountid)
   Union
   Select   F.Enroll_Id,
            F.Event_Id,
            F.Cust_Id,
            Cd.Ch_Num,
            Cd.Course_Ch,
            Cd.Md_Num,
            Cd.Course_Mod,
            Cd.Pl_Num,
            Cd.Course_Pl,
            Ed.Start_Date,
            Ed.End_Date,
            Cd.Course_Code,
            Cd.Course_Name,
            Cd.Short_Name,
            Ed.Ops_Country,
            F.Enroll_Date,
            Trunc (Et.[Getutcdate()] - 1) Sale_Date,
            F.Rev_Date,
            F.Book_Amt,
            F.List_Price,
            F.Curr_Code,
            Null,
            F.Salesperson,
            F.Enroll_Type,
            F.Country,
            F.Enroll_Status,
            F.Fee_Type,
            F.Payment_Method,
            F.Ppcard_Id,
            F.Po_Number,
            F.Acct_Id,
            F.Acct_Name,
            Upper (Ad1.City) Acct_City,
            Upper (Ad1.State) Acct_State,
            Upper (Ad1.Postalcode) Acct_Zipcode,
            Upper (Ad1.Country) Acct_Country,
            --  Change Begins: Tkt # 32405 By Sbaral
            F.Cust_First_Name Cust_First_Name,
            F.Cust_Last_Name Cust_Last_Name,
            F.Cust_First_Name + ' ' + F.Cust_Last_Name Cust_Name,
            F.Cust_Email Email,
            Upper (F.Cust_Address1) Address1,
            Upper (F.Cust_Address2) Address2,
            Upper (F.Cust_City) Cust_City,
            Upper (C.Workphone) Cust_Workphone,
            Upper (F.Cust_State) Cust_State,
            Upper (F.Cust_Zipcode) Cust_Zipcode,
            Upper (F.Cust_Country) Cust_Country,
            -- C.Firstname Cust_First_Name,
            --  C.Lastname Cust_Last_Name,
            -- C.Firstname + ' ' + C.Lastname Cust_Name,
            -- C.Email,
            -- Upper (Ad2.Address1) Address1,
            --  Upper (Ad2.Address2) Address2,
            --  Upper (Ad2.City) Cust_City,
            --  Upper (C.Workphone) Cust_Workphone,
            --  Upper (Ad2.State) Cust_State,
            --  Upper (Ad2.Postalcode) Cust_Zipcode,
            --  Upper (Ad2.Country) Cust_Country,

            --  Change Ends: Tkt # 32405 By Sbaral
            --       Sl.Segment,
            --       Sl.Field_Rep Sl_Sales_Rep,
            --       Sl.Ob_Terr Sl_Ob_Terr,
            --       Sl.Field_Terr Sl_Field_Terr,
            --       Gt.Salesrep Zip_Sales_Rep,
            --       Gt.Territory_Id Zip_Terr,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             'Field Only'
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             Ui3.Division
            --          When Sl.Segment = 'Channel'
            --          Then
            --             Ui2.Division
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Sp 1'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Sp 2'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Sp 2'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             Gt.Territory_Id
            --          When Sl.Ob_Terr Is Not Null           --And Sl.Accountid Is Not Null
            --          Then
            --             Sl.Ob_Terr
            --          Else
            --             Isnull(Ui.Division, Gt.Territory_Id)
            --       End
            --          Sales_Terr_Id,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             Ui2.Username
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             Ui3.Username
            --          When Sl.Segment = 'Channel'
            --          Then
            --             Ui2.Username
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Carl Beardsworth'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Anna Tancredi'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Anna Tancredi'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             Gt.Salesrep
            --          When Sl.Ob_Terr Is Not Null           --And Sl.Accountid Is Not Null
            --          Then
            --             Isnull(Ui.Username, Ui2.Username)
            --          Else
            --             Isnull(Ui.Username, Gt.Salesrep)
            --       End
            --          Sales_Rep,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             Um2.Username
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             Um3.Username
            --          When Sl.Segment = 'Channel'
            --          Then
            --             Um2.Username
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Adam Vandamia'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Adam Vandamia'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Adam Vandamia'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             Gt.Region_Mgr
            --          When Sl.Ob_Terr Is Not Null
            --          Then
            --             Isnull(Um.Username, Um2.Username)
            --          Else
            --             Isnull(Um.Username, Gt.Region_Mgr)
            --       End
            --          Sales_Manager,
            --       Case
            --          When Ui2.Division = 'Field Only'
            --          Then
            --             'Field Only'
            --          When Cd.Ch_Num = '20' And Ui3.Region = 'Channel'
            --          Then
            --             'Channel'
            --          When Sl.Segment = 'Channel'
            --          Then
            --             'Channel'
            --          When Sl.Segment = 'Strategic Alliance'
            --          Then
            --             'Strategic Alliance'
            --          When     Sl.Segment Is Null
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Strategic Alliance'
            --          When     Sl.Segment = 'Inside'
            --               And Sl.Field_Rep = 'Tbd'
            --               And Substr (Upper (Ad2.Country), 1, 2) Not In ('Us', 'Ca')
            --          Then
            --             'Strategic Alliance'
            --          When Substr (Upper (Ad2.Country), 1, 2) = 'Ca'
            --          Then
            --             'Canada'
            --          When Sl.Ob_Terr Is Not Null
            --          Then
            --             Isnull(Ui.Region, Ui2.Region)
            --          Else
            --             Isnull(Ui.Region, Gt.Region)
            --       End
            --          Sales_Region,
            Td1.Dim_Year Pos_Year,
            Td1.Dim_Year + '-' + Lpad (Td1.Dim_Quarter, 2, '0') Pos_Qtr,
            Td1.Dim_Year + '-' + Lpad (Td1.Dim_Month_Num, 2, '0') Pos_Month,
            Td1.Dim_Month Pos_Month_Name,
            Td1.Dim_Period_Name Pos_Period,
            Td1.Dim_Year + '-' + Lpad (Td1.Dim_Week, 2, '0') Pos_Week,
            Td2.Dim_Year Pod_Year,
            Td2.Dim_Year + '-' + Lpad (Td2.Dim_Quarter, 2, '0') Pod_Qtr,
            Td2.Dim_Year + '-' + Lpad (Td2.Dim_Month_Num, 2, '0') Pod_Month,
            Td2.Dim_Month Pod_Month_Name,
            Td2.Dim_Period_Name Pod_Period,
            Td2.Dim_Year + '-' + Lpad (Td2.Dim_Week, 2, '0') Pod_Week,
            Nv.Gk_Vertical,
            Case When Cd.Pl_Num = '50' Then 'Y' Else 'N' End Farm_Flag,
            Td1.Fiscal_Year Fscl_Pos_Year,
            Td1.Fiscal_Year + '-' + Lpad (Td1.Fiscal_Quarter, 2, '0')
               Fscl_Pos_Qtr,
            Td1.Fiscal_Year + '-' + Lpad (Td1.Fiscal_Month_Num, 2, '0')
               Fscl_Pos_Month,
            Td1.Fiscal_Month Fscl_Pos_Month_Name,
            Td1.Fiscal_Period_Name Fscl_Pos_Period,
            Td1.Fiscal_Year + '-' + Lpad (Td1.Fiscal_Week, 2, '0')
               Fscl_Pos_Week,
            Td2.Fiscal_Year Fscl_Pod_Year,
            Td2.Fiscal_Year + '-' + Lpad (Td2.Fiscal_Quarter, 2, '0')
               Fscl_Pod_Qtr,
            Td2.Fiscal_Year + '-' + Lpad (Td2.Fiscal_Month_Num, 2, '0')
               Fscl_Pod_Month,
            Td2.Fiscal_Month Fscl_Pod_Month_Name,
            Td2.Fiscal_Period_Name Fscl_Pod_Period,
            Td2.Fiscal_Year + '-' + Lpad (Td2.Fiscal_Week, 2, '0')
               Fscl_Pod_Week,
            0 Promo_Adj,
            Et.Actual_Extended_Amount Comm_Amt,
            Case
               When Cd.Md_Num In
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    And Upper (Ad2.Country) = 'Canada'
               Then
                  'Canada'
               When Cd.Md_Num In
                          ('20', '31', '32', '33', '34', '42', '43', '44')
                    And Ad2.Country Is Null
                    And Upper (Ad1.Country) = 'Canada'
               Then
                  'Canada'
               When Cd.Md_Num In
                          ('20', '31', '32', '33', '34', '42', '43', '44')
               Then
                  'Usa'
               Else
                  Upper (Ed.Country)
            End
               Bookings_Country
     From                                    Gkdw.Ent_Trans_Bookings_Mv Et
                                          Inner Join
                                             Gkdw.Order_Fact F
                                          On Et.Evxeventid = F.Event_Id
                                             And Trunc (Et.Startdate) =
                                                   Trunc (F.Book_Date)
                                       Inner Join
                                          Gkdw.Event_Dim Ed
                                       On Et.Evxeventid = Ed.Event_Id
                                    Inner Join
                                       Gkdw.Course_Dim Cd
                                    On Ed.Course_Id = Cd.Course_Id
                                       And Case
                                             When Ed.Ops_Country = 'Canada'
                                             Then
                                                'Canada'
                                             Else
                                                'Usa'
                                          End = Cd.Country
                                 Inner Join
                                    Base.Account Ac
                                 On Et.Accountid = Ac.Accountid
                              Inner Join
                                 Base.Qg_Account Qa
                              On Ac.Accountid = Qa.Accountid
                           Left Outer Join
                              Gkdw.Gk_Naics_Verticals Nv
                           On Qa.Group_Naics_Code = Nv.Naics_Code
                        Inner Join
                           Base.Address Ad1
                        On Ac.Addressid = Ad1.Addressid
                     Inner Join
                        Base.Contact C
                     On Et.Contactid = C.Contactid
                  Inner Join
                     Base.Address Ad2
                  On C.Addressid = Ad2.Addressid
               --       Left Outer Join Gkdw.Gk_Account_Segments_Mv Sl
               --          On Ac.Accountid = Sl.Accountid
               --       Left Outer Join Gkdw.Gk_Territory Gt
               --          On     Ad2.Postalcode Between Gt.Zip_Start And Gt.Zip_End
               --             And Gt.Territory_Type = 'Ob'
               Inner Join
                  Gkdw.Time_Dim Td1
               On Trunc (Et.[Getutcdate()]) = Td1.Dim_Date
            Inner Join
               Gkdw.Time_Dim Td2
            On Case
                  When Cd.Md_Num In ('31', '32', '33', '34', '43', '44')
                  Then
                     Trunc (Et.[Getutcdate()])
                  Else
                     Ed.Start_Date
               End = Td2.Dim_Date
    --       Left Outer Join Base.Userinfo Ui
    --          On Ui.Userid = Isnull(Sl.Ob_Rep_Id, Gt.Userid)
    --       Left Outer Join Base.Usersecurity Us On Ui.Userid = Us.Userid
    --       Left Outer Join Base.Userinfo Um On Us.Managerid = Um.Userid
    --       Left Outer Join Base.Userinfo Ui2
    --          On Sl.Field_Rep_Id = Ui2.Userid And Ui2.Region != 'Retired'
    --       Left Outer Join Base.Usersecurity Us2 On Ui2.Userid = Us2.Userid
    --       Left Outer Join Base.Userinfo Um2 On Us2.Managerid = Um2.Userid
    --       Left Outer Join Base.Userinfo Ui3
    --          On Et.Salesrep = Ui3.Username And Ui3.Region != 'Retired'
    --       Left Outer Join Base.Usersecurity Us3 On Ui2.Userid = Us3.Userid
    --       Left Outer Join Base.Userinfo Um3 On Us3.Managerid = Um3.Userid
    Where   Td1.Dim_Year >= 2016
            -- And Et.Actual_Extended_Amount <> 0
            --And F.Event_Id='Qgkid0b936z6'
            And Cd.Course_Code Not In
                     ('1500D', '4931D', '283919I', '5983D', '1978I') -- Sr 11/6/2018 Ticket# 1937
            And Not Exists (Select   1
                              From   Gkdw.Gk_Master_Account_Exclude Ma
                             Where   Ma.Acct_Id = Ac.Accountid)
            And Not Exists
                  (Select   1
                     From   Gkdw.Ent_Trans_Bookings_Mv Mv
                    Where   Mv.Evxeventid = F.Event_Id
                            And Mv.Evxevenrollid = F.Enroll_Id);



