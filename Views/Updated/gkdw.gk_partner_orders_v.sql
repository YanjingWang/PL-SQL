


Create Or Alter View Hold.Gk_Partner_Orders_V
(
   Dim_Week,
   Po_Create_Meth,
   Po_Active,
   Vendor_Code,
   Oracle_Vendor_Id,
   Oracle_Vendor_Site,
   Event_Id,
   Event_Name,
   Start_Date,
   Facility_Code,
   Reseller_Event_Id,
   Location_Name,
   Ops_Country,
   Org_Id,
   Inv_Org_Id,
   Curr_Code,
   Le,
   Md_Num,
   Royalty_Fee,
   Course_Code,
   Act,
   Vpo_Desc,
   Enroll_Id,
   Enroll_Status,
   Book_Date,
   Cust_Name,
   Acct_Name,
   Address1,
   Address2,
   City,
   State,
   Zipcode
)
As
   Select   Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Dim_Week,
            Pr.Po_Create_Meth,
            Pr.Po_Active,
            Pv.Vendor_Code,
            Pv.Oracle_Vendor_Id,
            Pv.Oracle_Vendor_Site,
            Ed.Event_Id,
            Ed.Event_Name,
            Ed.Start_Date,
            Ed.Facility_Code,
            Ed.Reseller_Event_Id,
            Ed.Location_Name,
            Ed.Ops_Country,
            Pv.Org_Id Org_Id,
            Pv.Inv_Org_Id Inv_Org_Id,
            Pv.Payment_Currency_Code Curr_Code,
            Pv.Le,
            Cd.Md_Num,
            Case
               When Ed.Ops_Country = 'Canada' Then Rl.Ca_Fee
               Else Rl.Us_Fee
            End
               Royalty_Fee,
            Cd.Course_Code,
            '00' + Substring(Course_Code, 1,  4) Act,
               Course_Group
            + '-'
            + Cd.Course_Code
            + '-'
            + Format(Ed.Start_Date, 'Mmddyy')
            + '-'
            + C.Cust_Name
            + '-'
            + Case
                  When Ed.Ops_Country = 'Canada' Then Rl.Ca_Fee
                  Else Rl.Us_Fee
               End
            + '-Ev:'
            + Ed.Event_Id
            + '-En:'
            + F.Enroll_Id
               Vpo_Desc,
            F.Enroll_Id Enroll_Id,
            F.Enroll_Status,
            Trunc (F.Book_Date) Book_Date,
            C.Cust_Name,
            C.Acct_Name,
            C.Address1,
            C.Address2,
            C.City,
            C.State,
            C.Zipcode
     From                        Gkdw.Event_Dim Ed
                              Inner Join
                                 Gkdw.Course_Dim Cd
                              On Ed.Course_Id = Cd.Course_Id
                                 And Ed.Country = Cd.Country
                           Inner Join
                              Gkdw.Order_Fact F
                           On Ed.Event_Id = F.Event_Id
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Case
                              When Cd.Md_Num In ('10', '20', '41', '42')
                              Then
                                 Ed.Start_Date
                              Else
                                 F.Book_Date
                           End = Td.Dim_Date
                     Inner Join
                        Gkdw.Cust_Dim C
                     On F.Cust_Id = C.Cust_Id
                  Inner Join
                     Gkdw.Gk_Royalty_Lookup Rl
                  On Cd.Course_Code = Rl.Course_Code
                     And F.Book_Date Between Rl.Active_Date
                                         And  Rl.Inactive_Date
               Inner Join
                  Gkdw.Gk_Partner_Vendor Pv
               On Trim (Rl.Vendor_Code) = Trim (Pv.Vendor_Code)
                  And Ed.Ops_Country = Pv.Ops_Country
            Inner Join
               Gkdw.Gk_Partner_Royalty Pr
            On Trim (Pv.Vendor_Code) = Trim (Pr.Vendor_Code)
    Where       F.Enroll_Status != 'Cancelled' -- Requested Change By Erica Loring 6/5/09
            And F.Book_Amt > 0
            And Case
                  When Ed.Ops_Country = 'Canada' Then Rl.Ca_Fee
                  Else Rl.Us_Fee
               End > 0
            And Cd.Md_Num Not In ('20', '42')
            And Isnull(F.Keycode, 'None') Not In
                     ('Itil2432',
                      'Itil2437',
                      'Wprod',
                      'Wspec',
                      'Wcertap5',
                      'Wcertp4')
            And Isnull(Upper (Payment_Method), 'None') != 'Microsoft Satv'
   Union
   Select   Td.Dim_Year + '-' + Lpad (Td.Dim_Week, 2, '0') Dim_Week,
            Pr.Po_Create_Meth,
            Pr.Po_Active,
            Pv.Vendor_Code,
            Pv.Oracle_Vendor_Id,
            Pv.Oracle_Vendor_Site,
            Ed.Event_Id,
            Ed.Event_Name,
            Ed.Start_Date,
            Ed.Facility_Code,
            Ed.Reseller_Event_Id,
            Ed.Location_Name,
            Case
               When C.Country In ('Ca', 'Canada') Then 'Canada'
               Else 'Usa'
            End,
            Pv.Org_Id Org_Id,
            Pv.Inv_Org_Id Inv_Org_Id,
            Pv.Payment_Currency_Code Curr_Code,
            Pv.Le,
            Cd.Md_Num,
            Case When C.Country In ('Ca', 'Canada') Then Rl.Ca_Fee
               Else Rl.Us_Fee
            End
               Royalty_Fee,
            Cd.Course_Code,
            '00' + Substring(Course_Code, 1,  4) Act,
               Course_Group
            + '-'
            + Cd.Course_Code
            + '-'
            + Format(Ed.Start_Date, 'Mmddyy')
            + '-'
            + C.Cust_Name
            + '-'
            + Case
                  When Ed.Ops_Country = 'Canada' Then Rl.Ca_Fee
                  Else Rl.Us_Fee
               End
            + '-Ev:'
            + Ed.Event_Id
            + '-En:'
            + F.Enroll_Id
               Vpo_Desc,
            F.Enroll_Id Enroll_Id,
            F.Enroll_Status,
            Trunc (F.Book_Date) Book_Date,
            C.Cust_Name,
            C.Acct_Name,
            C.Address1,
            C.Address2,
            C.City,
            C.State,
            C.Zipcode
     From                        Gkdw.Event_Dim Ed
                              Inner Join
                                 Gkdw.Course_Dim Cd
                              On Ed.Course_Id = Cd.Course_Id
                                 And Ed.Country = Cd.Country
                           Inner Join
                              Gkdw.Order_Fact F
                           On Ed.Event_Id = F.Event_Id
                        Inner Join
                           Gkdw.Time_Dim Td
                        On Case
                              When Cd.Md_Num In ('10', '20', '41', '42')
                              Then
                                 Ed.Start_Date
                              Else
                                 F.Book_Date
                           End = Td.Dim_Date
                     Inner Join
                        Gkdw.Cust_Dim C
                     On F.Cust_Id = C.Cust_Id
                  Inner Join
                     Gkdw.Gk_Royalty_Lookup Rl
                  On Cd.Course_Code = Rl.Course_Code
                     And F.Book_Date Between Rl.Active_Date
                                         And  Rl.Inactive_Date
               Inner Join
                  Gkdw.Gk_Partner_Vendor Pv
               On Trim (Rl.Vendor_Code) = Trim (Pv.Vendor_Code)
                  And Case
                        --When Cd.Vendor_Code = 'Fmc' Then Ed.Ops_Country -- Requested Change By Lindsey Kanwasher 7/5/16
                     When C.Country In ('Ca', 'Canada') Then 'Canada' --C.Country
                        Else 'Usa'
                     End = Pv.Ops_Country
            Inner Join
               Gkdw.Gk_Partner_Royalty Pr
            On Trim (Pv.Vendor_Code) = Trim (Pr.Vendor_Code)
    Where       F.Enroll_Status != 'Cancelled' -- Requested Change By Erica Loring 6/5/09
            And F.Book_Amt > 0
            And Case
                  When Ed.Ops_Country = 'Canada' Then Rl.Ca_Fee
                  Else Rl.Us_Fee
               End > 0
            And Cd.Md_Num In ('20', '42')
            And Isnull(F.Keycode, 'None') Not In
                     ('Itil2432',
                      'Itil2437',
                      'Wprod',
                      'Wspec',
                      'Wcertap5',
                      'Wcertp4')
            And Isnull(Upper (Payment_Method), 'None') != 'Microsoft Satv';



