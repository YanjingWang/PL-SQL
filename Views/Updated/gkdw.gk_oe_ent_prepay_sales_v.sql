


Create Or Alter View Hold.Gk_Oe_Ent_Prepay_Sales_V
(
   [Transaction Id],
   [Cust Account],
   [Cust Country],
   Zipcode,
   [Product Code],
   Us_Farm,
   Ca_Farm,
   Keycode,
   [Geography Name],
   [Sold To Account],
   [Selling Price],
   [Selling Price Currency],
   [Incentive Date],
   [Order Date],
   [Order Type],
   [Field Sales Rep Name],
   [Field Sales],
   [Inside Sales Rep Name],
   [Inside Sales],
   [Csd Rep Name],
   Csd,
   [Channel],
   [Product],
   [Delivery Format],
   [Event Type],
   [Payment Method],
   [Product Family],
   [Product Type],
   [Segment],
   [Student Name]
)
As
   Select   Distinct
            F.Enroll_Id [Transaction Id],
            C.Acct_Id [Cust Account],
            Case
               When Substring(C.Country, 1,  2) = 'Ca' Then 'Canada'
               When Substring(C.Country, 1,  2) = 'Us' Then 'Usa'
               Else C.Country
            End
               [Cust Country],
            C.Zipcode,
            Ed.Course_Code [Product Code],
            Cd.Us_Farm,
            Cd.Ca_Farm,
            Rt.Partner_Key_Code Keycode,
            Null [Geography Name],
            Isnull(C.Acct_Name, F.Acct_Name) [Sold To Account],
            Case
               When F.Keycode = 'C09901068p' Then F.Book_Amt * 2
               Else F.Book_Amt
            End
               [Selling Price],
            F.Curr_Code [Selling Price Currency],
            Trunc (F.Book_Date) [Incentive Date],
            Trunc (F.Book_Date) [Order Date],
            'Sales' [Order Type],
            Case
               When Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 20, 40)
               Then
                  Rt.Channel_Manager
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside',
                              'Mid Market/Geo',
                              'Commercial/Geo',
                              'Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal')
                    And Cd.Ch_Num = 20
               Then
                  Isnull(Ui2.Username, Ui5.Username)              --Sl.Field_Rep
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside',
                              'Federal',
                              'Large Enterprise',
                              'Mid Market',
                              'Commercial')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui2.Username, Ui5.Username)              --Sl.Field_Rep
               When Substring(C.Country, 1,  2) In ('Us', 'Ca')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Cd.Ch_Num In (10, 40, 20)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Coalesce (Ui2.Username, Ui5.Username, Ui4.Username)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Null
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Isnull(Ui2.Username, Ui5.Username)
               Else
                  Null
            End
               [Field Sales Rep Name],
            Case
               When Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 20, 40)
               Then
                  Ui8.Accountinguserid                    --Rt.Channel_Manager
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside',
                              'Mid Market/Geo',
                              'Commercial/Geo',
                              'Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal')
                    And Cd.Ch_Num = 20
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid)
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside',
                              'Federal',
                              'Large Enterprise',
                              'Mid Market',
                              'Commercial')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid) -- Sl.Field_Rep_Id
               When Substring(C.Country, 1,  2) In ('Us', 'Ca')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Cd.Ch_Num In (10, 40, 20)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Coalesce (Ui2.Accountinguserid,
                            Ui5.Accountinguserid,
                            Ui4.Accountinguserid)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Null
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 20, 40)
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid)
               Else
                  Null
            End
               [Field Sales],
            Case
               When Substring(C.Country, 1,  2) = 'Us'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Null
               When     Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Channel'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 20)
               Then
                  Ui9.Username
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal',
                              'Strategic Alliance')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui.Username, Ui6.Username) -- Isnull(Sl.Ob_Rep,Ui5.Username)
               When     Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Channel'
                    And Cd.Ch_Num In (10, 40)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Isnull(Ui.Username, Ui6.Username) -- Isnull(Sl.Ob_Rep,Ui5.Username)
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside', 'Mid Market/Geo', 'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui4.Username, Ui.Username) -- Isnull(Sl.Ob_Rep,Ui5.Username)
               When     Substring(C.Country, 1,  2) = 'Us'
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Case
                     When Gt.Territory_Id Like 'Ne%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Ma%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Mw%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Sc%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Se%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'W%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Null
               When Substring(C.Country, 1,  2) = 'Ca'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Canada'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 40)
               Then
                  Null
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Qa.Rep_3_Id Is Not Null               -- Bell Accounts
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        F.Salesperson
                     When Cd.Ch_Num In (10, 40)
                     Then
                        Case
                           When Upper (Isnull(Ui.Username, Ui6.Username)) =
                                   'Marsha Scott'
                           Then
                              Isnull(Ui.Username, Ui6.Username)
                           Else
                              'Audrey Perry'
                        End
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
                    And Qa.Rep_3_Id Is Null
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        F.Salesperson
                     When Cd.Ch_Num In (10, 40) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Isnull(Ui.Username, Ui6.Username)
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Canada'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Coalesce (Ui.Username, Ui6.Username, Ui4.Username)
               When     Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Channel'
                    And Cd.Ch_Num In (10, 40)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Isnull(Ui.Username, Ui6.Username)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) =
                          'Commercial/Geo'
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui4.Username, Ui.Username)
               When     Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Inside'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Isnull(Ui4.Username, Ui.Username)
               -- Sl.Ob_Rep
            When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                 And Isnull(Qa.Segment, Sl.Segment) Is Not Null
               Then
                  Isnull(Ui.Username, Ui6.Username)
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
               Then
                  'Anna  Tancredi'
               Else
                  Null
            End
               [Inside Sales Rep Name],
            Case
               When Substring(C.Country, 1,  2) = 'Us'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Null
               When     Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Channel'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 20)
               Then
                  Ui9.Accountinguserid
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal',
                              'Strategic Alliance')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui.Accountinguserid, Ui6.Accountinguserid) --Sl.Ob_Rep_Id
               When     Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Channel'
                    And Cd.Ch_Num In (10, 40)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Isnull(Ui.Accountinguserid, Ui6.Accountinguserid) -- Isnull(Sl.Ob_Rep,Ui5.Username)
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside', 'Mid Market/Geo', 'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
               When     Substring(C.Country, 1,  2) = 'Us'
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Case
                     When Gt.Territory_Id Like 'Ne%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Ma%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Mw%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Sc%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Se%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'W%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40)
               Then
                  Null
               When Substring(C.Country, 1,  2) = 'Ca'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Canada'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 40)
               Then
                  Null
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Qa.Rep_3_Id Is Not Null     -- Bell Cad Named Accounts
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Ui7.Accountinguserid
                     When Cd.Ch_Num In (10, 40)
                     Then
                        Case
                           When Upper (Isnull(Ui.Username, Ui6.Username)) =
                                   'Marsha Scott'
                           Then
                              Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
                           Else
                              '002608'                          --Audrey Perry
                        End
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca' -- All Other Cad Named Accounts
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
                    And Qa.Rep_3_Id Is Null
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Ui7.Accountinguserid
                     When Cd.Ch_Num In (10, 40) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Canada'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Coalesce (Ui.Accountinguserid,
                            Ui6.Accountinguserid,
                            Ui4.Accountinguserid)
               When     Substring(C.Country, 1,  2) = 'Ca'
                    And Qa.Rep_3_Id Is Not Null
                    And Cd.Ch_Num In (10, 40)
               Then
                  Ui7.Accountinguserid
               When     Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Channel'
                    And Cd.Ch_Num In (10, 40)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Isnull(Ui.Accountinguserid, Ui6.Accountinguserid) -- Sl.Ob_Rep_Id
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) =
                          'Commercial/Geo'
                    And Cd.Ch_Num In (10, 40)
               Then
                  Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
               When     Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) = 'Inside'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Isnull(Ui4.Accountinguserid, Ui.Accountinguserid) -- Sl.Ob_Rep_Id
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Not Null
               Then
                  Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
               Then
                  '002219'                                 -- 'Anna  Tancredi'
               Else
                  Null
            End
               [Inside Sales],
            Case
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Isnull(Qa.Segment, Sl.Segment), '0')) Not In
                             ('0', 'Inside')
                    And Cd.Ch_Num = 20
                    And Course_Pl In
                             ('Business Training',
                              'Leadership And Business Solutions')
               Then
                  Ui3.Username                                  -- Qc.Rep_4_Id
               Else
                  Null
            End
               [Csd Rep Name],
            Case
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Isnull(Qa.Segment, Sl.Segment), '0')) Not In
                             ('0', 'Inside')
                    And Cd.Ch_Num = 20
                    And Course_Pl In
                             ('Business Training',
                              'Leadership And Business Solutions')
               Then
                  Ui3.Accountinguserid                         --  Qc.Rep_4_Id
               Else
                  Null
            End
               [Csd],
            Case
               When Cd.Ch_Num = '20' Then 'Enterprise'
               When Cd.Ch_Num In ('10', '40') Then 'Open Enrollment'
               When Cd.Ch_Num Is Null Then Null
            End
               [Channel],
            Cd.Course_Name [Product],
            Case
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In
                          ('N', 'C', 'G', 'H', 'D', 'I')
               Then
                  'Classroom'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('V', 'L', 'Y', 'U')
               Then
                  'Virtual'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('Z')
               Then
                  'Virtual Fit'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('S', 'W', 'E', 'P')
               Then
                  'Digital'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('A')
               Then
                  'Digital'
            End
               [Delivery Format],
            Ed.Event_Type [Event Type],
            Isnull(F.Payment_Method, Ft.Payment_Method) [Payment Method],
            Cd.Course_Pl [Product Family],
            'Class' [Product Type],
            Coalesce (Qa.Segment, Sl.Segment, Gt.Region) [Segment],
            F.Cust_First_Name + ' ' + F.Cust_Last_Name [Student Name]
     From                                                            Gkdw.Order_Fact F
                                                                  Inner Join
                                                                     (Select   Distinct
                                                                               Enroll_Id,
                                                                               Payment_Method
                                                                        From   Gkdw.Order_Fact
                                                                       Where   Bill_Status <>
                                                                                  'Cancelled')
                                                                     Ft
                                                                  On F.Enroll_Id =
                                                                        Ft.Enroll_Id
                                                               Inner Join
                                                                  Gkdw.Cust_Dim C
                                                               On F.Cust_Id =
                                                                     C.Cust_Id
                                                            --(Select Contactid Cust_Id,Accountid Acct_Id,Account Acct_Name,Upper(Adr.Country) Country,Adr.Postalcode Zipcode From Base.Contact Ct
                                                            --Inner Join Base.Address Adr On Ct.Addressid = Adr.Addressid) C On F.Cust_Id = C.Cust_Id
                                                            Inner Join
                                                               Gkdw.Event_Dim Ed
                                                            On F.Event_Id =
                                                                  Ed.Event_Id
                                                         Inner Join
                                                            Gkdw.Course_Dim Cd
                                                         On Ed.Course_Id =
                                                               Cd.Course_Id
                                                            And Ed.Ops_Country =
                                                                  Cd.Country
                                                      Left Outer Join
                                                         Base.Evxev_Txfee Tf
                                                      On F.Txfee_Id =
                                                            Tf.Evxev_Txfeereverseid
                                                   Left Outer Join
                                                      (Select   Accountid,
                                                                Ob_National_Rep_Id,
                                                                Ob_Rep_Id,
                                                                Ent_National_Rep_Id,
                                                                Ent_Inside_Rep_Id,
                                                                Gk_Segment
                                                                   Segment,
                                                                Rep_4_Id,
                                                                Rep_3_Id
                                                         From   Base.Qg_Account)
                                                      Qa
                                                   On C.Acct_Id =
                                                         Qa.Accountid
                                                Left Outer Join
                                                   Gkdw.Gk_Account_Segments_Mv Sl
                                                On C.Acct_Id = Sl.Accountid
                                             Left Outer Join
                                                Gkdw.Gk_Territory Gt
                                             On C.Zipcode Between Gt.Zip_Start
                                                              And  Gt.Zip_End
                                                And Substring(C.Country, 1,  2) In
                                                         ('Us', 'Ca')
                                          Left Outer Join
                                             Base.Userinfo Ui
                                          On Ui.Userid = Qa.Ob_Rep_Id
                                       Left Outer Join
                                          Base.Userinfo Ui6
                                       On Ui6.Userid = Sl.Ob_Rep_Id
                                    Left Outer Join
                                       Base.Userinfo Ui2
                                    On Ui2.Userid = Qa.Ent_National_Rep_Id
                                 Left Outer Join
                                    Base.Userinfo Ui5
                                 On Ui5.Userid = Sl.Field_Rep_Id
                              Left Outer Join
                                 Base.Userinfo Ui3
                              On Ui3.Userid = Qa.Rep_4_Id
                           Left Outer Join
                              Base.Userinfo Ui4
                           On Ui4.Userid = Gt.Userid
                        Left Outer Join
                           Base.Userinfo Ui7
                        On F.Salesperson = Ui7.Username
                     Left Outer Join
                        Gkdw.Gk_Channel_Partner Rt
                     On Rt.Partner_Key_Code = F.Keycode      -- Gk_Rep_Tagging
                  Left Outer Join
                     Base.Userinfo Ui8
                  On Rt.Channel_Manager = Ui8.Username
               Left Outer Join
                  Gkdw.Gk_Territory Gtt
               On Replace (Gtt.Territory_Id, Chr (32), '') = Rt.Ob_Comm_Type
            Left Outer Join
               Base.Userinfo Ui9
            On Ui9.Userid = Gtt.Userid
    Where   Format(F.Book_Date, 'Mm/Yyyy') =
               Format(Cast(Getutcdate() As Date), 'Mm/Yyyy')
            And F.Book_Amt <> '0'
            And Ch_Num In (10, 20, 40)
            And ( (F.Bill_Status = 'Cancelled'
                   And Evxev_Txfeereverseid Is Not Null)
                 Or F.Bill_Status <> 'Cancelled')
   --  And F.Enroll_Id = 'Qgkid0a0rjas'
   Union
   Select   Distinct
            Et.Evxevenrollid [Transaction Id],
            C2.Acct_Id [Cust Account],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
               Then
                  'Canada'
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Us'
               Then
                  'Usa'
               Else
                  Coalesce (C2.Country, F1.Cust_Country, F1.Acct_Country)
            End
               Cust_Country,
            Coalesce (C2.Zipcode, F1.Cust_Zipcode, F1.Acct_Zipcode) Zipcode,
            Et.Coursecode [Product Code],
            Cd.Us_Farm,
            Cd.Ca_Farm,
            Rt.Partner_Key_Code Keycode,
            Null [Geography Name],
            Isnull(C2.Acct_Name, Et.Account) [Sold To Account],
            Case
               When F1.Keycode = 'C09901068p'
               Then
                  Et.Actual_Extended_Amount * 2
               Else
                  Et.Actual_Extended_Amount
            End
               [Selling Price],
            Et.Currencytype [Selling Price Currency],
            Trunc (Et.Createdate) [Incentive Date],
            Trunc (Et.Createdate) [Order Date],
            'Sales' [Order Type],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) In
                          ('Ca', 'Us')
                    And Upper (Coalesce (Q.Segment, Sl.Segment, Gt2.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 20, 40)
               Then
                  Rt.Channel_Manager
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Us'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Inside',
                              'Mid Market/Geo',
                              'Commercial/Geo',
                              'Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal')
                    And Cd.Ch_Num = 20
               Then
                  Isnull(Ui2.Username, Ui5.Username)              --Sl.Field_Rep
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Isnull(Ui2.Username, Ui5.Username)
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) In
                          ('Us', 'Ca')
                    And Upper (Coalesce (Q.Segment, Sl.Segment, Gt2.Region)) =
                          'Channel'
                    And Cd.Ch_Num In (10, 40, 20)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Coalesce (Ui2.Username, Ui5.Username, Ui4.Username)
               Else
                  Null
            End
               [Field Sales Rep Name],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) In
                          ('Ca', 'Us')
                    And Upper (Coalesce (Q.Segment, Sl.Segment, Gt2.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Not Null
                    And Cd.Ch_Num In (10, 20, 40)
               Then
                  Ui8.Accountinguserid                         -- Rt.Field_Rep
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Us'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Inside',
                              'Mid Market/Geo',
                              'Commercial/Geo',
                              'Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal')
                    And Cd.Ch_Num = 20
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid)
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
                    And Cd.Ch_Num In (10, 20, 40)
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid) -- Sl.Field_Rep_Id
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) In
                          ('Us', 'Ca')
                    And Upper (Coalesce (Q.Segment, Sl.Segment, Gt2.Region)) =
                          'Channel'
                    And Cd.Ch_Num In (10, 20, 40)
                    And Rt.Partner_Key_Code Is Null
               Then
                  Coalesce (Ui2.Accountinguserid,
                            Ui5.Accountinguserid,
                            Ui4.Accountinguserid)           -- Sl.Field_Rep_Id
               Else
                  Null
            End
               [Field Sales],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Us'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Null
               When     Substr (
                           Coalesce (C2.Country,
                                     F1.Cust_Country,
                                     F1.Acct_Country),
                           1,
                           2
                        ) = 'Us'
                    And Isnull(Q.Segment, Sl.Segment) Is Null
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Case
                     When Gt2.Territory_Id Like 'Ne%'
                     Then
                        Isnull(Gt2.Salesrep, Ui.Username)
                     When Gt2.Territory_Id Like 'Ma%'
                     Then
                        Isnull(Gt2.Salesrep, Ui.Username)
                     When Gt2.Territory_Id Like 'Mw%'
                     Then
                        Isnull(Gt2.Salesrep, Ui.Username)
                     When Gt2.Territory_Id Like 'Sc%'
                     Then
                        Isnull(Gt2.Salesrep, Ui.Username)
                     When Gt2.Territory_Id Like 'Se%'
                     Then
                        Isnull(Gt2.Salesrep, Ui.Username)
                     When Gt2.Territory_Id Like 'W%'
                     Then
                        Isnull(Gt2.Salesrep, Ui.Username)
                     Else
                        Null
                  End
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Q.Rep_3_Id Is Not Null                -- Bell Accounts
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F1.Salesperson =
                                Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        F1.Salesperson
                     When Cd.Ch_Num In (10, 40)
                     Then
                        Case
                           When Upper (Isnull(Ui.Username, Ui6.Username)) =
                                   'Marsha Scott'
                           Then
                              Isnull(Ui.Username, Ui6.Username)
                           Else
                              'Audrey Perry'
                        End
                     Else
                        Null
                  End
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
                    And Q.Rep_3_Id Is Null
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F1.Salesperson =
                                Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        F1.Salesperson
                     When Cd.Ch_Num In (10, 40) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Isnull(Ui.Username, Ui6.Username)
                     Else
                        Null
                  End
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Coalesce (Q.Segment, Sl.Segment, Gt2.Region)) =
                          'Canada'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Coalesce (Ui.Username, Ui6.Username, Ui4.Username)
               When     Substr (
                           Coalesce (C2.Country,
                                     F1.Cust_Country,
                                     F1.Acct_Country),
                           1,
                           2
                        ) = 'Ca'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) = 'Inside'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Isnull(Ui4.Username, Ui.Username)
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) Not In
                          ('Us', 'Ca')
                    And Isnull(Q.Segment, Sl.Segment) Is Not Null
               Then
                  Isnull(Ui.Username, Ui6.Username)
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) Not In
                          ('Us', 'Ca')
                    And Isnull(Q.Segment, Sl.Segment) Is Null
               Then
                  'Anna  Tancredi'
               Else
                  Null
            End
               [Inside Sales Rep Name],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Us'
                    And ( (Cd.Us_Farm = 'Y' And Cd.Ca_Farm = 'Y')
                         Or Cd.Course_Pl = 'Microsoft Apps')
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Null
               When     Substr (
                           Coalesce (C2.Country,
                                     F1.Cust_Country,
                                     F1.Acct_Country),
                           1,
                           2
                        ) = 'Us'
                    And Isnull(Q.Segment, Sl.Segment) Is Null
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Case
                     When Gt2.Territory_Id Like 'Ne%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt2.Territory_Id Like 'Ma%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt2.Territory_Id Like 'Mw%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt2.Territory_Id Like 'Sc%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt2.Territory_Id Like 'Se%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt2.Territory_Id Like 'W%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     Else
                        Null
                  End
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Q.Rep_3_Id Is Not Null      -- Bell Cad Named Accounts
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F1.Salesperson =
                                Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Ui7.Accountinguserid
                     When Cd.Ch_Num In (10, 40)
                     Then
                        Case
                           When Upper (Isnull(Ui.Username, Ui6.Username)) =
                                   'Marsha Scott'
                           Then
                              Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
                           Else
                              '002608'                          --Audrey Perry
                        End
                     Else
                        Null
                  End
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'                   -- All Other Cad Named Accounts
                    And Upper (Isnull(Q.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
                    And Q.Rep_3_Id Is Null
               Then
                  Case
                     When Cd.Ch_Num = 20
                          And F1.Salesperson =
                                Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Ui7.Accountinguserid
                     When Cd.Ch_Num In (10, 40) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                     Then
                        Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
                     Else
                        Null
                  End
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Coalesce (Q.Segment, Sl.Segment, Gt2.Region)) =
                          'Canada'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Coalesce (Ui.Accountinguserid,
                            Ui6.Accountinguserid,
                            Ui4.Accountinguserid)
               When     Substr (
                           Coalesce (C2.Country,
                                     F1.Cust_Country,
                                     F1.Acct_Country),
                           1,
                           2
                        ) = 'Ca'
                    And Upper (Isnull(Q.Segment, Sl.Segment)) = 'Inside'
                    And Cd.Ch_Num In (10, 40, 20)
               Then
                  Isnull(Ui4.Accountinguserid, Ui.Accountinguserid) -- Sl.Ob_Rep_Id
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) Not In
                          ('Us', 'Ca')
                    And Isnull(Q.Segment, Sl.Segment) Is Not Null
               Then
                  Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) Not In
                          ('Us', 'Ca')
                    And Isnull(Q.Segment, Sl.Segment) Is Null
               Then
                  '002219'                                 -- 'Anna  Tancredi'
               Else
                  Null
            End
               [Inside Sales],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Isnull(Isnull(Q.Segment, Sl.Segment), '0')) Not In
                             ('0', 'Inside')
                    And Cd.Ch_Num = 20
                    And Course_Pl In
                             ('Business Training',
                              'Leadership And Business Solutions')
               Then
                  Ui3.Username                                  -- Qc.Rep_4_Id
               Else
                  Null
            End
               [Csd_Rep_Name],
            Case
               When Substr (
                       Coalesce (C2.Country,
                                 F1.Cust_Country,
                                 F1.Acct_Country),
                       1,
                       2
                    ) = 'Ca'
                    And Upper (Isnull(Isnull(Q.Segment, Sl.Segment), '0')) Not In
                             ('0', 'Inside')
                    And Cd.Ch_Num = 20
                    And Course_Pl In
                             ('Business Training',
                              'Leadership And Business Solutions')
               Then
                  Ui3.Accountinguserid                         --  Qc.Rep_4_Id
               Else
                  Null
            End
               [Csd],
            Case
               When Cd.Ch_Num = '20' Then 'Enterprise'
               Else 'Open Enrollment'
            End
               [Channel],
            Cd.Course_Name [Product],
            Case
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In
                          ('N', 'C', 'G', 'H', 'D', 'I')
               Then
                  'Classroom'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('V', 'L', 'Y', 'U')
               Then
                  'Virtual'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('Z')
               Then
                  'Virtual Fit'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('S', 'W', 'E', 'P')
               Then
                  'Digital'
               When Substring(Ed.Course_Code, Len(Ed.Course_Code),  1) In ('A')
               Then
                  'Digital'
            End
               [Delivery Format],
            Ed.Event_Type [Event Type],
            Case
               When Et.Ponumber Is Not Null Then 'Purchase Order'
               When Et.Evxppcardid Is Not Null Then 'Prepay Card'
               Else Ebp.[Method]
            End
               [Payment Method],
            Cd.Course_Pl [Product Family],
            'Class' [Product Type],
            Coalesce (Q.Segment, Sl.Segment, Gt2.Region) [Segment],
            Isnull(F1.Cust_First_Name + ' ' + F1.Cust_Last_Name,
                 Et.Attendee_Name)
               [Student Name]
     From                                                            Base.Ent_Trans_Bookings Et
                                                                  Inner Join
                                                                     Gkdw.Cust_Dim C2
                                                                  On Et.Contactid =
                                                                        C2.Cust_Id
                                                               Inner Join
                                                                  Gkdw.Event_Dim Ed
                                                               On Et.Evxeventid =
                                                                     Ed.Event_Id
                                                            Inner Join
                                                               Gkdw.Order_Fact F1
                                                            On F1.Enroll_Id =
                                                                  Et.Evxevenrollid
                                                         Inner Join
                                                            Gkdw.Course_Dim Cd
                                                         On Ed.Course_Id =
                                                               Cd.Course_Id
                                                            And Case
                                                                  When Ed.Ops_Country In
                                                                             ('Ca',
                                                                              'Canada')
                                                                  Then
                                                                     'Canada'
                                                                  Else
                                                                     'Usa'
                                                               End =
                                                                  Cd.Country
                                                      Inner Join
                                                         Base.Evxev_Txfee Etf
                                                      On Etf.Evxevenrollid =
                                                            Et.Evxevenrollid
                                                   Inner Join
                                                      Base.Evxevticket Etk
                                                   On Etf.Evxevticketid =
                                                         Etk.Evxevticketid
                                                Inner Join
                                                   Base.Evxbillpayment Ebp
                                                On Etf.Evxbillingid =
                                                      Ebp.Evxbillingid --And Isnull(Etf.Evxbillingid,'0') <> '0'
                                             Left Outer Join
                                                (Select   Accountid,
                                                          Ob_National_Rep_Id,
                                                          Ob_Rep_Id,
                                                          Ent_National_Rep_Id,
                                                          Ent_Inside_Rep_Id,
                                                          Gk_Segment Segment,
                                                          Rep_3_Id,
                                                          Rep_4_Id
                                                   From   Base.Qg_Account) Q
                                             On C2.Acct_Id = Q.Accountid
                                          Left Outer Join
                                             Gkdw.Gk_Account_Segments_Mv Sl
                                          On C2.Acct_Id = Sl.Accountid
                                       Left Outer Join
                                          Gkdw.Gk_Territory Gt2
                                       On Coalesce (C2.Zipcode,
                                                    F1.Cust_Zipcode,
                                                    F1.Acct_Zipcode) Between Gt2.Zip_Start
                                                                         And  Gt2.Zip_End
                                          And Substr (
                                                Coalesce (C2.Country,
                                                          F1.Cust_Country,
                                                          F1.Acct_Country),
                                                1,
                                                2
                                             ) In
                                                   ('Us', 'Ca')
                                    Left Outer Join
                                       Base.Userinfo Ui
                                    On Ui.Userid = Q.Ob_Rep_Id
                                 Left Outer Join
                                    Base.Userinfo Ui6
                                 On Ui6.Userid = Sl.Ob_Rep_Id
                              Left Outer Join
                                 Base.Userinfo Ui2
                              On Ui2.Userid = Q.Ent_National_Rep_Id
                           Left Outer Join
                              Base.Userinfo Ui5
                           On Ui5.Userid = Sl.Field_Rep_Id
                        Left Outer Join
                           Base.Userinfo Ui3
                        On Ui3.Userid = Q.Rep_4_Id
                     Left Outer Join
                        Base.Userinfo Ui4
                     On Ui4.Userid = Gt2.Userid
                  Left Outer Join
                     Base.Userinfo Ui7
                  On F1.Salesperson = Ui7.Username
               Left Outer Join
                  Gkdw.Gk_Channel_Partner Rt
               On Rt.Partner_Key_Code = F1.Keycode           -- Gk_Rep_Tagging
            Left Outer Join
               Base.Userinfo Ui8
            On Rt.Channel_Manager = Ui8.Username
    Where   Format(Et.Createdate, 'Mm/Yyyy') =
               Format(Cast(Getutcdate() As Date), 'Mm/Yyyy')
            And Cd.Ch_Num In (10, 20)
   Union
   Select   Distinct
            Epp.Evxppcardid [Transaction Id],
            C.Acct_Id [Cust Account],
            Case
               When Substring(C.Country, 1,  2) = 'Ca' Then 'Canada'
               When Substring(C.Country, 1,  2) = 'Us' Then 'Usa'
               Else C.Country
            End
               [Cust Country],
            C.Zipcode,
            Sf.Prod_Num [Product Code],
            Null Us_Farm,
            Null Cd_Farm,
            Rt.Partner_Key_Code Keycode,
            Null [Geography Name],
            C.Acct_Name [Sold To Account],
            Case
               When Sf.Keycode = 'C09901068p' Then Sf.Book_Amt * 2
               Else Sf.Book_Amt
            End
               [Selling Price],
            Sf.Curr_Code [Selling Price Currency],
            Isnull(Sf.Book_Date, Creation_Date) [Incentive Date],
            Isnull(Sf.Book_Date, Creation_Date) [Order Date],
            'Sales' [Order Type],                                 --C.Acct_Id,
            Case
               When Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Not Null
               Then
                  Rt.Channel_Manager
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside',
                              'Mid Market/Geo',
                              'Commercial/Geo',
                              'Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal')
               Then
                  Isnull(Ui2.Username, Ui5.Username)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
               Then
                  Isnull(Ui2.Username, Ui5.Username)
               When Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Null
               Then
                  Coalesce (Ui2.Username, Ui5.Username, Ui4.Username)
               Else
                  Null
            End
               [Field Sales Rep Name],                      --Gt.Territory_Id,
            Case
               When Substring(C.Country, 1,  2) In ('Ca', 'Us')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Not Null
               Then
                  Ui8.Accountinguserid                    --Rt.Channel_Manager
               When Substring(C.Country, 1,  2) = 'Us'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Inside',
                              'Mid Market/Geo',
                              'Commercial/Geo',
                              'Commercial',
                              'Mid Market',
                              'Large Enterprise',
                              'Federal')
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government',
                              'Large Enterprise',
                              'Commercial/Geo')
               Then
                  Isnull(Ui2.Accountinguserid, Ui5.Accountinguserid)
               When Substring(C.Country, 1,  2) In ('Us', 'Ca')
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Channel'
                    And Rt.Partner_Key_Code Is Null
               Then
                  Coalesce (Ui2.Accountinguserid,
                            Ui5.Accountinguserid,
                            Ui4.Username)
               Else
                  Null
            End
               [Field Sales],
            Case
               When Substring(C.Country, 1,  2) = 'Us'
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
               Then
                  Case
                     When Gt.Territory_Id Like 'Ne%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Ma%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Mw%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Sc%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'Se%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     When Gt.Territory_Id Like 'W%'
                     Then
                        Isnull(Gt.Salesrep, Ui.Username)
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Qa.Rep_3_Id Is Not Null               -- Bell Accounts
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
               Then
                  Case When Sf.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                                                                            Then Sf.Salesperson Else Null End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
                    And Qa.Rep_3_Id Is Null
               Then
                  Case When Sf.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                                                                            Then Sf.Salesperson Else Null End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Canada'
               Then
                  Coalesce (Ui.Username, Ui6.Username, Ui4.Username)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Inside'
               Then
                  Isnull(Ui4.Username, Ui.Username)
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Not Null
               Then
                  Isnull(Ui.Username, Ui6.Username)
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
               Then
                  'Anna Tancredi'
               Else
                  Null
            End
               [Inside Sales Rep Name],
            Case
               When Substring(C.Country, 1,  2) = 'Us'
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
               Then
                  Case
                     When Gt.Territory_Id Like 'Ne%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Ma%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Mw%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Sc%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'Se%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     When Gt.Territory_Id Like 'W%'
                     Then
                        Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
                     Else
                        Null
                  End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Qa.Rep_3_Id Is Not Null               -- Bell Accounts
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
               Then
                  Case When Sf.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                                                                            Then Ui7.Accountinguserid Else Null End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Upper (Isnull(Qa.Segment, Sl.Segment)) In
                             ('Government', 'Large Enterprise')
                    And Qa.Rep_3_Id Is Null
               Then
                  Case When Sf.Salesperson = Isnull(Ui.Username, Ui6.Username) /*And Upper(Isnull(Ui.Title,Ui6.Title)) = 'Account Manager'*/
                                                                            Then Ui7.Accountinguserid Else Null End
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Sf.Ppcard_Id Is Not Null
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Canada'
               Then
                  Coalesce (Ui.Accountinguserid,
                            Ui6.Accountinguserid,
                            Ui4.Accountinguserid)
               When Substring(C.Country, 1,  2) = 'Ca'
                    And Sf.Ppcard_Id Is Not Null
                    And Upper (Coalesce (Qa.Segment, Sl.Segment, Gt.Region)) =
                          'Inside'
               Then
                  Isnull(Ui4.Accountinguserid, Ui.Accountinguserid)
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Not Null
               Then
                  Isnull(Ui.Accountinguserid, Ui6.Accountinguserid)
               When Substring(C.Country, 1,  2) Not In ('Us', 'Ca')
                    And Isnull(Qa.Segment, Sl.Segment) Is Null
               Then
                  '002219'                                  --'Anna  Tancredi'
               Else
                  Null
            End
               [Inside Sales],
            Null [Csd_Rep_Name],
            Null [Csd],
            'Prepay' [Channel],
            Isnull(Epp.Cardtitle, P.Prod_Name) [Product],
            'Prepay' [Delivery Format],
            'Prepay' [Event Type],
            Sf.Payment_Method [Payment Method],
            'Prepay' [Product Family],
            'Prepay Card' [Product Type],
            Coalesce (Qa.Segment, Sl.Segment, Gt.Region) [Segment],
            'Prepay' [Student Name]
     From                                                Gkdw.Sales_Order_Fact Sf
                                                      Left Join
                                                         Base.Evxppcard Epp
                                                      On Sf.Sales_Order_Id =
                                                            Epp.Evxsoid
                                                   Left Join
                                                      Gkdw.Product_Dim P
                                                   On Sf.Product_Id =
                                                         P.Product_Id
                                                Left Join
                                                   Gkdw.Cust_Dim C
                                                On Sf.Cust_Id = C.Cust_Id
                                             Left Outer Join
                                                (Select   Accountid,
                                                          Ob_National_Rep_Id,
                                                          Ob_Rep_Id,
                                                          Ent_National_Rep_Id,
                                                          Ent_Inside_Rep_Id,
                                                          Gk_Segment Segment,
                                                          Rep_3_Id,
                                                          Rep_4_Id
                                                   From   Base.Qg_Account) Qa
                                             On C.Acct_Id = Qa.Accountid
                                          Left Outer Join
                                             Gkdw.Gk_Account_Segments_Mv Sl
                                          On C.Acct_Id = Sl.Accountid
                                       Left Outer Join
                                          Gkdw.Gk_Territory Gt
                                       On C.Zipcode Between Gt.Zip_Start
                                                        And  Gt.Zip_End
                                          And Substring(C.Country, 1,  2) In
                                                   ('Us', 'Ca')
                                    Left Outer Join
                                       Base.Userinfo Ui
                                    On Ui.Userid = Qa.Ob_Rep_Id
                                 Left Outer Join
                                    Base.Userinfo Ui6
                                 On Ui6.Userid = Sl.Ob_Rep_Id
                              Left Outer Join
                                 Base.Userinfo Ui2
                              On Ui2.Userid = Qa.Ent_National_Rep_Id
                           Left Outer Join
                              Base.Userinfo Ui5
                           On Ui5.Userid = Sl.Field_Rep_Id
                        Left Outer Join
                           Base.Userinfo Ui3
                        On Ui3.Userid = Qa.Rep_4_Id
                     Left Outer Join
                        Base.Userinfo Ui4
                     On Ui4.Userid = Gt.Userid
                  Left Outer Join
                     Base.Userinfo Ui7
                  On Sf.Salesperson = Ui7.Username
               Left Outer Join
                  Gkdw.Gk_Channel_Partner Rt
               On Rt.Partner_Key_Code = Sf.Keycode           -- Gk_Rep_Tagging
            Left Outer Join
               Base.Userinfo Ui8
            On Rt.Channel_Manager = Ui8.Username
    Where   Format(Sf.Book_Date, 'Mm/Yyyy') =
               Format(Cast(Getutcdate() As Date), 'Mm/Yyyy')
            And Sf.Book_Amt <> '0'
            And Sf.Ppcard_Id Is Not Null;





