


Create Or Alter View Hold.Gk_Mdm_Cust_Attendees_V
(
   Enroll_Id,
   Cust_Id,
   Book_Date,
   Course_Code,
   Event_Desc,
   Event_Id,
   Start_Date,
   End_Date,
   Book_Amt,
   Payment_Info,
   Facility_Code,
   Facility_Region_Metro,
   Enroll_Status,
   Cust_Name,
   Acct_Name,
   Address1,
   Address2,
   City,
   State,
   Zipcode,
   Email,
   Title,
   Workphone,
   Event_Type,
   Event_Status,
   Deliverymethod,
   Duration
)
As
   Select   O.Enroll_Id,
            O.Cust_Id,
            O.Book_Date,
            Ed.Course_Code,
            Ed.Event_Name,
            Ed.Event_Id,
            Ed.Start_Date,
            Ed.End_Date,
            O.Book_Amt,
            O.Payment_Method Payment_Info,
            Ed.Facility_Code,
            Ed.Facility_Region_Metro,
            O.Enroll_Status,
            Cd.Cust_Name,
            Cd.Acct_Name,
            Cd.Address1,
            Cd.Address2,
            Cd.City,
            Cd.State,
            Cd.Zipcode,
            Cd.Email,
            Cd.Title,
            Cd.Workphone,
            Ed.Event_Type,
            Ed.Status Event_Status,
            Ee.Deliverymethod,
            Case When Uom Like 'Day%' Then (Duration * 8)
               Else Null
            End
               Duration
     From               Gkdw.Order_Fact O
                     Join
                        Gkdw.Event_Dim Ed
                     On O.Event_Id = Ed.Event_Id
                  Join
                     Gkdw.Cust_Dim Cd
                  On O.Cust_Id = Cd.Cust_Id
               Join
                  Base.Evxevent Ee
               On Ed.Event_Id = Ee.Evxeventid
            Left Outer Join
               Base.Qg_Course Qc
            On Ed.Course_Id = Qc.Evxcourseid
    Where   O.Enroll_Status Not In ('Cancelled', 'T')
   --And Ed.Status <> 'Cancelled'
   --   And O.Gkdw_Source = 'Slxdw'
   Union All
   Select   So.Sales_Order_Id,
            So.Cust_Id,
            So.Book_Date,
            Pd.Prod_Num,
            Pd.Prod_Name,
            Pd.Product_Id,
            Case When So.Record_Type_Code = 1 Then So.Ship_Date Else So.Book_Date End
               Start_Date,
            Null,
            So.Book_Amt,
            So.Payment_Method,
            Null,
            Null,
            So_Status,
            Cd.Cust_Name,
            Cd.Acct_Name,
            Cd.Address1,
            Cd.Address2,
            Cd.City,
            Cd.State,
            Cd.Zipcode,
            Cd.Email,
            Cd.Title,
            Cd.Workphone,
            So.Record_Type,
            Null Event_Status,
            So.Record_Type Deliverymethod,
            Null Duration
     From         Gkdw.Sales_Order_Fact So
               Join
                  Gkdw.Product_Dim Pd
               On So.Product_Id = Pd.Product_Id
            Join
               Gkdw.Cust_Dim Cd
            On So.Cust_Id = Cd.Cust_Id
    Where   Isnull(So.So_Status, ' ') <> 'Cancelled'
   --   And So.Gkdw_Source = 'Slxdw'
   ;



