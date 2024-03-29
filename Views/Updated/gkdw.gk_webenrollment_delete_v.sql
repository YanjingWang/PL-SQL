


Create Or Alter View Hold.Gk_Webenrollment_Delete_V
(
   Gk_Webenrollmentid,
   Web_Createdate,
   Attendeecontactid,
   Attendeeaccountid,
   Attendeefirstname,
   Attendeelastname,
   Attendeeaccountname,
   Attendeecity,
   Attendeestate,
   Attendeecounty,
   Attendeepostalcode,
   Web_Eventid,
   Web_Coursecode,
   Web_Startdate,
   Web_Metro,
   Webfacility,
   Short_Name,
   Netamount,
   Taxamount,
   Currencytype,
   Methodofpayment,
   Cc_Cardtype,
   Cc_Appliedamount,
   Cc_Number,
   Cc_Authnumber,
   Cc_Responsemsg,
   Ponumber,
   Reenroll_Bookdate,
   Reenroll_Bookamt,
   Reenroll_Type,
   Reenroll_Eventid,
   Reenroll_Coursecode,
   Reenroll_Startdate,
   Reenroll_Metro,
   Reenroll_Facility
)
As
   Select   W.Gk_Webenrollmentid,
            W.Createdate Web_Createdate,
            W.Attendeecontactid,
            W.Attendeeaccountid,
            W.Attendeefirstname,
            W.Attendeelastname,
            W.Attendeeaccountname,
            W.Attendeecity,
            W.Attendeestate,
            W.Attendeecounty,
            W.Attendeepostalcode,
            Ed.Event_Id Web_Eventid,
            Ed.Course_Code Web_Coursecode,
            Ed.Start_Date Web_Startdate,
            Ed.Facility_Region_Metro Web_Metro,
            Ed.Facility_Code Webfacility,
            Cd.Short_Name,
            W.Netamount,
            W.Taxamount,
            W.Currencytype,
            W.Methodofpayment,
            W.Cc_Cardtype,
            W.Cc_Appliedamount,
            W.Cc_Number,
            W.Cc_Authnumber,
            W.Cc_Responsemsg,
            W.Ponumber,
            F.Book_Date Reenroll_Bookdate,
            F.Book_Amt Reenroll_Bookamt,
            F.Enroll_Type Reenroll_Type,
            Ed2.Event_Id Reenroll_Eventid,
            Ed2.Course_Code Reenroll_Coursecode,
            Ed2.Start_Date Reenroll_Startdate,
            Ed2.Facility_Region_Metro Reenroll_Metro,
            Ed2.Facility_Code Reenroll_Facility
     From               Gkdw.Gk_Webenrollment W
                     Inner Join
                        Gkdw.Event_Dim Ed
                     On W.Evxeventid = Ed.Event_Id
                  Inner Join
                     Gkdw.Course_Dim Cd
                  On Ed.Course_Id = Cd.Course_Id
                     And Ed.Ops_Country = Cd.Country
               Inner Join
                  Gkdw.Order_Fact F
               On     W.Attendeecontactid = F.Cust_Id
                  And Trunc (F.Creation_Date) >= Trunc (W.Createdate)
                  And F.Enroll_Status != 'Cancelled'
            Inner Join
               Gkdw.Event_Dim Ed2
            On F.Event_Id = Ed2.Event_Id And Ed.Course_Id = Ed2.Course_Id
    Where   W.Recordstatus = 'Deleted'
   --And W.Enrollmentdate >= Cast(Getutcdate() As Date)-7
   Union
   Select   W.Gk_Webenrollmentid,
            W.Createdate,
            W.Attendeecontactid,
            W.Attendeeaccountid,
            W.Attendeefirstname,
            W.Attendeelastname,
            W.Attendeeaccountname,
            W.Attendeecity,
            W.Attendeestate,
            W.Attendeecounty,
            W.Attendeepostalcode,
            Ed.Event_Id,
            Ed.Course_Code,
            Ed.Start_Date,
            Ed.Facility_Region_Metro,
            Ed.Facility_Code,
            Cd.Short_Name,
            W.Netamount,
            W.Taxamount,
            W.Currencytype,
            W.Methodofpayment,
            W.Cc_Cardtype,
            W.Cc_Appliedamount,
            W.Cc_Number,
            W.Cc_Authnumber,
            W.Cc_Responsemsg,
            W.Ponumber,
            Null,
            Null,
            Null,
            Null,
            Null,
            Null,
            Null,
            Null
     From         Gkdw.Gk_Webenrollment W
               Inner Join
                  Gkdw.Event_Dim Ed
               On W.Evxeventid = Ed.Event_Id
            Inner Join
               Gkdw.Course_Dim Cd
            On Ed.Course_Id = Cd.Course_Id And Ed.Ops_Country = Cd.Country
    Where   W.Recordstatus = 'Deleted'
            --And W.Enrollmentdate >= Cast(Getutcdate() As Date)-7
            And Not Exists
                  (Select   1
                     From      Gkdw.Order_Fact F
                            Inner Join
                               Gkdw.Event_Dim Ed2
                            On F.Event_Id = Ed2.Event_Id
                    Where   Ed2.Course_Id = Ed.Course_Id
                            And W.Attendeecontactid = F.Cust_Id
                            And Trunc (F.Creation_Date) >=
                                  Trunc (W.Createdate)
                            And F.Enroll_Status != 'Cancelled')
   ;



